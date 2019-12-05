Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7A95114327
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 15:59:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729662AbfLEO7O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 09:59:14 -0500
Received: from mail.dlink.ru ([178.170.168.18]:49430 "EHLO fd.dlink.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729099AbfLEO7O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Dec 2019 09:59:14 -0500
Received: by fd.dlink.ru (Postfix, from userid 5000)
        id 266FB1B2130C; Thu,  5 Dec 2019 17:59:11 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru 266FB1B2130C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dlink.ru; s=mail;
        t=1575557951; bh=KjNFJ+fpJBLEMDN29X7yO2/5Hj/TQQQOQnbnHQPMaPU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References;
        b=FBHT35gXSJaj0BgKN/jH8RITpkruadh0TgkSPrwRil5DanevqLTEH7ckjAIvtSlqN
         V6OzaqnZKdWTjTCkRQFH35r7ryV7W8pRopUcNG34XBmaFDc66TwrJ+9HWRjWaBnBtT
         Gx9ggQhG+1YrWwniVc50N9/kZ6olg5jt2Jwh/LX8=
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dlink.ru
X-Spam-Level: 
X-Spam-Status: No, score=-99.2 required=7.5 tests=BAYES_50,USER_IN_WHITELIST
        autolearn=disabled version=3.4.2
Received: from mail.rzn.dlink.ru (mail.rzn.dlink.ru [178.170.168.13])
        by fd.dlink.ru (Postfix) with ESMTP id B0BBD1B2025D;
        Thu,  5 Dec 2019 17:58:57 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru B0BBD1B2025D
Received: from mail.rzn.dlink.ru (localhost [127.0.0.1])
        by mail.rzn.dlink.ru (Postfix) with ESMTP id 687D01B2265F;
        Thu,  5 Dec 2019 17:58:57 +0300 (MSK)
Received: from mail.rzn.dlink.ru (localhost [127.0.0.1])
        by mail.rzn.dlink.ru (Postfix) with ESMTPA;
        Thu,  5 Dec 2019 17:58:57 +0300 (MSK)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Thu, 05 Dec 2019 17:58:57 +0300
From:   Alexander Lobakin <alobakin@dlink.ru>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Muciri Gatimu <muciri@openmesh.com>,
        Shashidhar Lakkavalli <shashidhar.lakkavalli@openmesh.com>,
        John Crispin <john@phrozen.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
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
In-Reply-To: <20191205140132.GD28269@lunn.ch>
References: <20191205100235.14195-1-alobakin@dlink.ru>
 <20191205125827.GA28269@lunn.ch> <2e03b82a8ec999fade26253ff35077c6@dlink.ru>
 <20191205140132.GD28269@lunn.ch>
User-Agent: Roundcube Webmail/1.4.0
Message-ID: <72a21c5f03abdc3d2d1c1bb85fd4489d@dlink.ru>
X-Sender: alobakin@dlink.ru
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrew Lunn wrote 05.12.2019 17:01:
>> Hi,
>> 
>> > What i'm missing here is an explanation why the flow dissector is
>> > called here if the protocol is already set? It suggests there is a
>> > case when the protocol is not correctly set, and we do need to look
>> > into the frame?
>> 
>> If we have a device with multiple Tx queues, but XPS is not configured
>> or system is running on uniprocessor system, then networking core code
>> selects Tx queue depending on the flow to utilize as much Tx queues as
>> possible but without breaking frames order.
>> This selection happens in net/core/dev.c:skb_tx_hash() as:
>> 
>> reciprocal_scale(skb_get_hash(skb), qcount)
>> 
>> where 'qcount' is the total number of Tx queues on the network device.
>> 
>> If skb has not been hashed prior to this line, then skb_get_hash() 
>> will
>> call flow dissector to generate a new hash. That's why flow dissection
>> can occur on Tx path.
> 
> 
> Hi Alexander
> 
> So it looks like you are now skipping this hash. Which in your
> testing, give better results, because the protocol is already set
> correctly. But are there cases when the protocol is not set correctly?
> We really do need to look into the frame?

Actually no, I'm not skipping the entire hashing, I'm only skipping
tag_ops->flow_dissect() (helper that only alters network offset and
replaces fake ETH_P_XDSA with the actual protocol) call on Tx path,
because this only breaks flow dissection logics. All skbs are still
processed and hashed by the generic code that goes after that call.

> How about when an outer header has just been removed? The frame was
> received on a GRE tunnel, the GRE header has just been removed, and
> now the frame is on its way out? Is the protocol still GRE, and we
> should look into the frame to determine if it is IPv4, ARP etc?
> 
> Your patch looks to improve things for the cases you have tested, but
> i'm wondering if there are other use cases where we really do need to
> look into the frame? In which case, your fix is doing the wrong thing.
> Should we be extending the tagger to handle the TX case as well as the
> RX case?

We really have two options: don't call tag_ops->flow_dissect() on Tx
(this patch), or extend tagger callbacks to handle Tx path too. I was
using both of this for several months each and couldn't detect cases
where the first one was worse than the second.
I mean, there _might_ be such cases in theory, and if they will appear
we should extend our taggers. But for now I don't see the necessity to
do this as generic flow dissection logics works as expected after this
patch and is completely broken without it.
And remember that we have the reverse logic on Tx and all skbs are
firstly queued on slave netdevice and only then on master/CPU port.

It would be nice to see what other people think about it anyways.

>    Andrew

Regards,
ᚷ ᛖ ᚢ ᚦ ᚠ ᚱ
