Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6A302F9069
	for <lists+netdev@lfdr.de>; Sun, 17 Jan 2021 05:23:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728042AbhAQEXh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jan 2021 23:23:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727629AbhAQEXX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jan 2021 23:23:23 -0500
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99AB4C061757;
        Sat, 16 Jan 2021 20:22:42 -0800 (PST)
Received: by mail-oi1-x230.google.com with SMTP id d203so14205904oia.0;
        Sat, 16 Jan 2021 20:22:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6cUrGuJbAAzbmOZxLUmIXIAt0gGPRKf0H8ukS5QNZuo=;
        b=Jd2EBia9tnghecfC5Dbu+OMDe9c8JNmsik+oPtczPwrpfvS8Dfhj2xkPzojPoAXlYv
         ZoDP9AxxK3r7N/qX8VrHYJ7rFrIypWuI7/nLxovXDiTdTgn2JvYoDHgdPutTAxxdOe9m
         02wPjrSeRYhqVYc6Aurt/ANHE5FOZv5/kvNhlQipqHHkbTIBlWgICXZo2aP5jcWuPCz+
         EAA2CsIYYzBUTfx5oGVtg9wZMLoxwGUwPgxtSJ1pNUI2ZlbtBfc31CnN7HD6Dh8HIoqY
         75fE1SQQKA2LPjXrFCYNI4U1RpKwZaVlitS9hY5K8OUy4FQKIZeayh8z8FkD697Q8YD0
         kKPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6cUrGuJbAAzbmOZxLUmIXIAt0gGPRKf0H8ukS5QNZuo=;
        b=DncPz+C2XTP14/wCA+GJU5i4pVV5xiDLRccfIQJ9YiJL/O0LfXL/SL2qkxC1kBzX3X
         4ZTiVu3ieIA/IAhxlPebnnplTGUlRcFsgBDu/upk9jb6qoGVO/p1tfYQ7DT+lhVc4ITy
         2wyoobP7Tjsel7CPtxgMAfhhyAkE+tXXHGgHPlJBcsZNNFbgsURQRVJpr+NWt24vYLG6
         ASOrLe9+NOFg+u3Vf+IdI2oRntYq72vMAXLyxjnW7E4IAxRhcdz91brF6yrcUqfAm0IX
         bzkotI4qSgXijbzzk3LsZNqhWqJkEeVBGxzoyj90tAt5X4PAOgfIcX8TeTSo4rwpcWml
         a2MA==
X-Gm-Message-State: AOAM532+CO4+nVaxc0QU6ZSpFG9tPEtAs+JUmwAd2ncwszihMhCjAtup
        yWBpvJX3++qPD7rWnhygOrVMXsguYyECMA==
X-Google-Smtp-Source: ABdhPJxkieVF8AWr9ff/GYSZamkS5xJ/OoIXpsYP/hMerLx95TLPHXfu2zkKsF2ursROiaA3J0NFBQ==
X-Received: by 2002:aca:5f07:: with SMTP id t7mr9475748oib.39.1610857361782;
        Sat, 16 Jan 2021 20:22:41 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:1c14:d05:b7d:917b])
        by smtp.gmail.com with ESMTPSA id l8sm537444ota.9.2021.01.16.20.22.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Jan 2021 20:22:41 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        Andrey Ignatov <rdna@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Dongdong Wang <wangdongdong.6@bytedance.com>
Subject: [Patch bpf-next v4 3/3] selftests/bpf: add timeout map check in map_ptr tests
Date:   Sat, 16 Jan 2021 20:22:24 -0800
Message-Id: <20210117042224.17839-4-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210117042224.17839-1-xiyou.wangcong@gmail.com>
References: <20210117042224.17839-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

Similar to regular hashmap test.

Acked-by: Andrey Ignatov <rdna@fb.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Dongdong Wang <wangdongdong.6@bytedance.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 .../selftests/bpf/progs/map_ptr_kern.c        | 20 +++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/tools/testing/selftests/bpf/progs/map_ptr_kern.c b/tools/testing/selftests/bpf/progs/map_ptr_kern.c
index d8850bc6a9f1..424a9e76c93f 100644
--- a/tools/testing/selftests/bpf/progs/map_ptr_kern.c
+++ b/tools/testing/selftests/bpf/progs/map_ptr_kern.c
@@ -648,6 +648,25 @@ static inline int check_ringbuf(void)
 	return 1;
 }
 
+struct {
+	__uint(type, BPF_MAP_TYPE_TIMEOUT_HASH);
+	__uint(max_entries, MAX_ENTRIES);
+	__type(key, __u32);
+	__type(value, __u32);
+} m_timeout SEC(".maps");
+
+static inline int check_timeout_hash(void)
+{
+	struct bpf_htab *timeout_hash = (struct bpf_htab *)&m_timeout;
+	struct bpf_map *map = (struct bpf_map *)&m_timeout;
+
+	VERIFY(check_default(&timeout_hash->map, map));
+	VERIFY(timeout_hash->n_buckets == MAX_ENTRIES);
+	VERIFY(timeout_hash->elem_size == 64);
+
+	return 1;
+}
+
 SEC("cgroup_skb/egress")
 int cg_skb(void *ctx)
 {
@@ -679,6 +698,7 @@ int cg_skb(void *ctx)
 	VERIFY_TYPE(BPF_MAP_TYPE_SK_STORAGE, check_sk_storage);
 	VERIFY_TYPE(BPF_MAP_TYPE_DEVMAP_HASH, check_devmap_hash);
 	VERIFY_TYPE(BPF_MAP_TYPE_RINGBUF, check_ringbuf);
+	VERIFY_TYPE(BPF_MAP_TYPE_TIMEOUT_HASH, check_timeout_hash);
 
 	return 1;
 }
-- 
2.25.1

