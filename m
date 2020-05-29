Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDEA91E72E7
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 04:58:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407105AbgE2CyG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 22:54:06 -0400
Received: from ex13-edg-ou-001.vmware.com ([208.91.0.189]:22730 "EHLO
        EX13-EDG-OU-001.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2406871AbgE2CyD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 22:54:03 -0400
Received: from sc9-mailhost3.vmware.com (10.113.161.73) by
 EX13-EDG-OU-001.vmware.com (10.113.208.155) with Microsoft SMTP Server id
 15.0.1156.6; Thu, 28 May 2020 19:53:56 -0700
Received: from ubuntu.eng.vmware.com (unknown [10.20.113.240])
        by sc9-mailhost3.vmware.com (Postfix) with ESMTP id DFDFA4016F;
        Thu, 28 May 2020 19:54:00 -0700 (PDT)
From:   Ronak Doshi <doshir@vmware.com>
To:     <netdev@vger.kernel.org>
CC:     Ronak Doshi <doshir@vmware.com>,
        "VMware, Inc." <pv-drivers@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] vmxnet3: use correct hdr reference when packet is encapsulated
Date:   Thu, 28 May 2020 19:53:52 -0700
Message-ID: <20200529025352.786-1-doshir@vmware.com>
X-Mailer: git-send-email 2.11.0
MIME-Version: 1.0
Content-Type: text/plain
Received-SPF: None (EX13-EDG-OU-001.vmware.com: doshir@vmware.com does not
 designate permitted sender hosts)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'Commit dacce2be3312 ("vmxnet3: add geneve and vxlan tunnel offload
support")' added support for encapsulation offload. However, while
preparing inner tso packet, it uses reference to outer ip headers.

This patch fixes this issue by using correct reference for inner
headers.

Fixes: dacce2be3312 ("vmxnet3: add geneve and vxlan tunnel offload support")
Signed-off-by: Ronak Doshi <doshir@vmware.com>
---
 drivers/net/vmxnet3/vmxnet3_drv.c | 31 +++++++++++++++++++++++--------
 1 file changed, 23 insertions(+), 8 deletions(-)

diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index 3d07ce6cb706..ca395f9679d0 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -859,14 +859,29 @@ vmxnet3_parse_hdr(struct sk_buff *skb, struct vmxnet3_tx_queue *tq,
 			 */
 			ctx->l4_offset = skb_checksum_start_offset(skb);
 
-			if (ctx->ipv4) {
-				const struct iphdr *iph = ip_hdr(skb);
+			if (VMXNET3_VERSION_GE_4(adapter) &&
+			    skb->encapsulation) {
+				struct iphdr *iph = inner_ip_hdr(skb);
+
+				if (iph->version == 4) {
+					protocol = iph->protocol;
+				} else {
+					const struct ipv6hdr *ipv6h;
 
-				protocol = iph->protocol;
-			} else if (ctx->ipv6) {
-				const struct ipv6hdr *ipv6h = ipv6_hdr(skb);
+					ipv6h = inner_ipv6_hdr(skb);
+					protocol = ipv6h->nexthdr;
+				}
+			} else {
+				if (ctx->ipv4) {
+					const struct iphdr *iph = ip_hdr(skb);
 
-				protocol = ipv6h->nexthdr;
+					protocol = iph->protocol;
+				} else if (ctx->ipv6) {
+					const struct ipv6hdr *ipv6h;
+
+					ipv6h = ipv6_hdr(skb);
+					protocol = ipv6h->nexthdr;
+				}
 			}
 
 			switch (protocol) {
@@ -946,11 +961,11 @@ vmxnet3_prepare_inner_tso(struct sk_buff *skb,
 	struct tcphdr *tcph = inner_tcp_hdr(skb);
 	struct iphdr *iph = inner_ip_hdr(skb);
 
-	if (ctx->ipv4) {
+	if (iph->version == 4) {
 		iph->check = 0;
 		tcph->check = ~csum_tcpudp_magic(iph->saddr, iph->daddr, 0,
 						 IPPROTO_TCP, 0);
-	} else if (ctx->ipv6) {
+	} else {
 		struct ipv6hdr *iph = inner_ipv6_hdr(skb);
 
 		tcph->check = ~csum_ipv6_magic(&iph->saddr, &iph->daddr, 0,
-- 
2.11.0

