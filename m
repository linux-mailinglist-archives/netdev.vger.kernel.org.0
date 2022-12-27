Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69FFF65677F
	for <lists+netdev@lfdr.de>; Tue, 27 Dec 2022 07:31:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbiL0GbO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Dec 2022 01:31:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiL0GbM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Dec 2022 01:31:12 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D4E8E37
        for <netdev@vger.kernel.org>; Mon, 26 Dec 2022 22:30:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672122627;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Qc5Wpn8Yna8TiyVEifGU6eJKuOo4jmiPUeXEpNoa60I=;
        b=Ax8nSKN7n7A8G+005iOopT6HTAeykHaYY6spHh3iTqdhRg/UiS2nXkx9ju+3b6YmtUyESH
        5nNTtQ/zxaQt3+B/4C+vXSyeNPAC810M7E4HNh+OQqDdM2QRNzHq2DVXQyUXvbe0PYK3xG
        FI7u7l9voq9fqoZlof3wp5VGY1mrTxI=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-481-eoHXW13xOgq17COIJyLZ_w-1; Tue, 27 Dec 2022 01:30:20 -0500
X-MC-Unique: eoHXW13xOgq17COIJyLZ_w-1
Received: by mail-pj1-f70.google.com with SMTP id k2-20020a17090a514200b002198214abdcso5257498pjm.8
        for <netdev@vger.kernel.org>; Mon, 26 Dec 2022 22:30:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Qc5Wpn8Yna8TiyVEifGU6eJKuOo4jmiPUeXEpNoa60I=;
        b=suhfxq2+DFigCPQUkCDFNpS5l8T9dJmyYJp8n0OpsO8LtJ2wFcfUs6g1W52wKwZd8K
         lsibaTHBbhB74c3U+orax98S/fryhp/cgITjM6OVEJBZPIHW6KAC9yBtsefrRZ9J7GIL
         8oREeIr4K5N2xnGYBifxe9JA6+uPtqqxotzhX2Bi4kheB8TZltQORv1LYPHhF0uNxeW1
         kY/qsc9OQvUntvwfMWn77t+m14ADtaGTCs6n248tQ73TV0wz+yInaMnDF8PCtEhPfHLe
         l9Njz4zrmD7q8nSdnXBH9K0xfdKODcrwz9dXEFufttH3sTVE7P2coq/XKw32EJk4iLwv
         Of3w==
X-Gm-Message-State: AFqh2krU3o833NbbQrNMeRais3FoKVG+weMFG8DnqHL3qLggqWnc2P9l
        j7XW+wMHki6sHk6NlmwMg5Lc4MDhm/C77w0ZKdudl7hp3D1tmWE0m6SK0pYOku121g1wyzhH2bV
        K1Y+yyQ8Zt32LzIBQ
X-Received: by 2002:a05:6a20:659d:b0:b0:275d:3036 with SMTP id p29-20020a056a20659d00b000b0275d3036mr25380627pzh.24.1672122619123;
        Mon, 26 Dec 2022 22:30:19 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvb7dxQymAEXYNINm9hRhsnXhATEDm8IA0GGM3QQlux5wp9WA2nHh01zvPc0v1335MPOWP2hA==
X-Received: by 2002:a05:6a20:659d:b0:b0:275d:3036 with SMTP id p29-20020a056a20659d00b000b0275d3036mr25380610pzh.24.1672122618892;
        Mon, 26 Dec 2022 22:30:18 -0800 (PST)
Received: from [10.72.13.143] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id k195-20020a633dcc000000b00478e14e6e76sm7189490pga.32.2022.12.26.22.30.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Dec 2022 22:30:17 -0800 (PST)
Message-ID: <8d81ab3b-c10b-1a46-3ae1-b87228dbeb4e@redhat.com>
Date:   Tue, 27 Dec 2022 14:30:10 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH v2 1/9] virtio_net: disable the hole mechanism for xdp
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
 <20221220141449.115918-2-hengqi@linux.alibaba.com>
Content-Language: en-US
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20221220141449.115918-2-hengqi@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/12/20 22:14, Heng Qi 写道:
> XDP core assumes that the frame_size of xdp_buff and the length of
> the frag are PAGE_SIZE. The hole may cause the processing of xdp to
> fail, so we disable the hole mechanism when xdp is set.
>
> Signed-off-by: Heng Qi <hengqi@linux.alibaba.com>
> Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---
>   drivers/net/virtio_net.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 9cce7dec7366..443aa7b8f0ad 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -1419,8 +1419,11 @@ static int add_recvbuf_mergeable(struct virtnet_info *vi,
>   		/* To avoid internal fragmentation, if there is very likely not
>   		 * enough space for another buffer, add the remaining space to
>   		 * the current buffer.
> +		 * XDP core assumes that frame_size of xdp_buff and the length
> +		 * of the frag are PAGE_SIZE, so we disable the hole mechanism.
>   		 */
> -		len += hole;
> +		if (!headroom)
> +			len += hole;


Is this only a requirement of multi-buffer XDP? If not, it need to be 
backported to stable.

Thanks


>   		alloc_frag->offset += hole;
>   	}
>   

