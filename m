Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BD292848AB
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 10:35:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726433AbgJFIfG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 04:35:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52794 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725946AbgJFIfE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 04:35:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601973262;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=RS1bQCjlVM88OcptMus2+kqpEPdF91Jre0Fco1efMUw=;
        b=aqaLzvI0qtoFg7a7KN1aN4RrzSocWYRw8DK0PvSKYASY182VgkVKUpgOX1T9s+xAGKm+Gn
        1Sz423ZU8OJfzjF8QETzNOzZJldrSNzNX7E1kgvQxv5gCyogoOOtKGaNDhVHROWYT8S7Oj
        OqFuyG2dBY95LAgvdVEqXjTzd4bwfk4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-203-ocmj1lczNJSG1z8XdAPGsA-1; Tue, 06 Oct 2020 04:34:20 -0400
X-MC-Unique: ocmj1lczNJSG1z8XdAPGsA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 70D54801817;
        Tue,  6 Oct 2020 08:34:19 +0000 (UTC)
Received: from nusiddiq.home.org.com (unknown [10.67.116.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 667D378818;
        Tue,  6 Oct 2020 08:34:16 +0000 (UTC)
From:   nusiddiq@redhat.com
To:     dev@openvswitch.org, netdev@vger.kernel.org
Cc:     davem@davemloft.net, Aaron Conole <aconole@redhat.com>,
        Numan Siddique <nusiddiq@redhat.com>,
        Pravin B Shelar <pshelar@ovn.org>
Subject: [PATCH net-next] net: openvswitch: Add support to lookup invalid packet in ct action.
Date:   Tue,  6 Oct 2020 14:03:55 +0530
Message-Id: <20201006083355.121018-1-nusiddiq@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Numan Siddique <nusiddiq@redhat.com>

For a tcp packet which is part of an existing committed connection,
nf_conntrack_in() will return err and set skb->_nfct to NULL if it is
out of tcp window. ct action for this packet will set the ct_state
to +inv which is as expected.

But a controller cannot add an OVS flow as

table=21,priority=100,ct_state=+inv, actions=drop

to drop such packets. That is because when ct action is executed on other
packets which are not part of existing committed connections, ct_state
can be set to invalid. Few such cases are:
   - ICMP reply packets.
   - TCP SYN/ACK packets during connection establishment.
   - SCTP INIT ACK, COOKIE ACK, DATA and DATA ACK packets.

To distinguish between an invalid packet part of committed connection
and others, this patch introduces as a new ct attribute
OVS_CT_ATTR_LOOKUP_INV. If this is set in the ct action (without commit),
it tries to find the ct entry and if present, sets the ct_state to
+inv,+trk and also sets the mark and labels associated with the
connection.

With this,  a controller can add flows like

....
....
table=20,ip, action=ct(table=21, lookup_invalid)
table=21,priority=100,ct_state=+inv+trk,ct_label=0x2/0x2 actions=drop
table=21,ip, actions=resubmit(,22)
....
....

CC: Pravin B Shelar <pshelar@ovn.org>
Signed-off-by: Numan Siddique <nusiddiq@redhat.com>
---

RFC -> PATCH
------
  * Changed the patch from RFC to a formal one. No other changes.

 include/uapi/linux/openvswitch.h |  4 +++
 net/openvswitch/conntrack.c      | 47 ++++++++++++++++++++++++--------
 2 files changed, 40 insertions(+), 11 deletions(-)

diff --git a/include/uapi/linux/openvswitch.h b/include/uapi/linux/openvswitch.h
index 8300cc29dec8..db942986c5b7 100644
--- a/include/uapi/linux/openvswitch.h
+++ b/include/uapi/linux/openvswitch.h
@@ -768,6 +768,9 @@ struct ovs_action_hash {
  * respectively.  Remaining bits control the changes for which an event is
  * delivered on the NFNLGRP_CONNTRACK_UPDATE group.
  * @OVS_CT_ATTR_TIMEOUT: Variable length string defining conntrack timeout.
+ * @OVS_CT_ATTR_LOOKUP_INV: If present, looks up and sets the state, mark and
+ * labels for an invalid packet (eg. out of tcp window) if it is part of
+ * committed connection.
  */
 enum ovs_ct_attr {
 	OVS_CT_ATTR_UNSPEC,
@@ -782,6 +785,7 @@ enum ovs_ct_attr {
 	OVS_CT_ATTR_EVENTMASK,  /* u32 mask of IPCT_* events. */
 	OVS_CT_ATTR_TIMEOUT,	/* Associate timeout with this connection for
 				 * fine-grain timeout tuning. */
+	OVS_CT_ATTR_LOOKUP_INV, /* No argument. */
 	__OVS_CT_ATTR_MAX
 };
 
diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index e6fe26a9c892..a6f96d9b4452 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -62,6 +62,7 @@ struct ovs_conntrack_info {
 	u8 nat : 3;                 /* enum ovs_ct_nat */
 	u8 force : 1;
 	u8 have_eventmask : 1;
+	u8 lookup_invalid : 1;
 	u16 family;
 	u32 eventmask;              /* Mask of 1 << IPCT_*. */
 	struct md_mark mark;
@@ -601,12 +602,13 @@ ovs_ct_get_info(const struct nf_conntrack_tuple_hash *h)
  *
  * Must be called with rcu_read_lock.
  *
- * On success, populates skb->_nfct and returns the connection.  Returns NULL
- * if there is no existing entry.
+ * On success, populates skb->_nfct if 'skb_set_ct' is true and returns the
+ * connection.  Returns NULL if there is no existing entry.
  */
 static struct nf_conn *
 ovs_ct_find_existing(struct net *net, const struct nf_conntrack_zone *zone,
-		     u8 l3num, struct sk_buff *skb, bool natted)
+		     u8 l3num, struct sk_buff *skb, bool natted,
+		     bool skb_set_ct)
 {
 	struct nf_conntrack_tuple tuple;
 	struct nf_conntrack_tuple_hash *h;
@@ -636,14 +638,17 @@ ovs_ct_find_existing(struct net *net, const struct nf_conntrack_zone *zone,
 
 	ct = nf_ct_tuplehash_to_ctrack(h);
 
-	/* Inverted packet tuple matches the reverse direction conntrack tuple,
-	 * select the other tuplehash to get the right 'ctinfo' bits for this
-	 * packet.
-	 */
-	if (natted)
-		h = &ct->tuplehash[!h->tuple.dst.dir];
+	if (skb_set_ct) {
+		/* Inverted packet tuple matches the reverse direction
+		 * conntrack tuple, select the other tuplehash to get the
+		 * right 'ctinfo' bits for this packet.
+		 */
+		if (natted)
+			h = &ct->tuplehash[!h->tuple.dst.dir];
+
+		nf_ct_set(skb, ct, ovs_ct_get_info(h));
+	}
 
-	nf_ct_set(skb, ct, ovs_ct_get_info(h));
 	return ct;
 }
 
@@ -669,7 +674,7 @@ struct nf_conn *ovs_ct_executed(struct net *net,
 	if (*ct_executed || (!key->ct_state && info->force)) {
 		ct = ovs_ct_find_existing(net, &info->zone, info->family, skb,
 					  !!(key->ct_state &
-					  OVS_CS_F_NAT_MASK));
+					  OVS_CS_F_NAT_MASK), true);
 	}
 
 	return ct;
@@ -1033,6 +1038,20 @@ static int __ovs_ct_lookup(struct net *net, struct sw_flow_key *key,
 		    ovs_ct_helper(skb, info->family) != NF_ACCEPT) {
 			return -EINVAL;
 		}
+	} else if (info->lookup_invalid) {
+		/* nf_conntrack_in() sets skb->_nfct to NULL if the packet is
+		 * invalid (eg. out of tcp window) even if it belongs to
+		 * an existing connection. Check if there is an existing entry
+		 * and if so, update the key with the mark and ct_labels.
+		 */
+		ct = ovs_ct_find_existing(net, &info->zone, info->family, skb,
+					  false, false);
+		if (ct) {
+			u8 state;
+
+			state = OVS_CS_F_TRACKED | OVS_CS_F_INVALID;
+			__ovs_ct_update_key(key, state, &info->zone, ct);
+		}
 	}
 
 	return 0;
@@ -1602,6 +1621,9 @@ static int parse_ct(const struct nlattr *attr, struct ovs_conntrack_info *info,
 			}
 			break;
 #endif
+		case OVS_CT_ATTR_LOOKUP_INV:
+			info->lookup_invalid = true;
+			break;
 
 		default:
 			OVS_NLERR(log, "Unknown conntrack attr (%d)",
@@ -1819,6 +1841,9 @@ int ovs_ct_action_to_attr(const struct ovs_conntrack_info *ct_info,
 		if (nla_put_string(skb, OVS_CT_ATTR_TIMEOUT, ct_info->timeout))
 			return -EMSGSIZE;
 	}
+	if (ct_info->lookup_invalid &&
+	    nla_put_flag(skb, OVS_CT_ATTR_LOOKUP_INV))
+		return -EMSGSIZE;
 
 #if IS_ENABLED(CONFIG_NF_NAT)
 	if (ct_info->nat && !ovs_ct_nat_to_attr(ct_info, skb))
-- 
2.26.2

