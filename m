Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 754DE29C943
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 20:52:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503946AbgJ0Tvu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 15:51:50 -0400
Received: from mailout10.rmx.de ([94.199.88.75]:45567 "EHLO mailout10.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2411512AbgJ0Tvu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Oct 2020 15:51:50 -0400
Received: from kdin01.retarus.com (kdin01.dmz1.retloc [172.19.17.48])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout10.rmx.de (Postfix) with ESMTPS id 4CLMm22dh0z3Bjl;
        Tue, 27 Oct 2020 20:51:46 +0100 (CET)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin01.retarus.com (Postfix) with ESMTPS id 4CLMln50Sjz2xD9;
        Tue, 27 Oct 2020 20:51:33 +0100 (CET)
Received: from N95HX1G2.wgnetz.xx (192.168.54.166) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.408.0; Tue, 27 Oct
 2020 20:51:33 +0100
From:   Christian Eggers <ceggers@arri.de>
To:     "David S . Miller" <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, Christian Eggers <ceggers@arri.de>,
        "Willem de Bruijn" <willemb@google.com>,
        Deepa Dinamani <deepa.kernel@gmail.com>
Subject: [PATCH] socket: don't clear SOCK_TSTAMP_NEW when SO_TIMESTAMPNS is disabled
Date:   Tue, 27 Oct 2020 20:51:12 +0100
Message-ID: <20201027195112.23921-1-ceggers@arri.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [192.168.54.166]
X-RMX-ID: 20201027-205133-4CLMln50Sjz2xD9-0@kdin01
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[ Upstream commit 4e3bbb33e6f36e4b05be1b1b9b02e3dd5aaa3e69 ]

SOCK_TSTAMP_NEW (timespec64 instead of timespec) is also used for
hardware time stamps (configured via SO_TIMESTAMPING_NEW).

User space (ptp4l) first configures hardware time stamping via
SO_TIMESTAMPING_NEW which sets SOCK_TSTAMP_NEW. In the next step, ptp4l
disables SO_TIMESTAMPNS(_NEW) (software time stamps), but this must not
switch hardware time stamps back to "32 bit mode".

This problem happens on 32 bit platforms were the libc has already
switched to struct timespec64 (from SO_TIMExxx_OLD to SO_TIMExxx_NEW
socket options). ptp4l complains with "missing timestamp on transmitted
peer delay request" because the wrong format is received (and
discarded).

Fixes: 887feae36aee ("socket: Add SO_TIMESTAMP[NS]_NEW")
Signed-off-by: Christian Eggers <ceggers@arri.de>
Acked-by: Willem de Bruijn <willemb@google.com>
Acked-by: Deepa Dinamani <deepa.kernel@gmail.com>
---
This is a back port for 5.4. The original version has been applied to 5.8/5.9
a few hours ago. It does the same as the upstream patch, only the affected code
is at another position here. 

Please decide whether the Acked-by: tags (from the upstream patch) should
be kept or removed.

This back port is only required for 5.4, older kernels like 4.19 are not
affected.

regards
Christian


 net/core/sock.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 9a186d2ad36d..1eda7337b881 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -923,7 +923,6 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
 		} else {
 			sock_reset_flag(sk, SOCK_RCVTSTAMP);
 			sock_reset_flag(sk, SOCK_RCVTSTAMPNS);
-			sock_reset_flag(sk, SOCK_TSTAMP_NEW);
 		}
 		break;
 
-- 
Christian Eggers
Embedded software developer

Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
Sitz: Muenchen - Registergericht: Amtsgericht Muenchen - Handelsregisternummer: HRA 57918
Persoenlich haftender Gesellschafter: Arnold & Richter Cine Technik GmbH
Sitz: Muenchen - Registergericht: Amtsgericht Muenchen - Handelsregisternummer: HRB 54477
Geschaeftsfuehrer: Dr. Michael Neuhaeuser; Stephan Schenk; Walter Trauninger; Markus Zeiler

