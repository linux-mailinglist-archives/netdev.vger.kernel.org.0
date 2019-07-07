Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A43246147E
	for <lists+netdev@lfdr.de>; Sun,  7 Jul 2019 10:56:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727272AbfGGI4r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jul 2019 04:56:47 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:42146 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727229AbfGGI4r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jul 2019 04:56:47 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from paulb@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 7 Jul 2019 11:56:40 +0300
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (reg-r-vrt-019-180.mtr.labs.mlnx [10.213.19.180])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x678ucJw005552;
        Sun, 7 Jul 2019 11:56:40 +0300
From:   Paul Blakey <paulb@mellanox.com>
To:     Jiri Pirko <jiri@mellanox.com>, Paul Blakey <paulb@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Yossi Kuperman <yossiku@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        Aaron Conole <aconole@redhat.com>,
        Zhike Wang <wangzhike@jd.com>
Cc:     Rony Efraim <ronye@mellanox.com>, nst-kernel@redhat.com,
        John Hurley <john.hurley@netronome.com>,
        Simon Horman <simon.horman@netronome.com>,
        Justin Pettit <jpettit@ovn.org>
Subject: [PATCH net-next iproute2 3/3] tc: flower: Add matching on conntrack info
Date:   Sun,  7 Jul 2019 11:53:48 +0300
Message-Id: <1562489628-5925-4-git-send-email-paulb@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1562489628-5925-1-git-send-email-paulb@mellanox.com>
References: <1562489628-5925-1-git-send-email-paulb@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Matches on conntrack state, zone, mark, and label.

Signed-off-by: Paul Blakey <paulb@mellanox.com>
Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: Yossi Kuperman <yossiku@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Acked-by: Roi Dayan <roid@mellanox.com>
---
 include/uapi/linux/pkt_cls.h |  17 +++
 man/man8/tc-flower.8         |  35 ++++++
 tc/f_flower.c                | 276 ++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 327 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
index 8cc6b67..6992df1 100644
--- a/include/uapi/linux/pkt_cls.h
+++ b/include/uapi/linux/pkt_cls.h
@@ -106,6 +106,7 @@ enum tca_id {
 	TCA_ID_SAMPLE = TCA_ACT_SAMPLE,
 	/* other actions go here */
 	TCA_ID_CTINFO,
+	TCA_ID_CT,
 	__TCA_ID_MAX = 255
 };
 
@@ -535,12 +536,28 @@ enum {
 	TCA_FLOWER_KEY_PORT_DST_MIN,	/* be16 */
 	TCA_FLOWER_KEY_PORT_DST_MAX,	/* be16 */
 
+	TCA_FLOWER_KEY_CT_STATE,	/* u16 */
+	TCA_FLOWER_KEY_CT_STATE_MASK,	/* u16 */
+	TCA_FLOWER_KEY_CT_ZONE,		/* u16 */
+	TCA_FLOWER_KEY_CT_ZONE_MASK,	/* u16 */
+	TCA_FLOWER_KEY_CT_MARK,		/* u32 */
+	TCA_FLOWER_KEY_CT_MARK_MASK,	/* u32 */
+	TCA_FLOWER_KEY_CT_LABELS,	/* u128 */
+	TCA_FLOWER_KEY_CT_LABELS_MASK,	/* u128 */
+
 	__TCA_FLOWER_MAX,
 };
 
 #define TCA_FLOWER_MAX (__TCA_FLOWER_MAX - 1)
 
 enum {
+	TCA_FLOWER_KEY_CT_FLAGS_NEW = 1 << 0, /* Beginning of a new connection. */
+	TCA_FLOWER_KEY_CT_FLAGS_ESTABLISHED = 1 << 1, /* Part of an existing connection. */
+	TCA_FLOWER_KEY_CT_FLAGS_RELATED = 1 << 2, /* Related to an established connection. */
+	TCA_FLOWER_KEY_CT_FLAGS_TRACKED = 1 << 3, /* Conntrack has occurred. */
+};
+
+enum {
 	TCA_FLOWER_KEY_ENC_OPTS_UNSPEC,
 	TCA_FLOWER_KEY_ENC_OPTS_GENEVE, /* Nested
 					 * TCA_FLOWER_KEY_ENC_OPT_GENEVE_
diff --git a/man/man8/tc-flower.8 b/man/man8/tc-flower.8
index adff41e..04ee194 100644
--- a/man/man8/tc-flower.8
+++ b/man/man8/tc-flower.8
@@ -289,6 +289,41 @@ bits is assumed.
 .TQ
 .BI enc_ttl " NUMBER"
 .TQ
+.BR
+.TP
+.BI ct_state " CT_STATE"
+.TQ
+.BI ct_zone " CT_MASKED_ZONE"
+.TQ
+.BI ct_mark " CT_MASKED_MARK"
+.TQ
+.BI ct_label " CT_MASKED_LABEL"
+Matches on connection tracking info
+.RS
+.TP
+.I CT_STATE
+Match the connection state, and can ne combination of [{+|-}flag] flags, where flag can be one of
+.RS
+.TP
+trk - Tracked connection.
+.TP
+new - New connection.
+.TP
+est - Established connection.
+.TP
+Example: +trk+est
+.RE
+.TP
+.I CT_MASKED_ZONE
+Match the connection zone, and can be masked.
+.TP
+.I CT_MASKED_MARK
+32bit match on the connection mark, and can be masked.
+.TP
+.I CT_MASKED_LABEL
+128bit match on the connection label, and can be masked.
+.RE
+.TP
 .BI geneve_opts " OPTIONS"
 Match on IP tunnel metadata. Key id
 .I NUMBER
diff --git a/tc/f_flower.c b/tc/f_flower.c
index 70d40d3..a2a2301 100644
--- a/tc/f_flower.c
+++ b/tc/f_flower.c
@@ -82,9 +82,14 @@ static void explain(void)
 		"			enc_ttl MASKED-IP_TTL |\n"
 		"			geneve_opts MASKED-OPTIONS |\n"
 		"			ip_flags IP-FLAGS | \n"
-		"			enc_dst_port [ port_number ] }\n"
+		"			enc_dst_port [ port_number ] |\n"
+		"			ct_state MASKED_CT_STATE |\n"
+		"			ct_label MASKED_CT_LABEL |\n"
+		"			ct_mark MASKED_CT_MARK |\n"
+		"			ct_zone MASKED_CT_ZONE }\n"
 		"	FILTERID := X:Y:Z\n"
 		"	MASKED_LLADDR := { LLADDR | LLADDR/MASK | LLADDR/BITS }\n"
+		"	MASKED_CT_STATE := combination of {+|-} and flags trk,est,new\n"
 		"	ACTION-SPEC := ... look at individual actions\n"
 		"\n"
 		"NOTE:	CLASSID, IP-PROTO are parsed as hexadecimal input.\n"
@@ -214,6 +219,159 @@ static int flower_parse_matching_flags(char *str,
 	return 0;
 }
 
+static int flower_parse_u16(char *str, int value_type, int mask_type,
+			    struct nlmsghdr *n)
+{
+	__u16 value, mask;
+	char *slash;
+
+	slash = strchr(str, '/');
+	if (slash)
+		*slash = '\0';
+
+	if (get_u16(&value, str, 0))
+		return -1;
+
+	if (slash) {
+		if (get_u16(&mask, slash + 1, 0))
+			return -1;
+	} else {
+		mask = UINT16_MAX;
+	}
+
+	addattr16(n, MAX_MSG, value_type, value);
+	addattr16(n, MAX_MSG, mask_type, mask);
+
+	return 0;
+}
+
+static int flower_parse_u32(char *str, int value_type, int mask_type,
+			    struct nlmsghdr *n)
+{
+	__u32 value, mask;
+	char *slash;
+
+	slash = strchr(str, '/');
+	if (slash)
+		*slash = '\0';
+
+	if (get_u32(&value, str, 0))
+		return -1;
+
+	if (slash) {
+		if (get_u32(&mask, slash + 1, 0))
+			return -1;
+	} else {
+		mask = UINT32_MAX;
+	}
+
+	addattr32(n, MAX_MSG, value_type, value);
+	addattr32(n, MAX_MSG, mask_type, mask);
+
+	return 0;
+}
+
+static int flower_parse_ct_mark(char *str, struct nlmsghdr *n)
+{
+	return flower_parse_u32(str,
+				TCA_FLOWER_KEY_CT_MARK,
+				TCA_FLOWER_KEY_CT_MARK_MASK,
+				n);
+}
+
+static int flower_parse_ct_zone(char *str, struct nlmsghdr *n)
+{
+	return flower_parse_u16(str,
+				TCA_FLOWER_KEY_CT_ZONE,
+				TCA_FLOWER_KEY_CT_ZONE_MASK,
+				n);
+}
+
+static int flower_parse_ct_labels(char *str, struct nlmsghdr *n)
+{
+#define LABELS_SIZE	16
+	uint8_t labels[LABELS_SIZE], lmask[LABELS_SIZE];
+	char *slash, *mask = NULL;
+	size_t slen, slen_mask = 0;
+
+	slash = index(str, '/');
+	if (slash) {
+		*slash = 0;
+		mask = slash + 1;
+		slen_mask = strlen(mask);
+	}
+
+	slen = strlen(str);
+	if (slen > LABELS_SIZE * 2 || slen_mask > LABELS_SIZE * 2) {
+		char errmsg[128];
+
+		snprintf(errmsg, sizeof(errmsg),
+				"%zd Max allowed size %d",
+				slen, LABELS_SIZE*2);
+		invarg(errmsg, str);
+	}
+
+	if (hex2mem(str, labels, slen / 2) < 0)
+		invarg("labels must be a hex string\n", str);
+	addattr_l(n, MAX_MSG, TCA_FLOWER_KEY_CT_LABELS, labels, slen / 2);
+
+	if (mask) {
+		if (hex2mem(mask, lmask, slen_mask / 2) < 0)
+			invarg("labels mask must be a hex string\n", mask);
+	} else {
+		memset(lmask, 0xff, sizeof(lmask));
+		slen_mask = sizeof(lmask) * 2;
+	}
+	addattr_l(n, MAX_MSG, TCA_FLOWER_KEY_CT_LABELS_MASK, lmask,
+		  slen_mask / 2);
+
+	return 0;
+}
+
+static struct flower_ct_states {
+	char *str;
+	int flag;
+} flower_ct_states[] = {
+	{ "trk", TCA_FLOWER_KEY_CT_FLAGS_TRACKED },
+	{ "new", TCA_FLOWER_KEY_CT_FLAGS_NEW },
+	{ "est", TCA_FLOWER_KEY_CT_FLAGS_ESTABLISHED },
+};
+
+static int flower_parse_ct_state(char *str, struct nlmsghdr *n)
+{
+	int flags = 0, mask = 0,  len, i;
+	bool p;
+
+	while (*str != '\0') {
+		if (*str == '+')
+			p = true;
+		else if (*str == '-')
+			p = false;
+		else
+			return -1;
+
+		for (i = 0; i < ARRAY_SIZE(flower_ct_states); i++) {
+			len = strlen(flower_ct_states[i].str);
+			if (strncmp(str + 1, flower_ct_states[i].str, len))
+				continue;
+
+			if (p)
+				flags |= flower_ct_states[i].flag;
+			mask |= flower_ct_states[i].flag;
+			break;
+		}
+
+		if (i == ARRAY_SIZE(flower_ct_states))
+			return -1;
+
+		str += len + 1;
+	}
+
+	addattr16(n, MAX_MSG, TCA_FLOWER_KEY_CT_STATE, flags);
+	addattr16(n, MAX_MSG, TCA_FLOWER_KEY_CT_STATE_MASK, mask);
+	return 0;
+}
+
 static int flower_parse_ip_proto(char *str, __be16 eth_type, int type,
 				 __u8 *p_ip_proto, struct nlmsghdr *n)
 {
@@ -898,6 +1056,34 @@ static int flower_parse_opt(struct filter_util *qu, char *handle,
 			flags |= TCA_CLS_FLAGS_SKIP_HW;
 		} else if (matches(*argv, "skip_sw") == 0) {
 			flags |= TCA_CLS_FLAGS_SKIP_SW;
+		} else if (matches(*argv, "ct_state") == 0) {
+			NEXT_ARG();
+			ret = flower_parse_ct_state(*argv, n);
+			if (ret < 0) {
+				fprintf(stderr, "Illegal \"ct_state\"\n");
+				return -1;
+			}
+		} else if (matches(*argv, "ct_zone") == 0) {
+			NEXT_ARG();
+			ret = flower_parse_ct_zone(*argv, n);
+			if (ret < 0) {
+				fprintf(stderr, "Illegal \"ct_zone\"\n");
+				return -1;
+			}
+		} else if (matches(*argv, "ct_mark") == 0) {
+			NEXT_ARG();
+			ret = flower_parse_ct_mark(*argv, n);
+			if (ret < 0) {
+				fprintf(stderr, "Illegal \"ct_mark\"\n");
+				return -1;
+			}
+		} else if (matches(*argv, "ct_label") == 0) {
+			NEXT_ARG();
+			ret = flower_parse_ct_labels(*argv, n);
+			if (ret < 0) {
+				fprintf(stderr, "Illegal \"ct_label\"\n");
+				return -1;
+			}
 		} else if (matches(*argv, "indev") == 0) {
 			NEXT_ARG();
 			if (check_ifname(*argv))
@@ -1590,6 +1776,85 @@ static void flower_print_tcp_flags(const char *name, struct rtattr *flags_attr,
 	print_string(PRINT_ANY, name, namefrm, out);
 }
 
+static void flower_print_ct_state(struct rtattr *flags_attr,
+				  struct rtattr *mask_attr)
+{
+	SPRINT_BUF(out);
+	uint16_t state;
+	uint16_t state_mask;
+	size_t done = 0;
+	int i;
+
+	if (!flags_attr)
+		return;
+
+	state = rta_getattr_u16(flags_attr);
+	if (mask_attr)
+		state_mask = rta_getattr_u16(mask_attr);
+	else
+		state_mask = UINT16_MAX;
+
+	for (i = 0; i < ARRAY_SIZE(flower_ct_states); i++) {
+		if (!(state_mask & flower_ct_states[i].flag))
+			continue;
+
+		if (state & flower_ct_states[i].flag)
+			done += sprintf(out + done, "+%s",
+					flower_ct_states[i].str);
+		else
+			done += sprintf(out + done, "-%s",
+					flower_ct_states[i].str);
+	}
+
+	print_string(PRINT_ANY, "ct_state", "\n  ct_state %s", out);
+}
+
+static void flower_print_ct_label(struct rtattr *attr,
+				  struct rtattr *mask_attr)
+{
+	const unsigned char *str;
+	bool print_mask = false;
+	int data_len, i;
+	SPRINT_BUF(out);
+	char *p;
+
+	if (!attr)
+		return;
+
+	data_len = RTA_PAYLOAD(attr);
+	hexstring_n2a(RTA_DATA(attr), data_len, out, sizeof(out));
+	p = out + data_len*2;
+
+	data_len = RTA_PAYLOAD(attr);
+	str = RTA_DATA(mask_attr);
+	if (data_len != 16)
+		print_mask = true;
+	for (i = 0; !print_mask && i < data_len; i++) {
+		if (str[i] != 0xff)
+			print_mask = true;
+	}
+	if (print_mask) {
+		*p++ = '/';
+		hexstring_n2a(RTA_DATA(mask_attr), data_len, p,
+			      sizeof(out)-(p-out));
+		p += data_len*2;
+	}
+	*p = '\0';
+
+	print_string(PRINT_ANY, "ct_label", "\n  ct_label %s", out);
+}
+
+static void flower_print_ct_zone(struct rtattr *attr,
+				 struct rtattr *mask_attr)
+{
+	print_masked_u16("ct_zone", attr, mask_attr);
+}
+
+static void flower_print_ct_mark(struct rtattr *attr,
+				 struct rtattr *mask_attr)
+{
+	print_masked_u32("ct_mark", attr, mask_attr);
+}
 
 static void flower_print_key_id(const char *name, struct rtattr *attr)
 {
@@ -1949,6 +2214,15 @@ static int flower_print_opt(struct filter_util *qu, FILE *f,
 				    tb[TCA_FLOWER_KEY_FLAGS],
 				    tb[TCA_FLOWER_KEY_FLAGS_MASK]);
 
+	flower_print_ct_state(tb[TCA_FLOWER_KEY_CT_STATE],
+			      tb[TCA_FLOWER_KEY_CT_STATE_MASK]);
+	flower_print_ct_zone(tb[TCA_FLOWER_KEY_CT_ZONE],
+			     tb[TCA_FLOWER_KEY_CT_ZONE_MASK]);
+	flower_print_ct_mark(tb[TCA_FLOWER_KEY_CT_MARK],
+			     tb[TCA_FLOWER_KEY_CT_MARK_MASK]);
+	flower_print_ct_label(tb[TCA_FLOWER_KEY_CT_LABELS],
+			      tb[TCA_FLOWER_KEY_CT_LABELS_MASK]);
+
 	close_json_object();
 
 	if (tb[TCA_FLOWER_FLAGS]) {
-- 
1.8.3.1

