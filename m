Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CAE53ADA3D
	for <lists+netdev@lfdr.de>; Sat, 19 Jun 2021 15:52:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234405AbhFSNyp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Jun 2021 09:54:45 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:7802 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233286AbhFSNyo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Jun 2021 09:54:44 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15JDqWMJ013104;
        Sat, 19 Jun 2021 13:52:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=q6x8cXptk9bAbyGqwKrSN4KbyGnGeTt3yuqAosSyyOM=;
 b=YXvKxCHV47nWKhfOk8TPcBCaY/i5uB+TGkP8vz0OThW9X9k8Y9ngpvYuBQm2VMQhkF5g
 u+u6NzckioiCskxsEQcbk9jF4hFPSVL0YG6a+k2lBsK44uRtfzIt3x23xNGm6r4o4w+M
 Nq1PSqtC5p08zAG7Lvehju+RxN5Hpbe5BrKvwfpcrBRz43o/b6m04IvcHv2MogT2TWc9
 ZVrwWl5xbItYFj98CM52DeePe4U2HaIRVATH2H/X/6ge8lTu4gQy2agJjtrsQGxqv/T7
 EBZ/GOivHxhOh0IiKtyc1Mu0iJKT+dFNM+PpkQi4ebI78rEmjgyDCbP5J3Wj1JH20sp1 zg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3998f88e9g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Jun 2021 13:52:32 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15JDpF6b027502;
        Sat, 19 Jun 2021 13:52:31 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 3998d2v5sh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Jun 2021 13:52:31 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 15JDqUrc029339;
        Sat, 19 Jun 2021 13:52:30 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 3998d2v5se-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Jun 2021 13:52:30 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 15JDqTXR017681;
        Sat, 19 Jun 2021 13:52:29 GMT
Received: from mwanda (/102.222.70.252)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 19 Jun 2021 06:52:29 -0700
Date:   Sat, 19 Jun 2021 16:52:22 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Cc:     Sean Tranchetti <stranche@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net-next] net: qualcomm: rmnet: fix two pointer math bugs
Message-ID: <YM32lkJIJdSgpR87@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-GUID: GeHDIUn5CnVAWPL_D25UMIMxFEUyoet-
X-Proofpoint-ORIG-GUID: GeHDIUn5CnVAWPL_D25UMIMxFEUyoet-
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We recently changed these two pointers from void pointers to struct
pointers and it breaks the pointer math so now the "txphdr" points
beyond the end of the buffer.

Fixes: 56a967c4f7e5 ("net: qualcomm: rmnet: Remove some unneeded casts")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
index 3ee5c1a8b46e..3676976c875b 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
@@ -168,7 +168,7 @@ static void rmnet_map_complement_ipv4_txporthdr_csum_field(struct iphdr *ip4h)
 	void *txphdr;
 	u16 *csum;
 
-	txphdr = ip4h + ip4h->ihl * 4;
+	txphdr = (void *)ip4h + ip4h->ihl * 4;
 
 	if (ip4h->protocol == IPPROTO_TCP || ip4h->protocol == IPPROTO_UDP) {
 		csum = (u16 *)rmnet_map_get_csum_field(ip4h->protocol, txphdr);
@@ -203,7 +203,7 @@ rmnet_map_complement_ipv6_txporthdr_csum_field(struct ipv6hdr *ip6h)
 	void *txphdr;
 	u16 *csum;
 
-	txphdr = ip6h + sizeof(struct ipv6hdr);
+	txphdr = ip6h + 1;
 
 	if (ip6h->nexthdr == IPPROTO_TCP || ip6h->nexthdr == IPPROTO_UDP) {
 		csum = (u16 *)rmnet_map_get_csum_field(ip6h->nexthdr, txphdr);
-- 
2.30.2

