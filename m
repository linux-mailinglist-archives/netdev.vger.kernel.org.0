Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CED5A3B1B97
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 15:52:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230411AbhFWNyv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 09:54:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230182AbhFWNyv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 09:54:51 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC406C061574
        for <netdev@vger.kernel.org>; Wed, 23 Jun 2021 06:52:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Mime-Version:Content-Type:References:
        In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=QHP8TpGEu6674Pbpz5bIaZumpvDwr2tdwmK+JFMYCxs=; b=brrSSImMGxLLU/Xsjx/4NQY/Ug
        u43EuHud6uXmjA864iPYR8lPlDu/vkNORcJtU1TBuHaUMOaztgpr5oP71SmQ0nrAxnNKBiVkqex3R
        TmgB4SztpASAklbAy5rW4MKj8njrdhEcVLlm5XOX1wgDIL6dCEAhnv1FPqcqFc6DTeC5qp9bdndbX
        yHkKkRzY/LHAHO9Pg8ncbPtHYqSdbUqldXyZAJFWkiA5eZLWiETnaL3jEG/kqwTteLABROPzLIkgA
        Zpst41GrdOml+YO9shu8ipAlGjeaXku/Eg289QbbakMAfBvmLa7/v03aWZ52KDz7kLrjxCn+BB4/N
        bZ+vLI+A==;
Received: from [2001:8b0:10b:1::3ae] (helo=u3832b3a9db3152.ant.amazon.com)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lw3Iu-00Ario-TR; Wed, 23 Jun 2021 13:52:33 +0000
Message-ID: <e8843f32aa14baff398584e5b3a00d20994836b6.camel@infradead.org>
Subject: Re: [PATCH v2 1/4] net: tun: fix tun_xdp_one() for IFF_TUN mode
From:   David Woodhouse <dwmw2@infradead.org>
To:     Jason Wang <jasowang@redhat.com>, netdev@vger.kernel.org
Cc:     Eugenio =?ISO-8859-1?Q?P=E9rez?= <eperezma@redhat.com>
Date:   Wed, 23 Jun 2021 14:52:30 +0100
In-Reply-To: <fedca272-a03e-4bac-4038-2bb1f6b4df84@redhat.com>
References: <03ee62602dd7b7101f78e0802249a6e2e4c10b7f.camel@infradead.org>
         <20210622161533.1214662-1-dwmw2@infradead.org>
         <fedca272-a03e-4bac-4038-2bb1f6b4df84@redhat.com>
X-Priority: 1
Content-Type: multipart/signed; micalg="sha-256";
        protocol="application/x-pkcs7-signature";
        boundary="=-ZUNNODiHTCBd5hDNyXRy"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-ZUNNODiHTCBd5hDNyXRy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2021-06-23 at 11:45 +0800, Jason Wang wrote:
>=20
> As replied in previous version, it would be better if we can unify=20
> similar logic in tun_get_user().

So that ends up looking something like this (incremental).

Note the '/* XXX: frags && */' part in tun_skb_set_protocol(), because
the 'frags &&' was there in tun_get_user() and it wasn't obvious to me
whether I should be lifting that out as a separate argument to
tun_skb_set_protocol() or if there's a better way.

Either way, in my judgement this is less suitable for a stable fix and
more appropriate for a follow-on cleanup. But I don't feel that
strongly; I'm more than happy for you to overrule me on that.
Especially if you fix the above XXX part while you're at it :)

I tested this with vhost-net and !IFF_NO_PI, and TX works. RX is still
hosed on the vhost-net side, for the same reason that a bunch of test
cases were already listed in #if 0, but I'll address that in a separate
email. It's not part of *this* patch.

--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1641,6 +1641,40 @@ static struct sk_buff *tun_build_skb(struct tun_stru=
ct *tun,
 	return NULL;
 }
=20
+static int tun_skb_set_protocol(struct tun_struct *tun, struct sk_buff *sk=
b,
+				__be16 pi_proto)
+{
+	switch (tun->flags & TUN_TYPE_MASK) {
+	case IFF_TUN:
+		if (tun->flags & IFF_NO_PI) {
+			u8 ip_version =3D skb->len ? (skb->data[0] >> 4) : 0;
+
+			switch (ip_version) {
+			case 4:
+				pi_proto =3D htons(ETH_P_IP);
+				break;
+			case 6:
+				pi_proto =3D htons(ETH_P_IPV6);
+				break;
+			default:
+				return -EINVAL;
+			}
+		}
+
+		skb_reset_mac_header(skb);
+		skb->protocol =3D pi_proto;
+		skb->dev =3D tun->dev;
+		break;
+	case IFF_TAP:
+		if (/* XXX frags && */!pskb_may_pull(skb, ETH_HLEN))
+			return -ENOMEM;
+
+		skb->protocol =3D eth_type_trans(skb, tun->dev);
+		break;
+	}
+	return 0;
+}
+
 /* Get packet from user space buffer */
 static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile=
,
 			    void *msg_control, struct iov_iter *from,
@@ -1784,37 +1818,9 @@ static ssize_t tun_get_user(struct tun_struct *tun, =
struct tun_file *tfile,
 		return -EINVAL;
 	}
=20
-	switch (tun->flags & TUN_TYPE_MASK) {
-	case IFF_TUN:
-		if (tun->flags & IFF_NO_PI) {
-			u8 ip_version =3D skb->len ? (skb->data[0] >> 4) : 0;
-
-			switch (ip_version) {
-			case 4:
-				pi.proto =3D htons(ETH_P_IP);
-				break;
-			case 6:
-				pi.proto =3D htons(ETH_P_IPV6);
-				break;
-			default:
-				atomic_long_inc(&tun->dev->rx_dropped);
-				kfree_skb(skb);
-				return -EINVAL;
-			}
-		}
-
-		skb_reset_mac_header(skb);
-		skb->protocol =3D pi.proto;
-		skb->dev =3D tun->dev;
-		break;
-	case IFF_TAP:
-		if (frags && !pskb_may_pull(skb, ETH_HLEN)) {
-			err =3D -ENOMEM;
-			goto drop;
-		}
-		skb->protocol =3D eth_type_trans(skb, tun->dev);
-		break;
-	}
+	err =3D tun_skb_set_protocol(tun, skb, pi.proto);
+	if (err)
+		goto drop;
=20
 	/* copy skb_ubuf_info for callback when skb has no error */
 	if (zerocopy) {
@@ -2334,8 +2340,10 @@ static int tun_xdp_one(struct tun_struct *tun,
 	struct virtio_net_hdr *gso =3D NULL;
 	struct bpf_prog *xdp_prog;
 	struct sk_buff *skb =3D NULL;
+	__be16 proto =3D 0;
 	u32 rxhash =3D 0, act;
 	int buflen =3D hdr->buflen;
+	int reservelen =3D xdp->data - xdp->data_hard_start;
 	int err =3D 0;
 	bool skb_xdp =3D false;
 	struct page *page;
@@ -2343,6 +2351,17 @@ static int tun_xdp_one(struct tun_struct *tun,
 	if (tun->flags & IFF_VNET_HDR)
 		gso =3D &hdr->gso;
=20
+	if (!(tun->flags & IFF_NO_PI)) {
+		struct tun_pi *pi =3D xdp->data;
+		if (datasize < sizeof(*pi)) {
+			atomic_long_inc(&tun->rx_frame_errors);
+			return  -EINVAL;
+		}
+		proto =3D pi->proto;
+		reservelen +=3D sizeof(*pi);
+		datasize -=3D sizeof(*pi);
+	}
+
 	xdp_prog =3D rcu_dereference(tun->xdp_prog);
 	if (xdp_prog) {
 		if (gso && gso->gso_type) {
@@ -2388,8 +2407,8 @@ static int tun_xdp_one(struct tun_struct *tun,
 		goto out;
 	}
=20
-	skb_reserve(skb, xdp->data - xdp->data_hard_start);
-	skb_put(skb, xdp->data_end - xdp->data);
+	skb_reserve(skb, reservelen);
+	skb_put(skb, datasize);
=20
 	if (gso && virtio_net_hdr_to_skb(skb, gso, tun_is_little_endian(tun))) {
 		atomic_long_inc(&tun->rx_frame_errors);
@@ -2397,48 +2416,12 @@ static int tun_xdp_one(struct tun_struct *tun,
 		err =3D -EINVAL;
 		goto out;
 	}
-	switch (tun->flags & TUN_TYPE_MASK) {
-	case IFF_TUN:
-		if (tun->flags & IFF_NO_PI) {
-			u8 ip_version =3D skb->len ? (skb->data[0] >> 4) : 0;
=20
-			switch (ip_version) {
-			case 4:
-				skb->protocol =3D htons(ETH_P_IP);
-				break;
-			case 6:
-				skb->protocol =3D htons(ETH_P_IPV6);
-				break;
-			default:
-				atomic_long_inc(&tun->dev->rx_dropped);
-				kfree_skb(skb);
-				err =3D -EINVAL;
-				goto out;
-			}
-		} else {
-			struct tun_pi *pi =3D (struct tun_pi *)skb->data;
-			if (!pskb_may_pull(skb, sizeof(*pi))) {
-				atomic_long_inc(&tun->dev->rx_dropped);
-				kfree_skb(skb);
-				err =3D -ENOMEM;
-				goto out;
-			}
-			skb_pull_inline(skb, sizeof(*pi));
-			skb->protocol =3D pi->proto;
-		}
-
-		skb_reset_mac_header(skb);
-		skb->dev =3D tun->dev;
-		break;
-	case IFF_TAP:
-		if (!pskb_may_pull(skb, ETH_HLEN)) {
-			atomic_long_inc(&tun->dev->rx_dropped);
-			kfree_skb(skb);
-			err =3D -ENOMEM;
-			goto out;
-		}
-		skb->protocol =3D eth_type_trans(skb, tun->dev);
-		break;
+	err =3D tun_skb_set_protocol(tun, skb, proto);
+	if (err) {
+		atomic_long_inc(&tun->dev->rx_dropped);
+		kfree_skb(skb);
+		goto out;
 	}
=20
 	skb_reset_network_header(skb);


--=-ZUNNODiHTCBd5hDNyXRy
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
NjIzMTM1MjMwWjAvBgkqhkiG9w0BCQQxIgQgPe9JOlozoxsd36q6tnbFk2XNWxfBxNBEY5IaOksd
+Rkwgb4GCSsGAQQBgjcQBDGBsDCBrTCBlzELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIg
TWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQx
PTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1h
aWwgQ0ECEQDiu0lIeSrsCenEpRjxmVhmMIHABgsqhkiG9w0BCRACCzGBsKCBrTCBlzELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgG
A1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhl
bnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0ECEQDiu0lIeSrsCenEpRjxmVhmMA0GCSqGSIb3
DQEBAQUABIIBAB/mkW1W4oeR+ySNWgXbfFk2VaTdJ/4MkuBAQAQT4bS+u4i21bfK/FRPDLPY31mj
v4DflulFC9Qa/uKRCeonaovi8d1C2L+xA+HwdnMQVSL9g814MSe74h/EibIk5Nn2E66JfQtLyep+
Scxl8A7CKBzFLvqp6E//A6r65MFtgAHnk/9N+OuL58v8BtNZw43BWpZquL2ySis80EaF6HXHXKHH
pyD9VAU0np8gVzb/YLxRUIbm2OUuJVjetA9kG5qYeyVPa0XH/VgfLPh6hy98+FpZ0he0bVdBKoj9
iBI448S2BNgNrthuroGAowLcngG1jiR8HJ+zo7Qvzl6SRrPF5HIAAAAAAAA=


--=-ZUNNODiHTCBd5hDNyXRy--

