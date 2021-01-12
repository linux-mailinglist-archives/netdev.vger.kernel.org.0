Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49C112F303C
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 14:05:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729081AbhALNFP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 08:05:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:54618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405274AbhALM6a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 07:58:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7B5A2333C;
        Tue, 12 Jan 2021 12:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610456278;
        bh=b9CxemwqiwqVvtJNPkPioR7wLvJqmQWZpXNqScf5hdw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ahYg3ypV1/x8NKcvMLg8QFa+vncV7VG4wn1klaPOXbes9AhkYdVUWUfjcKID5Soax
         k3bW7DbJQr3jtkdmRV0U9zK6J7FcLnUEZAIk76acI6hRppTd2g2DecXe4b6CRtI/u3
         KyLb5jRbZm+QaJpbmsSbr0lnZgicHlbTifZjBBWWzNRJOJ0yNV2AVdHfcGClqXEAbF
         1cyXSpOxsmHMSFm84XMogdIPvx8WONstw6K0l1YRCLTTnhdmTPQ2TjNUVxmUJBfp02
         P8phVq3hM/8dwixyCWWKZLAyhHcgLgPm0/wJmXzUGP9fql92CP895pnOSOTamcq/z5
         RA7ZgwpSPz8HA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Manish Chopra <manishc@marvell.com>,
        Sudarsana Kalluru <skalluru@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 06/13] qede: fix offload for IPIP tunnel packets
Date:   Tue, 12 Jan 2021 07:57:42 -0500
Message-Id: <20210112125749.71193-6-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210112125749.71193-1-sashal@kernel.org>
References: <20210112125749.71193-1-sashal@kernel.org>
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
index d50cc26354776..27c0300e72293 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_fp.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_fp.c
@@ -1708,6 +1708,11 @@ netdev_features_t qede_features_check(struct sk_buff *skb,
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

