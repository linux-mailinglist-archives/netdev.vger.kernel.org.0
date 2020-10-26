Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B9B329A1B5
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 01:48:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409156AbgJ0Anh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 20:43:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:50946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409225AbgJZXuy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 19:50:54 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EEBB521BE5;
        Mon, 26 Oct 2020 23:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603756253;
        bh=wgzB2Ulr1JbVEa9ka5s6DW9woEKo9kQUPUo2F6wsdus=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jnCOPluW4VJP40FPhUpxH+k6FYWo4Hvjdb3Jj9rCHnLhLwHwOJ86CfprpwRU08+0d
         75WoAa667jUoZLGXnG9DQu8FPuTEzED0Xo1kRn0dBilGp+c2sJmmpgbIitxuIWqAQu
         J282gZL3WrdFxQGmfM9P1moNPzyP01kIluN1Agx4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stanislaw Kardach <skardach@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.9 088/147] octeontx2-af: fix LD CUSTOM LTYPE aliasing
Date:   Mon, 26 Oct 2020 19:48:06 -0400
Message-Id: <20201026234905.1022767-88-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201026234905.1022767-1-sashal@kernel.org>
References: <20201026234905.1022767-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stanislaw Kardach <skardach@marvell.com>

[ Upstream commit 450f0b978870c384dd81d1176088536555f3170e ]

Since LD contains LTYPE definitions tweaked toward efficient
NIX_AF_RX_FLOW_KEY_ALG(0..31)_FIELD(0..4) usage, the original location
of NPC_LT_LD_CUSTOM0/1 was aliased with MPLS_IN_* definitions.
Moving custom frame to value 6 and 7 removes the aliasing at the cost of
custom frames being also considered when TCP/UDP RSS algo is configured.

However since the goal of CUSTOM frames is to classify them to a
separate set of RQs, this cost is acceptable.

Signed-off-by: Stanislaw Kardach <skardach@marvell.com>
Acked-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/npc.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/npc.h b/drivers/net/ethernet/marvell/octeontx2/af/npc.h
index 3803af9231c68..c0ff5f70aa431 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/npc.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/npc.h
@@ -77,6 +77,8 @@ enum npc_kpu_ld_ltype {
 	NPC_LT_LD_ICMP,
 	NPC_LT_LD_SCTP,
 	NPC_LT_LD_ICMP6,
+	NPC_LT_LD_CUSTOM0,
+	NPC_LT_LD_CUSTOM1,
 	NPC_LT_LD_IGMP = 8,
 	NPC_LT_LD_ESP,
 	NPC_LT_LD_AH,
@@ -85,8 +87,6 @@ enum npc_kpu_ld_ltype {
 	NPC_LT_LD_NSH,
 	NPC_LT_LD_TU_MPLS_IN_NSH,
 	NPC_LT_LD_TU_MPLS_IN_IP,
-	NPC_LT_LD_CUSTOM0 = 0xE,
-	NPC_LT_LD_CUSTOM1 = 0xF,
 };
 
 enum npc_kpu_le_ltype {
-- 
2.25.1

