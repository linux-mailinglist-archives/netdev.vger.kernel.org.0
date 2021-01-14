Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 037A22F682F
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 18:50:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729177AbhANRtw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 12:49:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:38298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727012AbhANRtv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Jan 2021 12:49:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 631B723772;
        Thu, 14 Jan 2021 17:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610646550;
        bh=+lxeZSv3qELn9FvLZh+ATubh71N2f0zhSD/AjAqT2bs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=onuwVat3FdA5WC6XrZkVFmrWdlfidKg8nQ1bZbIL49FLF9Hn8OOQpWnybnoBRfjRr
         aFNLgkITj3wHyQIOOofLFHBJINJDWvyxUnx2EjsfBaYfW5d1Pss1IoLr6E8/Xa4/xB
         hm3yooBFkIM3QxaLC0So0iTCtAcYQXkNmbuUGenRoMnVKRaFTMszwsgeYffA2beDMa
         yD7t6x71yfY3El+IdHBxz2FJ4Of8i1/XNVWaFr8Yz4RXvq/OauKntWRTeOqaGQaE5x
         iBStWqiTGuB/99jN2S242w9K/PW15vHK2VjqITHXIJ++RRnh+hvPy2kIw12UpEjt0i
         sKrsdvo6HM/UA==
Date:   Thu, 14 Jan 2021 09:49:09 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stefan Chulski <stefanc@marvell.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Nadav Haklai <nadavh@marvell.com>,
        Yan Markman <ymarkman@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "mw@semihalf.com" <mw@semihalf.com>,
        "rmk+kernel@armlinux.org.uk" <rmk+kernel@armlinux.org.uk>,
        "atenart@kernel.org" <atenart@kernel.org>
Subject: Re: [EXT] Re: [PATCH net-next] net: mvpp2: extend mib-fragments
 name to mib-fragments-err
Message-ID: <20210114094909.3ccb4148@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CO6PR18MB387365B7B1DADFF14150ACB0B0A81@CO6PR18MB3873.namprd18.prod.outlook.com>
References: <1610618858-5093-1-git-send-email-stefanc@marvell.com>
        <YABm5PDi94I5VKQp@lunn.ch>
        <CO6PR18MB387365B7B1DADFF14150ACB0B0A81@CO6PR18MB3873.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 Jan 2021 16:13:23 +0000 Stefan Chulski wrote:
> > > From: Stefan Chulski <stefanc@marvell.com>
> > >
> > > This patch doesn't change any functionality, but just extend MIB
> > > counter register and ethtool-statistic names with "err".
> > >
> > > The counter MVPP2_MIB_FRAGMENTS_RCVD in fact is Error counter.
> > > Extend REG name and appropriated ethtool statistic reg-name with the
> > > ERR/err.  
> >   
> > > --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> > > +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> > > @@ -1566,7 +1566,7 @@ static u32 mvpp2_read_index(struct mvpp2  
> > *priv, u32 index, u32 reg)  
> > >  	{ MVPP2_MIB_FC_RCVD, "fc_received" },
> > >  	{ MVPP2_MIB_RX_FIFO_OVERRUN, "rx_fifo_overrun" },
> > >  	{ MVPP2_MIB_UNDERSIZE_RCVD, "undersize_received" },
> > > -	{ MVPP2_MIB_FRAGMENTS_RCVD, "fragments_received" },
> > > +	{ MVPP2_MIB_FRAGMENTS_ERR_RCVD, "fragments_err_received" },  
> > 
> > Hi Stefan
> > 
> > I suspect this is now ABI and you cannot change it. You at least need to argue
> > why it is not ABI.
> > 
> >   Andrew  
> 
> Hi Andrew,
> 
> I not familiar with ABI concept. Does this mean we cannot change, fix
> or extend driver ethtool counters?

Extend yes, but some user may have a script tracking
"fragments_received", that script would break if you 
rename it.

It'd be good if the hardware errors were reported in 
standard netdev statistics.
