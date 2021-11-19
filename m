Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1918456E3A
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 12:32:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235104AbhKSLdw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 06:33:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232685AbhKSLdw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Nov 2021 06:33:52 -0500
Received: from forwardcorp1o.mail.yandex.net (forwardcorp1o.mail.yandex.net [IPv6:2a02:6b8:0:1a2d::193])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CEFEC06173E;
        Fri, 19 Nov 2021 03:30:49 -0800 (PST)
Received: from iva8-d2cd82b7433e.qloud-c.yandex.net (iva8-d2cd82b7433e.qloud-c.yandex.net [IPv6:2a02:6b8:c0c:a88e:0:640:d2cd:82b7])
        by forwardcorp1o.mail.yandex.net (Yandex) with ESMTP id C791E2E0A87;
        Fri, 19 Nov 2021 14:30:33 +0300 (MSK)
Received: from iva8-3a65cceff156.qloud-c.yandex.net (iva8-3a65cceff156.qloud-c.yandex.net [2a02:6b8:c0c:2d80:0:640:3a65:ccef])
        by iva8-d2cd82b7433e.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id EKjSaatRh8-UVsKQDuU;
        Fri, 19 Nov 2021 14:30:33 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.com; s=default;
        t=1637321433; bh=+L4v8jYAJNvQOeZwWnjjVUETCxcUIlwbJiPy76hhiGc=;
        h=In-Reply-To:References:Date:From:To:Subject:Message-ID:Cc;
        b=Phv9LjoFFPfzg/431KWrbeNCQFLqyLJhk/LLMH/jjKMCp8+b/rNNVD0iKobQ9uoJ1
         hfcn8C6+99r/xm/4ny0nG5U+2LsryFeG3pHjk/xF9no1EHF6SnNipN4l6UZ1dwThJy
         fcM/1euZs3NwnsyPmy196HLvoJdnkZql40r9r0oY=
Authentication-Results: iva8-d2cd82b7433e.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.com
Received: from [IPv6:2a02:6b8:0:107:3e85:844d:5b1d:60a] (dynamic-red3.dhcp.yndx.net [2a02:6b8:0:107:3e85:844d:5b1d:60a])
        by iva8-3a65cceff156.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPS id WlImvNE7yL-UUwSObAb;
        Fri, 19 Nov 2021 14:30:31 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
X-Yandex-Fwd: 2
Subject: Re: [PATCH 6/6] vhost_net: use RCU callbacks instead of
 synchronize_rcu()
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        kvm <kvm@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, bpf@vger.kernel.org
References: <20211115153003.9140-1-arbn@yandex-team.com>
 <20211115153003.9140-6-arbn@yandex-team.com>
 <CACGkMEumax9RFVNgWLv5GyoeQAmwo-UgAq=DrUd4yLxPAUUqBw@mail.gmail.com>
From:   Andrey Ryabinin <arbn@yandex-team.com>
Message-ID: <b163233f-090f-baaf-4460-37978cab4d55@yandex-team.com>
Date:   Fri, 19 Nov 2021 14:32:05 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <CACGkMEumax9RFVNgWLv5GyoeQAmwo-UgAq=DrUd4yLxPAUUqBw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/16/21 8:00 AM, Jason Wang wrote:
> On Mon, Nov 15, 2021 at 11:32 PM Andrey Ryabinin <arbn@yandex-team.com> wrote:
>>
>> Currently vhost_net_release() uses synchronize_rcu() to synchronize
>> freeing with vhost_zerocopy_callback(). However synchronize_rcu()
>> is quite costly operation. It take more than 10 seconds
>> to shutdown qemu launched with couple net devices like this:
>>         -netdev tap,id=tap0,..,vhost=on,queues=80
>> because we end up calling synchronize_rcu() netdev_count*queues times.
>>
>> Free vhost net structures in rcu callback instead of using
>> synchronize_rcu() to fix the problem.
> 
> I admit the release code is somehow hard to understand. But I wonder
> if the following case can still happen with this:
> 
> CPU 0 (vhost_dev_cleanup)   CPU1
> (vhost_net_zerocopy_callback()->vhost_work_queue())
>                                                 if (!dev->worker)
> dev->worker = NULL
> 
> wake_up_process(dev->worker)
> 
> If this is true. It seems the fix is to move RCU synchronization stuff
> in vhost_net_ubuf_put_and_wait()?
> 

It all depends whether vhost_zerocopy_callback() can be called outside of vhost
thread context or not. If it can run after vhost thread stopped, than the race you
describe seems possible and the fix in commit b0c057ca7e83 ("vhost: fix a theoretical race in device cleanup")
wasn't complete. I would fix it by calling synchronize_rcu() after vhost_net_flush()
and before vhost_dev_cleanup().

As for the performance problem, it can be solved by replacing synchronize_rcu() with synchronize_rcu_expedited().

But now I'm not sure that this race is actually exists and that synchronize_rcu() needed at all.
I did a bit of testing and I only see callback being called from vhost thread:

vhost-3724  3733 [002]  2701.768731: probe:vhost_zerocopy_callback: (ffffffff81af8c10)
        ffffffff81af8c11 vhost_zerocopy_callback+0x1 ([kernel.kallsyms])
        ffffffff81bb34f6 skb_copy_ubufs+0x256 ([kernel.kallsyms])
        ffffffff81bce621 __netif_receive_skb_core.constprop.0+0xac1 ([kernel.kallsyms])
        ffffffff81bd062d __netif_receive_skb_one_core+0x3d ([kernel.kallsyms])
        ffffffff81bd0748 netif_receive_skb+0x38 ([kernel.kallsyms])
        ffffffff819a2a1e tun_get_user+0xdce ([kernel.kallsyms])
        ffffffff819a2cf4 tun_sendmsg+0xa4 ([kernel.kallsyms])
        ffffffff81af9229 handle_tx_zerocopy+0x149 ([kernel.kallsyms])
        ffffffff81afaf05 handle_tx+0xc5 ([kernel.kallsyms])
        ffffffff81afce86 vhost_worker+0x76 ([kernel.kallsyms])
        ffffffff811581e9 kthread+0x169 ([kernel.kallsyms])
        ffffffff810018cf ret_from_fork+0x1f ([kernel.kallsyms])
                       0 [unknown] ([unknown])

This means that the callback can't run after kthread_stop() in vhost_dev_cleanup() and no synchronize_rcu() needed.

I'm not confident that my quite limited testing cover all possible vhost_zerocopy_callback() callstacks.
