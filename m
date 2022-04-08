Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D34814F8E84
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 08:27:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234224AbiDHER3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 00:17:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232658AbiDHER2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 00:17:28 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68EAC2E0F20;
        Thu,  7 Apr 2022 21:15:25 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id a16-20020a17090a6d9000b001c7d6c1bb13so8481238pjk.4;
        Thu, 07 Apr 2022 21:15:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4+rOEzFAMJJgXNy15jCz7SsQISiJWacBJllHkfSFDfk=;
        b=KTJGOHY1jWaNKMCowdV/0KshrzntST/NJ2chxhHVG54H7LfhRJb3PdOmoV4vHk+dKM
         RUFI7CS0leoZ+SvwHFyaN0W9MuV+RqDQ0RQvW8CDZl8rWUtEC3fn+9n9RRJaV6StWf7K
         rEMdl/86TDCo2CaDLveZaSAECeIy2KSZOJOs+acpnWyXp1UXGkhylydCDBPvi4d4721j
         GsIPPpMlcazsxT/Nd7gulCvAiaDdKMNhAmuIVisB3FcPHEEsp3pCIVCjRF58drpMXMSw
         1ZaeoiuxjGZC4xakz68ISoyZgv2lCPNYkijTEkS6dWaj9aXqMZZC+fm1J5szybcNCDdZ
         VUSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4+rOEzFAMJJgXNy15jCz7SsQISiJWacBJllHkfSFDfk=;
        b=cY68dX53NWczIZHElkIC2XYCqlZrbGDqpfHgi/53HNGxCoK6dZ+xEQJGt7xe4GlnZu
         1V0KThCOa+jWFeGlPTAaJ1TVliTjVZgXIM+GMMlr3EDzNHzpMpSdXbzlLSD7XorR1P7X
         EmWjq7MwLDueO1In5eHREMv1OMv7eB8/eQDUPNN4a51cxpGsBdDDbDtFl7PeePDUtF2Q
         3o2MpqUa9aAMagxV5m3ulR8tlzUUgxoyks5sCtbF2axoOyVRv9KVk64KeZHMTMGc5FeQ
         w6vQ0qVvTS9bwbRG4fff8p809R0cPP1BpVI0xUxPrPsGpBE+wArUIA//0j/IURl0I5M9
         snxg==
X-Gm-Message-State: AOAM530g7yz6R9NT5hriCdSwU054V5LV8el/cjHdj03ekyi9+HJSC8YT
        nq+LCQjjkmBEMjLTuu7xdVc=
X-Google-Smtp-Source: ABdhPJzBrWIOQA+LTz4iR7Gep1go2uzqC8EpRYuxlUgPRF1HnaokeSNqgrWe/R9KPRFBDelGdd1EGA==
X-Received: by 2002:a17:903:1104:b0:154:c628:e7c2 with SMTP id n4-20020a170903110400b00154c628e7c2mr17648425plh.54.1649391324970;
        Thu, 07 Apr 2022 21:15:24 -0700 (PDT)
Received: from localhost.localdomain ([43.132.141.8])
        by smtp.gmail.com with ESMTPSA id f14-20020a056a0022ce00b004fabe9fac23sm25789042pfj.151.2022.04.07.21.15.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Apr 2022 21:15:24 -0700 (PDT)
From:   Yuntao Wang <ytcoode@gmail.com>
To:     skhan@linuxfoundation.org
Cc:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, hengqi.chen@gmail.com,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org, shuah@kernel.org, songliubraving@fb.com,
        yhs@fb.com, ytcoode@gmail.com
Subject: [PATCH bpf-next v2] selftests/bpf: Fix return value checks in perf_event_stackmap.c
Date:   Fri,  8 Apr 2022 12:14:52 +0800
Message-Id: <20220408041452.933944-1-ytcoode@gmail.com>
X-Mailer: git-send-email 2.35.0.rc2
In-Reply-To: <7ac36fbe-aa44-9311-320b-1e953c29a3c4@linuxfoundation.org>
References: <7ac36fbe-aa44-9311-320b-1e953c29a3c4@linuxfoundation.org>
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

The bpf_get_stackid() function may also return 0 on success.

Correct checks from 'val > 0' to 'val >= 0' to ensure that they cover all
possible success return values.

Signed-off-by: Yuntao Wang <ytcoode@gmail.com>
---
v1 -> v2: update commit message

 tools/testing/selftests/bpf/progs/perf_event_stackmap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/perf_event_stackmap.c b/tools/testing/selftests/bpf/progs/perf_event_stackmap.c
index b3fcb5274ee0..f793280a3238 100644
--- a/tools/testing/selftests/bpf/progs/perf_event_stackmap.c
+++ b/tools/testing/selftests/bpf/progs/perf_event_stackmap.c
@@ -35,10 +35,10 @@ int oncpu(void *ctx)
 	long val;
 
 	val = bpf_get_stackid(ctx, &stackmap, 0);
-	if (val > 0)
+	if (val >= 0)
 		stackid_kernel = 2;
 	val = bpf_get_stackid(ctx, &stackmap, BPF_F_USER_STACK);
-	if (val > 0)
+	if (val >= 0)
 		stackid_user = 2;
 
 	trace = bpf_map_lookup_elem(&stackdata_map, &key);
-- 
2.35.0.rc2

