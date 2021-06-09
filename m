Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EBA03A1CDE
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 20:39:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbhFISlZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 14:41:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbhFISlY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 14:41:24 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50EF8C061574
        for <netdev@vger.kernel.org>; Wed,  9 Jun 2021 11:39:14 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id v22so26120533oic.2
        for <netdev@vger.kernel.org>; Wed, 09 Jun 2021 11:39:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=5WClByDETmZvmm0csnveMZom/CO5vFWxHvQFvCokIB8=;
        b=pBZXe8xcVPqWyzcfB7UbGO/3tGgUaCl7+4/+kir24LshWemnMl4P9ST3rMr35VKGmE
         GYL4ymCvYV+IgehItL7T935tagEXYez+X77luNyIe+QF9d6nbxT1tdlbuEQswydX5ZJM
         6yGO5Jr0vkdLZZLLQeS7PJKnOp3b4b/LKn3HgngXmQWEYarukwuSFYji88V5YJrVzzvt
         e+cSIlpSvHhst0Yz4YV6++eYrMpLPvh5RVUTKghPam1B1uL0I7owyByo0nFUjZR6tf/s
         zWFAh34uZyNtRtM/B0yfxdup7nxNQJHlsgFc3O5ekGooFk+is3fGUtpazl16t1EhS14N
         mZ3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=5WClByDETmZvmm0csnveMZom/CO5vFWxHvQFvCokIB8=;
        b=GkwQU+kdqfIpI/D8jWp1252R48j9AZ32KsR3rLnvrEbsjH0Tz56ZJF2c2wr3vbrnGl
         2GL8+QNeTQSa7TWm2Iips3i0/E+l7VLtdA2x7QcML8PrUPxCed3aEBiXI4ofpPYy5sdP
         sQR0Z9Dl6GymFpwGLPta6fn1/+E8vkd5h8+oDPtDnLtM1RdPMk10qQl9H9hXlcrlXC1j
         x2uxSUfMQufowXFGOWS1+7Fm7zFauJtbyjHHjiU0r6UjpCAnzxCawErcE3pE4/Q3N5ix
         PME1dPvWJc3Ka0zJlUrp7grPjt6u8IG93w949Ggu2J4nFofPJFiY921/io0cbXiXCvxm
         j8OQ==
X-Gm-Message-State: AOAM533amqrXvINLuQuOecYnXtGTU6P4NviJbK87Ql1kEy25yVm8xvpQ
        feXc4f7lA78Evn/thPo8X0phSXXzCYIqnU3RTwAinYBoV4I=
X-Google-Smtp-Source: ABdhPJxXez179tJ/aQ827NOMwsmCm+7btynE9uHLpFlz2Cht5tukqXcqD4TQJVM7/0lCvJgSCP27z4l6oBzmB/8R0CI=
X-Received: by 2002:aca:b8c2:: with SMTP id i185mr4361476oif.172.1623263953425;
 Wed, 09 Jun 2021 11:39:13 -0700 (PDT)
MIME-Version: 1.0
From:   Kristian Evensen <kristian.evensen@gmail.com>
Date:   Wed, 9 Jun 2021 20:39:02 +0200
Message-ID: <CAKfDRXgBcW4Ps57Bfj7y=NwDX3K-vB8Hpa-ykJ0BOnOdUfdcmg@mail.gmail.com>
Subject: Kernel oops when using rmnet together with qmi_wwan on kernel 5.4
To:     Network Development <netdev@vger.kernel.org>,
        subashab@codeaurora.org, stranche@codeaurora.org,
        sharathv@codeaurora.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

I am currently trying to make use of the rmnet passthrough feature
that was recently added to the qmi_wwan driver. Configuring QMAP via
QMI, as well as the rmnet interface, works fine and I can send (and
receive) traffic via the rmnet interface. However, as soon as I start
a  demanding data transfer/transfers (like downloading a file or
running iperf3), I get a kernel oops more or less instantly. The
kernel oops (or rather oopses) comes in a couple of variations, which
I have included at the bottom of the email.

The devices I am working on are based on mt7621/mt7622 and are all
running kernel 5.4.123. The kernel includes a backport of the rmnet
passthrough commit, and I have set the rx_urb_size in qmi_wwan to 32kb
to accommodate the maximum datagram size. What I have tested is:

* I tried with two modem - Quectel EM12 and RM500Q. I can see the
oopses with both.
* I have tried setting the aggregation size to both 16Kb and 32Kb, but
to no effect. Kernel still crashes.
* I have backported all commits to the rmnet driver that are not in
5.4.123. This did not help.
* I have tried with and without QMAPv5, without any luck.
* When I disable QMAP or configure QMAP via qmimux, I do not see the oops.

Does anyone have any idea about what could be wrong, where to look or
how to fix the problem? Are there for example any related commits that
I should backport to my 5.4 kernel?

Thanks in advance for any help,
Kristian

Kernel oops #1:
[   86.338533] CPU 1 Unable to handle kernel paging request at virtual
address 00000000, epc == 8040bba8, ra == 803cd1f8
[   86.359800] Oops[#1]:
[   86.364347] CPU: 1 PID: 15 Comm: ksoftirqd/1 Not tainted 5.4.123 #0
[   86.376829] $ 0   : 00000000 00000001 8e4b7300 00000000
[   86.387251] $ 4   : ff7d68f8 8e4b7300 8e4b7cc0 00000020
[   86.397661] $ 8   : 00000000 00000006 00000240 00000001
[   86.408068] $12   : 01825d69 00000000 00000001 00000000
[   86.418475] $16   : ff7d68f8 00000001 00000040 ff7d68e8
[   86.428886] $20   : 80682040 ffff2f20 8fc77e28 80690000
[   86.439312] $24   : 00000000 80020f4c
[   86.449760] $28   : 8fc76000 8fc77db0 806b0000 803cd1f8
[   86.460196] Hi    : 000002ff
[   86.465923] Lo    : ef9db4cd
[   86.471701] epc   : 8040bba8 gro_cell_poll+0x64/0xb8
[   86.481607] ra    : 803cd1f8 __napi_poll+0x3c/0x10c
[   86.491309] Status: 11007c03 KERNEL EXL IE
[   86.499646] Cause : 4080000c (ExcCode 03)
[   86.507633] BadVA : 00000000
[   86.513374] PrId  : 0001992f (MIPS 1004Kc)
[   86.521521] Modules linked in: qcserial option cdc_mbim wireguard
usb_wwan rndis_host qmi_wwan mt76x2e mt76x2_common mt76x02_lib mt7603e
mt76 mac80211 libchacha20poly1305 libblake2s iptable_nat ipt_REJECT
cfg80211 cdc_ncm cdc_ether ax88179_178a asix xt_time xt_tcpudp
xt_tcpmss xt_string xt_statistic xt_state xt_socket xt_recent xt_quota
xt_policy xt_pkttype xt_owner4
[   86.521861]  nf_flow_table_hw nf_flow_table nf_conntrack_tftp
nf_conntrack_snmp nf_conntrack_sip nf_conntrack_pptp
nf_conntrack_netlink nf_conntrack_irc nf_conntrack_h323
nf_conntrack_ftp nf_conntrack_broadcast ts_kmp nf_conntrack_amanda
nf_conncount libcurve25519_generic libblake2s_generic iptable_rawpost
iptable_raw iptable_mangle iptable_filter ipt_ah ipt_ECN ip6p
[   86.696196]  ip_set nfnetlink nf_log_ipv6 nf_log_common
ip6table_mangle ip6table_filter ip6_tables ip6t_REJECT x_tables
nf_reject_ipv6 ifb sit ipcomp6 xfrm6_tunnel esp6 ah6 xfrm4_tunnel
ipcomp esp4 ah4 ipip tunnel6 tunnel4 ip_tunnel tun xfrm_user
xfrm_ipcomp af_key xfrm_algo vxlan udp_tunnel ip6_udp_tunnel
crypto_user algif_skcipher algif_rng algif_hash algif_aead ai
[   86.989644] Process ksoftirqd/1 (pid: 15, threadinfo=3c98731d,
task=5dab33af, tls=00000000)
[   87.006253] Stack : 81012378 807f4e20 00200000 00000001 806e1e40
00000001 00000040 ff7d68f8
[   87.022884]         8fc77e1f 803cd1f8 00000100 80690000 806dc2b8
80063148 00000001 ff7d68f8
[   87.039513]         810146c0 0000012c 8fc77e20 803cd46c 8fc3dfa0
00000001 00000001 00000040
[   87.056140]         80653a64 806616cc 00000001 007f0000 8fc77e20
8fc77e20 8fc77e28 8fc77e28
[   87.072768]         8068204c 00000028 00000003 806903c4 80682040
806e1aa0 00000100 0000000a
[   87.089396]         ...
[   87.094256] Call Trace:
[   87.099155] [<8040bba8>] gro_cell_poll+0x64/0xb8
[   87.108359] [<803cd1f8>] __napi_poll+0x3c/0x10c
[   87.117371] [<803cd46c>] net_rx_action+0x114/0x28c
[   87.126927] [<80573b54>] __do_softirq+0x16c/0x334
[   87.136317] [<80030034>] run_ksoftirqd+0x5c/0x70
[   87.145524] [<8004e744>] smpboot_thread_fn+0x188/0x1e0
[   87.155768] [<8004a840>] kthread+0x140/0x148
[   87.164267] [<800067d8>] ret_from_kernel_thread+0x14/0x1c
[   87.175006] Code: ac400000  ac400004  acc30004 <ac660000> 0c0f320e
00000000  12510008  8fbf0024  8e02fff0
[   87.194412]
[   87.198839] ---[ end trace 93dbf192b12357e7 ]---
[   87.208094] Kernel panic - not syncing: Fatal exception in interrupt
[   87.220786] ------------[ cut here ]------------
[   87.230049] WARNING: CPU: 1 PID: 15 at kernel/smp.c:433
smp_call_function_many+0x42c/0x448
[   87.246510] Modules linked in: qcserial option cdc_mbim wireguard
usb_wwan rndis_host qmi_wwan mt76x2e mt76x2_common mt76x02_lib mt7603e
mt76 mac80211 libchacha20poly1305 libblake2s iptable_nat ipt_REJECT
cfg80211 cdc_ncm cdc_ether ax88179_178a asix xt_time xt_tcpudp
xt_tcpmss xt_string xt_statistic xt_state xt_socket xt_recent xt_quota
xt_policy xt_pkttype xt_owner4
[   87.246813]  nf_flow_table_hw nf_flow_table nf_conntrack_tftp
nf_conntrack_snmp nf_conntrack_sip nf_conntrack_pptp
nf_conntrack_netlink nf_conntrack_irc nf_conntrack_h323
nf_conntrack_ftp nf_conntrack_broadcast ts_kmp nf_conntrack_amanda
nf_conncount libcurve25519_generic libblake2s_generic iptable_rawpost
iptable_raw iptable_mangle iptable_filter ipt_ah ipt_ECN ip6p
[   87.421114]  ip_set nfnetlink nf_log_ipv6 nf_log_common
ip6table_mangle ip6table_filter ip6_tables ip6t_REJECT x_tables
nf_reject_ipv6 ifb sit ipcomp6 xfrm6_tunnel esp6 ah6 xfrm4_tunnel
ipcomp esp4 ah4 ipip tunnel6 tunnel4 ip_tunnel tun xfrm_user
xfrm_ipcomp af_key xfrm_algo vxlan udp_tunnel ip6_udp_tunnel
crypto_user algif_skcipher algif_rng algif_hash algif_aead ai
[   87.714493] CPU: 1 PID: 15 Comm: ksoftirqd/1 Tainted: G      D
     5.4.123 #0
[   87.729719] Stack : 00000000 8007afa4 80670000 8066ce30 806b0000
8066cdf8 8066bf40 8fc77b1c
[   87.746354]         807f0000 8fc3e348 80692c63 806034b0 00000001
00000001 8fc77ac0 e103f581
[   87.762987]         00000000 00000000 80830000 00000000 00000030
000001a7 20202020 2e342e35
[   87.779618]         00000000 00000004 00000000 000ae6fd 00000000
806b0000 00000000 800ab1c0
[   87.796248]         00000009 00000000 800109ac 00000000 00000002
8030cf44 00000004 807f0004
[   87.812879]         ...
[   87.817740] Call Trace:
[   87.822631] [<8000b60c>] show_stack+0x30/0x100
[   87.831485] [<8055551c>] dump_stack+0xa4/0xdc
[   87.840167] [<8002bd68>] __warn+0xc0/0x10c
[   87.848318] [<8002be10>] warn_slowpath_fmt+0x5c/0xac
[   87.858206] [<800ab1c0>] smp_call_function_many+0x42c/0x448
[   87.869295] [<800ab1fc>] smp_call_function+0x20/0x2c
[   87.879175] [<8002b874>] panic+0x124/0x32c
[   87.887325] [<8000b8c0>] die+0x108/0x114
[   87.895143] [<800173b4>] do_page_fault+0x4a8/0x4b8
[   87.904678] [<8001c478>] tlb_do_page_fault_1+0x118/0x120
[   87.915264] [<803cd1f8>] __napi_poll+0x3c/0x10c
[   87.924280] [<803cd1f8>] __napi_poll+0x3c/0x10c
[   87.933291] [<803cd46c>] net_rx_action+0x114/0x28c
[   87.942851] [<80573b54>] __do_softirq+0x16c/0x334
[   87.952217] [<80030034>] run_ksoftirqd+0x5c/0x70
[   87.961425] [<8004e744>] smpboot_thread_fn+0x188/0x1e0
[   87.971674] [<8004a840>] kthread+0x140/0x148
[   87.980169] [<800067d8>] ret_from_kernel_thread+0x14/0x1c
[   87.990916] ---[ end trace 93dbf192b12357e8 ]---
[   88.000123] Rebooting in 3 seconds..

Kernel oops #2:
[  127.906088] Oops[#1]:
[  127.906105] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 5.4.123 #0
[  127.906114] $ 0   : 00000000 00000001 8e06db40 00000000
[  127.906137] $ 4   : 8e06db40 00000101 00000000 00000004
[  127.906156] $ 8   : 8e008dc8 00000040 00000001 ffffffff
[  127.906174] $12   : ffffffff 806af030 00000001 00000000
[  127.906191] $16   : 81014750 00000004 810146c8 00000040
[  127.906210] $20   : 81014740 8101474c 8fc0ff20 80690000
[  127.906229] $24   : 00000000 80020f4c
[  127.906251] $28   : 8fc62000 8fc0fea0 806b0000 803cb914
[  127.906279] Hi    : 00000000
[  127.906285] Lo    : 0000002d
[  127.906327] epc   : 803cb904 process_backlog+0x8c/0x178
[  127.906337] ra    : 803cb914 process_backlog+0x9c/0x178
[  127.906342] Status: 11007c03 KERNEL EXL IE
[  127.906358] Cause : 4080000c (ExcCode 03)
[  127.906363] BadVA : 00000004
[  127.906370] PrId  : 0001992f (MIPS 1004Kc)
[  127.906375] Modules linked in: qcserial option cdc_mbim wireguard
usb_wwan rndis_host qmi_wwan mt76x2e mt76x2_common mt76x02_lib mt7603e
mt76 mac80211 libchacha20poly1305 libblake2s iptable_nat ipt_REJECT
cfg80211 cdc_ncm cdc_ether ax88179_178a asix xt_time xt_tcpudp
xt_tcpmss xt_string xt_statistic xt_state xt_socket xt_recent xt_quota
xt_policy xt_pkttype xt_owner4
[  127.906739]  nf_flow_table_hw
[  127.919685] usb 2-1.2: GSM modem (1-port) converter now attached to ttyUSB0
[  127.923413]  nf_flow_table nf_conntrack_tftp nf_conntrack_snmp
nf_conntrack_sip nf_conntrack_pptp nf_conntrack_netlink
nf_conntrack_irc nf_conntrack_h323 nf_conntrack_ftp
nf_conntrack_broadcast ts_kmp nf_conntrack_amanda nf_conncount
libcurve25519_generic libblake2s_generic iptable_rawpost iptable_raw
iptable_mangle iptable_filter ipt_ah ipt_ECN ip6table_rawpost ip6k
[  127.923680]  nf_log_ipv6
[  127.936757] option 2-1.2:1.2: GSM modem (1-port) converter detected
[  127.945777]  nf_log_common ip6table_mangle ip6table_filter
ip6_tables ip6t_REJECT x_tables nf_reject_ipv6 ifb sit ipcomp6
xfrm6_tunnel esp6 ah6 xfrm4_tunnel ipcomp esp4 ah4 ipip tunnel6
tunnel4 ip_tunnel tun xfrm_user xfrm_ipcomp af_key xfrm_algo vxlan
udp_tunnel ip6_udp_tunnel crypto_user algif_skcipher algif_rng
algif_hash algif_aead af_alg sha256_generic libsha25i
[  127.957013] usb 2-1.2: GSM modem (1-port) converter now attached to ttyUSB1
[  127.966724] Process swapper/1 (pid: 0, threadinfo=b0ece177,
task=3c25e8a3, tls=00000000)
[  127.966731] Stack : 8e06db40 80683420 00020000 00000001 80820000
00000001 00000040 81014750
[  127.966756]         8fc0ff17 80682040 ffff57b0 803cd1f8 00000000
00005b54 810145ac 00000401
[  127.966785]         806a8680 81014750 810146c0 0000012c 8fc0ff18
803cd46c 806987c0 00000001
[  127.966809]         00000002 80683420 80653a64 806616cc 00000001
007f0000 8fc0ff18 8fc0ff18
[  127.966832]         8fc0ff20 8fc0ff20 8068204c 00000000 00000003
806903c4 80682040 806e1aa0
[  127.966858]         ...
[  127.966868] Call Trace:
[  127.966903] [<803cb904>] process_backlog+0x8c/0x178
[  127.966924] [<803cd1f8>] __napi_poll+0x3c/0x10c
[  127.966937] [<803cd46c>] net_rx_action+0x114/0x28c
[  127.966988] [<80573b54>] __do_softirq+0x16c/0x334
[  127.978771] option 2-1.2:1.3: GSM modem (1-port) converter detected
[  127.987750] [<80030324>] irq_exit+0x98/0xb0
[  127.987783] [<802bad28>] plat_irq_dispatch+0x64/0x104
[  127.998667] usb 2-1.2: GSM modem (1-port) converter now attached to ttyUSB2
[  128.008536] [<80006ce8>] except_vec_vi_end+0xb8/0xc4
[  128.008573] [<80573208>] r4k_wait_irqoff+0x1c/0x24
[  128.008589] Code: 8c820004  ac800000  ac800004 <ac620004> ac430000
0c0f2dd3  00000000  8e02ffb0  26310001
[  128.030486] qmi_wwan 2-1.2:1.4: cdc-wdm0: USB WDM device
[  128.040794]
[  128.041034] ---[ end trace bd74e222fad3dcb2 ]---
[  128.041053] Kernel panic - not syncing: Fatal exception in interrupt
[  128.041066] ------------[ cut here ]------------
[  128.055329] qmi_wwan 2-1.2:1.4 wwan0: register 'qmi_wwan' at
usb-1e1c0000.xhci-1.2, WWAN/QMI device, 06:59:71:d9:c5:ec
[  128.059790] WARNING: CPU: 1 PID: 0 at kernel/smp.c:433
smp_call_function_many+0x42c/0x448
[  128.059797] Modules linked in: qcserial option cdc_mbim wireguard
usb_wwan rndis_host qmi_wwan mt76x2e mt76x2_common mt76x02_lib mt7603e
mt76 mac80211 libchacha20poly1305 libblake2s iptable_nat ipt_REJECT
cfg80211 cdc_ncm cdc_ether ax88179_178a asix xt_time xt_tcpudp
xt_tcpmss xt_string xt_statistic xt_state xt_socket xt_recent xt_quota
xt_policy xt_pkttype xt_owner4
[  128.060093]  nf_flow_table_hw nf_flow_table nf_conntrack_tftp
nf_conntrack_snmp nf_conntrack_sip nf_conntrack_pptp
nf_conntrack_netlink nf_conntrack_irc nf_conntrack_h323
nf_conntrack_ftp nf_conntrack_broadcast ts_kmp nf_conntrack_amanda
nf_conncount libcurve25519_generic libblake2s_generic iptable_rawpost
iptable_raw iptable_mangle iptable_filter ipt_ah ipt_ECN ip6p
[  129.080980]  ip_set nfnetlink nf_log_ipv6 nf_log_common
ip6table_mangle ip6table_filter ip6_tables ip6t_REJECT x_tables
nf_reject_ipv6 ifb sit ipcomp6 xfrm6_tunnel esp6 ah6 xfrm4_tunnel
ipcomp esp4 ah4 ipip tunnel6 tunnel4 ip_tunnel tun xfrm_user
xfrm_ipcomp af_key xfrm_algo vxlan udp_tunnel ip6_udp_tunnel
crypto_user algif_skcipher algif_rng algif_hash algif_aead ai
[  129.374369] CPU: 1 PID: 0 Comm: swapper/1 Tainted: G      D
  5.4.123 #0
[  129.389078] Stack : 00000000 8007afa4 80670000 8066ce30 806b0000
8066cdf8 8066bf40 8fc0fc0c
[  129.405713]         807f0000 8fc3c188 80692c63 806034b0 00000001
00000001 8fc0fbb0 567266f9
[  129.422346]         00000000 00000000 80830000 00000000 00000030
000001ca 342e3520 3332312e
[  129.438978]         00000000 00000006 00000000 0005b661 00000000
806b0000 00000000 800ab1c0
[  129.455607]         00000009 00000000 800109ac 00000000 00000003
8030cf44 00000004 807f0004
[  129.472240]         ...
[  129.477098] Call Trace:
[  129.481990] [<8000b60c>] show_stack+0x30/0x100
[  129.490839] [<8055551c>] dump_stack+0xa4/0xdc
[  129.499520] [<8002bd68>] __warn+0xc0/0x10c
[  129.507668] [<8002be10>] warn_slowpath_fmt+0x5c/0xac
[  129.517570] [<800ab1c0>] smp_call_function_many+0x42c/0x448
[  129.528659] [<800ab1fc>] smp_call_function+0x20/0x2c
[  129.538552] [<8002b874>] panic+0x124/0x32c
[  129.546712] [<8000b8c0>] die+0x108/0x114
[  129.554526] [<800173b4>] do_page_fault+0x4a8/0x4b8
[  129.564075] [<8001c478>] tlb_do_page_fault_1+0x118/0x120
[  129.574665] [<803cb914>] process_backlog+0x9c/0x178
[  129.584380] [<803cd1f8>] __napi_poll+0x3c/0x10c
[  129.593393] [<803cd46c>] net_rx_action+0x114/0x28c
[  129.602948] [<80573b54>] __do_softirq+0x16c/0x334
[  129.612354] [<80030324>] irq_exit+0x98/0xb0
[  129.620691] [<802bad28>] plat_irq_dispatch+0x64/0x104
[  129.630752] [<80006ce8>] except_vec_vi_end+0xb8/0xc4
[  129.640645] [<80573208>] r4k_wait_irqoff+0x1c/0x24
[  129.650181] ---[ end trace bd74e222fad3dcb3 ]---
[  129.659393] Rebooting in 3 seconds..

Kernel oops #3:
[   82.521658] Unhandled kernel unaligned access[#1]:
[   82.526485] CPU 0 Unable to handle kernel paging request at virtual
address 00000000, epc == 803c2294, ra == 803c2138
[   82.531233] CPU: 2 PID: 10794 Comm: dnsmasq Not tainted 5.4.123 #0
[   82.564596] $ 0   : 00000000 00000001 00000001 80653a14
[   82.575002] $ 4   : 00000000 00000000 8fc11e94 8f2e09c0
[   82.585407] $ 8   : 00001fb1 f0000080 0000000a 00000122
[   82.595810] $12   : 00000100 0000004c 00000033 00000019
[   82.606212] $16   : 81022740 00000003 810226c8 00000001
[   82.616615] $20   : 81022740 80690000 8fc11f20 00000000
[   82.627017] $24   : 00000000 0000000e
[   82.637420] $28   : 8f2ae000 8fc11e10 8fc11ea0 803cb704
[   82.647823] Hi    : 000002ff
[   82.653545] Lo    : ef9db4cd
[   82.659302] epc   : 803caaa0 __netif_receive_skb_core+0xb0/0xcf0
[   82.671253] ra    : 803cb704 __netif_receive_skb_one_core+0x24/0x50
[   82.683716] Status: 11007c03 KERNEL EXL IE
[   82.692044] Cause : 40800010 (ExcCode 04)
[   82.700013] BadVA : 000000a9
[   82.705738] PrId  : 0001992f (MIPS 1004Kc)
[   82.713878] Modules linked in: qcserial option cdc_mbim wireguard
usb_wwan rndis_host qmi_wwan mt76x2e mt76x2_common mt76x02_lib mt7603e
mt76 mac80211 libchacha20poly1305 libblake2s iptable_nat ipt_REJECT
cfg80211 cdc_ncm cdc_ether ax88179_178a asix xt_time xt_tcpudp
xt_tcpmss xt_string xt_statistic xt_state xt_socket xt_recent xt_quota
xt_policy xt_pkttype xt_owner4
[   82.714218]  nf_flow_table_hw nf_flow_table nf_conntrack_tftp
nf_conntrack_snmp nf_conntrack_sip nf_conntrack_pptp
nf_conntrack_netlink nf_conntrack_irc nf_conntrack_h323
nf_conntrack_ftp nf_conntrack_broadcast ts_kmp nf_conntrack_amanda
nf_conncount libcurve25519_generic libblake2s_generic iptable_rawpost
iptable_raw iptable_mangle iptable_filter ipt_ah ipt_ECN ip6p
[   82.888522]  ip_set nfnetlink nf_log_ipv6 nf_log_common
ip6table_mangle ip6table_filter ip6_tables ip6t_REJECT x_tables
nf_reject_ipv6 ifb sit ipcomp6 xfrm6_tunnel esp6 ah6 xfrm4_tunnel
ipcomp esp4 ah4 ipip tunnel6 tunnel4 ip_tunnel tun xfrm_user
xfrm_ipcomp af_key xfrm_algo vxlan udp_tunnel ip6_udp_tunnel
crypto_user algif_skcipher algif_rng algif_hash algif_aead ai
[   83.181939] Process dnsmasq (pid: 10794, threadinfo=089c8dea,
task=4d4c240c, tls=77e38ec8)
[   83.198374] Stack : 8f39b902 8fdef800 00000000 8fc11e24 80820000
806e26d8 00000000 80820000
[   83.215012]         80690000 80653a14 81022740 8040bb3c 00000000
8ff8a800 8f2e0900 8f2e0900
[   83.231647]         8f2e0900 80547ccc 00000001 00000003 810226c8
00000040 81022740 8102274c
[   83.248282]         8fc11f20 80690000 806b0000 803cb704 8fc11f20
80690000 8fc11e94 806a0000
[   83.264918]         806393a8 00000000 81022750 803cb914 81022740
806834e0 00020000 00000001
[   83.281552]         ...
[   83.286416] Call Trace:
[   83.291288] [<803caaa0>] __netif_receive_skb_core+0xb0/0xcf0
[   83.302561] [<803cb704>] __netif_receive_skb_one_core+0x24/0x50
[   83.314344] [<803cb914>] process_backlog+0x9c/0x178
[   83.324054] [<803cd1f8>] __napi_poll+0x3c/0x10c
[   83.333069] [<803cd46c>] net_rx_action+0x114/0x28c
[   83.342638] [<80573b54>] __do_softirq+0x16c/0x334
[   83.352031] [<80030324>] irq_exit+0x98/0xb0
[   83.360370] [<802bad28>] plat_irq_dispatch+0x64/0x104
[   83.370433] [<80006ce8>] except_vec_vi_end+0xb8/0xc4
[   83.380341] [<801c10fc>] locks_free_lock_context+0x14/0xe4
[   83.391282] [<801808ac>] __destroy_inode+0xbc/0x228
[   83.400994] [<80180a50>] destroy_inode+0x38/0xb0
[   83.410186] [<8017bde0>] __dentry_kill+0xe8/0x208
[   83.419574] [<80162e50>] __fput+0x110/0x2a0
[   83.427920] [<80048d30>] task_work_run+0xb8/0xec
[   83.437123] [<8000ac7c>] do_notify_resume+0x260/0x274
[   83.447177] [<80006910>] work_notifysig+0x10/0x18
[   83.456539] Code: 3c038065  24633a14  afa30024 <8c4300a8> 26b503c4
ae030074  8f83000c  8fa20014  00031880
