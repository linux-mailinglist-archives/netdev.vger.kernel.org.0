Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABCC563A58C
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 11:00:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230044AbiK1KAg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 05:00:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230013AbiK1KAf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 05:00:35 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 67A80193EA;
        Mon, 28 Nov 2022 02:00:34 -0800 (PST)
Date:   Mon, 28 Nov 2022 11:00:31 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Ivan Babrou <ivan@ivan.computer>
Cc:     Daniel Xu <dxu@dxuuu.xyz>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Unused variable 'mark' in v6.1-rc7
Message-ID: <Y4SGv3W+TtAiizwi@salvia>
References: <CAGjnhw_2oSWfMjNPZMneJXxdvT+qoqhKV8787NYuHnOauhSVyw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAGjnhw_2oSWfMjNPZMneJXxdvT+qoqhKV8787NYuHnOauhSVyw@mail.gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Sun, Nov 27, 2022 at 05:30:47PM -0800, Ivan Babrou wrote:
> There's 52d1aa8b8249 in v6.1-rc7:
> 
> * netfilter: conntrack: Fix data-races around ct mark
> 
> It triggers an error:
> 
> #19 355.8 /build/linux-source/net/netfilter/nf_conntrack_netlink.c: In
> function '__ctnetlink_glue_build':
> #19 355.8 /build/linux-source/net/netfilter/nf_conntrack_netlink.c:2674:13:
> error: unused variable 'mark' [-Werror=unused-variable]
> #19 355.8  2674 |         u32 mark;
> #19 355.8       |             ^~~~
> #19 355.8 cc1: all warnings being treated as errors
> 
> If CONFIG_NF_CONNTRACK_MARK is not enabled, as mark is declared
> unconditionally, but used under ifdef:
> 
>  #ifdef CONFIG_NF_CONNTRACK_MARK
> -       if ((events & (1 << IPCT_MARK) || ct->mark)
> -           && ctnetlink_dump_mark(skb, ct) < 0)
> +       mark = READ_ONCE(ct->mark);
> +       if ((events & (1 << IPCT_MARK) || mark) &&
> +           ctnetlink_dump_mark(skb, mark) < 0)
>                 goto nla_put_failure;
>  #endif
> 
> To have NF_CONNTRACK_MARK one needs NETFILTER_ADVANCED:
> 
> config NF_CONNTRACK_MARK
>         bool  'Connection mark tracking support'
>         depends on NETFILTER_ADVANCED
> 
> It's supposed to be enabled by default:
> 
> config NETFILTER_ADVANCED
>         bool "Advanced netfilter configuration"
>         depends on NETFILTER
>         default y
> 
> But it's not in defconfig (it's missing from arm64 completely):
> 
> $ rg NETFILTER_ADVANCED arch/x86/configs/x86_64_defconfig
> 93:# CONFIG_NETFILTER_ADVANCED is not set
> 
> I think the solution is to enclose mark definition into ifdef as well
> and I'm happy to send a patch if you agree and would like me to.

Thanks for reporting and offering a patch:

Could you give a try to this one? I'll be glad to get a Tested-by:
tag if this is correct to you.

https://patchwork.ozlabs.org/project/netfilter-devel/patch/20221128095853.10589-1-pablo@netfilter.org/

Thanks.
