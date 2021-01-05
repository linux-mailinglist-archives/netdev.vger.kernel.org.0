Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D74452EA455
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 05:15:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728258AbhAEEPT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 23:15:19 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32822 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727024AbhAEEPM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jan 2021 23:15:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609820026;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YNwfaLROqYRPmfvgvxa6nI7hiNfX/WzqZuvzfVKuUUY=;
        b=X7stQoxYPpRYvUucFqkuhGo0wOaDqvza8Jac1WrZneynwrUCyPHP1krN4PLFNs2IzWoAaF
        gRCz+DOQgf9dW1YEQDdhxGnYVzP9Ux3O9I6mmhI1qzgSfKzW8ysFT5t4U+oYNZ6RAmkbN2
        ahjtDuK4PukR/8XitD+cWaoCz711nh0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-79-quVrtjhsOZmNy5g7PEYh9g-1; Mon, 04 Jan 2021 23:13:42 -0500
X-MC-Unique: quVrtjhsOZmNy5g7PEYh9g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 380C9107ACE3;
        Tue,  5 Jan 2021 04:13:41 +0000 (UTC)
Received: from [10.72.13.192] (ovpn-13-192.pek2.redhat.com [10.72.13.192])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E55165D9C6;
        Tue,  5 Jan 2021 04:13:28 +0000 (UTC)
Subject: Re: [PATCH 06/21] vdpa: introduce virtqueue groups
To:     Stefan Hajnoczi <stefanha@gmail.com>
Cc:     mst@redhat.com, kvm@vger.kernel.org, lulu@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, eperezma@redhat.com,
        stefanha@redhat.com, eli@mellanox.com, lingshan.zhu@intel.com,
        rob.miller@broadcom.com
References: <20201216064818.48239-1-jasowang@redhat.com>
 <20201216064818.48239-7-jasowang@redhat.com>
 <20210104100458.GC342399@stefanha-x1.localdomain>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <bf7e6f2e-eeb8-38b3-94f0-8b4a3ce9ff9f@redhat.com>
Date:   Tue, 5 Jan 2021 12:13:27 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210104100458.GC342399@stefanha-x1.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/1/4 下午6:04, Stefan Hajnoczi wrote:
> On Wed, Dec 16, 2020 at 02:48:03PM +0800, Jason Wang wrote:
>> This patch introduces virtqueue groups to vDPA device. The virtqueue
>> group is the minimal set of virtqueues that must share an address
>> space. And the adddress space identifier could only be attached to
>> a specific virtqueue group.
>>
>> A new mandated bus operation is introduced to get the virtqueue group
>> ID for a specific virtqueue.
>>
>> All the vDPA device drivers were converted to simply support a single
>> virtqueue group.
>>
>> Signed-off-by: Jason Wang <jasowang@redhat.com>
>> ---
>>   drivers/vdpa/ifcvf/ifcvf_main.c   |  9 ++++++++-
>>   drivers/vdpa/mlx5/net/mlx5_vnet.c |  8 +++++++-
>>   drivers/vdpa/vdpa.c               |  4 +++-
>>   drivers/vdpa/vdpa_sim/vdpa_sim.c  | 11 ++++++++++-
>>   include/linux/vdpa.h              | 12 +++++++++---
>>   5 files changed, 37 insertions(+), 7 deletions(-)
> Maybe consider calling it iotlb_group or iommu_group so the purpose of
> the group is clear?


I'm not sure. The reason that I choose virtqueue group is because:

1) Virtqueue is the only entity that tries to issues DMA
2) For IOMMU group, it may cause confusion to the existing IOMMU group 
who group devices
3) IOTLB is the concept in vhost, we don't have such definition in the 
virtio spec

Thanks


