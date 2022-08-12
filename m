Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F15C85914BF
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 19:23:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238666AbiHLRX1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 13:23:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237992AbiHLRXU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 13:23:20 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D42AB2490
        for <netdev@vger.kernel.org>; Fri, 12 Aug 2022 10:23:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660325000; x=1691861000;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/1VBxrCN2fjIF05RGteZ5bU8n8lorWLvY/y9d87GZ4o=;
  b=XMkRu7qpoNHCnOL4GHLaJHBSLulIK2QAgnGEYWBEhUvc9HbUQVvYh4xy
   +gTfKF7rQj8SZJ66ArzdMRZ5dUOvQr6XyaduhTsBMtrLZeeGBrhJThyRT
   uqFrg/LOQXSxfgRViFYwF2/hk88OBErzdg5vgdj1fHVV/LiXkbgvx1Elq
   Mo3bVVh4ypSWMvCLt4H32fswfHuNDeCV8jNHaK9CsNT2iTRi3ZRS9lixt
   FfX4U+spF0sAjB9dv/Tc+B1/2FIFBPNxbujADDh3bk5RotjUHXC86ehFg
   EUWDSAWPY1t741ouvW8waIdB3U0rm7zhvK09zcv5e0Xq3HuMb46hGg1Go
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10437"; a="290396036"
X-IronPort-AV: E=Sophos;i="5.93,233,1654585200"; 
   d="scan'208";a="290396036"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2022 10:23:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,233,1654585200"; 
   d="scan'208";a="634716860"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga008.jf.intel.com with ESMTP; 12 Aug 2022 10:23:16 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Ivan Vecera <ivecera@redhat.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, sassmann@kpanic.de,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net 4/4] iavf: Fix deadlock in initialization
Date:   Fri, 12 Aug 2022 10:23:09 -0700
Message-Id: <20220812172309.853230-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220812172309.853230-1-anthony.l.nguyen@intel.com>
References: <20220812172309.853230-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ivan Vecera <ivecera@redhat.com>

Fix deadlock that occurs when iavf interface is a part of failover
configuration.

1. Mutex crit_lock is taken at the beginning of iavf_watchdog_task()
2. Function iavf_init_config_adapter() is called when adapter
   state is __IAVF_INIT_CONFIG_ADAPTER
3. iavf_init_config_adapter() calls register_netdevice() that emits
   NETDEV_REGISTER event
4. Notifier function failover_event() then calls
   net_failover_slave_register() that calls dev_open()
5. dev_open() calls iavf_open() that tries to take crit_lock in
   end-less loop

Stack trace:
...
[  790.251876]  usleep_range_state+0x5b/0x80
[  790.252547]  iavf_open+0x37/0x1d0 [iavf]
[  790.253139]  __dev_open+0xcd/0x160
[  790.253699]  dev_open+0x47/0x90
[  790.254323]  net_failover_slave_register+0x122/0x220 [net_failover]
[  790.255213]  failover_slave_register.part.7+0xd2/0x180 [failover]
[  790.256050]  failover_event+0x122/0x1ab [failover]
[  790.256821]  notifier_call_chain+0x47/0x70
[  790.257510]  register_netdevice+0x20f/0x550
[  790.258263]  iavf_watchdog_task+0x7c8/0xea0 [iavf]
[  790.259009]  process_one_work+0x1a7/0x360
[  790.259705]  worker_thread+0x30/0x390

To fix the situation we should check the current adapter state after
first unsuccessful mutex_trylock() and return with -EBUSY if it is
__IAVF_INIT_CONFIG_ADAPTER.

Fixes: 226d528512cf ("iavf: fix locking of critical sections")
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 95d4348e7579..f39440ad5c50 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -4088,8 +4088,17 @@ static int iavf_open(struct net_device *netdev)
 		return -EIO;
 	}
 
-	while (!mutex_trylock(&adapter->crit_lock))
+	while (!mutex_trylock(&adapter->crit_lock)) {
+		/* If we are in __IAVF_INIT_CONFIG_ADAPTER state the crit_lock
+		 * is already taken and iavf_open is called from an upper
+		 * device's notifier reacting on NETDEV_REGISTER event.
+		 * We have to leave here to avoid dead lock.
+		 */
+		if (adapter->state == __IAVF_INIT_CONFIG_ADAPTER)
+			return -EBUSY;
+
 		usleep_range(500, 1000);
+	}
 
 	if (adapter->state != __IAVF_DOWN) {
 		err = -EBUSY;
-- 
2.35.1

