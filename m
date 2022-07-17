Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D34A657732B
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 04:24:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230376AbiGQCY0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jul 2022 22:24:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiGQCYZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jul 2022 22:24:25 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51275B7E0
        for <netdev@vger.kernel.org>; Sat, 16 Jul 2022 19:24:24 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id m9so7212541ljp.9
        for <netdev@vger.kernel.org>; Sat, 16 Jul 2022 19:24:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=prwat4Ik8xHkzcRwLqAMZrYqOyhfQA85Ybzkfp94Lfk=;
        b=Cs8E+WCX+d+Mn/P1pWSIGmbkXtKD452JG8eI43VOJF+SI9e2+cbI3WdHiAR46sABWZ
         pMTwT9apKNSROE9lftSJAw1b/RYmGok4qvGDjiB4tXyZR656JD9mM0+GFKe8lFFUFzUw
         iO63Ye1GzRvowASugWOn4GL+Aby3MaYS93PQQfqls2wBuRMr56new9K+HAkCGh4VSODm
         JvgUDcyKB7GucyGLWtS20otL1p9jnY/kH4q4SSHkdLPxzLiAjdhzleyw6kgMlrr/ARyh
         muX5VdGxXoBVjQMrvng2mcRINgzl0N5olvtN9w+GVBwm6jRvA8MJubmIttwuwc72MhiN
         jQ/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=prwat4Ik8xHkzcRwLqAMZrYqOyhfQA85Ybzkfp94Lfk=;
        b=Q9MbkiHmJgf1m+f+UbF/mSk9gkNLkTsl/Yc+MNlPCBl4QJ2jANW5U1wbx/+yP5RPx2
         8PGioexwQAYTgZoLda7SgT2T58L+Zg5kdkn6ufYcHzsJYXFfeDj3nvGMdvVffMNGDTc9
         diBEBFsF864yNrUfwdQclPtVLMYS6POOMRqr504Jlykgm1j1MI414fPtk6yB0HiW6E84
         wxhbyGJYyW+Ch22OLMxiJGiGRjpsf8HyP3FYKTMXBeTHzv0NYforoiM0vbm8BQBPK1Rh
         ah2mWxfa+7PIekC3c9d33klEywoTFyKgY6P4+foRYCipzOMnrYNFyGKswvPaLXQzG7N3
         gj2Q==
X-Gm-Message-State: AJIora/Y3jc7igBPZe5FiYRfjbkEkIpne3WWE8ORJT6Iga7D31AorDUN
        kkL05Mmdw96/yapDdZ21Tg90QCoSGxM=
X-Google-Smtp-Source: AGRyM1sst8dbc8ipajL6qc+K9fUmoIKZC/s1YOi0JsaP/guTVKZ5/IYjj8ys+s0lhpV5w5ZodcJbVQ==
X-Received: by 2002:a2e:bf14:0:b0:255:b789:576b with SMTP id c20-20020a2ebf14000000b00255b789576bmr10146918ljr.47.1658024662409;
        Sat, 16 Jul 2022 19:24:22 -0700 (PDT)
Received: from localhost.localdomain ([149.62.15.87])
        by smtp.gmail.com with ESMTPSA id c28-20020ac25f7c000000b0047f750ecd8csm1767224lfc.67.2022.07.16.19.24.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Jul 2022 19:24:22 -0700 (PDT)
From:   Andrey Turkin <andrey.turkin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Ronak Doshi <doshir@vmware.com>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        Andrey Turkin <andrey.turkin@gmail.com>
Subject: [PATCH] vmxnet3: Record queue number to incoming packets
Date:   Sun, 17 Jul 2022 02:20:50 +0000
Message-Id: <20220717022050.822766-2-andrey.turkin@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220717022050.822766-1-andrey.turkin@gmail.com>
References: <20220717022050.822766-1-andrey.turkin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make generic XDP processing attribute packets to their actual
queues instead of queue #0. This improves AF_XDP performance
considerably since softirq threads no longer fight over single
AF_XDP socket spinlock.

Signed-off-by: Andrey Turkin <andrey.turkin@gmail.com>
---
 drivers/net/vmxnet3/vmxnet3_drv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index 93e8d119d45f..479e640513dc 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -1503,6 +1503,7 @@ vmxnet3_rq_rx_complete(struct vmxnet3_rx_queue *rq,
 					     hash_type);
 			}
 #endif
+			skb_record_rx_queue(ctx->skb, rq->qid);
 			skb_put(ctx->skb, rcd->len);
 
 			if (VMXNET3_VERSION_GE_2(adapter) &&
-- 
2.25.1

