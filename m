Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B45213EB34
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 18:49:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406700AbgAPRqb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 12:46:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:39298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406678AbgAPRq3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:46:29 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 41340246EA;
        Thu, 16 Jan 2020 17:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579196788;
        bh=Vl0mUl3nyA3+imvByviOLU+uQpGETegssy81vreRVno=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uOuj/myyekutclpFsBSSmvIfJ7KoYiWS5RXXje10aObPDmj5jA8Rlj/upN5sOhqk9
         PJWn3g8Os2RErZWxc8lwKikXJng1cPNdu0ZAyGgd/YxYw72N0veLYjW4CI63vV92+v
         KvN2WNtY/4VTPtspLAV6jDumkkARqDGR03sSmRKE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>,
        Jakub Kicinski <kubakici@wp.pl>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 4.4 151/174] mt7601u: fix bbp version check in mt7601u_wait_bbp_ready
Date:   Thu, 16 Jan 2020 12:42:28 -0500
Message-Id: <20200116174251.24326-151-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116174251.24326-1-sashal@kernel.org>
References: <20200116174251.24326-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 15e14f76f85f4f0eab3b8146e1cd3c58ce272823 ]

Fix bbp ready check in mt7601u_wait_bbp_ready. The issue is reported by
coverity with the following error:

Logical vs. bitwise operator
The expression's value does not depend on the operands; inadvertent use
of the wrong operator is a likely logic error.

Addresses-Coverity-ID: 1309441 ("Logical vs. bitwise operator")
Fixes: c869f77d6abb ("add mt7601u driver")
Acked-by: Jakub Kicinski <kubakici@wp.pl>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt7601u/phy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt7601u/phy.c b/drivers/net/wireless/mediatek/mt7601u/phy.c
index 1908af6add87..59ed073a8572 100644
--- a/drivers/net/wireless/mediatek/mt7601u/phy.c
+++ b/drivers/net/wireless/mediatek/mt7601u/phy.c
@@ -219,7 +219,7 @@ int mt7601u_wait_bbp_ready(struct mt7601u_dev *dev)
 
 	do {
 		val = mt7601u_bbp_rr(dev, MT_BBP_REG_VERSION);
-		if (val && ~val)
+		if (val && val != 0xff)
 			break;
 	} while (--i);
 
-- 
2.20.1

