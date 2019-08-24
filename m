Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D7339BEEA
	for <lists+netdev@lfdr.de>; Sat, 24 Aug 2019 18:59:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726842AbfHXQ7A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Aug 2019 12:59:00 -0400
Received: from relay10.mail.gandi.net ([217.70.178.230]:49403 "EHLO
        relay10.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726769AbfHXQ7A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Aug 2019 12:59:00 -0400
Received: from ubuntu-ct.localdomain (c-73-170-242-251.hsd1.ca.comcast.net [73.170.242.251])
        (Authenticated sender: jpettit@ovn.org)
        by relay10.mail.gandi.net (Postfix) with ESMTPSA id 4C592240003;
        Sat, 24 Aug 2019 16:58:57 +0000 (UTC)
From:   Justin Pettit <jpettit@ovn.org>
To:     netdev@vger.kernel.org, Pravin Shelar <pshelar@ovn.org>
Cc:     Joe Stringer <joe@wand.net.nz>
Subject: [PATCH net 2/2] openvswitch: Clear the L4 portion of the key for "later" fragments.
Date:   Sat, 24 Aug 2019 09:58:46 -0700
Message-Id: <20190824165846.79627-2-jpettit@ovn.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190824165846.79627-1-jpettit@ovn.org>
References: <20190824165846.79627-1-jpettit@ovn.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Only the first fragment in a datagram contains the L4 headers.  When the
Open vSwitch module parses a packet, it always sets the IP protocol
field in the key, but can only set the L4 fields on the first fragment.
The original behavior would not clear the L4 portion of the key, so
garbage values would be sent in the key for "later" fragments.  This
patch clears the L4 fields in that circumstance to prevent sending those
garbage values as part of the upcall.

Signed-off-by: Justin Pettit <jpettit@ovn.org>
---
 net/openvswitch/flow.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/openvswitch/flow.c b/net/openvswitch/flow.c
index bc89e16e0505..0fb2cec08523 100644
--- a/net/openvswitch/flow.c
+++ b/net/openvswitch/flow.c
@@ -623,6 +623,7 @@ static int key_extract(struct sk_buff *skb, struct sw_flow_key *key)
 		offset = nh->frag_off & htons(IP_OFFSET);
 		if (offset) {
 			key->ip.frag = OVS_FRAG_TYPE_LATER;
+			memset(&key->tp, 0, sizeof(key->tp));
 			return 0;
 		}
 		if (nh->frag_off & htons(IP_MF) ||
@@ -740,8 +741,10 @@ static int key_extract(struct sk_buff *skb, struct sw_flow_key *key)
 			return error;
 		}
 
-		if (key->ip.frag == OVS_FRAG_TYPE_LATER)
+		if (key->ip.frag == OVS_FRAG_TYPE_LATER) {
+			memset(&key->tp, 0, sizeof(key->tp));
 			return 0;
+		}
 		if (skb_shinfo(skb)->gso_type & SKB_GSO_UDP)
 			key->ip.frag = OVS_FRAG_TYPE_FIRST;
 
-- 
2.17.1

