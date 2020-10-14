Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7692628D744
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 02:04:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389404AbgJNAEB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 20:04:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:46198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730370AbgJNAEB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Oct 2020 20:04:01 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 54A9220776;
        Wed, 14 Oct 2020 00:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633840;
        bh=r1nAnxVv/eKDQN7JToxDXPC6mg1uZBhl71AnIjFw31c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=p1/CPNjjc4AvlAPo4ua1mnYI/l+xmWHNyK8fIFPGsWdntkP9lIXedMaNXr723QlCU
         wcNZQ6RdNVEuipndhoIh6TYwmK7RFabTUhEDKscb6lAfGQ8bORlE4UlurQwtJ0M2co
         Xt4L/B5H91YkqrWkeevBG1fhXngb6mdiaaVcyHrk=
Date:   Tue, 13 Oct 2020 17:03:58 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Willy Tarreau <w@1wt.eu>
Cc:     Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        netdev@vger.kernel.org, David Miller <davem@davemloft.net>
Subject: Re: [PATCH net-next 0/3] macb: support the 2-deep Tx queue on at91
Message-ID: <20201013170358.1a4d282a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201011090944.10607-1-w@1wt.eu>
References: <20201011090944.10607-1-w@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 11 Oct 2020 11:09:41 +0200 Willy Tarreau wrote:
> while running some tests on my Breadbee board, I noticed poor network
> Tx performance. I had a look at the driver (macb, at91ether variant)
> and noticed that at91ether_start_xmit() immediately stops the queue
> after sending a frame and waits for the interrupt to restart the queue,
> causing a dead time after each packet is sent.
> 
> The AT91RM9200 datasheet states that the controller supports two frames,
> one being sent and the other one being queued, so I performed minimal
> changes to support this. The transmit performance on my board has
> increased by 50% on medium-sized packets (HTTP traffic), and with large
> packets I can now reach line rate.
> 
> Since this driver is shared by various platforms, I tried my best to
> isolate and limit the changes as much as possible and I think it's pretty
> reasonable as-is. I've run extensive tests and couldn't meet any
> unexpected situation (no stall, overflow nor lockup).
> 
> There are 3 patches in this series. The first one adds the missing
> interrupt flag for RM9200 (TBRE, indicating the tx buffer is willing
> to take a new packet). The second one replaces the single skb with a
> 2-array and uses only index 0. It does no other change, this is just
> to prepare the code for the third one. The third one implements the
> queue. Packets are added at the tail of the queue, the queue is
> stopped at 2 packets and the interrupt releases 0, 1 or 2 depending
> on what the transmit status register reports.

LGTM. There's always a chance that this will make other 
designs explode, but short of someone from Cadence giving 
us a timely review we have only one way to find that out.. :)

Applied, thanks!
