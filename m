Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 909625E99ED
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 08:55:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233549AbiIZGz4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 02:55:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229898AbiIZGzz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 02:55:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BC3B1FCE0
        for <netdev@vger.kernel.org>; Sun, 25 Sep 2022 23:55:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E4574B80D99
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 06:55:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 856D6C433C1;
        Mon, 26 Sep 2022 06:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664175350;
        bh=5foC364C9cRM9oLxP3HfRBsb+BybVDkvyA1AAe9Pw9A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pCTkXzioYvp69siIS7ZxX7EUeXhGl8rEFG2Lm8aDbD4FBdzupdoXIHRN5WX+8Xl/G
         QIXjq5/e59ZcBGWMRgiSgy1bLcOOZHdnLYeYqqrlqU8fo0rs3A3lF4RoSqUkqM3xny
         9Im+HF1a/MkR7dg6YT9vv7cWmZZi6dNXQd8pIwA4WI0T2XISfQpJTQEeNw4Mz2ByO7
         m9FOpUnlOSKMijsfbZaqRQ5Zg7JlKuwUNvBYt0wptl9iA51n+PFdef/iz5Ug2/JNgH
         GiAzj1Y8oN+5WDnYzQtPUJ41V9/21dvJX+sSxzyg3VO85/Q6jaFrGbIX9ZFtmj9hfR
         fuw1RDXYb+1yw==
Date:   Mon, 26 Sep 2022 09:55:45 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Bharat Bhushan <bbhushan2@marvell.com>
Subject: Re: [PATCH RFC xfrm-next v3 0/8] Extend XFRM core to allow full
 offload configuration
Message-ID: <YzFM8RF0suHc4cKI@unreal>
References: <cover.1662295929.git.leonro@nvidia.com>
 <Yxm8QFvtMcpHWzIy@unreal>
 <20220921075927.3ace0307@kernel.org>
 <YytLwlvza1ulmyTd@unreal>
 <20220925094039.GV2602992@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220925094039.GV2602992@gauss3.secunet.de>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 25, 2022 at 11:40:39AM +0200, Steffen Klassert wrote:
> On Wed, Sep 21, 2022 at 08:37:06PM +0300, Leon Romanovsky wrote:
> > On Wed, Sep 21, 2022 at 07:59:27AM -0700, Jakub Kicinski wrote:
> > > On Thu, 8 Sep 2022 12:56:16 +0300 Leon Romanovsky wrote:
> > > > I have TX traces too and can add if RX are not sufficient. 
> > > 
> > > The perf trace is good, but for those of us not intimately familiar
> > > with xfrm, could you provide some analysis here?
> > 
> > The perf trace presented is for RX path of IPsec crypto offload mode. In that
> > mode, decrypted packet enters the netdev stack to perform various XFRM specific
> > checks.
> 
> Can you provide the perf traces and analysis for the TX side too? That
> would be interesting in particular, because the policy and state lookups
> there happen still in software.

Single core TX (crypto mode) from the same run:
Please notice that it is not really bottleneck, probably RX caused to the situation
where TX was not executed enough. It is also lighter path than RX.

# Children      Self       Samples  Command          Shared Object       Symbol                                        
# ........  ........  ............  ...............  ..................  ..............................................
#
    86.58%     0.00%             0  swapper          [kernel.vmlinux]    [k] secondary_startup_64_no_verify
            |
            ---secondary_startup_64_no_verify
               start_secondary
               cpu_startup_entry
               do_idle
               |          
                --86.37%--cpu_idle_poll
                          |          
                           --24.53%--asm_common_interrupt
                                     |          
                                      --24.48%--common_interrupt
                                                |          
                                                |--23.47%--irq_exit_rcu
                                                |          |          
                                                |           --23.23%--do_softirq_own_stack
                                                |                     |          
                                                |                      --23.17%--asm_call_irq_on_stack
                                                |                                __do_softirq
                                                |                                |          
                                                |                                |--22.23%--net_rx_action
                                                |                                |          |          
                                                |                                |          |--20.17%--gro_cell_poll
                                                |                                |          |          |          
                                                |                                |          |           --20.02%--napi_complete_done
                                                |                                |          |                     |          
                                                |                                |          |                      --19.98%--gro_normal_list.part.154
                                                |                                |          |                                |          
                                                |                                |          |                                 --19.96%--netif_receive_skb_list_internal
                                                |                                |          |                                           |          
                                                |                                |          |                                            --19.89%--__netif_receive_skb_list_core
                                                |                                |          |                                                      |          
                                                |                                |          |                                                       --19.77%--ip_list_rcv
                                                |                                |          |                                                                 |          
                                                |                                |          |                                                                  --19.67%--ip_sublist_rcv
                                                |                                |          |                                                                            |          
                                                |                                |          |                                                                             --19.56%--ip_sublist_rcv_finish
                                                |                                |          |                                                                                       |          
                                                |                                |          |                                                                                        --19.54%--ip_local_deliver
                                                |                                |          |                                                                                                  |          
                                                |                                |          |                                                                                                   --19.49%--ip_local_deliver_finish
                                                |                                |          |                                                                                                             |          
                                                |                                |          |                                                                                                              --19.47%--ip_protocol_deliver_rcu
                                                |                                |          |                                                                                                                        |          
                                                |                                |          |                                                                                                                         --19.43%--tcp_v4_rcv
                                                |                                |          |                                                                                                                                   |          
                                                |                                |          |                                                                                                                                    --18.87%--tcp_v4_do_rcv
                                                |                                |          |                                                                                                                                              |          
                                                |                                |          |                                                                                                                                               --18.83%--tcp_rcv_established
                                                |                                |          |                                                                                                                                                         |          
                                                |                                |          |                                                                                                                                                         |--16.41%--__tcp_push_pending_frames
                                                |                                |          |                                                                                                                                                         |          |          
                                                |                                |          |                                                                                                                                                         |           --16.38%--tcp_write_xmit
                                                |                                |          |                                                                                                                                                         |                     |          
                                                |                                |          |                                                                                                                                                         |                     |--6.35%--tcp_event_new_data_sent
                                                |                                |          |                                                                                                                                                         |                     |          |          
                                                |                                |          |                                                                                                                                                         |                     |           --6.22%--sk_reset_timer
                                                |                                |          |                                                                                                                                                         |                     |                     |          
                                                |                                |          |                                                                                                                                                         |                     |                      --6.21%--mod_timer
                                                |                                |          |                                                                                                                                                         |                     |                                |          
                                                |                                |          |                                                                                                                                                         |                     |                                 --6.10%--get_nohz_timer_target
                                                |                                |          |                                                                                                                                                         |                     |                                           |          
                                                |                                |          |                                                                                                                                                         |                     |                                            --1.87%--cpumask_next_and
                                                |                                |          |                                                                                                                                                         |                     |                                                      |          
                                                |                                |          |                                                                                                                                                         |                     |                                                       --1.07%--_find_next_bit.constprop.1
                                                |                                |          |                                                                                                                                                         |                     |          
                                                |                                |          |                                                                                                                                                         |                     |--5.50%--tcp_schedule_loss_probe
                                                |                                |          |                                                                                                                                                         |                     |          |          
                                                |                                |          |                                                                                                                                                         |                     |           --5.49%--sk_reset_timer
                                                |                                |          |                                                                                                                                                         |                     |                     mod_timer
                                                |                                |          |                                                                                                                                                         |                     |                     |          
                                                |                                |          |                                                                                                                                                         |                     |                      --5.43%--get_nohz_timer_target
                                                |                                |          |                                                                                                                                                         |                     |                                |          
                                                |                                |          |                                                                                                                                                         |                     |                                 --1.37%--cpumask_next_and
                                                |                                |          |                                                                                                                                                         |                     |                                           |          
                                                |                                |          |                                                                                                                                                         |                     |                                            --0.71%--_find_next_bit.constprop.1
                                                |                                |          |                                                                                                                                                         |                     |          
                                                |                                |          |                                                                                                                                                         |                      --4.31%--__tcp_transmit_skb
                                                |                                |          |                                                                                                                                                         |                                |          
                                                |                                |          |                                                                                                                                                         |                                 --3.87%--__ip_queue_xmit
                                                |                                |          |                                                                                                                                                         |                                           |          
                                                |                                |          |                                                                                                                                                         |                                            --3.54%--xfrm4_output
                                                |                                |          |                                                                                                                                                         |                                                      |          
                                                |                                |          |                                                                                                                                                         |                                                       --3.26%--xfrm_output_resume
                                                |                                |          |                                                                                                                                                         |                                                                 |          
                                                |                                |          |                                                                                                                                                         |                                                                  --2.88%--ip_output
                                                |                                |          |                                                                                                                                                         |                                                                            |          
                                                |                                |          |                                                                                                                                                         |                                                                             --2.78%--ip_finish_output2
                                                |                                |          |                                                                                                                                                         |                                                                                       |          
                                                |                                |          |                                                                                                                                                         |                                                                                        --2.73%--__dev_queue_xmit
                                                |                                |          |                                                                                                                                                         |                                                                                                  |          
                                                |                                |          |                                                                                                                                                         |                                                                                                   --2.49%--sch_direct_xmit
                                                |                                |          |                                                                                                                                                         |                                                                                                             |          
                                                |                                |          |                                                                                                                                                         |                                                                                                             |--1.50%--validate_xmit_skb_list
               |                                |                                |          |                                                                                                                                                         |                                                                                                             |          |          
                                                |                                |          |                                                                                                                                                         |                                                                                                             |           --1.32%--validate_xmit_skb
                          |                     |                                |          |                                                                                                                                                         |                                                                                                             |                     |          
                                                |                                |          |                                                                                                                                                         |                                                                                                             |                      --1.06%--__skb_gso_segment
                                     |          |                                |          |                                                                                                                                                         |                                                                                                             |                                |          
                                                |                                |          |                                                                                                                                                         |                                                                                                             |                                 --1.04%--skb_mac_gso_segment
                                                |                                |          |                                                                                                                                                         |                                                                                                             |                                           |          
                                                                                 |          |                                                                                                                                                         |                                                                                                             |                                            --1.02%--inet_gso_segment
                                                           |                     |          |                                                                                                                                                         |                                                                                                             |                                                      |          
                                                                                 |          |                                                                                                                                                         |                                                                                                             |                                                       --0.93%--esp4_gso_segment
                                                                      |          |          |                                                                                                                                                         |                                                                                                             |                                                                 |          
                                                                                 |          |                                                                                                                                                         |                                                                                                             |                                                                  --0.86%--tcp_gso_segment
                                                                                 |          |                                                                                                                                                         |                                                                                                             |                                                                            |          
                                                                                            |                                                                                                                                                         |                                                                                                             |                                                                             --0.78%--skb_segment
                                                |                                |          |                                                                                                                                                         |                                                                                                             |          
                                                |                                |          |                                                                                                                                                         |                                                                                                              --0.77%--dev_hard_start_xmit
               |                                |                                |          |                                                                                                                                                         |                                                                                                                        |          
                                                |                                |          |                                                                                                                                                         |                                                                                                                         --0.75%--mlx5e_xmit
                                                |                                |          |                                                                                                                                                         |          
                                                |                                |          |                                                                                                                                                          --1.87%--tcp_ack
                                                |                                |          |                                                                                                                                                                    |          
                                                |                                |          |                                                                                                                                                                     --1.66%--tcp_clean_rtx_queue
                                                |                                |          |                                                                                                                                                                               |          
                                                |                                |          |                                                                                                                                                                                --1.35%--__kfree_skb
                                                |                                |          |                                                                                                                                                                                          |          
                                                |                                |          |                                                                                                                                                                                           --1.21%--skb_release_data
                                                |                                |          |          
                                                |                                |           --1.92%--mlx5e_napi_poll
                                                |                                |                     |          
                                                |                                |                      --1.38%--mlx5e_poll_rx_cq
                                                |                                |                                |          
                                                |                                |                                 --1.33%--mlx5e_handle_rx_cqe
                                                |                                |                                           |          
                                                |                                |                                            --0.53%--napi_gro_receive
                                                |                                |                                                      |          
                                                |                                |                                                       --0.52%--dev_gro_receive
                                                |                                |          
                                                |                                 --0.77%--tasklet_action_common.isra.17
                                                |          
                                                 --0.80%--asm_call_irq_on_stack
                                                           |          
                                                            --0.78%--handle_edge_irq
                                                                      |          
                                                                       --0.74%--handle_irq_event
                                                                                 |          
                                                                                  --0.71%--handle_irq_event_percpu
                                                                                            |          
                                                                                             --0.64%--__handle_irq_event_percpu
                                                                                                       |          
                                                                                                        --0.60%--mlx5_irq_int_handler
                                                                                                                  |          
                                                                                                                   --0.58%--atomic_notifier_call_chain
                                                                                                                             |          
                                                                                                                              --0.57%--mlx5_eq_comp_int

