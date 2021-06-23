Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59E1B3B1E6A
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 18:12:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229916AbhFWQOi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 12:14:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbhFWQOh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 12:14:37 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EDC2C061574
        for <netdev@vger.kernel.org>; Wed, 23 Jun 2021 09:12:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Mime-Version:Content-Type:References:
        In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=pVHLK11DVLPLd73BDgce8I+2Nwl7nzGJNY1mWY2pU/c=; b=E/pQG72r2/MedqdaPIj5Kfd3+S
        ritDlAcb1Tw1IobYEfTDJau8JF8MROdSur6RqJqQEFiPnbZoRDIAVBy+gaMUGJlmEW7ZUBhXS/9sH
        pRfzvWvKPj4cNaHvzuiKP4a5Zhuw649Wf3jj8GF0yaewzLf7X1itqK1HLWYUvu3BnCb2Q1LsymhtW
        fIjofDRHgDS9VeQweD5TyXOSSqrs+gxI9y1dx779nFjy+gBt+MTwyDi51wW3PnYWBRT0smgxYJXBJ
        G1pPUv4ewgeLqkYLdP4dRMg2ZXiG0/Eq8RKURHUAJeGmKLnGk3tZE+KToV4OA1P8Fgjexjv82NOQo
        Ea+upsqA==;
Received: from [2001:8b0:10b:1::3ae] (helo=u3832b3a9db3152.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lw5UB-00BDhG-Gp; Wed, 23 Jun 2021 16:12:20 +0000
Message-ID: <d6ad85649fd56d3e12e59085836326a09885593b.camel@infradead.org>
Subject: Re: [PATCH v2 4/4] vhost_net: Add self test with tun device
From:   David Woodhouse <dwmw2@infradead.org>
To:     Jason Wang <jasowang@redhat.com>, netdev@vger.kernel.org
Cc:     Eugenio =?ISO-8859-1?Q?P=E9rez?= <eperezma@redhat.com>
Date:   Wed, 23 Jun 2021 17:12:16 +0100
In-Reply-To: <85e55d53-4ef2-0b61-234e-4b5f30909efa@redhat.com>
References: <03ee62602dd7b7101f78e0802249a6e2e4c10b7f.camel@infradead.org>
         <20210622161533.1214662-1-dwmw2@infradead.org>
         <20210622161533.1214662-4-dwmw2@infradead.org>
         <85e55d53-4ef2-0b61-234e-4b5f30909efa@redhat.com>
Content-Type: multipart/signed; micalg="sha-256";
        protocol="application/x-pkcs7-signature";
        boundary="=-8aa8k3QPOX25U9FQNdla"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-8aa8k3QPOX25U9FQNdla
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2021-06-23 at 12:02 +0800, Jason Wang wrote:
> =E5=9C=A8 2021/6/23 =E4=B8=8A=E5=8D=8812:15, David Woodhouse =E5=86=99=E9=
=81=93:
> > From: David Woodhouse <dwmw@amazon.co.uk>
> >=20
> > This creates a tun device and brings it up, then finds out the link-loc=
al
> > address the kernel automatically assigns to it.
> >=20
> > It sends a ping to that address, from a fake LL address of its own, and
> > then waits for a response.
> >=20
> > If the virtio_net_hdr stuff is all working correctly, it gets a respons=
e
> > and manages to understand it.
>=20
>=20
> I wonder whether it worth to bother the dependency like ipv6 or kernel=
=20
> networking stack.
>=20
> How about simply use packet socket that is bound to tun to receive and=
=20
> send packets?
>=20

I pondered that but figured that using the kernel's network stack
wasn't too much of an additional dependency. We *could* use an
AF_PACKET socket on the tun device and then drive both ends, but given
that the kernel *automatically* assigns a link-local address when we
bring the device up anyway, it seemed simple enough just to use ICMP.
I also happened to have the ICMP generation/checking code lying around
anyway in the same emacs instance, so it was reduced to a previously
solved problem.

We *should* eventually expand this test case to attach an AF_PACKET
device to the vhost-net, instead of using a tun device as the back end.
(Although I don't really see *why* vhost is limited to AF_PACKET. Why
*can't* I attach anything else, like an AF_UNIX socket, to vhost-net?)


> > +	/*
> > +	 * I just want to map the *whole* of userspace address space. But
> > +	 * from userspace I don't know what that is. On x86_64 it would be:
> > +	 *
> > +	 * vmem->regions[0].guest_phys_addr =3D 4096;
> > +	 * vmem->regions[0].memory_size =3D 0x7fffffffe000;
> > +	 * vmem->regions[0].userspace_addr =3D 4096;
> > +	 *
> > +	 * For now, just ensure we put everything inside a single BSS region.
> > +	 */
> > +	vmem->regions[0].guest_phys_addr =3D (uint64_t)&rings;
> > +	vmem->regions[0].userspace_addr =3D (uint64_t)&rings;
> > +	vmem->regions[0].memory_size =3D sizeof(rings);
>=20
>=20
> Instead of doing tricks like this, we can do it in another way:
>=20
> 1) enable device IOTLB
> 2) wait for the IOTLB miss request (iova, len) and update identity=20
> mapping accordingly
>=20
> This should work for all the archs (with some performance hit).

Ick. For my actual application (OpenConnect) I'm either going to suck
it up and put in the arch-specific limits like in the comment above, or
I'll fix things to do the VHOST_F_IDENTITY_MAPPING thing we're talking
about elsewhere. (Probably the former, since if I'm requiring kernel
changes then I have grander plans around extending AF_TLS to do DTLS,
then hooking that directly up to the tun socket via BPF and a sockmap
without the data frames ever going to userspace at all.)

For this test case, a hard-coded single address range in BSS is fine.

I've now added !IFF_NO_PI support to the test case, but as noted it
fails just like the other ones I'd already marked with #if 0, which is
because vhost-net pulls some value for 'sock_hlen' out of its posterior
based on some assumption around the vhost features. And then expects
sock_recvmsg() to return precisely that number of bytes more than the
value it peeks in the skb at the head of the sock's queue.

I think I can fix *all* those test cases by making tun_get_socket()
take an extra 'int *' argument, and use that to return the *actual*
value of sock_hlen. Here's the updated test case in the meantime:


=46rom cf74e3fc80b8fd9df697a42cfc1ff3887de18f78 Mon Sep 17 00:00:00 2001
From: David Woodhouse <dwmw@amazon.co.uk>
Date: Wed, 23 Jun 2021 16:38:56 +0100
Subject: [PATCH] test_vhost_net: add test cases with tun_pi header

These fail too, for the same reason as the previous tests were
guarded with #if 0: vhost-net pulls 'sock_hlen' out of its
posterior and just assumes it's 10 bytes. And then barfs when
a sock_recvmsg() doesn't return precisely ten bytes more than
it peeked in the head skb:

[1296757.531103] Discarded rx packet:  len 78, expected 74

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 .../testing/selftests/vhost/test_vhost_net.c  | 97 +++++++++++++------
 1 file changed, 65 insertions(+), 32 deletions(-)

diff --git a/tools/testing/selftests/vhost/test_vhost_net.c b/tools/testing=
/selftests/vhost/test_vhost_net.c
index fd4a2b0e42f0..734b3015a5bd 100644
--- a/tools/testing/selftests/vhost/test_vhost_net.c
+++ b/tools/testing/selftests/vhost/test_vhost_net.c
@@ -48,7 +48,7 @@ static unsigned char hexchar(char *hex)
 	return (hexnybble(hex[0]) << 4) | hexnybble(hex[1]);
 }
=20
-int open_tun(int vnet_hdr_sz, struct in6_addr *addr)
+int open_tun(int vnet_hdr_sz, int pi, struct in6_addr *addr)
 {
 	int tun_fd =3D open("/dev/net/tun", O_RDWR);
 	if (tun_fd =3D=3D -1)
@@ -56,7 +56,9 @@ int open_tun(int vnet_hdr_sz, struct in6_addr *addr)
=20
 	struct ifreq ifr =3D { 0 };
=20
-	ifr.ifr_flags =3D IFF_TUN | IFF_NO_PI;
+	ifr.ifr_flags =3D IFF_TUN;
+	if (!pi)
+		ifr.ifr_flags |=3D IFF_NO_PI;
 	if (vnet_hdr_sz)
 		ifr.ifr_flags |=3D IFF_VNET_HDR;
=20
@@ -249,11 +251,18 @@ static inline uint16_t csum_finish(uint32_t sum)
 	return htons((uint16_t)(~sum));
 }
=20
-static int create_icmp_echo(unsigned char *data, struct in6_addr *dst,
+static int create_icmp_echo(unsigned char *data, int pi, struct in6_addr *=
dst,
 			    struct in6_addr *src, uint16_t id, uint16_t seq)
 {
 	const int icmplen =3D ICMP_MINLEN + sizeof(ping_payload);
-	const int plen =3D sizeof(struct ip6_hdr) + icmplen;
+	int plen =3D sizeof(struct ip6_hdr) + icmplen;
+
+	if (pi) {
+		struct tun_pi *pi =3D (void *)data;
+		data +=3D sizeof(*pi);
+		plen +=3D sizeof(*pi);
+		pi->proto =3D htons(ETH_P_IPV6);
+	}
=20
 	struct ip6_hdr *iph =3D (void *)data;
 	struct icmp6_hdr *icmph =3D (void *)(data + sizeof(*iph));
@@ -312,8 +321,21 @@ static int create_icmp_echo(unsigned char *data, struc=
t in6_addr *dst,
 }
=20
=20
-static int check_icmp_response(unsigned char *data, uint32_t len, struct i=
n6_addr *dst, struct in6_addr *src)
+static int check_icmp_response(unsigned char *data, uint32_t len, int pi,
+			       struct in6_addr *dst, struct in6_addr *src)
 {
+	if (pi) {
+		struct tun_pi *pi =3D (void *)data;
+		if (len < sizeof(*pi))
+			return 0;
+
+		if (pi->proto !=3D htons(ETH_P_IPV6))
+			return 0;
+
+		data +=3D sizeof(*pi);
+		len -=3D sizeof(*pi);
+	}
+
 	struct ip6_hdr *iph =3D (void *)data;
 	return ( len >=3D 41 && (ntohl(iph->ip6_flow) >> 28)=3D=3D6 /* IPv6 heade=
r */
 		 && iph->ip6_nxt =3D=3D IPPROTO_ICMPV6 /* IPv6 next header field =3D ICM=
Pv6 */
@@ -337,7 +359,7 @@ static int check_icmp_response(unsigned char *data, uin=
t32_t len, struct in6_add
 #endif
=20
=20
-int test_vhost(int vnet_hdr_sz, int xdp, uint64_t features)
+int test_vhost(int vnet_hdr_sz, int pi, int xdp, uint64_t features)
 {
 	int call_fd =3D eventfd(0, EFD_CLOEXEC|EFD_NONBLOCK);
 	int kick_fd =3D eventfd(0, EFD_CLOEXEC|EFD_NONBLOCK);
@@ -353,7 +375,7 @@ int test_vhost(int vnet_hdr_sz, int xdp, uint64_t featu=
res)
 	/* Pick up the link-local address that the kernel
 	 * assigns to the tun device. */
 	struct in6_addr tun_addr;
-	tun_fd =3D open_tun(vnet_hdr_sz, &tun_addr);
+	tun_fd =3D open_tun(vnet_hdr_sz, pi, &tun_addr);
 	if (tun_fd < 0)
 		goto err;
=20
@@ -387,18 +409,18 @@ int test_vhost(int vnet_hdr_sz, int xdp, uint64_t fea=
tures)
 	local_addr.s6_addr16[0] =3D htons(0xfe80);
 	local_addr.s6_addr16[7] =3D htons(1);
=20
+
 	/* Set up RX and TX descriptors; the latter with ping packets ready to
 	 * send to the kernel, but don't actually send them yet. */
 	for (int i =3D 0; i < RING_SIZE; i++) {
 		struct pkt_buf *pkt =3D &rings[1].pkts[i];
-		int plen =3D create_icmp_echo(&pkt->data[vnet_hdr_sz], &tun_addr,
-					    &local_addr, 0x4747, i);
+		int plen =3D create_icmp_echo(&pkt->data[vnet_hdr_sz], pi,
+					    &tun_addr, &local_addr, 0x4747, i);
=20
 		rings[1].desc[i].addr =3D vio64((uint64_t)pkt);
 		rings[1].desc[i].len =3D vio32(plen + vnet_hdr_sz);
 		rings[1].avail_ring[i] =3D vio16(i);
=20
-
 		pkt =3D &rings[0].pkts[i];
 		rings[0].desc[i].addr =3D vio64((uint64_t)pkt);
 		rings[0].desc[i].len =3D vio32(sizeof(*pkt));
@@ -438,9 +460,10 @@ int test_vhost(int vnet_hdr_sz, int xdp, uint64_t feat=
ures)
 				return -1;
=20
 			if (check_icmp_response((void *)(addr + vnet_hdr_sz), len - vnet_hdr_sz=
,
-						&local_addr, &tun_addr)) {
+						pi, &local_addr, &tun_addr)) {
 				ret =3D 0;
-				printf("Success (%d %d %llx)\n", vnet_hdr_sz, xdp, (unsigned long long=
)features);
+				printf("Success (hdr %d, xdp %d, pi %d, features %llx)\n",
+				       vnet_hdr_sz, xdp, pi, (unsigned long long)features);
 				goto err;
 			}
=20
@@ -466,51 +489,61 @@ int test_vhost(int vnet_hdr_sz, int xdp, uint64_t fea=
tures)
 	return ret;
 }
=20
-
-int main(void)
+/* Perform the given test with all four combinations of XDP/PI */
+int test_four(int vnet_hdr_sz, uint64_t features)
 {
-	int ret;
-
-	ret =3D test_vhost(0, 0, ((1ULL << VHOST_NET_F_VIRTIO_NET_HDR) |
-				(1ULL << VIRTIO_F_VERSION_1)));
+	int ret =3D test_vhost(vnet_hdr_sz, 0, 0, features);
 	if (ret && ret !=3D KSFT_SKIP)
 		return ret;
=20
-	ret =3D test_vhost(0, 1, ((1ULL << VHOST_NET_F_VIRTIO_NET_HDR) |
-				(1ULL << VIRTIO_F_VERSION_1)));
+	ret =3D test_vhost(vnet_hdr_sz, 0, 1, features);
 	if (ret && ret !=3D KSFT_SKIP)
 		return ret;
-
-	ret =3D test_vhost(0, 0, ((1ULL << VHOST_NET_F_VIRTIO_NET_HDR)));
+#if 0 /* These don't work *either* for the same reason as the #if 0 later =
*/
+	ret =3D test_vhost(vnet_hdr_sz, 1, 0, features);
 	if (ret && ret !=3D KSFT_SKIP)
 		return ret;
=20
-	ret =3D test_vhost(0, 1, ((1ULL << VHOST_NET_F_VIRTIO_NET_HDR)));
+	ret =3D test_vhost(vnet_hdr_sz, 1, 1, features);
 	if (ret && ret !=3D KSFT_SKIP)
 		return ret;
+#endif
+}
=20
-	ret =3D test_vhost(10, 0, 0);
-	if (ret && ret !=3D KSFT_SKIP)
-		return ret;
+int main(void)
+{
+	int ret;
=20
-	ret =3D test_vhost(10, 1, 0);
+	ret =3D test_four(10, 0);
 	if (ret && ret !=3D KSFT_SKIP)
 		return ret;
=20
-#if 0 /* These ones will fail */
-	ret =3D test_vhost(0, 0, 0);
+	ret =3D test_four(0, ((1ULL << VHOST_NET_F_VIRTIO_NET_HDR) |
+			    (1ULL << VIRTIO_F_VERSION_1)));
 	if (ret && ret !=3D KSFT_SKIP)
 		return ret;
=20
-	ret =3D test_vhost(0, 1, 0);
+	ret =3D test_four(0, ((1ULL << VHOST_NET_F_VIRTIO_NET_HDR)));
 	if (ret && ret !=3D KSFT_SKIP)
 		return ret;
=20
-	ret =3D test_vhost(12, 0, 0);
+
+#if 0
+	/*
+	 * These ones will fail, because right now vhost *assumes* that the
+	 * underlying (tun, etc.) socket will be doing a header of precisely
+	 * sizeof(struct virtio_net_hdr), if vhost isn't doing so itself due
+	 * to VHOST_NET_F_VIRTIO_NET_HDR.
+	 *
+	 * That assumption breaks both tun with no IFF_VNET_HDR, and also
+	 * presumably raw sockets. So leave these test cases disabled for
+	 * now until it's fixed.
+	 */
+	ret =3D test_four(0, 0);
 	if (ret && ret !=3D KSFT_SKIP)
 		return ret;
=20
-	ret =3D test_vhost(12, 1, 0);
+	ret =3D test_four(12, 0);
 	if (ret && ret !=3D KSFT_SKIP)
 		return ret;
 #endif
--=20
2.31.1


--=-8aa8k3QPOX25U9FQNdla
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
NjIzMTYxMjE3WjAvBgkqhkiG9w0BCQQxIgQgVhZLQCIewdLnEA9g/b9J+vJAuyUaTWx3DluhMLr9
rtQwgb4GCSsGAQQBgjcQBDGBsDCBrTCBlzELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIg
TWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQx
PTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1h
aWwgQ0ECEQDiu0lIeSrsCenEpRjxmVhmMIHABgsqhkiG9w0BCRACCzGBsKCBrTCBlzELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgG
A1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhl
bnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0ECEQDiu0lIeSrsCenEpRjxmVhmMA0GCSqGSIb3
DQEBAQUABIIBAHtf69wkjCwROoSjA5Snbbb3Z3lHkSQ4Oe0Ru3lA/lqD/pWMFNFKSpMp0MCHYH0+
YrpTjM8ChhO1wL1eUNShidNKuDjyXIpwAioy6glYFkjwERneQuL3wZ9qz2PeG4KoNLXdWx6/XL9c
vh1Ki2nvjYUBGb/IQ3ZZstIZijfy6GduljS2e02BGkbMLx3Iqp5GokGuqZ6AzbGGn68hYENfJiUo
SIKVm4O6SNmSe028ocJWuc3AP0ztJTatpGUkhB/AxAaKldoD3czDIaR0SOVi2MEhvQWNKKKjmn/e
mXXFNoaysRoYStb36Ac5xHD9VpPnDZnjS9kwdJqRkFjuGFjATF0AAAAAAAA=


--=-8aa8k3QPOX25U9FQNdla--

