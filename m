Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52A893D4034
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 20:17:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229808AbhGWRgc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 13:36:32 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:26298 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229626AbhGWRgb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 13:36:31 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16NIBXFm015456;
        Fri, 23 Jul 2021 11:17:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=1KvrLnWXlzuHHxBSAbILQdWaKWwxZo7KU4xYdtN4x1Q=;
 b=Rs9AvIGw1dH6H8PQdcmFYMA3vVwr2NTojF6zgXjXZsDm3kJqQeWrNf+laVTg9SiOfpyb
 7dHh4zvuHY0oBHYi90aKlG8wNh6reI/rzjkQLZ9bLHXNT36n8dU1zC7ILpPjpULnwGvc
 ZpfX8XVMEPQ+gIsSxj5xnkrSTjdmr1vN0e9n4Kl3Ho2S4A2i84p47bYIXmyH/jtw1BTC
 bxaX0eewvB+WCW/tnpG8DKyETUE76Fdl5NEqKwchXenrOWb3jlISOzpzLBGcjEfyXAr2
 yHaGtK/z5WZuqidFao3uwxc4juZY9MrXnGs9mGA3gX+0J6FepO6WDVsmFK73UI4Nqruc XQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 39y972dwsr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 23 Jul 2021 11:17:01 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 23 Jul
 2021 11:16:59 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Fri, 23 Jul 2021 11:16:59 -0700
Received: from machine421.marvell.com (unknown [10.29.37.2])
        by maili.marvell.com (Postfix) with ESMTP id BD01A3F7089;
        Fri, 23 Jul 2021 11:16:57 -0700 (PDT)
From:   Sunil Goutham <sgoutham@marvell.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH v2 1/2] net: ethtool: Support setting ntuple rule count
Date:   Fri, 23 Jul 2021 23:46:45 +0530
Message-ID: <1627064206-16032-2-git-send-email-sgoutham@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1627064206-16032-1-git-send-email-sgoutham@marvell.com>
References: <1627064206-16032-1-git-send-email-sgoutham@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: MF8_ziE-hVNe000xAUMpJBqW0sMhUwKj
X-Proofpoint-ORIG-GUID: MF8_ziE-hVNe000xAUMpJBqW0sMhUwKj
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-23_09:2021-07-23,2021-07-23 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
index 67aa713..178f346 100644
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
index 6134b18..ca0f75e 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -2863,6 +2863,7 @@ int dev_ethtool(struct net *net, struct ifreq *ifr)
 	case ETHTOOL_SRXFH:
 	case ETHTOOL_SRXCLSRLDEL:
 	case ETHTOOL_SRXCLSRLINS:
+	case ETHTOOL_SRXCLSRLCNT:
 		rc = ethtool_set_rxnfc(dev, ethcmd, useraddr);
 		break;
 	case ETHTOOL_FLASHDEV:
-- 
2.7.4

