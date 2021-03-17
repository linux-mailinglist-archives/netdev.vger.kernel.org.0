Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1F4433F4A1
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 16:53:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232085AbhCQPwd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 11:52:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232601AbhCQPwB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 11:52:01 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B911AC061760;
        Wed, 17 Mar 2021 07:54:20 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id g15so1281897pfq.3;
        Wed, 17 Mar 2021 07:54:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VX8xHL+87BW1KLwBi9gunx33qho2YZRZxASXIV7grFw=;
        b=O9LTjZNCsR9gSSAS+S8FvfugaFJ75IngmN7wDk/aTR6vvVj+58f7H+crABZO9DV+d2
         v7rUGLBY0T42bTYQvj+u1nUuKW15KVOzOAaeyembU52SXZMktL1TDX+ShLFSUgdy7ebD
         Buebn2I0ry8Et/OCCHpxEj6stBlHCeTVGI8iVq+le09+iCFBrB3PDH86FYmnmxtVmAYV
         rqQGHsFH5epsVYZ/jIOOdb4ws+0holHCI0SsdAx2HpyFGBSHP1weEUflFlNYmvuAgAGZ
         t7JvgoerfGrf4kuQhySJwtRtxzaQinU70aNmPckqAnsGu301M1K36ZJU8Q8dOOXWrtm1
         UdAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=VX8xHL+87BW1KLwBi9gunx33qho2YZRZxASXIV7grFw=;
        b=kjJze3HqKgJ1jDoSXs2rB1aiuxtqtM9kYjjE1jGsLayGAw+HPwJmXp26oIIf9OlUbF
         tb9Yix0kfQ3cFdJVWcwIxjl+y6aoEYC1VyEsTxf054jvNTuzaON9a+E7YzMgib76Fbkh
         9RWnlkoslEzLOAhy8ttDdJADgKj1jVHqVONws1CLvRDBwJCTGW5nt4oAhX/EdDEPZmNG
         V/WnOTaPRfjFM0evj8N0QOLkRmPtwchl4Yz8Hn5HBNnD6H4o6Ug92V2Hh1k5BUTpkhmK
         pgekBXM0TJbd4sOzPemUNgb51yUinN8Tyod6AaGxLqXpFqx5Mtv1qYtT7BKWLLUQJ8Ny
         VlMg==
X-Gm-Message-State: AOAM531K2t4gKtCfBMP1gF6ONFywzXKHf5AGMa6Fh19IGn80EP8VHeFw
        cGURw1LQ2m4YMZKs4/hWYnQ=
X-Google-Smtp-Source: ABdhPJwbAGPp4ws0MaZtGJkBqm1DZmMs5QuR3yhHECr1wnRYWABNXQoGOhIDe/BozfrUnBjzWKgEbg==
X-Received: by 2002:a65:6a48:: with SMTP id o8mr2937671pgu.424.1615992860178;
        Wed, 17 Mar 2021 07:54:20 -0700 (PDT)
Received: from balhae.roam.corp.google.com ([101.235.31.111])
        by smtp.gmail.com with ESMTPSA id a19sm19926273pfn.181.2021.03.17.07.54.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 07:54:19 -0700 (PDT)
Sender: Namhyung Kim <namhyung@gmail.com>
From:   Namhyung Kim <namhyung@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] libbpf: Fix error path in bpf_object__elf_init()
Date:   Wed, 17 Mar 2021 23:54:14 +0900
Message-Id: <20210317145414.884817-1-namhyung@kernel.org>
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When it failed to get section names, it should call
bpf_object__elf_finish() like others.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/lib/bpf/libbpf.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 2f351d3ad3e7..8d610259f4be 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -1194,7 +1194,8 @@ static int bpf_object__elf_init(struct bpf_object *obj)
 	if (!elf_rawdata(elf_getscn(obj->efile.elf, obj->efile.shstrndx), NULL)) {
 		pr_warn("elf: failed to get section names strings from %s: %s\n",
 			obj->path, elf_errmsg(-1));
-		return -LIBBPF_ERRNO__FORMAT;
+		err = -LIBBPF_ERRNO__FORMAT;
+		goto errout;
 	}
 
 	/* Old LLVM set e_machine to EM_NONE */
-- 
2.31.0.rc2.261.g7f71774620-goog

