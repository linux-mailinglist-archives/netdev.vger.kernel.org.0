Return-Path: <netdev+bounces-10654-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2257672F94A
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 11:31:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C37B2280DA2
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 09:31:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BC9E5693;
	Wed, 14 Jun 2023 09:31:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECF9F3D6C
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 09:31:37 +0000 (UTC)
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11EE51FE8
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 02:31:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686735096; x=1718271096;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Ua9/vDlh16RtRWBYcVBjOVTp5U9meZkTAZ+lakC5V5o=;
  b=JHWkCsgerfFRSRmXD9N7MXN4IWvaQjEUkQETOb43QJx2WJ1w6JEV1zHS
   GV2Pi9wKHB2zsEwPdhGNwBs0gEZ33obfN1x47E98+toc+leFwNxs7h7dN
   elIekgDCYsrxkhTYc1pn+3pgEH1YKAhDDwk1GbnkCV8ugSgxRrkyASdyW
   wRx9nBmsqJi24t2tVyNmJEHrPumxgEw1PLjk1nMNZELm5E1CRxQYRCYh2
   Mft9T2uhrN3H5+EzTTuTw9E7Cwx0lxsCGyvBQAZpJSxPRBp23DK6QFiLz
   5E1GT+KVeM95J3cd9pOZ3vBFgCSjXwVtgtMbHBT6GpGdjpEj+N8NdixLX
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="361939454"
X-IronPort-AV: E=Sophos;i="6.00,242,1681196400"; 
   d="scan'208";a="361939454"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2023 02:31:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="958744537"
X-IronPort-AV: E=Sophos;i="6.00,242,1681196400"; 
   d="scan'208";a="958744537"
Received: from irvmail002.ir.intel.com ([10.43.11.120])
  by fmsmga006.fm.intel.com with ESMTP; 14 Jun 2023 02:31:32 -0700
Received: from giewont.igk.intel.com (giewont.igk.intel.com [10.211.8.15])
	by irvmail002.ir.intel.com (Postfix) with ESMTP id D3F103493A;
	Wed, 14 Jun 2023 10:31:32 +0100 (IST)
From: Marcin Szycik <marcin.szycik@linux.intel.com>
To: netdev@vger.kernel.org
Cc: dsahern@gmail.com,
	stephen@networkplumber.org,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Marcin Szycik <marcin.szycik@linux.intel.com>
Subject: [PATCH iproute2-next] f_flower: implement pfcp opts
Date: Wed, 14 Jun 2023 11:17:58 +0200
Message-Id: <20230614091758.11180-1-marcin.szycik@linux.intel.com>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>

Allow adding tc filter for PFCP header.

Add support for parsing TCA_FLOWER_KEY_ENC_OPTS_PFCP.
Options are as follows: TYPE:SEID.

TYPE is a 8-bit value represented in hex and can be  1
for session header and 0 for node header. In PFCP packet
this is S flag in header.

SEID is a 64-bit session id value represented in hex.

This patch enables adding hardware filters using PFCP fields, see [1].

[1] https://lore.kernel.org/intel-wired-lan/20230607112606.15899-1-marcin.szycik@linux.intel.com

Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Signed-off-by: Marcin Szycik <marcin.szycik@linux.intel.com>
---
 include/libnetlink.h         |   6 ++
 include/uapi/linux/pkt_cls.h |  14 ++++
 man/man8/tc-flower.8         |  11 +++
 tc/f_flower.c                | 126 +++++++++++++++++++++++++++++++++++
 4 files changed, 157 insertions(+)

diff --git a/include/libnetlink.h b/include/libnetlink.h
index 39ed87a7976e..56d56c0a3d26 100644
--- a/include/libnetlink.h
+++ b/include/libnetlink.h
@@ -260,6 +260,12 @@ static inline __u64 rta_getattr_u64(const struct rtattr *rta)
 	memcpy(&tmp, RTA_DATA(rta), sizeof(__u64));
 	return tmp;
 }
+
+static inline __be64 rta_getattr_be64(const struct rtattr *rta)
+{
+	return htobe64(rta_getattr_u64(rta));
+}
+
 static inline __s32 rta_getattr_s32(const struct rtattr *rta)
 {
 	return *(__s32 *)RTA_DATA(rta);
diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
index 00933dda7b10..a1b219451ebe 100644
--- a/include/uapi/linux/pkt_cls.h
+++ b/include/uapi/linux/pkt_cls.h
@@ -629,6 +629,10 @@ enum {
 					 * TCA_FLOWER_KEY_ENC_OPT_GTP_
 					 * attributes
 					 */
+	TCA_FLOWER_KEY_ENC_OPTS_PFCP,	/* Nested
+					 * TCA_FLOWER_KEY_ENC_IPT_PFCP
+					 * attributes
+					 */
 	__TCA_FLOWER_KEY_ENC_OPTS_MAX,
 };
 
@@ -678,6 +682,16 @@ enum {
 #define TCA_FLOWER_KEY_ENC_OPT_GTP_MAX \
 		(__TCA_FLOWER_KEY_ENC_OPT_GTP_MAX - 1)
 
+enum {
+	TCA_FLOWER_KEY_ENC_OPT_PFCP_UNSPEC,
+	TCA_FLOWER_KEY_ENC_OPT_PFCP_TYPE,		/* u8 */
+	TCA_FLOWER_KEY_ENC_OPT_PFCP_SEID,		/* be64 */
+	__TCA_FLOWER_KEY_ENC_OPT_PFCP_MAX,
+};
+
+#define TCA_FLOWER_KEY_ENC_OPT_PFCP_MAX \
+		(__TCA_FLOWER_KEY_ENC_OPT_PFCP_MAX - 1)
+
 enum {
 	TCA_FLOWER_KEY_MPLS_OPTS_UNSPEC,
 	TCA_FLOWER_KEY_MPLS_OPTS_LSE,
diff --git a/man/man8/tc-flower.8 b/man/man8/tc-flower.8
index cd99745065cf..388b0b96a0a2 100644
--- a/man/man8/tc-flower.8
+++ b/man/man8/tc-flower.8
@@ -97,6 +97,8 @@ flower \- flow based traffic control filter
 .B erspan_opts
 |
 .B gtp_opts
+|
+.B pfcp_opts
 }
 .IR OPTIONS " | "
 .BR ip_flags
@@ -444,6 +446,8 @@ Match the connection zone, and can be masked.
 .BI erspan_opts " OPTIONS"
 .TQ
 .BI gtp_opts " OPTIONS"
+.TQ
+.BI pfcp_opts " OPTIONS"
 Match on IP tunnel metadata. Key id
 .I NUMBER
 is a 32 bit tunnel key id (e.g. VNI for VXLAN tunnel).
@@ -485,6 +489,13 @@ doesn't support multiple options, and it consists of a key followed by a slash
 and corresponding mask. If the mask is missing, \fBtc\fR assumes a full-length
 match. The option can be described in the form PDU_TYPE:QFI/PDU_TYPE_MASK:QFI_MASK
 where both PDU_TYPE and QFI are represented as a 8bit hexadecimal values.
+pfcp_opts
+.I OPTIONS
+doesn't support multiple options, and it consists of a key followed by a slash
+and corresponding mask. If the mask is missing, \fBtc\fR assumes a full-length
+match. The option can be described in the form TYPE:SEID/TYPE_MASK:SEID_MASK
+where TYPE is represented as a 8bit number, SEID is represented by 64bit, both
+of them are in hex.
 .TP
 .BI ip_flags " IP_FLAGS"
 .I IP_FLAGS
diff --git a/tc/f_flower.c b/tc/f_flower.c
index b9fe6afb49b2..002698b77c6b 100644
--- a/tc/f_flower.c
+++ b/tc/f_flower.c
@@ -90,6 +90,7 @@ static void explain(void)
 		"			vxlan_opts MASKED-OPTIONS |\n"
 		"			erspan_opts MASKED-OPTIONS |\n"
 		"			gtp_opts MASKED-OPTIONS |\n"
+		"			pfcp_opts MASKED-OPTIONS |\n"
 		"			ip_flags IP-FLAGS |\n"
 		"			l2_miss L2_MISS |\n"
 		"			enc_dst_port [ port_number ] |\n"
@@ -1115,6 +1116,58 @@ static int flower_parse_gtp_opt(char *str, struct nlmsghdr *n)
 	return 0;
 }
 
+static int flower_parse_pfcp_opt(char *str, struct nlmsghdr *n)
+{
+	struct rtattr *nest;
+	char *token;
+	int i, err;
+
+	nest = addattr_nest(n, MAX_MSG,
+			    TCA_FLOWER_KEY_ENC_OPTS_PFCP | NLA_F_NESTED);
+
+	i = 1;
+	token = strsep(&str, ":");
+	while (token) {
+		switch (i) {
+		case TCA_FLOWER_KEY_ENC_OPT_PFCP_TYPE:
+		{
+			__u8 opt_type;
+
+			if (!strlen(token))
+				break;
+			err = get_u8(&opt_type, token, 16);
+			if (err)
+				return err;
+
+			addattr8(n, MAX_MSG, i, opt_type);
+			break;
+		}
+		case TCA_FLOWER_KEY_ENC_OPT_PFCP_SEID:
+		{
+			__be64 opt_seid;;
+
+			if (!strlen(token))
+				break;
+			err = get_be64(&opt_seid, token, 16);
+			if (err)
+				return err;
+
+			addattr64(n, MAX_MSG, i, opt_seid);
+			break;
+		}
+		default:
+			fprintf(stderr, "Unknown \"pfcp_opts\" type\n");
+			return -1;
+		}
+
+		token = strsep(&str, ":");
+		i++;
+	}
+	addattr_nest_end(n, nest);
+
+	return 0;
+}
+
 static int flower_parse_geneve_opts(char *str, struct nlmsghdr *n)
 {
 	char *token;
@@ -1333,6 +1386,44 @@ static int flower_parse_enc_opts_gtp(char *str, struct nlmsghdr *n)
 	return 0;
 }
 
+static int flower_parse_enc_opts_pfcp(char *str, struct nlmsghdr *n)
+{
+	char key[XATTR_SIZE_MAX], mask[XATTR_SIZE_MAX];
+	struct rtattr *nest;
+	char *slash;
+	int err;
+
+
+	slash = strchr(str, '/');
+	if (slash) {
+		*slash++ = '\0';
+		if (strlen(slash) > XATTR_SIZE_MAX)
+			return -1;
+		strcpy(mask, slash);
+	} else {
+		strcpy(mask, "ff:ffffffffffffffff");
+	}
+
+	if (strlen(str) > XATTR_SIZE_MAX)
+		return -1;
+	strcpy(key, str);
+
+	nest = addattr_nest(n, MAX_MSG, TCA_FLOWER_KEY_ENC_OPTS | NLA_F_NESTED);
+	err = flower_parse_pfcp_opt(key, n);
+	if (err)
+		return err;
+	addattr_nest_end(n, nest);
+
+	nest = addattr_nest(n, MAX_MSG,
+			    TCA_FLOWER_KEY_ENC_OPTS_MASK | NLA_F_NESTED);
+	err = flower_parse_pfcp_opt(mask, n);
+	if (err)
+		return err;
+	addattr_nest_end(n, nest);
+
+	return 0;
+}
+
 static int flower_parse_mpls_lse(int *argc_p, char ***argv_p,
 				 struct nlmsghdr *nlh)
 {
@@ -2057,6 +2148,13 @@ static int flower_parse_opt(struct filter_util *qu, char *handle,
 				fprintf(stderr, "Illegal \"gtp_opts\"\n");
 				return -1;
 			}
+		} else if (!strcmp(*argv, "pfcp_opts")) {
+			NEXT_ARG();
+			ret = flower_parse_enc_opts_pfcp(*argv, n);
+			if (ret < 0) {
+				fprintf(stderr, "Illegal \"pfcp_opts\"\n");
+				return -1;
+			}
 		} else if (matches(*argv, "action") == 0) {
 			NEXT_ARG();
 			ret = parse_action(&argc, &argv, TCA_FLOWER_ACT, n);
@@ -2543,6 +2641,22 @@ static void flower_print_gtp_opts(const char *name, struct rtattr *attr,
 	snprintf(strbuf, len, "%02x:%02x", pdu_type, qfi);
 }
 
+static void flower_print_pfcp_opts(const char *name, struct rtattr *attr,
+				   char *strbuf, int len)
+{
+	struct rtattr *tb[TCA_FLOWER_KEY_ENC_OPT_PFCP_MAX + 1];
+	struct rtattr *i = RTA_DATA(attr);
+	int rem = RTA_PAYLOAD(attr);
+	__be64 seid;
+	__u8 type;
+
+	parse_rtattr(tb, TCA_FLOWER_KEY_ENC_OPT_PFCP_MAX, i, rem);
+	type = rta_getattr_u8(tb[TCA_FLOWER_KEY_ENC_OPT_PFCP_TYPE]);
+	seid = rta_getattr_be64(tb[TCA_FLOWER_KEY_ENC_OPT_PFCP_SEID]);
+
+	snprintf(strbuf, len, "%02x:%llx", type, seid);
+}
+
 static void __attribute__((format(printf, 2, 0)))
 flower_print_enc_parts(const char *name, const char *namefrm,
 		       struct rtattr *attr, char *key, char *mask)
@@ -2635,6 +2749,18 @@ static void flower_print_enc_opts(const char *name, struct rtattr *attr,
 
 		flower_print_enc_parts(name, "  gtp_opts %s", attr, key,
 				       msk);
+	} else if (key_tb[TCA_FLOWER_KEY_ENC_OPTS_PFCP]) {
+		flower_print_pfcp_opts("pfcp_opt_key",
+				key_tb[TCA_FLOWER_KEY_ENC_OPTS_PFCP],
+				key, len);
+
+		if (msk_tb[TCA_FLOWER_KEY_ENC_OPTS_PFCP])
+			flower_print_pfcp_opts("pfcp_opt_mask",
+				msk_tb[TCA_FLOWER_KEY_ENC_OPTS_PFCP],
+				msk, len);
+
+		flower_print_enc_parts(name, "  pfcp_opts %s", attr, key,
+				       msk);
 	}
 
 	free(msk);
-- 
2.31.1


