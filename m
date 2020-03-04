Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCA591799BF
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 21:26:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388343AbgCDU0F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 15:26:05 -0500
Received: from mx2.suse.de ([195.135.220.15]:33782 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388327AbgCDU0F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Mar 2020 15:26:05 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id BFBA9B2A4;
        Wed,  4 Mar 2020 20:26:01 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 6D2E1E037F; Wed,  4 Mar 2020 21:26:01 +0100 (CET)
Message-Id: <85121f2a8fc0a04c2109936d48c926c465054b00.1583347351.git.mkubecek@suse.cz>
In-Reply-To: <cover.1583347351.git.mkubecek@suse.cz>
References: <cover.1583347351.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ethtool v2 17/25] netlink: add bitset command line parser
 handlers
To:     John Linville <linville@tuxdriver.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Date:   Wed,  4 Mar 2020 21:26:01 +0100 (CET)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add three more command line parser handlers for different representation of
bitsets:

  - series of "name on|off" pairs for bitset with mask
  - series of names for bitsets without mask (lists)
  - string consisting of characters representing bits (e.g. WoL modes);
    extended syntax "([+-][a-z])+" is supported for bitsets with mask

Numeric syntax %u[/%u] is also supported.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 netlink/parser.c | 443 +++++++++++++++++++++++++++++++++++++++++++++++
 netlink/parser.h |  21 +++
 2 files changed, 464 insertions(+)

diff --git a/netlink/parser.c b/netlink/parser.c
index 0e2190eed0b4..40eb4a5c0b26 100644
--- a/netlink/parser.c
+++ b/netlink/parser.c
@@ -43,6 +43,12 @@ static void parser_err_invalid_value(struct nl_context *nlctx, const char *val)
 		nlctx->cmd, val, nlctx->param);
 }
 
+static void parser_err_invalid_flag(struct nl_context *nlctx, const char *flag)
+{
+	fprintf(stderr, "ethtool (%s): flag '%s' for parameter '%s' is not followed by 'on' or 'off'\n",
+		nlctx->cmd, flag, nlctx->param);
+}
+
 static bool __prefix_0x(const char *p)
 {
 	return p[0] == '0' && (p[1] == 'x' || p[1] == 'X');
@@ -282,6 +288,35 @@ int nl_parse_lookup_u8(struct nl_context *nlctx, uint16_t type,
 	return (type && ethnla_put_u8(msgbuff, type, val)) ? -EMSGSIZE : 0;
 }
 
+/* number of significant bits */
+static unsigned int __nsb(uint32_t x)
+{
+	unsigned int ret = 0;
+
+	if (x & 0xffff0000U) {
+		x >>= 16;
+		ret += 16;
+	}
+	if (x & 0xff00U) {
+		x >>= 8;
+		ret += 8;
+	}
+	if (x & 0xf0U) {
+		x >>= 4;
+		ret += 4;
+	}
+	if (x & 0xcU) {
+		x >>= 2;
+		ret += 2;
+	}
+	if (x & 0x2U) {
+		x >>= 1;
+		ret += 1;
+	}
+
+	return ret + x;
+}
+
 static bool __is_hex(char c)
 {
 	if (isdigit(c))
@@ -405,6 +440,414 @@ int nl_parse_error(struct nl_context *nlctx, uint16_t type, const void *data,
 	return parser_data->ret_val;
 }
 
+/* bitset parser handlers */
+
+/* Return true if a bitset argument should be parsed as numeric, i.e.
+ * (a) it starts with '0x'
+ * (b) it consists only of hex digits and at most one slash which can be
+ *     optionally followed by "0x"; if no_mask is true, slash is not allowed
+ */
+static bool is_numeric_bitset(const char *arg, bool no_mask)
+{
+	const char *p = arg;
+	bool has_slash = false;
+
+	if (!arg)
+		return false;
+	if (__prefix_0x(arg))
+		return true;
+	while (*p) {
+		if (*p == '/') {
+			if (has_slash || no_mask)
+				return false;
+			has_slash = true;
+			p++;
+			if (__prefix_0x(p))
+				p += 2;
+			continue;
+		}
+		if (!__is_hex(*p))
+			return false;
+		p++;
+	}
+	return true;
+}
+
+#define __MAX_U32_DIGITS 10
+
+/* Parse hex string (without leading "0x") into a bitmap consisting of 32-bit
+ * words. Caller must make sure arg is at least len characters long and dst has
+ * place for at least (len + 7) / 8 32-bit words. If force_hex is false, allow
+ * also base 10 unsigned 32-bit value.
+ *
+ * Returns number of significant bits in the bitmap on success and negative
+ * value on error.
+ */
+static int __parse_num_string(const char *arg, unsigned int len, uint32_t *dst,
+			      bool force_hex)
+{
+	char buff[__MAX_U32_DIGITS + 1] = {};
+	unsigned int nbits = 0;
+	const char *p = arg;
+
+	if (!len)
+		return -EINVAL;
+	if (!force_hex && len <= __MAX_U32_DIGITS) {
+		strncpy(buff, arg, len);
+		if (!buff[__MAX_U32_DIGITS]) {
+			u32 val;
+			int ret;
+
+			ret = parse_u32d(buff, &val);
+			if (!ret) {
+				*dst = val;
+				return __nsb(val);
+			}
+		}
+	}
+
+	dst += (len - 1) / 8;
+	while (len > 0) {
+		unsigned int chunk = (len % 8) ?: 8;
+		unsigned long val;
+		char *endp;
+
+		memcpy(buff, p, chunk);
+		buff[chunk] = '\0';
+		val = strtoul(buff, &endp, 16);
+		if (*endp)
+			return -EINVAL;
+		*dst-- = (uint32_t)val;
+		if (nbits)
+			nbits += 4 * chunk;
+		else
+			nbits = __nsb(val);
+
+		p += chunk;
+		len -= chunk;
+	}
+	return nbits;
+}
+
+/* Parse bitset provided as a base 16 numeric value (@no_mask is true) or pair
+ * of base 16 numeric values  separated by '/' (@no_mask is false). The "0x"
+ * prefix is optional. Generates bitset nested attribute in compact form.
+ */
+static int parse_numeric_bitset(struct nl_context *nlctx, uint16_t type,
+				bool no_mask, bool force_hex,
+				struct nl_msg_buff *msgbuff)
+{
+	unsigned int nwords, len1, len2;
+	const char *arg = *nlctx->argp;
+	bool force_hex1 = force_hex;
+	bool force_hex2 = force_hex;
+	uint32_t *value = NULL;
+	uint32_t *mask = NULL;
+	struct nlattr *nest;
+	const char *maskptr;
+	int ret = 0;
+	int nbits;
+
+	if (__prefix_0x(arg)) {
+		force_hex1 = true;
+		arg += 2;
+	}
+
+	maskptr = strchr(arg, '/');
+	if (maskptr && no_mask) {
+		parser_err_invalid_value(nlctx, arg);
+		return -EINVAL;
+	}
+	len1 = maskptr ? (maskptr - arg) : strlen(arg);
+	nwords = DIV_ROUND_UP(len1, 8);
+	nbits = 0;
+
+	if (maskptr) {
+		maskptr++;
+		if (__prefix_0x(maskptr)) {
+			maskptr += 2;
+			force_hex2 = true;
+		}
+		len2 = strlen(maskptr);
+		if (len2 > len1)
+			nwords = DIV_ROUND_UP(len2, 8);
+		mask = calloc(nwords, sizeof(uint32_t));
+		if (!mask)
+			return -ENOMEM;
+		ret = __parse_num_string(maskptr, strlen(maskptr), mask,
+					 force_hex2);
+		if (ret < 0) {
+			parser_err_invalid_value(nlctx, arg);
+			goto out_free;
+		}
+		nbits = ret;
+	}
+
+	value = calloc(nwords, sizeof(uint32_t));
+	if (!value)
+		return -ENOMEM;
+	ret = __parse_num_string(arg, len1, value, force_hex1);
+	if (ret < 0) {
+		parser_err_invalid_value(nlctx, arg);
+		goto out_free;
+	}
+	nbits = (nbits < ret) ? ret : nbits;
+	nwords = (nbits + 31) / 32;
+
+	ret = 0;
+	if (!type)
+		goto out_free;
+	ret = -EMSGSIZE;
+	nest = ethnla_nest_start(msgbuff, type);
+	if (!nest)
+	       goto out_free;
+	if (ethnla_put_flag(msgbuff, ETHTOOL_A_BITSET_NOMASK, !mask) ||
+	    ethnla_put_u32(msgbuff, ETHTOOL_A_BITSET_SIZE, nbits) ||
+	    ethnla_put(msgbuff, ETHTOOL_A_BITSET_VALUE,
+		       nwords * sizeof(uint32_t), value) ||
+	    (mask &&
+	     ethnla_put(msgbuff, ETHTOOL_A_BITSET_MASK,
+			nwords * sizeof(uint32_t), mask)))
+		goto out_free;
+	ethnla_nest_end(msgbuff, nest);
+	ret = 0;
+
+out_free:
+	free(value);
+	free(mask);
+	nlctx->argp++;
+	nlctx->argc--;
+	return ret;
+}
+
+/* Parse bitset provided as series of "name on|off" pairs (@no_mask is false)
+ * or names (@no_mask is true). Generates bitset nested attribute in verbose
+ * form with names from command line.
+ */
+static int parse_name_bitset(struct nl_context *nlctx, uint16_t type,
+			     bool no_mask, struct nl_msg_buff *msgbuff)
+{
+	struct nlattr *bitset_attr;
+	struct nlattr *bits_attr;
+	struct nlattr *bit_attr;
+	int ret;
+
+	bitset_attr = ethnla_nest_start(msgbuff, type);
+	if (!bitset_attr)
+		return -EMSGSIZE;
+	ret = -EMSGSIZE;
+	if (no_mask && ethnla_put_flag(msgbuff, ETHTOOL_A_BITSET_NOMASK, true))
+		goto err;
+	bits_attr = ethnla_nest_start(msgbuff, ETHTOOL_A_BITSET_BITS);
+	if (!bits_attr)
+		goto err;
+
+	while (nlctx->argc > 0) {
+		bool bit_val = true;
+
+		if (!strcmp(*nlctx->argp, "--")) {
+			nlctx->argp++;
+			nlctx->argc--;
+			break;
+		}
+		ret = -EINVAL;
+		if (!no_mask) {
+			if (nlctx->argc < 2 ||
+			    (strcmp(nlctx->argp[1], "on") &&
+			     strcmp(nlctx->argp[1], "off"))) {
+				parser_err_invalid_flag(nlctx, *nlctx->argp);
+				goto err;
+			}
+			bit_val = !strcmp(nlctx->argp[1], "on");
+		}
+
+		ret = -EMSGSIZE;
+		bit_attr = ethnla_nest_start(msgbuff,
+					     ETHTOOL_A_BITSET_BITS_BIT);
+		if (!bit_attr)
+			goto err;
+		if (ethnla_put_strz(msgbuff, ETHTOOL_A_BITSET_BIT_NAME,
+				    nlctx->argp[0]))
+			goto err;
+		if (!no_mask &&
+		    ethnla_put_flag(msgbuff, ETHTOOL_A_BITSET_BIT_VALUE,
+				    bit_val))
+			goto err;
+		ethnla_nest_end(msgbuff, bit_attr);
+
+		nlctx->argp += (no_mask ? 1 : 2);
+		nlctx->argc -= (no_mask ? 1 : 2);
+	}
+
+	ethnla_nest_end(msgbuff, bits_attr);
+	ethnla_nest_end(msgbuff, bitset_attr);
+	return 0;
+err:
+	ethnla_nest_cancel(msgbuff, bitset_attr);
+	return ret;
+}
+
+static bool is_char_bitset(const char *arg,
+			   const struct char_bitset_parser_data *data)
+{
+	bool mask = (arg[0] == '+' || arg[0] == '-');
+	unsigned int i;
+	const char *p;
+
+	for (p = arg; *p; p++) {
+		if (*p == data->reset_char)
+			continue;
+		if (mask && (*p == '+' || *p == '-'))
+			continue;
+		for (i = 0; i < data->nbits; i++)
+			if (*p == data->bit_chars[i])
+				goto found;
+		return false;
+found:
+		;
+	}
+
+	return true;
+}
+
+/* Parse bitset provided as a string consisting of characters corresponding to
+ * bit indices. The "reset character" resets the no-mask bitset to empty. If
+ * the first character is '+' or '-', generated bitset has mask and '+' and
+ * '-' switch between enabling and disabling the following bits (i.e. their
+ * value being true/false). In such case, "reset character" is not allowed.
+ */
+static int parse_char_bitset(struct nl_context *nlctx, uint16_t type,
+			     const struct char_bitset_parser_data *data,
+			     struct nl_msg_buff *msgbuff)
+{
+	const char *arg = *nlctx->argp;
+	struct nlattr *bitset_attr;
+	struct nlattr *saved_pos;
+	struct nlattr *bits_attr;
+	struct nlattr *bit_attr;
+	unsigned int idx;
+	bool val = true;
+	const char *p;
+	bool no_mask;
+	int ret;
+
+	no_mask = data->no_mask || !(arg[0] == '+' || arg[0] == '-');
+	bitset_attr = ethnla_nest_start(msgbuff, type);
+	if (!bitset_attr)
+		return -EMSGSIZE;
+	ret = -EMSGSIZE;
+	if (no_mask && ethnla_put_flag(msgbuff, ETHTOOL_A_BITSET_NOMASK, true))
+		goto err;
+	bits_attr = ethnla_nest_start(msgbuff, ETHTOOL_A_BITSET_BITS);
+	if (!bits_attr)
+		goto err;
+	saved_pos = mnl_nlmsg_get_payload_tail(msgbuff->nlhdr);
+
+	for (p = arg; *p; p++) {
+		if (*p == '+' || *p == '-') {
+			if (no_mask) {
+				parser_err_invalid_value(nlctx, arg);
+				ret = -EINVAL;
+				goto err;
+			}
+			val = (*p == '+');
+			continue;
+		}
+		if (*p == data->reset_char) {
+			if (no_mask) {
+				mnl_attr_nest_cancel(msgbuff->nlhdr, saved_pos);
+				continue;
+			}
+			fprintf(stderr, "ethtool (%s): invalid char '%c' in '%s' for parameter '%s'\n",
+				nlctx->cmd, *p, arg, nlctx->param);
+			ret = -EINVAL;
+			goto err;
+		}
+
+		for (idx = 0; idx < data->nbits; idx++) {
+			if (data->bit_chars[idx] == *p)
+				break;
+		}
+		if (idx >= data->nbits) {
+			fprintf(stderr, "ethtool (%s): invalid char '%c' in '%s' for parameter '%s'\n",
+				nlctx->cmd, *p, arg, nlctx->param);
+			ret = -EINVAL;
+			goto err;
+		}
+		bit_attr = ethnla_nest_start(msgbuff,
+					     ETHTOOL_A_BITSET_BITS_BIT);
+		if (!bit_attr)
+			goto err;
+		if (ethnla_put_u32(msgbuff, ETHTOOL_A_BITSET_BIT_INDEX, idx))
+			goto err;
+		if (!no_mask &&
+		    ethnla_put_flag(msgbuff, ETHTOOL_A_BITSET_BIT_VALUE, val))
+			goto err;
+		ethnla_nest_end(msgbuff, bit_attr);
+	}
+
+	ethnla_nest_end(msgbuff, bits_attr);
+	ethnla_nest_end(msgbuff, bitset_attr);
+	nlctx->argp++;
+	nlctx->argc--;
+	return 0;
+err:
+	ethnla_nest_cancel(msgbuff, bitset_attr);
+	return ret;
+}
+
+/* Parser handler for bitset. Expects either a numeric value (base 16 or 10
+ * (unless force_hex is set)), optionally followed by '/' and another numeric
+ * value (mask, unless no_mask is set), or a series of "name on|off" pairs
+ * (no_mask not set) or names (no_mask set). In the latter case, names are
+ * passed on as they are and kernel performs their interpretation and
+ * validation. The @data parameter points to struct bitset_parser_data.
+ * Generates only a bitset nested attribute. Fails if @type is zero or @dest
+ * is not null.
+ */
+int nl_parse_bitset(struct nl_context *nlctx, uint16_t type, const void *data,
+		    struct nl_msg_buff *msgbuff, void *dest)
+{
+	const struct bitset_parser_data *parser_data = data;
+
+	if (!type || dest) {
+		fprintf(stderr, "ethtool (%s): internal error parsing '%s'\n",
+			nlctx->cmd, nlctx->param);
+		return -EFAULT;
+	}
+	if (is_numeric_bitset(*nlctx->argp, false))
+		return parse_numeric_bitset(nlctx, type, parser_data->no_mask,
+					    parser_data->force_hex, msgbuff);
+	else
+		return parse_name_bitset(nlctx, type, parser_data->no_mask,
+					 msgbuff);
+}
+
+/* Parser handler for bitset. Expects either a numeric value (base 10 or 16),
+ * optionally followed by '/' and another numeric value (mask, unless no_mask
+ * is set), or a string consisting of characters corresponding to bit indices.
+ * The @data parameter points to struct char_bitset_parser_data. Generates
+ * biset nested attribute. Fails if type is zero or if @dest is not null.
+ */
+int nl_parse_char_bitset(struct nl_context *nlctx, uint16_t type,
+			 const void *data, struct nl_msg_buff *msgbuff,
+			 void *dest)
+{
+	const struct char_bitset_parser_data *parser_data = data;
+
+	if (!type || dest) {
+		fprintf(stderr, "ethtool (%s): internal error parsing '%s'\n",
+			nlctx->cmd, nlctx->param);
+		return -EFAULT;
+	}
+	if (is_char_bitset(*nlctx->argp, data) ||
+	    !is_numeric_bitset(*nlctx->argp, false))
+		return parse_char_bitset(nlctx, type, parser_data, msgbuff);
+	else
+		return parse_numeric_bitset(nlctx, type, parser_data->no_mask,
+					    false, msgbuff);
+}
+
 /* parser implementation */
 
 static const struct param_parser *find_parser(const struct param_parser *params,
diff --git a/netlink/parser.h b/netlink/parser.h
index b5e8cd418b50..3cc26d21916c 100644
--- a/netlink/parser.h
+++ b/netlink/parser.h
@@ -79,6 +79,20 @@ struct error_parser_data {
 	unsigned int	extra_args;
 };
 
+/* used by nl_parse_bitset() */
+struct bitset_parser_data {
+	bool		force_hex;
+	bool		no_mask;
+};
+
+/* used by nl_parse_char_bitset() */
+struct char_bitset_parser_data {
+	const char	*bit_chars;
+	unsigned int	nbits;
+	char		reset_char;
+	bool		no_mask;
+};
+
 int parse_u32(const char *arg, uint32_t *result);
 
 /* parser handlers to use as param_parser::handler */
@@ -115,6 +129,13 @@ int nl_parse_error(struct nl_context *nlctx, uint16_t type, const void *data,
 int nl_parse_byte_str(struct nl_context *nlctx, uint16_t type,
 		      const void *data, struct nl_msg_buff *msgbuff,
 		      void *dest);
+/* bitset represented by %x[/%x] or name on|off ... [--] */
+int nl_parse_bitset(struct nl_context *nlctx, uint16_t type, const void *data,
+		    struct nl_msg_buff *msgbuff, void *dest);
+/* bitset represented by %u[/%u] or string (characters for bits) */
+int nl_parse_char_bitset(struct nl_context *nlctx, uint16_t type,
+			 const void *data, struct nl_msg_buff *msgbuff,
+			 void *dest);
 
 /* main entry point called to parse the command line */
 int nl_parser(struct nl_context *nlctx, const struct param_parser *params,
-- 
2.25.1

