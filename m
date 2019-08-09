Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3966187F09
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 18:10:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436979AbfHIQKp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 12:10:45 -0400
Received: from mail-pf1-f202.google.com ([209.85.210.202]:42072 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407417AbfHIQKo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 12:10:44 -0400
Received: by mail-pf1-f202.google.com with SMTP id 21so61740703pfu.9
        for <netdev@vger.kernel.org>; Fri, 09 Aug 2019 09:10:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=L4yZea8IEn3vpqRXOnaZAYea/jIcVQkwlGCXfxu4CzM=;
        b=aHOB42o/3TrG5n4CNpOVqpv3Max3ijN3TNu8UU45xOUuSHHlQ4xFQUDOdhDu189t90
         54RVRBZqCIDcGZ+cbQCjjiWBy0n7I4dpdMXyYWvF5+PXsrTyoIvZ0EJbFA1R/6S9PZdA
         8dXWquAuCkMCyg2FWvB2wRLGY5y44cij1iOnyjWRhdWLAnuhksn/kChG3+NC01atTRsS
         b5RwiWF3tvAMYT8VcUdEztoJFMGzzUAjDfPtqrqRgMtNvknE7u96CkNYGMviTxdag6OC
         kHYidx/xcTAfpHENVjecQnoZUoxC64ci43qYYKLoi5Ncaa3IDNgaIuKt6twiRDxMc19S
         R/Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=L4yZea8IEn3vpqRXOnaZAYea/jIcVQkwlGCXfxu4CzM=;
        b=Fe3AMlENRcyGFz/2KtF6hvinkiWQ/g8tqJ9QXqQAuBbkxZ2f6Zf6wQOAWyR5SaiQb4
         1HrfhaBdIDgRk409oQGn78DDtmvG/600rtGEofpEWnHU/E4+eU6LtbzDbwgDwNW05FRR
         kXnTY4wa1F8PriZuDrIu62s8aD/eNwYVY8nvyazTprXcWt4uDLhN88t+0KIRWNK8ELGx
         KjH+BU9TjhtJFNLJuHBSzz8MnsBFVQQBGoCAWQJjLHJAOUSJ4r6no2rYva/XnL8+6O8p
         ScEfNgqjECtGfeYxRKUNY7sIQmEulAbQI4dVO9zx8h8bvd4LuRseQHd41DTAOkgDRZWO
         tiBA==
X-Gm-Message-State: APjAAAXQO5JNoOrZRdn0l2LRgGWFo/kg8Q237UWYlmmNa0kwGF5b71Fk
        YIpqZLdvp5lsP0FolzXdffO/hT8TcOzpsXzaVVYOvBgYA8VUCd5ubt4ogFAT+ptdCA/tKO4Ifr2
        LvNs3OCf+W7Ssi9QToz0Bj/8cRsSgP+XZRiCxc04xHkxcCIKzOKGhrg==
X-Google-Smtp-Source: APXvYqy4ECcHfbz5fv44uR/I3ON0BpzynLmhBfgB1ADxD50hugu4ALYCZnpr/18drES/BQq9GCUjz3A=
X-Received: by 2002:a63:f304:: with SMTP id l4mr18118367pgh.66.1565367043089;
 Fri, 09 Aug 2019 09:10:43 -0700 (PDT)
Date:   Fri,  9 Aug 2019 09:10:35 -0700
In-Reply-To: <20190809161038.186678-1-sdf@google.com>
Message-Id: <20190809161038.186678-2-sdf@google.com>
Mime-Version: 1.0
References: <20190809161038.186678-1-sdf@google.com>
X-Mailer: git-send-email 2.23.0.rc1.153.gdeed80330f-goog
Subject: [PATCH bpf-next v2 1/4] bpf: export bpf_map_inc_not_zero
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

