Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E6704B2C3E
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 19:00:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346997AbiBKR62 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 12:58:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352414AbiBKR6Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 12:58:24 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D1E0CE9
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 09:58:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644602302; x=1676138302;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=h7PyZhJNMymZF+zbOeFkQDdKqL/V8yvJjY+IvnQoN/A=;
  b=hdCK8pJOSuwxmd//eJunNyIhyin70/svO+W0Unyg6QKn5zl/SGGXuuAg
   QHr3YdVy3X5YJZUV5bUmyaFNIwB7/7c5YnWlcMyXAa9heDS/AkRvuY9uO
   hr6katIa4z4YJR0RmVgBb6a5PGF4MvX4/jUJ2pbxaEszTJh2ggDvohrE/
   1dZuuaVtrzdAtouyC5muEjsMyLg5G7I7Uu9C9Y+bOzGphIpEZ7woDpre2
   mykB8VVz1BhN+U4xRKsOiWQ05HI0GzD1e7bXGL/PCUS1xG/sWBhCLu/j5
   AOg4Zn5VZAkufjhvY+oBMwr9hxbjZiVcdJ4hpMYdHKthYFT/sarR2ri/f
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10255"; a="249984417"
X-IronPort-AV: E=Sophos;i="5.88,361,1635231600"; 
   d="scan'208";a="249984417"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2022 09:58:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,361,1635231600"; 
   d="scan'208";a="772156590"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga006.fm.intel.com with ESMTP; 11 Feb 2022 09:58:19 -0800
Received: from switcheroo.igk.intel.com (switcheroo.igk.intel.com [172.22.229.137])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 21BHwINH017261;
        Fri, 11 Feb 2022 17:58:18 GMT
From:   Marcin Szycik <marcin.szycik@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     michal.swiatkowski@linux.intel.com, wojciech.drewek@intel.com,
        davem@davemloft.net, kuba@kernel.org, pablo@netfilter.org,
        laforge@gnumonks.org, osmocom-net-gprs@lists.osmocom.org,
        jiri@resnulli.us
Subject: [RFC PATCH net-next v5 3/6] net/sched: Allow flower to match on GTP options
Date:   Fri, 11 Feb 2022 18:55:06 +0100
Message-Id: <20220211175506.7903-1-marcin.szycik@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220211175405.7651-1-marcin.szycik@linux.intel.com>
References: <20220211175405.7651-1-marcin.szycik@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wojciech Drewek <wojciech.drewek@intel.com>

Options are as follows: PDU_TYPE:QFI and they refernce to
the fields from the  PDU Session Protocol. PDU Session data
is conveyed in GTP-U Extension Header.

GTP-U Extension Header is described in 3GPP TS 29.281.
PDU Session Protocol is described in 3GPP TS 38.415.

PDU_TYPE -  indicates the type of the PDU Session Information (4 bits)
QFI      -  QoS Flow Identifier (6 bits)

  # ip link add gtp_dev type gtp role sgsn
  # tc qdisc add dev gtp_dev ingress
  # tc filter add dev gtp_dev protocol ip parent ffff: \
      flower \
        enc_key_id 11 \
        gtp_opts 1:8/ff:ff \
      action mirred egress redirect dev eth0

Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
---
 include/net/gtp.h              |   5 ++
 include/uapi/linux/if_tunnel.h |   4 +-
 include/uapi/linux/pkt_cls.h   |  15 +++++
 net/sched/cls_flower.c         | 116 +++++++++++++++++++++++++++++++++
 4 files changed, 139 insertions(+), 1 deletion(-)

diff --git a/include/net/gtp.h b/include/net/gtp.h
index 0e12c37f2958..23c2aaae8a42 100644
--- a/include/net/gtp.h
+++ b/include/net/gtp.h
@@ -58,6 +58,11 @@ struct gtp1u_packet {
 	struct gtp_ie ie;
 } __packed;
 
+struct gtp_pdu_session_info {	/* According to 3GPP TS 38.415. */
+	u8	pdu_type;
+	u8	qfi;
+};
+
 #define GTP1_F_NPDU	0x01
 #define GTP1_F_SEQ	0x02
 #define GTP1_F_EXTHDR	0x04
diff --git a/include/uapi/linux/if_tunnel.h b/include/uapi/linux/if_tunnel.h
index 7d9105533c7b..102119628ff5 100644
--- a/include/uapi/linux/if_tunnel.h
+++ b/include/uapi/linux/if_tunnel.h
@@ -176,8 +176,10 @@ enum {
 #define TUNNEL_VXLAN_OPT	__cpu_to_be16(0x1000)
 #define TUNNEL_NOCACHE		__cpu_to_be16(0x2000)
 #define TUNNEL_ERSPAN_OPT	__cpu_to_be16(0x4000)
+#define TUNNEL_GTP_OPT		__cpu_to_be16(0x8000)
 
 #define TUNNEL_OPTIONS_PRESENT \
-		(TUNNEL_GENEVE_OPT | TUNNEL_VXLAN_OPT | TUNNEL_ERSPAN_OPT)
+		(TUNNEL_GENEVE_OPT | TUNNEL_VXLAN_OPT | TUNNEL_ERSPAN_OPT | \
+		TUNNEL_GTP_OPT)
 
 #endif /* _UAPI_IF_TUNNEL_H_ */
diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
index ee38b35c3f57..404f97fb239c 100644
--- a/include/uapi/linux/pkt_cls.h
+++ b/include/uapi/linux/pkt_cls.h
@@ -616,6 +616,10 @@ enum {
 					 * TCA_FLOWER_KEY_ENC_OPT_ERSPAN_
 					 * attributes
 					 */
+	TCA_FLOWER_KEY_ENC_OPTS_GTP,	/* Nested
+					 * TCA_FLOWER_KEY_ENC_OPT_GTP_
+					 * attributes
+					 */
 	__TCA_FLOWER_KEY_ENC_OPTS_MAX,
 };
 
@@ -654,6 +658,17 @@ enum {
 #define TCA_FLOWER_KEY_ENC_OPT_ERSPAN_MAX \
 		(__TCA_FLOWER_KEY_ENC_OPT_ERSPAN_MAX - 1)
 
+enum {
+	TCA_FLOWER_KEY_ENC_OPT_GTP_UNSPEC,
+	TCA_FLOWER_KEY_ENC_OPT_GTP_PDU_TYPE,		/* u8 */
+	TCA_FLOWER_KEY_ENC_OPT_GTP_QFI,			/* u8 */
+
+	__TCA_FLOWER_KEY_ENC_OPT_GTP_MAX,
+};
+
+#define TCA_FLOWER_KEY_ENC_OPT_GTP_MAX \
+		(__TCA_FLOWER_KEY_ENC_OPT_GTP_MAX - 1)
+
 enum {
 	TCA_FLOWER_KEY_MPLS_OPTS_UNSPEC,
 	TCA_FLOWER_KEY_MPLS_OPTS_LSE,
diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index 1a9b1f140f9e..c80fc49c0da1 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -25,6 +25,7 @@
 #include <net/geneve.h>
 #include <net/vxlan.h>
 #include <net/erspan.h>
+#include <net/gtp.h>
 
 #include <net/dst.h>
 #include <net/dst_metadata.h>
@@ -723,6 +724,7 @@ enc_opts_policy[TCA_FLOWER_KEY_ENC_OPTS_MAX + 1] = {
 	[TCA_FLOWER_KEY_ENC_OPTS_GENEVE]        = { .type = NLA_NESTED },
 	[TCA_FLOWER_KEY_ENC_OPTS_VXLAN]         = { .type = NLA_NESTED },
 	[TCA_FLOWER_KEY_ENC_OPTS_ERSPAN]        = { .type = NLA_NESTED },
+	[TCA_FLOWER_KEY_ENC_OPTS_GTP]		= { .type = NLA_NESTED },
 };
 
 static const struct nla_policy
@@ -746,6 +748,12 @@ erspan_opt_policy[TCA_FLOWER_KEY_ENC_OPT_ERSPAN_MAX + 1] = {
 	[TCA_FLOWER_KEY_ENC_OPT_ERSPAN_HWID]       = { .type = NLA_U8 },
 };
 
+static const struct nla_policy
+gtp_opt_policy[TCA_FLOWER_KEY_ENC_OPT_GTP_MAX + 1] = {
+	[TCA_FLOWER_KEY_ENC_OPT_GTP_PDU_TYPE]	   = { .type = NLA_U8 },
+	[TCA_FLOWER_KEY_ENC_OPT_GTP_QFI]	   = { .type = NLA_U8 },
+};
+
 static const struct nla_policy
 mpls_stack_entry_policy[TCA_FLOWER_KEY_MPLS_OPT_LSE_MAX + 1] = {
 	[TCA_FLOWER_KEY_MPLS_OPT_LSE_DEPTH]    = { .type = NLA_U8 },
@@ -1262,6 +1270,49 @@ static int fl_set_erspan_opt(const struct nlattr *nla, struct fl_flow_key *key,
 	return sizeof(*md);
 }
 
+static int fl_set_gtp_opt(const struct nlattr *nla, struct fl_flow_key *key,
+			  int depth, int option_len,
+			  struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb[TCA_FLOWER_KEY_ENC_OPT_GTP_MAX + 1];
+	struct gtp_pdu_session_info *sinfo;
+	u8 len = key->enc_opts.len;
+	int err;
+
+	sinfo = (struct gtp_pdu_session_info *)&key->enc_opts.data[len];
+	memset(sinfo, 0xff, option_len);
+
+	if (!depth)
+		return sizeof(*sinfo);
+
+	if (nla_type(nla) != TCA_FLOWER_KEY_ENC_OPTS_GTP) {
+		NL_SET_ERR_MSG_MOD(extack, "Non-gtp option type for mask");
+		return -EINVAL;
+	}
+
+	err = nla_parse_nested(tb, TCA_FLOWER_KEY_ENC_OPT_GTP_MAX, nla,
+			       gtp_opt_policy, extack);
+	if (err < 0)
+		return err;
+
+	if (!option_len &&
+	    (!tb[TCA_FLOWER_KEY_ENC_OPT_GTP_PDU_TYPE] ||
+	     !tb[TCA_FLOWER_KEY_ENC_OPT_GTP_QFI])) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Missing tunnel key gtp option pdu type or qfi");
+		return -EINVAL;
+	}
+
+	if (tb[TCA_FLOWER_KEY_ENC_OPT_GTP_PDU_TYPE])
+		sinfo->pdu_type =
+			nla_get_u8(tb[TCA_FLOWER_KEY_ENC_OPT_GTP_PDU_TYPE]);
+
+	if (tb[TCA_FLOWER_KEY_ENC_OPT_GTP_QFI])
+		sinfo->qfi = nla_get_u8(tb[TCA_FLOWER_KEY_ENC_OPT_GTP_QFI]);
+
+	return sizeof(*sinfo);
+}
+
 static int fl_set_enc_opt(struct nlattr **tb, struct fl_flow_key *key,
 			  struct fl_flow_key *mask,
 			  struct netlink_ext_ack *extack)
@@ -1386,6 +1437,38 @@ static int fl_set_enc_opt(struct nlattr **tb, struct fl_flow_key *key,
 				return -EINVAL;
 			}
 			break;
+		case TCA_FLOWER_KEY_ENC_OPTS_GTP:
+			if (key->enc_opts.dst_opt_type) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Duplicate type for gtp options");
+				return -EINVAL;
+			}
+			option_len = 0;
+			key->enc_opts.dst_opt_type = TUNNEL_GTP_OPT;
+			option_len = fl_set_gtp_opt(nla_opt_key, key,
+						    key_depth, option_len,
+						    extack);
+			if (option_len < 0)
+				return option_len;
+
+			key->enc_opts.len += option_len;
+			/* At the same time we need to parse through the mask
+			 * in order to verify exact and mask attribute lengths.
+			 */
+			mask->enc_opts.dst_opt_type = TUNNEL_GTP_OPT;
+			option_len = fl_set_gtp_opt(nla_opt_msk, mask,
+						    msk_depth, option_len,
+						    extack);
+			if (option_len < 0)
+				return option_len;
+
+			mask->enc_opts.len += option_len;
+			if (key->enc_opts.len != mask->enc_opts.len) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Key and mask miss aligned");
+				return -EINVAL;
+			}
+			break;
 		default:
 			NL_SET_ERR_MSG(extack, "Unknown tunnel option type");
 			return -EINVAL;
@@ -2761,6 +2844,34 @@ static int fl_dump_key_erspan_opt(struct sk_buff *skb,
 	return -EMSGSIZE;
 }
 
+static int fl_dump_key_gtp_opt(struct sk_buff *skb,
+			       struct flow_dissector_key_enc_opts *enc_opts)
+
+{
+	struct gtp_pdu_session_info *session_info;
+	struct nlattr *nest;
+
+	nest = nla_nest_start_noflag(skb, TCA_FLOWER_KEY_ENC_OPTS_GTP);
+	if (!nest)
+		goto nla_put_failure;
+
+	session_info = (struct gtp_pdu_session_info *)&enc_opts->data[0];
+
+	if (nla_put_u8(skb, TCA_FLOWER_KEY_ENC_OPT_GTP_PDU_TYPE,
+		       session_info->pdu_type))
+		goto nla_put_failure;
+
+	if (nla_put_u8(skb, TCA_FLOWER_KEY_ENC_OPT_GTP_QFI, session_info->qfi))
+		goto nla_put_failure;
+
+	nla_nest_end(skb, nest);
+	return 0;
+
+nla_put_failure:
+	nla_nest_cancel(skb, nest);
+	return -EMSGSIZE;
+}
+
 static int fl_dump_key_ct(struct sk_buff *skb,
 			  struct flow_dissector_key_ct *key,
 			  struct flow_dissector_key_ct *mask)
@@ -2824,6 +2935,11 @@ static int fl_dump_key_options(struct sk_buff *skb, int enc_opt_type,
 		if (err)
 			goto nla_put_failure;
 		break;
+	case TUNNEL_GTP_OPT:
+		err = fl_dump_key_gtp_opt(skb, enc_opts);
+		if (err)
+			goto nla_put_failure;
+		break;
 	default:
 		goto nla_put_failure;
 	}
-- 
2.31.1

