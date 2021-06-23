Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE9133B125E
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 05:45:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230130AbhFWDrc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 23:47:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36591 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229774AbhFWDrb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 23:47:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624419914;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zRO9M68B1N+iUNIIknyesktneXdWBFn4ufwTcOykBZg=;
        b=AhFnsvIV76reESiFdA++kagVp1DtEig1M7guKlUxd2V7y5T57xiu6VNQYVppQsMl5rBG1/
        Sfk8EYqOZcJ1fevc9T833HMLwFM8iW8+ChDPzIvx+h3sgqfOwU8LtB+ShNkug8vMePKGnE
        rqtKRWGgVDWd0yR392A09+Z8ABDlRqw=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-398-ZOkqT-VFOWK8WpbTwUZgNA-1; Tue, 22 Jun 2021 23:45:12 -0400
X-MC-Unique: ZOkqT-VFOWK8WpbTwUZgNA-1
Received: by mail-pl1-f197.google.com with SMTP id 62-20020a1709020544b0290116739a77a4so334768plf.7
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 20:45:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=zRO9M68B1N+iUNIIknyesktneXdWBFn4ufwTcOykBZg=;
        b=Nu9Hdo437DO/wQeYcMcjZpnzz6PEld9RPn7F6eSFM7Xfw8wfVdv4CgZGJ4yCYre19a
         Jrom+nqvtKoMQ9IIBCZzeBdBIkntad69m5wScKc8rEtNaiQjy9hCSzVgy235kRUguld5
         o+PvxcPJiDPZq1a9hfLqf29iXnLPLph1BjBJtD5JeGem3zxdsBbBz+WoJKtsdn7LeNYg
         4jOcjWxnEpVG19Zk1g3oTkteFK95/UZnRzzl1+ySBxCBfp8Y7NxWoC+WGFOB8VkcNROV
         8dFQrJGKT0UlZmUvZ4VxBu0FQVvWG63eYF3QQqFOnGRyqOnJEQPtVzcapG+XnXJk0hyq
         C5GA==
X-Gm-Message-State: AOAM532vHpJINC8lh0DKShv3ACXXDAP0HhMhs6ZkGyuqeqrp+OF3uhk9
        gaOQ/pGkOwN8iU0F79UR5bjVolmZS0lij24mlgTNqUKlADV/emD7ulFH13adhNC82RmZqVB+ijf
        5Nf368CWu/rDsuKrg
X-Received: by 2002:a17:90b:a4d:: with SMTP id gw13mr7378687pjb.104.1624419911616;
        Tue, 22 Jun 2021 20:45:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwxFqS7ubsJQfj4eUKMay2yhZshrB/Ikx5Se0fw5yi5YILch4xMHX63qczK3Qb17MW+OaNNRA==
X-Received: by 2002:a17:90b:a4d:: with SMTP id gw13mr7378673pjb.104.1624419911344;
        Tue, 22 Jun 2021 20:45:11 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y13sm20612981pgp.16.2021.06.22.20.45.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Jun 2021 20:45:10 -0700 (PDT)
Subject: Re: [PATCH v2 1/4] net: tun: fix tun_xdp_one() for IFF_TUN mode
To:     David Woodhouse <dwmw2@infradead.org>, netdev@vger.kernel.org
Cc:     =?UTF-8?Q?Eugenio_P=c3=a9rez?= <eperezma@redhat.com>
References: <03ee62602dd7b7101f78e0802249a6e2e4c10b7f.camel@infradead.org>
 <20210622161533.1214662-1-dwmw2@infradead.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <fedca272-a03e-4bac-4038-2bb1f6b4df84@redhat.com>
Date:   Wed, 23 Jun 2021 11:45:07 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210622161533.1214662-1-dwmw2@infradead.org>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/6/23 ÉÏÎç12:15, David Woodhouse Ð´µÀ:
> From: David Woodhouse <dwmw@amazon.co.uk>
>
> In tun_get_user(), skb->protocol is either taken from the tun_pi header
> or inferred from the first byte of the packet in IFF_TUN mode, while
> eth_type_trans() is called only in the IFF_TAP mode where the payload
> is expected to be an Ethernet frame.
>
> The alternative path in tun_xdp_one() was unconditionally using
> eth_type_trans(), which corrupts packets in IFF_TUN mode. Fix it to
> do the correct thing for IFF_TUN mode, as tun_get_user() does.
>
> Fixes: 043d222f93ab ("tuntap: accept an array of XDP buffs through sendmsg()")
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
>   drivers/net/tun.c | 44 +++++++++++++++++++++++++++++++++++++++++++-
>   1 file changed, 43 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index 4cf38be26dc9..f812dcdc640e 100644
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -2394,8 +2394,50 @@ static int tun_xdp_one(struct tun_struct *tun,
>   		err = -EINVAL;
>   		goto out;
>   	}
> +	switch (tun->flags & TUN_TYPE_MASK) {
> +	case IFF_TUN:
> +		if (tun->flags & IFF_NO_PI) {
> +			u8 ip_version = skb->len ? (skb->data[0] >> 4) : 0;
> +
> +			switch (ip_version) {
> +			case 4:
> +				skb->protocol = htons(ETH_P_IP);
> +				break;
> +			case 6:
> +				skb->protocol = htons(ETH_P_IPV6);
> +				break;
> +			default:
> +				atomic_long_inc(&tun->dev->rx_dropped);
> +				kfree_skb(skb);
> +				err = -EINVAL;
> +				goto out;
> +			}
> +		} else {
> +			struct tun_pi *pi = (struct tun_pi *)skb->data;
> +			if (!pskb_may_pull(skb, sizeof(*pi))) {
> +				atomic_long_inc(&tun->dev->rx_dropped);
> +				kfree_skb(skb);
> +				err = -ENOMEM;
> +				goto out;
> +			}
> +			skb_pull_inline(skb, sizeof(*pi));
> +			skb->protocol = pi->proto;


As replied in previous version, it would be better if we can unify 
similar logic in tun_get_user().

Thanks


> +		}
> +
> +		skb_reset_mac_header(skb);
> +		skb->dev = tun->dev;
> +		break;
> +	case IFF_TAP:
> +		if (!pskb_may_pull(skb, ETH_HLEN)) {
> +			atomic_long_inc(&tun->dev->rx_dropped);
> +			kfree_skb(skb);
> +			err = -ENOMEM;
> +			goto out;
> +		}
> +		skb->protocol = eth_type_trans(skb, tun->dev);
> +		break;
> +	}
>   
> -	skb->protocol = eth_type_trans(skb, tun->dev);
>   	skb_reset_network_header(skb);
>   	skb_probe_transport_header(skb);
>   	skb_record_rx_queue(skb, tfile->queue_index);

