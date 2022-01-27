Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 099A949E325
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 14:16:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241583AbiA0NQt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 08:16:49 -0500
Received: from mga01.intel.com ([192.55.52.88]:18686 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241577AbiA0NQs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jan 2022 08:16:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643289407; x=1674825407;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/XfqX1m5MxBxtsisV0mgRcgHWEfykadDhImTOwE95xM=;
  b=TAg1URUOXNbNywvrPnbAyzDCiAsmEz5330q2wDsqW3W7etRv+1qr/Hqe
   5vVscnXFbNwRLGYjTgm+51vyu9rFcCTs/s9rkXLoPsYWDohVLs5de+59r
   SbQmddC6T9fCd+m30rAjkY8wc1KTiT68KIaCvRA4/4zf/hVC2EY7Dh5P7
   ezZQWixN5Vc+i4e65oke0Mpq/e1r30E7S/vkCVzkICi4Iw1XWjvYMefh7
   UrUuo9rvxDGsLRRkssVe0/PEtTzkyPL6D/PcVYQx7i0JZsCRIKIKflFVm
   NOFjA4Xw4i0PUzFmTB2pjQ2nX40zjsNeKX+NS2FxSd2cHYRG7eeYxPkvm
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10239"; a="271300475"
X-IronPort-AV: E=Sophos;i="5.88,320,1635231600"; 
   d="scan'208";a="271300475"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2022 05:16:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,320,1635231600"; 
   d="scan'208";a="625211860"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga002.fm.intel.com with ESMTP; 27 Jan 2022 05:16:46 -0800
Received: from switcheroo.igk.intel.com (switcheroo.igk.intel.com [172.22.229.137])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 20RDGipe023596;
        Thu, 27 Jan 2022 13:16:45 GMT
From:   Wojciech Drewek <wojciech.drewek@intel.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org,
        michal.swiatkowski@linux.intel.com, marcin.szycik@linux.intel.com
Subject: [PATCH iproute2-next 2/2] f_flower: Implement gtp options support
Date:   Thu, 27 Jan 2022 14:13:55 +0100
Message-Id: <20220127131355.126824-3-wojciech.drewek@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220127131355.126824-1-wojciech.drewek@intel.com>
References: <20220127131355.126824-1-wojciech.drewek@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for parsing TCA_FLOWER_KEY_ENC_OPTS_GTP.
Options are as follows: PDU_TYPE:QFI where each
option is represented as 8-bit hexadecimal value.

e.g.
  # ip link add gtp_dev type gtp role sgsn
  # tc qdisc add dev gtp_dev ingress
  # tc filter add dev gtp_dev protocol ip parent ffff: \
      flower \
        enc_key_id 11 \
        gtp_opts 1:8/ff:ff \
      action mirred egress redirect dev eth0

Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
---
 include/uapi/linux/pkt_cls.h |  16 +++++
 man/man8/tc-flower.8         |  10 +++
 tc/f_flower.c                | 120 +++++++++++++++++++++++++++++++++++
 3 files changed, 146 insertions(+)

diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
index ee38b35c3f57..30ff8da0631b 100644
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
 
@@ -654,6 +658,18 @@ enum {
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
+
 enum {
 	TCA_FLOWER_KEY_MPLS_OPTS_UNSPEC,
 	TCA_FLOWER_KEY_MPLS_OPTS_LSE,
diff --git a/man/man8/tc-flower.8 b/man/man8/tc-flower.8
index 4541d9372684..f918a06d2927 100644
--- a/man/man8/tc-flower.8
+++ b/man/man8/tc-flower.8
@@ -89,6 +89,8 @@ flower \- flow based traffic control filter
 .B vxlan_opts
 |
 .B erspan_opts
+|
+.B gtp_opts
 }
 .IR OPTIONS " | "
 .BR ip_flags
@@ -411,6 +413,8 @@ Match the connection zone, and can be masked.
 .BI vxlan_opts " OPTIONS"
 .TQ
 .BI erspan_opts " OPTIONS"
+.TQ
+.BI gtp_opts " OPTIONS"
 Match on IP tunnel metadata. Key id
 .I NUMBER
 is a 32 bit tunnel key id (e.g. VNI for VXLAN tunnel).
@@ -446,6 +450,12 @@ VERSION:INDEX:DIR:HWID/VERSION:INDEX_MASK:DIR_MASK:HWID_MASK, where VERSION is
 represented as a 8bit number, INDEX as an 32bit number, DIR and HWID as a 8bit
 number. Multiple options is not supported. Note INDEX/INDEX_MASK is used when
 VERSION is 1, and DIR/DIR_MASK and HWID/HWID_MASK are used when VERSION is 2.
+gtp_opts
+.I OPTIONS
+doesn't support multiple options, and it consists of a key followed by a slash
+and corresponding mask. If the mask is missing, \fBtc\fR assumes a full-length
+match. The option can be described in the form PDU_TYPE:QFI/PDU_TYPE_MASK:QFI_MASK
+where both PDU_TYPE and QFI are represented as a 8bit hexadecimal values.
 .TP
 .BI ip_flags " IP_FLAGS"
 .I IP_FLAGS
diff --git a/tc/f_flower.c b/tc/f_flower.c
index 6d70b92a2894..eb234bc70484 100644
--- a/tc/f_flower.c
+++ b/tc/f_flower.c
@@ -1022,6 +1022,52 @@ static int flower_parse_erspan_opt(char *str, struct nlmsghdr *n)
 	return 0;
 }
 
+static int flower_parse_gtp_opt(char *str, struct nlmsghdr *n)
+{
+	struct rtattr *nest;
+	char *token;
+	int arg, err;
+
+	nest = addattr_nest(n, MAX_MSG, TCA_FLOWER_KEY_ENC_OPTS_GTP | NLA_F_NESTED);
+
+	token = strsep(&str, ":");
+	for (arg = 1; arg <= TCA_FLOWER_KEY_ENC_OPT_GTP_MAX; arg++) {
+		switch (arg) {
+		case TCA_FLOWER_KEY_ENC_OPT_GTP_PDU_TYPE:
+		{
+			__u8 pdu_type;
+
+			if (!strlen(token))
+				break;
+			err = get_u8(&pdu_type, token, 16);
+			if (err)
+				return err;
+			addattr8(n, MAX_MSG, arg, pdu_type);
+			break;
+		}
+		case TCA_FLOWER_KEY_ENC_OPT_GTP_QFI:
+		{
+			__u8 qfi;
+
+			if (!strlen(token))
+				break;
+			err = get_u8(&qfi, token, 16);
+			if (err)
+				return err;
+			addattr8(n, MAX_MSG, arg, qfi);
+			break;
+		}
+		default:
+			fprintf(stderr, "Unknown \"gtp_opts\" type\n");
+			return -1;
+		}
+		token = strsep(&str, ":");
+	}
+	addattr_nest_end(n, nest);
+
+	return 0;
+}
+
 static int flower_parse_geneve_opts(char *str, struct nlmsghdr *n)
 {
 	char *token;
@@ -1205,6 +1251,41 @@ static int flower_parse_enc_opts_erspan(char *str, struct nlmsghdr *n)
 	return 0;
 }
 
+static int flower_parse_enc_opts_gtp(char *str, struct nlmsghdr *n)
+{
+	char key[XATTR_SIZE_MAX], mask[XATTR_SIZE_MAX];
+	struct rtattr *nest;
+	char *slash;
+	int err;
+
+	slash = strchr(str, '/');
+	if (slash) {
+		*slash++ = '\0';
+		if (strlen(slash) > XATTR_SIZE_MAX)
+			return -1;
+		strcpy(mask, slash);
+	} else
+		strcpy(mask, "ff:ff");
+
+	if (strlen(str) > XATTR_SIZE_MAX)
+		return -1;
+	strcpy(key, str);
+
+	nest = addattr_nest(n, MAX_MSG, TCA_FLOWER_KEY_ENC_OPTS | NLA_F_NESTED);
+	err = flower_parse_gtp_opt(key, n);
+	if (err)
+		return err;
+	addattr_nest_end(n, nest);
+
+	nest = addattr_nest(n, MAX_MSG, TCA_FLOWER_KEY_ENC_OPTS_MASK | NLA_F_NESTED);
+	err = flower_parse_gtp_opt(mask, n);
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
@@ -1857,6 +1938,13 @@ static int flower_parse_opt(struct filter_util *qu, char *handle,
 				fprintf(stderr, "Illegal \"erspan_opts\"\n");
 				return -1;
 			}
+		} else if (matches(*argv, "gtp_opts") == 0) {
+			NEXT_ARG();
+			ret = flower_parse_enc_opts_gtp(*argv, n);
+			if (ret < 0) {
+				fprintf(stderr, "Illegal \"gtp_opts\"\n");
+				return -1;
+			}
 		} else if (matches(*argv, "action") == 0) {
 			NEXT_ARG();
 			ret = parse_action(&argc, &argv, TCA_FLOWER_ACT, n);
@@ -2342,6 +2430,28 @@ static void flower_print_erspan_opts(const char *name, struct rtattr *attr,
 	sprintf(strbuf, "%u:%u:%u:%u", ver, idx, dir, hwid);
 }
 
+static void flower_print_gtp_opts(const char *name, struct rtattr *attr,
+				  char *strbuf)
+{
+	struct rtattr *tb[TCA_FLOWER_KEY_ENC_OPT_GTP_MAX + 1];
+	__u8 pdu_type, qfi;
+
+	parse_rtattr(tb, TCA_FLOWER_KEY_ENC_OPT_GTP_MAX, RTA_DATA(attr),
+		     RTA_PAYLOAD(attr));
+
+	pdu_type = rta_getattr_u8(tb[TCA_FLOWER_KEY_ENC_OPT_GTP_PDU_TYPE]);
+	qfi = rta_getattr_u8(tb[TCA_FLOWER_KEY_ENC_OPT_GTP_QFI]);
+
+	open_json_array(PRINT_JSON, name);
+	open_json_object(NULL);
+	print_uint(PRINT_JSON, "pdu_type", NULL, pdu_type);
+	print_uint(PRINT_JSON, "qfi", NULL, qfi);
+	close_json_object();
+	close_json_array(PRINT_JSON, name);
+
+	sprintf(strbuf, "%02x:%02x", pdu_type, qfi);
+}
+
 static void flower_print_enc_parts(const char *name, const char *namefrm,
 				   struct rtattr *attr, char *key, char *mask)
 {
@@ -2418,6 +2528,16 @@ static void flower_print_enc_opts(const char *name, struct rtattr *attr,
 
 		flower_print_enc_parts(name, "  erspan_opts %s", attr, key,
 				       msk);
+	} else if (key_tb[TCA_FLOWER_KEY_ENC_OPTS_GTP]) {
+		flower_print_gtp_opts("gtp_opt_key",
+				      key_tb[TCA_FLOWER_KEY_ENC_OPTS_GTP], key);
+
+		if (msk_tb[TCA_FLOWER_KEY_ENC_OPTS_GTP])
+			flower_print_gtp_opts("gtp_opt_mask",
+					      msk_tb[TCA_FLOWER_KEY_ENC_OPTS_GTP], msk);
+
+		flower_print_enc_parts(name, "  gtp_opts %s", attr, key,
+				       msk);
 	}
 
 	free(msk);
-- 
2.31.1

