Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC0A12886FD
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 12:32:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387690AbgJIKcS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 06:32:18 -0400
Received: from mailout08.rmx.de ([94.199.90.85]:41460 "EHLO mailout08.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730763AbgJIKcS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Oct 2020 06:32:18 -0400
Received: from kdin02.retarus.com (kdin02.dmz1.retloc [172.19.17.49])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout08.rmx.de (Postfix) with ESMTPS id 4C74Bk6dDszMt0L;
        Fri,  9 Oct 2020 12:32:14 +0200 (CEST)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin02.retarus.com (Postfix) with ESMTPS id 4C74BJ1tfXz2TTLg;
        Fri,  9 Oct 2020 12:31:52 +0200 (CEST)
Received: from N95HX1G2.wgnetz.xx (192.168.54.145) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.408.0; Fri, 9 Oct
 2020 12:31:52 +0200
From:   Christian Eggers <ceggers@arri.de>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Deepa Dinamani <deepa.kernel@gmail.com>
CC:     Willem de Bruijn <willemb@google.com>,
        Christoph Hellwig <hch@lst.de>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Christian Eggers <ceggers@arri.de>
Subject: [PATCH net 1/2] socket: fix option SO_TIMESTAMPING_NEW
Date:   Fri, 9 Oct 2020 12:31:20 +0200
Message-ID: <20201009103121.1004-1-ceggers@arri.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [192.168.54.145]
X-RMX-ID: 20201009-123152-4C74BJ1tfXz2TTLg-0@kdin02
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The comparison of optname with SO_TIMESTAMPING_NEW is wrong way around,
so SOCK_TSTAMP_NEW will first be set and than reset again. Additionally
move it out of the test for SOF_TIMESTAMPING_RX_SOFTWARE as this seems
unrelated.

This problem happens on 32 bit platforms were the libc has already
switched to struct timespec64 (from SO_TIMExxx_OLD to SO_TIMExxx_NEW
socket options). ptp4l complains with "missing timestamp on transmitted
peer delay request" because the wrong format is received (and
discarded).

Fixes: 9718475e6908 ("socket: Add SO_TIMESTAMPING_NEW")
Signed-off-by: Christian Eggers <ceggers@arri.de>
---
 net/core/sock.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 34a8d12e38d7..3926804702c1 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1024,16 +1024,15 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
 		}
 
 		sk->sk_tsflags = val;
+		if (optname != SO_TIMESTAMPING_NEW)
+			sock_reset_flag(sk, SOCK_TSTAMP_NEW);
+
 		if (val & SOF_TIMESTAMPING_RX_SOFTWARE)
 			sock_enable_timestamp(sk,
 					      SOCK_TIMESTAMPING_RX_SOFTWARE);
-		else {
-			if (optname == SO_TIMESTAMPING_NEW)
-				sock_reset_flag(sk, SOCK_TSTAMP_NEW);
-
+		else
 			sock_disable_timestamp(sk,
 					       (1UL << SOCK_TIMESTAMPING_RX_SOFTWARE));
-		}
 		break;
 
 	case SO_RCVLOWAT:
-- 
Christian Eggers
Embedded software developer

Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
Sitz: Muenchen - Registergericht: Amtsgericht Muenchen - Handelsregisternummer: HRA 57918
Persoenlich haftender Gesellschafter: Arnold & Richter Cine Technik GmbH
Sitz: Muenchen - Registergericht: Amtsgericht Muenchen - Handelsregisternummer: HRB 54477
Geschaeftsfuehrer: Dr. Michael Neuhaeuser; Stephan Schenk; Walter Trauninger; Markus Zeiler

