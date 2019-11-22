Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27E30107852
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 20:53:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727519AbfKVTtj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 14:49:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:49554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727484AbfKVTti (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 14:49:38 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 34BCB2072D;
        Fri, 22 Nov 2019 19:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574452177;
        bh=o+FcnjAr4l6b6GsIcdrroLJ1V8AgtiMh6PuIpSHnYUw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L8H8gX9PsKYFim98w7pgmrD1Ieoq6kGvSVZoC7mmCkullhqDbrrrgp1k4F8v5qBCu
         HWsOZF2aV9GRf6kYW7eWr8+G8YIVYQn3b4mwKL8ocL5pJICkkTT/Ootsus9jL54ctB
         p9njCZMDadiKRqH8+Exs6yp8qUEXUdfsbkwx/4SU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mordechay Goodstein <mordechay.goodstein@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 04/21] iwlwifi: pcie: don't consider IV len in A-MSDU
Date:   Fri, 22 Nov 2019 14:49:14 -0500
Message-Id: <20191122194931.24732-4-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122194931.24732-1-sashal@kernel.org>
References: <20191122194931.24732-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mordechay Goodstein <mordechay.goodstein@intel.com>

[ Upstream commit cb1a4badf59275eb7221dcec621e8154917eabd1 ]

From gen2 PN is totally offloaded to hardware (also the space for the
IV isn't part of the skb).  As you can see in mvm/mac80211.c:3545, the
MAC for cipher types CCMP/GCMP doesn't set
IEEE80211_KEY_FLAG_PUT_IV_SPACE for gen2 NICs.

This causes all the AMSDU data to be corrupted with cipher enabled.

Signed-off-by: Mordechay Goodstein <mordechay.goodstein@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/intel/iwlwifi/pcie/tx-gen2.c | 20 +++++++------------
 1 file changed, 7 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
index 6f45c8148b279..bbb39d6ec2ee3 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
@@ -232,27 +232,23 @@ static int iwl_pcie_gen2_build_amsdu(struct iwl_trans *trans,
 	struct ieee80211_hdr *hdr = (void *)skb->data;
 	unsigned int snap_ip_tcp_hdrlen, ip_hdrlen, total_len, hdr_room;
 	unsigned int mss = skb_shinfo(skb)->gso_size;
-	u16 length, iv_len, amsdu_pad;
+	u16 length, amsdu_pad;
 	u8 *start_hdr;
 	struct iwl_tso_hdr_page *hdr_page;
 	struct page **page_ptr;
 	struct tso_t tso;
 
-	/* if the packet is protected, then it must be CCMP or GCMP */
-	iv_len = ieee80211_has_protected(hdr->frame_control) ?
-		IEEE80211_CCMP_HDR_LEN : 0;
-
 	trace_iwlwifi_dev_tx(trans->dev, skb, tfd, sizeof(*tfd),
 			     &dev_cmd->hdr, start_len, 0);
 
 	ip_hdrlen = skb_transport_header(skb) - skb_network_header(skb);
 	snap_ip_tcp_hdrlen = 8 + ip_hdrlen + tcp_hdrlen(skb);
-	total_len = skb->len - snap_ip_tcp_hdrlen - hdr_len - iv_len;
+	total_len = skb->len - snap_ip_tcp_hdrlen - hdr_len;
 	amsdu_pad = 0;
 
 	/* total amount of header we may need for this A-MSDU */
 	hdr_room = DIV_ROUND_UP(total_len, mss) *
-		(3 + snap_ip_tcp_hdrlen + sizeof(struct ethhdr)) + iv_len;
+		(3 + snap_ip_tcp_hdrlen + sizeof(struct ethhdr));
 
 	/* Our device supports 9 segments at most, it will fit in 1 page */
 	hdr_page = get_page_hdr(trans, hdr_room);
@@ -263,14 +259,12 @@ static int iwl_pcie_gen2_build_amsdu(struct iwl_trans *trans,
 	start_hdr = hdr_page->pos;
 	page_ptr = (void *)((u8 *)skb->cb + trans_pcie->page_offs);
 	*page_ptr = hdr_page->page;
-	memcpy(hdr_page->pos, skb->data + hdr_len, iv_len);
-	hdr_page->pos += iv_len;
 
 	/*
-	 * Pull the ieee80211 header + IV to be able to use TSO core,
+	 * Pull the ieee80211 header to be able to use TSO core,
 	 * we will restore it for the tx_status flow.
 	 */
-	skb_pull(skb, hdr_len + iv_len);
+	skb_pull(skb, hdr_len);
 
 	/*
 	 * Remove the length of all the headers that we don't actually
@@ -348,8 +342,8 @@ static int iwl_pcie_gen2_build_amsdu(struct iwl_trans *trans,
 		}
 	}
 
-	/* re -add the WiFi header and IV */
-	skb_push(skb, hdr_len + iv_len);
+	/* re -add the WiFi header */
+	skb_push(skb, hdr_len);
 
 	return 0;
 
-- 
2.20.1

