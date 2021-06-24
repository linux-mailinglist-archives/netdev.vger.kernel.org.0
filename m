Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 454703B2755
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 08:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231167AbhFXGUu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 02:20:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59271 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230397AbhFXGUt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 02:20:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624515510;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=00uMR65X9z5B4ChXWbYOEc5c3pHvBS/t1Ho+CTLzgs8=;
        b=NWiDAA5OmuUnlRZm6iSjZdA9SzNQLJtqeT1wSabOp2NSWya1AtgUHkpueSjbXO7B7QaMEd
        TaKVds5XG0zG5vbyoNiMeSni7Qf8LvzoSlNJhGktmBIfIhMMGCx0VkcUwxB5p8nH/oUClv
        sQE7u5/iuL1XhI5FbpZRWXKENabA1cg=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-109-70JjB3o0NVakr8NSzRASdA-1; Thu, 24 Jun 2021 02:18:28 -0400
X-MC-Unique: 70JjB3o0NVakr8NSzRASdA-1
Received: by mail-pl1-f199.google.com with SMTP id j6-20020a170902da86b029012092e5da71so1787745plx.15
        for <netdev@vger.kernel.org>; Wed, 23 Jun 2021 23:18:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=00uMR65X9z5B4ChXWbYOEc5c3pHvBS/t1Ho+CTLzgs8=;
        b=JQ01bOdsk7fgN4IjkUJnvc4WnMPZixcxpc9skw0AMp/rTkRBAumNPOa5Jf0IIa2iDN
         63RwRhOje/PV9E6/iJ8Jqu2dS5sqyhRoqIc1Moal/XOaWJNvsl4q9dp5RhFk6kH0sraI
         TgUipeFRsCIesUxU5Cz/NmXU7I0nc0I5NXuvdjVKB73XnvrHUXFRhlDbwNVMTsi7MdHq
         4c+WZ4aQgBAqpim+0AP/r8O/Ea3KZSoYEvl0ifTozg6JTy8CZTmfYwzog3vi7sq4iCbj
         PKjVktPiljDYLxpEPyvIq3BCe2f5SOXKRUhrvlXE3WvSIBc2qw0DV3TeIFFvmyQjr4+7
         fDrQ==
X-Gm-Message-State: AOAM530qtgcBXuZsRCT6/eFAs46SsARdz88mRG/bnIfaMGOju9a4QXJ7
        OkDciDAe9nuL88nSYOzn5Ms6ZU+dQ34J29KHgE4QKtjHwr+x3xoR8423Ro+NkIsA/FSYaFgin5e
        SnKLpsmAZNuL8Gxj9
X-Received: by 2002:a17:90a:9dca:: with SMTP id x10mr3784888pjv.15.1624515507791;
        Wed, 23 Jun 2021 23:18:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx8BEMs5m6lD+klj8bSB7obVeASulAJ461pgBhyPez6qI4tohs98cfe8d+bhRyH7jbizNdUWw==
X-Received: by 2002:a17:90a:9dca:: with SMTP id x10mr3784871pjv.15.1624515507595;
        Wed, 23 Jun 2021 23:18:27 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id c22sm1632350pfv.121.2021.06.23.23.18.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jun 2021 23:18:27 -0700 (PDT)
Subject: Re: [PATCH v2 1/4] net: tun: fix tun_xdp_one() for IFF_TUN mode
To:     David Woodhouse <dwmw2@infradead.org>, netdev@vger.kernel.org
Cc:     =?UTF-8?Q?Eugenio_P=c3=a9rez?= <eperezma@redhat.com>
References: <03ee62602dd7b7101f78e0802249a6e2e4c10b7f.camel@infradead.org>
 <20210622161533.1214662-1-dwmw2@infradead.org>
 <fedca272-a03e-4bac-4038-2bb1f6b4df84@redhat.com>
 <e8843f32aa14baff398584e5b3a00d20994836b6.camel@infradead.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <f860d6a2-12a4-c766-ee57-db789c4a8d1f@redhat.com>
Date:   Thu, 24 Jun 2021 14:18:08 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <e8843f32aa14baff398584e5b3a00d20994836b6.camel@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/6/23 下午9:52, David Woodhouse 写道:
> On Wed, 2021-06-23 at 11:45 +0800, Jason Wang wrote:
>> As replied in previous version, it would be better if we can unify
>> similar logic in tun_get_user().
> So that ends up looking something like this (incremental).
>
> Note the '/* XXX: frags && */' part in tun_skb_set_protocol(), because
> the 'frags &&' was there in tun_get_user() and it wasn't obvious to me
> whether I should be lifting that out as a separate argument to
> tun_skb_set_protocol() or if there's a better way.
>
> Either way, in my judgement this is less suitable for a stable fix and
> more appropriate for a follow-on cleanup. But I don't feel that
> strongly; I'm more than happy for you to overrule me on that.
> Especially if you fix the above XXX part while you're at it :)


By simply adding a boolean "pull" in tun_skb_set_protocol()?

Thanks


>
> I tested this with vhost-net and !IFF_NO_PI, and TX works. RX is still
> hosed on the vhost-net side, for the same reason that a bunch of test
> cases were already listed in #if 0, but I'll address that in a separate
> email. It's not part of *this* patch.
>
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -1641,6 +1641,40 @@ static struct sk_buff *tun_build_skb(struct tun_struct *tun,
>   	return NULL;
>   }
>   
> +static int tun_skb_set_protocol(struct tun_struct *tun, struct sk_buff *skb,
> +				__be16 pi_proto)
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
> +		if (/* XXX frags && */!pskb_may_pull(skb, ETH_HLEN))
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
> @@ -1784,37 +1818,9 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
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
> +	err = tun_skb_set_protocol(tun, skb, pi.proto);
> +	if (err)
> +		goto drop;
>   
>   	/* copy skb_ubuf_info for callback when skb has no error */
>   	if (zerocopy) {
> @@ -2334,8 +2340,10 @@ static int tun_xdp_one(struct tun_struct *tun,
>   	struct virtio_net_hdr *gso = NULL;
>   	struct bpf_prog *xdp_prog;
>   	struct sk_buff *skb = NULL;
> +	__be16 proto = 0;
>   	u32 rxhash = 0, act;
>   	int buflen = hdr->buflen;
> +	int reservelen = xdp->data - xdp->data_hard_start;
>   	int err = 0;
>   	bool skb_xdp = false;
>   	struct page *page;
> @@ -2343,6 +2351,17 @@ static int tun_xdp_one(struct tun_struct *tun,
>   	if (tun->flags & IFF_VNET_HDR)
>   		gso = &hdr->gso;
>   
> +	if (!(tun->flags & IFF_NO_PI)) {
> +		struct tun_pi *pi = xdp->data;
> +		if (datasize < sizeof(*pi)) {
> +			atomic_long_inc(&tun->rx_frame_errors);
> +			return  -EINVAL;
> +		}
> +		proto = pi->proto;
> +		reservelen += sizeof(*pi);
> +		datasize -= sizeof(*pi);
> +	}
> +
>   	xdp_prog = rcu_dereference(tun->xdp_prog);
>   	if (xdp_prog) {
>   		if (gso && gso->gso_type) {
> @@ -2388,8 +2407,8 @@ static int tun_xdp_one(struct tun_struct *tun,
>   		goto out;
>   	}
>   
> -	skb_reserve(skb, xdp->data - xdp->data_hard_start);
> -	skb_put(skb, xdp->data_end - xdp->data);
> +	skb_reserve(skb, reservelen);
> +	skb_put(skb, datasize);
>   
>   	if (gso && virtio_net_hdr_to_skb(skb, gso, tun_is_little_endian(tun))) {
>   		atomic_long_inc(&tun->rx_frame_errors);
> @@ -2397,48 +2416,12 @@ static int tun_xdp_one(struct tun_struct *tun,
>   		err = -EINVAL;
>   		goto out;
>   	}
> -	switch (tun->flags & TUN_TYPE_MASK) {
> -	case IFF_TUN:
> -		if (tun->flags & IFF_NO_PI) {
> -			u8 ip_version = skb->len ? (skb->data[0] >> 4) : 0;
>   
> -			switch (ip_version) {
> -			case 4:
> -				skb->protocol = htons(ETH_P_IP);
> -				break;
> -			case 6:
> -				skb->protocol = htons(ETH_P_IPV6);
> -				break;
> -			default:
> -				atomic_long_inc(&tun->dev->rx_dropped);
> -				kfree_skb(skb);
> -				err = -EINVAL;
> -				goto out;
> -			}
> -		} else {
> -			struct tun_pi *pi = (struct tun_pi *)skb->data;
> -			if (!pskb_may_pull(skb, sizeof(*pi))) {
> -				atomic_long_inc(&tun->dev->rx_dropped);
> -				kfree_skb(skb);
> -				err = -ENOMEM;
> -				goto out;
> -			}
> -			skb_pull_inline(skb, sizeof(*pi));
> -			skb->protocol = pi->proto;
> -		}
> -
> -		skb_reset_mac_header(skb);
> -		skb->dev = tun->dev;
> -		break;
> -	case IFF_TAP:
> -		if (!pskb_may_pull(skb, ETH_HLEN)) {
> -			atomic_long_inc(&tun->dev->rx_dropped);
> -			kfree_skb(skb);
> -			err = -ENOMEM;
> -			goto out;
> -		}
> -		skb->protocol = eth_type_trans(skb, tun->dev);
> -		break;
> +	err = tun_skb_set_protocol(tun, skb, proto);
> +	if (err) {
> +		atomic_long_inc(&tun->dev->rx_dropped);
> +		kfree_skb(skb);
> +		goto out;
>   	}
>   
>   	skb_reset_network_header(skb);
>

