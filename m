Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 006093EA792
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 17:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238035AbhHLPao (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 11:30:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238063AbhHLPam (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 11:30:42 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89E4CC0613D9
        for <netdev@vger.kernel.org>; Thu, 12 Aug 2021 08:30:17 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id e16-20020a5b0cd00000b0290593fc399a4fso3245798ybr.15
        for <netdev@vger.kernel.org>; Thu, 12 Aug 2021 08:30:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=no6+bYPfReViSGb78W1KnZUyTvE5oF+fEDZlu8PUIXM=;
        b=nEA5kIv2/ByW70VMaP9Vq0v/glxqFnQZUPZvfWyMrwIB8Bc+s08efOW2tgifAq3QPe
         okcuYbSbrryreiHpAQkf+AijXU4SVKkLTD7YbPJgTkepSXi4N352cQiXLQIw+WLD7Apt
         z5Xla0oBizkxYF1rjvv9ityjXiEQXK3iJ4Fx8ltcvms60z3K44j7vehsUHj5hN1nFhGE
         PwAtKZ5tv5V+yeywe8RNiQAT0w1NOTm4Z1p4hU/58cuQRNu9NE36Z2N9Dr2VEmUZjaZ7
         ZIK9dxoZ1I8u/4HMyX/cWHDvFT/999tBULUX8Xwb9QVohxzbvBY33w6mBVAnhcol1crT
         xhUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=no6+bYPfReViSGb78W1KnZUyTvE5oF+fEDZlu8PUIXM=;
        b=NdQw1s3Ntz8yUnZwHbhEbN9+F9PtQ7nDu1821JEe3vvNIXOWB7hCw/dg+RN2krOF1K
         gFH+6BUiKTzqZ/1VEp/tCpLWNSpzkSB9xOPJ181qlhxpWvpXuO1qNLpcuNlx22DvYLiM
         2Jdd/qyxLDoubtuv6eubqWic/UhYnB1ngk7IuAiyKxJATlXqhC9RoFYRNQpI3fdYXJ6R
         pWWb399jALubwKODNgHBSkb7UZwnZK51E9rt2VN+YfGOkEIZpGAA01kLs+yAya+3G2NC
         6tH20JaBgR/UgbOVPtnHEXqLRzqokgF+KwwhhYdIyRsWAef0ssEe7GwtvEseTN7U+F9u
         E/gg==
X-Gm-Message-State: AOAM533tBlUHPYgEZX76ny27fF60RBzV38sutHq1f2O0kU/BIVRcsqMt
        QTDHvh3wkdVFjwvM0pPd92asYRb3pfVC6h5+mvdRyb1G9mKT5wfZAtJzavJbctIWfgTICOELzqX
        W/RJCV9ymJz9fKfA9pfFn3dr9av3SfXWQXlCFRJ+iFpYMdFI3GU+Q0w==
X-Google-Smtp-Source: ABdhPJxiXlMaWwgo1J6w+IEMXqt+3fCCOt/SHHG41nlIn6nyvaWeHGu5y3us38EDI+gxBGHXtx1pJJc=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:201:fa15:8621:e6d2:7ad4])
 (user=sdf job=sendgmr) by 2002:a25:4188:: with SMTP id o130mr4838371yba.394.1628782216704;
 Thu, 12 Aug 2021 08:30:16 -0700 (PDT)
Date:   Thu, 12 Aug 2021 08:30:10 -0700
In-Reply-To: <20210812153011.983006-1-sdf@google.com>
Message-Id: <20210812153011.983006-2-sdf@google.com>
Mime-Version: 1.0
References: <20210812153011.983006-1-sdf@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH bpf-next v2 1/2] bpf: Allow bpf_get_netns_cookie in BPF_PROG_TYPE_CGROUP_SOCKOPT
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is similar to existing BPF_PROG_TYPE_CGROUP_SOCK
and BPF_PROG_TYPE_CGROUP_SOCK_ADDR.

Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 kernel/bpf/cgroup.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index b567ca46555c..ca5af8852260 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -1846,11 +1846,30 @@ const struct bpf_verifier_ops cg_sysctl_verifier_ops = {
 const struct bpf_prog_ops cg_sysctl_prog_ops = {
 };
 
+#ifdef CONFIG_NET
+BPF_CALL_1(bpf_get_netns_cookie_sockopt, struct bpf_sockopt_kern *, ctx)
+{
+	struct sock *sk = ctx ? ctx->sk : NULL;
+	const struct net *net = sk ? sock_net(sk) : &init_net;
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

