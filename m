Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53143F0520
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 19:34:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390612AbfKESeH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 13:34:07 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:47965 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2390571AbfKESeH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 13:34:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572978846;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H9feM4A9AfoDIHKTuN0rynXXPyED946lrCjOtbhrTDw=;
        b=fyAhyk3Onwb2GiEfmRvlfSVxRiWKmRCu5SE3+k7sxk9NDiZehL0/B81n0msvxmpnZ7q8Ir
        2KxVPV2sUtZjpcTsPdHuo78MiGyI7iGlReM8VylGioh3vCTLdYU8YRDZmJb+gIfJeb7h37
        YqACcVZumzvbczGHfq0exOAwjMRb5SU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-230-wKB1DIDFPlmgljNYjH5vkw-1; Tue, 05 Nov 2019 13:34:02 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0F8751800D4A;
        Tue,  5 Nov 2019 18:33:58 +0000 (UTC)
Received: from gondolin (unknown [10.36.118.27])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9D4395D9C9;
        Tue,  5 Nov 2019 18:33:39 +0000 (UTC)
Date:   Tue, 5 Nov 2019 19:33:36 +0100
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
Subject: Re: [PATCH V8 5/6] virtio: introduce a mdev based transport
Message-ID: <20191105193336.570e8e3a.cohuck@redhat.com>
In-Reply-To: <20191105093240.5135-6-jasowang@redhat.com>
References: <20191105093240.5135-1-jasowang@redhat.com>
        <20191105093240.5135-6-jasowang@redhat.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: wKB1DIDFPlmgljNYjH5vkw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  5 Nov 2019 17:32:39 +0800
Jason Wang <jasowang@redhat.com> wrote:

> This patch introduces a new mdev transport for virtio. This is used to
> use kernel virtio driver to drive the mediated device that is capable
> of populating virtqueue directly.
>=20
> A new virtio-mdev driver will be registered to the mdev bus, when a
> new virtio-mdev device is probed, it will register the device with
> mdev based config ops. This means it is a software transport between
> mdev driver and mdev device. The transport was implemented through
> device specific ops which is a part of mdev_parent_ops now.
>=20
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  drivers/virtio/Kconfig       |   7 +
>  drivers/virtio/Makefile      |   1 +
>  drivers/virtio/virtio_mdev.c | 407 +++++++++++++++++++++++++++++++++++
>  3 files changed, 415 insertions(+)
>  create mode 100644 drivers/virtio/virtio_mdev.c

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

