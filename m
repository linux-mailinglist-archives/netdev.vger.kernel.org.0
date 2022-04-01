Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 125BE4EFD0F
	for <lists+netdev@lfdr.de>; Sat,  2 Apr 2022 01:24:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353179AbiDAX0G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 19:26:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237030AbiDAX0F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 19:26:05 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E919C65799
        for <netdev@vger.kernel.org>; Fri,  1 Apr 2022 16:24:14 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id bx24-20020a17090af49800b001c6872a9e4eso3823517pjb.5
        for <netdev@vger.kernel.org>; Fri, 01 Apr 2022 16:24:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fungible.com; s=google;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LlIGOC/t6orxeMu/DPZ2tOEeKUM52Yorezenz0quC3Y=;
        b=KFH1LQ342ynnuB96ZCrZPzI7t0Cle/iklG2aIHzYKrPgaqtyoL4cTidcfeSV4G162A
         irZmlyTw2HwJ0JveqM3lVXKR28uKoBNv6wYiQ4+JT+XRWD9gK4BGlZDwQgKlpBGYZgCu
         ohg4xe+cuWblW+d4YnkiyDT/DrbXWwK0UfriM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LlIGOC/t6orxeMu/DPZ2tOEeKUM52Yorezenz0quC3Y=;
        b=RDbWD8u+KdVkgnx32H4uN2T/kztA4Ha0dlA0dDdwT4gPexU5KcUAa0DnllNwV4WqRP
         9FiuYh8e5bCneP78FVlAHXimx3Teg7ntPD21XLjCqVlogc4DB0jLK6Je+TNWutpuLxPU
         rNnGGvtpJuaJkPP6vsKHxZ2wspYMxHNKdfOBbq2/d9GFvwrRrYpWHsK9PMhZT4vZdAun
         oxW6+FiGfAIf7NQTA1D0DWrB29Cu1Qxwuiu8hWwn9K1jlEIaHgF3GMKgNfhLlnF/0k36
         RywclClWTAnnQexHHhV5vx9pR6b/XyDgDyByyrZtGkefq/5MZAAh8G94GExXb36/VVH1
         4sdw==
X-Gm-Message-State: AOAM530nP8ns3hm/mCXjaEXoAELKRfEbIMSqoo5OUtzdD/6aA8ajDLWy
        JwDIN2P2gmTj9JCbjnxT9wsdTQ==
X-Google-Smtp-Source: ABdhPJyEL/C5eCN1OwLYO22RnVsVhe9rM+z31GneD9i3FGNKO2VJCHtOZds4xSpzPN14K0JeXkufSg==
X-Received: by 2002:a17:90a:db0f:b0:1ca:545e:df51 with SMTP id g15-20020a17090adb0f00b001ca545edf51mr942779pjv.29.1648855454440;
        Fri, 01 Apr 2022 16:24:14 -0700 (PDT)
Received: from cab09-qa-09.fungible.local ([12.190.10.11])
        by smtp.gmail.com with ESMTPSA id ck13-20020a056a00328d00b004fb1414476bsm4036579pfb.200.2022.04.01.16.24.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Apr 2022 16:24:13 -0700 (PDT)
From:   Dimitris Michailidis <d.michailidis@fungible.com>
X-Google-Original-From: Dimitris Michailidis <dmichail@fungible.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        d.michailidis@fungible.com, rdunlap@infradead.org
Subject: [PATCH net] net/fungible: Fix reference to __udivdi3 on 32b builds
Date:   Fri,  1 Apr 2022 16:24:11 -0700
Message-Id: <20220401232411.313881-1-dmichail@fungible.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

32b builds with CONFIG_PHYS_ADDR_T_64BIT=y, such as i386 PAE,
raise a linker error due to a 64b division:

ld: drivers/net/ethernet/fungible/funcore/fun_dev.o: in function
`fun_dev_enable':
(.text+0xe1a): undefined reference to `__udivdi3'

The divisor in the offendinng expression is a power of 2. Change it to
use an explicit right shift.

Fixes: e1ffcc66818f ("net/fungible: Add service module for Fungible drivers")
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Dimitris Michailidis <dmichail@fungible.com>
---
 drivers/net/ethernet/fungible/funcore/fun_dev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/fungible/funcore/fun_dev.c b/drivers/net/ethernet/fungible/funcore/fun_dev.c
index 5d7aef73df61..fb5120d90f26 100644
--- a/drivers/net/ethernet/fungible/funcore/fun_dev.c
+++ b/drivers/net/ethernet/fungible/funcore/fun_dev.c
@@ -586,8 +586,8 @@ static int fun_get_dev_limits(struct fun_dev *fdev)
 	/* Calculate the max QID based on SQ/CQ/doorbell counts.
 	 * SQ/CQ doorbells alternate.
 	 */
-	num_dbs = (pci_resource_len(pdev, 0) - NVME_REG_DBS) /
-		  (fdev->db_stride * 4);
+	num_dbs = (pci_resource_len(pdev, 0) - NVME_REG_DBS) >>
+		  (2 + NVME_CAP_STRIDE(fdev->cap_reg));
 	fdev->max_qid = min3(cq_count, sq_count, num_dbs / 2) - 1;
 	fdev->kern_end_qid = fdev->max_qid + 1;
 	return 0;
-- 
2.25.1

