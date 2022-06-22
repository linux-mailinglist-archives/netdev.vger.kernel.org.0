Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2130955479C
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 14:12:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243556AbiFVKDO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 06:03:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244780AbiFVKCt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 06:02:49 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF8303A5F0
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 03:02:48 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id w6so29299564ybl.4
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 03:02:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=i5TcadfDwpNkHBHIGjc2aejtAjCEkDrL44PzWJy8/V0=;
        b=L3XsTDjK6bd7Lklt/VqZOZHzMPK51HDrkj40KLhiL3PYWfI42oo542VKJrW9hpm/Tp
         VCXGOSA8SUS6Keb+m635xGx/eS3Yas4Kq3fJCIGqApKcx2bme9EUR8rpN2Aw1OsQsVuf
         biE8iLSSVzRF1pXBcVAp/zHWcaPLqwQHBtWk9/HxBcYTKtmDHFg2um2GE1G0MG1LhCbJ
         llSDUKeGQAN6aX3zqn0Ms8hW4KwlWBwHR8aS/NTbvfgXfAv6Wr66i8WKvUiWP0lvA3+Q
         tl/2YOGACARIcMzwvrZwvRdohnnV7CPjVczI5rz0NnSju3sQTYc59xuofhQCndxokN8m
         2LjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=i5TcadfDwpNkHBHIGjc2aejtAjCEkDrL44PzWJy8/V0=;
        b=WoxjWnMOQ368EyhBuiuJ+F4uMfoMo80D4X/4IQUn0NyGsIbfZZ9tN192C9jbCZYMTD
         TwOrK93NkCmNREErd1hyFLLbBiSHEHaB6Yawi0KjAmeBfvUkV/N0eJG0uvVYPKeYCT3f
         yx5skzu6GVvVlHwdUbXytK4TUMIXrJhNFst5y7xe5STcyA5eFLB4pX7WmxrAE/+PkDv6
         Jj6g9ADamvUhho9qFahlvPv2IaoO/Xx1HZX+x/7mLmgkz7Xrk0BAJwQdw62+Y+ZIXM24
         rDR2XWp8qjox+VeEzgknXi9lRt1J2U9A+K4sMA6qh9WaXspaQH/NImJYADz9juRYdqvT
         mM9A==
X-Gm-Message-State: AJIora9RMZVTYg1YsC8zoP4Qt2dV9hF3S3dUWwalwr1grWPZBV09ixq7
        +GTl1XSfhK2opRrDTaoYrUVkbVdCIku4sTxsE9kIWn2CBC0=
X-Google-Smtp-Source: AGRyM1sV6bezNTxFdNk13U3p+VXhOBJQu0/mI+L7VnjJbxiSkdDBQbNDUQOmO/4J4gjHVebjZL+eDU+pfoHNNyUCsAw=
X-Received: by 2002:a25:e211:0:b0:669:9cf9:bac7 with SMTP id
 h17-20020a25e211000000b006699cf9bac7mr328830ybe.407.1655892167707; Wed, 22
 Jun 2022 03:02:47 -0700 (PDT)
MIME-Version: 1.0
References: <20220619003919.394622-1-i.maximets@ovn.org>
In-Reply-To: <20220619003919.394622-1-i.maximets@ovn.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 22 Jun 2022 12:02:36 +0200
Message-ID: <CANn89iL_EmkEgPAVdhNW4tyzwQbARyji93mUQ9E2MRczWpNm7g@mail.gmail.com>
Subject: Re: [PATCH net] net: ensure all external references are released in
 deferred skbuffs
To:     Ilya Maximets <i.maximets@ovn.org>
Cc:     netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, dev@openvswitch.org,
        LKML <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Westphal <fw@strlen.de>
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

On Sun, Jun 19, 2022 at 2:39 AM Ilya Maximets <i.maximets@ovn.org> wrote:
>
> Open vSwitch system test suite is broken due to inability to
> load/unload netfilter modules.  kworker thread is getting trapped
> in the infinite loop while running a net cleanup inside the
> nf_conntrack_cleanup_net_list, because deferred skbuffs are still
> holding nfct references and not being freed by their CPU cores.
>
> In general, the idea that we will have an rx interrupt on every
> CPU core at some point in a near future doesn't seem correct.
> Devices are getting created and destroyed, interrupts are getting
> re-scheduled, CPUs are going online and offline dynamically.
> Any of these events may leave packets stuck in defer list for a
> long time.  It might be OK, if they are just a piece of memory,
> but we can't afford them holding references to any other resources.
>
> In case of OVS, nfct reference keeps the kernel thread in busy loop
> while holding a 'pernet_ops_rwsem' semaphore.  That blocks the
> later modprobe request from user space:
>
>   # ps
>    299 root  R  99.3  200:25.89 kworker/u96:4+
>
>   # journalctl
>   INFO: task modprobe:11787 blocked for more than 1228 seconds.
>         Not tainted 5.19.0-rc2 #8
>   task:modprobe     state:D
>   Call Trace:
>    <TASK>
>    __schedule+0x8aa/0x21d0
>    schedule+0xcc/0x200
>    rwsem_down_write_slowpath+0x8e4/0x1580
>    down_write+0xfc/0x140
>    register_pernet_subsys+0x15/0x40
>    nf_nat_init+0xb6/0x1000 [nf_nat]
>    do_one_initcall+0xbb/0x410
>    do_init_module+0x1b4/0x640
>    load_module+0x4c1b/0x58d0
>    __do_sys_init_module+0x1d7/0x220
>    do_syscall_64+0x3a/0x80
>    entry_SYSCALL_64_after_hwframe+0x46/0xb0
>
> At this point OVS testsuite is unresponsive and never recover,
> because these skbuffs are never freed.
>
> Solution is to make sure no external references attached to skb
> before pushing it to the defer list.  Using skb_release_head_state()
> for that purpose.  The function modified to be re-enterable, as it
> will be called again during the defer list flush.
>
> Another approach that can fix the OVS use-case, is to kick all
> cores while waiting for references to be released during the net
> cleanup.  But that sounds more like a workaround for a current
> issue rather than a proper solution and will not cover possible
> issues in other parts of the code.
>
> Additionally checking for skb_zcopy() while deferring.  This might
> not be necessary, as I'm not sure if we can actually have zero copy
> packets on this path, but seems worth having for completeness as we
> should never defer such packets regardless.
>
> CC: Eric Dumazet <edumazet@google.com>
> Fixes: 68822bdf76f1 ("net: generalize skb freeing deferral to per-cpu lists")
> Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
> ---
>  net/core/skbuff.c | 16 +++++++++++-----
>  1 file changed, 11 insertions(+), 5 deletions(-)

I do not think this patch is doing the right thing.

Packets sitting in TCP receive queues should not hold state that is
not relevant for TCP recvmsg().

This consumes extra memory for no good reason, and defer expensive
atomic operations.

We for instance release skb dst before skb is queued, we should do the
same for conntrack state.

This would increase performance anyway, as we free ct state while cpu
caches are hot.
