Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A727531481
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 18:25:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237247AbiEWOdq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 10:33:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237239AbiEWOdp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 10:33:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCA655932E;
        Mon, 23 May 2022 07:33:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A264611B0;
        Mon, 23 May 2022 14:33:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B24D9C385AA;
        Mon, 23 May 2022 14:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653316421;
        bh=6r/B2OiSPv2B6dH1KlUZS6QI0noV85NyqC24Oc19PEo=;
        h=From:To:Cc:Subject:Date:From;
        b=lOs2ImVwgVmmINHSludw0yNi1tbrS3ywDZ2SfgkBtafqAZswN4yzgTqV9IF//YBmk
         8QS4lcNCnRkaHau7Vkk/6hCF8iB2ULjSDbWrIITHFz7BCHGVusWg9jkBBKLmnV0bUS
         rIQKTCrxgBr0klOfwKBUgrazCgNgC7GoqRnVagX+urlz4Mhn/+yKv5moFKHn/Kaqsd
         S4EuLecAlegL7wm+R2XrBidnYA/w1wcF27a8MQSZk1qeChz3T9zxc+UjB9ZfUAp33a
         dFCIGc2ucp4JoMgBApju9s8Qkke1fvexvLh3o8hQuHSJNDRh6FjJCuphrFsf5FTUlT
         EuvlRrb/SkOuw==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan+linaro@kernel.org>)
        id 1nt97p-0006Sw-T1; Mon, 23 May 2022 16:33:37 +0200
From:   Johan Hovold <johan+linaro@kernel.org>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Johan Hovold <johan+linaro@kernel.org>
Subject: [PATCH] ath11k: fix IRQ affinity warning on shutdown
Date:   Mon, 23 May 2022 16:32:58 +0200
Message-Id: <20220523143258.24818-1-johan+linaro@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make sure to clear the IRQ affinity hint also on shutdown to avoid
triggering a WARN_ON_ONCE() in __free_irq() when stopping MHI while
using a single MSI vector.

Fixes: e94b07493da3 ("ath11k: Set IRQ affinity to CPU0 in case of one MSI vector")
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
---
 drivers/net/wireless/ath/ath11k/pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/pci.c b/drivers/net/wireless/ath/ath11k/pci.c
index dedf1b88ddf6..487a303b3077 100644
--- a/drivers/net/wireless/ath/ath11k/pci.c
+++ b/drivers/net/wireless/ath/ath11k/pci.c
@@ -920,7 +920,9 @@ static void ath11k_pci_remove(struct pci_dev *pdev)
 static void ath11k_pci_shutdown(struct pci_dev *pdev)
 {
 	struct ath11k_base *ab = pci_get_drvdata(pdev);
+	struct ath11k_pci *ab_pci = ath11k_pci_priv(ab);
 
+	ath11k_pci_set_irq_affinity_hint(ab_pci, NULL);
 	ath11k_pci_power_down(ab);
 }
 
-- 
2.35.1

