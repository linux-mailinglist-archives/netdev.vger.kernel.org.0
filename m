Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A6B634F6C9
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 04:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233479AbhCaCdU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 22:33:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233410AbhCaCc4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 22:32:56 -0400
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42017C061574;
        Tue, 30 Mar 2021 19:32:56 -0700 (PDT)
Received: by mail-oi1-x233.google.com with SMTP id n140so18579192oig.9;
        Tue, 30 Mar 2021 19:32:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ia35mLKoc/vzo79tg+pjBoddoF8fRkfZ+FycVXH6fOo=;
        b=PtUXUUOGhfnXaUZfgQvUE5SGxYS6ri0EFSDTszqlEsSAkcsvtQJSQO25/cMp6Vhe4I
         YEcEtujeEkLxehJlHnBvznHEwPbSulzCHuulzYdo9mr0DuiPE1bkA6SGsWb1Ed7tUdMk
         XTMsPf2Om6SJ8dC0EMciavI4aoKizhPbXpvV2QH9ZGN2yU3hTfhDZ/e8KlQ3nqgVClnm
         GnuRNj2GYT1dpSNEhsmrBV3k9Z0sKo9ONQhNXSf1P+BqtaDvCyjXj4dY5kNJF1B6wG9X
         OBji9bFVbR30Se4k19VOqYOyzf4X37bn6+b+I4RuRn7jBGWB7WP3+AymFXW3DHc7XyNG
         yzsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ia35mLKoc/vzo79tg+pjBoddoF8fRkfZ+FycVXH6fOo=;
        b=eP/rAzNunMT4KiWFsLdUH31J7ldv5t+kyCu/LpEdQmFb5h2EI0GpaRFMdoWxnc00b9
         hElGKZnCdjg2rSgHg5+I3oIX6UVYIChnTnJ4OVQcf0fiXc0prProgFR02WB/hnrW5+X2
         GIBkdiRMvfHIPWz6TBjs9EdUpdX8AMLDNkaVita0Wp3eqaZlubd7G7skP5dQw9bRFB9P
         IooBolEAnN+bM1Ji9WFsMEXv6yVt8R72JHdS7f31Ia//upBaB5d6vlI+e8FJz89MURY7
         QI6GSp8nldC9iD5MYlNwzrzgeT5j53K/RsVlHWnMp9nxANvMhRzsPW+YoMIPtulgo5WD
         cekQ==
X-Gm-Message-State: AOAM533a0WAJW1sDesLnCuWkDKQQSR/3dxCq7/HCxREyE4lVKnqRRAGq
        2yKCOqLrZy3A2ayK4LHzUA4K5TrC4kwOkw==
X-Google-Smtp-Source: ABdhPJzjsBubH5BnPVqvvuIDnyqIs1QyH6GDsnFcjo18gU+RPywRqXBTbZD3T5puijAPA2KXS2v3Yw==
X-Received: by 2002:a05:6808:54c:: with SMTP id i12mr675971oig.17.1617157975557;
        Tue, 30 Mar 2021 19:32:55 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:a099:767b:2b62:48df])
        by smtp.gmail.com with ESMTPSA id 7sm188125ois.20.2021.03.30.19.32.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Mar 2021 19:32:55 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>
Subject: [Patch bpf-next v8 07/16] sock_map: simplify sock_map_link() a bit
Date:   Tue, 30 Mar 2021 19:32:28 -0700
Message-Id: <20210331023237.41094-8-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210331023237.41094-1-xiyou.wangcong@gmail.com>
References: <20210331023237.41094-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

sock_map_link() passes down map progs, but it is confusing
to see both map progs and psock progs. Make the map progs
more obvious by retrieving it directly with sock_map_progs()
inside sock_map_link(). Now it is aligned with
sock_map_link_no_progs() too.

Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 net/core/sock_map.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index e564fdeaada1..d06face0f16c 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -26,6 +26,7 @@ struct bpf_stab {
 
 static int sock_map_prog_update(struct bpf_map *map, struct bpf_prog *prog,
 				struct bpf_prog *old, u32 which);
+static struct sk_psock_progs *sock_map_progs(struct bpf_map *map);
 
 static struct bpf_map *sock_map_alloc(union bpf_attr *attr)
 {
@@ -224,10 +225,10 @@ static struct sk_psock *sock_map_psock_get_checked(struct sock *sk)
 	return psock;
 }
 
-static int sock_map_link(struct bpf_map *map, struct sk_psock_progs *progs,
-			 struct sock *sk)
+static int sock_map_link(struct bpf_map *map, struct sock *sk)
 {
 	struct bpf_prog *msg_parser, *stream_parser, *stream_verdict;
+	struct sk_psock_progs *progs = sock_map_progs(map);
 	struct sk_psock *psock;
 	int ret;
 
@@ -492,7 +493,7 @@ static int sock_map_update_common(struct bpf_map *map, u32 idx,
 	 * and sk_write_space callbacks overridden.
 	 */
 	if (sock_map_redirect_allowed(sk))
-		ret = sock_map_link(map, &stab->progs, sk);
+		ret = sock_map_link(map, sk);
 	else
 		ret = sock_map_link_no_progs(map, sk);
 	if (ret < 0)
@@ -1004,7 +1005,7 @@ static int sock_hash_update_common(struct bpf_map *map, void *key,
 	 * and sk_write_space callbacks overridden.
 	 */
 	if (sock_map_redirect_allowed(sk))
-		ret = sock_map_link(map, &htab->progs, sk);
+		ret = sock_map_link(map, sk);
 	else
 		ret = sock_map_link_no_progs(map, sk);
 	if (ret < 0)
-- 
2.25.1

