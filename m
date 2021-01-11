Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 616D22F0F6B
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 10:50:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728691AbhAKJs0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 04:48:26 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:1928 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728679AbhAKJs0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 04:48:26 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5ffc1ec00003>; Mon, 11 Jan 2021 01:47:44 -0800
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 11 Jan
 2021 09:47:42 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1473.3 via Frontend
 Transport; Mon, 11 Jan 2021 09:47:40 +0000
From:   Eran Ben Elisha <eranbe@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, Tariq Toukan <tariqt@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Jiri Pirko <jiri@nvidia.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Guillaume Nault <gnault@redhat.com>,
        Eran Ben Elisha <eranbe@nvidia.com>
Subject: [PATCH net-next v2 1/2] net: vlan: Add parse protocol header ops
Date:   Mon, 11 Jan 2021 11:46:51 +0200
Message-ID: <1610358412-25248-2-git-send-email-eranbe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1610358412-25248-1-git-send-email-eranbe@nvidia.com>
References: <1610358412-25248-1-git-send-email-eranbe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1610358464; bh=tCYjgofZgw0uArsqzR5z4wwhD1tZyn0bJ13TuqGapCw=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Type;
        b=X9gqZN2Wg0D5DZJ8ar1Cf3iIFnWjzrdGz0soxJf6b3bKjvIxC+iGKJniKqZAgVzCZ
         kt/9imEuP3o0/PPlSZIRbPB0MPJGQagVE7F+CTawgWsEkiIalkTxEKMO0oWKL7a0a9
         zOdgXq3Z3wQxISgQr5C79ROzBODIfbn57cZQkpxJVpVf+k89bc/MhILujzmi/nlf5x
         MHM2uym0OMdbuVgEojuWm+c/0wl7u+LZY++6d6AybSpJ76KF1RZNOpYNY82IwBJ8n8
         NIXOawhF2PgDUdCcKWlH9oXSOikre+7HYMRD9pKJIMd9pJSzOitJitLgNutEBBNYvE
         EtZHSI8ujiIXA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add parse protocol header ops for vlan device. Before this patch, vlan
tagged packet transmitted by af_packet had skb->protocol unset. Some
kernel methods (like __skb_flow_dissect()) rely on this missing information
for its packet processing.

Signed-off-by: Eran Ben Elisha <eranbe@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
---
 net/8021q/vlan_dev.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index ec8408d1638f..dc1a197792e6 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -510,9 +510,17 @@ static void vlan_dev_set_lockdep_class(struct net_device *dev)
 	netdev_for_each_tx_queue(dev, vlan_dev_set_lockdep_one, NULL);
 }
 
+static __be16 vlan_parse_protocol(const struct sk_buff *skb)
+{
+	struct vlan_ethhdr *veth = (struct vlan_ethhdr *)(skb->data);
+
+	return __vlan_get_protocol(skb, veth->h_vlan_proto, NULL);
+}
+
 static const struct header_ops vlan_header_ops = {
 	.create	 = vlan_dev_hard_header,
 	.parse	 = eth_header_parse,
+	.parse_protocol = vlan_parse_protocol,
 };
 
 static int vlan_passthru_hard_header(struct sk_buff *skb, struct net_device *dev,
@@ -532,6 +540,7 @@ static int vlan_passthru_hard_header(struct sk_buff *skb, struct net_device *dev
 static const struct header_ops vlan_passthru_header_ops = {
 	.create	 = vlan_passthru_hard_header,
 	.parse	 = eth_header_parse,
+	.parse_protocol = vlan_parse_protocol,
 };
 
 static struct device_type vlan_type = {
-- 
2.17.1

