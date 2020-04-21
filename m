Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCA531B2A7C
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 16:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728957AbgDUOvD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 10:51:03 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54212 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726628AbgDUOvD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Apr 2020 10:51:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=8Qynf6hcLm2W/HhSDd8tPztQA+MysekaejQSi+2hhk0=; b=CPDR2qKjZV2X/H2PE8UZcmkZul
        8ImSTp8v4SUbHT7q+fufkRKFY23Kywx7R6etZoDudVi9sy5Oa+barX6Ia8KAEzlmndHj5tHM/excM
        dinEZX0XyzbBgpwQ6xO8XQsm7uL/1BeKZwCswHFESEx1/IaKSTtP98KXHsPCrbwoRTdM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jQuEl-0042c2-7e; Tue, 21 Apr 2020 16:50:59 +0200
Date:   Tue, 21 Apr 2020 16:50:59 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net 1/2] net: dsa: be compatible with DSA masters with
 max_mtu of 1500 or less
Message-ID: <20200421145059.GC933345@lunn.ch>
References: <20200421123110.13733-1-olteanv@gmail.com>
 <20200421123110.13733-2-olteanv@gmail.com>
 <20200421133321.GD937199@lunn.ch>
 <CA+h21hrXJf1vm-5b3O7zQciznKF-jGSTpe_v6Mgtv8dXNOCt7g@mail.gmail.com>
 <20200421140653.GA933345@lunn.ch>
 <CA+h21hq4deLKEp80Kt4Gboxon4MLsOYaXPk6Tz2JBAH0yF2q9Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hq4deLKEp80Kt4Gboxon4MLsOYaXPk6Tz2JBAH0yF2q9Q@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > We have always assumed the slave can send normal sized frames,
> > independent of what the master supports. This is just a follow on from
> > the fact we ignore errors setting the MTU on the master for the DSA
> > overhead for normal size frames. So don't set the MTU to 1496, leave
> > it at 1500. For all working boards out in the wild, 1500 will work.
> >
> >          Andrew
> 
> Does iperf3 TCP work on your Vybrid board with the master MTU equal to
> the slave MTU equal to 1500 (without IP fragmentation, that is)? If it
> does, ok, this patch can maybe be dropped.

Yes it does.

> qca7000 doesn't support packets larger than 1500 MTU either, neither
> does broadcom b44, and neither do probably more adapters which I
> didn't find now.

And unfortunately, there are probably a similar number of devices
which do work, and don't have correct MTU settings. So long as the IP
stack does MTU correctly, it does not matter what the network device
does with frames bigger than the MTU. And so network devices whos MTU
handling is wrong never causes issues, and so never get detected and
fixed.

We have to live in a world where trying to be correct is going to
cause regressions because of poor decisions in the past. But we can do
jumbo correctly, since it is new, it cannot regress. And doing jumbo
correct will help find some of these network drivers which do MTU
settings wrong.

      Andrew
