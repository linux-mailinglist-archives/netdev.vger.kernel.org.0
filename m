Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E121B3F6F7E
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 08:29:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238950AbhHYG37 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 02:29:59 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:14318 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237913AbhHYG36 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 02:29:58 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4GvbfH4Bc0z89Wb;
        Wed, 25 Aug 2021 14:28:55 +0800 (CST)
Received: from dggpeml500017.china.huawei.com (7.185.36.243) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 25 Aug 2021 14:29:10 +0800
Received: from huawei.com (10.175.103.91) by dggpeml500017.china.huawei.com
 (7.185.36.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Wed, 25 Aug
 2021 14:29:09 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <sgoutham@marvell.com>, <davem@davemloft.net>
Subject: [PATCH -next] octeontx2-pf: cn10k: Fix error return code in otx2_set_flowkey_cfg()
Date:   Wed, 25 Aug 2021 14:34:47 +0800
Message-ID: <20210825063447.2383587-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500017.china.huawei.com (7.185.36.243)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If otx2_mbox_get_rsp() fails, otx2_set_flowkey_cfg() need return an
error code.

Fixes: e7938365459f ("octeontx2-pf: Fix algorithm index in MCAM rules with RSS action")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index f630e5713025..ad79d2c05ca4 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -289,8 +289,10 @@ int otx2_set_flowkey_cfg(struct otx2_nic *pfvf)
 
 	rsp = (struct nix_rss_flowkey_cfg_rsp *)
 			otx2_mbox_get_rsp(&pfvf->mbox.mbox, 0, &req->hdr);
-	if (IS_ERR(rsp))
+	if (IS_ERR(rsp)) {
+		err = PTR_ERR(rsp);
 		goto fail;
+	}
 
 	pfvf->hw.flowkey_alg_idx = rsp->alg_idx;
 fail:
-- 
2.25.1

