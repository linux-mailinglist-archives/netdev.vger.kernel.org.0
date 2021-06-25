Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3E1A3B3D74
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 09:34:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbhFYHgG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 03:36:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:28718 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230111AbhFYHgE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Jun 2021 03:36:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624606424;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1LhOEe0NchnLPEK73YryX6GSY7fv1PW9V4gyCQJIs+A=;
        b=RH6ijZ0OkiKv3WsyevVe2upgcBJuqFYlX5kEt3aIwm8f2axOMh/1R9AQEiYBema3Wn1W9b
        /u21RJG/qTVKPpk4pgQw2Bwjt9CIRR7U5NSIJ9SbzIA9m8weO7F85BA777Bdzfn1RR3gOk
        AY2vx+t0u03c0ZoLoQcZ4qv7yydBQ0I=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-512-Qij6WHupMzO4qOgZ21GVHw-1; Fri, 25 Jun 2021 03:33:42 -0400
X-MC-Unique: Qij6WHupMzO4qOgZ21GVHw-1
Received: by mail-pg1-f199.google.com with SMTP id y1-20020a655b410000b02902235977d00cso5511467pgr.21
        for <netdev@vger.kernel.org>; Fri, 25 Jun 2021 00:33:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=1LhOEe0NchnLPEK73YryX6GSY7fv1PW9V4gyCQJIs+A=;
        b=DQWFj5/HRmEMnlCQxyv3OjcQpNvMrzVG8kOfrpTS8Fc0rjvL654E2gUFlpAtMdG+w/
         EbwjUjRzSc7dPjyEk4OTgxlT/uUYxSesd21NOA0tZqRvi7B8ITm7IVjeQA/jmMtxh6MT
         RyY/iiFM28LS1O+IDxWrZNONJROcOrve+e7KpIGUvXyVIESOYjauK6UVKiT48olJSr/0
         teW3Dvl8CQNiq0hjlEoBOsevWzV8g4BamK4NqvrLEyRmVQVbDEwxEn5KH9MtqFTqXbXd
         vFR0QyeluUhdKByuYg9YpMXrWabEWRpZhSggRYhTiLZG0JGiH70jVxrd+DoG5jBzLVg4
         P/Sw==
X-Gm-Message-State: AOAM531BdeNDrqY/uBk3h4xaWNS1j200CD/wazZpKnQWEcf1/0ZMIrBD
        tjpnGL/9SoxAmgEHmwjGHc5z/Vzs/2MNPBtPUdcl3DJYh/+I81qoBy3E/wa7zzS6qTDFfbDrOFE
        OhJXVfmOjLXS5FIOY
X-Received: by 2002:aa7:829a:0:b029:2e9:e53:198d with SMTP id s26-20020aa7829a0000b02902e90e53198dmr9392573pfm.72.1624606421309;
        Fri, 25 Jun 2021 00:33:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyNbqDtLT+W2TBlvt4EeH2TlY6CMl62jQSAlMBKUImWe1znpEvBJ4IEDkia+M2NjyEolCWhGA==
X-Received: by 2002:aa7:829a:0:b029:2e9:e53:198d with SMTP id s26-20020aa7829a0000b02902e90e53198dmr9392552pfm.72.1624606421053;
        Fri, 25 Jun 2021 00:33:41 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id i128sm4981430pfc.142.2021.06.25.00.33.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Jun 2021 00:33:40 -0700 (PDT)
Subject: Re: [PATCH v3 3/5] vhost_net: remove virtio_net_hdr validation, let
 tun/tap do it themselves
To:     David Woodhouse <dwmw2@infradead.org>, netdev@vger.kernel.org
Cc:     =?UTF-8?Q?Eugenio_P=c3=a9rez?= <eperezma@redhat.com>,
        Willem de Bruijn <willemb@google.com>
References: <03ee62602dd7b7101f78e0802249a6e2e4c10b7f.camel@infradead.org>
 <20210624123005.1301761-1-dwmw2@infradead.org>
 <20210624123005.1301761-3-dwmw2@infradead.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <b339549d-c8f1-1e56-2759-f7b15ee8eca1@redhat.com>
Date:   Fri, 25 Jun 2021 15:33:36 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210624123005.1301761-3-dwmw2@infradead.org>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/6/24 ÏÂÎç8:30, David Woodhouse Ð´µÀ:
> From: David Woodhouse<dwmw@amazon.co.uk>
>
> When the underlying socket isn't configured with a virtio_net_hdr, the
> existing code in vhost_net_build_xdp() would attempt to validate
> uninitialised data, by copying zero bytes (sock_hlen) into the local
> copy of the header and then trying to validate that.
>
> Fixing it is somewhat non-trivial because the tun device might put a
> struct tun_pi*before*  the virtio_net_hdr, which makes it hard to find.
> So just stop messing with someone else's data in vhost_net_build_xdp(),
> and let tap and tun validate it for themselves, as they do in the
> non-XDP case anyway.


Thinking in another way. All XDP stuffs for vhost is prepared for TAP. 
XDP is not expected to work for TUN.

So we can simply let's vhost doesn't go with XDP path is the underlayer 
socket is TUN.

Thanks


>
> This means that the 'gso' member of struct tun_xdp_hdr can die, leaving
> only 'int buflen'.
>
> The socket header of sock_hlen is still copied separately from the
> data payload because there may be a gap between them to ensure suitable
> alignment of the latter.
>
> Fixes: 0a0be13b8fe2 ("vhost_net: batch submitting XDP buffers to underlayer sockets")
> Signed-off-by: David Woodhouse<dwmw@amazon.co.uk>
> ---
>   drivers/net/tap.c      | 25 ++++++++++++++++++++++---
>   drivers/net/tun.c      | 21 ++++++++++++++++++---
>   drivers/vhost/net.c    | 30 +++++++++---------------------
>   include/linux/if_tun.h |  1 -
>   4 files changed, 49 insertions(+), 28 deletions(-)

