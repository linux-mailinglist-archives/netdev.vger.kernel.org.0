Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19931327682
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 04:55:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232102AbhCADyr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Feb 2021 22:54:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:21076 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232081AbhCADyl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Feb 2021 22:54:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614570794;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uLH9M0I0CMwxLIlKabThSQ9LIWBinbU59JWEShdZQWQ=;
        b=SenIaJHhjWEHdoNUf8xdjQZZ17akz5//Bqt7cb/Mv45KCH4bz2hYcrnUrH1kTEY6G0NVaS
        RDv/9WhL8Pjl5lSTmE5tHDIavKIce2AznUNRXV65RSnN2+IhquACrkwEFLjB8HWpljQh64
        zVQhRnlT4oSL0Q3VNXUnxVjRKovD7H0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-456-ENPFafOsPduOMSBAOY-e8g-1; Sun, 28 Feb 2021 22:53:12 -0500
X-MC-Unique: ENPFafOsPduOMSBAOY-e8g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 22E1880196C;
        Mon,  1 Mar 2021 03:53:11 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-12-164.pek2.redhat.com [10.72.12.164])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0A7836E406;
        Mon,  1 Mar 2021 03:53:05 +0000 (UTC)
Subject: Re: [PATCH] vdpa/mlx5: set_features should allow reset to zero
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Si-Wei Liu <si-wei.liu@oracle.com>, elic@nvidia.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
References: <20210223082536-mutt-send-email-mst@kernel.org>
 <3ff5fd23-1db0-2f95-4cf9-711ef403fb62@oracle.com>
 <20210224000057-mutt-send-email-mst@kernel.org>
 <0559fd8c-ff44-cb7a-8a74-71976dd2ee33@redhat.com>
 <20210224014232-mutt-send-email-mst@kernel.org>
 <ce6b0380-bc4c-bcb8-db82-2605e819702c@redhat.com>
 <20210224021222-mutt-send-email-mst@kernel.org>
 <babc654d-8dcd-d8a2-c3b6-d20cc4fc554c@redhat.com>
 <20210224034240-mutt-send-email-mst@kernel.org>
 <d2992c03-d639-54e3-4599-c168ceeac148@redhat.com>
 <20210228162909-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <4ac87dc6-4629-78fa-c080-b4cd1eaaccb7@redhat.com>
Date:   Mon, 1 Mar 2021 11:53:04 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210228162909-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/3/1 5:30 上午, Michael S. Tsirkin wrote:
> On Wed, Feb 24, 2021 at 05:30:37PM +0800, Jason Wang wrote:
>> On 2021/2/24 4:43 下午, Michael S. Tsirkin wrote:
>>> On Wed, Feb 24, 2021 at 04:26:43PM +0800, Jason Wang wrote:
>>>>       Basically on first guest access QEMU would tell kernel whether
>>>>       guest is using the legacy or the modern interface.
>>>>       E.g. virtio_pci_config_read/virtio_pci_config_write will call ioctl(ENABLE_LEGACY, 1)
>>>>       while virtio_pci_common_read will call ioctl(ENABLE_LEGACY, 0)
>>>>
>>>>
>>>> But this trick work only for PCI I think?
>>>>
>>>> Thanks
>>> ccw has a revision it can check. mmio does not have transitional devices
>>> at all.
>>
>> Ok, then we can do the workaround in the qemu, isn't it?
>>
>> Thanks
> which one do you mean?


I meant the workaround that is done by 452639a64ad8 ("vdpa: make sure 
set_features is invoked for legacy").

Thanks


>

