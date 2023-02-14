Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABAEC696482
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 14:21:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232601AbjBNNVF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 08:21:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232470AbjBNNVB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 08:21:01 -0500
Received: from mail-4317.proton.ch (mail-4317.proton.ch [185.70.43.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8264265BD
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 05:20:37 -0800 (PST)
Date:   Tue, 14 Feb 2023 13:20:25 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=systemb.ch;
        s=protonmail; t=1676380835; x=1676640035;
        bh=8AmFFgy2lxaoStl2yp+jrbUYg5WYi0q0Y7u85UwNb/k=;
        h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
         Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
        b=E8kSsNtIs9RQ3hhAxa8EyurMI5sarsZ8BZTc/GByT0yYhjS7s2OTiv4/4KIuGSO8H
         UyByh/MqTbJ3i0F1Ay9Qyr8TK45QnOmDwfd/4oHRCTFo+fplUGnKSopHe2AmNX4rPe
         MRF1Ga49FB6uSbzwgBRJdE5cwZE6yTyMZRXiyYc1le20PTbrpqvZIrXPIXgJIiZD7F
         YGv1Pm7qv/+V7mrovP8MmclXUsufCu0ZFX3pDjgKdnbt7dU9RjrxKV+oh8FlNz5AEO
         Gpz31u9nx4WzRs1J18zC54iGtZMyFdIBJsjRIY6NR5MMUyVaOWQmFqTUiOlqdDmgK2
         brccMsfBRSi2w==
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
Subject: [PATCH v4] Set ssid when authenticating
Message-ID: <20230214132009.1011452-1-dev.mbornand@systemb.ch>
Feedback-ID: 65519157:user:proton
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

changes since v3:
- add missing NULL check
- add missing break

changes since v2:
- The code was tottaly rewritten based on the disscution of the
  v2 patch.
- the ssid is set in __cfg80211_connect_result() and only if the ssid is
  not already set.
- Do not add an other ssid reset path since it is already done in
  __cfg80211_disconnected()

When a connexion was established without going through
NL80211_CMD_CONNECT, the ssid was never set in the wireless_dev struct.
Now we set it in __cfg80211_connect_result() when it is not already set.

Reported-by: Yohan Prod'homme <kernel@zoddo.fr>
Fixes: 7b0a0e3c3a88260b6fcb017e49f198463aa62ed1
Cc: linux-wireless@vger.kernel.org
Cc: stable@vger.kernel.org
Link: https://bugzilla.kernel.org/show_bug.cgi?id=3D216711
Signed-off-by: Marc Bornand <dev.mbornand@systemb.ch>
---
 net/wireless/sme.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 4b5b6ee0fe01..b552d6c20a26 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -723,6 +723,7 @@ void __cfg80211_connect_result(struct net_device *dev,
 =09=09=09       bool wextev)
 {
 =09struct wireless_dev *wdev =3D dev->ieee80211_ptr;
+=09const struct element *ssid;
 =09const struct element *country_elem =3D NULL;
 =09const u8 *country_data;
 =09u8 country_datalen;
@@ -883,6 +884,22 @@ void __cfg80211_connect_result(struct net_device *dev,
 =09=09=09=09   country_data, country_datalen);
 =09kfree(country_data);

+=09if (wdev->u.client.ssid_len =3D=3D 0) {
+=09=09rcu_read_lock();
+=09=09for_each_valid_link(cr, link) {
+=09=09=09ssid =3D ieee80211_bss_get_elem(cr->links[link].bss,
+=09=09=09=09=09=09      WLAN_EID_SSID);
+
+=09=09=09if (!ssid || ssid->datalen =3D=3D 0)
+=09=09=09=09continue;
+
+=09=09=09memcpy(wdev->u.client.ssid, ssid->data, ssid->datalen);
+=09=09=09wdev->u.client.ssid_len =3D ssid->datalen;
+=09=09=09break;
+=09=09}
+=09=09rcu_read_unlock();
+=09}
+
 =09return;
 out:
 =09for_each_valid_link(cr, link)
--
2.39.1


