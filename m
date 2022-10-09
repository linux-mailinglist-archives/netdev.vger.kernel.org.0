Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 609E75F9296
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 00:50:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232901AbiJIWuB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 18:50:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233065AbiJIWs0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 18:48:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 487B738444;
        Sun,  9 Oct 2022 15:24:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F2B5E60C2B;
        Sun,  9 Oct 2022 22:23:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3981C433D6;
        Sun,  9 Oct 2022 22:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665354183;
        bh=gFrW7cGD5JJ4ll2P3SrnHW8IEKo4ms+qt3S6ja08OKM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=powlyeuP6sZk2roy5xM/QPpGVcWkLIKawAgopO+hJCZrPKZsqIcowy9QFHAl1JnFj
         MMjXWGwJtOg/5wqrnkartkz5drsXFVEcTc6nqEvLK5Fc0jfq9lKHsZNXTKcIm7Op81
         JPXaF5yydEGoi0GrEiQHlAQtWRwI+KqI/4FrD1hqqHgJCuJUFNOEjW03lrwQ+YTaLV
         OWk7YW5eXAcHJFfM9anK+fub9/Grngsa9pJvpZk5BtKAtCHnxB0anC4LYy7b4kgfXn
         kfwzMGtc/vSQiPdepywQDyvgGbUYi+3iG8qqR0/psqMNn7Z8xmyYLjigjDFt71vgFf
         3HK4hzyT5SqVw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrew Gaul <gaul@gaul.org>, Andrew Gaul <gaul@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, hayeswang@realtek.com,
        jflf_kernel@gmx.com, aaron.ma@canonical.com, dober6023@gmail.com,
        svenva@chromium.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 34/34] r8152: Rate limit overflow messages
Date:   Sun,  9 Oct 2022 18:21:28 -0400
Message-Id: <20221009222129.1218277-34-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009222129.1218277-1-sashal@kernel.org>
References: <20221009222129.1218277-1-sashal@kernel.org>
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
index 0bb5b1c78654..a526242a3e36 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -1689,7 +1689,9 @@ static void intr_callback(struct urb *urb)
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

