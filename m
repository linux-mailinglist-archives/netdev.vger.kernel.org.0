Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1810694383
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 11:55:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230002AbjBMKzN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 05:55:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229814AbjBMKzL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 05:55:11 -0500
Received: from mail-4018.proton.ch (mail-4018.proton.ch [185.70.40.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96D66CA26;
        Mon, 13 Feb 2023 02:55:07 -0800 (PST)
Date:   Mon, 13 Feb 2023 10:55:00 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=systemb.ch;
        s=protonmail; t=1676285704; x=1676544904;
        bh=hJGEW7a9Y+Lo90p9BgYos2s5IIPNHsJdRYhSO+fYzKA=;
        h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
         Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
        b=mgOqjeCezZNTRLN7QDR9cXFw7qoiAUXQkl7SgoDvYkhQgIMNgUsm+ynzLGnQffugl
         Ck2eft9OoazYJxPF1q+7qwLG/qVidWKAqJ2Ptyt7J0+7xfr9GDoJc2fwhhKZAAMpUw
         8MJnOlxKjbBWPiQl7/QBQM1/iY5U+faA1hbOB1abiwxIGr5OoR1FaerzmMCEor2rri
         9bCuLffNKpeQsHN2f/4F1iI3C6ms/S+R+xe1KV6PvjNxFBn0F+882hE/X7TSxxLq+R
         KMManUbhRhKgyc/qg2DWGGMeB0CfG7r6JuXulKv/13Fi68ucc/46cAaOqfwhaRqZRG
         SgEKdCcILkxsA==
To:     Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
From:   Marc Bornand <dev.mbornand@systemb.ch>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kalle Valo <kvalo@kernel.org>,
        Marc Bornand <dev.mbornand@systemb.ch>,
        Yohan Prod'homme <kernel@zoddo.fr>, stable@vger.kernel.org
Subject: [PATCH v2] Set ssid when authenticating
Message-ID: <20230213105436.595245-1-dev.mbornand@systemb.ch>
Feedback-ID: 65519157:user:proton
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

changes since v1:
- add some informations
- test it on wireless-2023-01-18 tag
- no real code change

When a connexion was established without going through
NL80211_CMD_CONNECT, the ssid was never set in the wireless_dev struct.
Now we set it during when an NL80211_CMD_AUTHENTICATE is issued.

It may be needed to test this on some additional hardware (tested with
iwlwifi and a AX201, and iwd on the userspace side), I could not test
things like roaming and p2p.

alternatives:
1. Do the same but during association and not authentication.
2. use ieee80211_bss_get_elem in nl80211_send_iface, this would report
   the right ssid to userspace, but this would not fix the root cause,
   this alos wa the behavior prior to 7b0a0e3c3a882 when the bug was
   introduced.

This applies to v6.2-rc8 or wireless-2023-01-18,

The last linux version known to be unafected is 5.19 and the bug was
backported to the 5.19.y releases

Reported-by: Yohan Prod'homme <kernel@zoddo.fr>
Fixes: 7b0a0e3c3a88260b6fcb017e49f198463aa62ed1
Cc: stable@vger.kernel.org
Link: https://bugzilla.kernel.org/show_bug.cgi?id=3D216711
Signed-off-by: Marc Bornand <dev.mbornand@systemb.ch>
---
 net/wireless/nl80211.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 33a82ecab9d5..f1627ea542b9 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -10552,6 +10552,10 @@ static int nl80211_authenticate(struct sk_buff *sk=
b, struct genl_info *info)
 =09=09return -ENOENT;

 =09wdev_lock(dev->ieee80211_ptr);
+
+=09memcpy(dev->ieee80211_ptr->u.client.ssid, ssid, ssid_len);
+=09dev->ieee80211_ptr->u.client.ssid_len =3D ssid_len;
+
 =09err =3D cfg80211_mlme_auth(rdev, dev, &req);
 =09wdev_unlock(dev->ieee80211_ptr);

@@ -11025,6 +11029,11 @@ static int nl80211_deauthenticate(struct sk_buff *=
skb, struct genl_info *info)
 =09local_state_change =3D !!info->attrs[NL80211_ATTR_LOCAL_STATE_CHANGE];

 =09wdev_lock(dev->ieee80211_ptr);
+
+=09if (reason_code =3D=3D WLAN_REASON_DEAUTH_LEAVING) {
+=09=09dev->ieee80211_ptr->u.client.ssid_len =3D 0;
+=09}
+
 =09err =3D cfg80211_mlme_deauth(rdev, dev, bssid, ie, ie_len, reason_code,
 =09=09=09=09   local_state_change);
 =09wdev_unlock(dev->ieee80211_ptr);
--
2.39.1


