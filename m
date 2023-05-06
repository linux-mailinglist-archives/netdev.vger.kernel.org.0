Return-Path: <netdev+bounces-718-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D74D06F94F9
	for <lists+netdev@lfdr.de>; Sun,  7 May 2023 01:30:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 954811C217CC
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 23:29:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD6BA1095A;
	Sat,  6 May 2023 23:29:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA773C2EB
	for <netdev@vger.kernel.org>; Sat,  6 May 2023 23:29:58 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F217040FE
	for <netdev@vger.kernel.org>; Sat,  6 May 2023 16:29:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683415796;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+gNvFiVxqoiEcwnyK8XYJDq5WEteQhpcSXCb2jal7a0=;
	b=Zh1Y7uOpdltWQrMzW5t62AQW73zIYBqNyzn1k5FGwtPmhCdSA8IhCYyFN/x/uKaUQSiXpg
	awSUcArfuta21mqODdjACjhuGWoYmgJfnCV7/6vRbOxxJaDmbeeSHAmCO/NN5a645//tog
	1Eyc5qB4IemL2t0Z2Yvpvgh1fkV5wWo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-557-9Ma0TpdnOWKX11mgr_TQyw-1; Sat, 06 May 2023 19:29:54 -0400
X-MC-Unique: 9Ma0TpdnOWKX11mgr_TQyw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AA39385A588;
	Sat,  6 May 2023 23:29:53 +0000 (UTC)
Received: from toolbox.redhat.com (unknown [10.2.16.10])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 21B37440BC;
	Sat,  6 May 2023 23:29:53 +0000 (UTC)
From: Chris Leech <cleech@redhat.com>
To: Lee Duncan <lduncan@suse.com>,
	linux-scsi@vger.kernel.org,
	open-iscsi@googlegroups.com,
	netdev@vger.kernel.org
Cc: Chris Leech <cleech@redhat.com>
Subject: [PATCH 01/11] iscsi: create per-net iscsi netlink kernel sockets
Date: Sat,  6 May 2023 16:29:20 -0700
Message-Id: <20230506232930.195451-2-cleech@redhat.com>
In-Reply-To: <20230506232930.195451-1-cleech@redhat.com>
References: <20230506232930.195451-1-cleech@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Lee Duncan <lduncan@suse.com>

Prepare iSCSI netlink to operate in multiple namespaces.

Signed-off-by: Lee Duncan <lduncan@suse.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Chris Leech <cleech@redhat.com>
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
2.39.2


