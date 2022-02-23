Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9E674C0E8D
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 09:53:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239091AbiBWIx7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 03:53:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239090AbiBWIx5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 03:53:57 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7974D7B55B;
        Wed, 23 Feb 2022 00:53:29 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id o8so490004pgf.9;
        Wed, 23 Feb 2022 00:53:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iDb45oPj0ifDcB8Xoh2dodzalPDAwvLvo6tLmA+1g1A=;
        b=mjbK/Qvyky40bHpb9CMcZeTXTikILi0QdvNGlkl/xfbx4ehMMLyLVLBwG4UAHrjXJC
         qZ97pFWziKsT8Ay5h4ojKoZyq6NeXAh6ADGWvdRQa2t2iIkkdmV2eHSjj0U7qlbim6Pt
         FOYoBJP5rOCNKtQOZvrqlHbv5uETayn7kMpKlF8KWDXNKiHmjBGNDZWHjf+DZDKrSyua
         Lm6AqmUKEXj9hGreOdCtBvtMXNSDrHIgPQrlpdQq/UEKV8bD9T1yuxUEc8zw9Ok2X2Cx
         N3iRl6WixrLYYwWx9/RAIeCWXNAfflB6skCejDzhXl7Y0nrM4wBCthW0YvQBvuwFhJko
         ctiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iDb45oPj0ifDcB8Xoh2dodzalPDAwvLvo6tLmA+1g1A=;
        b=zK7TWib1MGdDn8GbDGLRy9sHiG69cgzLpzUsWXSvgPBDUaCYXn/kxj7fZYT2h4qFd/
         ofaWWLyaXya3vy7Wxrq+Gk+eicoGvJ7fV1JX2WT7MjiVXkVHLimNihIzBEgdjkNyIdvo
         i+eaQ8vh0c9Rs4N61dLgsqfprHzyFk41Sxi6Zvw7oWNSBsgcvcKrE5/z89nIgc0pvaHV
         S/eD6P/dV9Jk0qoDsBMXAyBttZeeFfjOqy3rr+qKqKX3XsQc9O4tCgMllgYI/1BYpO9Z
         orItWqqgtS501u4OaeJ96uo6YQTTqujcCG9O5bwIH/j8H3c5qTQYDvXj1B2+V09woR9G
         StqA==
X-Gm-Message-State: AOAM531zDWZAyhVzq3R0ReaDEaxUiGK01fDklDDT+b8ylnWg2xQdEqzm
        Ln/2fk2zXEY18WLH+HjAQBssuALfPl2Vp9PpnNc=
X-Google-Smtp-Source: ABdhPJx/R0IJt/LaaJ2AfxqrABa8uf/z9Mb2sxVMk8u3hvcBKdcmjiDWBmzbbR8L5ikg9VGcY06oyQ==
X-Received: by 2002:a63:5d09:0:b0:372:9a55:bf89 with SMTP id r9-20020a635d09000000b003729a55bf89mr22668044pgb.321.1645606408731;
        Wed, 23 Feb 2022 00:53:28 -0800 (PST)
Received: from localhost.localdomain ([43.132.141.8])
        by smtp.gmail.com with ESMTPSA id ft9sm2043174pjb.4.2022.02.23.00.53.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Feb 2022 00:53:28 -0800 (PST)
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
Subject: [PATCH bpf-next] libbpf: Simplify the find_elf_sec_sz() function
Date:   Wed, 23 Feb 2022 16:52:44 +0800
Message-Id: <20220223085244.3058118-1-ytcoode@gmail.com>
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

