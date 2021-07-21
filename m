Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55CEF3D12A5
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 17:38:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240053AbhGUO5t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 10:57:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240038AbhGUO5n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 10:57:43 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 694D2C061798
        for <netdev@vger.kernel.org>; Wed, 21 Jul 2021 08:38:17 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id d12so2633458wre.13
        for <netdev@vger.kernel.org>; Wed, 21 Jul 2021 08:38:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fnOxE/tjyREC4ZyB6l9KZyxHyA5SXgSGw3IqkFpMRkw=;
        b=BWy+BqtQHYwnvDrTJ0vM3lU8Rt87nFtAXLqsNZ0m5ThbkImzabkh2c/VpIXLE7BGCN
         u2ROwRKtxTsPPXGJoOsPhVC09m/lDS2EJy6lXUGM0ZSTsnCz03UYJ14SbdkdzHxbDaXs
         hIyMPkV0mAmvs2jncDwGaEDo2KyGJx6zh5EqswvxAGWKD9kJpt67SpR60fcHZfmd3pPF
         fKRwvb8YkhjXex/EGSCOoF2084EH6JdjhBLrYHeDJQhksVYPjBdn0Wrjt61dqtydFN6S
         2jc9zcLZy5I1MJbAoO+eYLCveGETpjR4JH+5NmC+YvcYNgYLA7vW5okaDuu/CEnzIlco
         WIwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fnOxE/tjyREC4ZyB6l9KZyxHyA5SXgSGw3IqkFpMRkw=;
        b=Z4+vZ30EKFFIOJnchN4GUpKkWu9GPt11J7/7XS6Mi8xILITX17CB6mcTpqe0lZApkp
         G54Eq1nUxXcHvLpC74usJirFHU+vZA6hgTj5lcPCtpoo2GQ6RtlowP1F04m/r0xQJSov
         Ks07vAQ2CIsatfB2yZsjszlkUiIp62VgP29AW/G5h8vZhQhUCyVVyhs+bHw2rZl5y6f2
         dN09T4dgiwdCaWBfmdZomIwSzGssYYYl7tAEiSsVFdBXkIS7Q13vPKpMyQd/x7oHzAYJ
         SAT/O1JEhi4iL1T/1d0JW//28xHSoOSJdOyCQrhaWWLKTFCzTi5+ZstmK7agbvw8eScD
         9m1A==
X-Gm-Message-State: AOAM5338UeGmL0E+ygHM2VpN50I0VvbSMg3+6X05UJxXWPO9pm1U6zur
        ctjFRc3T26Bgf0CnQzoifFdIbw==
X-Google-Smtp-Source: ABdhPJz/62r0jFfqQ6sCgbtWSgKcpXV+g9h6K7jglfCXoKIaPf+lKd5OtYK/Mb4d6No2lsPW8Qoz/g==
X-Received: by 2002:a5d:65cb:: with SMTP id e11mr45268304wrw.105.1626881896030;
        Wed, 21 Jul 2021 08:38:16 -0700 (PDT)
Received: from localhost.localdomain ([149.86.71.195])
        by smtp.gmail.com with ESMTPSA id n18sm26209714wrt.89.2021.07.21.08.38.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jul 2021 08:38:15 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>,
        John Fastabend <john.fastabend@gmail.com>
Subject: [PATCH bpf-next v2 4/5] libbpf: add split BTF support for btf__load_from_kernel_by_id()
Date:   Wed, 21 Jul 2021 16:38:07 +0100
Message-Id: <20210721153808.6902-5-quentin@isovalent.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210721153808.6902-1-quentin@isovalent.com>
References: <20210721153808.6902-1-quentin@isovalent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new API function btf__load_from_kernel_by_id_split(), which takes
a pointer to a base BTF object in order to support split BTF objects
when retrieving BTF information from the kernel.

Reference: https://github.com/libbpf/libbpf/issues/314

Signed-off-by: Quentin Monnet <quentin@isovalent.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
---
 tools/lib/bpf/btf.c      | 9 +++++++--
 tools/lib/bpf/btf.h      | 2 ++
 tools/lib/bpf/libbpf.map | 1 +
 3 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index 6654bdee7ad7..38a901e3a483 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -1383,7 +1383,7 @@ struct btf *btf_get_from_fd(int btf_fd, struct btf *base_btf)
 	return btf;
 }
 
-struct btf *btf__load_from_kernel_by_id(__u32 id)
+struct btf *btf__load_from_kernel_by_id_split(__u32 id, struct btf *base_btf)
 {
 	struct btf *btf;
 	int btf_fd;
@@ -1392,12 +1392,17 @@ struct btf *btf__load_from_kernel_by_id(__u32 id)
 	if (btf_fd < 0)
 		return ERR_PTR(-errno);
 
-	btf = btf_get_from_fd(btf_fd, NULL);
+	btf = btf_get_from_fd(btf_fd, base_btf);
 	close(btf_fd);
 
 	return libbpf_ptr(btf);
 }
 
+struct btf *btf__load_from_kernel_by_id(__u32 id)
+{
+	return btf__load_from_kernel_by_id_split(id, NULL);
+}
+
 int btf__get_from_id(__u32 id, struct btf **btf)
 {
 	struct btf *res;
diff --git a/tools/lib/bpf/btf.h b/tools/lib/bpf/btf.h
index 3db9446bc133..c9407d57d096 100644
--- a/tools/lib/bpf/btf.h
+++ b/tools/lib/bpf/btf.h
@@ -69,6 +69,8 @@ LIBBPF_API const char *btf__name_by_offset(const struct btf *btf, __u32 offset);
 LIBBPF_API const char *btf__str_by_offset(const struct btf *btf, __u32 offset);
 LIBBPF_API int btf__get_from_id(__u32 id, struct btf **btf);
 LIBBPF_API struct btf *btf__load_from_kernel_by_id(__u32 id);
+LIBBPF_API struct btf *btf__load_from_kernel_by_id_split(__u32 id,
+							 struct btf *base_btf);
 LIBBPF_API int btf__get_map_kv_tids(const struct btf *btf, const char *map_name,
 				    __u32 expected_key_size,
 				    __u32 expected_value_size,
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index ca8cc7a7faad..eecf77227aeb 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -374,6 +374,7 @@ LIBBPF_0.5.0 {
 		bpf_map_lookup_and_delete_elem_flags;
 		bpf_object__gen_loader;
 		btf__load_from_kernel_by_id;
+		btf__load_from_kernel_by_id_split;
 		btf__load_into_kernel;
 		btf_dump__dump_type_data;
 		libbpf_set_strict_mode;
-- 
2.30.2

