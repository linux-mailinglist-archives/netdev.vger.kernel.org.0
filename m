Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3332368F5E2
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 18:44:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231464AbjBHRoh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 12:44:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231301AbjBHRoI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 12:44:08 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4857E4FCD4;
        Wed,  8 Feb 2023 09:42:43 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 425C21FF2B;
        Wed,  8 Feb 2023 17:40:59 +0000 (UTC)
Received: from localhost (unknown [10.163.24.10])
        by relay2.suse.de (Postfix) with ESMTP id 03EB92C143;
        Wed,  8 Feb 2023 17:40:59 +0000 (UTC)
Received: by localhost (Postfix, from userid 1000)
        id 276D3CA188; Wed,  8 Feb 2023 09:40:57 -0800 (PST)
From:   Lee Duncan <leeman.duncan@gmail.com>
To:     linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com,
        netdev@vger.kernel.org
Cc:     Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>
Subject: [RFC PATCH 2/9] iscsi: associate endpoints with a host
Date:   Wed,  8 Feb 2023 09:40:50 -0800
Message-Id: <154c7602b3cc59f8af44439249ea5e5eb75f92d3.1675876734.git.lduncan@suse.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <cover.1675876731.git.lduncan@suse.com>
References: <cover.1675876731.git.lduncan@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NML_ADSP_CUSTOM_MED,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lee Duncan <lduncan@suse.com>

Right now the iscsi_endpoint is only linked to a connection once that
connection has been established.  For net namespace filtering of the
sysfs objects, associate an endpoint with the host that it was
allocated for when it is created.

Signed-off-by: Chris Leech <cleech@redhat.com>
Signed-off-by: Lee Duncan <lduncan@suse.com>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c | 2 +-
 drivers/scsi/be2iscsi/be_iscsi.c         | 2 +-
 drivers/scsi/bnx2i/bnx2i_iscsi.c         | 2 +-
 drivers/scsi/cxgbi/libcxgbi.c            | 2 +-
 drivers/scsi/qedi/qedi_iscsi.c           | 2 +-
 drivers/scsi/qla4xxx/ql4_os.c            | 2 +-
 drivers/scsi/scsi_transport_iscsi.c      | 3 ++-
 include/scsi/scsi_transport_iscsi.h      | 6 +++++-
 8 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 620ae5b2d80d..d38c909b462f 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -802,7 +802,7 @@ static struct iscsi_endpoint *iscsi_iser_ep_connect(struct Scsi_Host *shost,
 	struct iser_conn *iser_conn;
 	struct iscsi_endpoint *ep;
 
-	ep = iscsi_create_endpoint(0);
+	ep = iscsi_create_endpoint(shost, 0);
 	if (!ep)
 		return ERR_PTR(-ENOMEM);
 
diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index 8aeaddc93b16..c893d193f5ef 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -1168,7 +1168,7 @@ beiscsi_ep_connect(struct Scsi_Host *shost, struct sockaddr *dst_addr,
 		return ERR_PTR(ret);
 	}
 
-	ep = iscsi_create_endpoint(sizeof(struct beiscsi_endpoint));
+	ep = iscsi_create_endpoint(shost, sizeof(struct beiscsi_endpoint));
 	if (!ep) {
 		ret = -ENOMEM;
 		return ERR_PTR(ret);
diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index a3c800e04a2e..ac63e93e07c6 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -384,7 +384,7 @@ static struct iscsi_endpoint *bnx2i_alloc_ep(struct bnx2i_hba *hba)
 	struct bnx2i_endpoint *bnx2i_ep;
 	u32 ec_div;
 
-	ep = iscsi_create_endpoint(sizeof(*bnx2i_ep));
+	ep = iscsi_create_endpoint(hba->shost, sizeof(*bnx2i_ep));
 	if (!ep) {
 		printk(KERN_ERR "bnx2i: Could not allocate ep\n");
 		return NULL;
diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index af281e271f88..94edf8e1fb0c 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -2926,7 +2926,7 @@ struct iscsi_endpoint *cxgbi_ep_connect(struct Scsi_Host *shost,
 		goto release_conn;
 	}
 
-	ep = iscsi_create_endpoint(sizeof(*cep));
+	ep = iscsi_create_endpoint(shost, sizeof(*cep));
 	if (!ep) {
 		err = -ENOMEM;
 		pr_info("iscsi alloc ep, OOM.\n");
diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
index 31ec429104e2..4baf1dbb8e92 100644
--- a/drivers/scsi/qedi/qedi_iscsi.c
+++ b/drivers/scsi/qedi/qedi_iscsi.c
@@ -931,7 +931,7 @@ qedi_ep_connect(struct Scsi_Host *shost, struct sockaddr *dst_addr,
 		return ERR_PTR(-ENXIO);
 	}
 
-	ep = iscsi_create_endpoint(sizeof(struct qedi_endpoint));
+	ep = iscsi_create_endpoint(shost, sizeof(struct qedi_endpoint));
 	if (!ep) {
 		QEDI_ERR(&qedi->dbg_ctx, "endpoint create fail\n");
 		ret = -ENOMEM;
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 005502125b27..acebf9c92c04 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -1717,7 +1717,7 @@ qla4xxx_ep_connect(struct Scsi_Host *shost, struct sockaddr *dst_addr,
 	}
 
 	ha = iscsi_host_priv(shost);
-	ep = iscsi_create_endpoint(sizeof(struct qla_endpoint));
+	ep = iscsi_create_endpoint(shost, sizeof(struct qla_endpoint));
 	if (!ep) {
 		ret = -ENOMEM;
 		return ERR_PTR(ret);
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index be69cea9c6f8..86bafdb862a5 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -204,7 +204,7 @@ static struct attribute_group iscsi_endpoint_group = {
 };
 
 struct iscsi_endpoint *
-iscsi_create_endpoint(int dd_size)
+iscsi_create_endpoint(struct Scsi_Host *shost, int dd_size)
 {
 	struct iscsi_endpoint *ep;
 	int err, id;
@@ -230,6 +230,7 @@ iscsi_create_endpoint(int dd_size)
 
 	ep->id = id;
 	ep->dev.class = &iscsi_endpoint_class;
+	ep->dev.parent = &shost->shost_gendev;
 	dev_set_name(&ep->dev, "ep-%d", id);
 	err = device_register(&ep->dev);
         if (err)
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index 34c03707fb6e..268ccaac1c05 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -287,6 +287,9 @@ struct iscsi_cls_session {
 #define iscsi_session_to_shost(_session) \
 	dev_to_shost(_session->dev.parent)
 
+#define iscsi_endpoint_to_shost(_ep) \
+	dev_to_shost(_ep->dev.parent)
+
 #define starget_to_session(_stgt) \
 	iscsi_dev_to_session(_stgt->dev.parent)
 
@@ -462,7 +465,8 @@ extern void iscsi_put_conn(struct iscsi_cls_conn *conn);
 extern void iscsi_get_conn(struct iscsi_cls_conn *conn);
 extern void iscsi_unblock_session(struct iscsi_cls_session *session);
 extern void iscsi_block_session(struct iscsi_cls_session *session);
-extern struct iscsi_endpoint *iscsi_create_endpoint(int dd_size);
+extern struct iscsi_endpoint *iscsi_create_endpoint(struct Scsi_Host *shost,
+						    int dd_size);
 extern void iscsi_destroy_endpoint(struct iscsi_endpoint *ep);
 extern struct iscsi_endpoint *iscsi_lookup_endpoint(u64 handle);
 extern void iscsi_put_endpoint(struct iscsi_endpoint *ep);
-- 
2.39.1

