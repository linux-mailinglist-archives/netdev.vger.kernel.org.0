Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17ACB4BA801
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 19:19:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244170AbiBQST2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 13:19:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235092AbiBQSTY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 13:19:24 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A82B51DE8B3;
        Thu, 17 Feb 2022 10:19:09 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id x11so5205180pll.10;
        Thu, 17 Feb 2022 10:19:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ySzwGOE+U2qlPrNi5jOXRQPdSTD9RwwIc00N8pv5+NA=;
        b=LwP6eSUUv55CJayFQM0yhSrA9rROx8NFJeh7nAwPc4FQ4pdpZ4HRfU7GLDAW0Ga7Rg
         LgC3nSD6YhlWzjhsbJY/O/6vhl9AUzN4IkLY8OREbmdEgnLZtJxCWzzQnTtnqGfUJd5j
         xEKpCrMLSxLtc4TuVU+zig0x/qR2QXx7ayWiM3cKU7Ai2cDuUS+7AxixxKf0LEZigYMj
         mt2nleuTVmaJ5sJbf9QqHuNbBfXesKD2Ln8FsiA6X4YSf5D+w/BN/dE0QhyUIPWHT4Gs
         moCc56LEsPu7yfsatQhQPUjdZaLLRDr3DPf678zNYSEGdtfHmuoSWgEYEUjfHsdKCM6k
         HV8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ySzwGOE+U2qlPrNi5jOXRQPdSTD9RwwIc00N8pv5+NA=;
        b=nQxehGKdPbB1TgqBKX7+NkM7BF/ra2ZCBYoAdRK8VYiVwpWah8RcUqx/58yBuKBPxD
         PNGczhYqidTQtrwSHSDYeb6Zc+7tCXuberyEcmk1/9J2w1SRTJp/NLj20ELNDqIM6n9A
         G8wTacaJes3/6SLB+oPUUhT2UsVnafXFTg+3ZuzywlIJQEmcDIqMpXyEqQhBXrO+DV4R
         aHZnO8H+jipV53JYUXXSlTCIu/tkMDXlc9BmW3I/wDifIJaXRPzhL8SNgV+gjF/zzr9i
         LdgGpFds/SwE4XwazGgH+TXFKlLupkGVgixxeStVyxHy53d1O3JuKxcvZXgZHSqk74m1
         J8Pg==
X-Gm-Message-State: AOAM531iafjosY02OcQQalWVdccBTKKoWxTTZH77S7XoTU0cnWk9Lm+Q
        GFb3xDvoLDC2cuRirK5um4c=
X-Google-Smtp-Source: ABdhPJzu+gC2AstACqu/5sieoC5520pQrFbDzb04QyflJsfLVnnYeps1fG0oRh0f+eg4ibadCyT9Tg==
X-Received: by 2002:a17:902:bd47:b0:14d:a8b7:236 with SMTP id b7-20020a170902bd4700b0014da8b70236mr3909662plx.20.1645121949174;
        Thu, 17 Feb 2022 10:19:09 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:8878:fd78:2268:60a3])
        by smtp.gmail.com with ESMTPSA id m126sm7375829pga.94.2022.02.17.10.19.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Feb 2022 10:19:08 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        bpf <bpf@vger.kernel.org>, Brian Vazquez <brianvv@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH bpf] bpf: add schedule points in batch ops
Date:   Thu, 17 Feb 2022 10:19:02 -0800
Message-Id: <20220217181902.808742-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
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

syzbot reported various soft lockups caused by bpf batch operations.

 INFO: task kworker/1:1:27 blocked for more than 140 seconds.
 INFO: task hung in rcu_barrier

Nothing prevents batch ops to process huge amount of data,
we need to add schedule points in them.

Note that maybe_wait_bpf_programs(map) calls from
generic_map_delete_batch() can be factorized by moving
the call after the loop.

This will be done later in -next tree once we get this fix merged,
unless there is strong opinion doing this optimization sooner.

Fixes: aa2e93b8e58e ("bpf: Add generic support for update and delete batch ops")
Fixes: cb4d03ab499d ("bpf: Add generic support for lookup batch op")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Brian Vazquez <brianvv@google.com>
Cc: Stanislav Fomichev <sdf@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 kernel/bpf/syscall.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index fa4505f9b6119bcb219ab9733847a98da65d1b21..ca70fe6fba387937dfb54f10826f19ac55a8a8e7 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1355,6 +1355,7 @@ int generic_map_delete_batch(struct bpf_map *map,
 		maybe_wait_bpf_programs(map);
 		if (err)
 			break;
+		cond_resched();
 	}
 	if (copy_to_user(&uattr->batch.count, &cp, sizeof(cp)))
 		err = -EFAULT;
@@ -1412,6 +1413,7 @@ int generic_map_update_batch(struct bpf_map *map,
 
 		if (err)
 			break;
+		cond_resched();
 	}
 
 	if (copy_to_user(&uattr->batch.count, &cp, sizeof(cp)))
@@ -1509,6 +1511,7 @@ int generic_map_lookup_batch(struct bpf_map *map,
 		swap(prev_key, key);
 		retry = MAP_LOOKUP_RETRIES;
 		cp++;
+		cond_resched();
 	}
 
 	if (err == -EFAULT)
-- 
2.35.1.265.g69c8d7142f-goog

