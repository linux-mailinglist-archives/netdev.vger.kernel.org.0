Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 830DE3AFBFE
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 06:34:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbhFVEg0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 00:36:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48929 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229574AbhFVEgZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 00:36:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624336450;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uQV+UviyW/kR8kffWJDELxyBABId2f5mGgpOBkqYzrw=;
        b=hM3zrAzE1sALQ7eduhRh1r5G8Guv6bdgntDsEpjHRvs3P/l0mjsPQOecar3iMU+MwP4yYu
        jQ47Tfw4qL88S5IiH9cbL8AjyaTeywWO4AKw8FOOsjdgoyu48K7zeedRJkUyEy98MqUGTB
        JzS521sqBg9Gib/SkO6wUckTio1dXZs=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-265-9a00-TesO6yUtivjECXxlg-1; Tue, 22 Jun 2021 00:34:08 -0400
X-MC-Unique: 9a00-TesO6yUtivjECXxlg-1
Received: by mail-pj1-f69.google.com with SMTP id bv6-20020a17090af186b029016fb0e27fe2so950665pjb.4
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 21:34:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=uQV+UviyW/kR8kffWJDELxyBABId2f5mGgpOBkqYzrw=;
        b=cQxkAgEMYlC6sHHKA0z+A+TWinZkmP31C1wN5mD5IERu7z7OKyu9GUdN0BPOXxljDH
         NJg6V57HmMIvHEwyy0cLmt4y2NYUd0wQvolOR094KalU1HzUl56+mjoC6qe9lyVUOvKn
         yq877sj3ZeDSYthuyn2bhEkPfTATKL87cCVEvBADXVWG+59VLCJGLYo1pBVFQNfpOZTE
         ufEn3l4TWfjTJuLJvGUzLYuB/udGt0ppYz8KLK48ZOEOKZSkiuTGVm5cmvSjUbEnbOxM
         v9fYkBLndtNM2+3MpAHHngLbUkyP8EiIoXGN5eHPixuFtp+A45r9nRudQEzKM+HLmagH
         IeQw==
X-Gm-Message-State: AOAM531QA8AAPII1aXa/OOTnuaoUD8eOdqdNFxB5r50Vf7GPiR2PPLgb
        VKxOPPXq4/+GO2h0P3LjHa49uLSXNsCImXzaUQ6+QANdufCLevCZwBndtlPgyV2aFxS8ahogCml
        /myU755sdM/ZtyfRK
X-Received: by 2002:a17:902:bf44:b029:11e:5454:26c0 with SMTP id u4-20020a170902bf44b029011e545426c0mr20942757pls.2.1624336447481;
        Mon, 21 Jun 2021 21:34:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwP02irb7e4qfNjkQK78qCihD5jzRsqMcxO/b3CBcph8KrHdieyLL6L0w9c7u5WVKR3ZZBlNA==
X-Received: by 2002:a17:902:bf44:b029:11e:5454:26c0 with SMTP id u4-20020a170902bf44b029011e545426c0mr20942743pls.2.1624336447266;
        Mon, 21 Jun 2021 21:34:07 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id e13sm6721327pfd.8.2021.06.21.21.34.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Jun 2021 21:34:06 -0700 (PDT)
Subject: Re: [PATCH] net: tun: fix tun_xdp_one() for IFF_TUN mode
To:     David Woodhouse <dwmw2@infradead.org>,
        netdev <netdev@vger.kernel.org>
Cc:     =?UTF-8?Q?Eugenio_P=c3=a9rez?= <eperezma@redhat.com>
References: <03ee62602dd7b7101f78e0802249a6e2e4c10b7f.camel@infradead.org>
 <e832b356-ffc2-8bca-f5d9-75e8b98cfcf2@redhat.com>
 <2cbe878845eb2a1e3803b3340263ea14436fe053.camel@infradead.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <c7ae488b-ffde-f9e3-8b45-1c3d5669b519@redhat.com>
Date:   Tue, 22 Jun 2021 12:34:00 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <2cbe878845eb2a1e3803b3340263ea14436fe053.camel@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/6/21 下午6:52, David Woodhouse 写道:
> On Mon, 2021-06-21 at 15:00 +0800, Jason Wang wrote:
>> I think it's probably too late to fix? Since it should work before
>> 043d222f93ab.
>>
>> The only way is to backport this fix to stable.
> Yeah, I assumed the fix would be backported; if not then the "does the
> kernel have it" check is fairly trivial.
>
> I *can* avoid it for now by just using TUNSNDBUF to reduce the sndbuf
> and then we never take the XDP path at all.
>
> My initial crappy hacks are slowly turning into something that I might
> actually want to commit to mainline (once I've fixed endianness and
> memory ordering issues):
> https://gitlab.com/openconnect/openconnect/-/compare/master...vhost
>
> I have a couple of remaining problems using vhost-net directly from
> userspace though.
>
> Firstly, I don't think I can set IFF_VNET_HDR on the tun device after
> opening it. So my model of "open the tun device, then *see* if we can
> use vhost to accelerate it" doesn't work.


Yes, IFF_VNET_HDR is set during TUN_SET_IFF which can't be changed 
afterwards.


>
> I tried setting VHOST_NET_F_VIRTIO_NET_HDR in the vhost features
> instead, but that gives me a weird failure mode where it drops around
> half the incoming packets, and I haven't yet worked out why.
>
> Of course I don't *actually* want a vnet header at all but the vhost
> code really assumes that *someone* will add one; if I *don't* set
> VHOST_NET_F_VIRTIO_NET_HDR then it always *assumes* it can read ten
> bytes more from the tun socket than the 'peek' says, and barfs when it
> can't. (Or such was my initial half-thought-through diagnosis before I
> made it go away by setting IFF_VNET_HDR, at least).


Yes, vhost always assumes there's a vnet header.


>
>
> Secondly, I need to pull numbers out of my posterior for the
> VHOST_SET_MEM_TABLE call. This works for x86_64:
>
> 	vmem->nregions = 1;
> 	vmem->regions[0].guest_phys_addr = 4096;
> 	vmem->regions[0].memory_size = 0x7fffffffe000;
> 	vmem->regions[0].userspace_addr = 4096;
> 	if (ioctl(vpninfo->vhost_fd, VHOST_SET_MEM_TABLE, vmem) < 0) {
>
> Is there a way to bypass that and just unconditionally set a 1:1
> mapping of *all* userspace address space?


Memory Table is one of the basic abstraction of the vhost. Basically, 
you only need to map the userspace buffers. This is how DPDK virtio-user 
PMD did. Vhost will validate the addresses through access_ok() during 
VHOST_SET_MEM_TABLE.

The range of all usersapce space seems architecture specific, I'm not 
sure if it's worth to bother.

Thanks


>
>
>
> It's possible that one or the other of those problems will result in a
> new advertised "feature" which is so simple (like a 1:1 map) that we
> can call it a bugfix and backport it along with the tun fix I already
> posted, and the presence of *that* can indicate that the tun bug is
> fixed :)

