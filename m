Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F43BFD44D
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 06:30:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727298AbfKOF35 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 00:29:57 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:43340 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727217AbfKOF3r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 00:29:47 -0500
Received: by mail-pf1-f193.google.com with SMTP id 3so5852446pfb.10
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 21:29:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=C9I5FqW0z8fenw97nfBVEeoAsOoFr9Mv0e0uFaFX9H0=;
        b=KdyazIcVt/KrZ4Q4dPukr55+0f+LWN3FdURkiejEjDxeIaipIHVsXos1gZ7NOv5oAC
         nBCU6ZcNEllQVcTxPM68PAW4OKdhuUVgvhoaKG9dWWFK2T3anLrxqjrWgpudcjZfD4Mh
         ArgbCrLslQ6DK1H1FpXuVXtZvw6Lu0L2HKHTs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=C9I5FqW0z8fenw97nfBVEeoAsOoFr9Mv0e0uFaFX9H0=;
        b=sWSeEqNJE+HV59PY5ihhmHCtip5NaKzOWBK2bZQwWTNpTgHSvwlfF2FmZIR5CDcXeO
         91J8CXpYE2mB0oHzI8dvDQEzqLhdvbN3L6oAWQxOoe0cP6idOxh8YOJ1mgk8AI6hy/Im
         q/2RRKpCUKra9BVdRfZCBxgqqAS34WCqXGkw/ituTRXkH0J+7EKl99LZMXukE2ToUoGm
         YF/fryPe9m64uljrMxdRfTMVHGxi2wArZPErMoT5UtCh3xEWUto5I/OW13AecnmgfY4+
         772T3k7n3/SEgY2P9OEInTLpw7LFrbhJxMzdqnY5cCigbReP4FsfIpWFEDuZZdst5+VG
         kSrw==
X-Gm-Message-State: APjAAAWLSY2LAIsYObmBdDfms3+wG3BmznGfWHrcwwfE8VksOXCq/LY4
        rORXBv893dEDZSHVM2V19b/R4A==
X-Google-Smtp-Source: APXvYqwc5nrGGxexFGky4nRCM5cHAELptoH7k4Z94evZphJre2euyv6XPNoAvpYGEjuz34jD3TFjNQ==
X-Received: by 2002:a63:535c:: with SMTP id t28mr1441537pgl.173.1573795786355;
        Thu, 14 Nov 2019 21:29:46 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id r33sm8438101pjb.5.2019.11.14.21.29.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2019 21:29:42 -0800 (PST)
From:   Kees Cook <keescook@chromium.org>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Kees Cook <keescook@chromium.org>,
        Ariel Elior <aelior@marvell.com>,
        Sudarsana Kalluru <skalluru@marvell.com>,
        GR-everest-linux-l2@marvell.com,
        Sami Tolvanen <samitolvanen@google.com>,
        netdev@vger.kernel.org, kernel-hardening@lists.openwall.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] bnx2x: Remove hw_reset_t function casts
Date:   Thu, 14 Nov 2019 21:07:15 -0800
Message-Id: <20191115050715.6247-6-keescook@chromium.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191115050715.6247-1-keescook@chromium.org>
References: <20191115050715.6247-1-keescook@chromium.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All .rw_reset callbacks except bnx2x_84833_hw_reset_phy() use a
void return type. No callers of .hw_reset check a return value and
bnx2x_84833_hw_reset_phy() unconditionally returns 0. Remove all
hw_reset_t casts and fix the return type to void.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 .../net/ethernet/broadcom/bnx2x/bnx2x_link.c  | 20 +++++++++----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c
index 7dd35aa75925..9638d65d8261 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c
@@ -10201,8 +10201,8 @@ static u8 bnx2x_84833_get_reset_gpios(struct bnx2x *bp,
 	return reset_gpios;
 }
 
-static int bnx2x_84833_hw_reset_phy(struct bnx2x_phy *phy,
-				struct link_params *params)
+static void bnx2x_84833_hw_reset_phy(struct bnx2x_phy *phy,
+				     struct link_params *params)
 {
 	struct bnx2x *bp = params->bp;
 	u8 reset_gpios;
@@ -10230,8 +10230,6 @@ static int bnx2x_84833_hw_reset_phy(struct bnx2x_phy *phy,
 	udelay(10);
 	DP(NETIF_MSG_LINK, "84833 hw reset on pin values 0x%x\n",
 		reset_gpios);
-
-	return 0;
 }
 
 static int bnx2x_8483x_disable_eee(struct bnx2x_phy *phy,
@@ -11737,7 +11735,7 @@ static const struct bnx2x_phy phy_warpcore = {
 	.link_reset	= bnx2x_warpcore_link_reset,
 	.config_loopback = bnx2x_set_warpcore_loopback,
 	.format_fw_ver	= NULL,
-	.hw_reset	= (hw_reset_t)bnx2x_warpcore_hw_reset,
+	.hw_reset	= bnx2x_warpcore_hw_reset,
 	.set_link_led	= NULL,
 	.phy_specific_func = NULL
 };
@@ -11768,7 +11766,7 @@ static const struct bnx2x_phy phy_7101 = {
 	.link_reset	= bnx2x_common_ext_link_reset,
 	.config_loopback = bnx2x_7101_config_loopback,
 	.format_fw_ver	= bnx2x_7101_format_ver,
-	.hw_reset	= (hw_reset_t)bnx2x_7101_hw_reset,
+	.hw_reset	= bnx2x_7101_hw_reset,
 	.set_link_led	= bnx2x_7101_set_link_led,
 	.phy_specific_func = NULL
 };
@@ -11919,7 +11917,7 @@ static const struct bnx2x_phy phy_8727 = {
 	.link_reset	= bnx2x_8727_link_reset,
 	.config_loopback = NULL,
 	.format_fw_ver	= bnx2x_format_ver,
-	.hw_reset	= (hw_reset_t)bnx2x_8727_hw_reset,
+	.hw_reset	= bnx2x_8727_hw_reset,
 	.set_link_led	= bnx2x_8727_set_link_led,
 	.phy_specific_func = bnx2x_8727_specific_func
 };
@@ -11954,7 +11952,7 @@ static const struct bnx2x_phy phy_8481 = {
 	.link_reset	= bnx2x_8481_link_reset,
 	.config_loopback = NULL,
 	.format_fw_ver	= bnx2x_848xx_format_ver,
-	.hw_reset	= (hw_reset_t)bnx2x_8481_hw_reset,
+	.hw_reset	= bnx2x_8481_hw_reset,
 	.set_link_led	= bnx2x_848xx_set_link_led,
 	.phy_specific_func = NULL
 };
@@ -12026,7 +12024,7 @@ static const struct bnx2x_phy phy_84833 = {
 	.link_reset	= bnx2x_848x3_link_reset,
 	.config_loopback = NULL,
 	.format_fw_ver	= bnx2x_848xx_format_ver,
-	.hw_reset	= (hw_reset_t)bnx2x_84833_hw_reset_phy,
+	.hw_reset	= bnx2x_84833_hw_reset_phy,
 	.set_link_led	= bnx2x_848xx_set_link_led,
 	.phy_specific_func = bnx2x_848xx_specific_func
 };
@@ -12060,7 +12058,7 @@ static const struct bnx2x_phy phy_84834 = {
 	.link_reset	= bnx2x_848x3_link_reset,
 	.config_loopback = NULL,
 	.format_fw_ver	= bnx2x_848xx_format_ver,
-	.hw_reset	= (hw_reset_t)bnx2x_84833_hw_reset_phy,
+	.hw_reset	= bnx2x_84833_hw_reset_phy,
 	.set_link_led	= bnx2x_848xx_set_link_led,
 	.phy_specific_func = bnx2x_848xx_specific_func
 };
@@ -12094,7 +12092,7 @@ static const struct bnx2x_phy phy_84858 = {
 	.link_reset	= bnx2x_848x3_link_reset,
 	.config_loopback = NULL,
 	.format_fw_ver	= bnx2x_8485x_format_ver,
-	.hw_reset	= (hw_reset_t)bnx2x_84833_hw_reset_phy,
+	.hw_reset	= bnx2x_84833_hw_reset_phy,
 	.set_link_led	= bnx2x_848xx_set_link_led,
 	.phy_specific_func = bnx2x_848xx_specific_func
 };
-- 
2.17.1

