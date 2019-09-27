Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C7DAC014E
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 10:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726144AbfI0Ihh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 04:37:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33376 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725946AbfI0Ihg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Sep 2019 04:37:36 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 38C8EC05AA52;
        Fri, 27 Sep 2019 08:37:36 +0000 (UTC)
Received: from [10.72.12.30] (ovpn-12-30.pek2.redhat.com [10.72.12.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 18629600C6;
        Fri, 27 Sep 2019 08:37:08 +0000 (UTC)
Subject: Re: [PATCH V2 6/8] mdev: introduce virtio device and its device ops
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org, kwankhede@nvidia.com,
        mst@redhat.com, tiwei.bie@intel.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        cohuck@redhat.com, maxime.coquelin@redhat.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        rob.miller@broadcom.com, xiao.w.wang@intel.com,
        haotian.wang@sifive.com, zhenyuw@linux.intel.com,
        zhi.a.wang@intel.com, jani.nikula@linux.intel.com,
        joonas.lahtinen@linux.intel.com, rodrigo.vivi@intel.com,
        airlied@linux.ie, daniel@ffwll.ch, farman@linux.ibm.com,
        pasic@linux.ibm.com, sebott@linux.ibm.com, oberpar@linux.ibm.com,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com,
        borntraeger@de.ibm.com, akrowiak@linux.ibm.com,
        freude@linux.ibm.com, lingshan.zhu@intel.com, idos@mellanox.com,
        eperezma@redhat.com, lulu@redhat.com, parav@mellanox.com,
        christophe.de.dinechin@gmail.com, kevin.tian@intel.com
References: <20190924135332.14160-1-jasowang@redhat.com>
 <20190924135332.14160-7-jasowang@redhat.com>
 <20190924170640.1da03bae@x1.home>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <baa742f5-8d4e-f1f1-1194-f362cdf51fea@redhat.com>
Date:   Fri, 27 Sep 2019 16:37:06 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190924170640.1da03bae@x1.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Fri, 27 Sep 2019 08:37:36 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/9/25 上午7:06, Alex Williamson wrote:
> On Tue, 24 Sep 2019 21:53:30 +0800
> Jason Wang<jasowang@redhat.com>  wrote:
>
>> This patch implements basic support for mdev driver that supports
>> virtio transport for kernel virtio driver.
>>
>> Signed-off-by: Jason Wang<jasowang@redhat.com>
>> ---
>>   include/linux/mdev.h        |   2 +
>>   include/linux/virtio_mdev.h | 145 ++++++++++++++++++++++++++++++++++++
>>   2 files changed, 147 insertions(+)
>>   create mode 100644 include/linux/virtio_mdev.h
>>
>> diff --git a/include/linux/mdev.h b/include/linux/mdev.h
>> index 3414307311f1..73ac27b3b868 100644
>> --- a/include/linux/mdev.h
>> +++ b/include/linux/mdev.h
>> @@ -126,6 +126,8 @@ struct mdev_device *mdev_from_dev(struct device *dev);
>>   
>>   enum {
>>   	MDEV_ID_VFIO = 1,
>> +	MDEV_ID_VIRTIO = 2,
>> +	MDEV_ID_VHOST = 3,
> MDEV_ID_VHOST isn't used yet here.  Also, given the strong
> interdependence between the class_id and the ops structure, we might
> wand to define them in the same place.  Thanks,
>
> Alex
>

Rethink about this,  I believe it's better to define the device ops in 
their own headers, and one set of device ops could be used for two 
classes (e.g both virtio and vhost). And to avoid a duplicated ID 
definition. I tend to keep this in the common mdev.h header.

Thanks

