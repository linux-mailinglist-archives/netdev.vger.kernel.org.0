Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9273134C8E
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 21:06:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727229AbgAHUGf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 15:06:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:60040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726702AbgAHUGd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jan 2020 15:06:33 -0500
Received: from localhost.localdomain (unknown [83.218.167.187])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C73972072A;
        Wed,  8 Jan 2020 20:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578513992;
        bh=HCaYTB1zjoRsDFDAYW5IZdMXtSdvLZDxsdHLQEpJXVw=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=m+nvoD3luPC+M4NYm9Cy4BcKfxdPdPUsJ31Cd7NkOVQ+WOFcAXwSaITpIPz1EqvoH
         +eMoq0S0mICrEfHCjUhhQI8kcaAxgbrRKLZuMNnZxLLRWRLbcmGrTPANM+zEfxOomW
         kmDDOtmeZ9MFoNKtMrTgtyh+9s8VZmSJxKatZzaI=
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>,
        Alexey Brodkin <abrodkin@synopsys.com>,
        Vineet Gupta <vgupta@synopsys.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Helge Deller <deller@gmx.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>,
        Dave Airlie <airlied@redhat.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Ben Skeggs <bskeggs@redhat.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jiri Slaby <jirislaby@gmail.com>,
        Nick Kossifidis <mickflemm@gmail.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Dave Jiang <dave.jiang@intel.com>,
        Jon Mason <jdmason@kudzu.us>, Allen Hubbe <allenbh@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-snps-arc@lists.infradead.org, linux-parisc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-sh@vger.kernel.org,
        dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org,
        linux-media@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-ntb@googlegroups.com,
        virtualization@lists.linux-foundation.org,
        linux-arch@vger.kernel.org
Subject: [PATCH v2 5/9] arc: Constify ioreadX() iomem argument (as in generic implementation)
Date:   Wed,  8 Jan 2020 21:05:24 +0100
Message-Id: <20200108200528.4614-6-krzk@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200108200528.4614-1-krzk@kernel.org>
References: <20200108200528.4614-1-krzk@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ioreadX() helpers have inconsistent interface.  On some architectures
void *__iomem address argument is a pointer to const, on some not.

Implementations of ioreadX() do not modify the memory under the
address so they can be converted to a "const" version for const-safety
and consistency among architectures.

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
---
 arch/arc/plat-axs10x/axs10x.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arc/plat-axs10x/axs10x.c b/arch/arc/plat-axs10x/axs10x.c
index 63ea5a606ecd..180c260a8221 100644
--- a/arch/arc/plat-axs10x/axs10x.c
+++ b/arch/arc/plat-axs10x/axs10x.c
@@ -84,7 +84,7 @@ static void __init axs10x_print_board_ver(unsigned int creg, const char *str)
 		unsigned int val;
 	} board;
 
-	board.val = ioread32((void __iomem *)creg);
+	board.val = ioread32((const void __iomem *)creg);
 	pr_info("AXS: %s FPGA Date: %u-%u-%u\n", str, board.d, board.m,
 		board.y);
 }
@@ -95,7 +95,7 @@ static void __init axs10x_early_init(void)
 	char mb[32];
 
 	/* Determine motherboard version */
-	if (ioread32((void __iomem *) CREG_MB_CONFIG) & (1 << 28))
+	if (ioread32((const void __iomem *) CREG_MB_CONFIG) & (1 << 28))
 		mb_rev = 3;	/* HT-3 (rev3.0) */
 	else
 		mb_rev = 2;	/* HT-2 (rev2.0) */
-- 
2.17.1

