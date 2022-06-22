Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11B0D554871
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 14:15:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354879AbiFVKgi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 06:36:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354930AbiFVKgg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 06:36:36 -0400
Received: from mail-yw1-x1129.google.com (mail-yw1-x1129.google.com [IPv6:2607:f8b0:4864:20::1129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9ADB3B571
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 03:36:35 -0700 (PDT)
Received: by mail-yw1-x1129.google.com with SMTP id 00721157ae682-3178ea840easo120212777b3.13
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 03:36:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1glGpp0SEw3V0blGR4ljyCdLhDM0hardx9yidp3fQx8=;
        b=b8nMleUO4TwkYSRjujyr/LLTBCRck31lksmnQJcNGC/AwwYGnL6D8o8Sp/G+xQPnIO
         5LzJ21oKoQfvxa76OrCV3zrmuJJqPj2bmAJilYQXMfkLH4xArHcQUC83VgW/jND/x4uT
         OEzizq835lbeoVzbqsf4FHGXN2RKTFd71Vcx4LAmXb2VjdBzeYhKBvzwLF4GTcMNC/XX
         DRnFPQYVpdNH+nvSPmLiYXPXncNF28y74FdF0VrSvQB8jZXfHQFoSyMHLLFRuP5W/BQu
         qESfWuYTFiKdeMwRl46qvUNk7gYSWvjpnlqHGNJpUeLeqYyXaWtaqSG0f3WYA60h2ic9
         CDbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1glGpp0SEw3V0blGR4ljyCdLhDM0hardx9yidp3fQx8=;
        b=VfutJJkW4wXPVYas61yirvHGjYlkwrMOQUyto1RPvs6bUsFp3/GMCS5AlhuyhZMgs3
         yI2/EUkRw63tYVcOhMoetgxzbVTeyvrZzy92Q0QUWZs17CN5/hu6Tglc5Nj1CDFLFE4/
         9c8/I7lihsDiCHkwGkrcuLZw0I0OdlLS2W4CtTzjlWrjjUaF+OgW2bho2fYusTjqdBkM
         ed2yB3DiRC1yWT7aeaK5u5tnRUngrFNEZWtf10XGFlD8x7UgDk86L43HH7QaGMYSZc5Z
         VRUfi+a2F5CZjwuq0sF9NITsYtC3cXedIymEaRe9y6yla4qWEHLMp+CI+gp0zHJa0Z/Y
         mvGA==
X-Gm-Message-State: AJIora/s4/wHZjhFxv8oz24/p1DqpzCUkBiYc1aqZLL9vaCtSEIxYFp0
        YmW1aKIYp80+hCEHA5CJpgHbq19rVJuOBpy1fuBe3PHXFTXXnw==
X-Google-Smtp-Source: AGRyM1tlcwk6SnFnNf7pVIdNkgOurDpmBFMUq4+6i+KfMQeYT3ql5GPnHD9Rl3OYC5pHOitwTImoOlgJbC0lMdl0ycg=
X-Received: by 2002:a81:e93:0:b0:317:8db7:aa8e with SMTP id
 141-20020a810e93000000b003178db7aa8emr3284423ywo.55.1655894194871; Wed, 22
 Jun 2022 03:36:34 -0700 (PDT)
MIME-Version: 1.0
References: <20220619003919.394622-1-i.maximets@ovn.org> <CANn89iL_EmkEgPAVdhNW4tyzwQbARyji93mUQ9E2MRczWpNm7g@mail.gmail.com>
 <20220622102813.GA24844@breakpoint.cc>
In-Reply-To: <20220622102813.GA24844@breakpoint.cc>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 22 Jun 2022 12:36:23 +0200
Message-ID: <CANn89iLGKbeeBNoDQU9C7nPRCxc6FUsrwn0LfrAKrJiJ14PH+w@mail.gmail.com>
Subject: Re: [PATCH net] net: ensure all external references are released in
 deferred skbuffs
To:     Florian Westphal <fw@strlen.de>
Cc:     Ilya Maximets <i.maximets@ovn.org>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, dev@openvswitch.org,
        LKML <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 22, 2022 at 12:28 PM Florian Westphal <fw@strlen.de> wrote:
>
> Eric Dumazet <edumazet@google.com> wrote:
> > On Sun, Jun 19, 2022 at 2:39 AM Ilya Maximets <i.maximets@ovn.org> wrote:
> > >
> > > Open vSwitch system test suite is broken due to inability to
> > > load/unload netfilter modules.  kworker thread is getting trapped
> > > in the infinite loop while running a net cleanup inside the
> > > nf_conntrack_cleanup_net_list, because deferred skbuffs are still
> > > holding nfct references and not being freed by their CPU cores.
> > >
> > > In general, the idea that we will have an rx interrupt on every
> > > CPU core at some point in a near future doesn't seem correct.
> > > Devices are getting created and destroyed, interrupts are getting
> > > re-scheduled, CPUs are going online and offline dynamically.
> > > Any of these events may leave packets stuck in defer list for a
> > > long time.  It might be OK, if they are just a piece of memory,
> > > but we can't afford them holding references to any other resources.
> > >
> > > In case of OVS, nfct reference keeps the kernel thread in busy loop
> > > while holding a 'pernet_ops_rwsem' semaphore.  That blocks the
> > > later modprobe request from user space:
> > >
> > >   # ps
> > >    299 root  R  99.3  200:25.89 kworker/u96:4+
> > >
> > >   # journalctl
> > >   INFO: task modprobe:11787 blocked for more than 1228 seconds.
> > >         Not tainted 5.19.0-rc2 #8
> > >   task:modprobe     state:D
> > >   Call Trace:
> > >    <TASK>
> > >    __schedule+0x8aa/0x21d0
> > >    schedule+0xcc/0x200
> > >    rwsem_down_write_slowpath+0x8e4/0x1580
> > >    down_write+0xfc/0x140
> > >    register_pernet_subsys+0x15/0x40
> > >    nf_nat_init+0xb6/0x1000 [nf_nat]
> > >    do_one_initcall+0xbb/0x410
> > >    do_init_module+0x1b4/0x640
> > >    load_module+0x4c1b/0x58d0
> > >    __do_sys_init_module+0x1d7/0x220
> > >    do_syscall_64+0x3a/0x80
> > >    entry_SYSCALL_64_after_hwframe+0x46/0xb0
> > >
> > > At this point OVS testsuite is unresponsive and never recover,
> > > because these skbuffs are never freed.
> > >
> > > Solution is to make sure no external references attached to skb
> > > before pushing it to the defer list.  Using skb_release_head_state()
> > > for that purpose.  The function modified to be re-enterable, as it
> > > will be called again during the defer list flush.
> > >
> > > Another approach that can fix the OVS use-case, is to kick all
> > > cores while waiting for references to be released during the net
> > > cleanup.  But that sounds more like a workaround for a current
> > > issue rather than a proper solution and will not cover possible
> > > issues in other parts of the code.
> > >
> > > Additionally checking for skb_zcopy() while deferring.  This might
> > > not be necessary, as I'm not sure if we can actually have zero copy
> > > packets on this path, but seems worth having for completeness as we
> > > should never defer such packets regardless.
> > >
> > > CC: Eric Dumazet <edumazet@google.com>
> > > Fixes: 68822bdf76f1 ("net: generalize skb freeing deferral to per-cpu lists")
> > > Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
> > > ---
> > >  net/core/skbuff.c | 16 +++++++++++-----
> > >  1 file changed, 11 insertions(+), 5 deletions(-)
> >
> > I do not think this patch is doing the right thing.
> >
> > Packets sitting in TCP receive queues should not hold state that is
> > not relevant for TCP recvmsg().
>
> Agree, but tcp_v4/6_rcv() already call nf_reset_ct(), else it would
> not be possible to remove nf_conntrack module in practice.

Well, existing nf_reset_ct() does not catch all cases, like TCP fastopen ?

Maybe 68822bdf76f1 ("net: generalize skb freeing deferral to per-cpu lists")
only widened the problem.

>
> I wonder where the deferred skbs are coming from, any and all
> queued skbs need the conntrack state dropped.
>
> I don't mind a new helper that does a combined dst+ct release though.
