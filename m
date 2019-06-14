Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41CC146898
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 22:08:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726096AbfFNUID (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 16:08:03 -0400
Received: from rcdn-iport-8.cisco.com ([173.37.86.79]:24328 "EHLO
        rcdn-iport-8.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725802AbfFNUID (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 16:08:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=2407; q=dns/txt; s=iport;
  t=1560542882; x=1561752482;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=xffpghCdF5cL6T3Foi3kBh7eZx84hLsQBzIRPqcn/2o=;
  b=AlIHs+P92lHxwrc0V1GI/f24+g6HFO/UR6E8QcKiDjxKrHfEAylIvpgd
   jkrwkL5LAwn3h/1LxJpmgMmka/y+ypKIYsJMRqPJqTWeIdwEzgdoupn9g
   vz9RCt4IthPh4pk+qnMo0+3/4XfwS42SrZgAUV4z5/CtTIpiYM9eP5K4w
   E=;
X-IronPort-AV: E=Sophos;i="5.63,373,1557187200"; 
   d="scan'208";a="572840358"
Received: from rcdn-core-1.cisco.com ([173.37.93.152])
  by rcdn-iport-8.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 14 Jun 2019 20:08:02 +0000
Received: from 240m5ahost.cisco.com (240m5ahost.cisco.com [10.193.164.13])
        (authenticated bits=0)
        by rcdn-core-1.cisco.com (8.15.2/8.15.2) with ESMTPSA id x5EK7uav025362
        (version=TLSv1.2 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO);
        Fri, 14 Jun 2019 20:08:02 GMT
From:   Govindarajulu Varadarajan <gvaradar@cisco.com>
To:     benve@cisco.com, davem@davemloft.net, netdev@vger.kernel.org,
        govind.varadar@gmail.com
Cc:     ssuryaextr@gmail.com, toshiaki.makita1@gmail.com,
        Govindarajulu Varadarajan <gvaradar@cisco.com>
Subject: [PATCH net v2] net: handle 802.1P vlan 0 packets properly
Date:   Fri, 14 Jun 2019 06:13:54 -0700
Message-Id: <20190614131354.8287-1-gvaradar@cisco.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: gvaradar@cisco.com
X-Outbound-SMTP-Client: 10.193.164.13, 240m5ahost.cisco.com
X-Outbound-Node: rcdn-core-1.cisco.com
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
v2:	Move the check out of vlan_do_receive() to
	__netif_receive_skb_core(). This way, we do not change the
	behaviour when rx_handler is registered. i.e do not strip off
	802.1P header when bridge (or rx_handler) is registered.

Previous discussions:
http://patchwork.ozlabs.org/patch/1113413/
http://patchwork.ozlabs.org/patch/1113347/

 net/core/dev.c | 30 +++++++++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index eb7fb6daa1ef..d6edd218babd 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4923,8 +4923,36 @@ static int __netif_receive_skb_core(struct sk_buff *skb, bool pfmemalloc,
 	}
 
 	if (unlikely(skb_vlan_tag_present(skb))) {
-		if (skb_vlan_tag_get_id(skb))
+check_vlan_id:
+		if (skb_vlan_tag_get_id(skb)) {
+			/* Vlan id is non 0 and vlan_do_receive() above couldn't
+			 * find vlan device.
+			 */
 			skb->pkt_type = PACKET_OTHERHOST;
+		} else if (skb->protocol == cpu_to_be16(ETH_P_8021Q) ||
+			   skb->protocol == cpu_to_be16(ETH_P_8021AD)) {
+			/* Outer header is 802.1P with vlan 0, inner header is
+			 * 802.1Q or 802.1AD and vlan_do_receive() above could
+			 * not find vlan dev for vlan id 0.
+			 */
+			__vlan_hwaccel_clear_tag(skb);
+			skb = skb_vlan_untag(skb);
+			if (unlikely(!skb))
+				goto out;
+			if (vlan_do_receive(&skb))
+				/* After stripping off 802.1P header with vlan 0
+				 * vlan dev is found for inner header.
+				 */
+				goto another_round;
+			else if (unlikely(!skb))
+				goto out;
+			else
+				/* We have stripped outer 802.1P vlan 0 header.
+				 * But could not find vlan dev.
+				 * check again for vlan id to set OTHERHOST.
+				 */
+				goto check_vlan_id;
+		}
 		/* Note: we might in the future use prio bits
 		 * and set skb->priority like in vlan_do_receive()
 		 * For the time being, just ignore Priority Code Point
-- 
2.22.0

