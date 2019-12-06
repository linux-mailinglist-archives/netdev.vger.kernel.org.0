Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05E98114CAE
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 08:37:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726421AbfLFHhr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Dec 2019 02:37:47 -0500
Received: from mail.dlink.ru ([178.170.168.18]:42090 "EHLO fd.dlink.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726184AbfLFHhq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Dec 2019 02:37:46 -0500
Received: by fd.dlink.ru (Postfix, from userid 5000)
        id 050001B214D2; Fri,  6 Dec 2019 10:37:43 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru 050001B214D2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dlink.ru; s=mail;
        t=1575617864; bh=Au2fc/AWkb3xBjkPZdnApOwUFi8kXkwwYCBQ06Wg7qc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References;
        b=rnQoWc4b7+17JT9/ugB67EsYY1h3IRiasuPuddiWtUUMu9RZr94qT1E8BVtXe2jDs
         ghjo1e4W2s9s1xhEQfNJvXRJLPDQed2FxPwwItF5YHdfghffojDCWMUZNuy9RPXbKi
         8PFtvT0vYM70QRSQTb7SxEI/RkvjdIahLN1eRhzA=
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dlink.ru
X-Spam-Level: 
X-Spam-Status: No, score=-99.2 required=7.5 tests=BAYES_50,USER_IN_WHITELIST
        autolearn=disabled version=3.4.2
Received: from mail.rzn.dlink.ru (mail.rzn.dlink.ru [178.170.168.13])
        by fd.dlink.ru (Postfix) with ESMTP id 585151B20144;
        Fri,  6 Dec 2019 10:37:27 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru 585151B20144
Received: from mail.rzn.dlink.ru (localhost [127.0.0.1])
        by mail.rzn.dlink.ru (Postfix) with ESMTP id CD9B41B22974;
        Fri,  6 Dec 2019 10:37:26 +0300 (MSK)
Received: from mail.rzn.dlink.ru (localhost [127.0.0.1])
        by mail.rzn.dlink.ru (Postfix) with ESMTPA;
        Fri,  6 Dec 2019 10:37:26 +0300 (MSK)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Fri, 06 Dec 2019 10:37:26 +0300
From:   Alexander Lobakin <alobakin@dlink.ru>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Muciri Gatimu <muciri@openmesh.com>,
        Shashidhar Lakkavalli <shashidhar.lakkavalli@openmesh.com>,
        John Crispin <john@phrozen.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Stanislav Fomichev <sdf@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Matteo Croce <mcroce@redhat.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Eric Dumazet <edumazet@google.com>,
        Paul Blakey <paulb@mellanox.com>,
        Yoshiki Komachi <komachi.yoshiki@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: dsa: fix flow dissection on Tx path
In-Reply-To: <3cc7a0c3-4eeb-52d5-1777-f646329a9303@gmail.com>
References: <20191205100235.14195-1-alobakin@dlink.ru>
 <20191205125827.GA28269@lunn.ch> <2e03b82a8ec999fade26253ff35077c6@dlink.ru>
 <20191205140132.GD28269@lunn.ch> <72a21c5f03abdc3d2d1c1bb85fd4489d@dlink.ru>
 <3cc7a0c3-4eeb-52d5-1777-f646329a9303@gmail.com>
User-Agent: Roundcube Webmail/1.4.0
Message-ID: <5e108291220110b10fdf0c88f8894fdb@dlink.ru>
X-Sender: alobakin@dlink.ru
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Florian Fainelli wrote 06.12.2019 06:32:
> On 12/5/2019 6:58 AM, Alexander Lobakin wrote:
>> Andrew Lunn wrote 05.12.2019 17:01:
>>>> Hi,
>>>> 
>>>> > What i'm missing here is an explanation why the flow dissector is
>>>> > called here if the protocol is already set? It suggests there is a
>>>> > case when the protocol is not correctly set, and we do need to look
>>>> > into the frame?
>>>> 
>>>> If we have a device with multiple Tx queues, but XPS is not 
>>>> configured
>>>> or system is running on uniprocessor system, then networking core 
>>>> code
>>>> selects Tx queue depending on the flow to utilize as much Tx queues 
>>>> as
>>>> possible but without breaking frames order.
>>>> This selection happens in net/core/dev.c:skb_tx_hash() as:
>>>> 
>>>> reciprocal_scale(skb_get_hash(skb), qcount)
>>>> 
>>>> where 'qcount' is the total number of Tx queues on the network 
>>>> device.
>>>> 
>>>> If skb has not been hashed prior to this line, then skb_get_hash() 
>>>> will
>>>> call flow dissector to generate a new hash. That's why flow 
>>>> dissection
>>>> can occur on Tx path.
>>> 
>>> 
>>> Hi Alexander
>>> 
>>> So it looks like you are now skipping this hash. Which in your
>>> testing, give better results, because the protocol is already set
>>> correctly. But are there cases when the protocol is not set 
>>> correctly?
>>> We really do need to look into the frame?
>> 
>> Actually no, I'm not skipping the entire hashing, I'm only skipping
>> tag_ops->flow_dissect() (helper that only alters network offset and
>> replaces fake ETH_P_XDSA with the actual protocol) call on Tx path,
>> because this only breaks flow dissection logics. All skbs are still
>> processed and hashed by the generic code that goes after that call.
>> 
>>> How about when an outer header has just been removed? The frame was
>>> received on a GRE tunnel, the GRE header has just been removed, and
>>> now the frame is on its way out? Is the protocol still GRE, and we
>>> should look into the frame to determine if it is IPv4, ARP etc?
>>> 
>>> Your patch looks to improve things for the cases you have tested, but
>>> i'm wondering if there are other use cases where we really do need to
>>> look into the frame? In which case, your fix is doing the wrong 
>>> thing.
>>> Should we be extending the tagger to handle the TX case as well as 
>>> the
>>> RX case?
>> 
>> We really have two options: don't call tag_ops->flow_dissect() on Tx
>> (this patch), or extend tagger callbacks to handle Tx path too. I was
>> using both of this for several months each and couldn't detect cases
>> where the first one was worse than the second.
>> I mean, there _might_ be such cases in theory, and if they will appear
>> we should extend our taggers. But for now I don't see the necessity to
>> do this as generic flow dissection logics works as expected after this
>> patch and is completely broken without it.
>> And remember that we have the reverse logic on Tx and all skbs are
>> firstly queued on slave netdevice and only then on master/CPU port.
>> 
>> It would be nice to see what other people think about it anyways.
> 
> Your patch seems appropriate to me and quite frankly I am not sure why
> flow dissection on RX is done at the DSA master device level, where we
> have not parsed the DSA tag yet, instead of being done at the DSA slave
> network device level. It seems to me that if the DSA master has N RX
> queues, we should be creating the DSA slave devices with the same 
> amount
> of RX queues and perform RPS there against a standard Ethernet frame
> (sans DSA tag).
> 
> For TX the story is a little different because we can have multiqueue
> DSA slave network devices in order to steer traffic towards particular
> switch queues and we could do XPS there that way.
> 
> What do you think?

Hi Florian,

First of all, thank you for the "Reviewed-by"!

I agree with you that all the network stack processing should be
performed on standard frames without CPU tags and on corresponding
slave netdevices. So I think we really should think about extending
DSA core code to create slaves with at least as many Rx queues as
master device have. With this done we could remove .flow_dissect()
callback from DSA taggers entirely and simplify traffic flow.

Also, if we get back to Tx processing, number of Tx queues on slaves
should be equal to number of queues on switch inself in ideal case.
Maybe we should then apply this rule to Rx queues too, i.e. create
slaves with the number of Rx queues that switch has?

(for example, I'm currently working with the switches that have 8 Rxqs
and 8 Txqs, but their Ethernet controlers / CPU ports have only 4/4)

Regards,
ᚷ ᛖ ᚢ ᚦ ᚠ ᚱ
