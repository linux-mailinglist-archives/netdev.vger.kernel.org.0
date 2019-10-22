Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC2CDE0726
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 17:18:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731573AbfJVPSY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 11:18:24 -0400
Received: from imap1.codethink.co.uk ([176.9.8.82]:60425 "EHLO
        imap1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731220AbfJVPSY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 11:18:24 -0400
Received: from [167.98.27.226] (helo=rainbowdash.codethink.co.uk)
        by imap1.codethink.co.uk with esmtpsa (Exim 4.84_2 #1 (Debian))
        id 1iMvvP-00067a-C6; Tue, 22 Oct 2019 16:18:19 +0100
Received: from ben by rainbowdash.codethink.co.uk with local (Exim 4.92.3)
        (envelope-from <ben@rainbowdash.codethink.co.uk>)
        id 1iMvvP-0005Ze-0Q; Tue, 22 Oct 2019 16:18:19 +0100
From:   "Ben Dooks (Codethink)" <ben.dooks@codethink.co.uk>
To:     linux-kernel@lists.codethink.co.uk
Cc:     "Ben Dooks (Codethink)" <ben.dooks@codethink.co.uk>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: hwbm: if CONFIG_NET_HWBM unset, make stub functions static
Date:   Tue, 22 Oct 2019 16:18:18 +0100
Message-Id: <20191022151818.21383-1-ben.dooks@codethink.co.uk>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If CONFIG_NET_HWBM is not set, then these stub functions in
<net/hwbm.h> should be declared static to avoid trying to
export them from any driver that includes this.

Note, add __maybe_unused as the marvell mvneta.c driver will
otherwise cause gcc warnings from these.

Fixes the following sparse warnings:

./include/net/hwbm.h:24:6: warning: symbol 'hwbm_buf_free' was not declared. Should it be static?
./include/net/hwbm.h:25:5: warning: symbol 'hwbm_pool_refill' was not declared. Should it be static?
./include/net/hwbm.h:26:5: warning: symbol 'hwbm_pool_add' was not declared. Should it be static?

Signed-off-by: Ben Dooks (Codethink) <ben.dooks@codethink.co.uk>
---
Cc: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 include/net/hwbm.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/net/hwbm.h b/include/net/hwbm.h
index 81643cf8a1c4..cb5e6de8b7cd 100644
--- a/include/net/hwbm.h
+++ b/include/net/hwbm.h
@@ -21,9 +21,9 @@ void hwbm_buf_free(struct hwbm_pool *bm_pool, void *buf);
 int hwbm_pool_refill(struct hwbm_pool *bm_pool, gfp_t gfp);
 int hwbm_pool_add(struct hwbm_pool *bm_pool, unsigned int buf_num);
 #else
-void hwbm_buf_free(struct hwbm_pool *bm_pool, void *buf) {}
-int hwbm_pool_refill(struct hwbm_pool *bm_pool, gfp_t gfp) { return 0; }
-int hwbm_pool_add(struct hwbm_pool *bm_pool, unsigned int buf_num)
+static void __maybe_unused hwbm_buf_free(struct hwbm_pool *bm_pool, void *buf) {}
+static int __maybe_unused hwbm_pool_refill(struct hwbm_pool *bm_pool, gfp_t gfp) { return 0; }
+static int __maybe_unused hwbm_pool_add(struct hwbm_pool *bm_pool, unsigned int buf_num)
 { return 0; }
 #endif /* CONFIG_HWBM */
 #endif /* _HWBM_H */
-- 
2.23.0

