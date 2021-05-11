Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 960B537B16E
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 00:11:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbhEKWMz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 18:12:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbhEKWMy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 18:12:54 -0400
Received: from warlock.wand.net.nz (warlock.cms.waikato.ac.nz [IPv6:2001:df0:4:4000::250:15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF2A5C061574
        for <netdev@vger.kernel.org>; Tue, 11 May 2021 15:11:47 -0700 (PDT)
Received: from [209.85.215.179] (helo=mail-pg1-f179.google.com)
        by warlock.wand.net.nz with esmtpsa (TLS1.2:RSA_AES_128_CBC_SHA1:128)
        (Exim 4.84_2)
        (envelope-from <rsanger@wand.net.nz>)
        id 1lgabO-0002QF-Pw
        for netdev@vger.kernel.org; Wed, 12 May 2021 10:11:43 +1200
Received: by mail-pg1-f179.google.com with SMTP id s22so16737295pgk.6
        for <netdev@vger.kernel.org>; Tue, 11 May 2021 15:11:41 -0700 (PDT)
X-Gm-Message-State: AOAM532h3MhWEdl8Mu79RcZ06d1vA4aF8lbnXWBQQNnpstECxIcP1/2z
        D+SmFsCkCt66GcdKQO8qs/V6l7HDNErHTmgLR4o=
X-Google-Smtp-Source: ABdhPJwuOSl+xLclShilt3RbNRaFQlhPoUcLvfZ3Cp1C7AsXc0FGBttUpbRFKKFnhp5I5fVw0VQo16uGag3tZw6EemI=
X-Received: by 2002:aa7:908c:0:b029:209:aacd:d8b with SMTP id
 i12-20020aa7908c0000b0290209aacd0d8bmr33010449pfa.74.1620771099811; Tue, 11
 May 2021 15:11:39 -0700 (PDT)
MIME-Version: 1.0
References: <1620085579-5646-1-git-send-email-rsanger@wand.net.nz>
 <CA+FuTSeDTYMZzT3n3tfm9KPCRx_ObWU-HaU4JxZCSCm_8sf2XA@mail.gmail.com>
 <CAN6QFNzj9+Y3W2eYTpHzVVjy_sYN+9d_Sa99HgQ0KgKyNmpeNw@mail.gmail.com>
 <CA+FuTSfE9wW55BbYRWNE1=XYAjG7gKVLLLbfAvB-4F+dL=8gHA@mail.gmail.com>
 <CAN6QFNw9xx0F35RNxDJS-4xbYu4SdU=XND=_dqCkGJgdNj5Hqw@mail.gmail.com> <CA+FuTSc=x6bG5O7mveAuNc6EXq3TdiD+nNYYp9rfiZ3frfGziA@mail.gmail.com>
In-Reply-To: <CA+FuTSc=x6bG5O7mveAuNc6EXq3TdiD+nNYYp9rfiZ3frfGziA@mail.gmail.com>
From:   Richard Sanger <rsanger@wand.net.nz>
Date:   Wed, 12 May 2021 10:11:28 +1200
X-Gmail-Original-Message-ID: <CAN6QFNyHep+UGjM7XpA4akbtvZFNDarVcs3=zZPpYO7RMTJgHg@mail.gmail.com>
Message-ID: <CAN6QFNyHep+UGjM7XpA4akbtvZFNDarVcs3=zZPpYO7RMTJgHg@mail.gmail.com>
Subject: Re: [PATCH] net: packetmmap: fix only tx timestamp on request
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Received-SPF: softfail client-ip=209.85.215.179; envelope-from=rsanger@wand.net.nz; helo=mail-pg1-f179.google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I've had a chance to look into this further and have found where the
timestamp is added. Details are at the end of this message.

On Thu, May 6, 2021 at 1:23 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Wed, May 5, 2021 at 7:42 PM Richard Sanger <rsanger@wand.net.nz> wrote:
[...]
> >
> > I've just verified using printk() that after the call to skb_tx_timestamp(skb)
> > in veth_xmit() skb->tstamp == 0 as expected.
> >
> > However, when skb_tx_timestamp() is called within the packetmmap code path
> > skb->tstamp holds a valid time.
>
> Interesting. I had expected veth_xmit to trigger skb_orphan, which
> calls the destructor.
>
> But this is no longer true as of commit 9c4c325252c5 ("skbuff:
> preserve sock reference when scrubbing the skb.").
>
> As a result, I suppose the skb can enter the next namespace and be
> timestamped there if receive timestamps are enabled (this is not
> per-socket).
>
> One way to verify, if you can easily recompile a kernel, is to add a
> WARN_ON_ONCE(1) to tpacket_destruct_skb to see which path led up to
> queuing the completion notification.
>

Here's the output of putting a WARN_ON_ONCE(1) statement in
tpacket_destruct_skb, I don't believe it is related to the problem.

[   37.249629] RIP: 0010:tpacket_destruct_skb+0x24/0x60
[...]
[   37.249659] Call Trace:
[   37.249661]  <IRQ>
[   37.249666]  skb_release_head_state+0x44/0x90
[   37.249680]  skb_release_all+0x13/0x30
[   37.249684]  kfree_skb+0x2f/0xa0
[   37.249689]  llc_rcv+0x2e/0x360 [llc]
[   37.249698]  __netif_receive_skb_one_core+0x8f/0xa0
[   37.249707]  __netif_receive_skb+0x18/0x60
[   37.249710]  process_backlog+0xa9/0x160
[   37.249714]  __napi_poll+0x31/0x140
[   37.249717]  net_rx_action+0xde/0x210
[   37.249722]  __do_softirq+0xe0/0x29b
[   37.249737]  do_softirq+0x66/0x80
[   37.249747]  </IRQ>
[   37.249748]  __local_bh_enable_ip+0x50/0x60
[   37.249751]  __dev_queue_xmit+0x23a/0x6e0
[   37.249756]  dev_queue_xmit+0x10/0x20
[   37.249759]  packet_sendmsg+0x6b8/0x1c90
[   37.249763]  ? __drain_all_pages+0x150/0x1c0
[   37.249772]  sock_sendmsg+0x65/0x70
[   37.249778]  __sys_sendto+0x113/0x190
[   37.249783]  ? handle_mm_fault+0xda/0x2b0
[   37.249790]  ? exit_to_user_mode_prepare+0x3c/0x1e0
[   37.249800]  ? do_user_addr_fault+0x1d3/0x640
[   37.249805]  __x64_sys_sendto+0x29/0x30
[   37.249809]  do_syscall_64+0x40/0xb0
[   37.249816]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[   37.249820] RIP: 0033:0x7f43950d27ea

[...]

> I think we need to understand exactly what goes on before we apply a
> patch. It might just be papering over the problem otherwise.

Okay, so the call path that adds the timestamp looks like this:

send() syscall triggers tpacket_snd() which calls the veth_xmit() hander.
In drivers/net/veth.c veth_xmit() calls veth_forward_skb() which then
calls netif_rx()/netif_rx_internal() in net/core/dev.c.
And finally, net_timestamp_check(netdev_tstamp_prequeue, skb) adds
the timestamp, netdev_tstamp_prequeue defaults to 1.

net_timestamp_check in its current form was added by 588f033075
("net: use jump_label for netstamp_needed ")
In the kernel since 3.3-rc1, so it looks like this issue has been present the
entire time. Pre-conditions are netstamp_needed_key and
netdev_tstamp_prequeue, so if either is false, timestamping won't happen
at this stage in the code.

Here's the call trace of where the timestamp is added

[  251.619538] Call Trace:
[  251.619550]  netif_rx+0x1b/0x60
[  251.619556]  veth_xmit+0x19d/0x230 [veth]
[  251.619563]  netdev_start_xmit+0x4a/0x8b
[  251.619566]  dev_hard_start_xmit.cold+0xc8/0x1d5
[  251.619569]  __dev_queue_xmit.cold+0xa3/0x12c
[  251.619572]  dev_queue_xmit+0x10/0x20
[  251.619575]  packet_sendmsg+0x6b8/0x1c90
[  251.619580]  ? __drain_all_pages+0x150/0x1c0
[  251.619588]  sock_sendmsg+0x65/0x70
[  251.619594]  __sys_sendto+0x113/0x190
[  251.619598]  ? handle_mm_fault+0xda/0x2b0
[  251.619604]  ? exit_to_user_mode_prepare+0x3c/0x1e0
[  251.619611]  ? do_user_addr_fault+0x1d3/0x640
[  251.619615]  __x64_sys_sendto+0x29/0x30
[  251.619618]  do_syscall_64+0x40/0xb0
[  251.619623]  entry_SYSCALL_64_after_hwframe+0x44/0xae

This appears to be reasonable, but I don't know what the expected behaviour
is. Should this timestamp still be cleared before returning the sent skb?
