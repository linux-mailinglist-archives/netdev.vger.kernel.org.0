Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6340D2ECFFA
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 13:42:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728350AbhAGMjr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 07:39:47 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:8689 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728204AbhAGMjq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 07:39:46 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5ff700ea0000>; Thu, 07 Jan 2021 04:39:06 -0800
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 7 Jan
 2021 12:39:05 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1473.3 via Frontend
 Transport; Thu, 7 Jan 2021 12:39:03 +0000
From:   Eran Ben Elisha <eranbe@nvidia.com>
To:     <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>
CC:     Tariq Toukan <tariqt@nvidia.com>,
        Eran Ben Elisha <eranbe@nvidia.com>
Subject: [PATCH net-next 1/2] net: vlan: Add parse protocol header ops
Date:   Thu, 7 Jan 2021 14:38:59 +0200
Message-ID: <1610023140-20256-2-git-send-email-eranbe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1610023140-20256-1-git-send-email-eranbe@nvidia.com>
References: <1610023140-20256-1-git-send-email-eranbe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1610023146; bh=tCYjgofZgw0uArsqzR5z4wwhD1tZyn0bJ13TuqGapCw=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Type;
        b=M5cCLNpzBARYfX0ILG8gJyj+wxieH52cGsmqgIhVRQMTDfL9Wwtpwac49wspQLzne
         q9tC2mESf7KXO1yHaJagU92OSLLf9H5bs5EEQxA5k3M0itLcaDAVkGqKdL+YLJgUJZ
         TuoTxtl9YCOTD8E2iRDBEo1cexlR7fLiMP+e1ci8wZvl05f5JUYjq3qv3To+t56k7r
         WJRZv5WZA/ofaylP+9SHowUzpFW1B+KZkbs0DRIvz8iiN/zdlA6OUma24PuHkPi39g
         +YbExv8ykS8f1BOmwHhvJXl3OI1IuVRanfETbfWcIsVr65w1QpLq+X7Ag7vUSGtDyF
         wzn1EHypdMTPA==
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

