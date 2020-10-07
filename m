Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 173D2286290
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 17:48:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728797AbgJGPsg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 11:48:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:23509 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728306AbgJGPse (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 11:48:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602085713;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=RUk8uE5L81CVhH/FPCfUR7Mp8obFZgRtra7vzsmq1Uc=;
        b=Qm3n0x9/Rt8BsB+yxOmj53P4Rkf1nPQweqTTOY26lBRVSP9VetTzrQokJ/U4CIX2s+vLss
        NvzEyyMuSgEstJ1ebA1Q4SSDDcwkWa/ehmW5N92B5nrOuNGXWmUcm869hCXNWVkPK+p5QP
        EtoMdLucmVEZL36TWJaLO4lHtogzFfc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-342-e_LO1dkLMl-i2egBIH6Sqg-1; Wed, 07 Oct 2020 11:48:28 -0400
X-MC-Unique: e_LO1dkLMl-i2egBIH6Sqg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ED9DA81EE6D;
        Wed,  7 Oct 2020 15:48:26 +0000 (UTC)
Received: from dceara.remote.csb (ovpn-113-93.ams2.redhat.com [10.36.113.93])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 50DA678437;
        Wed,  7 Oct 2020 15:48:25 +0000 (UTC)
From:   Dumitru Ceara <dceara@redhat.com>
To:     netdev@vger.kernel.org, dev@openvswitch.org
Cc:     pshelar@ovn.org, aconole@redhat.com, fw@strlen.de
Subject: [PATCH net] openvswitch: handle DNAT tuple collision
Date:   Wed,  7 Oct 2020 17:48:03 +0200
Message-Id: <1602085683-29043-1-git-send-email-dceara@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With multiple DNAT rules it's possible that after destination
translation the resulting tuples collide.

For example, two openvswitch flows:
nw_dst=10.0.0.10,tp_dst=10, actions=ct(commit,table=2,nat(dst=20.0.0.1:20))
nw_dst=10.0.0.20,tp_dst=10, actions=ct(commit,table=2,nat(dst=20.0.0.1:20))

Assuming two TCP clients initiating the following connections:
10.0.0.10:5000->10.0.0.10:10
10.0.0.10:5000->10.0.0.20:10

Both tuples would translate to 10.0.0.10:5000->20.0.0.1:20 causing
nf_conntrack_confirm() to fail because of tuple collision.

Netfilter handles this case by allocating a null binding for SNAT at
egress by default.  Perform the same operation in openvswitch for DNAT
if no explicit SNAT is requested by the user and allocate a null binding
for SNAT for packets in the "original" direction.

Reported-at: https://bugzilla.redhat.com/1877128
Suggested-by: Florian Westphal <fw@strlen.de>
Fixes: 05752523e565 ("openvswitch: Interface with NAT.")
Signed-off-by: Dumitru Ceara <dceara@redhat.com>
---
 net/openvswitch/conntrack.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index a3f1204..12d42ab 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -905,15 +905,19 @@ static int ovs_ct_nat(struct net *net, struct sw_flow_key *key,
 	}
 	err = ovs_ct_nat_execute(skb, ct, ctinfo, &info->range, maniptype);
 
-	if (err == NF_ACCEPT &&
-	    ct->status & IPS_SRC_NAT && ct->status & IPS_DST_NAT) {
-		if (maniptype == NF_NAT_MANIP_SRC)
-			maniptype = NF_NAT_MANIP_DST;
-		else
-			maniptype = NF_NAT_MANIP_SRC;
-
-		err = ovs_ct_nat_execute(skb, ct, ctinfo, &info->range,
-					 maniptype);
+	if (err == NF_ACCEPT && ct->status & IPS_DST_NAT) {
+		if (ct->status & IPS_SRC_NAT) {
+			if (maniptype == NF_NAT_MANIP_SRC)
+				maniptype = NF_NAT_MANIP_DST;
+			else
+				maniptype = NF_NAT_MANIP_SRC;
+
+			err = ovs_ct_nat_execute(skb, ct, ctinfo, &info->range,
+						 maniptype);
+		} else if (CTINFO2DIR(ctinfo) == IP_CT_DIR_ORIGINAL) {
+			err = ovs_ct_nat_execute(skb, ct, ctinfo, NULL,
+						 NF_NAT_MANIP_SRC);
+		}
 	}
 
 	/* Mark NAT done if successful and update the flow key. */
-- 
1.8.3.1

