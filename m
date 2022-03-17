Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C830A4DC432
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 11:45:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232721AbiCQKqv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 06:46:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232715AbiCQKqv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 06:46:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9BB6716AA5F
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 03:45:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647513933;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ZuoRHSiS5sMoIOb7MZ6BQa2RBfHZJ9wFo+kGOXs9LKw=;
        b=P/5Vn6chuR98mZEF7tk9SReUSl7lbOPuq5ZWA6SRFwKY8pb0YnMrYXEbBQsXNyJLZmAf4E
        htE0OrwN32QZRy/L2zfTpq103VRJcXP2gEADdiugWs70IpVWD4jlM5elbiK4OiKRPRl3Mo
        +BregFJfoRyxw8Vd5ZcX3XLY8WWBrho=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-62-k1Mx3SeaPEmGbW7fj8nQYg-1; Thu, 17 Mar 2022 06:45:28 -0400
X-MC-Unique: k1Mx3SeaPEmGbW7fj8nQYg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F224E1C06909;
        Thu, 17 Mar 2022 10:45:27 +0000 (UTC)
Received: from ceranb.redhat.com (unknown [10.40.193.33])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BD363C28100;
        Thu, 17 Mar 2022 10:45:25 +0000 (UTC)
From:   Ivan Vecera <ivecera@redhat.com>
To:     netdev@vger.kernel.org
Cc:     poros@redhat.com, Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Slawomir Laba <slawomirx.laba@intel.com>,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Phani Burra <phani.r.burra@intel.com>,
        intel-wired-lan@lists.osuosl.org (moderated list:INTEL ETHERNET DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] iavf: Fix hang during reboot/shutdown
Date:   Thu, 17 Mar 2022 11:45:24 +0100
Message-Id: <20220317104524.2802848-1-ivecera@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Recent commit 974578017fc1 ("iavf: Add waiting so the port is
initialized in remove") adds a wait-loop at the beginning of
iavf_remove() to ensure that port initialization is finished
prior unregistering net device. This causes a regression
in reboot/shutdown scenario because in this case callback
iavf_shutdown() is called and this callback detaches the device,
makes it down if it is running and sets its state to __IAVF_REMOVE.
Later shutdown callback of associated PF driver (e.g. ice_shutdown)
is called. That callback calls among other things sriov_disable()
that calls indirectly iavf_remove() (see stack trace below).
As the adapter state is already __IAVF_REMOVE then the mentioned
loop is end-less and shutdown process hangs.

The patch fixes this by checking adapter's state at the beginning
of iavf_remove() and skips the rest of the function if the adapter
is already in remove state (shutdown is in progress).

Reproducer:
1. Create VF on PF driven by ice or i40e driver
2. Ensure that the VF is bound to iavf driver
3. Reboot

[52625.981294] sysrq: SysRq : Show Blocked State
[52625.988377] task:reboot          state:D stack:    0 pid:17359 ppid:     1 f2
[52625.996732] Call Trace:
[52625.999187]  __schedule+0x2d1/0x830
[52626.007400]  schedule+0x35/0xa0
[52626.010545]  schedule_hrtimeout_range_clock+0x83/0x100
[52626.020046]  usleep_range+0x5b/0x80
[52626.023540]  iavf_remove+0x63/0x5b0 [iavf]
[52626.027645]  pci_device_remove+0x3b/0xc0
[52626.031572]  device_release_driver_internal+0x103/0x1f0
[52626.036805]  pci_stop_bus_device+0x72/0xa0
[52626.040904]  pci_stop_and_remove_bus_device+0xe/0x20
[52626.045870]  pci_iov_remove_virtfn+0xba/0x120
[52626.050232]  sriov_disable+0x2f/0xe0
[52626.053813]  ice_free_vfs+0x7c/0x340 [ice]
[52626.057946]  ice_remove+0x220/0x240 [ice]
[52626.061967]  ice_shutdown+0x16/0x50 [ice]
[52626.065987]  pci_device_shutdown+0x34/0x60
[52626.070086]  device_shutdown+0x165/0x1c5
[52626.074011]  kernel_restart+0xe/0x30
[52626.077593]  __do_sys_reboot+0x1d2/0x210
[52626.093815]  do_syscall_64+0x5b/0x1a0
[52626.097483]  entry_SYSCALL_64_after_hwframe+0x65/0xca

Fixes: 974578017fc1 ("iavf: Add waiting so the port is initialized in remove")
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 45570e3f782e..0e178a0a59c5 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -4620,6 +4620,13 @@ static void iavf_remove(struct pci_dev *pdev)
 	struct iavf_hw *hw = &adapter->hw;
 	int err;
 
+	/* When reboot/shutdown is in progress no need to do anything
+	 * as the adapter is already REMOVE state that was set during
+	 * iavf_shutdown() callback.
+	 */
+	if (adapter->state == __IAVF_REMOVE)
+		return;
+
 	set_bit(__IAVF_IN_REMOVE_TASK, &adapter->crit_section);
 	/* Wait until port initialization is complete.
 	 * There are flows where register/unregister netdev may race.
-- 
2.34.1

