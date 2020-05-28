Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5621F1E5F9A
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 14:05:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389536AbgE1MDB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 08:03:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:50076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389039AbgE1L5d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 07:57:33 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B89F921475;
        Thu, 28 May 2020 11:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590667053;
        bh=CKtD8J02zi1GXn5FojkAwD2VlMui6Y5z2va8/XDci2k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pJxPieVFvFI9JerKK3Nde0ZB1+3HLmc6ZdfTmn7xz53DL5WgEP0RGwm3TIr38ARk4
         lFO1IMnqvz1WyV4Lbg6cbIxk86fLCp1ZmALg7kwwUWTUS/qzJkjkXUEKEyG4rC5MUi
         9zpKR0vGfsd+WrjhGU1zyLcxin+BezXvxEServTo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jeremy Kerr <jk@ozlabs.org>, Stan Johnson <userm57@yahoo.com>,
        Finn Thain <fthain@telegraphics.com.au>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 07/17] net: bmac: Fix read of MAC address from ROM
Date:   Thu, 28 May 2020 07:57:14 -0400
Message-Id: <20200528115724.1406376-7-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200528115724.1406376-1-sashal@kernel.org>
References: <20200528115724.1406376-1-sashal@kernel.org>
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
index 6a8e2567f2bd..ab6ce85540b8 100644
--- a/drivers/net/ethernet/apple/bmac.c
+++ b/drivers/net/ethernet/apple/bmac.c
@@ -1181,7 +1181,7 @@ bmac_get_station_address(struct net_device *dev, unsigned char *ea)
 	int i;
 	unsigned short data;
 
-	for (i = 0; i < 6; i++)
+	for (i = 0; i < 3; i++)
 		{
 			reset_and_select_srom(dev);
 			data = read_srom(dev, i + EnetAddressOffset/2, SROMAddressBits);
-- 
2.25.1

