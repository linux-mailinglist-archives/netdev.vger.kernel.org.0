Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53721DE945
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 12:20:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728083AbfJUKUN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 06:20:13 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:43062 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728076AbfJUKUN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 06:20:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571653211;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fYrZFHZOW1YUmAoRCKQjGzYd6i7mjDB4UBqk3ydgai0=;
        b=Oh8e5EhPDQakn/OVQC6Blu1iuUx1XNzGi6H3Ip3ISxOFTzX3iX6S9aUNMiT1DWtG9uw3ON
        Wl5KkqPte0yWklPCdJr4BpQ++YJNBJiXknYVzLrgsB9ZT3cxXeih+EzjqcnuLMGh9GyGzU
        4T/eL3LFitwTbkRzFO75CL5f+x1uy34=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-59-DGgyACdxNFywAbDdAHZQfA-1; Mon, 21 Oct 2019 06:20:08 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CA8A55ED;
        Mon, 21 Oct 2019 10:20:06 +0000 (UTC)
Received: from [10.72.12.22] (ovpn-12-22.pek2.redhat.com [10.72.12.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 686441001B09;
        Mon, 21 Oct 2019 10:19:54 +0000 (UTC)
Subject: Re: [RFC 2/2] vhost: IFC VF vdpa layer
To:     "Zhu, Lingshan" <lingshan.zhu@intel.com>, mst@redhat.com,
        alex.williamson@redhat.com
Cc:     linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, dan.daly@intel.com,
        cunming.liang@intel.com, tiwei.bie@intel.com, jason.zeng@intel.com,
        zhiyuan.lv@intel.com
References: <20191016013050.3918-1-lingshan.zhu@intel.com>
 <20191016013050.3918-3-lingshan.zhu@intel.com>
 <9495331d-3c65-6f49-dcd9-bfdb17054cf0@redhat.com>
 <f65358e9-6728-8260-74f7-176d7511e989@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <1cae60b6-938d-e2df-2dca-fbf545f06853@redhat.com>
Date:   Mon, 21 Oct 2019 18:19:52 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <f65358e9-6728-8260-74f7-176d7511e989@intel.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: DGgyACdxNFywAbDdAHZQfA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/10/21 =E4=B8=8B=E5=8D=885:53, Zhu, Lingshan wrote:
>
> On 10/16/2019 6:19 PM, Jason Wang wrote:
>>
>> On 2019/10/16 =E4=B8=8A=E5=8D=889:30, Zhu Lingshan wrote:
>>> This commit introduced IFC VF operations for vdpa, which complys to
>>> vhost_mdev interfaces, handles IFC VF initialization,
>>> configuration and removal.
>>>
>>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>>> ---
>>> =C2=A0 drivers/vhost/ifcvf/ifcvf_main.c | 541=20
>>> +++++++++++++++++++++++++++++++++++++++
>>> =C2=A0 1 file changed, 541 insertions(+)
>>> =C2=A0 create mode 100644 drivers/vhost/ifcvf/ifcvf_main.c
>>>
>>> diff --git a/drivers/vhost/ifcvf/ifcvf_main.c=20
>>> b/drivers/vhost/ifcvf/ifcvf_main.c
>>> new file mode 100644
>>> index 000000000000..c48a29969a85
>>> --- /dev/null
>>> +++ b/drivers/vhost/ifcvf/ifcvf_main.c
>>> @@ -0,0 +1,541 @@
>>> +// SPDX-License-Identifier: GPL-2.0-only
>>> +/*
>>> + * Copyright (C) 2019 Intel Corporation.
>>> + */
>>> +
>>> +#include <linux/interrupt.h>
>>> +#include <linux/module.h>
>>> +#include <linux/mdev.h>
>>> +#include <linux/pci.h>
>>> +#include <linux/sysfs.h>
>>> +
>>> +#include "ifcvf_base.h"
>>> +
>>> +#define VERSION_STRING=C2=A0=C2=A0=C2=A0 "0.1"
>>> +#define DRIVER_AUTHOR=C2=A0=C2=A0=C2=A0 "Intel Corporation"
>>> +#define IFCVF_DRIVER_NAME=C2=A0=C2=A0=C2=A0 "ifcvf"
>>> +
>>> +static irqreturn_t ifcvf_intr_handler(int irq, void *arg)
>>> +{
>>> +=C2=A0=C2=A0=C2=A0 struct vring_info *vring =3D arg;
>>> +
>>> +=C2=A0=C2=A0=C2=A0 if (vring->cb.callback)
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return vring->cb.callback(v=
ring->cb.private);
>>> +
>>> +=C2=A0=C2=A0=C2=A0 return IRQ_HANDLED;
>>> +}
>>> +
>>> +static u64 ifcvf_mdev_get_features(struct mdev_device *mdev)
>>> +{
>>> +=C2=A0=C2=A0=C2=A0 return IFC_SUPPORTED_FEATURES;
>>
>>
>> I would expect this should be done by querying the hw. Or IFC VF=20
>> can't get any update through its firmware?
>
> Hi Jason,
>
> Thanks for your comments, for now driver just support these features.


Ok, it should work but less flexible, we can change it in the future.


>
>>
>>
>>> +}
>>> +
>>> +static int ifcvf_mdev_set_features(struct mdev_device *mdev, u64=20
>>> features)
>>> +{
>>> +=C2=A0=C2=A0=C2=A0 struct ifcvf_adapter *adapter =3D mdev_get_drvdata(=
mdev);
>>> +=C2=A0=C2=A0=C2=A0 struct ifcvf_hw *vf =3D IFC_PRIVATE_TO_VF(adapter);
>>> +
>>> +=C2=A0=C2=A0=C2=A0 vf->req_features =3D features;
>>> +
>>> +=C2=A0=C2=A0=C2=A0 return 0;
>>> +}
>>> +
>>> +static u64 ifcvf_mdev_get_vq_state(struct mdev_device *mdev, u16 qid)
>>> +{
>>> +=C2=A0=C2=A0=C2=A0 struct ifcvf_adapter *adapter =3D mdev_get_drvdata(=
mdev);
>>> +=C2=A0=C2=A0=C2=A0 struct ifcvf_hw *vf =3D IFC_PRIVATE_TO_VF(adapter);
>>> +
>>> +=C2=A0=C2=A0=C2=A0 return vf->vring[qid].last_avail_idx;
>>
>>
>> Does this really work? I'd expect it should be fetched from hw since=20
>> it's an internal state.
> for now, it's working, we intend to support LM in next version drivers.


I'm not sure I understand here, I don't see any synchronization between=20
the hardware and last_avail_idx, so last_avail_idx should not change.

Btw, what did "LM" mean :) ?


>>
>>
>>> +}
>>> +
>>> +static int ifcvf_mdev_set_vq_state(struct mdev_device *mdev, u16=20
>>> qid, u64 num)
>>> +{
>>> +=C2=A0=C2=A0=C2=A0 struct ifcvf_adapter *adapter =3D mdev_get_drvdata(=
mdev);
>>> +=C2=A0=C2=A0=C2=A0 struct ifcvf_hw *vf =3D IFC_PRIVATE_TO_VF(adapter);
>>> +
>>> +=C2=A0=C2=A0=C2=A0 vf->vring[qid].last_used_idx =3D num;
>>
>>
>> I fail to understand why last_used_idx is needed. It looks to me the=20
>> used idx in the used ring is sufficient.
> I will remove it.
>>
>>
>>> +=C2=A0=C2=A0=C2=A0 vf->vring[qid].last_avail_idx =3D num;
>>
>>
>> Do we need a synchronization with hw immediately here?
>>
>>
>>> +
>>> +=C2=A0=C2=A0=C2=A0 return 0;
>>> +}
>>> +
>>> +static int ifcvf_mdev_set_vq_address(struct mdev_device *mdev, u16=20
>>> idx,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 desc_area, u64 driv=
er_area,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 device_area)
>>> +{
>>> +=C2=A0=C2=A0=C2=A0 struct ifcvf_adapter *adapter =3D mdev_get_drvdata(=
mdev);
>>> +=C2=A0=C2=A0=C2=A0 struct ifcvf_hw *vf =3D IFC_PRIVATE_TO_VF(adapter);
>>> +
>>> +=C2=A0=C2=A0=C2=A0 vf->vring[idx].desc =3D desc_area;
>>> +=C2=A0=C2=A0=C2=A0 vf->vring[idx].avail =3D driver_area;
>>> +=C2=A0=C2=A0=C2=A0 vf->vring[idx].used =3D device_area;
>>> +
>>> +=C2=A0=C2=A0=C2=A0 return 0;
>>> +}
>>> +
>>> +static void ifcvf_mdev_set_vq_num(struct mdev_device *mdev, u16=20
>>> qid, u32 num)
>>> +{
>>> +=C2=A0=C2=A0=C2=A0 struct ifcvf_adapter *adapter =3D mdev_get_drvdata(=
mdev);
>>> +=C2=A0=C2=A0=C2=A0 struct ifcvf_hw *vf =3D IFC_PRIVATE_TO_VF(adapter);
>>> +
>>> +=C2=A0=C2=A0=C2=A0 vf->vring[qid].size =3D num;
>>> +}
>>> +
>>> +static void ifcvf_mdev_set_vq_ready(struct mdev_device *mdev,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 u16 qid, bool ready)
>>> +{
>>> +
>>> +=C2=A0=C2=A0=C2=A0 struct ifcvf_adapter *adapter =3D mdev_get_drvdata(=
mdev);
>>> +=C2=A0=C2=A0=C2=A0 struct ifcvf_hw *vf =3D IFC_PRIVATE_TO_VF(adapter);
>>> +
>>> +=C2=A0=C2=A0=C2=A0 vf->vring[qid].ready =3D ready;
>>> +}
>>> +
>>> +static bool ifcvf_mdev_get_vq_ready(struct mdev_device *mdev, u16 qid)
>>> +{
>>> +
>>> +=C2=A0=C2=A0=C2=A0 struct ifcvf_adapter *adapter =3D mdev_get_drvdata(=
mdev);
>>> +=C2=A0=C2=A0=C2=A0 struct ifcvf_hw *vf =3D IFC_PRIVATE_TO_VF(adapter);
>>> +
>>> +=C2=A0=C2=A0=C2=A0 return vf->vring[qid].ready;
>>> +}
>>> +
>>> +static void ifcvf_mdev_set_vq_cb(struct mdev_device *mdev, u16 idx,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct virtio_mdev_callback *cb)
>>> +{
>>> +=C2=A0=C2=A0=C2=A0 struct ifcvf_adapter *adapter =3D mdev_get_drvdata(=
mdev);
>>> +=C2=A0=C2=A0=C2=A0 struct ifcvf_hw *vf =3D IFC_PRIVATE_TO_VF(adapter);
>>> +
>>> +=C2=A0=C2=A0=C2=A0 vf->vring[idx].cb =3D *cb;
>>> +}
>>> +
>>> +static void ifcvf_mdev_kick_vq(struct mdev_device *mdev, u16 idx)
>>> +{
>>> +=C2=A0=C2=A0=C2=A0 struct ifcvf_adapter *adapter =3D mdev_get_drvdata(=
mdev);
>>> +=C2=A0=C2=A0=C2=A0 struct ifcvf_hw *vf =3D IFC_PRIVATE_TO_VF(adapter);
>>> +
>>> +=C2=A0=C2=A0=C2=A0 ifcvf_notify_queue(vf, idx);
>>> +}
>>> +
>>> +static u8 ifcvf_mdev_get_status(struct mdev_device *mdev)
>>> +{
>>> +=C2=A0=C2=A0=C2=A0 struct ifcvf_adapter *adapter =3D mdev_get_drvdata(=
mdev);
>>> +=C2=A0=C2=A0=C2=A0 struct ifcvf_hw *vf =3D IFC_PRIVATE_TO_VF(adapter);
>>> +
>>> +=C2=A0=C2=A0=C2=A0 return vf->status;
>>> +}
>>> +
>>> +static u32 ifcvf_mdev_get_generation(struct mdev_device *mdev)
>>> +{
>>> +=C2=A0=C2=A0=C2=A0 struct ifcvf_adapter *adapter =3D mdev_get_drvdata(=
mdev);
>>> +=C2=A0=C2=A0=C2=A0 struct ifcvf_hw *vf =3D IFC_PRIVATE_TO_VF(adapter);
>>> +
>>> +=C2=A0=C2=A0=C2=A0 return vf->generation;
>>> +}
>>> +
>>> +static int ifcvf_mdev_get_version(struct mdev_device *mdev)
>>> +{
>>> +=C2=A0=C2=A0=C2=A0 return VIRTIO_MDEV_VERSION;
>>> +}
>>> +
>>> +static u32 ifcvf_mdev_get_device_id(struct mdev_device *mdev)
>>> +{
>>> +=C2=A0=C2=A0=C2=A0 return IFCVF_DEVICE_ID;
>>> +}
>>> +
>>> +static u32 ifcvf_mdev_get_vendor_id(struct mdev_device *mdev)
>>> +{
>>> +=C2=A0=C2=A0=C2=A0 return IFCVF_VENDOR_ID;
>>> +}
>>> +
>>> +static u16 ifcvf_mdev_get_vq_align(struct mdev_device *mdev)
>>> +{
>>> +=C2=A0=C2=A0=C2=A0 return IFCVF_QUEUE_ALIGNMENT;
>>> +}
>>> +
>>> +static int ifcvf_start_datapath(void *private)
>>> +{
>>> +=C2=A0=C2=A0=C2=A0 int i, ret;
>>> +=C2=A0=C2=A0=C2=A0 struct ifcvf_hw *vf =3D IFC_PRIVATE_TO_VF(private);
>>> +
>>> +=C2=A0=C2=A0=C2=A0 for (i =3D 0; i < (IFCVF_MAX_QUEUE_PAIRS * 2); i++)=
 {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!vf->vring[i].ready)
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bre=
ak;
>>
>>
>> Looks like error should be returned here?
> agreed!
>>
>>
>>> +
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!vf->vring[i].size)
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bre=
ak;
>>> +
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!vf->vring[i].desc || !=
vf->vring[i].avail ||
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 !vf=
->vring[i].used)
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bre=
ak;
>>> +=C2=A0=C2=A0=C2=A0 }
>>> +=C2=A0=C2=A0=C2=A0 vf->nr_vring =3D i;
>>> +
>>> +=C2=A0=C2=A0=C2=A0 ret =3D ifcvf_start_hw(vf);
>>> +=C2=A0=C2=A0=C2=A0 return ret;
>>> +}
>>> +
>>> +static int ifcvf_stop_datapath(void *private)
>>> +{
>>> +=C2=A0=C2=A0=C2=A0 struct ifcvf_hw *vf =3D IFC_PRIVATE_TO_VF(private);
>>> +=C2=A0=C2=A0=C2=A0 int i;
>>> +
>>> +=C2=A0=C2=A0=C2=A0 for (i =3D 0; i < IFCVF_MAX_QUEUES; i++)
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 vf->vring[i].cb.callback =
=3D NULL;
>>
>>
>> Any synchronization is needed for the vq irq handler?
> I think even we set callback =3D NULL, the code is still there, on-going=
=20
> routines would not be effected.


Ok I think you mean when ifcvf_stop_hw() return, hardware will not=20
respond to e.g kick and other events etc.


>>
>>
>>> +
>>> +=C2=A0=C2=A0=C2=A0 ifcvf_stop_hw(vf);
>>> +
>>> +=C2=A0=C2=A0=C2=A0 return 0;
>>> +}
>>> +
>>> +static void ifcvf_reset_vring(struct ifcvf_adapter *adapter)
>>> +{
>>> +=C2=A0=C2=A0=C2=A0 int i;
>>> +=C2=A0=C2=A0=C2=A0 struct ifcvf_hw *vf =3D IFC_PRIVATE_TO_VF(adapter);
>>> +
>>> +=C2=A0=C2=A0=C2=A0 for (i =3D 0; i < IFCVF_MAX_QUEUE_PAIRS * 2; i++) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 vf->vring[i].last_used_idx =
=3D 0;
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 vf->vring[i].last_avail_idx=
 =3D 0;
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 vf->vring[i].desc =3D 0;
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 vf->vring[i].avail =3D 0;
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 vf->vring[i].used =3D 0;
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 vf->vring[i].ready =3D 0;
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 vf->vring->cb.callback =3D =
NULL;
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 vf->vring->cb.private =3D N=
ULL;
>>> +=C2=A0=C2=A0=C2=A0 }
>>> +}
>>> +
>>> +static void ifcvf_mdev_set_status(struct mdev_device *mdev, u8 status)
>>> +{
>>> +=C2=A0=C2=A0=C2=A0 struct ifcvf_adapter *adapter =3D mdev_get_drvdata(=
mdev);
>>> +=C2=A0=C2=A0=C2=A0 struct ifcvf_hw *vf =3D IFC_PRIVATE_TO_VF(adapter);
>>> +
>>> +=C2=A0=C2=A0=C2=A0 vf->status =3D status;
>>> +
>>> +=C2=A0=C2=A0=C2=A0 if (status =3D=3D 0) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ifcvf_stop_datapath(adapter=
);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ifcvf_reset_vring(adapter);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return;
>>> +=C2=A0=C2=A0=C2=A0 }
>>> +
>>> +=C2=A0=C2=A0=C2=A0 if (status & VIRTIO_CONFIG_S_DRIVER_OK) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ifcvf_start_datapath(adapte=
r);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return;
>>> +=C2=A0=C2=A0=C2=A0 }
>>> +}
>>> +
>>> +static u16 ifcvf_mdev_get_queue_max(struct mdev_device *mdev)
>>> +{
>>> +=C2=A0=C2=A0=C2=A0 return IFCVF_MAX_QUEUES;
>>
>>
>> The name is confusing, it was used to return the maximum queue size.=20
>> In new version of virtio-mdev, the callback was renamed as=20
>> get_vq_num_max().
> will change that.
>>
>>
>>> +}
>>> +
>>> +static struct virtio_mdev_device_ops ifc_mdev_ops =3D {
>>> +=C2=A0=C2=A0=C2=A0 .get_features=C2=A0 =3D ifcvf_mdev_get_features,
>>> +=C2=A0=C2=A0=C2=A0 .set_features=C2=A0 =3D ifcvf_mdev_set_features,
>>> +=C2=A0=C2=A0=C2=A0 .get_status=C2=A0=C2=A0=C2=A0 =3D ifcvf_mdev_get_st=
atus,
>>> +=C2=A0=C2=A0=C2=A0 .set_status=C2=A0=C2=A0=C2=A0 =3D ifcvf_mdev_set_st=
atus,
>>> +=C2=A0=C2=A0=C2=A0 .get_queue_max =3D ifcvf_mdev_get_queue_max,
>>> +=C2=A0=C2=A0=C2=A0 .get_vq_state=C2=A0=C2=A0 =3D ifcvf_mdev_get_vq_sta=
te,
>>> +=C2=A0=C2=A0=C2=A0 .set_vq_state=C2=A0=C2=A0 =3D ifcvf_mdev_set_vq_sta=
te,
>>> +=C2=A0=C2=A0=C2=A0 .set_vq_cb=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D ifcvf_=
mdev_set_vq_cb,
>>> +=C2=A0=C2=A0=C2=A0 .set_vq_ready=C2=A0=C2=A0 =3D ifcvf_mdev_set_vq_rea=
dy,
>>> +=C2=A0=C2=A0=C2=A0 .get_vq_ready=C2=A0=C2=A0=C2=A0 =3D ifcvf_mdev_get_=
vq_ready,
>>> +=C2=A0=C2=A0=C2=A0 .set_vq_num=C2=A0=C2=A0=C2=A0=C2=A0 =3D ifcvf_mdev_=
set_vq_num,
>>> +=C2=A0=C2=A0=C2=A0 .set_vq_address =3D ifcvf_mdev_set_vq_address,
>>> +=C2=A0=C2=A0=C2=A0 .kick_vq=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
=3D ifcvf_mdev_kick_vq,
>>> +=C2=A0=C2=A0=C2=A0 .get_generation=C2=A0=C2=A0=C2=A0 =3D ifcvf_mdev_ge=
t_generation,
>>> +=C2=A0=C2=A0=C2=A0 .get_version=C2=A0=C2=A0=C2=A0 =3D ifcvf_mdev_get_v=
ersion,
>>> +=C2=A0=C2=A0=C2=A0 .get_device_id=C2=A0=C2=A0=C2=A0 =3D ifcvf_mdev_get=
_device_id,
>>> +=C2=A0=C2=A0=C2=A0 .get_vendor_id=C2=A0=C2=A0=C2=A0 =3D ifcvf_mdev_get=
_vendor_id,
>>> +=C2=A0=C2=A0=C2=A0 .get_vq_align=C2=A0=C2=A0=C2=A0 =3D ifcvf_mdev_get_=
vq_align,
>>> +};
>>
>>
>> set_config/get_config is missing. It looks to me they are not hard,=20
>> just implementing the access to dev_cfg. It's key to make kernel=20
>> virtio driver to work.
>>
>> And in the new version of virito-mdev, features like _F_LOG_ALL=20
>> should be advertised through get_mdev_features.
> IMHO, currently the driver can work without set/get_config, vhost_mdev=20
> doesn't call them for now.


Yes, but it was required by virtio_mdev for host driver to work, and it=20
looks to me it's not hard to add them. If possible please add them and=20
"virtio" type then we can use the ops for both the case of VM and=20
containers.


>>
>>
>>> +
>>> +static int ifcvf_init_msix(struct ifcvf_adapter *adapter)
>>> +{
>>> +=C2=A0=C2=A0=C2=A0 int vector, i, ret, irq;
>>> +=C2=A0=C2=A0=C2=A0 struct pci_dev *pdev =3D to_pci_dev(adapter->dev);
>>> +=C2=A0=C2=A0=C2=A0 struct ifcvf_hw *vf =3D &adapter->vf;
>>> +
>>> +=C2=A0=C2=A0=C2=A0 ret =3D pci_alloc_irq_vectors(pdev, IFCVF_MAX_INTR,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 IFC=
VF_MAX_INTR, PCI_IRQ_MSIX);
>>> +=C2=A0=C2=A0=C2=A0 if (ret < 0) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 IFC_ERR(adapter->dev, "Fail=
ed to alloc irq vectors.\n");
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return ret;
>>> +=C2=A0=C2=A0=C2=A0 }
>>> +
>>> +=C2=A0=C2=A0=C2=A0 for (i =3D 0; i < IFCVF_MAX_QUEUE_PAIRS * 2; i++) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 vector =3D i + IFCVF_MSI_QU=
EUE_OFF;
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 irq =3D pci_irq_vector(pdev=
, vector);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D request_irq(irq, if=
cvf_intr_handler, 0,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 pci_name(pdev), &vf->vring[i]);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 IFC=
_ERR(adapter->dev,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 "Failed to request irq for vq %d.\n", i);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret=
urn ret;
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>> +=C2=A0=C2=A0=C2=A0 }
>>
>>
>> Do we need to provide fallback when we can't do per vq MSIX?
> I think it would be very rarely that can not get enough vectors.


Right.


>>
>>
>>> +
>>> +=C2=A0=C2=A0=C2=A0 return 0;
>>> +}
>>> +
>>> +static void ifcvf_destroy_adapter(struct ifcvf_adapter *adapter)
>>> +{
>>> +=C2=A0=C2=A0=C2=A0 int i, vector, irq;
>>> +=C2=A0=C2=A0=C2=A0 struct ifcvf_hw *vf =3D IFC_PRIVATE_TO_VF(adapter);
>>> +=C2=A0=C2=A0=C2=A0 struct pci_dev *pdev =3D to_pci_dev(adapter->dev);
>>> +
>>> +=C2=A0=C2=A0=C2=A0 for (i =3D 0; i < IFCVF_MAX_QUEUE_PAIRS * 2; i++) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 vector =3D i + IFCVF_MSI_QU=
EUE_OFF;
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 irq =3D pci_irq_vector(pdev=
, vector);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 free_irq(irq, &vf->vring[i]=
);
>>> +=C2=A0=C2=A0=C2=A0 }
>>> +}
>>> +
>>> +static ssize_t name_show(struct kobject *kobj, struct device *dev,=20
>>> char *buf)
>>> +{
>>> +=C2=A0=C2=A0=C2=A0 const char *name =3D "vhost accelerator (virtio rin=
g compatible)";
>>> +
>>> +=C2=A0=C2=A0=C2=A0 return sprintf(buf, "%s\n", name);
>>> +}
>>> +MDEV_TYPE_ATTR_RO(name);
>>> +
>>> +static ssize_t device_api_show(struct kobject *kobj, struct device=20
>>> *dev,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 char *buf)
>>> +{
>>> +=C2=A0=C2=A0=C2=A0 return sprintf(buf, "%s\n", VIRTIO_MDEV_DEVICE_API_=
STRING);
>>> +}
>>> +MDEV_TYPE_ATTR_RO(device_api);
>>> +
>>> +static ssize_t available_instances_show(struct kobject *kobj,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct device *dev, char *buf=
)
>>> +{
>>> +=C2=A0=C2=A0=C2=A0 struct pci_dev *pdev =3D to_pci_dev(dev);
>>> +=C2=A0=C2=A0=C2=A0 struct ifcvf_adapter *adapter =3D pci_get_drvdata(p=
dev);
>>> +
>>> +=C2=A0=C2=A0=C2=A0 return sprintf(buf, "%d\n", adapter->mdev_count);
>>> +}
>>> +
>>> +MDEV_TYPE_ATTR_RO(available_instances);
>>> +
>>> +static ssize_t type_show(struct kobject *kobj,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 str=
uct device *dev, char *buf)
>>> +{
>>> +=C2=A0=C2=A0=C2=A0 return sprintf(buf, "%s\n", "net");
>>> +}
>>> +
>>> +MDEV_TYPE_ATTR_RO(type);
>>> +
>>> +
>>> +static struct attribute *mdev_types_attrs[] =3D {
>>> +=C2=A0=C2=A0=C2=A0 &mdev_type_attr_name.attr,
>>> +=C2=A0=C2=A0=C2=A0 &mdev_type_attr_device_api.attr,
>>> +=C2=A0=C2=A0=C2=A0 &mdev_type_attr_available_instances.attr,
>>> +=C2=A0=C2=A0=C2=A0 &mdev_type_attr_type.attr,
>>> +=C2=A0=C2=A0=C2=A0 NULL,
>>> +};
>>> +
>>> +static struct attribute_group mdev_type_group =3D {
>>> +=C2=A0=C2=A0=C2=A0 .name=C2=A0 =3D "vdpa_virtio",
>>
>>
>> To be consistent, it should be "vhost" or "virtio".
> agreed!
>>
>>
>>> +=C2=A0=C2=A0=C2=A0 .attrs =3D mdev_types_attrs,
>>> +};
>>> +
>>> +static struct attribute_group *mdev_type_groups[] =3D {
>>> +=C2=A0=C2=A0=C2=A0 &mdev_type_group,
>>> +=C2=A0=C2=A0=C2=A0 NULL,
>>> +};
>>> +
>>> +const struct attribute_group *mdev_dev_groups[] =3D {
>>> +=C2=A0=C2=A0=C2=A0 NULL,
>>> +};
>>> +
>>> +static int ifcvf_mdev_create(struct kobject *kobj, struct=20
>>> mdev_device *mdev)
>>> +{
>>> +=C2=A0=C2=A0=C2=A0 struct device *dev =3D mdev_parent_dev(mdev);
>>> +=C2=A0=C2=A0=C2=A0 struct pci_dev *pdev =3D to_pci_dev(dev);
>>> +=C2=A0=C2=A0=C2=A0 struct ifcvf_adapter *adapter =3D pci_get_drvdata(p=
dev);
>>> +=C2=A0=C2=A0=C2=A0 int ret =3D 0;
>>> +
>>> +=C2=A0=C2=A0=C2=A0 mutex_lock(&adapter->mdev_lock);
>>> +
>>> +=C2=A0=C2=A0=C2=A0 if (adapter->mdev_count < 1) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D -EINVAL;
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto out;
>>> +=C2=A0=C2=A0=C2=A0 }
>>> +
>>> +=C2=A0=C2=A0=C2=A0 mdev_set_class_id(mdev, MDEV_ID_VHOST);
>>> +=C2=A0=C2=A0=C2=A0 mdev_set_dev_ops(mdev, &ifc_mdev_ops);
>>> +
>>> +=C2=A0=C2=A0=C2=A0 mdev_set_drvdata(mdev, adapter);
>>> +=C2=A0=C2=A0=C2=A0 mdev_set_iommu_device(mdev_dev(mdev), dev);
>>> +
>>> +=C2=A0=C2=A0=C2=A0 INIT_LIST_HEAD(&adapter->dma_maps);
>>> +=C2=A0=C2=A0=C2=A0 adapter->mdev_count--;
>>> +
>>> +out:
>>> +=C2=A0=C2=A0=C2=A0 mutex_unlock(&adapter->mdev_lock);
>>> +=C2=A0=C2=A0=C2=A0 return ret;
>>> +}
>>> +
>>> +static int ifcvf_mdev_remove(struct mdev_device *mdev)
>>> +{
>>> +=C2=A0=C2=A0=C2=A0 struct device *dev =3D mdev_parent_dev(mdev);
>>> +=C2=A0=C2=A0=C2=A0 struct pci_dev *pdev =3D to_pci_dev(dev);
>>> +=C2=A0=C2=A0=C2=A0 struct ifcvf_adapter *adapter =3D pci_get_drvdata(p=
dev);
>>> +
>>> +=C2=A0=C2=A0=C2=A0 mutex_lock(&adapter->mdev_lock);
>>> +=C2=A0=C2=A0=C2=A0 adapter->mdev_count++;
>>> +=C2=A0=C2=A0=C2=A0 mutex_unlock(&adapter->mdev_lock);
>>> +
>>> +=C2=A0=C2=A0=C2=A0 return 0;
>>> +}
>>> +
>>> +static struct mdev_parent_ops ifcvf_mdev_fops =3D {
>>> +=C2=A0=C2=A0=C2=A0 .owner=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 =3D THIS_MODULE,
>>> +=C2=A0=C2=A0=C2=A0 .supported_type_groups=C2=A0=C2=A0=C2=A0 =3D mdev_t=
ype_groups,
>>> +=C2=A0=C2=A0=C2=A0 .mdev_attr_groups=C2=A0=C2=A0=C2=A0 =3D mdev_dev_gr=
oups,
>>> +=C2=A0=C2=A0=C2=A0 .create=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 =3D ifcvf_mdev_create,
>>> +=C2=A0=C2=A0=C2=A0 .remove=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 =3D ifcvf_mdev_remove,
>>> +};
>>> +
>>> +static int ifcvf_probe(struct pci_dev *pdev, const struct=20
>>> pci_device_id *id)
>>> +{
>>> +=C2=A0=C2=A0=C2=A0 struct device *dev =3D &pdev->dev;
>>> +=C2=A0=C2=A0=C2=A0 struct ifcvf_adapter *adapter;
>>> +=C2=A0=C2=A0=C2=A0 struct ifcvf_hw *vf;
>>> +=C2=A0=C2=A0=C2=A0 int ret, i;
>>> +
>>> +=C2=A0=C2=A0=C2=A0 adapter =3D kzalloc(sizeof(struct ifcvf_adapter), G=
FP_KERNEL);
>>> +=C2=A0=C2=A0=C2=A0 if (adapter =3D=3D NULL) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D -ENOMEM;
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto fail;
>>> +=C2=A0=C2=A0=C2=A0 }
>>> +
>>> +=C2=A0=C2=A0=C2=A0 mutex_init(&adapter->mdev_lock);
>>> +=C2=A0=C2=A0=C2=A0 adapter->mdev_count =3D 1;
>>
>>
>> So this is per VF based vDPA implementation, which seems not=20
>> convenient for management.=C2=A0 Anyhow we can control the creation in P=
F?
>>
>> Thanks
> the driver scope for now doesn't support that, we can add these=20
> feature in next releases.


Not a must for this series, but to have a better interaction with=20
management like libvirt, it's better.

Btw, do you have the plan to post PF drivers?

Thanks


