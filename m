Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E9A83A949D
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 10:01:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232115AbhFPIDe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 04:03:34 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:58433 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232091AbhFPIDH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 04:03:07 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1623830462; h=Message-Id: Date: Subject: Cc: To: From:
 Sender; bh=NygIblzJTCzdASa3kZQx7rw0OJI0BGtDI3dahCvh+8s=; b=O+swb8r6KYXATCQHkCN6Mwd2hW09L6lYPm5SGO/R85JBW1H4UcCsFLuwTeDT6Iir5xUqZUJI
 5zdyIWsBEkeAHRPXKYwbf6dr5XfdjUTIDKAt6XEHykEtA2yW+zt6OXcJoCEAABChUVKkejK8
 SQbBZE6Z2Obxyh5iw+2OqF4CLxg=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-east-1.postgun.com with SMTP id
 60c9af95e27c0cc77f0e0ed6 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 16 Jun 2021 08:00:21
 GMT
Sender: subashab=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 265E8C4360C; Wed, 16 Jun 2021 08:00:21 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from subashab-lnx.qualcomm.com (unknown [129.46.15.92])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: subashab)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D020FC433F1;
        Wed, 16 Jun 2021 08:00:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org D020FC433F1
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=subashab@codeaurora.org
From:   Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
To:     davem@davemloft.net, kuba@kernel.org, stranche@codeaurora.org,
        netdev@vger.kernel.org
Cc:     Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Subject: [PATCH net-next] net: qualcomm: rmnet: Remove some unneeded casts
Date:   Wed, 16 Jun 2021 01:59:13 -0600
Message-Id: <1623830353-9236-1-git-send-email-subashab@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove the explicit casts in the checksum complement functions
and pass the actual protocol specific headers instead.

Signed-off-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
---
 drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
index 39fba3a..3ee5c1a 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
@@ -163,13 +163,12 @@ rmnet_map_ipv6_dl_csum_trailer(struct sk_buff *skb,
 }
 #endif
 
-static void rmnet_map_complement_ipv4_txporthdr_csum_field(void *iphdr)
+static void rmnet_map_complement_ipv4_txporthdr_csum_field(struct iphdr *ip4h)
 {
-	struct iphdr *ip4h = (struct iphdr *)iphdr;
 	void *txphdr;
 	u16 *csum;
 
-	txphdr = iphdr + ip4h->ihl * 4;
+	txphdr = ip4h + ip4h->ihl * 4;
 
 	if (ip4h->protocol == IPPROTO_TCP || ip4h->protocol == IPPROTO_UDP) {
 		csum = (u16 *)rmnet_map_get_csum_field(ip4h->protocol, txphdr);
@@ -198,13 +197,13 @@ rmnet_map_ipv4_ul_csum_header(struct iphdr *iphdr,
 }
 
 #if IS_ENABLED(CONFIG_IPV6)
-static void rmnet_map_complement_ipv6_txporthdr_csum_field(void *ip6hdr)
+static void
+rmnet_map_complement_ipv6_txporthdr_csum_field(struct ipv6hdr *ip6h)
 {
-	struct ipv6hdr *ip6h = (struct ipv6hdr *)ip6hdr;
 	void *txphdr;
 	u16 *csum;
 
-	txphdr = ip6hdr + sizeof(struct ipv6hdr);
+	txphdr = ip6h + sizeof(struct ipv6hdr);
 
 	if (ip6h->nexthdr == IPPROTO_TCP || ip6h->nexthdr == IPPROTO_UDP) {
 		csum = (u16 *)rmnet_map_get_csum_field(ip6h->nexthdr, txphdr);
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

