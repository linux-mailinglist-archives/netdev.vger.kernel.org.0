Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 169914DD7A0
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 11:05:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234761AbiCRKGr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 06:06:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231978AbiCRKGq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 06:06:46 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4390C1E8CC0
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 03:05:27 -0700 (PDT)
Date:   Fri, 18 Mar 2022 11:05:23 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1647597924;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QaH1uwdJSV7WwsZJ3y0nd6+bDSDude64b3XfEmRCOgg=;
        b=cADDDL6FjrIualtqpUcK7jELVnuQPAmITBIiUSrPAnxbO6khVrM5b+dudTk0o1TRxbphI8
        pA0Hj1hSOccZxr9gNSFw42Cz9xXeblbn5ppkKScdJkUVIvNwBp7O8FRmVEtPj7wnsHACE/
        HCaDHjrvq+D2VNAmz9cHYW/Il9EqQXVnpuP4qiT3/rNybBCMFTkYH4tjZ/7uDAj/xNggvJ
        BOiighXnt4zyBWeYgFCwajiyyUmloyzgI0kwCwxzyo8wlhaCbgv8eNlAXS9d3TtsQFJyZA
        M/HPfP1PppESH/BXfFX/eNGjrbLgItDiyXJqqHD8TVbNfvAvReYgDJtNxDPb3g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1647597924;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QaH1uwdJSV7WwsZJ3y0nd6+bDSDude64b3XfEmRCOgg=;
        b=qIaSBYdTmMef2iUf6crqvddI3BTnglFjigrHhcfCVGKPUZcMQMWxooTiLJXxMiY+lNX7DJ
        znzz4vXV4GcqTUAg==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH net-next] net: Add lockdep asserts to ____napi_schedule().
Message-ID: <YjRZY6CXOJPCAoNK@linutronix.de>
References: <YitkzkjU5zng7jAM@linutronix.de>
 <20220317192145.g23wprums5iunx6c@sx1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20220317192145.g23wprums5iunx6c@sx1>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-03-17 12:21:45 [-0700], Saeed Mahameed wrote:
> On 11 Mar 16:03, Sebastian Andrzej Siewior wrote:
> > ____napi_schedule() needs to be invoked with disabled interrupts due to
> > __raise_softirq_irqoff (in order not to corrupt the per-CPU list).
>=20
> This patch is likely causing the following call trace when RPS is enabled:
>=20
>  [  690.429122] WARNING: CPU: 0 PID: 0 at net/core/dev.c:4268 rps_trigger=
_softirq+0x21/0xb0
>  [  690.431236] Modules linked in: bonding ib_ipoib ipip tunnel4 geneve i=
b_umad ip6_gre ip6_tunnel tunnel6 rdma_ucm nf_tables ip_gre gre mlx5_ib ib_=
uverbs mlx5_core iptable_raw openvswitch nsh xt_conntrack xt_MASQUERADE nf_=
conntrack_netlink nfnetlink rpcrdma ib_iser xt_addrtype libiscsi scsi_trans=
port_iscsi rdma_cm iw_cm iptable_nat nf_nat ib_cm br_netfilter ib_core over=
lay fuse [last unloaded: ib_uverbs]
>  [  690.439693] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.17.0-rc7_net_=
next_4303f9c #1
>  [  690.441709] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS =
rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
>  [  690.444587] RIP: 0010:rps_trigger_softirq+0x21/0xb0
>  [  690.445971] Code: ff 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 8b 05 b1 =
ea 21 01 53 48 89 fb 85 c0 74 1b 65 8b 05 16 56 71 7e a9 00 ff 0f 00 75 02 =
<0f> 0b 65 8b 05 4e 5f 72 7e 85 c0 74 5b 48 8b 83 e0 01 00 00 f6 c4
>  [  690.450682] RSP: 0018:ffffffff82803e70 EFLAGS: 00010046
>  [  690.452106] RAX: 0000000000000001 RBX: ffff88852ca3d400 RCX: ffff8885=
2ca3d540
>  [  690.453972] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8885=
2ca3d400
>  [  690.455860] RBP: 0000000000000000 R08: ffff88852ca3d400 R09: 00000000=
00000001
>  [  690.457684] R10: 0000000000000001 R11: 0000000000000000 R12: 00000000=
00000000
>  [  690.459548] R13: ffff88852ca3d540 R14: ffffffff82829628 R15: 00000000=
00000000
>  [  690.461429] FS:  0000000000000000(0000) GS:ffff88852ca00000(0000) knl=
GS:0000000000000000
>  [  690.463653] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>  [  690.465180] CR2: 00007ff718200b98 CR3: 000000013b4de003 CR4: 00000000=
00370eb0
>  [  690.467022] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000=
00000000
>  [  690.468915] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 00000000=
00000400
>  [  690.470742] Call Trace:
>  [  690.471544]  <TASK>
>  [  690.472242]  flush_smp_call_function_queue+0xe5/0x1e0
>  [  690.473639]  flush_smp_call_function_from_idle+0x5f/0xa0
>=20
>=20
> For some reason - that i haven't looked into yet -
> net_rps_send_ipi() will eventually ____napi_schedule()
> only after enabling IRQ. see net_rps_action_and_irq_enable()

Perfect. There is a do_softirq() in flush_smp_call_function_from_idle()
it so it fine.
PeterZ any idea in how to shut lockdep here? Playing with the preemption
counter will do the trick=E2=80=A6 I'm worried that by disabling BH
unconditionally here it will need to be done by the upper caller and
this in turn will force a BH-flush on PREEMPT_RT. While it looks
harmless in the idle case, it looks bad for migration_cpu_stop().

Sebastian
