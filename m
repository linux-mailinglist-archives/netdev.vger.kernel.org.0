Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C278210AEDC
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 12:45:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbfK0LpJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 06:45:09 -0500
Received: from mail.dlink.ru ([178.170.168.18]:37264 "EHLO fd.dlink.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726204AbfK0LpI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Nov 2019 06:45:08 -0500
Received: by fd.dlink.ru (Postfix, from userid 5000)
        id 793FD1B2130C; Wed, 27 Nov 2019 14:45:05 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru 793FD1B2130C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dlink.ru; s=mail;
        t=1574855105; bh=o17u0Mv938KWC6Gx4yfR1SxtCwAXy8AEp8aMy0JxuQM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References;
        b=fG4FBn8+OFjm9R90Co2zGjnVTCOBwLns0io5LQ6aQAqW4l5BKg+W8OJejOJ6hFehI
         XvzCdOo6K+KA2LuiZ6ucmaBkzNTheV+DjIkdOUAyVDz9Bo25bPtFzy3REOSpPNJkC1
         w9dXfcWNvOQvx1iefFnLF0bcFzvC4qpCLadcrDf4=
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dlink.ru
X-Spam-Level: 
X-Spam-Status: No, score=-99.2 required=7.5 tests=BAYES_50,URIBL_BLOCKED,
        USER_IN_WHITELIST autolearn=disabled version=3.4.2
Received: from mail.rzn.dlink.ru (mail.rzn.dlink.ru [178.170.168.13])
        by fd.dlink.ru (Postfix) with ESMTP id 506021B20153;
        Wed, 27 Nov 2019 14:44:55 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru 506021B20153
Received: from mail.rzn.dlink.ru (localhost [127.0.0.1])
        by mail.rzn.dlink.ru (Postfix) with ESMTP id E8EFB1B210B7;
        Wed, 27 Nov 2019 14:44:54 +0300 (MSK)
Received: from mail.rzn.dlink.ru (localhost [127.0.0.1])
        by mail.rzn.dlink.ru (Postfix) with ESMTPA;
        Wed, 27 Nov 2019 14:44:54 +0300 (MSK)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Wed, 27 Nov 2019 14:44:54 +0300
From:   Alexander Lobakin <alobakin@dlink.ru>
To:     Nicholas Johnson <nicholas.johnson-opensource@outlook.com.au>
Cc:     Luciano Coelho <luciano.coelho@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Edward Cree <ecree@solarflare.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Eric Dumazet <edumazet@google.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Petr Machata <petrm@mellanox.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "Kenneth R. Crudup" <kenny@panix.com>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: wireless: intel: iwlwifi: fix GRO_NORMAL packet
 stalling
In-Reply-To: <PSXP216MB04382F0BA8CE3754439EA2CC80440@PSXP216MB0438.KORP216.PROD.OUTLOOK.COM>
References: <20191127094123.18161-1-alobakin@dlink.ru>
 <7a9332bf645fbb8c9fff634a3640c092fb9b4b79.camel@intel.com>
 <c571a88c15c4a70a61cde6ca270af033@dlink.ru>
 <PSXP216MB0438B2F163C635F8B8B4AD8AA4440@PSXP216MB0438.KORP216.PROD.OUTLOOK.COM>
 <a638ab877999dbc4ded87bfaebe784f5@dlink.ru>
 <PSXP216MB04382F0BA8CE3754439EA2CC80440@PSXP216MB0438.KORP216.PROD.OUTLOOK.COM>
User-Agent: Roundcube Webmail/1.4.0
Message-ID: <d2c0caa0b14c6fddbf8155b4edbd7fcd@dlink.ru>
X-Sender: alobakin@dlink.ru
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Nicholas Johnson wrote 27.11.2019 14:16:
> On Wed, Nov 27, 2019 at 01:29:03PM +0300, Alexander Lobakin wrote:
>> Nicholas Johnson wrote 27.11.2019 13:23:
>> > Hi,
>> 
>> Hi Nicholas,
>> 
>> >  Sorry for top down reply, stuck with my phone. If it replies HTML
>> > then I am so done with Outlook client.
> 
> I am very sorry to everybody for the improper reply. It looks like it
> was HTML as vger.kernel.org told me I was spam. If anybody knows a good
> email client for kernel development for Android then I am all ears.
> 
> I went home early and I have my computer(s) now.
> 
>> >
>> >  Does my Reported-by tag apply here?
>> >
>> >  As the reporter, should I check to see that it indeed solves the
>> > issue on the original hardware setup? I can do this within two hours
>> > and give Tested-by then.
>> 
>> Oops, I'm sorry I forgot to mention you in the commit message. Let's
>> see what Dave will say, I have no problems with waiting for your test
>> results and publishing v2.
> 
> All good. :)
> 
> I tested the the patch and it works fine. Great work, the first
> hypothesis as to what the problem was is correct. It now connects to
> wireless networks without any hassles.
> 
> Reported-by: Nicholas Johnson 
> <nicholas.johnson-opensource@outlook.com.au>
> Tested-by: Nicholas Johnson 
> <nicholas.johnson-opensource@outlook.com.au>

Oh, much thanks for testing this out! I think this one will hit netdev
fixes tree soon.

> I do not understand the networking subsystem well enough to give
> Reviewed-by, yet. Hopefully in time.

I'm sure you will :)

> Thanks to everybody for handling my report.
> 
>> 
>> >  Thanks
>> >
>> >  Regards,
>> >
>> >  Nicholas
>> 
>> Regards,
>> ᚷ ᛖ ᚢ ᚦ ᚠ ᚱ
> 
> Regards,
> Nicholas

Regards,
ᚷ ᛖ ᚢ ᚦ ᚠ ᚱ
