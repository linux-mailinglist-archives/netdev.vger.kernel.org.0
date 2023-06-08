Return-Path: <netdev+bounces-9210-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D45E727F3E
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 13:44:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E41B71C21007
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 11:44:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B591613ACC;
	Thu,  8 Jun 2023 11:42:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7F951119E
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 11:42:27 +0000 (UTC)
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6360D1FFE;
	Thu,  8 Jun 2023 04:42:20 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3587PrOq031841;
	Thu, 8 Jun 2023 04:42:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=3CLAvGehOw6drICaAP9rNGWXuKYD45GJWFQlQxrZPwk=;
 b=H8xDgqAwghR063uwI0TwEpSqkJUuJyO4HIatAbGtFZNancxVfB+UmmjlgywTUgDe72zc
 5G4q4T4gCpHucBqHuUpfA7GkGadJphEsYCfh4JQDbsO+CUZmkRUIlsfe97yQWRD7TrkR
 X/2cuRWy4IDhlsprsZtSYFZABjPksV4+V/zH1e4sGlLswCer3Q0feqSg4L9Yguajiz++
 +JrORWFpkfWcKSg8mVOuUpVKrbgW0QJwczFJl27fCBcXMK3YeELMQjCC8H0vs+6gkxPV
 740VPxQSqusMTo9wr46sN08rVPE/5u4t7zYV+bNJPCUOhQTjBTpjw0NccdtaKsQrRAsD yA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3r30eu2csd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
	Thu, 08 Jun 2023 04:42:11 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Thu, 8 Jun
 2023 04:42:08 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Thu, 8 Jun 2023 04:42:09 -0700
Received: from #hyd1583.marvell.com (unknown [10.29.37.44])
	by maili.marvell.com (Postfix) with ESMTP id 687A83F704F;
	Thu,  8 Jun 2023 04:42:06 -0700 (PDT)
From: Naveen Mamindlapalli <naveenm@marvell.com>
To: <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <sgoutham@marvell.com>
CC: Satha Rao <skoteshwar@marvell.com>,
        Naveen Mamindlapalli
	<naveenm@marvell.com>
Subject: [net PATCH 1/2] octeontx2-af: fixed resource availability check
Date: Thu, 8 Jun 2023 17:12:00 +0530
Message-ID: <20230608114201.31112-2-naveenm@marvell.com>
X-Mailer: git-send-email 2.39.0.198.ga38d39a4c5
In-Reply-To: <20230608114201.31112-1-naveenm@marvell.com>
References: <20230608114201.31112-1-naveenm@marvell.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: cGF082epGDhcMHeoVTH1NS0sHtZ_aeDg
X-Proofpoint-GUID: cGF082epGDhcMHeoVTH1NS0sHtZ_aeDg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-08_08,2023-06-08_01,2023-05-22_02
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Satha Rao <skoteshwar@marvell.com>

txschq_alloc response have two different arrays to store continuous
and non-continuous schedulers of each level. Requested count should
be checked for each array separately.

Fixes: 5d9b976d4480 ("octeontx2-af: Support fixed transmit scheduler topology")
Signed-off-by: Satha Rao <skoteshwar@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 26e639e57dae..967370c0a649 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -1864,7 +1864,8 @@ static int nix_check_txschq_alloc_req(struct rvu *rvu, int lvl, u16 pcifunc,
 		free_cnt = rvu_rsrc_free_count(&txsch->schq);
 	}
 
-	if (free_cnt < req_schq || req_schq > MAX_TXSCHQ_PER_FUNC)
+	if (free_cnt < req_schq || req->schq[lvl] > MAX_TXSCHQ_PER_FUNC ||
+	    req->schq_contig[lvl] > MAX_TXSCHQ_PER_FUNC)
 		return NIX_AF_ERR_TLX_ALLOC_FAIL;
 
 	/* If contiguous queues are needed, check for availability */
-- 
2.39.0.198.ga38d39a4c5


