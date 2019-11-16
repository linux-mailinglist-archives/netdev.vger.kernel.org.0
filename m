Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C5E9FEB14
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 08:18:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726178AbfKPHPe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 02:15:34 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:45606 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726034AbfKPHPe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Nov 2019 02:15:34 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 1CA9B7C7B863244442F8;
        Sat, 16 Nov 2019 15:15:31 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.439.0; Sat, 16 Nov 2019
 15:15:23 +0800
From:   zhengbin <zhengbin13@huawei.com>
To:     <arend.vanspriel@broadcom.com>, <franky.lin@broadcom.com>,
        <kvalo@codeaurora.org>, <davem@davemloft.net>,
        <linux-wireless@vger.kernel.org>,
        <brcm80211-dev-list.pdl@broadcom.com>,
        <brcm80211-dev-list@cypress.com>, <netdev@vger.kernel.org>
CC:     <zhengbin13@huawei.com>
Subject: [PATCH -next] brcmfmac: remove set but not used variable 'mpnum','nsp','nmp'
Date:   Sat, 16 Nov 2019 15:22:47 +0800
Message-ID: <1573888967-104078-1-git-send-email-zhengbin13@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c: In function brcmf_chip_dmp_get_regaddr:
drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c:790:5: warning: variable mpnum set but not used [-Wunused-but-set-variable]
drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c: In function brcmf_chip_dmp_erom_scan:
drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c:866:10: warning: variable nsp set but not used [-Wunused-but-set-variable]
drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c: In function brcmf_chip_dmp_erom_scan:
drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c:866:5: warning: variable nmp set but not used [-Wunused-but-set-variable]

They are introduced by commit 05491d2ccf20 ("brcm80211:
move under broadcom vendor directory"), but never used,
so remove them.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: zhengbin <zhengbin13@huawei.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
index dd586a9..a795d78 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
@@ -778,7 +778,6 @@ static int brcmf_chip_dmp_get_regaddr(struct brcmf_chip_priv *ci, u32 *eromaddr,
 {
 	u8 desc;
 	u32 val, szdesc;
-	u8 mpnum = 0;
 	u8 stype, sztype, wraptype;

 	*regbase = 0;
@@ -786,7 +785,6 @@ static int brcmf_chip_dmp_get_regaddr(struct brcmf_chip_priv *ci, u32 *eromaddr,

 	val = brcmf_chip_dmp_get_desc(ci, eromaddr, &desc);
 	if (desc == DMP_DESC_MASTER_PORT) {
-		mpnum = (val & DMP_MASTER_PORT_NUM) >> DMP_MASTER_PORT_NUM_S;
 		wraptype = DMP_SLAVE_TYPE_MWRAP;
 	} else if (desc == DMP_DESC_ADDRESS) {
 		/* revert erom address */
@@ -854,7 +852,7 @@ int brcmf_chip_dmp_erom_scan(struct brcmf_chip_priv *ci)
 	u8 desc_type = 0;
 	u32 val;
 	u16 id;
-	u8 nmp, nsp, nmw, nsw, rev;
+	u8 nmw, nsw, rev;
 	u32 base, wrap;
 	int err;

@@ -880,8 +878,6 @@ int brcmf_chip_dmp_erom_scan(struct brcmf_chip_priv *ci)
 			return -EFAULT;

 		/* only look at cores with master port(s) */
-		nmp = (val & DMP_COMP_NUM_MPORT) >> DMP_COMP_NUM_MPORT_S;
-		nsp = (val & DMP_COMP_NUM_SPORT) >> DMP_COMP_NUM_SPORT_S;
 		nmw = (val & DMP_COMP_NUM_MWRAP) >> DMP_COMP_NUM_MWRAP_S;
 		nsw = (val & DMP_COMP_NUM_SWRAP) >> DMP_COMP_NUM_SWRAP_S;
 		rev = (val & DMP_COMP_REVISION) >> DMP_COMP_REVISION_S;
--
2.7.4

