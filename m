Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FE355F9252
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 00:48:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233212AbiJIWsL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 18:48:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233046AbiJIWqm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 18:46:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77AC23A160;
        Sun,  9 Oct 2022 15:23:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 16C4160CF8;
        Sun,  9 Oct 2022 22:22:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44BB2C433D7;
        Sun,  9 Oct 2022 22:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665354162;
        bh=WtmUHpXH7zAUYwCL3i2VSbXYr6kSqUkFecpd0pNxcTY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MuZDBHFZ9YXso5FradbIc88NM2hPulHLoZS/BC+aAfX07aZIWSGF9Hn2BQUwC+UTf
         znmY9onn7D06zpfYu3H5VPIEf56/gXN7JethSdil9v17tyGNA5boJ6BZYTpWWofAol
         3XXqt2dvOmxLifd6uiGO0ESIH78ZyAQmzs0btURGTGDblZNGbqTM1oB1g57gKj+A0Z
         Sc+dGzvGpMnpLnQ0/08JVybREOCxnGjN6Gh0bv2By1a0zm+B2jfZEk3W2e0FPw/vxH
         /bd5CCwoNvouVCD4tVJ9DtZJqj0V7TlDw/C34PMwsU1pKAUoVNx0RMReDTeqWHHOHr
         PSD2vSqPX3LRw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ziyang Xuan <william.xuanziyang@huawei.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 25/34] can: bcm: check the result of can_send() in bcm_can_tx()
Date:   Sun,  9 Oct 2022 18:21:19 -0400
Message-Id: <20221009222129.1218277-25-sashal@kernel.org>
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

From: Ziyang Xuan <william.xuanziyang@huawei.com>

[ Upstream commit 3fd7bfd28cfd68ae80a2fe92ea1615722cc2ee6e ]

If can_send() fail, it should not update frames_abs counter
in bcm_can_tx(). Add the result check for can_send() in bcm_can_tx().

Suggested-by: Marc Kleine-Budde <mkl@pengutronix.de>
Suggested-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
Link: https://lore.kernel.org/all/9851878e74d6d37aee2f1ee76d68361a46f89458.1663206163.git.william.xuanziyang@huawei.com
Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/can/bcm.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/can/bcm.c b/net/can/bcm.c
index e918a0f3cda2..afa82adaf6cd 100644
--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -274,6 +274,7 @@ static void bcm_can_tx(struct bcm_op *op)
 	struct sk_buff *skb;
 	struct net_device *dev;
 	struct canfd_frame *cf = op->frames + op->cfsiz * op->currframe;
+	int err;
 
 	/* no target device? => exit */
 	if (!op->ifindex)
@@ -298,11 +299,11 @@ static void bcm_can_tx(struct bcm_op *op)
 	/* send with loopback */
 	skb->dev = dev;
 	can_skb_set_owner(skb, op->sk);
-	can_send(skb, 1);
+	err = can_send(skb, 1);
+	if (!err)
+		op->frames_abs++;
 
-	/* update statistics */
 	op->currframe++;
-	op->frames_abs++;
 
 	/* reached last frame? */
 	if (op->currframe >= op->nframes)
-- 
2.35.1

