Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7818C1068CF
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 10:25:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726985AbfKVJZz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 04:25:55 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:28895 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726942AbfKVJZy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 04:25:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574414753;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NQ5wfa2k/ZGh4tRlMZlUTAY+jcVvzWiqwqcMi1NaDLQ=;
        b=B62s9SHUvoqPoLcWIXbiT4r3I6/nHEA9YBdgVHlwN5gxUgUv8gReP1/zR42LQhfr5++8ml
        YON8fzyUqOlwUvB2t1H+UqROn9Y5NEiMN/YV0NLz4aUr2m2snuT7DX+w0NPxxkB0wQ31+7
        EAY30p2aFg2pfVeluUTBUKkK7PCKHbA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-317-l_ijsUHGPBSfxTfG5fbmtQ-1; Fri, 22 Nov 2019 04:25:50 -0500
X-MC-Unique: l_ijsUHGPBSfxTfG5fbmtQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2C04D107AD89;
        Fri, 22 Nov 2019 09:25:48 +0000 (UTC)
Received: from localhost (unknown [10.36.118.40])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7BC3B5D6A7;
        Fri, 22 Nov 2019 09:25:47 +0000 (UTC)
Date:   Fri, 22 Nov 2019 09:25:46 +0000
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     Stefan Hajnoczi <stefanha@gmail.com>, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Dexuan Cui <decui@microsoft.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jorgen Hansen <jhansen@vmware.com>
Subject: Re: [PATCH net-next 4/6] vsock: add vsock_loopback transport
Message-ID: <20191122092546.GA464656@stefanha-x1.localdomain>
References: <20191119110121.14480-1-sgarzare@redhat.com>
 <20191119110121.14480-5-sgarzare@redhat.com>
 <20191121093458.GB439743@stefanha-x1.localdomain>
 <20191121095948.bc7lc3ptsh6jxizw@steredhat>
 <20191121152517.zfedz6hg6ftcb2ks@steredhat>
MIME-Version: 1.0
In-Reply-To: <20191121152517.zfedz6hg6ftcb2ks@steredhat>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Mimecast-Spam-Score: 0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="zYM0uCDKw75PZbzx"
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--zYM0uCDKw75PZbzx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 21, 2019 at 04:25:17PM +0100, Stefano Garzarella wrote:
> On Thu, Nov 21, 2019 at 10:59:48AM +0100, Stefano Garzarella wrote:
> > On Thu, Nov 21, 2019 at 09:34:58AM +0000, Stefan Hajnoczi wrote:
> > > On Tue, Nov 19, 2019 at 12:01:19PM +0100, Stefano Garzarella wrote:
> > > > +static struct workqueue_struct *vsock_loopback_workqueue;
> > > > +static struct vsock_loopback *the_vsock_loopback;
> > >=20
> > > the_vsock_loopback could be a static global variable (not a pointer) =
and
> > > vsock_loopback_workqueue could also be included in the struct.
> > >=20
> > > The RCU pointer is really a way to synchronize vsock_loopback_send_pk=
t()
> > > and vsock_loopback_cancel_pkt() with module exit.  There is no other
> > > reason for using a pointer.
> > >=20
> > > It's cleaner to implement the synchronization once in af_vsock.c (or
> > > virtio_transport_common.c) instead of making each transport do it.
> > > Maybe try_module_get() and related APIs provide the necessary semanti=
cs
> > > so that core vsock code can hold the transport module while it's bein=
g
> > > used to send/cancel a packet.
> >=20
> > Right, the module cannot be unloaded until open sockets, so here the
> > synchronization is not needed.
> >=20
> > The synchronization come from virtio-vsock device that can be
> > hot-unplugged while sockets are still open, but that can't happen here.
> >=20
> > I will remove the pointers and RCU in the v2.
> >=20
> > Can I keep your R-b or do you prefer to watch v2 first?

I'd like to review v2.

> > > > +MODULE_ALIAS_NETPROTO(PF_VSOCK);
> > >=20
> > > Why does this module define the alias for PF_VSOCK?  Doesn't another
> > > module already define this alias?
> >=20
> > It is a way to load this module when PF_VSOCK is starting to be used.
> > MODULE_ALIAS_NETPROTO(PF_VSOCK) is already defined in vmci_transport
> > and hyperv_transport. IIUC it is used for the same reason.
> >=20
> > In virtio_transport we don't need it because it will be loaded when
> > the PCI device is discovered.
> >=20
> > Do you think there's a better way?
> > Should I include the vsock_loopback transport directly in af_vsock
> > without creating a new module?
> >=20
>=20
> That last thing I said may not be possible:
> I remembered that I tried, but DEPMOD found a cyclic dependency because
> vsock_transport use virtio_transport_common that use vsock, so if I
> include vsock_transport in the vsock module, DEPMOD is not happy.
>=20
> Do you think it's okay in this case to keep MODULE_ALIAS_NETPROTO(PF_VSOC=
K)
> or is there a better way?

The reason I asked is because the semantics of duplicate module aliases
aren't clear to me.  Do all modules with the same alias get loaded?
Or just the first?  Or ...?

Stefan

--zYM0uCDKw75PZbzx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl3XqZoACgkQnKSrs4Gr
c8g8zwgAgv0qn/NHDbIBcCRih2eGRkR+l2CqDKByM5A65GN5n5ZwQJvooj/0hZZa
maHWK3vTmOU1c5m5gwRHJcTNTvK3hL3xYgxMCzanpWkpK6xPFSbBReQ1KtN+2IJh
1bXN7mvpTAKFkIm10jnGIzK53Tv5y46c+dHQ+Q+Wx56zSCMWcMhPZUBXSAE8Tx61
VAeo0HFPzx/wgy785xR3+tw4xV0M8UlbcYqJG/jTToIES2z4JUNIVTAczg22QpSe
hp9KwKDgSMvJLmb6fzefYTgp/hTT3fQh448YbpeHAsly8RSoJjkJx/1w4qj/AVAT
rI4XWaP4Enu7IgGna2wLQSCP+fqRog==
=VfA7
-----END PGP SIGNATURE-----

--zYM0uCDKw75PZbzx--

