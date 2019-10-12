Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDFA6D4F70
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 13:54:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729041AbfJLLx4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Oct 2019 07:53:56 -0400
Received: from fd.dlink.ru ([178.170.168.18]:46642 "EHLO fd.dlink.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727231AbfJLLv4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Oct 2019 07:51:56 -0400
Received: by fd.dlink.ru (Postfix, from userid 5000)
        id 944891B20983; Sat, 12 Oct 2019 14:51:52 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru 944891B20983
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dlink.ru; s=mail;
        t=1570881112; bh=GVdyMAkJoaCzEF7enJYVSyxNIEivWNJHyH4jL2SwDe8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References;
        b=R1cXAHL0FigCYkYf211zc5POTUXLGBUKygLqCdjJb0OCLYxcHzAAIjkjk1ywkK+g1
         T3iDsNnAVd8/6r/UT04PVGfoXRm/p9P6NslcMsy3mZ9VzalPDyZPU4h6uopD78ewsk
         N70f9jDbkBTYjPlnG1fjMPkUNIv+qF8Bg/d9hWSI=
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on mail.dlink.ru
X-Spam-Level: 
X-Spam-Status: No, score=-99.2 required=7.5 tests=BAYES_50,URIBL_BLOCKED,
        USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from mail.rzn.dlink.ru (mail.rzn.dlink.ru [178.170.168.13])
        by fd.dlink.ru (Postfix) with ESMTP id 388411B202D2;
        Sat, 12 Oct 2019 14:51:49 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru 388411B202D2
Received: by mail.rzn.dlink.ru (Postfix, from userid 5000)
        id 232351B21890; Sat, 12 Oct 2019 14:51:49 +0300 (MSK)
Received: from mail.rzn.dlink.ru (localhost [127.0.0.1])
        by mail.rzn.dlink.ru (Postfix) with ESMTPA id 7A6C71B2120F;
        Sat, 12 Oct 2019 14:51:41 +0300 (MSK)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Sat, 12 Oct 2019 14:51:41 +0300
From:   Alexander Lobakin <alobakin@dlink.ru>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Edward Cree <ecree@solarflare.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Petr Machata <petrm@mellanox.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 2/2] net: core: increase the default size of
 GRO_NORMAL skb lists to flush
In-Reply-To: <CANn89iLrVU2OVTj1yk4Sjd=SVxHYN-WpXeGhMEWx0DsVLz7giQ@mail.gmail.com>
References: <20191010144226.4115-1-alobakin@dlink.ru>
 <20191010144226.4115-3-alobakin@dlink.ru>
 <c2450dc3-8ee0-f7cd-4f8a-61a061989eb7@solarflare.com>
 <1eaac2e1f1d65194a4a39232d7e45870@dlink.ru>
 <3c459c84df86f79b593632d3f08d5f4c@dlink.ru>
 <CANn89iLrVU2OVTj1yk4Sjd=SVxHYN-WpXeGhMEWx0DsVLz7giQ@mail.gmail.com>
Message-ID: <c0e2778ed47c5934bb83a77c77de8dfa@dlink.ru>
X-Sender: alobakin@dlink.ru
User-Agent: Roundcube Webmail/1.3.6
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

Eric Dumazet wrote 12.10.2019 14:18:
> On Sat, Oct 12, 2019 at 2:22 AM Alexander Lobakin <alobakin@dlink.ru> 
> wrote:
> 
>> 
>> I've generated an another solution. Considering that gro_normal_batch
>> is very individual for every single case, maybe it would be better to
>> make it per-NAPI (or per-netdevice) variable rather than a global
>> across the kernel?
>> I think most of all network-capable configurations and systems has 
>> more
>> than one network device nowadays, and they might need different values
>> for achieving their bests.
>> 
>> One possible variant is:
>> 
>> #define THIS_DRIVER_GRO_NORMAL_BATCH    16
>> 
>> /* ... */
>> 
>> netif_napi_add(dev, napi, this_driver_rx_poll, NAPI_POLL_WEIGHT); /*
>> napi->gro_normal_batch will be set to the systcl value during NAPI
>> context initialization */
>> napi_set_gro_normal_batch(napi, THIS_DRIVER_GRO_NORMAL_BATCH); /* new
>> static inline helper, napi->gro_normal_batch will be set to the
>> driver-speficic value of 16 */
>> 
>> The second possible variant is to make gro_normal_batch sysctl
>> per-netdevice to tune it from userspace.
>> Or we can combine them into one to make it available for tweaking from
>> both driver and userspace, just like it's now with XPS CPUs setting.
>> 
>> If you'll find any of this reasonable and worth implementing, I'll 
>> come
>> with it in v2 after a proper testing.
> 
> Most likely the optimal tuning is also a function of the host cpu 
> caches.
> 
> Building a too big list can also lead to premature cache evictions.
> 
> Tuning the value on your test machines does not mean the value will be 
> good
> for other systems.

Oh, I missed that it might be a lot more machine-dependent than
netdevice-dependent. Thank you for explanation. The best I can do in
that case is to leave batch control in its current.
I'll publish v2 containing only the acked first part of the series on
Monday if nothing serious will happen. Addition of listified Rx to
napi_gro_receive() was the main goal anyway.

> 
> Adding yet another per device value should only be done if you 
> demonstrate
> a significant performance increase compared to the conservative value
> Edward chose.
> 
> Also the behavior can be quite different depending on the protocols,
> make sure you test handling of TCP pure ACK packets.
> 
> Accumulating 64 (in case the device uses standard NAPI_POLL_WEIGHT)
> of them before entering upper stacks seems not a good choice, since 64 
> skbs
> will need to be kept in the GRO system, compared to only 8 with Edward 
> value.

Regards,
ᚷ ᛖ ᚢ ᚦ ᚠ ᚱ
