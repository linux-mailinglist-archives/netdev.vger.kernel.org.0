Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A692510C48A
	for <lists+netdev@lfdr.de>; Thu, 28 Nov 2019 08:51:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726730AbfK1HvO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Nov 2019 02:51:14 -0500
Received: from ivanoab7.miniserver.com ([37.128.132.42]:50472 "EHLO
        www.kot-begemot.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726448AbfK1HvN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Nov 2019 02:51:13 -0500
Received: from tun252.jain.kot-begemot.co.uk ([192.168.18.6] helo=jain.kot-begemot.co.uk)
        by www.kot-begemot.co.uk with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <anton.ivanov@cambridgegreys.com>)
        id 1iaEZw-00064a-J8; Thu, 28 Nov 2019 07:51:08 +0000
Received: from sleer.kot-begemot.co.uk ([192.168.3.72])
        by jain.kot-begemot.co.uk with esmtps (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <anton.ivanov@cambridgegreys.com>)
        id 1iaEZu-0003UN-3Z; Thu, 28 Nov 2019 07:51:08 +0000
Subject: Re: [PATCH -next] um: vector: use GFP_ATOMIC under spin lock
To:     Wei Yongjun <weiyongjun1@huawei.com>,
        Jeff Dike <jdike@addtoit.com>,
        Richard Weinberger <richard@nod.at>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>
Cc:     kernel-janitors@vger.kernel.org, linux-um@lists.infradead.org,
        bpf@vger.kernel.org, netdev@vger.kernel.org
References: <20191128020147.191893-1-weiyongjun1@huawei.com>
From:   Anton Ivanov <anton.ivanov@cambridgegreys.com>
Organization: Cambridge Greys
Message-ID: <b4ebeac2-c180-0ca0-5170-e9ff2fac32e9@cambridgegreys.com>
Date:   Thu, 28 Nov 2019 07:51:06 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191128020147.191893-1-weiyongjun1@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0
X-Spam-Score: -1.0
X-Clacks-Overhead: GNU Terry Pratchett
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28/11/2019 02:01, Wei Yongjun wrote:
> A spin lock is taken here so we should use GFP_ATOMIC.
> 
> Fixes: 9807019a62dc ("um: Loadable BPF "Firmware" for vector drivers")
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> ---
>   arch/um/drivers/vector_kern.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/um/drivers/vector_kern.c b/arch/um/drivers/vector_kern.c
> index 92617e16829e..6ff0065a271d 100644
> --- a/arch/um/drivers/vector_kern.c
> +++ b/arch/um/drivers/vector_kern.c
> @@ -1402,7 +1402,7 @@ static int vector_net_load_bpf_flash(struct net_device *dev,
>   		kfree(vp->bpf->filter);
>   		vp->bpf->filter = NULL;
>   	} else {
> -		vp->bpf = kmalloc(sizeof(struct sock_fprog), GFP_KERNEL);
> +		vp->bpf = kmalloc(sizeof(struct sock_fprog), GFP_ATOMIC);
>   		if (vp->bpf == NULL) {
>   			netdev_err(dev, "failed to allocate memory for firmware\n");
>   			goto flash_fail;
> @@ -1414,7 +1414,7 @@ static int vector_net_load_bpf_flash(struct net_device *dev,
>   	if (request_firmware(&fw, efl->data, &vdevice->pdev.dev))
>   		goto flash_fail;
>   
> -	vp->bpf->filter = kmemdup(fw->data, fw->size, GFP_KERNEL);
> +	vp->bpf->filter = kmemdup(fw->data, fw->size, GFP_ATOMIC);
>   	if (!vp->bpf->filter)
>   		goto free_buffer;
> 
> 
> 
> 

Acked-by: Anton Ivanov <anton.ivanov@cambridgegreys.co.uk>

> _______________________________________________
> linux-um mailing list
> linux-um@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-um
> 


-- 
Anton R. Ivanov
Cambridgegreys Limited. Registered in England. Company Number 10273661
https://www.cambridgegreys.com/
