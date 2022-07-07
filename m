Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EDC25696ED
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 02:32:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234798AbiGGAcf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 20:32:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234794AbiGGAcd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 20:32:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F33CB26560
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 17:32:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A7382B81F7D
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 00:32:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D56FEC341C6;
        Thu,  7 Jul 2022 00:32:28 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="Cq5mPOMW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1657153947;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OA2QFt+2gvJo2Pk/rp8P/PX/rTWdkmDvEFC7g2Qkr50=;
        b=Cq5mPOMWNnks+v9r33vq5NmqxyMpXacS7y8rhQJ9OuuLaXiVSMpB5hD764i9HMGiheq/eI
        nVSZUcjslMLL+/7MnN2XpdtNDYq/ZSuKsf3hhPauII4LYxQCUv8pE75MvoF2zC1/cHfwZ2
        SOIdlakRK5boGwT0WA0bxcJT+r1EfIg=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id ef0d48f3 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Thu, 7 Jul 2022 00:32:27 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
        davem@davemloft.net
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH net 3/6] wireguard: selftests: always call kernel makefile
Date:   Thu,  7 Jul 2022 02:31:54 +0200
Message-Id: <20220707003157.526645-4-Jason@zx2c4.com>
In-Reply-To: <20220707003157.526645-1-Jason@zx2c4.com>
References: <20220707003157.526645-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These selftests are used for much more extensive changes than just the
wireguard source files. So always call the kernel's build file, which
will do something or nothing after checking the whole tree, per usual.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 tools/testing/selftests/wireguard/qemu/Makefile | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/wireguard/qemu/Makefile b/tools/testing/selftests/wireguard/qemu/Makefile
index ed07fdc4589c..ce6176928a7d 100644
--- a/tools/testing/selftests/wireguard/qemu/Makefile
+++ b/tools/testing/selftests/wireguard/qemu/Makefile
@@ -19,8 +19,6 @@ endif
 MIRROR := https://download.wireguard.com/qemu-test/distfiles/
 
 KERNEL_BUILD_PATH := $(BUILD_PATH)/kernel$(if $(findstring yes,$(DEBUG_KERNEL)),-debug)
-rwildcard=$(foreach d,$(wildcard $1*),$(call rwildcard,$d/,$2) $(filter $(subst *,%,$2),$d))
-WIREGUARD_SOURCES := $(call rwildcard,$(KERNEL_PATH)/drivers/net/wireguard/,*)
 
 default: qemu
 
@@ -323,8 +321,9 @@ $(KERNEL_BUILD_PATH)/.config: $(TOOLCHAIN_PATH)/.installed kernel.config arch/$(
 	cd $(KERNEL_BUILD_PATH) && ARCH=$(KERNEL_ARCH) $(KERNEL_PATH)/scripts/kconfig/merge_config.sh -n $(KERNEL_BUILD_PATH)/.config $(KERNEL_BUILD_PATH)/minimal.config
 	$(if $(findstring yes,$(DEBUG_KERNEL)),cp debug.config $(KERNEL_BUILD_PATH) && cd $(KERNEL_BUILD_PATH) && ARCH=$(KERNEL_ARCH) $(KERNEL_PATH)/scripts/kconfig/merge_config.sh -n $(KERNEL_BUILD_PATH)/.config debug.config,)
 
-$(KERNEL_BZIMAGE): $(TOOLCHAIN_PATH)/.installed $(KERNEL_BUILD_PATH)/.config $(BUILD_PATH)/init-cpio-spec.txt $(IPERF_PATH)/src/iperf3 $(IPUTILS_PATH)/ping $(BASH_PATH)/bash $(IPROUTE2_PATH)/misc/ss $(IPROUTE2_PATH)/ip/ip $(IPTABLES_PATH)/iptables/xtables-legacy-multi $(NMAP_PATH)/ncat/ncat $(WIREGUARD_TOOLS_PATH)/src/wg $(BUILD_PATH)/init ../netns.sh $(WIREGUARD_SOURCES)
+$(KERNEL_BZIMAGE): $(TOOLCHAIN_PATH)/.installed $(KERNEL_BUILD_PATH)/.config $(BUILD_PATH)/init-cpio-spec.txt $(IPERF_PATH)/src/iperf3 $(IPUTILS_PATH)/ping $(BASH_PATH)/bash $(IPROUTE2_PATH)/misc/ss $(IPROUTE2_PATH)/ip/ip $(IPTABLES_PATH)/iptables/xtables-legacy-multi $(NMAP_PATH)/ncat/ncat $(WIREGUARD_TOOLS_PATH)/src/wg $(BUILD_PATH)/init
 	$(MAKE) -C $(KERNEL_PATH) O=$(KERNEL_BUILD_PATH) ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(CROSS_COMPILE)
+.PHONY: $(KERNEL_BZIMAGE)
 
 $(TOOLCHAIN_PATH)/$(CHOST)/include/linux/.installed: | $(KERNEL_BUILD_PATH)/.config $(TOOLCHAIN_PATH)/.installed
 	rm -rf $(TOOLCHAIN_PATH)/$(CHOST)/include/linux
-- 
2.35.1

