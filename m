Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01EFE550D9C
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 01:34:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234969AbiFSXeh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jun 2022 19:34:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231539AbiFSXeh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jun 2022 19:34:37 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30B1165B9;
        Sun, 19 Jun 2022 16:34:32 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4LR8J25MDpz4xD3;
        Mon, 20 Jun 2022 09:34:25 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1655681667;
        bh=XCmoHAJGKCFrPOl+19AKGJEOmMMNLQ7mtdF3GYoctpc=;
        h=Date:From:To:Cc:Subject:From;
        b=LrAXmYNMKJQFE6xc/ROjRyS2fEKsVGVfQn1Ww90Fj9MoDIq9bqjbYJOkfNY2xounT
         wqiQySykp675Y66viCFq7OgjRUCVhTcqUAKCdwxXfQSaSFUO6a4jRPSI18pFpxg9SP
         6dMfJObonep3pQo+RBb09NYg+EC7GEhamdKTszRm4FgEhYTEkbjNffB6YiUcxdDAp2
         gq/9J88gm3osvH7HLSC6Us5hsOw08QEXfP6WOsxV3G/w5bbJfErrtkoSArVGmiHbIh
         QLUue1cTwZEut61Q78nF8av9Cs4kleGh4dLRWZFH/c/2W3MariC22yN3oNKyOB+2Aw
         AL6LpOEFrJa9w==
Date:   Mon, 20 Jun 2022 09:34:24 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>
Cc:     Networking <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build failure after merge of the net-next tree
Message-ID: <20220620093424.0615a374@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/4DCfUCSlQH8GtJ8aX_cx.qX";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/4DCfUCSlQH8GtJ8aX_cx.qX
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net-next tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

net/ipv4/raw.c: In function 'raw_icmp_error':
net/ipv4/raw.c:266:9: error: ISO C90 forbids mixed declarations and code [-=
Werror=3Ddeclaration-after-statement]
  266 |         struct hlist_nulls_head *hlist;
      |         ^~~~~~
cc1: all warnings being treated as errors

Introduced by commit

  ba44f8182ec2 ("raw: use more conventional iterators")

I have applied the following patch for today.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 20 Jun 2022 09:21:01 +1000
Subject: [PATCH] raw: fix build error

The linux-next x86_64 allmodconfig build produced this error:

net/ipv4/raw.c: In function 'raw_icmp_error':
net/ipv4/raw.c:266:9: error: ISO C90 forbids mixed declarations and code [-=
Werror=3Ddeclaration-after-statement]
  266 |         struct hlist_nulls_head *hlist;
      |         ^~~~~~
cc1: all warnings being treated as errors

Fixes: ba44f8182ec2 ("raw: use more conventional iterators")
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 net/ipv4/raw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index d28bf0b901a2..b3b255db9021 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -262,7 +262,7 @@ static void raw_err(struct sock *sk, struct sk_buff *sk=
b, u32 info)
=20
 void raw_icmp_error(struct sk_buff *skb, int protocol, u32 info)
 {
-	struct net *net =3D dev_net(skb->dev);;
+	struct net *net =3D dev_net(skb->dev);
 	struct hlist_nulls_head *hlist;
 	struct hlist_nulls_node *hnode;
 	int dif =3D skb->dev->ifindex;
--=20
2.35.1

--=20
Cheers,
Stephen Rothwell

--Sig_/4DCfUCSlQH8GtJ8aX_cx.qX
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmKvsoAACgkQAVBC80lX
0GwhXQgAgW6VnNxSLdSjFSsZxN2oozgsu0RTviMHE7u2sKOO72cj8BOOiSen6QyO
UF9a0iHDjIJoJ9QuhPiqeUfsVdQge4HlzKdIkOOI9/lkbDPscZowD23UEKnjhmP6
+nlOSGQ1kusToP+RfGh+ust+0Jza9B5BWYaNoaCSpnXE6V12nfXt43rhvdRV9FE4
SqUztSK+YZuwRGUg/axsFbsxaPWjyEQyZ0eHFD/4r2koWhbtFPSrU+uWKCE9CDfo
pf/EtnvwK90mMStRjx5Q9Ko4kwzDpQ7CvNP0D2g1X7k3SvjE5KSJ504s92KFqdEb
InH/tFb8SzNKNr/Ss/24xSW43ajZUQ==
=Whmj
-----END PGP SIGNATURE-----

--Sig_/4DCfUCSlQH8GtJ8aX_cx.qX--
