Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B26C31BF51E
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 12:15:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbgD3KP0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 06:15:26 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:49052 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726420AbgD3KPY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 06:15:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588241723;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XFp47qmUIQNvYi/Y/57QAuRfezAWad6iVDDbiawYq80=;
        b=b+KPsKvDlaUwNuimBMQshbnuX/iq+NVsY1exLwwfhH8IhEGo0aGVwhS4amt2loDc/aOb7m
        m62RHdQgyxfXFjS0gs9olDNuQzaq8f+KPl5+PQlaPHuosWXxW3NTjFONM46DohkoPBarCZ
        ItjRO37wfytj6pgWSEp882TCISLdGtI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-16-f054Qw8oOpaks-D2zOHAVw-1; Thu, 30 Apr 2020 06:15:18 -0400
X-MC-Unique: f054Qw8oOpaks-D2zOHAVw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 238DD107ACCA;
        Thu, 30 Apr 2020 10:15:16 +0000 (UTC)
Received: from carbon (unknown [10.40.208.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 42989605DD;
        Thu, 30 Apr 2020 10:15:00 +0000 (UTC)
Date:   Thu, 30 Apr 2020 12:14:58 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     sameehj@amazon.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        zorik@amazon.com, akiyano@amazon.com, gtzalik@amazon.com,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        steffen.klassert@secunet.com, brouer@redhat.com
Subject: Re: [PATCH net-next 21/33] virtio_net: add XDP frame size in two
 code paths
Message-ID: <20200430121458.4659bb53@carbon>
In-Reply-To: <d939445b-9713-2b2f-9830-38c2867bb963@redhat.com>
References: <158757160439.1370371.13213378122947426220.stgit@firesoul>
        <158757174774.1370371.14395462229209766397.stgit@firesoul>
        <3958d9c6-a7d1-6a3d-941d-0a2915cc6b09@redhat.com>
        <20200427163224.6445d4bb@carbon>
        <d939445b-9713-2b2f-9830-38c2867bb963@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 Apr 2020 17:50:11 +0800
Jason Wang <jasowang@redhat.com> wrote:

> We tried to reserve space for vnet header before
> xdp.data_hard_start. But this is useless since the packet could be
> modified by XDP which may invalidate the information stored in the
> header and there's no way for XDP to know the existence of the vnet
> header currently.

I think this is wrong.  We can reserve space for vnet header before
xdp.data_hard_start, and it will be safe and cannot be modified by XDP
as BPF program cannot access data before xdp.data_hard_start.
 
> So let's just not reserve space for vnet header in this case.
> 
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  drivers/net/virtio_net.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 2fe7a3188282..9bdaf2425e6e 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -681,8 +681,8 @@ static struct sk_buff *receive_small(struct net_device *dev,
>  			page = xdp_page;
>  		}
>  
> -		xdp.data_hard_start = buf + VIRTNET_RX_PAD + vi->hdr_len;
> -		xdp.data = xdp.data_hard_start + xdp_headroom;
> +		xdp.data_hard_start = buf + VIRTNET_RX_PAD;
> +		xdp.data = xdp.data_hard_start + xdp_headroom + vi->hdr_len;;

I think this is wrong.  You are exposing the vi header info, which will
be overwritten when code creates an xdp_frame.  I find it very fragile,
as later in the code the vi header info is copied, but only if xdp_prog
is not loaded, so in principle it's okay, but when someone later
figures out that we want to look at this area, we will be in trouble
(and I expect this will be needed when we work towards multi-buffer
XDP).

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

