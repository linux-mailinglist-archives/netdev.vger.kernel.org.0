Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56CDE4DAEB2
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 12:12:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355258AbiCPLNZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 07:13:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243826AbiCPLNX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 07:13:23 -0400
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEB7564BC6
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 04:12:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647429129; x=1678965129;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fYeTnsETI7IB641Ohm9kjQEUQBx0F0j/47UmyRJ0ztM=;
  b=LRnQtHTnI9G+UevCRc83CBx2wwtgFVdlR9hQQq34J1OopmhiZ+u8/GMM
   McWFrAfDaUc+tT2dApPdmbU7izimeElaKYih8BsRuj7jCmNEe0yTKmqtv
   gy25UMVLRnchI0RRJWEogGJrTqcUXr6A/XiXH6O1sYVA+LPOoVf++UuDA
   slz2A0mCSUObqcgcMjYeEEiLbTxnnbKPPqmtuJCwxEaskvK16LpLKjWz3
   6oStAu9Oi1QlDUJHy0MhnHf0TrUYMChBPX5S7jiFzqHfRjXrDOtX1JJfR
   C2hvNSgAuZXgS+E200KAvqIkBE3vd5AUDGsZCum17wcOgyyZ8aJDKw9UF
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10286"; a="317273421"
X-IronPort-AV: E=Sophos;i="5.90,186,1643702400"; 
   d="scan'208";a="317273421"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2022 04:12:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,186,1643702400"; 
   d="scan'208";a="498393803"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga003.jf.intel.com with ESMTP; 16 Mar 2022 04:12:08 -0700
Received: from switcheroo.igk.intel.com (switcheroo.igk.intel.com [172.22.229.137])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 22GBC69X016809;
        Wed, 16 Mar 2022 11:12:07 GMT
From:   Wojciech Drewek <wojciech.drewek@intel.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org
Subject: [PATCH iproute2-next v5 2/2] f_flower: Implement gtp options support
Date:   Wed, 16 Mar 2022 12:08:15 +0100
Message-Id: <20220316110815.46779-3-wojciech.drewek@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220316110815.46779-1-wojciech.drewek@intel.com>
References: <20220316110815.46779-1-wojciech.drewek@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
v2: use SPDX tag, use strcmp() instead of matches(), parse
    IFLA_GTP_RESTART_COUNT arg
v3: IFLA_GTP_CREATE_SOCKETS attribute introduced, fix options
    alpha order
v5: add gtp_opts to explain function
---
 include/uapi/linux/pkt_cls.h |  16 +++++
 man/man8/tc-flower.8         |  10 +++
 tc/f_flower.c                | 123 ++++++++++++++++++++++++++++++++++-
 3 files changed, 147 insertions(+), 2 deletions(-)

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
index ad159719c05f..a541031f5a10 100644
--- a/tc/f_flower.c
+++ b/tc/f_flower.c
@@ -84,6 +84,7 @@ static void explain(void)
 		"			geneve_opts MASKED-OPTIONS |\n"
 		"			vxlan_opts MASKED-OPTIONS |\n"
 		"                       erspan_opts MASKED-OPTIONS |\n"
+		"			gtp_opts MASKED-OPTIONS |\n"
 		"			ip_flags IP-FLAGS |\n"
 		"			enc_dst_port [ port_number ] |\n"
 		"			ct_state MASKED_CT_STATE |\n"
@@ -1034,6 +1035,52 @@ static int flower_parse_erspan_opt(char *str, struct nlmsghdr *n)
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
@@ -1217,6 +1264,41 @@ static int flower_parse_enc_opts_erspan(char *str, struct nlmsghdr *n)
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
@@ -1869,6 +1951,13 @@ static int flower_parse_opt(struct filter_util *qu, char *handle,
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
@@ -2338,6 +2427,21 @@ static void flower_print_erspan_opts(const char *name, struct rtattr *attr,
 	sprintf(strbuf, "%u:%u:%u:%u", ver, idx, dir, hwid);
 }
 
+static void flower_print_gtp_opts(const char *name, struct rtattr *attr,
+				  char *strbuf, int len)
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
+	snprintf(strbuf, len, "%02x:%02x", pdu_type, qfi);
+}
+
 static void __attribute__((format(printf, 2, 0)))
 flower_print_enc_parts(const char *name, const char *namefrm,
 		       struct rtattr *attr, char *key, char *mask)
@@ -2370,15 +2474,18 @@ static void flower_print_enc_opts(const char *name, struct rtattr *attr,
 	struct rtattr *key_tb[TCA_FLOWER_KEY_ENC_OPTS_MAX + 1];
 	struct rtattr *msk_tb[TCA_FLOWER_KEY_ENC_OPTS_MAX + 1];
 	char *key, *msk;
+	int len;
 
 	if (!attr)
 		return;
 
-	key = malloc(RTA_PAYLOAD(attr) * 2 + 1);
+	len = RTA_PAYLOAD(attr) * 2 + 1;
+
+	key = malloc(len);
 	if (!key)
 		return;
 
-	msk = malloc(RTA_PAYLOAD(attr) * 2 + 1);
+	msk = malloc(len);
 	if (!msk)
 		goto err_key_free;
 
@@ -2415,6 +2522,18 @@ static void flower_print_enc_opts(const char *name, struct rtattr *attr,
 
 		flower_print_enc_parts(name, "  erspan_opts %s", attr, key,
 				       msk);
+	} else if (key_tb[TCA_FLOWER_KEY_ENC_OPTS_GTP]) {
+		flower_print_gtp_opts("gtp_opt_key",
+				      key_tb[TCA_FLOWER_KEY_ENC_OPTS_GTP],
+				      key, len);
+
+		if (msk_tb[TCA_FLOWER_KEY_ENC_OPTS_GTP])
+			flower_print_gtp_opts("gtp_opt_mask",
+					      msk_tb[TCA_FLOWER_KEY_ENC_OPTS_GTP],
+					      msk, len);
+
+		flower_print_enc_parts(name, "  gtp_opts %s", attr, key,
+				       msk);
 	}
 
 	free(msk);
-- 
2.31.1

