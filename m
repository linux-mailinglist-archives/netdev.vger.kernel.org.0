Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 028B04DD9E8
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 13:43:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236175AbiCRMoo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 08:44:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234989AbiCRMom (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 08:44:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 98A7781669
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 05:43:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647607402;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=TK7mxEKgRZNWLvZlXF9vfxNBabyBYOfERDIL1PEFFRk=;
        b=HWP0tCQRD0OamqFeG1YiwUmrKejIEUklyhWsNCTgfMQDLxwqvHW424DbPfaVHjZmrGOXPQ
        2Bk4+MTKnNXu5OOumc7DthDBxYPVIA5kZjRM+8zOXQI1L0+ycNDpH1frpp2fIgqIwoArlJ
        DQUjCKWEhmTOdLRb/8Ofts5yV0d4khM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-533-v4he9Kh0Omat7rcir5jpwg-1; Fri, 18 Mar 2022 08:43:21 -0400
X-MC-Unique: v4he9Kh0Omat7rcir5jpwg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AB9AF85A5BE;
        Fri, 18 Mar 2022 12:43:20 +0000 (UTC)
Received: from RHTPC1VM0NT.redhat.com (unknown [10.22.17.112])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4247140D1CB;
        Fri, 18 Mar 2022 12:43:20 +0000 (UTC)
From:   Aaron Conole <aconole@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dev@openvswitch.org, pshelar@ovn.org,
        Ilya Maximets <i.maximets@ovn.org>,
        Dumitru Ceara <dceara@redhat.com>,
        Numan Siddique <nusiddiq@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>
Subject: [PATCH net v2] openvswitch: always update flow key after nat
Date:   Fri, 18 Mar 2022 08:43:19 -0400
Message-Id: <20220318124319.3056455-1-aconole@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

During NAT, a tuple collision may occur.  When this happens, openvswitch
will make a second pass through NAT which will perform additional packet
modification.  This will update the skb data, but not the flow key that
OVS uses.  This means that future flow lookups, and packet matches will
have incorrect data.  This has been supported since
5d50aa83e2c8 ("openvswitch: support asymmetric conntrack").

That commit failed to properly update the sw_flow_key attributes, since
it only called the ovs_ct_nat_update_key once, rather than each time
ovs_ct_nat_execute was called.  As these two operations are linked, the
ovs_ct_nat_execute() function should always make sure that the
sw_flow_key is updated after a successful call through NAT infrastructure.

Fixes: 5d50aa83e2c8 ("openvswitch: support asymmetric conntrack")
Cc: Dumitru Ceara <dceara@redhat.com>
Cc: Numan Siddique <nusiddiq@redhat.com>
Signed-off-by: Aaron Conole <aconole@redhat.com>
---
v1->v2: removed forward decl., moved the ovs_nat_update_key function
        made sure it compiles with NF_NAT disabled and enabled

 net/openvswitch/conntrack.c | 118 ++++++++++++++++++------------------
 1 file changed, 59 insertions(+), 59 deletions(-)

diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index c07afff57dd3..4a947c13c813 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -734,6 +734,57 @@ static bool skb_nfct_cached(struct net *net,
 }
 
 #if IS_ENABLED(CONFIG_NF_NAT)
+static void ovs_nat_update_key(struct sw_flow_key *key,
+			       const struct sk_buff *skb,
+			       enum nf_nat_manip_type maniptype)
+{
+	if (maniptype == NF_NAT_MANIP_SRC) {
+		__be16 src;
+
+		key->ct_state |= OVS_CS_F_SRC_NAT;
+		if (key->eth.type == htons(ETH_P_IP))
+			key->ipv4.addr.src = ip_hdr(skb)->saddr;
+		else if (key->eth.type == htons(ETH_P_IPV6))
+			memcpy(&key->ipv6.addr.src, &ipv6_hdr(skb)->saddr,
+			       sizeof(key->ipv6.addr.src));
+		else
+			return;
+
+		if (key->ip.proto == IPPROTO_UDP)
+			src = udp_hdr(skb)->source;
+		else if (key->ip.proto == IPPROTO_TCP)
+			src = tcp_hdr(skb)->source;
+		else if (key->ip.proto == IPPROTO_SCTP)
+			src = sctp_hdr(skb)->source;
+		else
+			return;
+
+		key->tp.src = src;
+	} else {
+		__be16 dst;
+
+		key->ct_state |= OVS_CS_F_DST_NAT;
+		if (key->eth.type == htons(ETH_P_IP))
+			key->ipv4.addr.dst = ip_hdr(skb)->daddr;
+		else if (key->eth.type == htons(ETH_P_IPV6))
+			memcpy(&key->ipv6.addr.dst, &ipv6_hdr(skb)->daddr,
+			       sizeof(key->ipv6.addr.dst));
+		else
+			return;
+
+		if (key->ip.proto == IPPROTO_UDP)
+			dst = udp_hdr(skb)->dest;
+		else if (key->ip.proto == IPPROTO_TCP)
+			dst = tcp_hdr(skb)->dest;
+		else if (key->ip.proto == IPPROTO_SCTP)
+			dst = sctp_hdr(skb)->dest;
+		else
+			return;
+
+		key->tp.dst = dst;
+	}
+}
+
 /* Modelled after nf_nat_ipv[46]_fn().
  * range is only used for new, uninitialized NAT state.
  * Returns either NF_ACCEPT or NF_DROP.
@@ -741,7 +792,7 @@ static bool skb_nfct_cached(struct net *net,
 static int ovs_ct_nat_execute(struct sk_buff *skb, struct nf_conn *ct,
 			      enum ip_conntrack_info ctinfo,
 			      const struct nf_nat_range2 *range,
-			      enum nf_nat_manip_type maniptype)
+			      enum nf_nat_manip_type maniptype, struct sw_flow_key *key)
 {
 	int hooknum, nh_off, err = NF_ACCEPT;
 
@@ -813,58 +864,11 @@ static int ovs_ct_nat_execute(struct sk_buff *skb, struct nf_conn *ct,
 push:
 	skb_push_rcsum(skb, nh_off);
 
-	return err;
-}
-
-static void ovs_nat_update_key(struct sw_flow_key *key,
-			       const struct sk_buff *skb,
-			       enum nf_nat_manip_type maniptype)
-{
-	if (maniptype == NF_NAT_MANIP_SRC) {
-		__be16 src;
-
-		key->ct_state |= OVS_CS_F_SRC_NAT;
-		if (key->eth.type == htons(ETH_P_IP))
-			key->ipv4.addr.src = ip_hdr(skb)->saddr;
-		else if (key->eth.type == htons(ETH_P_IPV6))
-			memcpy(&key->ipv6.addr.src, &ipv6_hdr(skb)->saddr,
-			       sizeof(key->ipv6.addr.src));
-		else
-			return;
-
-		if (key->ip.proto == IPPROTO_UDP)
-			src = udp_hdr(skb)->source;
-		else if (key->ip.proto == IPPROTO_TCP)
-			src = tcp_hdr(skb)->source;
-		else if (key->ip.proto == IPPROTO_SCTP)
-			src = sctp_hdr(skb)->source;
-		else
-			return;
-
-		key->tp.src = src;
-	} else {
-		__be16 dst;
-
-		key->ct_state |= OVS_CS_F_DST_NAT;
-		if (key->eth.type == htons(ETH_P_IP))
-			key->ipv4.addr.dst = ip_hdr(skb)->daddr;
-		else if (key->eth.type == htons(ETH_P_IPV6))
-			memcpy(&key->ipv6.addr.dst, &ipv6_hdr(skb)->daddr,
-			       sizeof(key->ipv6.addr.dst));
-		else
-			return;
-
-		if (key->ip.proto == IPPROTO_UDP)
-			dst = udp_hdr(skb)->dest;
-		else if (key->ip.proto == IPPROTO_TCP)
-			dst = tcp_hdr(skb)->dest;
-		else if (key->ip.proto == IPPROTO_SCTP)
-			dst = sctp_hdr(skb)->dest;
-		else
-			return;
+	/* Update the flow key if NAT successful. */
+	if (err == NF_ACCEPT)
+		ovs_nat_update_key(key, skb, maniptype);
 
-		key->tp.dst = dst;
-	}
+	return err;
 }
 
 /* Returns NF_DROP if the packet should be dropped, NF_ACCEPT otherwise. */
@@ -906,7 +910,7 @@ static int ovs_ct_nat(struct net *net, struct sw_flow_key *key,
 	} else {
 		return NF_ACCEPT; /* Connection is not NATed. */
 	}
-	err = ovs_ct_nat_execute(skb, ct, ctinfo, &info->range, maniptype);
+	err = ovs_ct_nat_execute(skb, ct, ctinfo, &info->range, maniptype, key);
 
 	if (err == NF_ACCEPT && ct->status & IPS_DST_NAT) {
 		if (ct->status & IPS_SRC_NAT) {
@@ -916,17 +920,13 @@ static int ovs_ct_nat(struct net *net, struct sw_flow_key *key,
 				maniptype = NF_NAT_MANIP_SRC;
 
 			err = ovs_ct_nat_execute(skb, ct, ctinfo, &info->range,
-						 maniptype);
+						 maniptype, key);
 		} else if (CTINFO2DIR(ctinfo) == IP_CT_DIR_ORIGINAL) {
 			err = ovs_ct_nat_execute(skb, ct, ctinfo, NULL,
-						 NF_NAT_MANIP_SRC);
+						 NF_NAT_MANIP_SRC, key);
 		}
 	}
 
-	/* Mark NAT done if successful and update the flow key. */
-	if (err == NF_ACCEPT)
-		ovs_nat_update_key(key, skb, maniptype);
-
 	return err;
 }
 #else /* !CONFIG_NF_NAT */
-- 
2.31.1

