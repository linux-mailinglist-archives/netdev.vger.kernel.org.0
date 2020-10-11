Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD3CE28AAF9
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 00:41:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387750AbgJKWly (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 18:41:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:33132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387717AbgJKWlx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Oct 2020 18:41:53 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F8FB2074A;
        Sun, 11 Oct 2020 22:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602456113;
        bh=KjfGjYsSnfWIwHrASEVqiRbvBtfZz9AkJ6pI70LmAbY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DXXI2vnw0yJuPJ+UvqE/MJmockTPIdo7j2X4VD6cjbrAv9qt0TDpFCu4E2diTbvCa
         shuUVYDttC88i8EshqLCBbS7Pgnjatcg9oMtKR2Gt/ZosE3SnuV5Kkmq5YtSR7y6jw
         Db1nukMbgdyTCNrBWKddb4xAZNlStmyMTtVuHomM=
Date:   Sun, 11 Oct 2020 15:41:50 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        =?UTF-8?B?QmrDuHJu?= Mork <bjorn@mork.no>,
        Oliver Neukum <oneukum@suse.com>,
        Igor Mitsyanko <imitsyanko@quantenna.com>,
        Sergey Matyukevich <geomatsi@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Pravin B Shelar <pshelar@ovn.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-rdma@vger.kernel.org,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH net-next 00/12] net: add and use function
 dev_fetch_sw_netstats for fetching pcpu_sw_netstats
Message-ID: <20201011154150.6cad3758@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1f1dceab-bab0-ff9e-dae6-ed35be504a9c@gmail.com>
References: <a46f539e-a54d-7e92-0372-cd96bb280729@gmail.com>
        <20201011151030.05ad88dd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <1f1dceab-bab0-ff9e-dae6-ed35be504a9c@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 12 Oct 2020 00:29:52 +0200 Heiner Kallweit wrote:
> On 12.10.2020 00:10, Jakub Kicinski wrote:
> > On Sun, 11 Oct 2020 21:34:58 +0200 Heiner Kallweit wrote:  
> >> In several places the same code is used to populate rtnl_link_stats64
> >> fields with data from pcpu_sw_netstats. Therefore factor out this code
> >> to a new function dev_fetch_sw_netstats().  
> > 
> > FWIW probably fine to convert nfp_repr_get_host_stats64() as well, just
> > take out the drop counter and make it a separate atomic. If you're up
> > for that.
> >   
> Looking at nfp_repr_get_host_stats64() I'm not sure why the authors
> decided to add a 64bit tx drop counter, struct net_device_stats has
> an unsigned long tx_dropped counter already. And that the number of
> dropped tx packets exceeds 32bit (on 32bit systems) seems not very
> likely.

struct net_device::stats? That's not per-cpu.
Or do you mean struct net_device::tx_dropped? That'd work nicely.
