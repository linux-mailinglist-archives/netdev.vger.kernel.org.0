Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C487104FF5
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 11:04:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727092AbfKUKDr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 05:03:47 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:39786 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726822AbfKUKDr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 05:03:47 -0500
Received: by mail-pl1-f196.google.com with SMTP id o9so1340165plk.6
        for <netdev@vger.kernel.org>; Thu, 21 Nov 2019 02:03:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=aCy1wPKPscgw575L5dBHLzsjbqT1fEQcMlZAJIuGLUw=;
        b=ueIeoGjwEYycaRdgiD6YHQn6eMEEZYF9+yBAKm4mrxZqVinSsuG9h3B0+5jJi3US13
         0HpsYmZ5oPi8TBxQIlEaFFr3QYH+gdlDCArTd4+pYdNhJ+9UTtJK2w2MQy6WrnPP1ypR
         sDhy/2ujMKvW6u3YGyJ9BaanKBweOsLB2trdpNxLhct5GuT7kgp8HeHz1Bs0ZOf8VVaW
         m5VorTwpL4RCgJGxZ2IJHZwjFRLMLYQIt0l1AgSoOUDae7FVqaxvbiBZU+S+sodXl4Wq
         1ay5+bjYt2Z4u4vpC5IiUg/Bq04A2hFFaWYf8stCTKLEA69Qr6b7kaK1SjndHnB31C+r
         2uBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=aCy1wPKPscgw575L5dBHLzsjbqT1fEQcMlZAJIuGLUw=;
        b=F+vzmeedgW7voxH73ED86wvG4tN8lslMQuf/Ycq4DPw0+TmLNQnFgqxQfNDsR3D82E
         IdXBmNaku3XzL0+AJhXxJac1Mlxo9NTuPAgGhhIjoPfP6LN5a/ZV+8kbt4pen8WH2qaG
         ogeqMG5/940zQVcGVc7xReHttJL4nIsrUmY7DmFfDTMLSGH9aDZAsvwJ0ljB8t/hYEI8
         Usmsdk/ywErxwLo8q8LN2crs3PVzKoVw4ewBLzYkTlAhUFqW5+H8VOMV6EDQoAWZdQAm
         MdSgJHPI/q5bS7eJGuqgxk0VNMUPRT8AklWSmW9pw8RERqDr1xrsCwn4Sb0QAhuh9rtq
         +zPw==
X-Gm-Message-State: APjAAAV/ZE2qxMOaJl2GkPqGPGss/s5XcObkqZVVUGvP8sqBDsSPHqLh
        pjCWKrm8qZ7KEC858Rph4+E5uyFi
X-Google-Smtp-Source: APXvYqwjqbzWThPuQG3SHeTDBaZhRw1jWrY67DBIVRlewFE+sQux8sO4P5v3LK8mfz1FW3oN2Kyd/g==
X-Received: by 2002:a17:902:ba91:: with SMTP id k17mr7967252pls.100.1574330625889;
        Thu, 21 Nov 2019 02:03:45 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id p7sm2670398pfn.14.2019.11.21.02.03.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 21 Nov 2019 02:03:45 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, simon.horman@netronome.com,
        jakub.kicinski@netronome.com
Subject: [PATCHv2 net-next 1/4] net: sched: add vxlan option support to act_tunnel_key
Date:   Thu, 21 Nov 2019 18:03:26 +0800
Message-Id: <a67eb8fbc6f2244cd8ae67747ebc4dd42d0516d0.1574330535.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1574330535.git.lucien.xin@gmail.com>
References: <cover.1574330535.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1574330535.git.lucien.xin@gmail.com>
References: <cover.1574330535.git.lucien.xin@gmail.com>
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

v1->v2:
  - add .strict_start_type for enc_opts_policy as Jakub noticed.
  - use Duplicate instead of Wrong in err msg for extack as Jakub
    suggested.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/uapi/linux/tc_act/tc_tunnel_key.h | 13 +++++
 net/sched/act_tunnel_key.c                | 85 ++++++++++++++++++++++++++++++-
 2 files changed, 97 insertions(+), 1 deletion(-)

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
index cb34e5d..ff0909b 100644
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
@@ -53,7 +54,10 @@ static int tunnel_key_act(struct sk_buff *skb, const struct tc_action *a,
 
 static const struct nla_policy
 enc_opts_policy[TCA_TUNNEL_KEY_ENC_OPTS_MAX + 1] = {
+	[TCA_TUNNEL_KEY_ENC_OPTS_UNSPEC]	= {
+		.strict_start_type = TCA_TUNNEL_KEY_ENC_OPTS_VXLAN },
 	[TCA_TUNNEL_KEY_ENC_OPTS_GENEVE]	= { .type = NLA_NESTED },
+	[TCA_TUNNEL_KEY_ENC_OPTS_VXLAN]		= { .type = NLA_NESTED },
 };
 
 static const struct nla_policy
@@ -64,6 +68,11 @@ geneve_opt_policy[TCA_TUNNEL_KEY_ENC_OPT_GENEVE_MAX + 1] = {
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
@@ -116,10 +125,36 @@ tunnel_key_copy_geneve_opt(const struct nlattr *nla, void *dst, int dst_len,
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
@@ -130,6 +165,10 @@ static int tunnel_key_copy_opts(const struct nlattr *nla, u8 *dst,
 	nla_for_each_attr(attr, head, len, rem) {
 		switch (nla_type(attr)) {
 		case TCA_TUNNEL_KEY_ENC_OPTS_GENEVE:
+			if (type && type != TUNNEL_GENEVE_OPT) {
+				NL_SET_ERR_MSG(extack, "Duplicate type for geneve options");
+				return -EINVAL;
+			}
 			opt_len = tunnel_key_copy_geneve_opt(attr, dst,
 							     dst_len, extack);
 			if (opt_len < 0)
@@ -139,6 +178,19 @@ static int tunnel_key_copy_opts(const struct nlattr *nla, u8 *dst,
 				dst_len -= opt_len;
 				dst += opt_len;
 			}
+			type = TUNNEL_GENEVE_OPT;
+			break;
+		case TCA_TUNNEL_KEY_ENC_OPTS_VXLAN:
+			if (type) {
+				NL_SET_ERR_MSG(extack, "Duplicate type for vxlan options");
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
@@ -175,6 +227,14 @@ static int tunnel_key_opts_set(struct nlattr *nla, struct ip_tunnel_info *info,
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
@@ -451,6 +511,25 @@ static int tunnel_key_geneve_opts_dump(struct sk_buff *skb,
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
@@ -468,6 +547,10 @@ static int tunnel_key_opts_dump(struct sk_buff *skb,
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

