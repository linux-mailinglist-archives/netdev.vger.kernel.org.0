Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 961771B6045
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 18:05:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729483AbgDWQFE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 12:05:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729407AbgDWQFD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 12:05:03 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AFA4C09B041
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 09:05:03 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id x25so7002954wmc.0
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 09:05:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bV275IP5Jw11a9pF8qMDVB9WoaXSE2YATQ9Er+FF2MY=;
        b=jsUTH8mn57tPjBpXgvDqV6OV3UXX6u9YNlV/5dOnkhD6/dG5/dn5CgXTLNuiiQ3Ze2
         dFRcDfa5VjKJmNjwk7RTQWsQJQkCFLevfEwuLphuhwLWzCVD6xHdLqzMNYKDhEGkPfQr
         SL32TkpPcxPSOQDJ27pNAxfmwuZdaBa51dKxr4QAoNzQLbj9XOBVVn2yTjHYexp0gtmn
         ggAjVJvt7ldIZ4eflqt39Xa8IHVAsC5tBMsc7qR/bD9DHBfwS2qodf0N04xc2fIomaGI
         syn6QZmUDExLkvTwLs7oMaNLKvP4HhSClJpJL07QZ6zH6Jgwp+RQ9u/iqzqIuf4f0/L5
         n01A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bV275IP5Jw11a9pF8qMDVB9WoaXSE2YATQ9Er+FF2MY=;
        b=Q0wOqrVeKR64RLqjz9BZaCSCib0If5ZA+VjpBM1r1pFuJDznO97OgzAr77MOqL1CT/
         MKRI/aprWnT2fdcv7haf/jgut+C8Y9Z1eH+aldu2WdIV3p8dW6bJD0yW1tMM6lgxHisg
         VWJA9vyQ5iWbEwcI92ArnpIgG2AhPtUzX4tKmXP/jSvFP8hSBmUmubSWwKTxWZvwEqJm
         CV8bxZ9a1SZqOerQpnVQ2DBt2IFBGwULD+q6mbwf/ObssOYPai8mb/t3tR9mywI4trf4
         xbwX0ciMd+loZmfgkvLlgOvaEtSSS5sSiJb0QcBbnjJbb1lRwLsSXOLA97JuQ11hKy4a
         DENw==
X-Gm-Message-State: AGi0PuYomeRgbrl86dDBE/8rJQJvkEWrlcv7kS8mW1gOdpCZmu3Xgc40
        6v6MD957zP0bt4qzru/hkYYtyg==
X-Google-Smtp-Source: APiQypKK/OFyVOwNcRBsOqWFkAQcX1ArugtVuAR3/fkNREdoc6HTu4JiB7sqV90IHXrhoCjicvr70g==
X-Received: by 2002:a1c:1d84:: with SMTP id d126mr4829451wmd.119.1587657901855;
        Thu, 23 Apr 2020 09:05:01 -0700 (PDT)
Received: from localhost.localdomain ([194.53.185.104])
        by smtp.gmail.com with ESMTPSA id x13sm4544259wmc.5.2020.04.23.09.05.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2020 09:05:01 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>,
        Richard Palethorpe <rpalethorpe@suse.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: [PATCH bpf-next] tools: bpftool: allow unprivileged users to probe features
Date:   Thu, 23 Apr 2020 17:04:55 +0100
Message-Id: <20200423160455.28509-1-quentin@isovalent.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is demand for a way to identify what BPF helper functions are
available to unprivileged users. To do so, allow unprivileged users to
run "bpftool feature probe" to list BPF-related features. This will only
show features accessible to those users, and may not reflect the full
list of features available (to administrators) on the system. For
non-JSON output, print an informational message stating so at the top of
the list.

Note that there is no particular reason why the probes were restricted
to root, other than the fact I did not need them for unprivileged and
did not bother with the additional checks at the time probes were added.

Cc: Richard Palethorpe <rpalethorpe@suse.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Signed-off-by: Quentin Monnet <quentin@isovalent.com>
---
 .../bpftool/Documentation/bpftool-feature.rst |  4 +++
 tools/bpf/bpftool/feature.c                   | 32 +++++++++++++------
 2 files changed, 26 insertions(+), 10 deletions(-)

diff --git a/tools/bpf/bpftool/Documentation/bpftool-feature.rst b/tools/bpf/bpftool/Documentation/bpftool-feature.rst
index b04156cfd7a3..313888e87249 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-feature.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-feature.rst
@@ -49,6 +49,10 @@ DESCRIPTION
 		  Keyword **kernel** can be omitted. If no probe target is
 		  specified, probing the kernel is the default behaviour.
 
+		  Running this command as an unprivileged user will dump only
+		  the features available to the user, which usually represent a
+		  small subset of the parameters supported by the system.
+
 	**bpftool feature probe dev** *NAME* [**full**] [**macros** [**prefix** *PREFIX*]]
 		  Probe network device for supported eBPF features and dump
 		  results to the console.
diff --git a/tools/bpf/bpftool/feature.c b/tools/bpf/bpftool/feature.c
index 88718ee6a438..f455bc5fcc64 100644
--- a/tools/bpf/bpftool/feature.c
+++ b/tools/bpf/bpftool/feature.c
@@ -471,6 +471,11 @@ probe_prog_type(enum bpf_prog_type prog_type, bool *supported_types,
 		}
 
 	res = bpf_probe_prog_type(prog_type, ifindex);
+	/* Probe may succeed even if program load fails, for unprivileged users
+	 * check that we did not fail because of insufficient permissions
+	 */
+	if (geteuid() && errno == EPERM)
+		res = false;
 
 	supported_types[prog_type] |= res;
 
@@ -499,6 +504,10 @@ probe_map_type(enum bpf_map_type map_type, const char *define_prefix,
 
 	res = bpf_probe_map_type(map_type, ifindex);
 
+	/* Probe result depends on the success of map creation, no additional
+	 * check required for unprivileged users
+	 */
+
 	maxlen = sizeof(plain_desc) - strlen(plain_comment) - 1;
 	if (strlen(map_type_name[map_type]) > maxlen) {
 		p_info("map type name too long");
@@ -518,12 +527,17 @@ probe_helper_for_progtype(enum bpf_prog_type prog_type, bool supported_type,
 			  const char *define_prefix, unsigned int id,
 			  const char *ptype_name, __u32 ifindex)
 {
-	bool res;
+	bool res = false;
 
-	if (!supported_type)
-		res = false;
-	else
+	if (supported_type) {
 		res = bpf_probe_helper(id, prog_type, ifindex);
+		/* Probe may succeed even if program load fails, for
+		 * unprivileged users check that we did not fail because of
+		 * insufficient permissions
+		 */
+		if (geteuid() && errno == EPERM)
+			res = false;
+	}
 
 	if (json_output) {
 		if (res)
@@ -729,13 +743,11 @@ static int do_probe(int argc, char **argv)
 	__u32 ifindex = 0;
 	char *ifname;
 
-	/* Detection assumes user has sufficient privileges (CAP_SYS_ADMIN).
-	 * Let's approximate, and restrict usage to root user only.
+	/* Full feature detection requires CAP_SYS_ADMIN privilege.
+	 * Let's approximate, and warn if user is not root.
 	 */
-	if (geteuid()) {
-		p_err("please run this command as root user");
-		return -1;
-	}
+	if (geteuid())
+		p_info("probing as unprivileged user, run as root to see all system features");
 
 	set_max_rlimit();
 
-- 
2.20.1

