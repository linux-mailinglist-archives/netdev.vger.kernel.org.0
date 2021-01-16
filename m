Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43FC52F8BD8
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 07:14:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726498AbhAPGOt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jan 2021 01:14:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725781AbhAPGOs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jan 2021 01:14:48 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 698E1C061793;
        Fri, 15 Jan 2021 22:14:08 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id v1so6293379pjr.2;
        Fri, 15 Jan 2021 22:14:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=/iL/g7I8EapQ7hx/Ua42HZrRsvsGuh8TkarNGwQsIs8=;
        b=gB937wVqSTEEqgO4ChtFvHK3VK3JSjkIepCYK5rBbNLDVN8uQ2ycZXkcxgJIPZ5lN+
         oSPfWgjLRy47C0aKrjnoz3vsDKV4HPitJLVVZi3jJ+KbMHRZYrBYlN/z/nKnH3YE6rBG
         khfL8WOCDNRbeSLjdVOjfaHuZRp8oczRC0nmVPO6wlgzWeTaaHr20/aXeovupBIGfzfY
         zBKwotFTysy9nhmp0peXofo7arXQ1TIL3L/i/1ErTu4yxsfMHlR5jAAG20MXB1IIoA3k
         BfCvT3cOPfwnBHwL9AabCLBsTfdDFS+E123bOTnZ7v0FRmzVJToef1LxFvziNZ/JrLdL
         dGmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=/iL/g7I8EapQ7hx/Ua42HZrRsvsGuh8TkarNGwQsIs8=;
        b=dg5t60s8ZM5OsnY2lcANdkUB1USeyfBTRAAUx34q9pk5DRukS+pTDKZ/supZ5GeR+5
         sOxvuL5Q6X2Ntfc0JirwgQcxe3UF0xEWjovPFPNdNaXK9GLpQFMW1WmU0uPfmUht7a3g
         1b4za3P4eaWhIOrbql+/4CNAV/WhmvEmc8GBs0RekwAk/vHTDc9MhULqI1sGJOlVosLI
         +zhjQx54xUedYPclkVrYLYCVUyl5OwAXPmQKlYvIb4GU37y6VR93waFFun7iM2ooZIJc
         k1R6y3kmgMH2QBzH1lA9uHzdqDWTEQa0rOtPu1x893FdNeD8GzjFgLufLAdP7c5lWslm
         P4XA==
X-Gm-Message-State: AOAM5338uFHfubxXLd+UzjbdmOXUHErtHvBLlR1AWoGSF0UcuiSWD6IV
        hg0YB6ZnhXrWF3xxYCXewGWXOhhZFzaVTQ==
X-Google-Smtp-Source: ABdhPJxLveKMeCpGPHjtVz4XEHzWNkVtXJXc6F6ZL4bY7V2ABEPcgX7nQoGKkKf27M9Tj8v6vzP9xA==
X-Received: by 2002:a17:90b:305:: with SMTP id ay5mr14955006pjb.4.1610777647794;
        Fri, 15 Jan 2021 22:14:07 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 19sm9658182pfn.133.2021.01.15.22.14.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 15 Jan 2021 22:14:07 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        intel-wired-lan@lists.osuosl.org
Subject: [PATCH net-next 2/6] net: igb: use skb_csum_is_sctp instead of protocol check
Date:   Sat, 16 Jan 2021 14:13:38 +0800
Message-Id: <aa69157e286b0178bf115124f4b2da254e07a291.1610777159.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <34c9f5b8c31610687925d9db1f151d5bc87deba7.1610777159.git.lucien.xin@gmail.com>
References: <cover.1610777159.git.lucien.xin@gmail.com>
 <34c9f5b8c31610687925d9db1f151d5bc87deba7.1610777159.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1610777159.git.lucien.xin@gmail.com>
References: <cover.1610777159.git.lucien.xin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Using skb_csum_is_sctp is a easier way to validate it's a SCTP
CRC checksum offload packet, and there is no need to parse the
packet to check its proto field, especially when it's a UDP or
GRE encapped packet.

So this patch also makes igb support SCTP CRC checksum offload
for UDP and GRE encapped packets.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 03f78fd..8757ad0 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -5959,15 +5959,6 @@ static int igb_tso(struct igb_ring *tx_ring,
 	return 1;
 }
 
-static inline bool igb_ipv6_csum_is_sctp(struct sk_buff *skb)
-{
-	unsigned int offset = 0;
-
-	ipv6_find_hdr(skb, &offset, IPPROTO_SCTP, NULL, NULL);
-
-	return offset == skb_checksum_start_offset(skb);
-}
-
 static void igb_tx_csum(struct igb_ring *tx_ring, struct igb_tx_buffer *first)
 {
 	struct sk_buff *skb = first->skb;
@@ -5990,10 +5981,7 @@ static void igb_tx_csum(struct igb_ring *tx_ring, struct igb_tx_buffer *first)
 		break;
 	case offsetof(struct sctphdr, checksum):
 		/* validate that this is actually an SCTP request */
-		if (((first->protocol == htons(ETH_P_IP)) &&
-		     (ip_hdr(skb)->protocol == IPPROTO_SCTP)) ||
-		    ((first->protocol == htons(ETH_P_IPV6)) &&
-		     igb_ipv6_csum_is_sctp(skb))) {
+		if (skb_csum_is_sctp(skb)) {
 			type_tucmd = E1000_ADVTXD_TUCMD_L4T_SCTP;
 			break;
 		}
-- 
2.1.0

