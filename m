Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9C785B9206
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 03:14:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbiIOBIq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 21:08:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiIOBIq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 21:08:46 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4812A8052E;
        Wed, 14 Sep 2022 18:08:41 -0700 (PDT)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4MSfB04wcsz14QWd;
        Thu, 15 Sep 2022 09:04:40 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 15 Sep 2022 09:08:38 +0800
From:   Ziyang Xuan <william.xuanziyang@huawei.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <netdev@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] net/af_packet: registration process optimization in packet_init()
Date:   Thu, 15 Sep 2022 09:08:35 +0800
Message-ID: <20220915010835.1761211-1-william.xuanziyang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 canpemm500006.china.huawei.com (7.192.105.130)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now, register_pernet_subsys() and register_netdevice_notifier() are both
after sock_register(). It can create PF_PACKET socket and process socket
once sock_register() successfully. It is possible PF_PACKET socket is
creating but register_pernet_subsys() and register_netdevice_notifier()
are not registered yet. Thus net->packet.sklist_lock and net->packet.sklist
will be accessed without initialization that is done in packet_net_init().
Although this is a low probability scenario.

Move register_pernet_subsys() and register_netdevice_notifier() to the
front in packet_init(). Correspondingly, adjust the unregister process
in packet_exit().

Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
---
 net/packet/af_packet.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 5cbe07116e04..52cc9931b367 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -4725,37 +4725,37 @@ static struct pernet_operations packet_net_ops = {
 
 static void __exit packet_exit(void)
 {
-	unregister_netdevice_notifier(&packet_netdev_notifier);
-	unregister_pernet_subsys(&packet_net_ops);
 	sock_unregister(PF_PACKET);
 	proto_unregister(&packet_proto);
+	unregister_netdevice_notifier(&packet_netdev_notifier);
+	unregister_pernet_subsys(&packet_net_ops);
 }
 
 static int __init packet_init(void)
 {
 	int rc;
 
-	rc = proto_register(&packet_proto, 0);
-	if (rc)
-		goto out;
-	rc = sock_register(&packet_family_ops);
-	if (rc)
-		goto out_proto;
 	rc = register_pernet_subsys(&packet_net_ops);
 	if (rc)
-		goto out_sock;
+		goto out;
 	rc = register_netdevice_notifier(&packet_netdev_notifier);
 	if (rc)
 		goto out_pernet;
+	rc = proto_register(&packet_proto, 0);
+	if (rc)
+		goto out_notifier;
+	rc = sock_register(&packet_family_ops);
+	if (rc)
+		goto out_proto;
 
 	return 0;
 
-out_pernet:
-	unregister_pernet_subsys(&packet_net_ops);
-out_sock:
-	sock_unregister(PF_PACKET);
 out_proto:
 	proto_unregister(&packet_proto);
+out_notifier:
+	unregister_netdevice_notifier(&packet_netdev_notifier);
+out_pernet:
+	unregister_pernet_subsys(&packet_net_ops);
 out:
 	return rc;
 }
-- 
2.25.1

