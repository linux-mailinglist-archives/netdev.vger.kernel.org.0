Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C26DB1E4B79
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 19:08:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731153AbgE0RIy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 13:08:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731144AbgE0RIx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 13:08:53 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34989C03E97D
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 10:08:52 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id o15so7594990ejm.12
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 10:08:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ake+ZECmllu4KjoI5HH1jXA8S9PkpzaukmThdKDNcmU=;
        b=qEIqJDypMvwq/WQxXJFbsfi9MC0b7w5CtjoOu/BPko+4IuBgu8Z0qb1JSjyddg9Cp1
         FbEGHkh9jiXS3Li/XexO8U1mEBPVgcVQFphun467D9s3Z3uv/JrppbL+F/NS/mGcd/ja
         e7elLHS+lyzY3StbZZXJrvGZYnUnmdCTxvy04=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ake+ZECmllu4KjoI5HH1jXA8S9PkpzaukmThdKDNcmU=;
        b=DegMkUn8vgunBz166LBZ1cDOKGmSXBsQSBnE10mxjDOPrNGM92JGTheHGz7u8zyq8z
         psbpvVeNZj5O8+hR20gSALl69Pdt6HQmVI9kSzBX2sUEvhcZIeGTKcxCU9R1bxNhrTto
         r1c+zCN2b6yuAVmyQxLjgQLa1zUzbiU2Y8TbBTyEOwtMDWkihr2nBrGcJt4aUJN+wdgm
         JgMpnGQjuVepsXGFYrO8v/NxTGhOnHlIuSCaIncqXOJOWJqXdVrvlzdjybpru4mkvl1B
         4zXUzL/et0JKcSyIgBqZeXpgiCMU6zq0sAEMEK71Tc7h19i5SspCDtyQ+MkjEgulN+2Q
         2D3A==
X-Gm-Message-State: AOAM532pS0hP3Aa5eEbx2UOuosNcn5epwu/Tir/mCU342LzBEV4nbiib
        xxXpTnzVDwKGyLB1mIrzlSQjEA==
X-Google-Smtp-Source: ABdhPJxVTX7traBXwpsonrqToKzBslZcI94UNACOACxgAotufo56gbZhV02X88DTU+1pZQMy25peNw==
X-Received: by 2002:a17:906:b299:: with SMTP id q25mr7390916ejz.448.1590599330909;
        Wed, 27 May 2020 10:08:50 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id h10sm2466273ejb.2.2020.05.27.10.08.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2020 10:08:50 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com
Subject: [PATCH bpf-next 6/8] libbpf: Add support for bpf_link-based netns attachment
Date:   Wed, 27 May 2020 19:08:38 +0200
Message-Id: <20200527170840.1768178-7-jakub@cloudflare.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200527170840.1768178-1-jakub@cloudflare.com>
References: <20200527170840.1768178-1-jakub@cloudflare.com>
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
 tools/lib/bpf/libbpf.c   | 20 ++++++++++++++++----
 tools/lib/bpf/libbpf.h   |  2 ++
 tools/lib/bpf/libbpf.map |  1 +
 3 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 5d60de6fd818..a49c1eb5db64 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -7894,8 +7894,8 @@ static struct bpf_link *attach_iter(const struct bpf_sec_def *sec,
 	return bpf_program__attach_iter(prog, NULL);
 }
 
-struct bpf_link *
-bpf_program__attach_cgroup(struct bpf_program *prog, int cgroup_fd)
+static struct bpf_link *
+bpf_program__attach_fd(struct bpf_program *prog, int target_fd)
 {
 	enum bpf_attach_type attach_type;
 	char errmsg[STRERR_BUFSIZE];
@@ -7915,11 +7915,11 @@ bpf_program__attach_cgroup(struct bpf_program *prog, int cgroup_fd)
 	link->detach = &bpf_link__detach_fd;
 
 	attach_type = bpf_program__get_expected_attach_type(prog);
-	link_fd = bpf_link_create(prog_fd, cgroup_fd, attach_type, NULL);
+	link_fd = bpf_link_create(prog_fd, target_fd, attach_type, NULL);
 	if (link_fd < 0) {
 		link_fd = -errno;
 		free(link);
-		pr_warn("program '%s': failed to attach to cgroup: %s\n",
+		pr_warn("program '%s': failed to attach to cgroup/netns: %s\n",
 			bpf_program__title(prog, false),
 			libbpf_strerror_r(link_fd, errmsg, sizeof(errmsg)));
 		return ERR_PTR(link_fd);
@@ -7928,6 +7928,18 @@ bpf_program__attach_cgroup(struct bpf_program *prog, int cgroup_fd)
 	return link;
 }
 
+struct bpf_link *
+bpf_program__attach_cgroup(struct bpf_program *prog, int cgroup_fd)
+{
+	return bpf_program__attach_fd(prog, cgroup_fd);
+}
+
+struct bpf_link *
+bpf_program__attach_netns(struct bpf_program *prog, int netns_fd)
+{
+	return bpf_program__attach_fd(prog, netns_fd);
+}
+
 struct bpf_link *
 bpf_program__attach_iter(struct bpf_program *prog,
 			 const struct bpf_iter_attach_opts *opts)
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index 1e2e399a5f2c..adf6fd9b6fe8 100644
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
index 381a7342ecfc..7ad21ba1feb6 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -263,4 +263,5 @@ LIBBPF_0.0.9 {
 		bpf_link_get_next_id;
 		bpf_program__attach_iter;
 		perf_buffer__consume;
+		bpf_program__attach_netns;
 } LIBBPF_0.0.8;
-- 
2.25.4

