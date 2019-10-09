Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96E4FD14A1
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 18:53:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731385AbfJIQxY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 12:53:24 -0400
Received: from mga12.intel.com ([192.55.52.136]:59505 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730490AbfJIQxY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Oct 2019 12:53:24 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Oct 2019 09:53:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,276,1566889200"; 
   d="scan'208";a="198063106"
Received: from unknown (HELO [10.241.228.165]) ([10.241.228.165])
  by orsmga006.jf.intel.com with ESMTP; 09 Oct 2019 09:53:22 -0700
Subject: Re: FW: [PATCH bpf-next 2/4] xsk: allow AF_XDP sockets to receive
 packets directly from a queue
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Netdev <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        intel-wired-lan@lists.osuosl.org,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "Herbert, Tom" <tom.herbert@intel.com>
References: <1570515415-45593-1-git-send-email-sridhar.samudrala@intel.com>
 <1570515415-45593-3-git-send-email-sridhar.samudrala@intel.com>
 <CAADnVQ+XxmvY0cs8MYriMMd7=2TSEm4zCtB+fs2vkwdUY6UgAQ@mail.gmail.com>
 <3ED8E928C4210A4289A677D2FEB48235140134CE@fmsmsx111.amr.corp.intel.com>
From:   "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Message-ID: <2bc26acd-170d-634e-c066-71557b2b3e4f@intel.com>
Date:   Wed, 9 Oct 2019 09:53:21 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <3ED8E928C4210A4289A677D2FEB48235140134CE@fmsmsx111.amr.corp.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


>> +
>> +u32 bpf_direct_xsk(const struct bpf_prog *prog, struct xdp_buff *xdp)
>> +{
>> +       struct xdp_sock *xsk;
>> +
>> +       xsk = xdp_get_xsk_from_qid(xdp->rxq->dev, xdp->rxq->queue_index);
>> +       if (xsk) {
>> +               struct bpf_redirect_info *ri =
>> + this_cpu_ptr(&bpf_redirect_info);
>> +
>> +               ri->xsk = xsk;
>> +               return XDP_REDIRECT;
>> +       }
>> +
>> +       return XDP_PASS;
>> +}
>> +EXPORT_SYMBOL(bpf_direct_xsk);
> 
> So you're saying there is a:
> """
> xdpsock rxdrop 1 core (both app and queue's irq pinned to the same core)
>     default : taskset -c 1 ./xdpsock -i enp66s0f0 -r -q 1
>     direct-xsk :taskset -c 1 ./xdpsock -i enp66s0f0 -r -q 1 6.1x improvement in drop rate """
> 
> 6.1x gain running above C code vs exactly equivalent BPF code?
> How is that possible?

It seems to be due to the overhead of __bpf_prog_run on older processors 
(Ivybridge). The overhead is smaller on newer processors, but even on 
skylake i see around 1.5x improvement.

perf report with default xdpsock
================================
Samples: 2K of event 'cycles:ppp', Event count (approx.): 8437658090
Overhead  Command          Shared Object     Symbol
   34.57%  xdpsock          xdpsock           [.] main
   17.19%  ksoftirqd/1      [kernel.vmlinux]  [k] ___bpf_prog_run
   13.12%  xdpsock          [kernel.vmlinux]  [k] ___bpf_prog_run
    4.09%  ksoftirqd/1      [kernel.vmlinux]  [k] __x86_indirect_thunk_rax
    3.08%  xdpsock          [kernel.vmlinux]  [k] nmi
    2.76%  ksoftirqd/1      [kernel.vmlinux]  [k] xsk_map_lookup_elem
    2.33%  xdpsock          [kernel.vmlinux]  [k] __x86_indirect_thunk_rax
    2.33%  ksoftirqd/1      [i40e]            [k] i40e_clean_rx_irq_zc
    2.16%  xdpsock          [kernel.vmlinux]  [k] bpf_map_lookup_elem
    1.82%  ksoftirqd/1      [kernel.vmlinux]  [k] xdp_do_redirect
    1.41%  ksoftirqd/1      [kernel.vmlinux]  [k] xsk_rcv
    1.39%  ksoftirqd/1      [kernel.vmlinux]  [k] update_curr
    1.09%  ksoftirqd/1      [kernel.vmlinux]  [k] bpf_xdp_redirect_map
    1.09%  xdpsock          [i40e]            [k] i40e_clean_rx_irq_zc
    1.08%  ksoftirqd/1      [kernel.vmlinux]  [k] __xsk_map_redirect
    1.07%  swapper          [kernel.vmlinux]  [k] xsk_umem_peek_addr
    1.05%  ksoftirqd/1      [kernel.vmlinux]  [k] xsk_umem_peek_addr
    0.89%  swapper          [kernel.vmlinux]  [k] __xsk_map_redirect
    0.87%  ksoftirqd/1      [kernel.vmlinux]  [k] __bpf_prog_run32
    0.87%  swapper          [kernel.vmlinux]  [k] intel_idle
    0.67%  xdpsock          [kernel.vmlinux]  [k] bpf_xdp_redirect_map
    0.57%  xdpsock          [kernel.vmlinux]  [k] xdp_do_redirect

perf report with direct xdpsock
===============================
Samples: 2K of event 'cycles:ppp', Event count (approx.): 17996091975
Overhead  Command          Shared Object     Symbol
   18.44%  xdpsock          [i40e]            [k] i40e_clean_rx_irq_zc
   15.14%  ksoftirqd/1      [i40e]            [k] i40e_clean_rx_irq_zc
    6.87%  xdpsock          [kernel.vmlinux]  [k] xsk_umem_peek_addr
    5.03%  ksoftirqd/1      [kernel.vmlinux]  [k] xdp_do_redirect
    4.21%  xdpsock          xdpsock           [.] main
    4.13%  ksoftirqd/1      [i40e]            [k] 
i40e_clean_programming_status
    3.71%  xdpsock          [kernel.vmlinux]  [k] xsk_rcv
    3.44%  ksoftirqd/1      [kernel.vmlinux]  [k] nmi
    3.41%  xdpsock          [kernel.vmlinux]  [k] nmi
    3.20%  ksoftirqd/1      [kernel.vmlinux]  [k] xsk_rcv
    2.45%  xdpsock          [kernel.vmlinux]  [k] xdp_get_xsk_from_qid
    2.35%  ksoftirqd/1      [kernel.vmlinux]  [k] xsk_umem_peek_addr
    2.33%  ksoftirqd/1      [kernel.vmlinux]  [k] net_rx_action
    2.16%  ksoftirqd/1      [kernel.vmlinux]  [k] xsk_umem_consume_tx
    2.10%  swapper          [kernel.vmlinux]  [k] __softirqentry_text_start
    2.06%  xdpsock          [kernel.vmlinux]  [k] native_irq_return_iret
    1.43%  xdpsock          [kernel.vmlinux]  [k] check_preempt_wakeup
    1.42%  xdpsock          [kernel.vmlinux]  [k] xsk_umem_consume_tx
    1.22%  xdpsock          [kernel.vmlinux]  [k] xdp_do_redirect
    1.21%  xdpsock          [kernel.vmlinux]  [k] 
dma_direct_sync_single_for_device
    1.16%  ksoftirqd/1      [kernel.vmlinux]  [k] irqtime_account_irq
    1.09%  xdpsock          [kernel.vmlinux]  [k] sock_def_readable
    0.99%  swapper          [kernel.vmlinux]  [k] intel_idle
    0.88%  xdpsock          [i40e]            [k] 
i40e_clean_programming_status
    0.74%  ksoftirqd/1      [kernel.vmlinux]  [k] xsk_umem_discard_addr
    0.71%  ksoftirqd/1      [kernel.vmlinux]  [k] __switch_to
    0.50%  ksoftirqd/1      [kernel.vmlinux]  [k] 
dma_direct_sync_single_for_device
