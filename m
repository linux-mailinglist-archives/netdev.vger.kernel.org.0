Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACC2742A5A9
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 15:26:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236954AbhJLN2b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 09:28:31 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:45307 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236878AbhJLN2X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 09:28:23 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id B2A7B5C01B7;
        Tue, 12 Oct 2021 09:26:21 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 12 Oct 2021 09:26:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=zUD5GBF2ebXJb0XVim+Ra+wlLi5U31N/YSUUpCaPpoA=; b=XwCqKuVr
        COu7ZhtN61y2joROum+sN9uNRDRXBFZ+9in+8vIW6JzVbLxB+HCG/AyF37YjtLK3
        60vnLmdfuoux/c2TlNL78tJ7/BD8a66WF6prCiN8LgtHbQBl8uQQGuCLPvI1/8pK
        iO6L1FRPipiq3mODhZpX3ZPXNp6CkD2iT/YsGLjsMklwmp22vfrAKM4nfJf2cvNZ
        hjZ+vmqVkMg7QabF9jiUK4FM3xt7Qg+DuzR2RnHbf9y/1hPe4FgcmyEcFdYVkd8/
        SzdbO6jTS3K9yDNkzojkfRq+XySgkdEXxiYDdXfCoXBMFdW5GXHFdftbJfptTTga
        Wmoyxhq5A9WFLA==
X-ME-Sender: <xms:_YxlYZC2p9wChp86FYPL3MAKBemz_JzpSXFVjAZRQT5APzmQuVwGkw>
    <xme:_YxlYXg3JBbjm1Y9-jCLflWMPqYYpHjferN_eozggDurQNvU8JAXtMvNjwl0uhaur
    vJb8Fjcz_bpa4A>
X-ME-Received: <xmr:_YxlYUnGQSH6rT5iCI2R_6T0rUEmwpS_bPqBb6KmIK6oh1ugxs5d_msJ5htwR_i9E33URtCbhATMe2Haubw6gfiix52lcW8qWvgRyK1ES2iTJw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvddtkedgiedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgepjeenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:_YxlYTxvVp8wPZVzMyRnE1TEwWrqU-Y1KW04Uu7HriKMPK4TdEqYng>
    <xmx:_YxlYeQIUU8c4rN6Swea5IVdNlCJoPdN62-a41aUkl3T1QVtIfv4vw>
    <xmx:_YxlYWY9lP4xvFnFL6jrW_GBsDoec07PISWe0Y4nGlYWoRYuI_bcRQ>
    <xmx:_YxlYUOzrP5oXViGzQYwgN0D5VMmQ2SISyPBWi54IIaPY26Mdjkiaw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 12 Oct 2021 09:26:19 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     mkubecek@suse.cz, popadrian1996@gmail.com, andrew@lunn.ch,
        mlxsw@nvidia.com, moshe@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH ethtool-next 14/14] netlink: eeprom: Defer page requests to individual parsers
Date:   Tue, 12 Oct 2021 16:25:25 +0300
Message-Id: <20211012132525.457323-15-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211012132525.457323-1-idosch@idosch.org>
References: <20211012132525.457323-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

The individual EEPROM parsers (e.g., CMIS, SFF-8636) now request the
EEPROM pages they intend to parse and populate their memory maps before
parsing them.

Therefore, there is no need for the common netlink code to request
potentially invalid pages and pass them as blobs to these parsers.

Instead, only query the SFF-8024 Identifier Value which is located at
I2C address 0x50, byte 0 and dispatch to the relevant EEPROM parser.

Tested by making sure that the output of 'ethtool -m' does not change
for SFF-8079, SFF-8636 and CMIS before and after the patch.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 netlink/module-eeprom.c | 347 +++++++---------------------------------
 1 file changed, 59 insertions(+), 288 deletions(-)

diff --git a/netlink/module-eeprom.c b/netlink/module-eeprom.c
index 6d76b8a96461..f359aeec4ddf 100644
--- a/netlink/module-eeprom.c
+++ b/netlink/module-eeprom.c
@@ -19,7 +19,6 @@
 #include "parser.h"
 
 #define ETH_I2C_ADDRESS_LOW	0x50
-#define ETH_I2C_ADDRESS_HIGH	0x51
 #define ETH_I2C_MAX_ADDRESS	0x7F
 
 struct cmd_params {
@@ -78,267 +77,6 @@ static const struct param_parser getmodule_params[] = {
 	{}
 };
 
-struct page_entry {
-	struct list_head link;
-	struct ethtool_module_eeprom *page;
-};
-
-static struct list_head page_list = LIST_HEAD_INIT(page_list);
-
-static int cache_add(struct ethtool_module_eeprom *page)
-{
-	struct page_entry *list_element;
-
-	if (!page)
-		return -1;
-	list_element = malloc(sizeof(*list_element));
-	if (!list_element)
-		return -ENOMEM;
-	list_element->page = page;
-
-	list_add(&list_element->link, &page_list);
-	return 0;
-}
-
-static void page_free(struct ethtool_module_eeprom *page)
-{
-	free(page->data);
-	free(page);
-}
-
-static void cache_del(struct ethtool_module_eeprom *page)
-{
-	struct ethtool_module_eeprom *entry;
-	struct list_head *head, *next;
-
-	list_for_each_safe(head, next, &page_list) {
-		entry = ((struct page_entry *)head)->page;
-		if (entry == page) {
-			list_del(head);
-			free(head);
-			page_free(entry);
-			break;
-		}
-	}
-}
-
-static void cache_free(void)
-{
-	struct ethtool_module_eeprom *entry;
-	struct list_head *head, *next;
-
-	list_for_each_safe(head, next, &page_list) {
-		entry = ((struct page_entry *)head)->page;
-		list_del(head);
-		free(head);
-		page_free(entry);
-	}
-}
-
-static struct ethtool_module_eeprom *page_join(struct ethtool_module_eeprom *page_a,
-					       struct ethtool_module_eeprom *page_b)
-{
-	struct ethtool_module_eeprom *joined_page;
-	u32 total_length;
-
-	if (!page_a || !page_b ||
-	    page_a->page != page_b->page ||
-	    page_a->bank != page_b->bank ||
-	    page_a->i2c_address != page_b->i2c_address)
-		return NULL;
-
-	total_length = page_a->length + page_b->length;
-	joined_page = calloc(1, sizeof(*joined_page));
-	joined_page->data = calloc(1, total_length);
-	joined_page->page = page_a->page;
-	joined_page->bank = page_a->bank;
-	joined_page->length = total_length;
-	joined_page->i2c_address = page_a->i2c_address;
-
-	if (page_a->offset < page_b->offset) {
-		memcpy(joined_page->data, page_a->data, page_a->length);
-		memcpy(joined_page->data + page_a->length, page_b->data, page_b->length);
-		joined_page->offset = page_a->offset;
-	} else {
-		memcpy(joined_page->data, page_b->data, page_b->length);
-		memcpy(joined_page->data + page_b->length, page_a->data, page_a->length);
-		joined_page->offset = page_b->offset;
-	}
-
-	return joined_page;
-}
-
-static struct ethtool_module_eeprom *cache_get(u32 page, u32 bank, u8 i2c_address)
-{
-	struct ethtool_module_eeprom *entry;
-	struct list_head *head, *next;
-
-	list_for_each_safe(head, next, &page_list) {
-		entry = ((struct page_entry *)head)->page;
-		if (entry->page == page && entry->bank == bank &&
-		    entry->i2c_address == i2c_address)
-			return entry;
-	}
-
-	return NULL;
-}
-
-static int getmodule_page_fetch_reply_cb(const struct nlmsghdr *nlhdr,
-					 void *data)
-{
-	const struct nlattr *tb[ETHTOOL_A_MODULE_EEPROM_DATA + 1] = {};
-	DECLARE_ATTR_TB_INFO(tb);
-	struct ethtool_module_eeprom *lower_page;
-	struct ethtool_module_eeprom *response;
-	struct ethtool_module_eeprom *request;
-	struct ethtool_module_eeprom *joined;
-	u8 *eeprom_data;
-	int ret;
-
-	ret = mnl_attr_parse(nlhdr, GENL_HDRLEN, attr_cb, &tb_info);
-	if (ret < 0)
-		return ret;
-
-	if (!tb[ETHTOOL_A_MODULE_EEPROM_DATA]) {
-		fprintf(stderr, "Malformed netlink message (getmodule)\n");
-		return MNL_CB_ERROR;
-	}
-
-	response = calloc(1, sizeof(*response));
-	if (!response)
-		return -ENOMEM;
-
-	request = (struct ethtool_module_eeprom *)data;
-	response->offset = request->offset;
-	response->page = request->page;
-	response->bank = request->bank;
-	response->i2c_address = request->i2c_address;
-	response->length = mnl_attr_get_payload_len(tb[ETHTOOL_A_MODULE_EEPROM_DATA]);
-	eeprom_data = mnl_attr_get_payload(tb[ETHTOOL_A_MODULE_EEPROM_DATA]);
-
-	response->data = malloc(response->length);
-	if (!response->data) {
-		free(response);
-		return -ENOMEM;
-	}
-	memcpy(response->data, eeprom_data, response->length);
-
-	if (!request->page) {
-		lower_page = cache_get(request->page, request->bank, response->i2c_address);
-		if (lower_page) {
-			joined = page_join(lower_page, response);
-			page_free(response);
-			cache_del(lower_page);
-			return cache_add(joined);
-		}
-	}
-
-	return cache_add(response);
-}
-
-static int page_fetch(struct nl_context *nlctx, const struct ethtool_module_eeprom *request)
-{
-	struct nl_socket *nlsock = nlctx->ethnl_socket;
-	struct nl_msg_buff *msg = &nlsock->msgbuff;
-	struct ethtool_module_eeprom *page;
-	int ret;
-
-	if (!request || request->i2c_address > ETH_I2C_MAX_ADDRESS)
-		return -EINVAL;
-
-	/* Satisfy request right away, if region is already in cache */
-	page = cache_get(request->page, request->bank, request->i2c_address);
-	if (page && page->offset <= request->offset &&
-	    page->offset + page->length >= request->offset + request->length) {
-		return 0;
-	}
-
-	ret = nlsock_prep_get_request(nlsock, ETHTOOL_MSG_MODULE_EEPROM_GET,
-				      ETHTOOL_A_MODULE_EEPROM_HEADER, 0);
-	if (ret < 0)
-		return ret;
-
-	if (ethnla_put_u32(msg, ETHTOOL_A_MODULE_EEPROM_LENGTH, request->length) ||
-	    ethnla_put_u32(msg, ETHTOOL_A_MODULE_EEPROM_OFFSET, request->offset) ||
-	    ethnla_put_u8(msg, ETHTOOL_A_MODULE_EEPROM_PAGE, request->page) ||
-	    ethnla_put_u8(msg, ETHTOOL_A_MODULE_EEPROM_BANK, request->bank) ||
-	    ethnla_put_u8(msg, ETHTOOL_A_MODULE_EEPROM_I2C_ADDRESS, request->i2c_address))
-		return -EMSGSIZE;
-
-	ret = nlsock_sendmsg(nlsock, NULL);
-	if (ret < 0)
-		return ret;
-	ret = nlsock_process_reply(nlsock, getmodule_page_fetch_reply_cb, (void *)request);
-	if (ret < 0)
-		return ret;
-
-	return nlsock_process_reply(nlsock, nomsg_reply_cb, NULL);
-}
-
-#ifdef ETHTOOL_ENABLE_PRETTY_DUMP
-static int decoder_prefetch(struct nl_context *nlctx)
-{
-	struct ethtool_module_eeprom *page_zero_lower = cache_get(0, 0, ETH_I2C_ADDRESS_LOW);
-	struct ethtool_module_eeprom request = {0};
-	u8 module_id = page_zero_lower->data[0];
-	int err = 0;
-
-	/* Fetch rest of page 00 */
-	request.i2c_address = ETH_I2C_ADDRESS_LOW;
-	request.offset = 128;
-	request.length = 128;
-	err = page_fetch(nlctx, &request);
-	if (err)
-		return err;
-
-	switch (module_id) {
-	case SFF8024_ID_QSFP:
-	case SFF8024_ID_QSFP28:
-	case SFF8024_ID_QSFP_PLUS:
-		memset(&request, 0, sizeof(request));
-		request.i2c_address = ETH_I2C_ADDRESS_LOW;
-		request.offset = 128;
-		request.length = 128;
-		request.page = 3;
-		break;
-	case SFF8024_ID_QSFP_DD:
-	case SFF8024_ID_DSFP:
-		memset(&request, 0, sizeof(request));
-		request.i2c_address = ETH_I2C_ADDRESS_LOW;
-		request.offset = 128;
-		request.length = 128;
-		request.page = 1;
-		break;
-	}
-
-	return page_fetch(nlctx, &request);
-}
-
-static void decoder_print(struct cmd_context *ctx)
-{
-	struct ethtool_module_eeprom *page_zero = cache_get(0, 0, ETH_I2C_ADDRESS_LOW);
-	u8 module_id = page_zero->data[SFF8636_ID_OFFSET];
-
-	switch (module_id) {
-	case SFF8024_ID_SFP:
-		sff8079_show_all_nl(ctx);
-		break;
-	case SFF8024_ID_QSFP:
-	case SFF8024_ID_QSFP28:
-	case SFF8024_ID_QSFP_PLUS:
-		sff8636_show_all_nl(ctx);
-		break;
-	case SFF8024_ID_QSFP_DD:
-	case SFF8024_ID_DSFP:
-		cmis_show_all_nl(ctx);
-		break;
-	default:
-		dump_hex(stdout, page_zero->data, page_zero->length, page_zero->offset);
-		break;
-	}
-}
-#endif
-
 static struct list_head eeprom_page_list = LIST_HEAD_INIT(eeprom_page_list);
 
 struct eeprom_page_entry {
@@ -443,14 +181,64 @@ int nl_get_eeprom_page(struct cmd_context *ctx,
 				    (void *)request);
 }
 
+static int eeprom_dump_hex(struct cmd_context *ctx)
+{
+	struct ethtool_module_eeprom request = {
+		.length = 128,
+		.i2c_address = ETH_I2C_ADDRESS_LOW,
+	};
+	int ret;
+
+	ret = nl_get_eeprom_page(ctx, &request);
+	if (ret < 0)
+		return ret;
+
+	dump_hex(stdout, request.data, request.length, request.offset);
+
+	return 0;
+}
+
+static int eeprom_parse(struct cmd_context *ctx)
+{
+	struct ethtool_module_eeprom request = {
+		.length = 1,
+		.i2c_address = ETH_I2C_ADDRESS_LOW,
+	};
+	int ret;
+
+	/* Fetch the SFF-8024 Identifier Value. For all supported standards, it
+	 * is located at I2C address 0x50, byte 0. See section 4.1 in SFF-8024,
+	 * revision 4.9.
+	 */
+	ret = nl_get_eeprom_page(ctx, &request);
+	if (ret < 0)
+		return ret;
+
+	switch (request.data[0]) {
+#ifdef ETHTOOL_ENABLE_PRETTY_DUMP
+	case SFF8024_ID_SFP:
+		return sff8079_show_all_nl(ctx);
+	case SFF8024_ID_QSFP:
+	case SFF8024_ID_QSFP28:
+	case SFF8024_ID_QSFP_PLUS:
+		return sff8636_show_all_nl(ctx);
+	case SFF8024_ID_QSFP_DD:
+	case SFF8024_ID_DSFP:
+		return cmis_show_all_nl(ctx);
+#endif
+	default:
+		/* If we cannot recognize the memory map, default to dumping
+		 * the first 128 bytes in hex.
+		 */
+		return eeprom_dump_hex(ctx);
+	}
+}
+
 int nl_getmodule(struct cmd_context *ctx)
 {
 	struct cmd_params getmodule_cmd_params = {};
 	struct ethtool_module_eeprom request = {0};
-	struct ethtool_module_eeprom *reply_page;
 	struct nl_context *nlctx = ctx->nlctx;
-	u32 dump_length;
-	u8 *eeprom_data;
 	int ret;
 
 	if (netlink_cmd_check(ctx, ETHTOOL_MSG_MODULE_EEPROM_GET, false))
@@ -479,12 +267,6 @@ int nl_getmodule(struct cmd_context *ctx)
 		return -EOPNOTSUPP;
 	}
 
-	request.i2c_address = ETH_I2C_ADDRESS_LOW;
-	request.length = 128;
-	ret = page_fetch(nlctx, &request);
-	if (ret)
-		goto cleanup;
-
 #ifdef ETHTOOL_ENABLE_PRETTY_DUMP
 	if (getmodule_cmd_params.page || getmodule_cmd_params.bank ||
 	    getmodule_cmd_params.offset || getmodule_cmd_params.length)
@@ -501,33 +283,22 @@ int nl_getmodule(struct cmd_context *ctx)
 		request.offset = 128;
 
 	if (getmodule_cmd_params.dump_hex || getmodule_cmd_params.dump_raw) {
-		ret = page_fetch(nlctx, &request);
+		ret = nl_get_eeprom_page(ctx, &request);
 		if (ret < 0)
 			goto cleanup;
-		reply_page = cache_get(request.page, request.bank, request.i2c_address);
-		if (!reply_page) {
-			ret = -EINVAL;
-			goto cleanup;
-		}
 
-		eeprom_data = reply_page->data + (request.offset - reply_page->offset);
-		dump_length = reply_page->length < request.length ? reply_page->length
-								  : request.length;
 		if (getmodule_cmd_params.dump_raw)
-			fwrite(eeprom_data, 1, request.length, stdout);
+			fwrite(request.data, 1, request.length, stdout);
 		else
-			dump_hex(stdout, eeprom_data, dump_length, request.offset);
+			dump_hex(stdout, request.data, request.length,
+				 request.offset);
 	} else {
-#ifdef ETHTOOL_ENABLE_PRETTY_DUMP
-		ret = decoder_prefetch(nlctx);
-		if (ret)
+		ret = eeprom_parse(ctx);
+		if (ret < 0)
 			goto cleanup;
-		decoder_print(ctx);
-#endif
 	}
 
 cleanup:
 	eeprom_page_list_flush();
-	cache_free();
 	return ret;
 }
-- 
2.31.1

