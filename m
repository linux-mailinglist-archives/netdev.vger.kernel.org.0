Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 303544D1B1E
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 15:58:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347687AbiCHO7I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 09:59:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347688AbiCHO7H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 09:59:07 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E37D71B785
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 06:58:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646751490;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gvNVqarfNkzMY75zhkRvdB+Wpo5cjAId5AeXOVZkNno=;
        b=aISNWBe9aCFm+HiVctpbC0iEfI+Px0FAFunVzdlzPWWyCVl7zje+b5HCmQdmiLUMI+khHe
        swiF8nTThJFy9lbqR8tnnyQoHchgJiOpo5/nOyxEgqV2V1510zF3AJWLVZA+XBGpPSqfwx
        DkTqYj0vmNA/gbDzQGmDNcbzLOG53yA=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-458-dBlp_CMJNJSeKu6iHMYt_w-1; Tue, 08 Mar 2022 09:58:08 -0500
X-MC-Unique: dBlp_CMJNJSeKu6iHMYt_w-1
Received: by mail-ed1-f69.google.com with SMTP id l24-20020a056402231800b00410f19a3103so10744135eda.5
        for <netdev@vger.kernel.org>; Tue, 08 Mar 2022 06:58:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gvNVqarfNkzMY75zhkRvdB+Wpo5cjAId5AeXOVZkNno=;
        b=GNIM4xudjInOS9X0iWAe4SZhqLsHzf0d9bqJR7rOW5WTWOXqssRFFrkOlYPuFmIvJt
         C7Fg6FYy/cn60v9aAS0E0RoksYaTLEe0kRANEgs4ETDaA1fb9LVrYPzkNJh+ZPq2linG
         HegfS61Xr1fje2Sz0AScLZ4JnHU+dzq3MzG6HCCCuFbWLI6OV6uOB4p/eFgDuGfk2rPL
         S90K618Yli/MpWn7OhxxJF0Bp8oM/Q5AvVsTySYSbJX0d1el7mIhkT2m2KH09RJ3fZH8
         +AZrMbC26/Gxi4QDmmjppoQzR4YpoDSpYy6Ma0KedjXknsWSBwBDrtOhDcF5PBUTAknf
         iYQw==
X-Gm-Message-State: AOAM532kvUlMnqoVht1TvAvdLlfdBimiMQsYWtTZwRQzp4NA9aQ9d4dV
        l1hqXlq4NVjf+xkEpfamyS2VkbRt/M5WaG3Zuu8Ryq71uQ1wuQFd5hPcIYPjbZhdmzREvX++SS6
        Xvep+NNyZY/QVuV9r
X-Received: by 2002:a17:906:fb1b:b0:6da:9e7d:1390 with SMTP id lz27-20020a170906fb1b00b006da9e7d1390mr13259479ejb.644.1646751486430;
        Tue, 08 Mar 2022 06:58:06 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxckfWnRhAYcHBmCxOgoj4VKqW6GOb5gPXGwumyS2wB47Ean+tc4hOZw1goN1vtGkzrIzN8ww==
X-Received: by 2002:a17:906:fb1b:b0:6da:9e7d:1390 with SMTP id lz27-20020a170906fb1b00b006da9e7d1390mr13259392ejb.644.1646751485080;
        Tue, 08 Mar 2022 06:58:05 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id fy1-20020a1709069f0100b006d229ed7f30sm6117558ejc.39.2022.03.08.06.58.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 06:58:04 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id CBB531928D6; Tue,  8 Mar 2022 15:58:03 +0100 (CET)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf-next v10 3/5] libbpf: Support batch_size option to bpf_prog_test_run
Date:   Tue,  8 Mar 2022 15:57:59 +0100
Message-Id: <20220308145801.46256-4-toke@redhat.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220308145801.46256-1-toke@redhat.com>
References: <20220308145801.46256-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for setting the new batch_size parameter to BPF_PROG_TEST_RUN
to libbpf; just add it as an option and pass it through to the kernel.

Acked-by: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 tools/lib/bpf/bpf.c | 1 +
 tools/lib/bpf/bpf.h | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index 3c7c180294fa..f69ce3a01385 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -995,6 +995,7 @@ int bpf_prog_test_run_opts(int prog_fd, struct bpf_test_run_opts *opts)
 
 	memset(&attr, 0, sizeof(attr));
 	attr.test.prog_fd = prog_fd;
+	attr.test.batch_size = OPTS_GET(opts, batch_size, 0);
 	attr.test.cpu = OPTS_GET(opts, cpu, 0);
 	attr.test.flags = OPTS_GET(opts, flags, 0);
 	attr.test.repeat = OPTS_GET(opts, repeat, 0);
diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
index 16b21757b8bf..5253cb4a4c0a 100644
--- a/tools/lib/bpf/bpf.h
+++ b/tools/lib/bpf/bpf.h
@@ -512,8 +512,9 @@ struct bpf_test_run_opts {
 	__u32 duration;      /* out: average per repetition in ns */
 	__u32 flags;
 	__u32 cpu;
+	__u32 batch_size;
 };
-#define bpf_test_run_opts__last_field cpu
+#define bpf_test_run_opts__last_field batch_size
 
 LIBBPF_API int bpf_prog_test_run_opts(int prog_fd,
 				      struct bpf_test_run_opts *opts);
-- 
2.35.1

