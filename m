Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7DC112B006
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 01:45:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726981AbfL0ApZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 19:45:25 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:34727 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726375AbfL0ApX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 19:45:23 -0500
Received: by mail-wr1-f66.google.com with SMTP id t2so24862097wrr.1
        for <netdev@vger.kernel.org>; Thu, 26 Dec 2019 16:45:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=USllTaYQMZKfNxtrVl2nIUqk5hV99/lPZ+brsWY2g4A=;
        b=f6dJO4BBQmv/zUaxnlR4sVkHOC9eTq3w4rKohCROS8ZdYDTuesPW/hkKsG76M645Zk
         +gBU51ltt5acasCMDoOsYi8s4a8AlmO+H1VPHopiKNcMW8GLSgtpJHbzbd53/ylHCs+O
         XibVDoveDlqm8i9bK9bJKUdbCv9eqRVa5whpCJsx9P4qxoa4H8AdpkYlt536go4sUiSV
         R4YLpAascbfVsuYI9PkziLhXDJA4hb1dHoCnFVMO+Nlaf7Aj9Dv4vPZ4CnzmBU+JJWqk
         9e6nrsoNF19ZKCo/iF2bd9wsnRzzpjkLaORpfoXf8a/iiEanwDmSFCt0qOKsFjo9Io7+
         3VTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=USllTaYQMZKfNxtrVl2nIUqk5hV99/lPZ+brsWY2g4A=;
        b=QcfPBuit5Srx98raXc+Bu/A4tFWucWQzStOKt0o77zywtqr9dZvKGrZ0/sjClg+EAd
         1u5xN7BiZreI6SgqDOxiAwNxB7nt0D6bl2bD38zlIVV3Byj4NsNJCLiwEpwPjANZ7VMD
         Do6YU+oshm7KADwStqUrjq1U4n0iFvZ1LKGUHOPOFhmoORCEf2Y4T4KdPRMCwe4i3jwh
         hcljCb39pg3lEDylJx+a/YMmCoysjctPrzRGnVgaMn5UqNJ0lf2AkfGuM5NX65d4qyst
         N2Dg4hGdYW8iil38h/t1aGlXR9+/UN5O7nZh5rs3n6JT+r4TXc9gJV2wT6gQ7Y4P9uio
         e0gg==
X-Gm-Message-State: APjAAAWZgUXooDcgq8hGyCZAgJ5Munc/S7YSGB3X8DtnC2srODlMEun2
        U/5wjRlamDCJ5RCVD0bEqgB4/+uz
X-Google-Smtp-Source: APXvYqw9oSDTq/gosets8Tr6G+y7juuiNpRargJ+r5YsVNmlUGYfhnzL8fnIDdzx6xjqeU/AYOT1DQ==
X-Received: by 2002:a5d:5044:: with SMTP id h4mr46118625wrt.4.1577407521645;
        Thu, 26 Dec 2019 16:45:21 -0800 (PST)
Received: from localhost.localdomain ([188.25.254.226])
        by smtp.gmail.com with ESMTPSA id 60sm33816488wrn.86.2019.12.26.16.45.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Dec 2019 16:45:21 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, jakub.kicinski@netronome.com
Cc:     richardcochran@gmail.com, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, andrew@lunn.ch, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net 1/2] gianfar: Fix TX timestamping with stacked (DSA and PHY) drivers
Date:   Fri, 27 Dec 2019 02:44:34 +0200
Message-Id: <20191227004435.21692-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191227004435.21692-1-olteanv@gmail.com>
References: <20191227004435.21692-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver wrongly assumes that it is the only entity that can set the
SKBTX_IN_PROGRESS bit of the current skb. Therefore, in the
gfar_clean_tx_ring function, where the TX timestamp is collected if
necessary, the aforementioned bit is used to discriminate whether or not
the TX timestamp should be delivered to the socket's error queue.

But a stacked driver such as a DSA switch or a PTP-capable PHY can
also set SKBTX_IN_PROGRESS, which is actually exactly what it should do
in order to denote that the hardware timestamping process is undergoing.

Therefore, gianfar would misinterpret the "in progress" bit as being its
own, and deliver a second skb clone in the socket's error queue,
completely throwing off a PTP process which is not expecting to receive
it.

There have been discussions [0] as to whether non-MAC drivers need or not to
set SKBTX_IN_PROGRESS at all (whose purpose is to avoid sending 2
timestamps, a sw and a hw one, to applications which only expect one).
But as of this patch, there are at least 2 PTP drivers that would break
in conjunction with gianfar: the sja1105 DSA switch and the TI PHYTER
(dp83640). So until we reach a conclusion, fix the gianfar driver to not
do stuff based on flags set by others and not intended for it.

[0]: https://www.spinics.net/lists/netdev/msg619699.html

Fixes: f0ee7acfcdd4 ("gianfar: Add hardware TX timestamping support")
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
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

