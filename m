Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 410634DC5A7
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 13:17:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233498AbiCQMS5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 08:18:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232341AbiCQMS4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 08:18:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 561FA1EA5FD
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 05:17:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647519459;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ja78C+l8CFVXkuPOyePhWOKAv7INGJfRDKrX1cATsTU=;
        b=a13J+ltr4iBmxjSTa4mNdRfAsamb/IuTNcsYSu+7Nc8VplKJGHN7y69ZCwlIp8X0Be5gia
        YGEwMTGjpesiLI7unxWjA+mSTKZwhIncN9Pq0fEE/Ru3/Eb48+x+4gDwYCis2ZepzqOOJh
        xS/A5DWSo4T+H2kO0mjEu/UHARjDE6s=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-54-0TeE1bSPNeyrJZJ3nu0gaQ-1; Thu, 17 Mar 2022 08:17:36 -0400
X-MC-Unique: 0TeE1bSPNeyrJZJ3nu0gaQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7F1B03804502;
        Thu, 17 Mar 2022 12:17:35 +0000 (UTC)
Received: from RHTPC1VM0NT.redhat.com (unknown [10.22.17.112])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1C5D0C090D9;
        Thu, 17 Mar 2022 12:17:35 +0000 (UTC)
From:   Aaron Conole <aconole@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dev@openvswitch.org, pshelar@ovn.org,
        Ilya Maximets <i.maximets@ovn.org>,
        Dumitru Ceara <dceara@redhat.com>,
        Numan Siddique <nusiddiq@redhat.com>
Subject: [PATCH net] openvswitch: always update flow key after NAT
Date:   Thu, 17 Mar 2022 08:17:29 -0400
Message-Id: <20220317121729.2810292-1-aconole@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
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
commit 5d50aa83e2c8 ("openvswitch: support asymmetric conntrack").

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
 net/openvswitch/conntrack.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index c07afff57dd3..461dbb3b7090 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -104,6 +104,10 @@ static bool labels_nonzero(const struct ovs_key_ct_labels *labels);
 
 static void __ovs_ct_free_action(struct ovs_conntrack_info *ct_info);
 
+static void ovs_nat_update_key(struct sw_flow_key *key,
+			       const struct sk_buff *skb,
+			       enum nf_nat_manip_type maniptype);
+
 static u16 key_to_nfproto(const struct sw_flow_key *key)
 {
 	switch (ntohs(key->eth.type)) {
@@ -741,7 +745,7 @@ static bool skb_nfct_cached(struct net *net,
 static int ovs_ct_nat_execute(struct sk_buff *skb, struct nf_conn *ct,
 			      enum ip_conntrack_info ctinfo,
 			      const struct nf_nat_range2 *range,
-			      enum nf_nat_manip_type maniptype)
+			      enum nf_nat_manip_type maniptype, struct sw_flow_key *key)
 {
 	int hooknum, nh_off, err = NF_ACCEPT;
 
@@ -813,6 +817,10 @@ static int ovs_ct_nat_execute(struct sk_buff *skb, struct nf_conn *ct,
 push:
 	skb_push_rcsum(skb, nh_off);
 
+	/* Update the flow key if NAT successful. */
+	if (err == NF_ACCEPT)
+		ovs_nat_update_key(key, skb, maniptype);
+
 	return err;
 }
 
@@ -906,7 +914,7 @@ static int ovs_ct_nat(struct net *net, struct sw_flow_key *key,
 	} else {
 		return NF_ACCEPT; /* Connection is not NATed. */
 	}
-	err = ovs_ct_nat_execute(skb, ct, ctinfo, &info->range, maniptype);
+	err = ovs_ct_nat_execute(skb, ct, ctinfo, &info->range, maniptype, key);
 
 	if (err == NF_ACCEPT && ct->status & IPS_DST_NAT) {
 		if (ct->status & IPS_SRC_NAT) {
@@ -916,17 +924,13 @@ static int ovs_ct_nat(struct net *net, struct sw_flow_key *key,
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

