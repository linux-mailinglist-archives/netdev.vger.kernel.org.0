Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81D60676643
	for <lists+netdev@lfdr.de>; Sat, 21 Jan 2023 13:42:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229661AbjAUMmU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Jan 2023 07:42:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbjAUMmT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Jan 2023 07:42:19 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACC5531E11
        for <netdev@vger.kernel.org>; Sat, 21 Jan 2023 04:42:13 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id w14so9657185edi.5
        for <netdev@vger.kernel.org>; Sat, 21 Jan 2023 04:42:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LjX4FJ8gRkEtjzAf9WCo0Kq35+A6/erPh54GkDAerRk=;
        b=GCwPUECMnDFqKMhJOpLV9kvA4uDr9sjHrlCQIN6QEJzxwu9lYnJMuvD04RathL2YRK
         yZAssOYSRJk6DrOAQwglUClqNJcQDvu7wEHiE2h+dETBqxcvM29qQnXNQdrndi6IwBae
         3SoYlIlBvS388NIbtbRcJ7VP6RkfEzUwh3U50=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LjX4FJ8gRkEtjzAf9WCo0Kq35+A6/erPh54GkDAerRk=;
        b=EWCLc7BZjuRlJiPBJIlRpVxJPBfzc/erJH6TteSohikC7WWfmWQm/KLKenBoXnEZsO
         9nB6R3n2UHNtZWCZAkNQ1hqj7cVyzer6pDOtVyVyXIbfbQetyZj/D/BJW6cihfJCF4Fr
         SvyQ2iC/QLFhr4hQ44NQTfIDe5Hr7/mcXz/ALTmgEyCBpJVdQg5NmtGIMuSiFCgbnEhG
         ZUBD7wTx9H0LbgjTQKKqrkBeIXl50OZwXXz59Xusz8WTXcS+BHDVrJG+B5/Id449XlvE
         IgxrMlAqKh8PkHEJl4c10tk22Qnrp0hAcHOjHKQ189/Jv6bmr3vUju6emlf5NKukmG05
         7o+Q==
X-Gm-Message-State: AFqh2kq027fxnx+4eg25owWEmugIesC0lPVe5nwMcwLUbKP/QnLRcxPF
        S5rcv1AysWj1mRgHvB8DvsP0ag==
X-Google-Smtp-Source: AMrXdXui1DV/13uq+rKAGkbW48xZirbek85clMWFGgnI3sZI1LxBY8gKr2F0+ZaOrxcL8Pd3w8em9Q==
X-Received: by 2002:a05:6402:528b:b0:49e:28c1:9375 with SMTP id en11-20020a056402528b00b0049e28c19375mr19104122edb.10.1674304932041;
        Sat, 21 Jan 2023 04:42:12 -0800 (PST)
Received: from cloudflare.com (79.191.179.97.ipv4.supernova.orange.pl. [79.191.179.97])
        by smtp.gmail.com with ESMTPSA id f9-20020a056402068900b0048999d127e0sm18559536edy.86.2023.01.21.04.42.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Jan 2023 04:42:11 -0800 (PST)
From:   Jakub Sitnicki <jakub@cloudflare.com>
Date:   Sat, 21 Jan 2023 13:41:46 +0100
Subject: [PATCH bpf v2 4/4] selftests/bpf: Cover listener cloning with
 progs attached to sockmap
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230113-sockmap-fix-v2-4-1e0ee7ac2f90@cloudflare.com>
References: <20230113-sockmap-fix-v2-0-1e0ee7ac2f90@cloudflare.com>
In-Reply-To: <20230113-sockmap-fix-v2-0-1e0ee7ac2f90@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, John Fastabend <john.fastabend@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, kernel-team@cloudflare.com
X-Mailer: b4 0.12.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Today we test if a child socket is cloned properly from a listening socket
inside a sockmap only when there are no BPF programs attached to the map.

A bug has been reported [1] for the case when sockmap has a verdict program
attached. So cover this case as well to prevent regressions.

[1]: https://lore.kernel.org/r/00000000000073b14905ef2e7401@google.com

Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 .../selftests/bpf/prog_tests/sockmap_listen.c      | 30 ++++++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
index 499fba8f55b9..567e07c19ecc 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
@@ -563,8 +563,7 @@ static void test_update_existing(struct test_sockmap_listen *skel __always_unuse
 /* Exercise the code path where we destroy child sockets that never
  * got accept()'ed, aka orphans, when parent socket gets closed.
  */
-static void test_destroy_orphan_child(struct test_sockmap_listen *skel __always_unused,
-				      int family, int sotype, int mapfd)
+static void do_destroy_orphan_child(int family, int sotype, int mapfd)
 {
 	struct sockaddr_storage addr;
 	socklen_t len;
@@ -595,6 +594,33 @@ static void test_destroy_orphan_child(struct test_sockmap_listen *skel __always_
 	xclose(s);
 }
 
+static void test_destroy_orphan_child(struct test_sockmap_listen *skel,
+				      int family, int sotype, int mapfd)
+{
+	int msg_verdict = bpf_program__fd(skel->progs.prog_msg_verdict);
+	int skb_verdict = bpf_program__fd(skel->progs.prog_skb_verdict);
+	const struct test {
+		int progfd;
+		enum bpf_attach_type atype;
+	} tests[] = {
+		{ -1, -1 },
+		{ msg_verdict, BPF_SK_MSG_VERDICT },
+		{ skb_verdict, BPF_SK_SKB_VERDICT },
+	};
+	const struct test *t;
+
+	for (t = tests; t < tests + ARRAY_SIZE(tests); t++) {
+		if (t->progfd != -1 &&
+		    xbpf_prog_attach(t->progfd, mapfd, t->atype, 0) != 0)
+			return;
+
+		do_destroy_orphan_child(family, sotype, mapfd);
+
+		if (t->progfd != -1)
+			xbpf_prog_detach2(t->progfd, mapfd, t->atype);
+	}
+}
+
 /* Perform a passive open after removing listening socket from SOCKMAP
  * to ensure that callbacks get restored properly.
  */

-- 
2.39.0

