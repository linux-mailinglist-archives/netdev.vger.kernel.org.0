Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A6D9608384
	for <lists+netdev@lfdr.de>; Sat, 22 Oct 2022 04:10:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbiJVCK4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 22:10:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbiJVCKy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 22:10:54 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB6B7270836
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 19:10:50 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id pb15so3863446pjb.5
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 19:10:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=dp0M8QaGTosDxslHlGRlCukiGrX1euoV7+LSShJejvQ=;
        b=P1ssKOsDGfAzkbS0J6o4jiEFKiAboRIfCX2SAcxEgTcVO9vc1+K5Sg5TjmSIxZCgFI
         GoNyXhBmBcrAt5ZfHf0dXVi02HlyuP8oEFD8UYBYVvwFZSyE+7bCu2JIAFgq4fqgXP7z
         jFGXOKcAVvCjO4ZbHwMgiSY7EHRorbLDhbfQ4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dp0M8QaGTosDxslHlGRlCukiGrX1euoV7+LSShJejvQ=;
        b=Q0Z7XHiPPgr5LI2jqRdZT1xZ9BK4DRiATOUBoy+xfQx/SjnkpM6VM8L3kPOJC7Mbf6
         +oIAIMnrDqt3vcgOIvA7boXYf8KSFuTASjWHiBa374B6QrkWC3j/whLzG/letxeLbiZb
         kceSeQoEWSTm4vH33X0nqYVMf6jSy/IXkxXhCuPWH5bKOUP7j3FA3PskXpHAnQz7FSho
         0s+plSTwVmQnEmUkUaYs5ieu2zwcasEmj9/q+DTNBxTFhtywGdibbGe88EFUHDv/oLrc
         pl2s3Mol/FWymvOei9snhbtlzSzAFUD8Y1JYpxoNuJuK2kjKhu5fwsz7aJEGhOkQOFBs
         ep0Q==
X-Gm-Message-State: ACrzQf1ov8YbHKZ1/MJ8iYtMtg+GAwh6pNzbNyQwr/LgnsCw8K4jktom
        jtJZiu7ATaYeSXNC+J20r7kuIA==
X-Google-Smtp-Source: AMsMyM6jm2GtYy+3kW0UC6u5jGkSAqsZcb5CSahh4k7vcl8TM7CxQH/X/1BElJpw9hgAtV01pXRtJQ==
X-Received: by 2002:a17:90a:13:b0:212:d139:748a with SMTP id 19-20020a17090a001300b00212d139748amr6201964pja.182.1666404650081;
        Fri, 21 Oct 2022 19:10:50 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id x9-20020a170902ec8900b0018685aaf41dsm935195plg.18.2022.10.21.19.10.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Oct 2022 19:10:49 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Rasesh Mody <rmody@marvell.com>
Cc:     Kees Cook <keescook@chromium.org>, GR-Linux-NIC-Dev@marvell.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: [PATCH v2] bnx2: Use kmalloc_size_roundup() to match ksize() usage
Date:   Fri, 21 Oct 2022 19:10:47 -0700
Message-Id: <20221022021004.gonna.489-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1611; h=from:subject:message-id; bh=lPZ4Wk6QPlApa8DQwhP0RlPQkBfpj7yqelwZL9l0DOE=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBjU1En16msYKz6GI19Alpm5t9/fISZHDbDu9U/jkXb jpPDKhSJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCY1NRJwAKCRCJcvTf3G3AJj2HD/ 9Xt0fOgmZo9iMbVqCVd17EwCvEoJg6/inBTNKzuruzFllB69/8PiuUxO5yQjwycpmkBKlYiizirjyM DdMZBMxdYjDflL5Qf3km4kI+yoPaHnD6kGAFUKUzoaQyp11oYaDk9iG5lDug734TySlRmf128kXMqE o79eZXtP6Q2+9ytiDwJUTuMmyK6ZY6LKXmhA2rU6JbrTmNuvh/jTfn0DI6+TFKQ3Jlv49KX8P9hLRk dXjIFQvOvBYgoOE7blbgaJ2eCRf8wVCxxPu+rJ2bwShBKN458wFIDJF20VvHNzqWwYUgUROndiTrUW r3Yw/nYjS9i58GRSkOouNSLpMPMmLeIuUgOtmbVPQ3uCOYFxbhB85KBBReeiHJcF5BTCZU1ayyaWAt fvx5KqtrtmbaDu+ynQFgCXokDdoFYE72DXfxHJ7yzWe1SRuTEV3eY3iqKsQ8g8kfUTVUBKT8MBGY4X t4Av1NiZxXz8BHB/BuoGTJvUtNjnLRZpxU8+Ku4SJ0//btZ33zNENR+3h4Iwi/nIAl+LadgaGnNTTz 4oIP9d7w7Lfa28Uq63RqBENtxFybsE/JaAlVmJ15aNAtOtGqDbBCDjGcYGRDJeRBzpNWqWpb8dPt79 iqPS9R68WYUuIR/nxj0Dv1yxC9R6RqMh8VfoWH+XK1i2yCJDkHTe8CQC3xlA==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Round up allocations with kmalloc_size_roundup() so that build_skb()'s
use of ksize() is always accurate and no special handling of the memory
is needed by KASAN, UBSAN_BOUNDS, nor FORTIFY_SOURCE.

Cc: Rasesh Mody <rmody@marvell.com>
Cc: GR-Linux-NIC-Dev@marvell.com
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
v2: use kmalloc_size_roundup() instead of replacing build_skb() argument
v1: https://lore.kernel.org/lkml/20221018085911.never.761-kees@kernel.org/
---
 drivers/net/ethernet/broadcom/bnx2.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2.c b/drivers/net/ethernet/broadcom/bnx2.c
index fec57f1982c8..dbe310144780 100644
--- a/drivers/net/ethernet/broadcom/bnx2.c
+++ b/drivers/net/ethernet/broadcom/bnx2.c
@@ -5415,8 +5415,9 @@ bnx2_set_rx_ring_size(struct bnx2 *bp, u32 size)
 
 	bp->rx_buf_use_size = rx_size;
 	/* hw alignment + build_skb() overhead*/
-	bp->rx_buf_size = SKB_DATA_ALIGN(bp->rx_buf_use_size + BNX2_RX_ALIGN) +
-		NET_SKB_PAD + SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
+	bp->rx_buf_size = kmalloc_size_roundup(
+		SKB_DATA_ALIGN(bp->rx_buf_use_size + BNX2_RX_ALIGN) +
+		NET_SKB_PAD + SKB_DATA_ALIGN(sizeof(struct skb_shared_info)));
 	bp->rx_jumbo_thresh = rx_size - BNX2_RX_OFFSET;
 	bp->rx_ring_size = size;
 	bp->rx_max_ring = bnx2_find_max_ring(size, BNX2_MAX_RX_RINGS);
-- 
2.34.1

