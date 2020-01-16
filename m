Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26DB013F0FC
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 19:25:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729235AbgAPR0x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 12:26:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:36024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392321AbgAPR0v (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:26:51 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E7360246BE;
        Thu, 16 Jan 2020 17:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579195610;
        bh=ANUvViKeXBvEPwexAXTC3sSiZj/WPinEAqQ8t19PqOc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KrVTv2TxoJtxyjgeDn1kd170hWr2gRZ4Tfr9PQ0eixlS9f/1n+Ms241jtZGx2ww8X
         MwFNEUBRE9graXx7WRIr1AhBnLRpYExSCvWk7lIkYCobu/ragDjxY4SgvqUULiHJYT
         aQAADU4RmLCkiJZsQ+CaM1jvmKPyruLJ4jN8abLU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sameeh Jubran <sameehj@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 184/371] net: ena: fix incorrect test of supported hash function
Date:   Thu, 16 Jan 2020 12:20:56 -0500
Message-Id: <20200116172403.18149-127-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116172403.18149-1-sashal@kernel.org>
References: <20200116172403.18149-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sameeh Jubran <sameehj@amazon.com>

[ Upstream commit d3cfe7ddbc3dfbb9b201615b7fef8fd66d1b5fe8 ]

ena_com_set_hash_function() tests if a hash function is supported
by the device before setting it.
The test returns the opposite result than needed.
Reverse the condition to return the correct value.
Also use the BIT macro instead of inline shift.

Fixes: 1738cd3ed342 ("net: ena: Add a driver for Amazon Elastic Network Adapters (ENA)")
Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amazon/ena/ena_com.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_com.c b/drivers/net/ethernet/amazon/ena/ena_com.c
index 1a4ffc5d3da4..011b54c541aa 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_com.c
@@ -2002,7 +2002,7 @@ int ena_com_set_hash_function(struct ena_com_dev *ena_dev)
 	if (unlikely(ret))
 		return ret;
 
-	if (get_resp.u.flow_hash_func.supported_func & (1 << rss->hash_func)) {
+	if (!(get_resp.u.flow_hash_func.supported_func & BIT(rss->hash_func))) {
 		pr_err("Func hash %d isn't supported by device, abort\n",
 		       rss->hash_func);
 		return -EOPNOTSUPP;
-- 
2.20.1

