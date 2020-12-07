Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A5E52D0DCE
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 11:10:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726379AbgLGKKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 05:10:22 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:54953 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725852AbgLGKKW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 05:10:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607335736;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=407nREWadhGUGGch/H/lIX+363IUVYp0pItC9LeiBg8=;
        b=UbiDIvsXkcNratWTbdlvIXYNJuDOze40eA/U/YOJBOIPsBGttBHV33WfBLvlF21vSLr3NJ
        jM0+UxpnHjnb7R24C69XBCLl7cbswv6rwiQXX3u974PZHFIFiPnyU5P3Fe2rpSrvh7STcC
        syXgL1MB430/tNg8RP98ik/usvwzH8s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-248-165CpBxrMAWqvrNPysed5w-1; Mon, 07 Dec 2020 05:08:51 -0500
X-MC-Unique: 165CpBxrMAWqvrNPysed5w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3866B190B2DD;
        Mon,  7 Dec 2020 10:08:42 +0000 (UTC)
Received: from wsfd-netdev64.ntdv.lab.eng.bos.redhat.com (wsfd-netdev64.ntdv.lab.eng.bos.redhat.com [10.19.188.127])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4D94F5D9DE;
        Mon,  7 Dec 2020 10:08:41 +0000 (UTC)
From:   Eelco Chaudron <echaudro@redhat.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, dev@openvswitch.org, kuba@kernel.org,
        pshelar@ovn.org, bindiyakurle@gmail.com, mcroce@linux.microsoft.com
Subject: [PATCH net v2] net: openvswitch: fix TTL decrement exception action execution
Date:   Mon,  7 Dec 2020 05:08:39 -0500
Message-Id:  <160733569860.3007.12938188180387116741.stgit@wsfd-netdev64.ntdv.lab.eng.bos.redhat.com>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, the exception actions are not processed correctly as the wrong
dataset is passed. This change fixes this, including the misleading
comment.

In addition, a check was added to make sure we work on an IPv4 packet,
and not just assume if it's not IPv6 it's IPv4.

This was all tested using OVS with patch,
https://patchwork.ozlabs.org/project/openvswitch/list/?series=21639,
applied and sending packets with a TTL of 1 (and 0), both with IPv4
and IPv6.

Fixes: 69929d4c49e1 ("net: openvswitch: fix TTL decrement action netlink message format")
Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
---
v2: - Undid unnessesary paramerter removal from dec_ttl_exception_handler()
    - Updated commit message to include testing information.

 net/openvswitch/actions.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
index 5829a020b81c..ace69777cb29 100644
--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -956,16 +956,13 @@ static int dec_ttl_exception_handler(struct datapath *dp, struct sk_buff *skb,
 				     struct sw_flow_key *key,
 				     const struct nlattr *attr, bool last)
 {
-	/* The first action is always 'OVS_DEC_TTL_ATTR_ARG'. */
-	struct nlattr *dec_ttl_arg = nla_data(attr);
+	/* The first attribute is always 'OVS_DEC_TTL_ATTR_ACTION'. */
+	struct nlattr *actions = nla_data(attr);
 
-	if (nla_len(dec_ttl_arg)) {
-		struct nlattr *actions = nla_data(dec_ttl_arg);
+	if (nla_len(actions))
+		return clone_execute(dp, skb, key, 0, nla_data(actions),
+				     nla_len(actions), last, false);
 
-		if (actions)
-			return clone_execute(dp, skb, key, 0, nla_data(actions),
-					     nla_len(actions), last, false);
-	}
 	consume_skb(skb);
 	return 0;
 }
@@ -1209,7 +1206,7 @@ static int execute_dec_ttl(struct sk_buff *skb, struct sw_flow_key *key)
 			return -EHOSTUNREACH;
 
 		key->ip.ttl = --nh->hop_limit;
-	} else {
+	} else if (skb->protocol == htons(ETH_P_IP)) {
 		struct iphdr *nh;
 		u8 old_ttl;
 

