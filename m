Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A2CF2F8BE4
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 07:18:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726741AbhAPGPU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jan 2021 01:15:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725781AbhAPGPT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jan 2021 01:15:19 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45BFCC061757;
        Fri, 15 Jan 2021 22:14:39 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id n10so7405769pgl.10;
        Fri, 15 Jan 2021 22:14:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=tdERieQxHdGfwIbBa+vBjrBhMvCQN0KrezwB3bCvhCI=;
        b=AjcIgbmspBRodbPF6HCP12RUDlCEdUblG8XgtE6rAarmbJbtnjqyW9JxUvl2IJYV1e
         F6SJBjnt5ofo5gojJxy4deiqtVaQUguzqUpeQF4D0+gDroeYtpC+ecQ86SKT9Vb3NOy/
         eIJ+SisYel2+kYCVsbNNT70NJ2ny5P5mzNtfNHibf+rDppRbGGupUZUDDcsnPxpl085U
         EGb+O7JpM+uD76HSJuBKLBA0zh8Q0jc75fCC/LRWCPEXgAif69mx8VQVsEMGuotoAvSN
         JSvV8CDACiLR6GGHsNZYteuY03NTiWAa6ka0WyS6CQVe/EqZzHYmAgmpeiu+iCsfpu6R
         PiNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=tdERieQxHdGfwIbBa+vBjrBhMvCQN0KrezwB3bCvhCI=;
        b=qyogI8qK0/k4cqHG0M2xs5osuNKOHtdFWpsDKsAJkEfJVvaQnC0+FCkrnBRT2uCAGg
         Tl2mbdrU3fvutQFZ+wvYqkcz8RXOsjy0KamKTCoRJ0QuNb0ufnRiY2079skpwp1nKdT0
         xpFLWLyu4lsBIEEe4bctKn1lbi4mWjmf7aUPOR0frRFIwfTas/89Jbnwt5Zq02x/IUov
         WbTBgcW9dIGLub0CTwqhTKcETX3hACaFKkKRSqEgveeQB2Tta1Ur1yf1OlQ9KNjL3RBN
         wnhfykfD3G+5VwsJ8wzcNetK5dTPlc3WQGas83VwmNdgBG/jpRfrTx1H5M1D3pjhgycT
         aOMA==
X-Gm-Message-State: AOAM530FA6JjuRY5Vcsuac+OS74O570Aw28CUW5rPAM31A2TDX47fRMB
        IrHLw4wpbPYTcdgjzXspT8clW9pCqX5K/g==
X-Google-Smtp-Source: ABdhPJyHhkO2bjdkIB45X0LnolVIdaFq4kG082tSkw1Um22ir/+9vGKKnuz4igyhIXt4mGN0dy7uKg==
X-Received: by 2002:a05:6a00:a88:b029:19e:4ba8:bbe4 with SMTP id b8-20020a056a000a88b029019e4ba8bbe4mr16769998pfl.41.1610777678637;
        Fri, 15 Jan 2021 22:14:38 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y189sm9593875pfb.155.2021.01.15.22.14.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 15 Jan 2021 22:14:38 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        intel-wired-lan@lists.osuosl.org
Subject: [PATCH net-next 6/6] net: ixgbevf: use skb_csum_is_sctp instead of protocol check
Date:   Sat, 16 Jan 2021 14:13:42 +0800
Message-Id: <c7cd3ae7df46d579a11c277f9cb258b7955415b2.1610777159.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <f58d50ef96eb1504f4a952cc75a19d21dcf85827.1610777159.git.lucien.xin@gmail.com>
References: <cover.1610777159.git.lucien.xin@gmail.com>
 <34c9f5b8c31610687925d9db1f151d5bc87deba7.1610777159.git.lucien.xin@gmail.com>
 <aa69157e286b0178bf115124f4b2da254e07a291.1610777159.git.lucien.xin@gmail.com>
 <c1a1972ea509a7559a8900e1a33212d09f58f3c9.1610777159.git.lucien.xin@gmail.com>
 <7b4d84fe32d588884fcd75c2f6f84eb8cd052622.1610777159.git.lucien.xin@gmail.com>
 <f58d50ef96eb1504f4a952cc75a19d21dcf85827.1610777159.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1610777159.git.lucien.xin@gmail.com>
References: <cover.1610777159.git.lucien.xin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Using skb_csum_is_sctp is a easier way to validate it's a SCTP CRC
checksum offload packet, and yet it also makes ixgbevf support SCTP
CRC checksum offload for UDP and GRE encapped packets, just as it
does in igb driver.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
index 4061cd7..cd9d79f 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -3844,15 +3844,6 @@ static int ixgbevf_tso(struct ixgbevf_ring *tx_ring,
 	return 1;
 }
 
-static inline bool ixgbevf_ipv6_csum_is_sctp(struct sk_buff *skb)
-{
-	unsigned int offset = 0;
-
-	ipv6_find_hdr(skb, &offset, IPPROTO_SCTP, NULL, NULL);
-
-	return offset == skb_checksum_start_offset(skb);
-}
-
 static void ixgbevf_tx_csum(struct ixgbevf_ring *tx_ring,
 			    struct ixgbevf_tx_buffer *first,
 			    struct ixgbevf_ipsec_tx_data *itd)
@@ -3873,10 +3864,7 @@ static void ixgbevf_tx_csum(struct ixgbevf_ring *tx_ring,
 		break;
 	case offsetof(struct sctphdr, checksum):
 		/* validate that this is actually an SCTP request */
-		if (((first->protocol == htons(ETH_P_IP)) &&
-		     (ip_hdr(skb)->protocol == IPPROTO_SCTP)) ||
-		    ((first->protocol == htons(ETH_P_IPV6)) &&
-		     ixgbevf_ipv6_csum_is_sctp(skb))) {
+		if (skb_csum_is_sctp(skb)) {
 			type_tucmd = IXGBE_ADVTXD_TUCMD_L4T_SCTP;
 			break;
 		}
-- 
2.1.0

