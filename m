Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A25FCDCE60
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 20:40:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505903AbfJRSkJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 14:40:09 -0400
Received: from mga05.intel.com ([192.55.52.43]:11655 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394568AbfJRSkI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Oct 2019 14:40:08 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Oct 2019 11:40:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,312,1566889200"; 
   d="scan'208";a="226632749"
Received: from unknown (HELO [10.241.228.71]) ([10.241.228.71])
  by fmsmga002.fm.intel.com with ESMTP; 18 Oct 2019 11:40:07 -0700
Subject: Re: FW: [PATCH bpf-next 2/4] xsk: allow AF_XDP sockets to receive
 packets directly from a queue
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Netdev <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "Herbert, Tom" <tom.herbert@intel.com>
References: <1570515415-45593-1-git-send-email-sridhar.samudrala@intel.com>
 <1570515415-45593-3-git-send-email-sridhar.samudrala@intel.com>
 <CAADnVQ+XxmvY0cs8MYriMMd7=2TSEm4zCtB+fs2vkwdUY6UgAQ@mail.gmail.com>
 <3ED8E928C4210A4289A677D2FEB48235140134CE@fmsmsx111.amr.corp.intel.com>
 <2bc26acd-170d-634e-c066-71557b2b3e4f@intel.com>
 <CAADnVQ+qq6RLMjh5bB1ugXP5p7vYM2F1fLGFQ2pL=2vhCLiBdA@mail.gmail.com>
 <2032d58c-916f-d26a-db14-bd5ba6ad92b9@intel.com>
 <CAADnVQ+CH1YM52+LfybLS+NK16414Exrvk1QpYOF=HaT4KRaxg@mail.gmail.com>
From:   "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Message-ID: <acf69635-5868-f876-f7da-08954d1f690e@intel.com>
Date:   Fri, 18 Oct 2019 11:40:07 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <CAADnVQ+CH1YM52+LfybLS+NK16414Exrvk1QpYOF=HaT4KRaxg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/9/2019 6:06 PM, Alexei Starovoitov wrote:
>>
>> Will update the patchset with the right performance data and address
>> feedback from Bjorn.
>> Hope you are not totally against direct XDP approach as it does provide
>> value when an AF_XDP socket is bound to a queue and a HW filter can
>> direct packets targeted for that queue.
> 
> I used to be in favor of providing "prog bypass" for af_xdp,
> because of anecdotal evidence that it will make af_xdp faster.
> Now seeing the numbers and the way they were collected
> I'm against such bypass.
> I want to see hard proof that trivial bpf prog is actually slowing things down
> before reviewing any new patch sets.
> 

Here is a more detailed performance report that compares the current AF_XDP rx_drop
with the patches that enable direct receive without any XDP program. I also collected
and included kernel rxdrop data too as Jakub requested and also perf reports.
Hope it addresses the concerns you raised with the earlier data I posted.

Test Setup
==========
2 Skylake servers with Intel 40Gbe NICs connected via 100Gb Switch

Server Configuration
====================
Intel(R) Xeon(R) Platinum 8180 CPU @ 2.50GHz (skylake)
CPU(s):              112
On-line CPU(s) list: 0-111
Thread(s) per core:  2
Core(s) per socket:  28
Socket(s):           2
NUMA node(s):        2
NUMA node0 CPU(s):   0-27,56-83
NUMA node1 CPU(s):   28-55,84-111

Memory: 96GB

NIC: Intel Corporation Ethernet Controller XL710 for 40GbE QSFP+ (rev 02)

Distro
======
Fedora 29 (Server Edition)

Kernel Configuration
====================
AF_XDP direct socket patches applied on top of
bpf-next git repo HEAD: 05949f63055fcf53947886ddb8e23c8a5d41bd80

# cat /proc/cmdline
BOOT_IMAGE=/vmlinuz-5.3.0-bpf-next-dxk+ root=/dev/mapper/fedora-root ro resume=/dev/mapper/fedora-swap rd.lvm.lv=fedora/root rd.lvm.lv=fedora/swap LANG=en_IN.UTF-8

For ‘mitigations OFF’ scenarios, the kernel command line parameter is changed to add ‘mitigations=off’

Packet Generator on the link partner
====================================
   pktgen - sending 64 byte UDP packets at 43mpps

HW filter to redirect packet to a queue
=======================================
ethtool -N ens260f1 flow-type udp4 dst-ip 192.168.128.41 dst-port 9 action 28

Test Cases
==========
kernel rxdrop
   taskset -c 28 samples/bpf/xdp_rxq_info -d ens260f1 -a XDP_DROP

AF_XDP default rxdrop
   taskset -c 28 samples/bpf/xdpsock -i ens260f1 -r -q 28

AD_XDP direct rxdrop
   taskset -c 28 samples/bpf/xdpsock -i ens260f1 -r -d -q 28

Performance Results
===================
Only 1 core is used in all these testcases as the app and the queue irq are pinned to the same core.

----------------------------------------------------------------------------------
                                mitigations ON                mitigations OFF
   Testcase              ----------------------------------------------------------
                         no patches    with patches       no patches   with patches
----------------------------------------------------------------------------------
AF_XDP default rxdrop        X             X                   Y            Y
AF_XDP direct rxdrop        N/A          X+46%                N/A         Y+25%
Kernel rxdrop              X+61%         X+61%               Y+53%        Y+53%
----------------------------------------------------------------------------------

Here Y is pps with CPU security mitigations turned OFF and it is 26% better than X.
So there is 46% improvement in AF_XDP rxdrop performance with direct receive when
mitigations are ON (default configuration) and 25% improvement when mitigations are
turned OFF.
As expected, the in-kernel rxdrop performance is higher even with direct receive in
both scenarios.

Perf report for "AF_XDP default rxdrop" with patched kernel - mitigations ON
==========================================================================
Samples: 44K of event 'cycles', Event count (approx.): 38532389541
Overhead  Command          Shared Object              Symbol
   15.31%  ksoftirqd/28     [i40e]                     [k] i40e_clean_rx_irq_zc
   10.50%  ksoftirqd/28     bpf_prog_80b55d8a76303785  [k] bpf_prog_80b55d8a76303785
    9.48%  xdpsock          [i40e]                     [k] i40e_clean_rx_irq_zc
    8.62%  xdpsock          xdpsock                    [.] main
    7.11%  ksoftirqd/28     [kernel.vmlinux]           [k] xsk_rcv
    5.81%  ksoftirqd/28     [kernel.vmlinux]           [k] xdp_do_redirect
    4.46%  xdpsock          bpf_prog_80b55d8a76303785  [k] bpf_prog_80b55d8a76303785
    3.83%  xdpsock          [kernel.vmlinux]           [k] xsk_rcv
    2.81%  ksoftirqd/28     [kernel.vmlinux]           [k] bpf_xdp_redirect_map
    2.78%  ksoftirqd/28     [kernel.vmlinux]           [k] xsk_map_lookup_elem
    2.44%  xdpsock          [kernel.vmlinux]           [k] xdp_do_redirect
    2.19%  ksoftirqd/28     [kernel.vmlinux]           [k] __xsk_map_redirect
    1.62%  ksoftirqd/28     [kernel.vmlinux]           [k] xsk_umem_peek_addr
    1.57%  xdpsock          [kernel.vmlinux]           [k] xsk_umem_peek_addr
    1.32%  ksoftirqd/28     [kernel.vmlinux]           [k] dma_direct_sync_single_for_cpu
    1.28%  xdpsock          [kernel.vmlinux]           [k] bpf_xdp_redirect_map
    1.15%  xdpsock          [kernel.vmlinux]           [k] dma_direct_sync_single_for_device
    1.12%  xdpsock          [kernel.vmlinux]           [k] xsk_map_lookup_elem
    1.06%  xdpsock          [kernel.vmlinux]           [k] __xsk_map_redirect
    0.94%  ksoftirqd/28     [kernel.vmlinux]           [k] dma_direct_sync_single_for_device
    0.75%  ksoftirqd/28     [kernel.vmlinux]           [k] __x86_indirect_thunk_rax
    0.66%  ksoftirqd/28     [i40e]                     [k] i40e_clean_programming_status
    0.64%  ksoftirqd/28     [kernel.vmlinux]           [k] net_rx_action
    0.64%  swapper          [kernel.vmlinux]           [k] intel_idle
    0.62%  ksoftirqd/28     [i40e]                     [k] i40e_napi_poll
    0.57%  xdpsock          [kernel.vmlinux]           [k] dma_direct_sync_single_for_cpu

Perf report for "AF_XDP direct rxdrop" with patched kernel - mitigations ON
==========================================================================
Samples: 46K of event 'cycles', Event count (approx.): 38387018585
Overhead  Command          Shared Object             Symbol
   21.94%  ksoftirqd/28     [i40e]                    [k] i40e_clean_rx_irq_zc
   14.36%  xdpsock          xdpsock                   [.] main
   11.53%  ksoftirqd/28     [kernel.vmlinux]          [k] xsk_rcv
   11.32%  xdpsock          [i40e]                    [k] i40e_clean_rx_irq_zc
    4.02%  xdpsock          [kernel.vmlinux]          [k] xsk_rcv
    2.91%  ksoftirqd/28     [kernel.vmlinux]          [k] xdp_do_redirect
    2.45%  ksoftirqd/28     [kernel.vmlinux]          [k] xsk_umem_peek_addr
    2.19%  xdpsock          [kernel.vmlinux]          [k] xsk_umem_peek_addr
    2.08%  ksoftirqd/28     [kernel.vmlinux]          [k] bpf_direct_xsk
    2.07%  ksoftirqd/28     [kernel.vmlinux]          [k] dma_direct_sync_single_for_cpu
    1.53%  ksoftirqd/28     [kernel.vmlinux]          [k] dma_direct_sync_single_for_device
    1.39%  xdpsock          [kernel.vmlinux]          [k] dma_direct_sync_single_for_device
    1.22%  ksoftirqd/28     [kernel.vmlinux]          [k] xdp_get_xsk_from_qid
    1.12%  ksoftirqd/28     [i40e]                    [k] i40e_clean_programming_status
    0.96%  ksoftirqd/28     [i40e]                    [k] i40e_napi_poll
    0.95%  ksoftirqd/28     [kernel.vmlinux]          [k] net_rx_action
    0.89%  xdpsock          [kernel.vmlinux]          [k] xdp_do_redirect
    0.83%  swapper          [i40e]                    [k] i40e_clean_rx_irq_zc
    0.70%  swapper          [kernel.vmlinux]          [k] intel_idle
    0.66%  xdpsock          [kernel.vmlinux]          [k] dma_direct_sync_single_for_cpu
    0.60%  xdpsock          [kernel.vmlinux]          [k] bpf_direct_xsk
    0.50%  ksoftirqd/28     [kernel.vmlinux]          [k] xsk_umem_discard_addr

Based on the perf reports comparing AF_XDP default and direct rxdrop, we can say that
AF_XDP direct rxdrop codepath is avoiding the overhead of going through these functions
	bpf_prog_xxx
         bpf_xdp_redirect_map
	xsk_map_lookup_elem
         __xsk_map_redirect
With AF_XDP direct, xsk_rcv() is directly called via bpf_direct_xsk() in xdp_do_redirect()

The above test results document performance of components on a particular test, in specific systems.
Differences in hardware, software, or configuration will affect actual performance.

Thanks
Sridhar
