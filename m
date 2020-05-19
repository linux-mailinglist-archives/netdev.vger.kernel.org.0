Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 776C11D8CEE
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 03:07:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727819AbgESBHj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 21:07:39 -0400
Received: from ozlabs.org ([203.11.71.1]:39671 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726713AbgESBHj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 May 2020 21:07:39 -0400
Received: by ozlabs.org (Postfix, from userid 1023)
        id 49QyRF0gcQz9sTT; Tue, 19 May 2020 11:07:36 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1589850457; bh=/ckANuUqu3gyx20H5W9aJipVsE8n+HFMzdiIK207svE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PjBgUvGm0ESUu1SWVNI0mfNWV30lA4kJ1o1w2yRcKglraMF2wAqCNXhWb7JCQOWET
         PVo03rjfEE+WF4cP+wj9jcEmSzXGwnGA+RuOun/HGnYIkjb5JLgbz8sGs1uIipHVUW
         DUhowF+WRXiXTQq+sdVFuV4vbj7S56QFi3xXc7SiL6K7zre7cHU6zFkWWfq4ZTWS1+
         NsypY/n3szCW0SdEicB9ZOj1R771Vo0HN/c3P0CLanDQGsm9bs5P00U/ILPopZHKpQ
         8G3uQNQmc+2cfmoE1IUrkq4Hw+DdrS0m+Gm3Ad/pRZ5kjoRhJwF/LlgdawO8X0qaHM
         2eY7RXnAp+jFw==
From:   Jeremy Kerr <jk@ozlabs.org>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Finn Thain <fthain@telegraphics.com.au>,
        Stan Johnson <userm57@yahoo.com>
Subject: [PATCH] net: bmac: Fix read of MAC address from ROM
Date:   Tue, 19 May 2020 09:05:58 +0800
Message-Id: <20200519010558.24805-1-jk@ozlabs.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <4863b7d34cf23d269921ad133dc585ec83a0bb63.camel@ozlabs.org>
References: <4863b7d34cf23d269921ad133dc585ec83a0bb63.camel@ozlabs.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In bmac_get_station_address, We're reading two bytes at a time from ROM,
but we do that six times, resulting in 12 bytes of read & writes. This
means we will write off the end of the six-byte destination buffer.

This change fixes the for-loop to only read/write six bytes.

Based on a proposed fix from Finn Thain <fthain@telegraphics.com.au>.

Signed-off-by: Jeremy Kerr <jk@ozlabs.org>
Reported-by: Stan Johnson <userm57@yahoo.com>
Tested-by: Stan Johnson <userm57@yahoo.com>
Reported-by: Finn Thain <fthain@telegraphics.com.au>
---
 drivers/net/ethernet/apple/bmac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/apple/bmac.c b/drivers/net/ethernet/apple/bmac.c
index a58185b1d8bf..3e3711b60d01 100644
--- a/drivers/net/ethernet/apple/bmac.c
+++ b/drivers/net/ethernet/apple/bmac.c
@@ -1182,7 +1182,7 @@ bmac_get_station_address(struct net_device *dev, unsigned char *ea)
 	int i;
 	unsigned short data;
 
-	for (i = 0; i < 6; i++)
+	for (i = 0; i < 3; i++)
 		{
 			reset_and_select_srom(dev);
 			data = read_srom(dev, i + EnetAddressOffset/2, SROMAddressBits);
-- 
2.17.1

