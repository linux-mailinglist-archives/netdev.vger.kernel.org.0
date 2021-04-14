Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51EF235F601
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 16:22:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344300AbhDNOPa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 10:15:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26224 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231158AbhDNOP2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 10:15:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618409706;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4JOWJDfwxWBSnU6F6WuBZ7JaBtVqAeLmps6k0L0IgMY=;
        b=GF/QPzK+qMvJyHjnq8FfhNxd74nCV9ODUn7R9z/cg1wkjSFCt0DtgKEYpxrPzHuYPuWmH5
        Xs1zaBZCVFbbMCtf9NhbHm7Ia3Fb5pUZe34zTKgDVPwXV/Lc0z/cLPBbTGSgbJOP5KdlSq
        FpjjKAOBI3oX9JqoGqZ25+vEcOhF+Qc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-501-f5b934_WPZSsjss-1GwwtA-1; Wed, 14 Apr 2021 10:15:02 -0400
X-MC-Unique: f5b934_WPZSsjss-1GwwtA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D2315107ACE4;
        Wed, 14 Apr 2021 14:14:59 +0000 (UTC)
Received: from localhost (ovpn-114-209.ams2.redhat.com [10.36.114.209])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 05A8319C78;
        Wed, 14 Apr 2021 14:14:58 +0000 (UTC)
Date:   Wed, 14 Apr 2021 15:14:57 +0100
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Xie Yongji <xieyongji@bytedance.com>
Cc:     mst@redhat.com, jasowang@redhat.com, sgarzare@redhat.com,
        parav@nvidia.com, hch@infradead.org,
        christian.brauner@canonical.com, rdunlap@infradead.org,
        willy@infradead.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
        bcrl@kvack.org, corbet@lwn.net, mika.penttila@nextfour.com,
        dan.carpenter@oracle.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v6 10/10] Documentation: Add documentation for VDUSE
Message-ID: <YHb44R4HyLEUVSTF@stefanha-x1.localdomain>
References: <20210331080519.172-1-xieyongji@bytedance.com>
 <20210331080519.172-11-xieyongji@bytedance.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="+8CNRb8u7kJfIjoT"
Content-Disposition: inline
In-Reply-To: <20210331080519.172-11-xieyongji@bytedance.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--+8CNRb8u7kJfIjoT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 31, 2021 at 04:05:19PM +0800, Xie Yongji wrote:
> VDUSE (vDPA Device in Userspace) is a framework to support
> implementing software-emulated vDPA devices in userspace. This
> document is intended to clarify the VDUSE design and usage.
>=20
> Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> ---
>  Documentation/userspace-api/index.rst |   1 +
>  Documentation/userspace-api/vduse.rst | 212 ++++++++++++++++++++++++++++=
++++++
>  2 files changed, 213 insertions(+)
>  create mode 100644 Documentation/userspace-api/vduse.rst

Just looking over the documentation briefly (I haven't studied the code
yet)...

> +How VDUSE works
> +------------
> +Each userspace vDPA device is created by the VDUSE_CREATE_DEV ioctl on
> +the character device (/dev/vduse/control). Then a device file with the
> +specified name (/dev/vduse/$NAME) will appear, which can be used to
> +implement the userspace vDPA device's control path and data path.

These steps are taken after sending the VDPA_CMD_DEV_NEW netlink
message? (Please consider reordering the documentation to make it clear
what the sequence of steps are.)

> +	static int netlink_add_vduse(const char *name, int device_id)
> +	{
> +		struct nl_sock *nlsock;
> +		struct nl_msg *msg;
> +		int famid;
> +
> +		nlsock =3D nl_socket_alloc();
> +		if (!nlsock)
> +			return -ENOMEM;
> +
> +		if (genl_connect(nlsock))
> +			goto free_sock;
> +
> +		famid =3D genl_ctrl_resolve(nlsock, VDPA_GENL_NAME);
> +		if (famid < 0)
> +			goto close_sock;
> +
> +		msg =3D nlmsg_alloc();
> +		if (!msg)
> +			goto close_sock;
> +
> +		if (!genlmsg_put(msg, NL_AUTO_PORT, NL_AUTO_SEQ, famid, 0, 0,
> +		    VDPA_CMD_DEV_NEW, 0))
> +			goto nla_put_failure;
> +
> +		NLA_PUT_STRING(msg, VDPA_ATTR_DEV_NAME, name);
> +		NLA_PUT_STRING(msg, VDPA_ATTR_MGMTDEV_DEV_NAME, "vduse");
> +		NLA_PUT_U32(msg, VDPA_ATTR_DEV_ID, device_id);

What are the permission/capability requirements for VDUSE?

How does VDUSE interact with namespaces?

What is the meaning of VDPA_ATTR_DEV_ID? I don't see it in Linux
v5.12-rc6 drivers/vdpa/vdpa.c:vdpa_nl_cmd_dev_add_set_doit().

> +MMU-based IOMMU Driver
> +----------------------
> +VDUSE framework implements an MMU-based on-chip IOMMU driver to support
> +mapping the kernel DMA buffer into the userspace iova region dynamically.
> +This is mainly designed for virtio-vdpa case (kernel virtio drivers).
> +
> +The basic idea behind this driver is treating MMU (VA->PA) as IOMMU (IOV=
A->PA).
> +The driver will set up MMU mapping instead of IOMMU mapping for the DMA =
transfer
> +so that the userspace process is able to use its virtual address to acce=
ss
> +the DMA buffer in kernel.
> +
> +And to avoid security issue, a bounce-buffering mechanism is introduced =
to
> +prevent userspace accessing the original buffer directly which may conta=
in other
> +kernel data. During the mapping, unmapping, the driver will copy the dat=
a from
> +the original buffer to the bounce buffer and back, depending on the dire=
ction of
> +the transfer. And the bounce-buffer addresses will be mapped into the us=
er address
> +space instead of the original one.

Is mmap(2) the right interface if memory is not actually shared, why not
just use pread(2)/pwrite(2) to make the copy explicit? That way the copy
semantics are clear. For example, don't expect to be able to busy wait
on the memory because changes will not be visible to the other side.

(I guess I'm missing something here and that mmap(2) is the right
approach, but maybe this documentation section can be clarified.)

--+8CNRb8u7kJfIjoT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmB2+OEACgkQnKSrs4Gr
c8jpugf+NHnGf6o2QvHFiSjjcoe0QPBmiySO4mz+2/oqmyL0YElWKcuyJJ16uxOx
p1SCMSYhoSE4EVZ1zWXMy18X6Lc3WjfU5s4dyo1dy4qrumXxGDj8Q93Togh8UL1Q
URNKuVbUBZp8anAt5KUXQt+fW/kw6luipS8XDrpszHN1mGVPrs8o0oORCwcD/8u9
95gfUL+acvkfocg6F//QpNUi1/BE7F6iTTRJhZ0UG0GHaVeJ/U0D7z0NrnaZLpgP
VPBvWxdqfOwiX3ABCVHIS18tafCmkLfadpmH0dxwZgVIC/hmE0gs96/7tDhQqZLg
1RAejoIQX/MqVpzh3XGHjGqnDW8e6w==
=hqt0
-----END PGP SIGNATURE-----

--+8CNRb8u7kJfIjoT--

