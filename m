Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A60D399A55
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 07:53:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbhFCFzf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 01:55:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbhFCFzf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 01:55:35 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A11AC06174A;
        Wed,  2 Jun 2021 22:53:51 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id s5-20020a7bc0c50000b0290147d0c21c51so2921060wmh.4;
        Wed, 02 Jun 2021 22:53:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=+LavzohDJpbvg/dpCNljR3NbpSeXC/kKjcfv8mBT/jc=;
        b=guI7rJGwRqalQxlRFJ83qNrLap9ESqnpMotNGMlOc29W/d6GsmHFpZm3xiEPaX7TP/
         TNtw8t3P8y3IZGAWyH/K4CKR8mRpt/osLOYq+nkQtaS3GAId0WkMf8fvfXmkhrwi8vm2
         BjZmDo20YCoEEDGqoCaui/Zkyij1Uo26e6Co3wWmBEQfqKYp24tPMbC89NMstQCB71rW
         kpIeRdKIAltgfW2szfDh4i5S8Uv2RnKoyFI3asJVlKZVCRb2ZfhhrrAMlsabz5eVcS1p
         iWGIrYS1p4zIZ1EhoU+1dA0FKkR8Ql2hyczUhEpUKZt+DXFTC6LDi29C+exWRISVZ/Nq
         GBJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=+LavzohDJpbvg/dpCNljR3NbpSeXC/kKjcfv8mBT/jc=;
        b=UqwE47GCl8dK4Ct5jz1b3omCAYkhmuWYWrIB3XGmWRC+onpqDmo5oAKoPs1g8C1sXN
         ewIZjRIQsoloFEklTfdSk4s1u20W9mmZKpuvUnqHepn0ONBIxy98wo1IX7wfxpY27vnv
         CYU9xtAInOVV6xlZjOTDk/hze0ui650OsxRNtLo5RUzgiIAfMwyl2Jl9HGyLi2i44yoO
         qOAoVKSY9GhsEnn/5ocI/0uYr9Tq70lVAs6R2cZb7yb6kxBT+ghg7f5buFuf+IjWsM28
         waUWqBH2iriQrUf75eLiI9SAVuFoRbbxZlcEBkvpTJvLkM0tMiIWXGV1bwv5s265HSDT
         VQmg==
X-Gm-Message-State: AOAM533R1mpEhJATQ1fJ6F5RZr9CHAwh/NnyLclYh8L8n1jdnvZtGvtz
        MTMxotIyxGhqUhKGZYG+hvPcSqz5SNw8DA==
X-Google-Smtp-Source: ABdhPJxTE6CaglFYIN0bT7p+BDX3O+bhx3vkXDZHLkVV5VX1+AWxmSHjKEwEnT4mmgTq/ZwQAB+4/w==
X-Received: by 2002:a1c:2155:: with SMTP id h82mr35846198wmh.115.1622699629622;
        Wed, 02 Jun 2021 22:53:49 -0700 (PDT)
Received: from wsfd-netdev-buildsys.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id e17sm2219784wre.79.2021.06.02.22.53.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 02 Jun 2021 22:53:49 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH] crypto: x86/curve25519 - fix cpu feature checking logic in mod_exit
Date:   Thu,  3 Jun 2021 01:53:40 -0400
Message-Id: <20210603055341.24473-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.18.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In curve25519_mod_init() the curve25519_alg will be registered only when
(X86_FEATURE_BMI2 && X86_FEATURE_ADX). But in curve25519_mod_exit()
it still checks (X86_FEATURE_BMI2 || X86_FEATURE_ADX) when do crypto
unregister. This will trigger a BUG_ON in crypto_unregister_alg() as
alg->cra_refcnt is 0 if the cpu only supports one of X86_FEATURE_BMI2
and X86_FEATURE_ADX.

Fixes: 07b586fe0662 ("crypto: x86/curve25519 - replace with formally verified implementation")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 arch/x86/crypto/curve25519-x86_64.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/crypto/curve25519-x86_64.c b/arch/x86/crypto/curve25519-x86_64.c
index 6706b6cb1d0f..38caf61cd5b7 100644
--- a/arch/x86/crypto/curve25519-x86_64.c
+++ b/arch/x86/crypto/curve25519-x86_64.c
@@ -1500,7 +1500,7 @@ static int __init curve25519_mod_init(void)
 static void __exit curve25519_mod_exit(void)
 {
 	if (IS_REACHABLE(CONFIG_CRYPTO_KPP) &&
-	    (boot_cpu_has(X86_FEATURE_BMI2) || boot_cpu_has(X86_FEATURE_ADX)))
+	    static_branch_likely(&curve25519_use_bmi2_adx))
 		crypto_unregister_kpp(&curve25519_alg);
 }
 
-- 
2.26.3

