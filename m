Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCA812E206D
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 19:28:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728252AbgLWS1q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 13:27:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728107AbgLWS1o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Dec 2020 13:27:44 -0500
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [IPv6:2001:67c:2050::465:202])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FCD0C0611CA
        for <netdev@vger.kernel.org>; Wed, 23 Dec 2020 10:26:52 -0800 (PST)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [80.241.60.241])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4D1M9F3ck5zQlTL;
        Wed, 23 Dec 2020 19:26:25 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1608747983;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yeRNgwe0JmybMxnybs4eBYlHym42cCcjoItePfYHSDs=;
        b=g2QXl2lzs54BxqxWyTXw/9IzHyx+QvGBKO/zC1Vs5mDQq25PuT4h7UDQ0aLDTl1K3NwxLV
        /F1dUXdQf799yNQAB5N9HDutykT0F6cSpzoo8Des8cnDY6YQYDjoLcPM4n/A3Ozxd4euD3
        9qgC7IApNiyTeA25xB0FOyXtOUxSr/ZNMl0lf/4YAlzbOrI9YPlrBn6cHk4K2s3KYqADL4
        XCtOstRcTWRTl1WUEYpw63rPlnLpWyaYhTNfHCrA/Ek6/8hYqAQ6c3OEstV82fh6+evXjS
        n7wSJk4xaXno92H/JUrKSx/D01adIEDGnBU1f35loT4oBxShzcOUXEKeLnn0jA==
Received: from smtp2.mailbox.org ([80.241.60.241])
        by spamfilter01.heinlein-hosting.de (spamfilter01.heinlein-hosting.de [80.241.56.115]) (amavisd-new, port 10030)
        with ESMTP id iP78V8WEnMrM; Wed, 23 Dec 2020 19:26:21 +0100 (CET)
From:   Petr Machata <me@pmachata.org>
To:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
Cc:     Petr Machata <me@pmachata.org>
Subject: [PATCH iproute2-next 8/9] dcb: Add a subtool for the DCB APP object
Date:   Wed, 23 Dec 2020 19:25:46 +0100
Message-Id: <d51da41734d45bdc9eb28031b9f12d603c9ff558.1608746691.git.me@pmachata.org>
In-Reply-To: <cover.1608746691.git.me@pmachata.org>
References: <cover.1608746691.git.me@pmachata.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: 
X-Rspamd-Score: -1.43 / 15.00 / 15.00
X-Rspamd-Queue-Id: 68B5D17C3
X-Rspamd-UID: 300504
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DCB APP interfaces are standardized in 802.1q-2018, and allow configuration
of traffic prioritization rules based on several possible headers.

Add a dcb subtool for maintenance and display of the APP table. For
example:

    # dcb app add dev eni1np1 dscp-prio 0:0 CS3:3 CS6:6
    # dcb app show dev eni1np1
    dscp-prio 0:0 CS3:3 CS6:6
    # dcb app add dev eni1np1 dscp-prio CS3:4
    # dcb app show dev eni1np1
    dscp-prio 0:0 CS3:3 CS3:4 CS6:6
    # dcb app replace dev eni1np1 dscp-prio CS3:5
    # dcb app show dev eni1np1
    dscp-prio 0:0 CS3:5 CS6:6

Signed-off-by: Petr Machata <me@pmachata.org>
---
 dcb/Makefile       |   7 +-
 dcb/dcb.c          |   4 +-
 dcb/dcb.h          |   4 +
 dcb/dcb_app.c      | 796 +++++++++++++++++++++++++++++++++++++++++++++
 man/man8/dcb-app.8 | 237 ++++++++++++++
 man/man8/dcb.8     |   7 +-
 6 files changed, 1052 insertions(+), 3 deletions(-)
 create mode 100644 dcb/dcb_app.c
 create mode 100644 man/man8/dcb-app.8

diff --git a/dcb/Makefile b/dcb/Makefile
index 4add954b4bba..13d45f2b96b1 100644
--- a/dcb/Makefile
+++ b/dcb/Makefile
@@ -5,7 +5,12 @@ TARGETS :=
 
 ifeq ($(HAVE_MNL),y)
 
-DCBOBJ = dcb.o dcb_buffer.o dcb_ets.o dcb_maxrate.o dcb_pfc.o
+DCBOBJ = dcb.o \
+         dcb_app.o \
+         dcb_buffer.o \
+         dcb_ets.o \
+         dcb_maxrate.o \
+         dcb_pfc.o
 TARGETS += dcb
 
 endif
diff --git a/dcb/dcb.c b/dcb/dcb.c
index e6cda7337924..85e40a7e0d0b 100644
--- a/dcb/dcb.c
+++ b/dcb/dcb.c
@@ -465,7 +465,7 @@ static void dcb_help(void)
 	fprintf(stderr,
 		"Usage: dcb [ OPTIONS ] OBJECT { COMMAND | help }\n"
 		"       dcb [ -f | --force ] { -b | --batch } filename [ -N | --Netns ] netnsname\n"
-		"where  OBJECT := { buffer | ets | maxrate | pfc }\n"
+		"where  OBJECT := { app | buffer | ets | maxrate | pfc }\n"
 		"       OPTIONS := [ -V | --Version | -i | --iec | -j | --json\n"
 		"                  | -n | --no-nice-names | -p | --pretty\n"
 		"                  | -s | --statistics | -v | --verbose]\n");
@@ -476,6 +476,8 @@ static int dcb_cmd(struct dcb *dcb, int argc, char **argv)
 	if (!argc || matches(*argv, "help") == 0) {
 		dcb_help();
 		return 0;
+	} else if (matches(*argv, "app") == 0) {
+		return dcb_cmd_app(dcb, argc - 1, argv + 1);
 	} else if (matches(*argv, "buffer") == 0) {
 		return dcb_cmd_buffer(dcb, argc - 1, argv + 1);
 	} else if (matches(*argv, "ets") == 0) {
diff --git a/dcb/dcb.h b/dcb/dcb.h
index f1d089257867..c4993d689656 100644
--- a/dcb/dcb.h
+++ b/dcb/dcb.h
@@ -54,6 +54,10 @@ void dcb_print_array_on_off(const __u8 *array, size_t size);
 void dcb_print_array_kw(const __u8 *array, size_t array_size,
 			const char *const kw[], size_t kw_size);
 
+/* dcb_app.c */
+
+int dcb_cmd_app(struct dcb *dcb, int argc, char **argv);
+
 /* dcb_buffer.c */
 
 int dcb_cmd_buffer(struct dcb *dcb, int argc, char **argv);
diff --git a/dcb/dcb_app.c b/dcb/dcb_app.c
new file mode 100644
index 000000000000..791abaa62cec
--- /dev/null
+++ b/dcb/dcb_app.c
@@ -0,0 +1,796 @@
+// SPDX-License-Identifier: GPL-2.0+
+
+#include <errno.h>
+#include <inttypes.h>
+#include <stdio.h>
+#include <libmnl/libmnl.h>
+#include <linux/dcbnl.h>
+
+#include "dcb.h"
+#include "utils.h"
+#include "rt_names.h"
+
+static void dcb_app_help_add(void)
+{
+	fprintf(stderr,
+		"Usage: dcb app { add | del | replace } dev STRING\n"
+		"           [ default-prio PRIO ]\n"
+		"           [ ethtype-prio ET:PRIO ]\n"
+		"           [ stream-port-prio PORT:PRIO ]\n"
+		"           [ dgram-port-prio PORT:PRIO ]\n"
+		"           [ port-prio PORT:PRIO ]\n"
+		"           [ dscp-prio INTEGER:PRIO ]\n"
+		"\n"
+		" where PRIO := { 0 .. 7 }\n"
+		"       ET := { 0x600 .. 0xffff }\n"
+		"       PORT := { 1 .. 65535 }\n"
+		"       DSCP := { 0 .. 63 }\n"
+		"\n"
+	);
+}
+
+static void dcb_app_help_show_flush(void)
+{
+	fprintf(stderr,
+		"Usage: dcb app { show | flush } dev STRING\n"
+		"           [ default-prio ]\n"
+		"           [ ethtype-prio ]\n"
+		"           [ stream-port-prio ]\n"
+		"           [ dgram-port-prio ]\n"
+		"           [ port-prio ]\n"
+		"           [ dscp-prio ]\n"
+		"\n"
+	);
+}
+
+static void dcb_app_help(void)
+{
+	fprintf(stderr,
+		"Usage: dcb app help\n"
+		"\n"
+	);
+	dcb_app_help_show_flush();
+	dcb_app_help_add();
+}
+
+struct dcb_app_table {
+	struct dcb_app *apps;
+	size_t n_apps;
+};
+
+static void dcb_app_table_fini(struct dcb_app_table *tab)
+{
+	free(tab->apps);
+}
+
+static int dcb_app_table_push(struct dcb_app_table *tab, struct dcb_app *app)
+{
+	struct dcb_app *apps = reallocarray(tab->apps, tab->n_apps + 1,
+					    sizeof(*tab->apps));
+
+	if (apps == NULL) {
+		perror("Cannot allocate APP table");
+		return -ENOMEM;
+	}
+
+	tab->apps = apps;
+	tab->apps[tab->n_apps++] = *app;
+	return 0;
+}
+
+static void dcb_app_table_remove_existing(struct dcb_app_table *a,
+					  const struct dcb_app_table *b)
+{
+	size_t ia, ja;
+	size_t ib;
+
+	for (ia = 0, ja = 0; ia < a->n_apps; ia++) {
+		struct dcb_app *aa = &a->apps[ia];
+		bool found = false;
+
+		for (ib = 0; ib < b->n_apps; ib++) {
+			const struct dcb_app *ab = &b->apps[ib];
+
+			if (aa->selector == ab->selector &&
+			    aa->protocol == ab->protocol &&
+			    aa->priority == ab->priority) {
+				found = true;
+				break;
+			}
+		}
+
+		if (!found)
+			a->apps[ja++] = *aa;
+	}
+
+	a->n_apps = ja;
+}
+
+static void dcb_app_table_remove_replaced(struct dcb_app_table *a,
+					  const struct dcb_app_table *b)
+{
+	size_t ia, ja;
+	size_t ib;
+
+	for (ia = 0, ja = 0; ia < a->n_apps; ia++) {
+		struct dcb_app *aa = &a->apps[ia];
+		bool present = false;
+		bool found = false;
+
+		for (ib = 0; ib < b->n_apps; ib++) {
+			const struct dcb_app *ab = &b->apps[ib];
+
+			if (aa->selector == ab->selector &&
+			    aa->protocol == ab->protocol)
+				present = true;
+			else
+				continue;
+
+			if (aa->priority == ab->priority) {
+				found = true;
+				break;
+			}
+		}
+
+		/* Entries that remain in A will be removed, so keep in the
+		 * table only APP entries whose sel/pid is mentioned in B,
+		 * but that do not have the full sel/pid/prio match.
+		 */
+		if (present && !found)
+			a->apps[ja++] = *aa;
+	}
+
+	a->n_apps = ja;
+}
+
+static int dcb_app_table_copy(struct dcb_app_table *a,
+			      const struct dcb_app_table *b)
+{
+	size_t i;
+	int ret;
+
+	for (i = 0; i < b->n_apps; i++) {
+		ret = dcb_app_table_push(a, &b->apps[i]);
+		if (ret != 0)
+			return ret;
+	}
+	return 0;
+}
+
+static int dcb_app_cmp(const struct dcb_app *a, const struct dcb_app *b)
+{
+	if (a->protocol < b->protocol)
+		return -1;
+	if (a->protocol > b->protocol)
+		return 1;
+	return a->priority - b->priority;
+}
+
+static int dcb_app_cmp_cb(const void *a, const void *b)
+{
+	return dcb_app_cmp(a, b);
+}
+
+static void dcb_app_table_sort(struct dcb_app_table *tab)
+{
+	qsort(tab->apps, tab->n_apps, sizeof(*tab->apps), dcb_app_cmp_cb);
+}
+
+struct dcb_app_parse_mapping {
+	__u8 selector;
+	struct dcb_app_table *tab;
+	int err;
+};
+
+static void dcb_app_parse_mapping_cb(__u32 key, __u64 value, void *data)
+{
+	struct dcb_app_parse_mapping *pm = data;
+	struct dcb_app app = {
+		.selector = pm->selector,
+		.priority = value,
+		.protocol = key,
+	};
+
+	if (pm->err)
+		return;
+
+	pm->err = dcb_app_table_push(pm->tab, &app);
+}
+
+static int dcb_app_parse_mapping_ethtype_prio(__u32 key, char *value, void *data)
+{
+	__u8 prio;
+
+	if (key < 0x600) {
+		fprintf(stderr, "Protocol IDs < 0x600 are reserved for EtherType\n");
+		return -EINVAL;
+	}
+
+	if (get_u8(&prio, value, 0))
+		return -EINVAL;
+
+	return dcb_parse_mapping("ETHTYPE", key, 0xffff,
+				 "PRIO", prio, IEEE_8021QAZ_MAX_TCS - 1,
+				 dcb_app_parse_mapping_cb, data);
+}
+
+static int dcb_app_parse_dscp(__u32 *key, const char *arg)
+{
+	if (parse_mapping_num_all(key, arg) == 0)
+		return 0;
+
+	if (rtnl_dsfield_a2n(key, arg) != 0)
+		return -1;
+
+	if (*key & 0x03) {
+		fprintf(stderr, "The values `%s' uses non-DSCP bits.\n", arg);
+		return -1;
+	}
+
+	/* Unshift the value to convert it from dsfield to DSCP. */
+	*key >>= 2;
+	return 0;
+}
+
+static int dcb_app_parse_mapping_dscp_prio(__u32 key, char *value, void *data)
+{
+	__u8 prio;
+
+	if (get_u8(&prio, value, 0))
+		return -EINVAL;
+
+	return dcb_parse_mapping("DSCP", key, 63,
+				 "PRIO", prio, IEEE_8021QAZ_MAX_TCS - 1,
+				 dcb_app_parse_mapping_cb, data);
+}
+
+static int dcb_app_parse_mapping_port_prio(__u32 key, char *value, void *data)
+{
+	__u8 prio;
+
+	if (key == 0) {
+		fprintf(stderr, "Port ID of 0 is invalid\n");
+		return -EINVAL;
+	}
+
+	if (get_u8(&prio, value, 0))
+		return -EINVAL;
+
+	return dcb_parse_mapping("PORT", key, 0xffff,
+				 "PRIO", prio, IEEE_8021QAZ_MAX_TCS - 1,
+				 dcb_app_parse_mapping_cb, data);
+}
+
+static int dcb_app_parse_default_prio(int *argcp, char ***argvp, struct dcb_app_table *tab)
+{
+	int argc = *argcp;
+	char **argv = *argvp;
+	int ret = 0;
+
+	while (argc > 0) {
+		struct dcb_app app;
+		__u8 prio;
+
+		if (get_u8(&prio, *argv, 0)) {
+			ret = 1;
+			break;
+		}
+
+		app = (struct dcb_app){
+			.selector = IEEE_8021QAZ_APP_SEL_ETHERTYPE,
+			.protocol = 0,
+			.priority = prio,
+		};
+		ret = dcb_app_table_push(tab, &app);
+		if (ret != 0)
+			break;
+
+		argc--, argv++;
+	}
+
+	*argcp = argc;
+	*argvp = argv;
+	return ret;
+}
+
+static bool dcb_app_is_ethtype(const struct dcb_app *app)
+{
+	return app->selector == IEEE_8021QAZ_APP_SEL_ETHERTYPE &&
+	       app->protocol != 0;
+}
+
+static bool dcb_app_is_default(const struct dcb_app *app)
+{
+	return app->selector == IEEE_8021QAZ_APP_SEL_ETHERTYPE &&
+	       app->protocol == 0;
+}
+
+static bool dcb_app_is_dscp(const struct dcb_app *app)
+{
+	return app->selector == IEEE_8021QAZ_APP_SEL_DSCP;
+}
+
+static bool dcb_app_is_stream_port(const struct dcb_app *app)
+{
+	return app->selector == IEEE_8021QAZ_APP_SEL_STREAM;
+}
+
+static bool dcb_app_is_dgram_port(const struct dcb_app *app)
+{
+	return app->selector == IEEE_8021QAZ_APP_SEL_DGRAM;
+}
+
+static bool dcb_app_is_port(const struct dcb_app *app)
+{
+	return app->selector == IEEE_8021QAZ_APP_SEL_ANY;
+}
+
+static int dcb_app_print_key_dec(__u16 protocol)
+{
+	return print_uint(PRINT_ANY, NULL, "%d:", protocol);
+}
+
+static int dcb_app_print_key_hex(__u16 protocol)
+{
+	return print_uint(PRINT_ANY, NULL, "%x:", protocol);
+}
+
+static int dcb_app_print_key_dscp(__u16 protocol)
+{
+	const char *name = rtnl_dsfield_get_name(protocol << 2);
+
+
+	if (!is_json_context() && name != NULL)
+		return print_string(PRINT_FP, NULL, "%s:", name);
+	return print_uint(PRINT_ANY, NULL, "%d:", protocol);
+}
+
+static void dcb_app_print_filtered(const struct dcb_app_table *tab,
+				   bool (*filter)(const struct dcb_app *),
+				   int (*print_key)(__u16 protocol),
+				   const char *json_name,
+				   const char *fp_name)
+{
+	bool first = true;
+	size_t i;
+
+	for (i = 0; i < tab->n_apps; i++) {
+		struct dcb_app *app = &tab->apps[i];
+
+		if (!filter(app))
+			continue;
+		if (first) {
+			open_json_array(PRINT_JSON, json_name);
+			print_string(PRINT_FP, NULL, "%s ", fp_name);
+			first = false;
+		}
+
+		open_json_array(PRINT_JSON, NULL);
+		print_key(app->protocol);
+		print_uint(PRINT_ANY, NULL, "%d ", app->priority);
+		close_json_array(PRINT_JSON, NULL);
+	}
+
+	if (!first) {
+		close_json_array(PRINT_JSON, json_name);
+		print_nl();
+	}
+}
+
+static void dcb_app_print_ethtype_prio(const struct dcb_app_table *tab)
+{
+	dcb_app_print_filtered(tab, dcb_app_is_ethtype,  dcb_app_print_key_hex,
+			       "ethtype_prio", "ethtype-prio");
+}
+
+static void dcb_app_print_dscp_prio(const struct dcb *dcb,
+				    const struct dcb_app_table *tab)
+{
+	dcb_app_print_filtered(tab, dcb_app_is_dscp,
+			       dcb->no_nice_names ? dcb_app_print_key_dec
+						  : dcb_app_print_key_dscp,
+			       "dscp_prio", "dscp-prio");
+}
+
+static void dcb_app_print_stream_port_prio(const struct dcb_app_table *tab)
+{
+	dcb_app_print_filtered(tab, dcb_app_is_stream_port, dcb_app_print_key_dec,
+			       "stream_port_prio", "stream-port-prio");
+}
+
+static void dcb_app_print_dgram_port_prio(const struct dcb_app_table *tab)
+{
+	dcb_app_print_filtered(tab, dcb_app_is_dgram_port, dcb_app_print_key_dec,
+			       "dgram_port_prio", "dgram-port-prio");
+}
+
+static void dcb_app_print_port_prio(const struct dcb_app_table *tab)
+{
+	dcb_app_print_filtered(tab, dcb_app_is_port, dcb_app_print_key_dec,
+			       "port_prio", "port-prio");
+}
+
+static void dcb_app_print_default_prio(const struct dcb_app_table *tab)
+{
+	bool first = true;
+	size_t i;
+
+	for (i = 0; i < tab->n_apps; i++) {
+		if (!dcb_app_is_default(&tab->apps[i]))
+			continue;
+		if (first) {
+			open_json_array(PRINT_JSON, "default_prio");
+			print_string(PRINT_FP, NULL, "default-prio ", NULL);
+			first = false;
+		}
+		print_uint(PRINT_ANY, NULL, "%d ", tab->apps[i].priority);
+	}
+
+	if (!first) {
+		close_json_array(PRINT_JSON, "default_prio");
+		print_nl();
+	}
+}
+
+static void dcb_app_print(const struct dcb *dcb, const struct dcb_app_table *tab)
+{
+	dcb_app_print_ethtype_prio(tab);
+	dcb_app_print_default_prio(tab);
+	dcb_app_print_dscp_prio(dcb, tab);
+	dcb_app_print_stream_port_prio(tab);
+	dcb_app_print_dgram_port_prio(tab);
+	dcb_app_print_port_prio(tab);
+}
+
+static int dcb_app_get_table_attr_cb(const struct nlattr *attr, void *data)
+{
+	struct dcb_app_table *tab = data;
+	struct dcb_app *app;
+	int ret;
+
+	if (mnl_attr_get_type(attr) != DCB_ATTR_IEEE_APP) {
+		fprintf(stderr, "Unknown attribute in DCB_ATTR_IEEE_APP_TABLE: %d\n",
+			mnl_attr_get_type(attr));
+		return MNL_CB_OK;
+	}
+	if (mnl_attr_get_payload_len(attr) < sizeof(struct dcb_app)) {
+		fprintf(stderr, "DCB_ATTR_IEEE_APP payload expected to have size %zd, not %d\n",
+			sizeof(struct dcb_app), mnl_attr_get_payload_len(attr));
+		return MNL_CB_OK;
+	}
+
+	app = mnl_attr_get_payload(attr);
+	ret = dcb_app_table_push(tab, app);
+	if (ret != 0)
+		return MNL_CB_ERROR;
+
+	return MNL_CB_OK;
+}
+
+static int dcb_app_get(struct dcb *dcb, const char *dev, struct dcb_app_table *tab)
+{
+	uint16_t payload_len;
+	void *payload;
+	int ret;
+
+	ret = dcb_get_attribute_va(dcb, dev, DCB_ATTR_IEEE_APP_TABLE, &payload, &payload_len);
+	if (ret != 0)
+		return ret;
+
+	ret = mnl_attr_parse_payload(payload, payload_len, dcb_app_get_table_attr_cb, tab);
+	if (ret != MNL_CB_OK)
+		return -EINVAL;
+
+	return 0;
+}
+
+struct dcb_app_add_del {
+	const struct dcb_app_table *tab;
+	bool (*filter)(const struct dcb_app *app);
+};
+
+static int dcb_app_add_del_cb(struct dcb *dcb, struct nlmsghdr *nlh, void *data)
+{
+	struct dcb_app_add_del *add_del = data;
+	struct nlattr *nest;
+	size_t i;
+
+	nest = mnl_attr_nest_start(nlh, DCB_ATTR_IEEE_APP_TABLE);
+
+	for (i = 0; i < add_del->tab->n_apps; i++) {
+		const struct dcb_app *app = &add_del->tab->apps[i];
+
+		if (add_del->filter == NULL || add_del->filter(app))
+			mnl_attr_put(nlh, DCB_ATTR_IEEE_APP, sizeof(*app), app);
+	}
+
+	mnl_attr_nest_end(nlh, nest);
+	return 0;
+}
+
+static int dcb_app_add_del(struct dcb *dcb, const char *dev, int command,
+			   const struct dcb_app_table *tab,
+			   bool (*filter)(const struct dcb_app *))
+{
+	struct dcb_app_add_del add_del = {
+		.tab = tab,
+		.filter = filter,
+	};
+
+	if (tab->n_apps == 0)
+		return 0;
+
+	return dcb_set_attribute_va(dcb, command, dev, dcb_app_add_del_cb, &add_del);
+}
+
+static int dcb_cmd_app_parse_add_del(struct dcb *dcb, const char *dev,
+				     int argc, char **argv, struct dcb_app_table *tab)
+{
+	struct dcb_app_parse_mapping pm = {
+		.tab = tab,
+	};
+	int ret;
+
+	if (!argc) {
+		dcb_app_help_add();
+		return 0;
+	}
+
+	do {
+		if (matches(*argv, "help") == 0) {
+			dcb_app_help_add();
+			return 0;
+		} else if (matches(*argv, "ethtype-prio") == 0) {
+			NEXT_ARG();
+			pm.selector = IEEE_8021QAZ_APP_SEL_ETHERTYPE;
+			ret = parse_mapping(&argc, &argv, false,
+					    &dcb_app_parse_mapping_ethtype_prio,
+					    &pm);
+		} else if (matches(*argv, "default-prio") == 0) {
+			NEXT_ARG();
+			ret = dcb_app_parse_default_prio(&argc, &argv, pm.tab);
+			if (ret != 0) {
+				fprintf(stderr, "Invalid default priority %s\n", *argv);
+				return ret;
+			}
+		} else if (matches(*argv, "dscp-prio") == 0) {
+			NEXT_ARG();
+			pm.selector = IEEE_8021QAZ_APP_SEL_DSCP;
+			ret = parse_mapping_gen(&argc, &argv,
+						&dcb_app_parse_dscp,
+						&dcb_app_parse_mapping_dscp_prio,
+						&pm);
+		} else if (matches(*argv, "stream-port-prio") == 0) {
+			NEXT_ARG();
+			pm.selector = IEEE_8021QAZ_APP_SEL_STREAM;
+			ret = parse_mapping(&argc, &argv, false,
+					    &dcb_app_parse_mapping_port_prio,
+					    &pm);
+		} else if (matches(*argv, "dgram-port-prio") == 0) {
+			NEXT_ARG();
+			pm.selector = IEEE_8021QAZ_APP_SEL_DGRAM;
+			ret = parse_mapping(&argc, &argv, false,
+					    &dcb_app_parse_mapping_port_prio,
+					    &pm);
+		} else if (matches(*argv, "port-prio") == 0) {
+			NEXT_ARG();
+			pm.selector = IEEE_8021QAZ_APP_SEL_ANY;
+			ret = parse_mapping(&argc, &argv, false,
+					    &dcb_app_parse_mapping_port_prio,
+					    &pm);
+		} else {
+			fprintf(stderr, "What is \"%s\"?\n", *argv);
+			dcb_app_help_add();
+			return -EINVAL;
+		}
+
+		if (ret != 0) {
+			fprintf(stderr, "Invalid mapping %s\n", *argv);
+			return ret;
+		}
+		if (pm.err)
+			return pm.err;
+	} while (argc > 0);
+
+	return 0;
+}
+
+static int dcb_cmd_app_add(struct dcb *dcb, const char *dev, int argc, char **argv)
+{
+	struct dcb_app_table tab = {};
+	int ret;
+
+	ret = dcb_cmd_app_parse_add_del(dcb, dev, argc, argv, &tab);
+	if (ret != 0)
+		return ret;
+
+	ret = dcb_app_add_del(dcb, dev, DCB_CMD_IEEE_SET, &tab, NULL);
+	dcb_app_table_fini(&tab);
+	return ret;
+}
+
+static int dcb_cmd_app_del(struct dcb *dcb, const char *dev, int argc, char **argv)
+{
+	struct dcb_app_table tab = {};
+	int ret;
+
+	ret = dcb_cmd_app_parse_add_del(dcb, dev, argc, argv, &tab);
+	if (ret != 0)
+		return ret;
+
+	ret = dcb_app_add_del(dcb, dev, DCB_CMD_IEEE_DEL, &tab, NULL);
+	dcb_app_table_fini(&tab);
+	return ret;
+}
+
+static int dcb_cmd_app_show(struct dcb *dcb, const char *dev, int argc, char **argv)
+{
+	struct dcb_app_table tab = {};
+	int ret;
+
+	ret = dcb_app_get(dcb, dev, &tab);
+	if (ret != 0)
+		return ret;
+
+	dcb_app_table_sort(&tab);
+
+	open_json_object(NULL);
+
+	if (!argc) {
+		dcb_app_print(dcb, &tab);
+		goto out;
+	}
+
+	do {
+		if (matches(*argv, "help") == 0) {
+			dcb_app_help_show_flush();
+			goto out;
+		} else if (matches(*argv, "ethtype-prio") == 0) {
+			dcb_app_print_ethtype_prio(&tab);
+		} else if (matches(*argv, "dscp-prio") == 0) {
+			dcb_app_print_dscp_prio(dcb, &tab);
+		} else if (matches(*argv, "stream-port-prio") == 0) {
+			dcb_app_print_stream_port_prio(&tab);
+		} else if (matches(*argv, "dgram-port-prio") == 0) {
+			dcb_app_print_dgram_port_prio(&tab);
+		} else if (matches(*argv, "port-prio") == 0) {
+			dcb_app_print_port_prio(&tab);
+		} else {
+			fprintf(stderr, "What is \"%s\"?\n", *argv);
+			dcb_app_help_show_flush();
+			ret = -EINVAL;
+			goto out;
+		}
+
+		NEXT_ARG_FWD();
+	} while (argc > 0);
+
+out:
+	close_json_object();
+	dcb_app_table_fini(&tab);
+	return 0;
+}
+
+static int dcb_cmd_app_flush(struct dcb *dcb, const char *dev, int argc, char **argv)
+{
+	struct dcb_app_table tab = {};
+	int ret;
+
+	ret = dcb_app_get(dcb, dev, &tab);
+	if (ret != 0)
+		return ret;
+
+	if (!argc) {
+		ret = dcb_app_add_del(dcb, dev, DCB_CMD_IEEE_DEL, &tab, NULL);
+		goto out;
+	}
+
+	do {
+		if (matches(*argv, "help") == 0) {
+			dcb_app_help_show_flush();
+			goto out;
+		} else if (matches(*argv, "ethtype-prio") == 0) {
+			ret = dcb_app_add_del(dcb, dev, DCB_CMD_IEEE_DEL, &tab,
+					      &dcb_app_is_ethtype);
+			if (ret != 0)
+				goto out;
+		} else if (matches(*argv, "default-prio") == 0) {
+			ret = dcb_app_add_del(dcb, dev, DCB_CMD_IEEE_DEL, &tab,
+					      &dcb_app_is_default);
+			if (ret != 0)
+				goto out;
+		} else if (matches(*argv, "dscp-prio") == 0) {
+			ret = dcb_app_add_del(dcb, dev, DCB_CMD_IEEE_DEL, &tab,
+					      &dcb_app_is_dscp);
+			if (ret != 0)
+				goto out;
+		} else {
+			fprintf(stderr, "What is \"%s\"?\n", *argv);
+			dcb_app_help_show_flush();
+			ret = -EINVAL;
+			goto out;
+		}
+
+		NEXT_ARG_FWD();
+	} while (argc > 0);
+
+out:
+	dcb_app_table_fini(&tab);
+	return ret;
+}
+
+static int dcb_cmd_app_replace(struct dcb *dcb, const char *dev, int argc, char **argv)
+{
+	struct dcb_app_table orig = {};
+	struct dcb_app_table tab = {};
+	struct dcb_app_table new = {};
+	int ret;
+
+	ret = dcb_app_get(dcb, dev, &orig);
+	if (ret != 0)
+		return ret;
+
+	ret = dcb_cmd_app_parse_add_del(dcb, dev, argc, argv, &tab);
+	if (ret != 0)
+		goto out;
+
+	/* Attempts to add an existing entry would be rejected, so drop
+	 * these entries from tab.
+	 */
+	ret = dcb_app_table_copy(&new, &tab);
+	if (ret != 0)
+		goto out;
+	dcb_app_table_remove_existing(&new, &orig);
+
+	ret = dcb_app_add_del(dcb, dev, DCB_CMD_IEEE_SET, &new, NULL);
+	if (ret != 0) {
+		fprintf(stderr, "Could not add new APP entries\n");
+		goto out;
+	}
+
+	/* Remove the obsolete entries. */
+	dcb_app_table_remove_replaced(&orig, &tab);
+	ret = dcb_app_add_del(dcb, dev, DCB_CMD_IEEE_DEL, &orig, NULL);
+	if (ret != 0) {
+		fprintf(stderr, "Could not remove replaced APP entries\n");
+		goto out;
+	}
+
+out:
+	dcb_app_table_fini(&new);
+	dcb_app_table_fini(&tab);
+	dcb_app_table_fini(&orig);
+	return 0;
+}
+
+int dcb_cmd_app(struct dcb *dcb, int argc, char **argv)
+{
+	if (!argc || matches(*argv, "help") == 0) {
+		dcb_app_help();
+		return 0;
+	} else if (matches(*argv, "show") == 0) {
+		NEXT_ARG_FWD();
+		return dcb_cmd_parse_dev(dcb, argc, argv,
+					 dcb_cmd_app_show, dcb_app_help_show_flush);
+	} else if (matches(*argv, "flush") == 0) {
+		NEXT_ARG_FWD();
+		return dcb_cmd_parse_dev(dcb, argc, argv,
+					 dcb_cmd_app_flush, dcb_app_help_show_flush);
+	} else if (matches(*argv, "add") == 0) {
+		NEXT_ARG_FWD();
+		return dcb_cmd_parse_dev(dcb, argc, argv,
+					 dcb_cmd_app_add, dcb_app_help_add);
+	} else if (matches(*argv, "del") == 0) {
+		NEXT_ARG_FWD();
+		return dcb_cmd_parse_dev(dcb, argc, argv,
+					 dcb_cmd_app_del, dcb_app_help_add);
+	} else if (matches(*argv, "replace") == 0) {
+		NEXT_ARG_FWD();
+		return dcb_cmd_parse_dev(dcb, argc, argv,
+					 dcb_cmd_app_replace, dcb_app_help_add);
+	} else {
+		fprintf(stderr, "What is \"%s\"?\n", *argv);
+		dcb_app_help();
+		return -EINVAL;
+	}
+}
diff --git a/man/man8/dcb-app.8 b/man/man8/dcb-app.8
new file mode 100644
index 000000000000..6a5f267489bc
--- /dev/null
+++ b/man/man8/dcb-app.8
@@ -0,0 +1,237 @@
+.TH DCB-ETS 8 "6 December 2020" "iproute2" "Linux"
+.SH NAME
+dcb-app \- show / manipulate application priority table of
+the DCB (Data Center Bridging) subsystem
+.SH SYNOPSIS
+.sp
+.ad l
+.in +8
+
+.ti -8
+.B dcb
+.RI "[ " OPTIONS " ] "
+.B app
+.RI "{ " COMMAND " | " help " }"
+.sp
+
+.ti -8
+.B dcb app " { " show " | " flush " } " dev
+.RI DEV
+.RB "[ " default-prio " ]"
+.RB "[ " ethtype-prio " ]"
+.RB "[ " stream-port-prio " ]"
+.RB "[ " dgram-port-prio " ]"
+.RB "[ " port-prio " ]"
+.RB "[ " dscp-prio " ]"
+
+.ti -8
+.B dcb ets " { " add " | " del " | " replace " } " dev
+.RI DEV
+.RB "[ " default-prio " " \fIPRIO-LIST\fB " ]"
+.RB "[ " ethtype-prio " " \fIET-MAP\fB " ]"
+.RB "[ " stream-port-prio " " \fIPORT-MAP\fB " ]"
+.RB "[ " dgram-port-prio " " \fIPORT-MAP\fB " ]"
+.RB "[ " port-prio " " \fIPORT-MAP\fB " ]"
+.RB "[ " dscp-prio " " \fIDSCP-MAP\fB " ]"
+
+.ti -8
+.IR PRIO-LIST " := [ " PRIO-LIST " ] " PRIO
+
+.ti -8
+.IR ET-MAP " := [ " ET-MAP " ] " ET-MAPPING
+
+.ti -8
+.IR ET-MAPPING " := " ET\fB:\fIPRIO\fR
+
+.ti -8
+.IR PORT-MAP " := [ " PORT-MAP " ] " PORT-MAPPING
+
+.ti -8
+.IR PORT-MAPPING " := " PORT\fB:\fIPRIO\fR
+
+.ti -8
+.IR DSCP-MAP " := [ " DSCP-MAP " ] " DSCP-MAPPING
+
+.ti -8
+.IR DSCP-MAPPING " := { " DSCP " | " \fBall " }" \fB:\fIPRIO\fR
+
+.ti -8
+.IR ET " := { " \fB0x600\fR " .. " \fB0xffff\fR " }"
+
+.ti -8
+.IR PORT " := { " \fB1\fR " .. " \fB65535\fR " }"
+
+.ti -8
+.IR DSCP " := { " \fB0\fR " .. " \fB63\fR " }"
+
+.ti -8
+.IR PRIO " := { " \fB0\fR " .. " \fB7\fR " }"
+
+.SH DESCRIPTION
+
+.B dcb app
+is used to configure APP table, or application priority table in the DCB (Data
+Center Bridging) subsystem. The APP table is used to assign priority to traffic
+based on value in one of several headers: EtherType, L4 destination port, or
+DSCP. It also allows configuration of port-default priority that is chosen if no
+other prioritization rule applies.
+
+DCB APP entries are 3-tuples of selector, protocol ID, and priority. Selector is
+an enumeration that picks one of the prioritization namespaces. Currently it
+mostly corresponds to configurable parameters described below. Protocol ID is a
+value in the selector namespace. E.g. for EtherType selector, protocol IDs are
+the individual EtherTypes, for DSCP they are individual code points. The
+priority is the priority that should be assigned to traffic that matches the
+selector and protocol ID.
+
+The APP table is a set of DCB APP entries. The only requirement is that
+duplicate entries are not added. Notably, it is valid to have conflicting
+priority assignment for the same selector and protocol ID. For example, the set
+of two APP entries (DSCP, 10, 1) and (DSCP, 10, 2), where packets with DSCP of
+10 should get priority of both 1 and 2, form a well-defined APP table. The
+.B dcb app
+tool allows low-level management of the app table by adding and deleting
+individual APP 3-tuples through
+.B add
+and
+.B del
+commands. On the other other hand, the command
+.B replace
+does what one would typically want in this situation--first adds the new
+configuration, and then removes the obsolete one, so that only one
+prioritization is in effect for a given selector and protocol ID.
+
+.SH COMMANDS
+
+.TP
+.B show
+Display all entries with a given selector. When no selector is given, shows all
+APP table entries categorized per selector.
+
+.TP
+.B flush
+Remove all entries with a given selector. When no selector is given, removes all
+APP table entries.
+
+.TP
+.B add
+.TQ
+.B del
+Add and, respectively, remove individual APP 3-tuples to and from the DCB APP
+table.
+
+.TP
+.B replace
+Take the list of entries mentioned as parameter, and add those that are not
+present in the APP table yet. Then remove those entries, whose selector and
+protocol ID have been mentioned as parameter, but not with the exact same
+priority. This has the effect of, for the given selector and protocol ID,
+causing that the table only contains the priority (or priorities) given as
+parameter.
+
+.SH PARAMETERS
+
+The following table shows parameters in a way that they would be used with
+\fBadd\fR, \fBdel\fR and \fBreplace\fR commands. For \fBshow\fR and \fBflush\fR,
+the parameter name is to be used as a simple keyword without further arguments.
+
+.TP
+.B default-prio \fIPRIO-LIST
+The priority to be used for traffic the priority of which is otherwise
+unspecified. The argument is a list of individual priorities. Note that
+.B default-prio
+rules are configured as triplets (\fBEtherType\fR, \fB0\fR, \fIPRIO\fR).
+.B dcb app
+translates these rules to the symbolic name
+.B default-prio
+and back.
+
+.TP
+.B ethtype-prio \fIET-MAP
+\fIET-MAP\fR uses the array parameter syntax, see
+.BR dcb (8)
+for details. Keys are EtherType values. Values are priorities to be assigned to
+traffic with the matching EtherType.
+
+.TP
+.B stream-port-prio \fIPORT-MAP
+.TQ
+.B dgram-port-prio \fIPORT-MAP
+.TQ
+.B port-prio \fIPORT-MAP
+\fIPORT-MAP\fR uses the array parameter syntax, see
+.BR dcb (8)
+for details. Keys are L4 destination port numbers that match on, respectively,
+TCP and SCTP traffic, UDP and DCCP traffic, and either of those. Values are
+priorities that should be assigned to matching traffic.
+
+.TP
+.B dscp-prio \fIDSCP-MAP
+\fIDSCP-MAP\fR uses the array parameter syntax, see
+.BR dcb (8)
+for details. Keys are DSCP points, values are priorities assigned to
+traffic with matching DSCP. DSCP points can be written either direcly as
+numeric values, or using symbolic names specified in
+.B /etc/iproute2/rt_dsfield
+(however note that that file specifies full 8-bit dsfield values, whereas
+.B dcb app
+will only use the higher six bits).
+.B dcb app show
+will similarly format DSCP values as symbolic names if possible. The
+command line option
+.B -n
+turns the show translation off.
+
+.SH EXAMPLE & USAGE
+
+Prioritize traffic with DSCP 0 to priority 0, 24 to 3 and 48 to 6:
+
+.P
+# dcb app add dev eth0 dscp-prio 0:0 24:3 48:6
+
+Add another rule to configure DSCP 24 to priority 2 and show the result:
+
+.P
+# dcb app add dev eth0 dscp-prio 24:2
+.br
+# dcb app show dev eth0 dscp-prio
+.br
+dscp-prio 0:0 CS3:2 CS3:3 CS6:6
+.br
+# dcb -n app show dev eth0 dscp-prio
+.br
+dscp-prio 0:0 24:2 24:3 48:6
+
+Reconfigure the table so that the only rule for DSCP 24 is for assignment of
+priority 4:
+
+.P
+# dcb app replace dev eth0 dscp-prio 24:4
+.br
+# dcb app show dev eth0 dscp-prio
+.br
+dscp-prio 0:0 24:4 48:6
+
+Flush all DSCP rules:
+
+.P
+# dcb app flush dev eth0 dscp-prio
+.br
+# dcb app show dev eth0 dscp-prio
+.br
+(nothing)
+
+.SH EXIT STATUS
+Exit status is 0 if command was successful or a positive integer upon failure.
+
+.SH SEE ALSO
+.BR dcb (8)
+
+.SH REPORTING BUGS
+Report any bugs to the Network Developers mailing list
+.B <netdev@vger.kernel.org>
+where the development and maintenance is primarily done.
+You do not have to be subscribed to the list to send a message there.
+
+.SH AUTHOR
+Petr Machata <me@pmachata.org>
diff --git a/man/man8/dcb.8 b/man/man8/dcb.8
index 46c7a31410b7..78be104e0b3b 100644
--- a/man/man8/dcb.8
+++ b/man/man8/dcb.8
@@ -9,7 +9,7 @@ dcb \- show / manipulate DCB (Data Center Bridging) settings
 .ti -8
 .B dcb
 .RI "[ " OPTIONS " ] "
-.RB "{ " buffer " | " ets " | " maxrate " | " pfc " }"
+.RB "{ " app " | " buffer " | " ets " | " maxrate " | " pfc " }"
 .RI "{ " COMMAND " | " help " }"
 .sp
 
@@ -68,6 +68,10 @@ part of the "show" output.
 
 .SH OBJECTS
 
+.TP
+.B app
+- Configuration of application priority table
+
 .TP
 .B buffer
 - Configuration of port buffers
@@ -128,6 +132,7 @@ other values:
 Exit status is 0 if command was successful or a positive integer upon failure.
 
 .SH SEE ALSO
+.BR dcb-app (8),
 .BR dcb-buffer (8),
 .BR dcb-ets (8),
 .BR dcb-maxrate (8),
-- 
2.25.1

