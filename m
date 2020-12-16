Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5813E2DC0B0
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 14:04:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726077AbgLPNEI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 08:04:08 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:9611 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726056AbgLPNEI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 08:04:08 -0500
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CwwJs00v9zM3ng;
        Wed, 16 Dec 2020 21:02:36 +0800 (CST)
Received: from ubuntu.network (10.175.138.68) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.498.0; Wed, 16 Dec 2020 21:03:19 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <arend.vanspriel@broadcom.com>, <franky.lin@broadcom.com>,
        <kvalo@codeaurora.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <brcm80211-dev-list.pdl@broadcom.com>,
        <SHA-cyfmac-dev-list@infineon.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH wireless -next] brcmfmac: Delete useless kfree code
Date:   Wed, 16 Dec 2020 21:03:50 +0800
Message-ID: <20201216130350.13815-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.138.68]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The parameter of kfree function is NULL, so kfree code is useless, delete it.
Therefore, goto expression is no longer needed, so simplify it.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 .../net/wireless/broadcom/brcm80211/brcmfmac/firmware.c  | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
index d821a4758f8c..add416a35a62 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
@@ -319,8 +319,10 @@ static void brcmf_fw_strip_multi_v2(struct nvram_parser *nvp, u16 domain_nr,
 	u8 *nvram;
 
 	nvram = kzalloc(nvp->nvram_len + 1 + 3 + sizeof(u32), GFP_KERNEL);
-	if (!nvram)
-		goto fail;
+	if (!nvram) {
+		nvp->nvram_len = 0;
+		return;
+	}
 
 	/* Copy all valid entries, release old nvram and assign new one.
 	 * Valid entries are of type pcie/X/Y/ where X = domain_nr and
@@ -351,9 +353,6 @@ static void brcmf_fw_strip_multi_v2(struct nvram_parser *nvp, u16 domain_nr,
 	nvp->nvram = nvram;
 	nvp->nvram_len = j;
 	return;
-fail:
-	kfree(nvram);
-	nvp->nvram_len = 0;
 }
 
 static void brcmf_fw_add_defaults(struct nvram_parser *nvp)
-- 
2.22.0

