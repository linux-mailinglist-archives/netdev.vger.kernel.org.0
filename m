Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D0582F3096
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 14:15:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729647AbhALNHp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 08:07:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:53814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388926AbhALM6S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 07:58:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 601862389B;
        Tue, 12 Jan 2021 12:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610456254;
        bh=a3pS4Nr4useFWLBhV8kloHfU5I/TJvA1p7WWtVSEuAY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KKigiKmBDroqYfEbVF1VysGCtqGlIFNujtWhOUWWUlpyO84Yc/lq9BRfj4b1yEqqm
         Z16RETleg62prs90OKtgM7YlUo1sCthWPRSAoDdKvjyrtHfsIy7spYH0hYLUQ3mVb4
         TQAy/upQPqXmSiSmA9KKNgQhNLcmX+6HDlFKBHHp4hXjlU8oqZCqE3/adkyJYSPxWz
         2GWvMPRye61AZD60jMBIb4MdbXhCayRsHb6crAMeNoSjsFIAaFScKxEuBY67tZbSPZ
         04Btf7gyLZJgiZ4mDhKDqrEomqUpxo7ZsZJI6kDDPVro8IGD1Jb+LdmasT8bapw8xF
         vDvz8ZI4DFlDg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Manish Chopra <manishc@marvell.com>,
        Sudarsana Kalluru <skalluru@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 06/16] qede: fix offload for IPIP tunnel packets
Date:   Tue, 12 Jan 2021 07:57:15 -0500
Message-Id: <20210112125725.71014-6-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210112125725.71014-1-sashal@kernel.org>
References: <20210112125725.71014-1-sashal@kernel.org>
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
index a96da16f34049..1976279800cd8 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_fp.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_fp.c
@@ -1747,6 +1747,11 @@ netdev_features_t qede_features_check(struct sk_buff *skb,
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

