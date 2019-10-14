Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BDC0D5D40
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 10:17:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730349AbfJNIR3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 04:17:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47202 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725936AbfJNIR3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Oct 2019 04:17:29 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 79C4810C092A;
        Mon, 14 Oct 2019 08:17:28 +0000 (UTC)
Received: from localhost (unknown [10.36.118.37])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 877E15D6A3;
        Mon, 14 Oct 2019 08:17:25 +0000 (UTC)
Date:   Mon, 14 Oct 2019 09:17:24 +0100
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org,
        Jason Wang <jasowang@redhat.com>, kvm <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 1/5] vsock/virtio: limit the memory used per-socket
Message-ID: <20191014081724.GD22963@stefanha-x1.localdomain>
References: <20190717113030.163499-1-sgarzare@redhat.com>
 <20190717113030.163499-2-sgarzare@redhat.com>
 <20190729095956-mutt-send-email-mst@kernel.org>
 <20190830094059.c7qo5cxrp2nkrncd@steredhat>
 <20190901024525-mutt-send-email-mst@kernel.org>
 <CAGxU2F7fA5UtkuMQbOHHy0noOGZUtpepBNKFg5afD81bynMVUQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="k4f25fnPtRuIRUb3"
Content-Disposition: inline
In-Reply-To: <CAGxU2F7fA5UtkuMQbOHHy0noOGZUtpepBNKFg5afD81bynMVUQ@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.66]); Mon, 14 Oct 2019 08:17:28 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--k4f25fnPtRuIRUb3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 11, 2019 at 03:40:48PM +0200, Stefano Garzarella wrote:
> On Sun, Sep 1, 2019 at 8:56 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> > On Fri, Aug 30, 2019 at 11:40:59AM +0200, Stefano Garzarella wrote:
> > > On Mon, Jul 29, 2019 at 10:04:29AM -0400, Michael S. Tsirkin wrote:
> > > > On Wed, Jul 17, 2019 at 01:30:26PM +0200, Stefano Garzarella wrote:
> > > > > Since virtio-vsock was introduced, the buffers filled by the host
> > > > > and pushed to the guest using the vring, are directly queued in
> > > > > a per-socket list. These buffers are preallocated by the guest
> > > > > with a fixed size (4 KB).
> > > > >
> > > > > The maximum amount of memory used by each socket should be
> > > > > controlled by the credit mechanism.
> > > > > The default credit available per-socket is 256 KB, but if we use
> > > > > only 1 byte per packet, the guest can queue up to 262144 of 4 KB
> > > > > buffers, using up to 1 GB of memory per-socket. In addition, the
> > > > > guest will continue to fill the vring with new 4 KB free buffers
> > > > > to avoid starvation of other sockets.
> > > > >
> > > > > This patch mitigates this issue copying the payload of small
> > > > > packets (< 128 bytes) into the buffer of last packet queued, in
> > > > > order to avoid wasting memory.
> > > > >
> > > > > Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
> > > > > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> > > >
> > > > This is good enough for net-next, but for net I think we
> > > > should figure out how to address the issue completely.
> > > > Can we make the accounting precise? What happens to
> > > > performance if we do?
> > > >
> > >
> > > Since I'm back from holidays, I'm restarting this thread to figure out
> > > how to address the issue completely.
> > >
> > > I did a better analysis of the credit mechanism that we implemented in
> > > virtio-vsock to get a clearer view and I'd share it with you:
> > >
> > >     This issue affect only the "host->guest" path. In this case, when=
 the
> > >     host wants to send a packet to the guest, it uses a "free" buffer
> > >     allocated by the guest (4KB).
> > >     The "free" buffers available for the host are shared between all
> > >     sockets, instead, the credit mechanism is per-socket, I think to
> > >     avoid the starvation of others sockets.
> > >     The guests re-fill the "free" queue when the available buffers are
> > >     less than half.
> > >
> > >     Each peer have these variables in the per-socket state:
> > >        /* local vars */
> > >        buf_alloc        /* max bytes usable by this socket
> > >                            [exposed to the other peer] */
> > >        fwd_cnt          /* increased when RX packet is consumed by the
> > >                            user space [exposed to the other peer] */
> > >        tx_cnt                 /* increased when TX packet is sent to =
the other peer */
> > >
> > >        /* remote vars  */
> > >        peer_buf_alloc   /* peer's buf_alloc */
> > >        peer_fwd_cnt     /* peer's fwd_cnt */
> > >
> > >     When a peer sends a packet, it increases the 'tx_cnt'; when the
> > >     receiver consumes the packet (copy it to the user-space buffer), =
it
> > >     increases the 'fwd_cnt'.
> > >     Note: increments are made considering the payload length and not =
the
> > >     buffer length.
> > >
> > >     The value of 'buf_alloc' and 'fwd_cnt' are sent to the other peer=
 in
> > >     all packet headers or with an explicit CREDIT_UPDATE packet.
> > >
> > >     The local 'buf_alloc' value can be modified by the user space usi=
ng
> > >     setsockopt() with optname=3DSO_VM_SOCKETS_BUFFER_SIZE.
> > >
> > >     Before to send a packet, the peer checks the space available:
> > >       credit_available =3D peer_buf_alloc - (tx_cnt - peer_fwd_cnt)
> > >     and it will send up to credit_available bytes to the other peer.
> > >
> > > Possible solutions considering Michael's advice:
> > > 1. Use the buffer length instead of the payload length when we increm=
ent
> > >    the counters:
> > >   - This approach will account precisely the memory used per socket.
> > >   - This requires changes in both guest and host.
> > >   - It is not compatible with old drivers, so a feature should be neg=
otiated.
> > > 2. Decrease the advertised 'buf_alloc' taking count of bytes queued in
> > >    the socket queue but not used. (e.g. 256 byte used on 4K available=
 in
> > >    the buffer)
> > >   - pkt->hdr.buf_alloc =3D buf_alloc - bytes_not_used.
> > >   - This should be compatible also with old drivers.
> > >
> > > Maybe the second is less invasive, but will it be too tricky?
> > > Any other advice or suggestions?
> > >
> > > Thanks in advance,
> > > Stefano
> >
> > OK let me try to clarify.  The idea is this:
> >
> > Let's say we queue a buffer of 4K, and we copy if len < 128 bytes.  This
> > means that in the worst case (128 byte packets), each byte of credit in
> > the socket uses up 4K/128 =3D 16 bytes of kernel memory. In fact we need
> > to also account for the virtio_vsock_pkt since I think it's kept around
> > until userspace consumes it.
> >
> > Thus given X buf alloc allowed in the socket, we should publish X/16
> > credits to the other side. This will ensure the other side does not send
> > more than X/16 bytes for a given socket and thus we won't need to
> > allocate more than X bytes to hold the data.
> >
> > We can play with the copy break value to tweak this.
> >
>=20
> Hi Michael,
> sorry for the long silence, but I focused on multi-transport.
>=20
> Before to implement your idea, I tried to do some calculations and
> looking better to our credit mechanism:
>=20
>   buf_alloc =3D 256 KB (default, tunable through setsockopt)
>   sizeof(struct virtio_vsock_pkt) =3D 128
>=20
>   - guest (we use preallocated 4 KB buffers to receive packets, copying
>     small packet - < 128 -)
>     worst_case =3D 129
>     buf_size =3D 4 KB
>     credit2mem =3D (buf_size + sizeof(struct virtio_vsock_pkt)) / worst_c=
ase =3D 32
>=20
>     credit_published =3D buf_alloc / credit2mem =3D ~8 KB
>     Space for just 2 full packet (4 KB)
>=20
>   - host (we copy packets from the vring, allocating the space for the pa=
yload)
>     worst_case =3D 1
>     buf_size =3D 1
>     credit2mem =3D (buf_size + sizeof(struct virtio_vsock_pkt)) / worst_c=
ase =3D 129
>=20
>     credit_published =3D buf_alloc / credit2mem =3D ~2 KB
>     Less than a full packet (guest now can send up to 64 KB with a single
>     packet, so it will be limited to 2 KB)
>=20
> Current memory consumption in the worst case if the RX queue is full:
>   - guest
>     mem =3D (buf_alloc / worst_case) *
>           (buf_size + sizeof(struct virtio_vsock_pkt) =3D ~8MB
>=20
>   - host
>     mem =3D (buf_alloc / worst_case) *
>           (buf_size + sizeof(struct virtio_vsock_pkt) =3D ~32MB
>=20
> I think that the performance with big packets will be affected,
> but I still have to try.
>=20
> Another approach that I want to explore is to play with buf_alloc
> published to the peer.
>=20
> One thing that's not clear to me yet is the meaning of
> SO_VM_SOCKETS_BUFFER_SIZE:
> - max amount of memory used in the RX queue
> - max amount of payload bytes in the RX queue (without overhead of
>   struct virtio_vsock_pkt + preallocated buffer)
>=20
> From the 'include/uapi/linux/vm_sockets.h':
>     /* Option name for STREAM socket buffer size.  Use as the option name=
 in
>      * setsockopt(3) or getsockopt(3) to set or get an unsigned long long=
 that
>      * specifies the size of the buffer underlying a vSockets STREAM sock=
et.
>      * Value is clamped to the MIN and MAX.
>      */
>=20
>     #define SO_VM_SOCKETS_BUFFER_SIZE 0
>=20
> Regardless, I think we need to limit memory consumption in some way.
> I'll check the implementation of other transports, to understand better.

SO_VM_SOCKETS_BUFFER_SIZE might have been useful for VMCI-specific
applications, but we should use SO_RCVBUF and SO_SNDBUF for portable
applications in the future.  Those socket options also work with other
address families.

I guess these sockopts are bypassed by AF_VSOCK because it doesn't use
the common skb queuing code in net/core/sock.c :(.  But one day we might
migrate to it...

Stefan

--k4f25fnPtRuIRUb3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl2kLxQACgkQnKSrs4Gr
c8icQwf/ZRNeyaIkiIZwHbov8HDI2J5Ex0Q1vP56zK7G7A3gNTuGnBkrbzv7R0tR
9Mt2gMYQg1GKhl9yUChS8RYqj3t95DdoYJoBqOF11aX/HL2DOYMjUkSwgnutlIU9
GWYoUP8Dand1CoustleyCaVzAYqr/FetwRbaXIClCsgg8UOQEohkioMOdeRTAQ2x
2+I3aYjBlaC80yO+yUrrYPbePjqDtph2Q/J2r6cr1G+VMn0e0lqY4e8hskd+eoFc
tN/VpnfOhGII3H74W20DJK1U2srU38+VBL0SByrUiAgZwXCIRMnHs3nkBB312OaD
3T9UCvgKBOR3CS1sRTLybhEMo05JCQ==
=Qy/H
-----END PGP SIGNATURE-----

--k4f25fnPtRuIRUb3--
