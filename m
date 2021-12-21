Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 248D847B68B
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 01:50:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233488AbhLUAuI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 19:50:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232190AbhLUAuI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 19:50:08 -0500
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [IPv6:2404:9400:2:0:216:3eff:fee2:21ea])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5DE0C061574;
        Mon, 20 Dec 2021 16:50:07 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4JHyXr5XjJz4xd4;
        Tue, 21 Dec 2021 11:50:04 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1640047806;
        bh=o7imnqc01K6O2x4L1xT595ExkFUcfmNcjumSxNKsTNQ=;
        h=Date:From:To:Cc:Subject:From;
        b=ISTij4Lc6XsfULDHvU77JbihwPhaCBWf/CyiyjMFIQ7T6OMRIZ/NGMglgkZU+V1/b
         5EaQ92pEpg7Fn971jCpxLXmPwPK/Merd3AOPE432TFPbLw0dpH9MflaaruznC6Mcl2
         wUMHuEK3mNeJ2Kc9ujwUgpvqcpoHJMHi6iVCwFbJtIGlQNfXq24sCF6KwkgHFcqUCf
         WFK25P3FhXcSBR9WR7zw7ZFGrk8LsF97kS2ctBxA6fgF51prdi2+Q9/3j73onfkpru
         ULRTvM3eT2B1kQ00c/sFdIHzlzApUOXRoTgAARxDjm7DU5+5xteFMpJWsmgqztinN+
         2ScWP/X2DgY3Q==
Date:   Tue, 21 Dec 2021 11:50:04 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Johannes Berg <johannes@sipsolutions.net>,
        Wireless <linux-wireless@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Kalle Valo <quic_kvalo@quicinc.com>,
        Wen Gong <quic_wgong@quicinc.com>,
        Ayala Beker <ayala.beker@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build failure after merge of the mac80211-next tree
Message-ID: <20211221115004.1cd6b262@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/03R.m108Y_t1hW6EI1SYrX8";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/03R.m108Y_t1hW6EI1SYrX8
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the mac80211-next tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/net/wireless/ath/ath10k/wmi.c: In function 'ath10k_wmi_event_mgmt_r=
x':
drivers/net/wireless/ath/ath10k/wmi.c:2626:12: error: too few arguments to =
function 'cfg80211_get_ies_channel_number'
 2626 |   ies_ch =3D cfg80211_get_ies_channel_number(mgmt->u.beacon.variabl=
e,
      |            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
In file included from include/net/mac80211.h:21,
                 from drivers/net/wireless/ath/ath10k/htt.h:16,
                 from drivers/net/wireless/ath/ath10k/core.h:18,
                 from drivers/net/wireless/ath/ath10k/wmi.c:11:
include/net/cfg80211.h:6421:5: note: declared here
 6421 | int cfg80211_get_ies_channel_number(const u8 *ie, size_t ielen,
      |     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Caused by commit

  7f599aeccbd2 ("cfg80211: Use the HE operation IE to determine a 6GHz BSS =
channel")

interacting with commit

  3bf2537ec2e3 ("ath10k: drop beacon and probe response which leak from oth=
er channel")

from the net-next tree.

I have applied the following merge fix patch for today (which, on
reflection, may not be correct, but builds).

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 21 Dec 2021 11:40:49 +1100
Subject: [PATCH] fixup for "cfg80211: Use the HE operation IE to determine =
a 6GHz BSS channel"

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/net/wireless/ath/ath10k/wmi.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/a=
th/ath10k/wmi.c
index 4733fd7fb169..657bd6a32a36 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -2613,6 +2613,7 @@ int ath10k_wmi_event_mgmt_rx(struct ath10k *ar, struc=
t sk_buff *skb)
 	if (ieee80211_is_beacon(hdr->frame_control) ||
 	    ieee80211_is_probe_resp(hdr->frame_control)) {
 		struct ieee80211_mgmt *mgmt =3D (void *)skb->data;
+		enum cfg80211_bss_frame_type ftype;
 		u8 *ies;
 		int ies_ch;
=20
@@ -2623,9 +2624,14 @@ int ath10k_wmi_event_mgmt_rx(struct ath10k *ar, stru=
ct sk_buff *skb)
=20
 		ies =3D mgmt->u.beacon.variable;
=20
+		if (ieee80211_is_beacon(mgmt->frame_control))
+			ftype =3D CFG80211_BSS_FTYPE_BEACON;
+		else /* if (ieee80211_is_probe_resp(mgmt->frame_control)) */
+			ftype =3D CFG80211_BSS_FTYPE_PRESP;
+
 		ies_ch =3D cfg80211_get_ies_channel_number(mgmt->u.beacon.variable,
 							 skb_tail_pointer(skb) - ies,
-							 sband->band);
+							 sband->band, ftype);
=20
 		if (ies_ch > 0 && ies_ch !=3D channel) {
 			ath10k_dbg(ar, ATH10K_DBG_MGMT,
--=20
2.33.0



--=20
Cheers,
Stephen Rothwell

--Sig_/03R.m108Y_t1hW6EI1SYrX8
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmHBJLwACgkQAVBC80lX
0GwPygf+Kdmuupv94+ul74skfM1l6UVffIhetINDDorSIeBSZVHaajDwmqi7P8PZ
0N0722gKosC32PXbvmaqvqg1myGKaPza7p6IfQ9sxQDikFPIjdBPjY7spJq8c1qp
2ohSvsqklP8c7Bn5hszbg1RaKESb2NnB/nD8DkXYZbUUh6L/aktbaPBwMaart2K1
ezT4pKeILtDJoYMdqUYpQKDDM/iIZdy+BMfS8NAkUhcm2FmtrqmCsJ/z9m4+eiMu
oByQ03O+mu/G568/Dqmp1Cc+oBvdlB15DdqJZTz7osV67dugIvBHdrK2XZch3etz
C941+p2Sqdftj6paKziCPyjmFnHfGA==
=iUW7
-----END PGP SIGNATURE-----

--Sig_/03R.m108Y_t1hW6EI1SYrX8--
