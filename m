Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D58410C558
	for <lists+netdev@lfdr.de>; Thu, 28 Nov 2019 09:41:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727547AbfK1IlT convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 28 Nov 2019 03:41:19 -0500
Received: from lithops.sigma-star.at ([195.201.40.130]:49034 "EHLO
        lithops.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726937AbfK1IlT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Nov 2019 03:41:19 -0500
Received: from localhost (localhost [127.0.0.1])
        by lithops.sigma-star.at (Postfix) with ESMTP id C0F90605A915;
        Thu, 28 Nov 2019 09:41:15 +0100 (CET)
Received: from lithops.sigma-star.at ([127.0.0.1])
        by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id 6HwXfqQxNdPA; Thu, 28 Nov 2019 09:41:12 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by lithops.sigma-star.at (Postfix) with ESMTP id 743CB607BD98;
        Thu, 28 Nov 2019 09:41:12 +0100 (CET)
Received: from lithops.sigma-star.at ([127.0.0.1])
        by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id XTUUL9IeyYvs; Thu, 28 Nov 2019 09:41:12 +0100 (CET)
Received: from lithops.sigma-star.at (lithops.sigma-star.at [195.201.40.130])
        by lithops.sigma-star.at (Postfix) with ESMTP id 3F62F605A915;
        Thu, 28 Nov 2019 09:41:12 +0100 (CET)
Date:   Thu, 28 Nov 2019 09:41:12 +0100 (CET)
From:   Richard Weinberger <richard@nod.at>
To:     anton ivanov <anton.ivanov@cambridgegreys.com>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Song Liu <songliubraving@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        kernel-janitors <kernel-janitors@vger.kernel.org>,
        Jeff Dike <jdike@addtoit.com>,
        linux-um <linux-um@lists.infradead.org>,
        Alexei Starovoitov <ast@kernel.org>,
        netdev <netdev@vger.kernel.org>, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>
Message-ID: <1784077834.99875.1574930472125.JavaMail.zimbra@nod.at>
In-Reply-To: <5892ee7c-ff24-fb3c-6911-44e0b1d5895f@cambridgegreys.com>
References: <20191128020147.191893-1-weiyongjun1@huawei.com> <20191128080641.GD1781@kadam> <5892ee7c-ff24-fb3c-6911-44e0b1d5895f@cambridgegreys.com>
Subject: Re: [PATCH -next] um: vector: use GFP_ATOMIC under spin lock
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [195.201.40.130]
X-Mailer: Zimbra 8.8.12_GA_3807 (ZimbraWebClient - FF68 (Linux)/8.8.12_GA_3809)
Thread-Topic: vector: use GFP_ATOMIC under spin lock
Thread-Index: 2J60FgWBh1I2FSErd4xdDGw7I9dybg==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

----- Ursprüngliche Mail -----
> Von: "anton ivanov" <anton.ivanov@cambridgegreys.com>
> An: "Dan Carpenter" <dan.carpenter@oracle.com>, "Wei Yongjun" <weiyongjun1@huawei.com>
> CC: "Song Liu" <songliubraving@fb.com>, "Daniel Borkmann" <daniel@iogearbox.net>, "kernel-janitors"
> <kernel-janitors@vger.kernel.org>, "richard" <richard@nod.at>, "Jeff Dike" <jdike@addtoit.com>, "linux-um"
> <linux-um@lists.infradead.org>, "Alexei Starovoitov" <ast@kernel.org>, "netdev" <netdev@vger.kernel.org>,
> bpf@vger.kernel.org, "Martin KaFai Lau" <kafai@fb.com>
> Gesendet: Donnerstag, 28. November 2019 09:18:30
> Betreff: Re: [PATCH -next] um: vector: use GFP_ATOMIC under spin lock

> On 28/11/2019 08:06, Dan Carpenter wrote:
>> On Thu, Nov 28, 2019 at 02:01:47AM +0000, Wei Yongjun wrote:
>>> A spin lock is taken here so we should use GFP_ATOMIC.
>>>
>>> Fixes: 9807019a62dc ("um: Loadable BPF "Firmware" for vector drivers")
>>> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
>>> ---
>>>   arch/um/drivers/vector_kern.c | 4 ++--
>>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/arch/um/drivers/vector_kern.c b/arch/um/drivers/vector_kern.c
>>> index 92617e16829e..6ff0065a271d 100644
>>> --- a/arch/um/drivers/vector_kern.c
>>> +++ b/arch/um/drivers/vector_kern.c
>>> @@ -1402,7 +1402,7 @@ static int vector_net_load_bpf_flash(struct net_device
>>> *dev,
>>>   		kfree(vp->bpf->filter);
>>>   		vp->bpf->filter = NULL;
>>>   	} else {
>>> -		vp->bpf = kmalloc(sizeof(struct sock_fprog), GFP_KERNEL);
>>> +		vp->bpf = kmalloc(sizeof(struct sock_fprog), GFP_ATOMIC);
>>>   		if (vp->bpf == NULL) {
>>>   			netdev_err(dev, "failed to allocate memory for firmware\n");
>>>   			goto flash_fail;
>>> @@ -1414,7 +1414,7 @@ static int vector_net_load_bpf_flash(struct net_device
>>> *dev,
>>>   	if (request_firmware(&fw, efl->data, &vdevice->pdev.dev))
>>              ^^^^^^^^^^^^^^^^
>> 
>> Is it really possible to call request_firmware() while holding a
>> spin_lock?  I was so sure that read from the disk.
> 
> Works, I tested the patch quite a few times.

It works because of the nature of UML ->no  SMP or PREEMPT.
But better request the firmware before taking the spinlock.
request_firmware() can block.
Same for the kmalloc(), just allocate the buffer before and then assign
the pointer under the lock. That way you don't need GFP_ATOMIC.

Thanks,
//richard
