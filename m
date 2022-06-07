Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC6DB53F6C3
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 09:02:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237424AbiFGHCj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 03:02:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231392AbiFGHCf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 03:02:35 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25EE12BE4
        for <netdev@vger.kernel.org>; Tue,  7 Jun 2022 00:02:32 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id b5so14049368plx.10
        for <netdev@vger.kernel.org>; Tue, 07 Jun 2022 00:02:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=H34LxMkAFP+DkTgdcqrRm2gNvdKgyJnK0afFx5apcdM=;
        b=BshH9FExaBARPxGDTjy+z0IiBbCdbEiC97wtAlfvSxCTntXYxoPj+7Symtk+8fziZl
         QVZMaLcUKxEWGNR3Zg73d2e8WcjtVCYVFISgOkZLIzfrws0V+FjrywnzLSRdAK7d5sNg
         WGE+ec7PLKZrEiIKIQFhLw6jZXXgjVwBMEvTzYRbaFlqUitf3+r1Y0g7q5Wx7AWMs+XF
         3K0fVcVEghEtEbj3RqlZNFGOb+f48fM8al8iSKV28MnPLGgbqYbXsH3N4hmbXIIScZhV
         AvQHML/Tplr8ElTI/KpYLOBOwDIgL+LJDARI3WDMbT9o4/oIwX40YHQXSpoK5VlZ4yg3
         Reuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=H34LxMkAFP+DkTgdcqrRm2gNvdKgyJnK0afFx5apcdM=;
        b=KJD22C0eBv57P9xVvL2uY09yfxd4BsYiJHhaFpKY0y/9R7jumfXFoYqqUGFOBHM7Tc
         H43okcsnGZGKiQYOL40gFFoiApvALpoHtniIVP53QcSQMCvupoNx5sq1wnveFC7IEAXg
         dyz+gSpRUMxGS17i03Z3VB+UrV3qzfkdrRPY+lYwjW33bSwsoqpRVw87Vq0yZyomkLcK
         zSrvgFL7n92NX7WfvU6hTRsP73SScxrmCx827PFgvH7ePkHzbbn7fk8d+g/1wacD0WcO
         lKqUyA9JLX4XfjuynfmW6epWu4DFX+YoFL8tGx9e3+07VrIG+GFnh09NeCUaWtfUc1ih
         E2qA==
X-Gm-Message-State: AOAM530V+LthVqv2/SD4jfmh9u+KhhYoZPfwPjqXAvDSaa+GBvFVBiyG
        pC7zKtlpR/skjtq3MlXOZUi8og==
X-Google-Smtp-Source: ABdhPJzErMTWpUOSIazPoK/DQ/jVv6WZiYOMns5RvsYTnEWA9p099f8YkGl+nWZsg9w3GEiIvOOovg==
X-Received: by 2002:a17:902:cf0f:b0:15a:24e0:d9b0 with SMTP id i15-20020a170902cf0f00b0015a24e0d9b0mr27333000plg.42.1654585351518;
        Tue, 07 Jun 2022 00:02:31 -0700 (PDT)
Received: from FVFYT0MHHV2J.bytedance.net ([139.177.225.238])
        by smtp.gmail.com with ESMTPSA id t27-20020aa7947b000000b0051c0fe8fb8csm4193687pfq.95.2022.06.07.00.02.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jun 2022 00:02:31 -0700 (PDT)
From:   Muchun Song <songmuchun@bytedance.com>
To:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org, w@1wt.eu,
        Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v2] tcp: use alloc_large_system_hash() to allocate table_perturb
Date:   Tue,  7 Jun 2022 15:02:14 +0800
Message-Id: <20220607070214.94443-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.32.1 (Apple Git-133)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In our server, there may be no high order (>= 6) memory since we reserve
lots of HugeTLB pages when booting.  Then the system panic.  So use
alloc_large_system_hash() to allocate table_perturb.

Fixes: e9261476184b ("tcp: dynamically allocate the perturb table used by source ports")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
v2:
 - Add Fixes tag and replace kvmalloc_array with alloc_large_system_hash suggested
   by Eric Dumazet.

 net/ipv4/inet_hashtables.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index e8de5e699b3f..545f91b6cb5e 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -1026,10 +1026,12 @@ void __init inet_hashinfo2_init(struct inet_hashinfo *h, const char *name,
 	init_hashinfo_lhash2(h);
 
 	/* this one is used for source ports of outgoing connections */
-	table_perturb = kmalloc_array(INET_TABLE_PERTURB_SIZE,
-				      sizeof(*table_perturb), GFP_KERNEL);
-	if (!table_perturb)
-		panic("TCP: failed to alloc table_perturb");
+	table_perturb = alloc_large_system_hash("Table-perturb",
+						sizeof(*table_perturb),
+						INET_TABLE_PERTURB_SIZE,
+						0, 0, NULL, NULL,
+						INET_TABLE_PERTURB_SIZE,
+						INET_TABLE_PERTURB_SIZE);
 }
 
 int inet_hashinfo2_init_mod(struct inet_hashinfo *h)
-- 
2.11.0

