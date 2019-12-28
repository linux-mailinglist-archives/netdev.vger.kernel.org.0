Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C1AE12BDA4
	for <lists+netdev@lfdr.de>; Sat, 28 Dec 2019 14:32:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726315AbfL1Nb6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Dec 2019 08:31:58 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:55624 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726080AbfL1Nb6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Dec 2019 08:31:58 -0500
Received: by mail-wm1-f67.google.com with SMTP id q9so8732042wmj.5
        for <netdev@vger.kernel.org>; Sat, 28 Dec 2019 05:31:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=a6NyS5+y4Q5nUf+y9HIj/RTAUFghXtAyQP1xj5M8W9o=;
        b=BZKbuqcTs98lAbnE7wNdzeQpeo3a6Vxxkqd0xh4nzQoecL3OqzlfJIM8g9Q+kVTRrx
         lQzRqytN64nNYQmy+SQNmag+6QphksdjxGyBD0QAu3ZEru9F4LTU6A5P3Nxd+CixiHQR
         qJKiNdaddmeKDfPw5a4YsLpKIuiFKaM/TH+fi6yxUQ7WHMqoIHiDAP32JblMckIE3bLO
         nFqNgShbYl4ks0HPPfIzrcSiXc14igZQLvki/vi49/1dGmXivJfXsI117AXZE6LNde7y
         vhVzoUh3a5doB3/cyyEqacL6JMQd0HAqz70v0UtDEBV6B/kYlklvxGXnacQCsChBkM/N
         Ba2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=a6NyS5+y4Q5nUf+y9HIj/RTAUFghXtAyQP1xj5M8W9o=;
        b=bdKUEb2MLrOD8vVuPENzXuP6AHm0N7Ys6nUufb9XFzIZVLOhYp8C/iJPPch1bgjnT9
         L4+NE7j1oZ2bYNFz9G9DytBrftHCxWv7//RDtZrzyPfSj24cxF1SOrUxbgKqN3T1cmlJ
         uj4H1omeU4YMSPBc4WbFMbFKLHaP/uatNS9ghL/TQWG5FtJuUNJUY/gUuSgclIyuRPax
         CJf7ixIm3NU3YCzUEhsjA4S++WoIt6/NvDfRA+1XlaPg/TBk16Gw5un426+boq7z3J1h
         ItInS6QuVajzqQ21m5Ds5aBIF3tr7iPcX47AKHjEd4oehXd6ma5Sj5m9y2gS3n+a6UHu
         iD6Q==
X-Gm-Message-State: APjAAAWuXT8b3+H+4eoVqd7/vfgDeEsNIAsYiD55nAITdXwEtT0tPL3m
        7GWuVpop+o+20NaPDsTWpuw=
X-Google-Smtp-Source: APXvYqxDrWJmTgQLUtqAQiLubqoGUySWtq690+EYgkRxBmyiF3QMDa8tVSN9Ng4ZfM0k3U+HkuGkTg==
X-Received: by 2002:a05:600c:251:: with SMTP id 17mr23325616wmj.88.1577539916234;
        Sat, 28 Dec 2019 05:31:56 -0800 (PST)
Received: from localhost.localdomain ([188.25.254.226])
        by smtp.gmail.com with ESMTPSA id a1sm37846199wrr.80.2019.12.28.05.31.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Dec 2019 05:31:55 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, jakub.kicinski@netronome.com
Cc:     richardcochran@gmail.com, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, andrew@lunn.ch, claudiu.manoil@nxp.com,
        yangbo.lu@nxp.com, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v2 net 1/2] gianfar: Fix TX timestamping with a stacked DSA driver
Date:   Sat, 28 Dec 2019 15:30:45 +0200
Message-Id: <20191228133046.9406-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191228133046.9406-1-olteanv@gmail.com>
References: <20191228133046.9406-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver wrongly assumes that it is the only entity that can set the
SKBTX_IN_PROGRESS bit of the current skb. Therefore, in the
gfar_clean_tx_ring function, where the TX timestamp is collected if
necessary, the aforementioned bit is used to discriminate whether or not
the TX timestamp should be delivered to the socket's error queue.

But a stacked driver such as a DSA switch can also set the
SKBTX_IN_PROGRESS bit, which is actually exactly what it should do in
order to denote that the hardware timestamping process is undergoing.

Therefore, gianfar would misinterpret the "in progress" bit as being its
own, and deliver a second skb clone in the socket's error queue,
completely throwing off a PTP process which is not expecting to receive
it, _even though_ TX timestamping is not enabled for gianfar.

There have been discussions [0] as to whether non-MAC drivers need or
not to set SKBTX_IN_PROGRESS at all (whose purpose is to avoid sending 2
timestamps, a sw and a hw one, to applications which only expect one).
But as of this patch, there are at least 2 PTP drivers that would break
in conjunction with gianfar: the sja1105 DSA switch and the felix
switch, by way of its ocelot core driver.

So regardless of that conclusion, fix the gianfar driver to not do stuff
based on flags set by others and not intended for it.

[0]: https://www.spinics.net/lists/netdev/msg619699.html

Fixes: f0ee7acfcdd4 ("gianfar: Add hardware TX timestamping support")
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
Acked-by: Richard Cochran <richardcochran@gmail.com>
---
Changes from v1:
- Reworded the commit message, dropped reference to the TI PHYTER.

 drivers/net/ethernet/freescale/gianfar.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/freescale/gianfar.c b/drivers/net/ethernet/freescale/gianfar.c
index 72868a28b621..7d08bf6370ae 100644
--- a/drivers/net/ethernet/freescale/gianfar.c
+++ b/drivers/net/ethernet/freescale/gianfar.c
@@ -2205,13 +2205,17 @@ static void gfar_clean_tx_ring(struct gfar_priv_tx_q *tx_queue)
 	skb_dirtytx = tx_queue->skb_dirtytx;
 
 	while ((skb = tx_queue->tx_skbuff[skb_dirtytx])) {
+		bool do_tstamp;
+
+		do_tstamp = (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) &&
+			    priv->hwts_tx_en;
 
 		frags = skb_shinfo(skb)->nr_frags;
 
 		/* When time stamping, one additional TxBD must be freed.
 		 * Also, we need to dma_unmap_single() the TxPAL.
 		 */
-		if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_IN_PROGRESS))
+		if (unlikely(do_tstamp))
 			nr_txbds = frags + 2;
 		else
 			nr_txbds = frags + 1;
@@ -2225,7 +2229,7 @@ static void gfar_clean_tx_ring(struct gfar_priv_tx_q *tx_queue)
 		    (lstatus & BD_LENGTH_MASK))
 			break;
 
-		if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_IN_PROGRESS)) {
+		if (unlikely(do_tstamp)) {
 			next = next_txbd(bdp, base, tx_ring_size);
 			buflen = be16_to_cpu(next->length) +
 				 GMAC_FCB_LEN + GMAC_TXPAL_LEN;
@@ -2235,7 +2239,7 @@ static void gfar_clean_tx_ring(struct gfar_priv_tx_q *tx_queue)
 		dma_unmap_single(priv->dev, be32_to_cpu(bdp->bufPtr),
 				 buflen, DMA_TO_DEVICE);
 
-		if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_IN_PROGRESS)) {
+		if (unlikely(do_tstamp)) {
 			struct skb_shared_hwtstamps shhwtstamps;
 			u64 *ns = (u64 *)(((uintptr_t)skb->data + 0x10) &
 					  ~0x7UL);
-- 
2.17.1

