Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EEFE3A5916
	for <lists+netdev@lfdr.de>; Sun, 13 Jun 2021 16:37:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231905AbhFMOjW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Jun 2021 10:39:22 -0400
Received: from mail-pj1-f43.google.com ([209.85.216.43]:37753 "EHLO
        mail-pj1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231782AbhFMOjV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Jun 2021 10:39:21 -0400
Received: by mail-pj1-f43.google.com with SMTP id 22-20020a17090a0c16b0290164a5354ad0so8570533pjs.2;
        Sun, 13 Jun 2021 07:37:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EA4ywZJGJgO/S0GCMMfw5wsW/fmHuUSs+6+pUCTlOuw=;
        b=VoDm0XhRof9E9YzseYhNh0LHoXNNqDwwyl1kLv7tOXi+Mq8XaMu36G0gQJ/6rBswLa
         5ISLicU1zrU9vZpLL5u/s8sXH2uXzzTdSsKgMyV5NQ/tghZUpboEhBtRXx1D6s8uhH9l
         jRXes9J2M8dVYwqxR3dTaz4+2c+wOa0djILU5sq5dK6e/7IY0Q5A4N6nlt9Fh/zpJ+Zy
         aa67tee7Dk4oYNjLdMZPXBUNiZ6Spf0+mCihx5mK6mUFtjUAHOxK8C2fBFsslHd2T+PO
         A9jjSJxcstF0LyazwW1zkuGKBT09KIheU0XDCCJkRMXQCXoGNPPvCuasG6V4COIl0jbp
         p60Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EA4ywZJGJgO/S0GCMMfw5wsW/fmHuUSs+6+pUCTlOuw=;
        b=QU7vFekzYB98f5gsww1SHcV5lZd0MZGXhdAKcRBaKDkhGVV349pgvJXjl8bFNyec1j
         tINSU5iqEn8z0oCwFolYAfcmJ8E11QnEs4LDriCPXmytWhoncawMorcLl6bqGvX9kflg
         sizRuGbBzHXOWYmSOs0dgVSIYr2+lEmLOGlhIbWoIDp4L34JTuGTusPOmqLWBtVHWqpU
         XqSAYcZRiYyym4JxIXezxoEhorMATfbWgnA1ARV/IUgup+0/oIN99oETQa4ck/BL5GGY
         l5KNbLhLSVr8XIV5QLRz8p3oOAVx/Ty+r/6UtHxhcibRprgGml0PxSuL2xIWlQRGGqqG
         3Ukw==
X-Gm-Message-State: AOAM533hX3fUmvo6TvsdAWrym6bFw6Da22FLAby+bVFAaE/27P/xvUbY
        XsMl5BGwavNRbWs08uKGixI=
X-Google-Smtp-Source: ABdhPJygLdD8SUpY6TYgvdshITwhWKYR50QBGYOfWAjZh7xkmcVgmLV7ZGyTu5GM66kuTQ0eFU/lrQ==
X-Received: by 2002:a17:90a:8c14:: with SMTP id a20mr14029790pjo.167.1623594966297;
        Sun, 13 Jun 2021 07:36:06 -0700 (PDT)
Received: from localhost.localdomain ([14.169.121.97])
        by smtp.gmail.com with ESMTPSA id kb14sm8181985pjb.2.2021.06.13.07.36.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Jun 2021 07:36:06 -0700 (PDT)
From:   Bui Quang Minh <minhquangbui99@gmail.com>
Cc:     minhquangbui99@gmail.com, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Roman Gushchin <guro@fb.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] bpf: Fix integer overflow in argument calculation for bpf_map_area_alloc
Date:   Sun, 13 Jun 2021 21:34:39 +0700
Message-Id: <20210613143440.71975-1-minhquangbui99@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In 32-bit architecture, the result of sizeof() is a 32-bit integer so
the expression becomes the multiplication between 2 32-bit integer which
can potentially leads to integer overflow. As a result,
bpf_map_area_alloc() allocates less memory than needed.

Fix this by casting 1 operand to u64.

Fixes: 0d2c4f964050 ("bpf: Eliminate rlimit-based memory accounting for sockmap
and sockhash maps")
Fixes: 99c51064fb06 ("devmap: Use bpf_map_area_alloc() for allocating hash
buckets")
Fixes: 546ac1ffb70d ("bpf: add devmap, a map for storing net device references")
Signed-off-by: Bui Quang Minh <minhquangbui99@gmail.com>
---
v2: Add Fixes tag

 kernel/bpf/devmap.c | 4 ++--
 net/core/sock_map.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index aa516472ce46..3b45c23286c0 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -92,7 +92,7 @@ static struct hlist_head *dev_map_create_hash(unsigned int entries,
 	int i;
 	struct hlist_head *hash;
 
-	hash = bpf_map_area_alloc(entries * sizeof(*hash), numa_node);
+	hash = bpf_map_area_alloc((u64) entries * sizeof(*hash), numa_node);
 	if (hash != NULL)
 		for (i = 0; i < entries; i++)
 			INIT_HLIST_HEAD(&hash[i]);
@@ -143,7 +143,7 @@ static int dev_map_init_map(struct bpf_dtab *dtab, union bpf_attr *attr)
 
 		spin_lock_init(&dtab->index_lock);
 	} else {
-		dtab->netdev_map = bpf_map_area_alloc(dtab->map.max_entries *
+		dtab->netdev_map = bpf_map_area_alloc((u64) dtab->map.max_entries *
 						      sizeof(struct bpf_dtab_netdev *),
 						      dtab->map.numa_node);
 		if (!dtab->netdev_map)
diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 6f1b82b8ad49..60decd6420ca 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -48,7 +48,7 @@ static struct bpf_map *sock_map_alloc(union bpf_attr *attr)
 	bpf_map_init_from_attr(&stab->map, attr);
 	raw_spin_lock_init(&stab->lock);
 
-	stab->sks = bpf_map_area_alloc(stab->map.max_entries *
+	stab->sks = bpf_map_area_alloc((u64) stab->map.max_entries *
 				       sizeof(struct sock *),
 				       stab->map.numa_node);
 	if (!stab->sks) {
-- 
2.25.1

