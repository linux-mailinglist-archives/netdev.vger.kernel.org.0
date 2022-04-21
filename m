Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1D3B50A12B
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 15:48:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387457AbiDUNvX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 09:51:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387513AbiDUNvW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 09:51:22 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDDB43879C
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 06:48:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 24FFDCE21FE
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 13:48:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0FCFC385A5;
        Thu, 21 Apr 2022 13:48:28 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="GvCPmctg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1650548907;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5wr0l3BHVNZHwQ3R14nVoAwKBu1bvapZ1Azxtd2xvqA=;
        b=GvCPmctgnVrEryWGaI6vw99TZ5ZVtJsfw7xA+jv6WuynMtG3PNkHIsNtflAU99Qte3CBXG
        8jjrAYRCawwpMK6r1jC8zUFOZHBy635BJFSPNbI1kCI9J/QuIflx/Fn8Qje9czQD5EqsI4
        MSCNXmfN8QeJT047bjuTHq+3ypm6xL0=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 76828416 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Thu, 21 Apr 2022 13:48:27 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH net 1/2] wireguard: selftests: enable ACPI for SMP
Date:   Thu, 21 Apr 2022 15:48:04 +0200
Message-Id: <20220421134805.279118-2-Jason@zx2c4.com>
In-Reply-To: <20220421134805.279118-1-Jason@zx2c4.com>
References: <20220421134805.279118-1-Jason@zx2c4.com>
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

It turns out that by having CONFIG_ACPI=n, we've been failing to boot
additional CPUs, and so these systems were functionally UP. The code
bloat is unfortunate for build times, but I don't see an alternative. So
this commit sets CONFIG_ACPI=y for x86_64 and i686 configs.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 tools/testing/selftests/wireguard/qemu/arch/i686.config   | 1 +
 tools/testing/selftests/wireguard/qemu/arch/x86_64.config | 1 +
 2 files changed, 2 insertions(+)

diff --git a/tools/testing/selftests/wireguard/qemu/arch/i686.config b/tools/testing/selftests/wireguard/qemu/arch/i686.config
index a85025d7206e..a9b4fe795048 100644
--- a/tools/testing/selftests/wireguard/qemu/arch/i686.config
+++ b/tools/testing/selftests/wireguard/qemu/arch/i686.config
@@ -1,3 +1,4 @@
+CONFIG_ACPI=y
 CONFIG_SERIAL_8250=y
 CONFIG_SERIAL_8250_CONSOLE=y
 CONFIG_CMDLINE_BOOL=y
diff --git a/tools/testing/selftests/wireguard/qemu/arch/x86_64.config b/tools/testing/selftests/wireguard/qemu/arch/x86_64.config
index 00a1ef4869d5..45dd53a0d760 100644
--- a/tools/testing/selftests/wireguard/qemu/arch/x86_64.config
+++ b/tools/testing/selftests/wireguard/qemu/arch/x86_64.config
@@ -1,3 +1,4 @@
+CONFIG_ACPI=y
 CONFIG_SERIAL_8250=y
 CONFIG_SERIAL_8250_CONSOLE=y
 CONFIG_CMDLINE_BOOL=y
-- 
2.35.1

