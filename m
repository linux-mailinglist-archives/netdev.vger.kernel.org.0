Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 895335AB869
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 20:39:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229824AbiIBSjN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 14:39:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbiIBSjD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 14:39:03 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EC3F883E2
        for <netdev@vger.kernel.org>; Fri,  2 Sep 2022 11:39:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662143942; x=1693679942;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wKOrCWt4PVAry67+gVFrzKced+Tp4ZRLGQRx9HZkR/g=;
  b=mODYGUJfdQKxTR+Q8sWsmmz+ScwyoHUGAlQ+TDlvmDtLVjbjOZFM65I/
   xrhij9iLvXA6OV3sILrHtoAQHq3jJ+8ddb8Wq2SnjsHuFrDI3H/Ws4dPb
   SdVt0NyVfvopWYX5vMi/69256n7RouBeDCzSJ8c0ZSYnJbWifw8gkN01X
   RV5eCcM9Nss9Gzkffd99LWKz8oFQ3f8KrTzQ3ak9H22Unwlc+YrhEmF+f
   +xkob+y/2rQ3sLvJTJOwFIuw38EezmDa8SYF66cCfgSOktZ8WF0eKS56Z
   ROu4+KwOduLsM+p+ncoo2ia9c/TEu64F6YdE5dtCunI2ouqwld+dr50db
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10458"; a="357768801"
X-IronPort-AV: E=Sophos;i="5.93,283,1654585200"; 
   d="scan'208";a="357768801"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2022 11:39:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,283,1654585200"; 
   d="scan'208";a="590170957"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga006.jf.intel.com with ESMTP; 02 Sep 2022 11:39:00 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Ivan Vecera <ivecera@redhat.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Helena Anna Dubel <helena.anna.dubel@intel.com>
Subject: [PATCH net 2/3] i40e: Fix kernel crash during module removal
Date:   Fri,  2 Sep 2022 11:38:56 -0700
Message-Id: <20220902183857.1252065-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220902183857.1252065-1-anthony.l.nguyen@intel.com>
References: <20220902183857.1252065-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ivan Vecera <ivecera@redhat.com>

The driver incorrectly frees client instance and subsequent
i40e module removal leads to kernel crash.

Reproducer:
1. Do ethtool offline test followed immediately by another one
host# ethtool -t eth0 offline; ethtool -t eth0 offline
2. Remove recursively irdma module that also removes i40e module
host# modprobe -r irdma

Result:
[ 8675.035651] i40e 0000:3d:00.0 eno1: offline testing starting
[ 8675.193774] i40e 0000:3d:00.0 eno1: testing finished
[ 8675.201316] i40e 0000:3d:00.0 eno1: offline testing starting
[ 8675.358921] i40e 0000:3d:00.0 eno1: testing finished
[ 8675.496921] i40e 0000:3d:00.0: IRDMA hardware initialization FAILED init_state=2 status=-110
[ 8686.188955] i40e 0000:3d:00.1: i40e_ptp_stop: removed PHC on eno2
[ 8686.943890] i40e 0000:3d:00.1: Deleted LAN device PF1 bus=0x3d dev=0x00 func=0x01
[ 8686.952669] i40e 0000:3d:00.0: i40e_ptp_stop: removed PHC on eno1
[ 8687.761787] BUG: kernel NULL pointer dereference, address: 0000000000000030
[ 8687.768755] #PF: supervisor read access in kernel mode
[ 8687.773895] #PF: error_code(0x0000) - not-present page
[ 8687.779034] PGD 0 P4D 0
[ 8687.781575] Oops: 0000 [#1] PREEMPT SMP NOPTI
[ 8687.785935] CPU: 51 PID: 172891 Comm: rmmod Kdump: loaded Tainted: G        W I        5.19.0+ #2
[ 8687.794800] Hardware name: Intel Corporation S2600WFD/S2600WFD, BIOS SE5C620.86B.0X.02.0001.051420190324 05/14/2019
[ 8687.805222] RIP: 0010:i40e_lan_del_device+0x13/0xb0 [i40e]
[ 8687.810719] Code: d4 84 c0 0f 84 b8 25 01 00 e9 9c 25 01 00 41 bc f4 ff ff ff eb 91 90 0f 1f 44 00 00 41 54 55 53 48 8b 87 58 08 00 00 48 89 fb <48> 8b 68 30 48 89 ef e8 21 8a 0f d5 48 89 ef e8 a9 78 0f d5 48 8b
[ 8687.829462] RSP: 0018:ffffa604072efce0 EFLAGS: 00010202
[ 8687.834689] RAX: 0000000000000000 RBX: ffff8f43833b2000 RCX: 0000000000000000
[ 8687.841821] RDX: 0000000000000000 RSI: ffff8f4b0545b298 RDI: ffff8f43833b2000
[ 8687.848955] RBP: ffff8f43833b2000 R08: 0000000000000001 R09: 0000000000000000
[ 8687.856086] R10: 0000000000000000 R11: 000ffffffffff000 R12: ffff8f43833b2ef0
[ 8687.863218] R13: ffff8f43833b2ef0 R14: ffff915103966000 R15: ffff8f43833b2008
[ 8687.870342] FS:  00007f79501c3740(0000) GS:ffff8f4adffc0000(0000) knlGS:0000000000000000
[ 8687.878427] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 8687.884174] CR2: 0000000000000030 CR3: 000000014276e004 CR4: 00000000007706e0
[ 8687.891306] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 8687.898441] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[ 8687.905572] PKRU: 55555554
[ 8687.908286] Call Trace:
[ 8687.910737]  <TASK>
[ 8687.912843]  i40e_remove+0x2c0/0x330 [i40e]
[ 8687.917040]  pci_device_remove+0x33/0xa0
[ 8687.920962]  device_release_driver_internal+0x1aa/0x230
[ 8687.926188]  driver_detach+0x44/0x90
[ 8687.929770]  bus_remove_driver+0x55/0xe0
[ 8687.933693]  pci_unregister_driver+0x2a/0xb0
[ 8687.937967]  i40e_exit_module+0xc/0xf48 [i40e]

Two offline tests cause IRDMA driver failure (ETIMEDOUT) and this
failure is indicated back to i40e_client_subtask() that calls
i40e_client_del_instance() to free client instance referenced
by pf->cinst and sets this pointer to NULL. During the module
removal i40e_remove() calls i40e_lan_del_device() that dereferences
pf->cinst that is NULL -> crash.
Do not remove client instance when client open callbacks fails and
just clear __I40E_CLIENT_INSTANCE_OPENED bit. The driver also needs
to take care about this situation (when netdev is up and client
is NOT opened) in i40e_notify_client_of_netdev_close() and
calls client close callback only when __I40E_CLIENT_INSTANCE_OPENED
is set.

Fixes: 0ef2d5afb12d ("i40e: KISS the client interface")
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
Tested-by: Helena Anna Dubel <helena.anna.dubel@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_client.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_client.c b/drivers/net/ethernet/intel/i40e/i40e_client.c
index ea2bb0140a6e..10d7a982a5b9 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_client.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_client.c
@@ -177,6 +177,10 @@ void i40e_notify_client_of_netdev_close(struct i40e_vsi *vsi, bool reset)
 			"Cannot locate client instance close routine\n");
 		return;
 	}
+	if (!test_bit(__I40E_CLIENT_INSTANCE_OPENED, &cdev->state)) {
+		dev_dbg(&pf->pdev->dev, "Client is not open, abort close\n");
+		return;
+	}
 	cdev->client->ops->close(&cdev->lan_info, cdev->client, reset);
 	clear_bit(__I40E_CLIENT_INSTANCE_OPENED, &cdev->state);
 	i40e_client_release_qvlist(&cdev->lan_info);
@@ -429,7 +433,6 @@ void i40e_client_subtask(struct i40e_pf *pf)
 				/* Remove failed client instance */
 				clear_bit(__I40E_CLIENT_INSTANCE_OPENED,
 					  &cdev->state);
-				i40e_client_del_instance(pf);
 				return;
 			}
 		}
-- 
2.35.1

