Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97CDC462052
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 20:21:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348241AbhK2TYR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 14:24:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378113AbhK2TWQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 14:22:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 665C1C09B10A;
        Mon, 29 Nov 2021 07:39:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 04A526156C;
        Mon, 29 Nov 2021 15:39:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65DE7C53FCF;
        Mon, 29 Nov 2021 15:39:52 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="JQKzd3uj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1638200391;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gzQGL+TDRIbxJKNobwNPjcZuWrl+JWU730AGRPtU4y4=;
        b=JQKzd3ujn1rh/0kLkAyWL3UpTgVciUyRxL8YWzyHCDksKRXUrztcVesydyv6/BpbylA9jp
        h7wKHLg/TLfYIuq0Ldd0m5v4q/IhNzJ+N4xSZuAGyQ7Lm75sdpHWYmUVT159KHOh5XfFl7
        VF+IngAaszU0Jfb75TgpQmuK/Y3TfT8=
Received: by mail.zx2c4.com (OpenSMTPD) with ESMTPSA id 6bbbef5a (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Mon, 29 Nov 2021 15:39:51 +0000 (UTC)
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

