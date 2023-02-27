Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE0636A35F5
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 01:37:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbjB0Ag5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Feb 2023 19:36:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbjB0Ag4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Feb 2023 19:36:56 -0500
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44A1413534
        for <netdev@vger.kernel.org>; Sun, 26 Feb 2023 16:36:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1677458215; x=1708994215;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JHzVQtp/gD1Vd8DF+6l1jKG6Fk79mcXgSRlVyW3Lzx8=;
  b=V7jcqoVQ/9fKhRA6kjNk0MNDhjn31ab3Heg/DFSM/bo5v3aFDo6xzUjO
   tH748JkZxbAks4wcyKq15Nz1jv2hwaaVMkoVEgNiruVP6IuPnCMMKwhah
   EEkVQe1EI3E23Vf30HEtoNqWZfF1Zz9r/EkRqKAwX8Jc5Q6JvfgZCGXbr
   w=;
X-IronPort-AV: E=Sophos;i="5.97,330,1669075200"; 
   d="scan'208";a="186706292"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1e-m6i4x-9694bb9e.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 00:36:53 +0000
Received: from EX13MTAUWB002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1e-m6i4x-9694bb9e.us-east-1.amazon.com (Postfix) with ESMTPS id 4B989803DE;
        Mon, 27 Feb 2023 00:36:49 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB002.ant.amazon.com (10.43.161.202) with Microsoft SMTP Server (TLS)
 id 15.0.1497.45; Mon, 27 Feb 2023 00:36:48 +0000
Received: from 88665a182662.ant.amazon.com (10.187.171.11) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.24;
 Mon, 27 Feb 2023 00:36:45 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <hauke@hauke-m.de>
CC:     <acme@mandriva.com>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <kuni1840@gmail.com>, <kuniyu@amazon.com>,
        <netdev@vger.kernel.org>, <pabeni@redhat.com>, <tulup@mail.ru>,
        <yangshiji66@qq.com>
Subject: Re: [PATCH v3 net 1/2] dccp/tcp: Avoid negative sk_forward_alloc by ipv6_pinfo.pktoptions.
Date:   Sun, 26 Feb 2023 16:36:37 -0800
Message-ID: <20230227003637.19699-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <eb5ad452-0abe-8ea6-7e9e-1dd16852e8db@hauke-m.de>
References: <eb5ad452-0abe-8ea6-7e9e-1dd16852e8db@hauke-m.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.187.171.11]
X-ClientProxiedBy: EX19D045UWC003.ant.amazon.com (10.13.139.198) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Hauke Mehrtens <hauke@hauke-m.de>
Date:   Mon, 27 Feb 2023 01:17:55 +0100
> On 2/10/23 01:22, Kuniyuki Iwashima wrote:
> > Eric Dumazet pointed out [0] that when we call skb_set_owner_r()
> > for ipv6_pinfo.pktoptions, sk_rmem_schedule() has not been called,
> > resulting in a negative sk_forward_alloc.
> > 
> > We add a new helper which clones a skb and sets its owner only
> > when sk_rmem_schedule() succeeds.
> > 
> > Note that we move skb_set_owner_r() forward in (dccp|tcp)_v6_do_rcv()
> > because tcp_send_synack() can make sk_forward_alloc negative before
> > ipv6_opt_accepted() in the crossed SYN-ACK or self-connect() cases.
> > 
> > [0]: https://lore.kernel.org/netdev/CANn89iK9oc20Jdi_41jb9URdF210r7d1Y-+uypbMSbOfY6jqrg@mail.gmail.com/
> > 
> > Fixes: 323fbd0edf3f ("net: dccp: Add handling of IPV6_PKTOPTIONS to dccp_v6_do_rcv()")
> > Fixes: 3df80d9320bc ("[DCCP]: Introduce DCCPv6")
> > Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> > ---
> > Cc: Andrii <tulup@mail.ru>
> > Cc: Arnaldo Carvalho de Melo <acme@mandriva.com>
> > ---
> >   include/net/sock.h  | 13 +++++++++++++
> >   net/dccp/ipv6.c     |  7 ++-----
> >   net/ipv6/tcp_ipv6.c | 10 +++-------
> >   3 files changed, 18 insertions(+), 12 deletions(-)
> > 
> Hi,
> 
> Multiples people reported kernel warnings after the upgrade from kernel 
> 5.15.94 to 5.15.95 in OpenWrt master, see 
> https://github.com/openwrt/openwrt/pull/12071
> 
> This was seen on a MIPS and a x86 CPU. It is happening when a Windows 
> client connected, it works fine when an Android or iPad connects.
> 
> OpenWrt has some additional patches on top of the kernel, we haven't 
> checked yet if they are causing this problem in combination with this 
> new change. With kernel 5.15.94 as a base it works fine.
> 
> The problem is not showing up when the backport of this patch is reverted.
> 
> This warning was reported:
> 
> [  257.978586] ------------[ cut here ]------------
> [  257.987882] WARNING: CPU: 0 PID: 4377 at net/core/stream.c:212 
> inet_csk_destroy_sock+0x6c/0x17c

Hi,

Thanks for the report.

The both WARNINGs come from the same place which was removed in the
next patch in this series.

It seems the stable tree only backport this patch without the
following one.  I'll cook patches for 4.14/4.19/5.4/5.10/5.15/6.1.
Until they go into the stable, please apply this patch on top of
your tree.
https://lore.kernel.org/netdev/20230210002202.81442-3-kuniyu@amazon.com/

Thanks,
Kuniyuki


> [  258.005287] Modules linked in: rt2800soc rt2800mmio rt2800lib pppoe 
> ppp_async nft_fib_inet nf_flow_table_ipv6 nf_flow_table_ipv4 
> nf_flow_table_inet rt2x00soc rt2x00mmio rt2x00lib pppox ppp_generic 
> nft_reject_ipv6 nft_reject_ipv4 nft_reject_inet nft_reject nft_redir 
> nft_quota nft_objref nft_numgen nft_nat nft_masq nft_log nft_limit 
> nft_hash nft_flow_offload nft_fib_ipv6 nft_fib_ipv4 nft_fib nft_ct 
> nft_counter nft_chain_nat nf_tables nf_nat nf_flow_table nf_conntrack 
> mt76x2e mt76x2_common mt76x02_lib mt76 mac80211 lzo cfg80211 slhc 
> nfnetlink nf_reject_ipv6 nf_reject_ipv4 nf_log_syslog nf_defrag_ipv6 
> nf_defrag_ipv4 lzo_rle lzo_decompress lzo_compress libcrc32c crc_ccitt 
> compat sha256_generic libsha256 seqiv jitterentropy_rng drbg hmac cmac 
> crypto_acompress leds_gpio gpio_button_hotplug crc32c_generic
> [  258.146540] CPU: 0 PID: 4377 Comm: dnsmasq Tainted: G        W 
>   5.15.95 #0
> [  258.161475] Stack : 00000000 00000000 80c099dc 80860000 806b0000 
> 80608730 80f19830 806abe23
> [  258.178178]         808633b4 00001119 00000003 80061c60 80601eac 
> 00000001 80c09998 84245f1d
> [  258.194872]         00000000 00000000 80608730 80c09830 fffff171 
> 00000000 00000000 ffffffea
> [  258.211568]         00000000 80c0983c 00000171 806b2278 80860000 
> 00000009 00000000 804651e0
> [  258.228273]         00000009 00000003 00000002 00000006 00000018 
> 803347a4 00000000 80860000
> [  258.244993]         ...
> [  258.249877] Call Trace:
> [  258.254737] [<8000700c>] show_stack+0x28/0xf0
> [  258.263459] [<8002622c>] __warn+0x9c/0x124
> [  258.271649] [<80026310>] warn_slowpath_fmt+0x5c/0xac
> [  258.281564] [<804651e0>] inet_csk_destroy_sock+0x6c/0x17c
> [  258.292356] [<80479328>] tcp_reset+0x50/0xb0
> [  258.300896] [<8047973c>] tcp_validate_incoming+0x3b4/0x624
> [  258.311853] [<8047bc48>] tcp_rcv_state_process+0x32c/0xf80
> [  258.322810] [<80521fa0>] tcp_v6_do_rcv+0x290/0x4e4
> [  258.332400] [<80522da0>] tcp_v6_rcv+0xbac/0xc3c
> [  258.341454] [<804e6798>] ip6_protocol_deliver_rcu+0x118/0x640
> [  258.352945] [<804e6d6c>] ip6_input+0x84/0x9c
> [  258.361477] [<803e224c>] __netif_receive_skb_one_core+0x44/0x54
> [  258.373306] [<803e22ac>] netif_receive_skb+0x34/0xc8
> [  258.383221] [<8054ba34>] br_handle_frame_finish+0x330/0x5b0
> [  258.394362] [<8054c140>] br_handle_frame+0x48c/0x4fc
> [  258.404279] [<803dfa30>] __netif_receive_skb_core.constprop.0+0x268/0xc30
> [  258.417839] [<803e04e4>] __netif_receive_skb_list_core+0xec/0x224
> [  258.430008] [<803e07c0>] netif_receive_skb_list_internal+0x1a4/0x254
> [  258.442718] [<81c35b08>] ieee80211_rx_napi+0x84/0x8c [mac80211]
> [  258.454881] [<819e07c0>] rt2x00lib_rxdone+0x318/0x940 [rt2x00lib]
> [  258.467100] [<819bf08c>] rt2x00mmio_rxdone+0x8c/0xd8 [rt2x00mmio]
> [  258.479279] [<819f6df0>] rt2800mmio_rxdone_tasklet+0x18/0xac [rt2800mmio]
> [  258.492844] [<800294ec>] tasklet_action_common.constprop.0+0xc0/0xf8
> [  258.505545] [<8057742c>] __do_softirq+0x10c/0x2c4
> [  258.514934] [<80002950>] except_vec_vi_end+0xb8/0xc4
> [  258.524847] [<8013b058>] __do_munmap+0xac/0x54c
> [  258.533917] [<8013b55c>] __vm_munmap+0x64/0xd4
> [  258.542800] [<8000ea44>] syscall_common+0x34/0x58
> [  258.552197]
> [  258.555161] ---[ end trace 5910e4a6b837d518 ]---
> 
> And this one:
> [  259.281306] ------------[ cut here ]------------
> [  259.290596] WARNING: CPU: 0 PID: 502 at net/core/stream.c:212 
> inet_csk_destroy_sock+0x6c/0x17c
> [  259.307833] Modules linked in: rt2800soc rt2800mmio rt2800lib pppoe 
> ppp_async nft_fib_inet nf_flow_table_ipv6 nf_flow_table_ipv4 
> nf_flow_table_inet rt2x00soc rt2x00mmio rt2x00lib pppox ppp_generic 
> nft_reject_ipv6 nft_reject_ipv4 nft_reject_inet nft_reject nft_redir 
> nft_quota nft_objref nft_numgen nft_nat nft_masq nft_log nft_limit 
> nft_hash nft_flow_offload nft_fib_ipv6 nft_fib_ipv4 nft_fib nft_ct 
> nft_counter nft_chain_nat nf_tables nf_nat nf_flow_table nf_conntrack 
> mt76x2e mt76x2_common mt76x02_lib mt76 mac80211 lzo cfg80211 slhc 
> nfnetlink nf_reject_ipv6 nf_reject_ipv4 nf_log_syslog nf_defrag_ipv6 
> nf_defrag_ipv4 lzo_rle lzo_decompress lzo_compress libcrc32c crc_ccitt 
> compat sha256_generic libsha256 seqiv jitterentropy_rng drbg hmac cmac 
> crypto_acompress leds_gpio gpio_button_hotplug crc32c_generic
> [  259.449095] CPU: 0 PID: 502 Comm: napi/phy0-3 Tainted: G        W 
>      5.15.95 #0
> [  259.464551] Stack : 00000000 00000000 81a21934 80860000 806b0000 
> 80608730 80e38870 806abe23
> [  259.481251]         808633b4 000001f6 00000003 80061c60 80601eac 
> 00000001 81a218f0 22ee1ee2
> [  259.497945]         00000000 00000000 80608730 81a21788 fffff19a 
> 00000000 00000000 ffffffea
> [  259.514639]         00000000 81a21794 0000019a 806b2278 80860000 
> 00000009 00000000 804651e0
> [  259.531332]         00000009 00000003 00000002 00000006 00000018 
> 803347a4 00000000 80860000
> [  259.548030]         ...
> [  259.552907] Call Trace:
> [  259.557767] [<8000700c>] show_stack+0x28/0xf0
> [  259.566489] [<8002622c>] __warn+0x9c/0x124
> [  259.574672] [<80026310>] warn_slowpath_fmt+0x5c/0xac
> [  259.584584] [<804651e0>] inet_csk_destroy_sock+0x6c/0x17c
> [  259.595374] [<80479328>] tcp_reset+0x50/0xb0
> [  259.603909] [<8047973c>] tcp_validate_incoming+0x3b4/0x624
> [  259.614861] [<8047bc48>] tcp_rcv_state_process+0x32c/0xf80
> [  259.625817] [<80521fa0>] tcp_v6_do_rcv+0x290/0x4e4
> [  259.635399] [<80522da0>] tcp_v6_rcv+0xbac/0xc3c
> [  259.644451] [<804e6798>] ip6_protocol_deliver_rcu+0x118/0x640
> [  259.655939] [<804e6d6c>] ip6_input+0x84/0x9c
> [  259.664461] [<803e224c>] __netif_receive_skb_one_core+0x44/0x54
> [  259.676289] [<803e22ac>] netif_receive_skb+0x34/0xc8
> [  259.686201] [<8054ba34>] br_handle_frame_finish+0x330/0x5b0
> [  259.697339] [<8054c140>] br_handle_frame+0x48c/0x4fc
> [  259.707255] [<803dfa30>] __netif_receive_skb_core.constprop.0+0x268/0xc30
> [  259.720807] [<803e04e4>] __netif_receive_skb_list_core+0xec/0x224
> [  259.732979] [<803e07c0>] netif_receive_skb_list_internal+0x1a4/0x254
> [  259.745670] [<803e0bf8>] napi_complete_done+0x74/0x214
> [  259.755957] [<818f2484>] mt76_dma_rx_poll+0x4b0/0x50c [mt76]
> [  259.767307] [<803e0e08>] __napi_poll+0x70/0x1f8
> [  259.776358] [<803e1034>] napi_threaded_poll+0xa4/0x110
> [  259.786618] [<80045ef0>] kthread+0x140/0x164
> [  259.795161] [<80002458>] ret_from_kernel_thread+0x14/0x1c
> [  259.805942]
> [  259.808899] ---[ end trace 5910e4a6b837d519 ]---
> 
> Hauke
