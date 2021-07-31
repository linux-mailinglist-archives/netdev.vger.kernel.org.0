Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 867A83DC471
	for <lists+netdev@lfdr.de>; Sat, 31 Jul 2021 09:30:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231725AbhGaHan (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Jul 2021 03:30:43 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:13219 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229715AbhGaHal (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Jul 2021 03:30:41 -0400
Received: from dggeme760-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4GcG402VFmz1CQwc;
        Sat, 31 Jul 2021 15:24:32 +0800 (CST)
Received: from huawei.com (10.175.112.208) by dggeme760-chm.china.huawei.com
 (10.3.19.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Sat, 31
 Jul 2021 15:30:31 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <jreuter@yaina.de>, <ralf@linux-mips.org>, <davem@davemloft.net>,
        <kuba@kernel.org>, <linux-hams@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH -next] net: ax25: Fix error path of ax25_init()
Date:   Sat, 31 Jul 2021 07:27:32 +0000
Message-ID: <20210731072732.103631-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.9.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.208]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggeme760-chm.china.huawei.com (10.3.19.106)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch add error path for ax25_init() to avoid possible crash if some
error occurs.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 net/ax25/af_ax25.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index 2631efc..4edc322 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -1977,17 +1977,32 @@ static int __init ax25_init(void)
 {
 	int rc = proto_register(&ax25_proto, 0);
 
-	if (rc != 0)
+	if (rc)
 		goto out;
 
-	sock_register(&ax25_family_ops);
-	dev_add_pack(&ax25_packet_type);
-	register_netdevice_notifier(&ax25_dev_notifier);
+	rc = sock_register(&ax25_family_ops);
+	if (rc)
+		goto out_proto;
+	rc = dev_add_pack(&ax25_packet_type);
+	if (rc)
+		goto out_sock;
+	rc = register_netdevice_notifier(&ax25_dev_notifier);
+	if (rc)
+		goto out_dev;
 
 	proc_create_seq("ax25_route", 0444, init_net.proc_net, &ax25_rt_seqops);
 	proc_create_seq("ax25", 0444, init_net.proc_net, &ax25_info_seqops);
 	proc_create_seq("ax25_calls", 0444, init_net.proc_net,
 			&ax25_uid_seqops);
+
+	return 0;
+
+out_dev:
+	dev_remove_pack(&ax25_packet_type);
+out_sock:
+	sock_unregister(PF_AX25);
+out_proto:
+	proto_unregister(&ax25_proto);
 out:
 	return rc;
 }
-- 
2.9.4

