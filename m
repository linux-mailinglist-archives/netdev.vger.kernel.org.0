Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8E98650173
	for <lists+netdev@lfdr.de>; Sun, 18 Dec 2022 17:30:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231196AbiLRQa1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Dec 2022 11:30:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232120AbiLRQ3a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Dec 2022 11:29:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A305191;
        Sun, 18 Dec 2022 08:10:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1EA9EB80766;
        Sun, 18 Dec 2022 16:10:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52C0DC433EF;
        Sun, 18 Dec 2022 16:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671379844;
        bh=KwN2bMdPre7EeSZ84sX1w8C+zSF1PheaV2lQkhgNTPc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qu8rCFVLTm9mqFhfzaS1Kx8GxDo5UB5gfcWqpPS2Op2wBVFYBhIchCe0uJ+XBpCmr
         Wtoi3TMSLIVgwEwtnI+fbWXWYGgrNAqQKNYB2dIucIlReIHndIZU1yf5SUJ/9g6oJ8
         oBHtCcU+45OA7828lgjkzitO+HzcIxTrUrz6/8UH4ZEE9yjWq4bjupEzHHAp/R3he6
         el15odWDmNS7nzaVc8IUwZgEzSaHJlKI1efib2uxMTXvSjCKFQDIaRAlOXkZRJIqXz
         R2m9iHSqGH8GNzQCy8/9mRaGRTckn18Cw+hZ5Gv1DGzKtlq7kqTg+QAeNU/LocFKvr
         7vOPMvJU3VpZQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maxim Korotkov <korotkov.maxim.s@gmail.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, nikolay@nvidia.com,
        sean.anderson@seco.com, trix@redhat.com, marco@mebeim.net,
        wsa+renesas@sang-engineering.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 49/73] ethtool: avoiding integer overflow in ethtool_phys_id()
Date:   Sun, 18 Dec 2022 11:07:17 -0500
Message-Id: <20221218160741.927862-49-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221218160741.927862-1-sashal@kernel.org>
References: <20221218160741.927862-1-sashal@kernel.org>
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

From: Maxim Korotkov <korotkov.maxim.s@gmail.com>

[ Upstream commit 64a8f8f7127da228d59a39e2c5e75f86590f90b4 ]

The value of an arithmetic expression "n * id.data" is subject
to possible overflow due to a failure to cast operands to a larger data
type before performing arithmetic. Used macro for multiplication instead
operator for avoiding overflow.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Maxim Korotkov <korotkov.maxim.s@gmail.com>
Reviewed-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/20221122122901.22294-1-korotkov.maxim.s@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ethtool/ioctl.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 6a7308de192d..6b59e7a1c906 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -2007,7 +2007,8 @@ static int ethtool_phys_id(struct net_device *dev, void __user *useraddr)
 	} else {
 		/* Driver expects to be called at twice the frequency in rc */
 		int n = rc * 2, interval = HZ / n;
-		u64 count = n * id.data, i = 0;
+		u64 count = mul_u32_u32(n, id.data);
+		u64 i = 0;
 
 		do {
 			rtnl_lock();
-- 
2.35.1

