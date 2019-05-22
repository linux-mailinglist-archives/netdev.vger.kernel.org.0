Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97A3926C2B
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 21:34:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387648AbfEVTbu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 15:31:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:55444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732822AbfEVTbt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 May 2019 15:31:49 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C32D820879;
        Wed, 22 May 2019 19:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558553508;
        bh=78wZS+899SrgVN7cXDBK/8FQ7m3iln6bT4/x6tNGrFg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=svtt60PmXa0T6CuMokGKegTdjJmoV1xWATL9lQgBlE/Jeh05GcJZbJPOA2nnsB/uG
         +Q/W+SXvjR5zo9NEmVzayE6MmMKbJReZzhA3y+40BaYs93cM3VK7NRvw/MCWl25Z5O
         vdsM/6/REmm8VdhuGziiNhNJMWz4y4bVC9d2Lyp8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 14/92] mwifiex: prevent an array overflow
Date:   Wed, 22 May 2019 15:30:09 -0400
Message-Id: <20190522193127.27079-14-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190522193127.27079-1-sashal@kernel.org>
References: <20190522193127.27079-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit b4c35c17227fe437ded17ce683a6927845f8c4a4 ]

The "rate_index" is only used as an index into the phist_data->rx_rate[]
array in the mwifiex_hist_data_set() function.  That array has
MWIFIEX_MAX_AC_RX_RATES (74) elements and it's used to generate some
debugfs information.  The "rate_index" variable comes from the network
skb->data[] and it is a u8 so it's in the 0-255 range.  We need to cap
it to prevent an array overflow.

Fixes: cbf6e05527a7 ("mwifiex: add rx histogram statistics support")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mwifiex/cfp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/mwifiex/cfp.c b/drivers/net/wireless/mwifiex/cfp.c
index 3ddb8ec676ed3..6dd331dfb5179 100644
--- a/drivers/net/wireless/mwifiex/cfp.c
+++ b/drivers/net/wireless/mwifiex/cfp.c
@@ -533,5 +533,8 @@ u8 mwifiex_adjust_data_rate(struct mwifiex_private *priv,
 		rate_index = (rx_rate > MWIFIEX_RATE_INDEX_OFDM0) ?
 			      rx_rate - 1 : rx_rate;
 
+	if (rate_index >= MWIFIEX_MAX_AC_RX_RATES)
+		rate_index = MWIFIEX_MAX_AC_RX_RATES - 1;
+
 	return rate_index;
 }
-- 
2.20.1

