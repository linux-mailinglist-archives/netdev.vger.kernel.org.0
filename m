Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 461693B3DBD
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 09:41:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230099AbhFYHoO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 03:44:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46459 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230019AbhFYHoM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Jun 2021 03:44:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624606911;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/ha7TjKExrVrQKdn8vLwBPvLm+tch9OjPjqQo8Zysyc=;
        b=Uv8zLo0coLH+ZHtR1Mmh06AEwfOBVwI5MnCbPasHQoJDLae1zy3AmAbDRNpmAti+TmJNK/
        EaD3Wn5DaKi9so9NSCWho6EHfK9C2y2AAJ1JrVih0P9kgn4jcHiNDEoXMwe0mOWQIsympn
        1Q0dLX+Gli/xuq7GBNGSZ4TpRCmtYhs=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-359-YRx-giXoMzWi4aDrSe4qgA-1; Fri, 25 Jun 2021 03:41:49 -0400
X-MC-Unique: YRx-giXoMzWi4aDrSe4qgA-1
Received: by mail-pj1-f71.google.com with SMTP id gp23-20020a17090adf17b029016f3623a819so5084690pjb.5
        for <netdev@vger.kernel.org>; Fri, 25 Jun 2021 00:41:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=/ha7TjKExrVrQKdn8vLwBPvLm+tch9OjPjqQo8Zysyc=;
        b=q2Ori17tq+hnRKcjsD3JO4/6+QS0Ny28WoYhFSKMOC+jHSRfzof658NLPGtWP15u5c
         Xl/YexVgXOfFeFbwGZ6fFPPbKl06bqg6F3i/5adKXVRig93VKkMTv6n/nHm/4fhmcXYa
         XYG96u3yeIFnukwjK0rfUpFgiS6fymdhEGLN02e7VeyqJQuiRXm0AvcWMBC4GfsxfDLZ
         JRzGo24wwFrJPVAvTNfybJ4cawnXDeb+Mu0mEVVdTNYm8LOL+kEvPz7Af1dcD/4r5VS1
         HxXpEaCW6HzOqz79PsAFozjXPSxEOUn2gn4pZoB4r65WHXSb3Fj7Dkw7pKur14Hm7KdZ
         PASw==
X-Gm-Message-State: AOAM530BJVd8xyCkvdN4KsVEja8PBYy6gf9K7NBnjHNShlsgZRkZE7Ng
        +0adcpC42i0HXnpr7HW0R0KdCUIKNuW50C+LqbSMuHjjVlM8tX7T8a9A7HZRYV+Z2WgVEIEe4SN
        jYNoDlpatLZ4nXg8f
X-Received: by 2002:a17:90b:23c5:: with SMTP id md5mr9869974pjb.93.1624606908617;
        Fri, 25 Jun 2021 00:41:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzjLHnPZpHoWmkqQQX6SU4qUbz6NIRfXHOkD8hVKqNcd+7NC9mqpMJgkTH9RajEYqVXlxWUVg==
X-Received: by 2002:a17:90b:23c5:: with SMTP id md5mr9869956pjb.93.1624606908325;
        Fri, 25 Jun 2021 00:41:48 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id w11sm4430797pgp.60.2021.06.25.00.41.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Jun 2021 00:41:47 -0700 (PDT)
Subject: Re: [PATCH v3 4/5] net: tun: fix tun_xdp_one() for IFF_TUN mode
To:     David Woodhouse <dwmw2@infradead.org>, netdev@vger.kernel.org
Cc:     =?UTF-8?Q?Eugenio_P=c3=a9rez?= <eperezma@redhat.com>,
        Willem de Bruijn <willemb@google.com>
References: <03ee62602dd7b7101f78e0802249a6e2e4c10b7f.camel@infradead.org>
 <20210624123005.1301761-1-dwmw2@infradead.org>
 <20210624123005.1301761-4-dwmw2@infradead.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <be6ec48e-ffc7-749b-f775-a34d376f474c@redhat.com>
Date:   Fri, 25 Jun 2021 15:41:27 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210624123005.1301761-4-dwmw2@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/6/24 下午8:30, David Woodhouse 写道:
> From: David Woodhouse <dwmw@amazon.co.uk>
>
> In tun_get_user(), skb->protocol is either taken from the tun_pi header
> or inferred from the first byte of the packet in IFF_TUN mode, while
> eth_type_trans() is called only in the IFF_TAP mode where the payload
> is expected to be an Ethernet frame.
>
> The equivalent code path in tun_xdp_one() was unconditionally using
> eth_type_trans(), which is the wrong thing to do in IFF_TUN mode and
> corrupts packets.
>
> Pull the logic out to a separate tun_skb_set_protocol() function, and
> call it from both tun_get_user() and tun_xdp_one().
>
> XX: It is not entirely clear to me why it's OK to call eth_type_trans()
> in some cases without first checking that enough of the Ethernet header
> is linearly present by calling pskb_may_pull().


Looks like a bug.


>   Such a check was never
> present in the tun_xdp_one() code path, and commit 96aa1b22bd6bb ("tun:
> correct header offsets in napi frags mode") deliberately added it *only*
> for the IFF_NAPI_FRAGS mode.


We had already checked this in tun_get_user() before:

         if ((tun->flags & TUN_TYPE_MASK) == IFF_TAP) {
                 align += NET_IP_ALIGN;
                 if (unlikely(len < ETH_HLEN ||
                              (gso.hdr_len && tun16_to_cpu(tun, 
gso.hdr_len) < ETH_HLEN)))
                         return -EINVAL;
         }


>
> I would like to see specific explanations of *why* it's ever valid and
> necessary (is it so much faster?) to skip the pskb_may_pull() by setting
> the 'no_pull_check' flag to tun_skb_set_protocol(), but for now I'll
> settle for faithfully preserving the existing behaviour and pretending
> it's someone else's problem.
>
> Cc: Willem de Bruijn <willemb@google.com>
> Fixes: 043d222f93ab ("tuntap: accept an array of XDP buffs through sendmsg()")
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>


Thanks


> ---
>   drivers/net/tun.c | 95 +++++++++++++++++++++++++++++++----------------
>   1 file changed, 63 insertions(+), 32 deletions(-)
>
> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index 1b553f79adb0..9379fa86fae9 100644
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -1641,6 +1641,47 @@ static struct sk_buff *tun_build_skb(struct tun_struct *tun,
>   	return NULL;
>   }
>   
> +static int tun_skb_set_protocol(struct tun_struct *tun, struct sk_buff *skb,
> +				__be16 pi_proto, bool no_pull_check)
> +{
> +	switch (tun->flags & TUN_TYPE_MASK) {
> +	case IFF_TUN:
> +		if (tun->flags & IFF_NO_PI) {
> +			u8 ip_version = skb->len ? (skb->data[0] >> 4) : 0;
> +
> +			switch (ip_version) {
> +			case 4:
> +				pi_proto = htons(ETH_P_IP);
> +				break;
> +			case 6:
> +				pi_proto = htons(ETH_P_IPV6);
> +				break;
> +			default:
> +				return -EINVAL;
> +			}
> +		}
> +
> +		skb_reset_mac_header(skb);
> +		skb->protocol = pi_proto;
> +		skb->dev = tun->dev;
> +		break;
> +	case IFF_TAP:
> +		/* As an optimisation, no_pull_check can be set in the cases
> +		 * where the caller *knows* that eth_type_trans() will be OK
> +		 * because the Ethernet header is linearised at skb->data.
> +		 *
> +		 * XX: Or so I was reliably assured when I moved this code
> +		 * and didn't make it unconditional. dwmw2.
> +		 */
> +		if (!no_pull_check && !pskb_may_pull(skb, ETH_HLEN))
> +			return -ENOMEM;
> +
> +		skb->protocol = eth_type_trans(skb, tun->dev);
> +		break;
> +	}
> +	return 0;
> +}
> +
>   /* Get packet from user space buffer */
>   static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
>   			    void *msg_control, struct iov_iter *from,
> @@ -1784,37 +1825,9 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
>   		return -EINVAL;
>   	}
>   
> -	switch (tun->flags & TUN_TYPE_MASK) {
> -	case IFF_TUN:
> -		if (tun->flags & IFF_NO_PI) {
> -			u8 ip_version = skb->len ? (skb->data[0] >> 4) : 0;
> -
> -			switch (ip_version) {
> -			case 4:
> -				pi.proto = htons(ETH_P_IP);
> -				break;
> -			case 6:
> -				pi.proto = htons(ETH_P_IPV6);
> -				break;
> -			default:
> -				atomic_long_inc(&tun->dev->rx_dropped);
> -				kfree_skb(skb);
> -				return -EINVAL;
> -			}
> -		}
> -
> -		skb_reset_mac_header(skb);
> -		skb->protocol = pi.proto;
> -		skb->dev = tun->dev;
> -		break;
> -	case IFF_TAP:
> -		if (frags && !pskb_may_pull(skb, ETH_HLEN)) {
> -			err = -ENOMEM;
> -			goto drop;
> -		}
> -		skb->protocol = eth_type_trans(skb, tun->dev);
> -		break;
> -	}
> +	err = tun_skb_set_protocol(tun, skb, pi.proto, !frags);
> +	if (err)
> +		goto drop;
>   
>   	/* copy skb_ubuf_info for callback when skb has no error */
>   	if (zerocopy) {
> @@ -2335,12 +2348,24 @@ static int tun_xdp_one(struct tun_struct *tun,
>   	struct virtio_net_hdr *gso = NULL;
>   	struct bpf_prog *xdp_prog;
>   	struct sk_buff *skb = NULL;
> +	__be16 proto = 0;
>   	u32 rxhash = 0, act;
>   	int buflen = hdr->buflen;
>   	int err = 0;
>   	bool skb_xdp = false;
>   	struct page *page;
>   
> +	if (!(tun->flags & IFF_NO_PI)) {
> +		struct tun_pi *pi = tun_hdr;
> +		tun_hdr += sizeof(*pi);
> +
> +		if (tun_hdr > xdp->data) {
> +			atomic_long_inc(&tun->rx_frame_errors);
> +			return -EINVAL;
> +		}
> +		proto = pi->proto;
> +	}


As replied in patch 2, I think it's better to make XDP path work only 
for TAP but not TUN.

Then the series would be much simpler.

Thanks


> +
>   	if (tun->flags & IFF_VNET_HDR) {
>   		gso = tun_hdr;
>   		tun_hdr += sizeof(*gso);
> @@ -2413,7 +2438,13 @@ static int tun_xdp_one(struct tun_struct *tun,
>   		goto out;
>   	}
>   
> -	skb->protocol = eth_type_trans(skb, tun->dev);
> +	err = tun_skb_set_protocol(tun, skb, proto, true);
> +	if (err) {
> +		atomic_long_inc(&tun->dev->rx_dropped);
> +		kfree_skb(skb);
> +		goto out;
> +	}
> +
>   	skb_reset_network_header(skb);
>   	skb_probe_transport_header(skb);
>   	skb_record_rx_queue(skb, tfile->queue_index);

