Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA776138DDA
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 10:30:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728721AbgAMJaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 04:30:24 -0500
Received: from fd.dlink.ru ([178.170.168.18]:52132 "EHLO fd.dlink.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725992AbgAMJaX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jan 2020 04:30:23 -0500
Received: by fd.dlink.ru (Postfix, from userid 5000)
        id D580E1B214D6; Mon, 13 Jan 2020 12:30:20 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru D580E1B214D6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dlink.ru; s=mail;
        t=1578907820; bh=ay0aQdubfRd2z0EzjvG25Fck9nkLxv3o/IS7a8ekqDc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References;
        b=bGqnuwxbo0Z07sOYtv9NUXBctnRgbn7nlabKLezk3u4M46bLYz7z9E6ySDnUpTWMZ
         Ezwe/0ZWB6UgSVedSes8EerOVLi70PFeujrQSEqsZJjOB/rMRcy+0gc9E7jce0wj47
         gC4dSYDAHBLi17t9IhWDm9gDK7btRMzc9ex8AXt0=
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dlink.ru
X-Spam-Level: 
X-Spam-Status: No, score=-99.2 required=7.5 tests=BAYES_50,URIBL_BLOCKED,
        USER_IN_WHITELIST autolearn=disabled version=3.4.2
Received: from mail.rzn.dlink.ru (mail.rzn.dlink.ru [178.170.168.13])
        by fd.dlink.ru (Postfix) with ESMTP id CCEA41B20968;
        Mon, 13 Jan 2020 12:30:07 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru CCEA41B20968
Received: from mail.rzn.dlink.ru (localhost [127.0.0.1])
        by mail.rzn.dlink.ru (Postfix) with ESMTP id 2FC251B2613E;
        Mon, 13 Jan 2020 12:30:07 +0300 (MSK)
Received: from mail.rzn.dlink.ru (localhost [127.0.0.1])
        by mail.rzn.dlink.ru (Postfix) with ESMTPA;
        Mon, 13 Jan 2020 12:30:07 +0300 (MSK)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Mon, 13 Jan 2020 12:30:06 +0300
From:   Alexander Lobakin <alobakin@dlink.ru>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Edward Cree <ecree@solarflare.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Sean Wang <sean.wang@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Stanislav Fomichev <sdf@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>,
        Matteo Croce <mcroce@redhat.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Paul Blakey <paulb@mellanox.com>,
        Yoshiki Komachi <komachi.yoshiki@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH RFC net-next 00/20] net: dsa: add GRO support
In-Reply-To: <CA+h21hq95SmS3BraUQeEytP+3Y7irmShBEwpXqqJv+xOp4ePrg@mail.gmail.com>
References: <20191230143028.27313-1-alobakin@dlink.ru>
 <CA+h21hq95SmS3BraUQeEytP+3Y7irmShBEwpXqqJv+xOp4ePrg@mail.gmail.com>
User-Agent: Roundcube Webmail/1.4.0
Message-ID: <607283965483d3bc3c0e969b1fadf540@dlink.ru>
X-Sender: alobakin@dlink.ru
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vladimir Oltean wrote 31.12.2019 18:32:
> Hi Alexander,

Hi,

> On Mon, 30 Dec 2019 at 16:31, Alexander Lobakin <alobakin@dlink.ru> 
> wrote:
>> 
>> I mark this as RFC, and there are the key questions for maintainers,
>> developers, users etc.:
>> - Do we need GRO support for DSA at all?
>> - Which tagger protocols really need it and which don't?
>> - Does this series bring any performance improvements on the
>>   affected systems?
> 
> If these are these questions for maintainers, developers, users etc,
> then what has determined you to make these changes?

The main reason was obviously pretty good results on a particular
hardware on which I developed this (and other) series and a general
opinion that GRO improves overall performance on most systems.
DSA is a special case though.

> Thanks,
> -Vladimir

Regards,
ᚷ ᛖ ᚢ ᚦ ᚠ ᚱ
