Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 481394B04C5
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 06:12:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233435AbiBJFME (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 00:12:04 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231807AbiBJFMD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 00:12:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F23E290;
        Wed,  9 Feb 2022 21:12:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ADAEF61BA3;
        Thu, 10 Feb 2022 05:12:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30F7BC340E5;
        Thu, 10 Feb 2022 05:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644469925;
        bh=LFqZdC12qnwe1Y76es8sEhk/QMcb0vADkit1XFNLr34=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SLaXM7J9xK+YQ9Jr7kXvubbxpi3xl7gqfDPey6gwEBPx2hWZ12w9X7UbLDtyz6blr
         mE0EImwRa46BGO201erGuYl1zMHxJ8M/TE0y/D/+vEClKv2CGXfC6zHqkotWC8sb5J
         84yOu6sctQvK3e+L1YPK6ZS2PagBVB5+scs5nnrWly++bWRlTuZKZY8cnW5CCHO5ii
         CVfxTzQWdfAqHrDQZIoOnqzOSMnCNAs67uFSV19RRniqAkTwG9z4d9awrgoXOOaiLK
         4untIMC2Ku42zp5TFTnIejVV1xLvwlEj3Ttvkwg515y5TYwbT0HmOeprMyZa1SXwdG
         EHLIz1eGtApcQ==
Date:   Wed, 9 Feb 2022 21:12:02 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Menglong Dong <menglong8.dong@gmail.com>
Cc:     David Ahern <dsahern@gmail.com>, David Ahern <dsahern@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, mingo@redhat.com,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        pablo@netfilter.org, kadlec@netfilter.org,
        Florian Westphal <fw@strlen.de>,
        Menglong Dong <imagedong@tencent.com>,
        Eric Dumazet <edumazet@google.com>, alobakin@pm.me,
        paulb@nvidia.com, Kees Cook <keescook@chromium.org>,
        talalahmad@google.com, haokexin@gmail.com, memxor@gmail.com,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, Cong Wang <cong.wang@bytedance.com>
Subject: Re: [PATCH v3 net-next 1/7] net: skb_drop_reason: add document for
 drop reasons
Message-ID: <20220209211202.7cddd337@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CADxym3akuxC_Cr07Vzvv+BD55XgMEx7nqU4qW8WHowGR0jeoOQ@mail.gmail.com>
References: <20220128073319.1017084-1-imagedong@tencent.com>
        <20220128073319.1017084-2-imagedong@tencent.com>
        <0029e650-3f38-989b-74a3-58c512d63f6b@gmail.com>
        <CADxym3akuxC_Cr07Vzvv+BD55XgMEx7nqU4qW8WHowGR0jeoOQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Feb 2022 11:19:49 +0800 Menglong Dong wrote:
> I'm doing the job of using kfree_skb_reason() for the TCP layer,
> and I have some puzzles.
> 
> When collecting drop reason for tcp_v4_inbound_md5_hash() in
> tcp_v4_rcv(), I come up with 2 ways:
> 
> First way: pass the address of reason to tcp_v4_inbound_md5_hash()
> like this:
> 
>  static bool tcp_v4_inbound_md5_hash(const struct sock *sk,
>                       const struct sk_buff *skb,
> -                    int dif, int sdif)
> +                    int dif, int sdif,
> +                    enum skb_drop_reason *reason)
> 
> This can work, but many functions like tcp_v4_inbound_md5_hash()
> need to do such a change.
> 
> Second way: introduce a 'drop_reason' field to 'struct sk_buff'. Therefore,
> drop reason can be set by 'skb->drop_reason = SKB_DROP_REASON_XXX'
> anywhere.
> 
> For TCP, there are many cases where you can't get a drop reason in
> the place where skb is freed, so I think there needs to be a way to
> deeply collect drop reasons. The second can resolve this problem
> easily, but extra fields may have performance problems.
> 
> Do you have some better ideas?

On a quick look tcp_v4_inbound_md5_hash() returns a drop / no drop
decision, so you could just change the return type to enum
skb_drop_reason. SKB_DROP_REASON_NOT_SPECIFIED is 0 is false, 
so if (reason) goto drop; logic will hold up.
