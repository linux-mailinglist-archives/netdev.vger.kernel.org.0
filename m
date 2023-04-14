Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DAB26E1D61
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 09:39:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbjDNHje (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 03:39:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjDNHjd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 03:39:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E37310E
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 00:38:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681457926;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lMIqjynha0lnhe23OoFWtNYm7T0bO0fGReoRZ9IdJV8=;
        b=dYFTMh2D4vUohX36JRWJWQV5sS8UfrDxr5I90LB9s1h0JE+oyMi5doYFAa/GYcFXL7YB20
        7PuY2AlBPBVIC665Am6hQee9OCQCI2rIA4qv3INfNd2P86MvYCxjHAySjHZglLnQCJ8YUY
        numijLxpDIANPJ9Jyo/8St6QPZUSeFY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-519-aXgoYOFnOkCQpG1RKBsKJw-1; Fri, 14 Apr 2023 03:38:42 -0400
X-MC-Unique: aXgoYOFnOkCQpG1RKBsKJw-1
Received: by mail-wm1-f69.google.com with SMTP id q19-20020a05600c46d300b003ef69894934so7126406wmo.6
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 00:38:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681457921; x=1684049921;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lMIqjynha0lnhe23OoFWtNYm7T0bO0fGReoRZ9IdJV8=;
        b=gcshA1jxTMxM6AqTG5sVFcwA4ktI1x2LVCcPlJc118o6XU4keV+WKfNVbDKB2MP3da
         QXWZyEPROe+i2Lejv7DNhBi/uaI1YTn7a02wYLn3G7rRkQEmpdtWetKSXPG4Yx4NvRoI
         ui29tLzoRS/YSpJVViPlIEI4XdPbKn5aSqH1k3Vkpv1Gt0CrYgrWrS8ccCD/2tYGgRcI
         Of7P8VLQwaGwYhXSbb6x5WJJuFEuaFYev505xdPQs9l8isET9JuRXV0ddCDSj/lcBfiG
         86atk/VK+BQcx0ttW9Ws/BxW8iyLypVnBen02rTp11LNv0WzD1RD6/X5VHq1e2cNcM9J
         cmMw==
X-Gm-Message-State: AAQBX9c8LVDyUZiB2ibawXKtPSi1JQvuzngHqqPC8oizrRNnQnHaCPCG
        WF8fm5DdHS8Uuxu+qJ5fkibCXLx2kOGqe2ZtGj90dh0Z4Wo85RFEUX+09WsmShxTFcjsAqKkosk
        4ZhTlikTsc0rXzYXsfLVCzVdY
X-Received: by 2002:a5d:688b:0:b0:2ef:ba74:663 with SMTP id h11-20020a5d688b000000b002efba740663mr3600345wru.27.1681457921244;
        Fri, 14 Apr 2023 00:38:41 -0700 (PDT)
X-Google-Smtp-Source: AKy350bKnQLs9BRa6pmx717Y3ZbnYozswFnfUPMxvV8w2vmX/ki/yiZdrxC+QHPU+hLN+NERHNjBdQ==
X-Received: by 2002:a5d:688b:0:b0:2ef:ba74:663 with SMTP id h11-20020a5d688b000000b002efba740663mr3600321wru.27.1681457920950;
        Fri, 14 Apr 2023 00:38:40 -0700 (PDT)
Received: from redhat.com ([2a06:c701:742d:fd00:c847:221d:9254:f7ce])
        by smtp.gmail.com with ESMTPSA id h4-20020a1ccc04000000b003f071466229sm3600005wmb.17.2023.04.14.00.38.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Apr 2023 00:38:40 -0700 (PDT)
Date:   Fri, 14 Apr 2023 03:38:37 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
Subject: Re: [PATCH net v1] virtio_net: bugfix overflow inside
 xdp_linearize_page()
Message-ID: <20230414033826-mutt-send-email-mst@kernel.org>
References: <20230414060835.74975-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230414060835.74975-1-xuanzhuo@linux.alibaba.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 14, 2023 at 02:08:35PM +0800, Xuan Zhuo wrote:
> Here we copy the data from the original buf to the new page. But we
> not check that it may be overflow.
> 
> As long as the size received(including vnethdr) is greater than 3840
> (PAGE_SIZE -VIRTIO_XDP_HEADROOM). Then the memcpy will overflow.
> 
> And this is completely possible, as long as the MTU is large, such
> as 4096. In our test environment, this will cause crash. Since crash is
> caused by the written memory, it is meaningless, so I do not include it.
> 
> Fixes: 72979a6c3590 ("virtio_net: xdp, add slowpath case for non contiguous buffers")
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> Acked-by: Jason Wang <jasowang@redhat.com>

Acked-by: Michael S. Tsirkin <mst@redhat.com>

> ---
> v1:  add Fixes tag
> 
>  drivers/net/virtio_net.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 2396c28c0122..ea1bd4bb326d 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -814,8 +814,13 @@ static struct page *xdp_linearize_page(struct receive_queue *rq,
>  				       int page_off,
>  				       unsigned int *len)
>  {
> -	struct page *page = alloc_page(GFP_ATOMIC);
> +	int tailroom = SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
> +	struct page *page;
> +
> +	if (page_off + *len + tailroom > PAGE_SIZE)
> +		return NULL;
> 
> +	page = alloc_page(GFP_ATOMIC);
>  	if (!page)
>  		return NULL;
> 
> @@ -823,7 +828,6 @@ static struct page *xdp_linearize_page(struct receive_queue *rq,
>  	page_off += *len;
> 
>  	while (--*num_buf) {
> -		int tailroom = SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
>  		unsigned int buflen;
>  		void *buf;
>  		int off;
> --
> 2.32.0.3.g01195cf9f

