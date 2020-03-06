Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A54FE17C392
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 18:05:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727195AbgCFRFZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 12:05:25 -0500
Received: from mx2.suse.de ([195.135.220.15]:43760 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727066AbgCFRFY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Mar 2020 12:05:24 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 7B974AEF8;
        Fri,  6 Mar 2020 17:05:20 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 20754E00E7; Fri,  6 Mar 2020 18:05:20 +0100 (CET)
Message-Id: <7ec07fe56010053a402c3507edf224679d32bbc6.1583513281.git.mkubecek@suse.cz>
In-Reply-To: <cover.1583513281.git.mkubecek@suse.cz>
References: <cover.1583513281.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ethtool v3 16/25] netlink: add basic command line parsing
 helpers
To:     John Linville <linville@tuxdriver.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Date:   Fri,  6 Mar 2020 18:05:20 +0100 (CET)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Existing command line parser functions from the ioctl interface are often
too closely tied to the ioctl data structures and would not be easily
adapted to generating netlink messages. Introduce a new parser framework
which assigns parser handlers to parameters and provide basic handlers for
most common parameter types:

  - flag represented by presence of a parameter
  - u8 bool represented by name followed by "on" or "off"
  - string represented by string argument
  - u32 represented by numeric argument
  - u8 represented by numeric argument
  - u32 represented by symbolic name (lookup table)
  - u8 represented by symbolic name (lookup table)
  - binary blob represented by MAC-like syntax

Main parser entry point is nl_parse() function; it gets an array of with
entries assigning parser handlers and optional data to command line
parameters and generates corresponding netlink attributes or fills raw
data.

Optionally, attributes can be divided into multiple netlink messages or
multiple nested attributes.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 Makefile.am       |   2 +-
 netlink/netlink.h |   4 +
 netlink/parser.c  | 615 ++++++++++++++++++++++++++++++++++++++++++++++
 netlink/parser.h  | 123 ++++++++++
 4 files changed, 743 insertions(+), 1 deletion(-)
 create mode 100644 netlink/parser.c
 create mode 100644 netlink/parser.h

diff --git a/Makefile.am b/Makefile.am
index eeb36a279045..30cda5b1fc6f 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -29,7 +29,7 @@ ethtool_SOURCES += \
 		  netlink/msgbuff.c netlink/msgbuff.h netlink/nlsock.c \
 		  netlink/nlsock.h netlink/strset.c netlink/strset.h \
 		  netlink/monitor.c netlink/bitset.c netlink/bitset.h \
-		  netlink/settings.c \
+		  netlink/settings.c netlink/parser.c netlink/parser.h \
 		  uapi/linux/ethtool_netlink.h \
 		  uapi/linux/netlink.h uapi/linux/genetlink.h \
 		  uapi/linux/rtnetlink.h uapi/linux/if_link.h
diff --git a/netlink/netlink.h b/netlink/netlink.h
index 730f8e1b3fe9..3ab5f2329e2f 100644
--- a/netlink/netlink.h
+++ b/netlink/netlink.h
@@ -31,6 +31,10 @@ struct nl_context {
 	uint32_t		filter_cmds[CMDMASK_WORDS];
 	const char		*filter_devname;
 	bool			no_banner;
+	const char		*cmd;
+	const char		*param;
+	char			**argp;
+	int			argc;
 };
 
 struct attr_tb_info {
diff --git a/netlink/parser.c b/netlink/parser.c
new file mode 100644
index 000000000000..0e2190eed0b4
--- /dev/null
+++ b/netlink/parser.c
@@ -0,0 +1,615 @@
+/*
+ * parser.c - netlink command line parser
+ *
+ * Implementation of command line parser used by netlink code.
+ */
+
+#include <string.h>
+#include <stdlib.h>
+#include <errno.h>
+#include <ctype.h>
+
+#include "../internal.h"
+#include "../common.h"
+#include "netlink.h"
+#include "parser.h"
+
+static void parser_err_unknown_param(struct nl_context *nlctx)
+{
+	fprintf(stderr, "ethtool (%s): unknown parameter '%s'\n", nlctx->cmd,
+		nlctx->param);
+}
+
+static void parser_err_dup_param(struct nl_context *nlctx)
+{
+	fprintf(stderr, "ethtool (%s): duplicate parameter '%s'\n", nlctx->cmd,
+		nlctx->param);
+}
+
+static void parser_err_min_argc(struct nl_context *nlctx, unsigned int min_argc)
+{
+	if (min_argc == 1)
+		fprintf(stderr, "ethtool (%s): no value for parameter '%s'\n",
+			nlctx->cmd, nlctx->param);
+	else
+		fprintf(stderr,
+			"ethtool (%s): parameter '%s' requires %u words\n",
+			nlctx->cmd, nlctx->param, min_argc);
+}
+
+static void parser_err_invalid_value(struct nl_context *nlctx, const char *val)
+{
+	fprintf(stderr, "ethtool (%s): invalid value '%s' for parameter '%s'\n",
+		nlctx->cmd, val, nlctx->param);
+}
+
+static bool __prefix_0x(const char *p)
+{
+	return p[0] == '0' && (p[1] == 'x' || p[1] == 'X');
+}
+
+static int __parse_u32(const char *arg, uint32_t *result, uint32_t min,
+		       uint32_t max, int base)
+{
+	unsigned long long val;
+	char *endptr;
+
+	if (!arg || !arg[0])
+		return -EINVAL;
+	val = strtoul(arg, &endptr, base);
+	if (*endptr || val < min || val > max)
+		return -EINVAL;
+
+	*result = (uint32_t)val;
+	return 0;
+}
+
+static int parse_u32d(const char *arg, uint32_t *result)
+{
+	return __parse_u32(arg, result, 0, 0xffffffff, 10);
+}
+
+static int parse_x32(const char *arg, uint32_t *result)
+{
+	return __parse_u32(arg, result, 0, 0xffffffff, 16);
+}
+
+int parse_u32(const char *arg, uint32_t *result)
+{
+	if (!arg)
+		return -EINVAL;
+	if (__prefix_0x(arg))
+		return parse_x32(arg + 2, result);
+	else
+		return parse_u32d(arg, result);
+}
+
+static int parse_u8(const char *arg, uint8_t *result)
+{
+	uint32_t val;
+	int ret = parse_u32(arg, &val);
+
+	if (ret < 0)
+		return ret;
+	if (val > UINT8_MAX)
+		return -EINVAL;
+
+	*result = (uint8_t)val;
+	return 0;
+}
+
+static int lookup_u32(const char *arg, uint32_t *result,
+		      const struct lookup_entry_u32 *tbl)
+{
+	if (!arg)
+		return -EINVAL;
+	while (tbl->arg) {
+		if (!strcmp(tbl->arg, arg)) {
+			*result = tbl->val;
+			return 0;
+		}
+		tbl++;
+	}
+
+	return -EINVAL;
+}
+
+static int lookup_u8(const char *arg, uint8_t *result,
+		     const struct lookup_entry_u8 *tbl)
+{
+	if (!arg)
+		return -EINVAL;
+	while (tbl->arg) {
+		if (!strcmp(tbl->arg, arg)) {
+			*result = tbl->val;
+			return 0;
+		}
+		tbl++;
+	}
+
+	return -EINVAL;
+}
+
+/* Parser handler for a flag. Expects a name (with no additional argument),
+ * generates NLA_FLAG or sets a bool (if the name was present).
+ */
+int nl_parse_flag(struct nl_context *nlctx, uint16_t type, const void *data,
+		  struct nl_msg_buff *msgbuff, void *dest)
+{
+	if (dest)
+		*(bool *)dest = true;
+	return (type && ethnla_put_flag(msgbuff, type, true)) ? -EMSGSIZE : 0;
+}
+
+/* Parser handler for null terminated string. Expects a string argument,
+ * generates NLA_NUL_STRING or fills const char *
+ */
+int nl_parse_string(struct nl_context *nlctx, uint16_t type, const void *data,
+		    struct nl_msg_buff *msgbuff, void *dest)
+{
+	const char *arg = *nlctx->argp;
+
+	nlctx->argp++;
+	nlctx->argc--;
+
+	if (dest)
+		*(const char **)dest = arg;
+	return (type && ethnla_put_strz(msgbuff, type, arg)) ? -EMSGSIZE : 0;
+}
+
+/* Parser handler for unsigned 32-bit integer. Expects a numeric argument
+ * (may use 0x prefix), generates NLA_U32 or fills an uint32_t.
+ */
+int nl_parse_direct_u32(struct nl_context *nlctx, uint16_t type,
+			const void *data, struct nl_msg_buff *msgbuff,
+			void *dest)
+{
+	const char *arg = *nlctx->argp;
+	uint32_t val;
+	int ret;
+
+	nlctx->argp++;
+	nlctx->argc--;
+	ret = parse_u32(arg, &val);
+	if (ret < 0) {
+		parser_err_invalid_value(nlctx, arg);
+		return ret;
+	}
+
+	if (dest)
+		*(uint32_t *)dest = val;
+	return (type && ethnla_put_u32(msgbuff, type, val)) ? -EMSGSIZE : 0;
+}
+
+/* Parser handler for unsigned 32-bit integer. Expects a numeric argument
+ * (may use 0x prefix), generates NLA_U32 or fills an uint32_t.
+ */
+int nl_parse_direct_u8(struct nl_context *nlctx, uint16_t type,
+		       const void *data, struct nl_msg_buff *msgbuff,
+		       void *dest)
+{
+	const char *arg = *nlctx->argp;
+	uint8_t val;
+	int ret;
+
+	nlctx->argp++;
+	nlctx->argc--;
+	ret = parse_u8(arg, &val);
+	if (ret < 0) {
+		parser_err_invalid_value(nlctx, arg);
+		return ret;
+	}
+
+	if (dest)
+		*(uint8_t *)dest = val;
+	return (type && ethnla_put_u8(msgbuff, type, val)) ? -EMSGSIZE : 0;
+}
+
+/* Parser handler for (tri-state) bool. Expects "name on|off", generates
+ * NLA_U8 which is 1 for "on" and 0 for "off".
+ */
+int nl_parse_u8bool(struct nl_context *nlctx, uint16_t type, const void *data,
+		    struct nl_msg_buff *msgbuff, void *dest)
+{
+	const char *arg = *nlctx->argp;
+	int ret;
+
+	nlctx->argp++;
+	nlctx->argc--;
+	if (!strcmp(arg, "on")) {
+		if (dest)
+			*(uint8_t *)dest = 1;
+		ret = type ? ethnla_put_u8(msgbuff, type, 1) : 0;
+	} else if (!strcmp(arg, "off")) {
+		if (dest)
+			*(uint8_t *)dest = 0;
+		ret = type ? ethnla_put_u8(msgbuff, type, 0) : 0;
+	} else {
+		parser_err_invalid_value(nlctx, arg);
+		return -EINVAL;
+	}
+
+	return ret ? -EMSGSIZE : 0;
+}
+
+/* Parser handler for 32-bit lookup value. Expects a string argument, looks it
+ * up in a table, generates NLA_U32 or fills uint32_t variable. The @data
+ * parameter is a null terminated array of struct lookup_entry_u32.
+ */
+int nl_parse_lookup_u32(struct nl_context *nlctx, uint16_t type,
+			const void *data, struct nl_msg_buff *msgbuff,
+			void *dest)
+{
+	const char *arg = *nlctx->argp;
+	uint32_t val;
+	int ret;
+
+	nlctx->argp++;
+	nlctx->argc--;
+	ret = lookup_u32(arg, &val, data);
+	if (ret < 0) {
+		parser_err_invalid_value(nlctx, arg);
+		return ret;
+	}
+
+	if (dest)
+		*(uint32_t *)dest = val;
+	return (type && ethnla_put_u32(msgbuff, type, val)) ? -EMSGSIZE : 0;
+}
+
+/* Parser handler for 8-bit lookup value. Expects a string argument, looks it
+ * up in a table, generates NLA_U8 or fills uint8_t variable. The @data
+ * parameter is a null terminated array of struct lookup_entry_u8.
+ */
+int nl_parse_lookup_u8(struct nl_context *nlctx, uint16_t type,
+		       const void *data, struct nl_msg_buff *msgbuff,
+		       void *dest)
+{
+	const char *arg = *nlctx->argp;
+	uint8_t val;
+	int ret;
+
+	nlctx->argp++;
+	nlctx->argc--;
+	ret = lookup_u8(arg, &val, data);
+	if (ret < 0) {
+		parser_err_invalid_value(nlctx, arg);
+		return ret;
+	}
+
+	if (dest)
+		*(uint8_t *)dest = val;
+	return (type && ethnla_put_u8(msgbuff, type, val)) ? -EMSGSIZE : 0;
+}
+
+static bool __is_hex(char c)
+{
+	if (isdigit(c))
+		return true;
+	else
+		return (c >= 'a' && c <= 'f') || (c >= 'A' && c <= 'F');
+}
+
+static unsigned int __hex_val(char c)
+{
+	if (c >= '0' && c <= '9')
+		return c - '0';
+	if (c >= 'a' && c <= 'f')
+		return c - 'a' + 0xa;
+	if (c >= 'A' && c <= 'F')
+		return c - 'A' + 0xa;
+	return 0;
+}
+
+static bool __bytestr_delim(const char *p, char delim)
+{
+	return !*p || (delim ? (*p == delim) : !__is_hex(*p));
+}
+
+/* Parser handler for generic byte string in MAC-like format. Expects string
+ * argument in the "[[:xdigit:]]{2}(:[[:xdigit:]]{2})*" format, generates
+ * NLA_BINARY or fills a struct byte_str_value (if @dest is not null and the
+ * handler succeeds, caller is responsible for freeing the value). The @data
+ * parameter points to struct byte_str_parser_data.
+ */
+int nl_parse_byte_str(struct nl_context *nlctx, uint16_t type, const void *data,
+		      struct nl_msg_buff *msgbuff, void *dest)
+{
+	const struct byte_str_parser_data *pdata = data;
+	struct byte_str_value *dest_value = dest;
+	const char *arg = *nlctx->argp;
+	uint8_t *val = NULL;
+	unsigned int len, i;
+	const char *p;
+	int ret;
+
+	nlctx->argp++;
+	nlctx->argc--;
+
+	len = 0;
+	p = arg;
+	if (!*p)
+		goto err;
+	while (true) {
+		len++;
+		if (!__bytestr_delim(p, pdata->delim))
+			p++;
+		if (!__bytestr_delim(p, pdata->delim))
+			p++;
+		if (!__bytestr_delim(p, pdata->delim))
+			goto err;
+		if (!*p)
+			break;
+		p++;
+		if (*p && __bytestr_delim(p, pdata->delim))
+			goto err;
+	}
+	if (len < pdata->min_len || (pdata->max_len && len > pdata->max_len))
+		goto err;
+	val = malloc(len);
+	if (!val)
+		return -ENOMEM;
+
+	p = arg;
+	for (i = 0; i < len; i++) {
+		uint8_t byte = 0;
+
+		if (!__is_hex(*p))
+			goto err;
+		while (__is_hex(*p))
+			byte = 16 * byte + __hex_val(*p++);
+		if (!__bytestr_delim(p, pdata->delim))
+			goto err;
+		val[i] = byte;
+		if (*p)
+			p++;
+	}
+	ret = type ? ethnla_put(msgbuff, type, len, val) : 0;
+	if (dest) {
+		dest_value->len = len;
+		dest_value->data = val;
+	} else {
+		free(val);
+	}
+	return ret;
+
+err:
+	free(val);
+	fprintf(stderr, "ethtool (%s): invalid value '%s' of parameter '%s'\n",
+		nlctx->cmd, arg, nlctx->param);
+	return -EINVAL;
+}
+
+/* Parser handler for parameters recognized for backward compatibility but
+ * supposed to fail without passing to kernel. Does not generate any netlink
+ * attributes of fill any variable. The @data parameter points to struct
+ * error_parser_params (error message, return value and number of extra
+ * arguments to skip).
+ */
+int nl_parse_error(struct nl_context *nlctx, uint16_t type, const void *data,
+		   struct nl_msg_buff *msgbuff, void *dest)
+{
+	const struct error_parser_data *parser_data = data;
+	unsigned int skip = parser_data->extra_args;
+
+	fprintf(stderr, "ethtool (%s): ", nlctx->cmd);
+	fprintf(stderr, parser_data->err_msg, nlctx->param);
+	if (nlctx->argc < skip) {
+		fprintf(stderr, "ethtool (%s): too few arguments for parameter '%s' (expected %u)\n",
+			nlctx->cmd, nlctx->param, skip);
+	} else {
+		nlctx->argp += skip;
+		nlctx->argc -= skip;
+	}
+
+	return parser_data->ret_val;
+}
+
+/* parser implementation */
+
+static const struct param_parser *find_parser(const struct param_parser *params,
+					      const char *arg)
+{
+	const struct param_parser *parser;
+
+	for (parser = params; parser->arg; parser++)
+		if (!strcmp(arg, parser->arg))
+			return parser;
+	return NULL;
+}
+
+static bool __parser_bit(const uint64_t *map, unsigned int idx)
+{
+	return map[idx / 64] & (1 << (idx % 64));
+}
+
+static void __parser_set(uint64_t *map, unsigned int idx)
+{
+	map[idx / 64] |= (1 << (idx % 64));
+}
+
+struct tmp_buff {
+	struct nl_msg_buff	msgbuff;
+	unsigned int		id;
+	unsigned int		orig_len;
+	struct tmp_buff		*next;
+};
+
+static struct tmp_buff *tmp_buff_find(struct tmp_buff *head, unsigned int id)
+{
+	struct tmp_buff *buff;
+
+	for (buff = head; buff; buff = buff->next)
+		if (buff->id == id)
+			break;
+
+	return buff;
+}
+
+static struct tmp_buff *tmp_buff_find_or_create(struct tmp_buff **phead,
+						unsigned int id)
+{
+	struct tmp_buff **pbuff;
+	struct tmp_buff *new_buff;
+
+	for (pbuff = phead; *pbuff; pbuff = &(*pbuff)->next)
+		if ((*pbuff)->id == id)
+			return *pbuff;
+
+	new_buff = malloc(sizeof(*new_buff));
+	if (!new_buff)
+		return NULL;
+	new_buff->id = id;
+	msgbuff_init(&new_buff->msgbuff);
+	new_buff->next = NULL;
+	*pbuff = new_buff;
+
+	return new_buff;
+}
+
+static void tmp_buff_destroy(struct tmp_buff *head)
+{
+	struct tmp_buff *buff = head;
+	struct tmp_buff *next;
+
+	while (buff) {
+		next = buff->next;
+		msgbuff_done(&buff->msgbuff);
+		free(buff);
+		buff = next;
+	}
+}
+
+/* Main entry point of parser implementation.
+ * @nlctx: netlink context
+ * @params:      array of struct param_parser describing expected arguments
+ *               and their handlers; the array must be terminated by null
+ *               element {}
+ * @dest:        optional destination to copy parsed data to (at
+ *               param_parser::offset)
+ * @group_style: defines if identifiers in .group represent separate messages,
+ *               nested attributes or are not allowed
+ */
+int nl_parser(struct nl_context *nlctx, const struct param_parser *params,
+	      void *dest, enum parser_group_style group_style)
+{
+	struct nl_socket *nlsk = nlctx->ethnl_socket;
+	const struct param_parser *parser;
+	struct tmp_buff *buffs = NULL;
+	struct tmp_buff *buff;
+	unsigned int n_params;
+	uint64_t *params_seen;
+	int ret;
+
+	n_params = 0;
+	for (parser = params; parser->arg; parser++) {
+		struct nl_msg_buff *msgbuff;
+		struct nlattr *nest;
+
+		n_params++;
+		if (group_style == PARSER_GROUP_NONE || !parser->group)
+			continue;
+		ret = -ENOMEM;
+		buff = tmp_buff_find_or_create(&buffs, parser->group);
+		if (!buff)
+			goto out_free_buffs;
+		msgbuff = &buff->msgbuff;
+
+		switch (group_style) {
+		case PARSER_GROUP_NEST:
+			ret = -EMSGSIZE;
+			nest = ethnla_nest_start(&buff->msgbuff, parser->group);
+			if (!nest)
+				goto out_free_buffs;
+			break;
+		case PARSER_GROUP_MSG:
+			ret = msg_init(nlctx, msgbuff, parser->group,
+				       NLM_F_REQUEST | NLM_F_ACK);
+			if (ret < 0)
+				goto out_free_buffs;
+			if (ethnla_fill_header(msgbuff,
+					       ETHTOOL_A_LINKINFO_HEADER,
+					       nlctx->devname, 0))
+				goto out_free_buffs;
+			break;
+		default:
+			break;
+		}
+
+		buff->orig_len = msgbuff_len(msgbuff);
+	}
+	ret = -ENOMEM;
+	params_seen = calloc(DIV_ROUND_UP(n_params, 64), sizeof(uint64_t));
+	if (!params_seen)
+		goto out_free_buffs;
+
+	while (nlctx->argc > 0) {
+		struct nl_msg_buff *msgbuff;
+		void *param_dest;
+
+		nlctx->param = *nlctx->argp;
+		ret = -EINVAL;
+		parser = find_parser(params, nlctx->param);
+		if (!parser) {
+			parser_err_unknown_param(nlctx);
+			goto out_free;
+		}
+
+		/* check duplicates and minimum number of arguments */
+		if (__parser_bit(params_seen, parser - params)) {
+			parser_err_dup_param(nlctx);
+			goto out_free;
+		}
+		nlctx->argc--;
+		nlctx->argp++;
+		if (nlctx->argc < parser->min_argc) {
+			parser_err_min_argc(nlctx, parser->min_argc);
+			goto out_free;
+		}
+		__parser_set(params_seen, parser - params);
+
+		buff = NULL;
+		if (parser->group)
+			buff = tmp_buff_find(buffs, parser->group);
+		msgbuff = buff ? &buff->msgbuff : &nlsk->msgbuff;
+
+		param_dest = dest ? (dest + parser->dest_offset) : NULL;
+		ret = parser->handler(nlctx, parser->type, parser->handler_data,
+				      msgbuff, param_dest);
+		if (ret < 0)
+			goto out_free;
+	}
+
+	for (buff = buffs; buff; buff = buff->next) {
+		struct nl_msg_buff *msgbuff = &buff->msgbuff;
+
+		if (group_style == PARSER_GROUP_NONE ||
+		    msgbuff_len(msgbuff) == buff->orig_len)
+			continue;
+		switch (group_style) {
+		case PARSER_GROUP_NEST:
+			ethnla_nest_end(msgbuff, msgbuff->payload);
+			ret = msgbuff_append(&nlsk->msgbuff, msgbuff);
+			if (ret < 0)
+				goto out_free;
+			break;
+		case PARSER_GROUP_MSG:
+			ret = nlsock_sendmsg(nlsk, msgbuff);
+			if (ret < 0)
+				goto out_free;
+			ret = nlsock_process_reply(nlsk, nomsg_reply_cb, NULL);
+			if (ret < 0)
+				goto out_free;
+			break;
+		default:
+			break;
+		}
+	}
+
+	ret = 0;
+out_free:
+	free(params_seen);
+out_free_buffs:
+	tmp_buff_destroy(buffs);
+	return ret;
+}
diff --git a/netlink/parser.h b/netlink/parser.h
new file mode 100644
index 000000000000..b5e8cd418b50
--- /dev/null
+++ b/netlink/parser.h
@@ -0,0 +1,123 @@
+/*
+ * parser.h - netlink command line parser
+ *
+ * Interface for command line parser used by netlink code.
+ */
+
+#ifndef ETHTOOL_NETLINK_PARSER_H__
+#define ETHTOOL_NETLINK_PARSER_H__
+
+#include <stddef.h>
+
+#include "netlink.h"
+
+/* Some commands need to generate multiple netlink messages or multiple nested
+ * attributes from one set of command line parameters. Argument @group_style
+ * of nl_parser() takes one of three values:
+ *
+ * PARSER_GROUP_NONE - no grouping, flat series of attributes (default)
+ * PARSER_GROUP_NEST - one nest for each @group value (@group is nest type)
+ * PARSER_GROUP_MSG  - one message for each @group value (@group is command)
+ */
+enum parser_group_style {
+	PARSER_GROUP_NONE = 0,
+	PARSER_GROUP_NEST,
+	PARSER_GROUP_MSG,
+};
+
+typedef int (*param_parser_cb_t)(struct nl_context *, uint16_t, const void *,
+				 struct nl_msg_buff *, void *);
+
+struct param_parser {
+	/* command line parameter handled by this entry */
+	const char		*arg;
+	/* group id (see enum parser_group_style above) */
+	unsigned int		group;
+	/* netlink attribute type */
+	uint16_t		type;		/* netlink attribute type */
+	/* function called to parse parameter and its value */
+	param_parser_cb_t	handler;
+	/* pointer passed as @data argument of the handler */
+	const void		*handler_data;
+	/* minimum number of extra arguments after this parameter */
+	unsigned int		min_argc;
+	/* if @dest is passed to nl_parser(), offset to store value */
+	unsigned int		dest_offset;
+};
+
+/* data structures used for handler data */
+
+/* used by nl_parse_lookup_u32() */
+struct lookup_entry_u32 {
+	const char	*arg;
+	uint32_t	val;
+};
+
+/* used by nl_parse_lookup_u8() */
+struct lookup_entry_u8 {
+	const char	*arg;
+	uint8_t		val;
+};
+
+/* used by nl_parse_byte_str() */
+struct byte_str_parser_data {
+	unsigned int	min_len;
+	unsigned int	max_len;
+	char		delim;
+};
+
+/* used for value stored by nl_parse_byte_str() */
+struct byte_str_value {
+	unsigned int	len;
+	u8		*data;
+};
+
+/* used by nl_parse_error() */
+struct error_parser_data {
+	const char	*err_msg;
+	int		ret_val;
+	unsigned int	extra_args;
+};
+
+int parse_u32(const char *arg, uint32_t *result);
+
+/* parser handlers to use as param_parser::handler */
+
+/* NLA_FLAG represented by on | off */
+int nl_parse_flag(struct nl_context *nlctx, uint16_t type, const void *data,
+		  struct nl_msg_buff *msgbuff, void *dest);
+/* NLA_NUL_STRING represented by a string argument */
+int nl_parse_string(struct nl_context *nlctx, uint16_t type, const void *data,
+		    struct nl_msg_buff *msgbuff, void *dest);
+/* NLA_U32 represented as numeric argument */
+int nl_parse_direct_u32(struct nl_context *nlctx, uint16_t type,
+			const void *data, struct nl_msg_buff *msgbuff,
+			void *dest);
+/* NLA_U8 represented as numeric argument */
+int nl_parse_direct_u8(struct nl_context *nlctx, uint16_t type,
+		       const void *data, struct nl_msg_buff *msgbuff,
+		       void *dest);
+/* NLA_U8 represented as on | off */
+int nl_parse_u8bool(struct nl_context *nlctx, uint16_t type, const void *data,
+		    struct nl_msg_buff *msgbuff, void *dest);
+/* NLA_U32 represented by a string argument (lookup table) */
+int nl_parse_lookup_u32(struct nl_context *nlctx, uint16_t type,
+			const void *data, struct nl_msg_buff *msgbuff,
+			void *dest);
+/* NLA_U8 represented by a string argument (lookup table) */
+int nl_parse_lookup_u8(struct nl_context *nlctx, uint16_t type,
+		       const void *data, struct nl_msg_buff *msgbuff,
+		       void *dest);
+/* always fail (for deprecated parameters) */
+int nl_parse_error(struct nl_context *nlctx, uint16_t type, const void *data,
+		   struct nl_msg_buff *msgbuff, void *dest);
+/* NLA_BINARY represented by %x:%x:...%x (e.g. a MAC address) */
+int nl_parse_byte_str(struct nl_context *nlctx, uint16_t type,
+		      const void *data, struct nl_msg_buff *msgbuff,
+		      void *dest);
+
+/* main entry point called to parse the command line */
+int nl_parser(struct nl_context *nlctx, const struct param_parser *params,
+	      void *dest, enum parser_group_style group_style);
+
+#endif /* ETHTOOL_NETLINK_PARSER_H__ */
-- 
2.25.1

