Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E937B1DF3B1
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 03:02:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387477AbgEWBCy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 21:02:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731233AbgEWBCx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 21:02:53 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A85ACC061A0E
        for <netdev@vger.kernel.org>; Fri, 22 May 2020 18:02:51 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id i15so11951166wrx.10
        for <netdev@vger.kernel.org>; Fri, 22 May 2020 18:02:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UA9qNsuSqBuwEW9X2q53MDSN/CA+BUtr5zDrNyDcPlg=;
        b=fN6ekS+SlPlpBuANldX3LQofzetiK2tkYG5OKa45+e7LPEepION2QeEyntKELhOVwj
         TH69OIeLhkSQbgK1vwTP8FycqJt6LWtrGZ2WXWN8uvR9CnZx+l4E1QTp/jUIM/1mkMyB
         JqjkhQYPeRgfOvSe+mMYH9DR8pbR/nvGzxYe37rcLaTm6DgmDaxTiAl4VdxqC0IIocnq
         RsGYEt001I/i0mpXryxDa73QWwXijKaoajbZ77iRGmtgk2B7kM59bAjca+JR0diSQfpU
         GPkVpt7D2BtVGeDQAhPvpMFPG1lX61gucbe0iR9xVyH17EcX+TgRJj4x1onBoedFXO05
         uFqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UA9qNsuSqBuwEW9X2q53MDSN/CA+BUtr5zDrNyDcPlg=;
        b=NHdYo3KVI1ykaAIy381aC1jWC3Mj7IUjH+5uKtarxfCjM4xn5/srNPgTo4EaXbP03c
         cdi9o8YbqWoYzIduhPsfZDNOSfWQ7Ag/6aK4dXd9rLtMgcKc5STphmzZrLSCsAud6WkX
         VvO4DHXueDvUvsj+yk2hqkBaOIsypD9truG9eRtub5OHtSXenDWqRPUiTGyhMG4nmFg/
         HtkMzRWRv3PsVfxTraINCzxX70AFkCV7SDAZN94rM52h0KF4EnkIZIOYnQ5g5t74dxb9
         oZde59q3JFSf9eliETMmQV4/asYxQEDqaY0k7JY37DiBCcXfFzbcTgPQbjPWoZWv6ZUc
         FG/g==
X-Gm-Message-State: AOAM531DsOFsY71u0C6RuJW9+Q6bTb3bfMxBbibWgK6fJIrBBp5qRpW0
        srYmHMFsXoafmWOexSUin/1FzA==
X-Google-Smtp-Source: ABdhPJw5pgW9Cyi/1DCHRA/WqhgnHR9OmPZM0hkiKfxZ3ld1iSDPFx6bLVvmqvQs1HmSzAw2iaOE8g==
X-Received: by 2002:adf:f5c1:: with SMTP id k1mr5288953wrp.30.1590195770374;
        Fri, 22 May 2020 18:02:50 -0700 (PDT)
Received: from localhost.localdomain ([194.53.184.60])
        by smtp.gmail.com with ESMTPSA id s8sm8114158wrg.50.2020.05.22.18.02.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2020 18:02:49 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next v2] tools: bpftool: make capability check account for new BPF caps
Date:   Sat, 23 May 2020 02:02:47 +0100
Message-Id: <20200523010247.20654-1-quentin@isovalent.com>
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

v2:
- Do not allocate cap_list dynamically.
- Drop BPF-related capabilities when running with "unprivileged", even
  if we didn't have the full set in the first place (in v1, we would
  skip dropping them in that case).
- Keep track of what capabilities we have, print the names of the
  missing ones for privileged probing.
- Attempt to drop only the capabilities we actually have.
- Rename a couple variables.

Signed-off-by: Quentin Monnet <quentin@isovalent.com>
---
 tools/bpf/bpftool/feature.c | 85 ++++++++++++++++++++++++++++---------
 1 file changed, 66 insertions(+), 19 deletions(-)

diff --git a/tools/bpf/bpftool/feature.c b/tools/bpf/bpftool/feature.c
index 1b73e63274b5..0e60d9e30beb 100644
--- a/tools/bpf/bpftool/feature.c
+++ b/tools/bpf/bpftool/feature.c
@@ -758,11 +758,29 @@ static void section_misc(const char *define_prefix, __u32 ifindex)
 	print_end_section();
 }
 
+#ifdef USE_LIBCAP
+#define capability(c) { c, false, #c }
+#define capability_msg(a, i) a[i].set ? "" : a[i].name, a[i].set ? "" : ", "
+#endif
+
 static int handle_perms(void)
 {
 #ifdef USE_LIBCAP
-	cap_value_t cap_list[1] = { CAP_SYS_ADMIN };
-	bool has_sys_admin_cap = false;
+	struct {
+		cap_value_t cap;
+		bool set;
+		char name[14];	/* strlen("CAP_SYS_ADMIN") */
+	} bpf_caps[] = {
+		capability(CAP_SYS_ADMIN),
+#ifdef CAP_BPF
+		capability(CAP_BPF),
+		capability(CAP_NET_ADMIN),
+		capability(CAP_PERFMON),
+#endif
+	};
+	cap_value_t cap_list[ARRAY_SIZE(bpf_caps)];
+	unsigned int i, nb_bpf_caps = 0;
+	bool cap_sys_admin_only = true;
 	cap_flag_value_t val;
 	int res = -1;
 	cap_t caps;
@@ -774,35 +792,64 @@ static int handle_perms(void)
 		return -1;
 	}
 
-	if (cap_get_flag(caps, CAP_SYS_ADMIN, CAP_EFFECTIVE, &val)) {
-		p_err("bug: failed to retrieve CAP_SYS_ADMIN status");
-		goto exit_free;
-	}
-	if (val == CAP_SET)
-		has_sys_admin_cap = true;
+#ifdef CAP_BPF
+	if (CAP_IS_SUPPORTED(CAP_BPF))
+		cap_sys_admin_only = false;
+#endif
 
-	if (!run_as_unprivileged && !has_sys_admin_cap) {
-		p_err("full feature probing requires CAP_SYS_ADMIN, run as root or use 'unprivileged'");
-		goto exit_free;
+	for (i = 0; i < ARRAY_SIZE(bpf_caps); i++) {
+		const char *cap_name = bpf_caps[i].name;
+		cap_value_t cap = bpf_caps[i].cap;
+
+		if (cap_get_flag(caps, cap, CAP_EFFECTIVE, &val)) {
+			p_err("bug: failed to retrieve %s status: %s", cap_name,
+			      strerror(errno));
+			goto exit_free;
+		}
+
+		if (val == CAP_SET) {
+			bpf_caps[i].set = true;
+			cap_list[nb_bpf_caps++] = cap;
+		}
+
+		if (cap_sys_admin_only)
+			/* System does not know about CAP_BPF, meaning that
+			 * CAP_SYS_ADMIN is the only capability required. We
+			 * just checked it, break.
+			 */
+			break;
 	}
 
-	if ((run_as_unprivileged && !has_sys_admin_cap) ||
-	    (!run_as_unprivileged && has_sys_admin_cap)) {
+	if ((run_as_unprivileged && !nb_bpf_caps) ||
+	    (!run_as_unprivileged && nb_bpf_caps == ARRAY_SIZE(bpf_caps)) ||
+	    (!run_as_unprivileged && cap_sys_admin_only && nb_bpf_caps)) {
 		/* We are all good, exit now */
 		res = 0;
 		goto exit_free;
 	}
 
-	/* if (run_as_unprivileged && has_sys_admin_cap), drop CAP_SYS_ADMIN */
+	if (!run_as_unprivileged) {
+		if (cap_sys_admin_only)
+			p_err("missing %s, required for full feature probing; run as root or use 'unprivileged'",
+			      bpf_caps[0].name);
+		else
+			p_err("missing %s%s%s%s%s%s%s%srequired for full feature probing; run as root or use 'unprivileged'",
+			      capability_msg(bpf_caps, 0),
+			      capability_msg(bpf_caps, 1),
+			      capability_msg(bpf_caps, 2),
+			      capability_msg(bpf_caps, 3));
+		goto exit_free;
+	}
 
-	if (cap_set_flag(caps, CAP_EFFECTIVE, ARRAY_SIZE(cap_list), cap_list,
+	/* if (run_as_unprivileged && nb_bpf_caps > 0), drop capabilities. */
+	if (cap_set_flag(caps, CAP_EFFECTIVE, nb_bpf_caps, cap_list,
 			 CAP_CLEAR)) {
-		p_err("bug: failed to clear CAP_SYS_ADMIN from capabilities");
+		p_err("bug: failed to clear capabilities: %s", strerror(errno));
 		goto exit_free;
 	}
 
 	if (cap_set_proc(caps)) {
-		p_err("failed to drop CAP_SYS_ADMIN: %s", strerror(errno));
+		p_err("failed to drop capabilities: %s", strerror(errno));
 		goto exit_free;
 	}
 
@@ -817,7 +864,7 @@ static int handle_perms(void)
 
 	return res;
 #else
-	/* Detection assumes user has sufficient privileges (CAP_SYS_ADMIN).
+	/* Detection assumes user has specific privileges.
 	 * We do not use libpcap so let's approximate, and restrict usage to
 	 * root user only.
 	 */
@@ -901,7 +948,7 @@ static int do_probe(int argc, char **argv)
 		}
 	}
 
-	/* Full feature detection requires CAP_SYS_ADMIN privilege.
+	/* Full feature detection requires specific privileges.
 	 * Let's approximate, and warn if user is not root.
 	 */
 	if (handle_perms())
-- 
2.20.1

