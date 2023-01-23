Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4235E678A86
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 23:13:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233122AbjAWWNk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 17:13:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233180AbjAWWNL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 17:13:11 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB6B739BB9
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 14:11:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674511896;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lvUmurC9HOodDs2LaRkp+R+qT18zMiP3C2WK1UkBQdM=;
        b=ItZgT6QPp68KTAVibaTP4znhV+bC7K013rBJRU8Yc/9zoj0lZg5cIdFm13DSBMJXJukJS3
        uAVCm2eQ09oq83ymspjwbDMMM3+YJZf/S/N5FNV8s+79IsrJzYTsZ8sVK9tJpXWCSE/enQ
        aRFFnzRnp534pTunriBH4AtJBDvxAhE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-452--3poGQaqMM66JfqihUnbzw-1; Mon, 23 Jan 2023 17:11:33 -0500
X-MC-Unique: -3poGQaqMM66JfqihUnbzw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8DF1F3C22745;
        Mon, 23 Jan 2023 22:11:32 +0000 (UTC)
Received: from localhost (unknown [10.39.193.206])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F2C8F492C3C;
        Mon, 23 Jan 2023 22:11:31 +0000 (UTC)
Date:   Mon, 23 Jan 2023 17:11:30 -0500
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     mst@redhat.com, pbonzini@redhat.com, bcodding@redhat.com,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: Re: [PATCH V2] vhost-scsi: unbreak any layout for response
Message-ID: <Y88GEm63Tsg1AAu4@fedora>
References: <20230119073647.76467-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="vqhw79aaCtf0o+Pf"
Content-Disposition: inline
In-Reply-To: <20230119073647.76467-1-jasowang@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--vqhw79aaCtf0o+Pf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 19, 2023 at 03:36:47PM +0800, Jason Wang wrote:
> Al Viro said:
>=20
> """
> Since "vhost/scsi: fix reuse of &vq->iov[out] in response"
> we have this:
>                 cmd->tvc_resp_iov =3D vq->iov[vc.out];
>                 cmd->tvc_in_iovs =3D vc.in;
> combined with
>                 iov_iter_init(&iov_iter, ITER_DEST, &cmd->tvc_resp_iov,
>                               cmd->tvc_in_iovs, sizeof(v_rsp));
> in vhost_scsi_complete_cmd_work().  We used to have ->tvc_resp_iov
> _pointing_ to vq->iov[vc.out]; back then iov_iter_init() asked to
> set an iovec-backed iov_iter over the tail of vq->iov[], with
> length being the amount of iovecs in the tail.
>=20
> Now we have a copy of one element of that array.  Fortunately, the members
> following it in the containing structure are two non-NULL kernel pointers,
> so copy_to_iter() will not copy anything beyond the first iovec - kernel
> pointer is not (on the majority of architectures) going to be accepted by
> access_ok() in copyout() and it won't be skipped since the "length" (in
> reality - another non-NULL kernel pointer) won't be zero.
>=20
> So it's not going to give a guest-to-qemu escalation, but it's definitely
> a bug.  Frankly, my preference would be to verify that the very first iov=
ec
> is long enough to hold rsp_size.  Due to the above, any users that try to
> give us vq->iov[vc.out].iov_len < sizeof(struct virtio_scsi_cmd_resp)
> would currently get a failure in vhost_scsi_complete_cmd_work()
> anyway.
> """
>=20
> However, the spec doesn't say anything about the legacy descriptor
> layout for the respone. So this patch tries to not assume the response
> to reside in a single separate descriptor which is what commit
> 79c14141a487 ("vhost/scsi: Convert completion path to use") tries to
> achieve towards to ANY_LAYOUT.
>=20
> This is done by allocating and using dedicate resp iov in the
> command. To be safety, start with UIO_MAXIOV to be consistent with the
> limitation that we advertise to the vhost_get_vq_desc().
>=20
> Testing with the hacked virtio-scsi driver that use 1 descriptor for 1
> byte in the response.
>=20
> Reported-by: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Benjamin Coddington <bcodding@redhat.com>
> Cc: Nicholas Bellinger <nab@linux-iscsi.org>
> Fixes: a77ec83a5789 ("vhost/scsi: fix reuse of &vq->iov[out] in response")
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
> Changes since V1:
> - tweak the changelog
> - fix the allocation size for tvc_resp_iov (should be sizeof(struct iovec=
))
> ---
>  drivers/vhost/scsi.c | 21 +++++++++++++++++----
>  1 file changed, 17 insertions(+), 4 deletions(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--vqhw79aaCtf0o+Pf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmPPBhIACgkQnKSrs4Gr
c8h2CQgAjfogTnTq3fYLEVF3lup+f3//rNwFv+dD9Nj1SS3Hb+2tSXDvQWYcimF0
Rk2sqHjeU50pU/ne5Scqe1SadPjqZb+iigRq/M0aRUuE3fa4os5tBRRLXbLNzu+v
iyxXAskl3d9DwbOE13uocY4ldeRqAutyvVrvezMxwyGA2C19yWtmCjsu4FHrA6Wo
WsM4Xu7WtIiqkxeR5TpkEhQokoMaVU+7w80WR1OsUhT3u40sfSwoN6Ue4kknBBHe
JC3z804whf97+HwQ062bfKNZGLYpx8xjid9HqseL8u/n4DLsZTl6XN75f4878FbK
npQ3QkEwdpabVVUxLsYfNsvXyuTwNg==
=1Jmd
-----END PGP SIGNATURE-----

--vqhw79aaCtf0o+Pf--

