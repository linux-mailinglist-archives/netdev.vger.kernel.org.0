Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 395E84DD8B7
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 12:09:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235480AbiCRLJB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 07:09:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230497AbiCRLJA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 07:09:00 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [176.9.125.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 956EBF3F94;
        Fri, 18 Mar 2022 04:07:40 -0700 (PDT)
Received: from apollo.. (unknown [IPv6:2a02:810b:4340:43bf:4685:ff:fe12:5967])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 7843D22239;
        Fri, 18 Mar 2022 12:07:38 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1647601659;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kpZldNNYBJTp9yf5Y+ivhFJC/uN9Z5dpmxTpmvhEQG8=;
        b=WJLvZBA4z31N9K2YLGi6hW3RzzZ+JnTaeU99GUKXDtuyQhPkQfmbDfKd15J2sBy8Z5o94t
        h0vkbObsAyDJOGVoGGYtUZrOF+F/W1O7/rS4/gtFSXWmfAgNpQSFwm5tcoDe6xSa+A4G1+
        WRKR5LCMx5MlfFiwxPTXujR8MyvvY7U=
From:   Michael Walle <michael@walle.cc>
To:     horatiu.vultur@microchip.com
Cc:     UNGLinuxDriver@microchip.com, davem@davemloft.net,
        devicetree@vger.kernel.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        robh+dt@kernel.org, Michael Walle <michael@walle.cc>
Subject: Re: [PATCH net-next 0/5] net: lan966x: Add support for FDMA
Date:   Fri, 18 Mar 2022 12:07:31 +0100
Message-Id: <20220318110731.27794-1-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220317185159.1661469-1-horatiu.vultur@microchip.com>
References: <20220317185159.1661469-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Horatiu,

> Currently when injecting or extracting a frame from CPU, the frame
> is given to the HW each word at a time. There is another way to
> inject/extract frames from CPU using FDMA(Frame Direct Memory Access).
> In this way the entire frame is given to the HW. This improves both
> RX and TX bitrate.

I wanted to test this. ping and such works fine and I'm also
seeing fdma interrupts. But as soon as I try iperf3 I get a skb_panic
(due to frame size?). Hope that splash below helps.

-michael

[  159.778850] skbuff: skb_over_panic: text:c07960c0 len:106 put:4 head:c8cc6e00 data:c8cc6e9a tail:0xc8cc6f04 end:0xc8cc6f00 dev:eth0
[  159.788067] ------------[ cut here ]------------
[  159.792575] kernel BUG at net/core/skbuff.c:113!
..
[  160.620995] Backtrace:
[  160.623426] [<c0a62350>] (skb_panic) from [<c08876f8>] (skb_put+0x54/0x58)
[  160.630284] [<c08876a4>] (skb_put) from [<c07960c0>] (lan966x_fdma_xmit+0x108/0x504)
[  160.638011]  r5:00000000 r4:00000000
[  160.641566] [<c0795fb8>] (lan966x_fdma_xmit) from [<c078cdf8>] (lan966x_port_xmit+0x1b0/0x450)
[  160.650171]  r10:c1960160 r9:c1960040 r8:00000001 r7:0000001c r6:c196b000 r5:c891a780
[  160.657973]  r4:00000000
[  160.660488] [<c078cc48>] (lan966x_port_xmit) from [<c08a3e24>] (dev_hard_start_xmit+0x114/0x248)
[  160.669267]  r10:c0f016e8 r9:c0f060cc r8:c0e8d350 r7:c196ba00 r6:00000000 r5:c196b000
[  160.677069]  r4:c891a780
[  160.679584] [<c08a3d10>] (dev_hard_start_xmit) from [<c0904728>] (sch_direct_xmit+0x11c/0x31c)
[  160.688188]  r10:2a01000a r9:00000000 r8:00000000 r7:c196b000 r6:c196ba00 r5:c891a780
[  160.695991]  r4:c1e57400
[  160.698507] [<c090460c>] (sch_direct_xmit) from [<c08a4520>] (__dev_queue_xmit+0x508/0xaac)
[  160.706850]  r9:c8cc6f00 r8:0000004a r7:00000001 r6:00000000 r5:c1e57400 r4:c891a780
[  160.714565] [<c08a4018>] (__dev_queue_xmit) from [<c08a4ad8>] (dev_queue_xmit+0x14/0x18)
[  160.722648]  r10:2a01000a r9:00000010 r8:0000004a r7:c1e7038c r6:00000000 r5:c891a780
[  160.730451]  r4:c1e70300
[  160.732966] [<c08a4ac4>] (dev_queue_xmit) from [<c092b0c0>] (ip_finish_output2+0x270/0x5dc)
[  160.741300] [<c092ae50>] (ip_finish_output2) from [<c092ceb8>] (__ip_finish_output+0x9c/0x144)
[  160.749903]  r9:c8cdef00 r8:c10833c0 r7:000005dc r6:c8924000 r5:c891a780 r4:c891a780
[  160.757618] [<c092ce1c>] (__ip_finish_output) from [<c092d01c>] (ip_output+0xbc/0xc4)
[  160.765441]  r10:2a01000a r9:c8cdef00 r8:c8cc6e00 r7:c196b000 r6:c8924000 r5:c10833c0
[  160.773244]  r4:c891a780
[  160.775759] [<c092cf60>] (ip_output) from [<c092ab10>] (ip_local_out+0x60/0x6c)
[  160.783058]  r7:00000000 r6:c8924000 r5:c10833c0 r4:c891a780
[  160.788692] [<c092aab0>] (ip_local_out) from [<c092ad74>] (ip_build_and_send_pkt+0x110/0x1ec)
[  160.797206]  r7:00000000 r6:c8d40000 r5:000000c4 r4:c891a780
[  160.802841] [<c092ac64>] (ip_build_and_send_pkt) from [<c0952bb8>] (tcp_v4_send_synack+0xec/0x138)
[  160.811792]  r10:c8cdef00 r9:c0b9b614 r8:c10833c0 r7:8b01000a r6:2a01000a r5:c8d40000
[  160.819595]  r4:c8924000
[  160.822110] [<c0952acc>] (tcp_v4_send_synack) from [<c0941520>] (tcp_conn_request+0x6cc/0x984)
[  160.830711]  r7:c891ab40 r6:c0952acc r5:c8d40000 r4:c8924000
[  160.836345] [<c0940e54>] (tcp_conn_request) from [<c095299c>] (tcp_v4_conn_request+0x38/0x84)
[  160.844863]  r10:c892902a r9:c892903e r8:c10833c0 r7:00000000 r6:00000000 r5:c891ab40
[  160.852666]  r4:c8d40000
[  160.855181] [<c0952964>] (tcp_v4_conn_request) from [<c09d05a0>] (tcp_v6_conn_request+0x12c/0x138)
[  160.864122] [<c09d0474>] (tcp_v6_conn_request) from [<c0948870>] (tcp_rcv_state_process+0x29c/0xf44)
[  160.873240]  r5:c891ab40 r4:c8d40000
[  160.876794] [<c09485d4>] (tcp_rcv_state_process) from [<c0953374>] (tcp_v4_do_rcv+0x110/0x22c)
[  160.885398]  r10:c892902a r9:c892903e r8:c10833c0 r7:00000000 r6:c8d40000 r5:c891ab40
[  160.893201]  r4:c8d40000
[  160.895716] [<c0953264>] (tcp_v4_do_rcv) from [<c0955158>] (tcp_v4_rcv+0xb08/0xba8)
[  160.903362]  r7:00000000 r6:c8d40000 r5:00000000 r4:c891ab40
[  160.908998] [<c0954650>] (tcp_v4_rcv) from [<c09273f4>] (ip_protocol_deliver_rcu+0x34/0x1d8)
[  160.917428]  r10:c10833c0 r9:c891ab40 r8:00000000 r7:c10833c0 r6:c0f06f64 r5:c891ab40
[  160.925230]  r4:00000006
[  160.927746] [<c09273c0>] (ip_protocol_deliver_rcu) from [<c0927640>] (ip_local_deliver+0xa8/0xf0)
[  160.936609]  r8:c0f01c0c r7:c0f01c0c r6:00000000 r5:c0f01bc4 r4:c891ab40
[  160.943283] [<c0927598>] (ip_local_deliver) from [<c0926794>] (ip_sublist_rcv_finish+0x44/0x58)
[  160.951967]  r5:c0f01bc4 r4:c0f01bc4
[  160.955522] [<c0926750>] (ip_sublist_rcv_finish) from [<c0926d58>] (ip_list_rcv_finish.constprop.0+0x10c/0x134)
[  160.965598]  r7:c0f01c0c r6:c0f01bc4 r5:c0f01c0c r4:c0f01c0c
[  160.971232] [<c0926c4c>] (ip_list_rcv_finish.constprop.0) from [<c09277cc>] (ip_list_rcv+0xec/0x114)
[  160.980358]  r10:c0f01c5c r9:c10833c0 r8:c0f01c0c r7:c0f01c5c r6:c10833c0 r5:c196b000
[  160.988160]  r4:c891ab40
[  160.990676] [<c09276e0>] (ip_list_rcv) from [<c08a6328>] (__netif_receive_skb_list_core+0x90/0x214)
[  160.999714]  r10:c196b000 r9:c196b000 r8:00000000 r7:c0f01c5c r6:c0f07450 r5:c891acc0
[  161.007517]  r4:c09276e0
[  161.010032] [<c08a6298>] (__netif_receive_skb_list_core) from [<c08a6670>] (netif_receive_skb_list_internal+0x1c4/0x2c4)
[  161.020893]  r10:c10833b8 r9:c0f08a00 r8:00000000 r7:c0f01d44 r6:c0f01d44 r5:c0f01d44
[  161.028696]  r4:00000000
[  161.031211] [<c08a64ac>] (netif_receive_skb_list_internal) from [<c08a67a8>] (netif_receive_skb_list+0x38/0xe4)
[  161.041291]  r10:c1963de0 r9:f08527d0 r8:f08527c0 r7:00000003 r6:c1960040 r5:c103d920
[  161.049094]  r4:c0f01d44
[  161.051609] [<c08a6770>] (netif_receive_skb_list) from [<c0795af4>] (lan966x_fdma_napi_poll+0x3ec/0x490)
[  161.061081]  r9:f08527d0 r8:f08527c0 r7:00000003 r6:c1960040 r5:c1962de0 r4:00000040
[  161.068796] [<c0795708>] (lan966x_fdma_napi_poll) from [<c08a6ee4>] (__napi_poll+0x34/0x1dc)
[  161.077226]  r10:ef7e6080 r9:c0f01db4 r8:c0f03d00 r7:c0f01db3 r6:00000040 r5:c1963de0
[  161.085029]  r4:00000001
[  161.087545] [<c08a6eb0>] (__napi_poll) from [<c08a7290>] (net_rx_action+0xec/0x288)
[  161.095190]  r7:2e957000 r6:ffffc936 r5:0000012c r4:c1963de0
[  161.100825] [<c08a71a4>] (net_rx_action) from [<c010143c>] (__do_softirq+0x13c/0x384)
[  161.108647]  r10:c0f08a00 r9:00000008 r8:00000100 r7:c1037d40 r6:00000003 r5:00000004
[  161.116451]  r4:c0f0308c
[  161.118966] [<c0101300>] (__do_softirq) from [<c013bc9c>] (irq_exit+0xac/0xdc)
[  161.126182]  r10:c0f04f78 r9:c0f08a00 r8:00000000 r7:c0f01ed4 r6:00000000 r5:c0f01ea0
[  161.133985]  r4:c0f08a00
[  161.136500] [<c013bbf0>] (irq_exit) from [<c0a62c84>] (generic_handle_arch_irq+0x48/0x4c)
[  161.144663]  r5:c0f01ea0 r4:c0e8d358
[  161.148218] [<c0a62c3c>] (generic_handle_arch_irq) from [<c0100be8>] (__irq_svc+0x88/0xb0)
