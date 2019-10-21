Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB93ADEBFC
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 14:19:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728591AbfJUMTK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 08:19:10 -0400
Received: from ni.piap.pl ([195.187.100.5]:48172 "EHLO ni.piap.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728540AbfJUMTJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Oct 2019 08:19:09 -0400
Received: from t19.piap.pl (OSB1819.piap.pl [10.0.9.19])
        (using TLSv1.2 with cipher AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ni.piap.pl (Postfix) with ESMTPSA id 8F1E7443597;
        Mon, 21 Oct 2019 14:11:31 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 ni.piap.pl 8F1E7443597
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=piap.pl; s=mail;
        t=1571659891; bh=2l3g9AQNQvoNkKc40D1gZPWvLVs7AjrMyGTdwvpiyJo=;
        h=From:To:Cc:Subject:Date:From;
        b=hR8kZEAIxIvs7So3Xp8ANP/+MxjRK9eNSwNzAsIfbz4WyTzOfezCPLNASVzEbjKE/
         Xmgf6XaIHh+QVaam4MXqyTCBgkFPrOD/s0rj5y+NPltuyessadSQT9ZDpelTGbhdIA
         kpb9cfzTBUWcVrbuoVt77n/RWsRRfubcxySgma+Y=
From:   khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: 802.11n IBSS: wlan0 stops receiving packets due to aggregation after sender reboot
Date:   Mon, 21 Oct 2019 14:11:30 +0200
Message-ID: <m34l02mh71.fsf@t19.piap.pl>
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

Johannes,

it seems I've encountered a bug in mac80211 RX aggregation handler.
The hw is a pair of stations using AR9580 (PCI ID 168c:0033) PCIe
adapters. Linux 5.4-rc4.
The driver shows the chip is Atheros AR9300 Rev:4.
I'm using (on both ends):
	iw wlan0 set type ibss
	ip link set wlan0 up
	iw dev wlan0 ibss join $ESSID $FREQ HT20

The problem manifests itself after one of the stations is restarted
(or the ath9k driver is reloaded, or a station is out of range for
some time etc).
It appears that the mac80211 RX aggregation code sets a new aggregation
"session" at the remote station's request, but the head_seq_num
(the sequence number the receiver expects to receive) isn't reset.
I've added some debugging code to ___ieee80211_start_rx_ba_session()
and ieee80211_sta_manage_reorder_buf() and it produced the following:

Both stations boot and join the IBSS, packets get through:
[   61.123131] AGG RX OK: ssn 1
[   61.125346] SEQ OK: 1 vs 1
[   61.125484] SEQ OK: 2 vs 2
[   62.100841] SEQ OK: 3 vs 3
...
[  180.124210] SEQ OK: 130 vs 130
[  181.123888] SEQ OK: 131 vs 131
[  182.126046] SEQ OK: 132 vs 132

Now I'm rebooting the remote station. It joins IBSS, packets can be seen
on mon0 monitoring interface (on the local station), but they aren't
arriving on wlan0:

[  192.131102] SEQ BAD: 0 vs 133
[  192.151243] AGG RX no change - OK: ssn 1
[  192.242760] SEQ BAD: 1 vs 133
[  193.133819] SEQ BAD: 2 vs 133
[  193.272802] SEQ BAD: 3 vs 133
...
[  421.272374] SEQ BAD: 130 vs 133
[  421.303630] SEQ BAD: 131 vs 133
[  422.327924] SEQ BAD: 132 vs 133

Then the sequence number catches up and the communication is
reestablished:
[  423.167023] SEQ OK: 133 vs 133
[  423.169061] SEQ OK: 134 vs 134
[  423.351618] SEQ OK: 135 vs 135

I'll attach a patch in a separate mail but I'm not sure if it's
the optimal fix - one packet (the "SEQ BAD: 0 vs 133) is still dropped,
and I guess it won't work if the sender decides to not request
aggregation anymore.

Comments?

The debugging code:
--- a/net/mac80211/agg-rx.c
+++ b/net/mac80211/agg-rx.c
@@ -354,9 +354,10 @@ void ___ieee80211_start_rx_ba_session(struct sta_info =
*sta,
 			 */
 			rcu_read_lock();
 			tid_rx =3D rcu_dereference(sta->ampdu_mlme.tid_rx[tid]);
-			if (tid_rx && tid_rx->timeout =3D=3D timeout)
+			if (tid_rx && tid_rx->timeout =3D=3D timeout) {
 				status =3D WLAN_STATUS_SUCCESS;
-			else
+				printk(KERN_DEBUG "AGG RX no change - OK: ssn %u\n", start_seq_num);
+			} else
 				status =3D WLAN_STATUS_REQUEST_DECLINED;
 			rcu_read_unlock();
 			goto end;
@@ -434,6 +437,7 @@ void ___ieee80211_start_rx_ba_session(struct sta_info *=
sta,
 	tid_agg_rx->tid =3D tid;
 	tid_agg_rx->sta =3D sta;
 	status =3D WLAN_STATUS_SUCCESS;
+	printk(KERN_DEBUG "AGG RX OK: ssn %u\n", start_seq_num);
=20
 	/* activate it for RX */
 	rcu_assign_pointer(sta->ampdu_mlme.tid_rx[tid], tid_agg_rx);
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1298,9 +1298,11 @@ static bool ieee80211_sta_manage_reorder_buf(struct =
ieee80211_sub_if_data *sdata
=20
 	/* frame with out of date sequence number */
 	if (ieee80211_sn_less(mpdu_seq_num, head_seq_num)) {
+		printk(KERN_DEBUG "SEQ BAD: %u vs %u\n", mpdu_seq_num, head_seq_num);
 		dev_kfree_skb(skb);
 		goto out;
-	}
+	} else
+		printk(KERN_DEBUG "SEQ OK: %u vs %u\n", mpdu_seq_num, head_seq_num);
=20
 	/*
 	 * If frame the sequence number exceeds our buffering window

--=20
Krzysztof Ha=C5=82asa

=C5=81UKASIEWICZ Research Network
Industrial Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
