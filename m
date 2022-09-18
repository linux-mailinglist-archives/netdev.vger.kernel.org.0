Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F75C5BC05C
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 00:18:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbiIRWSJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 18:18:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbiIRWSH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 18:18:07 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3112517E0C;
        Sun, 18 Sep 2022 15:18:07 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id c198so26344153pfc.13;
        Sun, 18 Sep 2022 15:18:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=sdMjgVjjAnbiiUNEW0iYZefKbrfHrYNSoqWXWFLophY=;
        b=E1NybUn6BAtU07WgYjFs7GXDT6zfdF1lkijuQVgKAU8v9oRgKGf0lllhOBhyPJ0MiZ
         kHJhyfEa+JmOuBr3VnV5mtM6HLiHP5o4D27PhkwBNfcG76j5uFyCqw132b41CbZMcyty
         cMnzDyxj+r8BeC3B9J/Ovl4B8QJdjgMkvGxRPLncLQnD281IZZUT1mI8/TL/V7jjPzax
         oAyP8J8teVU/Tt9inaZm5IyEEhLIOf4U5WOAxUJkGOH+k5dqSao6Ffj2yRDugJWyw2Ro
         D+MGfPQtUsPiT4B6b8Rmze5AfLonp0rjnfOGXMC6jUg2LN09PxbIIZs6Z7z+uxxzKl5u
         NT3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=sdMjgVjjAnbiiUNEW0iYZefKbrfHrYNSoqWXWFLophY=;
        b=LKnkM4V54ZsJtLXv8more94hgLs+4Wn/ZC+dCO3Wh+pCjIs+LVP/akLJiVMx0yI7IV
         Kn7QD4d+/0RLE5k3LNvmZxqIQh4TmUe8etYN9FnOhr9dRmBpKcQ4SPmRgdMrojEvqMm7
         hbjSzAU0Wm5Fb0Ft8C+ISlrpyIKQ/a13Iz5dTf3+u/+ZUBd89897ZSj/e2Ybaka54Gd9
         1UQxpSXP3ipjL+4ALxid0xZ00t+MTQBHvKDU+tc2Ex2NJAjgcwrrQmW06e3IpA67Lq9G
         8jlO2TO44tv891+3DQyOOFe2ABg9HRs/1VVb13F4UfCzaYlViGFhVS/tT8E6+/6anxVA
         bfPg==
X-Gm-Message-State: ACrzQf1ePZLOfp+iJpWOPQ0b0srmvX+smjI6i475bE38dAn/MueGoDH4
        2mV8k8eKtY99HC6UpwFyZru6qvjKvksrlg==
X-Google-Smtp-Source: AMsMyM6xUUZ+BaqIhTuUMDzaPNBCTSsTR/5KEfYxUIdSQpR+aVEyBC0U6jRLqZP5qXYS8o+zm3sbJg==
X-Received: by 2002:a65:6c11:0:b0:439:ebfb:f8cb with SMTP id y17-20020a656c11000000b00439ebfbf8cbmr5595306pgu.6.1663539486383;
        Sun, 18 Sep 2022 15:18:06 -0700 (PDT)
Received: from localhost.localdomain (lily-optiplex-3070.dynamic.ucsd.edu. [2607:f720:1300:3033::1:4dd])
        by smtp.googlemail.com with ESMTPSA id rm2-20020a17090b3ec200b001fde655225fsm17286524pjb.2.2022.09.18.15.18.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Sep 2022 15:18:05 -0700 (PDT)
From:   Li Zhong <floridsleeves@gmail.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org
Cc:     pabeni@redhat.com, kuba@kernel.org, edumazet@google.com,
        davem@davemloft.net, anthony.l.nguyen@intel.com,
        jesse.brandeburg@intel.com, Li Zhong <floridsleeves@gmail.com>
Subject: [PATCH v1] drivers/net/ethernet/intel/e100: Check the return value of e100_exec_cmd()
Date:   Sun, 18 Sep 2022 15:17:50 -0700
Message-Id: <20220918221750.1065134-1-floridsleeves@gmail.com>
X-Mailer: git-send-email 2.25.1
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

Check the return value of e100_exec_cmd(), which could be error when the
command execution fail.

Signed-off-by: Li Zhong <floridsleeves@gmail.com>
---
 drivers/net/ethernet/intel/e100.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/e100.c b/drivers/net/ethernet/intel/e100.c
index 11a884aa5082..f785dd73d537 100644
--- a/drivers/net/ethernet/intel/e100.c
+++ b/drivers/net/ethernet/intel/e100.c
@@ -1903,6 +1903,8 @@ static int e100_alloc_cbs(struct nic *nic)
 
 static inline void e100_start_receiver(struct nic *nic, struct rx *rx)
 {
+	int err;
+
 	if (!nic->rxs) return;
 	if (RU_SUSPENDED != nic->ru_running) return;
 
@@ -1911,7 +1913,10 @@ static inline void e100_start_receiver(struct nic *nic, struct rx *rx)
 
 	/* (Re)start RU if suspended or idle and RFA is non-NULL */
 	if (rx->skb) {
-		e100_exec_cmd(nic, ruc_start, rx->dma_addr);
+		err = e100_exec_cmd(nic, ruc_start, rx->dma_addr);
+		if (err)
+			return;
+
 		nic->ru_running = RU_RUNNING;
 	}
 }
-- 
2.25.1

