Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C191C99A64
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 19:13:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391077AbfHVRMs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 13:12:48 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:46403 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733052AbfHVRMs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 13:12:48 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20190822171246euoutp02c68c901d0e1cc8edf7189ce2a7980f76~9TfaSWEyE1898918989euoutp02a
        for <netdev@vger.kernel.org>; Thu, 22 Aug 2019 17:12:46 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20190822171246euoutp02c68c901d0e1cc8edf7189ce2a7980f76~9TfaSWEyE1898918989euoutp02a
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1566493966;
        bh=UOkCLCh1WvbHpQZYwO8RvemaDSbUwqU6rhWFFCiDmsE=;
        h=From:To:Cc:Subject:Date:References:From;
        b=TPbQ2XJDJbuC8DG7na1TEViPhYVzfQuh1wa5MJXju7r1vw3m9zDcarWNF+fEC/s5Q
         XGybKQ1hnE5G/RihIQMbEf2kJBZ5887IxVbVln6mET5jPT00RJ+wA6xaWDsVUIWUqS
         sww8+vYYaQvbR1J72maXmf4HhoTMgt11UBMWvkQo=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20190822171245eucas1p113b527ac20ca4f2ed2c842a3cf5cdfcc~9TfYuOA5y2704927049eucas1p1E;
        Thu, 22 Aug 2019 17:12:45 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id CB.76.04374.C0DCE5D5; Thu, 22
        Aug 2019 18:12:44 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20190822171243eucas1p12213f2239d6c36be515dade41ed7470b~9TfXnJsX31493014930eucas1p1T;
        Thu, 22 Aug 2019 17:12:43 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20190822171243eusmtrp2d541b2dd599bc153d0eaa02062fc26b1~9TfXXgzaw1649316493eusmtrp2e;
        Thu, 22 Aug 2019 17:12:43 +0000 (GMT)
X-AuditID: cbfec7f5-4f7ff70000001116-28-5d5ecd0cfc62
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 84.F8.04117.B0DCE5D5; Thu, 22
        Aug 2019 18:12:43 +0100 (BST)
Received: from imaximets.rnd.samsung.ru (unknown [106.109.129.180]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20190822171242eusmtip15aebbf240f5ddf60e37aa801dea65411~9TfWNfopd1319413194eusmtip1T;
        Thu, 22 Aug 2019 17:12:42 +0000 (GMT)
From:   Ilya Maximets <i.maximets@samsung.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        intel-wired-lan@lists.osuosl.org,
        Eelco Chaudron <echaudro@redhat.com>,
        William Tu <u9012063@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Ilya Maximets <i.maximets@samsung.com>
Subject: [PATCH net v3] ixgbe: fix double clean of tx descriptors with xdp
Date:   Thu, 22 Aug 2019 20:12:37 +0300
Message-Id: <20190822171237.20798-1-i.maximets@samsung.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA0WSaUgUcRjG++/szoybq9N6/d3EYqkPiml28QelLM0GKYoIkUxr1PEoV2VH
        LTPIUFbTsDRKMDUPwgtUdPFKzRbZ9SrTNM/Y/GDqRuWVKYrmOkrfnvd5f+/zfHlJTFoukpER
        UbGsMoqJlONiYb12te+I6YfAgKOF7S5oM39ciJZWxwm0rqoBaLFDh6OSomUM5fWlCNHE4CqO
        BlNXCbQ5tiZC2pkUHHXW6QH63JyHozJNJ4G0hdZoeMDUw5xWl48K6KbcrwRd0jIroNNHBjC6
        tuIxTnclx9E5GZMY/bttCKcz1RWAXqy1vyK+LnYPYSMj4lmly+lb4nBDkV4QU21771OeVRJY
        sEwHJiSkTsA1bbkoHYhJKVUGoEFr2BmWAFxe6RfwwyKA01PTwt2TKt1TjF+UAqjT9+H8sALg
        29RXIiOFU06wu7IDGLUlJYPzjQ2EEcKoFiF83pm9HWVB+cClzPktiCSF1GFYXsAZpYRygxl1
        TnzZAVhZ075dBqkqAmZlVW3jkPKCDS8v8YwFNOjUBK/t4GbTawGvH0J9yizgb9MAzNFs7CzO
        QPWPj4QxB6McYHWzC2+fhaOppQI+3gyO/NxntLEtmV2fg/G2BKappDx9CK69L8V4LYOjvxYJ
        HqGhwbBtS6kAmNP/AjwD9rn/qwoBqAA2bBynCGO541HsXWeOUXBxUWHOwdGKWrD1QD0buj+N
        oG09SAMoEshNJZ3pgQFSERPPJSg0AJKY3FISn7VlSUKYhPusMvqmMi6S5TRgPymU20gS93zz
        l1JhTCx7h2VjWOXuVkCayJLAqYXbA0NzAFkNqrr8VY7nned7E57YMTVTfh7dZq3VVFbBTIp5
        67LbuXeunn9r3nz3Dg4d93XzuRZUXPogtiByTjp5o8S5p3v4wtCjfNPkXl+ZtTi0mFRcBmsn
        D9LA08FTtWSbfWxocK+X+mKiHE0wNu6+V/VFZmOzqMdv4ou3XMiFM66OmJJj/gGOd8bIPAMA
        AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkkeLIzCtJLcpLzFFi42I5/e/4XV3us3GxBnePiVr8n3ubxeLLz9vs
        Fn/aNjBafD5ynM1i8cJvzBZzzrewWNy58pPN4kr7T3aL/7d+s1oce9HCZnFi831Gi8u75rBZ
        rDh0gt3i2AIxi+uXeBz4PbasvMnksXPWXXaPxXteMnl03bjE7LFpVSebx8nmUo/p3Q+ZPd7v
        u8rm0bdlFaPH501yAVxRejZF+aUlqQoZ+cUltkrRhhZGeoaWFnpGJpZ6hsbmsVZGpkr6djYp
        qTmZZalF+nYJehmvFt5nKlgvWXFhjmgD4yeRLkZODgkBE4l1x/uZuxi5OIQEljJKdHw+ywSR
        kJL48esCK4QtLPHnWhcbRNE3Rombd2eygyTYBHQkTq0+wghiiwA1fNyxnR2kiFngBIvEzIkn
        wSYJC3hJfOn7CFTEwcEioCqxcl4xiMkrYC3RvVkHYr68xOoNB5gnMPIsYGRYxSiSWlqcm55b
        bKRXnJhbXJqXrpecn7uJERj824793LKDsetd8CFGAQ5GJR7eE11xsUKsiWXFlbmHGCU4mJVE
        eMsmAoV4UxIrq1KL8uOLSnNSiw8xmgKtnsgsJZqcD4zMvJJ4Q1NDcwtLQ3Njc2MzCyVx3g6B
        gzFCAumJJanZqakFqUUwfUwcnFINjFrxOWs9fWbsXJCoKfp6mn6dx12lZY7z/8Qf+V9o6Z03
        KyF2svNe5dQLW1PPTcu7+k+jOfH+G3WbopW3pi2/8J/ncnXo9q1LKkVMwy+fFruwUTL9+Mu4
        U+cDtyamXPRv9vXQynlgPH+PgYXYeabodQcMuVl33pKuFXUTtlz7Jrgy+crLUvH3j5RYijMS
        DbWYi4oTAU/1fI6UAgAA
X-CMS-MailID: 20190822171243eucas1p12213f2239d6c36be515dade41ed7470b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20190822171243eucas1p12213f2239d6c36be515dade41ed7470b
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20190822171243eucas1p12213f2239d6c36be515dade41ed7470b
References: <CGME20190822171243eucas1p12213f2239d6c36be515dade41ed7470b@eucas1p1.samsung.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tx code doesn't clear the descriptors' status after cleaning.
So, if the budget is larger than number of used elems in a ring, some
descriptors will be accounted twice and xsk_umem_complete_tx will move
prod_tail far beyond the prod_head breaking the completion queue ring.

Fix that by limiting the number of descriptors to clean by the number
of used descriptors in the tx ring.

'ixgbe_clean_xdp_tx_irq()' function refactored to look more like
'ixgbe_xsk_clean_tx_ring()' since we're allowed to directly use
'next_to_clean' and 'next_to_use' indexes.

Fixes: 8221c5eba8c1 ("ixgbe: add AF_XDP zero-copy Tx support")
Signed-off-by: Ilya Maximets <i.maximets@samsung.com>
---

Version 3:
  * Reverted some refactoring made for v2.
  * Eliminated 'budget' for tx clean.
  * prefetch returned.

Version 2:
  * 'ixgbe_clean_xdp_tx_irq()' refactored to look more like
    'ixgbe_xsk_clean_tx_ring()'.

 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c | 29 ++++++++------------
 1 file changed, 11 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
index 6b609553329f..a3b6d8c89127 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
@@ -633,19 +633,17 @@ static void ixgbe_clean_xdp_tx_buffer(struct ixgbe_ring *tx_ring,
 bool ixgbe_clean_xdp_tx_irq(struct ixgbe_q_vector *q_vector,
 			    struct ixgbe_ring *tx_ring, int napi_budget)
 {
+	u16 ntc = tx_ring->next_to_clean, ntu = tx_ring->next_to_use;
 	unsigned int total_packets = 0, total_bytes = 0;
-	u32 i = tx_ring->next_to_clean, xsk_frames = 0;
-	unsigned int budget = q_vector->tx.work_limit;
 	struct xdp_umem *umem = tx_ring->xsk_umem;
 	union ixgbe_adv_tx_desc *tx_desc;
 	struct ixgbe_tx_buffer *tx_bi;
-	bool xmit_done;
+	u32 xsk_frames = 0;
 
-	tx_bi = &tx_ring->tx_buffer_info[i];
-	tx_desc = IXGBE_TX_DESC(tx_ring, i);
-	i -= tx_ring->count;
+	tx_bi = &tx_ring->tx_buffer_info[ntc];
+	tx_desc = IXGBE_TX_DESC(tx_ring, ntc);
 
-	do {
+	while (ntc != ntu) {
 		if (!(tx_desc->wb.status & cpu_to_le32(IXGBE_TXD_STAT_DD)))
 			break;
 
@@ -661,22 +659,18 @@ bool ixgbe_clean_xdp_tx_irq(struct ixgbe_q_vector *q_vector,
 
 		tx_bi++;
 		tx_desc++;
-		i++;
-		if (unlikely(!i)) {
-			i -= tx_ring->count;
+		ntc++;
+		if (unlikely(ntc == tx_ring->count)) {
+			ntc = 0;
 			tx_bi = tx_ring->tx_buffer_info;
 			tx_desc = IXGBE_TX_DESC(tx_ring, 0);
 		}
 
 		/* issue prefetch for next Tx descriptor */
 		prefetch(tx_desc);
+	}
 
-		/* update budget accounting */
-		budget--;
-	} while (likely(budget));
-
-	i += tx_ring->count;
-	tx_ring->next_to_clean = i;
+	tx_ring->next_to_clean = ntc;
 
 	u64_stats_update_begin(&tx_ring->syncp);
 	tx_ring->stats.bytes += total_bytes;
@@ -688,8 +682,7 @@ bool ixgbe_clean_xdp_tx_irq(struct ixgbe_q_vector *q_vector,
 	if (xsk_frames)
 		xsk_umem_complete_tx(umem, xsk_frames);
 
-	xmit_done = ixgbe_xmit_zc(tx_ring, q_vector->tx.work_limit);
-	return budget > 0 && xmit_done;
+	return ixgbe_xmit_zc(tx_ring, q_vector->tx.work_limit);
 }
 
 int ixgbe_xsk_async_xmit(struct net_device *dev, u32 qid)
-- 
2.17.1

