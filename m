Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 501042F8BE2
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 07:18:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726704AbhAPGPN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jan 2021 01:15:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725781AbhAPGPM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jan 2021 01:15:12 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8010C061796;
        Fri, 15 Jan 2021 22:14:30 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id x126so6884882pfc.7;
        Fri, 15 Jan 2021 22:14:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=GcDQDv7mFHcGzkL4z+RhUvR05OkRKTeW0Xhqt5i/PZc=;
        b=YyOsnKFsHbCCOnTLmJKeqet080Pd14q0jBAKWAnJz0hX9kpU44mvuJcBaesXsg64ST
         6bKPjzj+/HetnFOx2C2NTYicW2Xn9Om0LhlTtGnjvNp1/gU40KgDmUarRbqsBA0b3Xvv
         pGxmXTWzRWWflsIQYQawDa+J484K1aAZuTpV8s4+bR7zP1Y86bEM0Kg8/hjvPS+fSj5U
         YqfP51movbhNtI4sPdTFLKyXHRw4A4nJhyDe2peak0nLa8y9i45gsQMeYUaHqelCOmAq
         p7aolZ0XIr14JFiDPcyu4yl6r8doSXOS5G3wPqbQv/Zd3OmS/ssDOphM7sTJ2UEHMM2C
         arxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=GcDQDv7mFHcGzkL4z+RhUvR05OkRKTeW0Xhqt5i/PZc=;
        b=IaGr4S0YqjE9qVjTApxgTQ5s/d2t9ILGEG5eBWqGxngqr9C/ecaieYGbjuwoUY5RjH
         K5oUQjYbLEDobBnVsdNhQqHanP71PJ2n3pl4tq2p67UX5AUb16TFvZF8hclWYMg0lobh
         Im04jI2nskGrpq2hu2ScuOgk/Wjuw1SaD1mQpUZFzbcGpUO7W513hEudjUtkSwxLHXQh
         uP+FCocOYr/xtAG6/T0WI8jQgaSdsyTwGjzr75K1Dtus0YCai8AjE/sjNSj6ilFYFilL
         mKW/oEW0SWExAatukfBQ7YPPsUyp+3Wi10w0M5Zx7ycauewaVcvIb8BchzKOumlfrrAy
         DH5g==
X-Gm-Message-State: AOAM531JyYqX4VTiUmrpd93HuhMvGMnhj//wo824Rk3NQoePsG/nGk61
        Qok/JnWyhwsNHrqkxt449pOXFf1QY9idkw==
X-Google-Smtp-Source: ABdhPJxETlwAXI2t5X+FU6+CsHVtHCXjSMbknJQFc+8hdJKgfKrSOvWgMOyi9vIPNWMHLCnfN8lFkA==
X-Received: by 2002:a65:5283:: with SMTP id y3mr16253618pgp.174.1610777670297;
        Fri, 15 Jan 2021 22:14:30 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id w200sm9864931pfc.14.2021.01.15.22.14.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 15 Jan 2021 22:14:29 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        intel-wired-lan@lists.osuosl.org
Subject: [PATCH net-next 5/6] net: ixgbe: use skb_csum_is_sctp instead of protocol check
Date:   Sat, 16 Jan 2021 14:13:41 +0800
Message-Id: <f58d50ef96eb1504f4a952cc75a19d21dcf85827.1610777159.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <7b4d84fe32d588884fcd75c2f6f84eb8cd052622.1610777159.git.lucien.xin@gmail.com>
References: <cover.1610777159.git.lucien.xin@gmail.com>
 <34c9f5b8c31610687925d9db1f151d5bc87deba7.1610777159.git.lucien.xin@gmail.com>
 <aa69157e286b0178bf115124f4b2da254e07a291.1610777159.git.lucien.xin@gmail.com>
 <c1a1972ea509a7559a8900e1a33212d09f58f3c9.1610777159.git.lucien.xin@gmail.com>
 <7b4d84fe32d588884fcd75c2f6f84eb8cd052622.1610777159.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1610777159.git.lucien.xin@gmail.com>
References: <cover.1610777159.git.lucien.xin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Using skb_csum_is_sctp is a easier way to validate it's a SCTP CRC
checksum offload packet, and yet it also makes ixgbe support SCTP
CRC checksum offload for UDP and GRE encapped packets, just as it
does in igb driver.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 6cbbe09..2973c54 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -8040,15 +8040,6 @@ static int ixgbe_tso(struct ixgbe_ring *tx_ring,
 	return 1;
 }
 
-static inline bool ixgbe_ipv6_csum_is_sctp(struct sk_buff *skb)
-{
-	unsigned int offset = 0;
-
-	ipv6_find_hdr(skb, &offset, IPPROTO_SCTP, NULL, NULL);
-
-	return offset == skb_checksum_start_offset(skb);
-}
-
 static void ixgbe_tx_csum(struct ixgbe_ring *tx_ring,
 			  struct ixgbe_tx_buffer *first,
 			  struct ixgbe_ipsec_tx_data *itd)
@@ -8074,10 +8065,7 @@ static void ixgbe_tx_csum(struct ixgbe_ring *tx_ring,
 		break;
 	case offsetof(struct sctphdr, checksum):
 		/* validate that this is actually an SCTP request */
-		if (((first->protocol == htons(ETH_P_IP)) &&
-		     (ip_hdr(skb)->protocol == IPPROTO_SCTP)) ||
-		    ((first->protocol == htons(ETH_P_IPV6)) &&
-		     ixgbe_ipv6_csum_is_sctp(skb))) {
+		if (skb_csum_is_sctp(skb)) {
 			type_tucmd = IXGBE_ADVTXD_TUCMD_L4T_SCTP;
 			break;
 		}
-- 
2.1.0

