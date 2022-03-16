Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A64CC4DB3BD
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 15:53:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356903AbiCPOyO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 10:54:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356899AbiCPOyM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 10:54:12 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DF6913E36;
        Wed, 16 Mar 2022 07:52:58 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id z12-20020a17090ad78c00b001bf022b69d6so2635287pju.2;
        Wed, 16 Mar 2022 07:52:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JKCi7Su9vnsmUw/t9IHlylpTsFhsnuAWupOqKFBulF0=;
        b=lCSV2spDvHv9GvZYRwqzrDNf8h7uO/G8Oz+wQmgvz9b9U0Pap2otnjQ9PG/bsJQGUz
         hNz0R5dFAk2IYEdpxb6WDLRc9fpmE/TbLNS5toackiN4zLX35TBGLl0X4WATG3F8fzzf
         8IpSoMY+ehovP4fHEn7aLhEv87PDNdpWzC0u6vDv76gZDRHInyC4salkA/JTVezkmvzN
         vFYiXozOG/PEHlx73ms9VpDTUlF/IQdCt0Fbcs7Z+4B3k+h3wl/kiPgwaqGxFsPnE7aA
         vFaGLNI3K5qVn8qM3TFNe/DkcGV97tShvjHVwPcgRE/fqvglThBbrUQjjwyINLwxO8iY
         cLdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JKCi7Su9vnsmUw/t9IHlylpTsFhsnuAWupOqKFBulF0=;
        b=doe4GoSHyjB0LL+Jf6VDsgtit0ofKe3AfLnw1GPY+4CaIwEmqscAlTwwLBFnbTGfzq
         rXeaONun7xx4oFM/9ztEJIp+awI7SSwyBamwgRhQfqlQMofq4zlyL6sLjM/rbKWy21xS
         m8lw1QTZTOq/nRFvj73BC0+xMcumaguMtjhP/ubOQ4McDDZYlbE9o3gcohoNvRgUIYwk
         MZQRMuSjyLT8EhNpbCMWSz4rVtBeHAHHoaXgzMTE8jmYWCCsWCnV4NajWobX6VzCteNI
         V05VEx6b6ltrD2tYHAT+ffmV5aSZYTdpmI+e1YBk5MqTW2Eu0ADt7EjVCtJvolcccbqJ
         Bb/Q==
X-Gm-Message-State: AOAM531z9TICJmP3gdMPlWElAz9lcGVi9vtJYWP0YzWbxqf2TvXcvkGM
        XCSVOafhuulSU3LPLIX4NUtzbVzFTFfABg==
X-Google-Smtp-Source: ABdhPJxldpCgtWX9JhT3WhaQDe+Cf1JLQrGo6TDJA7q5Ug1R66JW8t/1ky0EnqhDy8gC6X6vcbGnTQ==
X-Received: by 2002:a17:902:e944:b0:14e:dc4f:f099 with SMTP id b4-20020a170902e94400b0014edc4ff099mr290909pll.161.1647442377709;
        Wed, 16 Mar 2022 07:52:57 -0700 (PDT)
Received: from localhost.localdomain ([223.212.58.71])
        by smtp.gmail.com with ESMTPSA id p10-20020a056a0026ca00b004fa06fa407asm3659915pfw.91.2022.03.16.07.52.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 07:52:57 -0700 (PDT)
From:   Yuntao Wang <ytcoode@gmail.com>
To:     andrii.nakryiko@gmail.com
Cc:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, john.fastabend@gmail.com, kafai@fb.com,
        kpsingh@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com, yhs@fb.com,
        ytcoode@gmail.com, toke@redhat.com
Subject: [PATCH bpf-next v2] libbpf: Don't return -EINVAL if hdr_len < offsetofend(core_relo_len)
Date:   Wed, 16 Mar 2022 22:52:13 +0800
Message-Id: <20220316145213.868746-1-ytcoode@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <CAEf4BzbzqvQM63-mO96tbNaPXsKSbff4h-mX6UBfbU9zZG67OQ@mail.gmail.com>
References: <CAEf4BzbzqvQM63-mO96tbNaPXsKSbff4h-mX6UBfbU9zZG67OQ@mail.gmail.com>
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

Since core relos is an optional part of the .BTF.ext ELF section, we should
skip parsing it instead of returning -EINVAL if header size is less than
offsetofend(struct btf_ext_header, core_relo_len).

Fixes: e9fc3ce99b34 ("libbpf: Streamline error reporting for high-level APIs")
Signed-off-by: Yuntao Wang <ytcoode@gmail.com>
---
v1 -> v2: skip core relos if hdr_len < offsetofend(core_relo_len)

 tools/lib/bpf/btf.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index 1383e26c5d1f..9b7196b21498 100644
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
+		goto done; // skip core relos parsing
 
 	err = btf_ext_setup_core_relos(btf_ext);
 	if (err)
-- 
2.35.1

