Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E06226CA09
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 21:43:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727269AbgIPTn2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 15:43:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:51288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727988AbgIPTnI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Sep 2020 15:43:08 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3656120936;
        Wed, 16 Sep 2020 19:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600285371;
        bh=8Z+lDdeh/Lm54wkc4RMJo8HAmOvWkS+ewAR6dfsYcPQ=;
        h=From:To:Cc:Subject:Date:From;
        b=AX69Si35meEms7Rz4sNGJC1SKd2elLLYYH9IavaMlECDn8e3Z1c7C5x2iuzD2TaWN
         EzYD53ev3gCtekoqW619v5aF9FolTPEnhk4bDpKQ0OIkL3aNhXdqwA/R/jdxox+w0w
         RWakqZXzwL+x5msCwAPwB19oNMAirqewfUyKvELs=
From:   Jakub Kicinski <kuba@kernel.org>
To:     dsahern@gmail.com
Cc:     stephen@networkplumber.org, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH iproute2-next] ip: promote missed packets to the -s row
Date:   Wed, 16 Sep 2020 12:42:49 -0700
Message-Id: <20200916194249.505389-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

missed_packet_errors are much more commonly reported:

linux$ git grep -c '[.>]rx_missed_errors ' -- drivers/ | wc -l
64
linux$ git grep -c '[.>]rx_over_errors ' -- drivers/ | wc -l
37

Plus those drivers are generally more modern than those
using rx_over_errors.

Since recently merged kernel documentation makes this
preference official, let's make ip -s output more informative
and let rx_missed_errors take the place of rx_over_errors.

Before:

2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP mode DEFAULT group default qlen 1000
    link/ether 00:0a:f7:c1:4d:38 brd ff:ff:ff:ff:ff:ff
    RX: bytes  packets  errors  dropped overrun mcast
    6.04T      4.67G    0       0       0       67.7M
    RX errors: length   crc     frame   fifo    missed
               0        0       0       0       7
    TX: bytes  packets  errors  dropped carrier collsns
    3.13T      2.76G    0       0       0       0
    TX errors: aborted  fifo   window heartbeat transns
               0        0       0       0       6

After:

2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP mode DEFAULT group default qlen 1000
    link/ether 00:0a:f7:c1:4d:38 brd ff:ff:ff:ff:ff:ff
    RX: bytes  packets  errors  dropped missed  mcast
    6.04T      4.67G    0       0       7       67.7M
    RX errors: length   crc     frame   fifo    overrun
               0        0       0       0       0
    TX: bytes  packets  errors  dropped carrier collsns
    3.13T      2.76G    0       0       0       0
    TX errors: aborted  fifo   window heartbeat transns
               0        0       0       0       6

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 ip/ipaddress.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/ip/ipaddress.c b/ip/ipaddress.c
index ccf67d1dd55c..0822a8d2d792 100644
--- a/ip/ipaddress.c
+++ b/ip/ipaddress.c
@@ -744,7 +744,7 @@ static void __print_link_stats(FILE *fp, struct rtattr *tb[])
 		close_json_object();
 	} else {
 		/* RX stats */
-		fprintf(fp, "    RX: bytes  packets  errors  dropped overrun mcast   %s%s",
+		fprintf(fp, "    RX: bytes  packets  errors  dropped missed  mcast   %s%s",
 			s->rx_compressed ? "compressed" : "", _SL_);
 
 		fprintf(fp, "    ");
@@ -752,7 +752,7 @@ static void __print_link_stats(FILE *fp, struct rtattr *tb[])
 		print_num(fp, 8, s->rx_packets);
 		print_num(fp, 7, s->rx_errors);
 		print_num(fp, 7, s->rx_dropped);
-		print_num(fp, 7, s->rx_over_errors);
+		print_num(fp, 7, s->rx_missed_errors);
 		print_num(fp, 7, s->multicast);
 		if (s->rx_compressed)
 			print_num(fp, 7, s->rx_compressed);
@@ -760,14 +760,14 @@ static void __print_link_stats(FILE *fp, struct rtattr *tb[])
 		/* RX error stats */
 		if (show_stats > 1) {
 			fprintf(fp, "%s", _SL_);
-			fprintf(fp, "    RX errors: length   crc     frame   fifo    missed%s%s",
+			fprintf(fp, "    RX errors: length   crc     frame   fifo    overrun%s%s",
 				s->rx_nohandler ? "   nohandler" : "", _SL_);
 			fprintf(fp, "               ");
 			print_num(fp, 8, s->rx_length_errors);
 			print_num(fp, 7, s->rx_crc_errors);
 			print_num(fp, 7, s->rx_frame_errors);
 			print_num(fp, 7, s->rx_fifo_errors);
-			print_num(fp, 7, s->rx_missed_errors);
+			print_num(fp, 7, s->rx_over_errors);
 			if (s->rx_nohandler)
 				print_num(fp, 7, s->rx_nohandler);
 		}
-- 
2.26.2

