Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9FCD13EE52
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 19:09:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405097AbgAPRiv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 12:38:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:54740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393374AbgAPRiq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:38:46 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 024D7246B1;
        Thu, 16 Jan 2020 17:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579196325;
        bh=+JvpNlVQp+syDwo0lHqeS6oTSkgWZhGvMmmUQwVPhkY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x6VK6QLPPlsG+wp2Zi8UMYv994CQXbP5yyOwxZv8nwI8KFMfmvHM4PI/dMhDMAZzv
         X3QaJvQFvJwhrhwvgroTJrqctKD6X2+gIpPxpvLGafAcNB8eYk5szdx+HOirD6IxIM
         3CAUCebuoDcPaaSan8Xdfe8yOwkj8D24K271WYCA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sameeh Jubran <sameehj@amazon.com>,
        Saeed Bshara <saeedb@amazon.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 128/251] net: ena: fix swapped parameters when calling ena_com_indirect_table_fill_entry
Date:   Thu, 16 Jan 2020 12:34:37 -0500
Message-Id: <20200116173641.22137-88-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116173641.22137-1-sashal@kernel.org>
References: <20200116173641.22137-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sameeh Jubran <sameehj@amazon.com>

[ Upstream commit 3c6eeff295f01bdf1c6c3addcb0a04c0c6c029e9 ]

second parameter should be the index of the table rather than the value.

Fixes: 1738cd3ed342 ("net: ena: Add a driver for Amazon Elastic Network Adapters (ENA)")
Signed-off-by: Saeed Bshara <saeedb@amazon.com>
Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amazon/ena/ena_ethtool.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_ethtool.c b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
index 67b2338f8fb3..06fd061a20e9 100644
--- a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
+++ b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
@@ -697,8 +697,8 @@ static int ena_set_rxfh(struct net_device *netdev, const u32 *indir,
 	if (indir) {
 		for (i = 0; i < ENA_RX_RSS_TABLE_SIZE; i++) {
 			rc = ena_com_indirect_table_fill_entry(ena_dev,
-							       ENA_IO_RXQ_IDX(indir[i]),
-							       i);
+							       i,
+							       ENA_IO_RXQ_IDX(indir[i]));
 			if (unlikely(rc)) {
 				netif_err(adapter, drv, netdev,
 					  "Cannot fill indirect table (index is too large)\n");
-- 
2.20.1

