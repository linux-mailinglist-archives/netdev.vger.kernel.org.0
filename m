Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A4673037EC
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 09:31:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389798AbhAZIa3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 03:30:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389930AbhAZI1Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 03:27:16 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEDD2C061574;
        Tue, 26 Jan 2021 00:26:35 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id r38so5142383pgk.13;
        Tue, 26 Jan 2021 00:26:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=eLDX3EtsebNExHOoaDQTARUSCDGmDLN0hLIYtdMe5Zo=;
        b=oKsdV7Y0HbiUUSRJyCavI1dIcTiZFyRU8XBbGbvxZkaVZ6rAmFcfHawAu2qrycyoNb
         NTs8gAXGG2LZ3hIZtWw5F4gVZexZpGcDW8iSK07RoIegEdOrvNFPYH+6ufhLwEMmQ7IZ
         9+Vd0WMiNGqLYLMVFPldalJlnrwNUxq1VytOcW8aKt/01UPOc4eQw7ymtbinKB/cqHIi
         fKq5y98APc3DPl66ug7EfRyE4274m+WNau4cR3mvtsQxIx6RdEuCB93Z93rw7DIKEgKQ
         nBvaB7tLHWnkR28swJo4doU4XTIk5wvI5X65kNqn/3uTlGB/Kv6yW1TxVBr8FNNSOLO2
         ySHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=eLDX3EtsebNExHOoaDQTARUSCDGmDLN0hLIYtdMe5Zo=;
        b=K0D1FhvI1f5NapXjOAJ6/VLcdiMiYSgL8TgekVFHqH5+Qgch+BkJ8rlvCmWrvzRKsh
         5LZ0jsT2MQsHsQNG6kQRHJhsnJCRF0NpAmqMAZRXSVXxIL/bKE8Eo5kdRY4EtqLTZMhH
         v17PSXwIi7lrvIegy7vaoIt75ofqeFVBLOtDTLTlh91Gqfyw0E5Ajd/9kBG1U9r2N345
         62uEkJGxgimbfFg/LzLu1wNa6GB5F2DsqnlbG1p62V1OJsK3JVC89tPpiTMqRw7edYdg
         l15fLlA86fy5ky+o90O2eTmaqUA3CyHszlx+AazjhMGszqCpS/pqO3WKEVs06L+nm7rU
         HW9A==
X-Gm-Message-State: AOAM532BLw3fGtlwURL49ltDoMVF/JdlWliUP/TUFxSLFtiGXgkrUp8Q
        wzzN/XK+uinW1yUt+pTj0Wo=
X-Google-Smtp-Source: ABdhPJxZdoQajeF68VODbuKRDysR+73tDTaxFHrq/Y1k/ZkKqWUX0VoCFlzMDMhoa51q4gdqytfXiw==
X-Received: by 2002:a63:5c61:: with SMTP id n33mr4784020pgm.153.1611649594685;
        Tue, 26 Jan 2021 00:26:34 -0800 (PST)
Received: from android.asia-east2-a.c.savvy-summit-295307.internal (53.207.96.34.bc.googleusercontent.com. [34.96.207.53])
        by smtp.googlemail.com with ESMTPSA id 7sm18135890pfh.142.2021.01.26.00.26.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jan 2021 00:26:33 -0800 (PST)
From:   Bui Quang Minh <minhquangbui99@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org, jakub@cloudflare.com, lmb@cloudflare.com
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, minhquangbui99@gmail.com
Subject: [PATCH] bpf: Fix integer overflow in argument calculation for bpf_map_area_alloc
Date:   Tue, 26 Jan 2021 08:26:06 +0000
Message-Id: <20210126082606.3183-1-minhquangbui99@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In 32-bit architecture, the result of sizeof() is a 32-bit integer so
the expression becomes the multiplication between 2 32-bit integer which
can potentially leads to integer overflow. As a result,
bpf_map_area_alloc() allocates less memory than needed.

Fix this by casting 1 operand to u64.

Signed-off-by: Bui Quang Minh <minhquangbui99@gmail.com>
---
 kernel/bpf/devmap.c | 4 ++--
 net/core/sock_map.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index f6e9c68afdd4..e849c3e8a49f 100644
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
index 64b5ec14ff50..7a42016a981d 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -44,7 +44,7 @@ static struct bpf_map *sock_map_alloc(union bpf_attr *attr)
 	bpf_map_init_from_attr(&stab->map, attr);
 	raw_spin_lock_init(&stab->lock);
 
-	stab->sks = bpf_map_area_alloc(stab->map.max_entries *
+	stab->sks = bpf_map_area_alloc((u64) stab->map.max_entries *
 				       sizeof(struct sock *),
 				       stab->map.numa_node);
 	if (!stab->sks) {
-- 
2.17.1

