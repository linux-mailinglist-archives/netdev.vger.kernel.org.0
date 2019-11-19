Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2A7810208B
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 10:32:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727432AbfKSJcH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 04:32:07 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:44491 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725784AbfKSJcH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 04:32:07 -0500
Received: by mail-pf1-f194.google.com with SMTP id q26so11855008pfn.11
        for <netdev@vger.kernel.org>; Tue, 19 Nov 2019 01:32:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=xNzzQz/LrZ5MM0UIIBjesw10qtwNbscMxNBQewxvLQo=;
        b=CPEN0TMhTpfk5B3OX6fzrqMnYotK2k11MEoxbl0q+CxFFNF+Uw+D++A5qXvQDlAuQK
         qYp7KWWi5H3kRiv1XCopsxzgXBsGOpkMnj2Bo5KxjRKbm2l6zrht0gEMwaQYrfCAJXzA
         2T4NQ2GFti7jtqR9+vswieEmiCDce2a828e2Q/AAu9ECXPO7hB9W+qsoip5jsWC/fI3O
         gu6W0t0yhwW5eCnF/0QHAVYYwqwc9T5mYnD2JQgxwayYw84vSYi0oi8hf+eAozaoibj0
         G2Ysns0FczUD17tkxS0BvFvmT4f9LRE6AUtkwxemdaIBQWkwWZ+vjqx2ghDBj9QyzdzI
         f7yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=xNzzQz/LrZ5MM0UIIBjesw10qtwNbscMxNBQewxvLQo=;
        b=lL6eDrY6K/tYB/pVuAln3q8tIu4JB4FOW95y9Nw/1FMG0lsYWTjWLo6NBgQH0jAgIE
         gmhWGe/V2m3wohdOw8HxL5YCNoFmZXcPAnPcGX26/J1URvUH36ASXBk3IlK9b8FTyPji
         M3hGV4CiQyf8ZfWYL6rVNtw3cKeXod6MA3HjPjzaN0BMxq+N24w7hS297xOG6jps7q5e
         5hl+aq2L/CuzRDBKTrVRkGrct5vnDQbVccfk92Tb1wod0uEzIVL4oo2nzgSGeexLrhu1
         3NNERgpL8C0lO2/s7jKqzcxEtZRek1mUAe17qmBjBWJNYbcC+j0dF8ctF+e7NLNo8Bf+
         vd3g==
X-Gm-Message-State: APjAAAUTISTIVImWeqXRyWJTUevPXRuENtiSBzF4F4uxVUkq1JojcWtO
        O+85Pi8EbnOmubk8vWhCzL4VFq9l
X-Google-Smtp-Source: APXvYqzRyct8n9CUZ7JgoZ3qcUGqGqAnk/86yQDutBdAP5o/0r9MwlCY6/M0Qo90/xpmKUBPSpj8eA==
X-Received: by 2002:a63:ff65:: with SMTP id s37mr4387366pgk.331.1574155925815;
        Tue, 19 Nov 2019 01:32:05 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 205sm14341686pgd.55.2019.11.19.01.32.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 19 Nov 2019 01:32:05 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, simon.horman@netronome.com
Subject: [PATCH net-next 1/4] net: sched: add vxlan option support to act_tunnel_key
Date:   Tue, 19 Nov 2019 17:31:46 +0800
Message-Id: <af3c3d95717d8ff70c2c21621cb2f49c310593e2.1574155869.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1574155869.git.lucien.xin@gmail.com>
References: <cover.1574155869.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1574155869.git.lucien.xin@gmail.com>
References: <cover.1574155869.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to allow setting vxlan options using the
act_tunnel_key action. Different from geneve options,
only one option can be set. And also, geneve options
and vxlan options can't be set at the same time.

gbp is the only param for vxlan options:

  # ip link add name vxlan0 type vxlan dstport 0 external
  # tc qdisc add dev eth0 ingress
  # tc filter add dev eth0 protocol ip parent ffff: \
           flower indev eth0 \
              ip_proto udp \
              action tunnel_key \
                  set src_ip 10.0.99.192 \
                  dst_ip 10.0.99.193 \
                  dst_port 6081 \
                  id 11 \
  		  vxlan_opts 01020304 \
          action mirred egress redirect dev vxlan0

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/uapi/linux/tc_act/tc_tunnel_key.h | 13 +++++
 net/sched/act_tunnel_key.c                | 83 ++++++++++++++++++++++++++++++-
 2 files changed, 95 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/tc_act/tc_tunnel_key.h b/include/uapi/linux/tc_act/tc_tunnel_key.h
index 41c8b46..f302c2a 100644
--- a/include/uapi/linux/tc_act/tc_tunnel_key.h
+++ b/include/uapi/linux/tc_act/tc_tunnel_key.h
@@ -50,6 +50,10 @@ enum {
 						 * TCA_TUNNEL_KEY_ENC_OPTS_
 						 * attributes
 						 */
+	TCA_TUNNEL_KEY_ENC_OPTS_VXLAN,		/* Nested
+						 * TCA_TUNNEL_KEY_ENC_OPTS_
+						 * attributes
+						 */
 	__TCA_TUNNEL_KEY_ENC_OPTS_MAX,
 };
 
@@ -67,4 +71,13 @@ enum {
 #define TCA_TUNNEL_KEY_ENC_OPT_GENEVE_MAX \
 	(__TCA_TUNNEL_KEY_ENC_OPT_GENEVE_MAX - 1)
 
+enum {
+	TCA_TUNNEL_KEY_ENC_OPT_VXLAN_UNSPEC,
+	TCA_TUNNEL_KEY_ENC_OPT_VXLAN_GBP,		/* u32 */
+	__TCA_TUNNEL_KEY_ENC_OPT_VXLAN_MAX,
+};
+
+#define TCA_TUNNEL_KEY_ENC_OPT_VXLAN_MAX \
+	(__TCA_TUNNEL_KEY_ENC_OPT_VXLAN_MAX - 1)
+
 #endif
diff --git a/net/sched/act_tunnel_key.c b/net/sched/act_tunnel_key.c
index cb34e5d..6519333 100644
--- a/net/sched/act_tunnel_key.c
+++ b/net/sched/act_tunnel_key.c
@@ -10,6 +10,7 @@
 #include <linux/skbuff.h>
 #include <linux/rtnetlink.h>
 #include <net/geneve.h>
+#include <net/vxlan.h>
 #include <net/netlink.h>
 #include <net/pkt_sched.h>
 #include <net/dst.h>
@@ -54,6 +55,7 @@ static int tunnel_key_act(struct sk_buff *skb, const struct tc_action *a,
 static const struct nla_policy
 enc_opts_policy[TCA_TUNNEL_KEY_ENC_OPTS_MAX + 1] = {
 	[TCA_TUNNEL_KEY_ENC_OPTS_GENEVE]	= { .type = NLA_NESTED },
+	[TCA_TUNNEL_KEY_ENC_OPTS_VXLAN]		= { .type = NLA_NESTED },
 };
 
 static const struct nla_policy
@@ -64,6 +66,11 @@ geneve_opt_policy[TCA_TUNNEL_KEY_ENC_OPT_GENEVE_MAX + 1] = {
 						       .len = 128 },
 };
 
+static const struct nla_policy
+vxlan_opt_policy[TCA_TUNNEL_KEY_ENC_OPT_VXLAN_MAX + 1] = {
+	[TCA_TUNNEL_KEY_ENC_OPT_VXLAN_GBP]	   = { .type = NLA_U32 },
+};
+
 static int
 tunnel_key_copy_geneve_opt(const struct nlattr *nla, void *dst, int dst_len,
 			   struct netlink_ext_ack *extack)
@@ -116,10 +123,36 @@ tunnel_key_copy_geneve_opt(const struct nlattr *nla, void *dst, int dst_len,
 	return opt_len;
 }
 
+static int
+tunnel_key_copy_vxlan_opt(const struct nlattr *nla, void *dst, int dst_len,
+			  struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb[TCA_TUNNEL_KEY_ENC_OPT_VXLAN_MAX + 1];
+	int err;
+
+	err = nla_parse_nested(tb, TCA_TUNNEL_KEY_ENC_OPT_VXLAN_MAX, nla,
+			       vxlan_opt_policy, extack);
+	if (err < 0)
+		return err;
+
+	if (!tb[TCA_TUNNEL_KEY_ENC_OPT_VXLAN_GBP]) {
+		NL_SET_ERR_MSG(extack, "Missing tunnel key vxlan option gbp");
+		return -EINVAL;
+	}
+
+	if (dst) {
+		struct vxlan_metadata *md = dst;
+
+		md->gbp = nla_get_u32(tb[TCA_TUNNEL_KEY_ENC_OPT_VXLAN_GBP]);
+	}
+
+	return sizeof(struct vxlan_metadata);
+}
+
 static int tunnel_key_copy_opts(const struct nlattr *nla, u8 *dst,
 				int dst_len, struct netlink_ext_ack *extack)
 {
-	int err, rem, opt_len, len = nla_len(nla), opts_len = 0;
+	int err, rem, opt_len, len = nla_len(nla), opts_len = 0, type = 0;
 	const struct nlattr *attr, *head = nla_data(nla);
 
 	err = nla_validate_deprecated(head, len, TCA_TUNNEL_KEY_ENC_OPTS_MAX,
@@ -130,6 +163,10 @@ static int tunnel_key_copy_opts(const struct nlattr *nla, u8 *dst,
 	nla_for_each_attr(attr, head, len, rem) {
 		switch (nla_type(attr)) {
 		case TCA_TUNNEL_KEY_ENC_OPTS_GENEVE:
+			if (type && type != TUNNEL_GENEVE_OPT) {
+				NL_SET_ERR_MSG(extack, "Wrong type for geneve options");
+				return -EINVAL;
+			}
 			opt_len = tunnel_key_copy_geneve_opt(attr, dst,
 							     dst_len, extack);
 			if (opt_len < 0)
@@ -139,6 +176,19 @@ static int tunnel_key_copy_opts(const struct nlattr *nla, u8 *dst,
 				dst_len -= opt_len;
 				dst += opt_len;
 			}
+			type = TUNNEL_GENEVE_OPT;
+			break;
+		case TCA_TUNNEL_KEY_ENC_OPTS_VXLAN:
+			if (type) {
+				NL_SET_ERR_MSG(extack, "Wrong type for vxlan options");
+				return -EINVAL;
+			}
+			opt_len = tunnel_key_copy_vxlan_opt(attr, dst,
+							    dst_len, extack);
+			if (opt_len < 0)
+				return opt_len;
+			opts_len += opt_len;
+			type = TUNNEL_VXLAN_OPT;
 			break;
 		}
 	}
@@ -175,6 +225,14 @@ static int tunnel_key_opts_set(struct nlattr *nla, struct ip_tunnel_info *info,
 #else
 		return -EAFNOSUPPORT;
 #endif
+	case TCA_TUNNEL_KEY_ENC_OPTS_VXLAN:
+#if IS_ENABLED(CONFIG_INET)
+		info->key.tun_flags |= TUNNEL_VXLAN_OPT;
+		return tunnel_key_copy_opts(nla, ip_tunnel_info_opts(info),
+					    opts_len, extack);
+#else
+		return -EAFNOSUPPORT;
+#endif
 	default:
 		NL_SET_ERR_MSG(extack, "Cannot set tunnel options for unknown tunnel type");
 		return -EINVAL;
@@ -451,6 +509,25 @@ static int tunnel_key_geneve_opts_dump(struct sk_buff *skb,
 	return 0;
 }
 
+static int tunnel_key_vxlan_opts_dump(struct sk_buff *skb,
+				      const struct ip_tunnel_info *info)
+{
+	struct vxlan_metadata *md = (struct vxlan_metadata *)(info + 1);
+	struct nlattr *start;
+
+	start = nla_nest_start_noflag(skb, TCA_TUNNEL_KEY_ENC_OPTS_VXLAN);
+	if (!start)
+		return -EMSGSIZE;
+
+	if (nla_put_u32(skb, TCA_TUNNEL_KEY_ENC_OPT_VXLAN_GBP, md->gbp)) {
+		nla_nest_cancel(skb, start);
+		return -EMSGSIZE;
+	}
+
+	nla_nest_end(skb, start);
+	return 0;
+}
+
 static int tunnel_key_opts_dump(struct sk_buff *skb,
 				const struct ip_tunnel_info *info)
 {
@@ -468,6 +545,10 @@ static int tunnel_key_opts_dump(struct sk_buff *skb,
 		err = tunnel_key_geneve_opts_dump(skb, info);
 		if (err)
 			goto err_out;
+	} else if (info->key.tun_flags & TUNNEL_VXLAN_OPT) {
+		err = tunnel_key_vxlan_opts_dump(skb, info);
+		if (err)
+			goto err_out;
 	} else {
 err_out:
 		nla_nest_cancel(skb, start);
-- 
2.1.0

