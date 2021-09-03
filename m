Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2A943FFFBA
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 14:29:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349322AbhICMaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 08:30:19 -0400
Received: from mail-wm1-f54.google.com ([209.85.128.54]:46684 "EHLO
        mail-wm1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230005AbhICMaR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 08:30:17 -0400
Received: by mail-wm1-f54.google.com with SMTP id m25-20020a7bcb99000000b002e751bcb5dbso3443085wmi.5
        for <netdev@vger.kernel.org>; Fri, 03 Sep 2021 05:29:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lwKmc6riTgSAB2Hg4tMEvl1OgRG+uLcwE8DIhu9wDfY=;
        b=is4XSu2AJiYYZcFuxZGv80kIkT6XpPOOJHUdz/DkRal8StDXjZHdrmdgI+tfsacXCV
         T1NhAABjmM71Lh+W+K8DEbhbgm7Da5EEHxWW5PEewmDpe98GaN0vDQkULYlf+v42uR53
         Bn6+6raGvUbhWJrLQBejqqq9e1dcjmcJi/Jh5t/sZ8Sz8n01/o+wTqrQNsA07f2Ioi0g
         +nwDQUMWvQhtvVr1OndPGlPqg++Erv+B21ONqDPH1DVNrJmQdVxZQwjoEnm8ZI9/pfMY
         DzoEiSj7KGtm49GB2mmmLTtfxw5SDxiJL9HznETi/SQmQTrsCOt3eC3gNofzgTFqmfqR
         qMFw==
X-Gm-Message-State: AOAM533EOFwGcllxAhk3S7hvoOKh6UTB4Bd64QhnzAAbo/CEdWONoxHP
        lHUINY1fus5llrODR3cekqEYcIHcP30lbA==
X-Google-Smtp-Source: ABdhPJxaKrYuPm5Z8oxODdxXapWB7DlvOgJw3SIHgrFOZu5G5IDjuT066a0SZrHK8ikAwxjDjaBQSg==
X-Received: by 2002:a7b:c1cf:: with SMTP id a15mr8240851wmj.85.1630672156529;
        Fri, 03 Sep 2021 05:29:16 -0700 (PDT)
Received: from klappe2.local (p54ab1e36.dip0.t-ipconnect.de. [84.171.30.54])
        by smtp.gmail.com with ESMTPSA id o5sm4524777wrw.17.2021.09.03.05.29.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 Sep 2021 05:29:16 -0700 (PDT)
From:   Arnd Bergmann <arnd@arndb.de>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Guenter Roeck <linux@roeck-us.net>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] net: cs89x0: disable compile testing on powerpc
Date:   Fri,  3 Sep 2021 12:29:07 +0000
Message-Id: <1630672147-29639-1-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ISA DMA API is inconsistent between architectures, and while
powerpc implements most of what the others have, it does not provide
isa_virt_to_bus():

../drivers/net/ethernet/cirrus/cs89x0.c: In function ‘net_open’:
../drivers/net/ethernet/cirrus/cs89x0.c:897:20: error: implicit declaration of function ‘isa_virt_to_bus’ [-Werror=implicit-function-declaration]
     (unsigned long)isa_virt_to_bus(lp->dma_buff));
../drivers/net/ethernet/cirrus/cs89x0.c:894:3: note: in expansion of macro ‘cs89_dbg’
   cs89_dbg(1, debug, "%s: dma %lx %lx\n",

I tried a couple of approaches to handle this consistently across
all architectures, but as this driver is really only used on
ARM, I ended up taking the easy way out and just disable compile
testing on powerpc.

Reported-by: Guenter Roeck <linux@roeck-us.net>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Reported-by: Reported-by: kernel test robot <lkp@intel.com>
Fixes: 47fd22f2b847 ("cs89x0: rework driver configuration")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
Sorry for taking my time with this, it was reported a while ago,
but I could not figure out a good solution at first and then
failed to send any fix before my vacation.
---
 drivers/net/ethernet/cirrus/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cirrus/Kconfig b/drivers/net/ethernet/cirrus/Kconfig
index dac1764..5bdf731 100644
--- a/drivers/net/ethernet/cirrus/Kconfig
+++ b/drivers/net/ethernet/cirrus/Kconfig
@@ -38,7 +38,7 @@ config CS89x0_ISA
 
 config CS89x0_PLATFORM
 	tristate "CS89x0 platform driver support"
-	depends on ARM || COMPILE_TEST
+	depends on ARM || (COMPILE_TEST && !PPC)
 	select CS89x0
 	help
 	  Say Y to compile the cs89x0 platform driver. This makes this driver
-- 
2.7.4

