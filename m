Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C87568F5E4
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 18:45:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230310AbjBHRpT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 12:45:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231483AbjBHRoI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 12:44:08 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 623C451C5B;
        Wed,  8 Feb 2023 09:42:44 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 40A9C1FF18;
        Wed,  8 Feb 2023 17:40:59 +0000 (UTC)
Received: from localhost (unknown [10.163.24.10])
        by relay2.suse.de (Postfix) with ESMTP id 010642C142;
        Wed,  8 Feb 2023 17:40:58 +0000 (UTC)
Received: by localhost (Postfix, from userid 1000)
        id 208A3CA186; Wed,  8 Feb 2023 09:40:57 -0800 (PST)
From:   Lee Duncan <leeman.duncan@gmail.com>
To:     linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com,
        netdev@vger.kernel.org
Cc:     Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>
Subject: [RFC PATCH 1/9] iscsi: create per-net iscsi netlink kernel sockets
Date:   Wed,  8 Feb 2023 09:40:49 -0800
Message-Id: <95df16a252bc2c9f0e7fba667d2f542814c9b91b.1675876733.git.lduncan@suse.com>
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

Prepare iSCSI netlink to operate in multiple namespaces.

Signed-off-by: Chris Leech <cleech@redhat.com>
Signed-off-by: Lee Duncan <lduncan@suse.com>
---
 drivers/scsi/scsi_transport_iscsi.c | 73 +++++++++++++++++++++++++----
 1 file changed, 63 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index b9b97300e3b3..be69cea9c6f8 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -13,6 +13,8 @@
 #include <linux/bsg-lib.h>
 #include <linux/idr.h>
 #include <net/tcp.h>
+#include <net/net_namespace.h>
+#include <net/netns/generic.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_device.h>
@@ -1597,7 +1599,11 @@ static DECLARE_TRANSPORT_CLASS(iscsi_connection_class,
 			       NULL,
 			       NULL);
 
-static struct sock *nls;
+struct iscsi_net {
+	struct sock *nls;
+};
+
+static int iscsi_net_id __read_mostly;
 static DEFINE_MUTEX(rx_queue_mutex);
 
 static LIST_HEAD(sesslist);
@@ -2552,14 +2558,32 @@ iscsi_if_transport_lookup(struct iscsi_transport *tt)
 }
 
 static int
-iscsi_multicast_skb(struct sk_buff *skb, uint32_t group, gfp_t gfp)
+iscsi_multicast_netns(struct net *net, struct sk_buff *skb,
+		      uint32_t group, gfp_t gfp)
 {
+	struct sock *nls;
+	struct iscsi_net *isn;
+
+	isn = net_generic(net, iscsi_net_id);
+	nls = isn->nls;
 	return nlmsg_multicast(nls, skb, 0, group, gfp);
 }
 
+static int
+iscsi_multicast_skb(struct sk_buff *skb, uint32_t group, gfp_t gfp)
+{
+	return iscsi_multicast_netns(&init_net, skb, group, gfp);
+}
+
 static int
 iscsi_unicast_skb(struct sk_buff *skb, u32 portid)
 {
+	struct sock *nls;
+	struct iscsi_net *isn;
+	struct net *net = &init_net;
+
+	isn = net_generic(net, iscsi_net_id);
+	nls = isn->nls;
 	return nlmsg_unicast(nls, skb, portid);
 }
 
@@ -4937,13 +4961,42 @@ void iscsi_dbg_trace(void (*trace)(struct device *dev, struct va_format *),
 }
 EXPORT_SYMBOL_GPL(iscsi_dbg_trace);
 
-static __init int iscsi_transport_init(void)
+static int __net_init iscsi_net_init(struct net *net)
 {
-	int err;
+	struct sock *nls;
+	struct iscsi_net *isn;
 	struct netlink_kernel_cfg cfg = {
 		.groups	= 1,
 		.input	= iscsi_if_rx,
 	};
+
+	nls = netlink_kernel_create(net, NETLINK_ISCSI, &cfg);
+	if (!nls)
+		return -ENOMEM;
+	isn = net_generic(net, iscsi_net_id);
+	isn->nls = nls;
+	return 0;
+}
+
+static void __net_exit iscsi_net_exit(struct net *net)
+{
+	struct iscsi_net *isn;
+
+	isn = net_generic(net, iscsi_net_id);
+	netlink_kernel_release(isn->nls);
+	isn->nls = NULL;
+}
+
+static struct pernet_operations iscsi_net_ops = {
+	.init = iscsi_net_init,
+	.exit = iscsi_net_exit,
+	.id   = &iscsi_net_id,
+	.size = sizeof(struct iscsi_net),
+};
+
+static __init int iscsi_transport_init(void)
+{
+	int err;
 	printk(KERN_INFO "Loading iSCSI transport class v%s.\n",
 		ISCSI_TRANSPORT_VERSION);
 
@@ -4977,8 +5030,8 @@ static __init int iscsi_transport_init(void)
 	if (err)
 		goto unregister_session_class;
 
-	nls = netlink_kernel_create(&init_net, NETLINK_ISCSI, &cfg);
-	if (!nls) {
+	err = register_pernet_subsys(&iscsi_net_ops);
+	if (err) {
 		err = -ENOBUFS;
 		goto unregister_flashnode_bus;
 	}
@@ -4988,13 +5041,13 @@ static __init int iscsi_transport_init(void)
 			"iscsi_conn_cleanup");
 	if (!iscsi_conn_cleanup_workq) {
 		err = -ENOMEM;
-		goto release_nls;
+		goto unregister_pernet_subsys;
 	}
 
 	return 0;
 
-release_nls:
-	netlink_kernel_release(nls);
+unregister_pernet_subsys:
+	unregister_pernet_subsys(&iscsi_net_ops);
 unregister_flashnode_bus:
 	bus_unregister(&iscsi_flashnode_bus);
 unregister_session_class:
@@ -5015,7 +5068,7 @@ static __init int iscsi_transport_init(void)
 static void __exit iscsi_transport_exit(void)
 {
 	destroy_workqueue(iscsi_conn_cleanup_workq);
-	netlink_kernel_release(nls);
+	unregister_pernet_subsys(&iscsi_net_ops);
 	bus_unregister(&iscsi_flashnode_bus);
 	transport_class_unregister(&iscsi_connection_class);
 	transport_class_unregister(&iscsi_session_class);
-- 
2.39.1

