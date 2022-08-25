Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C98145A1B48
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 23:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243928AbiHYVjj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 17:39:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243925AbiHYVjR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 17:39:17 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8C77C229A
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 14:39:15 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-3328a211611so359708967b3.5
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 14:39:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc;
        bh=qyjREfjkq0hIeesiuObUgKl0CFQ9rAXNLG/+EmCCOug=;
        b=Mz+DnI4of0BYshEfym2Ka/PzJ9GfRcPKAz/WWjS7OP9u7mD+Ksba3kRYQl/jBIVHoi
         oG2D2uUnrOrUQmHeUurZkx93oBq1ceQ2hn96zUZLgxRDyhVewe6kN1esNGMVQtSQvwvd
         hOBom9axJKVPjSlESgsenu4/V0Bj1iOZPFd+8oDkkdTGkk3FpOj2eWqqu/QQag7S66ek
         o3FOsVesz8mzvF8Pw9i9l7QuT/O55FB4w7ZAMUyMkjxAQU4h3TfjC+osbssLeWqwETJ8
         ejxR3J8KwtlQMKzLeUsTFomcDKHbkEpdjZZf1kOCcf8RwoJcg52MJ9Mp6rb9LuHOfQg1
         vdEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=qyjREfjkq0hIeesiuObUgKl0CFQ9rAXNLG/+EmCCOug=;
        b=yvo8HL+7/v3klCamhFWogQdFuAi9mprfKSx4YOK17zcRYNHXUJaUd/ypURLKLy+wRc
         zmmaWgUKK4vB01G+nrKcQvRcd+yjlHQUbxIk+0fkr9oGwpVldUSZfsq/oTk844vU2kRN
         refGuuJA5M9rpcEidNh7OWKnEjAT84X1Qd8rYDpyl5WKsbkspir08KxMCwm1RooUTWnL
         yUk+2QbIHCeqi7Ae5v7Y/GIoGOkJYB8XF0aeVARpHtTYntJetidXWMjKviAuR0qcKcVt
         z7WOXQfS/VjTweEZqcX5WMS7W4yDA6YRGPR7z6ocavrbiea80/W/ben6X5/M9rZqkoQx
         Jr1w==
X-Gm-Message-State: ACgBeo0PsmZOu/6qN1r/9wjFfrwF0R57Rge8ySjCN8d7Qik03G9MG93q
        URPkZRQAEs1BmbhvHPClwvJdISp4gxA=
X-Google-Smtp-Source: AA6agR7J1T+1mDf/L7KJ6viBPp96hK/l2ak65iQp0rK0p+gbSsL7vdWeOOGRneu6yCsZT9QG2uZsweyN+M0=
X-Received: from haoluo.svl.corp.google.com ([2620:15c:2d4:203:2c4f:653f:78b3:2b5b])
 (user=haoluo job=sendgmr) by 2002:a25:198b:0:b0:690:65bb:9416 with SMTP id
 133-20020a25198b000000b0069065bb9416mr4806243ybz.142.1661463555046; Thu, 25
 Aug 2022 14:39:15 -0700 (PDT)
Date:   Thu, 25 Aug 2022 14:39:05 -0700
In-Reply-To: <20220825213905.1817722-1-haoluo@google.com>
Mime-Version: 1.0
References: <20220825213905.1817722-1-haoluo@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220825213905.1817722-3-haoluo@google.com>
Subject: [PATCH bpf-next 2/2] selftests/bpf: Fix test that uses cgroup_iter order
From:   Hao Luo <haoluo@google.com>
To:     linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Yosry Ahmed <yosryahmed@google.com>,
        Hao Luo <haoluo@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Previous commit added a CGROUP prefix to the bpf_cgroup_iter_order.
It fixes the commit that introduced cgroup iter. This commit fixes
the selftest that uses the cgroup_iter_order. Because they fix two
different commits, so put them in separate patches.

Fixes: 88886309d2e8 ("selftests/bpf: add a selftest for cgroup hierarchical stats collection")
Suggested-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Hao Luo <haoluo@google.com>
---
 .../selftests/bpf/prog_tests/cgroup_hierarchical_stats.c        | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/cgroup_hierarchical_stats.c b/tools/testing/selftests/bpf/prog_tests/cgroup_hierarchical_stats.c
index 101a6d70b863..bed1661596f7 100644
--- a/tools/testing/selftests/bpf/prog_tests/cgroup_hierarchical_stats.c
+++ b/tools/testing/selftests/bpf/prog_tests/cgroup_hierarchical_stats.c
@@ -275,7 +275,7 @@ static int setup_cgroup_iter(struct cgroup_hierarchical_stats *obj,
 	 * traverse one cgroup, so set the traversal order to "self".
 	 */
 	linfo.cgroup.cgroup_fd = cgroup_fd;
-	linfo.cgroup.order = BPF_ITER_SELF_ONLY;
+	linfo.cgroup.order = BPF_CGROUP_ITER_SELF_ONLY;
 	opts.link_info = &linfo;
 	opts.link_info_len = sizeof(linfo);
 	link = bpf_program__attach_iter(obj->progs.dump_vmscan, &opts);
-- 
2.37.2.672.g94769d06f0-goog

