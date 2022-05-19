Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89A1B52C8DB
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 02:45:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230282AbiESAoe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 20:44:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231633AbiESAoZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 20:44:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 467A660AB1
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 17:44:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C703661760
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 00:44:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2DA1C385A5;
        Thu, 19 May 2022 00:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652921063;
        bh=Jh4eDlYKr4vxSbm/Qwtm/XL3RGowImkXoGQbfJe/bi4=;
        h=From:To:Cc:Subject:Date:From;
        b=OdeTJlSkSSfG7pwaJTdVp8lySzTT6xVK5/gsZ/tdkUMz8hV485CihS0Of2qj6EAjK
         i7SHQU146qnKnbc7tQVub0cf7kO3hcsg54rMv9yYdM9fQwa/tsHZKa6L+9RE+/TMr6
         ZZwV83KV2NjIp+x/tfREA61VSNN8oTBwC2Mz94nn8IpwyIIe7AP2FQoa5BDQBTdMN+
         Zgf5ud+RV+od4fHe69u/MlSOG5HUIzZQerpTGCdFxm9HNGYfdlEVoVG573i7vWGwgU
         yyD8iGkQhjh4e2xOzg7yYxjf0nUnTBX1hYuBudecCO6U8O9jYZGmoVny3tZ5qtGIvl
         23G2ui0YTieiA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>, elder@kernel.org
Subject: [PATCH net-next] net: ipa: don't proceed to out-of-bound write
Date:   Wed, 18 May 2022 17:44:17 -0700
Message-Id: <20220519004417.2109886-1-kuba@kernel.org>
X-Mailer: git-send-email 2.34.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

GCC 12 seems upset that we check ipa_irq against array bound
but then proceed, anyway:

drivers/net/ipa/ipa_interrupt.c: In function ‘ipa_interrupt_add’:
drivers/net/ipa/ipa_interrupt.c:196:27: warning: array subscript 30 is above array bounds of ‘void (*[30])(struct ipa *, enum ipa_irq_id)’ [-Warray-bounds]
  196 |         interrupt->handler[ipa_irq] = handler;
      |         ~~~~~~~~~~~~~~~~~~^~~~~~~~~
drivers/net/ipa/ipa_interrupt.c:42:27: note: while referencing ‘handler’
   42 |         ipa_irq_handler_t handler[IPA_IRQ_COUNT];
      |                           ^~~~~~~

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: elder@kernel.org
---
 drivers/net/ipa/ipa_interrupt.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ipa/ipa_interrupt.c b/drivers/net/ipa/ipa_interrupt.c
index b35170a93b0f..307bed2ee707 100644
--- a/drivers/net/ipa/ipa_interrupt.c
+++ b/drivers/net/ipa/ipa_interrupt.c
@@ -191,7 +191,8 @@ void ipa_interrupt_add(struct ipa_interrupt *interrupt,
 	struct ipa *ipa = interrupt->ipa;
 	u32 offset;
 
-	WARN_ON(ipa_irq >= IPA_IRQ_COUNT);
+	if (WARN_ON(ipa_irq >= IPA_IRQ_COUNT))
+		return;
 
 	interrupt->handler[ipa_irq] = handler;
 
@@ -208,7 +209,8 @@ ipa_interrupt_remove(struct ipa_interrupt *interrupt, enum ipa_irq_id ipa_irq)
 	struct ipa *ipa = interrupt->ipa;
 	u32 offset;
 
-	WARN_ON(ipa_irq >= IPA_IRQ_COUNT);
+	if (WARN_ON(ipa_irq >= IPA_IRQ_COUNT))
+		return;
 
 	/* Update the IPA interrupt mask to disable it */
 	interrupt->enabled &= ~BIT(ipa_irq);
-- 
2.34.3

