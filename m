Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE01D1BF203
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 10:05:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726764AbgD3IFT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 04:05:19 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:55274 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726743AbgD3IFR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 04:05:17 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03U852cG011045;
        Thu, 30 Apr 2020 01:05:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=sAfeTbmd3AUH9S7H4obLqMrEBI09s2nmOHj27TNy/xQ=;
 b=VULynRM2e8tVdPE1Lnglp7nJG2TThRGiJ6qPgdDf69CizuFBQKOJ8f+rX3Z7sxuXaYwt
 m/XQBvFtwbyp5z1LOr2Z7vdFPapKUTCaXXKy0RjsxDDIzCIWa2dvY8nEGCF2ylZaaPwP
 EzV9CYLm/H1S0bKKBOBoxvGb5sIagfbp68ZixXiJisOMijitv6u4uwcPIRw6tWvmtx6f
 b/24IsTrAKvDDw2+/nlgdq2eSY/BHHMyKSl9EjwIrRfFn5tFW2AquHiEYEHeN1xrxIC/
 qRKmSirICY9pLrqSx1o6JPnm/74qb9Kc9CA1xz7XCYwv+Kadxh6zzkK0Z3w5MNmTAbtU WQ== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 30mjjqnsk7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 30 Apr 2020 01:05:15 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 30 Apr
 2020 01:05:14 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 30 Apr 2020 01:05:14 -0700
Received: from NN-LT0019.marvell.com (unknown [10.193.46.2])
        by maili.marvell.com (Postfix) with ESMTP id 56E243F703F;
        Thu, 30 Apr 2020 01:05:13 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>
Subject: [PATCH v2 net-next 06/17] net: atlantic: make hw_get_regs optional
Date:   Thu, 30 Apr 2020 11:04:34 +0300
Message-ID: <20200430080445.1142-7-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200430080445.1142-1-irusskikh@marvell.com>
References: <20200430080445.1142-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-30_02:2020-04-30,2020-04-30 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Starovoytov <mstarovoitov@marvell.com>

This patch fixes potential crash in case if hw_get_regs is NULL.

Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
---
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
index 57102f35e9f3..2dbea5cd7684 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -778,6 +778,9 @@ int aq_nic_get_regs(struct aq_nic_s *self, struct ethtool_regs *regs, void *p)
 	u32 *regs_buff = p;
 	int err = 0;
 
+	if (unlikely(!self->aq_hw_ops->hw_get_regs))
+		return -EOPNOTSUPP;
+
 	regs->version = 1;
 
 	err = self->aq_hw_ops->hw_get_regs(self->aq_hw,
@@ -792,6 +795,9 @@ int aq_nic_get_regs(struct aq_nic_s *self, struct ethtool_regs *regs, void *p)
 
 int aq_nic_get_regs_count(struct aq_nic_s *self)
 {
+	if (unlikely(!self->aq_hw_ops->hw_get_regs))
+		return 0;
+
 	return self->aq_nic_cfg.aq_hw_caps->mac_regs_count;
 }
 
-- 
2.20.1

