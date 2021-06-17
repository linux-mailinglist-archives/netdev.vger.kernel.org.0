Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D96E3AA986
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 05:24:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230137AbhFQD0P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 23:26:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44894 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229992AbhFQD0O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 23:26:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623900246;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=P2YA3pPwX5KufYHZusNwV1Ms/tC5NgvQ2lY4eCYE9qw=;
        b=DSCD6Depk82GdWEIyvmUobkMAaJaDhM7Qd/F7TAe4KoN2RHY9nEcIsiLY2kKOVDfMQ9l89
        qDr64J2Vd7TuKOE9n8aJt7zZ2UnKIBqSF+Pxyb6q2KRQbgE7b/qnqM62wt9dOQtzzQ3EXV
        JGHm5NSnK+dwMSRhaKdK1Yes+KFtPzo=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-19-10zSgNVEPd2SxtAI92P5bA-1; Wed, 16 Jun 2021 23:24:05 -0400
X-MC-Unique: 10zSgNVEPd2SxtAI92P5bA-1
Received: by mail-pf1-f197.google.com with SMTP id j206-20020a6280d70000b02902e9e02e1654so2899183pfd.6
        for <netdev@vger.kernel.org>; Wed, 16 Jun 2021 20:24:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=P2YA3pPwX5KufYHZusNwV1Ms/tC5NgvQ2lY4eCYE9qw=;
        b=pqoRhGkEN4UKQcvjvNf0D1XfRl25DM8AEatKHTvR4FYP66Aatdq3kJGg55t4/Yab2b
         O4csZv6/V1W2fxnbom6M3XnfBEln0mPSWTAxPdtAKCsk2QjwsOpCi8QJRjAoTOO66ua4
         xm2JSEN8Zl7CqOj8Zaew7VGclSFx11htkkaevWE9SVdIX8TqLzdFGG4D8R1YOehFAW2w
         Ms/kRHJVIOJNHNVoEXq/KJSLXkTU9L3oizexM69i4J+ByNS3IV5v4j4lWt5EE5ShX7Yd
         3j1fPBLzqspzDN3JwQT5f6K+aPJpirvQFRMQVhUC39eH/BRnO2vQoLq0tRioy2KvC/8m
         h8eQ==
X-Gm-Message-State: AOAM530Iv8U0xfpqCnaiIjgdEWEJcZlxHtAm00Lxda6AgzS2CMp7Fih8
        xpIFnlXAgVxP9/1j9L/9YynVZCwJL0GGxH6gkceL+b43EQDmyYL+ewEe/kV+f3EvKETVAPBe5n6
        SUhfXVwFVU6reCeXa
X-Received: by 2002:a62:800d:0:b029:2f0:fe27:2935 with SMTP id j13-20020a62800d0000b02902f0fe272935mr3108394pfd.15.1623900244007;
        Wed, 16 Jun 2021 20:24:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxLsgZLhkeGRgsw9sNEy2BSQC7XLsAdd6KI8S9BIqhLUelD+ESONzXLb6Bkzo6ZqDFo4Y+zFQ==
X-Received: by 2002:a62:800d:0:b029:2f0:fe27:2935 with SMTP id j13-20020a62800d0000b02902f0fe272935mr3108370pfd.15.1623900243689;
        Wed, 16 Jun 2021 20:24:03 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y20sm3880550pfb.207.2021.06.16.20.23.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Jun 2021 20:24:03 -0700 (PDT)
Subject: Re: [PATCH net-next v5 13/15] virtio-net: support AF_XDP zc rx
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org,
        "dust . li" <dust.li@linux.alibaba.com>
References: <20210610082209.91487-1-xuanzhuo@linux.alibaba.com>
 <20210610082209.91487-14-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <d036be55-6d85-f64c-21c5-926403e18ff4@redhat.com>
Date:   Thu, 17 Jun 2021 11:23:52 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210610082209.91487-14-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/6/10 ÏÂÎç4:22, Xuan Zhuo Ð´µÀ:
> Compared to the case of xsk tx, the case of xsk zc rx is more
> complicated.
>
> When we process the buf received by vq, we may encounter ordinary
> buffers, or xsk buffers. What makes the situation more complicated is
> that in the case of mergeable, when num_buffer > 1, we may still
> encounter the case where xsk buffer is mixed with ordinary buffer.
>
> Another thing that makes the situation more complicated is that when we
> get an xsk buffer from vq, the xsk bound to this xsk buffer may have
> been unbound.
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>


This is somehow similar to the case of tx where we don't have per vq reset.

[...]

>   
> -	if (vi->mergeable_rx_bufs)
> +	if (is_xsk_ctx(ctx))
> +		skb = receive_xsk(dev, vi, rq, buf, len, xdp_xmit, stats);
> +	else if (vi->mergeable_rx_bufs)
>   		skb = receive_mergeable(dev, vi, rq, buf, ctx, len, xdp_xmit,
>   					stats);
>   	else if (vi->big_packets)
> @@ -1175,6 +1296,14 @@ static bool try_fill_recv(struct virtnet_info *vi, struct receive_queue *rq,
>   	int err;
>   	bool oom;
>   
> +	/* Because virtio-net does not yet support flow direct,


Note that this is not the case any more. RSS has been supported by 
virtio spec and qemu/vhost/tap now. We just need some work on the 
virtio-net driver part (e.g the ethool interface).

Thanks


