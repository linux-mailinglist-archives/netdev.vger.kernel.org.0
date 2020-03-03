Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F5DA176C2B
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 03:55:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728962AbgCCCyz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 21:54:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:45366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728698AbgCCCtM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Mar 2020 21:49:12 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D0143246D8;
        Tue,  3 Mar 2020 02:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583203751;
        bh=rjHWYPobdRHbKGN4H7K4flnCN8qtJdwaq+q8i9ErNKM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dDYl9WApHvVzGQ6YMKqL1YwxJ0wDpzvmeNTZqU/NoyLKxXoOnq4DZ/qZp9Xgqaim/
         CNb+M7d4DCzC0EdG/yysrSKNHcnn+beHE6QRRbuhgHK0/ngX7S7brX81Bo0888uCBe
         EQXoyJa/m7U+63tZwnvWjuQ00dDzQojE+ynBA2K4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavel Belous <pbelous@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        Dmitry Bogdanov <dbogdanov@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 15/32] net: atlantic: fix potential error handling
Date:   Mon,  2 Mar 2020 21:48:34 -0500
Message-Id: <20200303024851.10054-15-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200303024851.10054-1-sashal@kernel.org>
References: <20200303024851.10054-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pavel Belous <pbelous@marvell.com>

[ Upstream commit 380ec5b9af7f0d57dbf6ac067fd9f33cff2fef71 ]

Code inspection found that in case of mapping error we do return current
'ret' value. But beside error, it is used to count number of descriptors
allocated for the packet. In that case map_skb function could return '1'.

Changing it to return zero (number of mapped descriptors for skb)

Fixes: 018423e90bee ("net: ethernet: aquantia: Add ring support code")
Signed-off-by: Pavel Belous <pbelous@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Dmitry Bogdanov <dbogdanov@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
index d1de11b575f44..15dcfb6704e5b 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -399,8 +399,10 @@ static unsigned int aq_nic_map_skb(struct aq_nic_s *self,
 				     dx_buff->len,
 				     DMA_TO_DEVICE);
 
-	if (unlikely(dma_mapping_error(aq_nic_get_dev(self), dx_buff->pa)))
+	if (unlikely(dma_mapping_error(aq_nic_get_dev(self), dx_buff->pa))) {
+		ret = 0;
 		goto exit;
+	}
 
 	first = dx_buff;
 	dx_buff->len_pkt = skb->len;
-- 
2.20.1

