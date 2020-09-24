Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9828D276E72
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 12:17:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727375AbgIXKRf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 06:17:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:48653 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726818AbgIXKRd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 06:17:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600942651;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ORL76fhl426t9LBfvBEBRXRu6hVyw1ffJIy0ygUo/8M=;
        b=VHM7Aa6cttko5FrG8Cm/nYJ4NUHwwvn1xT67bKxO4ACYnii6VCx72BrspcuaxmWGgp2EfI
        7+fQOlqDxyvqacVIVRMyRmjcK3x9Nh8w1GmTJTgY/UjJmkEkKVtyd48Rio+M9J7IY7JQUU
        mbQ3eTO9/ujEV/oEqacHScvQpEqekw0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-136-HUuXQv_VMmKI01zE3R3vfA-1; Thu, 24 Sep 2020 06:17:29 -0400
X-MC-Unique: HUuXQv_VMmKI01zE3R3vfA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2B158107465D;
        Thu, 24 Sep 2020 10:17:28 +0000 (UTC)
Received: from localhost (ovpn-114-133.ams2.redhat.com [10.36.114.133])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 95B065D990;
        Thu, 24 Sep 2020 10:17:21 +0000 (UTC)
Date:   Thu, 24 Sep 2020 11:17:20 +0100
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     mst@redhat.com, lulu@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, rob.miller@broadcom.com,
        lingshan.zhu@intel.com, eperezma@redhat.com, hanand@xilinx.com,
        mhabets@solarflare.com, eli@mellanox.com, amorenoz@redhat.com,
        maxime.coquelin@redhat.com, sgarzare@redhat.com
Subject: Re: [RFC PATCH 00/24] Control VQ support in vDPA
Message-ID: <20200924101720.GR62770@stefanha-x1.localdomain>
References: <20200924032125.18619-1-jasowang@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20200924032125.18619-1-jasowang@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=stefanha@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="sxhug0Teuf3tiWmo"
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--sxhug0Teuf3tiWmo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 24, 2020 at 11:21:01AM +0800, Jason Wang wrote:
> This series tries to add the support for control virtqueue in vDPA.

Please include documentation for both driver authors and vhost-vdpa
ioctl users. vhost-vdpa ioctls are only documented with a single
sentence. Please add full information on arguments, return values, and a
high-level explanation of the feature (like this cover letter) to
introduce the API.

What is the policy for using virtqueue groups? My guess is:
1. virtio_vdpa simply enables all virtqueue groups.
2. vhost_vdpa relies on userspace policy on how to use virtqueue groups.
   Are the semantics of virtqueue groups documented somewhere so
   userspace knows what to do? If a vDPA driver author decides to create
   N virtqueue groups, N/2 virtqueue groups, or just 1 virtqueue group,
   how will userspace know what to do?

Maybe a document is needed to describe the recommended device-specific
virtqueue groups that vDPA drivers should implement (e.g. "put the net
control vq into its own virtqueue group")?

This could become messy with guidelines. For example, drivers might be
shipped that aren't usable for certain use cases just because the author
didn't know that a certain virtqueue grouping is advantageous.

BTW I like how general this feature is. It seems to allow vDPA devices
to be split into sub-devices for further passthrough. Who will write the
first vDPA-on-vDPA driver? :)

Stefan

--sxhug0Teuf3tiWmo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl9scjAACgkQnKSrs4Gr
c8g9gAgAsbQIA1ltN83b43L8ktGIqTkaBbgUY8qGUDhwkNGWmCp359eeVlWQpt4P
BtPsvuYFXv1eo5/EhiiWzKFZdP/q9pZ0I+BKvMtJ5kZ24KHVSG81nA+lrteSa4Xi
uNX5DZFX+D9QRJwSuH+IPW5Q9tVP40nkZm6wqE7NYmM2UDspkchA+Jn9+ekdfcXv
O3OEP7kgYb9Rv3OyRJ5lHzETfE8VBd45xm5G9QuiojYmBnS5b5jJGKcHyr7sc4I6
547J/3Xq9Hrp/JwivlmcHdPyQgTn4Xz/tzcpDUBa/KdF7J4v0djKtX3JSxMU3jGI
9lOAiZipWprTMyNjT6fuZpiuqHcniA==
=8jGt
-----END PGP SIGNATURE-----

--sxhug0Teuf3tiWmo--

