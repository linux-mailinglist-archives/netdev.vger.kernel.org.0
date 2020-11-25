Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 500612C43B3
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 16:43:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730574AbgKYPgX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 10:36:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:53636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730501AbgKYPgT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Nov 2020 10:36:19 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D75020B1F;
        Wed, 25 Nov 2020 15:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606318578;
        bh=j6EV2BbaUdxT/kWb+jnwFOpcQ4nYLTa874SOh+VMlIo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tTUFDUU8aHsPOOgieLaiOAUTjAbWhT7bhyET72amddL0hQqJVPEs/LQiRa9uFGyv2
         YgsQox67imrZIjJH4aWNPknVJdWK/rrigyBCxoIyoVvcv52oBEQkIafRsZnOjI7MMA
         iwQIgR4d3bvUZDxYAVATNxhAyzxpMLRkz/0h9e1A=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Maurizio Lombardi <mlombard@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.9 20/33] vhost scsi: alloc cmds per vq instead of session
Date:   Wed, 25 Nov 2020 10:35:37 -0500
Message-Id: <20201125153550.810101-20-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201125153550.810101-1-sashal@kernel.org>
References: <20201125153550.810101-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mike Christie <michael.christie@oracle.com>

[ Upstream commit 25b98b64e28423b0769313dcaf96423836b1f93d ]

We currently are limited to 256 cmds per session. This leads to problems
where if the user has increased virtqueue_size to more than 2 or
cmd_per_lun to more than 256 vhost_scsi_get_tag can fail and the guest
will get IO errors.

This patch moves the cmd allocation to per vq so we can easily match
whatever the user has specified for num_queues and
virtqueue_size/cmd_per_lun. It also makes it easier to control how much
memory we preallocate. For cases, where perf is not as important and
we can use the current defaults (1 vq and 128 cmds per vq) memory use
from preallocate cmds is cut in half. For cases, where we are willing
to use more memory for higher perf, cmd mem use will now increase as
the num queues and queue depth increases.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Link: https://lore.kernel.org/r/1604986403-4931-3-git-send-email-michael.christie@oracle.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Maurizio Lombardi <mlombard@redhat.com>
Acked-by: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/scsi.c | 207 ++++++++++++++++++++++++++-----------------
 1 file changed, 128 insertions(+), 79 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index b22adf03f5842..e31339be7dd78 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -52,7 +52,6 @@
 #define VHOST_SCSI_VERSION  "v0.1"
 #define VHOST_SCSI_NAMELEN 256
 #define VHOST_SCSI_MAX_CDB_SIZE 32
-#define VHOST_SCSI_DEFAULT_TAGS 256
 #define VHOST_SCSI_PREALLOC_SGLS 2048
 #define VHOST_SCSI_PREALLOC_UPAGES 2048
 #define VHOST_SCSI_PREALLOC_PROT_SGLS 2048
@@ -189,6 +188,9 @@ struct vhost_scsi_virtqueue {
 	 * Writers must also take dev mutex and flush under it.
 	 */
 	int inflight_idx;
+	struct vhost_scsi_cmd *scsi_cmds;
+	struct sbitmap scsi_tags;
+	int max_cmds;
 };
 
 struct vhost_scsi {
@@ -324,7 +326,9 @@ static void vhost_scsi_release_cmd(struct se_cmd *se_cmd)
 {
 	struct vhost_scsi_cmd *tv_cmd = container_of(se_cmd,
 				struct vhost_scsi_cmd, tvc_se_cmd);
-	struct se_session *se_sess = tv_cmd->tvc_nexus->tvn_se_sess;
+	struct vhost_scsi_virtqueue *svq = container_of(tv_cmd->tvc_vq,
+				struct vhost_scsi_virtqueue, vq);
+	struct vhost_scsi_inflight *inflight = tv_cmd->inflight;
 	int i;
 
 	if (tv_cmd->tvc_sgl_count) {
@@ -336,8 +340,8 @@ static void vhost_scsi_release_cmd(struct se_cmd *se_cmd)
 			put_page(sg_page(&tv_cmd->tvc_prot_sgl[i]));
 	}
 
-	vhost_scsi_put_inflight(tv_cmd->inflight);
-	target_free_tag(se_sess, se_cmd);
+	sbitmap_clear_bit(&svq->scsi_tags, se_cmd->map_tag);
+	vhost_scsi_put_inflight(inflight);
 }
 
 static u32 vhost_scsi_sess_get_index(struct se_session *se_sess)
@@ -566,31 +570,31 @@ static void vhost_scsi_complete_cmd_work(struct vhost_work *work)
 }
 
 static struct vhost_scsi_cmd *
-vhost_scsi_get_tag(struct vhost_virtqueue *vq, struct vhost_scsi_tpg *tpg,
+vhost_scsi_get_cmd(struct vhost_virtqueue *vq, struct vhost_scsi_tpg *tpg,
 		   unsigned char *cdb, u64 scsi_tag, u16 lun, u8 task_attr,
 		   u32 exp_data_len, int data_direction)
 {
+	struct vhost_scsi_virtqueue *svq = container_of(vq,
+					struct vhost_scsi_virtqueue, vq);
 	struct vhost_scsi_cmd *cmd;
 	struct vhost_scsi_nexus *tv_nexus;
-	struct se_session *se_sess;
 	struct scatterlist *sg, *prot_sg;
 	struct page **pages;
-	int tag, cpu;
+	int tag;
 
 	tv_nexus = tpg->tpg_nexus;
 	if (!tv_nexus) {
 		pr_err("Unable to locate active struct vhost_scsi_nexus\n");
 		return ERR_PTR(-EIO);
 	}
-	se_sess = tv_nexus->tvn_se_sess;
 
-	tag = sbitmap_queue_get(&se_sess->sess_tag_pool, &cpu);
+	tag = sbitmap_get(&svq->scsi_tags, 0, false);
 	if (tag < 0) {
 		pr_err("Unable to obtain tag for vhost_scsi_cmd\n");
 		return ERR_PTR(-ENOMEM);
 	}
 
-	cmd = &((struct vhost_scsi_cmd *)se_sess->sess_cmd_map)[tag];
+	cmd = &svq->scsi_cmds[tag];
 	sg = cmd->tvc_sgl;
 	prot_sg = cmd->tvc_prot_sgl;
 	pages = cmd->tvc_upages;
@@ -599,7 +603,6 @@ vhost_scsi_get_tag(struct vhost_virtqueue *vq, struct vhost_scsi_tpg *tpg,
 	cmd->tvc_prot_sgl = prot_sg;
 	cmd->tvc_upages = pages;
 	cmd->tvc_se_cmd.map_tag = tag;
-	cmd->tvc_se_cmd.map_cpu = cpu;
 	cmd->tvc_tag = scsi_tag;
 	cmd->tvc_lun = lun;
 	cmd->tvc_task_attr = task_attr;
@@ -1065,11 +1068,11 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 				scsi_command_size(cdb), VHOST_SCSI_MAX_CDB_SIZE);
 				goto err;
 		}
-		cmd = vhost_scsi_get_tag(vq, tpg, cdb, tag, lun, task_attr,
+		cmd = vhost_scsi_get_cmd(vq, tpg, cdb, tag, lun, task_attr,
 					 exp_data_len + prot_bytes,
 					 data_direction);
 		if (IS_ERR(cmd)) {
-			vq_err(vq, "vhost_scsi_get_tag failed %ld\n",
+			vq_err(vq, "vhost_scsi_get_cmd failed %ld\n",
 			       PTR_ERR(cmd));
 			goto err;
 		}
@@ -1373,6 +1376,83 @@ static void vhost_scsi_flush(struct vhost_scsi *vs)
 		wait_for_completion(&old_inflight[i]->comp);
 }
 
+static void vhost_scsi_destroy_vq_cmds(struct vhost_virtqueue *vq)
+{
+	struct vhost_scsi_virtqueue *svq = container_of(vq,
+					struct vhost_scsi_virtqueue, vq);
+	struct vhost_scsi_cmd *tv_cmd;
+	unsigned int i;
+
+	if (!svq->scsi_cmds)
+		return;
+
+	for (i = 0; i < svq->max_cmds; i++) {
+		tv_cmd = &svq->scsi_cmds[i];
+
+		kfree(tv_cmd->tvc_sgl);
+		kfree(tv_cmd->tvc_prot_sgl);
+		kfree(tv_cmd->tvc_upages);
+	}
+
+	sbitmap_free(&svq->scsi_tags);
+	kfree(svq->scsi_cmds);
+	svq->scsi_cmds = NULL;
+}
+
+static int vhost_scsi_setup_vq_cmds(struct vhost_virtqueue *vq, int max_cmds)
+{
+	struct vhost_scsi_virtqueue *svq = container_of(vq,
+					struct vhost_scsi_virtqueue, vq);
+	struct vhost_scsi_cmd *tv_cmd;
+	unsigned int i;
+
+	if (svq->scsi_cmds)
+		return 0;
+
+	if (sbitmap_init_node(&svq->scsi_tags, max_cmds, -1, GFP_KERNEL,
+			      NUMA_NO_NODE))
+		return -ENOMEM;
+	svq->max_cmds = max_cmds;
+
+	svq->scsi_cmds = kcalloc(max_cmds, sizeof(*tv_cmd), GFP_KERNEL);
+	if (!svq->scsi_cmds) {
+		sbitmap_free(&svq->scsi_tags);
+		return -ENOMEM;
+	}
+
+	for (i = 0; i < max_cmds; i++) {
+		tv_cmd = &svq->scsi_cmds[i];
+
+		tv_cmd->tvc_sgl = kcalloc(VHOST_SCSI_PREALLOC_SGLS,
+					  sizeof(struct scatterlist),
+					  GFP_KERNEL);
+		if (!tv_cmd->tvc_sgl) {
+			pr_err("Unable to allocate tv_cmd->tvc_sgl\n");
+			goto out;
+		}
+
+		tv_cmd->tvc_upages = kcalloc(VHOST_SCSI_PREALLOC_UPAGES,
+					     sizeof(struct page *),
+					     GFP_KERNEL);
+		if (!tv_cmd->tvc_upages) {
+			pr_err("Unable to allocate tv_cmd->tvc_upages\n");
+			goto out;
+		}
+
+		tv_cmd->tvc_prot_sgl = kcalloc(VHOST_SCSI_PREALLOC_PROT_SGLS,
+					       sizeof(struct scatterlist),
+					       GFP_KERNEL);
+		if (!tv_cmd->tvc_prot_sgl) {
+			pr_err("Unable to allocate tv_cmd->tvc_prot_sgl\n");
+			goto out;
+		}
+	}
+	return 0;
+out:
+	vhost_scsi_destroy_vq_cmds(vq);
+	return -ENOMEM;
+}
+
 /*
  * Called from vhost_scsi_ioctl() context to walk the list of available
  * vhost_scsi_tpg with an active struct vhost_scsi_nexus
@@ -1427,10 +1507,9 @@ vhost_scsi_set_endpoint(struct vhost_scsi *vs,
 
 		if (!strcmp(tv_tport->tport_name, t->vhost_wwpn)) {
 			if (vs->vs_tpg && vs->vs_tpg[tpg->tport_tpgt]) {
-				kfree(vs_tpg);
 				mutex_unlock(&tpg->tv_tpg_mutex);
 				ret = -EEXIST;
-				goto out;
+				goto undepend;
 			}
 			/*
 			 * In order to ensure individual vhost-scsi configfs
@@ -1442,9 +1521,8 @@ vhost_scsi_set_endpoint(struct vhost_scsi *vs,
 			ret = target_depend_item(&se_tpg->tpg_group.cg_item);
 			if (ret) {
 				pr_warn("target_depend_item() failed: %d\n", ret);
-				kfree(vs_tpg);
 				mutex_unlock(&tpg->tv_tpg_mutex);
-				goto out;
+				goto undepend;
 			}
 			tpg->tv_tpg_vhost_count++;
 			tpg->vhost_scsi = vs;
@@ -1457,6 +1535,16 @@ vhost_scsi_set_endpoint(struct vhost_scsi *vs,
 	if (match) {
 		memcpy(vs->vs_vhost_wwpn, t->vhost_wwpn,
 		       sizeof(vs->vs_vhost_wwpn));
+
+		for (i = VHOST_SCSI_VQ_IO; i < VHOST_SCSI_MAX_VQ; i++) {
+			vq = &vs->vqs[i].vq;
+			if (!vhost_vq_is_setup(vq))
+				continue;
+
+			if (vhost_scsi_setup_vq_cmds(vq, vq->num))
+				goto destroy_vq_cmds;
+		}
+
 		for (i = 0; i < VHOST_SCSI_MAX_VQ; i++) {
 			vq = &vs->vqs[i].vq;
 			mutex_lock(&vq->mutex);
@@ -1476,7 +1564,22 @@ vhost_scsi_set_endpoint(struct vhost_scsi *vs,
 	vhost_scsi_flush(vs);
 	kfree(vs->vs_tpg);
 	vs->vs_tpg = vs_tpg;
+	goto out;
 
+destroy_vq_cmds:
+	for (i--; i >= VHOST_SCSI_VQ_IO; i--) {
+		if (!vhost_vq_get_backend(&vs->vqs[i].vq))
+			vhost_scsi_destroy_vq_cmds(&vs->vqs[i].vq);
+	}
+undepend:
+	for (i = 0; i < VHOST_SCSI_MAX_TARGET; i++) {
+		tpg = vs_tpg[i];
+		if (tpg) {
+			tpg->tv_tpg_vhost_count--;
+			target_undepend_item(&tpg->se_tpg.tpg_group.cg_item);
+		}
+	}
+	kfree(vs_tpg);
 out:
 	mutex_unlock(&vs->dev.mutex);
 	mutex_unlock(&vhost_scsi_mutex);
@@ -1549,6 +1652,12 @@ vhost_scsi_clear_endpoint(struct vhost_scsi *vs,
 			mutex_lock(&vq->mutex);
 			vhost_vq_set_backend(vq, NULL);
 			mutex_unlock(&vq->mutex);
+			/*
+			 * Make sure cmds are not running before tearing them
+			 * down.
+			 */
+			vhost_scsi_flush(vs);
+			vhost_scsi_destroy_vq_cmds(vq);
 		}
 	}
 	/*
@@ -1842,23 +1951,6 @@ static void vhost_scsi_port_unlink(struct se_portal_group *se_tpg,
 	mutex_unlock(&vhost_scsi_mutex);
 }
 
-static void vhost_scsi_free_cmd_map_res(struct se_session *se_sess)
-{
-	struct vhost_scsi_cmd *tv_cmd;
-	unsigned int i;
-
-	if (!se_sess->sess_cmd_map)
-		return;
-
-	for (i = 0; i < VHOST_SCSI_DEFAULT_TAGS; i++) {
-		tv_cmd = &((struct vhost_scsi_cmd *)se_sess->sess_cmd_map)[i];
-
-		kfree(tv_cmd->tvc_sgl);
-		kfree(tv_cmd->tvc_prot_sgl);
-		kfree(tv_cmd->tvc_upages);
-	}
-}
-
 static ssize_t vhost_scsi_tpg_attrib_fabric_prot_type_store(
 		struct config_item *item, const char *page, size_t count)
 {
@@ -1898,45 +1990,6 @@ static struct configfs_attribute *vhost_scsi_tpg_attrib_attrs[] = {
 	NULL,
 };
 
-static int vhost_scsi_nexus_cb(struct se_portal_group *se_tpg,
-			       struct se_session *se_sess, void *p)
-{
-	struct vhost_scsi_cmd *tv_cmd;
-	unsigned int i;
-
-	for (i = 0; i < VHOST_SCSI_DEFAULT_TAGS; i++) {
-		tv_cmd = &((struct vhost_scsi_cmd *)se_sess->sess_cmd_map)[i];
-
-		tv_cmd->tvc_sgl = kcalloc(VHOST_SCSI_PREALLOC_SGLS,
-					  sizeof(struct scatterlist),
-					  GFP_KERNEL);
-		if (!tv_cmd->tvc_sgl) {
-			pr_err("Unable to allocate tv_cmd->tvc_sgl\n");
-			goto out;
-		}
-
-		tv_cmd->tvc_upages = kcalloc(VHOST_SCSI_PREALLOC_UPAGES,
-					     sizeof(struct page *),
-					     GFP_KERNEL);
-		if (!tv_cmd->tvc_upages) {
-			pr_err("Unable to allocate tv_cmd->tvc_upages\n");
-			goto out;
-		}
-
-		tv_cmd->tvc_prot_sgl = kcalloc(VHOST_SCSI_PREALLOC_PROT_SGLS,
-					       sizeof(struct scatterlist),
-					       GFP_KERNEL);
-		if (!tv_cmd->tvc_prot_sgl) {
-			pr_err("Unable to allocate tv_cmd->tvc_prot_sgl\n");
-			goto out;
-		}
-	}
-	return 0;
-out:
-	vhost_scsi_free_cmd_map_res(se_sess);
-	return -ENOMEM;
-}
-
 static int vhost_scsi_make_nexus(struct vhost_scsi_tpg *tpg,
 				const char *name)
 {
@@ -1960,12 +2013,9 @@ static int vhost_scsi_make_nexus(struct vhost_scsi_tpg *tpg,
 	 * struct se_node_acl for the vhost_scsi struct se_portal_group with
 	 * the SCSI Initiator port name of the passed configfs group 'name'.
 	 */
-	tv_nexus->tvn_se_sess = target_setup_session(&tpg->se_tpg,
-					VHOST_SCSI_DEFAULT_TAGS,
-					sizeof(struct vhost_scsi_cmd),
+	tv_nexus->tvn_se_sess = target_setup_session(&tpg->se_tpg, 0, 0,
 					TARGET_PROT_DIN_PASS | TARGET_PROT_DOUT_PASS,
-					(unsigned char *)name, tv_nexus,
-					vhost_scsi_nexus_cb);
+					(unsigned char *)name, tv_nexus, NULL);
 	if (IS_ERR(tv_nexus->tvn_se_sess)) {
 		mutex_unlock(&tpg->tv_tpg_mutex);
 		kfree(tv_nexus);
@@ -2015,7 +2065,6 @@ static int vhost_scsi_drop_nexus(struct vhost_scsi_tpg *tpg)
 		" %s Initiator Port: %s\n", vhost_scsi_dump_proto_id(tpg->tport),
 		tv_nexus->tvn_se_sess->se_node_acl->initiatorname);
 
-	vhost_scsi_free_cmd_map_res(se_sess);
 	/*
 	 * Release the SCSI I_T Nexus to the emulated vhost Target Port
 	 */
-- 
2.27.0

