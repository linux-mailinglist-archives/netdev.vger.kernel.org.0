Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 417512F8BDC
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 07:15:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726629AbhAPGO5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jan 2021 01:14:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725781AbhAPGO5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jan 2021 01:14:57 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6C64C061794;
        Fri, 15 Jan 2021 22:14:16 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id m6so6891617pfm.6;
        Fri, 15 Jan 2021 22:14:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=uvk0y2wENIsw6rNbF1+OkFOxLr21ev6bXBNVBL+g4HU=;
        b=ZNCpCUkAxqUeDra4bYat8qk9p9VWE1LQhAyFYufQ6mEdxVK2AuwF97T3rwO0nkneX9
         l/7wLnhi11YARgirZC6yyMt3A7kdP1d1rnXWzI24VZEpW1O9JGIIrDkhUZedEBW+VIjV
         OKT1Fydi6UYRGbnUWc25RXE7s56kgBF+Aic4W2ckaE8JFjdipL5c2+W0aM4M4Xmvz+Pn
         2f0TvIT+Yue7pqhe7ZIeEiKVXtzI/d/wAhbLPV9wDav45kn4FZTRYhIAzpAvso4e/caV
         JbyDMTB9Wui1eRVGMI4BT/0mjDRpPFWtjG0jjA0tCu0QKpEiVrgB2HwY01unbOs2omA0
         /ECQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=uvk0y2wENIsw6rNbF1+OkFOxLr21ev6bXBNVBL+g4HU=;
        b=ivj9HBMMYncre9BoOb+jWx43GDVWaHfANxzSiGckHovfaXL7kwX1l+ok/JoHpynTUe
         cBllWG7nvN6ul9Bmsz6QMHRbF2g9yPWr8LIravJW5Ek8ac11CvS6C45/+gTRdnE5mKnB
         jp1PJMtLTUsEUNMIgIvGcEuKzdEAoDJCslzLYgQ0sAwR8s/opOItYJQ8Y0cC16BUjA8T
         y8MHwmXKzRgtM7hOT2pERzEyZXKeJy7HloZDOey5Om4rYy4JVQ3j9f0/WXBglSnxR+/i
         UYsfhv0VJdjc1Anm8hosUFO8MukaHC8I/LqLGSQwqqRtLUUDf7sntc++INnpEieb0DRL
         sbIQ==
X-Gm-Message-State: AOAM531/AM9o8hxQVOm0jbSlSrN1D/ClllkjQ4hiSS4AAuEAAXe+4skL
        rmLzxhvv2xhV1FTNewZZonzJXtDiKrtkMw==
X-Google-Smtp-Source: ABdhPJwoc/sR8PjU9Laii5iV7OfMXQl+IWjX9V4X6Y7mAAcvpLXovNzIXFrw1UvSb+dhbq71uX/7ag==
X-Received: by 2002:a63:43c6:: with SMTP id q189mr16036820pga.245.1610777656113;
        Fri, 15 Jan 2021 22:14:16 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 129sm9663877pfw.86.2021.01.15.22.14.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 15 Jan 2021 22:14:15 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        intel-wired-lan@lists.osuosl.org
Subject: [PATCH net-next 3/6] net: igbvf: use skb_csum_is_sctp instead of protocol check
Date:   Sat, 16 Jan 2021 14:13:39 +0800
Message-Id: <c1a1972ea509a7559a8900e1a33212d09f58f3c9.1610777159.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <aa69157e286b0178bf115124f4b2da254e07a291.1610777159.git.lucien.xin@gmail.com>
References: <cover.1610777159.git.lucien.xin@gmail.com>
 <34c9f5b8c31610687925d9db1f151d5bc87deba7.1610777159.git.lucien.xin@gmail.com>
 <aa69157e286b0178bf115124f4b2da254e07a291.1610777159.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1610777159.git.lucien.xin@gmail.com>
References: <cover.1610777159.git.lucien.xin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Using skb_csum_is_sctp is a easier way to validate it's a SCTP CRC
checksum offload packet, and yet it also makes igbvf support SCTP
CRC checksum offload for UDP and GRE encapped packets, just as it
does in igb driver.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 drivers/net/ethernet/intel/igbvf/netdev.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/intel/igbvf/netdev.c b/drivers/net/ethernet/intel/igbvf/netdev.c
index 30fdea2..fb3fbcb 100644
--- a/drivers/net/ethernet/intel/igbvf/netdev.c
+++ b/drivers/net/ethernet/intel/igbvf/netdev.c
@@ -2072,15 +2072,6 @@ static int igbvf_tso(struct igbvf_ring *tx_ring,
 	return 1;
 }
 
-static inline bool igbvf_ipv6_csum_is_sctp(struct sk_buff *skb)
-{
-	unsigned int offset = 0;
-
-	ipv6_find_hdr(skb, &offset, IPPROTO_SCTP, NULL, NULL);
-
-	return offset == skb_checksum_start_offset(skb);
-}
-
 static bool igbvf_tx_csum(struct igbvf_ring *tx_ring, struct sk_buff *skb,
 			  u32 tx_flags, __be16 protocol)
 {
@@ -2102,10 +2093,7 @@ static bool igbvf_tx_csum(struct igbvf_ring *tx_ring, struct sk_buff *skb,
 		break;
 	case offsetof(struct sctphdr, checksum):
 		/* validate that this is actually an SCTP request */
-		if (((protocol == htons(ETH_P_IP)) &&
-		     (ip_hdr(skb)->protocol == IPPROTO_SCTP)) ||
-		    ((protocol == htons(ETH_P_IPV6)) &&
-		     igbvf_ipv6_csum_is_sctp(skb))) {
+		if (skb_csum_is_sctp(skb)) {
 			type_tucmd = E1000_ADVTXD_TUCMD_L4T_SCTP;
 			break;
 		}
-- 
2.1.0

