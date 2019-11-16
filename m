Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 275F6FF3CA
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 17:28:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728676AbfKPQ2D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 11:28:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:44520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727874AbfKPPl1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Nov 2019 10:41:27 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D7D2620718;
        Sat, 16 Nov 2019 15:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573918887;
        bh=Sf3cIY4FBXZRehIUMul+h13jBBMHJUAoQ3mb0dOaB0A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NSyNnHI7c1YpURCvhCSGXLv2VCk60uRyLkazMhMiNvRngL70JiKdkxdh3RFsGa/5D
         zioY/8bWIj2vW651hSaaWB+k/0yVLcI78ZC/G4P56obDoKitqEpVV137dr1Zq53cB2
         YC792hLX5rSbfiqgSXkxjyBpJ8wr/4QRz2Tnfo38=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 016/237] mt76: do not store aggregation sequence number for null-data frames
Date:   Sat, 16 Nov 2019 10:37:31 -0500
Message-Id: <20191116154113.7417-16-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 5155938d8a0fe0e0251435cae02539e81fb8e407 ]

Fixes a rare corner case where a BlockAckReq might get the wrong
sequence number.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/tx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wireless/mediatek/mt76/tx.c
index 20447fdce4c33..227e5ebfe3dc2 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -148,7 +148,8 @@ mt76_check_agg_ssn(struct mt76_txq *mtxq, struct sk_buff *skb)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 
-	if (!ieee80211_is_data_qos(hdr->frame_control))
+	if (!ieee80211_is_data_qos(hdr->frame_control) ||
+	    !ieee80211_is_data_present(hdr->frame_control))
 		return;
 
 	mtxq->agg_ssn = le16_to_cpu(hdr->seq_ctrl) + 0x10;
-- 
2.20.1

