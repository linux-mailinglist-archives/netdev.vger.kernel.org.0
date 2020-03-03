Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA3B1176D3B
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 04:02:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728063AbgCCDCF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 22:02:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:41470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727541AbgCCCqu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Mar 2020 21:46:50 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC03324681;
        Tue,  3 Mar 2020 02:46:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583203609;
        bh=nMjXQRsDoPXsYJxcEv3BktPQj7y3te40Mt7oG+KN+44=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nmstpG77Vy2P/Gz0qOahE1lMeRnzv0vvI9NdZRtobM81G1KnKpeaHIH9dnZTsbDAb
         RjZTcDTWLyjSjFdqRzWiRhl6nG1et30xUmvpAEaew2WKD5UszkrgA6SdRHR5UScgPG
         rhct9k80GJJI6cgcjLrDAV3F1JMRORNjhqo98pd4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavel Belous <pbelous@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        Dmitry Bogdanov <dbogdanov@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 27/66] net: atlantic: fix potential error handling
Date:   Mon,  2 Mar 2020 21:45:36 -0500
Message-Id: <20200303024615.8889-27-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200303024615.8889-1-sashal@kernel.org>
References: <20200303024615.8889-1-sashal@kernel.org>
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
index 263beea1859c1..e95f6a6bef733 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -533,8 +533,10 @@ unsigned int aq_nic_map_skb(struct aq_nic_s *self, struct sk_buff *skb,
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

