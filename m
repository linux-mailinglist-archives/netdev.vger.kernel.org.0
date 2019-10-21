Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77D8FDFCEE
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 06:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387651AbfJVE7B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 00:59:01 -0400
Received: from ni.piap.pl ([195.187.100.5]:41074 "EHLO ni.piap.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387462AbfJVE7A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Oct 2019 00:59:00 -0400
Received: from t19.piap.pl (OSB1819.piap.pl [10.0.9.19])
        (using TLSv1.2 with cipher AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ni.piap.pl (Postfix) with ESMTPSA id A1BD9443141;
        Tue, 22 Oct 2019 06:58:57 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 ni.piap.pl A1BD9443141
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=piap.pl; s=mail;
        t=1571720338; bh=5sGEWkaUNVS3ZDgcwrCiHd9vXY1HkWoD0Tk6Dh28hfM=;
        h=From:To:Cc:Subject:In-Reply-To:Date:References:From;
        b=lzJJG3out/A+BWjk9oZFkkvPT8gnUGpbqmq09MWSXDYx1sSDSOuZkuFadAvksnWTe
         dmiGyNb4wbvhhRDFQoJL2KMUrM/lWvY3bGdkUlpzrCsUvnFWwtjB7pO7v+rAHboqC8
         Rl8spBVi3z6o3Fqv3hL2lzwJfKGpNhMJpBIRVwYM=
From:   khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] 802.11n IBSS: wlan0 stops receiving packets due to aggregation after sender reboot
In-Reply-To: <m34l02mh71.fsf@t19.piap.pl>
Date:   Mon, 21 Oct 2019 14:18:53 +0200
Lines:  32
References: <m34l02mh71.fsf@t19.piap.pl>
Message-ID: <m3v9shl6jz.fsf@t19.piap.pl>
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

Signed-off-by: Krzysztof Halasa <khalasa@piap.pl>

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
