Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D974D5CF96
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 14:37:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbfGBMhd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 08:37:33 -0400
Received: from linuxlounge.net ([88.198.164.195]:58058 "EHLO linuxlounge.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726167AbfGBMhc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jul 2019 08:37:32 -0400
Subject: Re: [PATCH net 2/4] net: bridge: mcast: fix stale ipv6 hdr pointer
 when handling v6 query
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxlounge.net;
        s=mail; t=1562071051;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:content-type:content-type:in-reply-to:in-reply-to:
         references:references:openpgp:openpgp:autocrypt:autocrypt;
        bh=QwFRkItdW1M7k4agnxTsrRvmLb/4bS9WjKKcKoKQ+Xw=;
        b=uFMFM7iuNjrk0oV+0w6ldYsORzv+QTLui1LftPBTockPtiRVI6V08jpc3Yo8JsglcDk021
        FhOAajzg2HXVA5kzsOaoN4lf/j2ETGs5DbepGfi7BQI7wVrG8OST/Jej7z4M/b7dtpZxR5
        8NtBWKQe2JRBIZM3SQzOQljIl3buy9Q=
To:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        netdev@vger.kernel.org
Cc:     roopa@cumulusnetworks.com, davem@davemloft.net,
        bridge@lists.linux-foundation.org, yoshfuji@linux-ipv6.org
References: <20190702120021.13096-1-nikolay@cumulusnetworks.com>
 <20190702120021.13096-3-nikolay@cumulusnetworks.com>
From:   Martin Weinelt <martin@linuxlounge.net>
Openpgp: preference=signencrypt
Autocrypt: addr=martin@linuxlounge.net; prefer-encrypt=mutual; keydata=
 mQENBEv1rfkBCADFlzzmynjVg8L5ok/ef2Jxz8D96PtEAP//3U612b4QbHXzHC6+C2qmFEL6
 5kG1U1a7PPsEaS/A6K9AUpDhT7y6tX1IxAkSkdIEmIgWC5Pu2df4+xyWXarJfqlBeJ82biot
 /qETntfo01wm0AtqfJzDh/BkUpQw0dbWBSnAF6LytoNEggIGnUGmzvCidrEEsTCO6YlHfKIH
 cpz7iwgVZi4Ajtsky8v8P8P7sX0se/ce1L+qX/qN7TnXpcdVSfZpMnArTPkrmlJT4inBLhKx
 UeDMQmHe+BQvATa21fhcqi3BPIMwIalzLqVSIvRmKY6oYdCbKLM2TZ5HmyJepusl2Gi3ABEB
 AAG0J01hcnRpbiBXZWluZWx0IDxtYXJ0aW5AbGludXhsb3VuZ2UubmV0PokBWAQTAQoAQgIb
 IwYLCQgHAwIGFQgCCQoLBBYCAwECHgECF4ACGQEWIQTu0BYCvL0ZbDi8mh+9SqBSj2PxfgUC
 W/RuFQUJEd/znAAKCRC9SqBSj2PxfpfDCACDx6BYz6cGMiweQ96lXi+ihx7RBaXsfPp2KxUo
 eHilrDPqknq62XJibCyNCJiYGNb+RUS5WfDUAqxdl4HuNxQMC/sYlbP4b7p9Y1Q9QiTP4f6M
 8+Uvpicin+9H/lye5hS/Gp2KUiVI/gzqW68WqMhARUYw00lVSlJHy+xHEGVuQ0vmeopjU81R
 0si4+HhMX2HtILTxoUcvm67AFKidTHYMJKwNyMHiLLvSK6wwiy+MXaiqrMVTwSIOQhLgLVcJ
 33GNJ2Emkgkhs6xcaiN8xTjxDmiU7b5lXW4JiAsd1rbKINajcA7DVlZ/evGfpN9FczyZ4W6F
 Rf21CxSwtqv2SQHBuQENBEv1rfkBCADJX6bbb5LsXjdxDeFgqo+XRUvW0bzuS3SYNo0fuktM
 5WYMCX7TzoF556QU8A7C7bDUkT4THBUzfaA8ZKIuneYW2WN1OI0zRMpmWVeZcUQpXncWWKCg
 LBNYtk9CCukPE0OpDFnbR+GhGd1KF/YyemYnzwW2f1NOtHjwT3iuYnzzZNlWoZAR2CRSD02B
 YU87Mr2CMXrgG/pdRiaD+yBUG9RxCUkIWJQ5dcvgrsg81vOTj6OCp/47Xk/457O0pUFtySKS
 jZkZN6S7YXl/t+8C9g7o3N58y/X95VVEw/G3KegUR2SwcLdok4HaxgOy5YHiC+qtGNZmDiQn
 NXN7WIN/oof7ABEBAAGJATwEGAEKACYCGwwWIQTu0BYCvL0ZbDi8mh+9SqBSj2PxfgUCW/Ru
 GAUJEd/znwAKCRC9SqBSj2PxfpzMCACH55MVYTVykq+CWj1WMKHex9iFg7M9DkWQCF/Zl+0v
 QmyRMEMZnFW8GdX/Qgd4QbZMUTOGevGxFPTe4p0PPKqKEDXXXxTTHQETE/Hl0jJvyu+MgTxG
 E9/KrWmsmQC7ogTFCHf0vvVY3UjWChOqRE19Buk4eYpMbuU1dYefLNcD15o4hGDhohYn3SJr
 q9eaoO6rpnNIrNodeG+1vZYG1B2jpEdU4v354ziGcibt5835IONuVdvuZMFQJ4Pn2yyC+qJe
 ekXwZ5f4JEt0lWD9YUxB2cU+xM9sbDcQ2b6+ypVFzMyfU0Q6LzYugAqajZ10gWKmeyjisgyq
 sv5UJTKaOB/t
Message-ID: <fdd4c5d2-1872-bac5-3aa9-107e2081b18f@linuxlounge.net>
Date:   Tue, 2 Jul 2019 14:37:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
In-Reply-To: <20190702120021.13096-3-nikolay@cumulusnetworks.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="aUTpxe2HGk2DC1XXzq6MoiRXZ0eHKSzRs"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--aUTpxe2HGk2DC1XXzq6MoiRXZ0eHKSzRs
Content-Type: multipart/mixed; boundary="NfWoGR4PvcfAR9f75qVkkbowdPSqBgO69";
 protected-headers="v1"
From: Martin Weinelt <martin@linuxlounge.net>
To: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>, netdev@vger.kernel.org
Cc: roopa@cumulusnetworks.com, davem@davemloft.net,
 bridge@lists.linux-foundation.org, yoshfuji@linux-ipv6.org
Message-ID: <fdd4c5d2-1872-bac5-3aa9-107e2081b18f@linuxlounge.net>
Subject: Re: [PATCH net 2/4] net: bridge: mcast: fix stale ipv6 hdr pointer
 when handling v6 query
References: <20190702120021.13096-1-nikolay@cumulusnetworks.com>
 <20190702120021.13096-3-nikolay@cumulusnetworks.com>
In-Reply-To: <20190702120021.13096-3-nikolay@cumulusnetworks.com>

--NfWoGR4PvcfAR9f75qVkkbowdPSqBgO69
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Tested-by: Martin Weinelt <martin@linuxlounge.net>

On 7/2/19 2:00 PM, Nikolay Aleksandrov wrote:
> We get a pointer to the ipv6 hdr in br_ip6_multicast_query but we may
> call pskb_may_pull afterwards and end up using a stale pointer.
> So use the header directly, it's just 1 place where it's needed.
>=20
> Fixes: 08b202b67264 ("bridge br_multicast: IPv6 MLD support.")
> Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
> ---
>  net/bridge/br_multicast.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>=20
> diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
> index f37897e7b97b..3d8deac2353d 100644
> --- a/net/bridge/br_multicast.c
> +++ b/net/bridge/br_multicast.c
> @@ -1279,7 +1279,6 @@ static int br_ip6_multicast_query(struct net_brid=
ge *br,
>  				  u16 vid)
>  {
>  	unsigned int transport_len =3D ipv6_transport_len(skb);
> -	const struct ipv6hdr *ip6h =3D ipv6_hdr(skb);
>  	struct mld_msg *mld;
>  	struct net_bridge_mdb_entry *mp;
>  	struct mld2_query *mld2q;
> @@ -1323,7 +1322,7 @@ static int br_ip6_multicast_query(struct net_brid=
ge *br,
> =20
>  	if (is_general_query) {
>  		saddr.proto =3D htons(ETH_P_IPV6);
> -		saddr.u.ip6 =3D ip6h->saddr;
> +		saddr.u.ip6 =3D ipv6_hdr(skb)->saddr;
> =20
>  		br_multicast_query_received(br, port, &br->ip6_other_query,
>  					    &saddr, max_delay);
>=20



--NfWoGR4PvcfAR9f75qVkkbowdPSqBgO69--

--aUTpxe2HGk2DC1XXzq6MoiRXZ0eHKSzRs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEE7tAWAry9GWw4vJofvUqgUo9j8X4FAl0bUAgACgkQvUqgUo9j
8X5fcAf/cxwx2Jd5RMEWJU3S5Mc06qa6MpH+ssC31UKha2emhkwE4wZxkknT7viv
CRTcMcWJRPk4qkrYHFYpWuy5z7G+fjS9PlhwzHrIbtF8Qv+zausK+MTFqeI6QtsC
z3xrUPvb6oO0l1cqAAuwezXH+1HBmN97tTNXZrBQe2fjaYC5fZ+qUD8PsxpxT5QA
37WJvkb7BVQhkXPZLCNFZpO/0R6dtNlx0c/iHX4LyaSGuXOd5Z3ZppvAiQL9UGtp
lw7CjWuLhLhWU2s4yrXTc1gOEMJnRZDU/rO39Xck0Zf4K3pMsWxQx82B1LqrExfB
LsxsDRwFEjjO7gQdld64Qj/XnH2rsw==
=74Je
-----END PGP SIGNATURE-----

--aUTpxe2HGk2DC1XXzq6MoiRXZ0eHKSzRs--
