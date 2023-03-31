Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A29B96D1784
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 08:35:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbjCaGfx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 02:35:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230050AbjCaGfw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 02:35:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6B4C1B363;
        Thu, 30 Mar 2023 23:35:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5B0E2623AF;
        Fri, 31 Mar 2023 06:35:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A2A1C433D2;
        Fri, 31 Mar 2023 06:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680244520;
        bh=n9tkRf2K0WnDcaoxWyWeYtXelTwL20+bhYUtto0rAbw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u+Uz2wRSdv/yn7FwFqBseTSrdxbLws4ozQp3xqOMfi20V33rvcLi9yre+JDJwR9nf
         C3aHmnuvZrHP/6iMLxqAks5NGqBg8o/xICE2F42dev7yYFn2FD/84vCv/0tr0mxmpw
         pRNANvqJKvrQKwjG1H8qAoK5ROMuKhIBcIqKnGVEl2nbzEMyfqXQdo+eXb5tKwdye2
         mrtej7wrqf/XgGjeCDGwaB6w1bQPvJ1TUr+4ceQhCtcg5KKwmkTFYJLoXOO0hcGp0L
         3dqzqWy53jGY3pQGIDirJG2NTH896/ewK9lx78Gc2HHtXztk3QuFpkfPHIKBgMM7SI
         MIqbN0hrklN1w==
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
Subject: [PATCH] net: wwan: t7xx: do not compile with -Werror
Date:   Fri, 31 Mar 2023 08:35:15 +0200
Message-Id: <20230331063515.947-1-jirislaby@kernel.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230330232717.1f8bf5ea@kernel.org>
References: <20230330232717.1f8bf5ea@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
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
---

Notes:
    [v2] delete the line completely

 drivers/net/wwan/t7xx/Makefile | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wwan/t7xx/Makefile b/drivers/net/wwan/t7xx/Makefile
index 268ff9e87e5b..2652cd00504e 100644
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
2.40.0

