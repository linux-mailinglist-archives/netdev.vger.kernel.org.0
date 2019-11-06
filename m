Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E727F0D5F
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 04:53:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730946AbfKFDxp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 22:53:45 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:41158 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727266AbfKFDxp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 22:53:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573012424;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EaTbE+HmGj8bDfQK0HMuk+gfERcklzcbJD+zUHMoips=;
        b=LhNflBN+PrTgQwEkL5Fd+8csaEcGKVVgVJyT/E2WhSNoe/4Xq9E9s0/bHJ6MQjkG+VMp97
        xhmbxHnS59znS1kq0xxCIK+xeZeuSWAZ94liz7ydU08yqOlngCjacqI2zd66n+y6YwINos
        GSALM/6JGyHZTvtK99s2/CmavTMxiF0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-41-s3GVRo2xO9Kh53Br-bjUiw-1; Tue, 05 Nov 2019 22:53:41 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EE2061005500;
        Wed,  6 Nov 2019 03:53:36 +0000 (UTC)
Received: from [10.72.12.193] (ovpn-12-193.pek2.redhat.com [10.72.12.193])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 16874600C6;
        Wed,  6 Nov 2019 03:51:35 +0000 (UTC)
Subject: Re: [PATCH V8 4/6] mdev: introduce virtio device and its device ops
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
        christophe.de.dinechin@gmail.com, kevin.tian@intel.com,
        stefanha@redhat.com
References: <20191105093240.5135-1-jasowang@redhat.com>
 <20191105093240.5135-5-jasowang@redhat.com> <20191105104710.16d0f629@x1.home>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <0de9abaf-d740-f4c7-50ff-3bd68a50ab40@redhat.com>
Date:   Wed, 6 Nov 2019 11:51:33 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191105104710.16d0f629@x1.home>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: s3GVRo2xO9Kh53Br-bjUiw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/11/6 =E4=B8=8A=E5=8D=881:47, Alex Williamson wrote:
>> +#define VIRTIO_MDEV_DEVICE_API_STRING=09=09"virtio-mdev"
>> +#define VIRTIO_MDEV_F_VERSION_1 0x1
> This entire concept of VIRTIO_MDEV_F_VERSION_1 is gone now, right?
> Let's remove it here and below.  Thanks,
>
> Alex
>

Yes, will fix.

Thanks

