Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D2B44F0D4E
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 02:53:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376832AbiDDAzg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Apr 2022 20:55:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240987AbiDDAzf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Apr 2022 20:55:35 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2DEB639B;
        Sun,  3 Apr 2022 17:53:39 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id y10so7506674pfa.7;
        Sun, 03 Apr 2022 17:53:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yNiMC9MxNAVqib+SZgJ64s5pZC15kZoqX/VkezsKZbU=;
        b=A7WqEwsD/aUvHQ8X6WMd/LHTc2iOpLbQ6RzOtzK+70OO4r0OV1gzSUvIJ/eUBN/kZm
         LbDrm7jb3wjUd6pK3xKf3Brk2/rfiNQSMcag3JOEunkqcdFrlpV84yDNeZEl6R2p63fX
         vDenSLEN+t+QqnvXbjtyCT58Orv1T5ldIX3I9XNcELLSe1C+zDQsOX3I3QQeIWOvI1Os
         OD6IoUwl+jLZA7M6J2+VAr+oB15JkdTZ5m613Uf/MpgHc074HxXytLwVoo1L/36DNMTB
         IF+B92/88WWTfhi2YE+K0VDHPXA9z3GWoXkIo+qR+dn29G7i/EuOtOpKOJ97vIk7XwsP
         l7XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yNiMC9MxNAVqib+SZgJ64s5pZC15kZoqX/VkezsKZbU=;
        b=O+NpRXd8pziBh59mwKT+z+t2ND9VYjQQ93n9BfTdNIELCLmTaBjYR1iDRJ7Uoj70zY
         0CdgjoML7pHLNTbLgl3TIaNdWnnOaNQszgyP6ADqaPIo3NeCqWFdcNpHSs1mVJ1IFyqZ
         p0nLdS4D7olzPkHiVKsMDdOZT1w9lIbdVO8P9y6HfjDlbTRkl842bMFWaIHnsF6XUslU
         34b72HblCNd7cWkw+Du1LZg2iAhGYE/86WAxFOEQcDv16cXUQ32bgS1YFE2IPeCqINH+
         nMtEZ3kbloPnBYYyXo6ypIRikYQ14WNbaxm5kMvBEgTmYDMwrV96Vz68mruvkTE5coty
         oBgA==
X-Gm-Message-State: AOAM53210pCQ5qOP7eBge3c8aXjNYpROWp8AT/Ku6qBZPGYRAhA2BvPF
        PAMSEelwcE5q2WpPwMLmGGU=
X-Google-Smtp-Source: ABdhPJw/x073w6Z90xT359YpAOS5KIyzJB+bmchOhwkplxvv3ruSfxcQNW6brmHxBlUTfbm+oZaLtQ==
X-Received: by 2002:a05:6a00:1581:b0:4fa:e6d4:c3e6 with SMTP id u1-20020a056a00158100b004fae6d4c3e6mr21250956pfk.84.1649033619443;
        Sun, 03 Apr 2022 17:53:39 -0700 (PDT)
Received: from localhost.localdomain ([223.74.191.143])
        by smtp.gmail.com with ESMTPSA id d24-20020a637358000000b003823aefde04sm8658355pgn.86.2022.04.03.17.53.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Apr 2022 17:53:38 -0700 (PDT)
From:   Yuntao Wang <ytcoode@gmail.com>
To:     andrii.nakryiko@gmail.com
Cc:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, john.fastabend@gmail.com, kafai@fb.com,
        kpsingh@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com, toke@redhat.com,
        yhs@fb.com, ytcoode@gmail.com
Subject: [PATCH bpf-next v3] libbpf: Don't return -EINVAL if hdr_len < offsetofend(core_relo_len)
Date:   Mon,  4 Apr 2022 08:53:20 +0800
Message-Id: <20220404005320.1723055-1-ytcoode@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <CAEf4Bzbi1E_-yojgJQevM1rdhXF4EzU4dgPsGDT7F5uuDPOE7Q@mail.gmail.com>
References: <CAEf4Bzbi1E_-yojgJQevM1rdhXF4EzU4dgPsGDT7F5uuDPOE7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since core relos is an optional part of the .BTF.ext ELF section, we should
skip parsing it instead of returning -EINVAL if header size is less than
offsetofend(struct btf_ext_header, core_relo_len).

Signed-off-by: Yuntao Wang <ytcoode@gmail.com>
---
v1 -> v2: skip core relos if hdr_len < offsetofend(core_relo_len)
v2 -> v3: fix comment style

 tools/lib/bpf/btf.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index 1383e26c5d1f..d124e9e533f0 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -2826,10 +2826,8 @@ struct btf_ext *btf_ext__new(const __u8 *data, __u32 size)
 	if (err)
 		goto done;
 
-	if (btf_ext->hdr->hdr_len < offsetofend(struct btf_ext_header, core_relo_len)) {
-		err = -EINVAL;
-		goto done;
-	}
+	if (btf_ext->hdr->hdr_len < offsetofend(struct btf_ext_header, core_relo_len))
+		goto done; /* skip core relos parsing */
 
 	err = btf_ext_setup_core_relos(btf_ext);
 	if (err)
-- 
2.35.1

