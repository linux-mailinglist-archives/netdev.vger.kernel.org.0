Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D35879BEE9
	for <lists+netdev@lfdr.de>; Sat, 24 Aug 2019 18:59:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbfHXQ66 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Aug 2019 12:58:58 -0400
Received: from relay10.mail.gandi.net ([217.70.178.230]:44147 "EHLO
        relay10.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726390AbfHXQ66 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Aug 2019 12:58:58 -0400
Received: from ubuntu-ct.localdomain (c-73-170-242-251.hsd1.ca.comcast.net [73.170.242.251])
        (Authenticated sender: jpettit@ovn.org)
        by relay10.mail.gandi.net (Postfix) with ESMTPSA id 96FBB240002;
        Sat, 24 Aug 2019 16:58:54 +0000 (UTC)
From:   Justin Pettit <jpettit@ovn.org>
To:     netdev@vger.kernel.org, Pravin Shelar <pshelar@ovn.org>
Cc:     Joe Stringer <joe@wand.net.nz>
Subject: [PATCH net 1/2] openvswitch: Properly set L4 keys on "later" IP fragments.
Date:   Sat, 24 Aug 2019 09:58:45 -0700
Message-Id: <20190824165846.79627-1-jpettit@ovn.org>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When IP fragments are reassembled before being sent to conntrack, the
key from the last fragment is used.  Unless there are reordering
issues, the last fragment received will not contain the L4 ports, so the
key for the reassembled datagram won't contain them.  This patch updates
the key once we have a reassembled datagram.

Signed-off-by: Justin Pettit <jpettit@ovn.org>
---
 net/openvswitch/conntrack.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index 848c6eb55064..f40ad2a42086 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -524,6 +524,10 @@ static int handle_fragments(struct net *net, struct sw_flow_key *key,
 		return -EPFNOSUPPORT;
 	}
 
+	/* The key extracted from the fragment that completed this datagram
+	 * likely didn't have an L4 header, so regenerate it. */
+	ovs_flow_key_update(skb, key);
+
 	key->ip.frag = OVS_FRAG_TYPE_NONE;
 	skb_clear_hash(skb);
 	skb->ignore_df = 1;
-- 
2.17.1

