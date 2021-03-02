Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8584632B386
	for <lists+netdev@lfdr.de>; Wed,  3 Mar 2021 05:09:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449597AbhCCEBC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 23:01:02 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:37350 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1446818AbhCBMNa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Mar 2021 07:13:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614687122;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LGBva5DKxG/huAqoNDsaExI9eBFrJH4w3rCGjKd3xQk=;
        b=Dld80zAt12QO22T29W0FQZ3qJzciuN+Yperghd4mrKI8mR88cY9WZ9WYa6TvREz+mykPGG
        81MzBhZ1ujZQgO9kEXLGEbHGikiHUBP4X5ePfNKHTucEJ8ZKcx0NQftbDTYN69OaRC0Ww9
        m1Kod6f7E0NaAVrDHalsWmYX6cP5f50=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-50-i0WMWG6vPjGrowIkJsoFNQ-1; Tue, 02 Mar 2021 07:08:21 -0500
X-MC-Unique: i0WMWG6vPjGrowIkJsoFNQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D6FEA1868408;
        Tue,  2 Mar 2021 12:08:19 +0000 (UTC)
Received: from gondolin (ovpn-113-150.ams2.redhat.com [10.36.113.150])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0C84C60C05;
        Tue,  2 Mar 2021 12:08:14 +0000 (UTC)
Date:   Tue, 2 Mar 2021 13:08:12 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>, elic@nvidia.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        virtio-dev@lists.oasis-open.org
Subject: Re: [virtio-dev] Re: [PATCH] vdpa/mlx5: set_features should allow
 reset to zero
Message-ID: <20210302130812.6227f176.cohuck@redhat.com>
In-Reply-To: <cdd72199-ac7b-cc8d-2c40-81e43162c532@redhat.com>
References: <20210223041740-mutt-send-email-mst@kernel.org>
        <788a0880-0a68-20b7-5bdf-f8150b08276a@redhat.com>
        <20210223110430.2f098bc0.cohuck@redhat.com>
        <bbb0a09e-17e1-a397-1b64-6ce9afe18e44@redhat.com>
        <20210223115833.732d809c.cohuck@redhat.com>
        <8355f9b3-4cda-cd2e-98df-fed020193008@redhat.com>
        <20210224121234.0127ae4b.cohuck@redhat.com>
        <be6713d3-ac98-bbbf-1dc1-a003ed06a156@redhat.com>
        <20210225135229-mutt-send-email-mst@kernel.org>
        <0f8eb381-cc98-9e05-0e35-ccdb1cbd6119@redhat.com>
        <20210228162306-mutt-send-email-mst@kernel.org>
        <cdd72199-ac7b-cc8d-2c40-81e43162c532@redhat.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 1 Mar 2021 11:51:08 +0800
Jason Wang <jasowang@redhat.com> wrote:

> On 2021/3/1 5:25 =E4=B8=8A=E5=8D=88, Michael S. Tsirkin wrote:
> > On Fri, Feb 26, 2021 at 04:19:16PM +0800, Jason Wang wrote: =20
> >> On 2021/2/26 2:53 =E4=B8=8A=E5=8D=88, Michael S. Tsirkin wrote: =20

> >>> Confused. What is wrong with the above? It never reads the
> >>> field unless the feature has been offered by device. =20
> >>
> >> So the spec said:
> >>
> >> "
> >>
> >> The following driver-read-only field, max_virtqueue_pairs only exists =
if
> >> VIRTIO_NET_F_MQ is set.
> >>
> >> "
> >>
> >> If I read this correctly, there will be no max_virtqueue_pairs field i=
f the
> >> VIRTIO_NET_F_MQ is not offered by device? If yes the offsetof() violat=
es
> >> what spec said.
> >>
> >> Thanks =20
> > I think that's a misunderstanding. This text was never intended to
> > imply that field offsets change beased on feature bits.
> > We had this pain with legacy and we never wanted to go back there.
> >
> > This merely implies that without VIRTIO_NET_F_MQ the field
> > should not be accessed. Exists in the sense "is accessible to driver".
> >
> > Let's just clarify that in the spec, job done. =20
>=20
>=20
> Ok, agree. That will make things more eaiser.

Yes, that makes much more sense.

What about adding the following to the "Basic Facilities of a Virtio
Device/Device Configuration Space" section of the spec:

"If an optional configuration field does not exist, the corresponding
space is still present, but reserved."

(Do we need to specify what a device needs to do if the driver tries to
access a non-existing field? We cannot really make assumptions about
config space accesses; virtio-ccw can just copy a chunk of config space
that contains non-existing fields... I guess the device could ignore
writes and return zeroes on read?)

I've opened https://github.com/oasis-tcs/virtio-spec/issues/98 for the
spec issues.

