Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48F2D13F6C4
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 20:07:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387517AbgAPRB0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 12:01:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:52370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388078AbgAPRBW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:01:22 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35AE520730;
        Thu, 16 Jan 2020 17:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194082;
        bh=hyqnidKUhr5IO7828ua1HHV6ukySUvw9Gad4wTAK1DE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zggOnGeCZI/EA26jG4oEv6sh3FOEnUmDJdbScRBHtN81CbU0F7jAhANQARL5d0hSU
         +ZJC6X6/o00Eu/RuspxeEGruweQl0VKLA+mkCA1DzmI27VpDhNI28YFv7XCBsyH/vp
         6C1oqoQU9pH/YW2cVmemwzQ6BGPk7wNsKLKCFJa0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 187/671] mt76: usb: fix possible memory leak in mt76u_buf_free
Date:   Thu, 16 Jan 2020 11:51:36 -0500
Message-Id: <20200116165940.10720-70-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165940.10720-1-sashal@kernel.org>
References: <20200116165940.10720-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>

[ Upstream commit cb83585e1121bd6d6c039cf09fa32380bf8b6258 ]

Move q->ndesc initialization before the for loop in mt76u_alloc_rx
since otherwise allocated urbs will not be freed in mt76u_buf_free
Double-check scatterlist pointer in mt76u_buf_free

Fixes: b40b15e1521f ("mt76: add usb support to mt76 layer")
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/usb.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index 8d40e92fb6f2..dcf927de65f3 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -273,10 +273,16 @@ EXPORT_SYMBOL_GPL(mt76u_buf_alloc);
 void mt76u_buf_free(struct mt76u_buf *buf)
 {
 	struct urb *urb = buf->urb;
+	struct scatterlist *sg;
 	int i;
 
-	for (i = 0; i < urb->num_sgs; i++)
-		skb_free_frag(sg_virt(&urb->sg[i]));
+	for (i = 0; i < urb->num_sgs; i++) {
+		sg = &urb->sg[i];
+		if (!sg)
+			continue;
+
+		skb_free_frag(sg_virt(sg));
+	}
 	usb_free_urb(buf->urb);
 }
 EXPORT_SYMBOL_GPL(mt76u_buf_free);
@@ -478,7 +484,8 @@ static int mt76u_alloc_rx(struct mt76_dev *dev)
 		nsgs = 1;
 	}
 
-	for (i = 0; i < MT_NUM_RX_ENTRIES; i++) {
+	q->ndesc = MT_NUM_RX_ENTRIES;
+	for (i = 0; i < q->ndesc; i++) {
 		err = mt76u_buf_alloc(dev, &q->entry[i].ubuf,
 				      nsgs, q->buf_size,
 				      SKB_WITH_OVERHEAD(q->buf_size),
@@ -486,7 +493,6 @@ static int mt76u_alloc_rx(struct mt76_dev *dev)
 		if (err < 0)
 			return err;
 	}
-	q->ndesc = MT_NUM_RX_ENTRIES;
 
 	return mt76u_submit_rx_buffers(dev);
 }
-- 
2.20.1

