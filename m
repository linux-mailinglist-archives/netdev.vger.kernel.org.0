Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AF823AFE65
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 09:51:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbhFVHyH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 03:54:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45457 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229789AbhFVHyF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 03:54:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624348309;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+Mt+T6W7MLNfj5pt9CAyDY1YNxhCUEtdLfe2ajNqovU=;
        b=Gv6P9PM/NtFedjAcnwN9s7xMrSnjdjC2DGLHKyY6sZGiC2PgoAGrZbVi/XgU7jGgCQmDJl
        65IX8UrcPib8WblTNFv5bjzgZ4719qFf/yGYBd/xeOkyZZQHyvJJa7Vg1H3X2FuhCSZ25U
        dB+HMkvrLw+EcNJamXVq2VA6bYWA5xE=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-169-OLzuHFGMNNKChzWEGRKHzw-1; Tue, 22 Jun 2021 03:51:48 -0400
X-MC-Unique: OLzuHFGMNNKChzWEGRKHzw-1
Received: by mail-pf1-f198.google.com with SMTP id m14-20020aa78a0e0000b029030531e994a3so937793pfa.12
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 00:51:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=+Mt+T6W7MLNfj5pt9CAyDY1YNxhCUEtdLfe2ajNqovU=;
        b=B+3c3xQ9+uzlZICNBDy5lpQIDDLpAqdURNU5E7yuruIw8cwdOVKVRknyTn5T2g7Jbs
         3lwMxBu2K4gkUqzz1QES84omtcWcHkQ/bH1Gc0c7y/+4ZM6iQ0p82UrFULgmIERhFYyH
         Gbvwad1VJwPC8MB7k7kmQZT2dnOeh3u0KZ51takEQJKldf9gZJ7X8y2ftuODQ7qd2Ll9
         Z1GWZaP9pX4nBmXfhWjjGY/aoANVtaWFl9YPLQ1k1HkLC8LJDE2RtZ2IAcxqoaUuUBpe
         Uqd0dhFwy/y1nrYgo0RUaYgUirLIFL0VNMYNIBpsi/GsR3hSiYPLWNjD9zeU3hR9eOL1
         LvsA==
X-Gm-Message-State: AOAM531jm13kC01I0eiYj+dAR6MGPYeKHnFUC4iun98OCls6ESg5mbi5
        NFwWC+yu1Xqy4TG3VBatG45aPqy2WKq4BlVQ69k+I3Oe80YixQWDHR1WJnD1DwpsupCqjqGuGPa
        bXPM9UoWSXoFPgl9y
X-Received: by 2002:a63:561d:: with SMTP id k29mr2539172pgb.335.1624348307167;
        Tue, 22 Jun 2021 00:51:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw7GJyAa++3Pk1mV0pRM85TwaxayEEZOYDXf+GmSOq/WiMMZ0J3yomjCD9j2f6MOLuFHL/zaQ==
X-Received: by 2002:a63:561d:: with SMTP id k29mr2539167pgb.335.1624348307019;
        Tue, 22 Jun 2021 00:51:47 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id q4sm19489287pgg.0.2021.06.22.00.51.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Jun 2021 00:51:46 -0700 (PDT)
Subject: Re: [PATCH] net: tun: fix tun_xdp_one() for IFF_TUN mode
To:     David Woodhouse <dwmw2@infradead.org>,
        netdev <netdev@vger.kernel.org>
Cc:     =?UTF-8?Q?Eugenio_P=c3=a9rez?= <eperezma@redhat.com>
References: <03ee62602dd7b7101f78e0802249a6e2e4c10b7f.camel@infradead.org>
 <e832b356-ffc2-8bca-f5d9-75e8b98cfcf2@redhat.com>
 <2cbe878845eb2a1e3803b3340263ea14436fe053.camel@infradead.org>
 <2433592d2b26deec33336dd3e83acfd273b0cf30.camel@infradead.org>
 <c93c7357e9fa8a6ce89c0fc53328eeb4f3eb68d5.camel@infradead.org>
 <d26bbeb7-d184-9bda-55c3-2273f743b139@redhat.com>
 <f35b7857cba18aa6d187723624b57c8bb9b533e8.camel@infradead.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <ca2e6445-2ac7-7de1-bf3c-af000cb1739a@redhat.com>
Date:   Tue, 22 Jun 2021 15:51:43 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <f35b7857cba18aa6d187723624b57c8bb9b533e8.camel@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/6/22 下午3:24, David Woodhouse 写道:
> On Tue, 2021-06-22 at 12:52 +0800, Jason Wang wrote:
>>
>> I cook two patches. Please see and check if they fix the problem.
>> (compile test only for me).
> I did the second one slightly differently (below) but those are what I
> came up with too, which seems to be working.
>
> @@ -2331,7 +2344,7 @@ static int tun_xdp_one(struct tun_struct *tun,
>   {
>          unsigned int datasize = xdp->data_end - xdp->data;
>          struct tun_xdp_hdr *hdr = xdp->data_hard_start;
> -       struct virtio_net_hdr *gso = &hdr->gso;
> +       struct virtio_net_hdr *gso = NULL;
>          struct bpf_prog *xdp_prog;
>          struct sk_buff *skb = NULL;
>          u32 rxhash = 0, act;
> @@ -2340,9 +2353,12 @@ static int tun_xdp_one(struct tun_struct *tun,
>          bool skb_xdp = false;
>          struct page *page;
>   
> +       if (tun->flags & IFF_VNET_HDR)
> +               gso = &hdr->gso;
> +
>          xdp_prog = rcu_dereference(tun->xdp_prog);
>          if (xdp_prog) {
> -               if (gso->gso_type) {
> +               if (gso && gso->gso_type) {
>                          skb_xdp = true;
>                          goto build;
>                  }
> @@ -2388,14 +2406,18 @@ static int tun_xdp_one(struct tun_struct *tun,
>          skb_reserve(skb, xdp->data - xdp->data_hard_start);
>          skb_put(skb, xdp->data_end - xdp->data);
>   
> -       if (virtio_net_hdr_to_skb(skb, gso, tun_is_little_endian(tun))) {
> +       if (!gso)
> +               skb_reset_mac_header(skb);
> +       else if (virtio_net_hdr_to_skb(skb, gso, tun_is_little_endian(tun))) {
>                  atomic_long_inc(&tun->rx_frame_errors);
>                  kfree_skb(skb);


This should work as well.

Thanks

