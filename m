Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14F544BD6E
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 18:03:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729753AbfFSQDD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 12:03:03 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:36182 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726332AbfFSQDC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Jun 2019 12:03:02 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id D8830DA68DB5B2867508;
        Thu, 20 Jun 2019 00:02:56 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.439.0; Thu, 20 Jun 2019
 00:02:46 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <davem@davemloft.net>, <sdf@google.com>, <jianbol@mellanox.com>,
        <jiri@mellanox.com>, <mirq-linux@rere.qmqm.pl>,
        <willemb@google.com>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH] flow_dissector: Fix vlan header offset in __skb_flow_dissect
Date:   Thu, 20 Jun 2019 00:01:32 +0800
Message-ID: <20190619160132.38416-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We build vlan on top of bonding interface, which vlan offload
is off, bond mode is 802.3ad (LACP) and xmit_hash_policy is
BOND_XMIT_POLICY_ENCAP34.

__skb_flow_dissect() fails to get information from protocol headers
encapsulated within vlan, because 'nhoff' is points to IP header,
so bond hashing is based on layer 2 info, which fails to distribute
packets across slaves.

Fixes: d5709f7ab776 ("flow_dissector: For stripped vlan, get vlan info from skb->vlan_tci")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 net/core/flow_dissector.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index 415b95f..2a52abb 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -785,6 +785,9 @@ bool __skb_flow_dissect(const struct sk_buff *skb,
 		    skb && skb_vlan_tag_present(skb)) {
 			proto = skb->protocol;
 		} else {
+			if (dissector_vlan == FLOW_DISSECTOR_KEY_MAX)
+				nhoff -=  sizeof(*vlan);
+
 			vlan = __skb_header_pointer(skb, nhoff, sizeof(_vlan),
 						    data, hlen, &_vlan);
 			if (!vlan) {
-- 
2.7.0


