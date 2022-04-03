Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2D0A4F0A45
	for <lists+netdev@lfdr.de>; Sun,  3 Apr 2022 16:43:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359073AbiDCOpR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Apr 2022 10:45:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359062AbiDCOpL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Apr 2022 10:45:11 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 095A839828;
        Sun,  3 Apr 2022 07:43:16 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id q142so4523027pgq.9;
        Sun, 03 Apr 2022 07:43:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=G/TVx2XnkKIhWcX5k9unvUl8sU5ccEHxJlPYgV8oyCQ=;
        b=dXwLblJF7O8d8wO55CIc+bGJKbYdGX1/nE3Ilfjt9orEYzXTDbobIYWOvTrMIvDHwS
         R92Dz6LWTOeXvvGxkTfIzwK6RVtwvu6GNYjSd0G8vjPAQEF0tqwvdymaB2VS9EBhCM98
         vQ0THoPcBIEK0IW5Lfbmg0saUoDWCrazPOZsEa2g5hykS06vha9aLjvzPWegdpXALKy7
         NvNBX2dPa24n1n0nC/Rc0ga/KyetnMbQABYiPuNCRISxu2lox3BgSex5rT9MxIMj+6ex
         MRO6rw/n+4eP7cQs+VDCwPQij9/YrAQieZHw2Xtfgm+VnsunsdjOozK3rtU7ctIZFQK0
         eNHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=G/TVx2XnkKIhWcX5k9unvUl8sU5ccEHxJlPYgV8oyCQ=;
        b=BZnaeP7f2Kyaj1a9qO5PEPdeou1lZf7N5rnSvGvCvlVkSSejxlWQbYPYogzOfZ2vbM
         zM9viKncwTAybWD2d2eU2RqfgKYNNwbi0SzzkVnRfp89W1gkWAHy/CpXZmc1jqrhVA1/
         /GmlScAMVO2nUqdZyvU4NYWYXHRFCqeJ9kGcHTx/CIQENR50NVxJ5xQzq5HWAaZKv4ga
         lc80PK0lI0mj0/kc/kx5BTphyEb34H+1/xG6X3A8lpqi/asJLQ5oLYtO1iqwGHJ3EEec
         diNSHF1pKYYu1Bsr85l+WFAxGfLeEvU5y2JOE+kEFmRXkFeMG+5XMt51Xk1oop7amGyM
         dKUw==
X-Gm-Message-State: AOAM533IMxUaLjK7VLj+R0U6aCFh0V62QXv8/KfnsNagbMaHMh1btSd0
        8ItBNNkOtPy7K/lzMR39V7E=
X-Google-Smtp-Source: ABdhPJylsNm2gon9FQbC/cKegPNY9RiDuoiN1RZsHsCiDLgTPk3PNw1/OYxNe69MN1tjcn4h2eCRiA==
X-Received: by 2002:a05:6a00:a15:b0:4fb:4112:870e with SMTP id p21-20020a056a000a1500b004fb4112870emr19621715pfh.11.1648996996435;
        Sun, 03 Apr 2022 07:43:16 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:51a7:5400:3ff:feee:9f61])
        by smtp.gmail.com with ESMTPSA id c18-20020a056a000ad200b004cdccd3da08sm9464910pfl.44.2022.04.03.07.43.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Apr 2022 07:43:16 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH bpf-next v2 6/9] bpf: runqslower: Replace RLIMIT_MEMLOCK with LIBBPF_STRICT_ALL
Date:   Sun,  3 Apr 2022 14:42:57 +0000
Message-Id: <20220403144300.6707-7-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220403144300.6707-1-laoar.shao@gmail.com>
References: <20220403144300.6707-1-laoar.shao@gmail.com>
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

Avoid using the deprecated RLIMIT_MEMLOCK.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 tools/bpf/runqslower/runqslower.c | 17 ++---------------
 1 file changed, 2 insertions(+), 15 deletions(-)

diff --git a/tools/bpf/runqslower/runqslower.c b/tools/bpf/runqslower/runqslower.c
index d78f4148597f..3439ded327f8 100644
--- a/tools/bpf/runqslower/runqslower.c
+++ b/tools/bpf/runqslower/runqslower.c
@@ -88,16 +88,6 @@ int libbpf_print_fn(enum libbpf_print_level level,
 	return vfprintf(stderr, format, args);
 }
 
-static int bump_memlock_rlimit(void)
-{
-	struct rlimit rlim_new = {
-		.rlim_cur	= RLIM_INFINITY,
-		.rlim_max	= RLIM_INFINITY,
-	};
-
-	return setrlimit(RLIMIT_MEMLOCK, &rlim_new);
-}
-
 void handle_event(void *ctx, int cpu, void *data, __u32 data_sz)
 {
 	const struct runq_event *e = data;
@@ -133,11 +123,8 @@ int main(int argc, char **argv)
 
 	libbpf_set_print(libbpf_print_fn);
 
-	err = bump_memlock_rlimit();
-	if (err) {
-		fprintf(stderr, "failed to increase rlimit: %d", err);
-		return 1;
-	}
+	/* Use libbpf 1.0 API mode */
+	libbpf_set_strict_mode(LIBBPF_STRICT_ALL);
 
 	obj = runqslower_bpf__open();
 	if (!obj) {
-- 
2.17.1

