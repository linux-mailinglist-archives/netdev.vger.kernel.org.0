Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 966F2433096
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 10:05:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234832AbhJSIGz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 04:06:55 -0400
Received: from sender11-op-o11.zoho.eu ([31.186.226.225]:17209 "EHLO
        sender11-op-o11.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234519AbhJSIGw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 04:06:52 -0400
X-Greylist: delayed 905 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Oct 2021 04:06:51 EDT
ARC-Seal: i=1; a=rsa-sha256; t=1634629763; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=jMqkoii54nOAzrz8G3qNQ0rzHwkWEM9fbAfoLyPXNc2n50cUFIau8xAX/IL5eISB79fggXqnk9THLxVYaPYb6oLqY2e/yw3mbpeSIt2Pnjh5wfliMq1Fq5Czz+Hd8qgsH+2kZoG42v0bdr4YRWq6iyHIVS+jMmqfKjLBbGw+HxE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1634629763; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=Czx564W05Y+/SEPEv1luL1kRJ3nXcj6vqmTZ2XRacTg=; 
        b=CdbdYKa0w+bTpj/acXCzeXnSWZmKpSGw/wyRqkrABJNXZ7yf8yc/pSXbM/AHjzUJSBjLh2yPgefPFTcwL709LnGHZknqinhbNkA1a7Z5180exAMpBGLB+/PlNFdVax8Z6iQduwkc5hG3quFzlSXBHIxvxuthYBDw6BIiwClBkHo=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.4.48] (85.184.170.180 [85.184.170.180]) by mx.zoho.eu
        with SMTPS id 1634629762840830.7659684704782; Tue, 19 Oct 2021 09:49:22 +0200 (CEST)
Date:   Tue, 19 Oct 2021 09:49:20 +0200
From:   jes@trained-monkey.org
To:     davem@davemloft.net, Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Message-ID: <038b450c-e27a-4f61-897b-50a92f29abc7.maildroid@localhost>
In-Reply-To: <20211015221652.827253-4-kuba@kernel.org>
References: <20211015221652.827253-1-kuba@kernel.org>
 <20211015221652.827253-4-kuba@kernel.org>
Subject: Re: [PATCH net-next 03/12] ethernet: alteon: use eth_hw_addr_set()
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Mailer: MailDroid/5.11 (Android 11)
User-Agent: MailDroid/5.11 (Android 11)
X-ZohoMailClient: External
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Acked-By: Jes Sorensen <jes@trained-monkey.org>

Sorry for top posting, mobile email clients suck.

Jes

Sent from MailDroid

-----Original Message-----
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>, jes@trained-monkey.org, linux-acenic@sunsite.dk
Sent: Sat, 16 Oct 2021 0:17
Subject: [PATCH net-next 03/12] ethernet: alteon: use eth_hw_addr_set()

Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
of VLANs...") introduced a rbtree for faster Ethernet address look
up. To maintain netdev->dev_addr in this tree we need to make all
the writes to it got through appropriate helpers.

Break the address apart into an array on the stack, then call
eth_hw_addr_set().

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: jes@trained-monkey.org
CC: linux-acenic@sunsite.dk
---
 drivers/net/ethernet/alteon/acenic.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/alteon/acenic.c b/drivers/net/ethernet/alteon/acenic.c
index eeb86bd851f9..732da15a3827 100644
--- a/drivers/net/ethernet/alteon/acenic.c
+++ b/drivers/net/ethernet/alteon/acenic.c
@@ -869,6 +869,7 @@ static int ace_init(struct net_device *dev)
 	int board_idx, ecode = 0;
 	short i;
 	unsigned char cache_size;
+	u8 addr[ETH_ALEN];
 
 	ap = netdev_priv(dev);
 	regs = ap->regs;
@@ -988,12 +989,13 @@ static int ace_init(struct net_device *dev)
 	writel(mac1, &regs->MacAddrHi);
 	writel(mac2, &regs->MacAddrLo);
 
-	dev->dev_addr[0] = (mac1 >> 8) & 0xff;
-	dev->dev_addr[1] = mac1 & 0xff;
-	dev->dev_addr[2] = (mac2 >> 24) & 0xff;
-	dev->dev_addr[3] = (mac2 >> 16) & 0xff;
-	dev->dev_addr[4] = (mac2 >> 8) & 0xff;
-	dev->dev_addr[5] = mac2 & 0xff;
+	addr[0] = (mac1 >> 8) & 0xff;
+	addr[1] = mac1 & 0xff;
+	addr[2] = (mac2 >> 24) & 0xff;
+	addr[3] = (mac2 >> 16) & 0xff;
+	addr[4] = (mac2 >> 8) & 0xff;
+	addr[5] = mac2 & 0xff;
+	eth_hw_addr_set(dev, addr);
 
 	printk("MAC: %pM\n", dev->dev_addr);
 
-- 
2.31.1

