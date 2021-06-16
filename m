Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD0233A9B0B
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 14:51:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233069AbhFPMxo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 08:53:44 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:33282 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232879AbhFPMxi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 08:53:38 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15GCkGiI009776;
        Wed, 16 Jun 2021 05:51:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=sUpszw/kwM5wbYGbfoDfIcwxUEGoEUigSXp3GDhc4D0=;
 b=GEZMq7Nm2bNhDh1nN6Hvg9OaQKhsOJZUWWtJ9vOdQdOZ9M54gceZhwxo+fEyimOcbGnJ
 jnzHrXtqkAyNoONbhjPxgE49yHOxImInehsO0zkW0X+selaTOMFEMk59wqPOBHE2WhP/
 1EGhafYnSAQ3By+6SuXPEar755E/Q0VcMjHJYet9bPj93ty+I0RZcVUSvKOMKkxJlXQa
 H4h6SobG2h/uJGzps6eELx8wWUGtkj3XTyu8J1YYvF4BUEQgOzYGc62fsXuNJl27MH8/
 2Yld7cKRpLii7YQK286L6mLzfSzYGXPD+fEEXrVifAsJvC5qvs9kWQAANS1HALK8C6z/ kw== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 397auvhkkc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 16 Jun 2021 05:51:31 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 16 Jun
 2021 05:51:30 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 16 Jun 2021 05:51:30 -0700
Received: from machine421.marvell.com (unknown [10.29.37.2])
        by maili.marvell.com (Postfix) with ESMTP id D4E643F7061;
        Wed, 16 Jun 2021 05:51:28 -0700 (PDT)
From:   <sgoutham@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH net-next 1/2] net: ethtool: Support setting ntuple rule count
Date:   Wed, 16 Jun 2021 18:21:21 +0530
Message-ID: <1623847882-16744-2-git-send-email-sgoutham@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1623847882-16744-1-git-send-email-sgoutham@marvell.com>
References: <1623847882-16744-1-git-send-email-sgoutham@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: slvbzS4HPMbEjN9877gBf1Tt3Rn8wuIl
X-Proofpoint-GUID: slvbzS4HPMbEjN9877gBf1Tt3Rn8wuIl
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-16_07:2021-06-15,2021-06-16 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sunil Goutham <sgoutham@marvell.com>

Some NICs share resources like packet filters across
multiple interfaces they support. From HW point of view
it is possible to use all filters for a single interface.
Currently ethtool doesn't support modifying filter count so
that user can allocate more filters to a interface and less
to others. This patch adds ETHTOOL_SRXCLSRLCNT ioctl command
for modifying filter count.

example command:
./ethtool -U eth0 rule-count 256

Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 include/uapi/linux/ethtool.h | 1 +
 net/ethtool/ioctl.c          | 1 +
 2 files changed, 2 insertions(+)

diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index cfef6b0..2f16a07 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -1552,6 +1552,7 @@ enum ethtool_fec_config_bits {
 #define ETHTOOL_PHY_STUNABLE	0x0000004f /* Set PHY tunable configuration */
 #define ETHTOOL_GFECPARAM	0x00000050 /* Get FEC settings */
 #define ETHTOOL_SFECPARAM	0x00000051 /* Set FEC settings */
+#define ETHTOOL_SRXCLSRLCNT	0x00000052 /* Set RX class rule count */
 
 /* compatibility with older code */
 #define SPARC_ETH_GSET		ETHTOOL_GSET
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 3fa7a39..ced4a02 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -2759,6 +2759,7 @@ int dev_ethtool(struct net *net, struct ifreq *ifr)
 	case ETHTOOL_SRXFH:
 	case ETHTOOL_SRXCLSRLDEL:
 	case ETHTOOL_SRXCLSRLINS:
+	case ETHTOOL_SRXCLSRLCNT:
 		rc = ethtool_set_rxnfc(dev, ethcmd, useraddr);
 		break;
 	case ETHTOOL_FLASHDEV:
-- 
2.7.4

