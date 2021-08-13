Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CC533EBE89
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 01:05:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235508AbhHMXGE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 19:06:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235480AbhHMXGD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Aug 2021 19:06:03 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEE25C0617AD
        for <netdev@vger.kernel.org>; Fri, 13 Aug 2021 16:05:35 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id v130-20020a25c5880000b0290593c8c353ffso10642360ybe.7
        for <netdev@vger.kernel.org>; Fri, 13 Aug 2021 16:05:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=w5ArQODj62JzysVgNIqUBqKWTF4hbNQs1qCfMYZxXis=;
        b=DrZNkWWj5OC/mtB2NjaSWeG54bhFHodXay+7zjX2tQYgmFF7VmvEOrCLAINrAD+ttT
         EexC0Ijei3DPioGxCjMNwY9ynii/4PVBzQG1wA43gOKdPH2WRqY1yo2jPiVvILwlZfM/
         hrKLwHK1GwtAVWE3nHxAqi/nlvkHk0h8HzRHQ5TfP/Dqkq+GKnXXBJ15boS3tDovXNn2
         zZcNtPu7E4+Q6wJJEIcKSTa69Ou9rJYV1xn5RlSQlaRg3yHL32eLKdDZDxF8suO0O+VN
         aV996tTmUo4N87p57Qt1apl2ac+AGgmWW2qT2RsJpuqlzh7X8+3SLdFf/wMODDCjg2LH
         cjzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=w5ArQODj62JzysVgNIqUBqKWTF4hbNQs1qCfMYZxXis=;
        b=Fw3rgfuPcawcpVE1MZGx7W3dUpTG0RDupjRlLynN1zeHiD5H6PSBfLG6Hvgdm9kS+/
         pZeBnwXyScJurnLDIbjbwEPGv5isTrsgaKMGhMUKE49y2+09kuohyojVE4Bny5+7vPiQ
         8wvoo9hmsOcRyxllQ5H2/hZfhyAbjyts5Pm7TQCCA7t9ffqqZR83zP7jPwP9m4MhIrAG
         RfBFyIzfWC0xYSMrc+xOQbiEbHGQ76G2k8Fwoefqu183Brc5pnpEU5fGsox31YPbhWtq
         2MJ2tiHFeGt+9jDKflNb1S0nlOo+GbUEjgVE3EMozdaSehfYqhCL6A/PRRqxd+oeQ0D9
         QpGQ==
X-Gm-Message-State: AOAM532xbEr8C0i29eeKjoLpXEzpr3ZelWW11f0/8t1coan5Fr/iG911
        uT4zHt8vs/DZMn8Y5tP+sSZtu8lUU3fuY0udcNnLhx5TygRpclPBo3VTSKOvYXgA8K5EEfdSVRt
        bKiekjRedVvozI2GvjvVkY4BiivSEoxTr/fRMiXwNpwW+BDCAoMcFEQ==
X-Google-Smtp-Source: ABdhPJxx8HUPdBoso1DvwOX58ucsEqIzQLFLtjTEMiqP3iL2koYJnqNoZv7gm7vDBkl5+RJxvH+wRPQ=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:201:f73:a375:cbb9:779b])
 (user=sdf job=sendgmr) by 2002:a25:4941:: with SMTP id w62mr5976061yba.230.1628895934963;
 Fri, 13 Aug 2021 16:05:34 -0700 (PDT)
Date:   Fri, 13 Aug 2021 16:05:29 -0700
In-Reply-To: <20210813230530.333779-1-sdf@google.com>
Message-Id: <20210813230530.333779-2-sdf@google.com>
Mime-Version: 1.0
References: <20210813230530.333779-1-sdf@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH bpf-next v3 1/2] bpf: Allow bpf_get_netns_cookie in BPF_PROG_TYPE_CGROUP_SOCKOPT
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        Stanislav Fomichev <sdf@google.com>,
        Martin KaFai Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is similar to existing BPF_PROG_TYPE_CGROUP_SOCK
and BPF_PROG_TYPE_CGROUP_SOCK_ADDR.

Cc: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 kernel/bpf/cgroup.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index b567ca46555c..9f6070369caa 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -1846,11 +1846,29 @@ const struct bpf_verifier_ops cg_sysctl_verifier_ops = {
 const struct bpf_prog_ops cg_sysctl_prog_ops = {
 };
 
+#ifdef CONFIG_NET
+BPF_CALL_1(bpf_get_netns_cookie_sockopt, struct bpf_sockopt_kern *, ctx)
+{
+	const struct net *net = ctx ? sock_net(ctx->sk) : &init_net;
+
+	return net->net_cookie;
+}
+
+static const struct bpf_func_proto bpf_get_netns_cookie_sockopt_proto = {
+	.func		= bpf_get_netns_cookie_sockopt,
+	.gpl_only	= false,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_CTX_OR_NULL,
+};
+#endif
+
 static const struct bpf_func_proto *
 cg_sockopt_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 {
 	switch (func_id) {
 #ifdef CONFIG_NET
+	case BPF_FUNC_get_netns_cookie:
+		return &bpf_get_netns_cookie_sockopt_proto;
 	case BPF_FUNC_sk_storage_get:
 		return &bpf_sk_storage_get_proto;
 	case BPF_FUNC_sk_storage_delete:
-- 
2.33.0.rc1.237.g0d66db33f3-goog

