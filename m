Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF1F72A5D5B
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 05:29:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728225AbgKDE3c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 23:29:32 -0500
Received: from mail-yb1-f194.google.com ([209.85.219.194]:36475 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727385AbgKDE3c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 23:29:32 -0500
Received: by mail-yb1-f194.google.com with SMTP id f140so16917716ybg.3;
        Tue, 03 Nov 2020 20:29:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=j1H8bjADKFf0HV60cY3jZWoO7AXzACUzFAVA6zN+pP4=;
        b=gVuTvXBgAEWgvigx/AVRXQS2U9w1KVVXwCQW7qC4jX6HJg748Hmv4V/FnZm6DAQP6d
         YsPsNys4iUS2DRbGM+4zVxsarV+Sim1IPhC2HIQX0+RD50N0Jc4+bZNxiyvOxbiagiqT
         TXL8//PUpyisatQV4NTmM4Xnx05Abcbwkl4eAlDaFfCOgdTe9+jM07qlqSGsP2WSEPqD
         VR2zUBP7n9OdGRwYhfp7PYNl9+ESko7xKCCkWkR2jIcfgMiH555yHQQ/QZIuAVX9fAwB
         TeSiZIUcm2jCNvlkA0xZx0McXUzYnPTM7wZ5aWX/uKQKzC2rFjYFhSYRHKdmFGT6NLOo
         8Niw==
X-Gm-Message-State: AOAM5336SocZaCap08DeEGpXcL9QEDhpcG66b0d6WoNJ3f75GcJjs4Xf
        II+FfT12GfZ4ijuzkCFWOEnYgi65C2Ahh+9HOKs=
X-Google-Smtp-Source: ABdhPJyqlyMXnaXMAV9bfBdbMr8H7F6FvAE4TPMuj0LDWLiAa1OMHkyJearqaIZBQBMSzHTkABXLablsYuz3nD6Hb3U=
X-Received: by 2002:a5b:c43:: with SMTP id d3mr31935441ybr.487.1604464171040;
 Tue, 03 Nov 2020 20:29:31 -0800 (PST)
MIME-Version: 1.0
References: <20201103220636.972106-1-mkl@pengutronix.de> <20201103220636.972106-6-mkl@pengutronix.de>
 <20201103172102.3d75cb96@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201103172102.3d75cb96@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Wed, 4 Nov 2020 13:29:19 +0900
Message-ID: <CAMZ6RqJyZTcqZcq6jEzm5LLM_MMe=dYDbwvv=Y+dBR0drWuFmw@mail.gmail.com>
Subject: Re: [net 05/27] can: dev: can_get_echo_skb(): prevent call to
 kfree_skb() in hard IRQ context
To:     Jakub Kicinski <kuba@kernel.org>,
        linux-can <linux-can@vger.kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kernel@pengutronix.de,
        Eric Dumazet <edumazet@google.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed. 4 Nov 2020 10:21, Jakub Kicinski wrote:
> On Tue,  3 Nov 2020 23:06:14 +0100 Marc Kleine-Budde wrote:
>> From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
>>
>> If a driver calls can_get_echo_skb() during a hardware IRQ (which is often, but
>> not always, the case), the 'WARN_ON(in_irq)' in
>> net/core/skbuff.c#skb_release_head_state() might be triggered, under network
>> congestion circumstances, together with the potential risk of a NULL pointer
>> dereference.
>>
>> The root cause of this issue is the call to kfree_skb() instead of
>> dev_kfree_skb_irq() in net/core/dev.c#enqueue_to_backlog().
>>
>> This patch prevents the skb to be freed within the call to netif_rx() by
>> incrementing its reference count with skb_get(). The skb is finally freed by
>> one of the in-irq-context safe functions: dev_consume_skb_any() or
>> dev_kfree_skb_any(). The "any" version is used because some drivers might call
>> can_get_echo_skb() in a normal context.
>>
>> The reason for this issue to occur is that initially, in the core network
>> stack, loopback skb were not supposed to be received in hardware IRQ context.
>> The CAN stack is an exception.
>>
>> This bug was previously reported back in 2017 in [1] but the proposed patch
>> never got accepted.
>>
>> While [1] directly modifies net/core/dev.c, we try to propose here a
>> smoother modification local to CAN network stack (the assumption
>> behind is that only CAN devices are affected by this issue).
>>
>> [1] http://lore.kernel.org/r/57a3ffb6-3309-3ad5-5a34-e93c3fe3614d@cetitec.com
>>
>> Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
>> Link: https://lore.kernel.org/r/20201002154219.4887-2-mailhol.vincent@wanadoo.fr
>> Fixes: 39549eef3587 ("can: CAN Network device driver and Netlink interface")
>> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
>
> Hm... Why do we receive a skb with a socket attached?
>
> At a quick glance this is some loopback, so shouldn't we skb_orphan()
> in the xmit function instead?

This is a specific feature of SocketCAN. See:
https://www.kernel.org/doc/html/latest/networking/can.html#local-loopback-of-sent-frames

By default, each socket will receive the loopback packets from other
sockets but not its own sent frames. This behaviour can be controlled
by the socket option CAN_RAW_RECV_OWN_MSGS (c.f. member 'recv_own_msg'
in 'struct raw_sok':
https://elixir.bootlin.com/linux/latest/source/net/can/raw.c#L88)

This feature requires to have the socket attached to the skb.
Orphaning the skb would break it (c.f. function raw_rcv():
https://elixir.bootlin.com/linux/latest/source/net/can/raw.c#L116).

> Otherwise we should probably fix this in enqueue_to_backlog().

To my knowledge, this issue only occurs in SocketCAN, thus the idea to
try to fix it locally. But yes, replacing kfree_skb() with
dev_kfree_skb_any() in enqueue_to_backlog() would fix the issue as
well.

>> diff --git a/drivers/net/can/dev.c b/drivers/net/can/dev.c
>> index b70ded3760f2..73cfcd7e9517 100644
>> --- a/drivers/net/can/dev.c
>> +++ b/drivers/net/can/dev.c
>> @@ -538,7 +538,11 @@ unsigned int can_get_echo_skb(struct net_device *dev, unsigned int idx)
>>       if (!skb)
>>               return 0;
>>
>> -     netif_rx(skb);
>> +     skb_get(skb);
>> +     if (netif_rx(skb) == NET_RX_SUCCESS)
>> +             dev_consume_skb_any(skb);
>> +     else
>> +             dev_kfree_skb_any(skb);
>>
>>       return len;
>>  }
>

Yours sincerely,
Vincent Mailhol
