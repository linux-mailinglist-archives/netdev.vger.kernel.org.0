Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C1AB6F48B2
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 18:55:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233858AbjEBQzB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 12:55:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234122AbjEBQy7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 12:54:59 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F8141BE5;
        Tue,  2 May 2023 09:54:57 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1pttH4-0005tY-Py; Tue, 02 May 2023 18:54:46 +0200
Date:   Tue, 2 May 2023 18:54:46 +0200
From:   Florian Westphal <fw@strlen.de>
To:     "Fengtao (fengtao, Euler)" <fengtao40@huawei.com>
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, kuba@kernel.org, stephen@networkplumber.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        yanan@huawei.com, caowangbao@huawei.com
Subject: Re: BUG: KASAN: stack-out-of-bounds in __ip_options_echo
Message-ID: <20230502165446.GA22029@breakpoint.cc>
References: <05324dd2-3620-8f07-60a0-051814913ff8@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <05324dd2-3620-8f07-60a0-051814913ff8@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fengtao (fengtao, Euler) <fengtao40@huawei.com> wrote:
> Hi,all
> 
> We found the following crash on stable-5.10(reproduce in kasan kernel).
> ------------[ cut here ]------------
> [ 2203.651571] BUG: KASAN: stack-out-of-bounds in __ip_options_echo+0x589/0x800
> [ 2203.653327] Write of size 4 at addr ffff88811a388f27 by task swapper/3/0
> 
> [ 2203.655460] CPU: 3 PID: 0 Comm: swapper/3 Kdump: loaded Not tainted 5.10.0-60.18.0.50.h856.kasan.eulerosv2r11.x86_64 #1
> [ 2203.655466] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.10.2-0-g5f4c7b1-20181220_000000-szxrtosci10000 04/01/2014
> [ 2203.655475] Call Trace:
> [ 2203.655481]  <IRQ>
> [ 2203.655501]  dump_stack+0x9c/0xd3
> [ 2203.655514]  print_address_description.constprop.0+0x19/0x170
> [ 2203.655522]  ? __ip_options_echo+0x589/0x800
> [ 2203.655530]  __kasan_report.cold+0x6c/0x84
> [ 2203.655569]  ? resolve_normal_ct+0x301/0x430 [nf_conntrack]
> [ 2203.655576]  ? __ip_options_echo+0x589/0x800
> [ 2203.655586]  kasan_report+0x3a/0x50
> [ 2203.655594]  check_memory_region+0xfd/0x1f0
> [ 2203.655601]  memcpy+0x39/0x60
> [ 2203.655608]  __ip_options_echo+0x589/0x800
[..]

> [ 2203.655702]  ? tcp_print_conntrack+0xb0/0xb0 [nf_conntrack]
> [ 2203.655709]  ? memset+0x20/0x50
> [ 2203.655719]  ? nf_nat_setup_info+0x2fb/0x480 [nf_nat]
> [ 2203.655729]  ? get_unique_tuple+0x390/0x390 [nf_nat]
> [ 2203.655735]  ? tcp_mt+0x456/0x550
> [ 2203.655747]  ? ipt_do_table+0x776/0xa40 [ip_tables]
> [ 2203.655755]  nf_send_unreach+0x129/0x3d0 [nf_reject_ipv4]
> [ 2203.655763]  reject_tg+0x77/0x1bf [ipt_REJECT]
> [ 2203.655772]  ipt_do_table+0x691/0xa40 [ip_tables]
[..]
> [ 2203.655857]  ip_local_out+0x28/0x90
> [ 2203.655868]  ipvlan_process_v4_outbound+0x21e/0x260 [ipvlan]

Somewhere between ipvlan_queue_xmit() and ipvlan_process_v4|6_outbound
skb->cb has to be cleared; ip_local_out and friends assume that upper
layer took care of this for outbound packets.

Try something like this (not even compile tested):

diff --git a/drivers/net/ipvlan/ipvlan_core.c b/drivers/net/ipvlan/ipvlan_core.c
--- a/drivers/net/ipvlan/ipvlan_core.c
+++ b/drivers/net/ipvlan/ipvlan_core.c
@@ -436,6 +436,9 @@ static int ipvlan_process_v4_outbound(struct sk_buff *skb)
 		goto err;
 	}
 	skb_dst_set(skb, &rt->dst);
+
+	memset(skb->cb 0, sizeof(struct inet_skb_parm));
+
 	err = ip_local_out(net, skb->sk, skb);
 	if (unlikely(net_xmit_eval(err)))
 		dev->stats.tx_errors++;
@@ -474,6 +477,9 @@ static int ipvlan_process_v6_outbound(struct sk_buff *skb)
 		goto err;
 	}
 	skb_dst_set(skb, dst);
+
+	memset(skb->cb 0, sizeof(struct inet6_skb_parm));
+
 	err = ip6_local_out(net, skb->sk, skb);
 	if (unlikely(net_xmit_eval(err)))
 		dev->stats.tx_errors++;
