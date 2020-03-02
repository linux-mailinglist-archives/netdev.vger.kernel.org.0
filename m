Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F446175222
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 04:28:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726758AbgCBD2g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Mar 2020 22:28:36 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:53922 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726720AbgCBD2g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Mar 2020 22:28:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583119714;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7r00IH8QbmWhaSoPdhRwg5OGHbOwcEm8ZL85UsBsOw4=;
        b=UAhnboinboByTmEab2RL5a5vVelGdY+ls51L1i6/e0CT+2W3VxcbsKBRGvdVJ4aANOjFwu
        V9kzd391VD8PCV7IYloELcgd9YKBIEqNDp+DM4AAdbYwvjgk3NRe2y6ziMLT13OEFVscXW
        xNebN+f9eXL3/N9sm9dZM4+GAHsvZoE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-416-ing7ewgFP0yYWnrXuGxotg-1; Sun, 01 Mar 2020 22:28:31 -0500
X-MC-Unique: ing7ewgFP0yYWnrXuGxotg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CE27C100550E;
        Mon,  2 Mar 2020 03:28:28 +0000 (UTC)
Received: from [10.72.13.131] (ovpn-13-131.pek2.redhat.com [10.72.13.131])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DC8C89CA3;
        Mon,  2 Mar 2020 03:28:14 +0000 (UTC)
Subject: Re: [PATCH RFC v4 bpf-next 08/11] tun: Support xdp in the Tx path for
 skb
To:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, brouer@redhat.com, toke@redhat.com,
        mst@redhat.com, toshiaki.makita1@gmail.com, daniel@iogearbox.net,
        john.fastabend@gmail.com, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com, David Ahern <dahern@digitalocean.com>
References: <20200227032013.12385-1-dsahern@kernel.org>
 <20200227032013.12385-9-dsahern@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <0dc6768e-b8fa-f0b3-3c58-5135640f114a@redhat.com>
Date:   Mon, 2 Mar 2020 11:28:13 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200227032013.12385-9-dsahern@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/2/27 =E4=B8=8A=E5=8D=8811:20, David Ahern wrote:
> From: David Ahern <dahern@digitalocean.com>
>
> Add support to run Tx path program on packets arriving at a tun
> device as an skb.
>
> XDP_TX return code means move the packet to the Tx path of the device.
> For a program run in the Tx / egress path, XDP_TX is essentially the
> same as "continue on" which is XDP_PASS.
>
> Conceptually, XDP_REDIRECT for this path can work the same as it
> does for the Rx path, but that return code is left for a follow
> on series.
>
> Signed-off-by: Prashant Bhole <prashantbhole.linux@gmail.com>
> Signed-off-by: David Ahern <dahern@digitalocean.com>
> ---
>   drivers/net/tun.c | 69 ++++++++++++++++++++++++++++++++++++++++++++--=
-
>   1 file changed, 66 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index 6aae398b904b..dcae6521a39d 100644
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -1059,6 +1059,63 @@ static unsigned int run_ebpf_filter(struct tun_s=
truct *tun,
>   	return len;
>   }
>  =20
> +static struct sk_buff *tun_prepare_xdp_skb(struct sk_buff *skb)
> +{
> +	if (skb_shared(skb) || skb_cloned(skb)) {
> +		struct sk_buff *nskb;
> +
> +		nskb =3D skb_copy(skb, GFP_ATOMIC);
> +		consume_skb(skb);
> +		return nskb;
> +	}
> +
> +	return skb;
> +}
> +
> +static u32 tun_do_xdp_tx_generic(struct tun_struct *tun,
> +				 struct net_device *dev,
> +				 struct sk_buff *skb)
> +{
> +	struct bpf_prog *xdp_prog;
> +	u32 act =3D XDP_PASS;
> +
> +	xdp_prog =3D rcu_dereference(tun->xdp_egress_prog);
> +	if (xdp_prog) {
> +		struct xdp_txq_info txq =3D { .dev =3D dev };
> +		struct xdp_buff xdp;
> +
> +		skb =3D tun_prepare_xdp_skb(skb);
> +		if (!skb) {
> +			act =3D XDP_DROP;
> +			goto out;
> +		}
> +
> +		xdp.txq =3D &txq;
> +
> +		act =3D do_xdp_generic_core(skb, &xdp, xdp_prog);
> +		switch (act) {
> +		case XDP_TX:    /* for Tx path, XDP_TX =3D=3D XDP_PASS */
> +			act =3D XDP_PASS;
> +			break;


Jute a note here, I agree for TX XDP it may be better to do this.

But for offloaded program we need different semantic. Or we can deal=20
this with attach types?

Thanks


> +		case XDP_PASS:
> +			break;
> +		case XDP_REDIRECT:
> +			/* fall through */
> +		default:
> +			bpf_warn_invalid_xdp_action(act);
> +			/* fall through */
> +		case XDP_ABORTED:
> +			trace_xdp_exception(tun->dev, xdp_prog, act);
> +			/* fall through */
> +		case XDP_DROP:
> +			break;
> +		}
> +	}
> +
> +out:
> +	return act;
> +}
> +
>   /* Net device start xmit */
>   static netdev_tx_t tun_net_xmit(struct sk_buff *skb, struct net_devic=
e *dev)
>   {
> @@ -1066,6 +1123,7 @@ static netdev_tx_t tun_net_xmit(struct sk_buff *s=
kb, struct net_device *dev)
>   	int txq =3D skb->queue_mapping;
>   	struct tun_file *tfile;
>   	int len =3D skb->len;
> +	u32 act;
>  =20
>   	rcu_read_lock();
>   	tfile =3D rcu_dereference(tun->tfiles[txq]);
> @@ -1107,9 +1165,13 @@ static netdev_tx_t tun_net_xmit(struct sk_buff *=
skb, struct net_device *dev)
>  =20
>   	nf_reset_ct(skb);
>  =20
> -	if (ptr_ring_produce(&tfile->tx_ring, skb))
> +	act =3D tun_do_xdp_tx_generic(tun, dev, skb);
> +	if (act !=3D XDP_PASS)
>   		goto drop;
>  =20
> +	if (ptr_ring_produce(&tfile->tx_ring, skb))
> +		goto err_out;
> +
>   	/* Notify and wake up reader process */
>   	if (tfile->flags & TUN_FASYNC)
>   		kill_fasync(&tfile->fasync, SIGIO, POLL_IN);
> @@ -1118,10 +1180,11 @@ static netdev_tx_t tun_net_xmit(struct sk_buff =
*skb, struct net_device *dev)
>   	rcu_read_unlock();
>   	return NETDEV_TX_OK;
>  =20
> -drop:
> -	this_cpu_inc(tun->pcpu_stats->tx_dropped);
> +err_out:
>   	skb_tx_error(skb);
>   	kfree_skb(skb);
> +drop:
> +	this_cpu_inc(tun->pcpu_stats->tx_dropped);
>   	rcu_read_unlock();
>   	return NET_XMIT_DROP;
>   }

