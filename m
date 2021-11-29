Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92922461D06
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 18:50:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343745AbhK2Rxt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 12:53:49 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:37942 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242871AbhK2Rvs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 12:51:48 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id DD62DCE132B
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 17:48:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA955C53FAD
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 17:48:27 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="WFKu0J/e"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1638208107;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gzQGL+TDRIbxJKNobwNPjcZuWrl+JWU730AGRPtU4y4=;
        b=WFKu0J/eQopRBAcRm25eElJQhTgslvMA/9Nd+k03zm7iPf1hS8fskQW/97IGXGSQVOpVYY
        VgRkU6vLOnhoTCgFkSsqRGwlvAozKiHF8egk9V3Ql4zUu3Jq5CgLDfL+pMxrz+B790KBUb
        HJBNvgzju87GvnCLyWvzjWi4XcI3yvs=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 7b507265 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO)
        for <netdev@vger.kernel.org>;
        Mon, 29 Nov 2021 17:48:27 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        stable@vger.kernel.org, "Jason A . Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH net 09/10] wireguard: ratelimiter: use kvcalloc() instead of kvzalloc()
Date:   Mon, 29 Nov 2021 10:39:28 -0500
Message-Id: <20211129153929.3457-10-Jason@zx2c4.com>
In-Reply-To: <20211129153929.3457-1-Jason@zx2c4.com>
References: <20211129153929.3457-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Gustavo A. R. Silva" <gustavoars@kernel.org>

Use 2-factor argument form kvcalloc() instead of kvzalloc().

Link: https://github.com/KSPP/linux/issues/162
Cc: stable@vger.kernel.org
Fixes: e7096c131e51 ("net: WireGuard secure network tunnel")
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
[Jason: Gustavo's link above is for KSPP, but this isn't actually a
 security fix, as table_size is bounded to 8192 anyway, and gcc realizes
 this, so the codegen comes out to be about the same.]
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/net/wireguard/ratelimiter.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireguard/ratelimiter.c b/drivers/net/wireguard/ratelimiter.c
index 3fedd1d21f5e..dd55e5c26f46 100644
--- a/drivers/net/wireguard/ratelimiter.c
+++ b/drivers/net/wireguard/ratelimiter.c
@@ -176,12 +176,12 @@ int wg_ratelimiter_init(void)
 			(1U << 14) / sizeof(struct hlist_head)));
 	max_entries = table_size * 8;
 
-	table_v4 = kvzalloc(table_size * sizeof(*table_v4), GFP_KERNEL);
+	table_v4 = kvcalloc(table_size, sizeof(*table_v4), GFP_KERNEL);
 	if (unlikely(!table_v4))
 		goto err_kmemcache;
 
 #if IS_ENABLED(CONFIG_IPV6)
-	table_v6 = kvzalloc(table_size * sizeof(*table_v6), GFP_KERNEL);
+	table_v6 = kvcalloc(table_size, sizeof(*table_v6), GFP_KERNEL);
 	if (unlikely(!table_v6)) {
 		kvfree(table_v4);
 		goto err_kmemcache;
-- 
2.34.1

