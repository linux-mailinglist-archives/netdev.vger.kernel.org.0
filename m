Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D328510D318
	for <lists+netdev@lfdr.de>; Fri, 29 Nov 2019 10:15:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726709AbfK2JPt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Nov 2019 04:15:49 -0500
Received: from www62.your-server.de ([213.133.104.62]:55780 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726143AbfK2JPt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Nov 2019 04:15:49 -0500
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iacN8-0004Ma-KY; Fri, 29 Nov 2019 10:15:30 +0100
Received: from [2a02:1205:507e:bf80:bef8:7f66:49c8:72e5] (helo=pc-11.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1iacN8-000C4L-8d; Fri, 29 Nov 2019 10:15:30 +0100
Subject: Re: [PATCH] um: vector: fix BPF loading in vector drivers
To:     anton.ivanov@cambridgegreys.com, linux-um@lists.infradead.org
Cc:     richard@nod.at, dan.carpenter@oracle.com, weiyongjun1@huawei.com,
        kernel-janitors@vger.kernel.org, songliubraving@fb.com,
        ast@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kafai@fb.com
References: <20191128174405.4244-1-anton.ivanov@cambridgegreys.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <1416753c-e966-e259-a84d-2a5f0a166660@iogearbox.net>
Date:   Fri, 29 Nov 2019 10:15:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20191128174405.4244-1-anton.ivanov@cambridgegreys.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25647/Thu Nov 28 10:49:14 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/28/19 6:44 PM, anton.ivanov@cambridgegreys.com wrote:
> From: Anton Ivanov <anton.ivanov@cambridgegreys.com>
> 
> This fixes a possible hang in bpf firmware loading in the
> UML vector io drivers due to use of GFP_KERNEL while holding
> a spinlock.
> 
> Based on a prposed fix by weiyongjun1@huawei.com and suggestions for
> improving it by dan.carpenter@oracle.com
> 
> Signed-off-by: Anton Ivanov <anton.ivanov@cambridgegreys.com>

Any reason why this BPF firmware loading mechanism in UML vector driver that was
recently added [0] is plain old classic BPF? Quoting your commit log [0]:

   All vector drivers now allow a BPF program to be loaded and
   associated with the RX socket in the host kernel.

   1. The program can be loaded as an extra kernel command line
   option to any of the vector drivers.

   2. The program can also be loaded as "firmware", using the
   ethtool flash option. It is possible to turn this facility
   on or off using a command line option.

   A simplistic wrapper for generating the BPF firmware for the raw
   socket driver out of a tcpdump/libpcap filter expression can be
   found at: https://github.com/kot-begemot-uk/uml_vector_utilities/

... it tells what it does but /nothing/ about the original rationale / use case
why it is needed. So what is the use case? And why is this only classic BPF? Is
there any discussion to read up that lead you to this decision of only implementing
handling for classic BPF?

I'm asking because classic BPF is /legacy/ stuff that is on feature freeze and
only very limited in terms of functionality compared to native (e)BPF which is
why you need this weird 'firmware' loader [1] which wraps around tcpdump to
parse the -ddd output into BPF insns ...

Thanks,
Daniel

   [0] https://git.kernel.org/pub/scm/linux/kernel/git/rw/uml.git/commit/?h=linux-next&id=9807019a62dc670c73ce8e59e09b41ae458c34b3
   [1] https://github.com/kot-begemot-uk/uml_vector_utilities/blob/master/build_bpf_firmware.py

>   arch/um/drivers/vector_kern.c | 38 ++++++++++++++++++-----------------
>   1 file changed, 20 insertions(+), 18 deletions(-)
> 
> diff --git a/arch/um/drivers/vector_kern.c b/arch/um/drivers/vector_kern.c
> index 92617e16829e..dbbc6e850fdd 100644
> --- a/arch/um/drivers/vector_kern.c
> +++ b/arch/um/drivers/vector_kern.c
> @@ -1387,6 +1387,7 @@ static int vector_net_load_bpf_flash(struct net_device *dev,
>   	struct vector_private *vp = netdev_priv(dev);
>   	struct vector_device *vdevice;
>   	const struct firmware *fw;
> +	void *new_filter;
>   	int result = 0;
>   
>   	if (!(vp->options & VECTOR_BPF_FLASH)) {
> @@ -1394,6 +1395,15 @@ static int vector_net_load_bpf_flash(struct net_device *dev,
>   		return -1;
>   	}
>   
> +	vdevice = find_device(vp->unit);
> +
> +	if (request_firmware(&fw, efl->data, &vdevice->pdev.dev))
> +		return -1;
> +
> +	new_filter = kmemdup(fw->data, fw->size, GFP_KERNEL);
> +	if (!new_filter)
> +		goto free_buffer;
> +
>   	spin_lock(&vp->lock);
>   
>   	if (vp->bpf != NULL) {
> @@ -1402,41 +1412,33 @@ static int vector_net_load_bpf_flash(struct net_device *dev,
>   		kfree(vp->bpf->filter);
>   		vp->bpf->filter = NULL;
>   	} else {
> -		vp->bpf = kmalloc(sizeof(struct sock_fprog), GFP_KERNEL);
> +		vp->bpf = kmalloc(sizeof(struct sock_fprog), GFP_ATOMIC);
>   		if (vp->bpf == NULL) {
>   			netdev_err(dev, "failed to allocate memory for firmware\n");
> -			goto flash_fail;
> +			goto apply_flash_fail;
>   		}
>   	}
>   
> -	vdevice = find_device(vp->unit);
> -
> -	if (request_firmware(&fw, efl->data, &vdevice->pdev.dev))
> -		goto flash_fail;
> -
> -	vp->bpf->filter = kmemdup(fw->data, fw->size, GFP_KERNEL);
> -	if (!vp->bpf->filter)
> -		goto free_buffer;
> -
> +	vp->bpf->filter = new_filter;
>   	vp->bpf->len = fw->size / sizeof(struct sock_filter);
> -	release_firmware(fw);
>   
>   	if (vp->opened)
>   		result = uml_vector_attach_bpf(vp->fds->rx_fd, vp->bpf);
>   
>   	spin_unlock(&vp->lock);
>   
> -	return result;
> -
> -free_buffer:
>   	release_firmware(fw);
>   
> -flash_fail:
> +	return result;
> +
> +apply_flash_fail:
>   	spin_unlock(&vp->lock);
> -	if (vp->bpf != NULL)
> +	if (vp->bpf)
>   		kfree(vp->bpf->filter);
>   	kfree(vp->bpf);
> -	vp->bpf = NULL;
> +
> +free_buffer:
> +	release_firmware(fw);
>   	return -1;
>   }
>   
> 

