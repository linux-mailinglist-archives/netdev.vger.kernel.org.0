Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 066394D7015
	for <lists+netdev@lfdr.de>; Sat, 12 Mar 2022 18:14:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232191AbiCLRPX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Mar 2022 12:15:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbiCLRPW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Mar 2022 12:15:22 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 987E2BC38;
        Sat, 12 Mar 2022 09:14:15 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id t14so10132197pgr.3;
        Sat, 12 Mar 2022 09:14:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Iwg/DPu16+zMt2tN/Rk8mJRCieE5sWNSvOHeRAAyzGM=;
        b=idR4FmDrGhy80aAK7BHwwFEO5HxxbEizRYQebRPK3u8fTXNWPeBXpNwTRD3YCLkNp2
         STBXvblBzuCOgz+Ohu+9CWpcPSo5ii4zZxqNESAR0t9mBxUYngEv0T5X7grRGiES8Pad
         gBQyk0TF3siDGvcMCREPpMkZKOU3aA/OK9VbOBLjgLkuCW6k76PKDzGwowb2jfppExZF
         4Mc/r8MDFW+Xa875JjhzsYcxF+YID38q8OFPo+5jADvelrfk6BBa/bNkPpiI1Rqlc6wM
         lDEvWyPKNk3r3L+7gryD1eu4HDB8AZhN9YQ0xE68PH5fVkATQlHII8xA0TH+n6JGHEAB
         1vIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Iwg/DPu16+zMt2tN/Rk8mJRCieE5sWNSvOHeRAAyzGM=;
        b=DFGYE9yd/KKtE0hadQGv41a8z/dQSXUpPWXHHi+WShhU7PFfJ5lprPudtC3PBXrRnR
         Q8hs1OPLv+jfIz7EOCEZyINR3ZOV0LMdlPDt8t6ehtQE4prEG+3EQHj940xL7jDEI2hQ
         Dlg3/pMmHEPNvVAWg4I5S0lgOes1XKd0PyzWuZ4VUFmOhOqyWi/Zq9OKLO2tdj6X6JkN
         1yhSmSgaduoAlzOvDQJCDa260HVSWNuruwDqxf14M/zx/jlbmw3qb9aAc/x633OETPHL
         yu2Wf+e/HsB+tiBGVcXYa9xKf6xRY0Q9O23tzhFTs19YkyZMCp5lcPW9FlKekUi4ZXKP
         xR9w==
X-Gm-Message-State: AOAM533NcM3nFewHHYVHiWnBVzOcBR4Lgc8zmWIJ550QGjVRaCoxSq9/
        fT6G5n12i/hQokjv2oJ5Zvc=
X-Google-Smtp-Source: ABdhPJz4tuxHTgmXP0IDOb7+WpXoxLJegDdQ5hzPD6DQHWpqQVBabG3QuLP1Kbng/1nv/IRQ7oWLvQ==
X-Received: by 2002:a65:48c8:0:b0:375:9c2b:ad33 with SMTP id o8-20020a6548c8000000b003759c2bad33mr13791239pgs.232.1647105254855;
        Sat, 12 Mar 2022 09:14:14 -0800 (PST)
Received: from localhost.localdomain ([223.212.58.71])
        by smtp.gmail.com with ESMTPSA id b21-20020a17090a551500b001b90ef40301sm13371718pji.22.2022.03.12.09.14.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Mar 2022 09:14:14 -0800 (PST)
From:   Yuntao Wang <ytcoode@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yuntao Wang <ytcoode@gmail.com>
Subject: [PATCH bpf-next] libbpf: Remove redundant check in btf_ext__new()
Date:   Sun, 13 Mar 2022 01:13:54 +0800
Message-Id: <20220312171354.661448-1-ytcoode@gmail.com>
X-Mailer: git-send-email 2.35.1
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

Since 'core_relo_len' is the last field of 'struct btf_ext_header', if
'xxx->hdr_len' is not less than 'offsetofend(xxx, core_relo_len)', then
'xxx->hdr_len' must also be not less than 'offsetofend(xxx, line_info_len)'.

We can check 'xxx->hdr_len < offsetofend(xxx, core_relo_len)' first, if it
passes, the 'xxx->hdr_len < offsetofend(xxx, line_info_len)' check will be
redundant, it can be removed.

Signed-off-by: Yuntao Wang <ytcoode@gmail.com>
---
 tools/lib/bpf/btf.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index 1383e26c5d1f..d55b44124c3e 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -2813,7 +2813,7 @@ struct btf_ext *btf_ext__new(const __u8 *data, __u32 size)
 	if (err)
 		goto done;
 
-	if (btf_ext->hdr->hdr_len < offsetofend(struct btf_ext_header, line_info_len)) {
+	if (btf_ext->hdr->hdr_len < offsetofend(struct btf_ext_header, core_relo_len)) {
 		err = -EINVAL;
 		goto done;
 	}
@@ -2826,11 +2826,6 @@ struct btf_ext *btf_ext__new(const __u8 *data, __u32 size)
 	if (err)
 		goto done;
 
-	if (btf_ext->hdr->hdr_len < offsetofend(struct btf_ext_header, core_relo_len)) {
-		err = -EINVAL;
-		goto done;
-	}
-
 	err = btf_ext_setup_core_relos(btf_ext);
 	if (err)
 		goto done;
-- 
2.35.1

