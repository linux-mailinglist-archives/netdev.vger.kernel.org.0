Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E5995AC80A
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 00:55:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235217AbiIDWtE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Sep 2022 18:49:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230495AbiIDWtC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Sep 2022 18:49:02 -0400
Received: from shiva-su2.sorbonne-universite.fr (shiva-su2.sorbonne-universite.fr [134.157.0.153])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2BF3228E3C;
        Sun,  4 Sep 2022 15:49:00 -0700 (PDT)
Received: from nirriti.ent.upmc.fr (nirriti.dsi.upmc.fr [134.157.0.215])
        by shiva-su2.sorbonne-universite.fr (Postfix) with ESMTP id 9862D413FDB0;
        Mon,  5 Sep 2022 00:48:57 +0200 (CEST)
Received: from [44.168.19.21] (lfbn-idf1-1-596-24.w86-242.abo.wanadoo.fr [86.242.59.24])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pidoux)
        by nirriti.ent.upmc.fr (Postfix) with ESMTPSA id C373F1234C71D;
        Mon,  5 Sep 2022 00:48:58 +0200 (CEST)
Message-ID: <4cb974e2-d5ba-d610-7fe8-4089256a9854@free.fr>
Date:   Mon, 5 Sep 2022 00:48:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
To:     edumazet@google.com
Cc:     davem@davemloft.net, duoming@zju.edu.cn, f6bvp@free.fr,
        kuba@kernel.org, linux-hams@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, ralf@linux-mips.org
References: <CANn89i+FBa-KLJz5xPvk3jO3Miww4Vs+qw4nPf_9SPwiWpyTWw@mail.gmail.com>
Subject: Re: [PATCH 1/1] [PATCH] net: rose: fix unregistered netdevice:
 waiting for rose0 to become free
Content-Language: en-US
From:   f6bvp <f6bvp@free.fr>
In-Reply-To: <CANn89i+FBa-KLJz5xPvk3jO3Miww4Vs+qw4nPf_9SPwiWpyTWw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,FREEMAIL_FROM,
        NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NEUTRAL,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Linux bernard-f6bvp 6.0.0-rc3-DEBUG+ #6 SMP PREEMPT_DYNAMIC Sun Sep 4 
19:40:14 CEST 2022 x86_64 x86_64 x86_64 GNU/Linux


Trying to removing rose module when it is no more in use is still impossible

# lsmod

Module                  Size  Used by

rose                   53248  -1

ax25                   65536  1 rose



#dmesg
..........
[17199.188170] NET: Unregistered PF_ROSE protocol family

[17209.327901] unregister_netdevice: waiting for rose0 to become free. 
Usage count = 17

[17209.327910] leaked reference.

[17209.327913]  rose_rx_call_request+0x334/0x7b0 [rose]

[17209.327923]  rose_route_frame+0x287/0x740 [rose]

[17209.327928]  ax25_rx_iframe.part.0+0x8a/0x340 [ax25]

[17209.327936]  ax25_rx_iframe+0x13/0x20 [ax25]

[17209.327942]  ax25_std_frame_in+0x7ae/0x810 [ax25]

[17209.327948]  ax25_rcv.constprop.0+0x5ee/0x880 [ax25]

[17209.327953]  ax25_kiss_rcv+0x6c/0x90 [ax25]

[17209.327959]  __netif_receive_skb_one_core+0x91/0xa0

[17209.327964]  __netif_receive_skb+0x15/0x60

[17209.327968]  process_backlog+0x96/0x140

[17209.327971]  __napi_poll+0x33/0x190

[17209.327974]  net_rx_action+0x19f/0x300

[17209.327977]  __do_softirq+0x103/0x366

[17209.327983] leaked reference.

[17209.327985]  rose_rx_call_request+0x334/0x7b0 [rose]

[17209.327990]  rose_loopback_timer+0xa3/0x1c0 [rose]

[17209.327995]  call_timer_fn+0x2c/0x150

[17209.328000]  __run_timers.part.0+0x1d9/0x280

[17209.328003]  run_timer_softirq+0x3f/0xa0

[17209.328007]  __do_softirq+0x103/0x366

[17209.328011] leaked reference.

[17209.328013]  rose_rx_call_request+0x334/0x7b0 [rose]

[17209.328018]  rose_route_frame+0x287/0x740 [rose]

[17209.328023]  ax25_rx_iframe.part.0+0x8a/0x340 [ax25]

[17209.328028]  ax25_rx_iframe+0x13/0x20 [ax25]

[17209.328034]  ax25_std_frame_in+0x7ae/0x810 [ax25]

[17209.328040]  ax25_rcv.constprop.0+0x5ee/0x880 [ax25]

[17209.328045]  ax25_kiss_rcv+0x6c/0x90 [ax25]

[17209.328050]  __netif_receive_skb_one_core+0x91/0xa0

[17209.328054]  __netif_receive_skb+0x15/0x60

[17209.328057]  process_backlog+0x96/0x140

[17209.328060]  __napi_poll+0x33/0x190

[17209.328063]  net_rx_action+0x19f/0x300

[17209.328067]  __do_softirq+0x103/0x366

[17209.328071] leaked reference.

[17209.328072]  rose_rx_call_request+0x334/0x7b0 [rose]

[17209.328077]  rose_loopback_timer+0xa3/0x1c0 [rose]

[17209.328082]  call_timer_fn+0x2c/0x150

[17209.328085]  __run_timers.part.0+0x1d9/0x280

[17209.328089]  run_timer_softirq+0x3f/0xa0

[17209.328092]  __do_softirq+0x103/0x366

[17209.328096] leaked reference.

[17209.328098]  rose_rx_call_request+0x334/0x7b0 [rose]

[17209.328103]  rose_loopback_timer+0xa3/0x1c0 [rose]

[17209.328107]  call_timer_fn+0x2c/0x150

[17209.328111]  __run_timers.part.0+0x1d9/0x280

[17209.328114]  run_timer_softirq+0x3f/0xa0

[17209.328117]  __do_softirq+0x103/0x366

[17209.328121] leaked reference.

[17209.328123]  rose_rx_call_request+0x334/0x7b0 [rose]

[17209.328128]  rose_route_frame+0x287/0x740 [rose]

[17209.328133]  ax25_rx_iframe.part.0+0x8a/0x340 [ax25]

[17209.328138]  ax25_rx_iframe+0x13/0x20 [ax25]

[17209.328144]  ax25_std_frame_in+0x7ae/0x810 [ax25]

[17209.328150]  ax25_rcv.constprop.0+0x5ee/0x880 [ax25]

[17209.328155]  ax25_kiss_rcv+0x6c/0x90 [ax25]

[17209.328160]  __netif_receive_skb_one_core+0x91/0xa0

[17209.328164]  __netif_receive_skb+0x15/0x60

[17209.328167]  process_backlog+0x96/0x140

[17209.328170]  __napi_poll+0x33/0x190

[17209.328173]  net_rx_action+0x19f/0x300

[17209.328176]  __do_softirq+0x103/0x366

[17209.328180] leaked reference.

[17209.328182]  rose_rx_call_request+0x334/0x7b0 [rose]

[17209.328187]  rose_loopback_timer+0xa3/0x1c0 [rose]

[17209.328192]  call_timer_fn+0x2c/0x150

[17209.328195]  __run_timers.part.0+0x1d9/0x280

[17209.328198]  run_timer_softirq+0x3f/0xa0

[17209.328202]  __do_softirq+0x103/0x366

[17209.328206] leaked reference.

[17209.328208]  rose_rx_call_request+0x334/0x7b0 [rose]

[17209.328212]  rose_loopback_timer+0xa3/0x1c0 [rose]

[17209.328217]  call_timer_fn+0x2c/0x150

[17209.328220]  __run_timers.part.0+0x1d9/0x280

[17209.328223]  run_timer_softirq+0x3f/0xa0

[17209.328227]  __do_softirq+0x103/0x366

[17209.328231] leaked reference.

[17209.328232]  rose_rx_call_request+0x334/0x7b0 [rose]

[17209.328237]  rose_loopback_timer+0xa3/0x1c0 [rose]

[17209.328242]  call_timer_fn+0x2c/0x150

[17209.328245]  __run_timers.part.0+0x1d9/0x280

[17209.328248]  run_timer_softirq+0x3f/0xa0

[17209.328252]  __do_softirq+0x103/0x366

[17209.328256] leaked reference.

[17209.328258]  rose_rx_call_request+0x334/0x7b0 [rose]

[17209.328262]  rose_loopback_timer+0xa3/0x1c0 [rose]

[17209.328267]  call_timer_fn+0x2c/0x150

[17209.328270]  __run_timers.part.0+0x1d9/0x280

[17209.328273]  run_timer_softirq+0x3f/0xa0

[17209.328277]  __do_softirq+0x103/0x366








