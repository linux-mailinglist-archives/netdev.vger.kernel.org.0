Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AB73326D1B
	for <lists+netdev@lfdr.de>; Sat, 27 Feb 2021 14:21:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230010AbhB0NTE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Feb 2021 08:19:04 -0500
Received: from ssl.serverraum.org ([176.9.125.105]:50755 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229953AbhB0NTE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Feb 2021 08:19:04 -0500
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 5585A2222E;
        Sat, 27 Feb 2021 14:18:20 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1614431900;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=t2vu2bdoEZETXLEt9G1pHOB673wqmrwcy8PZ8jrbj/4=;
        b=CVhrv/hEkiVq4NZs6DwQ0H9k9Ct5MXQOk5jIg8PTVLJTrL0mzSNTRk3MXeqVwgBVR+Pu2B
        aEqAwpFzHgAxQGGObyg0CGCrn+ukg7diXLTAzkYty9yaDmaCV03r0Lh6RhR8ItzzM3GA7e
        m1otSu3Giyi5kt7b/6THqIVxcQC2/qQ=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Sat, 27 Feb 2021 14:18:20 +0100
From:   Michael Walle <michael@walle.cc>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        =?UTF-8?Q?Markus_Bl=C3=B6ch?= =?UTF-8?Q?l?= 
        <Markus.Bloechl@ipetronik.com>
Subject: Re: [PATCH v2 net 5/6] net: enetc: don't disable VLAN filtering in
 IFF_PROMISC mode
In-Reply-To: <20210227001651.geuv4pt2bxkzuz5d@skbuf>
References: <20210225121835.3864036-1-olteanv@gmail.com>
 <20210225121835.3864036-6-olteanv@gmail.com>
 <20210226152836.31a0b1bb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210226234244.w7xw7qnpo3skdseb@skbuf>
 <20210226154922.5956512b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210227001651.geuv4pt2bxkzuz5d@skbuf>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <7bb61f7190bebadb9b6281cb02fa103d@walle.cc>
X-Sender: michael@walle.cc
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2021-02-27 01:16, schrieb Vladimir Oltean:
> On Fri, Feb 26, 2021 at 03:49:22PM -0800, Jakub Kicinski wrote:
>> On Sat, 27 Feb 2021 01:42:44 +0200 Vladimir Oltean wrote:
>> > On Fri, Feb 26, 2021 at 03:28:36PM -0800, Jakub Kicinski wrote:
>> > > I don't understand what you're fixing tho.
>> > >
>> > > Are we trying to establish vlan-filter-on as the expected behavior?
>> >
>> > What I'm fixing is unexpected behavior, according to the applicable
>> > standards I could find.

In the referenced thread you quoted from the IEEE802.3 about the promisc
mode.
   The MAC sublayer may also provide the capability of operating in the
   promiscuous receive mode. In this mode of operation, the MAC sublayer
   recognizes and accepts all valid frames, regardless of their 
Destination
   Address field values.

Your argument was that the standard just talks about disabling the DMAC
filter. But was that really the _intention_ of the standard? Does the
standard even mention a possible vlan tag? What I mean is: maybe the
standard just mention the DMAC because it is the only filtering 
mechanism
in this standard and it's enough to disable it to "accept all valid 
frames".

I was biten by "the NIC drops frames with an unknown VLAN" even if
promisc mode was enabled. And IMHO it was quite suprising for me.

>> > If I don't mark this change as a bug fix but as
>> > a simple patch, somebody could claim it's a regression, since promiscuity
>> > used to be enough to see packets with unknown VLANs, and now it no
>> > longer is...
>> 
>> Can we take it into net-next? What's your feeling on that option?
> 
> I see how you can view this patch as pointless, but there is some
> context to it. It isn't just for tcpdump/debugging, instead NXP has 
> some
> TSN use cases which involve some asymmetric tc-vlan rules, which is how
> I arrived at this topic in the first place. I've already established
> that tc-vlan only works with ethtool -K eth0 rx-vlan-filter off:
> https://lore.kernel.org/netdev/CA+h21hoxwRdhq4y+w8Kwgm74d4cA0xLeiHTrmT-VpSaM7obhkg@mail.gmail.com/

Wasn't the conclusion that the VID should be added to the filter so it
also works with vlan filter enabled? Am I missing another discussion?

-michael

> and that's what we recommend doing, but while adding the support for
> rx-vlan-filter in enetc I accidentally created another possibility for
> this to work on enetc, by turning IFF_PROMISC on. This is not portable,
> so if somebody develops a solution based on that in parallel, it will
> most certainly break on other non-enetc drivers.
> NXP has not released a kernel based on the v5.10 stable yet, so there 
> is
> still time to change the behavior, but if this goes in through 
> net-next,
> the apparent regression will only be visible when the next LTS comes
> around (whatever the number of that might be). Now, I'm going to
> backport this to the NXP v5.10 anyway, so that's not an issue, but 
> there
> will still be the mild annoyance that the upstream v5.10 will behave
> differently in this regard compared to the NXP v5.10, which is again a
> point of potential confusion, but that seems to be out of my control.
> 
> So if you're still "yeah, don't care", then I guess I'm ok with leaving
> things alone on stable kernels.
