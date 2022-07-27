Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91A90583226
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 20:37:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233607AbiG0ShL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 14:37:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239495AbiG0Sg4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 14:36:56 -0400
X-Greylist: delayed 85 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 27 Jul 2022 10:34:08 PDT
Received: from EX-PRD-EDGE02.vmware.com (EX-PRD-EDGE02.vmware.com [208.91.3.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4600382441;
        Wed, 27 Jul 2022 10:34:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
    s=s1024; d=vmware.com;
    h=from:to:cc:subject:date:message-id:mime-version:content-type;
    bh=wrErnZfhnRkvo2LLwoRnPYYKs/RlfqIiCHFipEomp8I=;
    b=T6LxgJKVo1tp6h58WY/sG48nhf7IFTJ+R66xis/ZNiEJt1SCiXA7znrFGW+S6T
      egaKPNkLNPqanjMeikCav5Tb6R5RrUK63X0FJckR7OVzdgaIn7Qa5O0QynwSr0
      gdj8evEPFCb3qycFf5J+CQ0110UPORXHDiYYz0RBjxJoBeY=
Received: from sc9-mailhost3.vmware.com (10.113.161.73) by
 EX-PRD-EDGE02.vmware.com (10.188.245.7) with Microsoft SMTP Server id
 15.1.2308.14; Wed, 27 Jul 2022 10:30:33 -0700
Received: from htb-1n-eng-dhcp122.eng.vmware.com (unknown [10.20.114.216])
        by sc9-mailhost3.vmware.com (Postfix) with ESMTP id 1F5DA20151;
        Wed, 27 Jul 2022 10:30:40 -0700 (PDT)
Received: by htb-1n-eng-dhcp122.eng.vmware.com (Postfix, from userid 0)
        id 17361AA49F; Wed, 27 Jul 2022 10:30:40 -0700 (PDT)
From:   Ronak Doshi <doshir@vmware.com>
To:     <netdev@vger.kernel.org>
CC:     Ronak Doshi <doshir@vmware.com>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Guolin Yang <gyang@vmware.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] vmxnet3: do not reschedule napi for rx processing
Date:   Wed, 27 Jul 2022 10:30:37 -0700
Message-ID: <20220727173038.9951-1-doshir@vmware.com>
X-Mailer: git-send-email 2.11.0
MIME-Version: 1.0
Content-Type: text/plain
Received-SPF: None (EX-PRD-EDGE02.vmware.com: doshir@vmware.com does not
 designate permitted sender hosts)
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit '2c5a5748105a ("vmxnet3: add support for out of order rx
completion")' added support for out of order rx completion. Within
that patch, an enhancement was done to reschedule napi for processing
rx completions.

However, it can lead to missing an interrupt. So, this patch reverts
that part of the code.

Fixes: 2c5a5748105a ("vmxnet3: add support for out of order rx completion")
Signed-off-by: Ronak Doshi <doshir@vmware.com>
Acked-by: Guolin Yang <gyang@vmware.com>
---
 drivers/net/vmxnet3/vmxnet3_drv.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index dd831adbc1d1..53b3b241e027 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -2075,17 +2075,8 @@ vmxnet3_poll_rx_only(struct napi_struct *napi, int budget)
 	rxd_done = vmxnet3_rq_rx_complete(rq, adapter, budget);
 
 	if (rxd_done < budget) {
-		struct Vmxnet3_RxCompDesc *rcd;
-#ifdef __BIG_ENDIAN_BITFIELD
-		struct Vmxnet3_RxCompDesc rxComp;
-#endif
 		napi_complete_done(napi, rxd_done);
 		vmxnet3_enable_intr(adapter, rq->comp_ring.intr_idx);
-		/* after unmasking the interrupt, check if any descriptors were completed */
-		vmxnet3_getRxComp(rcd, &rq->comp_ring.base[rq->comp_ring.next2proc].rcd,
-				  &rxComp);
-		if (rcd->gen == rq->comp_ring.gen && napi_reschedule(napi))
-			vmxnet3_disable_intr(adapter, rq->comp_ring.intr_idx);
 	}
 	return rxd_done;
 }
-- 
2.11.0

