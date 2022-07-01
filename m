Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E2D75636B3
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 17:11:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230382AbiGAPLU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 11:11:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230213AbiGAPLS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 11:11:18 -0400
X-Greylist: delayed 917 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 01 Jul 2022 08:11:15 PDT
Received: from sender-of-o53.zoho.in (sender-of-o53.zoho.in [103.117.158.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 877EF3DDC3
        for <netdev@vger.kernel.org>; Fri,  1 Jul 2022 08:11:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1656687325; cv=none; 
        d=zohomail.in; s=zohoarc; 
        b=FiEaSlyeB5dJSM7DRWxy7RLVHSOSwxAuUQwWW/z+v3/iTTBRgQqhqjhn8WsmlaiZdMhy0qQ8Wxt4An/fhPhMXhy3gm7t8kCCus+apZY+9UDadMbP05nMLMOoG6dgIlEkm5lrndF7s2iyaQmkpgdN0QDKFwoAImnDTzZNHsSxq5o=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.in; s=zohoarc; 
        t=1656687325; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:MIME-Version:Message-ID:Subject:To; 
        bh=CrcF49UEX8SWd4LvC7g+h7rckFp6IPoWnRfYza7Wpf4=; 
        b=EQJdwhLyt76VZ7lKH/G1DVNEeFyuhp2Kdj4E61jM1HYf/eu/gw1/lcd3LEp9FmCjJjgs0kp60bKQddBpG4NO0EQl7lCabNdTZWEyRWQwUIwinocRC/TWoamlGroVKDrnEC9R6i3uimRN0bEnjct3DWMxjIVjYLXIDiIHzN3i4s0=
ARC-Authentication-Results: i=1; mx.zohomail.in;
        dkim=pass  header.i=siddh.me;
        spf=pass  smtp.mailfrom=code@siddh.me;
        dmarc=pass header.from=<code@siddh.me>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1656687325;
        s=zmail; d=siddh.me; i=code@siddh.me;
        h=From:From:To:To:Cc:Cc:Message-ID:Subject:Subject:Date:Date:MIME-Version:Content-Transfer-Encoding:Content-Type:Message-Id:Reply-To;
        bh=CrcF49UEX8SWd4LvC7g+h7rckFp6IPoWnRfYza7Wpf4=;
        b=QB2xsFvTFpkZpGWLYG/6EoL1vFDTxljo0BxBdEabq/ZUrVzoHxexceL2nc4VXXJh
        UW//enYAdJiTYS7yuE98h10sTM9umYD6qmp8rljEBDEniUJmAUWr7WPmNk2E8B3C9dO
        05iAWpaiLEtNxDVZW/OK3q3QB9LZ2+z0tPD6iSTU=
Received: from localhost.localdomain (103.250.137.221 [103.250.137.221]) by mx.zoho.in
        with SMTPS id 1656687324349795.6718155316092; Fri, 1 Jul 2022 20:25:24 +0530 (IST)
From:   Siddh Raman Pant <code@siddh.me>
To:     Johannes Berg <johannes@sipsolutions.net>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-kernel-mentees 
        <linux-kernel-mentees@lists.linuxfoundation.org>
Message-ID: <20220701145423.53208-1-code@siddh.me>
Subject: [PATCH] net: Fix UAF in ieee80211_scan_rx()
Date:   Fri,  1 Jul 2022 20:24:23 +0530
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-ZohoMailClient: External
Content-Type: text/plain; charset=utf8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_RED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ieee80211_scan_rx() tries to access scan_req->flags after a null check
(see line 303 of mac80211/scan.c), but ___cfg80211_scan_done() uses
kfree() on the scan_req (see line 991 of wireless/scan.c).

This results in a UAF.

ieee80211_scan_rx() is called inside a RCU read-critical section
initiated by ieee80211_rx_napi() (see line 5043 of mac80211/rx.c).

Thus, add an rcu_head to the scan_req struct so as to use kfree_rcu()
instead of kfree() so that we don't free during the critical section.

Bug report (3): https://syzkaller.appspot.com/bug?extid=3Df9acff9bf08a845f2=
25d
Reported-by: syzbot+f9acff9bf08a845f225d@syzkaller.appspotmail.com
Reported-by: syzbot+6cb476b7c69916a0caca@syzkaller.appspotmail.com
Reported-by: syzbot+9250865a55539d384347@syzkaller.appspotmail.com

Signed-off-by: Siddh Raman Pant <code@siddh.me>
---
 include/net/cfg80211.h | 2 ++
 net/wireless/scan.c    | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 6d02e12e4702..ba4a49884de8 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2368,6 +2368,7 @@ struct cfg80211_scan_6ghz_params {
  * @n_6ghz_params: number of 6 GHz params
  * @scan_6ghz_params: 6 GHz params
  * @bssid: BSSID to scan for (most commonly, the wildcard BSSID)
+ * @rcu_head: (internal) RCU head to use for freeing
  */
 struct cfg80211_scan_request {
 =09struct cfg80211_ssid *ssids;
@@ -2397,6 +2398,7 @@ struct cfg80211_scan_request {
 =09bool scan_6ghz;
 =09u32 n_6ghz_params;
 =09struct cfg80211_scan_6ghz_params *scan_6ghz_params;
+=09struct rcu_head rcu_head;
=20
 =09/* keep last */
 =09struct ieee80211_channel *channels[];
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 6d82bd9eaf8c..638b2805222c 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -988,7 +988,7 @@ void ___cfg80211_scan_done(struct cfg80211_registered_d=
evice *rdev,
 =09kfree(rdev->int_scan_req);
 =09rdev->int_scan_req =3D NULL;
=20
-=09kfree(rdev->scan_req);
+=09kfree_rcu(rdev->scan_req, rcu_head);
 =09rdev->scan_req =3D NULL;
=20
 =09if (!send_message)
--=20
2.35.1


