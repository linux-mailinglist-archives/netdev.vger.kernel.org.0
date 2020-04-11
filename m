Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 149781A52AB
	for <lists+netdev@lfdr.de>; Sat, 11 Apr 2020 17:56:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726182AbgDKP4a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Apr 2020 11:56:30 -0400
Received: from mail.skyhub.de ([5.9.137.197]:49344 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726054AbgDKP4a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Apr 2020 11:56:30 -0400
Received: from zn.tnic (p200300EC2F1EE2004DDA4FC6A7F1C076.dip0.t-ipconnect.de [IPv6:2003:ec:2f1e:e200:4dda:4fc6:a7f1:c076])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 404AB1EC085F;
        Sat, 11 Apr 2020 17:56:29 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1586620589;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=0QgKfyD3UcjRgzIwSEmTFwH1FvRCThOAFzQ5S67+qsI=;
        b=olq7daV2ItKU/slSpda7p8nzWckB9HYez1JCJ44uiLmdHYcn/3sb1KyxX0N4bSYLkeByEc
        tJIDbMt8m1/bjY7Pw0bZ4MMIIVKiNkPj1a+NKhcxS+2lDfEnuIHXkBiWRUKxiT0XVVWQPq
        DrnfQ0kcqIextkY2FMCiztRhZDUYQUs=
Date:   Sat, 11 Apr 2020 17:56:23 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Keyur Chudgar <keyur@os.amperecomputing.com>,
        Don Fry <pcnet32@frontier.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>, linux-acenic@sunsite.dk,
        Maxime Ripard <mripard@kernel.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Mark Einon <mark.einon@gmail.com>,
        Chris Snook <chris.snook@gmail.com>,
        linux-rockchip@lists.infradead.org,
        Iyappan Subramanian <iyappan@os.amperecomputing.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        David Dillow <dave@thedillows.org>,
        Netanel Belgazal <netanel@amazon.com>,
        Quan Nguyen <quan@os.amperecomputing.com>,
        Jay Cliburn <jcliburn@gmail.com>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        linux-arm-kernel@lists.infradead.org,
        Andreas Larsson <andreas@gaisler.com>,
        Andy Gospodarek <andy@greyhouse.net>, netdev@vger.kernel.org,
        Thor Thayer <thor.thayer@linux.intel.com>,
        linux-kernel@vger.kernel.org, Ion Badulescu <ionut@badula.org>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        Jes Sorensen <jes@trained-monkey.org>,
        nios2-dev@lists.rocketboards.org, Chen-Yu Tsai <wens@csie.org>
Subject: [PATCH] net/3com/3c515: Fix MODULE_ARCH_VERMAGIC redefinition
Message-ID: <20200411155623.GA22175@zn.tnic>
References: <20200224085311.460338-1-leon@kernel.org>
 <20200224085311.460338-4-leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200224085311.460338-4-leon@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Change the include order so that MODULE_ARCH_VERMAGIC from the arch
header arch/x86/include/asm/module.h gets used instead of the fallback
from include/linux/vermagic.h and thus fix:

  In file included from ./include/linux/module.h:30,
                   from drivers/net/ethernet/3com/3c515.c:56:
  ./arch/x86/include/asm/module.h:73: warning: "MODULE_ARCH_VERMAGIC" redefined
     73 | # define MODULE_ARCH_VERMAGIC MODULE_PROC_FAMILY
        |
  In file included from drivers/net/ethernet/3com/3c515.c:25:
  ./include/linux/vermagic.h:28: note: this is the location of the previous definition
     28 | #define MODULE_ARCH_VERMAGIC ""
        |

Fixes: 6bba2e89a88c ("net/3com: Delete driver and module versions from 3com drivers")
Signed-off-by: Borislav Petkov <bp@suse.de>
---
 drivers/net/ethernet/3com/3c515.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/3com/3c515.c b/drivers/net/ethernet/3com/3c515.c
index 90312fcd6319..cdceef891dbd 100644
--- a/drivers/net/ethernet/3com/3c515.c
+++ b/drivers/net/ethernet/3com/3c515.c
@@ -22,7 +22,6 @@
 
 */
 
-#include <linux/vermagic.h>
 #define DRV_NAME		"3c515"
 
 #define CORKSCREW 1
@@ -67,6 +66,7 @@ static int max_interrupt_work = 20;
 #include <linux/timer.h>
 #include <linux/ethtool.h>
 #include <linux/bitops.h>
+#include <linux/vermagic.h>
 
 #include <linux/uaccess.h>
 #include <asm/io.h>
-- 
2.21.0

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
