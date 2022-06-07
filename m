Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6472B53F884
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 10:47:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238482AbiFGIrE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 04:47:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238510AbiFGIqo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 04:46:44 -0400
Received: from EX-PRD-EDGE02.vmware.com (EX-PRD-EDGE02.vmware.com [208.91.3.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49824E5287;
        Tue,  7 Jun 2022 01:46:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
    s=s1024; d=vmware.com;
    h=from:to:cc:subject:date:message-id:in-reply-to:mime-version:
      content-type;
    bh=8jUo5ILLnzzIFtft13bYw8jpL7wDw6YblekTQ1WZdNs=;
    b=eFOh+k7HdLV4xx3GEEULIXdp+MZ3g7KW1Ac6ttO51wBMZtf+rWReWWAz+aIyKx
      8tl7zesemDpuAMEloY9AJFLRmRb330q6NvGW7JOsVZWVoS2nST5s5a63BZoutX
      TSkscoiPRHnygp+s36X5xvB8OI8b0p9LAK842Ix0Ia8D6TQ=
Received: from sc9-mailhost1.vmware.com (10.113.161.71) by
 EX-PRD-EDGE02.vmware.com (10.188.245.7) with Microsoft SMTP Server id
 15.1.2308.14; Tue, 7 Jun 2022 01:45:36 -0700
Received: from htb-1n-eng-dhcp122.eng.vmware.com (unknown [10.20.114.216])
        by sc9-mailhost1.vmware.com (Postfix) with ESMTP id 2811020194;
        Tue,  7 Jun 2022 01:45:42 -0700 (PDT)
Received: by htb-1n-eng-dhcp122.eng.vmware.com (Postfix, from userid 0)
        id 2350FAA2B0; Tue,  7 Jun 2022 01:45:42 -0700 (PDT)
From:   Ronak Doshi <doshir@vmware.com>
To:     <netdev@vger.kernel.org>
CC:     Ronak Doshi <doshir@vmware.com>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 net-next 6/8] vmxnet3: limit number of TXDs used for TSO packet
Date:   Tue, 7 Jun 2022 01:45:16 -0700
Message-ID: <20220607084518.30316-7-doshir@vmware.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20220607084518.30316-1-doshir@vmware.com>
References: <20220607084518.30316-1-doshir@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain
Received-SPF: None (EX-PRD-EDGE02.vmware.com: doshir@vmware.com does not
 designate permitted sender hosts)
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, vmxnet3 does not have a limit on number of descriptors
used for a TSO packet. However, with UPT, for hardware performance
reasons, this patch limits the number of transmit descriptors to 24
for a TSO packet.

Signed-off-by: Ronak Doshi <doshir@vmware.com>
Acked-by: Guolin Yang <gyang@vmware.com>
---
 drivers/net/vmxnet3/vmxnet3_defs.h |  2 ++
 drivers/net/vmxnet3/vmxnet3_drv.c  | 17 +++++++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/drivers/net/vmxnet3/vmxnet3_defs.h b/drivers/net/vmxnet3/vmxnet3_defs.h
index 415e4c9993ef..cb9dc72f2b3d 100644
--- a/drivers/net/vmxnet3/vmxnet3_defs.h
+++ b/drivers/net/vmxnet3/vmxnet3_defs.h
@@ -400,6 +400,8 @@ union Vmxnet3_GenericDesc {
 
 /* max # of tx descs for a non-tso pkt */
 #define VMXNET3_MAX_TXD_PER_PKT 16
+/* max # of tx descs for a tso pkt */
+#define VMXNET3_MAX_TSO_TXD_PER_PKT 24
 
 /* Max size of a single rx buffer */
 #define VMXNET3_MAX_RX_BUF_SIZE  ((1 << 14) - 1)
diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index 2ba263966989..6e013ae0b5ea 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -1061,6 +1061,23 @@ vmxnet3_tq_xmit(struct sk_buff *skb, struct vmxnet3_tx_queue *tq,
 			}
 			tq->stats.copy_skb_header++;
 		}
+		if (unlikely(count > VMXNET3_MAX_TSO_TXD_PER_PKT)) {
+			/* tso pkts must not use more than
+			 * VMXNET3_MAX_TSO_TXD_PER_PKT entries
+			 */
+			if (skb_linearize(skb) != 0) {
+				tq->stats.drop_too_many_frags++;
+				goto drop_pkt;
+			}
+			tq->stats.linearized++;
+
+			/* recalculate the # of descriptors to use */
+			count = VMXNET3_TXD_NEEDED(skb_headlen(skb)) + 1;
+			if (unlikely(count > VMXNET3_MAX_TSO_TXD_PER_PKT)) {
+				tq->stats.drop_too_many_frags++;
+				goto drop_pkt;
+			}
+		}
 		if (skb->encapsulation) {
 			vmxnet3_prepare_inner_tso(skb, &ctx);
 		} else {
-- 
2.11.0

