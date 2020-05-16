Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A3141D5D62
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 02:52:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726703AbgEPAwI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 20:52:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726198AbgEPAwH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 20:52:07 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8120AC061A0C
        for <netdev@vger.kernel.org>; Fri, 15 May 2020 17:52:06 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id j5so5465533wrq.2
        for <netdev@vger.kernel.org>; Fri, 15 May 2020 17:52:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qA+WHYCU54bvLLG7BvkbnqEr4Px6lZXqkbzW5AppLx8=;
        b=0e0+WkzuaS3aJza9rILUv7Gk8vwf4kyrb3+XfVw2NaAuDYxuBfcBGQeQ5gaLzLCuYo
         iNpWMhjNaSi1AX9D//OYsphjhC1VqL91AIFixmAbvIbIe4MDqvbXvbsE9VRxD/oO7oL4
         qUOpeoLfHePO3YMzdzGKJDXl937Nh37DXRj2EC+dzprKR8p2KFH1PuVKHZvVtOPeNBqR
         9vxgsI+srv9wJ0uoyz4bBir97CTy7HJ7XS8YrKrnsPgrFaVZCHZh+RpDBnAt0yIpsx3X
         Kc5S7eCm3pAtmlzb435kChmRvbAhao2p5mozWWo72FCJ0O6PMEuFKf4fnFqsnHFYmuJD
         vSRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qA+WHYCU54bvLLG7BvkbnqEr4Px6lZXqkbzW5AppLx8=;
        b=jjaZY5gQtpuI6MLhyDxVqSis2ScP3+5IF3GIG1k+TSmZX2yKEHvMnb373MJCCzNeAR
         DfS5eJrRxINANn8g7bjSyYzzdo1kxjyylOWxt7UaD7vctNRx0LrhGQ59VrYlFLZ7SLVv
         16HopioqUFtYwJjFsdHpXyuJYSdZvWeZlZcU9M1zhrXQ7Pw+zR6JjJCXhT3YBT7A5p6q
         QSaZNH2TDwJrjYgdFzSrSl42dw/7ZOtY3Efcat/c7nW5eN8cACTkFyBuLaorbb4+jTRm
         EJ7XucfqkFFIweq/oU2fdxBF7V6s7wxsCgvIQKVIYMnr/SuwxNqFFv2QC4qblQSdLOTJ
         EKcQ==
X-Gm-Message-State: AOAM532HbfKb2Y7sWwbVhmKfOz8gA7qI4/eS7QPwQFiPOCqHZV+xsiNM
        /Vr37v/jZUTAg2WEOxg+7H4Cdg==
X-Google-Smtp-Source: ABdhPJzgvgUUcMTjYoVAqw8BNwYlfoOz2zTRUuYbqa8BtJpEy0rWOxOM9XNk44k5+NqfPEE/Wp5Z/A==
X-Received: by 2002:adf:f041:: with SMTP id t1mr7070651wro.346.1589590325129;
        Fri, 15 May 2020 17:52:05 -0700 (PDT)
Received: from localhost.localdomain ([194.53.185.110])
        by smtp.gmail.com with ESMTPSA id q74sm6141256wme.14.2020.05.15.17.52.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2020 17:52:04 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next] tools: bpftool: make capability check account for new BPF caps
Date:   Sat, 16 May 2020 01:51:49 +0100
Message-Id: <20200516005149.3841-1-quentin@isovalent.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Following the introduction of CAP_BPF, and the switch from CAP_SYS_ADMIN
to other capabilities for various BPF features, update the capability
checks (and potentially, drops) in bpftool for feature probes. Because
bpftool and/or the system might not know of CAP_BPF yet, some caution is
necessary:

- If compiled and run on a system with CAP_BPF, check CAP_BPF,
  CAP_SYS_ADMIN, CAP_PERFMON, CAP_NET_ADMIN.

- Guard against CAP_BPF being undefined, to allow compiling bpftool from
  latest sources on older systems. If the system where feature probes
  are run does not know of CAP_BPF, stop checking after CAP_SYS_ADMIN,
  as this should be the only capability required for all the BPF
  probing.

- If compiled from latest sources on a system without CAP_BPF, but later
  executed on a newer system with CAP_BPF knowledge, then we only test
  CAP_SYS_ADMIN. Some probes may fail if the bpftool process has
  CAP_SYS_ADMIN but misses the other capabilities. The alternative would
  be to redefine the value for CAP_BPF in bpftool, but this does not
  look clean, and the case sounds relatively rare anyway.

Note that libcap offers a cap_to_name() function to retrieve the name of
a given capability (e.g. "cap_sys_admin"). We do not use it because
deriving the names from the macros looks simpler than using
cap_to_name() (doing a strdup() on the string) + cap_free() + handling
the case of failed allocations, when we just want to use the name of the
capability in an error message.

The checks when compiling without libcap (i.e. root versus non-root) are
unchanged.

Signed-off-by: Quentin Monnet <quentin@isovalent.com>
---
 tools/bpf/bpftool/feature.c | 85 +++++++++++++++++++++++++++++--------
 1 file changed, 67 insertions(+), 18 deletions(-)

diff --git a/tools/bpf/bpftool/feature.c b/tools/bpf/bpftool/feature.c
index 1b73e63274b5..3c3d779986c7 100644
--- a/tools/bpf/bpftool/feature.c
+++ b/tools/bpf/bpftool/feature.c
@@ -758,12 +758,32 @@ static void section_misc(const char *define_prefix, __u32 ifindex)
 	print_end_section();
 }
 
+#ifdef USE_LIBCAP
+#define capability(c) { c, #c }
+#endif
+
 static int handle_perms(void)
 {
 #ifdef USE_LIBCAP
-	cap_value_t cap_list[1] = { CAP_SYS_ADMIN };
-	bool has_sys_admin_cap = false;
+	struct {
+		cap_value_t cap;
+		char name[14];	/* strlen("CAP_SYS_ADMIN") */
+	} required_caps[] = {
+		capability(CAP_SYS_ADMIN),
+#ifdef CAP_BPF
+		/* Leave CAP_BPF in second position here: We will stop checking
+		 * if the system does not know about it, since it probably just
+		 * needs CAP_SYS_ADMIN to run all the probes in that case.
+		 */
+		capability(CAP_BPF),
+		capability(CAP_NET_ADMIN),
+		capability(CAP_PERFMON),
+#endif
+	};
+	bool has_admin_caps = true;
+	cap_value_t *cap_list;
 	cap_flag_value_t val;
+	unsigned int i;
 	int res = -1;
 	cap_t caps;
 
@@ -774,41 +794,70 @@ static int handle_perms(void)
 		return -1;
 	}
 
-	if (cap_get_flag(caps, CAP_SYS_ADMIN, CAP_EFFECTIVE, &val)) {
-		p_err("bug: failed to retrieve CAP_SYS_ADMIN status");
+	cap_list = malloc(sizeof(cap_value_t) * ARRAY_SIZE(required_caps));
+	if (!cap_list) {
+		p_err("failed to allocate cap_list: %s", strerror(errno));
 		goto exit_free;
 	}
-	if (val == CAP_SET)
-		has_sys_admin_cap = true;
 
-	if (!run_as_unprivileged && !has_sys_admin_cap) {
-		p_err("full feature probing requires CAP_SYS_ADMIN, run as root or use 'unprivileged'");
-		goto exit_free;
+	for (i = 0; i < ARRAY_SIZE(required_caps); i++) {
+		const char *cap_name = required_caps[i].name;
+		cap_value_t cap = required_caps[i].cap;
+
+#ifdef CAP_BPF
+		if (cap == CAP_BPF && !CAP_IS_SUPPORTED(cap))
+			/* System does not know about CAP_BPF, meaning
+			 * that CAP_SYS_ADMIN is the only capability
+			 * required. We already checked it, break.
+			 */
+			break;
+#endif
+
+		if (cap_get_flag(caps, cap, CAP_EFFECTIVE, &val)) {
+			p_err("bug: failed to retrieve %s status: %s", cap_name,
+			      strerror(errno));
+			goto exit_free;
+		}
+
+		if (val != CAP_SET) {
+			if (!run_as_unprivileged) {
+				p_err("missing %s, required for full feature probing; run as root or use 'unprivileged'",
+				      cap_name);
+				goto exit_free;
+			}
+			has_admin_caps = false;
+			break;
+		}
+		cap_list[i] = cap;
 	}
 
-	if ((run_as_unprivileged && !has_sys_admin_cap) ||
-	    (!run_as_unprivileged && has_sys_admin_cap)) {
+	if ((run_as_unprivileged && !has_admin_caps) ||
+	    (!run_as_unprivileged && has_admin_caps)) {
 		/* We are all good, exit now */
 		res = 0;
 		goto exit_free;
 	}
 
-	/* if (run_as_unprivileged && has_sys_admin_cap), drop CAP_SYS_ADMIN */
+	/* if (run_as_unprivileged && has_admin_caps), drop capabilities.
+	 * cap_set_flag() returns no error when trying to dump capabilities we
+	 * do not have, so simply attempt to drop the whole list we have.
+	 */
 
-	if (cap_set_flag(caps, CAP_EFFECTIVE, ARRAY_SIZE(cap_list), cap_list,
-			 CAP_CLEAR)) {
-		p_err("bug: failed to clear CAP_SYS_ADMIN from capabilities");
+	if (cap_set_flag(caps, CAP_EFFECTIVE, ARRAY_SIZE(required_caps),
+			 cap_list, CAP_CLEAR)) {
+		p_err("bug: failed to clear capabilities: %s", strerror(errno));
 		goto exit_free;
 	}
 
 	if (cap_set_proc(caps)) {
-		p_err("failed to drop CAP_SYS_ADMIN: %s", strerror(errno));
+		p_err("failed to drop capabilities: %s", strerror(errno));
 		goto exit_free;
 	}
 
 	res = 0;
 
 exit_free:
+	free(cap_list);
 	if (cap_free(caps) && !res) {
 		p_err("failed to clear storage object for capabilities: %s",
 		      strerror(errno));
@@ -817,7 +866,7 @@ static int handle_perms(void)
 
 	return res;
 #else
-	/* Detection assumes user has sufficient privileges (CAP_SYS_ADMIN).
+	/* Detection assumes user has specific privileges.
 	 * We do not use libpcap so let's approximate, and restrict usage to
 	 * root user only.
 	 */
@@ -901,7 +950,7 @@ static int do_probe(int argc, char **argv)
 		}
 	}
 
-	/* Full feature detection requires CAP_SYS_ADMIN privilege.
+	/* Full feature detection requires specific privileges.
 	 * Let's approximate, and warn if user is not root.
 	 */
 	if (handle_perms())
-- 
2.20.1

