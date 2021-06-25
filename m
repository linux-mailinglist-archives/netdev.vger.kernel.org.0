Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDA813B3CEA
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 08:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbhFYHBS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 03:01:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55902 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229741AbhFYHBP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Jun 2021 03:01:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624604335;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iKRBxKOs5o7oDuuNio2hXfanoEaZ20AOxL/AQwEayew=;
        b=icGs2eZZVPEYTRrX1CC6iibB+eEbxacmyf08WyHhS8Jy8XJsPuH2t0SkZLhZGQneMwYNGi
        471bge05kehbKOZ6Ixgklhyb0q4qSdam5pVGWs6Vkzq8e0ZoyViWrCXSDuVqAbJu6kKJ6W
        SsO0NWLEB7lXFz42OGKMJ0NoP6R9kpk=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-592-Lb-dn6r_P4KA5-9lVkyTlQ-1; Fri, 25 Jun 2021 02:58:53 -0400
X-MC-Unique: Lb-dn6r_P4KA5-9lVkyTlQ-1
Received: by mail-pj1-f71.google.com with SMTP id b9-20020a17090aa589b029016e99e81994so7613044pjq.0
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 23:58:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=iKRBxKOs5o7oDuuNio2hXfanoEaZ20AOxL/AQwEayew=;
        b=nsb4DFkZ4oM/6jtkCaCUDsKHF85Svj6/8xpkG/mKeBbCd6Yua3MsiJA19dA91g2NAA
         LA7W/VD1CuKs0ewru6azAqFUR4KhuUPo0OCVnBW6aC2FrV6A+PnRrRfxA7eMK7RiVYjQ
         cnN6SbaKN3uKax8G+V4hVcfgPq+PBTiRvs4RNksVG7eAu/S/lsrxxu58MWM6sxTsGHRH
         mOM3sNSAl1RLwQq3T53WK7ueeRzclvTiW8ZLKzegipKns+UWZm8h0e2Dw2Nv3PNZP7oO
         LK568haVMxjRHaPmtF5dcbxykOBjiuiQFV0MHgcZv5TWgrEeHXWPPBuKRxOO4CXZsxF2
         DPqQ==
X-Gm-Message-State: AOAM5323DMADQ94GKnautDCcWSJ3dhklh+325WHy9YrRsC3G3v6AS3DW
        zQ+vwS27s/MFwQary7hqUqbzQgA++xsF/Mcr7elo+akBvU9PJq2UCr1HoSf/bUmJPrXEs0fvrVJ
        d6UtZJotB1yZd7YsC
X-Received: by 2002:a62:8286:0:b029:2fc:812d:2e70 with SMTP id w128-20020a6282860000b02902fc812d2e70mr5174041pfd.24.1624604332384;
        Thu, 24 Jun 2021 23:58:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzETLmB5Oiws/nfe9ZLnzbe4nL3T+jcaIKrJH7VTExZ/N01jjU9W4XYYODnrCi3bmOC8IO60w==
X-Received: by 2002:a62:8286:0:b029:2fc:812d:2e70 with SMTP id w128-20020a6282860000b02902fc812d2e70mr5174022pfd.24.1624604332121;
        Thu, 24 Jun 2021 23:58:52 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 136sm4068169pfa.158.2021.06.24.23.58.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Jun 2021 23:58:51 -0700 (PDT)
Subject: Re: [PATCH v3 2/5] net: tun: don't assume IFF_VNET_HDR in
 tun_xdp_one() tx path
To:     David Woodhouse <dwmw2@infradead.org>, netdev@vger.kernel.org
Cc:     =?UTF-8?Q?Eugenio_P=c3=a9rez?= <eperezma@redhat.com>,
        Willem de Bruijn <willemb@google.com>
References: <03ee62602dd7b7101f78e0802249a6e2e4c10b7f.camel@infradead.org>
 <20210624123005.1301761-1-dwmw2@infradead.org>
 <20210624123005.1301761-2-dwmw2@infradead.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <3fb5a99a-52bb-0a47-0ea6-531104db5838@redhat.com>
Date:   Fri, 25 Jun 2021 14:58:32 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210624123005.1301761-2-dwmw2@infradead.org>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/6/24 ÏÂÎç8:30, David Woodhouse Ð´µÀ:
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
> index 67b406fa0881..9acd448e6dfc 100644
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

