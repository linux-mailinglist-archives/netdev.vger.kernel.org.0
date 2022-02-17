Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F4064B94D5
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 01:09:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238652AbiBQAJ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 19:09:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229820AbiBQAJ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 19:09:26 -0500
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20CD12A0D5F;
        Wed, 16 Feb 2022 16:09:13 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4JzZtm4lBLz4xv2;
        Thu, 17 Feb 2022 11:09:04 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1645056548;
        bh=aFgbb19PdfuiQgsKTnloIe4Cdxn6pysbLZDibuzMHSQ=;
        h=Date:From:To:Cc:Subject:From;
        b=pp6xMnlyDZY36465Orog80PIf7TuqocrVFR14PteUke4iMgbzX7ySdUUhPNz5yt0/
         VauOI8zSocCm6lAPQrMoJTBW7hAIMDfS4OeduJvP78q08gGNTP5MgTl5xjmqSKhTt+
         QASYCA8dVOGuvtIJ/lcyDgyMO9iEP8B551/RVrANoYsB1WN6WU+OSBH4vrYpcmha4o
         nfEFQQa211Fu/5tBzo2UAkWzu6fmihFr3oNjYX/AD22OrrGhVku9HP6Epj10QbErVN
         KI+mI32awzoX1TO3+Zg0V8Gs2MEqqCzOq2Sdzr9zmrj239Y9cNbFIcHNrndrr9OWiC
         xrUhLEm8vh3Tw==
Date:   Thu, 17 Feb 2022 11:09:03 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Kalle Valo <kvalo@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Wireless <linux-wireless@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Ilan Peer <ilan.peer@intel.com>,
        Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Johannes Berg <johannes.berg@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: manual merge of the wireless-next tree with the net
 tree
Message-ID: <20220217110903.7f58acae@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/yb=10YBNOeYNc=p1b9zxDvj";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/yb=10YBNOeYNc=p1b9zxDvj
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the wireless-next tree got a conflict in:

  net/mac80211/mlme.c

between commit:

  a72c01a94f1d ("mac80211: mlme: check for null after calling kmemdup")

from the net tree and commit:

  820acc810fb6 ("mac80211: Add EHT capabilities to association/probe reques=
t")

from the wireless-next tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc net/mac80211/mlme.c
index 20b57ddf149c,197cad4a2768..000000000000
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@@ -671,7 -692,49 +692,49 @@@ static void ieee80211_add_he_ie(struct=20
  	ieee80211_ie_build_he_6ghz_cap(sdata, skb);
  }
 =20
+ static void ieee80211_add_eht_ie(struct ieee80211_sub_if_data *sdata,
+ 				 struct sk_buff *skb,
+ 				 struct ieee80211_supported_band *sband)
+ {
+ 	u8 *pos;
+ 	const struct ieee80211_sta_he_cap *he_cap;
+ 	const struct ieee80211_sta_eht_cap *eht_cap;
+ 	struct ieee80211_chanctx_conf *chanctx_conf;
+ 	u8 eht_cap_size;
+ 	bool reg_cap =3D false;
+=20
+ 	rcu_read_lock();
+ 	chanctx_conf =3D rcu_dereference(sdata->vif.chanctx_conf);
+ 	if (!WARN_ON_ONCE(!chanctx_conf))
+ 		reg_cap =3D cfg80211_chandef_usable(sdata->wdev.wiphy,
+ 						  &chanctx_conf->def,
+ 						  IEEE80211_CHAN_NO_HE |
+ 						  IEEE80211_CHAN_NO_EHT);
+ 	rcu_read_unlock();
+=20
+ 	he_cap =3D ieee80211_get_he_iftype_cap(sband,
+ 					     ieee80211_vif_type_p2p(&sdata->vif));
+ 	eht_cap =3D ieee80211_get_eht_iftype_cap(sband,
+ 					       ieee80211_vif_type_p2p(&sdata->vif));
+=20
+ 	/*
+ 	 * EHT capabilities element is only added if the HE capabilities element
+ 	 * was added so assume that 'he_cap' is valid and don't check it.
+ 	 */
+ 	if (WARN_ON(!he_cap || !eht_cap || !reg_cap))
+ 		return;
+=20
+ 	eht_cap_size =3D
+ 		2 + 1 + sizeof(eht_cap->eht_cap_elem) +
+ 		ieee80211_eht_mcs_nss_size(&he_cap->he_cap_elem,
+ 					   &eht_cap->eht_cap_elem) +
+ 		ieee80211_eht_ppe_size(eht_cap->eht_ppe_thres[0],
+ 				       eht_cap->eht_cap_elem.phy_cap_info);
+ 	pos =3D skb_put(skb, eht_cap_size);
+ 	ieee80211_ie_build_eht_cap(pos, he_cap, eht_cap, pos + eht_cap_size);
+ }
+=20
 -static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 +static int ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
  {
  	struct ieee80211_local *local =3D sdata->local;
  	struct ieee80211_if_managed *ifmgd =3D &sdata->u.mgd;

--Sig_/yb=10YBNOeYNc=p1b9zxDvj
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmINkh8ACgkQAVBC80lX
0GziJQf/Swhed+4iBAPtpfrDVee66dAad92nU7K3ONqUxgGmBcRsYgYcpUTXy7jk
TimVhEG6hPEe0oC7FTSj38+crUYvJJ8sHq0ZPbZu9IPlXChIrdKr4JdNVq5rgy6V
KmHWfbz5rzApxlmsq7ogVyuIahqnDXxshJIAuINVfzl1yrnjqz5eTzrKU65WtNAC
U+4YTk+Wtb6uuLSkFJlrhxWx8uefi5lWT73ZO2ow7ittPjUBFNTCy7wDM5/jbCzq
8IR1oVQKZih3fAkUSIuZVqGOzlci6HPF/+ivwjjtHFIug1ie7XY0y9T9TVPIiVVH
ZH/7sOlE6xdX0jPNGwaOo8ggF+kICw==
=DM8N
-----END PGP SIGNATURE-----

--Sig_/yb=10YBNOeYNc=p1b9zxDvj--
