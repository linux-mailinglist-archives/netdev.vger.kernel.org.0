Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 372AC7568C
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 20:07:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726808AbfGYSHx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 14:07:53 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:52412 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726300AbfGYSHx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 14:07:53 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id B083B6050D; Thu, 25 Jul 2019 18:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1564078072;
        bh=xWcJB4xqD9BHc6q5GqWONIdIwBHTZkst/q/IRTHJ8lA=;
        h=From:To:Cc:Subject:Date:From;
        b=UX8BxhG6gouOuWQ70+zs0AftvhOViLcvZjRKnDl5IWT/biaTevxtAxp6dotDgjhHC
         ccq2cMr2RV2m8vAaZnh/11Sj41Jmc8jMGcq0qVTv47ZXFRma/0kv61GVPTxGyCS519
         VWKWrgv7Pp7nSgskAB6MIRK7Wajh8BZu1pJwLik4=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.0
Received: from subashab-lnx.qualcomm.com (unknown [129.46.15.92])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: subashab@codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id EB236602F5;
        Thu, 25 Jul 2019 18:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1564078071;
        bh=xWcJB4xqD9BHc6q5GqWONIdIwBHTZkst/q/IRTHJ8lA=;
        h=From:To:Cc:Subject:Date:From;
        b=VAQTpDWv9hxpqA8NB6QvkX1kQDtTque4Lk7xY5k+zlsfT5X/YmNLDx6QK60utyg7+
         N3NY8pCwPWpvM5w0gru66MRG1YWRbdT/BQniU1KjlQf/r4f7wU14b+eFULqT+2yvai
         H+JBZRpivN996PxjLcAg/cR3hObBJ2+SYNrioiRs=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org EB236602F5
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=subashab@codeaurora.org
From:   Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Sean Tranchetti <stranche@codeaurora.org>
Subject: [PATCH net] net: qualcomm: rmnet: Fix incorrect UL checksum offload logic
Date:   Thu, 25 Jul 2019 12:07:12 -0600
Message-Id: <1564078032-8754-1-git-send-email-subashab@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The udp_ip4_ind bit is set only for IPv4 UDP non-fragmented packets
so that the hardware can flip the checksum to 0xFFFF if the computed
checksum is 0 per RFC768.

However, this bit had to be set for IPv6 UDP non fragmented packets
as well per hardware requirements. Otherwise, IPv6 UDP packets
with computed checksum as 0 were transmitted by hardware and were
dropped in the network.

In addition to setting this bit for IPv6 UDP, the field is also
appropriately renamed to udp_ind as part of this change.

Fixes: 5eb5f8608ef1 ("net: qualcomm: rmnet: Add support for TX checksum offload")
Cc: Sean Tranchetti <stranche@codeaurora.org>
Signed-off-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
---
 drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c | 13 +++++++++----
 include/linux/if_rmnet.h                             |  4 ++--
 2 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
index 6018992..21d3816 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
@@ -206,9 +206,9 @@ static void rmnet_map_complement_ipv4_txporthdr_csum_field(void *iphdr)
 	ul_header->csum_insert_offset = skb->csum_offset;
 	ul_header->csum_enabled = 1;
 	if (ip4h->protocol == IPPROTO_UDP)
-		ul_header->udp_ip4_ind = 1;
+		ul_header->udp_ind = 1;
 	else
-		ul_header->udp_ip4_ind = 0;
+		ul_header->udp_ind = 0;
 
 	/* Changing remaining fields to network order */
 	hdr++;
@@ -239,6 +239,7 @@ static void rmnet_map_complement_ipv6_txporthdr_csum_field(void *ip6hdr)
 			      struct rmnet_map_ul_csum_header *ul_header,
 			      struct sk_buff *skb)
 {
+	struct ipv6hdr *ip6h = (struct ipv6hdr *)ip6hdr;
 	__be16 *hdr = (__be16 *)ul_header, offset;
 
 	offset = htons((__force u16)(skb_transport_header(skb) -
@@ -246,7 +247,11 @@ static void rmnet_map_complement_ipv6_txporthdr_csum_field(void *ip6hdr)
 	ul_header->csum_start_offset = offset;
 	ul_header->csum_insert_offset = skb->csum_offset;
 	ul_header->csum_enabled = 1;
-	ul_header->udp_ip4_ind = 0;
+
+	if (ip6h->nexthdr == IPPROTO_UDP)
+		ul_header->udp_ind = 1;
+	else
+		ul_header->udp_ind = 0;
 
 	/* Changing remaining fields to network order */
 	hdr++;
@@ -419,7 +424,7 @@ void rmnet_map_checksum_uplink_packet(struct sk_buff *skb,
 	ul_header->csum_start_offset = 0;
 	ul_header->csum_insert_offset = 0;
 	ul_header->csum_enabled = 0;
-	ul_header->udp_ip4_ind = 0;
+	ul_header->udp_ind = 0;
 
 	priv->stats.csum_sw++;
 }
diff --git a/include/linux/if_rmnet.h b/include/linux/if_rmnet.h
index b4f5403..9661416 100644
--- a/include/linux/if_rmnet.h
+++ b/include/linux/if_rmnet.h
@@ -41,11 +41,11 @@ struct rmnet_map_ul_csum_header {
 	__be16 csum_start_offset;
 #if defined(__LITTLE_ENDIAN_BITFIELD)
 	u16 csum_insert_offset:14;
-	u16 udp_ip4_ind:1;
+	u16 udp_ind:1;
 	u16 csum_enabled:1;
 #elif defined (__BIG_ENDIAN_BITFIELD)
 	u16 csum_enabled:1;
-	u16 udp_ip4_ind:1;
+	u16 udp_ind:1;
 	u16 csum_insert_offset:14;
 #else
 #error	"Please fix <asm/byteorder.h>"
-- 
1.9.1

