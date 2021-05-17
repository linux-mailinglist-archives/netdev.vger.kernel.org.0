Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6C78382779
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 10:49:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235510AbhEQIut (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 04:50:49 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:43730 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S235474AbhEQIur (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 04:50:47 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14H8fMjU016376;
        Mon, 17 May 2021 01:49:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=Z9OJMtgLjA0uRBBkpGCiG2/6rE3Vl7IJ25rjVtoUrHU=;
 b=QCz+IzfCTheWYKOc5R9CgsKAuQadXRo/vJHGbP8oB61ANJDZ5iX5Ll4/We5vLNN6Jtwx
 YEi70Ljx14uH8OnlMQQR/wRh07/Cdemnm3FetDIbfhvuoUhg+Vd+NuUbY79pfXWHTsFU
 1p8tmFT4EFluu2xYVyI+wjs9z0mamceaZx3xZcJv5PKtrHq3QwcUh9LS8otdrKZDxIx/
 fX/9NU1Z2W98n7ATTr4nTa7Aaw3BBkgLeNwXHcDc2BTzLj6v3M3ybqchGI2HF9rq3wEb
 wg3GrK5X55Azd1gd7Xpjqi75wC+ogTNeaw7VPhPT009/oKtV2UdIOWaxDsEVJ7xv7Su9 EA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 38kc9fsc4g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 17 May 2021 01:49:30 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 17 May
 2021 01:49:29 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 17 May 2021 01:49:29 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 28B663F7071;
        Mon, 17 May 2021 01:49:29 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 14H8nTCo008564;
        Mon, 17 May 2021 01:49:29 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 14H8nSnV008563;
        Mon, 17 May 2021 01:49:28 -0700
From:   Javed Hasan <jhasan@marvell.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <jhasan@marvell.com>
Subject: [PATCH] cnic: Fixed double assignment to ictx->xstorm_st_context.common.flags
Date:   Mon, 17 May 2021 01:49:04 -0700
Message-ID: <20210517084904.8529-1-jhasan@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: N_v1oH7oyyYMGVRAG9e3QrZwQKD81eUC
X-Proofpoint-ORIG-GUID: N_v1oH7oyyYMGVRAG9e3QrZwQKD81eUC
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-17_03:2021-05-12,2021-05-17 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

	Reported-by: Colin Ian King <colin.king@canonical.com>

diff --git a/drivers/net/ethernet/broadcom/cnic.c b/drivers/net/ethernet/broadcom/cnic.c
index f7f10cfb3476..d2e8421cc629 100644
--- a/drivers/net/ethernet/broadcom/cnic.c
+++ b/drivers/net/ethernet/broadcom/cnic.c
@@ -1760,7 +1760,7 @@ static int cnic_setup_bnx2x_ctx(struct cnic_dev *dev, struct kwqe *wqes[],
 	}
 	ictx->xstorm_st_context.common.flags =
 		1 << XSTORM_COMMON_CONTEXT_SECTION_PHYSQ_INITIALIZED_SHIFT;
-	ictx->xstorm_st_context.common.flags =
+	ictx->xstorm_st_context.common.flags |=
 		port << XSTORM_COMMON_CONTEXT_SECTION_PBF_PORT_SHIFT;
 
 	ictx->tstorm_st_context.iscsi.hdr_bytes_2_fetch = ISCSI_HEADER_SIZE;
-- 
2.18.2

