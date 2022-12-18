Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E6AA64FECF
	for <lists+netdev@lfdr.de>; Sun, 18 Dec 2022 13:04:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230383AbiLRMET (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Dec 2022 07:04:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbiLRMER (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Dec 2022 07:04:17 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E8CC121;
        Sun, 18 Dec 2022 04:04:15 -0800 (PST)
Received: from zn.tnic (p5de8e9fe.dip0.t-ipconnect.de [93.232.233.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 900461EC04C1;
        Sun, 18 Dec 2022 13:04:12 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1671365052;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:
         content-transfer-encoding:content-transfer-encoding:in-reply-to:
         references; bh=qZ7D+nJuEw06972G95/KVZOO2WSZfZWhv++0SW+ZtQo=;
        b=U3fwypfodtyAL0P58CBYz6SK6jS4gJTvWm8Tpp6gqcaZRMIN+AJbY2M8NhU8SpyIYuufk9
        rQGrjLFAPhRxrQqF70nVZZjU3BpfMKLuYfynJDnhD7NjlLOxd8ygzZLlsoITOuZUgLW256
        MME6mx8Mzcu1c1Twf2+HCRrxH+raQYo=
From:   Borislav Petkov <bp@alien8.de>
To:     Thomas Sailer <t.sailer@alumni.ethz.ch>
Cc:     linux-hams@vger.kernel.org, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] hamradio: baycom_epp: Do not use x86-specific rdtsc()
Date:   Sun, 18 Dec 2022 13:04:05 +0100
Message-Id: <20221218120405.2431-1-bp@alien8.de>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Borislav Petkov (AMD)" <bp@alien8.de>

Use get_cycles() which is provided by pretty much every arch.

The UML build works too because get_cycles() is a simple "return 0;"
because the rdtsc() is optimized away there.

Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
---
 drivers/net/hamradio/baycom_epp.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/net/hamradio/baycom_epp.c b/drivers/net/hamradio/baycom_epp.c
index bd3b0c2655a2..83ff882f5d97 100644
--- a/drivers/net/hamradio/baycom_epp.c
+++ b/drivers/net/hamradio/baycom_epp.c
@@ -623,16 +623,10 @@ static int receive(struct net_device *dev, int cnt)
 
 /* --------------------------------------------------------------------- */
 
-#if defined(__i386__) && !defined(CONFIG_UML)
-#include <asm/msr.h>
 #define GETTICK(x)						\
 ({								\
-	if (boot_cpu_has(X86_FEATURE_TSC))			\
-		x = (unsigned int)rdtsc();			\
+	x = (unsigned int)get_cycles();				\
 })
-#else /* __i386__  && !CONFIG_UML */
-#define GETTICK(x)
-#endif /* __i386__  && !CONFIG_UML */
 
 static void epp_bh(struct work_struct *work)
 {
-- 
2.35.1

