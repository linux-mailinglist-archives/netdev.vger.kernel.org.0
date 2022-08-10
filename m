Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31BD458EB5B
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 13:36:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbiHJLgX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 07:36:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiHJLgW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 07:36:22 -0400
Received: from sender-of-o50.zoho.in (sender-of-o50.zoho.in [103.117.158.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F7116E899;
        Wed, 10 Aug 2022 04:36:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1660131358; cv=none; 
        d=zohomail.in; s=zohoarc; 
        b=aryWP3VgZHtZyyf1fe+yB/wYpwYI/5u7qDCuk5w1GPKehXmPuT4fQ2NntknHdokV+p+SUeD6kON8r3giMUsGoBWiVB4aByHFH2JxdkOXrM1D3JjBoRXbdbrkJuL5UWTBlTwZCXOQIGi092czqFn4cuqH0F0hBaFOph6DY1IcKQM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.in; s=zohoarc; 
        t=1660131358; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=u9HSKOXe5zxLLHtzfzWYR6+aGKllL8CvnILcjWqDyDs=; 
        b=arB6iGGmipIutBpTpMKc7FGYnmCf4+lCJ+CaqE3vw/RXvicQiTcvggjJvsZCG7K4HEK4TdB8coBHU4UiMkokfQbCBii8p9K1o7dU68dOajMXCxSmJBw6D4n5/GmEqJF0v/NgqE0ig31Fii4p2Hxe7wK1D4NGQLqNFo0MbIG3dCs=
ARC-Authentication-Results: i=1; mx.zohomail.in;
        dkim=pass  header.i=siddh.me;
        spf=pass  smtp.mailfrom=code@siddh.me;
        dmarc=pass header.from=<code@siddh.me>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1660131358;
        s=zmail; d=siddh.me; i=code@siddh.me;
        h=From:From:To:To:Cc:Cc:Message-ID:Subject:Subject:Date:Date:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Content-Type:Message-Id:Reply-To;
        bh=u9HSKOXe5zxLLHtzfzWYR6+aGKllL8CvnILcjWqDyDs=;
        b=ip5aGDSkBQDyzNEquBXB9jsVjgOOtNrM/DGtt9uQEr4rPWyfcKB+H6ktLYGuLfCn
        Og51WvpUI+itDBj1tKENAVJz9IZvR5Np5c1zUuBUq1tD2EhitKeCK5RW53DVrbUanzj
        Vor0M9FFVphLscHxTUMoeFW8KS8xgHUq0WlS18hM=
Received: from localhost.localdomain (103.176.10.218 [103.176.10.218]) by mx.zoho.in
        with SMTPS id 166013135646156.58855889315157; Wed, 10 Aug 2022 17:05:56 +0530 (IST)
From:   Siddh Raman Pant <code@siddh.me>
To:     syzbot+b6c9fe29aefe68e4ad34@syzkaller.appspotmail.com
Cc:     davem@davemloft.net, johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Message-ID: <20220810113551.344792-1-code@siddh.me>
Subject: Re: WARNING in ieee80211_ibss_csa_beacon
Date:   Wed, 10 Aug 2022 17:05:51 +0530
X-Mailer: git-send-email 2.35.1
In-Reply-To: <0000000000008c848805b123f174@google.com>
References: <0000000000008c848805b123f174@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-ZohoMailClient: External
Content-Type: text/plain; charset=utf8
X-Spam-Status: No, score=0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_RED
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When we are not connected to a channel, sending channel "switch"
announcement doesn't make any sense.

#syz test https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.gi=
t master

--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -530,6 +530,10 @@ int ieee80211_ibss_finish_csa(struct ieee80211_sub_if_=
data *sdata)
=20
 =09sdata_assert_lock(sdata);
=20
+=09/* When not connected/joined, sending CSA doesn't make sense. */
+=09if (sdata->u.ibss.state !=3D IEEE80211_IBSS_MLME_JOINED)
+=09=09return -ENOLINK;
+
 =09/* update cfg80211 bss information with the new channel */
 =09if (!is_zero_ether_addr(ifibss->bssid)) {
 =09=09cbss =3D cfg80211_get_bss(sdata->local->hw.wiphy,
--=20
2.35.1


