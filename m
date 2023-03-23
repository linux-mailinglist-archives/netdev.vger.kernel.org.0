Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7902E6C718D
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 21:07:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231224AbjCWUHc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 16:07:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbjCWUHb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 16:07:31 -0400
Received: from EX-PRD-EDGE01.vmware.com (EX-PRD-EDGE01.vmware.com [208.91.3.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C208622DEA;
        Thu, 23 Mar 2023 13:07:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
    s=s1024; d=vmware.com;
    h=from:to:cc:subject:date:message-id:mime-version:content-type;
    bh=sJS1VMRs4nHPaI7UqQ2eYjD/zRoqmB8dlm9OvrdS33c=;
    b=nSbQ3HE6AE2cUSHWaEHtQH0QQharoUyJZccWFnsWsYUIDveg8GVMjXyMEED0Wr
      Uyc7XwJji5i5F9+mZ25p+tQg2H1JDEfFSgW4hoLqGt4b2z7HEKRqqnc6VpbTJn
      FJ/ZSlkGu7OXYHjj0HZRWhtp+MJV+eKftoZgHnlSFgyDF7w=
Received: from sc9-mailhost1.vmware.com (10.113.161.71) by
 EX-PRD-EDGE01.vmware.com (10.188.245.6) with Microsoft SMTP Server id
 15.1.2375.34; Thu, 23 Mar 2023 13:07:20 -0700
Received: from htb-1n-eng-dhcp122.eng.vmware.com (unknown [10.20.114.216])
        by sc9-mailhost1.vmware.com (Postfix) with ESMTP id 015A620165;
        Thu, 23 Mar 2023 13:07:23 -0700 (PDT)
Received: by htb-1n-eng-dhcp122.eng.vmware.com (Postfix, from userid 0)
        id DAD79A838E; Thu, 23 Mar 2023 13:07:22 -0700 (PDT)
From:   Ronak Doshi <doshir@vmware.com>
To:     <netdev@vger.kernel.org>
CC:     Ronak Doshi <doshir@vmware.com>, <stable@vger.kernel.org>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Guolin Yang <gyang@vmware.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: [PATCH net v2] vmxnet3: use gro callback when UPT is enabled
Date:   Thu, 23 Mar 2023 13:07:21 -0700
Message-ID: <20230323200721.27622-1-doshir@vmware.com>
X-Mailer: git-send-email 2.11.0
MIME-Version: 1.0
Content-Type: text/plain
Received-SPF: None (EX-PRD-EDGE01.vmware.com: doshir@vmware.com does not
 designate permitted sender hosts)
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, vmxnet3 uses GRO callback only if LRO is disabled. However,
on smartNic based setups where UPT is supported, LRO can be enabled
from guest VM but UPT devicve does not support LRO as of now. In such
cases, there can be performance degradation as GRO is not being done.

This patch fixes this issue by calling GRO API when UPT is enabled. We
use updateRxProd to determine if UPT mode is active or not.

To clarify few things discussed over the thread:
The patch is not neglecting any feature bits nor disabling GRO. It uses
GRO callback when UPT is active as LRO is not available in UPT.
GRO callback cannot be used as default for all cases as it degrades
performance for non-UPT cases or for cases when LRO is already done in
ESXi.

Cc: stable@vger.kernel.org
Fixes: 6f91f4ba046e ("vmxnet3: add support for capability registers")
Signed-off-by: Ronak Doshi <doshir@vmware.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
--
v1->v2: split if check on multiple lines
---
 drivers/net/vmxnet3/vmxnet3_drv.c |   4 +++-
 1 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index 682987040ea8..da488cbb0542 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -1688,7 +1688,9 @@ vmxnet3_rq_rx_complete(struct vmxnet3_rx_queue *rq,
 			if (unlikely(rcd->ts))
 				__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q), rcd->tci);
 
-			if (adapter->netdev->features & NETIF_F_LRO)
+			/* Use GRO callback if UPT is enabled */
+			if ((adapter->netdev->features & NETIF_F_LRO) &&
+			    !rq->shared->updateRxProd)
 				netif_receive_skb(skb);
 			else
 				napi_gro_receive(&rq->napi, skb);
-- 
2.11.0

