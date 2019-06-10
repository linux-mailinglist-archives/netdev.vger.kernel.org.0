Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF47D3C0ED
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 03:32:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390451AbfFKBct (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 21:32:49 -0400
Received: from rcdn-iport-3.cisco.com ([173.37.86.74]:31931 "EHLO
        rcdn-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390158AbfFKBct (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 21:32:49 -0400
X-Greylist: delayed 424 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Jun 2019 21:32:49 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=1724; q=dns/txt; s=iport;
  t=1560216769; x=1561426369;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=v99KLrLXi5Np9xBCfQxcfgOGI+oUw5rkya1Dz8ujbDs=;
  b=QjAKvgZN3wRGTCh47kJXwava3YM+JgjXkLs9lHxNTTe1cVAVxb1/xOSf
   3br7kH9uvHX70NarfoohLvLgwJgYQWMfE/nn5R8o6pghWBP2kDD6vLSNO
   Elk7vVl8M68KB8hsqw6hLhdFKcKoLSSjZzBydOsp9abtHay7TUxZbvguR
   Q=;
X-IronPort-AV: E=Sophos;i="5.63,577,1557187200"; 
   d="scan'208";a="560670717"
Received: from rcdn-core-7.cisco.com ([173.37.93.143])
  by rcdn-iport-3.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 11 Jun 2019 01:25:44 +0000
Received: from 240m5ahost.cisco.com (240m5ahost.cisco.com [10.193.164.13])
        (authenticated bits=0)
        by rcdn-core-7.cisco.com (8.15.2/8.15.2) with ESMTPSA id x5B1PdqH021279
        (version=TLSv1.2 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO);
        Tue, 11 Jun 2019 01:25:44 GMT
From:   Govindarajulu Varadarajan <gvaradar@cisco.com>
To:     benve@cisco.com, davem@davemloft.net, netdev@vger.kernel.org,
        govind.varadar@gmail.com
Cc:     ssuryaextr@gmail.com,
        Govindarajulu Varadarajan <gvaradar@cisco.com>
Subject: [PATCH RESEND net] net: handle 802.1P vlan 0 packets properly
Date:   Mon, 10 Jun 2019 11:31:22 -0700
Message-Id: <20190610183122.4521-1-gvaradar@cisco.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: gvaradar@cisco.com
X-Outbound-SMTP-Client: 10.193.164.13, 240m5ahost.cisco.com
X-Outbound-Node: rcdn-core-7.cisco.com
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

