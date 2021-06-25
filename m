Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4037C3B4713
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 17:56:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbhFYP7A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 11:59:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbhFYP7A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Jun 2021 11:59:00 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E11DC061574
        for <netdev@vger.kernel.org>; Fri, 25 Jun 2021 08:56:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Mime-Version:Content-Type:References:
        In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=m6u87kQ0aIQSTUpxRtp5/Q26ZDNDyHcdhpJ0QsEmB7g=; b=y1wgfaTL6tkC078YgHGk+HTj8R
        BTIIGtVE1nXGFMQw4v9GHfaXTCsv+ZDHNrhJhmMm2WW98SSOMPcwz+DzzOxS5Rvc27x1T/VTjDpTv
        CJrsakv1NdGXiTCh/eNuOTLmh0ez/04suFwCNp6WWJZJ+dikA4pb/oN1DOSPFJG7fi0sJwrIfuSB5
        fHbf8tmPjh7ru/BK28AQMl4IVTs0ZKNr46MKYSefxj4w6p5tCAyRLmgk2K0VEQ9R0QuzYW5EAfOe3
        dmc/RbtNlS80bnAAf/5yJtNjmtV5XHlFCPjqvBw9hH8zuHYsWfMRgjpP0n1H7ydnANH8E7ryLB2P3
        yngxUBFQ==;
Received: from [2001:8b0:10b:1::3ae] (helo=u3832b3a9db3152.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lwoBu-002DvP-MC; Fri, 25 Jun 2021 15:56:27 +0000
Message-ID: <291763b92bd198e867145b72d08dda1b5853e1af.camel@infradead.org>
Subject: Bringing the SSL VPN data path back in-kernel
From:   David Woodhouse <dwmw2@infradead.org>
To:     David Miller <davem@davemloft.net>
Cc:     mst@redhat.com, herbert@gondor.apana.org.au,
        eric.dumazet@gmail.com, jan.kiszka@siemens.com,
        netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        Eugenio Perez Martin <eperezma@redhat.com>,
        ahmeddan@amazon.co.uk
Date:   Fri, 25 Jun 2021 16:56:22 +0100
In-Reply-To: <20150201.210716.588479604128207372.davem@davemloft.net>
References: <1422797630.11044.32.camel@infradead.org>
         <20150201.121948.998046471405758397.davem@davemloft.net>
         <1422826183.11044.72.camel@infradead.org>
         <20150201.210716.588479604128207372.davem@davemloft.net>
Content-Type: multipart/signed; micalg="sha-256";
        protocol="application/x-pkcs7-signature";
        boundary="=-03yJKyuJoSSgHT4F7Hxe"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-03yJKyuJoSSgHT4F7Hxe
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Reviving an 11-year-old thread, which was 5 years old last time I
revived it, 6 years ago. But I figure this DaveM quote is a good place
to start:

On Sun, 2015-02-01 at 21:07 -0800, David Miller wrote:
> From: David Woodhouse <dwmw2@infradead.org>
> Date: Sun, 01 Feb 2015 21:29:43 +0000
>=20
> > I really was looking for some way to push down something like an XFRM
> > state into the tun device and just say "shove them out here until I tel=
l
> > you otherwise".
>=20
> People decided to use TUN and push VPN stuff back into userspace,
> and there are repercussions for that decision.
>=20
> I'm not saying this to be mean or whatever, but I was very
> disappointed when userland IPSEC solutions using TUN started showing
> up.
>=20
> We might as well have not have implemented the IPSEC stack at all,
> because as a result of the userland VPN stuff our IPSEC stack is
> largely unused except by a very narrow group of users.

I periodically come back to optimising OpenConnect, bumping up against
the fact that *most* of its time is spent pointlessly copying packets
up to userspace and back, and thinking about how much I'd *love* to use
the kernel IPSEC stack.

This is one of those times, as I've just been playing with using
vhost-net for optimising the tun device access directly from userspace:
https://gitlab.com/openconnect/openconnect/-/compare/master...vhost

I hate the fact that userspace is in the data path; the XFRM packet
flow is fairly much exactly what we want for the VPN fast path. We just
need to work out how to glue it together.

To recap on the problem statement briefly: WireGuard is great and all,
but SSL VPNs solve a slightly different problem =E2=80=94 they provide a
versatile client VPN which works *even* when you're stuck on a crappy
airport wifi and all you can establish is an HTTPS connection, and they
will *also* opportunistically upgrade to a datagram path based on
DTLS/ESP *if* they can.

We support a bunch of these protocols now =E2=80=94 Cisco AnyConnect, Pulse
Secure, Palo Alto's GlobalProtect, Fortinet, etc., and we have an open
source server implementation of the Cisco one. All of them use either
DTLS or ESP for the datagram path=C2=B9, with a fairly simple header of a
few bytes in front of the packet inside the DTLS payload.

I do not think we can ditch the tun device completely. All the
complexity of keepalives and rekeying and multiplexing on the TCP & UDP
sockets needs to remain in userspace, and some packets *will* have to
go through userspace on the traditional 'tun' read/write path. And from
an administrative point of view the fact that VPN packets are seen as
ingress/egress on that specific device is useful, and is a security
model that users are used to.

So what I'd like to do is find a way to optimise the *fast* path of
DTLS/ESP by keeping those packets entirely in the kernel using XFRM.
Probably starting with ESP since that's what XFRM already supports.

Some design criteria...

 =E2=80=A2 VPN clients can currently run as an unprivileged user, using a
   *persistent* tun device which is set up for that user in advance.
   I would like to retain this model.

 =E2=80=A2 XFRM state (the SPIs in use, etc.) is NOT GLOBAL. The same SPI
   pairs can be in use multiple times over multiple different UDP
   sockets at the same time.

Currently, to set up ESP over UDP I think I have to set up my incoming
and outgoing state as global state (with globally unique SPIs?), then
add policies which cause certain packets to be encrypted/decrypted
using the corresponding state. For an ESP-in-UDP tunnel the xfrm_state
needs to be given the public src and dst {IP,port} pairs *and* I also
need to bind/connect a real UDP socket and use sockopt(UDP_ENCAP) so
that *incoming* packets get fed to xfrm_input() to be handled. Right?

So... we don't want global state, we don't want generic xfrm policies.

Let's imagine a ULP-like sockopt (or sockopts) on the UDP socket which
provides all the information needed to build XFRM state for both
directions, *and* the fd of the tun device.

It generates a *private* xfrm_state using that information. No
privileges are required for this, since the user already has access to
the tun device and the UDP socket.

It registers its own ->encap_rcv() function on the UDP socket, which
sets up the skb and instead of calling xfrm_input() (which would try to
lookup the xfrm_state from global policies), it calls esp_input()
directly with the appropriate private xfrm_state. Or maybe we extend
the 'negative udp_encap' trick in xfrm_input() to make it bypass the
xfrm_state_lookup() and use the state it's told, but still following
the non-resume path? But that isn't really doing much *except* calling
esp_input() directly, which was my first suggestion.

I haven't quite worked out how, but then it needs to hook into the
xfrm_rcv_cb() or inner_mode handling, such that the decrypted skb is
handed back to us and we can do something vaguely equivalent to this
with it so that it appears to have been received on the tunnel:
  'skb->dev =3D tundev; netif_rx(skb);'

In the DTLS cases there is always a VPN protocol-specific header in the
encrypted payload. For Cisco it's a single byte, with zero being for
data packets and anything else is control stuff (keepalives, MTU
probes, etc.) to be handed up to userspace=C2=B2. So decrypted non-data
packets would ideally get fed back up to userspace on the UDP socket or
maybe some other fd. (Would have been nice in some ways if it was all
synchronous and we could just return an appropriate value from the UDP
->encap_rcv() function, but it's much too late by the time the packet
is decrypted).


The transmit path is a bit simpler, taking outbound skbs from the tun
queue and feeding them to a variant of xfrm_output() which takes the
xfrm_state from the skb (like xfrm_input() does in the resume case).

For DTLS encapsulations, the inner encap could be prepended to the skb
before it's fed to xfrm_input(). We would *also* need to be able to
handle control messages from userspace (perhaps sendmsg() on the UDP
socket, or again perhaps on a different fd).



Does that sound at all sane? Clearly there are details I haven't worked
out yet, but it seems like it might be a good start. Or is there a
better way to do it?

I'm happy to be told I'm a moron, but prefer for such observations to
come with better suggestions. Where "better suggestions" should be both
anatomically possible *and*, ideally, actually solve the problem at
hand.

--=20
dwmw2





=C2=B9 (apart from the Array Networks one, which has an unencrypted mode=
=20
   too, and also a legacy "some engineer rolled his own crypto" mode=20
   which AFAICT was basically equivalent in security to the unencrypted
   mode but I had to stop looking because I was saying too many naughty
   words in front of the children).

=C2=B2 Presumably a BPF program makes that decision, unless we want to
  hard-code the specifics for different protocols in a kernel module.
  It *could* be done with a simpler "memcmp <these> bytes and expect
  the length at <offset> to match the packet length minus <delta>" but=20
  expressing that in BPF is probably the better choice these days.





--=-03yJKyuJoSSgHT4F7Hxe
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
NjI1MTU1NjIyWjAvBgkqhkiG9w0BCQQxIgQginvgdtvSxXtn99q7qfrnnY6EDYURyttIxf6JdS4Z
uFwwgb4GCSsGAQQBgjcQBDGBsDCBrTCBlzELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIg
TWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQx
PTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1h
aWwgQ0ECEQDiu0lIeSrsCenEpRjxmVhmMIHABgsqhkiG9w0BCRACCzGBsKCBrTCBlzELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgG
A1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhl
bnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0ECEQDiu0lIeSrsCenEpRjxmVhmMA0GCSqGSIb3
DQEBAQUABIIBAEp2DNaO52+2p9ZLVTdp0sdQxZxI9tRoFsgWWwMHSs8z4VxCLEuIHBUb/4naMTnh
zK5CNdZEiV/HUheScYnOqp8c+v8C9bmphyxFkyPn3ub03PwGTV/019qlDK/IeFOGKsfNB+xBmJx1
K7zckcnoreR+SA3qGl5yn/HZMu9n6khsGq8qpwXgnAD61E4kXXmSMtp+HCui4rUI8OqlJmC/9F/b
XW5TuZwgOpF82XGYyVwEgFv8ZMgvEyVFysFQXlsdRHTZk64qIX2spAxa/o3kLqUAxX0h8T6vprP4
sOVCsEetineIMaAZbjQokGrtZnIo914F9Iyw6X5zghmMQl9akE0AAAAAAAA=


--=-03yJKyuJoSSgHT4F7Hxe--

