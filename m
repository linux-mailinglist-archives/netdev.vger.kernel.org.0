Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17B25E3AB4
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 20:12:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504031AbfJXSM5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 14:12:57 -0400
Received: from mga12.intel.com ([192.55.52.136]:36867 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2504015AbfJXSM5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Oct 2019 14:12:57 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Oct 2019 11:12:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,225,1569308400"; 
   d="scan'208";a="399854012"
Received: from unknown (HELO [10.241.228.119]) ([10.241.228.119])
  by fmsmga006.fm.intel.com with ESMTP; 24 Oct 2019 11:12:56 -0700
To:     alexei.starovoitov@gmail.com
Cc:     bjorn.topel@gmail.com, bjorn.topel@intel.com, bpf@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, jakub.kicinski@netronome.com,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        netdev@vger.kernel.org, sridhar.samudrala@intel.com,
        toke@redhat.com, tom.herbert@intel.com
References: <CAADnVQKwnMChzeGaC66A99cHn5szB4hPZaGXq8JAhd8sjrdGeA@mail.gmail.com>
Subject: Re: [Intel-wired-lan] FW: [PATCH bpf-next 2/4] xsk: allow AF_XDP
 sockets to receive packets directly from a queue
From:   "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Message-ID: <68d6e154-8646-7904-f081-10ec32115496@intel.com>
Date:   Thu, 24 Oct 2019 11:12:55 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <CAADnVQKwnMChzeGaC66A99cHn5szB4hPZaGXq8JAhd8sjrdGeA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> > OK. Here is another data point that shows the perf report with the same test but CPU mitigations
> > turned OFF. Here bpf_prog overhead goes down from almost (10.18 + 4.51)% to (3.23 + 1.44%).
> >
> >    21.40%  ksoftirqd/28     [i40e]                     [k] i40e_clean_rx_irq_zc
> >    14.13%  xdpsock          [i40e]                     [k] i40e_clean_rx_irq_zc
> >     8.33%  ksoftirqd/28     [kernel.vmlinux]           [k] xsk_rcv
> >     6.09%  ksoftirqd/28     [kernel.vmlinux]           [k] xdp_do_redirect
> >     5.19%  xdpsock          xdpsock                    [.] main
> >     3.48%  ksoftirqd/28     [kernel.vmlinux]           [k] bpf_xdp_redirect_map
> >     3.23%  ksoftirqd/28     bpf_prog_3c8251c7e0fef8db  [k] bpf_prog_3c8251c7e0fef8db
> >
> > So a major component of the bpf_prog overhead seems to be due to the CPU vulnerability mitigations.

> I feel that it's an incorrect conclusion because JIT is not doing
> any retpolines (because there are no indirect calls in bpf).
> There should be no difference in bpf_prog runtime with or without mitigations.
> Also you're running root, so no spectre mitigations either.

> This 3% seems like a lot for a function that does few loads that should
> hit d-cache and one direct call.
> Please investigate why you're seeing this 10% cpu cost when mitigations are on.
> perf report/annotate is the best.
> Also please double check that you're using the latest perf.
> Since bpf performance analysis was greatly improved several versions ago.
> I don't think old perf will be showing bogus numbers, but better to
> run the latest.

Here is perf annotate output for bpf_prog_ with and without mitigations turned ON
Using the perf built from the bpf-next tree.
   perf version 5.3.g4071324a76c1

With mitigations ON
-------------------
Samples: 6K of event 'cycles', 4000 Hz, Event count (approx.): 5646512726
bpf_prog_3c8251c7e0fef8db  bpf_prog_3c8251c7e0fef8db [Percent: local period]
  45.05      push   %rbp
   0.02      mov    %rsp,%rbp
   0.03      sub    $0x8,%rsp
  22.09      push   %rbx
   7.66      push   %r13
   1.08      push   %r14
   1.85      push   %r15
   0.63      pushq  $0x0
   1.13      mov    0x28(%rdi),%rsi
   0.47      mov    0x8(%rsi),%esi
   3.47      mov    %esi,-0x4(%rbp)
   0.02      movabs $0xffff8ab414a83e00,%rdi
   0.90      mov    $0x2,%edx
   2.85      callq  *ffffffffd149fc5f
   1.55      and    $0x6,%rax
             test   %rax,%rax
   1.48      jne    72
             mov    %rbp,%rsi
             add    $0xfffffffffffffffc,%rsi
             movabs $0xffff8ab414a83e00,%rdi
             callq  *ffffffffd0e5fd5f
             mov    %rax,%rdi
             mov    $0x2,%eax
             test   %rdi,%rdi
             je     72
             mov    -0x4(%rbp),%esi
             movabs $0xffff8ab414a83e00,%rdi
             xor    %edx,%edx
             callq  *ffffffffd149fc5f
        72:  pop    %rbx
             pop    %r15
   1.90      pop    %r14
   1.93      pop    %r13
             pop    %rbx
   3.63      leaveq
   2.27      retq

With mitigations OFF
--------------------
Samples: 2K of event 'cycles', 4000 Hz, Event count (approx.): 1872116166
bpf_prog_3c8251c7e0fef8db  bpf_prog_3c8251c7e0fef8db [Percent: local period]
   0.15      push   %rbp
             mov    %rsp,%rbp
  13.79      sub    $0x8,%rsp
   0.30      push   %rbx
   0.15      push   %r13
   0.20      push   %r14
  14.50      push   %r15
   0.20      pushq  $0x0
             mov    0x28(%rdi),%rsi
   0.25      mov    0x8(%rsi),%esi
  14.37      mov    %esi,-0x4(%rbp)
   0.25      movabs $0xffff8ea2c673b800,%rdi
             mov    $0x2,%edx
  13.60      callq  *ffffffffe50c2f38
  14.33      and    $0x6,%rax
             test   %rax,%rax
             jne    72
             mov    %rbp,%rsi
             add    $0xfffffffffffffffc,%rsi
             movabs $0xffff8ea2c673b800,%rdi
             callq  *ffffffffe4a83038
             mov    %rax,%rdi
             mov    $0x2,%eax
             test   %rdi,%rdi
             je     72
             mov    -0x4(%rbp),%esi
             movabs $0xffff8ea2c673b800,%rdi
             xor    %edx,%edx
             callq  *ffffffffe50c2f38
        72:  pop    %rbx
             pop    %r15
  13.97      pop    %r14
   0.10      pop    %r13
             pop    %rbx
  13.71      leaveq
   0.15      retq

Do you see any issues with this data? With mitigations ON push %rbp and push %rbx overhead seems to
be pretty high.

Thanks
Sridhar
