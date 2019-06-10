Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A02D73BEAC
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 23:29:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390205AbfFJV2e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 17:28:34 -0400
Received: from alln-iport-8.cisco.com ([173.37.142.95]:48333 "EHLO
        alln-iport-8.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389193AbfFJV2e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 17:28:34 -0400
X-Greylist: delayed 425 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Jun 2019 17:28:33 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=1724; q=dns/txt; s=iport;
  t=1560202113; x=1561411713;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=v99KLrLXi5Np9xBCfQxcfgOGI+oUw5rkya1Dz8ujbDs=;
  b=P1ysLboR3PkTsA2atmxY3YwdFJgPCtRq+CXPkD7rYpmUSgbF5q5QK8Bo
   L+ptw6ktL5hWEOB0K/pf3nO6qURSz7yo/itd7ZBajtMQspJD1GiJqaZM8
   ZR76PLYwcelIs8gnMWYI71y6k4zQfqtiMaHgrsFcDe6PX7Aul3wTWgPZE
   Y=;
X-IronPort-AV: E=Sophos;i="5.63,576,1557187200"; 
   d="scan'208";a="285159126"
Received: from rcdn-core-2.cisco.com ([173.37.93.153])
  by alln-iport-8.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 10 Jun 2019 21:21:27 +0000
Received: from 240m5ahost.cisco.com (240m5ahost.cisco.com [10.193.164.13])
        (authenticated bits=0)
        by rcdn-core-2.cisco.com (8.15.2/8.15.2) with ESMTPSA id x5ALLMW1017345
        (version=TLSv1.2 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO);
        Mon, 10 Jun 2019 21:21:27 GMT
From:   Govindarajulu Varadarajan <gvaradar@cisco.com>
To:     benve@cisco.com, davem@davemloft.net, netdev@vger.kernel.org,
        govind.varadar@gmail.com
Cc:     Govindarajulu Varadarajan <gvaradar@cisco.com>
Subject: [PATCH net] net: handle 802.1P vlan 0 packets properly
Date:   Mon, 10 Jun 2019 07:27:02 -0700
Message-Id: <20190610142702.2698-1-gvaradar@cisco.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: gvaradar@cisco.com
X-Outbound-SMTP-Client: 10.193.164.13, 240m5ahost.cisco.com
X-Outbound-Node: rcdn-core-2.cisco.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When stack receives pkt: [802.1P vlan 0][802.1AD vlan 100][IPv4],
vlan_do_receive() returns false if it does not find vlan_dev. Later
__netif_receive_skb_core() fails to find packet type handler for
skb->protocol 801.1AD and drops the packet.

801.1P header with vlan id 0 should be handled as untagged packets.
This patch fixes it by checking if vlan_id is 0 and processes next vlan
header.

Signed-off-by: Govindarajulu Varadarajan <gvaradar@cisco.com>
---
 net/8021q/vlan_core.c | 24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff --git a/net/8021q/vlan_core.c b/net/8021q/vlan_core.c
index a313165e7a67..0cde54c02c3f 100644
--- a/net/8021q/vlan_core.c
+++ b/net/8021q/vlan_core.c
@@ -9,14 +9,32 @@
 bool vlan_do_receive(struct sk_buff **skbp)
 {
 	struct sk_buff *skb = *skbp;
-	__be16 vlan_proto = skb->vlan_proto;
-	u16 vlan_id = skb_vlan_tag_get_id(skb);
+	__be16 vlan_proto;
+	u16 vlan_id;
 	struct net_device *vlan_dev;
 	struct vlan_pcpu_stats *rx_stats;
 
+again:
+	vlan_proto = skb->vlan_proto;
+	vlan_id = skb_vlan_tag_get_id(skb);
 	vlan_dev = vlan_find_dev(skb->dev, vlan_proto, vlan_id);
-	if (!vlan_dev)
+	if (!vlan_dev) {
+		/* Incase of 802.1P header with vlan id 0, continue if
+		 * vlan_dev is not found.
+		 */
+		if (unlikely(!vlan_id)) {
+			__vlan_hwaccel_clear_tag(skb);
+			if (skb->protocol == cpu_to_be16(ETH_P_8021Q) ||
+			    skb->protocol == cpu_to_be16(ETH_P_8021AD)) {
+				skb = skb_vlan_untag(skb);
+				*skbp = skb;
+				if (unlikely(!skb))
+					return false;
+				goto again;
+			}
+		}
 		return false;
+	}
 
 	skb = *skbp = skb_share_check(skb, GFP_ATOMIC);
 	if (unlikely(!skb))
-- 
2.22.0

