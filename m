Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D69AA4A4677
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 12:58:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376413AbiAaL6w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 06:58:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378545AbiAaL6C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 06:58:02 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F41EEC06175A;
        Mon, 31 Jan 2022 03:46:12 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id k17so12181738plk.0;
        Mon, 31 Jan 2022 03:46:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2LshZ+k3yxfozJYiL0Vvmb7zr16k7OxfcJf3YiQB8OU=;
        b=gVEqmyYpS4E5wGPfzb+OCHerQ0kpTF2TUYWo5J3fb+FenZtuWOpANbT8qkI1PiWehd
         kvzfB8SbZV5QSs6t8BEaQHotxt6Lj3FyRQ67IdsU3D1t6+rSK3v6uA1tG0Ob/zkfeYw6
         PvV5G6dL/QNzshf9MQyz3bKRhM7ON3i307Nz2SMaPNdivLPQ48HKv8Cw+WfTdNZIL8va
         c0qpxsXtRTn2gqMH/t7BUSt9akPP6nwHjeg3YVLmIF4aomGuGd3EPDl+XiLGlro9IM9L
         4t+9GdSBkFCB32armWBE6doeh3m573hrBR2+x2HvUKN9V/ZRD+dQrG/UAHfXNzcz5RC1
         112Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2LshZ+k3yxfozJYiL0Vvmb7zr16k7OxfcJf3YiQB8OU=;
        b=qKcD49QgQS2o/9//Jh0JQlBXzi2Nkts3JtgJblwEBsTpGDqQPrg7DG3O0j5s4dOM14
         lKy07II3wS48M32HzITBmrzMTHT7jRC0AqnWCo/OOEejAYAmTAk92Lgj85xOwLL0e5gN
         4jlibbmV1Tce/idBT2VOkl1AteqBUn1GqPzZK/GS1rqGYqFUdmm9/xHO+mKfQUB/Vrmm
         uffG110bi+7HibD5yADllz45sB0ZxOXKCa92N+jCfkhDdRzrJjiIFYmLYlUrVoz4Qzco
         sBmc0aP2cB0rogGQE4Ko+fY0jj/r8XlfkFq4rp6QWmmNW0z3veK9HMEWqXqOcIkYxJ34
         /C5w==
X-Gm-Message-State: AOAM533pvuyceEeTZBEhvBKe5cMl4S1oDq+C+aMSkXBaUprSzfavhv1Y
        WAN7H2djFyhInBFrSTrZfumsM8ZacCClzA==
X-Google-Smtp-Source: ABdhPJyrokr21nAAo8ywhF0RHkt/UlLAJ7G1HaG4SUfaJepDBODWmTOxwC3WSvMa1eRD2ZLDwwaCSg==
X-Received: by 2002:a17:903:188:: with SMTP id z8mr1147290plg.119.1643629572454;
        Mon, 31 Jan 2022 03:46:12 -0800 (PST)
Received: from localhost (61-223-193-169.dynamic-ip.hinet.net. [61.223.193.169])
        by smtp.gmail.com with ESMTPSA id nn4sm11123246pjb.39.2022.01.31.03.46.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jan 2022 03:46:11 -0800 (PST)
From:   Hou Tao <hotforest@gmail.com>
X-Google-Original-From: Hou Tao <houtao1@huawei.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org, houtao1@huawei.com
Subject: [PATCH bpf-next] bpf: use VM_MAP instead of VM_ALLOC for ringbuf
Date:   Mon, 31 Jan 2022 19:46:00 +0800
Message-Id: <20220131114600.21849-1-houtao1@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now the ringbuf area in /proc/vmallocinfo is showed as vmalloc,
but VM_ALLOC is only used for vmalloc(), and for the ringbuf area
it is created by mapping allocated pages, so use VM_MAP instead.

After the change, ringbuf info in /proc/vmallocinfo will changed from:
  [start]-[end]   24576 ringbuf_map_alloc+0x171/0x290 vmalloc user
to
  [start]-[end]   24576 ringbuf_map_alloc+0x171/0x290 vmap user

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 kernel/bpf/ringbuf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/ringbuf.c b/kernel/bpf/ringbuf.c
index 638d7fd7b375..710ba9de12ce 100644
--- a/kernel/bpf/ringbuf.c
+++ b/kernel/bpf/ringbuf.c
@@ -104,7 +104,7 @@ static struct bpf_ringbuf *bpf_ringbuf_area_alloc(size_t data_sz, int numa_node)
 	}
 
 	rb = vmap(pages, nr_meta_pages + 2 * nr_data_pages,
-		  VM_ALLOC | VM_USERMAP, PAGE_KERNEL);
+		  VM_MAP | VM_USERMAP, PAGE_KERNEL);
 	if (rb) {
 		kmemleak_not_leak(pages);
 		rb->pages = pages;
-- 
2.20.1

