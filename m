Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50C9C2FAFC9
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 06:03:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387751AbhASFCc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 00:02:32 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31109 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389392AbhASEwI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 23:52:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611031842;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+pWJ5GsR3rIWfGKSFBKQvCj+fn1kzsSBRyszU33k/C0=;
        b=JKxg3P5n4Kg5v91AKrdtItc/2Wr29/5d1lLwdYdrXcOisq66AV1dhumOLhJ3CwdeXqdkzP
        HYSOML7oQrDppC4ym2htgKce9sXS3ld72AVo5sH8MZ2xAA435ntg3piEvWcyLi5AnJkmdl
        YBG5i3C8DW/iHrBVFAa1OkO3TAVZUlo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-63-NUaHJrLCOreuFUI5Xhnylw-1; Mon, 18 Jan 2021 23:50:38 -0500
X-MC-Unique: NUaHJrLCOreuFUI5Xhnylw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 99CFB801817;
        Tue, 19 Jan 2021 04:50:35 +0000 (UTC)
Received: from [10.72.13.139] (ovpn-13-139.pek2.redhat.com [10.72.13.139])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 15FA563657;
        Tue, 19 Jan 2021 04:50:26 +0000 (UTC)
Subject: Re: [PATCH net-next v2 6/7] virtio-net, xsk: implement xsk wakeup
 callback
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>, netdev@vger.kernel.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
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
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
References: <cover.1609837120.git.xuanzhuo@linux.alibaba.com>
 <cover.1610765285.git.xuanzhuo@linux.alibaba.com>
 <2abdfb0b319d4075b68d50d2be9f441b75735e64.1610765285.git.xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <bf06c9a1-60da-0a6f-23a3-2ea86edc0bde@redhat.com>
Date:   Tue, 19 Jan 2021 12:50:25 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <2abdfb0b319d4075b68d50d2be9f441b75735e64.1610765285.git.xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/1/16 上午10:59, Xuan Zhuo wrote:
> Since I did not find an interface to directly notify virtio to generate
> a tx interrupt, I sent some data to trigger a new tx interrupt.
>
> Another advantage of this is that the transmission delay will be
> relatively small, and there is no need to wait for the tx interrupt to
> start softirq.
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---
>   drivers/net/virtio_net.c | 51 ++++++++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 51 insertions(+)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 42aa9ad..e552c2d 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -2841,6 +2841,56 @@ static int virtnet_xsk_run(struct send_queue *sq,
>   	return ret;
>   }
>   
> +static int virtnet_xsk_wakeup(struct net_device *dev, u32 qid, u32 flag)
> +{
> +	struct virtnet_info *vi = netdev_priv(dev);
> +	struct send_queue *sq;
> +	struct xsk_buff_pool *pool;
> +	struct netdev_queue *txq;
> +
> +	if (!netif_running(dev))
> +		return -ENETDOWN;
> +
> +	if (qid >= vi->curr_queue_pairs)
> +		return -EINVAL;
> +
> +	sq = &vi->sq[qid];
> +
> +	rcu_read_lock();
> +
> +	pool = rcu_dereference(sq->xsk.pool);
> +	if (!pool)
> +		goto end;
> +
> +	if (test_and_set_bit(VIRTNET_STATE_XSK_WAKEUP, &sq->xsk.state))
> +		goto end;
> +
> +	txq = netdev_get_tx_queue(dev, qid);
> +
> +	local_bh_disable();
> +	__netif_tx_lock(txq, raw_smp_processor_id());


You can use __netif_tx_lock_bh().

Thanks


> +
> +	/* Send part of the package directly to reduce the delay in sending the
> +	 * package, and this can actively trigger the tx interrupts.
> +	 *
> +	 * If the package is not processed, then continue processing in the
> +	 * subsequent tx interrupt(virtnet_poll_tx).
> +	 *
> +	 * If no packet is sent out, the ring of the device is full. In this
> +	 * case, we will still get a tx interrupt response. Then we will deal
> +	 * with the subsequent packet sending work.
> +	 */
> +
> +	virtnet_xsk_run(sq, pool, xsk_budget);
> +
> +	__netif_tx_unlock(txq);
> +	local_bh_enable();
> +
> +end:
> +	rcu_read_unlock();
> +	return 0;
> +}
> +
>   static int virtnet_get_phys_port_name(struct net_device *dev, char *buf,
>   				      size_t len)
>   {
> @@ -2895,6 +2945,7 @@ static int virtnet_set_features(struct net_device *dev,
>   	.ndo_vlan_rx_kill_vid = virtnet_vlan_rx_kill_vid,
>   	.ndo_bpf		= virtnet_xdp,
>   	.ndo_xdp_xmit		= virtnet_xdp_xmit,
> +	.ndo_xsk_wakeup		= virtnet_xsk_wakeup,
>   	.ndo_features_check	= passthru_features_check,
>   	.ndo_get_phys_port_name	= virtnet_get_phys_port_name,
>   	.ndo_set_features	= virtnet_set_features,

