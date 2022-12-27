Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64F3F656784
	for <lists+netdev@lfdr.de>; Tue, 27 Dec 2022 07:33:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229936AbiL0GdV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Dec 2022 01:33:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229961AbiL0GdL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Dec 2022 01:33:11 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFFFA3BE
        for <netdev@vger.kernel.org>; Mon, 26 Dec 2022 22:32:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672122751;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aPmuqzn4nncHHPF0mSfrt/O6uFSxH0gzkjB0fGhp5og=;
        b=H2uDYm+A5C10JzdelrravglRV3i2o4TIfmYm/Sp7XhNJx1Y0Y3kM4za7mE5P7RHkB42GLQ
        36txHiCeCDYOrRzEZhMsZPpdYbtG6HrFPCykIUBm1R+yZHZ3bQIeGSYLB8Sk/N/NUoEs5E
        SB3byo9UwdYwOMEzR/tQ72Rmx0UmqXw=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-163-SpDzo_LYOcOYkFGBuHVNpQ-1; Tue, 27 Dec 2022 01:32:28 -0500
X-MC-Unique: SpDzo_LYOcOYkFGBuHVNpQ-1
Received: by mail-pf1-f197.google.com with SMTP id k127-20020a628485000000b0058029fb70a3so6558303pfd.19
        for <netdev@vger.kernel.org>; Mon, 26 Dec 2022 22:32:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aPmuqzn4nncHHPF0mSfrt/O6uFSxH0gzkjB0fGhp5og=;
        b=RhCbcG5wMD9lOFJozVcn0yIClDB/JoWX5qGwuieKiE0DnrQMk0qNFYU67uq1Onv9eg
         7S0V9SXb4mblcIRWyAd+VcGvsryXiZXn7sb1HEHYQuHMwkjoK3lywsJI2r5AwAfKO6jh
         um5XKGMBa/96MorHzNgk4AH5dCZ06yBTUBcbrjkmM8nUcjUAjqBTEdzQbZfMBEKq6/yr
         +XADT9bo3ugoTA+m72bc3tnyTvd87V1fd9q4yDpZte1HZSoo0aKPIDPB9hpHpUsQdQlo
         KMZcMNHyHRWdPlEkOxILyxy6yoVUiyukidtsT16444uTJ1cSx+5tXaklAx/BKRsb3jQj
         UCXw==
X-Gm-Message-State: AFqh2kp1vC4yqdAQSlBFYZDSSKQkGTki+Be93cC2d6vHJPG0YlvUCLsX
        1WEcFOZ1g7A6lr1qeJ1+nBw7y2Lo2MnQPiLlXcxN79fE9kMM0v1kmf6bYyVyHKemlJU1nAs88CH
        xEi2CWm74J3mlvUF/
X-Received: by 2002:a17:902:6b4c:b0:18f:9cfb:42aa with SMTP id g12-20020a1709026b4c00b0018f9cfb42aamr22045680plt.10.1672122747706;
        Mon, 26 Dec 2022 22:32:27 -0800 (PST)
X-Google-Smtp-Source: AMrXdXsrAnVNmNt22zl34xlV/FnvjFVshRXkKyTIIxTV5+bWVoE6t8kn2NguNc4g3QX4X8EQwBapUA==
X-Received: by 2002:a17:902:6b4c:b0:18f:9cfb:42aa with SMTP id g12-20020a1709026b4c00b0018f9cfb42aamr22045664plt.10.1672122747491;
        Mon, 26 Dec 2022 22:32:27 -0800 (PST)
Received: from [10.72.13.143] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x2-20020a170902ec8200b0017f72a430adsm8245068plg.71.2022.12.26.22.32.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Dec 2022 22:32:27 -0800 (PST)
Message-ID: <82eb2ffc-ce97-0c76-f7bc-8a163968cde7@redhat.com>
Date:   Tue, 27 Dec 2022 14:32:22 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH v2 2/9] virtio_net: set up xdp for multi buffer packets
Content-Language: en-US
To:     Heng Qi <hengqi@linux.alibaba.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     "Michael S . Tsirkin" <mst@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>
References: <20221220141449.115918-1-hengqi@linux.alibaba.com>
 <20221220141449.115918-3-hengqi@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20221220141449.115918-3-hengqi@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/12/20 22:14, Heng Qi 写道:
> When the xdp program sets xdp.frags, which means it can process
> multi-buffer packets over larger MTU, so we continue to support xdp.
> But for single-buffer xdp, we should keep checking for MTU.
>
> Signed-off-by: Heng Qi <hengqi@linux.alibaba.com>
> Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---
>   drivers/net/virtio_net.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 443aa7b8f0ad..c5c4e9db4ed3 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -3095,8 +3095,8 @@ static int virtnet_xdp_set(struct net_device *dev, struct bpf_prog *prog,
>   		return -EINVAL;
>   	}
>   
> -	if (dev->mtu > max_sz) {
> -		NL_SET_ERR_MSG_MOD(extack, "MTU too large to enable XDP");
> +	if (prog && !prog->aux->xdp_has_frags && dev->mtu > max_sz) {


Not related to this patch, but I see:

         unsigned long int max_sz = PAGE_SIZE - sizeof(struct 
padded_vnet_hdr);

Which is suspicious, do we need to count reserved headroom/tailroom as well?

Thanks


> +		NL_SET_ERR_MSG_MOD(extack, "MTU too large to enable XDP without frags");
>   		netdev_warn(dev, "XDP requires MTU less than %lu\n", max_sz);
>   		return -EINVAL;
>   	}

