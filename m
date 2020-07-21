Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 077E9227C89
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 12:07:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729185AbgGUKHU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 06:07:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726415AbgGUKHT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 06:07:19 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C630C061794
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 03:07:19 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id o2so2283256wmh.2
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 03:07:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oXGSZ0dsXv7x3pURvQ2cvr8DFxcIdAjKTYhBK5oO81A=;
        b=PzoP31ht8eD53sERMB43pFIWqbCNcNQsde32C1X0lOcGO4jxyvkDb4kzJofJoqB23Y
         awubkNA1+MX7CpcGelunh1YRBzU1nt0tAKpq+GNGN2N/+LCO7a6sK9bKNhBBD0uODo/n
         ehzrrhFfcU4JjbPaIqV5KgSADbO7HWrkaOq34=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oXGSZ0dsXv7x3pURvQ2cvr8DFxcIdAjKTYhBK5oO81A=;
        b=O10Jp8oA8Ivf55WTTmWoQ/Dv3r6AD2JwdH67pQr3HaKSWR0m/nuY64Q7QQQuHV/iN5
         8LQbYkWg5nqw9q1m2DT+LqoilGXjK7M/vTn/Hp68fx4dR6PecKQjCtvJSBqeD9Szg8NI
         o4KO6DKru0TOFdNtbNlvlHRxgutUZQ1ofUxtKW7R1FTHLIC5wntV7UoZpHoxDWrhR1hF
         ttQ4moIcLHkY5m1grSe7zfzzT48G6WQSYr7+yoiDNRQo8iZPqcH3BiJ4QSd25obzGDX0
         mu8pMACVQsvzNf//I+30BkGoP+iRPeQAhMJrmjMiPoDbik1B6N/2tRBbU4zp9h6s//XL
         vsZQ==
X-Gm-Message-State: AOAM530BLrXl2rUqFysQ9IAnMlKVAwRk7HdyKfUBvXqu0H7pFYNhqyrI
        +PQ5OanLB9OJYnx3xkGToqOtvA==
X-Google-Smtp-Source: ABdhPJy3Jlln+qsPyGP9sChkcbPXDeup2njSIU7yISiWeOUvZKr7crp5YYZMX0v1paGnfuZLG9zhYQ==
X-Received: by 2002:a1c:7916:: with SMTP id l22mr3152439wme.115.1595326038161;
        Tue, 21 Jul 2020 03:07:18 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id u1sm45504409wrb.78.2020.07.21.03.07.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2020 03:07:17 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH bpf-next] bpf, netns: Fix build without CONFIG_INET
Date:   Tue, 21 Jul 2020 12:07:16 +0200
Message-Id: <20200721100716.720477-1-jakub@cloudflare.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When CONFIG_NET is set but CONFIG_INET isn't, build fails with:

  ld: kernel/bpf/net_namespace.o: in function `netns_bpf_attach_type_unneed':
  kernel/bpf/net_namespace.c:32: undefined reference to `bpf_sk_lookup_enabled'
  ld: kernel/bpf/net_namespace.o: in function `netns_bpf_attach_type_need':
  kernel/bpf/net_namespace.c:43: undefined reference to `bpf_sk_lookup_enabled'

This is because without CONFIG_INET bpf_sk_lookup_enabled symbol is not
available. Wrap references to bpf_sk_lookup_enabled with preprocessor
conditionals.

Fixes: 1559b4aa1db4 ("inet: Run SK_LOOKUP BPF program on socket lookup")
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 kernel/bpf/net_namespace.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/bpf/net_namespace.c b/kernel/bpf/net_namespace.c
index 4e1bcaa2c3cb..71405edd667c 100644
--- a/kernel/bpf/net_namespace.c
+++ b/kernel/bpf/net_namespace.c
@@ -28,9 +28,11 @@ DEFINE_MUTEX(netns_bpf_mutex);
 static void netns_bpf_attach_type_unneed(enum netns_bpf_attach_type type)
 {
 	switch (type) {
+#ifdef CONFIG_INET
 	case NETNS_BPF_SK_LOOKUP:
 		static_branch_dec(&bpf_sk_lookup_enabled);
 		break;
+#endif
 	default:
 		break;
 	}
@@ -39,9 +41,11 @@ static void netns_bpf_attach_type_unneed(enum netns_bpf_attach_type type)
 static void netns_bpf_attach_type_need(enum netns_bpf_attach_type type)
 {
 	switch (type) {
+#ifdef CONFIG_INET
 	case NETNS_BPF_SK_LOOKUP:
 		static_branch_inc(&bpf_sk_lookup_enabled);
 		break;
+#endif
 	default:
 		break;
 	}
-- 
2.25.4

