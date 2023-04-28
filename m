Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06C516F0FE4
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 03:09:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344428AbjD1BJV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 21:09:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229965AbjD1BJU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 21:09:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44EED19B6
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 18:08:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682644113;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SIlO9U65Fa78/bYD7F0pTgvbn+G5S4dqydIF9IQsHyM=;
        b=UvLRuhRxfD/NvVEGasvTkb7TtOMdtO6zs/jMC0gRyDIJ83uCt8FkWpUDaff9ksbmfMSHm2
        eRGz8yuEG2kYNMUeN65QOd9PClZZb+A2EItx3mhdj+ldux9UJFFhrs4gie8sRwIfcWSYr8
        19ShTY5p14OFhkz8cMppSCTonCgWhL4=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-100-i3h9GjkVMo6aprMk-iW4GA-1; Thu, 27 Apr 2023 21:08:31 -0400
X-MC-Unique: i3h9GjkVMo6aprMk-iW4GA-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-2f69e5def13so3402665f8f.0
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 18:08:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682644110; x=1685236110;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SIlO9U65Fa78/bYD7F0pTgvbn+G5S4dqydIF9IQsHyM=;
        b=LaskPOh2V8nfp2ffejfP2xHos3fzGAGuyTtr+2Rnw5kpmH/T03E04EYAcdvuHoOdBq
         2/avP/xAAEyNAKg9ExbSeJjWAVl2YesAgNl7jNPaYpxWX5SbVAMmQu+GrUnlADEJaNH/
         V6IBf+4ZrPDC0zq+R/cF01PPbYrUFtkDM5uJb+MmKiStsHBR0mJfoYb9UnL83kEdpSmo
         wIvw/mac+uYBnGbYggSiKKes3lcpics1EIoKkryWJ+Orw8dsuUGjuK/e9BN55PM0Wnn2
         rTtSwouwUgfLSmmiM/BvWRXp0dUdawO1Ouv8cWaqBX17+K2PxrvbnIaHLdyZmWtomDPY
         LMvA==
X-Gm-Message-State: AC+VfDyWZ0C5nV7i2U4WimroBiJdb8HGI2s+kOvs6ibaCxx0BytQQ1hm
        lZ/QW/14EwJHSaRDa2JS9OCwvpNXTdSIpww/GUWkGGiMDMB/pGdtPXjP/Y6phIGvNqoTBXdT1yD
        +pPJY3ld47XLRFx4gh4tvdwX6Gr4=
X-Received: by 2002:a05:6000:12c8:b0:303:a2e4:e652 with SMTP id l8-20020a05600012c800b00303a2e4e652mr2432530wrx.14.1682644110297;
        Thu, 27 Apr 2023 18:08:30 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ43yyZywMx1CB2ADiJh65tjfwD1uFSRC7hVGQKqY+xMXE6kvoExBkKUH0cVOJuari+LUhVLcQ==
X-Received: by 2002:a05:6000:12c8:b0:303:a2e4:e652 with SMTP id l8-20020a05600012c800b00303a2e4e652mr2432520wrx.14.1682644110024;
        Thu, 27 Apr 2023 18:08:30 -0700 (PDT)
Received: from redhat.com ([2.52.19.183])
        by smtp.gmail.com with ESMTPSA id t24-20020a1c7718000000b003f3195be0a0sm3088178wmi.31.2023.04.27.18.08.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Apr 2023 18:08:29 -0700 (PDT)
Date:   Thu, 27 Apr 2023 21:08:25 -0400
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
Subject: Re: [PATCH net-next v4 12/15] virtio_net: small: avoid double
 counting in xdp scenarios
Message-ID: <20230427210802-mutt-send-email-mst@kernel.org>
References: <20230427030534.115066-1-xuanzhuo@linux.alibaba.com>
 <20230427030534.115066-13-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230427030534.115066-13-xuanzhuo@linux.alibaba.com>
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 27, 2023 at 11:05:31AM +0800, Xuan Zhuo wrote:
> Avoid the problem that some variables(headroom and so on) will repeat
> the calculation when process xdp.
> 
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> Acked-by: Jason Wang <jasowang@redhat.com>


this is "code duplication" not "double counting".


> ---
>  drivers/net/virtio_net.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index b8ec642899c9..f832ab8a3e6e 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -1027,11 +1027,10 @@ static struct sk_buff *receive_small(struct net_device *dev,
>  	struct sk_buff *skb;
>  	struct bpf_prog *xdp_prog;
>  	unsigned int xdp_headroom = (unsigned long)ctx;
> -	unsigned int header_offset = VIRTNET_RX_PAD + xdp_headroom;
> -	unsigned int headroom = vi->hdr_len + header_offset;
> -	unsigned int buflen = SKB_DATA_ALIGN(GOOD_PACKET_LEN + headroom) +
> -			      SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
>  	struct page *page = virt_to_head_page(buf);
> +	unsigned int header_offset;
> +	unsigned int headroom;
> +	unsigned int buflen;
>  
>  	len -= vi->hdr_len;
>  	stats->bytes += len;
> @@ -1059,6 +1058,11 @@ static struct sk_buff *receive_small(struct net_device *dev,
>  	rcu_read_unlock();
>  
>  skip_xdp:
> +	header_offset = VIRTNET_RX_PAD + xdp_headroom;
> +	headroom = vi->hdr_len + header_offset;
> +	buflen = SKB_DATA_ALIGN(GOOD_PACKET_LEN + headroom) +
> +		SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
> +
>  	skb = build_skb(buf, buflen);
>  	if (!skb)
>  		goto err;
> -- 
> 2.32.0.3.g01195cf9f

