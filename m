Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9AE22D2DF1
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 16:13:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729817AbgLHPMV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 10:12:21 -0500
Received: from mail-m975.mail.163.com ([123.126.97.5]:56492 "EHLO
        mail-m975.mail.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729514AbgLHPMU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 10:12:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=SNfMS57SQ/9kcHp3Cs
        Z830nUpvVEC6Ph3YJtof5sGEk=; b=e1vo6C0dXm3t+EB0GWLJv2AZ/H9PC4ixpk
        Zz9DJ8fWfKVOzu3ZLM8GvKm1b0hEIl7wOLMKuG95/U1L+xE8ngamF3cNQVfIYjyV
        SLvhpS5c+8B2tP1ljb69CsT5Ms+xy7q2jhVkX12DGeOyAEGrTLDzeo/SeeEZZRWx
        uVOqCd9ZI=
Received: from localhost.localdomain (unknown [202.112.113.212])
        by smtp5 (Coremail) with SMTP id HdxpCgC30WdDl89fT5mvEA--.5983S4;
        Tue, 08 Dec 2020 23:09:57 +0800 (CST)
From:   Xiaohui Zhang <ruc_zhangxiaohui@163.com>
To:     Xiaohui Zhang <ruc_zhangxiaohui@163.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] mwifiex: Fix possible buffer overflows in mwifiex_config_scan
Date:   Tue,  8 Dec 2020 23:09:51 +0800
Message-Id: <20201208150951.35866-1-ruc_zhangxiaohui@163.com>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: HdxpCgC30WdDl89fT5mvEA--.5983S4
X-Coremail-Antispam: 1Uf129KBjvdXoWrtr47Ww13AF4xGw43XrW8Zwb_yoWkCwcEgw
        nYqFs7JrW5J3s2yFs09w4xu34ayr1kJFWfua17tayrGFWxtFZxGFnYvrs5Jry3CwnFvF93
        XrsxA3y3Jan7ZjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xRR9YFtUUUUU==
X-Originating-IP: [202.112.113.212]
X-CM-SenderInfo: puxfs6pkdqw5xldrx3rl6rljoofrz/1tbiHgX0MFSIrfsp4gAAse
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zhang Xiaohui <ruc_zhangxiaohui@163.com>

mwifiex_config_scan() calls memcpy() without checking
the destination size may trigger a buffer overflower,
which a local user could use to cause denial of service
or the execution of arbitrary code.
Fix it by putting the length check before calling memcpy().

Signed-off-by: Zhang Xiaohui <ruc_zhangxiaohui@163.com>
---
 drivers/net/wireless/marvell/mwifiex/scan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/scan.c b/drivers/net/wireless/marvell/mwifiex/scan.c
index c2a685f63..34293fd80 100644
--- a/drivers/net/wireless/marvell/mwifiex/scan.c
+++ b/drivers/net/wireless/marvell/mwifiex/scan.c
@@ -931,7 +931,7 @@ mwifiex_config_scan(struct mwifiex_private *priv,
 				wildcard_ssid_tlv->max_ssid_length = 0xfe;
 
 			memcpy(wildcard_ssid_tlv->ssid,
-			       user_scan_in->ssid_list[i].ssid, ssid_len);
+			       user_scan_in->ssid_list[i].ssid, min_t(u32, ssid_len, 1));
 
 			tlv_pos += (sizeof(wildcard_ssid_tlv->header)
 				+ le16_to_cpu(wildcard_ssid_tlv->header.len));
-- 
2.17.1

