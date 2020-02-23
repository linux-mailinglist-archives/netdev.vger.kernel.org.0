Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9D45169412
	for <lists+netdev@lfdr.de>; Sun, 23 Feb 2020 03:28:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729145AbgBWC1x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Feb 2020 21:27:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:54474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728068AbgBWCY3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 22 Feb 2020 21:24:29 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7801620707;
        Sun, 23 Feb 2020 02:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582424669;
        bh=/l4ZPkeE0i6ZByZlmN83M820iYF0kgTGc+JH5BDsacg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I5O1AVnw2iy2/HTgudEtWTM1uF5GBDHkOttPuba6tLnA66gd550YH39xRu2kwI5Dc
         3R9Odo2IE5S1V4lrDM77R7eNq51quXdRvwEp3rOCVaj+KLQDpyrSwoVbexBUu+IwlJ
         B5xeiSRDEPV0P+os6zY+Rp+5a31Uq4mxi6gL10gs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arthur Kiyanovski <akiyano@amazon.com>,
        Sameeh Jubran <sameehj@amazon.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 14/21] net: ena: rss: store hash function as values and not bits
Date:   Sat, 22 Feb 2020 21:24:04 -0500
Message-Id: <20200223022411.2159-14-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200223022411.2159-1-sashal@kernel.org>
References: <20200223022411.2159-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arthur Kiyanovski <akiyano@amazon.com>

[ Upstream commit 4844470d472d660c26149ad764da2406adb13423 ]

The device receives, stores and retrieves the hash function value as bits
and not as their enum value.

The bug:
* In ena_com_set_hash_function() we set
  cmd.u.flow_hash_func.selected_func to the bit value of rss->hash_func.
 (1 << rss->hash_func)
* In ena_com_get_hash_function() we retrieve the hash function and store
  it's bit value in rss->hash_func. (Now the bit value of rss->hash_func
  is stored in rss->hash_func instead of it's enum value)

The fix:
This commit fixes the issue by converting the retrieved hash function
values from the device to the matching enum value of the set bit using
ffs(). ffs() finds the first set bit's index in a word. Since the function
returns 1 for the LSB's index, we need to subtract 1 from the returned
value (note that BIT(0) is 1).

Fixes: 1738cd3ed342 ("net: ena: Add a driver for Amazon Elastic Network Adapters (ENA)")
Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amazon/ena/ena_com.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_com.c b/drivers/net/ethernet/amazon/ena/ena_com.c
index c5df80f31005f..552db5399503f 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_com.c
@@ -2128,7 +2128,11 @@ int ena_com_get_hash_function(struct ena_com_dev *ena_dev,
 	if (unlikely(rc))
 		return rc;
 
-	rss->hash_func = get_resp.u.flow_hash_func.selected_func;
+	/* ffs() returns 1 in case the lsb is set */
+	rss->hash_func = ffs(get_resp.u.flow_hash_func.selected_func);
+	if (rss->hash_func)
+		rss->hash_func--;
+
 	if (func)
 		*func = rss->hash_func;
 
-- 
2.20.1

