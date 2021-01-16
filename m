Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2639A2F8BDE
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 07:15:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726665AbhAPGPD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jan 2021 01:15:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725781AbhAPGPC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jan 2021 01:15:02 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9777AC061795;
        Fri, 15 Jan 2021 22:14:22 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id h10so6888868pfo.9;
        Fri, 15 Jan 2021 22:14:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=V2nEP27oGTcNy8IrU1fSA3OjNH51LnvWbCcr7tSh5c4=;
        b=bGjvKnbY+JV9g1sz/zHa0oU2w2C0idy+1+ZliPwg8xRc2aJP+MnrANHVyu8X0UT0hN
         J5M29sLWMEIbCec47kB7sRD6NLB6iUkAyaLFwEfpmsb+EY0h5EeV37f8LZsZRLwZR68y
         hPtUhSQqdGyT37M0dOr5Myagv/IUC+0js7TnMF7TDuib5eOhnhKRwWy3mzRb6GHdaLz7
         ZuE2C66mwjmtfDHwIXi6ocUZeHenQkWUFB86jdvB/xVW+sikj5LDQGEwuuzMjQNZ4WMO
         zgTETYT3JmNkoADYLl1+AruRau4yYTgjzw+f4k7rDejFXcjutW8xELStSBFH42tW+M73
         TL2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=V2nEP27oGTcNy8IrU1fSA3OjNH51LnvWbCcr7tSh5c4=;
        b=rjngdJtYphudYiNpVsxfZt07bnpz2gCC+QJbufXe3DdTeZ328r+eJJtFBmH3kwwNxh
         H5vM8aTBZaC75P5i6HwOmldXUpuU0i3xHhW3/NblrRfPkK9PZZ4HNaetSwVDV9y/dxaf
         U14U9rH//do1WTd1vbzbZZy04lOQS7jpxMxx3CPVnbxxtwp6YRSIoiSQWtkXjELuYKOv
         ThmAPotSWNBQAyNvEzFtC9eBFBV/bgrRa9ZXrOx3sf0Tgz6QO/a9qWoYxzFJOC0cS6gK
         9YcEiBpfTxxa71dwujOOEpRCgQVm2wBcfYudzmRd+K+TcAnhdvxGVxCatl9HeLhw5gXV
         k2pQ==
X-Gm-Message-State: AOAM530dgylQ2ZcOHq3DJdGtyKNnNivhlniseViqqQAbzNJgt39TB8v2
        /Ov62QwZe/pQ6mww5IM+TKXy4ok4RFsC7g==
X-Google-Smtp-Source: ABdhPJyyy42brQiNKCwn9At6xMddGS+824+a+h4kd+1mpMebf24dzNCMMmkQFeKXtYh5D0bHp7U+IA==
X-Received: by 2002:a63:1110:: with SMTP id g16mr16274126pgl.357.1610777661982;
        Fri, 15 Jan 2021 22:14:21 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id f24sm9447968pjj.5.2021.01.15.22.14.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 15 Jan 2021 22:14:21 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        intel-wired-lan@lists.osuosl.org
Subject: [PATCH net-next 4/6] net: igc: use skb_csum_is_sctp instead of protocol check
Date:   Sat, 16 Jan 2021 14:13:40 +0800
Message-Id: <7b4d84fe32d588884fcd75c2f6f84eb8cd052622.1610777159.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <c1a1972ea509a7559a8900e1a33212d09f58f3c9.1610777159.git.lucien.xin@gmail.com>
References: <cover.1610777159.git.lucien.xin@gmail.com>
 <34c9f5b8c31610687925d9db1f151d5bc87deba7.1610777159.git.lucien.xin@gmail.com>
 <aa69157e286b0178bf115124f4b2da254e07a291.1610777159.git.lucien.xin@gmail.com>
 <c1a1972ea509a7559a8900e1a33212d09f58f3c9.1610777159.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1610777159.git.lucien.xin@gmail.com>
References: <cover.1610777159.git.lucien.xin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Using skb_csum_is_sctp is a easier way to validate it's a SCTP CRC
checksum offload packet, and yet it also makes igc support SCTP
CRC checksum offload for UDP and GRE encapped packets, just as it
does in igb driver.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index afd6a62..43aec42 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -949,15 +949,6 @@ static void igc_tx_ctxtdesc(struct igc_ring *tx_ring,
 	}
 }
 
-static inline bool igc_ipv6_csum_is_sctp(struct sk_buff *skb)
-{
-	unsigned int offset = 0;
-
-	ipv6_find_hdr(skb, &offset, IPPROTO_SCTP, NULL, NULL);
-
-	return offset == skb_checksum_start_offset(skb);
-}
-
 static void igc_tx_csum(struct igc_ring *tx_ring, struct igc_tx_buffer *first)
 {
 	struct sk_buff *skb = first->skb;
@@ -980,10 +971,7 @@ static void igc_tx_csum(struct igc_ring *tx_ring, struct igc_tx_buffer *first)
 		break;
 	case offsetof(struct sctphdr, checksum):
 		/* validate that this is actually an SCTP request */
-		if ((first->protocol == htons(ETH_P_IP) &&
-		     (ip_hdr(skb)->protocol == IPPROTO_SCTP)) ||
-		    (first->protocol == htons(ETH_P_IPV6) &&
-		     igc_ipv6_csum_is_sctp(skb))) {
+		if (skb_csum_is_sctp(skb)) {
 			type_tucmd = IGC_ADVTXD_TUCMD_L4T_SCTP;
 			break;
 		}
-- 
2.1.0

