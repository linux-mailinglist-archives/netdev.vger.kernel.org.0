Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B3C23B1260
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 05:46:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230236AbhFWDsk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 23:48:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:48796 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229890AbhFWDsi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 23:48:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624419980;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fLUNn2OL+lIBHunrvsHZ9I6/+LDngeoA1H0hMEdVY8E=;
        b=DHVeOCzh44lFMmH0UFVsu26I0nQmLpabhtJzcuc4PlYWKzJavUXjy/dPiz7OxZfS+3pXfw
        feMR4zmhjtnNAXJCaRB7P5ndm6p+9W07X5SyO5OAp+VehUnV6ZhS5ToqvcGz5zp9U0q9Po
        VjoHmzWTd1lJWHe9fcHaiRVNkjLsOGM=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-590-3hoTR2ZPMzeTzK6GeM_9lw-1; Tue, 22 Jun 2021 23:46:19 -0400
X-MC-Unique: 3hoTR2ZPMzeTzK6GeM_9lw-1
Received: by mail-pg1-f197.google.com with SMTP id m13-20020a633f0d0000b0290222ece48979so500287pga.1
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 20:46:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=fLUNn2OL+lIBHunrvsHZ9I6/+LDngeoA1H0hMEdVY8E=;
        b=ndgPcPmKC//D4wFvlwspRQ6tMinwVSuGHpXSFRVLOUN3b0E9jht7ch95t0jp1Qn4q3
         9zPMv2RDKvveHa0W+d7mTP33t8DNf0s1qJAs0lVTD4ODlv7loe3+wVT8WMw2huZfgAUO
         WUt4zva3DEYBcsTgtPioQvYWIFKozStJMrz0jp7iVxrRPH6rX6uDSrrVxrqjLAIgXlHN
         E8d0zAPMnSiSPpq3HY/AaecWgKwZKeU1AM9IsnO5PqOJG3jYoKgiS5xyS9R/jaDPEUyl
         J4C5t8Z05FtKLWU4HbVe9tXvZagliQ9a/+R8WVdYZm5flBSkZ1JZxSD5nHOCMSlUhN1f
         knmg==
X-Gm-Message-State: AOAM533CFREe11OqDxE3d4Mn1eQipLwOFyc57tQjEVOsIB94Otf/0awX
        TSziczkn7V1pXVp03C5w8LoXQqAZpqNvLgnHo8YR0yzWaZNeXaGTqwX6QUrZ49H3nmjB6sGk9Iu
        x/KC8Lzn8oMhaSL2U
X-Received: by 2002:a63:ed12:: with SMTP id d18mr1827663pgi.12.1624419977995;
        Tue, 22 Jun 2021 20:46:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyaFxmQgTFsJT0jqVxK9TBCQr6JI90Nk3lusMjQIiiucwzksZdnBjCbSwNjlzVnLAHRxWBWvg==
X-Received: by 2002:a63:ed12:: with SMTP id d18mr1827650pgi.12.1624419977841;
        Tue, 22 Jun 2021 20:46:17 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id go16sm2265965pjb.42.2021.06.22.20.46.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Jun 2021 20:46:17 -0700 (PDT)
Subject: Re: [PATCH v2 2/4] net: tun: don't assume IFF_VNET_HDR in
 tun_xdp_one() tx path
To:     David Woodhouse <dwmw2@infradead.org>, netdev@vger.kernel.org
Cc:     =?UTF-8?Q?Eugenio_P=c3=a9rez?= <eperezma@redhat.com>
References: <03ee62602dd7b7101f78e0802249a6e2e4c10b7f.camel@infradead.org>
 <20210622161533.1214662-1-dwmw2@infradead.org>
 <20210622161533.1214662-2-dwmw2@infradead.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <f345667e-e896-509b-6bb6-4efdf7c46ff6@redhat.com>
Date:   Wed, 23 Jun 2021 11:46:14 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210622161533.1214662-2-dwmw2@infradead.org>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/6/23 ÉÏÎç12:15, David Woodhouse Ð´µÀ:
> From: David Woodhouse <dwmw@amazon.co.uk>
>
> Sometimes it's just a data packet. The virtio_net_hdr processing should be
> conditional on IFF_VNET_HDR, just as it is in tun_get_user().
>
> Fixes: 043d222f93ab ("tuntap: accept an array of XDP buffs through sendmsg()")
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>


Acked-by: Jason Wang <jasowang@redhat.com>


> ---
>   drivers/net/tun.c | 9 ++++++---
>   1 file changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index f812dcdc640e..96933887d03d 100644
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -2331,7 +2331,7 @@ static int tun_xdp_one(struct tun_struct *tun,
>   {
>   	unsigned int datasize = xdp->data_end - xdp->data;
>   	struct tun_xdp_hdr *hdr = xdp->data_hard_start;
> -	struct virtio_net_hdr *gso = &hdr->gso;
> +	struct virtio_net_hdr *gso = NULL;
>   	struct bpf_prog *xdp_prog;
>   	struct sk_buff *skb = NULL;
>   	u32 rxhash = 0, act;
> @@ -2340,9 +2340,12 @@ static int tun_xdp_one(struct tun_struct *tun,
>   	bool skb_xdp = false;
>   	struct page *page;
>   
> +	if (tun->flags & IFF_VNET_HDR)
> +		gso = &hdr->gso;
> +
>   	xdp_prog = rcu_dereference(tun->xdp_prog);
>   	if (xdp_prog) {
> -		if (gso->gso_type) {
> +		if (gso && gso->gso_type) {
>   			skb_xdp = true;
>   			goto build;
>   		}
> @@ -2388,7 +2391,7 @@ static int tun_xdp_one(struct tun_struct *tun,
>   	skb_reserve(skb, xdp->data - xdp->data_hard_start);
>   	skb_put(skb, xdp->data_end - xdp->data);
>   
> -	if (virtio_net_hdr_to_skb(skb, gso, tun_is_little_endian(tun))) {
> +	if (gso && virtio_net_hdr_to_skb(skb, gso, tun_is_little_endian(tun))) {
>   		atomic_long_inc(&tun->rx_frame_errors);
>   		kfree_skb(skb);
>   		err = -EINVAL;

