Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EE7EABD35
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 18:01:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395030AbfIFQBS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 12:01:18 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:36762 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2395023AbfIFQBR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 12:01:17 -0400
Received: by mail-wm1-f65.google.com with SMTP id p13so7710302wmh.1
        for <netdev@vger.kernel.org>; Fri, 06 Sep 2019 09:01:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Dcj/mXlOQpUiLA4AlOf/wtwWLYZIEfaK15WEJ2S4g6c=;
        b=2INgNlDbve0pcWH/YvpfFj4g2CBxta+vFy+a4M4ujIbT1/ts0054uD+Nel647Dq2Xk
         eqD2ZWij3J2P1UzWkGXkn48UDhlAScp4z2GfN36lz5paoJXsTBC/HhrQ09vw5xYt4DzJ
         JVN/GifOKmhIncEIuJqEuZzDbIXYEJ1WMjgG0li7tFwPOhM/6aSCyxvWlyL+09duFk5A
         E0C2k/fHIsxY8kIqDPix6AURogC473lpf5q9fUQ7fteUqmNIraIB+J7A2YPPE5ZejP3K
         WqdhXF9tFT84uSftkTFrkRZBC0r5YwNXVF/g+TrhDR8jNXv0pVyHK9Ok5DCfWHFMCMTI
         Z9Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Dcj/mXlOQpUiLA4AlOf/wtwWLYZIEfaK15WEJ2S4g6c=;
        b=p1wPIpB7zsJ5NCwjVPKUDTKf4OSfhP6nztCwdG9s+iGXpEKWvaLS7vohnr4qCj7/8D
         cTr99B6pL/1+ZrZyjQ87ogwNMVPP/8jJDB35BeXTRsX29rjcVard+ECCQTQg+XA/alzU
         0oOiHWssydQbKdLKg0FnT3IhvKhlEXfDOP+H0aTvv0WPQI14MJUA64AlJr9ZRmvRi8mY
         AqihVpZ+l1liVwLhm1eCZVa9Mu31LvQ0txbSpKQf0z/sQd7suyUwoSYoTmoiHnVWBqWU
         efHfqWQcGYe/8plEC4cLSILX7nm/6YCs85qcdZ8TGIPmfAbpAWr8HRLL/O4PUh5sMpnc
         TRfQ==
X-Gm-Message-State: APjAAAXPrg7ynEYNNT1IcW83tnC0i3ygPJ/l37jGd4UVs868tSollaYg
        THoG8dxH+MOtKWbyf3pqcRdP4A==
X-Google-Smtp-Source: APXvYqz13tNtSHQqnTiUoIDLVdgasUS98dMzWWljerfqE1O6I6Ei9TLEuKUnAF/Lgvaw/Bfj70Ehqw==
X-Received: by 2002:a05:600c:3d0:: with SMTP id z16mr7199914wmd.32.1567785675863;
        Fri, 06 Sep 2019 09:01:15 -0700 (PDT)
Received: from reginn.com ([2001:982:756:703:d63d:7eff:fe99:ac9d])
        by smtp.gmail.com with ESMTPSA id s1sm8524567wrg.80.2019.09.06.09.01.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Sep 2019 09:01:15 -0700 (PDT)
From:   Simon Horman <simon.horman@netronome.com>
To:     David Miller <davem@davemloft.net>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        netdev@vger.kernel.org, oss-drivers@netronome.com,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>,
        Simon Horman <simon.horman@netronome.com>
Subject: [net-next 04/11] nfp: nsp: add support for optional hwinfo lookup
Date:   Fri,  6 Sep 2019 18:00:54 +0200
Message-Id: <20190906160101.14866-5-simon.horman@netronome.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190906160101.14866-1-simon.horman@netronome.com>
References: <20190906160101.14866-1-simon.horman@netronome.com>
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
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
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

