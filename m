Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D8151020E1
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 10:39:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727262AbfKSJjU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 04:39:20 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:46005 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726658AbfKSJjU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 04:39:20 -0500
Received: by mail-pg1-f196.google.com with SMTP id k1so9773583pgg.12
        for <netdev@vger.kernel.org>; Tue, 19 Nov 2019 01:39:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=F2mAdthxl955f+6wY0RMAENUy6k1L5cbngy8ydfpP3U=;
        b=iBtUjrZ8kOm66CgKDEyC/1nminCHpIBC0/x2G9fDw96poETVHsAMIMZP6x+WoSgPdB
         I+Y3gh7KlPekEe/DBaz70OxVaQbfMxl2JGMZl1P7ELZD8zEup2trxAEYLmWS8Y55wqR0
         t9QigaDuzJUz8mqwHUXpXvmnfXhLU9J4edaxFymIvWR/9vRv9TzhFteM+MSKGapJLPr8
         i4B6tD2bE0T0WLed+oWlw/ScVEyrtODuixmhJqQn6DPCcDnyV3nmarbOrYAqETRk4Whg
         fHq0I8EivgbHAaD3DQCztO31h+Js83Dtm16zGMkE5qQUv4G/RefiB8C7H/f3fZksSwrh
         sGLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=F2mAdthxl955f+6wY0RMAENUy6k1L5cbngy8ydfpP3U=;
        b=dNy3EqeCJEJIX2pbmowXxcExUue1Hp9T8ny4xbwWoUjmBLOwN2yoSP2iXJeQ5rsK0J
         97DmI1fHYLzHI9kkPcv94Z2eC5d273BedVb1hbA73zcU0JrsqtKtA+ordvpGedh2P9aj
         Jiri+P0Ihr1xV0IR4DSQ1QNPL/uJ+vSEMRtBfXtqMHu15C48rFSAEzQ+gQeSB/cG/cp+
         MqjFNLcSsBH4bGhpQwLBIe3eWWqUN38ITCRVKdIBxYuX8nqmDs7J9k2aNZfq+Z5ljd3V
         YHv9cWP6yng20Z3kcHV6vEiaLvah1lSjwI1GRjt92CfA6GUEu0zTG2aGm5g3hytX+jwV
         LVWA==
X-Gm-Message-State: APjAAAXcx6t1Lq3mKvl7DmEtn/PkHM1YYKUzpg3on83amd0LmfhnRheN
        M16G0dJpCsY0xxb7DuXpQCOFXWt4
X-Google-Smtp-Source: APXvYqxXisY9egjK4mvqzcUAMbux1Km840EhbBSMvWfc/GGdkc+s7t1WHPd7QSx+bj2ciaXEmTQA0w==
X-Received: by 2002:a65:5cc1:: with SMTP id b1mr4512531pgt.36.1574156359205;
        Tue, 19 Nov 2019 01:39:19 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id j4sm6978917pgt.57.2019.11.19.01.39.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 19 Nov 2019 01:39:18 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, simon.horman@netronome.com
Subject: [PATCH net-next] lwtunnel: add support for multiple geneve opts
Date:   Tue, 19 Nov 2019 17:39:11 +0800
Message-Id: <9c4231b54baf60619c110c818ca7a6eb37a2e52e.1574156351.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

geneve RFC (draft-ietf-nvo3-geneve-14) allows a geneve packet to carry
multiple geneve opts, so it's necessary for lwtunnel to support adding
multiple geneve opts in one lwtunnel route. But vxlan and erspan opts
are still only allowed to add one option.

With this patch, iproute2 could make it like:

  # ip r a 1.1.1.0/24 encap ip id 1 geneve_opts 0:0:12121212,1:2:12121212 \
    dst 10.1.0.2 dev geneve1

  # ip r a 1.1.1.0/24 encap ip id 1 vxlan_opts 456 \
    dst 10.1.0.2 dev erspan1

  # ip r a 1.1.1.0/24 encap ip id 1 erspan_opts 1:123:0:0 \
    dst 10.1.0.2 dev erspan1

Which are pretty much like cls_flower and act_tunnel_key.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/ipv4/ip_tunnel_core.c | 111 +++++++++++++++++++++++++++++++---------------
 1 file changed, 75 insertions(+), 36 deletions(-)

diff --git a/net/ipv4/ip_tunnel_core.c b/net/ipv4/ip_tunnel_core.c
index ee71e76..7d21f7e 100644
--- a/net/ipv4/ip_tunnel_core.c
+++ b/net/ipv4/ip_tunnel_core.c
@@ -251,7 +251,7 @@ erspan_opt_policy[LWTUNNEL_IP_OPT_ERSPAN_MAX + 1] = {
 };
 
 static int ip_tun_parse_opts_geneve(struct nlattr *attr,
-				    struct ip_tunnel_info *info,
+				    struct ip_tunnel_info *info, int opts_len,
 				    struct netlink_ext_ack *extack)
 {
 	struct nlattr *tb[LWTUNNEL_IP_OPT_GENEVE_MAX + 1];
@@ -273,7 +273,7 @@ static int ip_tun_parse_opts_geneve(struct nlattr *attr,
 		return -EINVAL;
 
 	if (info) {
-		struct geneve_opt *opt = ip_tunnel_info_opts(info);
+		struct geneve_opt *opt = ip_tunnel_info_opts(info) + opts_len;
 
 		memcpy(opt->opt_data, nla_data(attr), data_len);
 		opt->length = data_len / 4;
@@ -288,7 +288,7 @@ static int ip_tun_parse_opts_geneve(struct nlattr *attr,
 }
 
 static int ip_tun_parse_opts_vxlan(struct nlattr *attr,
-				   struct ip_tunnel_info *info,
+				   struct ip_tunnel_info *info, int opts_len,
 				   struct netlink_ext_ack *extack)
 {
 	struct nlattr *tb[LWTUNNEL_IP_OPT_VXLAN_MAX + 1];
@@ -303,7 +303,8 @@ static int ip_tun_parse_opts_vxlan(struct nlattr *attr,
 		return -EINVAL;
 
 	if (info) {
-		struct vxlan_metadata *md = ip_tunnel_info_opts(info);
+		struct vxlan_metadata *md =
+			ip_tunnel_info_opts(info) + opts_len;
 
 		attr = tb[LWTUNNEL_IP_OPT_VXLAN_GBP];
 		md->gbp = nla_get_u32(attr);
@@ -314,7 +315,7 @@ static int ip_tun_parse_opts_vxlan(struct nlattr *attr,
 }
 
 static int ip_tun_parse_opts_erspan(struct nlattr *attr,
-				    struct ip_tunnel_info *info,
+				    struct ip_tunnel_info *info, int opts_len,
 				    struct netlink_ext_ack *extack)
 {
 	struct nlattr *tb[LWTUNNEL_IP_OPT_ERSPAN_MAX + 1];
@@ -329,7 +330,8 @@ static int ip_tun_parse_opts_erspan(struct nlattr *attr,
 		return -EINVAL;
 
 	if (info) {
-		struct erspan_metadata *md = ip_tunnel_info_opts(info);
+		struct erspan_metadata *md =
+			ip_tunnel_info_opts(info) + opts_len;
 
 		attr = tb[LWTUNNEL_IP_OPT_ERSPAN_VER];
 		md->version = nla_get_u8(attr);
@@ -356,30 +358,57 @@ static int ip_tun_parse_opts_erspan(struct nlattr *attr,
 static int ip_tun_parse_opts(struct nlattr *attr, struct ip_tunnel_info *info,
 			     struct netlink_ext_ack *extack)
 {
-	struct nlattr *tb[LWTUNNEL_IP_OPTS_MAX + 1];
-	int err;
+	int err, rem, opt_len, opts_len = 0, type = 0;
+	struct nlattr *nla;
 
 	if (!attr)
 		return 0;
 
-	err = nla_parse_nested(tb, LWTUNNEL_IP_OPTS_MAX, attr,
-			       ip_opts_policy, extack);
+	err = nla_validate(nla_data(attr), nla_len(attr), LWTUNNEL_IP_OPTS_MAX,
+			   ip_opts_policy, extack);
 	if (err)
 		return err;
 
-	if (tb[LWTUNNEL_IP_OPTS_GENEVE])
-		err = ip_tun_parse_opts_geneve(tb[LWTUNNEL_IP_OPTS_GENEVE],
-					       info, extack);
-	else if (tb[LWTUNNEL_IP_OPTS_VXLAN])
-		err = ip_tun_parse_opts_vxlan(tb[LWTUNNEL_IP_OPTS_VXLAN],
-					      info, extack);
-	else if (tb[LWTUNNEL_IP_OPTS_ERSPAN])
-		err = ip_tun_parse_opts_erspan(tb[LWTUNNEL_IP_OPTS_ERSPAN],
-					       info, extack);
-	else
-		err = -EINVAL;
+	nla_for_each_attr(nla, nla_data(attr), nla_len(attr), rem) {
+		switch (nla_type(nla)) {
+		case LWTUNNEL_IP_OPTS_GENEVE:
+			if (type && type != TUNNEL_GENEVE_OPT)
+				return -EINVAL;
+			opt_len = ip_tun_parse_opts_geneve(nla, info, opts_len,
+							   extack);
+			if (opt_len < 0)
+				return opt_len;
+			opts_len += opt_len;
+			if (opts_len > IP_TUNNEL_OPTS_MAX)
+				return -EINVAL;
+			type = TUNNEL_GENEVE_OPT;
+			break;
+		case LWTUNNEL_IP_OPTS_VXLAN:
+			if (type)
+				return -EINVAL;
+			opt_len = ip_tun_parse_opts_vxlan(nla, info, opts_len,
+							  extack);
+			if (opt_len < 0)
+				return opt_len;
+			opts_len += opt_len;
+			type = TUNNEL_VXLAN_OPT;
+			break;
+		case LWTUNNEL_IP_OPTS_ERSPAN:
+			if (type)
+				return -EINVAL;
+			opt_len = ip_tun_parse_opts_erspan(nla, info, opts_len,
+							   extack);
+			if (opt_len < 0)
+				return opt_len;
+			opts_len += opt_len;
+			type = TUNNEL_ERSPAN_OPT;
+			break;
+		default:
+			return -EINVAL;
+		}
+	}
 
-	return err;
+	return opts_len;
 }
 
 static int ip_tun_get_optlen(struct nlattr *attr,
@@ -475,18 +504,23 @@ static int ip_tun_fill_encap_opts_geneve(struct sk_buff *skb,
 {
 	struct geneve_opt *opt;
 	struct nlattr *nest;
+	int offset = 0;
 
 	nest = nla_nest_start_noflag(skb, LWTUNNEL_IP_OPTS_GENEVE);
 	if (!nest)
 		return -ENOMEM;
 
-	opt = ip_tunnel_info_opts(tun_info);
-	if (nla_put_be16(skb, LWTUNNEL_IP_OPT_GENEVE_CLASS, opt->opt_class) ||
-	    nla_put_u8(skb, LWTUNNEL_IP_OPT_GENEVE_TYPE, opt->type) ||
-	    nla_put(skb, LWTUNNEL_IP_OPT_GENEVE_DATA, opt->length * 4,
-		    opt->opt_data)) {
-		nla_nest_cancel(skb, nest);
-		return -ENOMEM;
+	while (tun_info->options_len > offset) {
+		opt = ip_tunnel_info_opts(tun_info) + offset;
+		if (nla_put_be16(skb, LWTUNNEL_IP_OPT_GENEVE_CLASS,
+				 opt->opt_class) ||
+		    nla_put_u8(skb, LWTUNNEL_IP_OPT_GENEVE_TYPE, opt->type) ||
+		    nla_put(skb, LWTUNNEL_IP_OPT_GENEVE_DATA, opt->length * 4,
+			    opt->opt_data)) {
+			nla_nest_cancel(skb, nest);
+			return -ENOMEM;
+		}
+		offset += sizeof(*opt) + opt->length * 4;
 	}
 
 	nla_nest_end(skb, nest);
@@ -602,13 +636,18 @@ static int ip_tun_opts_nlsize(struct ip_tunnel_info *info)
 
 	opt_len = nla_total_size(0);		/* LWTUNNEL_IP_OPTS */
 	if (info->key.tun_flags & TUNNEL_GENEVE_OPT) {
-		struct geneve_opt *opt = ip_tunnel_info_opts(info);
-
-		opt_len += nla_total_size(0)	/* LWTUNNEL_IP_OPTS_GENEVE */
-			   + nla_total_size(2)	/* OPT_GENEVE_CLASS */
-			   + nla_total_size(1)	/* OPT_GENEVE_TYPE */
-			   + nla_total_size(opt->length * 4);
-						/* OPT_GENEVE_DATA */
+		struct geneve_opt *opt;
+		int offset = 0;
+
+		opt_len += nla_total_size(0);	/* LWTUNNEL_IP_OPTS_GENEVE */
+		while (info->options_len > offset) {
+			opt = ip_tunnel_info_opts(info) + offset;
+			opt_len += nla_total_size(2)	/* OPT_GENEVE_CLASS */
+				   + nla_total_size(1)	/* OPT_GENEVE_TYPE */
+				   + nla_total_size(opt->length * 4);
+							/* OPT_GENEVE_DATA */
+			offset += sizeof(*opt) + opt->length * 4;
+		}
 	} else if (info->key.tun_flags & TUNNEL_VXLAN_OPT) {
 		opt_len += nla_total_size(0)	/* LWTUNNEL_IP_OPTS_VXLAN */
 			   + nla_total_size(4);	/* OPT_VXLAN_GBP */
-- 
2.1.0

