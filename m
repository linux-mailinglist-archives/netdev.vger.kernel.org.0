Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF19210D53C
	for <lists+netdev@lfdr.de>; Fri, 29 Nov 2019 12:54:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbfK2Lyu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Nov 2019 06:54:50 -0500
Received: from ivanoab7.miniserver.com ([37.128.132.42]:53692 "EHLO
        www.kot-begemot.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725892AbfK2Lyu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Nov 2019 06:54:50 -0500
Received: from tun252.jain.kot-begemot.co.uk ([192.168.18.6] helo=jain.kot-begemot.co.uk)
        by www.kot-begemot.co.uk with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <anton.ivanov@cambridgegreys.com>)
        id 1iaerD-0001y9-9y; Fri, 29 Nov 2019 11:54:43 +0000
Received: from jain.kot-begemot.co.uk ([192.168.3.3])
        by jain.kot-begemot.co.uk with esmtp (Exim 4.92)
        (envelope-from <anton.ivanov@cambridgegreys.com>)
        id 1iaerA-0005Yv-SH; Fri, 29 Nov 2019 11:54:43 +0000
Subject: Re: [PATCH] um: vector: fix BPF loading in vector drivers
To:     Daniel Borkmann <daniel@iogearbox.net>,
        linux-um@lists.infradead.org
Cc:     richard@nod.at, dan.carpenter@oracle.com, weiyongjun1@huawei.com,
        kernel-janitors@vger.kernel.org, songliubraving@fb.com,
        ast@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kafai@fb.com
References: <20191128174405.4244-1-anton.ivanov@cambridgegreys.com>
 <1416753c-e966-e259-a84d-2a5f0a166660@iogearbox.net>
From:   Anton Ivanov <anton.ivanov@cambridgegreys.com>
Message-ID: <cccc22d6-ee0a-c219-2bf0-2b89ae07ac2b@cambridgegreys.com>
Date:   Fri, 29 Nov 2019 11:54:40 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <1416753c-e966-e259-a84d-2a5f0a166660@iogearbox.net>
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



On 29/11/2019 09:15, Daniel Borkmann wrote:
> On 11/28/19 6:44 PM, anton.ivanov@cambridgegreys.com wrote:
>> From: Anton Ivanov <anton.ivanov@cambridgegreys.com>
>>
>> This fixes a possible hang in bpf firmware loading in the
>> UML vector io drivers due to use of GFP_KERNEL while holding
>> a spinlock.
>>
>> Based on a prposed fix by weiyongjun1@huawei.com and suggestions for
>> improving it by dan.carpenter@oracle.com
>>
>> Signed-off-by: Anton Ivanov <anton.ivanov@cambridgegreys.com>
> 
> Any reason why this BPF firmware loading mechanism in UML vector driver 
> that was
> recently added [0] is plain old classic BPF? Quoting your commit log [0]:

It will allow whatever is allowed by sockfilter. Looking at the 
sockfilter implementation in the kernel it takes eBPF, however even the 
kernel docs still state BPF.

> 
>    All vector drivers now allow a BPF program to be loaded and
>    associated with the RX socket in the host kernel.
> 
>    1. The program can be loaded as an extra kernel command line
>    option to any of the vector drivers.
> 
>    2. The program can also be loaded as "firmware", using the
>    ethtool flash option. It is possible to turn this facility
>    on or off using a command line option.
> 
>    A simplistic wrapper for generating the BPF firmware for the raw
>    socket driver out of a tcpdump/libpcap filter expression can be
>    found at: https://github.com/kot-begemot-uk/uml_vector_utilities/
> 
> ... it tells what it does but /nothing/ about the original rationale / 
> use case
> why it is needed. So what is the use case? And why is this only classic 
> BPF? Is
> there any discussion to read up that lead you to this decision of only 
> implementing
> handling for classic BPF?

Moving processing out of the GUEST onto the HOST using a safe language. 
The firmware load is on the GUEST and your BPF is your virtual NIC 
"firmware" which runs on the HOST (in the host kernel in fact).

It is identical as an idea to what Netronome cards do in hardware.

> 
> I'm asking because classic BPF is /legacy/ stuff that is on feature 
> freeze and
> only very limited in terms of functionality compared to native (e)BPF 
> which is
> why you need this weird 'firmware' loader [1] which wraps around tcpdump to
> parse the -ddd output into BPF insns ...

Because there is no other mechanism of retrieving it after it is 
compiled by libpcap in any of the common scripting languages.

The pcap Perl, Python, Go (or whatever else) wrappers do not give you 
access to the compiled code after the filter has been compiled.

Why is that ingenious design - you have to take it with their maintainers.

So if you want to start with pcap/tcpdump syntax and you do not want to 
rewrite that part of tcpdump as a dumper in C you have no other choice.

The starting point is chosen because the idea is at some point to 
replace the existing and very aged pcap network transport in UML. That 
takes pcap syntax on the kernel command line.

I admit it is a kludge, I will probably do the "do not want" bit and 
rewrite that in C.

In any case - the "loader" is only an example, you can compile BPF using 
LLVM or whatever else you like.

A.

> 
> Thanks,
> Daniel
> 
>    [0] 
> https://git.kernel.org/pub/scm/linux/kernel/git/rw/uml.git/commit/?h=linux-next&id=9807019a62dc670c73ce8e59e09b41ae458c34b3 
> 
>    [1] 
> https://github.com/kot-begemot-uk/uml_vector_utilities/blob/master/build_bpf_firmware.py 
> 
> 
>>   arch/um/drivers/vector_kern.c | 38 ++++++++++++++++++-----------------
>>   1 file changed, 20 insertions(+), 18 deletions(-)
>>
>> diff --git a/arch/um/drivers/vector_kern.c 
>> b/arch/um/drivers/vector_kern.c
>> index 92617e16829e..dbbc6e850fdd 100644
>> --- a/arch/um/drivers/vector_kern.c
>> +++ b/arch/um/drivers/vector_kern.c
>> @@ -1387,6 +1387,7 @@ static int vector_net_load_bpf_flash(struct 
>> net_device *dev,
>>       struct vector_private *vp = netdev_priv(dev);
>>       struct vector_device *vdevice;
>>       const struct firmware *fw;
>> +    void *new_filter;
>>       int result = 0;
>>       if (!(vp->options & VECTOR_BPF_FLASH)) {
>> @@ -1394,6 +1395,15 @@ static int vector_net_load_bpf_flash(struct 
>> net_device *dev,
>>           return -1;
>>       }
>> +    vdevice = find_device(vp->unit);
>> +
>> +    if (request_firmware(&fw, efl->data, &vdevice->pdev.dev))
>> +        return -1;
>> +
>> +    new_filter = kmemdup(fw->data, fw->size, GFP_KERNEL);
>> +    if (!new_filter)
>> +        goto free_buffer;
>> +
>>       spin_lock(&vp->lock);
>>       if (vp->bpf != NULL) {
>> @@ -1402,41 +1412,33 @@ static int vector_net_load_bpf_flash(struct 
>> net_device *dev,
>>           kfree(vp->bpf->filter);
>>           vp->bpf->filter = NULL;
>>       } else {
>> -        vp->bpf = kmalloc(sizeof(struct sock_fprog), GFP_KERNEL);
>> +        vp->bpf = kmalloc(sizeof(struct sock_fprog), GFP_ATOMIC);
>>           if (vp->bpf == NULL) {
>>               netdev_err(dev, "failed to allocate memory for 
>> firmware\n");
>> -            goto flash_fail;
>> +            goto apply_flash_fail;
>>           }
>>       }
>> -    vdevice = find_device(vp->unit);
>> -
>> -    if (request_firmware(&fw, efl->data, &vdevice->pdev.dev))
>> -        goto flash_fail;
>> -
>> -    vp->bpf->filter = kmemdup(fw->data, fw->size, GFP_KERNEL);
>> -    if (!vp->bpf->filter)
>> -        goto free_buffer;
>> -
>> +    vp->bpf->filter = new_filter;
>>       vp->bpf->len = fw->size / sizeof(struct sock_filter);
>> -    release_firmware(fw);
>>       if (vp->opened)
>>           result = uml_vector_attach_bpf(vp->fds->rx_fd, vp->bpf);
>>       spin_unlock(&vp->lock);
>> -    return result;
>> -
>> -free_buffer:
>>       release_firmware(fw);
>> -flash_fail:
>> +    return result;
>> +
>> +apply_flash_fail:
>>       spin_unlock(&vp->lock);
>> -    if (vp->bpf != NULL)
>> +    if (vp->bpf)
>>           kfree(vp->bpf->filter);
>>       kfree(vp->bpf);
>> -    vp->bpf = NULL;
>> +
>> +free_buffer:
>> +    release_firmware(fw);
>>       return -1;
>>   }
>>
> 
> 

-- 
Anton R. Ivanov
Cambridgegreys Limited. Registered in England. Company Number 10273661
https://www.cambridgegreys.com/
