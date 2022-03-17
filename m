Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54AD74DCEBB
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 20:22:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237896AbiCQTXV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 15:23:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238071AbiCQTXG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 15:23:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C6902296E6
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 12:21:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C3AF9B81FA4
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 19:21:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59DE2C340E9;
        Thu, 17 Mar 2022 19:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647544906;
        bh=mv1sK5ecKYVXdMmQgWjmwq3KLOo65G7nVhwMbPhuCr0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=D3PsRCPZ6GS/+YkSvx6QM9fWbNoIIW6kCGyGBgVoI4XStwpLBTQHd1HlwDQYffCVb
         fTVlyHPzsi/erK5k1yVJGo762mEvVa90DJ1mJozWhlCod9tectHS0wzhTWXBh6Oem+
         oLqP7dZ1k9rozRplVP9R4I9UaqJfmTEfgXvYEEvIG4jCu3q39rwqvtPubwyamstikB
         /BK6kDk9+7m+dhq+C8KHn10ZpIuLSoegf1tHJq+xT+D5mesTYDnIZrHlYRNK5RdLr5
         dcJ/TTzmwJGqCQ6fjU3Bx0kEZwRauFirMeUgl8dIs8E5+pcdrjuS91n2QOoWvwm5NG
         pSJFUZjxw5mrA==
Date:   Thu, 17 Mar 2022 12:21:45 -0700
From:   Saeed Mahameed <saeed@kernel.org>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH net-next] net: Add lockdep asserts to ____napi_schedule().
Message-ID: <20220317192145.g23wprums5iunx6c@sx1>
References: <YitkzkjU5zng7jAM@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <YitkzkjU5zng7jAM@linutronix.de>
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11 Mar 16:03, Sebastian Andrzej Siewior wrote:
>____napi_schedule() needs to be invoked with disabled interrupts due to
>__raise_softirq_irqoff (in order not to corrupt the per-CPU list).

This patch is likely causing the following call trace when RPS is enabled:

  [  690.429122] WARNING: CPU: 0 PID: 0 at net/core/dev.c:4268 rps_trigger_softirq+0x21/0xb0
  [  690.431236] Modules linked in: bonding ib_ipoib ipip tunnel4 geneve ib_umad ip6_gre ip6_tunnel tunnel6 rdma_ucm nf_tables ip_gre gre mlx5_ib ib_uverbs mlx5_core iptable_raw openvswitch nsh xt_conntrack xt_MASQUERADE nf_conntrack_netlink nfnetlink rpcrdma ib_iser xt_addrtype libiscsi scsi_transport_iscsi rdma_cm iw_cm iptable_nat nf_nat ib_cm br_netfilter ib_core overlay fuse [last unloaded: ib_uverbs]
  [  690.439693] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.17.0-rc7_net_next_4303f9c #1
  [  690.441709] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
  [  690.444587] RIP: 0010:rps_trigger_softirq+0x21/0xb0
  [  690.445971] Code: ff 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 8b 05 b1 ea 21 01 53 48 89 fb 85 c0 74 1b 65 8b 05 16 56 71 7e a9 00 ff 0f 00 75 02 <0f> 0b 65 8b 05 4e 5f 72 7e 85 c0 74 5b 48 8b 83 e0 01 00 00 f6 c4
  [  690.450682] RSP: 0018:ffffffff82803e70 EFLAGS: 00010046
  [  690.452106] RAX: 0000000000000001 RBX: ffff88852ca3d400 RCX: ffff88852ca3d540
  [  690.453972] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88852ca3d400
  [  690.455860] RBP: 0000000000000000 R08: ffff88852ca3d400 R09: 0000000000000001
  [  690.457684] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000000
  [  690.459548] R13: ffff88852ca3d540 R14: ffffffff82829628 R15: 0000000000000000
  [  690.461429] FS:  0000000000000000(0000) GS:ffff88852ca00000(0000) knlGS:0000000000000000
  [  690.463653] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  [  690.465180] CR2: 00007ff718200b98 CR3: 000000013b4de003 CR4: 0000000000370eb0
  [  690.467022] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  [  690.468915] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
  [  690.470742] Call Trace:
  [  690.471544]  <TASK>
  [  690.472242]  flush_smp_call_function_queue+0xe5/0x1e0
  [  690.473639]  flush_smp_call_function_from_idle+0x5f/0xa0


For some reason - that i haven't looked into yet -
net_rps_send_ipi() will eventually ____napi_schedule()
only after enabling IRQ. see net_rps_action_and_irq_enable()

