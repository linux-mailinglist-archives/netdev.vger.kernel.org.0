Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0296B4DE98B
	for <lists+netdev@lfdr.de>; Sat, 19 Mar 2022 18:30:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243110AbiCSRcF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Mar 2022 13:32:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243028AbiCSRcE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Mar 2022 13:32:04 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06EF64550E;
        Sat, 19 Mar 2022 10:30:43 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id h5so9468051plf.7;
        Sat, 19 Mar 2022 10:30:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SbeZr/I+CalicDsBM6Lp+v2L/E+i5mvTRbU/FduAJzc=;
        b=QlkPs7KKYZp/Vt3mckJyR+0PM1YuL5+7nltt6dNtOiHh8ERRVBjGf9kNzg+dsCk1iQ
         0yLLxrqsVlHtzV5Vw9ohcLqy7ZGSTA9UDNmE44KNDq3qg0R836FTm+vIEvjUXlOdpHqn
         lfuVupHZKfZynl/zXu/R6GrM8tSf4xhBKJJzR6G9p7Wr7CKYFWMyvr1x1rXPGWkVnYRi
         +O29Rngeovdqpp1gj0wIG0p9eDROkQQtL6oAlqK2HVVoGAsE4KSKddEcmAsJWfmzgMgh
         8OBxFs244+jpjfsaiYjXoP9WHiCR9DpnP7JVWQgPCGKq4GieqiFrA38N6mWdjbXmFfMc
         1JEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SbeZr/I+CalicDsBM6Lp+v2L/E+i5mvTRbU/FduAJzc=;
        b=wxh6ZGnbnFUY7MLq741RkTcGKHQHeBqD9U8e+/TRieox+0p0UlirxZZW6VSuzzv1VO
         iEZ+oyZM/RVqXEv1Qn3aMW4kJKOS5g19EMl1e8VbskuElWeKT1pJco9DvX7STkfjMOCC
         PWgKjAFnDfv0FzLuHhOK/MRhWb0Z7NpYJ0FmUgphEPODUv3oFLw2ABj4YCTHbjwt44CC
         +l0QPGbjKDSnWbrsm+Fa+1HCn40ZS3bdcEwHfEnbUuKxDlrwBFiA9QxNR7uzEtmwIhJ0
         UvqhH2VL+BgPFMl1y0G5yRGK3SRpRYJgn4Ct19v+Zo+shcbVIb/ifGuiLw7oRmJdNnHO
         83BA==
X-Gm-Message-State: AOAM530Rz8uk6g9aAjbLXB+ZIJV2Svs5Mz8cDRQEqyAW8AI679ClcRHG
        HDIZ4sHqnZiLmbEKE6HB2Co=
X-Google-Smtp-Source: ABdhPJyhjleiQ+4zT/uhoE3mMf1ZeubMi5rFuwyYwjBW0IfV8A8vwfM99q/1OpYQE8OfdMPNvRBg9A==
X-Received: by 2002:a17:902:d4c8:b0:154:2416:218b with SMTP id o8-20020a170902d4c800b001542416218bmr5180946plg.139.1647711042563;
        Sat, 19 Mar 2022 10:30:42 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:4ab8:5400:3ff:fee9:a154])
        by smtp.gmail.com with ESMTPSA id k21-20020aa788d5000000b004f71bff2893sm12722136pff.67.2022.03.19.10.30.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Mar 2022 10:30:42 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     roman.gushchin@linux.dev, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, shuah@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH 02/14] bpf: Only sys admin can set no charge flag
Date:   Sat, 19 Mar 2022 17:30:24 +0000
Message-Id: <20220319173036.23352-3-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220319173036.23352-1-laoar.shao@gmail.com>
References: <20220319173036.23352-1-laoar.shao@gmail.com>
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

Only the sys admin has the privilege to account the bpf map memory into
root memcg only.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 kernel/bpf/syscall.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 029f04588b1a..0cca3d7d0d84 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -852,6 +852,9 @@ static int map_create(union bpf_attr *attr)
 	    attr->map_extra != 0)
 		return -EINVAL;
 
+	if (attr->map_flags & BPF_F_NO_CHARGE && !capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
 	f_flags = bpf_get_file_flag(attr->map_flags);
 	if (f_flags < 0)
 		return f_flags;
-- 
2.17.1

