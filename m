Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EC438BE76
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 18:26:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727975AbfHMQ0h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 12:26:37 -0400
Received: from mail-pg1-f202.google.com ([209.85.215.202]:57064 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727803AbfHMQ0g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 12:26:36 -0400
Received: by mail-pg1-f202.google.com with SMTP id h5so66770200pgq.23
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 09:26:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=V3bTaQ1RYb35fMQheLr/L3CIid9YdUVh3NjbfiRt7+E=;
        b=H6sJVsm5OoLzEggQThsGP/nT4pWUG8zxMKFVcUflRWMIZL31OmiKKCUNz5zMEQ/9vx
         4wyijdKdQuJftqICOZi0nNPRUnGVFXLFeoguXpvbmGHtx0rBJ467nY9sCBrzPCtmTlA+
         7v+8dV2AcIPbdWQuVwYs1n+WmKksb7kOC3za81DxF8wPytJdSJxMVUIOSRdwsAf6Vqtk
         DLs9yKQyo3YRTpFbTLY3zxT6vvuFFOkBMRHpbuDakmpfBoneBu/MAqH9Rooiu3ngDEwC
         N8BkDncTBMj0VtsLyWCz4DBfOQPume/bfHETYPaWTUpHNaVZBCLogJBmlvay+Ut1Y9fV
         mpbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=V3bTaQ1RYb35fMQheLr/L3CIid9YdUVh3NjbfiRt7+E=;
        b=ZBy3vc96/NAfmCkMiICTFCvl3l5YMOPJkqDANojQ3R2zm4q2aY6f7K9n2HxJ247N5Q
         /onIWz5Yr8b5JxLS3TLnO4vipJydSuVOdI+p/8D6JaSHGPYD8kqgHy+nrQjdcvH0lnxO
         JsjVRaUP6Bk4LYHSwCpxD4Rb3Q9UcU3Nh2Ux/1G5XhE8NpBcs9pLDIrqgHtzNqdgsQHo
         JxClJv1W2VsLSfLBgWYw/jlRYWnrqpXdT27Um3rfALNXVscDZMtNvqHoNqigOsHip7av
         KcyQ3iPWW+Yc4HTJNTMGYfqhdy5XQVqZdQdEeDKLLxLj1rx8FKMj0FmeVuZZiKvv409s
         0g+A==
X-Gm-Message-State: APjAAAXD2fhuffUWuDmgcz73HKo6lks0WRxB5f15dS5S3rq+wJ/XGEva
        4awha8pD6fTQMkfMTIi7lES++INJd6b/5jqkrk/3krTZwwcQjvRErqSmduUBjPb4XnX/fJjozmZ
        MeTbB2+Xp2fTwM5tUSkiRHhCHtlTCQM2/AyR7SIQ6AHiUf2EEgfMEiQ==
X-Google-Smtp-Source: APXvYqxOaQ90tT0TphIlxV16N1sWi9MDntnDlUUYzt4pclbnIspGit9imEr4x4WIZEE7MtEQmXanjfE=
X-Received: by 2002:a63:f941:: with SMTP id q1mr35286334pgk.350.1565713595730;
 Tue, 13 Aug 2019 09:26:35 -0700 (PDT)
Date:   Tue, 13 Aug 2019 09:26:27 -0700
In-Reply-To: <20190813162630.124544-1-sdf@google.com>
Message-Id: <20190813162630.124544-2-sdf@google.com>
Mime-Version: 1.0
References: <20190813162630.124544-1-sdf@google.com>
X-Mailer: git-send-email 2.23.0.rc1.153.gdeed80330f-goog
Subject: [PATCH bpf-next v3 1/4] bpf: export bpf_map_inc_not_zero
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rename existing bpf_map_inc_not_zero to __bpf_map_inc_not_zero to
indicate that it's caller's responsibility to do proper locking.
Create and export bpf_map_inc_not_zero wrapper that properly
locks map_idr_lock. Will be used in the next commit to
hold a map while cloning a socket.

Cc: Martin KaFai Lau <kafai@fb.com>
Cc: Yonghong Song <yhs@fb.com>
Acked-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 include/linux/bpf.h  |  2 ++
 kernel/bpf/syscall.c | 16 +++++++++++++---
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index f9a506147c8a..15ae49862b82 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -647,6 +647,8 @@ void bpf_map_free_id(struct bpf_map *map, bool do_idr_lock);
 struct bpf_map *bpf_map_get_with_uref(u32 ufd);
 struct bpf_map *__bpf_map_get(struct fd f);
 struct bpf_map * __must_check bpf_map_inc(struct bpf_map *map, bool uref);
+struct bpf_map * __must_check bpf_map_inc_not_zero(struct bpf_map *map,
+						   bool uref);
 void bpf_map_put_with_uref(struct bpf_map *map);
 void bpf_map_put(struct bpf_map *map);
 int bpf_map_charge_memlock(struct bpf_map *map, u32 pages);
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 5d141f16f6fa..cf8052b016e7 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -683,8 +683,8 @@ struct bpf_map *bpf_map_get_with_uref(u32 ufd)
 }
 
 /* map_idr_lock should have been held */
-static struct bpf_map *bpf_map_inc_not_zero(struct bpf_map *map,
-					    bool uref)
+static struct bpf_map *__bpf_map_inc_not_zero(struct bpf_map *map,
+					      bool uref)
 {
 	int refold;
 
@@ -704,6 +704,16 @@ static struct bpf_map *bpf_map_inc_not_zero(struct bpf_map *map,
 	return map;
 }
 
+struct bpf_map *bpf_map_inc_not_zero(struct bpf_map *map, bool uref)
+{
+	spin_lock_bh(&map_idr_lock);
+	map = __bpf_map_inc_not_zero(map, uref);
+	spin_unlock_bh(&map_idr_lock);
+
+	return map;
+}
+EXPORT_SYMBOL_GPL(bpf_map_inc_not_zero);
+
 int __weak bpf_stackmap_copy(struct bpf_map *map, void *key, void *value)
 {
 	return -ENOTSUPP;
@@ -2177,7 +2187,7 @@ static int bpf_map_get_fd_by_id(const union bpf_attr *attr)
 	spin_lock_bh(&map_idr_lock);
 	map = idr_find(&map_idr, id);
 	if (map)
-		map = bpf_map_inc_not_zero(map, true);
+		map = __bpf_map_inc_not_zero(map, true);
 	else
 		map = ERR_PTR(-ENOENT);
 	spin_unlock_bh(&map_idr_lock);
-- 
2.23.0.rc1.153.gdeed80330f-goog

