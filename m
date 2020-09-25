Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 634A127920D
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 22:33:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728895AbgIYUdT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 16:33:19 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:59600 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726309AbgIYU1o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 16:27:44 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08PKPcgY017485;
        Fri, 25 Sep 2020 13:27:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=aHviQ9chxMvFVN0f5mn7AFwjztul3vFFdoK03HhDr1s=;
 b=YraBR+44tgmQfI99FhWkeufktFAmT+9SxkRFIEzguJzPyIlZptPgvjMmmsbXEX4MDq79
 w+c0j6XmVoG8UkBJoRuJ0NsJNIrrzyyBjq/BQfPHyK1iWM2fJSBFAiQoHM/PWb7ghRXS
 8+E2fwXhdF0aRoqSLoj1PYdjgqOr/lciJXvBr02LmrLfX6Pk93s5ZrO/GLlN+r0uDGVh
 069MTaG70TfgWQkH8Cp7bF9HtNCNgZiewM5GdNGkkuEyyHx0LgfmmA4YuDkE/qe3Orq7
 1MWbvvUCa7FgqWYTEO7AGxYnv0NYZADP0WL+UGERyCZf831FN7y8gpjAPpBq/0De/Luf cQ== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 33nhgnvmk4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 25 Sep 2020 13:27:40 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 25 Sep
 2020 13:27:39 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 25 Sep 2020 13:27:39 -0700
Received: from NN-LT0019.marvell.com (NN-LT0019.marvell.com [10.193.39.7])
        by maili.marvell.com (Postfix) with ESMTP id A8BED3F703F;
        Fri, 25 Sep 2020 13:27:37 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH net] net: atlantic: fix build when object tree is separate
Date:   Fri, 25 Sep 2020 23:27:35 +0300
Message-ID: <20200925202735.3296-1-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-25_19:2020-09-24,2020-09-25 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Driver subfolder files refer parent folder includes in an
absolute manner.

Makefile contains a -I for this, but apparently that does not
work if object tree is separated.

Adding srctree to fix that.

Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 drivers/net/ethernet/aquantia/atlantic/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/Makefile b/drivers/net/ethernet/aquantia/atlantic/Makefile
index 130a105d03f3..8ebcc68e807f 100644
--- a/drivers/net/ethernet/aquantia/atlantic/Makefile
+++ b/drivers/net/ethernet/aquantia/atlantic/Makefile
@@ -8,7 +8,7 @@
 
 obj-$(CONFIG_AQTION) += atlantic.o
 
-ccflags-y += -I$(src)
+ccflags-y += -I$(srctree)/$(src)
 
 atlantic-objs := aq_main.o \
 	aq_nic.o \
@@ -33,4 +33,4 @@ atlantic-objs := aq_main.o \
 
 atlantic-$(CONFIG_MACSEC) += aq_macsec.o
 
-atlantic-$(CONFIG_PTP_1588_CLOCK) += aq_ptp.o
\ No newline at end of file
+atlantic-$(CONFIG_PTP_1588_CLOCK) += aq_ptp.o
-- 
2.17.1

