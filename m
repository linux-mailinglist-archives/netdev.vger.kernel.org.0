Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA343634F5
	for <lists+netdev@lfdr.de>; Sun, 18 Apr 2021 14:03:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231434AbhDRMDh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Apr 2021 08:03:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230441AbhDRMDe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Apr 2021 08:03:34 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D59CC06174A
        for <netdev@vger.kernel.org>; Sun, 18 Apr 2021 05:03:05 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id g9so15080682wrx.0
        for <netdev@vger.kernel.org>; Sun, 18 Apr 2021 05:03:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=w5EWL9x9pFyov9bRXc5AqdXBp6bk93RVasdGvAZevwI=;
        b=sDUI78YjY9rEY3DnQ3zzY0SzukrzlRgs7/5e5vPQW859PwmrcLqkWO95AWLI9r69vz
         VQu5NCA6KGoZoqxarK2LN9BoQjzEdWIdaMtMiGE28NTaMsciuwpRHjnbXhRpObhWcimL
         YMjI8YgRmbGcHwYmSsEdJ8dnQS4Fic+UAxKo0FU0o8cs9HObtaR681JJ7wVIo7aEMVQL
         VzotO1WTVnGcJMd/VdbE0gZMiyJaNvLrZLeiXp+rD2QE6vt7IfOLDMRVkYwYS1bqPFhf
         yyBcsaD7tWoDyCfv7+ORW3y5tL0nBWWxDqW1MtjmapquSnr+MwmdtdknYVXOUVbiodvp
         mrPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=w5EWL9x9pFyov9bRXc5AqdXBp6bk93RVasdGvAZevwI=;
        b=Yzpr3W3EdBzwnP1BHgevKn9/C2n7+jyGdeqYNysqB6eyQ9o0a154RBu1gNVpBs/QIl
         xN9BM+KrTAc3iwJXH8fHmp/YGcp9P39xrAyoTjIKFvXq3g6yFATqUkiDsfskjwOjRe7O
         U0XC8MoYozLjUDrix4uoANXvgcG17eMwWmcuXbak1cTwCHyZnq1dEmrluGQXiG11E5KF
         B6Oxp/xF/TgqN8uxFXj8fK7WLVterCWujjS8BIYm6IP2GJhG8NhecyFIcNoBc4YM7dIU
         2EBbVrY/Y3GUzykL301XEbrh6Yndcf0tR8E9XcsrVIqrV4L7f3RWFJGRMmufi/VHLv8R
         H8CA==
X-Gm-Message-State: AOAM5301HoNrvPLN8EPFNl9zfldyeoPzpHB5Kq2meZrYewmX+N3MvUr5
        unnR77nL2v2/7WSGfamP8noUeteoBfC5C+bB
X-Google-Smtp-Source: ABdhPJx+rGdfJmCEWeCd0ifaWJntDJ2X/nvPcmQhFopV8+C13mbL/2Qkd/6zuiwzx+xO/fORJ3i0kQ==
X-Received: by 2002:a5d:6881:: with SMTP id h1mr9061103wru.121.1618747384019;
        Sun, 18 Apr 2021 05:03:04 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id x25sm16584763wmj.34.2021.04.18.05.03.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Apr 2021 05:03:03 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, dsahern@gmail.com,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH iproute2-next 2/6] bridge: add parse_stp_state helper
Date:   Sun, 18 Apr 2021 15:01:33 +0300
Message-Id: <20210418120137.2605522-3-razor@blackwall.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210418120137.2605522-1-razor@blackwall.org>
References: <20210418120137.2605522-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Add a helper which parses an STP state string to its numeric value.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 bridge/br_common.h |  1 +
 bridge/link.c      | 22 +++++++++++++++++-----
 2 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/bridge/br_common.h b/bridge/br_common.h
index e3f46765ab89..33e56452702b 100644
--- a/bridge/br_common.h
+++ b/bridge/br_common.h
@@ -11,6 +11,7 @@ int print_linkinfo(struct nlmsghdr *n, void *arg);
 int print_mdb_mon(struct nlmsghdr *n, void *arg);
 int print_fdb(struct nlmsghdr *n, void *arg);
 void print_stp_state(__u8 state);
+int parse_stp_state(const char *arg);
 
 int do_fdb(int argc, char **argv);
 int do_mdb(int argc, char **argv);
diff --git a/bridge/link.c b/bridge/link.c
index a8cfa1814986..205a2fe79c1a 100644
--- a/bridge/link.c
+++ b/bridge/link.c
@@ -78,6 +78,21 @@ void print_stp_state(__u8 state)
 			     "state (%d) ", state);
 }
 
+int parse_stp_state(const char *arg)
+{
+	size_t nstates = ARRAY_SIZE(stp_states);
+	int state;
+
+	for (state = 0; state < nstates; state++)
+		if (strcmp(stp_states[state], arg) == 0)
+			break;
+
+	if (state == nstates)
+		state = -1;
+
+	return state;
+}
+
 static void print_hwmode(__u16 mode)
 {
 	if (mode >= ARRAY_SIZE(hw_mode))
@@ -359,14 +374,11 @@ static int brlink_modify(int argc, char **argv)
 		} else if (strcmp(*argv, "state") == 0) {
 			NEXT_ARG();
 			char *endptr;
-			size_t nstates = ARRAY_SIZE(stp_states);
 
 			state = strtol(*argv, &endptr, 10);
 			if (!(**argv != '\0' && *endptr == '\0')) {
-				for (state = 0; state < nstates; state++)
-					if (strcasecmp(stp_states[state], *argv) == 0)
-						break;
-				if (state == nstates) {
+				state = parse_stp_state(*argv);
+				if (state == -1) {
 					fprintf(stderr,
 						"Error: invalid STP port state\n");
 					return -1;
-- 
2.30.2

