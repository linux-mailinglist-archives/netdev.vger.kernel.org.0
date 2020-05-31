Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 646021E964A
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 10:29:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727914AbgEaI3J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 May 2020 04:29:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727866AbgEaI3D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 May 2020 04:29:03 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23517C05BD43
        for <netdev@vger.kernel.org>; Sun, 31 May 2020 01:29:02 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id k11so6261783ejr.9
        for <netdev@vger.kernel.org>; Sun, 31 May 2020 01:29:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HbIQz4qBb+Mdbhu6/NilzJ04N5qRw6pfaMGv7iEKJmw=;
        b=pk1TyeuWzLJRS0oVZPXljlveuw3jX6BuC27OOLAJzfmvJmh5/Ut96Q3fr0nR/4PB82
         vDenJ4WJijxGYgTGNBtprWh6jFqDP/Ys0gXenHalZ0kS1snVXy/Wh6TtDkEuLRRSasnz
         NwNsTe5R1kaX5ClweLFXVY4r/rfG36G1/nH6E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HbIQz4qBb+Mdbhu6/NilzJ04N5qRw6pfaMGv7iEKJmw=;
        b=kk+UDuEavVSR8nJIENWJcAPp+xrFI8RJwGPQmhZdulXk4+D7lU1Bjz/acGWPwuU/2t
         iNsZweCLKWyUSPcxcqeuxlO4PCa5f497cMoEEJSu5K7VFWe7ud2PnO5H3Ly8MyN4Sg8R
         XjkzbOXNz9D2LLpagS8dUkvUnz71ralkE8iMxMjXV2b+UngPJvErrKMlMtdl5QvONcsO
         eZoTu4C0HkkQQKn9V3pudPk4AZsri2j9LWHdPIsOL7vX+PfPEHcbmaO/n7/LFSilWE5n
         77fldekgNuN3G2t5LNYqwAeS4egiyvAAdttO9w4dW5Qul6+WfIcti1i2QDD8NSzf88Nn
         3myg==
X-Gm-Message-State: AOAM530/sG8fN7WTNrs1G3vOR3LO9LrlkCrNX0LeauuWOS2LOd4/VxrY
        ywnwhtAh2umIHOMEi/0WhAj+Cw==
X-Google-Smtp-Source: ABdhPJwZsgNvOKh2A1lbQej0azacIlcHujQNEQMbnY2lUxSmxtywd6MhCFG0cOhzEbTSeiqCiy6skA==
X-Received: by 2002:a17:906:580e:: with SMTP id m14mr15722034ejq.457.1590913740795;
        Sun, 31 May 2020 01:29:00 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id d26sm12521915ejo.1.2020.05.31.01.28.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 May 2020 01:29:00 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com
Subject: [PATCH bpf-next v2 06/12] libbpf: Add support for bpf_link-based netns attachment
Date:   Sun, 31 May 2020 10:28:40 +0200
Message-Id: <20200531082846.2117903-7-jakub@cloudflare.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200531082846.2117903-1-jakub@cloudflare.com>
References: <20200531082846.2117903-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add bpf_program__attach_nets(), which uses LINK_CREATE subcommand to create
an FD-based kernel bpf_link, for attach types tied to network namespace,
that is BPF_FLOW_DISSECTOR for the moment.

Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 tools/lib/bpf/libbpf.c   | 23 ++++++++++++++++++-----
 tools/lib/bpf/libbpf.h   |  2 ++
 tools/lib/bpf/libbpf.map |  1 +
 3 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 74d967619dcf..b8af2f91b7c3 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -7894,8 +7894,9 @@ static struct bpf_link *attach_iter(const struct bpf_sec_def *sec,
 	return bpf_program__attach_iter(prog, NULL);
 }
 
-struct bpf_link *
-bpf_program__attach_cgroup(struct bpf_program *prog, int cgroup_fd)
+static struct bpf_link *
+bpf_program__attach_fd(struct bpf_program *prog, int target_fd,
+		       const char *target_name)
 {
 	enum bpf_attach_type attach_type;
 	char errmsg[STRERR_BUFSIZE];
@@ -7915,12 +7916,12 @@ bpf_program__attach_cgroup(struct bpf_program *prog, int cgroup_fd)
 	link->detach = &bpf_link__detach_fd;
 
 	attach_type = bpf_program__get_expected_attach_type(prog);
-	link_fd = bpf_link_create(prog_fd, cgroup_fd, attach_type, NULL);
+	link_fd = bpf_link_create(prog_fd, target_fd, attach_type, NULL);
 	if (link_fd < 0) {
 		link_fd = -errno;
 		free(link);
-		pr_warn("program '%s': failed to attach to cgroup: %s\n",
-			bpf_program__title(prog, false),
+		pr_warn("program '%s': failed to attach to %s: %s\n",
+			bpf_program__title(prog, false), target_name,
 			libbpf_strerror_r(link_fd, errmsg, sizeof(errmsg)));
 		return ERR_PTR(link_fd);
 	}
@@ -7928,6 +7929,18 @@ bpf_program__attach_cgroup(struct bpf_program *prog, int cgroup_fd)
 	return link;
 }
 
+struct bpf_link *
+bpf_program__attach_cgroup(struct bpf_program *prog, int cgroup_fd)
+{
+	return bpf_program__attach_fd(prog, cgroup_fd, "cgroup");
+}
+
+struct bpf_link *
+bpf_program__attach_netns(struct bpf_program *prog, int netns_fd)
+{
+	return bpf_program__attach_fd(prog, netns_fd, "netns");
+}
+
 struct bpf_link *
 bpf_program__attach_iter(struct bpf_program *prog,
 			 const struct bpf_iter_attach_opts *opts)
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index 8528a02d5af8..334437af3014 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -253,6 +253,8 @@ LIBBPF_API struct bpf_link *
 bpf_program__attach_lsm(struct bpf_program *prog);
 LIBBPF_API struct bpf_link *
 bpf_program__attach_cgroup(struct bpf_program *prog, int cgroup_fd);
+LIBBPF_API struct bpf_link *
+bpf_program__attach_netns(struct bpf_program *prog, int netns_fd);
 
 struct bpf_map;
 
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index c18860200abb..f732c77b7ed0 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -262,6 +262,7 @@ LIBBPF_0.0.9 {
 		bpf_link_get_fd_by_id;
 		bpf_link_get_next_id;
 		bpf_program__attach_iter;
+		bpf_program__attach_netns;
 		perf_buffer__consume;
 		ring_buffer__add;
 		ring_buffer__consume;
-- 
2.25.4

