Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C070240B7B
	for <lists+netdev@lfdr.de>; Mon, 10 Aug 2020 18:56:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728008AbgHJQ4B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Aug 2020 12:56:01 -0400
Received: from ex13-edg-ou-001.vmware.com ([208.91.0.189]:56134 "EHLO
        EX13-EDG-OU-001.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727018AbgHJQ4B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Aug 2020 12:56:01 -0400
Received: from sc9-mailhost3.vmware.com (10.113.161.73) by
 EX13-EDG-OU-001.vmware.com (10.113.208.155) with Microsoft SMTP Server id
 15.0.1156.6; Mon, 10 Aug 2020 09:55:56 -0700
Received: from ubuntu.eng.vmware.com (unknown [10.20.113.240])
        by sc9-mailhost3.vmware.com (Postfix) with ESMTP id C745140C19;
        Mon, 10 Aug 2020 09:55:57 -0700 (PDT)
From:   Ronak Doshi <doshir@vmware.com>
To:     <netdev@vger.kernel.org>
CC:     Ronak Doshi <doshir@vmware.com>,
        "VMware, Inc." <pv-drivers@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 net-next] vmxnet3: use correct tcp hdr length when packet is encapsulated
Date:   Mon, 10 Aug 2020 09:55:55 -0700
Message-ID: <20200810165555.12523-1-doshir@vmware.com>
X-Mailer: git-send-email 2.11.0
MIME-Version: 1.0
Content-Type: text/plain
Received-SPF: None (EX13-EDG-OU-001.vmware.com: doshir@vmware.com does not
 designate permitted sender hosts)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit dacce2be3312 ("vmxnet3: add geneve and vxlan tunnel offload
support") added support for encapsulation offload. However, while
calculating tcp hdr length, it does not take into account if the
packet is encapsulated or not.

This patch fixes this issue by using correct reference for inner
tcp header.

Fixes: dacce2be3312 ("vmxnet3: add geneve and vxlan tunnel offload support")
Signed-off-by: Ronak Doshi <doshir@vmware.com>
Acked-by: Guolin Yang <gyang@vmware.com>
---
Changes in v2:
 - Undo changes to driver version
 - Fixed commit message

 drivers/net/vmxnet3/vmxnet3_drv.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index ca395f9679d0..2818015324b8 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -886,7 +886,8 @@ vmxnet3_parse_hdr(struct sk_buff *skb, struct vmxnet3_tx_queue *tq,
 
 			switch (protocol) {
 			case IPPROTO_TCP:
-				ctx->l4_hdr_size = tcp_hdrlen(skb);
+				ctx->l4_hdr_size = skb->encapsulation ? inner_tcp_hdrlen(skb) :
+						   tcp_hdrlen(skb);
 				break;
 			case IPPROTO_UDP:
 				ctx->l4_hdr_size = sizeof(struct udphdr);
-- 
2.11.0

