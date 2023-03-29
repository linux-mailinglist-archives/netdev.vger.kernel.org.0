Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0D356CD79E
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 12:26:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231559AbjC2K0u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 06:26:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbjC2K0t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 06:26:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A7791A6;
        Wed, 29 Mar 2023 03:26:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CC8E1B8222E;
        Wed, 29 Mar 2023 10:26:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AF4AC433EF;
        Wed, 29 Mar 2023 10:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680085605;
        bh=YYUHL54YAobPiIqzNEEhlZwcJML+B3UvbCk9XC6VgC4=;
        h=From:To:Cc:Subject:Date:From;
        b=Bl/yieiQa1bn1ziwjaWMFWwRjHRpOurV3Ud47Nrr6IANqzedK3RVPF5m52d4h8FiQ
         KLFGvI6SQIZJ8g6MOdVX/BlBC+FcdUcCZfkhd0YeH98l6fFGgB3q8FGNy7s0kRMGXI
         7cWd1ucXTVXjKy4Zv/mtWmKD0hczQ2dzDZ8o8uMjf2OmTRABbJcWUkxKYPLxc0J2NW
         pAfaOQ87shVwHSshe5FGQo6q+mA7o1Um78XSkAbnqXkWUBJhfbr7790ioSBIOTSeXP
         JyUy+jA42pyoCtDjiFJENbnvKez0u0hzDte0gqcxQxbDwaEtU9uRCZrmC0/6Knc66y
         GmmCV4sNEqmlg==
From:   "Jiri Slaby (SUSE)" <jirislaby@kernel.org>
To:     kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org,
        "Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
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
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: [PATCH] net: wwan: t7xx: do not compile with -Werror by default
Date:   Wed, 29 Mar 2023 12:26:39 +0200
Message-Id: <20230329102640.8830-1-jirislaby@kernel.org>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
by default. Note that we have generic CONFIG_WERROR. OTOH, some drivers
may want to do this only on per-driver basis. Some do
CONFIG_DRM_I915_WERROR or alike. But I reused the scsi's:
  ifdef WARNINGS_BECOME_ERRORS
approach.

Now, if one wants to build t7xx with -Werror, they may say:
  make WARNINGS_BECOME_ERRORS=1

Signed-off-by: Jiri Slaby (SUSE) <jirislaby@kernel.org>
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
---
 drivers/net/wwan/t7xx/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wwan/t7xx/Makefile b/drivers/net/wwan/t7xx/Makefile
index 268ff9e87e5b..29622c2c4533 100644
--- a/drivers/net/wwan/t7xx/Makefile
+++ b/drivers/net/wwan/t7xx/Makefile
@@ -1,6 +1,8 @@
 # SPDX-License-Identifier: GPL-2.0-only
 
+ifdef WARNINGS_BECOME_ERRORS
 ccflags-y += -Werror
+endif
 
 obj-${CONFIG_MTK_T7XX} := mtk_t7xx.o
 mtk_t7xx-y:=	t7xx_pci.o \
-- 
2.40.0

