Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1CDD697877
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 09:48:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230492AbjBOIsE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 03:48:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229840AbjBOIsD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 03:48:03 -0500
Received: from mail-4323.proton.ch (mail-4323.proton.ch [185.70.43.23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B80B2E0E3;
        Wed, 15 Feb 2023 00:48:01 -0800 (PST)
Date:   Wed, 15 Feb 2023 08:47:53 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=systemb.ch;
        s=protonmail; t=1676450879; x=1676710079;
        bh=E7nP9FVYArp+l+shpevPrDGeTZGYU48EbnTnQ2n7ch4=;
        h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
         Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
        b=F/wEF9zb5AlqSOsqRdPkZEDaTX/ON9DLNOmGZHc3s6eCKKVW40n+fnHehEKp/bS+P
         XLUBkIbhIbcUHauBt0nU+GUCRL2DbpjVp26K1rW0n/XUdjwabpbCrX5AiPbk9ByXZ7
         AOrVMa5QNW2lXdjdyQx7bweJDGhMj2GZoB7fVBYvZ3euGQeuVe+JBpEtfWbYc+ElX0
         A8FzZ1lKQt+gJZLka/NUJCnjtQrrK8s/iGpVO7U4pVYLCbFRzM4nFmtzBoJdLji19y
         EEw1Z3JubySk/zxQ9uf2eQHkq9TsYgaqDiAYlMUgN8jQC9Zw8Y5VAH+dXpBMRIP9U7
         Cilma7VKOVXrQ==
To:     Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
From:   Marc Bornand <dev.mbornand@systemb.ch>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kalle Valo <kvalo@kernel.org>,
        Marc Bornand <dev.mbornand@systemb.ch>,
        Yohan Prod'homme <kernel@zoddo.fr>,
        Denis Kirjanov <dkirjanov@suse.de>, stable@vger.kernel.org
Subject: [PATCH wireless v5] wifi: cfg80211: Set SSID if it is not already set
Message-ID: <20230215084722.231535-1-dev.mbornand@systemb.ch>
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

When a connection was established without going through
NL80211_CMD_CONNECT, the ssid was never set in the wireless_dev struct.
Now we set it in __cfg80211_connect_result() when it is not already set.

When using a userspace configuration that does not call
cfg80211_connect() (can be checked with breakpoints in the kernel),
this patch should allow `networkctl status device_name` to output the
SSID instead of null.

Reported-by: Yohan Prod'homme <kernel@zoddo.fr>
Fixes: 7b0a0e3c3a88 (wifi: cfg80211: do some rework towards MLO link APIs)
CC: Kalle Valo <kvalo@kernel.org>
Cc: Denis Kirjanov <dkirjanov@suse.de>
Cc: linux-wireless@vger.kernel.org
Cc: stable@vger.kernel.org
Link: https://bugzilla.kernel.org/show_bug.cgi?id=3D216711
Signed-off-by: Marc Bornand <dev.mbornand@systemb.ch>
---
changes since v4:
- style: use xmas tree
- better fixes tag
- fix typo in commit message
- explain how to test the patch
- fix fixes tag
- move change log
- changing the title to something better

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
---
 net/wireless/sme.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 4b5b6ee0fe01..032464a38787 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -724,6 +724,7 @@ void __cfg80211_connect_result(struct net_device *dev,
 {
 =09struct wireless_dev *wdev =3D dev->ieee80211_ptr;
 =09const struct element *country_elem =3D NULL;
+=09const struct element *ssid;
 =09const u8 *country_data;
 =09u8 country_datalen;
 #ifdef CONFIG_CFG80211_WEXT
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
2.39.2


