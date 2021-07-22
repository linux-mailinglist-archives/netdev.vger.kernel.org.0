Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B05243D2383
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 14:46:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231929AbhGVMFn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 08:05:43 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:8404 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231738AbhGVMFm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 08:05:42 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16MCfFe4008517;
        Thu, 22 Jul 2021 05:46:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=vbG5f71vUbU3JPV995brpcZN2JjUYvEDBUfJBgxbZF8=;
 b=PP4N65391H/7vvJ6h5YFCrv6h+RZ4MbVfKcvAnqGQtVU/eN8SGH1mn84YkZmzkkDzohR
 GdJLJBECd0Y2VmS+z+jFtcfk60KuPmlwIheGItnB4D8YcfxdNGrttbCBG9ztBfWPv1Ae
 6xI+9C9f+oQ4mdDx8YXiF/UhPF7qhqKTck+UIa5+MK+YEw4mD7frPsHvXrMGAOIW6P5O
 tdLGX5djKHBQUWojq2CLXX8yzbBmVlYDyCWnoh3YAgONNVWEmhHXbqTSdfLYGnLJiJmv
 s5KrqO8t0RLJ9cnql9Vq1UDnX9B0HFlL+PXAiuuyn+rdZkZsXPTUYEM/wO6Tw36I60Ls 8w== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 39xx0qt6nh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 22 Jul 2021 05:46:14 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 22 Jul
 2021 05:46:12 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Thu, 22 Jul 2021 05:46:12 -0700
Received: from machine421.marvell.com (unknown [10.29.37.2])
        by maili.marvell.com (Postfix) with ESMTP id 401853F7084;
        Thu, 22 Jul 2021 05:46:11 -0700 (PDT)
From:   Sunil Goutham <sgoutham@marvell.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     Sunil Goutham <sgoutham@marvell.com>
Subject: [net PATCH] octeontx2-af: Remove unnecessary devm_kfree
Date:   Thu, 22 Jul 2021 18:15:51 +0530
Message-ID: <1626957951-31153-1-git-send-email-sgoutham@marvell.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: bkyfCklfGlMWSdUAjkeTu9wJXqAbUOX4
X-Proofpoint-ORIG-GUID: bkyfCklfGlMWSdUAjkeTu9wJXqAbUOX4
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-22_07:2021-07-22,2021-07-22 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove devm_kfree of memory where VLAN entry to RVU PF mapping
info is saved. This will be freed anyway at driver exit.
Having this could result in warning from devm_kfree() if
the memory is not allocated due to errors in rvu_nix_block_init()
before nix_setup_txvlan().

Fixes: 9a946def264d ("octeontx2-af: Modify nix_vtag_cfg mailbox to support TX VTAG entries")
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 0933699..0d2cd51 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -3842,7 +3842,6 @@ static void rvu_nix_block_freemem(struct rvu *rvu, int blkaddr,
 		vlan = &nix_hw->txvlan;
 		kfree(vlan->rsrc.bmap);
 		mutex_destroy(&vlan->rsrc_lock);
-		devm_kfree(rvu->dev, vlan->entry2pfvf_map);
 
 		mcast = &nix_hw->mcast;
 		qmem_free(rvu->dev, mcast->mce_ctx);
-- 
2.7.4

