Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F81B2F310B
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 14:16:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729554AbhALNPX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 08:15:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:54586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403932AbhALM5j (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 07:57:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E6DCF23117;
        Tue, 12 Jan 2021 12:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610456156;
        bh=H5pQPEc5iyPPT9rNhi7Jua1enRBDzNBh/PYR5I8UAH4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X9T+7hL8N9wqcTlL/mayBsd+t+9StyH6WucamFlQjGFWHiKanVAT5qNq3dwCnX94h
         q/MLAe4Odm9hzUg89ocxaE4xg4UsA0fb33Rlx+wYEE2W4gO9tk8t57ojXSqbFDtCep
         bzF1wJpICD+qp2/zJFUiaqJA853hXZH9NSF1ReajEwJ5FIjG9KIMPjmVAfvAFqFlsf
         EcO3Yb8NnceL1Ixg6EtMGnmSQ5OVjLwfCOR0/kej/E4bIVKT3lK4E+SQLpPo/3zuMB
         0RUrmZ+e/iX51MLbQb72aeDCzuVO1ibHyJk6bFnUzq1uY3z9QskRGQ/OqNXsRcvq1W
         qnCjom8mFWU2g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Manish Chopra <manishc@marvell.com>,
        Sudarsana Kalluru <skalluru@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 16/51] qede: fix offload for IPIP tunnel packets
Date:   Tue, 12 Jan 2021 07:54:58 -0500
Message-Id: <20210112125534.70280-16-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210112125534.70280-1-sashal@kernel.org>
References: <20210112125534.70280-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Manish Chopra <manishc@marvell.com>

[ Upstream commit 5d5647dad259bb416fd5d3d87012760386d97530 ]

IPIP tunnels packets are unknown to device,
hence these packets are incorrectly parsed and
caused the packet corruption, so disable offlods
for such packets at run time.

Signed-off-by: Manish Chopra <manishc@marvell.com>
Signed-off-by: Sudarsana Kalluru <skalluru@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Link: https://lore.kernel.org/r/20201221145530.7771-1-manishc@marvell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qede/qede_fp.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/qlogic/qede/qede_fp.c b/drivers/net/ethernet/qlogic/qede/qede_fp.c
index a2494bf850079..ca0ee29a57b50 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_fp.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_fp.c
@@ -1799,6 +1799,11 @@ netdev_features_t qede_features_check(struct sk_buff *skb,
 			      ntohs(udp_hdr(skb)->dest) != gnv_port))
 				return features & ~(NETIF_F_CSUM_MASK |
 						    NETIF_F_GSO_MASK);
+		} else if (l4_proto == IPPROTO_IPIP) {
+			/* IPIP tunnels are unknown to the device or at least unsupported natively,
+			 * offloads for them can't be done trivially, so disable them for such skb.
+			 */
+			return features & ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
 		}
 	}
 
-- 
2.27.0

