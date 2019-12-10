Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FF66119BEA
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 23:12:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729757AbfLJWMM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 17:12:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:33940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727972AbfLJWDk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 17:03:40 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1AE3C2053B;
        Tue, 10 Dec 2019 22:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576015419;
        bh=ix5mK7oJThaUdmYNmkZ6hF2IOt9z02uqSQrAY595ey8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AlK81up+SUeuzZwF2qDJe+94szCsZO+mx/bLAod1YfPmXiNPYUTTa3w+I9nmsRmFm
         GSChT4vP0ok9kJVdxhYvkUm52w6uPEsBEXynJByT+kLp+Pxm8z5uqus4lNALCANihc
         hC+yd6ayGUfjtbSUhPoePZ7yhso+SFsxn9bzEjlE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Navid Emamdoost <navid.emamdoost@gmail.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 032/130] mwifiex: pcie: Fix memory leak in mwifiex_pcie_init_evt_ring
Date:   Tue, 10 Dec 2019 17:01:23 -0500
Message-Id: <20191210220301.13262-32-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210220301.13262-1-sashal@kernel.org>
References: <20191210220301.13262-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>

[ Upstream commit d10dcb615c8e29d403a24d35f8310a7a53e3050c ]

In mwifiex_pcie_init_evt_ring, a new skb is allocated which should be
released if mwifiex_map_pci_memory() fails. The release for skb and
card->evtbd_ring_vbase is added.

Fixes: 0732484b47b5 ("mwifiex: separate ring initialization and ring creation routines")
Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Acked-by: Ganapathi Bhat <gbhat@marvell.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/mwifiex/pcie.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index 9511f5fe62f43..9d0d790a13197 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -677,8 +677,11 @@ static int mwifiex_pcie_init_evt_ring(struct mwifiex_adapter *adapter)
 		skb_put(skb, MAX_EVENT_SIZE);
 
 		if (mwifiex_map_pci_memory(adapter, skb, MAX_EVENT_SIZE,
-					   PCI_DMA_FROMDEVICE))
+					   PCI_DMA_FROMDEVICE)) {
+			kfree_skb(skb);
+			kfree(card->evtbd_ring_vbase);
 			return -1;
+		}
 
 		buf_pa = MWIFIEX_SKB_DMA_ADDR(skb);
 
-- 
2.20.1

