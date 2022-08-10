Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B61258EF24
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 17:18:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233050AbiHJPSs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 11:18:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229867AbiHJPSq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 11:18:46 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36A0E7820B;
        Wed, 10 Aug 2022 08:18:46 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id u133so13972593pfc.10;
        Wed, 10 Aug 2022 08:18:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=iWaAjku+9DHBSIX7N6Ue4B+MVNq84IC+6QjMUqI3TB0=;
        b=CPgLyVnidMMk4GxlhvJN9csE3zFaEsw0RkDcky9edtzCViXQGvkkolE7C4TauVH1QK
         2nwbPpGvXiEawLGVclFMmxHrdzGXGedWIq7VVtZ5LJZV4uDTybEQXg2lZo1vIrf119fs
         5a+PGRzH49LiiCC6cxeXW2R8+oPDi4Yqx67nioX52IQnf6F7a7PqSh3xeeN3GOKYuAGv
         UoZusZOzrP/kcTKXc+27w4CadHPevkiaH6PG5MPg4w589WghL5lDmrgT3NjzroR+Eo8x
         gORQJLAFVP5SqSrnPdA7oiaRP1IG1vN1c0YUxc1BT1Ff8ORvSMv7a3Vlh0p57unUFgrA
         YLPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=iWaAjku+9DHBSIX7N6Ue4B+MVNq84IC+6QjMUqI3TB0=;
        b=2TzZpmZNeKdG26OHvn2EdYi/SmlscMqQaK/nA/BC98kErpg+aM7p9vSsYb5ZEOToxS
         KWq1GB5H+1ryAdliVECFwyP9OC1Eta8CSXiaNU/aLmPatQZjWOml70Qa1hnO+biu5ZPM
         7FuA6KA//rRvrA1FKk8RcwTHtb3v+2KShnbB4GVVADOmBistDI8oV1Z4FfJehhMiyqHD
         NlFYm7XbyXZ/84QbkpIo4tPlWCNgWPC6yxVEVzxjrzG+LJdLLqniM/0UudTNFOvR7Gon
         LSbVGVStXkqYc7HHtYTJzfs0GFusC888b5+GzAy3jBX4KV0tATZH3g6fGZeX9Z/KuR5/
         GK4g==
X-Gm-Message-State: ACgBeo1ikQ1QelnHbKJT/f3VTsoDIiHl1Ct0FmZrumgVzv4gr9GH19Q/
        qOAjARDv65UNcg4FXvd9JAo=
X-Google-Smtp-Source: AA6agR7sx3QNeFXPD4mnbqj/uQJmqwZMeBLMKJlcJXBo6ebE+MWM5vHtGHaBxs5FWyjJha+MVy6bOg==
X-Received: by 2002:a63:494a:0:b0:41c:f29e:2a2e with SMTP id y10-20020a63494a000000b0041cf29e2a2emr22391660pgk.477.1660144725756;
        Wed, 10 Aug 2022 08:18:45 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:5c3e:5400:4ff:fe19:c3bc])
        by smtp.gmail.com with ESMTPSA id 85-20020a621558000000b0052b6ed5ca40sm2071935pfv.192.2022.08.10.08.18.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Aug 2022 08:18:44 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, hannes@cmpxchg.org,
        mhocko@kernel.org, roman.gushchin@linux.dev, shakeelb@google.com,
        songmuchun@bytedance.com, akpm@linux-foundation.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
        Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH bpf-next 01/15] bpf: Remove unneeded memset in queue_stack_map creation
Date:   Wed, 10 Aug 2022 15:18:26 +0000
Message-Id: <20220810151840.16394-2-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220810151840.16394-1-laoar.shao@gmail.com>
References: <20220810151840.16394-1-laoar.shao@gmail.com>
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

__GFP_ZERO will clear the memory, so we don't need to memset it.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 kernel/bpf/queue_stack_maps.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/bpf/queue_stack_maps.c b/kernel/bpf/queue_stack_maps.c
index a1c0794..8a5e060 100644
--- a/kernel/bpf/queue_stack_maps.c
+++ b/kernel/bpf/queue_stack_maps.c
@@ -78,8 +78,6 @@ static struct bpf_map *queue_stack_map_alloc(union bpf_attr *attr)
 	if (!qs)
 		return ERR_PTR(-ENOMEM);
 
-	memset(qs, 0, sizeof(*qs));
-
 	bpf_map_init_from_attr(&qs->map, attr);
 
 	qs->size = size;
-- 
1.8.3.1

