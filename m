Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1868D537DB6
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 15:43:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237558AbiE3Nlb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 09:41:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237813AbiE3Niv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 09:38:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 430ED994EC;
        Mon, 30 May 2022 06:31:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D1C25B80B3A;
        Mon, 30 May 2022 13:31:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE099C385B8;
        Mon, 30 May 2022 13:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917482;
        bh=sm8MbBlNG5K6X9hLCmzFjLBYl5czMKscsEUm5HoPOMk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fl7MFHeQYCfPN3iyOLE+7UN+Wm9qiOBH2xYL9mlYTjwFIOgX3/9pknQ8jIWK9K1xz
         YCRrr4in1cZmQWYlhaedVg2aS+UXrpb3k1ht0x25IPtRFLJYMA77CKzLw1advOKENa
         EBXPWTYo19C5s1DcWQthjlkEC43+6oVaZlJbqTr6i1sYbavvFMEhNUiPvMXJaCYW3Y
         bbTSJeobRT/1/aQ9PSBwjqj4gVWNxL3RHcJtUrWQSoUDe1vQkUwVhx96UUyXEX4VZi
         09ihgxhf5hXPTOVIpzmzKuJOl/zgsL82XdedBPyCX0Z5rsmJONM/zEgNxIW0dSleOk
         iiwtGOG6N5VbQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, edumazet@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 155/159] eth: tg3: silence the GCC 12 array-bounds warning
Date:   Mon, 30 May 2022 09:24:20 -0400
Message-Id: <20220530132425.1929512-155-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530132425.1929512-1-sashal@kernel.org>
References: <20220530132425.1929512-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 9dec850fd7c210a04b4707df8e6c95bfafdd6a4b ]

GCC 12 currently generates a rather inconsistent warning:

drivers/net/ethernet/broadcom/tg3.c:17795:51: warning: array subscript 5 is above array bounds of ‘struct tg3_napi[5]’ [-Warray-bounds]
17795 |                 struct tg3_napi *tnapi = &tp->napi[i];
      |                                           ~~~~~~~~^~~

i is guaranteed < tp->irq_max which in turn is either 1 or 5.
There are more loops like this one in the driver, but strangely
GCC 12 dislikes only this single one.

Silence this silliness for now.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/Makefile | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/Makefile b/drivers/net/ethernet/broadcom/Makefile
index 0ddfb5b5d53c..2e6c5f258a1f 100644
--- a/drivers/net/ethernet/broadcom/Makefile
+++ b/drivers/net/ethernet/broadcom/Makefile
@@ -17,3 +17,8 @@ obj-$(CONFIG_BGMAC_BCMA) += bgmac-bcma.o bgmac-bcma-mdio.o
 obj-$(CONFIG_BGMAC_PLATFORM) += bgmac-platform.o
 obj-$(CONFIG_SYSTEMPORT) += bcmsysport.o
 obj-$(CONFIG_BNXT) += bnxt/
+
+# FIXME: temporarily silence -Warray-bounds on non W=1+ builds
+ifndef KBUILD_EXTRA_WARN
+CFLAGS_tg3.o += -Wno-array-bounds
+endif
-- 
2.35.1

