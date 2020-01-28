Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3746414BD9D
	for <lists+netdev@lfdr.de>; Tue, 28 Jan 2020 17:23:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726211AbgA1QXh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jan 2020 11:23:37 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:57310 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725974AbgA1QXh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jan 2020 11:23:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=07JCtCTKQ7UvvvML72GagXCpNyJQ2USMb9PTprpgBv4=; b=FeLmdEOaQiSd33vvUtpsy7Xppx
        y6NANL/Gctx+InN9B+bCR3qw/b4eTp2/JTnT54jofhwxi6DlLnBtFCObn9qCz/tiIl6Ns+6+C9Qoy
        dFxRmnYQk8+qPTkrgIXQLuU07FstRjWCCu3tLCht1FrdpmA68OHW0jytDVTZTDncBSbg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1iwTeE-00036a-Qd; Tue, 28 Jan 2020 17:23:30 +0100
Date:   Tue, 28 Jan 2020 17:23:30 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     madalin.bucur@oss.nxp.com, "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        netdev <netdev@vger.kernel.org>, ykaukab@suse.de
Subject: Re: [PATCH v2 2/2] dpaa_eth: support all modes with rate adapting
 PHYs
Message-ID: <20200128162330.GN13647@lunn.ch>
References: <1580137671-22081-1-git-send-email-madalin.bucur@oss.nxp.com>
 <1580137671-22081-3-git-send-email-madalin.bucur@oss.nxp.com>
 <CA+h21hqzR72v9=dWGk1zBptNHNst+kajh6SHHSUMp02fAq5m5g@mail.gmail.com>
 <20200127160413.GI13647@lunn.ch>
 <CA+h21hoZVDFANhzP5BOkZ+HxLMg9=pcdmLbaavg-1CpDEq=CHg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hoZVDFANhzP5BOkZ+HxLMg9=pcdmLbaavg-1CpDEq=CHg@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 28, 2020 at 05:41:31PM +0200, Vladimir Oltean wrote:
> Hi Andrew,
> 
> On Mon, 27 Jan 2020 at 18:04, Andrew Lunn <andrew@lunn.ch> wrote:
> >
> > > Is this sufficient?
> > > I suppose this works because you have flow control enabled by default?
> > > What would happen if the user would disable flow control with ethtool?
> >
> > It will still work. Network protocols expect packets to be dropped,
> > there are bottlenecks on the network, and those bottlenecks change
> > dynamically. TCP will still be able to determine how much traffic it
> > can send without too much packet loss, independent of if the
> > bottleneck is here between the MAC and the PHY, or later when it hits
> > an RFC 1149 link.
> 
> Following this logic, this patch isn't needed at all, right? The PHY
> will drop frames that it can't hold in its small FIFOs when adapting a
> link speed to another, and higher-level protocols will cope. And flow
> control at large isn't needed.

Hi Vladimir

It is something worth testing. It might depend on the size of the
FIFO, and offloads like GSO. If the interface is given a 64KByte skb
to send, and the hardware sends it in a 10G line rate burst, is that
going to overflow the small FIFO? If the PHY trigger flow control fast
enough to pause the MAC within this burst, the performance could be
better.

So it is not a binary works/broken, but what is performance like? Can
you get 1Gbps, or does it drop to a much lower speed with a lot of
retires?

Flow control might not be the only option. It is simple, so if it
works, great. But when the PHY reports it has link at 1G, could you
enable some traffic shaping in the MAC to limit it to 1G, even if it
is going out a 10G SERDES?

   Andrew
