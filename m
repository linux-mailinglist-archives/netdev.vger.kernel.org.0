Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40CC610C5ED
	for <lists+netdev@lfdr.de>; Thu, 28 Nov 2019 10:24:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbfK1JYX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Nov 2019 04:24:23 -0500
Received: from ivanoab7.miniserver.com ([37.128.132.42]:50718 "EHLO
        www.kot-begemot.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726181AbfK1JYW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Nov 2019 04:24:22 -0500
Received: from tun252.jain.kot-begemot.co.uk ([192.168.18.6] helo=jain.kot-begemot.co.uk)
        by www.kot-begemot.co.uk with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <anton.ivanov@cambridgegreys.com>)
        id 1iaG23-0006JS-1o; Thu, 28 Nov 2019 09:24:16 +0000
Received: from jain.kot-begemot.co.uk ([192.168.3.3])
        by jain.kot-begemot.co.uk with esmtp (Exim 4.92)
        (envelope-from <anton.ivanov@cambridgegreys.com>)
        id 1iaG20-0006G8-LX; Thu, 28 Nov 2019 09:24:14 +0000
Subject: Re: [PATCH -next] um: vector: use GFP_ATOMIC under spin lock
To:     Richard Weinberger <richard@nod.at>
Cc:     Song Liu <songliubraving@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        linux-um <linux-um@lists.infradead.org>,
        Jeff Dike <jdike@addtoit.com>,
        kernel-janitors <kernel-janitors@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        netdev <netdev@vger.kernel.org>, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
References: <20191128020147.191893-1-weiyongjun1@huawei.com>
 <20191128080641.GD1781@kadam>
 <5892ee7c-ff24-fb3c-6911-44e0b1d5895f@cambridgegreys.com>
 <1784077834.99875.1574930472125.JavaMail.zimbra@nod.at>
From:   Anton Ivanov <anton.ivanov@cambridgegreys.com>
Message-ID: <ceedf42c-2dc0-df2e-cf3f-323c675dec78@cambridgegreys.com>
Date:   Thu, 28 Nov 2019 09:24:12 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <1784077834.99875.1574930472125.JavaMail.zimbra@nod.at>
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



On 28/11/2019 08:41, Richard Weinberger wrote:
> ----- Ursprüngliche Mail -----
>> Von: "anton ivanov" <anton.ivanov@cambridgegreys.com>
>> An: "Dan Carpenter" <dan.carpenter@oracle.com>, "Wei Yongjun" <weiyongjun1@huawei.com>
>> CC: "Song Liu" <songliubraving@fb.com>, "Daniel Borkmann" <daniel@iogearbox.net>, "kernel-janitors"
>> <kernel-janitors@vger.kernel.org>, "richard" <richard@nod.at>, "Jeff Dike" <jdike@addtoit.com>, "linux-um"
>> <linux-um@lists.infradead.org>, "Alexei Starovoitov" <ast@kernel.org>, "netdev" <netdev@vger.kernel.org>,
>> bpf@vger.kernel.org, "Martin KaFai Lau" <kafai@fb.com>
>> Gesendet: Donnerstag, 28. November 2019 09:18:30
>> Betreff: Re: [PATCH -next] um: vector: use GFP_ATOMIC under spin lock
> 
>> On 28/11/2019 08:06, Dan Carpenter wrote:
>>> On Thu, Nov 28, 2019 at 02:01:47AM +0000, Wei Yongjun wrote:
>>>> A spin lock is taken here so we should use GFP_ATOMIC.
>>>>
>>>> Fixes: 9807019a62dc ("um: Loadable BPF "Firmware" for vector drivers")
>>>> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
>>>> ---
>>>>    arch/um/drivers/vector_kern.c | 4 ++--
>>>>    1 file changed, 2 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/arch/um/drivers/vector_kern.c b/arch/um/drivers/vector_kern.c
>>>> index 92617e16829e..6ff0065a271d 100644
>>>> --- a/arch/um/drivers/vector_kern.c
>>>> +++ b/arch/um/drivers/vector_kern.c
>>>> @@ -1402,7 +1402,7 @@ static int vector_net_load_bpf_flash(struct net_device
>>>> *dev,
>>>>    		kfree(vp->bpf->filter);
>>>>    		vp->bpf->filter = NULL;
>>>>    	} else {
>>>> -		vp->bpf = kmalloc(sizeof(struct sock_fprog), GFP_KERNEL);
>>>> +		vp->bpf = kmalloc(sizeof(struct sock_fprog), GFP_ATOMIC);
>>>>    		if (vp->bpf == NULL) {
>>>>    			netdev_err(dev, "failed to allocate memory for firmware\n");
>>>>    			goto flash_fail;
>>>> @@ -1414,7 +1414,7 @@ static int vector_net_load_bpf_flash(struct net_device
>>>> *dev,
>>>>    	if (request_firmware(&fw, efl->data, &vdevice->pdev.dev))
>>>               ^^^^^^^^^^^^^^^^
>>>
>>> Is it really possible to call request_firmware() while holding a
>>> spin_lock?  I was so sure that read from the disk.
>>
>> Works, I tested the patch quite a few times.
> 
> It works because of the nature of UML ->no  SMP or PREEMPT.
> But better request the firmware before taking the spinlock.
> request_firmware() can block.
> Same for the kmalloc(), just allocate the buffer before and then assign
> the pointer under the lock. That way you don't need GFP_ATOMIC.

Ack.

I will make an incremental on top of the existing patch (as that is 
already in -next

Brgds,

> 
> Thanks,
> //richard
> 
> _______________________________________________
> linux-um mailing list
> linux-um@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-um
> 

-- 
Anton R. Ivanov
Cambridgegreys Limited. Registered in England. Company Number 10273661
https://www.cambridgegreys.com/
