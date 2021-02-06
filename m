Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AF86311BC1
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 07:40:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbhBFGiz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 01:38:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbhBFGiz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Feb 2021 01:38:55 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F01B2C06174A
        for <netdev@vger.kernel.org>; Fri,  5 Feb 2021 22:38:14 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id cl8so4815743pjb.0
        for <netdev@vger.kernel.org>; Fri, 05 Feb 2021 22:38:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ah16Tm7pIZZ71GnjSgsocms0uv9BGDOHd3yG17/sGTc=;
        b=BFssyVPRCaMb/FrjT1hv7J6UwJVn9PXzFFMB5Oj+WlBHRaJHx85LZUjSRSgbrQFyM5
         vv6xt6u+e0gGMDPYQHTSfFlfmlF1Y5dl3hG+2cFZhZWE8O2tJvo1JBkI1vJrZ3o1Xvmu
         2+VDJlQKnkK4o2AKpnaUZU8qhF0nEHvsUSe7Q27fSqXPCZ4nUGAepL6hEqRC++y3fzN2
         ZFV+8tDFAhGUVVNTV5fA7nvUZbDlTFbtoaeJo6Jtca+5ugk+FaBP4mApbs+TwZ6x7nnl
         m89zYdoDNMCyOPMvtUilm+7B73aqNYocwmIfTlalwtZXzwMV2ER/c9ZEJ8b1o60kFSf4
         sPVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ah16Tm7pIZZ71GnjSgsocms0uv9BGDOHd3yG17/sGTc=;
        b=LOUatGZy//YJbYSCoSmws+iqtLvA9JPhLJbMbSIUbj/z+R/EQs6n+GYaWQigRvOYgG
         T4AZ0EXtFrDc2x2ZY5baNYLIumUDaBUdutPUjeCrVuZSbBjFk4DDTO1Y0Ks0rxTFlzQu
         2KhWP8cJ88LVizvXA0bL5Ez+dc3jRVwQoFZKjHPmG/wTY5EM9y/Px4KsZO8F6ezk7aTQ
         hislBudUMz+PXD0GoT9vpOEiDcMkAnt21UNumdrsDwJKA+rRlKpZJvUwBM0cjorBUUDK
         B/wvYH04udgxgrWZSmeruGOeMyB0jvQYxqXcYZgmMXOgV3w+d1VVAJYubjMN6A+HuIuK
         qXng==
X-Gm-Message-State: AOAM531WFUJLkqs/P0spwVoak73tk9ip1CFAadgdSjl1SAYC9Q+9IBsF
        xytnlJ1fWA2ftQ4YTYbB817dczMfTdlzow==
X-Google-Smtp-Source: ABdhPJxXZC6a3yuXTcaE7DotTs5tHqrHDcCXa8v3EF5jwaI9UJ70nLcLbwu7bKSoNkKPI5Cq97UJSA==
X-Received: by 2002:a17:90b:1105:: with SMTP id gi5mr7338964pjb.26.1612593494078;
        Fri, 05 Feb 2021 22:38:14 -0800 (PST)
Received: from tardis.. (c-67-182-242-199.hsd1.ut.comcast.net. [67.182.242.199])
        by smtp.gmail.com with ESMTPSA id z11sm11971298pfk.97.2021.02.05.22.38.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 22:38:12 -0800 (PST)
From:   Thayne McCombs <astrothayne@gmail.com>
To:     netdev@vger.kernel.org, dsahern@kernel.org
Cc:     Thayne McCombs <astrothayne@gmail.com>
Subject: [PATCH iproute2-next] ss: Make leading ":" always optional for sport and dport
Date:   Fri,  5 Feb 2021 23:36:51 -0700
Message-Id: <20210206063650.7877-1-astrothayne@gmail.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The sport and dport conditions in expressions were inconsistent on
whether there should be a ":" at the beginning of the port when only a
port was provided depending on the family. The link and netlink
families required a ":" to work. The vsock family required the ":"
to be absent. The inet and inet6 families work with or without a leading
":".

This makes the leading ":" optional in all cases, so if sport or dport
are used, then it works with a leading ":" or without one, as inet and
inet6 did.
---
 misc/ss.c | 46 ++++++++++++++++++++++++----------------------
 1 file changed, 24 insertions(+), 22 deletions(-)

diff --git a/misc/ss.c b/misc/ss.c
index aefa1c2f..5c934fa0 100644
--- a/misc/ss.c
+++ b/misc/ss.c
@@ -2111,6 +2111,18 @@ static void vsock_set_inet_prefix(inet_prefix *a, __u32 cid)
 	memcpy(a->data, &cid, sizeof(cid));
 }
 
+static char* find_port(char *addr, bool is_port)
+{
+	char *port = NULL;
+	if (is_port)
+		port = addr;
+	else
+		port = strchr(addr, ':');
+	if (port && *port == ':')
+		*port++ = '\0';
+	return port;
+}
+
 void *parse_hostcond(char *addr, bool is_port)
 {
 	char *port = NULL;
@@ -2152,17 +2164,16 @@ void *parse_hostcond(char *addr, bool is_port)
 	if (fam == AF_PACKET) {
 		a.addr.family = AF_PACKET;
 		a.addr.bitlen = 0;
-		port = strchr(addr, ':');
+		port = find_port(addr, is_port);
 		if (port) {
-			*port = 0;
-			if (port[1] && strcmp(port+1, "*")) {
-				if (get_integer(&a.port, port+1, 0)) {
-					if ((a.port = xll_name_to_index(port+1)) <= 0)
+			if (*port && strcmp(port, "*")) {
+				if (get_integer(&a.port, port, 0)) {
+					if ((a.port = xll_name_to_index(port)) <= 0)
 						return NULL;
 				}
 			}
 		}
-		if (addr[0] && strcmp(addr, "*")) {
+		if (!is_port && addr[0] && strcmp(addr, "*")) {
 			unsigned short tmp;
 
 			a.addr.bitlen = 32;
@@ -2176,19 +2187,18 @@ void *parse_hostcond(char *addr, bool is_port)
 	if (fam == AF_NETLINK) {
 		a.addr.family = AF_NETLINK;
 		a.addr.bitlen = 0;
-		port = strchr(addr, ':');
+		port = find_port(addr, is_port);
 		if (port) {
-			*port = 0;
-			if (port[1] && strcmp(port+1, "*")) {
-				if (get_integer(&a.port, port+1, 0)) {
-					if (strcmp(port+1, "kernel") == 0)
+			if (*port && strcmp(port, "*")) {
+				if (get_integer(&a.port, port, 0)) {
+					if (strcmp(port, "kernel") == 0)
 						a.port = 0;
 					else
 						return NULL;
 				}
 			}
 		}
-		if (addr[0] && strcmp(addr, "*")) {
+		if (!is_port && addr[0] && strcmp(addr, "*")) {
 			a.addr.bitlen = 32;
 			if (nl_proto_a2n(&a.addr.data[0], addr) == -1)
 				return NULL;
@@ -2201,21 +2211,13 @@ void *parse_hostcond(char *addr, bool is_port)
 
 		a.addr.family = AF_VSOCK;
 
-		if (is_port)
-			port = addr;
-		else {
-			port = strchr(addr, ':');
-			if (port) {
-				*port = '\0';
-				port++;
-			}
-		}
+		port = find_port(addr, is_port);
 
 		if (port && strcmp(port, "*") &&
 		    get_u32((__u32 *)&a.port, port, 0))
 			return NULL;
 
-		if (addr[0] && strcmp(addr, "*")) {
+		if (!is_port && addr[0] && strcmp(addr, "*")) {
 			a.addr.bitlen = 32;
 			if (get_u32(&cid, addr, 0))
 				return NULL;
-- 
2.30.0

