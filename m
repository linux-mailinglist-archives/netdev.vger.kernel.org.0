Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 710E85382EC
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 16:38:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240281AbiE3O3I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 10:29:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240562AbiE3OZS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 10:25:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7178AABF51;
        Mon, 30 May 2022 06:50:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B9FD761001;
        Mon, 30 May 2022 13:50:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B78BC385B8;
        Mon, 30 May 2022 13:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653918656;
        bh=t7o3dVSPbYAXzDXsGXvIxTwGgdjNZH7ytre5uqNhv44=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CEWRHm7+BKnOUDOJ0aTvimILFj3w9gThaSO6K2OQn6PFKM0AU8lY8Sg9QFVFD3qEK
         H36k6IllAodUp/qzNQH3Vy/iYFv4vnKTOX64c0xP3USEnfVULmNQmyOUjhGVu97xge
         rYhLasE5FnoV52Rd+PqH1jVA0nC4CswL55v9SJwZSY7QuWWSU32VrLcwtMv2Kc5IOG
         w1FpTangRuzp3Yt6eVGVqE9kcGScEiXEMSmlSstoH1wAsKPsGbOUT9Lj2OavyEaT31
         JneE1vDk/2YKTm7DiT7EbxPF+j/txLDtQu9g5+vkR5J6GNu9mN+HMU7IxC0UrugOQy
         ovnvMySe2shvA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, edumazet@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 38/38] eth: tg3: silence the GCC 12 array-bounds warning
Date:   Mon, 30 May 2022 09:49:24 -0400
Message-Id: <20220530134924.1936816-38-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530134924.1936816-1-sashal@kernel.org>
References: <20220530134924.1936816-1-sashal@kernel.org>
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
index 7046ad6d3d0e..ac50da49ca77 100644
--- a/drivers/net/ethernet/broadcom/Makefile
+++ b/drivers/net/ethernet/broadcom/Makefile
@@ -16,3 +16,8 @@ obj-$(CONFIG_BGMAC_BCMA) += bgmac-bcma.o bgmac-bcma-mdio.o
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

