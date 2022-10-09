Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B323C5F91C2
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 00:40:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233192AbiJIWkm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 18:40:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233459AbiJIWkM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 18:40:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 567BB40E3C;
        Sun,  9 Oct 2022 15:21:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B8F61B80DCD;
        Sun,  9 Oct 2022 22:21:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0988AC433C1;
        Sun,  9 Oct 2022 22:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665354087;
        bh=2iUEDWD1ezspTCzc9bg+WDR4WYNaE+zGwReBsYIZA+Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uV37X/44DgAdhNNtx27kwFEMWFneuR2dOVHtXpaINpY/R/0fgSR5m50aX+D/T6u2l
         jUDpqS6KIqwBBjsHEWe+7GlQZnyRhP5WFNGCv5z1SxaNVHVPCZ4oaakJ5H+wnRQLiy
         /1YOg0GfyBwNanU1pIEve+YgI9jtJkCvULT0g1InaKyXgL1FbZLQMwauIfMrGhCY66
         ExqaLOC22rNvnyLaMhy6JO6M8MYmfT72WIhyMeeO/8ydFFocxfKwP+I+GBIheFLZoY
         P81vee3WU2f1UQrhLjFAIBE/djWxt2sNRz/fOVmPOkcs61+hz5MmjJTd77tQFpdDSU
         rSjG4Dsllbsgw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrew Gaul <gaul@gaul.org>, Andrew Gaul <gaul@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, hayeswang@realtek.com,
        aaron.ma@canonical.com, jflf_kernel@gmx.com, svenva@chromium.org,
        dober6023@gmail.com, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 46/46] r8152: Rate limit overflow messages
Date:   Sun,  9 Oct 2022 18:19:11 -0400
Message-Id: <20221009221912.1217372-46-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009221912.1217372-1-sashal@kernel.org>
References: <20221009221912.1217372-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Gaul <gaul@gaul.org>

[ Upstream commit 93e2be344a7db169b7119de21ac1bf253b8c6907 ]

My system shows almost 10 million of these messages over a 24-hour
period which pollutes my logs.

Signed-off-by: Andrew Gaul <gaul@google.com>
Link: https://lore.kernel.org/r/20221002034128.2026653-1-gaul@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/r8152.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 7e821bed91ce..c7169243aa6e 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -1871,7 +1871,9 @@ static void intr_callback(struct urb *urb)
 			   "Stop submitting intr, status %d\n", status);
 		return;
 	case -EOVERFLOW:
-		netif_info(tp, intr, tp->netdev, "intr status -EOVERFLOW\n");
+		if (net_ratelimit())
+			netif_info(tp, intr, tp->netdev,
+				   "intr status -EOVERFLOW\n");
 		goto resubmit;
 	/* -EPIPE:  should clear the halt */
 	default:
-- 
2.35.1

