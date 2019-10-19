Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67C57DD5D5
	for <lists+netdev@lfdr.de>; Sat, 19 Oct 2019 02:47:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728045AbfJSArb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 20:47:31 -0400
Received: from mga11.intel.com ([192.55.52.93]:9762 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726718AbfJSAqg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Oct 2019 20:46:36 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Oct 2019 17:45:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,313,1566889200"; 
   d="scan'208";a="209024251"
Received: from samudral-mobl1.amr.corp.intel.com (HELO [10.241.228.71]) ([10.241.228.71])
  by fmsmga001.fm.intel.com with ESMTP; 18 Oct 2019 17:45:26 -0700
Subject: Re: FW: [PATCH bpf-next 2/4] xsk: allow AF_XDP sockets to receive
 packets directly from a queue
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
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
 <acf69635-5868-f876-f7da-08954d1f690e@intel.com>
 <20191019001449.fk3gnhih4nx724pm@ast-mbp>
From:   "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Message-ID: <6f281517-3785-ce46-65de-e2f78576783b@intel.com>
Date:   Fri, 18 Oct 2019 17:45:26 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191019001449.fk3gnhih4nx724pm@ast-mbp>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/18/2019 5:14 PM, Alexei Starovoitov wrote:
> On Fri, Oct 18, 2019 at 11:40:07AM -0700, Samudrala, Sridhar wrote:
>>
>> Perf report for "AF_XDP default rxdrop" with patched kernel - mitigations ON
>> ==========================================================================
>> Samples: 44K of event 'cycles', Event count (approx.): 38532389541
>> Overhead  Command          Shared Object              Symbol
>>    15.31%  ksoftirqd/28     [i40e]                     [k] i40e_clean_rx_irq_zc
>>    10.50%  ksoftirqd/28     bpf_prog_80b55d8a76303785  [k] bpf_prog_80b55d8a76303785
>>     9.48%  xdpsock          [i40e]                     [k] i40e_clean_rx_irq_zc
>>     8.62%  xdpsock          xdpsock                    [.] main
>>     7.11%  ksoftirqd/28     [kernel.vmlinux]           [k] xsk_rcv
>>     5.81%  ksoftirqd/28     [kernel.vmlinux]           [k] xdp_do_redirect
>>     4.46%  xdpsock          bpf_prog_80b55d8a76303785  [k] bpf_prog_80b55d8a76303785
>>     3.83%  xdpsock          [kernel.vmlinux]           [k] xsk_rcv
> 
> why everything is duplicated?
> Same code runs in different tasks ?

Yes. looks like these functions run from both the app(xdpsock) context and ksoftirqd context.

> 
>>     2.81%  ksoftirqd/28     [kernel.vmlinux]           [k] bpf_xdp_redirect_map
>>     2.78%  ksoftirqd/28     [kernel.vmlinux]           [k] xsk_map_lookup_elem
>>     2.44%  xdpsock          [kernel.vmlinux]           [k] xdp_do_redirect
>>     2.19%  ksoftirqd/28     [kernel.vmlinux]           [k] __xsk_map_redirect
>>     1.62%  ksoftirqd/28     [kernel.vmlinux]           [k] xsk_umem_peek_addr
>>     1.57%  xdpsock          [kernel.vmlinux]           [k] xsk_umem_peek_addr
>>     1.32%  ksoftirqd/28     [kernel.vmlinux]           [k] dma_direct_sync_single_for_cpu
>>     1.28%  xdpsock          [kernel.vmlinux]           [k] bpf_xdp_redirect_map
>>     1.15%  xdpsock          [kernel.vmlinux]           [k] dma_direct_sync_single_for_device
>>     1.12%  xdpsock          [kernel.vmlinux]           [k] xsk_map_lookup_elem
>>     1.06%  xdpsock          [kernel.vmlinux]           [k] __xsk_map_redirect
>>     0.94%  ksoftirqd/28     [kernel.vmlinux]           [k] dma_direct_sync_single_for_device
>>     0.75%  ksoftirqd/28     [kernel.vmlinux]           [k] __x86_indirect_thunk_rax
>>     0.66%  ksoftirqd/28     [i40e]                     [k] i40e_clean_programming_status
>>     0.64%  ksoftirqd/28     [kernel.vmlinux]           [k] net_rx_action
>>     0.64%  swapper          [kernel.vmlinux]           [k] intel_idle
>>     0.62%  ksoftirqd/28     [i40e]                     [k] i40e_napi_poll
>>     0.57%  xdpsock          [kernel.vmlinux]           [k] dma_direct_sync_single_for_cpu
>>
>> Perf report for "AF_XDP direct rxdrop" with patched kernel - mitigations ON
>> ==========================================================================
>> Samples: 46K of event 'cycles', Event count (approx.): 38387018585
>> Overhead  Command          Shared Object             Symbol
>>    21.94%  ksoftirqd/28     [i40e]                    [k] i40e_clean_rx_irq_zc
>>    14.36%  xdpsock          xdpsock                   [.] main
>>    11.53%  ksoftirqd/28     [kernel.vmlinux]          [k] xsk_rcv
>>    11.32%  xdpsock          [i40e]                    [k] i40e_clean_rx_irq_zc
>>     4.02%  xdpsock          [kernel.vmlinux]          [k] xsk_rcv
>>     2.91%  ksoftirqd/28     [kernel.vmlinux]          [k] xdp_do_redirect
>>     2.45%  ksoftirqd/28     [kernel.vmlinux]          [k] xsk_umem_peek_addr
>>     2.19%  xdpsock          [kernel.vmlinux]          [k] xsk_umem_peek_addr
>>     2.08%  ksoftirqd/28     [kernel.vmlinux]          [k] bpf_direct_xsk
>>     2.07%  ksoftirqd/28     [kernel.vmlinux]          [k] dma_direct_sync_single_for_cpu
>>     1.53%  ksoftirqd/28     [kernel.vmlinux]          [k] dma_direct_sync_single_for_device
>>     1.39%  xdpsock          [kernel.vmlinux]          [k] dma_direct_sync_single_for_device
>>     1.22%  ksoftirqd/28     [kernel.vmlinux]          [k] xdp_get_xsk_from_qid
>>     1.12%  ksoftirqd/28     [i40e]                    [k] i40e_clean_programming_status
>>     0.96%  ksoftirqd/28     [i40e]                    [k] i40e_napi_poll
>>     0.95%  ksoftirqd/28     [kernel.vmlinux]          [k] net_rx_action
>>     0.89%  xdpsock          [kernel.vmlinux]          [k] xdp_do_redirect
>>     0.83%  swapper          [i40e]                    [k] i40e_clean_rx_irq_zc
>>     0.70%  swapper          [kernel.vmlinux]          [k] intel_idle
>>     0.66%  xdpsock          [kernel.vmlinux]          [k] dma_direct_sync_single_for_cpu
>>     0.60%  xdpsock          [kernel.vmlinux]          [k] bpf_direct_xsk
>>     0.50%  ksoftirqd/28     [kernel.vmlinux]          [k] xsk_umem_discard_addr
>>
>> Based on the perf reports comparing AF_XDP default and direct rxdrop, we can say that
>> AF_XDP direct rxdrop codepath is avoiding the overhead of going through these functions
>> 	bpf_prog_xxx
>>          bpf_xdp_redirect_map
>> 	xsk_map_lookup_elem
>>          __xsk_map_redirect
>> With AF_XDP direct, xsk_rcv() is directly called via bpf_direct_xsk() in xdp_do_redirect()
> 
> I don't think you're identifying the overhead correctly.
> xsk_map_lookup_elem is 1%
> but bpf_xdp_redirect_map() suppose to call __xsk_map_lookup_elem()
> which is a different function:
> ffffffff81493fe0 T __xsk_map_lookup_elem
> ffffffff81492e80 t xsk_map_lookup_elem
> 
> 10% for bpf_prog_80b55d8a76303785 is huge.
> It's the actual code of the program _without_ any helpers.
> How does the program actually look?

It is the xdp program that is loaded via xsk_load_xdp_prog() in tools/lib/bpf/xsk.c
https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/tree/tools/lib/bpf/xsk.c#n268

In the archives, i see that Toke had some comments, but somehow i didn't get his email in
my inbox.

> Performance Results
> ===================
> Only 1 core is used in all these testcases as the app and the queue irq are pinned to the same core.
>
> ----------------------------------------------------------------------------------
>                                 mitigations ON                mitigations OFF
>    Testcase              ----------------------------------------------------------
>                          no patches    with patches       no patches   with patches
> ----------------------------------------------------------------------------------
> AF_XDP default rxdrop        X             X                   Y            Y

> Is this really exactly the same with and without patches? You're adding
> an extra check to xdp_do_redirect(); are you really saying that the
> impact of that is zero?

Yes. I didn't see any impact. The variation is within +/- < 1%
I could use static_key even for that check in xdp_do_redirect() if required.

-Sridhar

  
