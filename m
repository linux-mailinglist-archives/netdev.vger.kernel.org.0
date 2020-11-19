Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB6C32B8E5E
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 10:05:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726406AbgKSJEN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 04:04:13 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:56016 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725873AbgKSJEN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 04:04:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605776652;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=lq86WK20JdqrrSDS9gzXlQHi/8HgeJ7N+9n6adOOnEE=;
        b=ajj6uCm64TCSRWyNrS3P1GHAkOfFAiL/bdxlLhB1VGQff9Hi3MBAGOrB/w2djqrl7SZY3e
        7fEtecYY3gbjoEGDmcCBVrHr0BmfF9Ms5AhL7RNi6WrvZocwW25+Ea4LsGBBc0ctm1rw1H
        nO7DNp+Y46PTGcAdcC69TfPhtMZOX+I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-478-0UKH3qgJNYGGHlNxMr1T8Q-1; Thu, 19 Nov 2020 04:04:09 -0500
X-MC-Unique: 0UKH3qgJNYGGHlNxMr1T8Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 97ABD84A614;
        Thu, 19 Nov 2020 09:04:07 +0000 (UTC)
Received: from wsfd-netdev64.ntdv.lab.eng.bos.redhat.com (wsfd-netdev64.ntdv.lab.eng.bos.redhat.com [10.19.188.127])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 962FF60843;
        Thu, 19 Nov 2020 09:04:06 +0000 (UTC)
From:   Eelco Chaudron <echaudro@redhat.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, dev@openvswitch.org, kuba@kernel.org,
        pshelar@ovn.org, bindiyakurle@gmail.com, i.maximets@ovn.org,
        mcroce@linux.microsoft.com
Subject: [PATCH net] net: openvswitch: fix TTL decrement action netlink message format
Date:   Thu, 19 Nov 2020 04:04:04 -0500
Message-Id:  <160577663600.7755.4779460826621858224.stgit@wsfd-netdev64.ntdv.lab.eng.bos.redhat.com>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, the openvswitch module is not accepting the correctly formated
netlink message for the TTL decrement action. For both setting and getting
the dec_ttl action, the actions should be nested in the
OVS_DEC_TTL_ATTR_ACTION attribute as mentioned in the openvswitch.h uapi.

Fixes: 744676e77720 ("openvswitch: add TTL decrement action")
Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
---
 include/uapi/linux/openvswitch.h |    2 +
 net/openvswitch/actions.c        |    7 ++--
 net/openvswitch/flow_netlink.c   |   74 ++++++++++++++++++++++++++++----------
 3 files changed, 60 insertions(+), 23 deletions(-)

diff --git a/include/uapi/linux/openvswitch.h b/include/uapi/linux/openvswitch.h
index 8300cc29dec8..8d16744edc31 100644
--- a/include/uapi/linux/openvswitch.h
+++ b/include/uapi/linux/openvswitch.h
@@ -1058,4 +1058,6 @@ enum ovs_dec_ttl_attr {
 	__OVS_DEC_TTL_ATTR_MAX
 };
 
+#define OVS_DEC_TTL_ATTR_MAX (__OVS_DEC_TTL_ATTR_MAX - 1)
+
 #endif /* _LINUX_OPENVSWITCH_H */
diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
index b87bfc82f44f..5829a020b81c 100644
--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -958,14 +958,13 @@ static int dec_ttl_exception_handler(struct datapath *dp, struct sk_buff *skb,
 {
 	/* The first action is always 'OVS_DEC_TTL_ATTR_ARG'. */
 	struct nlattr *dec_ttl_arg = nla_data(attr);
-	int rem = nla_len(attr);
 
 	if (nla_len(dec_ttl_arg)) {
-		struct nlattr *actions = nla_next(dec_ttl_arg, &rem);
+		struct nlattr *actions = nla_data(dec_ttl_arg);
 
 		if (actions)
-			return clone_execute(dp, skb, key, 0, actions, rem,
-					     last, false);
+			return clone_execute(dp, skb, key, 0, nla_data(actions),
+					     nla_len(actions), last, false);
 	}
 	consume_skb(skb);
 	return 0;
diff --git a/net/openvswitch/flow_netlink.c b/net/openvswitch/flow_netlink.c
index 9d3e50c4d29f..ec0689ddc635 100644
--- a/net/openvswitch/flow_netlink.c
+++ b/net/openvswitch/flow_netlink.c
@@ -2503,28 +2503,42 @@ static int validate_and_copy_dec_ttl(struct net *net,
 				     __be16 eth_type, __be16 vlan_tci,
 				     u32 mpls_label_count, bool log)
 {
-	int start, err;
-	u32 nested = true;
+	const struct nlattr *attrs[OVS_DEC_TTL_ATTR_MAX + 1];
+	int start, action_start, err, rem;
+	const struct nlattr *a, *actions;
+
+	memset(attrs, 0, sizeof(attrs));
+	nla_for_each_nested(a, attr, rem) {
+		int type = nla_type(a);
 
-	if (!nla_len(attr))
-		return ovs_nla_add_action(sfa, OVS_ACTION_ATTR_DEC_TTL,
-					  NULL, 0, log);
+		/* Ignore unknown attributes to be future proof. */
+		if (type > OVS_DEC_TTL_ATTR_MAX)
+			continue;
+
+		if (!type || attrs[type])
+			return -EINVAL;
+
+		attrs[type] = a;
+	}
+
+	actions = attrs[OVS_DEC_TTL_ATTR_ACTION];
+	if (rem || !actions || (nla_len(actions) && nla_len(actions) < NLA_HDRLEN))
+		return -EINVAL;
 
 	start = add_nested_action_start(sfa, OVS_ACTION_ATTR_DEC_TTL, log);
 	if (start < 0)
 		return start;
 
-	err = ovs_nla_add_action(sfa, OVS_DEC_TTL_ATTR_ACTION, &nested,
-				 sizeof(nested), log);
-
-	if (err)
-		return err;
+	action_start = add_nested_action_start(sfa, OVS_DEC_TTL_ATTR_ACTION, log);
+	if (action_start < 0)
+		return start;
 
-	err = __ovs_nla_copy_actions(net, attr, key, sfa, eth_type,
+	err = __ovs_nla_copy_actions(net, actions, key, sfa, eth_type,
 				     vlan_tci, mpls_label_count, log);
 	if (err)
 		return err;
 
+	add_nested_action_end(*sfa, action_start);
 	add_nested_action_end(*sfa, start);
 	return 0;
 }
@@ -3487,20 +3501,42 @@ static int check_pkt_len_action_to_attr(const struct nlattr *attr,
 static int dec_ttl_action_to_attr(const struct nlattr *attr,
 				  struct sk_buff *skb)
 {
-	int err = 0, rem = nla_len(attr);
-	struct nlattr *start;
+	struct nlattr *start, *action_start;
+	const struct nlattr *a;
+	int err = 0, rem;
 
 	start = nla_nest_start_noflag(skb, OVS_ACTION_ATTR_DEC_TTL);
-
 	if (!start)
 		return -EMSGSIZE;
 
-	err = ovs_nla_put_actions(nla_data(attr), rem, skb);
-	if (err)
-		nla_nest_cancel(skb, start);
-	else
-		nla_nest_end(skb, start);
+	nla_for_each_attr(a, nla_data(attr), nla_len(attr), rem) {
+		switch (nla_type(a)) {
+		case OVS_DEC_TTL_ATTR_ACTION:
+
+			action_start = nla_nest_start_noflag(skb, OVS_DEC_TTL_ATTR_ACTION);
+			if (!action_start) {
+				err = -EMSGSIZE;
+				goto out;
+			}
+
+			err = ovs_nla_put_actions(nla_data(a), nla_len(a), skb);
+			if (err)
+				goto out;
+
+			nla_nest_end(skb, action_start);
+			break;
 
+		default:
+			/* Ignore all other option to be future compatible */
+			break;
+		}
+	}
+
+	nla_nest_end(skb, start);
+	return 0;
+
+out:
+	nla_nest_cancel(skb, start);
 	return err;
 }
 

