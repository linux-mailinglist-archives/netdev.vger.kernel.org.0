Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1D896F3C7
	for <lists+netdev@lfdr.de>; Sun, 21 Jul 2019 16:53:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726458AbfGUOx2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jul 2019 10:53:28 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54100 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726399AbfGUOx2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 21 Jul 2019 10:53:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=uq/KuE4L/8X9xcpcAVbyOyvCVSdlgHWHWJ+hXa5I46s=; b=R6+5PvMZ6HPZqj04y1qoJH7CX6
        wXEj3JIz+te0OdiHsZf+nI7HO4H3/A0WqK+KvO8SK3avLB+Ra616cXfGTmroU1mBY5ikGNm4wh0Au
        tmld3U9xFezOLjatf+eS2Ki/7C2sRL9F+yp6eVRqTAdRLNKyhhW51ue1Z7Y8sJE4Nh+I=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hpDDJ-0006Ke-0B; Sun, 21 Jul 2019 16:53:25 +0200
Date:   Sun, 21 Jul 2019 16:53:24 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Zhu Yanjun <yanjun.zhu@oracle.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCHv2 0/2] forcedeth: recv cache to make NIC work steadily
Message-ID: <20190721145324.GD22996@lunn.ch>
References: <1563713633-25528-1-git-send-email-yanjun.zhu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1563713633-25528-1-git-send-email-yanjun.zhu@oracle.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 21, 2019 at 08:53:51AM -0400, Zhu Yanjun wrote:
> These patches are to this scenario:
> 
> "
> When the host run for long time, there are a lot of memory fragments in
> the hosts. And it is possible that kernel will compact memory fragments.
> But normally it is difficult for NIC driver to allocate a memory from
> kernel. From this variable stat_rx_dropped, we can confirm that NIC driver
> can not allocate skb very frequently.
> "
> 
> Since NIC driver can not allocate skb in time, this makes some important
> tasks not be completed in time.
> To avoid it, a recv cache is created to pre-allocate skb for NIC driver.
> This can make the important tasks be completed in time.
> >From Nan's tests in LAB, these patches can make NIC driver work steadily.
> Now in production hosts, these patches are applied.
> 
> With these patches, one NIC port needs 125MiB reserved. This 125MiB memory
> can not be used by others. To a host on which the communications are not
> mandatory, it is not necessary to reserve so much memory. So this recv cache
> is disabled by default.
> 
> V1->V2:
> 1. ndelay is replaced with GFP_KERNEL function __netdev_alloc_skb.
> 2. skb_queue_purge is used when recv cache is destroyed.
> 3. RECV_LIST_ALLOCATE bit is removed.
> 4. schedule_delayed_work is moved out of while loop.

Hi Zhu

You don't appear to of address David's comment that this is probably
the wrong way to do this, it should be a generic solution.

Also, that there should be enough atomic memory in the system
anyway. Have you looked at what other drivers are using atomic memory?
It could actually be you need to debug some other driver, rather than
add hacks to forcedeth.

    Andrew
