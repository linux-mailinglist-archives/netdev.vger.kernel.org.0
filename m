Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44209246541
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 13:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727773AbgHQLZh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 07:25:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726171AbgHQLZg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 07:25:36 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85ABFC061389
        for <netdev@vger.kernel.org>; Mon, 17 Aug 2020 04:25:36 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1k7dGY-0000Wl-7m; Mon, 17 Aug 2020 13:25:26 +0200
Received: from sha by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1k7dGX-0004S3-Ut; Mon, 17 Aug 2020 13:25:25 +0200
From:   Sascha Hauer <s.hauer@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     kernel@pengutronix.de, Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH v2] iproute2: ip maddress: Check multiaddr length
Date:   Mon, 17 Aug 2020 13:25:19 +0200
Message-Id: <20200817112519.15975-1-s.hauer@pengutronix.de>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ip maddress add|del takes a MAC address as argument, so insist on
getting a length of ETH_ALEN bytes. This makes sure the passed argument
is actually a MAC address and especially not an IPv4 address which
was previously accepted and silently taken as a MAC address.

While at it, do not print *argv in the error path as this has been
modified by ll_addr_a2n() and doesn't contain the full string anymore,
which can lead to misleading error messages.

Also while at it, replace the hardcoded buffer size with the actual
buffer size using sizeof().

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---

Changes since v1:
- Replace hardcoded 14 with sizeof(ifr.ifr_hwaddr.sa_data)

 ip/ipmaddr.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/ip/ipmaddr.c b/ip/ipmaddr.c
index 3400e055..d41ac63a 100644
--- a/ip/ipmaddr.c
+++ b/ip/ipmaddr.c
@@ -291,7 +291,7 @@ static int multiaddr_modify(int cmd, int argc, char **argv)
 {
 	struct ifreq ifr = {};
 	int family;
-	int fd;
+	int fd, len;
 
 	if (cmd == RTM_NEWADDR)
 		cmd = SIOCADDMULTI;
@@ -313,9 +313,14 @@ static int multiaddr_modify(int cmd, int argc, char **argv)
 				usage();
 			if (ifr.ifr_hwaddr.sa_data[0])
 				duparg("address", *argv);
-			if (ll_addr_a2n(ifr.ifr_hwaddr.sa_data,
-					14, *argv) < 0) {
-				fprintf(stderr, "Error: \"%s\" is not a legal ll address.\n", *argv);
+			len = ll_addr_a2n(ifr.ifr_hwaddr.sa_data,
+					  sizeof(ifr.ifr_hwaddr.sa_data),
+					  *argv);
+			if (len < 0)
+				exit(1);
+
+			if (len != ETH_ALEN) {
+				fprintf(stderr, "Error: Invalid address length %d - must be %d bytes\n", len, ETH_ALEN);
 				exit(1);
 			}
 		}
-- 
2.28.0

