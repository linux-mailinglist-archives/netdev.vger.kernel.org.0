Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 112A530535A
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 07:42:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231890AbhA0GmC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 01:42:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232509AbhA0Gh4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 01:37:56 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDB2BC061574;
        Tue, 26 Jan 2021 22:37:15 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id o16so917578pgg.5;
        Tue, 26 Jan 2021 22:37:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=W0uuLo/4/wCey2dN/nEYFd5YvwQZJzT08touWgY4O8w=;
        b=TUE4PN3EDWJkxwfN/6yW4sXh09Op1ZfGs87T0vPXMo2V2CUoevdBs0ZON/iG+qZZqz
         Nm+7tnV72tMSF8+lEMdVx9wuVGqcn6rbhUFJPh31xc6R/0sfQV6zjchM0y1DNW8J/s8Q
         neAWRok4qYmLx9jmUG4OJma0f84V4xDYy4W+F5xN0H7kyLR0OZxgB6/D9BWNxpAbhGMK
         Gpd+9oYmUvzguvnc2FbUsLpuJ5sio+bZwy+heoV5GnOIjqkxzajuyao/W+oxm0eNAI9Y
         vzqguRCGWWKF4XJtfqvSTXteaBP3M8p+TxQRSlIENIb1pTvDyj0mghBgYzOZtYT/NTiF
         QQ6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=W0uuLo/4/wCey2dN/nEYFd5YvwQZJzT08touWgY4O8w=;
        b=X9wxGjp/U8RgLolmO0llJFrQNaZav+PkHcJ8LV98VvfofM/ptNnMc60QtsXEsJlGhw
         uWGdl14lur++1TVBSyIMcizHFPYj1V+1uV8sjkGU1KbHvlx3mY/Jwd9wFOpwjNI7F7KG
         etLpDMNOvT6teGkPbTfeNTgKra6cbP/035cv4gZ9/wRCpuKUsHYh8YF5mdAMAq1MGORS
         XDNz0UnX/gOuCFTLjedXn0u7/JaVqlNrgANmqRtgDyNfXIvUh4JcLKSxve68Sv+0tvAJ
         ZUdaAhKdj+FMpZVrFIYUmDuglkHfxFkuktaPufrv/ycJeDZrqMk9q4T1ZZQubfsF3M4a
         0/3Q==
X-Gm-Message-State: AOAM5310abMjhFqpmAnWZJXn2v1lbqNXbm1LCrk5P6AG9sAm9ab7EWoW
        5qVS1HwVyNqgRfuNjXKGY9u4suzdqlBYoh0n
X-Google-Smtp-Source: ABdhPJzh1C84Hi+SAxJwm9/lhQAEyp9wdc9QrUhAJj915LWhtVjGpOpzm2MMrtRjVGk88F/LHp2GNg==
X-Received: by 2002:aa7:8f1c:0:b029:1c0:60c7:f7c5 with SMTP id x28-20020aa78f1c0000b02901c060c7f7c5mr9220246pfr.59.1611729435387;
        Tue, 26 Jan 2021 22:37:15 -0800 (PST)
Received: from android.asia-east2-a.c.savvy-summit-295307.internal (204.60.92.34.bc.googleusercontent.com. [34.92.60.204])
        by smtp.googlemail.com with ESMTPSA id v3sm1038824pff.217.2021.01.26.22.37.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jan 2021 22:37:14 -0800 (PST)
From:   Bui Quang Minh <minhquangbui99@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, minhquangbui99@gmail.com
Subject: [PATCH] bpf: Check for integer overflow when using roundup_pow_of_two()
Date:   Wed, 27 Jan 2021 06:36:53 +0000
Message-Id: <20210127063653.3576-1-minhquangbui99@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 32-bit architecture, roundup_pow_of_two() can return 0 when the argument
has upper most bit set due to resulting 1UL << 32. Add a check for this
case.

Fixes: d5a3b1f ("bpf: introduce BPF_MAP_TYPE_STACK_TRACE")
Signed-off-by: Bui Quang Minh <minhquangbui99@gmail.com>
---
 kernel/bpf/stackmap.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/bpf/stackmap.c b/kernel/bpf/stackmap.c
index aea96b638473..bfafbf115bf3 100644
--- a/kernel/bpf/stackmap.c
+++ b/kernel/bpf/stackmap.c
@@ -115,6 +115,8 @@ static struct bpf_map *stack_map_alloc(union bpf_attr *attr)
 
 	/* hash table size must be power of 2 */
 	n_buckets = roundup_pow_of_two(attr->max_entries);
+	if (!n_buckets)
+		return ERR_PTR(-E2BIG);
 
 	cost = n_buckets * sizeof(struct stack_map_bucket *) + sizeof(*smap);
 	cost += n_buckets * (value_size + sizeof(struct stack_map_bucket));
-- 
2.17.1

