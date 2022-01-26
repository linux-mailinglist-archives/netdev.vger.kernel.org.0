Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8208449C1FE
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 04:18:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237052AbiAZDSI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 22:18:08 -0500
Received: from szxga08-in.huawei.com ([45.249.212.255]:32058 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237017AbiAZDSH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 22:18:07 -0500
Received: from kwepemi100009.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Jk82R3NLSz1FD5q;
        Wed, 26 Jan 2022 11:14:07 +0800 (CST)
Received: from kwepeml500002.china.huawei.com (7.221.188.128) by
 kwepemi100009.china.huawei.com (7.221.188.242) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 26 Jan 2022 11:18:01 +0800
Received: from huawei.com (10.175.104.82) by kwepeml500002.china.huawei.com
 (7.221.188.128) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Wed, 26 Jan
 2022 11:18:00 +0800
From:   Huang Guobin <huangguobin4@huawei.com>
To:     <nikolay@cumulusnetworks.com>, <roopa@cumulusnetworks.com>,
        <davem@davemloft.net>
CC:     <bridge@lists.linux-foundation.org>, <netdev@vger.kernel.org>,
        <stable@vger.kernel.org>
Subject: [PATCH 4.19 1/1] net: bridge: clear bridge's private skb space on xmit
Date:   Wed, 26 Jan 2022 11:36:39 +0800
Message-ID: <20220126033639.909340-2-huangguobin4@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220126033639.909340-1-huangguobin4@huawei.com>
References: <20220126033639.909340-1-huangguobin4@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepeml500002.china.huawei.com (7.221.188.128)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>

[ Upstream commit fd65e5a95d08389444e8591a20538b3edece0e15 ]

We need to clear all of the bridge private skb variables as they can be
stale due to the packet being recirculated through the stack and then
transmitted through the bridge device. Similar memset is already done on
bridge's input. We've seen cases where proxyarp_replied was 1 on routed
multicast packets transmitted through the bridge to ports with neigh
suppress which were getting dropped. Same thing can in theory happen with
the port isolation bit as well.

Fixes: 821f1b21cabb ("bridge: add new BR_NEIGH_SUPPRESS port flag to suppress arp and nd flood")
Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Huang Guobin <huangguobin4@huawei.com>
---
 net/bridge/br_device.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
index a350c05b7ff5..7c6b1024dd4b 100644
--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -42,6 +42,8 @@ netdev_tx_t br_dev_xmit(struct sk_buff *skb, struct net_device *dev)
 	struct ethhdr *eth;
 	u16 vid = 0;
 
+	memset(skb->cb, 0, sizeof(struct br_input_skb_cb));
+
 	rcu_read_lock();
 	nf_ops = rcu_dereference(nf_br_ops);
 	if (nf_ops && nf_ops->br_dev_xmit_hook(skb)) {
-- 
2.25.1

