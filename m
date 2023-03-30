Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEBD26D0225
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 12:51:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229988AbjC3Ku5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 06:50:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231287AbjC3Kue (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 06:50:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40D058A46
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 03:48:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680173308;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TIDod7ZXofypu7NUVBtHJ0EV23P25HL2cdjDfrBqZcY=;
        b=EEGX9ygGl2/KM2idIK/zK1yLxa/XlNdgT2RdXsHKMzJj/l3mGRUEM3z8HtfV/RJDHV5edO
        USKY024T5geePx2ldqw0FYT8gA9QTRvs9gsGOIjnEfbF2A6Zc9ZOKHkbqvg9ceX/KGQLid
        E7Dh2qW3epa9kE8F3hp16o2dISe1aCc=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-260-qq0uigCxNZutEr_ci040Fg-1; Thu, 30 Mar 2023 06:48:27 -0400
X-MC-Unique: qq0uigCxNZutEr_ci040Fg-1
Received: by mail-qv1-f70.google.com with SMTP id r4-20020ad44044000000b005ad0ce58902so7969209qvp.5
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 03:48:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680173306; x=1682765306;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TIDod7ZXofypu7NUVBtHJ0EV23P25HL2cdjDfrBqZcY=;
        b=vipambic1Mdqsc6WI4jrnNv1ecH0GsbjcRVssCO2Os3Y2BlJlZJmOqOAg7bMKAEDU1
         w+E8f2MinQDEtYdsNKGy96cMo8W8P/IsXwr5+LcXtKYBm4GTyQp4r6+epULJv60MvIxk
         SRLye0Sw++dgsqUzNWARs+PbXjH50WRuCT9t+BrbtHBUp55Ean269D3M0BBBxSxLe4po
         LibcG0HqkFE0rQFkyI/Ew8SxR7K9iY0tRLnfq7kcU5cHR45xHllanjmryX4ngac2ljXb
         YjpT98pLwem9vOWfUM45eKohNth14jifb9Ro7g7iBQo6iT/8mGhqATkN+olZdWCOOkhU
         AeTA==
X-Gm-Message-State: AAQBX9dKlIRM5Z7Qgr6W4Fp1JVfJCAzWKDIkoMql2T5JBvVNVhq+hVUF
        5OYHYKpd4IBtXlFKXs15QLyiPhVozkyjUFTl3d8sbPxiM0SERNdxJz9NcZ13kavlJQthHWhXYnw
        vTMvOJI406BG5u+7+
X-Received: by 2002:a05:6214:4005:b0:5ab:af50:eb45 with SMTP id kd5-20020a056214400500b005abaf50eb45mr34992155qvb.3.1680173306621;
        Thu, 30 Mar 2023 03:48:26 -0700 (PDT)
X-Google-Smtp-Source: AKy350YDY67tBy0o9RQ5k6yj5iqQLAx/6owd7X3mSyyUGV6oV18zIIWEsjIBgDH+/vr4WGfXsj8SYQ==
X-Received: by 2002:a05:6214:4005:b0:5ab:af50:eb45 with SMTP id kd5-20020a056214400500b005abaf50eb45mr34992135qvb.3.1680173306396;
        Thu, 30 Mar 2023 03:48:26 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-228-125.dyn.eolo.it. [146.241.228.125])
        by smtp.gmail.com with ESMTPSA id l2-20020a0cee22000000b005dd8b9345d4sm5231323qvs.108.2023.03.30.03.48.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Mar 2023 03:48:26 -0700 (PDT)
Message-ID: <343825bad568ec0a21c283f876585585b040da9f.camel@redhat.com>
Subject: Re: [PATCH net-next 8/8] virtio_net: introduce receive_small_xdp()
From:   Paolo Abeni <pabeni@redhat.com>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>, netdev@vger.kernel.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
Date:   Thu, 30 Mar 2023 12:48:22 +0200
In-Reply-To: <20230328120412.110114-9-xuanzhuo@linux.alibaba.com>
References: <20230328120412.110114-1-xuanzhuo@linux.alibaba.com>
         <20230328120412.110114-9-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2023-03-28 at 20:04 +0800, Xuan Zhuo wrote:
> @@ -949,15 +1042,11 @@ static struct sk_buff *receive_small(struct net_de=
vice *dev,
>  {
>  	struct sk_buff *skb;
>  	struct bpf_prog *xdp_prog;
> -	unsigned int xdp_headroom =3D (unsigned long)ctx;
> -	unsigned int header_offset =3D VIRTNET_RX_PAD + xdp_headroom;
> +	unsigned int header_offset =3D VIRTNET_RX_PAD;
>  	unsigned int headroom =3D vi->hdr_len + header_offset;

This changes (reduces) the headroom for non-xpd-pass skbs.

[...]
> +	buf +=3D header_offset;
> +	memcpy(skb_vnet_hdr(skb), buf, vi->hdr_len);

AFAICS, that also means that receive_small(), for such packets, will
look for the virtio header in a different location. Is that expected?

Thanks.

Paolo

