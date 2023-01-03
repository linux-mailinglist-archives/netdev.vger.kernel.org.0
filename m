Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A25B65B9EE
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 05:09:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236637AbjACEJj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Jan 2023 23:09:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230071AbjACEJg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Jan 2023 23:09:36 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6801BB8;
        Mon,  2 Jan 2023 20:09:34 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3033dlcX007869;
        Mon, 2 Jan 2023 20:09:27 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=80oMAZ+XdV0nAXdYCOgANs9JArpVFoeo/x/Rs+bA+QM=;
 b=Hjwa5AAEqFqcCVuwGvbUZX8Ys1ifrNho1DhWfUA4RfK5O2M8DFtuLZ4VEfrl8aJ8C3z9
 DkfSlbQQI5Q8vkC8PJs4u/sdOfv/dZ2W7yCP5MSH8uV5XnmBcslB6jv9P9na5xtoUxkB
 XgJm1lKK+DXUSR/J0YHjaY5QPW9+b5NoJnFa5epaMzZFvqjWDhmC0QX0xFcyUwXoIiKI
 EJHbj1gZudyU/dO8MLIXiOIh885hkPWKvrM48fZWqpKChlkorrdpcGPvcB885BucBTbw
 x3ZgnuMemOCXeQ/cR0WHVV5agw+yYHNlSIVqJwJ470E0e30GoCeHMVkvPE6WwKsPhw9X SA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3mtkauv9vs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 02 Jan 2023 20:09:27 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Mon, 2 Jan
 2023 20:09:25 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.42 via Frontend
 Transport; Mon, 2 Jan 2023 20:09:25 -0800
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id 636493F7050;
        Mon,  2 Jan 2023 20:09:22 -0800 (PST)
From:   Geetha sowjanya <gakula@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <pabeni@redhat.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <sbhatta@marvell.com>, <hkelam@marvell.com>,
        <gakula@marvell.com>, <sgoutham@marvell.com>
Subject: [PATCH net] octeontx2-af: Fix QMEM struct memory allocation
Date:   Tue, 3 Jan 2023 09:39:17 +0530
Message-ID: <20230103040917.16151-1-gakula@marvell.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: gjDOZzwf_FQCzxah32j_04eGWyzPyoBn
X-Proofpoint-ORIG-GUID: gjDOZzwf_FQCzxah32j_04eGWyzPyoBn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-02_14,2022-12-30_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently NIX, NPA queue context memory is being allocated using
GFP_KERNEL flag which inturns allocates from memory reserved for
CMA_DMA. Sizing CMA_DMA memory is getting difficult due to this
dependency, the more number of interfaces enabled the more the
CMA_DMA memory requirement.

To address this issue, GFP_KERNEL flag is replaced with GFP_ATOMIC,
with this memory will be allocated from unreserved memory.

Fixes: 7a37245ef23f ("octeontx2-af: NPA block admin queue init")
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/common.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/common.h b/drivers/net/ethernet/marvell/octeontx2/af/common.h
index 8931864ee110..4b4be9ca4d2f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/common.h
@@ -61,7 +61,7 @@ static inline int qmem_alloc(struct device *dev, struct qmem **q,
 	qmem->entry_sz = entry_sz;
 	qmem->alloc_sz = (qsize * entry_sz) + OTX2_ALIGN;
 	qmem->base = dma_alloc_attrs(dev, qmem->alloc_sz, &qmem->iova,
-				     GFP_KERNEL, DMA_ATTR_FORCE_CONTIGUOUS);
+				     GFP_ATOMIC, DMA_ATTR_FORCE_CONTIGUOUS);
 	if (!qmem->base)
 		return -ENOMEM;
 
-- 
2.25.1

