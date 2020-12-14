Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6887B2DA136
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 21:14:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503101AbgLNUM4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 15:12:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503086AbgLNUMZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 15:12:25 -0500
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EA2FC0617A7;
        Mon, 14 Dec 2020 12:11:36 -0800 (PST)
Received: by mail-ot1-x32e.google.com with SMTP id 11so17026629oty.9;
        Mon, 14 Dec 2020 12:11:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=opfRPH7/5Ygcvu8PVbcBIUkauhhzFK5c8dPVoi/d7pI=;
        b=E+jnUsXxWviLRRfLL+l4oUhWA62lMNJgnIiP668fkpej1LOjtj2lvGDF1w7P5F7vWV
         RWazJ9flLUdPyARwJC0m9pjcAYUBLGyXBrL/ANtPFCKZmrflZcydPy+Anu6JSnKSk9iD
         B6UanvngCAl9R9owd0gRDexcM9MXbhaXxgPcXhje3NCYWomdMEXUmlqGGSfBnQSXhF9z
         SZls60dzb/4MRNTRfI4DPoz+xdshUhDX0wC9DrqrV4wBllNewwKoHVleG1NQSPEH11vc
         cCO7T7QK6ixcvSBF2hhV/HrmYI9bySR45Z4Mef7CSaKcG8UbPgjUOLZ+XWQUtwrmW7lS
         NMCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=opfRPH7/5Ygcvu8PVbcBIUkauhhzFK5c8dPVoi/d7pI=;
        b=LIYC4Mq6Hh3a64sc2Z38WFYWuMfkzpnu11mzKBZ2rYMQhhGC+ZNt45VNRUpq3DmDv5
         vPB9SHiKB1GNrxu1FwRtkQ7fP+xPxYliJcVSF3w0hYgMJjkOjXAsoJyKDea6c7iIc7/N
         GymKd5JNNuSI8cWUslALej6/Wb7b9m8rmyS3ZeAejdF9RK1KizFurK514QtnSX2/RUQR
         E/ow9m0NvV73IDsoJICG6DHYhAduKblGLx50BG3YGzySel3RhMPI5RXeaRkCKqJ2/JLI
         X0XlLuwEBXtU2Vc6SSV9YgwH1pt9XPEkpUdnvNAdioKREOCV6CfwZUU8NhIVrkBydx0C
         KTvA==
X-Gm-Message-State: AOAM533Jxbpp3jxdNFQC5hE3IvvzvDeFc1ci8WScKeurJQYA1H5MTsfw
        d88Uq47jkKV6byWd2KlRnnie61ydFp9J9g==
X-Google-Smtp-Source: ABdhPJzTnvIVLEIpm76mSDP8tTDwwGMBJlJBgfichUH2q/uxHdWfVt5bn1GAilUFyiUwyvqX66k9kw==
X-Received: by 2002:a9d:27e9:: with SMTP id c96mr20504771otb.15.1607976695733;
        Mon, 14 Dec 2020 12:11:35 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:3825:1c64:a3d3:108])
        by smtp.gmail.com with ESMTPSA id h26sm3905850ots.9.2020.12.14.12.11.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 12:11:35 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        Andrey Ignatov <rdna@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Dongdong Wang <wangdongdong.6@bytedance.com>
Subject: [Patch bpf-next v2 5/5] selftests/bpf: add timeout map check in map_ptr tests
Date:   Mon, 14 Dec 2020 12:11:18 -0800
Message-Id: <20201214201118.148126-6-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201214201118.148126-1-xiyou.wangcong@gmail.com>
References: <20201214201118.148126-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

Similar to regular hashmap test.

Cc: Andrey Ignatov <rdna@fb.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Dongdong Wang <wangdongdong.6@bytedance.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 .../selftests/bpf/progs/map_ptr_kern.c        | 20 +++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/tools/testing/selftests/bpf/progs/map_ptr_kern.c b/tools/testing/selftests/bpf/progs/map_ptr_kern.c
index 34f9880a1903..f158b4f7e6c8 100644
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
+	VERIFY(timeout_hash->elem_size == 72);
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

