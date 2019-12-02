Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCA1710E7B5
	for <lists+netdev@lfdr.de>; Mon,  2 Dec 2019 10:33:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726486AbfLBJdp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Dec 2019 04:33:45 -0500
Received: from ivanoab7.miniserver.com ([37.128.132.42]:60132 "EHLO
        www.kot-begemot.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726190AbfLBJdo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Dec 2019 04:33:44 -0500
Received: from tun252.jain.kot-begemot.co.uk ([192.168.18.6] helo=jain.kot-begemot.co.uk)
        by www.kot-begemot.co.uk with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <anton.ivanov@cambridgegreys.com>)
        id 1ibi5E-0004Xs-Gt; Mon, 02 Dec 2019 09:33:32 +0000
Received: from jain.kot-begemot.co.uk ([192.168.3.3])
        by jain.kot-begemot.co.uk with esmtp (Exim 4.92)
        (envelope-from <anton.ivanov@cambridgegreys.com>)
        id 1ibi5C-0006As-2n; Mon, 02 Dec 2019 09:33:32 +0000
Subject: Re: [PATCH] um: vector: fix BPF loading in vector drivers
From:   Anton Ivanov <anton.ivanov@cambridgegreys.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        linux-um@lists.infradead.org
Cc:     songliubraving@fb.com, jakub.kicinski@netronome.com,
        richard@nod.at, kernel-janitors@vger.kernel.org, ast@kernel.org,
        weiyongjun1@huawei.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kafai@fb.com, dan.carpenter@oracle.com
References: <20191128174405.4244-1-anton.ivanov@cambridgegreys.com>
 <1416753c-e966-e259-a84d-2a5f0a166660@iogearbox.net>
 <cccc22d6-ee0a-c219-2bf0-2b89ae07ac2b@cambridgegreys.com>
 <c54efbb0-8ac4-2788-5957-ff99ab357584@iogearbox.net>
 <fe8a15ff-7e95-548e-d41d-fa3ce1113202@cambridgegreys.com>
Message-ID: <643996ce-7b19-16b6-e02f-61859de04968@cambridgegreys.com>
Date:   Mon, 2 Dec 2019 09:33:29 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <fe8a15ff-7e95-548e-d41d-fa3ce1113202@cambridgegreys.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Spam-Score: -1.0
X-Spam-Score: -1.0
X-Clacks-Overhead: GNU Terry Pratchett
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 30/11/2019 07:29, Anton Ivanov wrote:
> On 29/11/2019 23:12, Daniel Borkmann wrote:
>> On 11/29/19 12:54 PM, Anton Ivanov wrote:
>>> On 29/11/2019 09:15, Daniel Borkmann wrote:
>>>> On 11/28/19 6:44 PM, anton.ivanov@cambridgegreys.com wrote:
>>>>> From: Anton Ivanov <anton.ivanov@cambridgegreys.com>
>>>>>
>>>>> This fixes a possible hang in bpf firmware loading in the
>>>>> UML vector io drivers due to use of GFP_KERNEL while holding
>>>>> a spinlock.
>>>>>
>>>>> Based on a prposed fix by weiyongjun1@huawei.com and suggestions for
>>>>> improving it by dan.carpenter@oracle.com
>>>>>
>>>>> Signed-off-by: Anton Ivanov <anton.ivanov@cambridgegreys.com>
>>>>
>>>> Any reason why this BPF firmware loading mechanism in UML vector 
>>>> driver that was
>>>> recently added [0] is plain old classic BPF? Quoting your commit log 
>>>> [0]:
>>>
>>> It will allow whatever is allowed by sockfilter. Looking at the 
>>> sockfilter implementation in the kernel it takes eBPF, however even 
>>> the kernel docs still state BPF.
>>
>> You are using SO_ATTACH_FILTER in uml_vector_attach_bpf() which is the 
>> old classic
>> BPF (and not eBPF). The kernel internally moves that over to eBPF 
>> insns, but you'll
>> be constrained forever with the abilities of cBPF. The later added 
>> SO_ATTACH_BPF is
>> the one for eBPF where you pass the prog fd from bpf().
> 
> I will switch to that in the next version.
> 
>>
>>>>    All vector drivers now allow a BPF program to be loaded and
>>>>    associated with the RX socket in the host kernel.
>>>>
>>>>    1. The program can be loaded as an extra kernel command line
>>>>    option to any of the vector drivers.
>>>>
>>>>    2. The program can also be loaded as "firmware", using the
>>>>    ethtool flash option. It is possible to turn this facility
>>>>    on or off using a command line option.
>>>>
>>>>    A simplistic wrapper for generating the BPF firmware for the raw
>>>>    socket driver out of a tcpdump/libpcap filter expression can be
>>>>    found at: https://github.com/kot-begemot-uk/uml_vector_utilities/
>>>>
>>>> ... it tells what it does but /nothing/ about the original rationale 
>>>> / use case
>>>> why it is needed. So what is the use case? And why is this only 
>>>> classic BPF? Is
>>>> there any discussion to read up that lead you to this decision of 
>>>> only implementing
>>>> handling for classic BPF?
>>>
>>> Moving processing out of the GUEST onto the HOST using a safe 
>>> language. The firmware load is on the GUEST and your BPF is your 
>>> virtual NIC "firmware" which runs on the HOST (in the host kernel in 
>>> fact).
>>>
>>> It is identical as an idea to what Netronome cards do in hardware.
>>>
>>>> I'm asking because classic BPF is /legacy/ stuff that is on feature 
>>>> freeze and
>>>> only very limited in terms of functionality compared to native 
>>>> (e)BPF which is
>>>> why you need this weird 'firmware' loader [1] which wraps around 
>>>> tcpdump to
>>>> parse the -ddd output into BPF insns ...
>>>
>>> Because there is no other mechanism of retrieving it after it is 
>>> compiled by libpcap in any of the common scripting languages.
>>>
>>> The pcap Perl, Python, Go (or whatever else) wrappers do not give you 
>>> access to the compiled code after the filter has been compiled.
>>>
>>> Why is that ingenious design - you have to take it with their 
>>> maintainers.
>>>
>>> So if you want to start with pcap/tcpdump syntax and you do not want 
>>> to rewrite that part of tcpdump as a dumper in C you have no other 
>>> choice.
>>>
>>> The starting point is chosen because the idea is at some point to 
>>> replace the existing and very aged pcap network transport in UML. 
>>> That takes pcap syntax on the kernel command line.
>>>
>>> I admit it is a kludge, I will probably do the "do not want" bit and 
>>> rewrite that in C.
>>
>> Yeah, it would probably be about the same # of LOC in C.
>>
>>> In any case - the "loader" is only an example, you can compile BPF 
>>> using LLVM or whatever else you like.
>>
>> But did you try that with the code you have? Seems not, which is 
>> perhaps why there are some
>> wrong assumptions.
> 
> All of my tests were done using bpf generated by tcpdump out of a pcap 
> expression. So the answer is no - I did not try LLVM because I did not 
> need to for what I was aiming to achieve.
> 
> The pcap route matches 1:1 existing functionality in the uml pcap driver 
> as well as existing functionality in the vector drivers for the cases 
> where they need to avoid seeing their own xmits and cannot use features 
> like QDISC_BYPASS.
> 
>>
>> You can't use LLVM's BPF backend here since you only allow to pass in 
>> cBPF, and LLVM emits
>> an object file with native eBPF insns (you could use libbpf (in-tree 
>> under tools/lib/bpf/)
>> for loading that).
> 
> My initial aim was the same feature sets as pcap and achieve it using a 
> virtual analogue of what cards like Netronome do - via the firmware route.
> 
> Switching to SO_ATTACH_BPF will come in the next revision.
> 
> A.
> 
>>
>>> A.
>>
>> _______________________________________________
>> linux-um mailing list
>> linux-um@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/linux-um
> 
> 
After reviewing what is needed for switching from SOCK_FILTER to 
SOCK_BPF, IMHO it will have to wait for a while.

1. I am not sticking yet another direct host syscall invocation into the 
userspace portion of the uml kernel and we cannot add extra userspace 
libraries like libbpf at present because it is not supported by kbuild.

I have a patch in the queue for that, but it will need to be approved by 
the kernel build people and merged before this can be done.

2. On top of that, in order to make use of eBPF for vNIC firmware 
properly, I will need to figure out the correct abstractions. The 
"program" part is quite clear - an  eBPF program fits exactly into the 
role of virtual nic firmware - it is identical to classic BPF and the 
way it is used at present.

The maps, however, and how do they go along with the "program firmware" 
is something which will need to be figured out. It may require a more 
complex load mechanisms and a proper (not 5 liner wrapper around pcap or 
tcpdump) firmware packer/unpacker.

Once I have figured it out and it can fit into the kbuild, I will send 
the next revision. I suspect that it will happen at about the same time 
I will finish the AF_XDP UML vNIC transport (it has the same 
requirements, needs the same calls and uses the same libraries).

-- 
Anton R. Ivanov
Cambridgegreys Limited. Registered in England. Company Number 10273661
https://www.cambridgegreys.com/
