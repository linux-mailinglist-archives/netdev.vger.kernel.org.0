Return-Path: <netdev+bounces-247-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E0336F65C6
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 09:33:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6B9751C20FA6
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 07:33:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97860186B;
	Thu,  4 May 2023 07:33:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DB0810EC
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 07:33:28 +0000 (UTC)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CBBF83;
	Thu,  4 May 2023 00:33:24 -0700 (PDT)
Received: from kwepemm600019.china.huawei.com (unknown [172.30.72.56])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4QBlqq5n3kzsR63;
	Thu,  4 May 2023 15:31:35 +0800 (CST)
Received: from [10.136.112.228] (10.136.112.228) by
 kwepemm600019.china.huawei.com (7.193.23.64) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 4 May 2023 15:33:21 +0800
Subject: Re: BUG: KASAN: stack-out-of-bounds in __ip_options_echo
To: Florian Westphal <fw@strlen.de>
CC: <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
	<davem@davemloft.net>, <kuba@kernel.org>, <stephen@networkplumber.org>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <yanan@huawei.com>,
	<caowangbao@huawei.com>
References: <05324dd2-3620-8f07-60a0-051814913ff8@huawei.com>
 <20230502165446.GA22029@breakpoint.cc>
From: "Fengtao (fengtao, Euler)" <fengtao40@huawei.com>
Message-ID: <9dd7ec8f-bc40-39af-febb-a7e8aabbaaed@huawei.com>
Date: Thu, 4 May 2023 15:33:20 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20230502165446.GA22029@breakpoint.cc>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.136.112.228]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600019.china.huawei.com (7.193.23.64)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-8.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi

I have tested the patch, the panic not happend.
And I search the similar issue in kernel, and found commit:
[1]https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=ed0de45a1008
[2]https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=3da1ed7ac398

So I tested another patch like this:
------------[ cut here ]------------
--- .//net/ipv4/netfilter/nf_reject_ipv4.c      2023-05-02 13:03:35.427896081 +0000
+++ .//net/ipv4/netfilter/nf_reject_ipv4.c.new  2023-05-02 13:03:00.433897970 +0000
@@ -187,6 +187,7 @@

 void nf_send_unreach(struct sk_buff *skb_in, int code, int hook)
 {
+       struct ip_options opt;
        struct iphdr *iph = ip_hdr(skb_in);
        u8 proto = iph->protocol;

@@ -196,13 +197,18 @@
        if (hook == NF_INET_PRE_ROUTING && nf_reject_fill_skb_dst(skb_in))
                return;

+       memset(&opt, 0, sizeof(opt));
+       opt.optlen = iph->ihl*4 - sizeof(struct iphdr);
+       if (__ip_options_compile(dev_net(skb_in->dev), &opt, skb_in, NULL))
+               return;
+
        if (skb_csum_unnecessary(skb_in) || !nf_reject_verify_csum(proto)) {
-               icmp_send(skb_in, ICMP_DEST_UNREACH, code, 0);
+               __icmp_send(skb_in, ICMP_DEST_UNREACH, code, 0, &opt);
                return;
        }

        if (nf_ip_checksum(skb_in, hook, ip_hdrlen(skb_in), proto) == 0)
-               icmp_send(skb_in, ICMP_DEST_UNREACH, code, 0);
+               __icmp_send(skb_in, ICMP_DEST_UNREACH, code, 0, &opt);
 }
 EXPORT_SYMBOL_GPL(nf_send_unreach);
------------[ cut here ]------------

This can also fix the issue:) So, which way is better?
BTW, I think the problem is more then ipvlan? Maybe some other scenarios that can trigger such issue.


On 2023/5/3 0:54, Florian Westphal wrote:
> Fengtao (fengtao, Euler) <fengtao40@huawei.com> wrote:
>> Hi,all
>>
>> We found the following crash on stable-5.10(reproduce in kasan kernel).
>> ------------[ cut here ]------------
>> [ 2203.651571] BUG: KASAN: stack-out-of-bounds in __ip_options_echo+0x589/0x800
>> [ 2203.653327] Write of size 4 at addr ffff88811a388f27 by task swapper/3/0
>>
>> [ 2203.655460] CPU: 3 PID: 0 Comm: swapper/3 Kdump: loaded Not tainted 5.10.0-60.18.0.50.h856.kasan.eulerosv2r11.x86_64 #1
>> [ 2203.655466] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.10.2-0-g5f4c7b1-20181220_000000-szxrtosci10000 04/01/2014
>> [ 2203.655475] Call Trace:
>> [ 2203.655481]  <IRQ>
>> [ 2203.655501]  dump_stack+0x9c/0xd3
>> [ 2203.655514]  print_address_description.constprop.0+0x19/0x170
>> [ 2203.655522]  ? __ip_options_echo+0x589/0x800
>> [ 2203.655530]  __kasan_report.cold+0x6c/0x84
>> [ 2203.655569]  ? resolve_normal_ct+0x301/0x430 [nf_conntrack]
>> [ 2203.655576]  ? __ip_options_echo+0x589/0x800
>> [ 2203.655586]  kasan_report+0x3a/0x50
>> [ 2203.655594]  check_memory_region+0xfd/0x1f0
>> [ 2203.655601]  memcpy+0x39/0x60
>> [ 2203.655608]  __ip_options_echo+0x589/0x800
> [..]
> 
>> [ 2203.655702]  ? tcp_print_conntrack+0xb0/0xb0 [nf_conntrack]
>> [ 2203.655709]  ? memset+0x20/0x50
>> [ 2203.655719]  ? nf_nat_setup_info+0x2fb/0x480 [nf_nat]
>> [ 2203.655729]  ? get_unique_tuple+0x390/0x390 [nf_nat]
>> [ 2203.655735]  ? tcp_mt+0x456/0x550
>> [ 2203.655747]  ? ipt_do_table+0x776/0xa40 [ip_tables]
>> [ 2203.655755]  nf_send_unreach+0x129/0x3d0 [nf_reject_ipv4]
>> [ 2203.655763]  reject_tg+0x77/0x1bf [ipt_REJECT]
>> [ 2203.655772]  ipt_do_table+0x691/0xa40 [ip_tables]
> [..]
>> [ 2203.655857]  ip_local_out+0x28/0x90
>> [ 2203.655868]  ipvlan_process_v4_outbound+0x21e/0x260 [ipvlan]
> 
> Somewhere between ipvlan_queue_xmit() and ipvlan_process_v4|6_outbound
> skb->cb has to be cleared; ip_local_out and friends assume that upper
> layer took care of this for outbound packets.
> 
> Try something like this (not even compile tested):
> 
> diff --git a/drivers/net/ipvlan/ipvlan_core.c b/drivers/net/ipvlan/ipvlan_core.c
> --- a/drivers/net/ipvlan/ipvlan_core.c
> +++ b/drivers/net/ipvlan/ipvlan_core.c
> @@ -436,6 +436,9 @@ static int ipvlan_process_v4_outbound(struct sk_buff *skb)
>  		goto err;
>  	}
>  	skb_dst_set(skb, &rt->dst);
> +
> +	memset(skb->cb 0, sizeof(struct inet_skb_parm));
> +
>  	err = ip_local_out(net, skb->sk, skb);
>  	if (unlikely(net_xmit_eval(err)))
>  		dev->stats.tx_errors++;
> @@ -474,6 +477,9 @@ static int ipvlan_process_v6_outbound(struct sk_buff *skb)
>  		goto err;
>  	}
>  	skb_dst_set(skb, dst);
> +
> +	memset(skb->cb 0, sizeof(struct inet6_skb_parm));
> +
>  	err = ip6_local_out(net, skb->sk, skb);
>  	if (unlikely(net_xmit_eval(err)))
>  		dev->stats.tx_errors++;
> 
> .
> 

