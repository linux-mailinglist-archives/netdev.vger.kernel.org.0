Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C80163B756
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 02:41:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235000AbiK2Blv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 20:41:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233573AbiK2Blr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 20:41:47 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F72E26AF1
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 17:41:46 -0800 (PST)
Received: from dggpeml500024.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NLlRQ18wpzRpYX;
        Tue, 29 Nov 2022 09:41:06 +0800 (CST)
Received: from huawei.com (10.175.112.208) by dggpeml500024.china.huawei.com
 (7.185.36.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Tue, 29 Nov
 2022 09:41:44 +0800
From:   Yuan Can <yuancan@huawei.com>
To:     <davem@davemloft.net>, <yoshfuji@linux-ipv6.org>,
        <dsahern@kernel.org>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     <yuancan@huawei.com>
Subject: [PATCH v2] udp_tunnel: Add checks for nla_nest_start() in __udp_tunnel_nic_dump_write()
Date:   Tue, 29 Nov 2022 01:39:34 +0000
Message-ID: <20221129013934.55184-1-yuancan@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.208]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500024.china.huawei.com (7.185.36.10)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As the nla_nest_start() may fail with NULL returned, the return value needs
to be checked.

Fixes: c7d759eb7b12 ("ethtool: add tunnel info interface")
Signed-off-by: Yuan Can <yuancan@huawei.com>
---
Changes in v2:
- return directly without calling nla_nest_cancel if nest_start fails

 net/ipv4/udp_tunnel_nic.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv4/udp_tunnel_nic.c b/net/ipv4/udp_tunnel_nic.c
index bc3a043a5d5c..029219749785 100644
--- a/net/ipv4/udp_tunnel_nic.c
+++ b/net/ipv4/udp_tunnel_nic.c
@@ -624,6 +624,8 @@ __udp_tunnel_nic_dump_write(struct net_device *dev, unsigned int table,
 			continue;
 
 		nest = nla_nest_start(skb, ETHTOOL_A_TUNNEL_UDP_TABLE_ENTRY);
+		if (!nest)
+			return -EMSGSIZE;
 
 		if (nla_put_be16(skb, ETHTOOL_A_TUNNEL_UDP_ENTRY_PORT,
 				 utn->entries[table][j].port) ||
-- 
2.17.1

