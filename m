Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CB95321CEB
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 17:29:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231843AbhBVQ2K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 11:28:10 -0500
Received: from mail.zx2c4.com ([104.131.123.232]:32820 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231700AbhBVQ1K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Feb 2021 11:27:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1614011156;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Z+7fThJ1DMrd5h9xcT9hDeO3ALShvpQVzlOZ35I18cE=;
        b=cAMVFP9hhw2agLuASQkx2ygpW91a3hJGPMRjC8uRHNtxjWsMNX4OzL7web+0cXzhmYLmpW
        Fu7fqx4NApX2LuaIiPEKR4gfabSTn8DzEh56Qv32iEek9FEL0wQHxKmYwR30tZTOjUN5qH
        JKigkCbmQLAAIScZA6hg1v3MYjUHjNo=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 7e050274 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Mon, 22 Feb 2021 16:25:56 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Subject: [PATCH net 2/7] wireguard: socket: remove bogus __be32 annotation
Date:   Mon, 22 Feb 2021 17:25:44 +0100
Message-Id: <20210222162549.3252778-3-Jason@zx2c4.com>
In-Reply-To: <20210222162549.3252778-1-Jason@zx2c4.com>
References: <20210222162549.3252778-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jann Horn <jannh@google.com>

The endpoint->src_if4 has nothing to do with fixed-endian numbers; remove
the bogus annotation.

This was introduced in
https://git.zx2c4.com/wireguard-monolithic-historical/commit?id=14e7d0a499a676ec55176c0de2f9fcbd34074a82
in the historical WireGuard repo because the old code used to
zero-initialize multiple members as follows:

    endpoint->src4.s_addr = endpoint->src_if4 = fl.saddr = 0;

Because fl.saddr is fixed-endian and an assignment returns a value with the
type of its left operand, this meant that sparse detected an assignment
between values of different endianness.

Since then, this assignment was already split up into separate statements;
just the cast survived.

Signed-off-by: Jann Horn <jannh@google.com>
Fixes: e7096c131e51 ("net: WireGuard secure network tunnel")
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/net/wireguard/socket.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireguard/socket.c b/drivers/net/wireguard/socket.c
index 41430c0e465a..d9ad850daa79 100644
--- a/drivers/net/wireguard/socket.c
+++ b/drivers/net/wireguard/socket.c
@@ -53,7 +53,7 @@ static int send4(struct wg_device *wg, struct sk_buff *skb,
 		if (unlikely(!inet_confirm_addr(sock_net(sock), NULL, 0,
 						fl.saddr, RT_SCOPE_HOST))) {
 			endpoint->src4.s_addr = 0;
-			*(__force __be32 *)&endpoint->src_if4 = 0;
+			endpoint->src_if4 = 0;
 			fl.saddr = 0;
 			if (cache)
 				dst_cache_reset(cache);
@@ -63,7 +63,7 @@ static int send4(struct wg_device *wg, struct sk_buff *skb,
 			     PTR_ERR(rt) == -EINVAL) || (!IS_ERR(rt) &&
 			     rt->dst.dev->ifindex != endpoint->src_if4)))) {
 			endpoint->src4.s_addr = 0;
-			*(__force __be32 *)&endpoint->src_if4 = 0;
+			endpoint->src_if4 = 0;
 			fl.saddr = 0;
 			if (cache)
 				dst_cache_reset(cache);
-- 
2.30.1

