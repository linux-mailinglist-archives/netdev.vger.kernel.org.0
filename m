Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C06C2108990
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 08:55:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725875AbfKYHzb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 02:55:31 -0500
Received: from mail.dlink.ru ([178.170.168.18]:48526 "EHLO fd.dlink.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725793AbfKYHza (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Nov 2019 02:55:30 -0500
Received: by fd.dlink.ru (Postfix, from userid 5000)
        id 48AB31B20A89; Mon, 25 Nov 2019 10:55:26 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru 48AB31B20A89
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dlink.ru; s=mail;
        t=1574668526; bh=hvwfIe2HDk9ILc0UQVhg8dykjGSlCUAMb+1VVK6Nd7Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References;
        b=jXrsbGojjUz1itx5gHaRBnrS0/KftQSPHUmsgorWimUflZEMPZIY7eOsNc+0E1oD2
         /cO8gHwH1JcsL6WUqIHiA9OAvoLtELouYzf5Fr04Ci3JXZrLmIsIB5kPH8RzPUA38n
         8OCr34LDlAPU2S/OqWInsSh1CgE2dzBJNqggvymU=
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dlink.ru
X-Spam-Level: 
X-Spam-Status: No, score=-99.2 required=7.5 tests=BAYES_50,URIBL_BLOCKED,
        USER_IN_WHITELIST autolearn=disabled version=3.4.2
Received: from mail.rzn.dlink.ru (mail.rzn.dlink.ru [178.170.168.13])
        by fd.dlink.ru (Postfix) with ESMTP id 9B8251B204A3;
        Mon, 25 Nov 2019 10:55:17 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru 9B8251B204A3
Received: from mail.rzn.dlink.ru (localhost [127.0.0.1])
        by mail.rzn.dlink.ru (Postfix) with ESMTP id C9F2A1B2175B;
        Mon, 25 Nov 2019 10:54:44 +0300 (MSK)
Received: from mail.rzn.dlink.ru (localhost [127.0.0.1])
        by mail.rzn.dlink.ru (Postfix) with ESMTPA;
        Mon, 25 Nov 2019 10:54:44 +0300 (MSK)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Mon, 25 Nov 2019 10:54:44 +0300
From:   Alexander Lobakin <alobakin@dlink.ru>
To:     Nicholas Johnson <nicholas.johnson-opensource@outlook.com.au>
Cc:     David Miller <davem@davemloft.net>, ecree@solarflare.com,
        jiri@mellanox.com, edumazet@google.com, idosch@mellanox.com,
        pabeni@redhat.com, petrm@mellanox.com, sd@queasysnail.net,
        f.fainelli@gmail.com, jaswinder.singh@linaro.org,
        ilias.apalodimas@linaro.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net-next] net: core: use listified Rx for GRO_NORMAL in
 napi_gro_receive()
In-Reply-To: <PSXP216MB04388962C411CD0B17A86F47804A0@PSXP216MB0438.KORP216.PROD.OUTLOOK.COM>
References: <20191014080033.12407-1-alobakin@dlink.ru>
 <20191015.181649.949805234862708186.davem@davemloft.net>
 <7e68da00d7c129a8ce290229743beb3d@dlink.ru>
 <PSXP216MB04388962C411CD0B17A86F47804A0@PSXP216MB0438.KORP216.PROD.OUTLOOK.COM>
User-Agent: Roundcube Webmail/1.4.0
Message-ID: <c762f5eee08a8f2d0d6cb927d7fa3848@dlink.ru>
X-Sender: alobakin@dlink.ru
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Nicholas Johnson wrote 25.11.2019 10:29:
> Hi,
> 
> On Wed, Oct 16, 2019 at 10:31:31AM +0300, Alexander Lobakin wrote:
>> David Miller wrote 16.10.2019 04:16:
>> > From: Alexander Lobakin <alobakin@dlink.ru>
>> > Date: Mon, 14 Oct 2019 11:00:33 +0300
>> >
>> > > Commit 323ebb61e32b4 ("net: use listified RX for handling GRO_NORMAL
>> > > skbs") made use of listified skb processing for the users of
>> > > napi_gro_frags().
>> > > The same technique can be used in a way more common napi_gro_receive()
>> > > to speed up non-merged (GRO_NORMAL) skbs for a wide range of drivers
>> > > including gro_cells and mac80211 users.
>> > > This slightly changes the return value in cases where skb is being
>> > > dropped by the core stack, but it seems to have no impact on related
>> > > drivers' functionality.
>> > > gro_normal_batch is left untouched as it's very individual for every
>> > > single system configuration and might be tuned in manual order to
>> > > achieve an optimal performance.
>> > >
>> > > Signed-off-by: Alexander Lobakin <alobakin@dlink.ru>
>> > > Acked-by: Edward Cree <ecree@solarflare.com>
>> >
>> > Applied, thank you.
>> 
>> David, Edward, Eric, Ilias,
>> thank you for your time.
>> 
>> Regards,
>> ᚷ ᛖ ᚢ ᚦ ᚠ ᚱ
> 
> I am very sorry to be the bearer of bad news. It appears that this
> commit is causing a regression in Linux 5.4.0-rc8-next-20191122,
> preventing me from connecting to Wi-Fi networks. I have a Dell XPS 9370
> (Intel Core i7-8650U) with Intel Wireless 8265 [8086:24fd].

Hi!

It's a bit strange as this commit doesn't directly affect the packet
flow. I don't have any iwlwifi hardware at the moment, so let's see if
anyone else will be able to reproduce this (for now, it is the first
report in a ~6 weeks after applying to net-next).
Anyway, I'll investigate iwlwifi's Rx processing -- maybe I could find
something driver-specific that might produce this.

Thank you for the report.

> I did a bisect, and this commit was named the culprit. I then applied
> the reverse patch on another clone of Linux next-20191122, and it
> started working.
> 
> 6570bc79c0dfff0f228b7afd2de720fb4e84d61d
> net: core: use listified Rx for GRO_NORMAL in napi_gro_receive()
> 
> You can see more at the bug report I filed at [0].
> 
> [0]
> https://bugzilla.kernel.org/show_bug.cgi?id=205647
> 
> I called on others at [0] to try to reproduce this - you should not 
> pull
> a patch because of a single reporter - as I could be wrong.
> 
> Please let me know if you want me to give more debugging information or
> test any potential fixes. I am happy to help to fix this. :)
> 
> Kind regards,
> Nicholas Johnson

Regards,
ᚷ ᛖ ᚢ ᚦ ᚠ ᚱ
