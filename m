Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 239F33B490A
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 20:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbhFYS5z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 14:57:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229700AbhFYS5y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Jun 2021 14:57:54 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED827C061574
        for <netdev@vger.kernel.org>; Fri, 25 Jun 2021 11:55:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Mime-Version:Content-Type:References:
        In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ydor9K0Xva61ydSQjjoc4QpxMvM2dKapSG3cv3mVpns=; b=tpr+h0lrSSdSALXCpcn0bfQo9W
        s/KDMzrongEf55LwJ4UsmhstbZ/W0pSQlKw76BcAvsqBoadP8H9qzYc+X8o6+L7MlmBANbSIagJgQ
        Zn77nYERLYzItqregJn8no5iR/a+8bUzNwpoqPrHasEbxlP9iWahGD3fEw+VyddhD6TJyP7irfLa+
        GGkvf8VpLwqx4dM8V7JGkqFUrg9w/olI169pzH4gKgx61mPUj8jeOE1DUuTZjp0OwSZBdP9whdzUX
        ywDweG3yVNyhoLG5QOv5oQQj14ipVRAYm317R1+kwIYsbK+slWWs+IjWV/iKODsZSR8JWtx0eRBqq
        30ScwawA==;
Received: from [2001:8b0:10b:1::3ae] (helo=u3832b3a9db3152.ant.amazon.com)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lwqzE-002dUg-UH; Fri, 25 Jun 2021 18:55:33 +0000
Message-ID: <d291fdafe4bb2ee5c1f272b990784894f03894fd.camel@infradead.org>
Subject: Re: [PATCH v3 1/5] net: add header len parameter to
 tun_get_socket(), tap_get_socket()
From:   David Woodhouse <dwmw2@infradead.org>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        Eugenio =?ISO-8859-1?Q?P=E9rez?= <eperezma@redhat.com>
Date:   Fri, 25 Jun 2021 19:55:30 +0100
In-Reply-To: <CA+FuTSecOyH_k-jmLm_Ux4V9w0LOfWfVf6kuKfhOPU5DyD-wCw@mail.gmail.com>
References: <03ee62602dd7b7101f78e0802249a6e2e4c10b7f.camel@infradead.org>
         <20210624123005.1301761-1-dwmw2@infradead.org>
         <CA+FuTSecOyH_k-jmLm_Ux4V9w0LOfWfVf6kuKfhOPU5DyD-wCw@mail.gmail.com>
Content-Type: multipart/signed; micalg="sha-256";
        protocol="application/x-pkcs7-signature";
        boundary="=-8h1Zr0gSVgbfl5jFVI1q"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-8h1Zr0gSVgbfl5jFVI1q
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2021-06-25 at 14:13 -0400, Willem de Bruijn wrote:
> On Thu, Jun 24, 2021 at 8:30 AM David Woodhouse <dwmw2@infradead.org>
> wrote:
> >=20
> > From: David Woodhouse <dwmw@amazon.co.uk>
> >=20
> > The vhost-net driver was making wild assumptions about the header
> > length
>=20
> If respinning, please more concretely describe which configuration is
> currently broken.

Fairly much all of them. Here's a test run on the 5.12.8 kernel:

$ sudo ./test_vhost_net=20
TEST: (hdr 0, xdp 0, pi 0, features 0) RESULT: -1
TEST: (hdr 10, xdp 0, pi 0, features 0) RESULT: 0
TEST: (hdr 12, xdp 0, pi 0, features 0) RESULT: -1
TEST: (hdr 20, xdp 0, pi 0, features 0) RESULT: -1
TEST: (hdr 0, xdp 1, pi 0, features 0) RESULT: -1
TEST: (hdr 10, xdp 1, pi 0, features 0) RESULT: -1
TEST: (hdr 12, xdp 1, pi 0, features 0) RESULT: -1
TEST: (hdr 20, xdp 1, pi 0, features 0) RESULT: -1
TEST: (hdr 0, xdp 0, pi 1, features 0) RESULT: -1
TEST: (hdr 10, xdp 0, pi 1, features 0) RESULT: -1
TEST: (hdr 12, xdp 0, pi 1, features 0) RESULT: -1
TEST: (hdr 20, xdp 0, pi 1, features 0) RESULT: -1
TEST: (hdr 0, xdp 1, pi 1, features 0) RESULT: -1
TEST: (hdr 10, xdp 1, pi 1, features 0) RESULT: -1
TEST: (hdr 12, xdp 1, pi 1, features 0) RESULT: -1
TEST: (hdr 20, xdp 1, pi 1, features 0) RESULT: -1
TEST: (hdr 0, xdp 0, pi 0, features 100000000) RESULT: -1
TEST: (hdr 10, xdp 0, pi 0, features 100000000) RESULT: -1
TEST: (hdr 12, xdp 0, pi 0, features 100000000) RESULT: 0
TEST: (hdr 20, xdp 0, pi 0, features 100000000) RESULT: -1
TEST: (hdr 0, xdp 1, pi 0, features 100000000) RESULT: -1
TEST: (hdr 10, xdp 1, pi 0, features 100000000) RESULT: -1
TEST: (hdr 12, xdp 1, pi 0, features 100000000) RESULT: -1
TEST: (hdr 20, xdp 1, pi 0, features 100000000) RESULT: -1
TEST: (hdr 0, xdp 0, pi 1, features 100000000) RESULT: -1
TEST: (hdr 10, xdp 0, pi 1, features 100000000) RESULT: -1
TEST: (hdr 12, xdp 0, pi 1, features 100000000) RESULT: -1
TEST: (hdr 20, xdp 0, pi 1, features 100000000) RESULT: -1
TEST: (hdr 0, xdp 1, pi 1, features 100000000) RESULT: -1
TEST: (hdr 10, xdp 1, pi 1, features 100000000) RESULT: -1
TEST: (hdr 12, xdp 1, pi 1, features 100000000) RESULT: -1
TEST: (hdr 20, xdp 1, pi 1, features 100000000) RESULT: -1
TEST: (hdr 0, xdp 0, pi 0, features 8000000) RESULT: 0
TEST: (hdr 0, xdp 1, pi 0, features 8000000) RESULT: -1
TEST: (hdr 0, xdp 0, pi 1, features 8000000) RESULT: -1
TEST: (hdr 0, xdp 1, pi 1, features 8000000) RESULT: -1
TEST: (hdr 0, xdp 0, pi 0, features 108000000) RESULT: 0
TEST: (hdr 0, xdp 1, pi 0, features 108000000) RESULT: -1
TEST: (hdr 0, xdp 0, pi 1, features 108000000) RESULT: -1
TEST: (hdr 0, xdp 1, pi 1, features 108000000) RESULT: -1

> IFF_NO_PI + IFF_VNET_HDR, if I understand correctly.=20

That's fairly much the only one that *did* work. As long as you use
TUNSETSNDBUF which has the undocumented side-effect of turning off the
XDP path.

> > On the receive side, where the tun device generates the virtio_net_hdr
> > but VIRITO_NET_F_MSG_RXBUF was negotiated and vhost-net needs to fill
>=20
> Nit: VIRTIO_NET_F_MSG_RXBUF

Thanks.

> > in the 'num_buffers' field on top of the existing virtio_net_hdr, fix
> > that to use 'sock_hlen - 2' as the location, which means that it goes
>=20
> Please use sizeof(hdr.num_buffers) instead of a raw constant 2, to
> self document the code.

Makes sense.

> Should this be an independent one-line fix?

I don't think so; it's very much intertwined with the way it makes
assumptions about someone else's data.

--=-8h1Zr0gSVgbfl5jFVI1q
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
NjI1MTg1NTMwWjAvBgkqhkiG9w0BCQQxIgQg/HYoMV3XMdxD+CfUjNAZ29+w8npGbvG153d7oGFj
CY4wgb4GCSsGAQQBgjcQBDGBsDCBrTCBlzELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIg
TWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQx
PTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1h
aWwgQ0ECEQDiu0lIeSrsCenEpRjxmVhmMIHABgsqhkiG9w0BCRACCzGBsKCBrTCBlzELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgG
A1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhl
bnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0ECEQDiu0lIeSrsCenEpRjxmVhmMA0GCSqGSIb3
DQEBAQUABIIBAGzvj3aY+VpLmAW42cxq75++XocCJ4jxQYzDSIMxb9Ruxg+4fDERG/xGvB8PU1LC
BJFGlX/nFd1DmV38apRk2rOHng1i1fdcSuQdSjeAg+0eMtv6ZcYo17TMovyZkDN1zbkrR3WKVklH
unJonN/o1riJJLjUahxmFs5Pnaz28nG5rp44BStMdytYw/O7mQqrQ6JVMXjar4Ludp/ivtVxkg+a
y2bKfkNXUPi4MtvRZMOeluzOuf4gzwP4T/iQydCB0uEZ/oEZva2/YEOCZ6HQsy8RjS5+ah9qyGzW
MCDcAnvW15Av/s8PUa1/4T1aMUxqcbFnRNQCNbxiKScPld5l5d0AAAAAAAA=


--=-8h1Zr0gSVgbfl5jFVI1q--

