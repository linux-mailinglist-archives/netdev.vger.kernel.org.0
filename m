Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B054A3B2CA4
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 12:42:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232208AbhFXKpQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 06:45:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232125AbhFXKpP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 06:45:15 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B8D7C061574
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 03:42:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Mime-Version:Content-Type:References:
        In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=wDgMkPQmXOqZSgElW9k8xdSbD9mRLEHlky3dz84A+q8=; b=EmwzX+D4hsWR06+9x6HfjdmTHb
        NcLJQXMyBKGfvIEYrHZGbro5c0ktCSV2c51xPgQHIZ997t7vsELa4MGNiFG6CElPQXQ1gryv379kZ
        Ly9jRKs3FEYWOfYF7ggoDXSgNyTq8MYNPDpzTQW2XOMuPgFKTn3rBuSuf/UoaGoxFdFdIfWkGvg5Q
        UmUvN4GTvAsorGMaAdIqXxtMU4LHXG02DS2JL3ts7atuquvPY6+CA3A7E0Ilw1U55F/2TpfI19fTY
        8uzzj1Amxp1LKL9aLMmVfsGN8vOFPaYn8Vb7ZSvQk46QRBX/M7rJ1tImp7g4msrcPywy6Ni6TT6tM
        mSD3cq7g==;
Received: from [2001:8b0:10b:1::3ae] (helo=u3832b3a9db3152.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lwMox-00ECc8-Dj; Thu, 24 Jun 2021 10:42:55 +0000
Message-ID: <3a5bf6b8a05a1bf6393abe4f3d2c7b0e8086c3df.camel@infradead.org>
Subject: Re: [PATCH v2 4/4] vhost_net: Add self test with tun device
From:   David Woodhouse <dwmw2@infradead.org>
To:     Jason Wang <jasowang@redhat.com>, netdev@vger.kernel.org
Cc:     Eugenio =?ISO-8859-1?Q?P=E9rez?= <eperezma@redhat.com>
Date:   Thu, 24 Jun 2021 11:42:52 +0100
In-Reply-To: <4a5c6e49-ee50-3c0c-c8e6-04d85137cfb1@redhat.com>
References: <03ee62602dd7b7101f78e0802249a6e2e4c10b7f.camel@infradead.org>
         <20210622161533.1214662-1-dwmw2@infradead.org>
         <20210622161533.1214662-4-dwmw2@infradead.org>
         <85e55d53-4ef2-0b61-234e-4b5f30909efa@redhat.com>
         <d6ad85649fd56d3e12e59085836326a09885593b.camel@infradead.org>
         <4a5c6e49-ee50-3c0c-c8e6-04d85137cfb1@redhat.com>
Content-Type: multipart/signed; micalg="sha-256";
        protocol="application/x-pkcs7-signature";
        boundary="=-UD7e98GBtsQtz8HLTqqG"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-UD7e98GBtsQtz8HLTqqG
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2021-06-24 at 14:12 +0800, Jason Wang wrote:
> =E5=9C=A8 2021/6/24 =E4=B8=8A=E5=8D=8812:12, David Woodhouse =E5=86=99=E9=
=81=93:
> > We *should* eventually expand this test case to attach an AF_PACKET
> > device to the vhost-net, instead of using a tun device as the back end.
> > (Although I don't really see *why* vhost is limited to AF_PACKET. Why
> > *can't* I attach anything else, like an AF_UNIX socket, to vhost-net?)
>=20
>=20
> It's just because nobody wrote the code. And we're lacking the real use=
=20
> case.

Hm, what code? For AF_PACKET I haven't actually spotted that there *is*
any.

As I've been refactoring the interaction between vhost and tun/tap, and
fixing it up for different vhdr lengths, PI, and (just now) frowning in
horror at the concept that tun and vhost can have *different*
endiannesses, I hadn't spotted that there was anything special on the
packet socket. For that case, sock_hlen is just zero and we
send/receive plain packets... or so I thought? Did I miss something?

As far as I was aware, that ought to have worked with any datagram
socket. I was pondering not just AF_UNIX but also UDP (since that's my
main transport for VPN data, at least in the case where I care about
performance).

An interesting use case for a non-packet socket might be to establish a
tunnel. A guest's virtio-net device is just connected to a UDP socket
on the host, and that tunnels all their packets to/from a remote
endpoint which is where that guest is logically connected to the
network. It might be useful for live migration cases, perhaps?

I don't have an overriding desire to *make* it work, mind you; I just
wanted to make sure I understand *why* it doesn't, if indeed it
doesn't. As far as I could tell, it *should* work if we just dropped
the check?

> Vhost_net is bascially used for accepting packet from userspace to the=
=20
> kernel networking stack.
>=20
> Using AF_UNIX makes it looks more like a case of inter process=20
> communication (without vnet header it won't be used efficiently by VM).=
=20
> In this case, using io_uring is much more suitable.
>=20
> Or thinking in another way, instead of depending on the vhost_net, we=20
> can expose TUN/TAP socket to userspace then io_uring could be used for=
=20
> the OpenConnect case as well?

That would work, I suppose. Although as noted, I *can* use vhost_net
with tun today from userspace as long as I disable XDP and PI, and use
a virtio_net_hdr that I don't really want. (And pull a value for
TASK_SIZE out of my posterior; qv.)

So I *can* ship a version of OpenConnect that works on existing
production kernels with those workarounds, and I'm fixing up the other
permutations of vhost/tun stuff in the kernel just because I figured we
*should*.

If I'm going to *require* new kernel support for OpenConnect then I
might as well go straight to the AF_TLS/DTLS + BPF + sockmap plan and
have the data packets never go to userspace in the first place.


>=20
> >=20
> >=20
> > > > +	/*
> > > > +	 * I just want to map the *whole* of userspace address space. But
> > > > +	 * from userspace I don't know what that is. On x86_64 it would b=
e:
> > > > +	 *
> > > > +	 * vmem->regions[0].guest_phys_addr =3D 4096;
> > > > +	 * vmem->regions[0].memory_size =3D 0x7fffffffe000;
> > > > +	 * vmem->regions[0].userspace_addr =3D 4096;
> > > > +	 *
> > > > +	 * For now, just ensure we put everything inside a single BSS reg=
ion.
> > > > +	 */
> > > > +	vmem->regions[0].guest_phys_addr =3D (uint64_t)&rings;
> > > > +	vmem->regions[0].userspace_addr =3D (uint64_t)&rings;
> > > > +	vmem->regions[0].memory_size =3D sizeof(rings);
> > >=20
> > > Instead of doing tricks like this, we can do it in another way:
> > >=20
> > > 1) enable device IOTLB
> > > 2) wait for the IOTLB miss request (iova, len) and update identity
> > > mapping accordingly
> > >=20
> > > This should work for all the archs (with some performance hit).
> >=20
> > Ick. For my actual application (OpenConnect) I'm either going to suck
> > it up and put in the arch-specific limits like in the comment above, or
> > I'll fix things to do the VHOST_F_IDENTITY_MAPPING thing we're talking
> > about elsewhere.
>=20
>=20
> The feature could be useful for the case of vhost-vDPA as well.
>=20
>=20
> >   (Probably the former, since if I'm requiring kernel
> > changes then I have grander plans around extending AF_TLS to do DTLS,
> > then hooking that directly up to the tun socket via BPF and a sockmap
> > without the data frames ever going to userspace at all.)
>=20
>=20
> Ok, I guess we need to make sockmap works for tun socket.

Hm, I need to work out the ideal data flow here. I don't know if
sendmsg() / recvmsg() on the tun socket are even what I want, for full
zero-copy.

In the case where the NIC supports encryption, we want true zero-copy
from the moment the "encrypted" packet arrives over UDP on the public
network, through the DTLS processing and seqno checking, to being
processed as netif_receive_skb() on the tun device.

Likewise skbs from tun_net_xmit() should have the appropriate DTLS and
IP/UDP headers prepended to them and that *same* skb (or at least the
same frags) should be handed to the NIC to encrypt and send.

In the case where we have software crypto in the kernel, we can
tolerate precisely *one* copy because the crypto doesn't have to be
done in-place, so moving from the input to the output crypto buffers
can be that one "copy", and we can use it to move data around (from the
incoming skb to the outgoing skb) if we need to.

Ultimately I think we want udp_sendmsg() and tun_sendmsg() to support
being *given* ownership of the buffers, rather than copying from them.
Or just being given a skb and pushing/pulling their headers.

I'm looking at skb_send_sock() and it *doesn't* seem to support "just
steal the frags from the initial skb and give them to the new one", but
there may be ways to make that work.

> > I think I can fix *all* those test cases by making tun_get_socket()
> > take an extra 'int *' argument, and use that to return the *actual*
> > value of sock_hlen. Here's the updated test case in the meantime:
>=20
>=20
> It would be better if you can post a new version of the whole series to=
=20
> ease the reviewing.

Yep. I was working on that... until I got even more distracted by
looking at how we can do the true in-kernel zero-copy option ;)


--=-UD7e98GBtsQtz8HLTqqG
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
NjI0MTA0MjUyWjAvBgkqhkiG9w0BCQQxIgQgzL7bWD1J/zDTYhLERlCL73y0uLmAX7AfbO8iCe7+
iXkwgb4GCSsGAQQBgjcQBDGBsDCBrTCBlzELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIg
TWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQx
PTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1h
aWwgQ0ECEQDiu0lIeSrsCenEpRjxmVhmMIHABgsqhkiG9w0BCRACCzGBsKCBrTCBlzELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgG
A1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhl
bnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0ECEQDiu0lIeSrsCenEpRjxmVhmMA0GCSqGSIb3
DQEBAQUABIIBAG8Gze5yT3acYuf4UXu/09K96ng1WIEG+23MMsCuTf0dMtDxV2EZGII8pICp2vZo
X7SXxZ0WYRlZJy13DahTiL/3ntyya2nAZwLL/rzyT/kSF265l0t5yxCKu6R2Q/H5bSem9cVkuTTT
ODFVNJIHfuYGTUxsraYARqCsXE+HwMhVgaZbKL8pidLARRVnL+LPm8AFhSvUgD16DFQewvbvpGzy
PJ4NxR3oiucH36Duzth4tLD/FNbxVe7x9KXAbTL6mT+xNdorzdiOs/n+CDRE1q47C9vlOvAktcBf
xwR+KbCSZJ7a1Mr7OlpBI6J0YqYP66NJB8/GuZytS73nDdt7l+UAAAAAAAA=


--=-UD7e98GBtsQtz8HLTqqG--

