Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDE6F2BB9A
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 23:04:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726839AbfE0VEP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 17:04:15 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:37622 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726346AbfE0VEO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 May 2019 17:04:14 -0400
Received: by mail-lj1-f195.google.com with SMTP id h19so7316308ljj.4
        for <netdev@vger.kernel.org>; Mon, 27 May 2019 14:04:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=RUXHZKYk5A7u3aeY63C0CmccTMg4cGkXdeY7tvMdnpI=;
        b=cqAkCudFdpoWmWGUcinDJKt0dHoCRbufbBWDXpIiKK7YI4L4t/fIskoJbb1Cbe4uAl
         gZILWaxtLMSbo4j04I7n6Ng9JuQocrfdMSllBeVye0yOvbJ/laoIrGhyK0P4uneA5GZO
         uNzkGyGzTcZlqFXZmHiPCuT7q7+VhK/O8aiA79K1vWpv4NQN89GLWCUG5o5/M4+WDQ65
         0zRw3WbeLsMsrPXgGMTHKe3P/IAQWLutn68eZuqutzHS+uGXLbetXcMXAAYV1b3LHlgU
         bnyqZ9b2fDwKNSbNnjfhleRVi26aPFFPi4NJUPYTLaLrkiihiP5Ly7bm79roLipieEsQ
         g0Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=RUXHZKYk5A7u3aeY63C0CmccTMg4cGkXdeY7tvMdnpI=;
        b=gw9PF3o8Pr7Z/uZv4S8enIKPWBhhjSufH+13aTE3smeF/568jaTdArOssk+D621y+m
         /p6Lh3Zn4sZP3MVUXQeFkm/fnuCulL620s58cFkqkdxPOGZ+PEUhLkH8gIIMevG/5gXL
         aABQmhIYRPnrwpyeuhs+Q7Iw9Om3JaOe+RrQLnkg9UVww+T3MrK/UOfFxC20AWiBOgcg
         ftp3NWK2a78BQNlAWq2GOlFoBSliJ+lUgZaoZ/ZJzF6UJDDCZX+1Dn9USzvJTgsSN3LG
         zVlzZhC0VVhL87mgSDRRnkpm2Wo/7kp7dXvpxZ7ntSAA20xvJZMVRDfqQZmDZjBBNA1f
         oLTA==
X-Gm-Message-State: APjAAAUh2QrqeywV3WwkKBezWPUPWF6/y84f2upWSAqkeKQLp6R5Ekp3
        pCOgzxpKTZ8txf9Si10YC3u65Basbes=
X-Google-Smtp-Source: APXvYqwzIDX8NM16rtiYpmUIUA4bDTDsBdNjBknIKdEB5EN6E/L/jWxj2BfQ8eM5q4ThvX2e4dr+Dw==
X-Received: by 2002:a2e:a0d1:: with SMTP id f17mr25179185ljm.117.1558991052886;
        Mon, 27 May 2019 14:04:12 -0700 (PDT)
Received: from localhost.localdomain.pl (178235190197.unknown.vectranet.pl. [178.235.190.197])
        by smtp.googlemail.com with ESMTPSA id n26sm2888444lfi.90.2019.05.27.14.04.11
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 27 May 2019 14:04:12 -0700 (PDT)
From:   Lukasz Czapnik <lukasz.czapnik@gmail.com>
To:     netdev@vger.kernel.org, stephen@networkplumber.org
Cc:     Lukasz Czapnik <lukasz.czapnik@gmail.com>,
        Lukasz Czapnik <lukasz.czapnik@intel.com>
Subject: [PATCH] tc: flower: fix port value truncation
Date:   Mon, 27 May 2019 23:03:49 +0200
Message-Id: <20190527210349.31833-1-lukasz.czapnik@gmail.com>
X-Mailer: git-send-email 2.17.2
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sscanf truncates read port values silently without any error. As sscanf
man says:
(...) sscanf() conform to C89 and C99 and POSIX.1-2001. These standards
do not specify the ERANGE error.

Replace sscanf with safer get_be16 that returns error when value is out
of range.

Example:
tc filter add dev eth0 protocol ip parent ffff: prio 1 flower ip_proto
tcp dst_port 70000 hw_tc 1

Would result in filter for port 4464 without any warning.

Fixes: 8930840e678b ("tc: flower: Classify packets based port ranges")
Signed-off-by: Lukasz Czapnik <lukasz.czapnik@intel.com>
---
 tc/f_flower.c | 48 ++++++++++++++++++++++++++++++++++++------------
 1 file changed, 36 insertions(+), 12 deletions(-)

diff --git a/tc/f_flower.c b/tc/f_flower.c
index 9659e894..e2420d92 100644
--- a/tc/f_flower.c
+++ b/tc/f_flower.c
@@ -493,23 +493,40 @@ static int flower_port_range_attr_type(__u8 ip_proto, enum flower_endpoint type,
 	return 0;
 }
 
+/* parse range args in format 10-20 */
+static int parse_range(char *str, __be16 *min, __be16 *max)
+{
+	char *sep;
+
+	sep = strchr(str, '-');
+	if (sep) {
+		*sep = '\0';
+
+		if (get_be16(min, str, 10))
+			return -1;
+
+		if (get_be16(max, sep + 1, 10))
+			return -1;
+	} else {
+		if (get_be16(min, str, 10))
+			return -1;
+	}
+	return 0;
+}
+
 static int flower_parse_port(char *str, __u8 ip_proto,
 			     enum flower_endpoint endpoint,
 			     struct nlmsghdr *n)
 {
-	__u16 min, max;
+	__be16 min = 0;
+	__be16 max = 0;
 	int ret;
 
-	ret = sscanf(str, "%hu-%hu", &min, &max);
-
-	if (ret == 1) {
-		int type;
+	ret = parse_range(str, &min, &max);
+	if (ret)
+		return -1;
 
-		type = flower_port_attr_type(ip_proto, endpoint);
-		if (type < 0)
-			return -1;
-		addattr16(n, MAX_MSG, type, htons(min));
-	} else if (ret == 2) {
+	if (min && max) {
 		__be16 min_port_type, max_port_type;
 
 		if (max <= min) {
@@ -520,8 +537,15 @@ static int flower_parse_port(char *str, __u8 ip_proto,
 						&min_port_type, &max_port_type))
 			return -1;
 
-		addattr16(n, MAX_MSG, min_port_type, htons(min));
-		addattr16(n, MAX_MSG, max_port_type, htons(max));
+		addattr16(n, MAX_MSG, min_port_type, min);
+		addattr16(n, MAX_MSG, max_port_type, max);
+	} else if (min && !max) {
+		int type;
+
+		type = flower_port_attr_type(ip_proto, endpoint);
+		if (type < 0)
+			return -1;
+		addattr16(n, MAX_MSG, type, min);
 	} else {
 		return -1;
 	}
-- 
2.17.2

