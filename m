Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12BA668F5E6
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 18:45:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232027AbjBHRpe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 12:45:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232571AbjBHRpM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 12:45:12 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 220FF1ABF6;
        Wed,  8 Feb 2023 09:44:04 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 698D91FFB2;
        Wed,  8 Feb 2023 17:41:01 +0000 (UTC)
Received: from localhost (unknown [10.163.24.10])
        by relay2.suse.de (Postfix) with ESMTP id 2B4242C143;
        Wed,  8 Feb 2023 17:41:01 +0000 (UTC)
Received: by localhost (Postfix, from userid 1000)
        id 3D19DCA18E; Wed,  8 Feb 2023 09:40:57 -0800 (PST)
From:   Lee Duncan <leeman.duncan@gmail.com>
To:     linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com,
        netdev@vger.kernel.org
Cc:     Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>
Subject: [RFC PATCH 5/9] iscsi: set netns for iscsi_tcp hosts
Date:   Wed,  8 Feb 2023 09:40:53 -0800
Message-Id: <566c527d12f6ed56eeb40952fef7431a0ccdc78f.1675876735.git.lduncan@suse.com>
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

This lets iscsi_tcp operate in multiple namespaces.  It uses current
during session creation to find the net namespace, but it might be
better to manage to pass it along from the iscsi netlink socket.

Signed-off-by: Chris Leech <cleech@redhat.com>
Signed-off-by: Lee Duncan <lduncan@suse.com>
---
 drivers/scsi/iscsi_tcp.c            | 7 +++++++
 drivers/scsi/scsi_transport_iscsi.c | 7 ++++++-
 include/scsi/scsi_transport_iscsi.h | 1 +
 3 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 0454d94e8cf0..22e7a5c93627 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -1069,6 +1069,11 @@ static int iscsi_sw_tcp_slave_configure(struct scsi_device *sdev)
 	return 0;
 }
 
+static struct net *iscsi_sw_tcp_netns(struct Scsi_Host *shost)
+{
+	return current->nsproxy->net_ns;
+}
+
 static struct scsi_host_template iscsi_sw_tcp_sht = {
 	.module			= THIS_MODULE,
 	.name			= "iSCSI Initiator over TCP/IP",
@@ -1124,6 +1129,8 @@ static struct iscsi_transport iscsi_sw_tcp_transport = {
 	.alloc_pdu		= iscsi_sw_tcp_pdu_alloc,
 	/* recovery */
 	.session_recovery_timedout = iscsi_session_recovery_timedout,
+	/* net namespace */
+	.get_netns		= iscsi_sw_tcp_netns,
 };
 
 static int __init iscsi_sw_tcp_init(void)
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 230b43d34c5f..996a9abfa1f5 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -1600,10 +1600,15 @@ static int iscsi_setup_host(struct transport_container *tc, struct device *dev,
 {
 	struct Scsi_Host *shost = dev_to_shost(dev);
 	struct iscsi_cls_host *ihost = shost->shost_data;
+	struct iscsi_internal *priv = to_iscsi_internal(shost->transportt);
+	struct iscsi_transport *transport = priv->iscsi_transport;
 
 	memset(ihost, 0, sizeof(*ihost));
 	mutex_init(&ihost->mutex);
-	ihost->netns = &init_net;
+	if (transport->get_netns)
+		ihost->netns = transport->get_netns(shost);
+	else
+		ihost->netns = &init_net;
 
 	iscsi_bsg_host_add(shost, ihost);
 	/* ignore any bsg add error - we just can't do sgio */
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index af0c5a15f316..f8885d0c37d8 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -156,6 +156,7 @@ struct iscsi_transport {
 	int (*logout_flashnode_sid) (struct iscsi_cls_session *cls_sess);
 	int (*get_host_stats) (struct Scsi_Host *shost, char *buf, int len);
 	u8 (*check_protection)(struct iscsi_task *task, sector_t *sector);
+	struct net *(*get_netns)(struct Scsi_Host *shost);
 };
 
 /*
-- 
2.39.1

