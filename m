Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DBD39BAF4
	for <lists+netdev@lfdr.de>; Sat, 24 Aug 2019 04:43:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726436AbfHXCnD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 22:43:03 -0400
Received: from mail.nic.cz ([217.31.204.67]:37294 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725930AbfHXCnC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Aug 2019 22:43:02 -0400
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTP id 07905140D24;
        Sat, 24 Aug 2019 04:43:00 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1566614580; bh=NOu986em+7K8n650ujDXWGowyX6J66HaMKRYhMqamFU=;
        h=From:To:Date;
        b=vVMMdXjP5SWcLVMPfTpNiR7jDQ3LlHbcVgJQ05WmrY5gMBiizdcahP9mLX8bUKS/u
         2ULj7d0FNoQ/T3SJ3gEPiinGmXfIz+K/SHQLRVhQcNhUV7J671I9EFyTD/LncuENV/
         a+LulmGNlD0V9HpJZ6zwwJrvpZzhn04GknxmjxmI=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
Subject: [PATCH RFC iproute2-next] iplink: allow to change iplink value
Date:   Sat, 24 Aug 2019 04:42:51 +0200
Message-Id: <20190824024251.4542-5-marek.behun@nic.cz>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190824024251.4542-1-marek.behun@nic.cz>
References: <20190824024251.4542-1-marek.behun@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.100.3 at mail.nic.cz
X-Virus-Status: Clean
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,SHORTCIRCUIT
        shortcircuit=ham autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow to change the interface to which a given interface is linked to.
This is useful in the case of multi-CPU port DSA, for changing the CPU
port of a given user port.

Signed-off-by: Marek Behún <marek.behun@nic.cz>
Cc: David Ahern <dsahern@gmail.com>
Cc: Stephen Hemminger <stephen@networkplumber.org>
---
 ip/iplink.c           | 16 +++++-----------
 man/man8/ip-link.8.in |  7 +++++++
 2 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/ip/iplink.c b/ip/iplink.c
index 212a0885..d52c0aaf 100644
--- a/ip/iplink.c
+++ b/ip/iplink.c
@@ -579,7 +579,6 @@ int iplink_parse(int argc, char **argv, struct iplink_req *req, char **type)
 {
 	char *name = NULL;
 	char *dev = NULL;
-	char *link = NULL;
 	int ret, len;
 	char abuf[32];
 	int qlen = -1;
@@ -590,6 +589,7 @@ int iplink_parse(int argc, char **argv, struct iplink_req *req, char **type)
 	int numrxqueues = -1;
 	int link_netnsid = -1;
 	int index = 0;
+	int link = -1;
 	int group = -1;
 	int addr_len = 0;
 
@@ -620,7 +620,10 @@ int iplink_parse(int argc, char **argv, struct iplink_req *req, char **type)
 				invarg("Invalid \"index\" value", *argv);
 		} else if (matches(*argv, "link") == 0) {
 			NEXT_ARG();
-			link = *argv;
+			link = ll_name_to_index(*argv);
+			if (!link)
+				return nodev(*argv);
+			addattr32(&req->n, sizeof(*req), IFLA_LINK, link);
 		} else if (matches(*argv, "address") == 0) {
 			NEXT_ARG();
 			addr_len = ll_addr_a2n(abuf, sizeof(abuf), *argv);
@@ -1004,15 +1007,6 @@ int iplink_parse(int argc, char **argv, struct iplink_req *req, char **type)
 			exit(-1);
 		}
 
-		if (link) {
-			int ifindex;
-
-			ifindex = ll_name_to_index(link);
-			if (!ifindex)
-				return nodev(link);
-			addattr32(&req->n, sizeof(*req), IFLA_LINK, ifindex);
-		}
-
 		req->i.ifi_index = index;
 	}
 
diff --git a/man/man8/ip-link.8.in b/man/man8/ip-link.8.in
index a8ae72d2..800aed05 100644
--- a/man/man8/ip-link.8.in
+++ b/man/man8/ip-link.8.in
@@ -149,6 +149,9 @@ ip-link \- network device configuration
 .br
 .RB "[ " nomaster " ]"
 .br
+.RB "[ " link
+.IR DEVICE " ]"
+.br
 .RB "[ " vrf
 .IR NAME " ]"
 .br
@@ -2131,6 +2134,10 @@ set master device of the device (enslave device).
 .BI nomaster
 unset master device of the device (release device).
 
+.TP
+.BI link " DEVICE"
+set device to which this device is linked to.
+
 .TP
 .BI addrgenmode " eui64|none|stable_secret|random"
 set the IPv6 address generation mode
-- 
2.21.0

