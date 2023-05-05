Return-Path: <netdev+bounces-492-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DC516F7C9E
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 07:58:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 91D801C216AD
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 05:58:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17CE41C29;
	Fri,  5 May 2023 05:58:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BAEA156E6
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 05:58:38 +0000 (UTC)
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E49E11D89;
	Thu,  4 May 2023 22:58:34 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1puoSU-0003tm-VJ; Fri, 05 May 2023 07:58:22 +0200
Date: Fri, 5 May 2023 07:58:22 +0200
From: Florian Westphal <fw@strlen.de>
To: "Fengtao (fengtao, Euler)" <fengtao40@huawei.com>
Cc: Florian Westphal <fw@strlen.de>, jhs@mojatatu.com,
	xiyou.wangcong@gmail.com, jiri@resnulli.us, davem@davemloft.net,
	kuba@kernel.org, stephen@networkplumber.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, yanan@huawei.com,
	caowangbao@huawei.com
Subject: Re: BUG: KASAN: stack-out-of-bounds in __ip_options_echo
Message-ID: <20230505055822.GA6126@breakpoint.cc>
References: <05324dd2-3620-8f07-60a0-051814913ff8@huawei.com>
 <20230502165446.GA22029@breakpoint.cc>
 <9dd7ec8f-bc40-39af-febb-a7e8aabbaaed@huawei.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9dd7ec8f-bc40-39af-febb-a7e8aabbaaed@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,T_SPF_TEMPERROR autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Fengtao (fengtao, Euler) <fengtao40@huawei.com> wrote:
> Hi
> 
> I have tested the patch, the panic not happend.
> And I search the similar issue in kernel, and found commit:
> [1]https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=ed0de45a1008
> [2]https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=3da1ed7ac398
> 
> So I tested another patch like this:
> ------------[ cut here ]------------
> --- .//net/ipv4/netfilter/nf_reject_ipv4.c      2023-05-02 13:03:35.427896081 +0000
> +++ .//net/ipv4/netfilter/nf_reject_ipv4.c.new  2023-05-02 13:03:00.433897970 +0000
> @@ -187,6 +187,7 @@ > 
>  void nf_send_unreach(struct sk_buff *skb_in, int code, int hook)
>  {
> +       struct ip_options opt;
>         struct iphdr *iph = ip_hdr(skb_in);
>         u8 proto = iph->protocol;
> 
> @@ -196,13 +197,18 @@
>         if (hook == NF_INET_PRE_ROUTING && nf_reject_fill_skb_dst(skb_in))
>                 return;
> 
> +       memset(&opt, 0, sizeof(opt));
> +       opt.optlen = iph->ihl*4 - sizeof(struct iphdr);
> +       if (__ip_options_compile(dev_net(skb_in->dev), &opt, skb_in, NULL))
> +               return;
> +
>         if (skb_csum_unnecessary(skb_in) || !nf_reject_verify_csum(proto)) {
> -               icmp_send(skb_in, ICMP_DEST_UNREACH, code, 0);
> +               __icmp_send(skb_in, ICMP_DEST_UNREACH, code, 0, &opt);
>                 return;
>         }
> 
>         if (nf_ip_checksum(skb_in, hook, ip_hdrlen(skb_in), proto) == 0)
> -               icmp_send(skb_in, ICMP_DEST_UNREACH, code, 0);
> +               __icmp_send(skb_in, ICMP_DEST_UNREACH, code, 0, &opt);
>  }
>  EXPORT_SYMBOL_GPL(nf_send_unreach);
> ------------[ cut here ]------------
> 
> This can also fix the issue :)

No, it papers over the problem, by only fixing this specific instance
(icmpv4).  What about ipv6?  What about all other IPCB accesses?

> BTW, I think the problem is more then ipvlan? Maybe some other scenarios that can trigger such issue.

Such as?

I don't see how this is fixable, just have have a look at "git grep
IPCB", how do you envision stack to know how such access is valid or
not?

