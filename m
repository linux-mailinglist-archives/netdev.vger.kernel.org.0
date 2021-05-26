Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C58013919CA
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 16:17:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234565AbhEZOTU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 10:19:20 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:4016 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233656AbhEZOTT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 10:19:19 -0400
Received: from dggems701-chm.china.huawei.com (unknown [172.30.72.59])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4FqtJW6pVCzmZ6j;
        Wed, 26 May 2021 22:15:23 +0800 (CST)
Received: from dggpeml500017.china.huawei.com (7.185.36.243) by
 dggems701-chm.china.huawei.com (10.3.19.178) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 26 May 2021 22:17:44 +0800
Received: from huawei.com (10.175.103.91) by dggpeml500017.china.huawei.com
 (7.185.36.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Wed, 26 May
 2021 22:17:44 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
CC:     <kvalo@codeaurora.org>, <davem@davemloft.net>
Subject: [PATCH -next] ath10k: Fix W=1 build warning in htt_rx.c
Date:   Wed, 26 May 2021 22:22:19 +0800
Message-ID: <20210526142219.2542528-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500017.china.huawei.com (7.185.36.243)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following W=1 build warning:

  drivers/net/wireless/ath/ath10k/htt_rx.c:1790:7: warning: variable ‘more_frags’ set but not used [-Wunused-but-set-variable]
   1790 |  bool more_frags;
        |       ^~~~~~~~~~

Fixes: a1166b2653db ("ath10k: add CCMP PN replay protection for fragmented frames for PCIe")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 7ffb5d5b2a70..adbaeb67eedf 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -1787,7 +1787,6 @@ static bool ath10k_htt_rx_h_frag_pn_check(struct ath10k *ar,
 	struct ath10k_peer *peer;
 	union htt_rx_pn_t *last_pn, new_pn = {0};
 	struct ieee80211_hdr *hdr;
-	bool more_frags;
 	u8 tid, frag_number;
 	u32 seq;
 
@@ -1805,7 +1804,6 @@ static bool ath10k_htt_rx_h_frag_pn_check(struct ath10k *ar,
 
 	last_pn = &peer->frag_tids_last_pn[tid];
 	new_pn.pn48 = ath10k_htt_rx_h_get_pn(ar, skb, offset, enctype);
-	more_frags = ieee80211_has_morefrags(hdr->frame_control);
 	frag_number = le16_to_cpu(hdr->seq_ctrl) & IEEE80211_SCTL_FRAG;
 	seq = (__le16_to_cpu(hdr->seq_ctrl) & IEEE80211_SCTL_SEQ) >> 4;
 
-- 
2.25.1

