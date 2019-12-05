Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C35311418B
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 14:34:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729396AbfLENei (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 08:34:38 -0500
Received: from mail.dlink.ru ([178.170.168.18]:40510 "EHLO fd.dlink.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729099AbfLENei (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Dec 2019 08:34:38 -0500
Received: by fd.dlink.ru (Postfix, from userid 5000)
        id 8B1221B21254; Thu,  5 Dec 2019 16:34:35 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru 8B1221B21254
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dlink.ru; s=mail;
        t=1575552875; bh=Sx8uJ3OCnuaKMNarVXnFV4HiDAvI2m8fmjUZHnprhIU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References;
        b=MPyjy2a0YkoSIcF7ZAHzBW2/DwSF371h3Bk1ovMWCsvhB+swr5yVnp4L3Rt793TXQ
         /4yQbJLhkJa69VM5cDmLtDr7KdSMzvH1IzwA6GStwtsDSr5YUy6RVldc7OTlNtoP4+
         wUvWq4YXFkA0z4vgkQrCeNAlsXBnUZlOuNudPEeg=
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dlink.ru
X-Spam-Level: 
X-Spam-Status: No, score=-99.2 required=7.5 tests=BAYES_50,USER_IN_WHITELIST
        autolearn=disabled version=3.4.2
Received: from mail.rzn.dlink.ru (mail.rzn.dlink.ru [178.170.168.13])
        by fd.dlink.ru (Postfix) with ESMTP id 0BA591B2010A;
        Thu,  5 Dec 2019 16:34:24 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru 0BA591B2010A
Received: from mail.rzn.dlink.ru (localhost [127.0.0.1])
        by mail.rzn.dlink.ru (Postfix) with ESMTP id AE0621B217D8;
        Thu,  5 Dec 2019 16:34:23 +0300 (MSK)
Received: from mail.rzn.dlink.ru (localhost [127.0.0.1])
        by mail.rzn.dlink.ru (Postfix) with ESMTPA;
        Thu,  5 Dec 2019 16:34:23 +0300 (MSK)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Thu, 05 Dec 2019 16:34:23 +0300
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
In-Reply-To: <20191205125827.GA28269@lunn.ch>
References: <20191205100235.14195-1-alobakin@dlink.ru>
 <20191205125827.GA28269@lunn.ch>
User-Agent: Roundcube Webmail/1.4.0
Message-ID: <2e03b82a8ec999fade26253ff35077c6@dlink.ru>
X-Sender: alobakin@dlink.ru
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrew Lunn wrote 05.12.2019 15:58:
> On Thu, Dec 05, 2019 at 01:02:35PM +0300, Alexander Lobakin wrote:
>> Commit 43e665287f93 ("net-next: dsa: fix flow dissection") added an
>> ability to override protocol and network offset during flow dissection
>> for DSA-enabled devices (i.e. controllers shipped as switch CPU ports)
>> in order to fix skb hashing for RPS on Rx path.
>> 
>> However, skb_hash() and added part of code can be invoked not only on
>> Rx, but also on Tx path if we have a multi-queued device and:
>>  - kernel is running on UP system or
>>  - XPS is not configured.
>> 
>> The call stack in this two cases will be like: dev_queue_xmit() ->
>> __dev_queue_xmit() -> netdev_core_pick_tx() -> netdev_pick_tx() ->
>> skb_tx_hash() -> skb_get_hash().
>> 
>> The problem is that skbs queued for Tx have both network offset and
>> correct protocol already set up even after inserting a CPU tag by DSA
>> tagger, so calling tag_ops->flow_dissect() on this path actually only
>> breaks flow dissection and hashing.
> 
> Hi Alexander

Hi,

> What i'm missing here is an explanation why the flow dissector is
> called here if the protocol is already set? It suggests there is a
> case when the protocol is not correctly set, and we do need to look
> into the frame?

If we have a device with multiple Tx queues, but XPS is not configured
or system is running on uniprocessor system, then networking core code
selects Tx queue depending on the flow to utilize as much Tx queues as
possible but without breaking frames order.
This selection happens in net/core/dev.c:skb_tx_hash() as:

reciprocal_scale(skb_get_hash(skb), qcount)

where 'qcount' is the total number of Tx queues on the network device.

If skb has not been hashed prior to this line, then skb_get_hash() will
call flow dissector to generate a new hash. That's why flow dissection
can occur on Tx path.

>      Andrew

Regards,
ᚷ ᛖ ᚢ ᚦ ᚠ ᚱ
