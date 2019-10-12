Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14807D4E90
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 11:24:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729087AbfJLJYh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Oct 2019 05:24:37 -0400
Received: from mail.dlink.ru ([178.170.168.18]:35580 "EHLO fd.dlink.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728882AbfJLJWh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Oct 2019 05:22:37 -0400
Received: by fd.dlink.ru (Postfix, from userid 5000)
        id 0F48C1B219EC; Sat, 12 Oct 2019 12:22:33 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru 0F48C1B219EC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dlink.ru; s=mail;
        t=1570872153; bh=iz4isrGMNy+Zh++q05GgOWAhVnORimqaqiBMYJJA23U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References;
        b=ivUyIbhesze5o1wD3jzYFlxtjVYvzkDVd4U1+a9LTj+Fr+gP6uEY4yCeAyRvdimp6
         4weqrXnketwoBCtBTtJW3Vvob4qsotF1ow1xzhjP6XtVp+T1L7cRmA6yk109iPGQv7
         dmWA+AqKAcccPdZ8tIbZ+YASYsjE7kH4GibWOzlA=
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on mail.dlink.ru
X-Spam-Level: 
X-Spam-Status: No, score=-99.2 required=7.5 tests=BAYES_50,URIBL_BLOCKED,
        USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from mail.rzn.dlink.ru (mail.rzn.dlink.ru [178.170.168.13])
        by fd.dlink.ru (Postfix) with ESMTP id AE7FA1B20B0D;
        Sat, 12 Oct 2019 12:22:29 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru AE7FA1B20B0D
Received: by mail.rzn.dlink.ru (Postfix, from userid 5000)
        id 91B0F1B21890; Sat, 12 Oct 2019 12:22:29 +0300 (MSK)
Received: from mail.rzn.dlink.ru (localhost [127.0.0.1])
        by mail.rzn.dlink.ru (Postfix) with ESMTPA id 4DE361B2023E;
        Sat, 12 Oct 2019 12:22:20 +0300 (MSK)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Sat, 12 Oct 2019 12:22:20 +0300
From:   Alexander Lobakin <alobakin@dlink.ru>
To:     Edward Cree <ecree@solarflare.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Eric Dumazet <edumazet@google.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Petr Machata <petrm@mellanox.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] net: core: increase the default size of
 GRO_NORMAL skb lists to flush
In-Reply-To: <1eaac2e1f1d65194a4a39232d7e45870@dlink.ru>
References: <20191010144226.4115-1-alobakin@dlink.ru>
 <20191010144226.4115-3-alobakin@dlink.ru>
 <c2450dc3-8ee0-f7cd-4f8a-61a061989eb7@solarflare.com>
 <1eaac2e1f1d65194a4a39232d7e45870@dlink.ru>
Message-ID: <3c459c84df86f79b593632d3f08d5f4c@dlink.ru>
X-Sender: alobakin@dlink.ru
User-Agent: Roundcube Webmail/1.3.6
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexander Lobakin wrote 11.10.2019 10:23:
> Hi Edward,
> 
> Edward Cree wrote 10.10.2019 21:16:
>> On 10/10/2019 15:42, Alexander Lobakin wrote:
>>> Commit 323ebb61e32b ("net: use listified RX for handling GRO_NORMAL
>>> skbs") have introduced a sysctl variable gro_normal_batch for 
>>> defining
>>> a limit for listified Rx of GRO_NORMAL skbs. The initial value of 8 
>>> is
>>> purely arbitrary and has been chosen, I believe, as a minimal safe
>>> default.
>> 8 was chosen by performance tests on my setup with v1 of that patch;
>>  see https://www.spinics.net/lists/netdev/msg585001.html .
>> Sorry for not including that info in the final version of the patch.
>> While I didn't re-do tests on varying gro_normal_batch on the final
>>  version, I think changing it needs more evidence than just "we tested
>>  it; it's better".  In particular, increasing the batch size should be
>>  accompanied by demonstration that latency isn't increased in e.g. a
>>  multi-stream ping-pong test.
>> 
>>> However, several tests show that it's rather suboptimal and doesn't
>>> allow to take a full advantage of listified processing. The best and
>>> the most balanced results have been achieved with a batches of 16 
>>> skbs
>>> per flush.
>>> So double the default value to give a yet another boost for Rx path.
>> 
>>> It remains configurable via sysctl anyway, so may be fine-tuned for
>>> each hardware.
>> I see this as a reason to leave the default as it is; the combination
>>  of your tests and mine have established that the optimal size does
>>  vary (I found 16 to be 2% slower than 8 with my setup), so any
>>  tweaking of the default is likely only worthwhile if we have data
>>  over lots of different hardware combinations.
> 
> Agree, if you've got slower results on 16, we must leave the default
> value, as it seems to be VERY hardware- and driver- dependent.
> So, patch 2/2 is not actual any more (I supposed that it would likely
> go away before sending this series).

I've generated an another solution. Considering that gro_normal_batch
is very individual for every single case, maybe it would be better to
make it per-NAPI (or per-netdevice) variable rather than a global
across the kernel?
I think most of all network-capable configurations and systems has more
than one network device nowadays, and they might need different values
for achieving their bests.

One possible variant is:

#define THIS_DRIVER_GRO_NORMAL_BATCH	16

/* ... */

netif_napi_add(dev, napi, this_driver_rx_poll, NAPI_POLL_WEIGHT); /*
napi->gro_normal_batch will be set to the systcl value during NAPI
context initialization */
napi_set_gro_normal_batch(napi, THIS_DRIVER_GRO_NORMAL_BATCH); /* new
static inline helper, napi->gro_normal_batch will be set to the
driver-speficic value of 16 */

The second possible variant is to make gro_normal_batch sysctl
per-netdevice to tune it from userspace.
Or we can combine them into one to make it available for tweaking from
both driver and userspace, just like it's now with XPS CPUs setting.

If you'll find any of this reasonable and worth implementing, I'll come
with it in v2 after a proper testing.

> 
>>> Signed-off-by: Alexander Lobakin <alobakin@dlink.ru>
>>> ---
>>>  net/core/dev.c | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>> 
>>> diff --git a/net/core/dev.c b/net/core/dev.c
>>> index a33f56b439ce..4f60444bb766 100644
>>> --- a/net/core/dev.c
>>> +++ b/net/core/dev.c
>>> @@ -4189,7 +4189,7 @@ int dev_weight_tx_bias __read_mostly = 1;  /* 
>>> bias for output_queue quota */
>>>  int dev_rx_weight __read_mostly = 64;
>>>  int dev_tx_weight __read_mostly = 64;
>>>  /* Maximum number of GRO_NORMAL skbs to batch up for list-RX */
>>> -int gro_normal_batch __read_mostly = 8;
>>> +int gro_normal_batch __read_mostly = 16;
>>> 
>>>  /* Called with irq disabled */
>>>  static inline void ____napi_schedule(struct softnet_data *sd,
> 
> Regards,
> ᚷ ᛖ ᚢ ᚦ ᚠ ᚱ

Regards,
ᚷ ᛖ ᚢ ᚦ ᚠ ᚱ
