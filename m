Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56B47134C9B
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 21:06:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727268AbgAHUGo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 15:06:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:60438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726254AbgAHUGm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jan 2020 15:06:42 -0500
Received: from localhost.localdomain (unknown [83.218.167.187])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 015B12073A;
        Wed,  8 Jan 2020 20:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578514001;
        bh=ROYxse2LMV9qCdYGhhd5RDHoWle4p7x0x717Y8KIPVQ=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=Dsuoro0q17u4KeOEA2Q/hkh8seb7zyjfBCAfziv4157Gd96Go6hbMdP/mPAAdHOsi
         7o50rTcrFx6CZhQpQ460xX2kb4G2tZLxxNLA7nx810dUwHnEospSF31unZdk5os034
         NEvd9AmfjmaXERpsSMxnLDpccz3ScjjSqLpyZqrE=
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
Subject: [PATCH v2 6/9] drm/mgag200: Constify ioreadX() iomem argument (as in generic implementation)
Date:   Wed,  8 Jan 2020 21:05:25 +0100
Message-Id: <20200108200528.4614-7-krzk@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200108200528.4614-1-krzk@kernel.org>
References: <20200108200528.4614-1-krzk@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ioreadX() helpers have inconsistent interface.  On some architectures
void *__iomem address argument is a pointer to const, on some not.

Implementations of ioreadX() do not modify the memory under the address
so they can be converted to a "const" version for const-safety and
consistency among architectures.

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
---
 drivers/gpu/drm/mgag200/mgag200_drv.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/mgag200/mgag200_drv.h b/drivers/gpu/drm/mgag200/mgag200_drv.h
index aa32aad222c2..6512b3af4fb7 100644
--- a/drivers/gpu/drm/mgag200/mgag200_drv.h
+++ b/drivers/gpu/drm/mgag200/mgag200_drv.h
@@ -34,9 +34,9 @@
 
 #define MGAG200FB_CONN_LIMIT 1
 
-#define RREG8(reg) ioread8(((void __iomem *)mdev->rmmio) + (reg))
+#define RREG8(reg) ioread8(((const void __iomem *)mdev->rmmio) + (reg))
 #define WREG8(reg, v) iowrite8(v, ((void __iomem *)mdev->rmmio) + (reg))
-#define RREG32(reg) ioread32(((void __iomem *)mdev->rmmio) + (reg))
+#define RREG32(reg) ioread32(((const void __iomem *)mdev->rmmio) + (reg))
 #define WREG32(reg, v) iowrite32(v, ((void __iomem *)mdev->rmmio) + (reg))
 
 #define ATTR_INDEX 0x1fc0
-- 
2.17.1

