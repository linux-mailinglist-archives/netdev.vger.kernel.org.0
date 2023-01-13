Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 782FB669B5C
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 16:05:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbjAMPF2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 10:05:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230090AbjAMPE6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 10:04:58 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D3DB840BD
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 06:56:32 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id v6so9900385ejg.6
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 06:56:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LjX4FJ8gRkEtjzAf9WCo0Kq35+A6/erPh54GkDAerRk=;
        b=RfXMs7/aeN1F0Luowy5Aok/0MUmvWvZ3FaoYpRALRgx0SweCHM1wGPBr8Zc7JeZaHV
         SiezbtQ39pChfrPSyLvsZzdt1sNLEx4SWY5sZEQaz6QBjruK9VqUnDayRpPO2bTGLXzs
         /I+WiyOd164IMMuPGQ4lU7tz8TapDa+40ObB0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LjX4FJ8gRkEtjzAf9WCo0Kq35+A6/erPh54GkDAerRk=;
        b=hJmoeY0UUuGYfGmL7FLdxVNXjYXDIz1M22R6nGrSlHc2PrGKXv2lqGKUnWAB33+sJ0
         m41n6cr0Q5Zon69ukj7gV7JQuFsFgc6BPe2XU78npqOoRyivC5Z5RCvAFiXjAa1KeJwj
         57/j4EEoKikmmxzLPA5LwxETngcrMq/vuIt2g8P+5ukra5eaDqD/Tea15KjekpiwwgF2
         +xfCsFPremia2Y3gOOvSpu3vt0gobZ6pdunY84/O+Kp5k7d9v7LIPOotErZEu6K6Sc+d
         emDOdqxgVIbPrGB8RBxt5ORQs7jzpHitm5b2+i+nhpL3uowqN+bSmDa9mduZ2VHT5Xze
         ggLA==
X-Gm-Message-State: AFqh2kp9GXoTauYNWEa5YRS5Q9ejWHwPdoEiVm9D/G7lX66nMT+Gm3YA
        j+v5SFJA5RidYqqQJB3mffsomZxqp4KNgveR
X-Google-Smtp-Source: AMrXdXuA/B7ppypRtstNR3RalKoTpfUXLkQGkLy3JGT6BWhvudDUOeLbHK75uqrUnlOiFDXqxFDUMg==
X-Received: by 2002:a17:907:d10f:b0:83f:cbfd:31a9 with SMTP id uy15-20020a170907d10f00b0083fcbfd31a9mr62946200ejc.47.1673621790638;
        Fri, 13 Jan 2023 06:56:30 -0800 (PST)
Received: from cloudflare.com (79.184.151.107.ipv4.supernova.orange.pl. [79.184.151.107])
        by smtp.gmail.com with ESMTPSA id b9-20020a1709063ca900b007c073be0127sm8589112ejh.202.2023.01.13.06.56.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jan 2023 06:56:30 -0800 (PST)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     netdev@vger.kernel.org
Cc:     kernel-team@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
Subject: [PATCH bpf 3/3] selftests/bpf: Cover listener cloning with progs attached to sockmap
Date:   Fri, 13 Jan 2023 15:56:23 +0100
Message-Id: <20230113-sockmap-fix-v1-3-d3cad092ee10@cloudflare.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230113-sockmap-fix-v1-0-d3cad092ee10@cloudflare.com>
References: <20230113-sockmap-fix-v1-0-d3cad092ee10@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
