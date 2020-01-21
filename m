Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 999D8144861
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 00:36:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727141AbgAUXgP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 18:36:15 -0500
Received: from www62.your-server.de ([213.133.104.62]:41308 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbgAUXgO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 18:36:14 -0500
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iu348-0003LX-7z; Wed, 22 Jan 2020 00:36:12 +0100
Received: from [178.197.248.28] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1iu347-00033r-S3; Wed, 22 Jan 2020 00:36:11 +0100
Subject: Re: [PATCH bpf-next] xsk, net: make sock_def_readable() have external
 linkage
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf <bpf@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
References: <20200120092917.13949-1-bjorn.topel@gmail.com>
 <5e264a3a5d5e6_20912afc5c86e5c4b5@john-XPS-13-9370.notmuch>
 <CAJ+HfNirBncXGcath_MKpzbcf3JRBRU7ThpapCQh_zMNqQVtxQ@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <38c0f2f6-436d-f0d6-42c6-242e550c06f2@iogearbox.net>
Date:   Wed, 22 Jan 2020 00:36:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAJ+HfNirBncXGcath_MKpzbcf3JRBRU7ThpapCQh_zMNqQVtxQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25702/Tue Jan 21 12:39:19 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/21/20 1:06 PM, Björn Töpel wrote:
> On Tue, 21 Jan 2020 at 01:48, John Fastabend <john.fastabend@gmail.com> wrote:
>> Björn Töpel wrote:
>>> From: Björn Töpel <bjorn.topel@intel.com>
>>>
>>> XDP sockets use the default implementation of struct sock's
>>> sk_data_ready callback, which is sock_def_readable(). This function is
>>> called in the XDP socket fast-path, and involves a retpoline. By
>>> letting sock_def_readable() have external linkage, and being called
>>> directly, the retpoline can be avoided.
>>>
>>> Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
>>> ---
>>>   include/net/sock.h | 2 ++
>>>   net/core/sock.c    | 2 +-
>>>   net/xdp/xsk.c      | 2 +-
>>>   3 files changed, 4 insertions(+), 2 deletions(-)
>>>
>>
>> I think this is fine but curious were you able to measure the
>> difference with before/after pps or something?
> 
> Ugh, yeah, of course I've should have added that. Sorry for that! Here
> goes; Benchmark is xdpsock rxdrop, NAPI running on core 20:
> 
> **Pre-patch: xdpsock rxdrop: 22.8 Mpps
>   Performance counter stats for 'CPU(s) 20':
> 
>           10,000.58 msec cpu-clock                 #    1.000 CPUs
> utilized
>                  12      context-switches          #    0.001 K/sec
>                   1      cpu-migrations            #    0.000 K/sec
>                   0      page-faults               #    0.000 K/sec
>      29,931,407,416      cycles                    #    2.993 GHz
>      82,538,852,331      instructions              #    2.76  insn per
> cycle
>      15,894,169,979      branches                  # 1589.324 M/sec
>          30,916,486      branch-misses             #    0.19% of all
> branches
> 
>        10.000636027 seconds time elapsed
> 
> **Post-patch: xdpsock rxdrop: 23.2 Mpps
>           10,000.90 msec cpu-clock                 #    1.000 CPUs
> utilized
>                  12      context-switches          #    0.001 K/sec
>                   1      cpu-migrations            #    0.000 K/sec
>                   0      page-faults               #    0.000 K/sec
>      29,932,353,067      cycles                    #    2.993 GHz
>      84,299,636,827      instructions              #    2.82  insn per
> cycle
>      16,228,795,437      branches                  # 1622.733 M/sec
>          28,113,847      branch-misses             #    0.17% of all
> branches
> 
>        10.000596454 seconds time elapsed
> 
> This could fall into the category of noise. :-) PPS and IPC is up a
> bit. OTOH, maybe UDP can benefit from this as well?

Yeah, might be within noise range though getting rid of retpolines in XDP
[socket] fast-path is fine and patch is tiny, so applied, thanks!
