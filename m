Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94321F0391
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 17:58:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390301AbfKEQ6B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 11:58:01 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:20946 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388836AbfKEQ6A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 11:58:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572973079;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=W8k8y0xwvZYiGfN3jpSGfUUS3E/00qqxgsKSLEHx8lY=;
        b=dqI6iO8HNEnUpxsiECHrllUxoM6yJL7z6VxE1LFyMpFeFZsp5XhaYNwYDQPcusxfMNULbD
        3c/ya7FLyyxFhxCnQr6G6AT78NYy8qD76uIQmcri9Se4ojqchS+EGzOv+PMvtEekTwqzvg
        HvffQhjzQfc7EpWn7U/rzGJ7gYRr36Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-236-Qp3HxU0YNEujQ2UorNEKXw-1; Tue, 05 Nov 2019 11:57:56 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7A7608017DE;
        Tue,  5 Nov 2019 16:57:52 +0000 (UTC)
Received: from gondolin (unknown [10.36.118.27])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A3A9B5C1D8;
        Tue,  5 Nov 2019 16:57:26 +0000 (UTC)
Date:   Tue, 5 Nov 2019 17:57:24 +0100
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
Subject: Re: [PATCH V8 4/6] mdev: introduce virtio device and its device ops
Message-ID: <20191105175724.0c52784e.cohuck@redhat.com>
In-Reply-To: <20191105093240.5135-5-jasowang@redhat.com>
References: <20191105093240.5135-1-jasowang@redhat.com>
        <20191105093240.5135-5-jasowang@redhat.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: Qp3HxU0YNEujQ2UorNEKXw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  5 Nov 2019 17:32:38 +0800
Jason Wang <jasowang@redhat.com> wrote:

> This patch implements basic support for mdev driver that supports
> virtio transport for kernel virtio driver.
>=20
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  drivers/vfio/mdev/mdev_core.c    |  21 +++++
>  drivers/vfio/mdev/mdev_private.h |   2 +
>  include/linux/mdev.h             |   6 ++
>  include/linux/mdev_virtio_ops.h  | 149 +++++++++++++++++++++++++++++++
>  4 files changed, 178 insertions(+)
>  create mode 100644 include/linux/mdev_virtio_ops.h

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

