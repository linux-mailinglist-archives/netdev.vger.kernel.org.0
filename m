Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E60BB507673
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 19:26:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245052AbiDSR33 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 13:29:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245193AbiDSR3P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 13:29:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EF56D21B3
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 10:26:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650389190;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KnT56PJN9F9nxcZCdsEbo1AgUlkLyacJ520jZAzXohM=;
        b=MYOkJM/XKdlOHnKmCD3eEYJIM9uUmQYqtf9i3SvD17NYPxWzvYzP1mmWLDYaPX5Okkob50
        U9KV6/ZmZfG5hMmTgb5LvTDxB64aToHVQzVmM0UbmBNgk33Jp5fGSTnfizLAWmcYA5BDmK
        qnQwUHINtBuKwbWNYbBxAORoNf8vb0U=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-412-hBe7CVIRNUytrpfFH5JZrg-1; Tue, 19 Apr 2022 13:26:29 -0400
X-MC-Unique: hBe7CVIRNUytrpfFH5JZrg-1
Received: by mail-il1-f199.google.com with SMTP id p10-20020a056e02104a00b002caa828f7b1so9952883ilj.7
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 10:26:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:references:mime-version:in-reply-to:date
         :message-id:subject:to:cc;
        bh=KnT56PJN9F9nxcZCdsEbo1AgUlkLyacJ520jZAzXohM=;
        b=GL0wrjWcCVhiQnwYaJf4nRsaw/IT1kfo0EUAOiRhE/kvYh7N86jjfV88mXQ69RXkqM
         WPi9kZMv8fNh2KiNePDj46QJ8gwSzyzYN4n9+OmiYcqO+Ady7uh6mX6gddadJ5CVhTeC
         b0mUxSWIYUDcdRp5E3atxRcF5hS5KfxPoeuYdQOoA/vAiK9xMF761Zs/xoE0xZLcrCWo
         0IjfaUUmT3aJsCp7Q2vkc/hjNFa25sFc5IN4MXPEun57ocGk7X0/fFHxkRoZ/4fIgIOc
         JkZT3rTBZdXcBa5U90mJjPrEKeproEjwJsDF9xUgRBiyD8DPiyXCye/TL38Y6W+ZtgNe
         Jktg==
X-Gm-Message-State: AOAM530JSEUUqDIA2sCqtsBD4TC2U4e0nnmDbemkp81dvv80hPwRKScl
        70ezHmx3fxmXCMNeM4gjUxTtC020OmobR1jDGHU8cKa0gM2wgJ9lJY1y9rTa1/lwxToZlCfMS28
        VPwkReq2WsQ2CumcElnuahUHVoHSukraI
X-Received: by 2002:a05:6e02:16c5:b0:2cc:450a:df7d with SMTP id 5-20020a056e0216c500b002cc450adf7dmr2062029ilx.39.1650389188033;
        Tue, 19 Apr 2022 10:26:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwqy2ykOW7FmenhOJHQOJvmdpfac55ywUqXQ5q/skGurVLHoT5jBVZi3AnZ9DrY9sO3Fw8nJTYkF0xO4xZK36E=
X-Received: by 2002:a05:6e02:16c5:b0:2cc:450a:df7d with SMTP id
 5-20020a056e0216c500b002cc450adf7dmr2062022ilx.39.1650389187774; Tue, 19 Apr
 2022 10:26:27 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 19 Apr 2022 12:26:27 -0500
From:   Marcelo Ricardo Leitner <mleitner@redhat.com>
References: <20210809070455.21051-1-liuhangbin@gmail.com> <162850320655.31628.17692584840907169170.git-patchwork-notify@kernel.org>
 <CAHsH6GuZciVLrn7J-DR4S+QU7Xrv422t1kfMyA7r=jADssNw+A@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAHsH6GuZciVLrn7J-DR4S+QU7Xrv422t1kfMyA7r=jADssNw+A@mail.gmail.com>
Date:   Tue, 19 Apr 2022 12:26:27 -0500
Message-ID: <CALnP8ZackbaUGJ_31LXyZpk3_AVi2Z-cDhexH8WKYZjjKTLGfw@mail.gmail.com>
Subject: Re: [PATCH net] net: sched: act_mirred: Reset ct info when
 mirror/redirect skb
To:     Eyal Birger <eyal.birger@gmail.com>
Cc:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, kuba@kernel.org, ahleihel@redhat.com,
        dcaratti@redhat.com, aconole@redhat.com, roid@nvidia.com,
        Shmulik Ladkani <shmulik.ladkani@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Tue, Apr 19, 2022 at 07:50:38PM +0300, Eyal Birger wrote:
> Hi,
>
> On Mon, Aug 9, 2021 at 1:29 PM <patchwork-bot+netdevbpf@kernel.org> wrote:
> >
> > Hello:
> >
> > This patch was applied to netdev/net.git (refs/heads/master):
> >
> > On Mon,  9 Aug 2021 15:04:55 +0800 you wrote:
> > > When mirror/redirect a skb to a different port, the ct info should be reset
> > > for reclassification. Or the pkts will match unexpected rules. For example,
> > > with following topology and commands:
> > >
> > >     -----------
> > >               |
> > >        veth0 -+-------
> > >               |
> > >        veth1 -+-------
> > >               |
> > >
> > > [...]
> >
> > Here is the summary with links:
> >   - [net] net: sched: act_mirred: Reset ct info when mirror/redirect skb
> >     https://git.kernel.org/netdev/net/c/d09c548dbf3b
>
> Unfortunately this commit breaks DNAT when performed before going via mirred
> egress->ingress.
>
> The reason is that connection tracking is lost and therefore a new state
> is created on ingress.
>
> This breaks existing setups.
>
> See below a simplified script reproducing this issue.

I guess I can understand why the reproducer triggers it, but I fail to
see the actual use case you have behind it. Can you please elaborate
on it?

>
> Therefore I suggest this commit be reverted and a knob is introduced to mirred
> for clearing ct as needed.
>
> Eyal.
>
> Reproduction script:
>
> #!/bin/bash
>
> ip netns add a
> ip netns add b
>
> ip netns exec a sysctl -w net.ipv4.conf.all.forwarding=1
> ip netns exec a sysctl -w net.ipv4.conf.all.accept_local=1
>
> ip link add veth0 netns a type veth peer name veth0 netns b
> ip -net a link set veth0 up
> ip -net a addr add dev veth0 198.51.100.1/30
>
> ip -net a link add dum0 type dummy
> ip -net a link set dev dum0 up
> ip -net a addr add dev dum0 198.51.100.2/32
>
> ip netns exec a iptables -t nat -I OUTPUT -d 10.0.0.1 -j DNAT
> --to-destination 10.0.0.2
> ip -net a route add default dev dum0
> ip -net a rule add pref 50 iif dum0 lookup 1000
> ip -net a route add table 1000 default dev veth0
>
> ip netns exec a tc qdisc add dev dum0 clsact
> ip netns exec a tc filter add dev dum0 parent ffff:fff3 prio 50 basic
> action mirred ingress redirect dev dum0
>
> ip -net b link set veth0 up
> ip  -net b addr add 10.0.0.2/32 dev veth0
> ip  -net b addr add 198.51.100.3/30 dev veth0
>
> ip netns exec a ping 10.0.0.1
> >
> > You are awesome, thank you!
> > --
> > Deet-doot-dot, I am a bot.
> > https://korg.docs.kernel.org/patchwork/pwbot.html
> >
> >
>

