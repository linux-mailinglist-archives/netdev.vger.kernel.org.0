Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1164758133A
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 14:40:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233571AbiGZMj6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 08:39:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232310AbiGZMj5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 08:39:57 -0400
Received: from sender-of-o53.zoho.in (sender-of-o53.zoho.in [103.117.158.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 119AE2ED4E;
        Tue, 26 Jul 2022 05:39:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1658839167; cv=none; 
        d=zohomail.in; s=zohoarc; 
        b=UkfuxHVLOwO/vn5hQmBft+g6uXh5aUV1+rD/VBC9ql1x2s1rMdkRKWSULiAbebxfR/MSK+qdzn+OnOf7NMUnOHQ57oCU3HX3xhwMVDOQf9vIJGoBfgRxVp8aKGU7AVIpjLOSrw1PbOSXUYaDZSMEXO48ClWDs+Lfl4+WG0RO89c=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.in; s=zohoarc; 
        t=1658839167; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:MIME-Version:Message-ID:Subject:To; 
        bh=UWd274VYR1WKzP/YgplPfzV3z+zLp7Z125urE755fUM=; 
        b=QvZvg9dVjsKln67kWE0aija4i5+ghMJp5YfYaJk2KYHmUrfh8Kg9WksFSajUUOUZZziuDuHwnr8V9guDo3eVd7ycHdr8xbJf/CCp2vy5vnigA1qCU4i1lRuBIUa+h2uwBC7eR4tSl10hgATJPR+pagwAzDzA2CNUa7VA1Y3M+sw=
ARC-Authentication-Results: i=1; mx.zohomail.in;
        dkim=pass  header.i=siddh.me;
        spf=pass  smtp.mailfrom=code@siddh.me;
        dmarc=pass header.from=<code@siddh.me>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1658839167;
        s=zmail; d=siddh.me; i=code@siddh.me;
        h=From:From:To:To:Cc:Cc:Message-ID:Subject:Subject:Date:Date:MIME-Version:Content-Transfer-Encoding:Content-Type:Message-Id:Reply-To;
        bh=UWd274VYR1WKzP/YgplPfzV3z+zLp7Z125urE755fUM=;
        b=LqDgFxJ4AeYBp4bkbR6w70NQ2bdc9fL3GxdkQIHkMTSd9yxCamFTE4AtO1bzE1Zu
        NX7Tu4CmcOyQ2dTUYqyxAkbTkmY8bgd1ruIHZcOcZRQM/9JDcWw+y746el1eKOLYZry
        5rQbUZEEZJv/9CMfr1eYdtCzNHHSusI33CNGf2Ag=
Received: from localhost.localdomain (103.240.204.132 [103.240.204.132]) by mx.zoho.in
        with SMTPS id 1658839166242252.82637890145338; Tue, 26 Jul 2022 18:09:26 +0530 (IST)
From:   Siddh Raman Pant <code@siddh.me>
To:     Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel-mentees 
        <linux-kernel-mentees@lists.linuxfoundation.org>,
        syzbot+f9acff9bf08a845f225d@syzkaller.appspotmail.com,
        syzbot+6cb476b7c69916a0caca@syzkaller.appspotmail.com,
        syzbot+9250865a55539d384347@syzkaller.appspotmail.com
Message-ID: <20220726123921.29664-1-code@siddh.me>
Subject: [PATCH v2] wifi: cfg80211: Fix UAF in ieee80211_scan_rx()
Date:   Tue, 26 Jul 2022 18:09:21 +0530
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-ZohoMailClient: External
Content-Type: text/plain; charset=utf8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_RED autolearn=ham autolearn_force=no
        version=3.4.6
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
initiated by ieee80211_rx_napi() (see line 5044 of mac80211/rx.c).

Thus, add an rcu_head to the scan_req struct, so that we can use
kfree_rcu() instead of kfree() and thus not free during the critical
section.

We can clear the pointer before freeing here, since scan_req is
accessed using rcu_dereference().

Bug report (3): https://syzkaller.appspot.com/bug?extid=3Df9acff9bf08a845f2=
25d
Reported-by: syzbot+f9acff9bf08a845f225d@syzkaller.appspotmail.com
Reported-by: syzbot+6cb476b7c69916a0caca@syzkaller.appspotmail.com
Reported-by: syzbot+9250865a55539d384347@syzkaller.appspotmail.com

Signed-off-by: Siddh Raman Pant <code@siddh.me>
---
Changes since v1 as requested:
- Fixed commit heading and better commit message.
- Clear pointer before freeing.

 include/net/cfg80211.h | 2 ++
 net/wireless/scan.c    | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 80f41446b1f0..7e0b448c4cdb 100644
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
index 6d82bd9eaf8c..6cf58fe6dea0 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -988,8 +988,8 @@ void ___cfg80211_scan_done(struct cfg80211_registered_d=
evice *rdev,
 =09kfree(rdev->int_scan_req);
 =09rdev->int_scan_req =3D NULL;
=20
-=09kfree(rdev->scan_req);
 =09rdev->scan_req =3D NULL;
+=09kfree_rcu(rdev_req, rcu_head);
=20
 =09if (!send_message)
 =09=09rdev->scan_msg =3D msg;
--=20
2.35.1


