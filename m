Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 981904DE99D
	for <lists+netdev@lfdr.de>; Sat, 19 Mar 2022 18:31:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243706AbiCSRcY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Mar 2022 13:32:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243683AbiCSRcV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Mar 2022 13:32:21 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC52845ADC;
        Sat, 19 Mar 2022 10:30:53 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id b8so9842126pjb.4;
        Sat, 19 Mar 2022 10:30:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qHQu4l0DNA359MKDX3wgS7bak31X8wuVL1Qxy9vcN30=;
        b=aVlQw/X30t3guhPlzexjfi4ZuV1qG2ftDBMaM2cxYxqwAi3vbYD6Qvz749eSnnmN3I
         dcjSrNHmbXjAqWtWH9tlty2IMJT5ilANT557Z9fyWcqL3VhW8p+AWj02tlbZx2cPrTVs
         b1ipu9ey3X/BQRhLYasrQJrjczm7Qpmz3cCvBHfN8DtM/l5g0NO1OCC7+VT+o5NJ9HcD
         FW2ZjEo7o8iZXK9cbz6wNQ+H4kITaPS7gbBuVDOIm5JLoDEbKsZMAthE037au1hACQBN
         kATbhDZARdTdhdL0FTjfcGN0oNMFTSTSZqrbMuUJc6K4XFgMwQEKQ8PAzDUSE+aqN1U1
         XiRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qHQu4l0DNA359MKDX3wgS7bak31X8wuVL1Qxy9vcN30=;
        b=1kKUSuEIBEri2WuLOsrtKm710NPF3xUsbNafiTV+CVzZPsLsQ8x+2uH3cttHl32XPk
         4CrsIYelW1Qv1VI1Tt1By59hAnxoTcDGaDlZEkFkbAffkZWPWOEc59ZSkM3c4rrG8V04
         yj9oSDSSvY8Y9o7JUqI+e6iCS3esG1gIGnijtRySEDJ3s4qLYs7u3Y67cc3/83nTwQAY
         7UmT+//Q+W3DGhCFpWyXOPnUrCMOWzjg+Ucs4k2TdEMUvbegKQH/oUaYU3SCcAhJ/NRS
         38QXWlRxNME9kJFm637ONboXRjANDcdjYnGbz1ohEKBWtaGIbN0VU+M9iWDH5xkoIF7j
         6X2Q==
X-Gm-Message-State: AOAM532CQb/VFS5CefiXp/3uO8Xozw16/QOditIROZz79oGiXuJVQtYA
        tEoIBWdEfglqWmtehVnMfw95sZkR4r1somi7sgU=
X-Google-Smtp-Source: ABdhPJxbI/bKQUsvIS+pdtOIBg2Ba5EngaSH06pOcvVbNR2cQU79iWIhoSG40JbwcKqwIDkohnV3Ig==
X-Received: by 2002:a17:903:230c:b0:151:93d0:5608 with SMTP id d12-20020a170903230c00b0015193d05608mr5013516plh.167.1647711053379;
        Sat, 19 Mar 2022 10:30:53 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:4ab8:5400:3ff:fee9:a154])
        by smtp.gmail.com with ESMTPSA id k21-20020aa788d5000000b004f71bff2893sm12722136pff.67.2022.03.19.10.30.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Mar 2022 10:30:52 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     roman.gushchin@linux.dev, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, shuah@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH 10/14] bpf: Only sys admin can set no charge flag for bpf prog
Date:   Sat, 19 Mar 2022 17:30:32 +0000
Message-Id: <20220319173036.23352-11-laoar.shao@gmail.com>
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

When a bpf prog is loaded by a proccess running in a container (with memcg),
only sys admin has privilege not to charge bpf prog memory into this
container while account it to root memcg only.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 kernel/bpf/syscall.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 346f3df9fa1d..ecc5de216f50 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2234,6 +2234,9 @@ static int bpf_prog_load(union bpf_attr *attr, bpfptr_t uattr)
 				 BPF_F_PROG_NO_CHARGE))
 		return -EINVAL;
 
+	if (attr->prog_flags & BPF_F_PROG_NO_CHARGE && !capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
 	if (!IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) &&
 	    (attr->prog_flags & BPF_F_ANY_ALIGNMENT) &&
 	    !bpf_capable())
-- 
2.17.1

