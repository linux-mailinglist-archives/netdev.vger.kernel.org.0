Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 685D05EE403
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 20:12:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234032AbiI1SMv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 14:12:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234454AbiI1SMo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 14:12:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E54EABF17
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 11:12:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8182C61F4D
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 18:12:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DFA6C433C1;
        Wed, 28 Sep 2022 18:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664388761;
        bh=fPV/RiIx/VCD/CnQYa94sSikfKUKXfmn5fNibwNFvGU=;
        h=From:To:Cc:Subject:Date:From;
        b=khEfdoH7urZY+sFxMKVVotpgl2VnJbqSQ0We6fsJq3hOG4ntWe+DhLI4bM72VD6QM
         2MRhiTarr8hACfl3RiLLeR8skARwJXELKJ4jVYb1tFHyCcE5QTA6Ujs0Ka4GYwXn9O
         2ZTjzi5u/Sc6FKLIQedHn3L3D7InQfTu6XKn4vv8AzPOxWl40z7UiJbx1zrqofa6S8
         8VjJDrNV02Py/O2XqixY5124Wfd1NRrGazZ1aStZXYT3uqfboS+s7T9eaUNlE4CQc6
         no8evHugxKwHTCoXaN83JML5ak1ScoLLjgtV+Z0N0sK4RVI2PDXaNwOYbGbJlJhKbk
         9Mnrp8V8/CSAA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>,
        Zbynek Michl <zbynek.michl@gmail.com>, chris.snook@gmail.com,
        dossche.niels@gmail.com, johannes@sipsolutions.net
Subject: [PATCH net] eth: alx: take rtnl_lock on resume
Date:   Wed, 28 Sep 2022 11:12:36 -0700
Message-Id: <20220928181236.1053043-1-kuba@kernel.org>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zbynek reports that alx trips an rtnl assertion on resume:

 RTNL: assertion failed at net/core/dev.c (2891)
 RIP: 0010:netif_set_real_num_tx_queues+0x1ac/0x1c0
 Call Trace:
  <TASK>
  __alx_open+0x230/0x570 [alx]
  alx_resume+0x54/0x80 [alx]
  ? pci_legacy_resume+0x80/0x80
  dpm_run_callback+0x4a/0x150
  device_resume+0x8b/0x190
  async_resume+0x19/0x30
  async_run_entry_fn+0x30/0x130
  process_one_work+0x1e5/0x3b0

indeed the driver does not hold rtnl_lock during its internal close
and re-open functions during suspend/resume. Note that this is not
a huge bug as the driver implements its own locking, and does not
implement changing the number of queues, but we need to silence
the splat.

Fixes: 4a5fe57e7751 ("alx: use fine-grained locking instead of RTNL")
Reported-and-tested-by: Zbynek Michl <zbynek.michl@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: chris.snook@gmail.com
CC: dossche.niels@gmail.com
CC: johannes@sipsolutions.net
---
 drivers/net/ethernet/atheros/alx/main.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/atheros/alx/main.c b/drivers/net/ethernet/atheros/alx/main.c
index a89b93cb4e26..d5939586c82e 100644
--- a/drivers/net/ethernet/atheros/alx/main.c
+++ b/drivers/net/ethernet/atheros/alx/main.c
@@ -1912,11 +1912,14 @@ static int alx_suspend(struct device *dev)
 
 	if (!netif_running(alx->dev))
 		return 0;
+
+	rtnl_lock();
 	netif_device_detach(alx->dev);
 
 	mutex_lock(&alx->mtx);
 	__alx_stop(alx);
 	mutex_unlock(&alx->mtx);
+	rtnl_unlock();
 
 	return 0;
 }
@@ -1927,6 +1930,7 @@ static int alx_resume(struct device *dev)
 	struct alx_hw *hw = &alx->hw;
 	int err;
 
+	rtnl_lock();
 	mutex_lock(&alx->mtx);
 	alx_reset_phy(hw);
 
@@ -1943,6 +1947,7 @@ static int alx_resume(struct device *dev)
 
 unlock:
 	mutex_unlock(&alx->mtx);
+	rtnl_unlock();
 	return err;
 }
 
-- 
2.37.3

