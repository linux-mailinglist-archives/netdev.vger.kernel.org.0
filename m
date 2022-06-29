Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5F5D5604E7
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 17:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234279AbiF2PtE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 11:49:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229885AbiF2PtA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 11:49:00 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CE2E1FCF6;
        Wed, 29 Jun 2022 08:48:59 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id b12-20020a17090a6acc00b001ec2b181c98so19854699pjm.4;
        Wed, 29 Jun 2022 08:48:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yW9E9JVH5fs7X71RFKnyotPspjqZm3d0xpIXUa3OJ/A=;
        b=Q7rsteGSBnW7ZEDalfCDVngQLqRN8/Tzx3ICFDxYPq0ldtWJitNSpcHyCkr/HrFaw0
         sWtA7D8VNHDqUAJKn+HBUSQegd+AIMTOubG0GyJ5pNGB3wPeDjXJM0/sSqTTDxo2II6m
         UOwZDc6TzDJkXs4PXTS7dLRtTtuln4ohuv70D1/Lrdk1//+M6MafQQwXjPfHx2kSXSUy
         4SKEiivqPcFTKCt4njn6YVAejfTihGdQY4RW8/8MtpfD6xuLsjXNxSc9FNkdfJdWFU8g
         l0Rz5k7+KpKiklel18Z+0tWgKEMc4GP1mOVelovmCqxQRXe2ij0pflR8/gu/iFKvY0YU
         IyPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yW9E9JVH5fs7X71RFKnyotPspjqZm3d0xpIXUa3OJ/A=;
        b=z+3I6evEVtiVc3YImuh/P78cIMjEgdWsTuElcqX8MkjzNF/27FVHsOXSKVFbPpz+mC
         rh8K5mjfj/JMwtkJZwlg6qpSN2fU/r94C0LR2fJqSY3RrfvH+TIKtLELNjjU2LqJcQSW
         2jF/NnwzZTLMJUwttiUjquMIodp5zS6Evr8/5jgsm0CTMoF+7Z/gZZ+UaSGE6HmP6mL0
         BHgAK7LYEuQ1ZEx+6ujB9eSzphVC3kLfywj0PebUvPFeVxT5XwF172OcK40ttXzeCBdK
         QDo2mRf7dkA8SeLjd/1JCrEyJlQY9v8Z9YOj1S5PWb/Ylhz4yw7U6Bjek0iS2SOta8Lf
         LN8w==
X-Gm-Message-State: AJIora+j9URpOLn6pya9Bn8gKRjoQtXTVdGHrw2062dLP4VVb01N0I5A
        LvtQEVogjmB51QH0Ik5qETg=
X-Google-Smtp-Source: AGRyM1stN92bINXjMaKBW+pcw4z7iWvZye3Zl3CnbtfYDy2SaWR+Uveru3hWhxIglaB+T9m/WGcNxg==
X-Received: by 2002:a17:902:b286:b0:16b:89b2:4e34 with SMTP id u6-20020a170902b28600b0016b89b24e34mr11291340plr.108.1656517739019;
        Wed, 29 Jun 2022 08:48:59 -0700 (PDT)
Received: from vultr.guest ([45.32.72.20])
        by smtp.gmail.com with ESMTPSA id 1-20020a620501000000b00527d84dfa42sm2661329pff.167.2022.06.29.08.48.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jun 2022 08:48:57 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, quentin@isovalent.com
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH bpf-next 2/4] bpf: Warn on non-preallocated case for missed trace types
Date:   Wed, 29 Jun 2022 15:48:30 +0000
Message-Id: <20220629154832.56986-3-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220629154832.56986-1-laoar.shao@gmail.com>
References: <20220629154832.56986-1-laoar.shao@gmail.com>
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

BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE and BPF_PROG_TYPE_TRACING are
trace type as well, which may also cause unexpected memory allocation if
we set BPF_F_NO_PREALLOC.
Let's also warn on both of them.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 kernel/bpf/verifier.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 4938477912cd..8452e5746f59 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -12539,6 +12539,8 @@ static bool is_tracing_prog_type(enum bpf_prog_type type)
 	case BPF_PROG_TYPE_TRACEPOINT:
 	case BPF_PROG_TYPE_PERF_EVENT:
 	case BPF_PROG_TYPE_RAW_TRACEPOINT:
+	case BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE:
+	case BPF_PROG_TYPE_TRACING:
 		return true;
 	default:
 		return false;
-- 
2.17.1

