Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BEFB5B1243
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 03:59:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230098AbiIHB72 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 21:59:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiIHB71 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 21:59:27 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0851CB18;
        Wed,  7 Sep 2022 18:59:22 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4MNMkD69YTz4xD3;
        Thu,  8 Sep 2022 11:59:16 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1662602358;
        bh=WQMypIQOXO6oFTr6CtsUzHPJrofSi4/VF3WEKPql46Y=;
        h=Date:From:To:Cc:Subject:From;
        b=oSh+TKlbIv9LRKLxRquA2TzOo4W3OdzwUNPL5uv7b+piKZ4Bpj5FcuoXuM88VQ7EZ
         7/71PyQfM2W5RKMvl9yrjIL8Qa05PiwcPmRDqiQrcy0iGmY8tFHZUPxJcnoUleil1R
         cf6qS86ego8ocxZDKlKm/Ih2230trTafvt1yl7tcb1AnxspqGSAt3Djk/DKu7dU//3
         0zQntMYD8BJayloVZk0WYuDuJrp453fX1IoS6LpCzBT5MEa6ju+HBr/QFc13+oi6dm
         rcdN0+fFGWbNpWOLFGg4pff6xzFgg6l/hzMQ9T0s9fQMpLZxz0QC7efZk2mppFdNm/
         nYxzk/TGvW3Jg==
Date:   Thu, 8 Sep 2022 11:59:14 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        David Miller <davem@davemloft.net>
Cc:     Networking <netdev@vger.kernel.org>,
        Eyal Birger <eyal.birger@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Lior Nahmanson <liorna@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: linux-next: manual merge of the ipsec-next tree with the net-next
 tree
Message-ID: <20220908115914.69ed4771@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_//MNlCg_j4vK0.DfBhen4Xg_";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_//MNlCg_j4vK0.DfBhen4Xg_
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the ipsec-next tree got a conflict in:

  include/net/dst_metadata.h

between commit:

  0a28bfd4971f ("net/macsec: Add MACsec skb_metadata_dst Tx Data path suppo=
rt")

from the net-next tree and commit:

  5182a5d48c3d ("net: allow storing xfrm interface metadata in metadata_dst=
")

from the ipsec-next tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc include/net/dst_metadata.h
index 22a6924bf6da,57f75960fa28..000000000000
--- a/include/net/dst_metadata.h
+++ b/include/net/dst_metadata.h
@@@ -10,7 -9,7 +10,8 @@@
  enum metadata_type {
  	METADATA_IP_TUNNEL,
  	METADATA_HW_PORT_MUX,
 +	METADATA_MACSEC,
+ 	METADATA_XFRM,
  };
 =20
  struct hw_port_info {
@@@ -18,17 -17,18 +19,23 @@@
  	u32 port_id;
  };
 =20
 +struct macsec_info {
 +	sci_t sci;
 +};
 +
+ struct xfrm_md_info {
+ 	u32 if_id;
+ 	int link;
+ };
+=20
  struct metadata_dst {
  	struct dst_entry		dst;
  	enum metadata_type		type;
  	union {
  		struct ip_tunnel_info	tun_info;
  		struct hw_port_info	port_info;
 +		struct macsec_info	macsec_info;
+ 		struct xfrm_md_info	xfrm_info;
  	} u;
  };
 =20
@@@ -89,9 -110,9 +117,12 @@@ static inline int skb_metadata_dst_cmp(
  		return memcmp(&a->u.tun_info, &b->u.tun_info,
  			      sizeof(a->u.tun_info) +
  					 a->u.tun_info.options_len);
 +	case METADATA_MACSEC:
 +		return memcmp(&a->u.macsec_info, &b->u.macsec_info,
 +			      sizeof(a->u.macsec_info));
+ 	case METADATA_XFRM:
+ 		return memcmp(&a->u.xfrm_info, &b->u.xfrm_info,
+ 			      sizeof(a->u.xfrm_info));
  	default:
  		return 1;
  	}

--Sig_//MNlCg_j4vK0.DfBhen4Xg_
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmMZTHIACgkQAVBC80lX
0Gz5gwf8CPfl/S8PoQzhBTW3z3C+pZdJ4NhXFkTTv6JMeWiJ0VNSlAbYFI0G7WAv
Tp8Bq2zWsrMzg1UM0U+KZ0+JUcZ6fKSXE5iHfqOYEmu1f8XvxIKJLIWx3veUiaeP
8JDgJ3ruQs90PC27KgzKUJqp9sE1ZAcGerOu1ozL+emv885ldG/mRA4m+AJZPuox
dt4Rf18Iu6YHTdExmcOXLUNhipDu6eie6hy7TPGRL237bgaVrl0A207D2SXqu+y4
TC7jiGHZmtSyTDJvYKcDN49wukE6KF67K9mxQTrVLe1c20Zqvqmbt4oKcv5b1emR
YUnhjUqEmOnwRb6vccP9A0gHBg+jww==
=1GGK
-----END PGP SIGNATURE-----

--Sig_//MNlCg_j4vK0.DfBhen4Xg_--
