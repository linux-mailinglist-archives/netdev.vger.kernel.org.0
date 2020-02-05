Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08B95152621
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 06:52:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725906AbgBEFvV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Feb 2020 00:51:21 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:37749 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725875AbgBEFvS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Feb 2020 00:51:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580881877;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mCCBz5Rdlbkg4ojmDomdGX6wRFkIiLU8SA3hhtwlDwg=;
        b=CDTocgNrNp/v/MPRdY1Z1xxqJcI6aeDY7cangVdqK8AbeIPTKYirbe48ezIr9SD4E0ycGs
        OE/J23fr9EYDJso0eoWIcOxpy1LXKxxWzQUYsd6BEGrPX1YQKmTOe58RydpsKGEnnlLijg
        afxOx7Y3aLl6N68CZckMirWa3CWjS1I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-6-BTzEyaLKMeuvyVcErxsMpw-1; Wed, 05 Feb 2020 00:51:15 -0500
X-MC-Unique: BTzEyaLKMeuvyVcErxsMpw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2C27D1034B21;
        Wed,  5 Feb 2020 05:51:13 +0000 (UTC)
Received: from [10.72.13.188] (ovpn-13-188.pek2.redhat.com [10.72.13.188])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5C1C548;
        Wed,  5 Feb 2020 05:50:36 +0000 (UTC)
Subject: Re: [PATCH] vhost: introduce vDPA based backend
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Tiwei Bie <tiwei.bie@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, shahafs@mellanox.com, jgg@mellanox.com,
        rob.miller@broadcom.com, haotian.wang@sifive.com,
        eperezma@redhat.com, lulu@redhat.com, parav@mellanox.com,
        rdunlap@infradead.org, hch@infradead.org, jiri@mellanox.com,
        hanand@xilinx.com, mhabets@solarflare.com,
        maxime.coquelin@redhat.com, lingshan.zhu@intel.com,
        dan.daly@intel.com, cunming.liang@intel.com, zhihong.wang@intel.com
References: <20200131033651.103534-1-tiwei.bie@intel.com>
 <7aab2892-bb19-a06a-a6d3-9c28bc4c3400@redhat.com>
 <20200204005306-mutt-send-email-mst@kernel.org>
 <cf485e7f-46e3-20d3-8452-e3058b885d0a@redhat.com>
 <20200205020555.GA369236@___>
 <798e5644-ca28-ee46-c953-688af9bccd3b@redhat.com>
 <20200205003048-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <eb53d1c2-92ae-febf-f502-2d3e107ee608@redhat.com>
Date:   Wed, 5 Feb 2020 13:50:28 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200205003048-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/2/5 =E4=B8=8B=E5=8D=881:31, Michael S. Tsirkin wrote:
> On Wed, Feb 05, 2020 at 11:12:21AM +0800, Jason Wang wrote:
>> On 2020/2/5 =E4=B8=8A=E5=8D=8810:05, Tiwei Bie wrote:
>>> On Tue, Feb 04, 2020 at 02:46:16PM +0800, Jason Wang wrote:
>>>> On 2020/2/4 =E4=B8=8B=E5=8D=882:01, Michael S. Tsirkin wrote:
>>>>> On Tue, Feb 04, 2020 at 11:30:11AM +0800, Jason Wang wrote:
>>>>>> 5) generate diffs of memory table and using IOMMU API to setup the=
 dma
>>>>>> mapping in this method
>>>>> Frankly I think that's a bunch of work. Why not a MAP/UNMAP interfa=
ce?
>>>>>
>>>> Sure, so that basically VHOST_IOTLB_UPDATE/INVALIDATE I think?
>>> Do you mean we let userspace to only use VHOST_IOTLB_UPDATE/INVALIDAT=
E
>>> to do the DMA mapping in vhost-vdpa case? When vIOMMU isn't available=
,
>>> userspace will set msg->iova to GPA, otherwise userspace will set
>>> msg->iova to GIOVA, and vhost-vdpa module will get HPA from msg->uadd=
r?
>>>
>>> Thanks,
>>> Tiwei
>> I think so. Michael, do you think this makes sense?
>>
>> Thanks
> to make sure, could you post the suggested argument format for
> these ioctls?
>

It's the existed uapi:

/* no alignment requirement */
struct vhost_iotlb_msg {
 =C2=A0=C2=A0=C2=A0 __u64 iova;
 =C2=A0=C2=A0=C2=A0 __u64 size;
 =C2=A0=C2=A0=C2=A0 __u64 uaddr;
#define VHOST_ACCESS_RO=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0x1
#define VHOST_ACCESS_WO=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0x2
#define VHOST_ACCESS_RW=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0x3
 =C2=A0=C2=A0=C2=A0 __u8 perm;
#define VHOST_IOTLB_MISS=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 1
#define VHOST_IOTLB_UPDATE=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 2
#define VHOST_IOTLB_INVALIDATE=C2=A0=C2=A0=C2=A0=C2=A0 3
#define VHOST_IOTLB_ACCESS_FAIL=C2=A0=C2=A0=C2=A0 4
 =C2=A0=C2=A0=C2=A0 __u8 type;
};

#define VHOST_IOTLB_MSG 0x1
#define VHOST_IOTLB_MSG_V2 0x2

struct vhost_msg {
 =C2=A0=C2=A0=C2=A0 int type;
 =C2=A0=C2=A0=C2=A0 union {
 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 struct vhost_iotlb_msg iotlb;
 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 __u8 padding[64];
 =C2=A0=C2=A0=C2=A0 };
};

struct vhost_msg_v2 {
 =C2=A0=C2=A0=C2=A0 __u32 type;
 =C2=A0=C2=A0=C2=A0 __u32 reserved;
 =C2=A0=C2=A0=C2=A0 union {
 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 struct vhost_iotlb_msg iotlb;
 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 __u8 padding[64];
 =C2=A0=C2=A0=C2=A0 };
};

