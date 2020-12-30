Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EE402E769D
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 07:37:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726300AbgL3Ggn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Dec 2020 01:36:43 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55947 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726185AbgL3Ggm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Dec 2020 01:36:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609310116;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=V3lC15jls6IaJqaREYiEoSGla45iKl4vF8Trns9tYY8=;
        b=OTF+WfpUVPmtcmFxRirnfjhubtQeMr/Tx8de5gJl3IjChpPmrwTPYUTOqhz2zko8dzmtqT
        7iQ+emaBvUWQski/bdqBL3DyC3euUgFq4lB5j7K16Ln9BBCUOBoDxtEqX8e+mG7j5VSvoX
        Oz38AZkfWx/5kD9egTelv+en+Umdcy4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-369-u9IGufgONymH5MxSpEGGwQ-1; Wed, 30 Dec 2020 01:35:12 -0500
X-MC-Unique: u9IGufgONymH5MxSpEGGwQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8B2D010054FF;
        Wed, 30 Dec 2020 06:35:10 +0000 (UTC)
Received: from [10.72.13.30] (ovpn-13-30.pek2.redhat.com [10.72.13.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B77922C166;
        Wed, 30 Dec 2020 06:35:00 +0000 (UTC)
Subject: Re: [PATCH 11/21] vhost-vdpa: introduce asid based IOTLB
To:     Eli Cohen <elic@nvidia.com>
Cc:     mst@redhat.com, eperezma@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lulu@redhat.com, eli@mellanox.com,
        lingshan.zhu@intel.com, rob.miller@broadcom.com,
        stefanha@redhat.com, sgarzare@redhat.com
References: <20201216064818.48239-1-jasowang@redhat.com>
 <20201216064818.48239-12-jasowang@redhat.com>
 <20201229115340.GD195479@mtl-vdi-166.wap.labs.mlnx>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <5df825a2-b794-9374-4ebf-83c5cc14584a@redhat.com>
Date:   Wed, 30 Dec 2020 14:34:59 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201229115340.GD195479@mtl-vdi-166.wap.labs.mlnx>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/12/29 下午7:53, Eli Cohen wrote:
>> +
>> +static struct vhost_vdpa_as *vhost_vdpa_alloc_as(struct vhost_vdpa *v, u32 asid)
>> +{
>> +	struct hlist_head *head = &v->as[asid % VHOST_VDPA_IOTLB_BUCKETS];
>> +	struct vhost_vdpa_as *as;
>> +
>> +	if (asid_to_as(v, asid))
>> +		return NULL;
>> +
>> +	as = kmalloc(sizeof(*as), GFP_KERNEL);
> kzalloc()? See comment below.
>
>> +	if (!as)
>> +		return NULL;
>> +
>> +	vhost_iotlb_init(&as->iotlb, 0, 0);
>> +	as->id = asid;
>> +	hlist_add_head(&as->hash_link, head);
>> +	++v->used_as;
> Although you eventually ended up removing used_as, this is a bug since
> you're incrementing a random value. Maybe it's better to be on the safe
> side and use kzalloc() for as above.


Yes and used_as needs to be removed.

Thanks



>

