Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00DA9F1842
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 15:17:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731835AbfKFORE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 09:17:04 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:35729 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730577AbfKFORE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 09:17:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573049823;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ER/WquWBpU7PunGVOI/swL9aOZ32qLf8hTv9Vd0HUN0=;
        b=K5C8nkI56OkAcoj9twh1LjAQV4fRlomAPzQEvTMAkaZJMTjsIC3gGXhwOERomTqWE9zDd4
        2fYmRhI6Kb/dAWuaHtBlrkqUvXaxiPxvAttKWCLkDpaH1sNEQx8nVltqBrUdej2IO+3/zK
        lhJF7todK2to4K7dbs5zChnSCptTpGc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-23-I-KaKfnbOz6RjNvb_LV7Ig-1; Wed, 06 Nov 2019 09:16:59 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A78B3477;
        Wed,  6 Nov 2019 14:16:55 +0000 (UTC)
Received: from gondolin (dhcp-192-218.str.redhat.com [10.33.192.218])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BD5815D70D;
        Wed,  6 Nov 2019 14:16:37 +0000 (UTC)
Date:   Wed, 6 Nov 2019 15:16:35 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org, kwankhede@nvidia.com,
        alex.williamson@redhat.com, mst@redhat.com, tiwei.bie@intel.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        maxime.coquelin@redhat.com, cunming.liang@intel.com,
        zhihong.wang@intel.com, rob.miller@broadcom.com,
        xiao.w.wang@intel.com, haotian.wang@sifive.com,
        zhenyuw@linux.intel.com, zhi.a.wang@intel.com,
        jani.nikula@linux.intel.com, joonas.lahtinen@linux.intel.com,
        rodrigo.vivi@intel.com, airlied@linux.ie, daniel@ffwll.ch,
        farman@linux.ibm.com, pasic@linux.ibm.com, sebott@linux.ibm.com,
        oberpar@linux.ibm.com, heiko.carstens@de.ibm.com,
        gor@linux.ibm.com, borntraeger@de.ibm.com, akrowiak@linux.ibm.com,
        freude@linux.ibm.com, lingshan.zhu@intel.com, idos@mellanox.com,
        eperezma@redhat.com, lulu@redhat.com, parav@mellanox.com,
        christophe.de.dinechin@gmail.com, kevin.tian@intel.com,
        stefanha@redhat.com
Subject: Re: [PATCH V10 0/6] mdev based hardware virtio offloading support
Message-ID: <20191106151635.0d1cb3bc.cohuck@redhat.com>
In-Reply-To: <20191106133531.693-1-jasowang@redhat.com>
References: <20191106133531.693-1-jasowang@redhat.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: I-KaKfnbOz6RjNvb_LV7Ig-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  6 Nov 2019 21:35:25 +0800
Jason Wang <jasowang@redhat.com> wrote:

> Hi all:
>=20
> There are hardwares that can do virtio datapath offloading while
> having its own control path. This path tries to implement a mdev based
> unified API to support using kernel virtio driver to drive those
> devices. This is done by introducing a new mdev transport for virtio
> (virtio_mdev) and register itself as a new kind of mdev driver. Then
> it provides a unified way for kernel virtio driver to talk with mdev
> device implementation.
>=20
> Though the series only contains kernel driver support, the goal is to
> make the transport generic enough to support userspace drivers. This
> means vhost-mdev[1] could be built on top as well by resuing the
> transport.
>=20
> A sample driver is also implemented which simulate a virito-net
> loopback ethernet device on top of vringh + workqueue. This could be
> used as a reference implementation for real hardware driver.
>=20
> Also a real IFC VF driver was also posted here[2] which is a good
> reference for vendors who is interested in their own virtio datapath
> offloading product.
>=20
> Consider mdev framework only support VFIO device and driver right now,
> this series also extend it to support other types. This is done
> through introducing class id to the device and pairing it with
> id_talbe claimed by the driver. On top, this seris also decouple
> device specific ops out of the common ones for implementing class
> specific operations over mdev bus.
>=20
> Pktgen test was done with virito-net + mvnet loop back device.
>=20
> Please review.

All looking good to me now.

>=20
> [1] https://lkml.org/lkml/2019/11/5/424
> [2] https://lkml.org/lkml/2019/11/5/227

