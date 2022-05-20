Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 680EC52F3EF
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 21:44:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353307AbiETTnj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 15:43:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350599AbiETTn3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 15:43:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE70F19579C;
        Fri, 20 May 2022 12:43:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A8D85B82DC7;
        Fri, 20 May 2022 19:43:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 087F1C385A9;
        Fri, 20 May 2022 19:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653075806;
        bh=kGj4DK2AiH/Fy8GJN92csFdqlx0nkTXqzwCAsyBJgCQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ujl4OyJMJhXcqy94icUbv39kImT4xeeZYppNS3omDd7APZFsYsnU6qWEs0/odVo1y
         tkYZ5xiY7XkxCkbhwnkkzkctDZcIwa0M3XbUb1Ju+W4nB2TS1JgkcHXD3vPWUGAYcp
         yi4wWQk1iQjhKegscrs6OKQzog7wf6kJtGAvcyhIRJ7btcLoOIhB2DCfENUUIXzjQD
         85L1C7q0AJW+U//aORTDKGZ1Z5DybNElM2OIB5mO39yxlHIbba8dwyL2dbNQxZw6Jk
         zEaKnVwUM0d0wNcrM4tBQKX/CupOACOiJCTjfUXIW8/U8EdVF25EyvfKHKfUT0oq2p
         qWP7ITzwix7Uw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     kvalo@kernel.org, johannes@sipsolutions.net
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>, gregory.greenman@intel.com,
        luciano.coelho@intel.com, johannes.berg@intel.com
Subject: [PATCH net-next 5/8] wifi: iwlwifi: use unsigned to silence a GCC 12 warning
Date:   Fri, 20 May 2022 12:43:17 -0700
Message-Id: <20220520194320.2356236-6-kuba@kernel.org>
X-Mailer: git-send-email 2.34.3
In-Reply-To: <20220520194320.2356236-1-kuba@kernel.org>
References: <20220520194320.2356236-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

GCC 12 says:

drivers/net/wireless/intel/iwlwifi/mvm/sta.c:1076:37: warning: array subscript -1 is below array bounds of ‘struct iwl_mvm_tid_data[9]’ [-Warray-bounds]
 1076 |                 if (mvmsta->tid_data[tid].state != IWL_AGG_OFF)
      |                     ~~~~~~~~~~~~~~~~^~~~~

Whatever, tid is a bit from for_each_set_bit(), it's clearly unsigned.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: gregory.greenman@intel.com
CC: kvalo@kernel.org
CC: luciano.coelho@intel.com
CC: johannes.berg@intel.com
CC: linux-wireless@vger.kernel.org
---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 406f0a50a5bf..bbb1522e7280 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -1058,7 +1058,7 @@ static bool iwl_mvm_remove_inactive_tids(struct iwl_mvm *mvm,
 					 unsigned long *unshare_queues,
 					 unsigned long *changetid_queues)
 {
-	int tid;
+	unsigned int tid;
 
 	lockdep_assert_held(&mvmsta->lock);
 	lockdep_assert_held(&mvm->mutex);
-- 
2.34.3

