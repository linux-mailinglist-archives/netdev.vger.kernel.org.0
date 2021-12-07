Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FE1446B0A6
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 03:33:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243805AbhLGCgg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 21:36:36 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:46196 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243541AbhLGCgf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 21:36:35 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CAD3CCE19B5
        for <netdev@vger.kernel.org>; Tue,  7 Dec 2021 02:33:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15DAEC341C1;
        Tue,  7 Dec 2021 02:33:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638844383;
        bh=kMYn3h28YU7aM2onZl/FMgMno2CEc1OPHq+GBB0FjTs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Vbd35rHd9yy0Zbj4C0KqhxMWo021zkA7+mZ7zuzj/mesb8wpITKwTjr2Tqtt4zZxI
         9x7EzePsKiI9p9WDQK4zS7FrMHjJ0BCh1uQz+4mLtDcI+byrUT1uN8+oH6ikQBoe5L
         RcHvLIr2cAxbKN2U1U+sbVTPnfb/9sapJU8GZK16lMl148sgLf7WrJbdviaw8SHjfN
         1MiQmrqawxMwccP+EMtDh6tVAT2CudAp/3+AEaGyFGBclc5vXKXEfLxjZwRgeHqaLR
         hu2MgpBLXoWP5t/yIbV7v4fOOz2NK7KW3OivNF2VqMgt6Hc7lHBiIHdLujn4Iu3NwP
         2zUZSjQ9Ss8KA==
Date:   Mon, 6 Dec 2021 18:33:01 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Paolo Abeni <pabeni@redhat.com>,
        Talal Ahmad <talalahmad@google.com>,
        Kevin Hao <haokexin@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Kees Cook <keescook@chromium.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Antoine Tenart <atenart@kernel.org>,
        Wei Wang <weiwan@google.com>, Arnd Bergmann <arnd@arndb.de>,
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: Re: [net-next v1 1/2] net: sched: use queue_mapping to pick tx
 queue
Message-ID: <20211206183301.50e44a41@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAMDZJNVnvAXfqFSah4wgXri1c3jnQhxCdBVo41uP37e0L3BUAg@mail.gmail.com>
References: <20211206080512.36610-1-xiangxia.m.yue@gmail.com>
        <20211206080512.36610-2-xiangxia.m.yue@gmail.com>
        <20211206124001.5a264583@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAMDZJNVnvAXfqFSah4wgXri1c3jnQhxCdBVo41uP37e0L3BUAg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 7 Dec 2021 10:10:22 +0800 Tonghao Zhang wrote:
> > In general recording the decision in the skb seems a little heavy
> > handed. We just need to carry the information from the egress hook
> > to the queue selection a few lines below. Or in fact maybe egress  
> Yes, we can refactor netdev_core_pick_tx to
> 1. select queue_index and invoke skb_set_queue_mapping, but don't
> return the txq.
> 2. after egress hook, use skb_get_queue_mapping/netdev_get_tx_queue to get txq.

I'm not sure that's what I meant, I meant the information you need to
store does not need to be stored in the skb, you can pass a pointer to
a stack variable to both egress handling and pick_tx.

> > hook shouldn't be used for this in the first place, and we need
> > a more appropriate root qdisc than simple mq?  
> I have no idea about mq, I think clsact may make the things more flexible.
> and act_bpf can also support to change sk queue_mapping. queue_mapping
> was included in __sk_buff.

Qdiscs can run a classifier to select a sub-queue. The advantage of
the classifier run by the Qdisc is that it runs after pick_tx.
