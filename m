Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 240A95BAF79
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 16:38:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231124AbiIPOiG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 10:38:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230442AbiIPOiC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 10:38:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 651B15E576
        for <netdev@vger.kernel.org>; Fri, 16 Sep 2022 07:38:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CEE9E62B71
        for <netdev@vger.kernel.org>; Fri, 16 Sep 2022 14:38:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB27CC433D6;
        Fri, 16 Sep 2022 14:38:00 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="PiDMrePF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1663339080;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=diS9gR/qeAx2HpUAtdIZwVB8J+2+LTMg/imIIacbFBk=;
        b=PiDMrePFn/JY1ImYBz9H/jOXhJqLpAbmlhqy/aL8Hs0gLUVfV56Gqb25mBDeUwUgc2tTm4
        qTc80IyNxVGVCxItnuQNjp65gBf3hCfVEp9AzilTyeT1qN8JGjyRCf7j1Ii/6JfCQeiU8B
        lalKZi8hVJqh0PwI7+/Lgk4nw4U03HI=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id f7a4004a (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Fri, 16 Sep 2022 14:38:00 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     kuba@kernel.org, pablo@netfilter.org, davem@davemloft.net,
        netdev@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH net 2/3] wireguard: selftests: do not install headers on UML
Date:   Fri, 16 Sep 2022 15:37:39 +0100
Message-Id: <20220916143740.831881-3-Jason@zx2c4.com>
In-Reply-To: <20220916143740.831881-1-Jason@zx2c4.com>
References: <20220916143740.831881-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since 1b620d539ccc ("kbuild: disable header exports for UML in a
straightforward way"), installing headers fails on UML, so just disable
installing them, since they're not needed anyway on the architecture.

Fixes: b438b3b8d6e6 ("wireguard: selftests: support UML")
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 tools/testing/selftests/wireguard/qemu/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/wireguard/qemu/Makefile b/tools/testing/selftests/wireguard/qemu/Makefile
index fda76282d34b..e95bd56b332f 100644
--- a/tools/testing/selftests/wireguard/qemu/Makefile
+++ b/tools/testing/selftests/wireguard/qemu/Makefile
@@ -343,8 +343,10 @@ $(KERNEL_BZIMAGE): $(TOOLCHAIN_PATH)/.installed $(KERNEL_BUILD_PATH)/.config $(B
 .PHONY: $(KERNEL_BZIMAGE)
 
 $(TOOLCHAIN_PATH)/$(CHOST)/include/linux/.installed: | $(KERNEL_BUILD_PATH)/.config $(TOOLCHAIN_PATH)/.installed
+ifneq ($(ARCH),um)
 	rm -rf $(TOOLCHAIN_PATH)/$(CHOST)/include/linux
 	$(MAKE) -C $(KERNEL_PATH) O=$(KERNEL_BUILD_PATH) INSTALL_HDR_PATH=$(TOOLCHAIN_PATH)/$(CHOST) ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(CROSS_COMPILE) headers_install
+endif
 	touch $@
 
 $(TOOLCHAIN_PATH)/.installed: $(TOOLCHAIN_TAR)
-- 
2.37.3

