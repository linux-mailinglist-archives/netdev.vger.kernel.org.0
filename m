Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F4DE31062
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 16:38:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726784AbfEaOiI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 10:38:08 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:44866 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726550AbfEaOiI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 10:38:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=tazGyoINDtGJDhMyeZiXu50p40iBVItCCWyPxYp1J44=; b=0bEtsjftZRI57pW96xurs+QNWH
        uL69zm/Rupsxy+Gb4/ZkKsXh/py+ygqkMY6C2AlcVszodNm5TRXWwog0X0PLmB9g8jrgMlyOXlxfq
        U66sudJsfecbf7suciGZA/1jXvhzje/FJ+Z4IEkJQLBksg0LzfedzzAmSf0uNqkqzxvA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hWifO-0006eu-Ph; Fri, 31 May 2019 16:37:58 +0200
Date:   Fri, 31 May 2019 16:37:58 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vivien Didelot <vivien.didelot@gmail.com>
Cc:     Nikita Yushchenko <nikita.yoush@cogentembedded.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Healy <cphealy@gmail.com>
Subject: Re: [PATCH] net: dsa: mv88e6xxx: avoid error message on remove from
 VLAN 0
Message-ID: <20190531143758.GB23821@lunn.ch>
References: <20190531073514.2171-1-nikita.yoush@cogentembedded.com>
 <20190531103105.GE23464@t480s.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190531103105.GE23464@t480s.localdomain>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I'm not sure that I like the semantic of it, because the driver can actually
> support VID 0 per-se, only the kernel does not use VLAN 0. Thus I would avoid
> calling the port_vlan_del() ops for VID 0, directly into the upper DSA layer.
> 
> Florian, Andrew, wouldn't the following patch be more adequate?
> 
>     diff --git a/net/dsa/slave.c b/net/dsa/slave.c
>     index 1e2ae9d59b88..80f228258a92 100644
>     --- a/net/dsa/slave.c
>     +++ b/net/dsa/slave.c
>     @@ -1063,6 +1063,10 @@ static int dsa_slave_vlan_rx_kill_vid(struct net_device *dev, __be16 proto,
>             struct bridge_vlan_info info;
>             int ret;
>      
>     +       /* VID 0 has a special meaning and is never programmed in hardware */
>     +       if (!vid)
>     +               return 0;
>     +
>             /* Check for a possible bridge VLAN entry now since there is no
>              * need to emulate the switchdev prepare + commit phase.
>              */
 
Hi Vivien

If we put this in rx_kill_vid, we should probably have something
similar in rx_add_vid, just in case the kernel does start using VID 0.

	Andrew
