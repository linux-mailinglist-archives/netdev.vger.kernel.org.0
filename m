Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D17A22199D0
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 09:29:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726629AbgGIH3R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 03:29:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:42590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726006AbgGIH3O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jul 2020 03:29:14 -0400
Received: from kozik-lap.mshome.net (unknown [194.230.155.195])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 50C8120786;
        Thu,  9 Jul 2020 07:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594279754;
        bh=QYSGAmbCCxKq7PeNXIOIYLZvnbzZZuWLOEUVbks30dw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1Vq5Rv+mJ7JMcX+20xViqkzmfdNd9iFeiU157MTdQIU4+8aph9P1UPl4B25DGwWL5
         hrvyew5GekUMVukmUmyVH1Uef1LLdOT9JBeKJZeXTdMus5SGdjIAF3SIv5q2RYQIiw
         p9JIqnDhZP52EWTpOYsrInFFCFBgKwGPUHdFeSTk=
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Helge Deller <deller@gmx.de>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Dave Jiang <dave.jiang@intel.com>,
        Jon Mason <jdmason@kudzu.us>, Allen Hubbe <allenbh@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-sh@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-ntb@googlegroups.com,
        virtualization@lists.linux-foundation.org,
        linux-arch@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH v3 4/4] virtio: pci: Constify ioreadX() iomem argument (as in generic implementation)
Date:   Thu,  9 Jul 2020 09:28:37 +0200
Message-Id: <20200709072837.5869-5-krzk@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200709072837.5869-1-krzk@kernel.org>
References: <20200709072837.5869-1-krzk@kernel.org>
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
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/virtio/virtio_pci_modern.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
index db93cedd262f..90eff165a719 100644
--- a/drivers/virtio/virtio_pci_modern.c
+++ b/drivers/virtio/virtio_pci_modern.c
@@ -27,16 +27,16 @@
  * method, i.e. 32-bit accesses for 32-bit fields, 16-bit accesses
  * for 16-bit fields and 8-bit accesses for 8-bit fields.
  */
-static inline u8 vp_ioread8(u8 __iomem *addr)
+static inline u8 vp_ioread8(const u8 __iomem *addr)
 {
 	return ioread8(addr);
 }
-static inline u16 vp_ioread16 (__le16 __iomem *addr)
+static inline u16 vp_ioread16 (const __le16 __iomem *addr)
 {
 	return ioread16(addr);
 }
 
-static inline u32 vp_ioread32(__le32 __iomem *addr)
+static inline u32 vp_ioread32(const __le32 __iomem *addr)
 {
 	return ioread32(addr);
 }
-- 
2.17.1

