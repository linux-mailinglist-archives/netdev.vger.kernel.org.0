Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19B4466545B
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 07:08:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbjAKGIe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 01:08:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230507AbjAKGI3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 01:08:29 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6E57235
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 22:07:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673417262;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Mc+ipx3hL+0k3YEmh3Z9O8oX1giHqQaiQUDX7FtPiHI=;
        b=CGHGZhtBa/2ASDJdsk+fZ+v7H7b4ODQ5XhC/z3dHOKfwX8Umy0p2bqroSFR7C4QZEorTmd
        /1+UmdMwNOazEA/d7yLN923P5LReAe35hx9TT06nu8oB5aY+YMg7SIn/U7W4PcODrYkjcZ
        6sle5h8LLadIBMU0HuLBvLBmQTtcHo0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-439-R-fD7dCyMXmVJBHNXOeLJg-1; Wed, 11 Jan 2023 01:07:38 -0500
X-MC-Unique: R-fD7dCyMXmVJBHNXOeLJg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 154E71C07557;
        Wed, 11 Jan 2023 06:07:38 +0000 (UTC)
Received: from localhost.localdomain (ovpn-13-175.pek2.redhat.com [10.72.13.175])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AA7E440ED784;
        Wed, 11 Jan 2023 06:07:33 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com, pbonzini@redhat.com,
        stefanha@redhat.com
Cc:     bcodding@redhat.com, virtualization@lists.linux-foundation.org,
        kvm@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH] vhost-scsi: unbreak any layout for response
Date:   Wed, 11 Jan 2023 14:07:30 +0800
Message-Id: <20230111060730.24779-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Al Viro said:

"""
Since "vhost/scsi: fix reuse of &vq->iov[out] in response"
we have this:
                cmd->tvc_resp_iov = vq->iov[vc.out];
                cmd->tvc_in_iovs = vc.in;
combined with
                iov_iter_init(&iov_iter, ITER_DEST, &cmd->tvc_resp_iov,
                              cmd->tvc_in_iovs, sizeof(v_rsp));
in vhost_scsi_complete_cmd_work().  We used to have ->tvc_resp_iov
_pointing_ to vq->iov[vc.out]; back then iov_iter_init() asked to
set an iovec-backed iov_iter over the tail of vq->iov[], with
length being the amount of iovecs in the tail.

Now we have a copy of one element of that array.  Fortunately, the members
following it in the containing structure are two non-NULL kernel pointers,
so copy_to_iter() will not copy anything beyond the first iovec - kernel
pointer is not (on the majority of architectures) going to be accepted by
access_ok() in copyout() and it won't be skipped since the "length" (in
reality - another non-NULL kernel pointer) won't be zero.

So it's not going to give a guest-to-qemu escalation, but it's definitely
a bug.  Frankly, my preference would be to verify that the very first iovec
is long enough to hold rsp_size.  Due to the above, any users that try to
give us vq->iov[vc.out].iov_len < sizeof(struct virtio_scsi_cmd_resp)
would currently get a failure in vhost_scsi_complete_cmd_work()
anyway.
"""

However, the spec doesn't say anything about the legacy descriptor
layout for the respone. So this patch tries to not assume the response
to reside in a single separate descriptor which is what commit
79c14141a487 ("vhost/scsi: Convert completion path to use") tries to
achieve towards to ANY_LAYOUT.

This is done by allocating and using dedicate resp iov in the
command. To be safety, start with UIO_MAXIOV to be consistent with the
vhost core.

Testing with the hacked virtio-scsi driver that use 1 descriptor for 1
byte in the response.

Reported-by: Al Viro <viro@zeniv.linux.org.uk>
Cc: Benjamin Coddington <bcodding@redhat.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Fixes: a77ec83a5789 ("vhost/scsi: fix reuse of &vq->iov[out] in response")
Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vhost/scsi.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index dca6346d75b3..7d6d70072603 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -80,7 +80,7 @@ struct vhost_scsi_cmd {
 	struct scatterlist *tvc_prot_sgl;
 	struct page **tvc_upages;
 	/* Pointer to response header iovec */
-	struct iovec tvc_resp_iov;
+	struct iovec *tvc_resp_iov;
 	/* Pointer to vhost_scsi for our device */
 	struct vhost_scsi *tvc_vhost;
 	/* Pointer to vhost_virtqueue for the cmd */
@@ -563,7 +563,7 @@ static void vhost_scsi_complete_cmd_work(struct vhost_work *work)
 		memcpy(v_rsp.sense, cmd->tvc_sense_buf,
 		       se_cmd->scsi_sense_length);
 
-		iov_iter_init(&iov_iter, ITER_DEST, &cmd->tvc_resp_iov,
+		iov_iter_init(&iov_iter, ITER_DEST, cmd->tvc_resp_iov,
 			      cmd->tvc_in_iovs, sizeof(v_rsp));
 		ret = copy_to_iter(&v_rsp, sizeof(v_rsp), &iov_iter);
 		if (likely(ret == sizeof(v_rsp))) {
@@ -594,6 +594,7 @@ vhost_scsi_get_cmd(struct vhost_virtqueue *vq, struct vhost_scsi_tpg *tpg,
 	struct vhost_scsi_cmd *cmd;
 	struct vhost_scsi_nexus *tv_nexus;
 	struct scatterlist *sg, *prot_sg;
+	struct iovec *tvc_resp_iov;
 	struct page **pages;
 	int tag;
 
@@ -613,6 +614,7 @@ vhost_scsi_get_cmd(struct vhost_virtqueue *vq, struct vhost_scsi_tpg *tpg,
 	sg = cmd->tvc_sgl;
 	prot_sg = cmd->tvc_prot_sgl;
 	pages = cmd->tvc_upages;
+	tvc_resp_iov = cmd->tvc_resp_iov;
 	memset(cmd, 0, sizeof(*cmd));
 	cmd->tvc_sgl = sg;
 	cmd->tvc_prot_sgl = prot_sg;
@@ -625,6 +627,7 @@ vhost_scsi_get_cmd(struct vhost_virtqueue *vq, struct vhost_scsi_tpg *tpg,
 	cmd->tvc_data_direction = data_direction;
 	cmd->tvc_nexus = tv_nexus;
 	cmd->inflight = vhost_scsi_get_inflight(vq);
+	cmd->tvc_resp_iov = tvc_resp_iov;
 
 	memcpy(cmd->tvc_cdb, cdb, VHOST_SCSI_MAX_CDB_SIZE);
 
@@ -935,7 +938,7 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 	struct iov_iter in_iter, prot_iter, data_iter;
 	u64 tag;
 	u32 exp_data_len, data_direction;
-	int ret, prot_bytes, c = 0;
+	int ret, prot_bytes, i, c = 0;
 	u16 lun;
 	u8 task_attr;
 	bool t10_pi = vhost_has_feature(vq, VIRTIO_SCSI_F_T10_PI);
@@ -1092,7 +1095,8 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 		}
 		cmd->tvc_vhost = vs;
 		cmd->tvc_vq = vq;
-		cmd->tvc_resp_iov = vq->iov[vc.out];
+		for (i = 0; i < vc.in ; i++)
+			cmd->tvc_resp_iov[i] = vq->iov[vc.out + i];
 		cmd->tvc_in_iovs = vc.in;
 
 		pr_debug("vhost_scsi got command opcode: %#02x, lun: %d\n",
@@ -1461,6 +1465,7 @@ static void vhost_scsi_destroy_vq_cmds(struct vhost_virtqueue *vq)
 		kfree(tv_cmd->tvc_sgl);
 		kfree(tv_cmd->tvc_prot_sgl);
 		kfree(tv_cmd->tvc_upages);
+		kfree(tv_cmd->tvc_resp_iov);
 	}
 
 	sbitmap_free(&svq->scsi_tags);
@@ -1508,6 +1513,14 @@ static int vhost_scsi_setup_vq_cmds(struct vhost_virtqueue *vq, int max_cmds)
 			goto out;
 		}
 
+		tv_cmd->tvc_resp_iov = kcalloc(UIO_MAXIOV,
+					       sizeof(struct page *),
+					       GFP_KERNEL);
+		if (!tv_cmd->tvc_resp_iov) {
+			pr_err("Unable to allocate tv_cmd->tvc_resp_iov\n");
+			goto out;
+		}
+
 		tv_cmd->tvc_prot_sgl = kcalloc(VHOST_SCSI_PREALLOC_PROT_SGLS,
 					       sizeof(struct scatterlist),
 					       GFP_KERNEL);
-- 
2.25.1

