Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B87272F4C84
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 14:54:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726822AbhAMNvk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 08:51:40 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28384 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725773AbhAMNvk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 08:51:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610545813;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=BSH4NBsgQaS0eMeaRfEbNarL6kc4UVWFPB7JvynS/EM=;
        b=TV8ckXsJJseDwKz/m2K/2bJNfC4534mZ0YAY/u/5JoL33iKZXRhjL9OIncZLNmVGFq8916
        KmYejn84PWCbS7VjfjXBmqD3b21E/61DzNKoL7j+6Tr+mdMpl27f6b34N5pJhM8j85t1g+
        5cZvBPP1hIfvT7DMGas/vLumBdxxFEo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-427-nBZBQ1-uOaiG8pjVAXfoyg-1; Wed, 13 Jan 2021 08:50:10 -0500
X-MC-Unique: nBZBQ1-uOaiG8pjVAXfoyg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6FC4E192CC40;
        Wed, 13 Jan 2021 13:50:08 +0000 (UTC)
Received: from ebuild.redhat.com (ovpn-114-248.ams2.redhat.com [10.36.114.248])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 61D1360C0F;
        Wed, 13 Jan 2021 13:50:04 +0000 (UTC)
From:   Eelco Chaudron <echaudro@redhat.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, dev@openvswitch.org, kuba@kernel.org,
        pshelar@ovn.org, bindiyakurle@gmail.com, fbl@sysclose.org
Subject: [PATCH net-next] net: openvswitch: add log message for error case
Date:   Wed, 13 Jan 2021 14:50:00 +0100
Message-Id: <161054576573.26637.18396634650212670580.stgit@ebuild>
User-Agent: StGit/0.21
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As requested by upstream OVS, added some error messages in the
validate_and_copy_dec_ttl function.

Includes a small cleanup, which removes an unnecessary parameter
from the dec_ttl_exception_handler() function.

Reported-by: Flavio Leitner <fbl@sysclose.org>
Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
---
 net/openvswitch/actions.c      |   12 +++++-------
 net/openvswitch/flow_netlink.c |   14 ++++++++++++--
 2 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
index e8902a7e60f2..92a0b67b2728 100644
--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -957,14 +957,14 @@ static int output_userspace(struct datapath *dp, struct sk_buff *skb,
 
 static int dec_ttl_exception_handler(struct datapath *dp, struct sk_buff *skb,
 				     struct sw_flow_key *key,
-				     const struct nlattr *attr, bool last)
+				     const struct nlattr *attr)
 {
 	/* The first attribute is always 'OVS_DEC_TTL_ATTR_ACTION'. */
 	struct nlattr *actions = nla_data(attr);
 
 	if (nla_len(actions))
 		return clone_execute(dp, skb, key, 0, nla_data(actions),
-				     nla_len(actions), last, false);
+				     nla_len(actions), true, false);
 
 	consume_skb(skb);
 	return 0;
@@ -1418,11 +1418,9 @@ static int do_execute_actions(struct datapath *dp, struct sk_buff *skb,
 
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
 
diff --git a/net/openvswitch/flow_netlink.c b/net/openvswitch/flow_netlink.c
index 4c5c2331e764..fd1f809e9bc1 100644
--- a/net/openvswitch/flow_netlink.c
+++ b/net/openvswitch/flow_netlink.c
@@ -2515,15 +2515,25 @@ static int validate_and_copy_dec_ttl(struct net *net,
 		if (type > OVS_DEC_TTL_ATTR_MAX)
 			continue;
 
-		if (!type || attrs[type])
+		if (!type || attrs[type]) {
+			OVS_NLERR(log, "Duplicate or invalid key (type %d).",
+				  type);
 			return -EINVAL;
+		}
 
 		attrs[type] = a;
 	}
 
+	if (rem) {
+		OVS_NLERR(log, "Message has %d unknown bytes.", rem);
+		return -EINVAL;
+	}
+
 	actions = attrs[OVS_DEC_TTL_ATTR_ACTION];
-	if (rem || !actions || (nla_len(actions) && nla_len(actions) < NLA_HDRLEN))
+	if (!actions || (nla_len(actions) && nla_len(actions) < NLA_HDRLEN)) {
+		OVS_NLERR(log, "Missing valid actions attribute.");
 		return -EINVAL;
+	}
 
 	start = add_nested_action_start(sfa, OVS_ACTION_ATTR_DEC_TTL, log);
 	if (start < 0)

