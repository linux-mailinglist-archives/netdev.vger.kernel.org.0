Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0083113E0A6
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 17:45:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729456AbgAPQov (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 11:44:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:53202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729429AbgAPQou (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 11:44:50 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B63B2081E;
        Thu, 16 Jan 2020 16:44:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193089;
        bh=rPeM6Exb/bpIFHgVOdXerZts0pPNjw0Ql01DxSFrg7I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sjqq1DLiSm2Fsv9uQuWaZd2gm3FAvLoKkRjbhziRVUMlgvSfNHz3ymxwu3Eg4Mdu+
         tuOLNqUCii/LqYXK/saDUiw5mEhLferePlYx/C1aR76xhgilBiSqIAc2IPeTVgSB8J
         G0pl25FJg9PB8fiBRG8cfkReJi+pGRRvUJawn6Qg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 022/205] rtw88: fix beaconing mode rsvd_page memory violation issue
Date:   Thu, 16 Jan 2020 11:39:57 -0500
Message-Id: <20200116164300.6705-22-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

[ Upstream commit c3594559f49c601d410dee4b767c3536a5535bfd ]

When downloading the reserved page, the first page always contains
a beacon for the firmware to reference. For non-beaconing modes such
as station mode, also put a blank skb with length=1.

And for the beaconing modes, driver will get a real beacon with a
length approximate to the page size. But as the beacon is always put
at the first page, it does not need a tx_desc, because the TX path
will generate one when TXing the reserved page to the hardware. So we
could allocate a buffer with a size smaller than the reserved page,
when using memcpy() to copy the content of reserved page to the buffer,
the over-sized reserved page will violate the kernel memory.

To fix it, add the tx_desc before memcpy() the reserved packets to
the buffer, then we can get SKBs with correct length when counting
the pages in total. And for page 0, count the extra tx_desc_sz that
the TX path will generate. This way, the first beacon that allocated
without tx_desc can be counted with the extra tx_desc_sz to get
actual pages it requires.

Fixes: e3037485c68e ("rtw88: new Realtek 802.11ac driver")
Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/fw.c | 52 ++++++++++++++++++++-----
 1 file changed, 43 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/fw.c b/drivers/net/wireless/realtek/rtw88/fw.c
index b082e2cc95f5..35dbdb3c4f1e 100644
--- a/drivers/net/wireless/realtek/rtw88/fw.c
+++ b/drivers/net/wireless/realtek/rtw88/fw.c
@@ -498,9 +498,6 @@ static void rtw_rsvd_page_list_to_buf(struct rtw_dev *rtwdev, u8 page_size,
 {
 	struct sk_buff *skb = rsvd_pkt->skb;
 
-	if (rsvd_pkt->add_txdesc)
-		rtw_fill_rsvd_page_desc(rtwdev, skb);
-
 	if (page >= 1)
 		memcpy(buf + page_margin + page_size * (page - 1),
 		       skb->data, skb->len);
@@ -625,16 +622,37 @@ static u8 *rtw_build_rsvd_page(struct rtw_dev *rtwdev,
 	list_for_each_entry(rsvd_pkt, &rtwdev->rsvd_page_list, list) {
 		iter = rtw_get_rsvd_page_skb(hw, vif, rsvd_pkt->type);
 		if (!iter) {
-			rtw_err(rtwdev, "fail to build rsvd packet\n");
+			rtw_err(rtwdev, "failed to build rsvd packet\n");
 			goto release_skb;
 		}
+
+		/* Fill the tx_desc for the rsvd pkt that requires one.
+		 * And iter->len will be added with size of tx_desc_sz.
+		 */
+		if (rsvd_pkt->add_txdesc)
+			rtw_fill_rsvd_page_desc(rtwdev, iter);
+
 		rsvd_pkt->skb = iter;
 		rsvd_pkt->page = total_page;
-		if (rsvd_pkt->add_txdesc)
+
+		/* Reserved page is downloaded via TX path, and TX path will
+		 * generate a tx_desc at the header to describe length of
+		 * the buffer. If we are not counting page numbers with the
+		 * size of tx_desc added at the first rsvd_pkt (usually a
+		 * beacon, firmware default refer to the first page as the
+		 * content of beacon), we could generate a buffer which size
+		 * is smaller than the actual size of the whole rsvd_page
+		 */
+		if (total_page == 0) {
+			if (rsvd_pkt->type != RSVD_BEACON) {
+				rtw_err(rtwdev, "first page should be a beacon\n");
+				goto release_skb;
+			}
 			total_page += rtw_len_to_page(iter->len + tx_desc_sz,
 						      page_size);
-		else
+		} else {
 			total_page += rtw_len_to_page(iter->len, page_size);
+		}
 	}
 
 	if (total_page > rtwdev->fifo.rsvd_drv_pg_num) {
@@ -647,13 +665,24 @@ static u8 *rtw_build_rsvd_page(struct rtw_dev *rtwdev,
 	if (!buf)
 		goto release_skb;
 
+	/* Copy the content of each rsvd_pkt to the buf, and they should
+	 * be aligned to the pages.
+	 *
+	 * Note that the first rsvd_pkt is a beacon no matter what vif->type.
+	 * And that rsvd_pkt does not require tx_desc because when it goes
+	 * through TX path, the TX path will generate one for it.
+	 */
 	list_for_each_entry(rsvd_pkt, &rtwdev->rsvd_page_list, list) {
 		rtw_rsvd_page_list_to_buf(rtwdev, page_size, page_margin,
 					  page, buf, rsvd_pkt);
-		page += rtw_len_to_page(rsvd_pkt->skb->len, page_size);
-	}
-	list_for_each_entry(rsvd_pkt, &rtwdev->rsvd_page_list, list)
+		if (page == 0)
+			page += rtw_len_to_page(rsvd_pkt->skb->len +
+						tx_desc_sz, page_size);
+		else
+			page += rtw_len_to_page(rsvd_pkt->skb->len, page_size);
+
 		kfree_skb(rsvd_pkt->skb);
+	}
 
 	return buf;
 
@@ -706,6 +735,11 @@ int rtw_fw_download_rsvd_page(struct rtw_dev *rtwdev, struct ieee80211_vif *vif)
 		goto free;
 	}
 
+	/* The last thing is to download the *ONLY* beacon again, because
+	 * the previous tx_desc is to describe the total rsvd page. Download
+	 * the beacon again to replace the TX desc header, and we will get
+	 * a correct tx_desc for the beacon in the rsvd page.
+	 */
 	ret = rtw_download_beacon(rtwdev, vif);
 	if (ret) {
 		rtw_err(rtwdev, "failed to download beacon\n");
-- 
2.20.1

