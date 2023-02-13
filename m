Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 290D66952A9
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 22:06:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbjBMVGS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 16:06:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbjBMVGR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 16:06:17 -0500
Received: from mail-4317.proton.ch (mail-4317.proton.ch [185.70.43.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2E8420558
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 13:06:05 -0800 (PST)
Date:   Mon, 13 Feb 2023 21:05:49 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=systemb.ch;
        s=protonmail; t=1676322356; x=1676581556;
        bh=vNl8muu2zut514XDhaSVpRfwNoz1vy088PrrWi2ZfbM=;
        h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
         Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
        b=aQHLisANKfKW84wW5vil1FfFh7d+lduBBQIpSZXJ44V7qOa/zQXaOQqfZ138AVAMN
         zBem9xE+mX67WwimkwcQIMeiaBCAs2cmCq27Hxoa18XuOMX66DPt3R4qoJcPPWSIUa
         3gffxU9ILyO0SUndvsjCGkB0CBNKMvsNd61aLLAZ0GZwtKj/FLCkjRcLXokRpTgYV6
         DJesDsBwpPRyZsvVhIWec2DS8/A43yFRRXnapLwXhrrlvgmvQLsFKPcsoZL6hU3i4C
         cnknkrfYaELOA3OYdjKyJhfCukTROwN406rjcKSd0mqpqXUaInGsIqC4RA3s97NRLy
         B58vsCiE066NQ==
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
Subject: [PATCH v3] Set ssid when authenticating
Message-ID: <20230213210521.1672392-1-dev.mbornand@systemb.ch>
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
 net/wireless/sme.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 4b5b6ee0fe01..629d7b5f65c1 100644
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
@@ -883,6 +884,21 @@ void __cfg80211_connect_result(struct net_device *dev,
 =09=09=09=09   country_data, country_datalen);
 =09kfree(country_data);

+=09if (wdev->u.client.ssid_len =3D=3D 0) {
+=09=09rcu_read_lock();
+=09=09for_each_valid_link(cr, link) {
+=09=09=09ssid =3D ieee80211_bss_get_elem(cr->links[link].bss,
+=09=09=09=09=09=09      WLAN_EID_SSID);
+
+=09=09=09if (ssid->datalen =3D=3D 0)
+=09=09=09=09continue;
+
+=09=09=09memcpy(wdev->u.client.ssid, ssid->data, ssid->datalen);
+=09=09=09wdev->u.client.ssid_len =3D ssid->datalen;
+=09=09}
+=09=09rcu_read_unlock();
+=09}
+
 =09return;
 out:
 =09for_each_valid_link(cr, link)
--
2.39.1


