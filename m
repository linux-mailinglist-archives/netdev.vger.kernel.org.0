Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF9906E918D
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 13:04:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232011AbjDTLEj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 07:04:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235303AbjDTLEI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 07:04:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE0237A97;
        Thu, 20 Apr 2023 04:02:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D515A647D3;
        Thu, 20 Apr 2023 11:02:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CEFEC433D2;
        Thu, 20 Apr 2023 11:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681988535;
        bh=QlA/nQG7SitaTN/sKCqXnsi2+TBW9xYbBV61Vs+0pRc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TgIIxfSR2kbxtQilCFLL+Y5C8/n4/AbpawIwwez9Z34zKdAAvF8xxBW4mnl3TbaaL
         M2WrNAINmvxlV+bwQYbybyc4nJSov7PbpjhV82vdo1wFFTfno8dwQzptLX8GmnuEBG
         B7uuvqVjHd2DC0s2PglXs7jhFNpLdwxHQJjA8XBEHBfcjCN1ijariP0xTcHzpZ56tQ
         ZkNOMtvW5+/0gvirnesFtoVQLnQq5NtqSXlhLJdQdAaqWSkdx+OdvUKbrvfB7V16Lo
         BIWBEKUEsW1YsdDh5rBq39wEIwqijZU1/EW5XA/dkb0Lkuu4Qk+GVpWCbJVWAVlQvT
         IrsBn8gEiie2Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
        Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>,
        Intel Corporation <linuxwwan@intel.com>,
        Chiranjeevi Rapolu <chiranjeevi.rapolu@linux.intel.com>,
        Liu Haijun <haijun.liu@mediatek.com>,
        M Chetan Kumar <m.chetan.kumar@linux.intel.com>,
        Ricardo Martinez <ricardo.martinez@linux.intel.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>, matthias.bgg@gmail.com,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 6.2 10/17] net: wwan: t7xx: do not compile with -Werror
Date:   Thu, 20 Apr 2023 07:01:39 -0400
Message-Id: <20230420110148.505779-10-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230420110148.505779-1-sashal@kernel.org>
References: <20230420110148.505779-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Jiri Slaby (SUSE)" <jirislaby@kernel.org>

[ Upstream commit 362f0b6678ad1377c322a7dd237ea6785efc7342 ]

When playing with various compilers or their versions, some choke on
the t7xx code. For example (with gcc 13):
 In file included from ./arch/s390/include/generated/asm/rwonce.h:1,
                  from ../include/linux/compiler.h:247,
                  from ../include/linux/build_bug.h:5,
                  from ../include/linux/bits.h:22,
                  from ../drivers/net/wwan/t7xx/t7xx_state_monitor.c:17:
 In function 'preempt_count',
     inlined from 't7xx_fsm_append_event' at ../drivers/net/wwan/t7xx/t7xx_state_monitor.c:439:43:
 ../include/asm-generic/rwonce.h:44:26: error: array subscript 0 is outside array bounds of 'const volatile int[0]' [-Werror=array-bounds=]

There is no reason for any code in the kernel to be built with -Werror
by default. Note that we have generic CONFIG_WERROR. So if anyone wants
-Werror, they can enable that.

Signed-off-by: Jiri Slaby (SUSE) <jirislaby@kernel.org>
Link: https://lore.kernel.org/all/20230330232717.1f8bf5ea@kernel.org/
Cc: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
Cc: Intel Corporation <linuxwwan@intel.com>
Cc: Chiranjeevi Rapolu <chiranjeevi.rapolu@linux.intel.com>
Cc: Liu Haijun <haijun.liu@mediatek.com>
Cc: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
Cc: Ricardo Martinez <ricardo.martinez@linux.intel.com>
Cc: Loic Poulain <loic.poulain@linaro.org>
Cc: Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wwan/t7xx/Makefile | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wwan/t7xx/Makefile b/drivers/net/wwan/t7xx/Makefile
index 268ff9e87e5b3..2652cd00504e6 100644
--- a/drivers/net/wwan/t7xx/Makefile
+++ b/drivers/net/wwan/t7xx/Makefile
@@ -1,7 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0-only
 
-ccflags-y += -Werror
-
 obj-${CONFIG_MTK_T7XX} := mtk_t7xx.o
 mtk_t7xx-y:=	t7xx_pci.o \
 		t7xx_pcie_mac.o \
-- 
2.39.2

