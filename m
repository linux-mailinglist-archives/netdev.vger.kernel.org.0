Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDE1310DBC8
	for <lists+netdev@lfdr.de>; Sat, 30 Nov 2019 00:27:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727205AbfK2X1y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Nov 2019 18:27:54 -0500
Received: from www62.your-server.de ([213.133.104.62]:36212 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727117AbfK2X1y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Nov 2019 18:27:54 -0500
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iapQk-0007kH-5i; Sat, 30 Nov 2019 00:12:06 +0100
Received: from [178.197.249.29] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1iapQj-0005xn-Mr; Sat, 30 Nov 2019 00:12:05 +0100
Subject: Re: [PATCH] um: vector: fix BPF loading in vector drivers
To:     Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        linux-um@lists.infradead.org
Cc:     richard@nod.at, dan.carpenter@oracle.com, weiyongjun1@huawei.com,
        kernel-janitors@vger.kernel.org, songliubraving@fb.com,
        ast@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kafai@fb.com, jakub.kicinski@netronome.com
References: <20191128174405.4244-1-anton.ivanov@cambridgegreys.com>
 <1416753c-e966-e259-a84d-2a5f0a166660@iogearbox.net>
 <cccc22d6-ee0a-c219-2bf0-2b89ae07ac2b@cambridgegreys.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <c54efbb0-8ac4-2788-5957-ff99ab357584@iogearbox.net>
Date:   Sat, 30 Nov 2019 00:12:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <cccc22d6-ee0a-c219-2bf0-2b89ae07ac2b@cambridgegreys.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25648/Fri Nov 29 10:44:54 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/29/19 12:54 PM, Anton Ivanov wrote:
> On 29/11/2019 09:15, Daniel Borkmann wrote:
>> On 11/28/19 6:44 PM, anton.ivanov@cambridgegreys.com wrote:
>>> From: Anton Ivanov <anton.ivanov@cambridgegreys.com>
>>>
>>> This fixes a possible hang in bpf firmware loading in the
>>> UML vector io drivers due to use of GFP_KERNEL while holding
>>> a spinlock.
>>>
>>> Based on a prposed fix by weiyongjun1@huawei.com and suggestions for
>>> improving it by dan.carpenter@oracle.com
>>>
>>> Signed-off-by: Anton Ivanov <anton.ivanov@cambridgegreys.com>
>>
>> Any reason why this BPF firmware loading mechanism in UML vector driver that was
>> recently added [0] is plain old classic BPF? Quoting your commit log [0]:
> 
> It will allow whatever is allowed by sockfilter. Looking at the sockfilter implementation in the kernel it takes eBPF, however even the kernel docs still state BPF.

You are using SO_ATTACH_FILTER in uml_vector_attach_bpf() which is the old classic
BPF (and not eBPF). The kernel internally moves that over to eBPF insns, but you'll
be constrained forever with the abilities of cBPF. The later added SO_ATTACH_BPF is
the one for eBPF where you pass the prog fd from bpf().

>>    All vector drivers now allow a BPF program to be loaded and
>>    associated with the RX socket in the host kernel.
>>
>>    1. The program can be loaded as an extra kernel command line
>>    option to any of the vector drivers.
>>
>>    2. The program can also be loaded as "firmware", using the
>>    ethtool flash option. It is possible to turn this facility
>>    on or off using a command line option.
>>
>>    A simplistic wrapper for generating the BPF firmware for the raw
>>    socket driver out of a tcpdump/libpcap filter expression can be
>>    found at: https://github.com/kot-begemot-uk/uml_vector_utilities/
>>
>> ... it tells what it does but /nothing/ about the original rationale / use case
>> why it is needed. So what is the use case? And why is this only classic BPF? Is
>> there any discussion to read up that lead you to this decision of only implementing
>> handling for classic BPF?
> 
> Moving processing out of the GUEST onto the HOST using a safe language. The firmware load is on the GUEST and your BPF is your virtual NIC "firmware" which runs on the HOST (in the host kernel in fact).
> 
> It is identical as an idea to what Netronome cards do in hardware.
> 
>> I'm asking because classic BPF is /legacy/ stuff that is on feature freeze and
>> only very limited in terms of functionality compared to native (e)BPF which is
>> why you need this weird 'firmware' loader [1] which wraps around tcpdump to
>> parse the -ddd output into BPF insns ...
> 
> Because there is no other mechanism of retrieving it after it is compiled by libpcap in any of the common scripting languages.
> 
> The pcap Perl, Python, Go (or whatever else) wrappers do not give you access to the compiled code after the filter has been compiled.
> 
> Why is that ingenious design - you have to take it with their maintainers.
> 
> So if you want to start with pcap/tcpdump syntax and you do not want to rewrite that part of tcpdump as a dumper in C you have no other choice.
> 
> The starting point is chosen because the idea is at some point to replace the existing and very aged pcap network transport in UML. That takes pcap syntax on the kernel command line.
> 
> I admit it is a kludge, I will probably do the "do not want" bit and rewrite that in C.

Yeah, it would probably be about the same # of LOC in C.

> In any case - the "loader" is only an example, you can compile BPF using LLVM or whatever else you like.

But did you try that with the code you have? Seems not, which is perhaps why there are some
wrong assumptions.

You can't use LLVM's BPF backend here since you only allow to pass in cBPF, and LLVM emits
an object file with native eBPF insns (you could use libbpf (in-tree under tools/lib/bpf/)
for loading that).

> A.
