Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E620592054
	for <lists+netdev@lfdr.de>; Sun, 14 Aug 2022 17:16:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230311AbiHNPQN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Aug 2022 11:16:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbiHNPQM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Aug 2022 11:16:12 -0400
Received: from sender-of-o50.zoho.in (sender-of-o50.zoho.in [103.117.158.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A319E614E;
        Sun, 14 Aug 2022 08:16:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1660490136; cv=none; 
        d=zohomail.in; s=zohoarc; 
        b=P0DMXelA8rZr+5tpNnF6yG45AYFNAp+orQVwMoEoNU36lj2KNLAhBcqvPXhkEjeaFoYq6MyA17DiK4I0A3l17aI/Lcm0KOsEbGKV5jbMC8riMgRKjxS2PEYjW843EE7WGsU05zUu5E6wQsFB2XVPdJni+tSv+msrN2YrzSoclTY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.in; s=zohoarc; 
        t=1660490136; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:MIME-Version:Message-ID:Subject:To; 
        bh=Vc8f/bR6BhLdNYT+B1nN0BGO6y9fqlas6nlpvef1JJI=; 
        b=VRRsUlpu/kFkS0lDXXYrUkehylNrf7iAPHo4MhQ6629Ix5dlK5WtWiBQbsHnsmh8+jlqi2YGX0ij1iXcHuDCKlUA7eqEW39lU9wisFQ/7TA9zvN2kMSi4QrwQdMJx2NlI99y8BvlGYCHt1w5Jd4rAEiLCGLOf4NmWNW+qdVJdU8=
ARC-Authentication-Results: i=1; mx.zohomail.in;
        dkim=pass  header.i=siddh.me;
        spf=pass  smtp.mailfrom=code@siddh.me;
        dmarc=pass header.from=<code@siddh.me>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1660490136;
        s=zmail; d=siddh.me; i=code@siddh.me;
        h=From:From:To:To:Cc:Cc:Message-ID:Subject:Subject:Date:Date:MIME-Version:Content-Transfer-Encoding:Content-Type:Message-Id:Reply-To;
        bh=Vc8f/bR6BhLdNYT+B1nN0BGO6y9fqlas6nlpvef1JJI=;
        b=qG2uwrkjvQvVaLteAYiN06fRfAxokADh32VxkVKlEj5gbvGV2+0KZ3Z3txOfNqxk
        7VxKz4tR79W2AhHUmjXzy3d27m/S57hs9Di5avdO4IlNXP071ru8ub+sUc6uAAnKk6d
        aojkofVw/A5JbzeUyiW8ooQ96PJCRe5ETeU1Eg7Q=
Received: from localhost.localdomain (103.86.19.140 [103.86.19.140]) by mx.zoho.in
        with SMTPS id 1660490133725920.3510862995147; Sun, 14 Aug 2022 20:45:33 +0530 (IST)
From:   Siddh Raman Pant <code@siddh.me>
To:     Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-kernel-mentees 
        <linux-kernel-mentees@lists.linuxfoundation.org>,
        syzbot+b6c9fe29aefe68e4ad34@syzkaller.appspotmail.com,
        stable@vger.kernel.org
Message-ID: <20220814151512.9985-1-code@siddh.me>
Subject: [PATCH] wifi: mac80211: Don't finalize CSA in IBSS mode if state is disconnected
Date:   Sun, 14 Aug 2022 20:45:12 +0530
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-ZohoMailClient: External
Content-Type: text/plain; charset=utf8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_RED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When we are not connected to a channel, sending channel "switch"
announcement doesn't make any sense.

The BSS list is empty in that case. This causes the for loop in
cfg80211_get_bss() to be bypassed, so the function returns NULL
(check line 1424 of net/wireless/scan.c), causing the WARN_ON()
in ieee80211_ibss_csa_beacon() to get triggered (check line 500
of net/mac80211/ibss.c), which was consequently reported on the
syzkaller dashboard.

Thus, check if we have an existing connection before generating
the CSA beacon in ieee80211_ibss_finish_csa().

Fixes: cd7760e62c2a ("mac80211: add support for CSA in IBSS mode")
Bug report: https://syzkaller.appspot.com/bug?id=3D05603ef4ae8926761b678d29=
39a3b2ad28ab9ca6
Reported-by: syzbot+b6c9fe29aefe68e4ad34@syzkaller.appspotmail.com
Cc: stable@vger.kernel.org

Signed-off-by: Siddh Raman Pant <code@siddh.me>
---
The fixes commit is old, and syzkaller shows the problem exists for
4.19 and 4.14 as well, so CC'd stable list.

 net/mac80211/ibss.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index d56890e3fabb..9b283bbc7bb4 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -530,6 +530,10 @@ int ieee80211_ibss_finish_csa(struct ieee80211_sub_if_=
data *sdata)
=20
 =09sdata_assert_lock(sdata);
=20
+=09/* When not connected/joined, sending CSA doesn't make sense. */
+=09if (ifibss->state !=3D IEEE80211_IBSS_MLME_JOINED)
+=09=09return -ENOLINK;
+
 =09/* update cfg80211 bss information with the new channel */
 =09if (!is_zero_ether_addr(ifibss->bssid)) {
 =09=09cbss =3D cfg80211_get_bss(sdata->local->hw.wiphy,
--=20
2.35.1


