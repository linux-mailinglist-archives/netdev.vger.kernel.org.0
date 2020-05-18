Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C63441D6E6A
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 03:07:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726700AbgERBHD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 May 2020 21:07:03 -0400
Received: from ozlabs.org ([203.11.71.1]:43601 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726665AbgERBHD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 17 May 2020 21:07:03 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 49QLSz6PcGz9sPK;
        Mon, 18 May 2020 11:06:59 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1589764021; bh=Nc6dohBCnRNOrZ1lpqEXvYZ9kCm+r1xCGET1JAWwSOA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ATYdjM7aKjYw0Scr9OWyzF/aZZ6lDvKze/viQikcdCpwIe8hKNY2ut2+XXAn3T07n
         HWaQxXIqdUz3APbhNerv+td8xbQ18TKEXB5rQCU6ZYR+zlkg4Zw1FLV6KwfBDfCfMY
         jP9WaK3oCeZG7sDHdTHQDFcW0U/9etV5qwwkdncMBNvh4ulAAyOvTdQwszrqjA+AzB
         Wy7JC4hR047sIOXwSP6txjM/wUDz6xM4kt1p8B1KfKXW26Bavj4Axgv5GZ4Kn++zHv
         wGXDqhbJOdJ7vedfeIqBzKCA63Dh2CXWa5ptCdxqap3iyRSjYmSaGqEtQFAfE53FLO
         WOfa2mOZUhn2Q==
Message-ID: <43d5717e7157fd300fd5bf893e517bbdf65c36f4.camel@ozlabs.org>
Subject: Re: [PATCH] net: bmac: Fix stack corruption panic in bmac_probe()
From:   Jeremy Kerr <jk@ozlabs.org>
To:     Finn Thain <fthain@telegraphics.com.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Paul Mackerras <paulus@samba.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Stan Johnson <userm57@yahoo.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date:   Mon, 18 May 2020 09:06:59 +0800
In-Reply-To: <769e9041942802d0e9ff272c12ee359a04b84a90.1589761211.git.fthain@telegraphics.com.au>
References: <769e9041942802d0e9ff272c12ee359a04b84a90.1589761211.git.fthain@telegraphics.com.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Finn,

> This fixes an old bug recently revealed by CONFIG_STACKPROTECTOR.

Good catch. I'm not sure about the fix though. That variable ('addr')
should be a ethernet hardware address; I'm surprised we're accessing
past the 6th byte. The culprit seems to be this, where 'ea' is the
address buffer:

   static void
   bmac_get_station_address(struct net_device *dev, unsigned char *ea)
   {
        int i;
        unsigned short data;

        for (i = 0; i < 6; i++)
                {
                        reset_and_select_srom(dev);
                        data = read_srom(dev, i + EnetAddressOffset/2, SROMAddressBits);
                        ea[2*i]   = bitrev8(data & 0x0ff);
                        ea[2*i+1] = bitrev8((data >> 8) & 0x0ff);
                }
   }

- where it looks like the condition on that for-loop is wrong; we're
reading two bytes at a time there.

Can you try the attached patch?

Ben/Paul - any thoughts?

Cheers,


Jeremy

-----

From 141b20bcbdb3ad7c166b83b4ea61f3521d0a0679 Mon Sep 17 00:00:00 2001
From: Jeremy Kerr <jk@ozlabs.org>
Date: Mon, 18 May 2020 08:54:25 +0800
Subject: [PATCH] net: bmac: Fix read of MAC address from ROM

In bmac_get_station_address, We're reading two bytes at a time from ROM,
but we do that six times, resulting in 12 bytes of read & writes. This
means we will write off the end of the six-byte destination buffer.

This change fixes the for-loop to only read/write six bytes.

Based on a proposed fix from Finn Thain <fthain@telegraphics.com.au>.

Signed-off-by: Jeremy Kerr <jk@ozlabs.org>
Reported-by: Stan Johnson <userm57@yahoo.com>
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
 
-       for (i = 0; i < 6; i++)
+       for (i = 0; i < 3; i++)
                {
                        reset_and_select_srom(dev);
                        data = read_srom(dev, i + EnetAddressOffset/2, SROMAddressBits);
-- 
2.17.1



