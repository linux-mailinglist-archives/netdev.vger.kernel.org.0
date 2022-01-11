Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01D9C48AAC8
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 10:47:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236503AbiAKJrU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 04:47:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbiAKJrT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 04:47:19 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A740C06173F;
        Tue, 11 Jan 2022 01:47:19 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id a5so27873062wrh.5;
        Tue, 11 Jan 2022 01:47:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=v2QJxNFlxychfmc0SUfctPqRHYA6Sjjj+AMrAeb3nUA=;
        b=UVAa4WApJhwYbXwo1m5M54GxZCuqmpUdXXNPk6/F6QpBOKJB9FamCitOVlhYOuUMCy
         MRyVYroL9lRN0WCgB/PuRwVtmMpe2/N2tBMSDrgMVtG42z2dXPiQcqbOO9cZF81+wFDr
         cYsalip7sfL1CD6FxbUQeYIh4ujRUriL2t2mG4qfsgdZ36n2X/aFLljjZIcPOtmA9pyY
         f0FDyymczdpJe+rMxUghtx7sZsjPPolAi3DHtQ8g2OLEq5WfhH825R1qq4kGFJYkaqQL
         sU+l4ux9TbO7yDG7SHigWQZfZvLNwFOD+UuCQ5O8hsexPoGNqQfe+tyzSeIB2UGZ+APu
         rKhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=v2QJxNFlxychfmc0SUfctPqRHYA6Sjjj+AMrAeb3nUA=;
        b=nMSZSviyJSwenmZYxM0juv4aBtBnsYWzA6FzOL3Z8jbmyMZiAhBqtEF/A/JahT6gw/
         YFkva2cCrjlMljhI8BQai9Z0ubuXjoN5zUkTyzJWbByHZHcKI06PeqRn0Cy7C9Xp9w/n
         6KLPNvltHqVKQSvv4xmoq2zlaP395/2xNMQJjKQabfuVNdCX/dd9+LIhx5BqMg5ajEo0
         vLybGPJ+WMVKtCqFNHffxh1XPWjpihWi/2IMoj37ckLMVxOffI3h6al2LBvaMxNolg2M
         I2BX8aE6J8wI27Og3X9dja5rFdcFDT+tPaA6iUtSC/Lq76U1Y7bCROAE/p64ihvpZeTy
         Q+RQ==
X-Gm-Message-State: AOAM53044tC4eOBJw0qonDNntMsgxk9IWQrrqhsn1LGM7UeVt9dehBcE
        m4R3WAs3fjR90tuE1SPSvbI7bctccws=
X-Google-Smtp-Source: ABdhPJzbsMi3KPTqgZxmEncG18p2l/N7sDe7Rezd1sx0CB5XYlfWJzGvc6IktLWJqgY1ZatymC5rew==
X-Received: by 2002:a5d:64c8:: with SMTP id f8mr3375613wri.158.1641894437777;
        Tue, 11 Jan 2022 01:47:17 -0800 (PST)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id p1sm9494239wrr.75.2022.01.11.01.47.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jan 2022 01:47:17 -0800 (PST)
Date:   Tue, 11 Jan 2022 10:47:12 +0100
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Subject: crypto: BUG: spinlock recursion when doing iperf over ipsec with
 crypto hardware device
Message-ID: <Yd1SIHUNdLIvKhzz@Red>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello

I work on adding crypto/engine support to my crypto driver sun4i-ss.
Selftests are passed but when doing iperf over ipsec I hit a spinlock recursion BUG.

This bug happen also against my sun8i-ce driver.
But this bug happen only on ARM (SoCs H3) and not on arm64 (SoCs H6, a64 tested) for it.

This is the full trace:
iperf 3.10.1
Linux buildroot 5.15.13-00003-g14f78eca130d #199 SMP Fri Jan 7 08:35:20 CET 2022 armv7l
Control connection MSS 1386
Time: Fri, 07 Jan 2022 08:52:27 GMT
Connecting to host ipsec.lava.local, port 5201
      Cookie: ylt5ilt5n4jnw72qu2lik5njq63rfalkshz6
      TCP MSS: 1386 (default)
[  5] local 192.168.1.204 port 33828 connected to 192.168.1.40 port 5201
Starting Test: protocol: TCP, 1 streams, 131072 byte blocks, omitting 0 seconds, 10 second test, tos 0
[   44.412526] BUG: spinlock recursion on CPU#0, 1c15000.crypto-/111
[   44.418674]  lock: 0xc3f40268, .magic: dead4ead, .owner: 1c15000.crypto-/111, .owner_cpu: 0
[   44.427040] CPU: 0 PID: 111 Comm: 1c15000.crypto- Not tainted 5.15.13-00003-g14f78eca130d #199
[   44.435647] Hardware name: Allwinner sun8i Family
[   44.440354] [<c010d7a0>] (unwind_backtrace) from [<c0109fa0>] (show_stack+0x10/0x14)
[   44.448110] [<c0109fa0>] (show_stack) from [<c0857fc4>] (dump_stack_lvl+0x40/0x4c)
[   44.455685] [<c0857fc4>] (dump_stack_lvl) from [<c016c5dc>] (do_raw_spin_lock+0x11c/0x120)
[   44.463953] [<c016c5dc>] (do_raw_spin_lock) from [<c0809034>] (xfrm_input+0x17c/0x1304)
[   44.471961] [<c0809034>] (xfrm_input) from [<c07f9804>] (xfrm4_esp_rcv+0x44/0x84)
[   44.479451] [<c07f9804>] (xfrm4_esp_rcv) from [<c0794c58>] (ip_protocol_deliver_rcu+0x2c/0x2b8)
[   44.488156] [<c0794c58>] (ip_protocol_deliver_rcu) from [<c0794f48>] (ip_local_deliver_finish+0x64/0x80)
[   44.497636] [<c0794f48>] (ip_local_deliver_finish) from [<c0793f58>] (ip_sublist_rcv_finish+0x3c/0x50)
[   44.506944] [<c0793f58>] (ip_sublist_rcv_finish) from [<c0794af8>] (ip_sublist_rcv+0x180/0x1a0)
[   44.515645] [<c0794af8>] (ip_sublist_rcv) from [<c07952d8>] (ip_list_rcv+0xf0/0x110)
[   44.523391] [<c07952d8>] (ip_list_rcv) from [<c0735f5c>] (__netif_receive_skb_list_core+0x194/0x1fc)
[   44.532527] [<c0735f5c>] (__netif_receive_skb_list_core) from [<c07361b0>] (netif_receive_skb_list_internal+0x1ec/0x304)
[   44.543394] [<c07361b0>] (netif_receive_skb_list_internal) from [<c0736ef0>] (napi_complete_done+0x130/0x1c8)
[   44.553306] [<c0736ef0>] (napi_complete_done) from [<c05ab408>] (stmmac_napi_poll_rx+0xa7c/0xbd8)
[   44.562182] [<c05ab408>] (stmmac_napi_poll_rx) from [<c0736fb0>] (__napi_poll+0x28/0x170)
[   44.570359] [<c0736fb0>] (__napi_poll) from [<c0737364>] (net_rx_action+0xf0/0x278)
[   44.578016] [<c0737364>] (net_rx_action) from [<c010126c>] (__do_softirq+0x104/0x29c)
[   44.585848] [<c010126c>] (__do_softirq) from [<c01231ac>] (irq_exit+0xbc/0x100)
[   44.593162] [<c01231ac>] (irq_exit) from [<c0174300>] (handle_domain_irq+0x60/0x78)
[   44.600824] [<c0174300>] (handle_domain_irq) from [<c044000c>] (gic_handle_irq+0x7c/0x90)
[   44.609007] [<c044000c>] (gic_handle_irq) from [<c0100afc>] (__irq_svc+0x5c/0x78)
[   44.616491] Exception stack(0xc1b79e38 to 0xc1b79e80)
[   44.621541] 9e20:                                                       c1c13c00 c0de5100
[   44.629712] 9e40: c1b78000 00000002 c3f40240 ffffe000 ec010000 c1b78000 00000002 00000000
[   44.637883] 9e60: c3f40268 c0de5100 c3c369c0 c1b79e88 c0809388 c080b9d4 a0000113 ffffffff
[   44.646050] [<c0100afc>] (__irq_svc) from [<c080b9d4>] (xfrm_replay_advance+0x11c/0x3dc)
[   44.654143] [<c080b9d4>] (xfrm_replay_advance) from [<c0809388>] (xfrm_input+0x4d0/0x1304)
[   44.662408] [<c0809388>] (xfrm_input) from [<c03a3d88>] (crypto_finalize_request+0x5c/0xc4)
[   44.670766] [<c03a3d88>] (crypto_finalize_request) from [<c06a0888>] (sun8i_ce_cipher_run+0x34/0x3c)
[   44.679900] [<c06a0888>] (sun8i_ce_cipher_run) from [<c03a4264>] (crypto_pump_work+0x1a8/0x330)
[   44.688600] [<c03a4264>] (crypto_pump_work) from [<c013e448>] (kthread_worker_fn+0xd8/0x220)
[   44.697045] [<c013e448>] (kthread_worker_fn) from [<c013f708>] (kthread+0x15c/0x180)
[   44.704793] [<c013f708>] (kthread) from [<c0100130>] (ret_from_fork+0x14/0x24)
[   44.712017] Exception stack(0xc1b79fb0 to 0xc1b79ff8)
[   44.717066] 9fa0:                                     00000000 00000000 00000000 00000000
[   44.725237] 9fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[   44.733406] 9fe0: 00000000 00000000 00000000 00000000 00000013 00000000
[ ID] Interval           Transfer     Bitrate         Retr  Cwnd
[  5]   0.00-1.11   sec  1.11 MBytes  8.39 Mbits/sec    1   1.35 KBytes       
[  5]   1.11-2.00   sec  0.00 Bytes  0.00 bits/sec    0   1.35 KBytes       
[   46.438402] sched: RT throttling activated
[   46.438402] sched: RT throttling activated
[  5]   2.00-3.00   sec  0.00 Bytes  0.00 bits/sec    0   1.35 KBytes       
[  5]   3.00-4.00   sec  0.00 Bytes  0.00 bits/sec    0   1.35 KBytes       
[  5]   4.00-5.00   sec  0.00 Bytes  0.00 bits/sec    0   1.35 KBytes       
[  5]   5.00-6.00   sec  0.00 Bytes  0.00 bits/sec    0   1.35 KBytes       
[  5]   6.00-7.00   sec  0.00 Bytes  0.00 bits/sec    0   1.35 KBytes       
[  5]   7.00-8.00   sec  0.00 Bytes  0.00 bits/sec    0   1.35 KBytes       
[  5]   8.00-9.00   sec  0.00 Bytes  0.00 bits/sec    0   1.35 KBytes       
[   65.398401] rcu: INFO: rcu_sched self-detected stall on CPU
[   65.403987] rcu: 	0-....: (2068 ticks this GP) idle=afd/1/0x40000004 softirq=3056/3057 fqs=1050 
[   65.412774] 	(t=2102 jiffies g=1437 q=434)
[   65.416873] NMI backtrace for cpu 0
[   65.420361] CPU: 0 PID: 111 Comm: 1c15000.crypto- Not tainted 5.15.13-00003-g14f78eca130d #199
[   65.428965] Hardware name: Allwinner sun8i Family
[   65.433669] [<c010d7a0>] (unwind_backtrace) from [<c0109fa0>] (show_stack+0x10/0x14)
[   65.441424] [<c0109fa0>] (show_stack) from [<c0857fc4>] (dump_stack_lvl+0x40/0x4c)
[   65.448998] [<c0857fc4>] (dump_stack_lvl) from [<c042dc1c>] (nmi_cpu_backtrace+0xdc/0x110)
[   65.457267] [<c042dc1c>] (nmi_cpu_backtrace) from [<c042dd58>] (nmi_trigger_cpumask_backtrace+0x108/0x168)
[   65.466918] [<c042dd58>] (nmi_trigger_cpumask_backtrace) from [<c0856bf8>] (rcu_dump_cpu_stacks+0x128/0x15c)
[   65.476745] [<c0856bf8>] (rcu_dump_cpu_stacks) from [<c0188224>] (rcu_sched_clock_irq+0x798/0x950)
[   65.485707] [<c0188224>] (rcu_sched_clock_irq) from [<c0193608>] (update_process_times+0x9c/0xd0)
[   65.494581] [<c0193608>] (update_process_times) from [<c01a5b14>] (tick_sched_timer+0x7c/0xf0)
[   65.503197] [<c01a5b14>] (tick_sched_timer) from [<c0193e3c>] (__hrtimer_run_queues+0x15c/0x218)
[   65.511984] [<c0193e3c>] (__hrtimer_run_queues) from [<c0194efc>] (hrtimer_interrupt+0x124/0x2b0)
[   65.520857] [<c0194efc>] (hrtimer_interrupt) from [<c06a552c>] (arch_timer_handler_phys+0x28/0x30)
[   65.529820] [<c06a552c>] (arch_timer_handler_phys) from [<c017a654>] (handle_percpu_devid_irq+0x78/0x13c)
[   65.539388] [<c017a654>] (handle_percpu_devid_irq) from [<c01742fc>] (handle_domain_irq+0x5c/0x78)
[   65.548352] [<c01742fc>] (handle_domain_irq) from [<c044000c>] (gic_handle_irq+0x7c/0x90)
[   65.556533] [<c044000c>] (gic_handle_irq) from [<c0100afc>] (__irq_svc+0x5c/0x78)
[   65.564017] Exception stack(0xc1b79a30 to 0xc1b79a78)
[   65.569067] 9a20:                                     00000000 00000000 000003dc 000003da
[   65.577238] 9a40: c3f40268 ffffe000 00000000 c1b78000 00000002 00000000 c3f40268 c0de5100
[   65.585408] 9a60: c0b496d0 c1b79a80 c016c5b0 c016c538 80000113 ffffffff
[   65.592015] [<c0100afc>] (__irq_svc) from [<c016c538>] (do_raw_spin_lock+0x78/0x120)
[   65.599759] [<c016c538>] (do_raw_spin_lock) from [<c0809034>] (xfrm_input+0x17c/0x1304)
[   65.607765] [<c0809034>] (xfrm_input) from [<c07f9804>] (xfrm4_esp_rcv+0x44/0x84)
[   65.615255] [<c07f9804>] (xfrm4_esp_rcv) from [<c0794c58>] (ip_protocol_deliver_rcu+0x2c/0x2b8)
[   65.623960] [<c0794c58>] (ip_protocol_deliver_rcu) from [<c0794f48>] (ip_local_deliver_finish+0x64/0x80)
[   65.633440] [<c0794f48>] (ip_local_deliver_finish) from [<c0793f58>] (ip_sublist_rcv_finish+0x3c/0x50)
[   65.642747] [<c0793f58>] (ip_sublist_rcv_finish) from [<c0794af8>] (ip_sublist_rcv+0x180/0x1a0)
[   65.651447] [<c0794af8>] (ip_sublist_rcv) from [<c07952d8>] (ip_list_rcv+0xf0/0x110)
[   65.659193] [<c07952d8>] (ip_list_rcv) from [<c0735f5c>] (__netif_receive_skb_list_core+0x194/0x1fc)
[   65.668329] [<c0735f5c>] (__netif_receive_skb_list_core) from [<c07361b0>] (netif_receive_skb_list_internal+0x1ec/0x304)
[   65.679196] [<c07361b0>] (netif_receive_skb_list_internal) from [<c0736ef0>] (napi_complete_done+0x130/0x1c8)
[   65.689108] [<c0736ef0>] (napi_complete_done) from [<c05ab408>] (stmmac_napi_poll_rx+0xa7c/0xbd8)
[   65.697982] [<c05ab408>] (stmmac_napi_poll_rx) from [<c0736fb0>] (__napi_poll+0x28/0x170)
[   65.706159] [<c0736fb0>] (__napi_poll) from [<c0737364>] (net_rx_action+0xf0/0x278)
[   65.713816] [<c0737364>] (net_rx_action) from [<c010126c>] (__do_softirq+0x104/0x29c)
[   65.721647] [<c010126c>] (__do_softirq) from [<c01231ac>] (irq_exit+0xbc/0x100)
[   65.728960] [<c01231ac>] (irq_exit) from [<c0174300>] (handle_domain_irq+0x60/0x78)
[   65.736620] [<c0174300>] (handle_domain_irq) from [<c044000c>] (gic_handle_irq+0x7c/0x90)
[   65.744799] [<c044000c>] (gic_handle_irq) from [<c0100afc>] (__irq_svc+0x5c/0x78)
[   65.752281] Exception stack(0xc1b79e38 to 0xc1b79e80)
[   65.757329] 9e20:                                                       c1c13c00 c0de5100
[   65.765500] 9e40: c1b78000 00000002 c3f40240 ffffe000 ec010000 c1b78000 00000002 00000000
[   65.773671] 9e60: c3f40268 c0de5100 c3c369c0 c1b79e88 c0809388 c080b9d4 a0000113 ffffffff
[   65.781837] [<c0100afc>] (__irq_svc) from [<c080b9d4>] (xfrm_replay_advance+0x11c/0x3dc)
[   65.789929] [<c080b9d4>] (xfrm_replay_advance) from [<c0809388>] (xfrm_input+0x4d0/0x1304)
[   65.798196] [<c0809388>] (xfrm_input) from [<c03a3d88>] (crypto_finalize_request+0x5c/0xc4)
[   65.806552] [<c03a3d88>] (crypto_finalize_request) from [<c06a0888>] (sun8i_ce_cipher_run+0x34/0x3c)
[   65.815686] [<c06a0888>] (sun8i_ce_cipher_run) from [<c03a4264>] (crypto_pump_work+0x1a8/0x330)
[   65.824384] [<c03a4264>] (crypto_pump_work) from [<c013e448>] (kthread_worker_fn+0xd8/0x220)
[   65.832827] [<c013e448>] (kthread_worker_fn) from [<c013f708>] (kthread+0x15c/0x180)
[   65.840574] [<c013f708>] (kthread) from [<c0100130>] (ret_from_fork+0x14/0x24)
[   65.847799] Exception stack(0xc1b79fb0 to 0xc1b79ff8)
[   65.852847] 9fa0:                                     00000000 00000000 00000000 00000000
[   65.861017] 9fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[   65.869186] 9fe0: 00000000 00000000 00000000 00000000 00000013 00000000
[  128.458402] rcu: INFO: rcu_sched self-detected stall on CPU
[  128.463984] rcu: 	0-....: (8328 ticks this GP) idle=afd/1/0x40000004 softirq=3056/3057 fqs=3872 
[  128.472769] 	(t=8408 jiffies g=1437 q=435)
[  128.476867] NMI backtrace for cpu 0
[  128.480354] CPU: 0 PID: 111 Comm: 1c15000.crypto- Not tainted 5.15.13-00003-g14f78eca130d #199
[  128.488958] Hardware name: Allwinner sun8i Family
[  128.493660] [<c010d7a0>] (unwind_backtrace) from [<c0109fa0>] (show_stack+0x10/0x14)
[  128.501413] [<c0109fa0>] (show_stack) from [<c0857fc4>] (dump_stack_lvl+0x40/0x4c)
[  128.508985] [<c0857fc4>] (dump_stack_lvl) from [<c042dc1c>] (nmi_cpu_backtrace+0xdc/0x110)
[  128.517252] [<c042dc1c>] (nmi_cpu_backtrace) from [<c042dd58>] (nmi_trigger_cpumask_backtrace+0x108/0x168)
[  128.526904] [<c042dd58>] (nmi_trigger_cpumask_backtrace) from [<c0856bf8>] (rcu_dump_cpu_stacks+0x128/0x15c)
[  128.536730] [<c0856bf8>] (rcu_dump_cpu_stacks) from [<c0188224>] (rcu_sched_clock_irq+0x798/0x950)
[  128.545691] [<c0188224>] (rcu_sched_clock_irq) from [<c0193608>] (update_process_times+0x9c/0xd0)
[  128.554564] [<c0193608>] (update_process_times) from [<c01a5b14>] (tick_sched_timer+0x7c/0xf0)
[  128.563179] [<c01a5b14>] (tick_sched_timer) from [<c0193e3c>] (__hrtimer_run_queues+0x15c/0x218)
[  128.571966] [<c0193e3c>] (__hrtimer_run_queues) from [<c0194efc>] (hrtimer_interrupt+0x124/0x2b0)
[  128.580838] [<c0194efc>] (hrtimer_interrupt) from [<c06a552c>] (arch_timer_handler_phys+0x28/0x30)
[  128.589800] [<c06a552c>] (arch_timer_handler_phys) from [<c017a654>] (handle_percpu_devid_irq+0x78/0x13c)
[  128.599369] [<c017a654>] (handle_percpu_devid_irq) from [<c01742fc>] (handle_domain_irq+0x5c/0x78)
[  128.608332] [<c01742fc>] (handle_domain_irq) from [<c044000c>] (gic_handle_irq+0x7c/0x90)
[  128.616514] [<c044000c>] (gic_handle_irq) from [<c0100afc>] (__irq_svc+0x5c/0x78)
[  128.623997] Exception stack(0xc1b79a30 to 0xc1b79a78)
[  128.629047] 9a20:                                     00000000 00000000 000003dc 000003da
[  128.637218] 9a40: c3f40268 ffffe000 00000000 c1b78000 00000002 00000000 c3f40268 c0de5100
[  128.645388] 9a60: c0b496d0 c1b79a80 c016c5b0 c016c538 80000113 ffffffff
[  128.651995] [<c0100afc>] (__irq_svc) from [<c016c538>] (do_raw_spin_lock+0x78/0x120)
[  128.659738] [<c016c538>] (do_raw_spin_lock) from [<c0809034>] (xfrm_input+0x17c/0x1304)
[  128.667744] [<c0809034>] (xfrm_input) from [<c07f9804>] (xfrm4_esp_rcv+0x44/0x84)
[  128.675233] [<c07f9804>] (xfrm4_esp_rcv) from [<c0794c58>] (ip_protocol_deliver_rcu+0x2c/0x2b8)
[  128.683936] [<c0794c58>] (ip_protocol_deliver_rcu) from [<c0794f48>] (ip_local_deliver_finish+0x64/0x80)
[  128.693408] [<c0794f48>] (ip_local_deliver_finish) from [<c0793f58>] (ip_sublist_rcv_finish+0x3c/0x50)
[  128.702716] [<c0793f58>] (ip_sublist_rcv_finish) from [<c0794af8>] (ip_sublist_rcv+0x180/0x1a0)
[  128.711417] [<c0794af8>] (ip_sublist_rcv) from [<c07952d8>] (ip_list_rcv+0xf0/0x110)
[  128.719163] [<c07952d8>] (ip_list_rcv) from [<c0735f5c>] (__netif_receive_skb_list_core+0x194/0x1fc)
[  128.728299] [<c0735f5c>] (__netif_receive_skb_list_core) from [<c07361b0>] (netif_receive_skb_list_internal+0x1ec/0x304)
[  128.739165] [<c07361b0>] (netif_receive_skb_list_internal) from [<c0736ef0>] (napi_complete_done+0x130/0x1c8)
[  128.749077] [<c0736ef0>] (napi_complete_done) from [<c05ab408>] (stmmac_napi_poll_rx+0xa7c/0xbd8)
[  128.757951] [<c05ab408>] (stmmac_napi_poll_rx) from [<c0736fb0>] (__napi_poll+0x28/0x170)
[  128.766129] [<c0736fb0>] (__napi_poll) from [<c0737364>] (net_rx_action+0xf0/0x278)
[  128.773786] [<c0737364>] (net_rx_action) from [<c010126c>] (__do_softirq+0x104/0x29c)
[  128.781617] [<c010126c>] (__do_softirq) from [<c01231ac>] (irq_exit+0xbc/0x100)
[  128.788930] [<c01231ac>] (irq_exit) from [<c0174300>] (handle_domain_irq+0x60/0x78)
[  128.796589] [<c0174300>] (handle_domain_irq) from [<c044000c>] (gic_handle_irq+0x7c/0x90)
[  128.804768] [<c044000c>] (gic_handle_irq) from [<c0100afc>] (__irq_svc+0x5c/0x78)
[  128.812250] Exception stack(0xc1b79e38 to 0xc1b79e80)
[  128.817298] 9e20:                                                       c1c13c00 c0de5100
[  128.825469] 9e40: c1b78000 00000002 c3f40240 ffffe000 ec010000 c1b78000 00000002 00000000
[  128.833640] 9e60: c3f40268 c0de5100 c3c369c0 c1b79e88 c0809388 c080b9d4 a0000113 ffffffff
[  128.841806] [<c0100afc>] (__irq_svc) from [<c080b9d4>] (xfrm_replay_advance+0x11c/0x3dc)
[  128.849898] [<c080b9d4>] (xfrm_replay_advance) from [<c0809388>] (xfrm_input+0x4d0/0x1304)
[  128.858163] [<c0809388>] (xfrm_input) from [<c03a3d88>] (crypto_finalize_request+0x5c/0xc4)
[  128.866518] [<c03a3d88>] (crypto_finalize_request) from [<c06a0888>] (sun8i_ce_cipher_run+0x34/0x3c)
[  128.875651] [<c06a0888>] (sun8i_ce_cipher_run) from [<c03a4264>] (crypto_pump_work+0x1a8/0x330)
[  128.884349] [<c03a4264>] (crypto_pump_work) from [<c013e448>] (kthread_worker_fn+0xd8/0x220)
[  128.892790] [<c013e448>] (kthread_worker_fn) from [<c013f708>] (kthread+0x15c/0x180)
[  128.900537] [<c013f708>] (kthread) from [<c0100130>] (ret_from_fork+0x14/0x24)
[  128.907760] Exception stack(0xc1b79fb0 to 0xc1b79ff8)
[  128.912809] 9fa0:                                     00000000 00000000 00000000 00000000
[  128.920978] 9fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[  128.929147] 9fe0: 00000000 00000000 00000000 00000000 00000013 00000000

None on my drivers are using spinlock so the only one which remains is crypto/engine one (queue_lock)

I have started to bisect this, but this lead to unrelated commits. (I tried twice with different starting point)

Known broken version are
5.13 5.14 5.15.13 next-20220105 5.10
I randomly hit also "NOHZ tick-stop error: Non-RCU local softirq work is pending, handler #08!!!".
On 5.6 and 5.7 I got: NOHZ: local_softirq_pending 08

Working version are 5.4.170 and 5.5

The normal iperf performance is at least 30Mbit/s, when bug is present, iperf never end.
But When the bug is present with "NOHZ: local_softirq_pending 08", iperf give 1Mbit/s.

I started also to test other crypto driver which use the crypto/crypto_engine
On my sun8i-ss, no kernel trace are given, but iperf performance decrease is present.
I also tested omap-aes and it seems un-impacted.

Any help to debug that is welcome.
Thanks in advance

Regards

