Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CDDD132BD9
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 17:54:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728543AbgAGQye (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 11:54:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:42024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728614AbgAGQyd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Jan 2020 11:54:33 -0500
Received: from PC-kkoz.proceq.com (unknown [213.160.61.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B861214D8;
        Tue,  7 Jan 2020 16:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578416071;
        bh=kcx/rxr2RLwdfnh8NHNbRoC/CMRusZFBrn/JE86e3Ww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nPI0cC7rOnafhOVC5bp7UTE2mQoTZDbOxMxBpCNT2a6rIVaeFzV7mtVVZ9F+98p+x
         Hk2gcfTOOvUk0qIzZk1BSRAhziD0R33MmnQ7l6nqXeVJ0q41DUIG7bmLWej2I0aWHz
         EJm+d+oMYMPHrJxueaaDZOqmBnz1RIpoH7U6LrGs=
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
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-snps-arc@lists.infradead.org, linux-parisc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-sh@vger.kernel.org,
        dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org,
        linux-media@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-ntb@googlegroups.com,
        virtualization@lists.linux-foundation.org,
        linux-arch@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzk@kernel.org>
Subject: [RFT 05/13] powerpc: Constify ioreadX() iomem argument (as in generic implementation)
Date:   Tue,  7 Jan 2020 17:53:04 +0100
Message-Id: <1578415992-24054-8-git-send-email-krzk@kernel.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1578415992-24054-1-git-send-email-krzk@kernel.org>
References: <1578415992-24054-1-git-send-email-krzk@kernel.org>
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
 arch/powerpc/kernel/iomap.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/powerpc/kernel/iomap.c b/arch/powerpc/kernel/iomap.c
index 5ac84efc6ede..de8da1c3496f 100644
--- a/arch/powerpc/kernel/iomap.c
+++ b/arch/powerpc/kernel/iomap.c
@@ -15,23 +15,23 @@
  * Here comes the ppc64 implementation of the IOMAP 
  * interfaces.
  */
-unsigned int ioread8(void __iomem *addr)
+unsigned int ioread8(const void __iomem *addr)
 {
 	return readb(addr);
 }
-unsigned int ioread16(void __iomem *addr)
+unsigned int ioread16(const void __iomem *addr)
 {
 	return readw(addr);
 }
-unsigned int ioread16be(void __iomem *addr)
+unsigned int ioread16be(const void __iomem *addr)
 {
 	return readw_be(addr);
 }
-unsigned int ioread32(void __iomem *addr)
+unsigned int ioread32(const void __iomem *addr)
 {
 	return readl(addr);
 }
-unsigned int ioread32be(void __iomem *addr)
+unsigned int ioread32be(const void __iomem *addr)
 {
 	return readl_be(addr);
 }
@@ -41,27 +41,27 @@ EXPORT_SYMBOL(ioread16be);
 EXPORT_SYMBOL(ioread32);
 EXPORT_SYMBOL(ioread32be);
 #ifdef __powerpc64__
-u64 ioread64(void __iomem *addr)
+u64 ioread64(const void __iomem *addr)
 {
 	return readq(addr);
 }
-u64 ioread64_lo_hi(void __iomem *addr)
+u64 ioread64_lo_hi(const void __iomem *addr)
 {
 	return readq(addr);
 }
-u64 ioread64_hi_lo(void __iomem *addr)
+u64 ioread64_hi_lo(const void __iomem *addr)
 {
 	return readq(addr);
 }
-u64 ioread64be(void __iomem *addr)
+u64 ioread64be(const void __iomem *addr)
 {
 	return readq_be(addr);
 }
-u64 ioread64be_lo_hi(void __iomem *addr)
+u64 ioread64be_lo_hi(const void __iomem *addr)
 {
 	return readq_be(addr);
 }
-u64 ioread64be_hi_lo(void __iomem *addr)
+u64 ioread64be_hi_lo(const void __iomem *addr)
 {
 	return readq_be(addr);
 }
-- 
2.7.4

