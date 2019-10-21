Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86A1FDEBF6
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 14:19:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728305AbfJUMS5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 08:18:57 -0400
Received: from ni.piap.pl ([195.187.100.5]:48156 "EHLO ni.piap.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727256AbfJUMS5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Oct 2019 08:18:57 -0400
X-Greylist: delayed 440 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Oct 2019 08:18:55 EDT
Received: from t19.piap.pl (OSB1819.piap.pl [10.0.9.19])
        (using TLSv1.2 with cipher AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ni.piap.pl (Postfix) with ESMTPSA id A1B08443491;
        Mon, 21 Oct 2019 14:18:54 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 ni.piap.pl A1B08443491
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=piap.pl; s=mail;
        t=1571660334; bh=Tp8OSf1h/wDKpwi0+HzYPecCfDy55FK9qmwYC4Eai90=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=CLbMeDVxHJ9JNtZuGbwZP5WljuUhEqWhdQiChl7+y7D2bbVOAbXSXERRWrruUaAnQ
         joD5Cz0rULQLcizQTb3L6boWn+924hxz9bhnhKdU9wPCgcP+y+QVf/5dMGPUm2jWxi
         HdZzdmfKXtgE0xHWFOaAwH/nSKLtw9vhkz3X9M/0=
From:   khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] 802.11n IBSS: wlan0 stops receiving packets due to aggregation after sender reboot
References: <m34l02mh71.fsf@t19.piap.pl>
Date:   Mon, 21 Oct 2019 14:18:53 +0200
In-Reply-To: <m34l02mh71.fsf@t19.piap.pl> ("Krzysztof \=\?utf-8\?Q\?Ha\=C5\=82as\?\=
 \=\?utf-8\?Q\?a\=22's\?\= message of
        "Mon, 21 Oct 2019 14:11:30 +0200")
Message-ID: <m3zhhul2aa.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-KLMS-Rule-ID: 4
X-KLMS-Message-Action: skipped
X-KLMS-AntiSpam-Status: not scanned, whitelist
X-KLMS-AntiPhishing: not scanned, whitelist
X-KLMS-AntiVirus: Kaspersky Security 8.0 for Linux Mail Server, version 8.0.1.721, not scanned, whitelist
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix a bug where the mac80211 RX aggregation code sets a new aggregation
"session" at the remote station's request, but the head_seq_num
(the sequence number the receiver expects to receive) isn't reset.

Spotted on a pair of AR9580 in IBSS mode.

diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
index 4d1c335e06e5..775a51cc51c9 100644
--- a/net/mac80211/agg-rx.c
+++ b/net/mac80211/agg-rx.c
@@ -354,9 +354,11 @@ void ___ieee80211_start_rx_ba_session(struct sta_info =
*sta,
 			 */
 			rcu_read_lock();
 			tid_rx =3D rcu_dereference(sta->ampdu_mlme.tid_rx[tid]);
-			if (tid_rx && tid_rx->timeout =3D=3D timeout)
+			if (tid_rx && tid_rx->timeout =3D=3D timeout) {
+				tid_rx->ssn =3D start_seq_num;
+				tid_rx->head_seq_num =3D start_seq_num;
 				status =3D WLAN_STATUS_SUCCESS;
-			else
+			} else
 				status =3D WLAN_STATUS_REQUEST_DECLINED;
 			rcu_read_unlock();
 			goto end;

--=20
Krzysztof Ha=C5=82asa

=C5=81UKASIEWICZ Research Network
Industrial Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
