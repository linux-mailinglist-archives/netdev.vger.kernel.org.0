Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A414F2CEDED
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 13:18:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728720AbgLDMR4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 07:17:56 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:38489 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727385AbgLDMRz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 07:17:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607084189;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=dlNwPf/VFGfp5GSHWAM6v0QxL1aPvAbANlA2ZrmxfsU=;
        b=SJ/b2aF3RCfpn995IxyxpkCG1sucApr4iptsqMiJp1ev40vEZ+SBpugNKUtoYxhJ9oV3Pl
        kMVCoqToOXqW4XHm7U1Js1dx9Cpf0t2JNtPwCdr/rGGZjOX2d9NttvQNgkvtYYyRa6kV2F
        jE1tDmlCwQAJYDd6xmWQBV2M0L50Fqk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-270-a-YQkGJyOQqwg6MYXEu92g-1; Fri, 04 Dec 2020 07:16:27 -0500
X-MC-Unique: a-YQkGJyOQqwg6MYXEu92g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 41EB7858183;
        Fri,  4 Dec 2020 12:16:26 +0000 (UTC)
Received: from wsfd-netdev64.ntdv.lab.eng.bos.redhat.com (wsfd-netdev64.ntdv.lab.eng.bos.redhat.com [10.19.188.127])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8A6F560C15;
        Fri,  4 Dec 2020 12:16:25 +0000 (UTC)
From:   Eelco Chaudron <echaudro@redhat.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, dev@openvswitch.org, kuba@kernel.org,
        pshelar@ovn.org, bindiyakurle@gmail.com, mcroce@linux.microsoft.com
Subject: [PATCH net] net: openvswitch: fix TTL decrement exception action execution
Date:   Fri,  4 Dec 2020 07:16:23 -0500
Message-Id:  <160708417520.39389.4157710029285521561.stgit@wsfd-netdev64.ntdv.lab.eng.bos.redhat.com>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, the exception actions are not processed correctly as the wrong
dataset is passed. This change fixes this, including the misleading
comment.

In addition, a check was added to make sure we work on an IPv4 packet,
and not just assume if it's not IPv6 it's IPv4.

Small cleanup which removes an unsessesaty parameter from the
dec_ttl_exception_handler() function.

Fixes: 69929d4c49e1 ("net: openvswitch: fix TTL decrement action netlink message format")
Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
---
 net/openvswitch/actions.c |   25 ++++++++++---------------
 1 file changed, 10 insertions(+), 15 deletions(-)

diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
index 5829a020b81c..616fa43ff6df 100644
--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -954,18 +954,15 @@ static int output_userspace(struct datapath *dp, struct sk_buff *skb,
 
 static int dec_ttl_exception_handler(struct datapath *dp, struct sk_buff *skb,
 				     struct sw_flow_key *key,
-				     const struct nlattr *attr, bool last)
+				     const struct nlattr *attr)
 {
-	/* The first action is always 'OVS_DEC_TTL_ATTR_ARG'. */
-	struct nlattr *dec_ttl_arg = nla_data(attr);
+	/* The first attribute is always 'OVS_DEC_TTL_ATTR_ACTION'. */
+	struct nlattr *actions = nla_data(attr);
 
-	if (nla_len(dec_ttl_arg)) {
-		struct nlattr *actions = nla_data(dec_ttl_arg);
+	if (nla_len(actions))
+		return clone_execute(dp, skb, key, 0, nla_data(actions),
+				     nla_len(actions), true, false);
 
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
 
@@ -1418,11 +1415,9 @@ static int do_execute_actions(struct datapath *dp, struct sk_buff *skb,
 
 		case OVS_ACTION_ATTR_DEC_TTL:
 			err = execute_dec_ttl(skb, key);
-			if (err == -EHOSTUNREACH) {
-				err = dec_ttl_exception_handler(dp, skb, key,
-								a, true);
-				return err;
-			}
+			if (err == -EHOSTUNREACH)
+				return dec_ttl_exception_handler(dp, skb,
+								 key, a);
 			break;
 		}
 

