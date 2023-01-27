Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5062467DBFD
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 02:57:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233597AbjA0B5M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 20:57:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233615AbjA0B46 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 20:56:58 -0500
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D05E27A4B4;
        Thu, 26 Jan 2023 17:51:01 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4P30sT4Kr2z4xyB;
        Fri, 27 Jan 2023 12:50:53 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1674784255;
        bh=VNMdS/CiloN9PaF8wxKbbGy+XMCZPUIYeLlMZIhbur4=;
        h=Date:From:To:Cc:Subject:From;
        b=HA2iypQAyHfpo1GP/aSTqG9JGfMwOWPqiY4Fj2kWrHEC/KuBvgi2XZv9mVkmWDAlb
         CUcrZ2NG+F/vV9ccVH6KbOkyiZq6oTlj2Z2b0B2kJGOTppuzTLL7U3E4OR9UXuM9jx
         LQZC2yXd48NIR9GuXTnd8qafZyIYYj306pQXzsNbUPPnUeR4W8MqRtD3ju7XOC0kiY
         LfKMk37a3jXi7gqJAPDvC2NxyCVrHZDNX6JnqZ4DKRj+An0rxSFLmyg8kOOOcfLpHE
         8FPF24V2UFQlT2tiFG1FN+P4yLcZs50+1VSzYXETxu37fYrTgcXKjeP/uEpoYExckC
         jF2PlO+2B3/gQ==
Date:   Fri, 27 Jan 2023 12:50:52 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sriram Yagnaraman <sriram.yagnaraman@est.tech>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20230127125052.674281f9@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/bDcnixPAPnVH4NOMG2umlS3";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/bDcnixPAPnVH4NOMG2umlS3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  net/netfilter/nf_conntrack_proto_sctp.c

between commits:

  13bd9b31a969 ("Revert "netfilter: conntrack: add sctp DATA_SENT state"")
  a44b7651489f ("netfilter: conntrack: unify established states for SCTP pa=
ths")

from the net tree and commit:

  f71cb8f45d09 ("netfilter: conntrack: sctp: use nf log infrastructure for =
invalid packets")

from the net-next tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc net/netfilter/nf_conntrack_proto_sctp.c
index 945dd40e7077,dbdfcc6cd2aa..000000000000
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@@ -238,14 -243,16 +227,12 @@@ static int sctp_new_state(enum ip_connt
  		i =3D 9;
  		break;
  	case SCTP_CID_HEARTBEAT_ACK:
- 		pr_debug("SCTP_CID_HEARTBEAT_ACK");
  		i =3D 10;
  		break;
 -	case SCTP_CID_DATA:
 -	case SCTP_CID_SACK:
 -		i =3D 11;
 -		break;
  	default:
  		/* Other chunks like DATA or SACK do not change the state */
- 		pr_debug("Unknown chunk type, Will stay in %s\n",
- 			 sctp_conntrack_names[cur_state]);
+ 		pr_debug("Unknown chunk type %d, Will stay in %s\n",
+ 			 chunk_type, sctp_conntrack_names[cur_state]);
  		return cur_state;
  	}
 =20
@@@ -381,19 -386,21 +364,21 @@@ int nf_conntrack_sctp_packet(struct nf_
 =20
  		if (!sctp_new(ct, skb, sh, dataoff))
  			return -NF_ACCEPT;
 -	} else {
 -		/* Check the verification tag (Sec 8.5) */
 -		if (!test_bit(SCTP_CID_INIT, map) &&
 -		    !test_bit(SCTP_CID_SHUTDOWN_COMPLETE, map) &&
 -		    !test_bit(SCTP_CID_COOKIE_ECHO, map) &&
 -		    !test_bit(SCTP_CID_ABORT, map) &&
 -		    !test_bit(SCTP_CID_SHUTDOWN_ACK, map) &&
 -		    !test_bit(SCTP_CID_HEARTBEAT, map) &&
 -		    !test_bit(SCTP_CID_HEARTBEAT_ACK, map) &&
 -		    sh->vtag !=3D ct->proto.sctp.vtag[dir]) {
 -			nf_ct_l4proto_log_invalid(skb, ct, state,
 -						  "verification tag check failed %x vs %x for dir %d",
 -						  sh->vtag, ct->proto.sctp.vtag[dir], dir);
 -			goto out;
 -		}
 +	}
 +
 +	/* Check the verification tag (Sec 8.5) */
 +	if (!test_bit(SCTP_CID_INIT, map) &&
 +	    !test_bit(SCTP_CID_SHUTDOWN_COMPLETE, map) &&
 +	    !test_bit(SCTP_CID_COOKIE_ECHO, map) &&
 +	    !test_bit(SCTP_CID_ABORT, map) &&
 +	    !test_bit(SCTP_CID_SHUTDOWN_ACK, map) &&
 +	    !test_bit(SCTP_CID_HEARTBEAT, map) &&
 +	    !test_bit(SCTP_CID_HEARTBEAT_ACK, map) &&
 +	    sh->vtag !=3D ct->proto.sctp.vtag[dir]) {
- 		pr_debug("Verification tag check failed\n");
++		nf_ct_l4proto_log_invalid(skb, ct, state,
++					  "verification tag check failed %x vs %x for dir %d",
++					  sh->vtag, ct->proto.sctp.vtag[dir], dir);
 +		goto out;
  	}
 =20
  	old_state =3D new_state =3D SCTP_CONNTRACK_NONE;

--Sig_/bDcnixPAPnVH4NOMG2umlS3
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmPTLfwACgkQAVBC80lX
0GxWyAf+OsNvsid/vbh+k5dWbGkivstckGHkL9tLnN7xLRGpesvdmuPp97pLoD5H
jNoa0MNqWSayhwKutKPaKRnLkhjvPqJs50cyq4V36g/qE3uvJ66Vb1pkQ6+R4HXd
fTlGzVG9wLokyLM351gQD7XAylY0VSmxw6awKat/ldgTA30wsuO4OvAfyIQg+jBX
oz7YbrZO8Hnoml5reitAaX3vJQT2k9qOnGX5z08zJrxjjvX92e+2yzzGVfRCvMhB
NVp3aYKO8t2o4tlNqqAm/CSitt6/JG3SmstVOC4Kmk2/VqJHK5FhxTkFnR3txru+
lrgdSPS3PSk6SMT/R6WFtVGRQFb9PQ==
=xjAJ
-----END PGP SIGNATURE-----

--Sig_/bDcnixPAPnVH4NOMG2umlS3--
