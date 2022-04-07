Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEBD44F7FFC
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 15:05:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245710AbiDGNHT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 09:07:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230229AbiDGNHS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 09:07:18 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44BDA48E73;
        Thu,  7 Apr 2022 06:05:18 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id h5so3954872pgc.7;
        Thu, 07 Apr 2022 06:05:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eyzEQI5WafpsISoL+TbuWgHkTeRTUB3yFRqImZRg+t4=;
        b=bzE4SJTzgtFCRXJ2TFUc7i2rHca5hXZZdPRDM4OBRmn1oFmJOIBXt/EQnH0L7t+GMQ
         Tec1XYCZXzD2FYZOnoT2R1wd7+FIJqcMlcLu+ABPlZ1hZi0Tgurz9umXAbg9I8V5gM/v
         lbwldi9lD3QWK/gAlbmzIvqdPlxoFgN2ZKoWovxY410ASjJlzeD8JUBu2RAUO/n3Tuv6
         Ik7Dy7afhSZSRXFdnYPK4+yGxEVqRZ9qglMEx/0b3tZTCF5CAPq82JEdRSYbgp/UIn5D
         QGYNcE/TKvJhJRMg0nUoRZWjAwxylrlYiBVR9iDTKm8TNflInc+EeWmEbOk9UjdnkMT7
         pICg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eyzEQI5WafpsISoL+TbuWgHkTeRTUB3yFRqImZRg+t4=;
        b=EbvXjbiz8LSCOP0kK/67QJTZzlIIOBSSRPJDwJ1vdvpsxnF5r/b+uAXXOQypAbd4Hl
         U9SLqU2VdDeezkTJjgqEiSGdlS9nJTLp3aF4nqUIDyRAF1SiPSH/k+bExN+IY4j6lqwM
         zhI+sQp+cW+GsBSpBPLyEo8eu1BQnMEtR9EHSR3+KwcSKCXKF7oMlhMBHZWy6H+jcMJB
         PytwM97C1E5ZyLWBK2G8/NSXSFXWZG9+znIja4JqBTFuBWvrqsG+TA6cC2HhofimiqR/
         dUnmItreJotR1uzqgxGdrpXW6G7aYQYYN8kipl5z2c71FU7aI75IUmPTq7KIbvKYKYja
         QYXA==
X-Gm-Message-State: AOAM532pNog0d88UVW6ATet64bZu6YEgvKl0KYALp8FFBoUnXykcNMm2
        uWsxNr2/uhmo+NTbAdsbAac=
X-Google-Smtp-Source: ABdhPJwEZ3C83TRCBuR0KDCwyNg2QrzTNHuPqYB2IaHRAiNoZoNseNjEIDwb9T3iw4nyEFjoPPvN1A==
X-Received: by 2002:a05:6a00:1252:b0:4fa:afcc:7d24 with SMTP id u18-20020a056a00125200b004faafcc7d24mr13960745pfi.85.1649336717708;
        Thu, 07 Apr 2022 06:05:17 -0700 (PDT)
Received: from localhost.localdomain ([43.132.141.3])
        by smtp.gmail.com with ESMTPSA id j18-20020a056a00235200b004faabd8d2f2sm22714534pfj.192.2022.04.07.06.05.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Apr 2022 06:05:16 -0700 (PDT)
From:   Yuntao Wang <ytcoode@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yuntao Wang <ytcoode@gmail.com>
Subject: [PATCH bpf-next] bpf: Fix excessive memory allocation in stack_map_alloc()
Date:   Thu,  7 Apr 2022 21:04:23 +0800
Message-Id: <20220407130423.798386-1-ytcoode@gmail.com>
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

The 'n_buckets * (value_size + sizeof(struct stack_map_bucket))' part of
the allocated memory for 'smap' is never used, get rid of it.

Fixes: b936ca643ade ("bpf: rework memlock-based memory accounting for maps")
Signed-off-by: Yuntao Wang <ytcoode@gmail.com>
---
 kernel/bpf/stackmap.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/bpf/stackmap.c b/kernel/bpf/stackmap.c
index 6131b4a19572..1dd5266fbebb 100644
--- a/kernel/bpf/stackmap.c
+++ b/kernel/bpf/stackmap.c
@@ -100,7 +100,6 @@ static struct bpf_map *stack_map_alloc(union bpf_attr *attr)
 		return ERR_PTR(-E2BIG);
 
 	cost = n_buckets * sizeof(struct stack_map_bucket *) + sizeof(*smap);
-	cost += n_buckets * (value_size + sizeof(struct stack_map_bucket));
 	smap = bpf_map_area_alloc(cost, bpf_map_attr_numa_node(attr));
 	if (!smap)
 		return ERR_PTR(-ENOMEM);
-- 
2.35.0.rc2

