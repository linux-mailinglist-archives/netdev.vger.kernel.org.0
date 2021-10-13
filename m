Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C243E42B993
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 09:51:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238664AbhJMHxR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 03:53:17 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:14342 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238696AbhJMHxP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 03:53:15 -0400
Received: from dggeml757-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HTl305nnJz90DD;
        Wed, 13 Oct 2021 15:46:20 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 dggeml757-chm.china.huawei.com (10.1.199.137) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.8; Wed, 13 Oct 2021 15:51:10 +0800
From:   Ziyang Xuan <william.xuanziyang@huawei.com>
To:     <krzysztof.kozlowski@canonical.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net 1/2] NFC: digital: fix possible memory leak in digital_tg_listen_mdaa()
Date:   Wed, 13 Oct 2021 15:50:12 +0800
Message-ID: <4e3578352a4548feb1d3087c7ec38fedab18292d.1634111083.git.william.xuanziyang@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1634111083.git.william.xuanziyang@huawei.com>
References: <cover.1634111083.git.william.xuanziyang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggeml757-chm.china.huawei.com (10.1.199.137)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'params' is allocated in digital_tg_listen_mdaa(), but not free when
digital_send_cmd() failed, which will cause memory leak. Fix it by
freeing 'params' if digital_send_cmd() return failed.

Fixes: 1c7a4c24fbfd ("NFC Digital: Add target NFC-DEP support")
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
---
 net/nfc/digital_core.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/nfc/digital_core.c b/net/nfc/digital_core.c
index fefc03674f4f..d63d2e5dc60c 100644
--- a/net/nfc/digital_core.c
+++ b/net/nfc/digital_core.c
@@ -277,6 +277,7 @@ int digital_tg_configure_hw(struct nfc_digital_dev *ddev, int type, int param)
 static int digital_tg_listen_mdaa(struct nfc_digital_dev *ddev, u8 rf_tech)
 {
 	struct digital_tg_mdaa_params *params;
+	int rc;
 
 	params = kzalloc(sizeof(*params), GFP_KERNEL);
 	if (!params)
@@ -291,8 +292,12 @@ static int digital_tg_listen_mdaa(struct nfc_digital_dev *ddev, u8 rf_tech)
 	get_random_bytes(params->nfcid2 + 2, NFC_NFCID2_MAXSIZE - 2);
 	params->sc = DIGITAL_SENSF_FELICA_SC;
 
-	return digital_send_cmd(ddev, DIGITAL_CMD_TG_LISTEN_MDAA, NULL, params,
-				500, digital_tg_recv_atr_req, NULL);
+	rc = digital_send_cmd(ddev, DIGITAL_CMD_TG_LISTEN_MDAA, NULL, params,
+			      500, digital_tg_recv_atr_req, NULL);
+	if (rc)
+		kfree(params);
+
+	return rc;
 }
 
 static int digital_tg_listen_md(struct nfc_digital_dev *ddev, u8 rf_tech)
-- 
2.25.1

