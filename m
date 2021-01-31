Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B92AC309B24
	for <lists+netdev@lfdr.de>; Sun, 31 Jan 2021 09:20:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbhAaITJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jan 2021 03:19:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbhAaISh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jan 2021 03:18:37 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8A6AC061573
        for <netdev@vger.kernel.org>; Sun, 31 Jan 2021 00:17:34 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id z21so9887238pgj.4
        for <netdev@vger.kernel.org>; Sun, 31 Jan 2021 00:17:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SPDcbnCSVv1jOMHvVh1TLx2fPiozRTxew+eQPVMCAw8=;
        b=KFsKbn+pY5OkYJxxWuo41LBquPHX9OrySBOfRT0nLQ7iuvV16QwCo/COwWj/6dAp/u
         YNRN9/nWjMn3wKgWS1tpiZenDH8dPM4/9H6ghqymZveFMYPtH1F4tibxoKg72xyGZcYx
         sIxHxBIIe2S8sR8c78fLkvb3oRStDbfYYJQiU5bbmHYhoy62mo2T9aPMsLdfsVdpA4cM
         XpG+4PAcaBDgE44TAeWYHisDSsmdXLnqGmakvxCv02xT/1gN4fkyMpvpgkOeXlFZqXqV
         y1SFNw+LbGC3oayB70S6AS225wcE6M8tLDeijPdBQM2onYOdEYErObaK0CspYndo4gUg
         yrvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SPDcbnCSVv1jOMHvVh1TLx2fPiozRTxew+eQPVMCAw8=;
        b=qIZZbGM2FJarjLQZ12lHRYeT2JcuoIlXDT1MeC6n/hKJVycZwmtZ5fKL6cyxxa+Bun
         td3ZXqZcdNo65xOrW872uG2n8loG/m06iks04km/lqNBObBFHbwV1jdE8engDoDbPAYz
         cysojBh88/ZoXOfxcbhq1nRnKiD4+GxeWJfkmj2cnAbD+41XhniJ+7GxhcdBpEy8RiKg
         RZ/2nsv948Puburz2N8sU24mAjIOerwLz7NlbfT00TEUBReaAFNIHCvKDdqwBNR3zySh
         Ol9y8UfrgP0MiAp2n/VAj7nCtBpX/mC6gk7DxWSfQV50Gjf+e1v/qosX56IG9maLW/40
         rzUA==
X-Gm-Message-State: AOAM533LT/e96hADZfBLWR08ScRQ3iHNu9WVfi0X2uqsJauyoOxdzT3Y
        PKCnSENBGlvK7ryMZdaADKyGXdByeAgmyA==
X-Google-Smtp-Source: ABdhPJy4VfAcg8pOcE+H5l1HrRMFOGEPatwAidwFhqOEUh8Ce+eapiSFy7ABopr/SChq0E8sIbzbhQ==
X-Received: by 2002:a62:7b90:0:b029:1be:9e89:1db5 with SMTP id w138-20020a627b900000b02901be9e891db5mr10998218pfc.35.1612081053662;
        Sun, 31 Jan 2021 00:17:33 -0800 (PST)
Received: from tardis.. (c-67-182-242-199.hsd1.ut.comcast.net. [67.182.242.199])
        by smtp.gmail.com with ESMTPSA id o21sm11790067pjp.42.2021.01.31.00.17.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Jan 2021 00:17:33 -0800 (PST)
From:   Thayne McCombs <astrothayne@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Thayne McCombs <astrothayne@gmail.com>
Subject: [PATCH iproute2-next] ss: always prefer family as part of host condition to default family
Date:   Sun, 31 Jan 2021 01:17:28 -0700
Message-Id: <20210131081728.29476-1-astrothayne@gmail.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ss accepts an address family both with the -f option and as part of a
host condition. However, if the family in the host condition is
different than the the last -f option, then which family is actually
used depends on the order that different families are checked.

This changes parse_hostcond to check all family prefixes before parsing
the rest of the address, so that the host condition's family always has
a higher priority than the "preferred" family.

Signed-off-by: Thayne McCombs <astrothayne@gmail.com>
---
 misc/ss.c | 50 ++++++++++++++++++++++++--------------------------
 1 file changed, 24 insertions(+), 26 deletions(-)

diff --git a/misc/ss.c b/misc/ss.c
index 0593627b..2a5e056a 100644
--- a/misc/ss.c
+++ b/misc/ss.c
@@ -2119,24 +2119,39 @@ void *parse_hostcond(char *addr, bool is_port)
 	int fam = preferred_family;
 	struct filter *f = &current_filter;
 
-	if (fam == AF_UNIX || strncmp(addr, "unix:", 5) == 0) {
+    if (strncmp(addr, "unix:", 5) == 0) {
+        fam = AF_UNIX;
+        addr += 5;
+    } else if (strncmp(addr, "link:", 5) == 0) {
+        fam = AF_PACKET;
+        addr += 5;
+    } else if (strncmp(addr, "netlink:", 8) == 0) {
+        fam = AF_NETLINK;
+        addr += 8;
+    } else if (strncmp(addr, "vsock:", 6) == 0) {
+        fam = AF_VSOCK;
+        addr += 6;
+    } else if (strncmp(addr, "inet:", 5) == 0) {
+        fam = AF_INET;
+        addr += 5;
+    } else if (strncmp(addr, "inet6:", 6) == 0) {
+        fam = AF_INET6;
+        addr += 6;
+    }
+
+	if (fam == AF_UNIX) {
 		char *p;
 
 		a.addr.family = AF_UNIX;
-		if (strncmp(addr, "unix:", 5) == 0)
-			addr += 5;
 		p = strdup(addr);
 		a.addr.bitlen = 8*strlen(p);
 		memcpy(a.addr.data, &p, sizeof(p));
-		fam = AF_UNIX;
 		goto out;
 	}
 
-	if (fam == AF_PACKET || strncmp(addr, "link:", 5) == 0) {
+	if (fam == AF_PACKET) {
 		a.addr.family = AF_PACKET;
 		a.addr.bitlen = 0;
-		if (strncmp(addr, "link:", 5) == 0)
-			addr += 5;
 		port = strchr(addr, ':');
 		if (port) {
 			*port = 0;
@@ -2155,15 +2170,12 @@ void *parse_hostcond(char *addr, bool is_port)
 				return NULL;
 			a.addr.data[0] = ntohs(tmp);
 		}
-		fam = AF_PACKET;
 		goto out;
 	}
 
-	if (fam == AF_NETLINK || strncmp(addr, "netlink:", 8) == 0) {
+	if (fam == AF_NETLINK) {
 		a.addr.family = AF_NETLINK;
 		a.addr.bitlen = 0;
-		if (strncmp(addr, "netlink:", 8) == 0)
-			addr += 8;
 		port = strchr(addr, ':');
 		if (port) {
 			*port = 0;
@@ -2181,16 +2193,13 @@ void *parse_hostcond(char *addr, bool is_port)
 			if (nl_proto_a2n(&a.addr.data[0], addr) == -1)
 				return NULL;
 		}
-		fam = AF_NETLINK;
 		goto out;
 	}
 
-	if (fam == AF_VSOCK || strncmp(addr, "vsock:", 6) == 0) {
+	if (fam == AF_VSOCK) {
 		__u32 cid = ~(__u32)0;
 
 		a.addr.family = AF_VSOCK;
-		if (strncmp(addr, "vsock:", 6) == 0)
-			addr += 6;
 
 		if (is_port)
 			port = addr;
@@ -2212,20 +2221,9 @@ void *parse_hostcond(char *addr, bool is_port)
 				return NULL;
 		}
 		vsock_set_inet_prefix(&a.addr, cid);
-		fam = AF_VSOCK;
 		goto out;
 	}
 
-	if (fam == AF_INET || !strncmp(addr, "inet:", 5)) {
-		fam = AF_INET;
-		if (!strncmp(addr, "inet:", 5))
-			addr += 5;
-	} else if (fam == AF_INET6 || !strncmp(addr, "inet6:", 6)) {
-		fam = AF_INET6;
-		if (!strncmp(addr, "inet6:", 6))
-			addr += 6;
-	}
-
 	/* URL-like literal [] */
 	if (addr[0] == '[') {
 		addr++;
-- 
2.30.0

