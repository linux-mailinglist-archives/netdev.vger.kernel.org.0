Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0770163A2D3
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 09:24:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229914AbiK1IYC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 03:24:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229868AbiK1IYB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 03:24:01 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBFD817893
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 00:22:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669623766;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=08ACbZbm+f4rrW15utHPQxye3zrEyxUiKLzM8Bx4A7A=;
        b=Z/tWeFEPBT+UmmcRi6LInvcL60AY9V7vv52d17mfGDV8XR2iEABQ0m2YmmrVXzYQKxBI8w
        OtoDIGXbUob13B5BysiToG6jOVTFHCqhxLFD6lLBDPWgmfivrdHLm+U1LG2Gqv/dhO629q
        E0us1vCoO6ohD7lakwFah+WlG7Kz81M=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-605-9wU9V0cuMyOkYWJtJatrzA-1; Mon, 28 Nov 2022 03:22:44 -0500
X-MC-Unique: 9wU9V0cuMyOkYWJtJatrzA-1
Received: by mail-wr1-f72.google.com with SMTP id g14-20020adfa48e000000b00241f94bcd54so1628515wrb.23
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 00:22:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:organization:from
         :content-language:references:cc:to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=08ACbZbm+f4rrW15utHPQxye3zrEyxUiKLzM8Bx4A7A=;
        b=axzIDGZTMWJpeuSNs4iftnbNN2ItCpIhR9tIOuRDVTKQVQzqkfQlRYUcs13O+sRV1/
         u7OIQjB5hmYzsSaxKJwQBlhP+fMN8POaLAarTmZ9BZny980v0lCWjjox8VW6hQNCICoD
         Qtkv+1pQVmurwM05SKXbcndPVwRd/1VZCc5UE4baH0M/NGclQl7oGgVWv+8Y8aKNRlIC
         ChraCBTgilzf8xqETUI54xxq9IsGiUpBPJY605i85Ic2qsJalGB8bQFLFxjk/5TsFOlA
         JLUfbzae3G6VNbXLoKV74ehjizY9Dg3IeLbAXOn0lvJEu1iBk1i2m7E2nUWXnLRMfbD/
         2+RQ==
X-Gm-Message-State: ANoB5pkVLgok1971CbtSBAn7NBowQ6stc5HcyFd4jMik6x3uhKEzk7px
        kjGeByOEHpg6M/CEL1R+G0s1YXCuLWuokYdeEHgmp/y+BX+4AVOV20sia2OCpY200SQ23P/1rd5
        U2KEQ21wGMEP7qQN4
X-Received: by 2002:adf:eb8a:0:b0:22e:31b2:ecb9 with SMTP id t10-20020adfeb8a000000b0022e31b2ecb9mr30942292wrn.693.1669623763100;
        Mon, 28 Nov 2022 00:22:43 -0800 (PST)
X-Google-Smtp-Source: AA0mqf50AS2I3KjwPnQrek1jGvg+yRK5+MF+33CkcubpJsA9CW/SHNSir8fcEWGsp4QA6DOlcXT2PQ==
X-Received: by 2002:adf:eb8a:0:b0:22e:31b2:ecb9 with SMTP id t10-20020adfeb8a000000b0022e31b2ecb9mr30942267wrn.693.1669623762803;
        Mon, 28 Nov 2022 00:22:42 -0800 (PST)
Received: from ?IPV6:2003:cb:c702:9000:3d6:e434:f8b4:80cf? (p200300cbc702900003d6e434f8b480cf.dip0.t-ipconnect.de. [2003:cb:c702:9000:3d6:e434:f8b4:80cf])
        by smtp.gmail.com with ESMTPSA id l19-20020a056000023300b00241de5be3f0sm10082939wrz.37.2022.11.28.00.22.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Nov 2022 00:22:42 -0800 (PST)
Message-ID: <af62e7fe-d848-acb8-ca77-cdf01022b8de@redhat.com>
Date:   Mon, 28 Nov 2022 09:22:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
To:     Li Zetao <lizetao1@huawei.com>, mst@redhat.com,
        jasowang@redhat.com, pbonzini@redhat.com, stefanha@redhat.com,
        axboe@kernel.dk, kraxel@redhat.com, ericvh@gmail.com,
        lucho@ionkov.net, asmadeus@codewreck.org, linux_oss@crudebyte.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, rusty@rustcorp.com.au
Cc:     virtualization@lists.linux-foundation.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org
References: <20221128021005.232105-1-lizetao1@huawei.com>
 <20221128021005.232105-3-lizetao1@huawei.com>
Content-Language: en-US
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH 2/4] virtio-mem: Fix probe failed when modprobe virtio_mem
In-Reply-To: <20221128021005.232105-3-lizetao1@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28.11.22 03:10, Li Zetao wrote:
> When doing the following test steps, an error was found:
>    step 1: modprobe virtio_mem succeeded
>      # modprobe virtio_mem      <-- OK
> 
>    step 2: fault injection in virtio_mem_init()
>      # modprobe -r virtio_mem   <-- OK
>      # ...
>        CPU: 0 PID: 1837 Comm: modprobe Not tainted
>        6.1.0-rc6-00285-g6a1e40c4b995-dirty
>        Hardware name: QEMU Standard PC (i440FX + PIIX, 1996)
>        Call Trace:
>         <TASK>
>         should_fail.cold+0x5/0x1f
>         ...
>         virtio_mem_init_hotplug+0x9ae/0xe57 [virtio_mem]
>         virtio_mem_init.cold+0x327/0x339 [virtio_mem]
>         virtio_mem_probe+0x48e/0x910 [virtio_mem]
>         virtio_dev_probe+0x608/0xae0
>         ...
>         </TASK>
>        virtio_mem virtio4: could not reserve device region
>        virtio_mem: probe of virtio4 failed with error -16
> 
>    step 3: modprobe virtio_net failed

virtio_net ?

>      # modprobe virtio_mem       <-- failed
>        virtio_mem: probe of virtio4 failed with error -16
> 
> The root cause of the problem is that the virtqueues are not
> stopped on the error handling path when virtio_mem_init()
> fails in virtio_mem_probe(), resulting in an error "-ENOENT"
> returned in the next modprobe call in setup_vq().
> 
> virtio_pci_modern_device uses virtqueues to send or
> receive message, and "queue_enable" records whether the
> queues are available. In vp_modern_find_vqs(), all queues
> will be selected and activated, but once queues are enabled
> there is no way to go back except reset.
> 
> Fix it by reset virtio device on error handling path. After
> virtio_mem_init_vq() succeeded, all virtqueues should be
> stopped on error handling path.
> 
> Fixes: 1fcf0512c9c8 ("virtio_pci: modern driver")

That commit is from 2014. virtio-mem was merged in 2020

Fixes: 5f1f79bbc9e2 ("virtio-mem: Paravirtualized memory hotplug")

> Signed-off-by: Li Zetao <lizetao1@huawei.com>
> ---
>   drivers/virtio/virtio_mem.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/virtio/virtio_mem.c b/drivers/virtio/virtio_mem.c
> index 0c2892ec6817..c7f09c2ce982 100644
> --- a/drivers/virtio/virtio_mem.c
> +++ b/drivers/virtio/virtio_mem.c
> @@ -2793,6 +2793,7 @@ static int virtio_mem_probe(struct virtio_device *vdev)
>   
>   	return 0;
>   out_del_vq:
> +	virtio_reset_device(vdev);
>   	vdev->config->del_vqs(vdev);
>   out_free_vm:
>   	kfree(vm);


Apart from that

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Thanks,

David / dhildenb

