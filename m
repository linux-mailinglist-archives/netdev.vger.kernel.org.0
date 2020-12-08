Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 433982D3680
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 23:55:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731498AbgLHWwU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 17:52:20 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:45196 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731438AbgLHWwQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Dec 2020 17:52:16 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kmlpN-00AvrE-AX; Tue, 08 Dec 2020 23:51:25 +0100
Date:   Tue, 8 Dec 2020 23:51:25 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sven Van Asbroeck <thesven73@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        David S Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net v1 2/2] lan743x: boost performance: limit PCIe
 bandwidth requirement
Message-ID: <20201208225125.GA2602479@lunn.ch>
References: <20201206034408.31492-1-TheSven73@gmail.com>
 <20201206034408.31492-2-TheSven73@gmail.com>
 <20201208114314.743ee6ec@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <CAGngYiVSHRGC+eOCeF3Kyj_wOVqxJHvoc9fXRk-w+sVRjeSpcw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGngYiVSHRGC+eOCeF3Kyj_wOVqxJHvoc9fXRk-w+sVRjeSpcw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> That's a good question. I used perf to create a flame graph of what
> the cpu was doing when receiving data at high speed. It showed that
> __dma_page_dev_to_cpu took up most of the cpu time. Which is triggered
> by dma_unmap_single(9K, DMA_FROM_DEVICE).
> 
> So I assumed that it's a PCIe dma bandwidth issue, but I could be wrong -
> I didn't do any PCIe bandwidth measurements.

Sometimes it is actually cache operations which take all the
time. This needs to invalidate the cache, so that when the memory is
then accessed, it get fetched from RAM. On SMP machines, cache
invalidation can be expensive, due to all the cross CPU operations.
I've actually got better performance by building a UP kernel on some
low core count ARM CPUs.

There are some tricks which can be played. Do you actually need all
9K? Does the descriptor tell you actually how much is used? You can
get a nice speed up if you just unmap 64 bytes for a TCP ACK, rather
than the full 9K.

     Andrew
