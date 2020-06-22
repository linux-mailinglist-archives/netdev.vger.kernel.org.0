Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6AB320359F
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 13:25:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728243AbgFVLZO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 07:25:14 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:4532 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728171AbgFVLO6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 07:14:58 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05MB74pA012022;
        Mon, 22 Jun 2020 04:14:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0818;
 bh=aSQnaeJ4BVFSG1Xi0jIbKbe60eR9TioORFDcgcGBMiA=;
 b=MBbHsVWmcfKB7yKqEpTH7+64j1IUmS+RlszCTmlXuNlG4O7NY4tRCKtrvFulfh4lztBM
 BHc6ct8QEUfQuk22l7ZprDfk38Uk/YD2EjtzvYhifLVufv8EI9zFhjmUtZtQwy/Htz5F
 BMt5N3ZC3Cpu0LN7rF2/mkN43OgJbQXQOqF1U4UTXy+vkva1b32dg/R7Xb/PVj8F/vMd
 5d4sgGrX9OYVLMwPsVoge2nX4FCCIUUlV+LztOZqsz8eFXU9uGvVrP3UZxGSlluovFOS
 7oKjsSiwCzpn/3cQ1diRRS/rNQt/hZHYgSMgRvq/LaEvxNaoDtwjJxtj+fbWPom7eG4/ wQ== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 31shynqpbj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 22 Jun 2020 04:14:55 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 22 Jun
 2020 04:14:53 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 22 Jun 2020 04:14:53 -0700
Received: from NN-LT0049.marvell.com (unknown [10.193.39.36])
        by maili.marvell.com (Postfix) with ESMTP id 3A74E3F703F;
        Mon, 22 Jun 2020 04:14:48 -0700 (PDT)
From:   Alexander Lobakin <alobakin@marvell.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Igor Russkikh <irusskikh@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        Ariel Elior <aelior@marvell.com>,
        Yuval Mintz <yuval.mintz@marvell.com>,
        Denis Bolotin <denis.bolotin@marvell.com>,
        "Ram Amrani" <ram.amrani@marvell.com>,
        Tomer Tayar <tomer.tayar@marvell.com>,
        Alexander Lobakin <alobakin@marvell.com>,
        <GR-everest-linux-l2@marvell.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net 7/9] net: qede: fix use-after-free on recovery and AER handling
Date:   Mon, 22 Jun 2020 14:14:11 +0300
Message-ID: <20200622111413.7006-8-alobakin@marvell.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200622111413.7006-1-alobakin@marvell.com>
References: <20200622111413.7006-1-alobakin@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-22_04:2020-06-22,2020-06-22 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Set edev->cdev pointer to NULL after calling remove() callback to avoid
using of already freed object.

Fixes: ccc67ef50b90 ("qede: Error recovery process")
Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
---
 drivers/net/ethernet/qlogic/qede/qede_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
index f6ff31e73ebe..29e285430f99 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -1318,6 +1318,7 @@ static void __qede_remove(struct pci_dev *pdev, enum qede_remove_mode mode)
 	if (system_state == SYSTEM_POWER_OFF)
 		return;
 	qed_ops->common->remove(cdev);
+	edev->cdev = NULL;
 
 	/* Since this can happen out-of-sync with other flows,
 	 * don't release the netdevice until after slowpath stop
-- 
2.21.0

