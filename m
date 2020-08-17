Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD8802468BC
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 16:51:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729039AbgHQOvw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 10:51:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728873AbgHQOvv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 10:51:51 -0400
X-Greylist: delayed 1582 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 17 Aug 2020 07:51:51 PDT
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F84BC061389
        for <netdev@vger.kernel.org>; Mon, 17 Aug 2020 07:51:51 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.93.0.4)
        (envelope-from <daniel@makrotopia.org>)
        id 1k7g4J-0003Pz-N0; Mon, 17 Aug 2020 16:25:03 +0200
Date:   Mon, 17 Aug 2020 15:24:38 +0100
From:   Daniel Golle <daniel@makrotopia.org>
To:     Sven Eckelmann <sven@narfation.org>
Cc:     gluon@luebeck.freifunk.net,
        Linus =?iso-8859-1?Q?L=FCssing?= <linus.luessing@c0d3.blue>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        netdev@vger.kernel.org, Roopa Prabhu <roopa@cumulusnetworks.com>,
        bridge@lists.linux-foundation.org, openwrt-devel@lists.openwrt.org,
        "David S . Miller" <davem@davemloft.net>,
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Subject: Re: [gluon] Re: [RFC PATCH net-next] bridge: Implement MLD Querier
 wake-up calls / Android bug workaround
Message-ID: <20200817142438.GB1299@makrotopia.org>
References: <20200816202424.3526-1-linus.luessing@c0d3.blue>
 <87zh6t650b.fsf@miraculix.mork.no>
 <1830568.o5y0iYavLQ@sven-edge>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1830568.o5y0iYavLQ@sven-edge>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 17, 2020 at 03:17:37PM +0200, Sven Eckelmann wrote:
> On Monday, 17 August 2020 10:39:00 CEST Bjørn Mork wrote:
> > Linus Lüssing <linus.luessing@c0d3.blue> writes:
> [...]
> > This is not a bug.  They are deliberately breaking IPv6 because they
> > consider this a feature.  You should not try to work around such issues.
> > It is a fight you cannot win.  Any workaround will only encourage them
> > to come up with new ways to break IPv6.
> 
> Who are "they" and where is this information coming from? And what do they 
> gain from breaking IPv6? Wouldn't it be easier for them just to disable IPv6 
> than adding random looking bugs?

They are Google and they want IPv6 to be used in a way which exposes
as much user data as possible to their servers (that's my guess).
Every additional identifying bit is like gold for them (that's their
business model).
Hence they like SLAAC and addressing schemes which reflect the network
topology and are enforcing that direction beyond good reason (that
should be obvious[1] to everyone[2] by now[3], no matter what the
reasons for that are).
You may say, hey, SLAAC also allows me to use Privary Extension and I'm
sure your browser will make use of that. But does the DNS resolver?
And what about all those Google services running in background? I'm not
sure all of them instruct the kernel to open every single socket using
a privacy source address...
Simply, when relying on SLAAC + Privary Extensions it's up to the
(mobile) client to avoid being very easily tracked.
When using DHCPv6 the situation is like it was for v4 (ok, it's still
a bit worse because you can distinguish clients much better).

As a work-around, I've been limiting source EUI-64 addresses from
leaving my local network -- but that's surely not what everyone would
want to make sure their local devices MAC addresses aren't leaked and
also just breaking v6 in yet another way.
I don't consider NAT66 an option and would like to avoid even
connection-tracking on v6 as it was promissed :). Tethering should
work using DHCPv6 prefix delegation imho rather than ND-proxy or
NAT66 which are both quite a burden for the battery-powered device
offering the tethering gateway (ie. each forwarded packet then needs
CPU intervention, I can't see anything great about that).



[1]: https://www.nullzero.co.uk/android-does-not-support-dhcpv6-and-google-wont-fix-that/

[2]: https://www.techrepublic.com/article/androids-lack-of-dhcpv6-support-frustrates-enterprise-network-admins/

[3]: https://lostintransit.se/2020/05/22/its-2020-and-androids-ipv6-is-still-broken/
