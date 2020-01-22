Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89D7F145E8F
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 23:25:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726049AbgAVWYC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 17:24:02 -0500
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:47802 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726026AbgAVWYB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 17:24:01 -0500
Received: by kvm5.telegraphics.com.au (Postfix, from userid 502)
        id 539A3299A5; Wed, 22 Jan 2020 17:23:59 -0500 (EST)
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Chris Zankel <chris@zankel.net>,
        Laurent Vivier <laurent@vivier.eu>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <440cbc1f97d5dff3ca3de53bc0fb35a308f96865.1579730846.git.fthain@telegraphics.com.au>
In-Reply-To: <cover.1579730846.git.fthain@telegraphics.com.au>
References: <cover.1579730846.git.fthain@telegraphics.com.au>
From:   Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH net v3 03/12] net/sonic: Use MMIO accessors
Date:   Thu, 23 Jan 2020 09:07:26 +1100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver accesses descriptor memory which is simultaneously accessed by
the chip, so the compiler must not be allowed to re-order CPU accesses.
sonic_buf_get() used 'volatile' to prevent that. sonic_buf_put() should
have done so too but was overlooked.

Fixes: efcce839360f ("[PATCH] macsonic/jazzsonic network drivers update")
Tested-by: Stan Johnson <userm57@yahoo.com>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
---
 drivers/net/ethernet/natsemi/sonic.h | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/natsemi/sonic.h b/drivers/net/ethernet/natsemi/sonic.h
index f9506863e9d1..fb160dfdf4ca 100644
--- a/drivers/net/ethernet/natsemi/sonic.h
+++ b/drivers/net/ethernet/natsemi/sonic.h
@@ -345,30 +345,30 @@ static void sonic_msg_init(struct net_device *dev);
    as far as we can tell. */
 /* OpenBSD calls this "SWO".  I'd like to think that sonic_buf_put()
    is a much better name. */
-static inline void sonic_buf_put(void* base, int bitmode,
+static inline void sonic_buf_put(u16 *base, int bitmode,
 				 int offset, __u16 val)
 {
 	if (bitmode)
 #ifdef __BIG_ENDIAN
-		((__u16 *) base + (offset*2))[1] = val;
+		__raw_writew(val, base + (offset * 2) + 1);
 #else
-		((__u16 *) base + (offset*2))[0] = val;
+		__raw_writew(val, base + (offset * 2) + 0);
 #endif
 	else
-	 	((__u16 *) base)[offset] = val;
+		__raw_writew(val, base + (offset * 1) + 0);
 }
 
-static inline __u16 sonic_buf_get(void* base, int bitmode,
+static inline __u16 sonic_buf_get(u16 *base, int bitmode,
 				  int offset)
 {
 	if (bitmode)
 #ifdef __BIG_ENDIAN
-		return ((volatile __u16 *) base + (offset*2))[1];
+		return __raw_readw(base + (offset * 2) + 1);
 #else
-		return ((volatile __u16 *) base + (offset*2))[0];
+		return __raw_readw(base + (offset * 2) + 0);
 #endif
 	else
-		return ((volatile __u16 *) base)[offset];
+		return __raw_readw(base + (offset * 1) + 0);
 }
 
 /* Inlines that you should actually use for reading/writing DMA buffers */
-- 
2.24.1

