Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A80943B8085
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 12:03:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234014AbhF3KF2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 06:05:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233959AbhF3KF1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Jun 2021 06:05:27 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FC2FC061756
        for <netdev@vger.kernel.org>; Wed, 30 Jun 2021 03:02:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Mime-Version:Content-Type:References:
        In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=rGu/49tSfR+qLPTuFT/mjeTPYWzfiv/xq3YoATq8tAY=; b=zDZr5+SigKBFlJioUwK8U6dRiG
        MgEp4js8/uTpL15LVZA47/GRHqBeZGgklJhOiszt6ytbng4SadE4YsdFBxvwzdlwsonlckBB7T++2
        7rBlBGDakgmr0+IVIbKiLroiDIY7IDQssOCPJZY0WY5odJp+FgGEadfUsOdzI/U+EVFKv59Vyfolq
        QO3rN/uSbdf63nlS13eYZXz/6js6PKp9lmzr3vWZ7aHyx1UCkcHFHwkPVqFQV12T5khwhgibDVq3Z
        2C4+yPjKiwRn5omjQLl1A6BJPrTm6nlkVj5OG4yMAQyRHQ0W1VFqIXmIghSqWYbC0oLstqfzHhWZN
        wt0eakqQ==;
Received: from 54-240-197-234.amazon.com ([54.240.197.234] helo=freeip.amazon.com)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lyX3Y-00DYt3-Ma; Wed, 30 Jun 2021 10:02:57 +0000
Message-ID: <aa70346d6983a0146b2220e93dac001706723fe3.camel@infradead.org>
Subject: Re: [PATCH v3 3/5] vhost_net: remove virtio_net_hdr validation, let
 tun/tap do it themselves
From:   David Woodhouse <dwmw2@infradead.org>
To:     Jason Wang <jasowang@redhat.com>, netdev@vger.kernel.org
Cc:     Eugenio =?ISO-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
        Willem de Bruijn <willemb@google.com>,
        "Michael S.Tsirkin" <mst@redhat.com>
Date:   Wed, 30 Jun 2021 11:02:54 +0100
In-Reply-To: <500370cc-d030-6c2d-8e96-533a3533a8e2@redhat.com>
References: <03ee62602dd7b7101f78e0802249a6e2e4c10b7f.camel@infradead.org>
         <20210624123005.1301761-1-dwmw2@infradead.org>
         <20210624123005.1301761-3-dwmw2@infradead.org>
         <b339549d-c8f1-1e56-2759-f7b15ee8eca1@redhat.com>
         <bfad641875aff8ff008dd7f9a072c5aa980703f4.camel@infradead.org>
         <1c6110d9-2a45-f766-9d9a-e2996c14b748@redhat.com>
         <72dfecd426d183615c0dd4c2e68690b0e95dd739.camel@infradead.org>
         <80f61c54a2b39cb129e8606f843f7ace605d67e0.camel@infradead.org>
         <99496947-8171-d252-66d3-0af12c62fd2c@redhat.com>
         <cdf3fe3ceff17bc2a5aaf006577c1cb0bef40f3a.camel@infradead.org>
         <500370cc-d030-6c2d-8e96-533a3533a8e2@redhat.com>
Content-Type: multipart/signed; micalg="sha-256";
        protocol="application/x-pkcs7-signature";
        boundary="=-XqcMwnOGuBOGbiU5D73p"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-XqcMwnOGuBOGbiU5D73p
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2021-06-30 at 12:39 +0800, Jason Wang wrote:
> =E5=9C=A8 2021/6/29 =E4=B8=8B=E5=8D=886:49, David Woodhouse =E5=86=99=E9=
=81=93:
> > On Tue, 2021-06-29 at 11:43 +0800, Jason Wang wrote:
> > > > The kernel on a c5.metal can transmit (AES128-SHA1) ESP at about
> > > > 1.2Gb/s from iperf, as it seems to be doing it all from the iperf
> > > > thread.
> > > >=20
> > > > Before I started messing with OpenConnect, it could transmit 1.6Gb/=
s.
> > > >=20
> > > > When I pull in the 'stitched' AES+SHA code from OpenSSL instead of
> > > > doing the encryption and the HMAC in separate passes, I get to 2.1G=
b/s.
> > > >=20
> > > > Adding vhost support on top of that takes me to 2.46Gb/s, which is =
a
> > > > decent enough win.
> > >=20
> > > Interesting, I think the latency should be improved as well in this
> > > case.
> >=20
> > I tried using 'ping -i 0.1' to get an idea of latency for the
> > interesting VoIP-like case of packets where we have to wake up each
> > time.
> >=20
> > For the *inbound* case, RX on the tun device followed by TX of the
> > replies, I see results like this:
> >=20
> >       --- 172.16.0.2 ping statistics ---
> >       141 packets transmitted, 141 received, 0% packet loss, time 14557=
ms
> >       rtt min/avg/max/mdev =3D 0.380/0.419/0.461/0.024 ms
> >=20
> >=20
> > The opposite direction (tun TX then RX) is similar:
> >=20
> >       --- 172.16.0.1 ping statistics ---
> >       295 packets transmitted, 295 received, 0% packet loss, time 30573=
ms
> >       rtt min/avg/max/mdev =3D 0.454/0.545/0.718/0.024 ms
> >=20
> >=20
> > Using vhost-net (and TUNSNDBUF of INT_MAX-1 just to avoid XDP), it
> > looks like this. Inbound:
> >=20
> >       --- 172.16.0.2 ping statistics ---
> >       139 packets transmitted, 139 received, 0% packet loss, time 14350=
ms
> >       rtt min/avg/max/mdev =3D 0.432/0.578/0.658/0.058 ms
> >=20
> > Outbound:
> >=20
> >       --- 172.16.0.1 ping statistics ---
> >       149 packets transmitted, 149 received, 0% packet loss, time 15391=
ms
> >       rtt mn/avg/max/mdev =3D 0.496/0.682/0.935/0.036 ms
> >=20
> >=20
> > So as I expected, the throughput is better with vhost-net once I get to
> > the point of 100% CPU usage in my main thread, because it offloads the
> > kernel=E2=86=90=E2=86=92user copies. But latency is somewhat worse.
> >=20
> > I'm still using select() instead of epoll() which would give me a
> > little back =E2=80=94 but only a little, as I only poll on 3-4 fds, and=
 more to
> > the point it'll give me just as much win in the non-vhost case too, so
> > it won't make much difference to the vhost vs. non-vhost comparison.
> >=20
> > Perhaps I really should look into that trick of "if the vhost TX ring
> > is already stopped and would need a kick, and I only have a few packets
> > in the batch, just write them directly to /dev/net/tun".
>=20
>=20
> That should work on low throughput.

Indeed it works remarkably well, as I noted in my follow-up. I also
fixed a minor stupidity where I was reading from the 'call' eventfd
*before* doing the real work of moving packets around. And that gives
me a few tens of microseconds back too.

> > I'm wondering how that optimisation would translate to actual guests,
> > which presumably have the same problem. Perhaps it would be an
> > operation on the vhost fd, which ends up processing the ring right
> > there in the context of *that* process instead of doing a wakeup?
>=20
>=20
> It might improve the latency in an ideal case but several possible issues=
:
>=20
> 1) this will blocks vCPU running until the sent is done
> 2) copy_from_user() may sleep which will block the vcpu thread further

Yes, it would block the vCPU for a short period of time, but we could
limit that. The real win is to improve latency of single, short packets
like a first SYN, or SYNACK. It should work fine even if it's limited
to *one* *short* packet which *is* resident in memory.

Although actually I'm not *overly* worried about the 'resident' part.
For a transmit packet, especially a short one not a sendpage(), it's
fairly likely the the guest has touched the buffer right before sending
it. And taken the hit of faulting it in then, if necessary. If the host
is paging out memory which is *active* use by a guest, that guest is
screwed anyway :)

I'm thinking of something like an ioctl on the vhost-net fd which *if*
the thread is currently sleeping and there's a single short packet,
processes it immediately. {Else,then} it wakes the thread just like the
eventfd would have done. (Perhaps just by signalling the kick eventfd,
but perhaps there's a more efficient way anyway).

> > My bandwidth tests go up from 2.46Gb/s with the workarounds, to
> > 2.50Gb/s once I enable XDP, and 2.52Gb/s when I drop the virtio-net
> > header. But there's no way for userspace to *detect* that those bugs
> > are fixed, which makes it hard to ship that version.

I'm up to 2.75Gb/s now with epoll and other fixes (including using
sendmmsg() on the other side). Since the kernel can only do *half*
that, I'm now wondering if I really want my data plane in the kernel at
all, which was my long-term plan :)

> Yes, that's sad. One possible way to advertise a VHOST_NET_TUN flag via=
=20
> VHOST_GET_BACKEND_FEATURES?

Strictly it isn't VHOST_NET_TUN, as that *does* work today if you pick
the right (very non-intuitive) combination of features. The feature is
really "VHOST_NET_TUN_WITHOUT_TUNSNDBUF_OR_UNWANTED_VNET_HEADER" :)

But we don't need a feature specifically for that; I only need to check
for *any* feature that goes in after the fixes.

Maybe if we do add a new low-latency kick then I could key on *that*
feature to assume the bugs are fixed.

Alternatively, there's still the memory map thing I need to fix before
I can commit this in my application:

#ifdef __x86_64__
	vmem->regions[0].guest_phys_addr =3D 4096;
	vmem->regions[0].memory_size =3D 0x7fffffffe000;
	vmem->regions[0].userspace_addr =3D 4096;
#else
#error FIXME
#endif
	if (ioctl(vpninfo->vhost_fd, VHOST_SET_MEM_TABLE, vmem) < 0) {

Perhaps if we end up with a user-visible feature to deal with that,
then I could use the presence of *that* feature to infer that the tun
bugs are fixed.

Another random thought as I stare at this... can't we handle checksums
in tun_get_user() / tun_put_user()? We could always set NETIF_F_HW_CSUM
on the tun device, and just do it *while* we're copying the packet to
userspace, if userspace doesn't support it. That would be better than
having the kernel complete the checksum in a separate pass *before*
handing the skb to tun_net_xmit().

We could similarly do a partial checksum in tun_get_user() and hand it
off to the network stack with ->ip_summed =3D=3D CHECKSUM_PARTIAL.



--=-XqcMwnOGuBOGbiU5D73p
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCCECow
ggUcMIIEBKADAgECAhEA4rtJSHkq7AnpxKUY8ZlYZjANBgkqhkiG9w0BAQsFADCBlzELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgG
A1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhl
bnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0EwHhcNMTkwMTAyMDAwMDAwWhcNMjIwMTAxMjM1
OTU5WjAkMSIwIAYJKoZIhvcNAQkBFhNkd213MkBpbmZyYWRlYWQub3JnMIIBIjANBgkqhkiG9w0B
AQEFAAOCAQ8AMIIBCgKCAQEAsv3wObLTCbUA7GJqKj9vHGf+Fa+tpkO+ZRVve9EpNsMsfXhvFpb8
RgL8vD+L133wK6csYoDU7zKiAo92FMUWaY1Hy6HqvVr9oevfTV3xhB5rQO1RHJoAfkvhy+wpjo7Q
cXuzkOpibq2YurVStHAiGqAOMGMXhcVGqPuGhcVcVzVUjsvEzAV9Po9K2rpZ52FE4rDkpDK1pBK+
uOAyOkgIg/cD8Kugav5tyapydeWMZRJQH1vMQ6OVT24CyAn2yXm2NgTQMS1mpzStP2ioPtTnszIQ
Ih7ASVzhV6csHb8Yrkx8mgllOyrt9Y2kWRRJFm/FPRNEurOeNV6lnYAXOymVJwIDAQABo4IB0zCC
Ac8wHwYDVR0jBBgwFoAUgq9sjPjF/pZhfOgfPStxSF7Ei8AwHQYDVR0OBBYEFLfuNf820LvaT4AK
xrGK3EKx1DE7MA4GA1UdDwEB/wQEAwIFoDAMBgNVHRMBAf8EAjAAMB0GA1UdJQQWMBQGCCsGAQUF
BwMEBggrBgEFBQcDAjBGBgNVHSAEPzA9MDsGDCsGAQQBsjEBAgEDBTArMCkGCCsGAQUFBwIBFh1o
dHRwczovL3NlY3VyZS5jb21vZG8ubmV0L0NQUzBaBgNVHR8EUzBRME+gTaBLhklodHRwOi8vY3Js
LmNvbW9kb2NhLmNvbS9DT01PRE9SU0FDbGllbnRBdXRoZW50aWNhdGlvbmFuZFNlY3VyZUVtYWls
Q0EuY3JsMIGLBggrBgEFBQcBAQR/MH0wVQYIKwYBBQUHMAKGSWh0dHA6Ly9jcnQuY29tb2RvY2Eu
Y29tL0NPTU9ET1JTQUNsaWVudEF1dGhlbnRpY2F0aW9uYW5kU2VjdXJlRW1haWxDQS5jcnQwJAYI
KwYBBQUHMAGGGGh0dHA6Ly9vY3NwLmNvbW9kb2NhLmNvbTAeBgNVHREEFzAVgRNkd213MkBpbmZy
YWRlYWQub3JnMA0GCSqGSIb3DQEBCwUAA4IBAQALbSykFusvvVkSIWttcEeifOGGKs7Wx2f5f45b
nv2ghcxK5URjUvCnJhg+soxOMoQLG6+nbhzzb2rLTdRVGbvjZH0fOOzq0LShq0EXsqnJbbuwJhK+
PnBtqX5O23PMHutP1l88AtVN+Rb72oSvnD+dK6708JqqUx2MAFLMevrhJRXLjKb2Mm+/8XBpEw+B
7DisN4TMlLB/d55WnT9UPNHmQ+3KFL7QrTO8hYExkU849g58Dn3Nw3oCbMUgny81ocrLlB2Z5fFG
Qu1AdNiBA+kg/UxzyJZpFbKfCITd5yX49bOriL692aMVDyqUvh8fP+T99PqorH4cIJP6OxSTdxKM
MIIFHDCCBASgAwIBAgIRAOK7SUh5KuwJ6cSlGPGZWGYwDQYJKoZIhvcNAQELBQAwgZcxCzAJBgNV
BAYTAkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGjAY
BgNVBAoTEUNPTU9ETyBDQSBMaW1pdGVkMT0wOwYDVQQDEzRDT01PRE8gUlNBIENsaWVudCBBdXRo
ZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBMB4XDTE5MDEwMjAwMDAwMFoXDTIyMDEwMTIz
NTk1OVowJDEiMCAGCSqGSIb3DQEJARYTZHdtdzJAaW5mcmFkZWFkLm9yZzCCASIwDQYJKoZIhvcN
AQEBBQADggEPADCCAQoCggEBALL98Dmy0wm1AOxiaio/bxxn/hWvraZDvmUVb3vRKTbDLH14bxaW
/EYC/Lw/i9d98CunLGKA1O8yogKPdhTFFmmNR8uh6r1a/aHr301d8YQea0DtURyaAH5L4cvsKY6O
0HF7s5DqYm6tmLq1UrRwIhqgDjBjF4XFRqj7hoXFXFc1VI7LxMwFfT6PStq6WedhROKw5KQytaQS
vrjgMjpICIP3A/CroGr+bcmqcnXljGUSUB9bzEOjlU9uAsgJ9sl5tjYE0DEtZqc0rT9oqD7U57My
ECIewElc4VenLB2/GK5MfJoJZTsq7fWNpFkUSRZvxT0TRLqznjVepZ2AFzsplScCAwEAAaOCAdMw
ggHPMB8GA1UdIwQYMBaAFIKvbIz4xf6WYXzoHz0rcUhexIvAMB0GA1UdDgQWBBS37jX/NtC72k+A
CsaxitxCsdQxOzAOBgNVHQ8BAf8EBAMCBaAwDAYDVR0TAQH/BAIwADAdBgNVHSUEFjAUBggrBgEF
BQcDBAYIKwYBBQUHAwIwRgYDVR0gBD8wPTA7BgwrBgEEAbIxAQIBAwUwKzApBggrBgEFBQcCARYd
aHR0cHM6Ly9zZWN1cmUuY29tb2RvLm5ldC9DUFMwWgYDVR0fBFMwUTBPoE2gS4ZJaHR0cDovL2Ny
bC5jb21vZG9jYS5jb20vQ09NT0RPUlNBQ2xpZW50QXV0aGVudGljYXRpb25hbmRTZWN1cmVFbWFp
bENBLmNybDCBiwYIKwYBBQUHAQEEfzB9MFUGCCsGAQUFBzAChklodHRwOi8vY3J0LmNvbW9kb2Nh
LmNvbS9DT01PRE9SU0FDbGllbnRBdXRoZW50aWNhdGlvbmFuZFNlY3VyZUVtYWlsQ0EuY3J0MCQG
CCsGAQUFBzABhhhodHRwOi8vb2NzcC5jb21vZG9jYS5jb20wHgYDVR0RBBcwFYETZHdtdzJAaW5m
cmFkZWFkLm9yZzANBgkqhkiG9w0BAQsFAAOCAQEAC20spBbrL71ZEiFrbXBHonzhhirO1sdn+X+O
W579oIXMSuVEY1LwpyYYPrKMTjKECxuvp24c829qy03UVRm742R9Hzjs6tC0oatBF7KpyW27sCYS
vj5wbal+TttzzB7rT9ZfPALVTfkW+9qEr5w/nSuu9PCaqlMdjABSzHr64SUVy4ym9jJvv/FwaRMP
gew4rDeEzJSwf3eeVp0/VDzR5kPtyhS+0K0zvIWBMZFPOPYOfA59zcN6AmzFIJ8vNaHKy5QdmeXx
RkLtQHTYgQPpIP1Mc8iWaRWynwiE3ecl+PWzq4i+vdmjFQ8qlL4fHz/k/fT6qKx+HCCT+jsUk3cS
jDCCBeYwggPOoAMCAQICEGqb4Tg7/ytrnwHV2binUlYwDQYJKoZIhvcNAQEMBQAwgYUxCzAJBgNV
BAYTAkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGjAY
BgNVBAoTEUNPTU9ETyBDQSBMaW1pdGVkMSswKQYDVQQDEyJDT01PRE8gUlNBIENlcnRpZmljYXRp
b24gQXV0aG9yaXR5MB4XDTEzMDExMDAwMDAwMFoXDTI4MDEwOTIzNTk1OVowgZcxCzAJBgNVBAYT
AkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGjAYBgNV
BAoTEUNPTU9ETyBDQSBMaW1pdGVkMT0wOwYDVQQDEzRDT01PRE8gUlNBIENsaWVudCBBdXRoZW50
aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKC
AQEAvrOeV6wodnVAFsc4A5jTxhh2IVDzJXkLTLWg0X06WD6cpzEup/Y0dtmEatrQPTRI5Or1u6zf
+bGBSyD9aH95dDSmeny1nxdlYCeXIoymMv6pQHJGNcIDpFDIMypVpVSRsivlJTRENf+RKwrB6vcf
WlP8dSsE3Rfywq09N0ZfxcBa39V0wsGtkGWC+eQKiz4pBZYKjrc5NOpG9qrxpZxyb4o4yNNwTqza
aPpGRqXB7IMjtf7tTmU2jqPMLxFNe1VXj9XB1rHvbRikw8lBoNoSWY66nJN/VCJv5ym6Q0mdCbDK
CMPybTjoNCQuelc0IAaO4nLUXk0BOSxSxt8kCvsUtQIDAQABo4IBPDCCATgwHwYDVR0jBBgwFoAU
u69+Aj36pvE8hI6t7jiY7NkyMtQwHQYDVR0OBBYEFIKvbIz4xf6WYXzoHz0rcUhexIvAMA4GA1Ud
DwEB/wQEAwIBhjASBgNVHRMBAf8ECDAGAQH/AgEAMBEGA1UdIAQKMAgwBgYEVR0gADBMBgNVHR8E
RTBDMEGgP6A9hjtodHRwOi8vY3JsLmNvbW9kb2NhLmNvbS9DT01PRE9SU0FDZXJ0aWZpY2F0aW9u
QXV0aG9yaXR5LmNybDBxBggrBgEFBQcBAQRlMGMwOwYIKwYBBQUHMAKGL2h0dHA6Ly9jcnQuY29t
b2RvY2EuY29tL0NPTU9ET1JTQUFkZFRydXN0Q0EuY3J0MCQGCCsGAQUFBzABhhhodHRwOi8vb2Nz
cC5jb21vZG9jYS5jb20wDQYJKoZIhvcNAQEMBQADggIBAHhcsoEoNE887l9Wzp+XVuyPomsX9vP2
SQgG1NgvNc3fQP7TcePo7EIMERoh42awGGsma65u/ITse2hKZHzT0CBxhuhb6txM1n/y78e/4ZOs
0j8CGpfb+SJA3GaBQ+394k+z3ZByWPQedXLL1OdK8aRINTsjk/H5Ns77zwbjOKkDamxlpZ4TKSDM
KVmU/PUWNMKSTvtlenlxBhh7ETrN543j/Q6qqgCWgWuMAXijnRglp9fyadqGOncjZjaaSOGTTFB+
E2pvOUtY+hPebuPtTbq7vODqzCM6ryEhNhzf+enm0zlpXK7q332nXttNtjv7VFNYG+I31gnMrwfH
M5tdhYF/8v5UY5g2xANPECTQdu9vWPoqNSGDt87b3gXb1AiGGaI06vzgkejL580ul+9hz9D0S0U4
jkhJiA7EuTecP/CFtR72uYRBcunwwH3fciPjviDDAI9SnC/2aPY8ydehzuZutLbZdRJ5PDEJM/1t
yZR2niOYihZ+FCbtf3D9mB12D4ln9icgc7CwaxpNSCPt8i/GqK2HsOgkL3VYnwtx7cJUmpvVdZ4o
gnzgXtgtdk3ShrtOS1iAN2ZBXFiRmjVzmehoMof06r1xub+85hFQzVxZx5/bRaTKTlL8YXLI8nAb
R9HWdFqzcOoB/hxfEyIQpx9/s81rgzdEZOofSlZHynoSMYIDyjCCA8YCAQEwga0wgZcxCzAJBgNV
BAYTAkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGjAY
BgNVBAoTEUNPTU9ETyBDQSBMaW1pdGVkMT0wOwYDVQQDEzRDT01PRE8gUlNBIENsaWVudCBBdXRo
ZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBAhEA4rtJSHkq7AnpxKUY8ZlYZjANBglghkgB
ZQMEAgEFAKCCAe0wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMjEw
NjMwMTAwMjU0WjAvBgkqhkiG9w0BCQQxIgQgPhMandFPjHXmJjniCGVAdsj0BfcnbW17JtYZd5p8
Xfowgb4GCSsGAQQBgjcQBDGBsDCBrTCBlzELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIg
TWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQx
PTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1h
aWwgQ0ECEQDiu0lIeSrsCenEpRjxmVhmMIHABgsqhkiG9w0BCRACCzGBsKCBrTCBlzELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgG
A1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhl
bnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0ECEQDiu0lIeSrsCenEpRjxmVhmMA0GCSqGSIb3
DQEBAQUABIIBABARKixsA5c2KJjH+5NbOFejSbngkvmXZrfhvVDQUrP/TgYcB0wJerQ2CvQzcDka
oW3KJqfuJ8VUzxdmgg30Zb1YeemFbZvbIduTz7iaoH50EuE5mT3Wc3CxvATWhi4oLU3k9dl8ID9S
5MgVs5ylvHploEkRtaniEykQtKj/cWvQ7gthrWLE5gX3E49j/sdVUFNsyNIp7DS3wZRa8b/H8D1I
26215GByRUvZjQD6xa1VoeJW0dumP6Q3dTNi8W1ESI9p8aausl8SNRgFPdK+6Rs3LKLbswTOCqhF
Pwvy+4KyxdwOw+BbdMZndT0/gz/w+n0R6rcxDtgTzJGCXn8/+yIAAAAAAAA=


--=-XqcMwnOGuBOGbiU5D73p--

