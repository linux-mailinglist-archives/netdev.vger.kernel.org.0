Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D03746BAB28
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 09:51:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231889AbjCOIvi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 04:51:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231888AbjCOIvR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 04:51:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C58C60D78;
        Wed, 15 Mar 2023 01:50:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DE4F3B81D97;
        Wed, 15 Mar 2023 08:50:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18654C433EF;
        Wed, 15 Mar 2023 08:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678870242;
        bh=6RfLbejOKTiXA62SePp2b8dNKrJtD8jDLe+R+QPG0As=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nOaLWWKCpLqjEouRJyhDxlrajLqETAvpzw9sbmiEYWd4wsYpT8FYTyAcU4udTdYKL
         ZFaMv2p8xBXeWHYlQa7l5s1RsloNDbKr08ofgFD17qC1czZYuEdp9GZBl/VKmkDBnR
         l0kI4oltDZbuDBcgBeBCKHHk/tJYEhvK+TT+bzAGmhm22NNcIoGx7M5we3000YaU9z
         tYHuNjZJyZKEg6WY9rkXNd+XzoP1NB68OJrxDQ8sl+C0PNMKRynO9hPQ+18j1nVxlp
         s5pYpTRT32m7VqUOwUbxVjyPXRjoCTSxLEPYLIJxjvHkZ++jlbm9kcf4S20N3ArCla
         lulPU4YB4tnUg==
Date:   Wed, 15 Mar 2023 10:50:38 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        magnus.karlsson@intel.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com, bpf@vger.kernel.org,
        Larysa Zaremba <larysa.zaremba@intel.com>,
        Chandan Kumar Rout <chandanx.rout@intel.com>
Subject: Re: [PATCH net 1/1] ice: xsk: disable txq irq before flushing hw
Message-ID: <20230315085038.GQ36557@unreal>
References: <20230314174543.1048607-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230314174543.1048607-1-anthony.l.nguyen@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 10:45:43AM -0700, Tony Nguyen wrote:
> From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> 
> ice_qp_dis() intends to stop a given queue pair that is a target of xsk
> pool attach/detach. One of the steps is to disable interrupts on these
> queues. It currently is broken in a way that txq irq is turned off
> *after* HW flush which in turn takes no effect.
> 
> ice_qp_dis():
> -> ice_qvec_dis_irq()
> --> disable rxq irq
> --> flush hw
> -> ice_vsi_stop_tx_ring()
> -->disable txq irq
> 
> Below splat can be triggered by following steps:
> - start xdpsock WITHOUT loading xdp prog
> - run xdp_rxq_info with XDP_TX action on this interface
> - start traffic
> - terminate xdpsock
> 
> [  256.312485] BUG: kernel NULL pointer dereference, address: 0000000000000018
> [  256.319560] #PF: supervisor read access in kernel mode
> [  256.324775] #PF: error_code(0x0000) - not-present page
> [  256.329994] PGD 0 P4D 0
> [  256.332574] Oops: 0000 [#1] PREEMPT SMP NOPTI
> [  256.337006] CPU: 3 PID: 32 Comm: ksoftirqd/3 Tainted: G           OE      6.2.0-rc5+ #51
> [  256.345218] Hardware name: Intel Corporation S2600WFT/S2600WFT, BIOS SE5C620.86B.02.01.0008.031920191559 03/19/2019
> [  256.355807] RIP: 0010:ice_clean_rx_irq_zc+0x9c/0x7d0 [ice]
> [  256.361423] Code: b7 8f 8a 00 00 00 66 39 ca 0f 84 f1 04 00 00 49 8b 47 40 4c 8b 24 d0 41 0f b7 45 04 66 25 ff 3f 66 89 04 24 0f 84 85 02 00 00 <49> 8b 44 24 18 0f b7 14 24 48 05 00 01 00 00 49 89 04 24 49 89 44
> [  256.380463] RSP: 0018:ffffc900088bfd20 EFLAGS: 00010206
> [  256.385765] RAX: 000000000000003c RBX: 0000000000000035 RCX: 000000000000067f
> [  256.393012] RDX: 0000000000000775 RSI: 0000000000000000 RDI: ffff8881deb3ac80
> [  256.400256] RBP: 000000000000003c R08: ffff889847982710 R09: 0000000000010000
> [  256.407500] R10: ffffffff82c060c0 R11: 0000000000000004 R12: 0000000000000000
> [  256.414746] R13: ffff88811165eea0 R14: ffffc9000d255000 R15: ffff888119b37600
> [  256.421990] FS:  0000000000000000(0000) GS:ffff8897e0cc0000(0000) knlGS:0000000000000000
> [  256.430207] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  256.436036] CR2: 0000000000000018 CR3: 0000000005c0a006 CR4: 00000000007706e0
> [  256.443283] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  256.450527] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [  256.457770] PKRU: 55555554
> [  256.460529] Call Trace:
> [  256.463015]  <TASK>
> [  256.465157]  ? ice_xmit_zc+0x6e/0x150 [ice]
> [  256.469437]  ice_napi_poll+0x46d/0x680 [ice]
> [  256.473815]  ? _raw_spin_unlock_irqrestore+0x1b/0x40
> [  256.478863]  __napi_poll+0x29/0x160
> [  256.482409]  net_rx_action+0x136/0x260
> [  256.486222]  __do_softirq+0xe8/0x2e5
> [  256.489853]  ? smpboot_thread_fn+0x2c/0x270
> [  256.494108]  run_ksoftirqd+0x2a/0x50
> [  256.497747]  smpboot_thread_fn+0x1c1/0x270
> [  256.501907]  ? __pfx_smpboot_thread_fn+0x10/0x10
> [  256.506594]  kthread+0xea/0x120
> [  256.509785]  ? __pfx_kthread+0x10/0x10
> [  256.513597]  ret_from_fork+0x29/0x50
> [  256.517238]  </TASK>
> 
> In fact, irqs were not disabled and napi managed to be scheduled and run
> while xsk_pool pointer was still valid, but SW ring of xdp_buff pointers
> was already freed.
> 
> To fix this, call ice_qvec_dis_irq() after ice_vsi_stop_tx_ring(). Also
> while at it, remove redundant ice_clean_rx_ring() call - this is handled
> in ice_qp_clean_rings().
> 
> Fixes: 2d4238f55697 ("ice: Add support for AF_XDP")
> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> Reviewed-by: Larysa Zaremba <larysa.zaremba@intel.com>
> Tested-by: Chandan Kumar Rout <chandanx.rout@intel.com> (A Contingent Worker at Intel)
> Acked-by: John Fastabend <john.fastabend@gmail.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_xsk.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
