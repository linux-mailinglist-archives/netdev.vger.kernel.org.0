Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FC804C0E4F
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 09:34:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238999AbiBWIeb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 03:34:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233549AbiBWIe2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 03:34:28 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A970674C4;
        Wed, 23 Feb 2022 00:34:02 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id j10-20020a17090a94ca00b001bc2a9596f6so2024409pjw.5;
        Wed, 23 Feb 2022 00:34:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iDb45oPj0ifDcB8Xoh2dodzalPDAwvLvo6tLmA+1g1A=;
        b=pZyB5i3EDjAvoOu1W4jIwUnpSx7RWt7r5xjs0PYS8CWbj9v/+h6LN5hErKk9z+R5tF
         3MK33kzZg+4iafVWLruxFp+YPsCSgYshqQy5MwK6eYG9h0d3tlqTJ6od746GCspi3onX
         xnO7jWcH5ymHmNkpRplsON3xjlfiMKGCfYXm+GpIHnUtRHzNQqUYj+lTAvPH/CrMK6EY
         snxwzaLrt4fp8VbMaoyw8FLwrR9702Qy/U4H0gjia+elRMlqIQEJPvDbzyvqBJa/QKPh
         6kH0c7Y2exw98Im4vIstHP54myt2aWXNIzXBi0/6htlpvmdWWBJS7lGkdO4dJxBn7Cb/
         H6hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iDb45oPj0ifDcB8Xoh2dodzalPDAwvLvo6tLmA+1g1A=;
        b=wRZt2jF9Q9Q2dv69l+QYBDUP2Fybnilnk3PVqFFxN4ETNpe8QOY2/rQXygs5hj7AMT
         e5n3n8mYTIz9YgiHpbnaBfj+/41rkR7Kw/IJYY0QI7driHpaCKi5i120L0PFcfllATrb
         pTKqAf0tbw/j9Xnsi5RtgiKi+QMjuJZLdsU/T06H9sTuGzn2u2ZY6rUKyEIGTE+Bfpy7
         yrvKSRgSA2vt2687pprcHf63im1iLDat6MsMKNIw7vEHIOGRbvMCY7n5MpBfNW3wy7WK
         WJeTce03gKVPiPGodQY9J12UC1+zv47PfpmCOZhteE2uvQrsI9F4OJ2C4s3QLdJSLpDW
         LCKA==
X-Gm-Message-State: AOAM533NBPVQpOK5d1RI+aSQfuDjVTmy/MjdtebqbWqvjWd8xJzHJI+Q
        hP3zjoLi74F2816f4TYv19KZLeom+M5zrKYPZho=
X-Google-Smtp-Source: ABdhPJxjyJEbWbvUjPn8qDp3Uys0pRB+Jj2L39nYmoHtTf0LFOWN1YRvivO9TAo6OOnscTXB4pYx9w==
X-Received: by 2002:a17:90a:ac1:b0:1b9:7dd3:ba5f with SMTP id r1-20020a17090a0ac100b001b97dd3ba5fmr8126134pje.178.1645605241389;
        Wed, 23 Feb 2022 00:34:01 -0800 (PST)
Received: from localhost.localdomain ([43.132.141.8])
        by smtp.gmail.com with ESMTPSA id bd14sm9338613pfb.165.2022.02.23.00.33.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Feb 2022 00:34:00 -0800 (PST)
From:   Yuntao Wang <ytcoode@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yuntao Wang <ytcoode@gmail.com>
Subject: [PATCH] libbpf: Simplify the find_elf_sec_sz() function
Date:   Wed, 23 Feb 2022 16:33:00 +0800
Message-Id: <20220223083300.3054673-1-ytcoode@gmail.com>
X-Mailer: git-send-email 2.35.0.rc2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The check in the last return statement is unnecessary, we can just return
the ret variable.

But we can simplify the function further by returning 0 immediately if we
find the section size and -ENOENT otherwise.

Thus we can also remove the ret variable.

Signed-off-by: Yuntao Wang <ytcoode@gmail.com>
---
 tools/lib/bpf/libbpf.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 7e978feaf822..776b8e034d62 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -1374,22 +1374,20 @@ static bool bpf_map_type__is_map_in_map(enum bpf_map_type type)
 
 static int find_elf_sec_sz(const struct bpf_object *obj, const char *name, __u32 *size)
 {
-	int ret = -ENOENT;
 	Elf_Data *data;
 	Elf_Scn *scn;
 
-	*size = 0;
 	if (!name)
 		return -EINVAL;
 
 	scn = elf_sec_by_name(obj, name);
 	data = elf_sec_data(obj, scn);
 	if (data) {
-		ret = 0; /* found it */
 		*size = data->d_size;
+		return 0; /* found it */
 	}
 
-	return *size ? 0 : ret;
+	return -ENOENT;
 }
 
 static int find_elf_var_offset(const struct bpf_object *obj, const char *name, __u32 *off)
-- 
2.35.0.rc2

