Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1478DB7634
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 11:25:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388682AbfISJZf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 05:25:35 -0400
Received: from baptiste.telenet-ops.be ([195.130.132.51]:50690 "EHLO
        baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388592AbfISJZe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 05:25:34 -0400
Received: from ramsan ([84.194.98.4])
        by baptiste.telenet-ops.be with bizsmtp
        id 3MRT2100F05gfCL01MRTpJ; Thu, 19 Sep 2019 11:25:32 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan with esmtp (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1iAsgp-0003ph-6D; Thu, 19 Sep 2019 11:25:27 +0200
Received: from geert by rox.of.borg with local (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1iAsgp-0007BK-3i; Thu, 19 Sep 2019 11:25:27 +0200
From:   Geert Uytterhoeven <geert@linux-m68k.org>
To:     Matthew Wilcox <willy@infradead.org>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH -net] staging: octeon: se "(uintptr_t)" to cast from pointer to int
Date:   Thu, 19 Sep 2019 11:25:26 +0200
Message-Id: <20190919092526.27564-1-geert@linux-m68k.org>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 32-bit:

    In file included from drivers/staging/octeon/octeon-ethernet.h:41,
		     from drivers/staging/octeon/ethernet-tx.c:25:
    drivers/staging/octeon/octeon-stubs.h: In function ‘cvmx_phys_to_ptr’:
    drivers/staging/octeon/octeon-stubs.h:1205:9: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
      return (void *)(physical_address);
	     ^
    drivers/staging/octeon/ethernet-tx.c: In function ‘cvm_oct_xmit’:
    drivers/staging/octeon/ethernet-tx.c:264:37: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
       hw_buffer.s.addr = XKPHYS_TO_PHYS((u64)skb->data);
					 ^
    drivers/staging/octeon/octeon-stubs.h:2:30: note: in definition of macro ‘XKPHYS_TO_PHYS’
     #define XKPHYS_TO_PHYS(p)   (p)
				  ^
    drivers/staging/octeon/ethernet-tx.c:268:37: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
       hw_buffer.s.addr = XKPHYS_TO_PHYS((u64)skb->data);
					 ^
    drivers/staging/octeon/octeon-stubs.h:2:30: note: in definition of macro ‘XKPHYS_TO_PHYS’
     #define XKPHYS_TO_PHYS(p)   (p)
				  ^
    drivers/staging/octeon/ethernet-tx.c:276:20: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
	 XKPHYS_TO_PHYS((u64)skb_frag_address(fs));
			^
    drivers/staging/octeon/octeon-stubs.h:2:30: note: in definition of macro ‘XKPHYS_TO_PHYS’
     #define XKPHYS_TO_PHYS(p)   (p)
				  ^
    drivers/staging/octeon/ethernet-tx.c:280:37: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
       hw_buffer.s.addr = XKPHYS_TO_PHYS((u64)CVM_OCT_SKB_CB(skb));
					 ^
    drivers/staging/octeon/octeon-stubs.h:2:30: note: in definition of macro ‘XKPHYS_TO_PHYS’
     #define XKPHYS_TO_PHYS(p)   (p)
				  ^

Fix this by replacing casts to "u64" by casts to "uintptr_t", which is
either 32-bit or 64-bit, and adding an intermediate cast to "uintptr_t"
where needed.

Exposed by commit 171a9bae68c72f2d ("staging/octeon: Allow test build on
!MIPS").

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/staging/octeon/ethernet-tx.c  | 9 +++++----
 drivers/staging/octeon/octeon-stubs.h | 2 +-
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/octeon/ethernet-tx.c b/drivers/staging/octeon/ethernet-tx.c
index c64728fc21f229d8..7021ff07ba2a0b70 100644
--- a/drivers/staging/octeon/ethernet-tx.c
+++ b/drivers/staging/octeon/ethernet-tx.c
@@ -261,11 +261,11 @@ int cvm_oct_xmit(struct sk_buff *skb, struct net_device *dev)
 	/* Build the PKO buffer pointer */
 	hw_buffer.u64 = 0;
 	if (skb_shinfo(skb)->nr_frags == 0) {
-		hw_buffer.s.addr = XKPHYS_TO_PHYS((u64)skb->data);
+		hw_buffer.s.addr = XKPHYS_TO_PHYS((uintptr_t)skb->data);
 		hw_buffer.s.pool = 0;
 		hw_buffer.s.size = skb->len;
 	} else {
-		hw_buffer.s.addr = XKPHYS_TO_PHYS((u64)skb->data);
+		hw_buffer.s.addr = XKPHYS_TO_PHYS((uintptr_t)skb->data);
 		hw_buffer.s.pool = 0;
 		hw_buffer.s.size = skb_headlen(skb);
 		CVM_OCT_SKB_CB(skb)[0] = hw_buffer.u64;
@@ -273,11 +273,12 @@ int cvm_oct_xmit(struct sk_buff *skb, struct net_device *dev)
 			skb_frag_t *fs = skb_shinfo(skb)->frags + i;
 
 			hw_buffer.s.addr =
-				XKPHYS_TO_PHYS((u64)skb_frag_address(fs));
+				XKPHYS_TO_PHYS((uintptr_t)skb_frag_address(fs));
 			hw_buffer.s.size = skb_frag_size(fs);
 			CVM_OCT_SKB_CB(skb)[i + 1] = hw_buffer.u64;
 		}
-		hw_buffer.s.addr = XKPHYS_TO_PHYS((u64)CVM_OCT_SKB_CB(skb));
+		hw_buffer.s.addr =
+			XKPHYS_TO_PHYS((uintptr_t)CVM_OCT_SKB_CB(skb));
 		hw_buffer.s.size = skb_shinfo(skb)->nr_frags + 1;
 		pko_command.s.segs = skb_shinfo(skb)->nr_frags + 1;
 		pko_command.s.gather = 1;
diff --git a/drivers/staging/octeon/octeon-stubs.h b/drivers/staging/octeon/octeon-stubs.h
index a4ac3bfb62a85e65..b78ce9eaab85d310 100644
--- a/drivers/staging/octeon/octeon-stubs.h
+++ b/drivers/staging/octeon/octeon-stubs.h
@@ -1202,7 +1202,7 @@ static inline int cvmx_wqe_get_grp(cvmx_wqe_t *work)
 
 static inline void *cvmx_phys_to_ptr(uint64_t physical_address)
 {
-	return (void *)(physical_address);
+	return (void *)(uintptr_t)(physical_address);
 }
 
 static inline uint64_t cvmx_ptr_to_phys(void *ptr)
-- 
2.17.1

