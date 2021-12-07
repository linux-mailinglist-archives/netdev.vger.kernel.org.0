Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2F2B46BFB5
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 16:45:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233865AbhLGPsd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 10:48:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233215AbhLGPsd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 10:48:33 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98F0FC061574
        for <netdev@vger.kernel.org>; Tue,  7 Dec 2021 07:45:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 91937CE1B19
        for <netdev@vger.kernel.org>; Tue,  7 Dec 2021 15:45:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F14DCC341C5;
        Tue,  7 Dec 2021 15:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638891898;
        bh=Zi+/SlHTByUpXQtd+xamp5ixbNT8p88NSknq2jwLqUE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FUiVPYFt8n9qqApeHX6Z3a3OZqj95Hcq77Gj7FsS/OzlNsD9ABdESiuGNSQzbiuQq
         pJFRBPQlzu8sT+R+8vHV/44M9hSn1sh+aIQ9zXOS5amSmkvup6BQ6ZFbkAN0w04gMp
         5Wv/qPtGAiWBnY/N8TOba2BdP4xo98SIx4rjlZNmPxD4loxWfU364RuAxcrIHhf8EY
         MaL0hmLnbp+/S3cWXq67YWBGHMjx0yzhMe4kW3GP4R05pAj+GgoFxpVoEmzHcHhx/3
         263Gjlvh53ysmDh2xe5WJgN68eCdLXJbAcFYpSQMLl2KBy6SH40WrzzNwIYF3eqOol
         p4kN0oV8SRAHQ==
Date:   Tue, 7 Dec 2021 07:44:57 -0800
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
Message-ID: <20211207074457.605dad52@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAMDZJNUwWnq9+d_2a3UatfxKz3+gjDo3GLftgOE9-=3-smA8BQ@mail.gmail.com>
References: <20211206080512.36610-1-xiangxia.m.yue@gmail.com>
        <20211206080512.36610-2-xiangxia.m.yue@gmail.com>
        <20211206124001.5a264583@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAMDZJNVnvAXfqFSah4wgXri1c3jnQhxCdBVo41uP37e0L3BUAg@mail.gmail.com>
        <20211206183301.50e44a41@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAMDZJNUwWnq9+d_2a3UatfxKz3+gjDo3GLftgOE9-=3-smA8BQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 7 Dec 2021 11:22:28 +0800 Tonghao Zhang wrote:
> On Tue, Dec 7, 2021 at 10:33 AM Jakub Kicinski <kuba@kernel.org> wrote:
> > On Tue, 7 Dec 2021 10:10:22 +0800 Tonghao Zhang wrote:  
> > > Yes, we can refactor netdev_core_pick_tx to
> > > 1. select queue_index and invoke skb_set_queue_mapping, but don't
> > > return the txq.
> > > 2. after egress hook, use skb_get_queue_mapping/netdev_get_tx_queue to get txq.  
> >
> > I'm not sure that's what I meant, I meant the information you need to
> > store does not need to be stored in the skb, you can pass a pointer to
> > a stack variable to both egress handling and pick_tx.  
> Thanks, I got it. I think we store the txq index in skb->queue_mapping
> better. because in egress hook,
> act_skbedit/act_bpf can change the skb queue_mapping. Then we can
> pick_tx depending on queue_mapping.

Actually Eric pointed out in another thread that xmit_more() is now
done via a per-CPU variable, you can try that instead of plumbing a
variable all the way into actions and back out to pick_tx().

Please make sure to include the analysis of the performance impact 
when the feature is _not_ used in the next version.

> > > I have no idea about mq, I think clsact may make the things more flexible.
> > > and act_bpf can also support to change sk queue_mapping. queue_mapping
> > > was included in __sk_buff.  
> >
> > Qdiscs can run a classifier to select a sub-queue. The advantage of
> > the classifier run by the Qdisc is that it runs after pick_tx.  
> Yes, we should consider the qdisc lock too. Qdisc lock may affect
> performance and latency when running a classifier in Qdisc
> and clsact is outside of qdisc.
