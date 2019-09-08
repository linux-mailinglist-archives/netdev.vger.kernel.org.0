Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BE73AD149
	for <lists+netdev@lfdr.de>; Mon,  9 Sep 2019 01:55:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731567AbfIHXy7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Sep 2019 19:54:59 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:41883 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731203AbfIHXy6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Sep 2019 19:54:58 -0400
Received: by mail-qt1-f193.google.com with SMTP id j10so14097941qtp.8
        for <netdev@vger.kernel.org>; Sun, 08 Sep 2019 16:54:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=WDphX/abkNdZSGaPRzwpnuRj8Go4BGIGepFdRBH1BMI=;
        b=BL6NWDhFPi5vUfygojrLJu38UtoHD+BZGK9mqtDy5SWjSVMmUcWmy9k2uKhGjt1SDe
         qJ19KZ7YR1p6AtcbYunqpl+5GbiK898HTigJuUgskbtRETft8wsLdI8pxX86oLupqQkG
         2KW02KUtN4TqypfSE2PQQI2Oq0/2JGYA4AL8EEvHZ/XB8yWUM8mYKDT7vWe3mAN3hd42
         fjvZQU6Ay8PSR1O+8cTxRxcKqbu2ZivNT42chTsCiQhkLmVtH/v+PDrfPA3YF9TYML3W
         3axlm2A44nb/APpb3mSL7IHBHYanqskrZasekZ5hsxRL4h+7jT2cfaRD0CEaDCxaTiEh
         2UFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=WDphX/abkNdZSGaPRzwpnuRj8Go4BGIGepFdRBH1BMI=;
        b=aZP9Fye44oTJIYUcQYRv3VW1TyvngcC8Hg8gKHmnHHftLDO8KY/peTqurwUB7fb6Is
         g1c1CB/l3+VnguAa8pBECFY15p5xpN48yRm9nsoD9zk+irknIKH/oVmI3QutjnBJ75Vv
         ab81fz4O1klr8ADjP/X/1P68wcLL+gEbcckdML1OmhOwLquJHwzW1GF6Ulh9LsyuIIq3
         hYf0I0U6GZVgzWkJRonyQ2DotyQpq9BJVXjeSoeJ5kBqC8/9UyMYNUhvoLr9GEpSFQKc
         DJFsTxXO377qDWQXV+fNhNZYDe9q5aH33kQZulpKtWzvwPe/c4SKfU5UDFIQBnawGbdr
         WuNA==
X-Gm-Message-State: APjAAAUm0w6LTD4GvKOlYVCRGojJKy4Qy7aKOMBCcSr9aIWLvWjuleb2
        9MG7DJtSngLi1giuy8LE1s+M7w==
X-Google-Smtp-Source: APXvYqy0QlJABfYGD8lSh+arrtx00wg3RWcfon+878LsBp0sKnWywPaujeMcUkWHcIpak3YaSDwEqA==
X-Received: by 2002:ac8:7612:: with SMTP id t18mr20032874qtq.94.1567986896923;
        Sun, 08 Sep 2019 16:54:56 -0700 (PDT)
Received: from penelope.pa.netronome.com (195-23-252-147.net.novis.pt. [195.23.252.147])
        by smtp.gmail.com with ESMTPSA id p27sm5464406qkm.92.2019.09.08.16.54.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 08 Sep 2019 16:54:56 -0700 (PDT)
From:   Simon Horman <simon.horman@netronome.com>
To:     David Miller <davem@davemloft.net>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        netdev@vger.kernel.org, oss-drivers@netronome.com,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>,
        Simon Horman <simon.horman@netronome.com>
Subject: [PATCH net-next v2 04/11] nfp: nsp: add support for optional hwinfo lookup
Date:   Mon,  9 Sep 2019 00:54:20 +0100
Message-Id: <20190908235427.9757-5-simon.horman@netronome.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190908235427.9757-1-simon.horman@netronome.com>
References: <20190908235427.9757-1-simon.horman@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dirk van der Merwe <dirk.vandermerwe@netronome.com>

There are cases where we want to read a hwinfo entry from the NFP, and
if it doesn't exist, use a default value instead.

To support this, we must silence warning/error messages when the hwinfo
entry doesn't exist since this is a valid use case. The NSP command
structure provides the ability to silence command errors, in which case
the caller should log any command errors appropriately. Protocol errors
are unaffected by this.

Signed-off-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Simon Horman <simon.horman@netronome.com>
---
 .../net/ethernet/netronome/nfp/nfpcore/nfp_nsp.c   | 52 ++++++++++++++++++++--
 .../net/ethernet/netronome/nfp/nfpcore/nfp_nsp.h   |  2 +
 2 files changed, 50 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.c b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.c
index b4c5dc5f7404..deee91cbf1b2 100644
--- a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.c
+++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.c
@@ -144,6 +144,8 @@ struct nfp_nsp {
  * @option:	NFP SP Command Argument
  * @buf:	NFP SP Buffer Address
  * @error_cb:	Callback for interpreting option if error occurred
+ * @error_quiet:Don't print command error/warning. Protocol errors are still
+ *		    logged.
  */
 struct nfp_nsp_command_arg {
 	u16 code;
@@ -152,6 +154,7 @@ struct nfp_nsp_command_arg {
 	u32 option;
 	u64 buf;
 	void (*error_cb)(struct nfp_nsp *state, u32 ret_val);
+	bool error_quiet;
 };
 
 /**
@@ -406,8 +409,10 @@ __nfp_nsp_command(struct nfp_nsp *state, const struct nfp_nsp_command_arg *arg)
 
 	err = FIELD_GET(NSP_STATUS_RESULT, reg);
 	if (err) {
-		nfp_warn(cpp, "Result (error) code set: %d (%d) command: %d\n",
-			 -err, (int)ret_val, arg->code);
+		if (!arg->error_quiet)
+			nfp_warn(cpp, "Result (error) code set: %d (%d) command: %d\n",
+				 -err, (int)ret_val, arg->code);
+
 		if (arg->error_cb)
 			arg->error_cb(state, ret_val);
 		else
@@ -892,12 +897,14 @@ int nfp_nsp_load_stored_fw(struct nfp_nsp *state)
 }
 
 static int
-__nfp_nsp_hwinfo_lookup(struct nfp_nsp *state, void *buf, unsigned int size)
+__nfp_nsp_hwinfo_lookup(struct nfp_nsp *state, void *buf, unsigned int size,
+			bool optional)
 {
 	struct nfp_nsp_command_buf_arg hwinfo_lookup = {
 		{
 			.code		= SPCODE_HWINFO_LOOKUP,
 			.option		= size,
+			.error_quiet	= optional,
 		},
 		.in_buf		= buf,
 		.in_size	= size,
@@ -914,7 +921,7 @@ int nfp_nsp_hwinfo_lookup(struct nfp_nsp *state, void *buf, unsigned int size)
 
 	size = min_t(u32, size, NFP_HWINFO_LOOKUP_SIZE);
 
-	err = __nfp_nsp_hwinfo_lookup(state, buf, size);
+	err = __nfp_nsp_hwinfo_lookup(state, buf, size, false);
 	if (err)
 		return err;
 
@@ -926,6 +933,43 @@ int nfp_nsp_hwinfo_lookup(struct nfp_nsp *state, void *buf, unsigned int size)
 	return 0;
 }
 
+int nfp_nsp_hwinfo_lookup_optional(struct nfp_nsp *state, void *buf,
+				   unsigned int size, const char *default_val)
+{
+	int err;
+
+	/* Ensure that the default value is usable irrespective of whether
+	 * it is actually going to be used.
+	 */
+	if (strnlen(default_val, size) == size)
+		return -EINVAL;
+
+	if (!nfp_nsp_has_hwinfo_lookup(state)) {
+		strcpy(buf, default_val);
+		return 0;
+	}
+
+	size = min_t(u32, size, NFP_HWINFO_LOOKUP_SIZE);
+
+	err = __nfp_nsp_hwinfo_lookup(state, buf, size, true);
+	if (err) {
+		if (err == -ENOENT) {
+			strcpy(buf, default_val);
+			return 0;
+		}
+
+		nfp_err(state->cpp, "NSP HWinfo lookup failed: %d\n", err);
+		return err;
+	}
+
+	if (strnlen(buf, size) == size) {
+		nfp_err(state->cpp, "NSP HWinfo value not NULL-terminated\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 int nfp_nsp_fw_loaded(struct nfp_nsp *state)
 {
 	const struct nfp_nsp_command_arg arg = {
diff --git a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.h b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.h
index 4ceecff347c6..a8985c2eb1f1 100644
--- a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.h
+++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.h
@@ -22,6 +22,8 @@ int nfp_nsp_write_flash(struct nfp_nsp *state, const struct firmware *fw);
 int nfp_nsp_mac_reinit(struct nfp_nsp *state);
 int nfp_nsp_load_stored_fw(struct nfp_nsp *state);
 int nfp_nsp_hwinfo_lookup(struct nfp_nsp *state, void *buf, unsigned int size);
+int nfp_nsp_hwinfo_lookup_optional(struct nfp_nsp *state, void *buf,
+				   unsigned int size, const char *default_val);
 int nfp_nsp_fw_loaded(struct nfp_nsp *state);
 int nfp_nsp_read_module_eeprom(struct nfp_nsp *state, int eth_index,
 			       unsigned int offset, void *data,
-- 
2.11.0

