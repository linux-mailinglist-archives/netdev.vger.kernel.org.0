Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B56283DA8DA
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 18:21:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232114AbhG2QVF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 12:21:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231755AbhG2QUt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 12:20:49 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 312D5C0613CF
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 09:20:46 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id b128so4082322wmb.4
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 09:20:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GLAH0UGomdUat0GatMlVuuZxkfmHz9v5KV19sL9pJ5o=;
        b=v3x8PWC4siRBKA6XN/dbpeJJAURFGja0rv6yXY3XF5iKlWwU/OCiJ5A4tepDF31VUL
         AraSFvisTTJAE/oHdUf99FAH3S5mtgeg7FG/dwjnMvksrKgRfbPTUn0eKCIa9Bn6pqLu
         rRYnFwrzS/t37SJGShz8ffttnnODwGj67cw9FVIvAxKhkzLuF4UGErcY7uha6RaMxVBj
         LwfdIiQhDx6dO7pqYrmlE64jXV+b9qDAjxN7YCe0ri4wIo8R6Q6Lx4LFp/voEUTspRmS
         71OH4uOWtr+tcNNWBo95V2Ksi/Psgd8M11Vjyu0rFgW+ZX8VWPG35ThEeZZsEqpwYZE2
         8moA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GLAH0UGomdUat0GatMlVuuZxkfmHz9v5KV19sL9pJ5o=;
        b=FmGnNRnn/+YsNPZ5wNFN3/CbVm9UalR4JYi2f+xIo/0H2IKe2t1iJ57hYRx+FjD6d/
         D1kJ53cRh6J9mvzybmQIWlJhPdzFF9iG6UX6rgbRCUq+X5/80Ovfkxww20XBnacYUbCy
         pxf0G+L6sAUWHZRiutPuxa4PjmatoEqFxzoLrx0tyELkjV/wPtd1FuWKh8kL6QA6n6Yk
         ttY0rMXocj5uAHmGTQCe4jzUDh2Lk0k1hwx4yo3MsUlH8MkwdjvVaEMPi2/6LNuxTbMs
         jJ+Uq07zr0+EuIhUzsX9Mjs6wcubUz7+3QWO8o7xQ0Txm0haRl3vkZ3F7mAkJS5yateQ
         W6sQ==
X-Gm-Message-State: AOAM530LfdwXzWy3oRc6P5FJPFW3VJwgyYh5NA+OxRHLhPaQISknggBm
        zQXMXgzhgWfVIBytOqMbO7b22g==
X-Google-Smtp-Source: ABdhPJyFWIZLqWsppsfu4zePJLVoOV33Wp4buOgmpKS9ZSqax4M268T4rOSvk9BKoJ02UeRrse6T0g==
X-Received: by 2002:a7b:cc16:: with SMTP id f22mr15212938wmh.99.1627575644791;
        Thu, 29 Jul 2021 09:20:44 -0700 (PDT)
Received: from localhost.localdomain ([149.86.66.250])
        by smtp.gmail.com with ESMTPSA id c10sm3854853wmb.40.2021.07.29.09.20.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 09:20:44 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>,
        John Fastabend <john.fastabend@gmail.com>
Subject: [PATCH bpf-next v3 7/8] libbpf: add split BTF support for btf__load_from_kernel_by_id()
Date:   Thu, 29 Jul 2021 17:20:27 +0100
Message-Id: <20210729162028.29512-8-quentin@isovalent.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210729162028.29512-1-quentin@isovalent.com>
References: <20210729162028.29512-1-quentin@isovalent.com>
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
 tools/lib/bpf/btf.h      | 1 +
 tools/lib/bpf/libbpf.map | 1 +
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index 948c29fee447..cafa4f6bd9b1 100644
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
 		return libbpf_err_ptr(-errno);
 
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
index a6039ca66895..358046ffc7bd 100644
--- a/tools/lib/bpf/btf.h
+++ b/tools/lib/bpf/btf.h
@@ -44,6 +44,7 @@ LIBBPF_API struct btf *btf__parse_elf_split(const char *path, struct btf *base_b
 LIBBPF_API struct btf *btf__parse_raw(const char *path);
 LIBBPF_API struct btf *btf__parse_raw_split(const char *path, struct btf *base_btf);
 LIBBPF_API struct btf *btf__load_from_kernel_by_id(__u32 id);
+LIBBPF_API struct btf *btf__load_from_kernel_by_id_split(__u32 id, struct btf *base_btf);
 LIBBPF_DEPRECATED_SINCE(0, 6, "use btf__load_from_kernel_by_id instead")
 LIBBPF_API int btf__get_from_id(__u32 id, struct btf **btf);
 
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 3a9c6939301e..5aca3686ca5e 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -376,6 +376,7 @@ LIBBPF_0.5.0 {
 		bpf_program__attach_kprobe_opts;
 		bpf_object__gen_loader;
 		btf__load_from_kernel_by_id;
+		btf__load_from_kernel_by_id_split;
 		btf__load_into_kernel;
 		btf_dump__dump_type_data;
 		libbpf_set_strict_mode;
-- 
2.30.2

