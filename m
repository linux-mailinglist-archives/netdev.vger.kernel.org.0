Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72A746527D9
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 21:26:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234048AbiLTU0M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 15:26:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbiLTU0K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 15:26:10 -0500
Received: from EX-PRD-EDGE02.vmware.com (EX-PRD-EDGE02.vmware.com [208.91.3.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A8E62643;
        Tue, 20 Dec 2022 12:26:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
    s=s1024; d=vmware.com;
    h=from:to:cc:subject:date:message-id:mime-version:content-type;
    bh=8U3eApao12GWve8oDar6sUznovKCP+eRvJkCKrFxhQk=;
    b=jjd/yi5NVcbT58GYrgPH93KraPA/fbV41LCvBgxmC/dqS6gDeYdXYmr8u2Sx9f
      jYIvYpX3HWQxcnJyARsc5cryAnvi+dWkhgXl9E71PYMroHzRdDnjmEr1Do0CZ8
      wQplh+OMzczxvQJ2/htcQVkqidfni8cW54Sf27mS17GtN+w=
Received: from sc9-mailhost2.vmware.com (10.113.161.72) by
 EX-PRD-EDGE02.vmware.com (10.188.245.7) with Microsoft SMTP Server id
 15.1.2375.34; Tue, 20 Dec 2022 12:25:57 -0800
Received: from htb-1n-eng-dhcp122.eng.vmware.com (unknown [10.20.114.216])
        by sc9-mailhost2.vmware.com (Postfix) with ESMTP id 2666420201;
        Tue, 20 Dec 2022 12:25:59 -0800 (PST)
Received: by htb-1n-eng-dhcp122.eng.vmware.com (Postfix, from userid 0)
        id 2079AAE377; Tue, 20 Dec 2022 12:25:59 -0800 (PST)
From:   Ronak Doshi <doshir@vmware.com>
To:     <netdev@vger.kernel.org>
CC:     <stable@vger.kernel.org>, Ronak Doshi <doshir@vmware.com>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: [PATCH net ] vmxnet3: correctly report csum_level for encapsulated packet
Date:   Tue, 20 Dec 2022 12:25:55 -0800
Message-ID: <20221220202556.24421-1-doshir@vmware.com>
X-Mailer: git-send-email 2.11.0
MIME-Version: 1.0
Content-Type: text/plain
Received-SPF: None (EX-PRD-EDGE02.vmware.com: doshir@vmware.com does not
 designate permitted sender hosts)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit dacce2be3312 ("vmxnet3: add geneve and vxlan tunnel offload
support") added support for encapsulation offload. However, the
pathc did not report correctly the csum_level for encapsulated packet.

This patch fixes this issue by reporting correct csum level for the
encapsulated packet.

Fixes: dacce2be3312 ("vmxnet3: add geneve and vxlan tunnel offload support")
Signed-off-by: Ronak Doshi <doshir@vmware.com>
Acked-by: Peng Li <lpeng@vmware.com>
---
 drivers/net/vmxnet3/vmxnet3_drv.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index 6f1e560fb15c..56267c327f0b 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -1288,6 +1288,10 @@ vmxnet3_rx_csum(struct vmxnet3_adapter *adapter,
 		    (le32_to_cpu(gdesc->dword[3]) &
 		     VMXNET3_RCD_CSUM_OK) == VMXNET3_RCD_CSUM_OK) {
 			skb->ip_summed = CHECKSUM_UNNECESSARY;
+			if ((le32_to_cpu(gdesc->dword[0]) &
+				     (1UL << VMXNET3_RCD_HDR_INNER_SHIFT))) {
+				skb->csum_level = 1;
+			}
 			WARN_ON_ONCE(!(gdesc->rcd.tcp || gdesc->rcd.udp) &&
 				     !(le32_to_cpu(gdesc->dword[0]) &
 				     (1UL << VMXNET3_RCD_HDR_INNER_SHIFT)));
@@ -1297,6 +1301,10 @@ vmxnet3_rx_csum(struct vmxnet3_adapter *adapter,
 		} else if (gdesc->rcd.v6 && (le32_to_cpu(gdesc->dword[3]) &
 					     (1 << VMXNET3_RCD_TUC_SHIFT))) {
 			skb->ip_summed = CHECKSUM_UNNECESSARY;
+			if ((le32_to_cpu(gdesc->dword[0]) &
+				     (1UL << VMXNET3_RCD_HDR_INNER_SHIFT))) {
+				skb->csum_level = 1;
+			}
 			WARN_ON_ONCE(!(gdesc->rcd.tcp || gdesc->rcd.udp) &&
 				     !(le32_to_cpu(gdesc->dword[0]) &
 				     (1UL << VMXNET3_RCD_HDR_INNER_SHIFT)));
-- 
2.11.0

