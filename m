Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38CA04BBF5B
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 19:20:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237169AbiBRSSZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 13:18:25 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236189AbiBRSSY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 13:18:24 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 778CA12A85;
        Fri, 18 Feb 2022 10:18:07 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id qe15so9272125pjb.3;
        Fri, 18 Feb 2022 10:18:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Br6SCzkS+wuKYi19e3xLSc3mR0U+4wqwOebNtfju5TU=;
        b=LAfOPblV4LkT5VepGAYShPVXWyu3Lz9xJVfENiMqBOVZBuQ7myckiBXuX3GJv+yDZE
         kZOpVFD9/3l1eKUpdCqgJSxUeL65/DfAl/TIxxy8qvJwQIL9KYnQJDLMwA3zyWOkVLsk
         spumhS5n2lDx2h70fE8qqolY+4nz9yFseF4p5IVnnso2NFBeEKVILYw4yOiD1YuZoEFW
         gZ2fYhpED9pQcl731oFOw1t3wAwlz89/O0vBvJbE2kNyysE17YKGGUVmNukNf0b5nRI+
         nHmfsQsCDSiQEPcG0eNOQVLUbP0u/gHqN0V16EIkiQvJuZygFylOluUzaQp+sA4trApf
         urlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Br6SCzkS+wuKYi19e3xLSc3mR0U+4wqwOebNtfju5TU=;
        b=p49Ud5gNN1SfNvRNUJ5zhQTjMzKZJcGrSInUkYJKsLi/aOHjSveJd+/eFoAC7Mo9K0
         vf368RB1DZSJ4hz7EzQouQmh8AatOrXbYnTkqmCUH2C2HLYp3zCxpFUYy33aiAoUp4tY
         hlBXiPuKZrH4IkpLfR6y6CFKqoPx8/cvDDoyQj9otnXPdrKGSXTUN32j+cUnxTRSEogA
         ZnvrF4+VdhqqmR8FsAhVLUYKsAYW1c4kW75XZujGUIzZWth00pz3hxwao9Ig7R+l2l6x
         3ksBf6CI17xWmBUEwUjTJbMztUHkdz6eHABA5qatxlGH/NJ8F46Fi2FIqAIh70bXBqhM
         ei0Q==
X-Gm-Message-State: AOAM53360xwFU4RP1usSQK/QOy//uMLH6qPSBAfGHDsstLVLyia1CggX
        zUnHjLpkh1LfA6O/Na88XQy3/i2TeS8=
X-Google-Smtp-Source: ABdhPJxRjXy6wWms907doYTrCPcJB/YLOSnqYxDZ1Ecdr7ZyMtC5rJ+0US3cn+nWJQ8Frq1ZYqMo2A==
X-Received: by 2002:a17:90b:3d0e:b0:1bb:8615:78d6 with SMTP id pt14-20020a17090b3d0e00b001bb861578d6mr9687078pjb.4.1645208286992;
        Fri, 18 Feb 2022 10:18:06 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:5c60:79a8:8f41:618f])
        by smtp.gmail.com with ESMTPSA id nh15-20020a17090b364f00b001bb7ab63027sm51836pjb.49.2022.02.18.10.18.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 10:18:06 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        bpf <bpf@vger.kernel.org>, Stanislav Fomichev <sdf@google.com>,
        Brian Vazquez <brianvv@google.com>
Subject: [PATCH bpf-next] bpf: Call maybe_wait_bpf_programs() only once from generic_map_delete_batch()
Date:   Fri, 18 Feb 2022 10:18:01 -0800
Message-Id: <20220218181801.2971275-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
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

From: Eric Dumazet <edumazet@google.com>

As stated in the comment found in maybe_wait_bpf_programs(),
the synchronize_rcu() barrier is only needed before returning
to userspace, not after each deletion in the batch.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Stanislav Fomichev <sdf@google.com>
Cc: Brian Vazquez <brianvv@google.com>
---
 kernel/bpf/syscall.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index a72f63d5a7daee057bcec3fa6119aca32e2945f7..9c7a72b65eee0ec8d54d36e2c0ab9ff4962091af 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1352,7 +1352,6 @@ int generic_map_delete_batch(struct bpf_map *map,
 		err = map->ops->map_delete_elem(map, key);
 		rcu_read_unlock();
 		bpf_enable_instrumentation();
-		maybe_wait_bpf_programs(map);
 		if (err)
 			break;
 		cond_resched();
@@ -1361,6 +1360,8 @@ int generic_map_delete_batch(struct bpf_map *map,
 		err = -EFAULT;
 
 	kvfree(key);
+
+	maybe_wait_bpf_programs(map);
 	return err;
 }
 
-- 
2.35.1.473.g83b2b277ed-goog

