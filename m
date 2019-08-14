Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 679CF8DC04
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 19:38:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728562AbfHNRh6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 13:37:58 -0400
Received: from mail-qt1-f201.google.com ([209.85.160.201]:43842 "EHLO
        mail-qt1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728520AbfHNRh6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 13:37:58 -0400
Received: by mail-qt1-f201.google.com with SMTP id p56so9793289qtb.10
        for <netdev@vger.kernel.org>; Wed, 14 Aug 2019 10:37:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=AJSXkIdAVH1oaTxBLhQrKqbmftfzMmTC+dK8Oqetgno=;
        b=gWD4LQo02Rl1oO95HM3VIMxCmviZpwWy2/z7MX+XEJbBpGlneWo4vAmHB/d5S2Eoxn
         ueEusHgNpYPcSc6BvpuXDL36hDpPZxA4Op2hDVt0RjKuLbPTuvo5XJnHDJvIqGuPjF7J
         cTmP6L+Kmr7OthlmlMfcqZogyduQvvMStEUahLxl70sCRwJH3fxrjJCxmqSXYeewRCHB
         eSlYT3I8wB/Am3RWsI3aNCo995kfjlQyCe/VO/kYJqFFQeYI4ICQDS5u++8CJPTxHc3v
         mwnk0BCYqBYsx0gRTkJUPPFKZglRcyuDZGolgxq674x9g6qhEF9frlm8ztIg2GC2dtfT
         rpLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=AJSXkIdAVH1oaTxBLhQrKqbmftfzMmTC+dK8Oqetgno=;
        b=Nlol9vbCeU8uo06fzqY7owI+sw2tBGaMpYuY7+CU9Yj0yK2oeihbepARorPStribIF
         PJL/u6uJawjBGWMWTciZnBhi4dx5DCvrxkojWBXSIJRIMZZNUvVMT3dBUEb77h51uHeR
         gL6IzCvy2I58h+6fqtQ5ERfXSFZWdFC2qHItF0u3yp4ccVDILoeb2woIFhdBRyWkBZao
         VtmI3ZogXy31zrKLvb6j88QFbHS34HABp81PnLOK5PDD3vssafOs5E5Q0MsU5mgwHfoT
         cTwjpJsSOIFMlnTrl1yRIm0fYSh2pqblUB4eN0fpWQ3YN89Ia7HfjjTneuYbE4cL1INO
         +Agw==
X-Gm-Message-State: APjAAAU2eHZNz6DWK52pKc5LZ+O+A9TNwbyLmct6tKxRh7ypP7Kn4Xhn
        sKSMgzbqFq/J0jiXiLURs1O2+IPI/ofhwZNZjVzGEWvrLiXW5sFDVTDKaUHHNQQ09n+bK/6R8DD
        P2WbvrXwdJZw2o27sXpDSlIu4fYu3Fzc+3zhuPO5DuRAASIw5fKf/kQ==
X-Google-Smtp-Source: APXvYqzI633zXBTyAMNZ8L6CuGXCE7Cfa6sHI4mPchxTrzKnXdkKMvhTHcr7OTkgZadJR7J65DkHHyw=
X-Received: by 2002:ae9:f804:: with SMTP id x4mr584188qkh.178.1565804277231;
 Wed, 14 Aug 2019 10:37:57 -0700 (PDT)
Date:   Wed, 14 Aug 2019 10:37:48 -0700
In-Reply-To: <20190814173751.31806-1-sdf@google.com>
Message-Id: <20190814173751.31806-2-sdf@google.com>
Mime-Version: 1.0
References: <20190814173751.31806-1-sdf@google.com>
X-Mailer: git-send-email 2.23.0.rc1.153.gdeed80330f-goog
Subject: [PATCH bpf-next v4 1/4] bpf: export bpf_map_inc_not_zero
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
Acked-by: Martin KaFai Lau <kafai@fb.com>
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

