Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E959F20A747
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 23:13:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405743AbgFYVNP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 17:13:15 -0400
Received: from ausw2a.mx.sorah.jp ([52.40.41.145]:38724 "EHLO mx.sorah.jp"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404016AbgFYVNO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jun 2020 17:13:14 -0400
X-Greylist: delayed 342 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Jun 2020 17:13:14 EDT
Received: from localhost.localdomain (home.igw.nkmiusercontent.com [192.50.220.178])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mx.sorah.jp (Postfix) with ESMTPSA id 62B0244C65;
        Thu, 25 Jun 2020 21:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=sorah.jp;
        s=nkmi1707srhjp; t=1593119251;
        bh=t48guIHwTRE/Cb0XHoF569vP+EV9GLGaMhQyQTYjLn4=;
        h=From:To:Cc:Subject:Date;
        b=iUpM6JfWF665eQmlzfL3n4CIc12HQrcUjb9VEVe+YvVYOJXQARHMT6H8Q07+jVOc1
         fXf1xG31jctUNuRd6mSijk/d2x/WVIUjeCGTS6VNknu7WpJCH+kWd1H8AHK/PPEif3
         UKLrNaSff5njaS/ipgMEzKvGDm8yqln3mm+3JSXGjAKLai1k27KBWBi4GkHXpBWxQ5
         HkSezIXAjQEK2Jv4E79BhteG2aM/9PqYB+yQGfDrwmYGMmmo1B97jDfsGjGYmJXIfL
         Wwx01vX/FgavxJIfxCXo2eQPoM2f1vm4u/DtE/3XquqbNMazQ+vsXk0E4RepFSSl7C
         kHTSbR4e1QkXg==
From:   Sorah Fukumori <her@sorah.jp>
To:     netdev@vger.kernel.org
Cc:     Sorah Fukumori <her@sorah.jp>
Subject: [PATCH iproute2] ip fou: respect preferred_family for IPv6
Date:   Fri, 26 Jun 2020 06:07:12 +0900
Message-Id: <20200625210712.1863300-1-her@sorah.jp>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ip(8) accepts -family ipv6 (-6) option at the toplevel. It is
straightforward to support the existing option for modifying listener
on IPv6 addresses.

Maintain the backward compatibility by leaving ip fou -6 flag
implemented, while it's removed from the usage message.

Signed-off-by: Sorah Fukumori <her@sorah.jp>
---
 ip/ipfou.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/ip/ipfou.c b/ip/ipfou.c
index ea126b08..9c697770 100644
--- a/ip/ipfou.c
+++ b/ip/ipfou.c
@@ -27,10 +27,10 @@
 static void usage(void)
 {
 	fprintf(stderr,
-		"Usage: ip fou add port PORT { ipproto PROTO  | gue } [ -6 ]\n"
+		"Usage: ip fou add port PORT { ipproto PROTO  | gue }\n"
 		"		   [ local IFADDR ] [ peer IFADDR ]\n"
 		"		   [ peer_port PORT ] [ dev IFNAME ]\n"
-		"       ip fou del port PORT [ -6 ] [ local IFADDR ]\n"
+		"       ip fou del port PORT [ local IFADDR ]\n"
 		"		   [ peer IFADDR ] [ peer_port PORT ]\n"
 		"		   [ dev IFNAME ]\n"
 		"       ip fou show\n"
@@ -55,13 +55,17 @@ static int fou_parse_opt(int argc, char **argv, struct nlmsghdr *n,
 {
 	const char *local = NULL, *peer = NULL;
 	__u16 port, peer_port = 0;
-	__u8 family = AF_INET;
+	__u8 family = preferred_family;
 	bool gue_set = false;
 	int ipproto_set = 0;
 	__u8 ipproto, type;
 	int port_set = 0;
 	int index = 0;
 
+	if (preferred_family == AF_UNSPEC) {
+		family = AF_INET;
+	}
+
 	while (argc > 0) {
 		if (!matches(*argv, "port")) {
 			NEXT_ARG();
-- 
2.26.2

