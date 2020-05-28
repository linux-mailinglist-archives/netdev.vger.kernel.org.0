Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9975C1E5F4C
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 14:02:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389403AbgE1MAd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 08:00:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:50946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389175AbgE1L6G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 07:58:06 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 175CE217A0;
        Thu, 28 May 2020 11:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590667085;
        bh=0l8c9k+8yFocyzIgv8IfzIQTVYUyVs5GizGv3/sGW/A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ozev9O3+B+Mq/X8hBDf8XN5Okan1Ncw8DbIdot8zU1BoPQLByoO7GOgI6Ba0eVT5n
         o2Co58zYhrUvQg7SnMEJmajmY4kuaNP2Qbjd861XEBX+U+7Wbj57wcfnK/cBAj8ZKR
         RSczoP1y3HyGZKvzGu3xY8FeeydP5gX5VVxh29vk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jeremy Kerr <jk@ozlabs.org>, Stan Johnson <userm57@yahoo.com>,
        Finn Thain <fthain@telegraphics.com.au>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 4/9] net: bmac: Fix read of MAC address from ROM
Date:   Thu, 28 May 2020 07:57:55 -0400
Message-Id: <20200528115800.1406703-4-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200528115800.1406703-1-sashal@kernel.org>
References: <20200528115800.1406703-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeremy Kerr <jk@ozlabs.org>

[ Upstream commit ef01cee2ee1b369c57a936166483d40942bcc3e3 ]

In bmac_get_station_address, We're reading two bytes at a time from ROM,
but we do that six times, resulting in 12 bytes of read & writes. This
means we will write off the end of the six-byte destination buffer.

This change fixes the for-loop to only read/write six bytes.

Based on a proposed fix from Finn Thain <fthain@telegraphics.com.au>.

Signed-off-by: Jeremy Kerr <jk@ozlabs.org>
Reported-by: Stan Johnson <userm57@yahoo.com>
Tested-by: Stan Johnson <userm57@yahoo.com>
Reported-by: Finn Thain <fthain@telegraphics.com.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/apple/bmac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/apple/bmac.c b/drivers/net/ethernet/apple/bmac.c
index a65d7a60f116..ffa7e7e6d18d 100644
--- a/drivers/net/ethernet/apple/bmac.c
+++ b/drivers/net/ethernet/apple/bmac.c
@@ -1187,7 +1187,7 @@ bmac_get_station_address(struct net_device *dev, unsigned char *ea)
 	int i;
 	unsigned short data;
 
-	for (i = 0; i < 6; i++)
+	for (i = 0; i < 3; i++)
 		{
 			reset_and_select_srom(dev);
 			data = read_srom(dev, i + EnetAddressOffset/2, SROMAddressBits);
-- 
2.25.1

