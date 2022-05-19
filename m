Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7606E52C8D1
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 02:44:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231998AbiESAn4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 20:43:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232375AbiESAnt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 20:43:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32745188E44
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 17:43:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ECCD6B82263
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 00:43:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F000C385A5;
        Thu, 19 May 2022 00:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652921025;
        bh=1KHCze923GMPRBdWjV3/vdfqnr8thCi4gJ45x5aXIL4=;
        h=From:To:Cc:Subject:Date:From;
        b=Le/MVIBr0eZ07qA4eujWJImDknEnGjoFQJnaTpBcgGRQcA/BptNVwi+i0ffxzjfWd
         3DSvuFO0cMQxXlHWrXI+JDPyCvyqJl10aFWCRrxOU2QuiCcCSY3Zs/OZS9Ffcl6yW5
         wHsq3N7ynY9VVWyOSUdAr1ganNbY8jNgJbaaAbkJLW+YjJgTK+yey7UycHfmlHX149
         YTXs5FZt7q3g97cugXfttf5VL4LwjCQ8I/hVFPR4IxV9TK5QkgDqAsHi3FeNvAaO0s
         CkLi+nKcguWM9h0uJTURRODy88OPBvY1oMyg6Y3lB1tVqE6dR2F+ZVSxjdYZyOsGJS
         raPS3NEQN0R8A==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>, m.chetan.kumar@intel.com,
        linuxwwan@intel.com, loic.poulain@linaro.org,
        ryazanov.s.a@gmail.com, johannes@sipsolutions.net
Subject: [PATCH net-next] net: wwan: iosm: remove pointless null check
Date:   Wed, 18 May 2022 17:43:42 -0700
Message-Id: <20220519004342.2109832-1-kuba@kernel.org>
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

GCC 12 warns:

drivers/net/wwan/iosm/iosm_ipc_protocol_ops.c: In function ‘ipc_protocol_dl_td_process’:
drivers/net/wwan/iosm/iosm_ipc_protocol_ops.c:406:13: warning: the comparison will always evaluate as ‘true’ for the address of ‘cb’ will never be NULL [-Waddress]
  406 |         if (!IPC_CB(skb)) {
      |             ^

Indeed the check seems entirely pointless. Hopefully the other
validation checks will catch if the cb is bad, but it can't be
NULL.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: m.chetan.kumar@intel.com
CC: linuxwwan@intel.com
CC: loic.poulain@linaro.org
CC: ryazanov.s.a@gmail.com
CC: johannes@sipsolutions.net
---
 drivers/net/wwan/iosm/iosm_ipc_protocol_ops.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_protocol_ops.c b/drivers/net/wwan/iosm/iosm_ipc_protocol_ops.c
index c6b032f95d2e..4627847c6daa 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_protocol_ops.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_protocol_ops.c
@@ -372,8 +372,6 @@ bool ipc_protocol_dl_td_prepare(struct iosm_protocol *ipc_protocol,
 struct sk_buff *ipc_protocol_dl_td_process(struct iosm_protocol *ipc_protocol,
 					   struct ipc_pipe *pipe)
 {
-	u32 tail =
-		le32_to_cpu(ipc_protocol->p_ap_shm->tail_array[pipe->pipe_nr]);
 	struct ipc_protocol_td *p_td;
 	struct sk_buff *skb;
 
@@ -403,14 +401,6 @@ struct sk_buff *ipc_protocol_dl_td_process(struct iosm_protocol *ipc_protocol,
 		goto ret;
 	}
 
-	if (!IPC_CB(skb)) {
-		dev_err(ipc_protocol->dev, "pipe# %d, tail: %d skb_cb is NULL",
-			pipe->pipe_nr, tail);
-		ipc_pcie_kfree_skb(ipc_protocol->pcie, skb);
-		skb = NULL;
-		goto ret;
-	}
-
 	if (p_td->buffer.address != IPC_CB(skb)->mapping) {
 		dev_err(ipc_protocol->dev, "invalid buf=%llx or skb=%p",
 			(unsigned long long)p_td->buffer.address, skb->data);
-- 
2.34.3

