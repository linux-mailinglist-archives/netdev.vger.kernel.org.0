Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06AC84F8150
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 16:09:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245459AbiDGOLD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 10:11:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239299AbiDGOLD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 10:11:03 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3035125584
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 07:09:02 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id x131so9717396ybe.11
        for <netdev@vger.kernel.org>; Thu, 07 Apr 2022 07:09:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+EmVfi/hJj5qY2xCfktuOrsdnIsyWAZ1Xcq7QuGbQNU=;
        b=Ex0ysAb+dbnteaKCmZ7UzEeMPi3ALwl7oqU2U5u9eYa2mlnSFM4mUMgA5+4eAYtPyP
         vC+JnwL0zhy6DpGw5JXfCvK4xzfjxOtppDH8k1rbCF47dlkDEvwfGl+CPja0wNS7GbSn
         /yXvqONPVbKl+RNbKMmxOjC8HRzkgQwpkv247GLGf6rsXcW2Je5SJAMJeVATgBnzV08Z
         dzHq5JNaohuG8MmLktFBTVxjQ10O5QHzokpNukEJUKNgLnfj101mie1rX77SGShNmnn6
         XLLko4jrbeL7eBcrzfbVOTxCTWr1xZiD7oCPRvS7mNzmNypgLQaNj7erZEeJpYz8tKKr
         jOjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+EmVfi/hJj5qY2xCfktuOrsdnIsyWAZ1Xcq7QuGbQNU=;
        b=6opVcIScec5MD8lNYOpr+XyP3Zl9TBDJQ87iBHablEsSwivygWCl3WRg1tyOm8MGWw
         y/EHCyfBpLjKJqR52HiQB6YiqsUAwWQNw20t5+DmZ4TkgcqnZjPKrvJQLpSJx7sSah1q
         OatfT11owuvXLhpH1VQySyV6ItHNp01ZOLGVCGzmId5alR9FNM0djDRg9ppCKzF8IiPA
         f4EaS5I2qRs1jc4CJbweavJfPkKjtql+7lqG8b4NpNOpGANKcHeoQKXqrj33WPREhmjd
         2cpKreTKrQ3j9NDSfTfdeq9HxHeu0vrqnJ5O6omI5115nUG0AVappduj/qUhzZCaojFJ
         0tjA==
X-Gm-Message-State: AOAM530w282q5PLvmirhEyeJiK9UZJwSccL8M95V9XUhYjyGxswJqaWT
        APQxdQcVkdZ6kMf8ZGgrGV5YSxzrX8n1GAtDCl4Jug==
X-Google-Smtp-Source: ABdhPJzTvMi/3phYwR9zHtqgXBwUBV0TEXLktdu1cNKs3HjpUdrL+s6rSTIYWysxJj9pyyZwmiiVD8zXjS9/3p7Dml4=
X-Received: by 2002:a25:3009:0:b0:63d:b1c1:e8e2 with SMTP id
 w9-20020a253009000000b0063db1c1e8e2mr10273569ybw.387.1649340541824; Thu, 07
 Apr 2022 07:09:01 -0700 (PDT)
MIME-Version: 1.0
References: <20220407112512.2099221-1-kongweibin2@huawei.com>
In-Reply-To: <20220407112512.2099221-1-kongweibin2@huawei.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 7 Apr 2022 07:08:50 -0700
Message-ID: <CANn89iLx5HRnyRShNatPveTBhdjoQTxaRn-8_gYk-6_NuSCiOQ@mail.gmail.com>
Subject: Re: [PATCH] ipv6:fix crash when idev is NULL
To:     kongweibin <kongweibin2@huawei.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Vasily Averin <vvs@virtuozzo.com>,
        Martin KaFai Lau <kafai@fb.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, rose.chen@huawei.com,
        liaichun@huawei.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 7, 2022 at 4:26 AM kongweibin <kongweibin2@huawei.com> wrote:
>
> When the remote device uses tc command to construct exception packages,
> and send it to the local device, which acts as a forwarding device, it
> will crash.
>
> the tc cmd such as:
> tc qdisc del dev vxlan100 root
> tc qdisc add dev vxlan100 root netem corrupt 5%

Probably not related to your fix.

>
> When using dev_get_by_index_rcu to get net_device struct, once the
> package is abnormal, the corresponding net_device can't be found
> according with error device index, then return a null value, which
> value will be directly used in the policy check below, resulting in
> system crash.
>
> Anyway, we can't directly use the idev variable. We need to ensure
> that it is a valid value.
>
> kernel version is base on kernel-5.10.0, and the stack information
> of the crash is as follows:
>
> [ 4484.161259] IPVS: __ip_vs_del_service: enter
> [ 4484.162263] IPVS: __ip_vs_del_service: enter
> [ 4686.564468] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000240
> [ 4686.565109] Mem abort info:
> [ 4686.565328]   ESR = 0x96000004
> [ 4686.565564]   EC = 0x25: DABT (current EL), IL = 32 bits
> [ 4686.565948]   SET = 0, FnV = 0
> [ 4686.566184]   EA = 0, S1PTW = 0
> [ 4686.566427] Data abort info:
> [ 4686.566651]   ISV = 0, ISS = 0x00000004
> [ 4686.567024]   CM = 0, WnR = 0
> [ 4686.567261] user pgtable: 4k pages, 48-bit VAs, pgdp=0000000102daa000
> [ 4686.567708] [0000000000000240] pgd=0000000000000000, p4d=0000000000000000
> [ 4686.568182] Internal error: Oops: 96000004 [#1] SMP
> [ 4686.568530] CPU: 1 PID: 0 Comm: swapper/1 Kdump: loaded Tainted: G        W  O      5.10.0-xxxxxx.aarch64 #1
> [ 4686.569316] Hardware name: QEMU KVM Virtual Machine, BIOS 0.0.0 02/06/2015
> [ 4686.569787] pstate: 40400005 (nZcv daif +PAN -UAO -TCO BTYPE=--)
> [ 4686.570214] pc : ip6_forward+0xb4/0x744
> [ 4686.570499] lr : ip6_forward+0x5c/0x744
> [ 4686.570782] sp : ffff80008800ba00
> [ 4686.571098] x29: ffff80008800ba00 x28: ffff0000c02e39c0
> [ 4686.571560] x27: ffff0000f6e97000 x26: ffff800089cfa500
> [ 4686.572021] x25: ffff80008800bc98 x24: ffff80008800bc08
> [ 4686.572487] x23: ffff800089cfa500 x22: ffff0000cbfd6c94
> [ 4686.572953] x21: 0000000000000000 x20: ffff80008800bb38
> [ 4686.573416] x19: ffff0000c995fc00 x18: 0000000000000000
> [ 4686.573882] x17: 0000000000000000 x16: ffff8000881b65c0
> [ 4686.574350] x15: 0000000000000000 x14: 0000000000000000
> [ 4686.574816] x13: 0000000065f01475 x12: 0000000002cc68fd
> [ 4686.575298] x11: 00000000d44127a3 x10: b181f30000000000
> [ 4686.575760] x9 : ffff800088d5d9cc x8 : ffff0000c02e39c0
> [ 4686.576224] x7 : 0000000000000000 x6 : 0000000000000000
> [ 4686.576686] x5 : ffff0000c995fc00 x4 : ffff80008800bb38
> [ 4686.577148] x3 : 0000000000000000 x2 : ffff0000cbfd6ec0
> [ 4686.577609] x1 : 0000000000000000 x0 : 0000000000000000
> [ 4686.578079] Call trace:
> [ 4686.578323]  ip6_forward+0xb4/0x744
> [ 4686.578646]  ip6_sublist_rcv_finish+0x6c/0x90
> [ 4686.579051]  ip6_list_rcv_finish.constprop.0+0x198/0x260
> [ 4686.579512]  ip6_sublist_rcv+0x40/0xb0
> [ 4686.579852]  ipv6_list_rcv+0x144/0x180
> [ 4686.580197]  __netif_receive_skb_list_core+0x154/0x28c
> [ 4686.580643]  __netif_receive_skb_list+0x120/0x1a0
> [ 4686.581057]  netif_receive_skb_list_internal+0xe4/0x1f0
> [ 4686.581508]  napi_complete_done+0x70/0x1f0
> [ 4686.581883]  virtnet_poll+0x214/0x2b0 [virtio_net]
> [ 4686.582309]  napi_poll+0xcc/0x264
> [ 4686.582617]  net_rx_action+0xd4/0x21c
> [ 4686.582969]  __do_softirq+0x130/0x358
> [ 4686.583308]  irq_exit+0x12c/0x150
> [ 4686.583621]  __handle_domain_irq+0x88/0xf0
> [ 4686.583991]  gic_handle_irq+0x78/0x2c0
> [ 4686.584332]  el1_irq+0xc8/0x180
> [ 4686.584628]  arch_cpu_idle+0x18/0x40
> [ 4686.584960]  default_idle_call+0x5c/0x1c0
> [ 4686.585323]  cpuidle_idle_call+0x174/0x1b0
> [ 4686.585690]  do_idle+0xc8/0x160
> [ 4686.585989]  cpu_startup_entry+0x30/0x10c
> [ 4686.586351]  secondary_start_kernel+0x158/0x1e4
> [ 4686.586754] Code: b9401842 34002ce2 b940d021 35000281 (b94242a1)
> [ 4686.587301] kernel fault(0x1) notification starting on CPU 1
> [ 4686.587787] kernel fault(0x1) notification finished on CPU 1
>
> Signed-off-by: kongweibin <kongweibin2@huawei.com>

Always provide a Fixes: tag for fixes.

And CC patch author for feedback.

In this case I suspect:

commit ccd27f05ae7b8ebc40af5b004e94517a919aa862
Author: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Date:   Tue Jul 6 11:13:35 2021 +0200

    ipv6: fix 'disable_policy' for fwd packets



> ---
>  net/ipv6/ip6_output.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
> index 54cabf1c2..347b5600d 100644
> --- a/net/ipv6/ip6_output.c
> +++ b/net/ipv6/ip6_output.c
> @@ -495,6 +495,9 @@ int ip6_forward(struct sk_buff *skb)
>         u32 mtu;
>
>         idev = __in6_dev_get_safely(dev_get_by_index_rcu(net, IP6CB(skb)->iif));
> +       if (!idev)
> +               goto drop;
> +
>         if (net->ipv6.devconf_all->forwarding == 0)
>                 goto error;
>
> --
> 2.23.0
>
