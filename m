Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66BBD461B36
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 16:41:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232627AbhK2PpF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 10:45:05 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:32896 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237054AbhK2PnE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 10:43:04 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 75AD9CE12D0;
        Mon, 29 Nov 2021 15:39:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52432C53FCB;
        Mon, 29 Nov 2021 15:39:43 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="S91NTsrU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1638200382;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=39rtvmyQkASHibXn0481p6iRu+YyqRAhHuCQzIOi/bY=;
        b=S91NTsrUmNPFHIqeUIGEUnXG9uCX/R5AfRXclEkPNizXSHZKBahuuORniHJekJc8d4waDC
        Til8F2zM1cGCmDrTWvNyAGKU4o4SrgiLynwAZsHmD6OyXAElInOhfM8uE6tB+EoW6u19y2
        By3Np4iQy2zZxUCc8UMNNjeFQhVhzk4=
Received: by mail.zx2c4.com (OpenSMTPD) with ESMTPSA id ca7d0c61 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Mon, 29 Nov 2021 15:39:42 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>, stable@vger.kernel.org
Subject: [PATCH net 01/10] wireguard: allowedips: add missing __rcu annotation to satisfy sparse
Date:   Mon, 29 Nov 2021 10:39:20 -0500
Message-Id: <20211129153929.3457-2-Jason@zx2c4.com>
In-Reply-To: <20211129153929.3457-1-Jason@zx2c4.com>
References: <20211129153929.3457-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A __rcu annotation got lost during refactoring, which caused sparse to
become enraged.

Fixes: bf7b042dc62a ("wireguard: allowedips: free empty intermediate nodes when removing single node")
Cc: stable@vger.kernel.org
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/net/wireguard/allowedips.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireguard/allowedips.c b/drivers/net/wireguard/allowedips.c
index b7197e80f226..9a4c8ff32d9d 100644
--- a/drivers/net/wireguard/allowedips.c
+++ b/drivers/net/wireguard/allowedips.c
@@ -163,7 +163,7 @@ static bool node_placement(struct allowedips_node __rcu *trie, const u8 *key,
 	return exact;
 }
 
-static inline void connect_node(struct allowedips_node **parent, u8 bit, struct allowedips_node *node)
+static inline void connect_node(struct allowedips_node __rcu **parent, u8 bit, struct allowedips_node *node)
 {
 	node->parent_bit_packed = (unsigned long)parent | bit;
 	rcu_assign_pointer(*parent, node);
-- 
2.34.1

