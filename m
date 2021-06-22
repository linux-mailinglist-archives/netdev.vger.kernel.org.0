Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F6D23AFE9E
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 10:00:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbhFVIDA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 04:03:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20734 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229677AbhFVICr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 04:02:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624348830;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0Riuyg6i5bwUWeWfOjphk5HkcnIpQY5TtovFERKz9nM=;
        b=L8Ckxz5WyeFOHwryDZPNfRorNAadh4b74iCqxCBafM9C6txMbef1r8+nCTLBoY07gdQdtL
        UyJ+3YmOAhO0yyUGeFzg+DUvHlIoMHlF12Nevr7TlaqYGhQx3SwNulIN94HrgJA/RHfdNg
        zcK9txiCqkAIM03TCuYREj/BIuvjobc=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-555-rlTrUinANYCXXSkELD22QQ-1; Tue, 22 Jun 2021 04:00:28 -0400
X-MC-Unique: rlTrUinANYCXXSkELD22QQ-1
Received: by mail-pg1-f198.google.com with SMTP id k9-20020a63d1090000b029021091ebb84cso11310367pgg.3
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 01:00:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=0Riuyg6i5bwUWeWfOjphk5HkcnIpQY5TtovFERKz9nM=;
        b=BENpKsnudqukzodAxbyuX+AS4vG3HgEiydUYL+kRk1zwgV+dl3pe9pTqT0IG9Oz9Xl
         gYnv2SNUZ5EnUJEWTTU1B/apKHaRwywBJJPdoyy5Z6cYbd+hsxBHgrjQW4XWPqjWTBzb
         BPLYsnKbbvOKvmcguTB2OPeaT5zjAqNMcRCDFN5xGf9pX5SHS+NGfUioU4zXxQEdUcNB
         jP2c+n75RQMrX+Ww/Sd3WXqS78w+iqgdqSR7MJ6vpuhUfhP7c8r0W2hQAEmuyWIey2Qi
         VBMYPgOEzJ5ulSwpcToLoeYhqKLDPyG+2ee2o+qvRIbAcNeUjFiRXo9w9Fk89SsPGmXc
         zxfg==
X-Gm-Message-State: AOAM530N6vbcYtqnahTToGhjHsnGFA1Q82aZsmmE54F3XJagy64ThBl2
        bjelYxAFEL4ObtF+6MS15NaDW//iDJw8mtEDFmTAtZB+8FSeD7yvEjR15os0O1WTjgVWB1FCh6r
        pJuOS49CDvweX3ImI
X-Received: by 2002:a63:fc06:: with SMTP id j6mr2619722pgi.226.1624348827439;
        Tue, 22 Jun 2021 01:00:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz1Vvwlf04FMNkxGQFQU1Vu5+fEzjWVyrlDc/d0+k6XDgQpEjvrsjpItdlil1O3POVcwyP0sA==
X-Received: by 2002:a63:fc06:: with SMTP id j6mr2619696pgi.226.1624348827172;
        Tue, 22 Jun 2021 01:00:27 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id j24sm17501620pfe.58.2021.06.22.01.00.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Jun 2021 01:00:26 -0700 (PDT)
Subject: Re: [PATCH] net: tun: fix tun_xdp_one() for IFF_TUN mode
To:     David Woodhouse <dwmw2@infradead.org>,
        netdev <netdev@vger.kernel.org>
Cc:     =?UTF-8?Q?Eugenio_P=c3=a9rez?= <eperezma@redhat.com>
References: <03ee62602dd7b7101f78e0802249a6e2e4c10b7f.camel@infradead.org>
 <e832b356-ffc2-8bca-f5d9-75e8b98cfcf2@redhat.com>
 <2cbe878845eb2a1e3803b3340263ea14436fe053.camel@infradead.org>
 <c7ae488b-ffde-f9e3-8b45-1c3d5669b519@redhat.com>
 <b287e6a4e5968e524daeeee4216286666a83bcd8.camel@infradead.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <cfe1ddd7-cc14-49ee-4126-83bd940b5777@redhat.com>
Date:   Tue, 22 Jun 2021 16:00:19 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <b287e6a4e5968e524daeeee4216286666a83bcd8.camel@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/6/22 下午3:28, David Woodhouse 写道:
> On Tue, 2021-06-22 at 12:34 +0800, Jason Wang wrote:
>>> Secondly, I need to pull numbers out of my posterior for the
>>> VHOST_SET_MEM_TABLE call. This works for x86_64:
>>>
>>>         vmem->nregions = 1;
>>>         vmem->regions[0].guest_phys_addr = 4096;
>>>         vmem->regions[0].memory_size = 0x7fffffffe000;
>>>         vmem->regions[0].userspace_addr = 4096;
>>>         if (ioctl(vpninfo->vhost_fd, VHOST_SET_MEM_TABLE, vmem) < 0) {
>>>
>>> Is there a way to bypass that and just unconditionally set a 1:1
>>> mapping of *all* userspace address space?
>>
>> Memory Table is one of the basic abstraction of the vhost. Basically,
>> you only need to map the userspace buffers. This is how DPDK virtio-user
>> PMD did. Vhost will validate the addresses through access_ok() during
>> VHOST_SET_MEM_TABLE.
>>
>> The range of all usersapce space seems architecture specific, I'm not
>> sure if it's worth to bother.
> The buffers are just malloc'd. I just need a full 1:1 mapping of all
> "guest" memory to userspace addresses, and was trying to avoid having
> to map them on demand *just* because I don't know the full range of
> possible addresses that malloc will return, in advance.
>
> I'm tempted to add a new feature for that 1:1 access, with no ->umem or
> ->iotlb at all. And then I can use it as a key to know that the XDP
> bugs are fixed too :)


This means we need validate the userspace address each time before vhost 
tries to use that. This will de-gradate the performance. So we still 
need to figure out the legal userspace address range which might not be 
easy.

Thanks


>

