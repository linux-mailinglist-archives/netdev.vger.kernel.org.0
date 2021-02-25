Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6889032544D
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 18:04:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234135AbhBYRE3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 12:04:29 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53070 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234003AbhBYRDR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Feb 2021 12:03:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614272510;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uvbKIoohXeRyXpBeKhyai4J6wvMoBTGi1G+ws1L6YJc=;
        b=aPaphRiReDG9ZjDYaMsRJCzuq9XOPY23Sqo+xsUF5gGByOZhzsa/TDt+51GtUJEKjFCCuX
        vK9rWU6gICVPw1If55xmEM1BpyxVndyCWqPoFCFpik0rsuhfciAs19X3Ri5+3O8MJX7OMN
        NF19b7ofb1ML4/0FcvTZOdeL8D6Kedw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-23-o4W_CKBAML-6ShrSM9NAlQ-1; Thu, 25 Feb 2021 12:01:33 -0500
X-MC-Unique: o4W_CKBAML-6ShrSM9NAlQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7CE98814303;
        Thu, 25 Feb 2021 17:01:31 +0000 (UTC)
Received: from carbon (unknown [10.36.110.51])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AF3795C266;
        Thu, 25 Feb 2021 17:01:21 +0000 (UTC)
Date:   Thu, 25 Feb 2021 18:01:20 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     brouer@redhat.com, netdev@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org,
        Marek Majtyka <alardam@gmail.com>
Subject: Re: [PATCH v2 net-next] virtio-net: support XDP_TX when not more
 queues
Message-ID: <20210225180120.09e8845a@carbon>
In-Reply-To: <1614241349-77324-1-git-send-email-xuanzhuo@linux.alibaba.com>
References: <1614241349-77324-1-git-send-email-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 25 Feb 2021 16:22:29 +0800
Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote:

> The number of queues implemented by many virtio backends is limited,
> especially some machines have a large number of CPUs. In this case, it
> is often impossible to allocate a separate queue for XDP_TX.
> 
> This patch allows XDP_TX to run by reuse the existing SQ with
> __netif_tx_lock() hold when there are not enough queues.
> 
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
> ---
>  drivers/net/virtio_net.c | 48 ++++++++++++++++++++++++++++++++++++------------
>  1 file changed, 36 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
[...]
> @@ -2416,12 +2441,8 @@ static int virtnet_xdp_set(struct net_device *dev, struct bpf_prog *prog,
>  		xdp_qp = nr_cpu_ids;
>  
>  	/* XDP requires extra queues for XDP_TX */
> -	if (curr_qp + xdp_qp > vi->max_queue_pairs) {
> -		NL_SET_ERR_MSG_MOD(extack, "Too few free TX rings available");
> -		netdev_warn(dev, "request %i queues but max is %i\n",
> -			    curr_qp + xdp_qp, vi->max_queue_pairs);
> -		return -ENOMEM;
> -	}
> +	if (curr_qp + xdp_qp > vi->max_queue_pairs)
> +		xdp_qp = 0;

I think we should keep a netdev_warn message, but as a warning (not
error) that this will cause XDP_TX and XDP_REDIRECT to be slower on
this device due to too few free TX rings available.

In the future, we can mark a XDP features flag that this device is
operating in a slower "locked" Tx mode.

>  
>  	old_prog = rtnl_dereference(vi->rq[0].xdp_prog);
>  	if (!prog && !old_prog)



-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

