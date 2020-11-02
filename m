Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7861F2A34B2
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 20:58:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbgKBT6F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 14:58:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:39798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726625AbgKBT5r (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 14:57:47 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF22E208B6;
        Mon,  2 Nov 2020 19:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604347066;
        bh=GPBPe1FgoF22Eev5y7JfZORGR2pEXjYUuU9ddm4txLA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=vUBWzCn9DvFnaXyt6pZcuBgaC7kBEbBl+Ye1HyYuqL59afYfb2dbmpOgWNzoGGyGf
         cWzzhhEYvbM8RLyHLoe8kNIFgPz8AtnFQ8u2iH4aUBpBFGf3hOrv4uxWnhxAvfsAKB
         OnWe6pbIiixQ0IlKDSmIdd3nf1M4WjJWnB//4QcE=
Date:   Mon, 2 Nov 2020 11:57:45 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        Christian Eggers <ceggers@arri.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: Re: [PATCH v2 net-next 01/12] net: dsa: implement a central TX
 reallocation procedure
Message-ID: <20201102115745.10b50a4e@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201101013728.zzepqg3tl4ddgdt5@skbuf>
References: <20201030014910.2738809-1-vladimir.oltean@nxp.com>
        <20201030014910.2738809-2-vladimir.oltean@nxp.com>
        <20201031180043.2f6bed15@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <20201101011434.e5crugmwy7drnvqt@skbuf>
        <20201101013728.zzepqg3tl4ddgdt5@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 1 Nov 2020 03:37:28 +0200 Vladimir Oltean wrote:
> On Sun, Nov 01, 2020 at 03:14:34AM +0200, Vladimir Oltean wrote:
> > On Sat, Oct 31, 2020 at 06:00:43PM -0700, Jakub Kicinski wrote:  
> > > On Fri, 30 Oct 2020 03:48:59 +0200 Vladimir Oltean wrote:  
> > > > @@ -567,6 +591,17 @@ static netdev_tx_t dsa_slave_xmit(struct sk_buff *skb, struct net_device *dev)
> > > >  	 */
> > > >  	dsa_skb_tx_timestamp(p, skb);
> > > >  
> > > > +	if (dsa_realloc_skb(skb, dev)) {
> > > > +		kfree_skb(skb);  
> > > 
> > > dev_kfree_skb_any()?  
> > 
> > Just showing my ignorance, but where does the hardirq context come from?  
> 
> I mean I do see that netpoll_send_udp requires IRQs disabled, but is
> that the only reason why all drivers need to assume hardirq context in
> .xmit, or are there more?

netpoll is the only one that comes to my mind, maybe others know more..
