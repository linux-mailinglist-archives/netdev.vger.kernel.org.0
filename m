Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 257362C25C8
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 13:35:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387458AbgKXMey (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 07:34:54 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:26398 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729172AbgKXMey (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 07:34:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606221292;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=30/9ZGKRGRWbK38cITnrJaeSJDXNAmQwyuGQI5tIvtc=;
        b=OcBDZw1YRvLd5G5KEqYjH4Z4eQSfFAuO0X/vpT1iWJcRjE9MeJWcbj6m4wiGieuD+D+e6d
        kws/L93vzD401k+m71rgLkdhHpV0GTccx0vKg0ueiJfvnvh+jIN86qdgIbTq/KJBqaNHGb
        jyvlX7YY7ipDWZdozA8L6ToniXrEywg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-226-zqoRpeqIMDCjhxQ_4faSdg-1; Tue, 24 Nov 2020 07:34:50 -0500
X-MC-Unique: zqoRpeqIMDCjhxQ_4faSdg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BD84C18C43DC;
        Tue, 24 Nov 2020 12:34:48 +0000 (UTC)
Received: from wsfd-netdev64.ntdv.lab.eng.bos.redhat.com (wsfd-netdev64.ntdv.lab.eng.bos.redhat.com [10.19.188.127])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F0EC85D9CA;
        Tue, 24 Nov 2020 12:34:47 +0000 (UTC)
From:   Eelco Chaudron <echaudro@redhat.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, dev@openvswitch.org, kuba@kernel.org,
        pshelar@ovn.org, bindiyakurle@gmail.com, i.maximets@ovn.org,
        mcroce@linux.microsoft.com
Subject: [PATCH net v2] net: openvswitch: fix TTL decrement action netlink message format
Date:   Tue, 24 Nov 2020 07:34:44 -0500
Message-Id:  <160622121495.27296.888010441924340582.stgit@wsfd-netdev64.ntdv.lab.eng.bos.redhat.com>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, the openvswitch module is not accepting the correctly formated
netlink message for the TTL decrement action. For both setting and getting
the dec_ttl action, the actions should be nested in the
OVS_DEC_TTL_ATTR_ACTION attribute as mentioned in the openvswitch.h uapi.

When the original patch was sent, it was tested with a private OVS userspace
implementation. This implementation was unfortunately not upstreamed and
reviewed, hence an erroneous version of this patch was sent out.

Leaving the patch as-is would cause problems as the kernel module could
interpret additional attributes as actions and vice-versa, due to the
actions not being encapsulated/nested within the actual attribute, but
being concatinated after it.

Fixes: 744676e77720 ("openvswitch: add TTL decrement action")
Signed-off-by: Eelco Chaudron <echaudro@redhat.com>

---
v2: Update commit message to better explain the issue with the existing patch

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
 

