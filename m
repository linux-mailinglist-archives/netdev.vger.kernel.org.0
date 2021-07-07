Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E8183BE4BD
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 10:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231259AbhGGIzp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 04:55:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26497 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230495AbhGGIzo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 04:55:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625647984;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RSGta0qNpB6QcJ/llRMjKtAhvAPIvAnC+iGh3rJx/qg=;
        b=hJtnXPMJIcE5o8NZgK0nnNYUwrB/6eLhIX1CQcKNw/EZqNPt4cXqHG8in8yY7OfXwdXMBD
        EFxLHaFVFpjcbkSXbtajKDTSiRScTnwz4QbCpTZiB2IlygToNIGPMsyN7ChEM7ITdTNSGy
        r1dwppbklqiEsBN/O6dKbYXg1Yvoo4w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-68-v1nUrO-5Ov24IW-5AspE9w-1; Wed, 07 Jul 2021 04:53:03 -0400
X-MC-Unique: v1nUrO-5Ov24IW-5AspE9w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4831F1800D41;
        Wed,  7 Jul 2021 08:53:00 +0000 (UTC)
Received: from localhost (ovpn-114-152.ams2.redhat.com [10.36.114.152])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A3E7719C44;
        Wed,  7 Jul 2021 08:52:55 +0000 (UTC)
Date:   Wed, 7 Jul 2021 09:52:54 +0100
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Xie Yongji <xieyongji@bytedance.com>
Cc:     mst@redhat.com, jasowang@redhat.com, sgarzare@redhat.com,
        parav@nvidia.com, hch@infradead.org,
        christian.brauner@canonical.com, rdunlap@infradead.org,
        willy@infradead.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
        bcrl@kvack.org, corbet@lwn.net, mika.penttila@nextfour.com,
        dan.carpenter@oracle.com, joro@8bytes.org,
        gregkh@linuxfoundation.org, songmuchun@bytedance.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 09/10] vduse: Introduce VDUSE - vDPA Device in
 Userspace
Message-ID: <YOVrZtGIEjZZSSoU@stefanha-x1.localdomain>
References: <20210615141331.407-1-xieyongji@bytedance.com>
 <20210615141331.407-10-xieyongji@bytedance.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="FCq4Eu07/ej1hAmI"
Content-Disposition: inline
In-Reply-To: <20210615141331.407-10-xieyongji@bytedance.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--FCq4Eu07/ej1hAmI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 15, 2021 at 10:13:30PM +0800, Xie Yongji wrote:
> +static bool vduse_validate_config(struct vduse_dev_config *config)
> +{

The name field needs to be NUL terminated?

> +	case VDUSE_CREATE_DEV: {
> +		struct vduse_dev_config config;
> +		unsigned long size = offsetof(struct vduse_dev_config, config);
> +		void *buf;
> +
> +		ret = -EFAULT;
> +		if (copy_from_user(&config, argp, size))
> +			break;
> +
> +		ret = -EINVAL;
> +		if (vduse_validate_config(&config) == false)
> +			break;
> +
> +		buf = vmemdup_user(argp + size, config.config_size);
> +		if (IS_ERR(buf)) {
> +			ret = PTR_ERR(buf);
> +			break;
> +		}
> +		ret = vduse_create_dev(&config, buf, control->api_version);
> +		break;
> +	}
> +	case VDUSE_DESTROY_DEV: {
> +		char name[VDUSE_NAME_MAX];
> +
> +		ret = -EFAULT;
> +		if (copy_from_user(name, argp, VDUSE_NAME_MAX))
> +			break;

Is this missing a NUL terminator?

--FCq4Eu07/ej1hAmI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmDla2YACgkQnKSrs4Gr
c8iwDwgAklDinwoNdcTKlrJAeuzd7lkg6g0pp6GgPOoSoPbIEzizyjezLIi98oHV
vF5TkSJ9SmhwrTkrfniJQf7czNd+oWvB/PeLW+YOTNYnHkS4AlS4z4/Z48sAiees
bjx0y6rK8AKEd1d2F5lOEbHr1hyPAEuA5j1trgrHzaUhKLKiRfCYQI0mJIaWYUTT
5AJ6lKidGWNOayzU4/GQ+PfEPahMie3/T2g+ivR4j0E6YLNvJs7CFFerZYRNGLXQ
D5MqzXxvgHF75J7QuXmOOYTRhRMzWoYI4K6EfwzZJHWIJrBhVeXogKJ0Z4tnp82W
f66VauRbMPZNCJ5g0gXGzczBzlXh0A==
=aR1n
-----END PGP SIGNATURE-----

--FCq4Eu07/ej1hAmI--

