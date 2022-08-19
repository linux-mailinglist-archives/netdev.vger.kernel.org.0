Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 939F459A6DB
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 22:12:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351719AbiHSUGI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 16:06:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351558AbiHSUGG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 16:06:06 -0400
Received: from sender-of-o50.zoho.in (sender-of-o50.zoho.in [103.117.158.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DE57EC4CD;
        Fri, 19 Aug 2022 13:06:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1660939524; cv=none; 
        d=zohomail.in; s=zohoarc; 
        b=YmzNaWO54q/8fCTIN4jaIZ5Ndxwp9+YSr/ByeZ1N7fM3t9mAdvJ8y6JVwVmhL749gAw2Crf1yFMBP/hmDlyxgG/vh5Z+ClbSGKiIy3i2NJwXvskTK6FyVe5N4KEHj2guGG5g6uEOd1go6jtRcc5iu0jDV2Sp2RVUv6Q4zeceEyk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.in; s=zohoarc; 
        t=1660939524; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:MIME-Version:Message-ID:Subject:To; 
        bh=ZbOmMhea6mo0GiKmo4Riv4/f27wDQaFeMZfT8F4TkaM=; 
        b=OTX/jA3DUnqGI4oQNVaV6ZBR9X9H6EIAEQjLXa/wZaMOl2Z3TZz6wxSZaDXy6qqFp6N63Js0NPNTVCPXH/86DU53MrALzPgxdKM/rLiqEHfJ+Mwd1ibKenRYgvk9gbnU3Bpi+dALQyCOps/2DnjxwkyK+0mLveRSoXh3t9vdtSg=
ARC-Authentication-Results: i=1; mx.zohomail.in;
        dkim=pass  header.i=siddh.me;
        spf=pass  smtp.mailfrom=code@siddh.me;
        dmarc=pass header.from=<code@siddh.me>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1660939524;
        s=zmail; d=siddh.me; i=code@siddh.me;
        h=From:From:To:To:Cc:Cc:Message-ID:Subject:Subject:Date:Date:MIME-Version:Content-Transfer-Encoding:Content-Type:Message-Id:Reply-To;
        bh=ZbOmMhea6mo0GiKmo4Riv4/f27wDQaFeMZfT8F4TkaM=;
        b=Neex3bMTcjTpaHR6LmwPqzEz9gmMywdSnuGnLC4/0PQxWQHeQgjvg/vIyndPhGIP
        g5dCrqPdTnxpeuhMSYF1XsLA1i8oN+RIhwNXtxznyHNgESUSm8EUXMycuICmyI0cgU/
        tX8mu62ADEKmBazZSC65bTiBd2o0Fmvhr3jTdaC0=
Received: from localhost.localdomain (103.86.19.2 [103.86.19.2]) by mx.zoho.in
        with SMTPS id 1660939523728629.6711836985853; Sat, 20 Aug 2022 01:35:23 +0530 (IST)
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
        syzbot+f9acff9bf08a845f225d@syzkaller.appspotmail.com
Message-ID: <20220819200340.34826-1-code@siddh.me>
Subject: [PATCH v3] wifi: mac80211: Fix UAF in ieee80211_scan_rx()
Date:   Sat, 20 Aug 2022 01:33:40 +0530
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

ieee80211_scan_rx() tries to access scan_req->flags after a
null check, but a UAF is observed when the scan is completed
and __ieee80211_scan_completed() executes, which then calls
cfg80211_scan_done() leading to the freeing of scan_req.

Since scan_req is rcu_dereference()'d, prevent the racing in
__ieee80211_scan_completed() by ensuring that from mac80211's
POV it is no longer accessed from an RCU read critical section
before we call cfg80211_scan_done().

Bug report: https://syzkaller.appspot.com/bug?extid=3Df9acff9bf08a845f225d
Reported-by: syzbot+f9acff9bf08a845f225d@syzkaller.appspotmail.com
Suggested-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Siddh Raman Pant <code@siddh.me>
---
Changes in v3:
Use Johannes Berg's suggestion as-it-is:
https://lore.kernel.org/netdev/18fd9b89d45aedc1504d0cbd299ffb289ae96438.cam=
el@sipsolutions.net/

v2 is now obsolete since it was an incorrect way to go about things.

 net/mac80211/scan.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index fa8ddf576bc1..c4f2aeb31da3 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -469,16 +469,19 @@ static void __ieee80211_scan_completed(struct ieee802=
11_hw *hw, bool aborted)
 =09scan_req =3D rcu_dereference_protected(local->scan_req,
 =09=09=09=09=09     lockdep_is_held(&local->mtx));
=20
-=09if (scan_req !=3D local->int_scan_req) {
-=09=09local->scan_info.aborted =3D aborted;
-=09=09cfg80211_scan_done(scan_req, &local->scan_info);
-=09}
 =09RCU_INIT_POINTER(local->scan_req, NULL);
 =09RCU_INIT_POINTER(local->scan_sdata, NULL);
=20
 =09local->scanning =3D 0;
 =09local->scan_chandef.chan =3D NULL;
=20
+=09synchronize_rcu();
+
+=09if (scan_req !=3D local->int_scan_req) {
+=09=09local->scan_info.aborted =3D aborted;
+=09=09cfg80211_scan_done(scan_req, &local->scan_info);
+=09}
+
 =09/* Set power back to normal operating levels. */
 =09ieee80211_hw_config(local, 0);
=20
--=20
2.35.1


