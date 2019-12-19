Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71D4C126E6F
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 21:08:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726992AbfLSUIp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 15:08:45 -0500
Received: from www62.your-server.de ([213.133.104.62]:47914 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726869AbfLSUIp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 15:08:45 -0500
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1ii269-000729-Lb; Thu, 19 Dec 2019 21:08:37 +0100
Received: from [178.197.249.31] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1ii269-000Rq9-6l; Thu, 19 Dec 2019 21:08:37 +0100
Subject: Re: [PATCH bpf-next 0/8] Simplify
 xdp_do_redirect_map()/xdp_do_flush_map() and XDP maps
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        Netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Fastabend <john.fastabend@gmail.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>
References: <20191218105400.2895-1-bjorn.topel@gmail.com>
 <20191218121132.4023f4f1@carbon>
 <CAJ+HfNgKsPN7V9r=N=hDoVb23-nk3q=y+Nv4jB3koPw0+4Zw9A@mail.gmail.com>
 <20191218130346.1a346606@carbon>
 <CAEf4BzZab=FvCuvKOKsj0M5RRoGuuXW2ME5EoDuqT8sJOd2Xtg@mail.gmail.com>
 <20191219203329.75d4bead@carbon>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <4e5cb0b0-14b9-5de9-4346-e4c2955e99a0@iogearbox.net>
Date:   Thu, 19 Dec 2019 21:08:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20191219203329.75d4bead@carbon>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25668/Thu Dec 19 10:55:58 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/19/19 8:33 PM, Jesper Dangaard Brouer wrote:
> On Wed, 18 Dec 2019 16:39:08 -0800
> Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> 
>> On Wed, Dec 18, 2019 at 4:04 AM Jesper Dangaard Brouer
>> <brouer@redhat.com> wrote:
>>>
>>> On Wed, 18 Dec 2019 12:39:53 +0100
>>> Björn Töpel <bjorn.topel@gmail.com> wrote:
>>>   
>>>> On Wed, 18 Dec 2019 at 12:11, Jesper Dangaard Brouer <brouer@redhat.com> wrote:
>>>>>
>>>>> On Wed, 18 Dec 2019 11:53:52 +0100
>>>>> Björn Töpel <bjorn.topel@gmail.com> wrote:
>>>>>   
>>>>>>    $ sudo ./xdp_redirect_cpu --dev enp134s0f0 --cpu 22 xdp_cpu_map0
>>>>>>
>>>>>>    Running XDP/eBPF prog_name:xdp_cpu_map5_lb_hash_ip_pairs
>>>>>>    XDP-cpumap      CPU:to  pps            drop-pps    extra-info
>>>>>>    XDP-RX          20      7723038        0           0
>>>>>>    XDP-RX          total   7723038        0
>>>>>>    cpumap_kthread  total   0              0           0
>>>>>>    redirect_err    total   0              0
>>>>>>    xdp_exception   total   0              0
>>>>>
>>>>> Hmm... I'm missing some counters on the kthread side.
>>>>>   
>>>>
>>>> Oh? Any ideas why? I just ran the upstream sample straight off.
>>>
>>> Looks like it happened in commit: bbaf6029c49c ("samples/bpf: Convert
>>> XDP samples to libbpf usage") (Cc Maciej).
>>>
>>> The old bpf_load.c will auto attach the tracepoints... for and libbpf
>>> you have to be explicit about it.
>>
>> ... or you can use skeleton, which will auto-attach them as well,
>> provided BPF program's section names follow expected naming
>> convention. So it might be a good idea to try it out.
> 
> To Andrii, can you provide some more info on how to use this new
> skeleton system of yours?  (Pointers to code examples?)

There's a man page ;-)

https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/tree/tools/bpf/bpftool/Documentation/bpftool-gen.rst
