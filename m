Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 466F72D2B9A
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 14:05:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728653AbgLHNDe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 08:03:34 -0500
Received: from mail-m974.mail.163.com ([123.126.97.4]:54852 "EHLO
        mail-m974.mail.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726104AbgLHNDd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 08:03:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=2vcpyoHgJzYZ/txQx7
        wtmk/iK/UcML704UL35GPC6CE=; b=iIY5MC+lMxcxfNYwc7Fwsw561wUW1jURKP
        evXq9F7QD2MMtak2M5rkRAFIEbUSyXxhd8YTmpluFMMDP/oRhm4DoLD0Z5p2+jXY
        cKU+TsxDE3rLwTeMD21bFVtyaTZ1twSRVoj7vPEnlG7ukLc9zMPMNOmNg0/u7khH
        jsqQpomc0=
Received: from localhost.localdomain (unknown [202.112.113.212])
        by smtp4 (Coremail) with SMTP id HNxpCgDn9k9ldc9fB_69bg--.53933S4;
        Tue, 08 Dec 2020 20:45:33 +0800 (CST)
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
Date:   Tue,  8 Dec 2020 20:45:23 +0800
Message-Id: <20201208124523.8169-1-ruc_zhangxiaohui@163.com>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: HNxpCgDn9k9ldc9fB_69bg--.53933S4
X-Coremail-Antispam: 1Uf129KBjvdXoWrtr47Ww13AF4xGw43XrW8Zwb_yoWDArgEgw
        sYqrs7JrZ8J34IkFs09rWxu34Fyr1kJFZ3Ga17trWrGFWIya9xKFnYvFs5JryUCwnFvF93
        Xrs8Ar4UJa18ZjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xRR9YFtUUUUU==
X-Originating-IP: [202.112.113.212]
X-CM-SenderInfo: puxfs6pkdqw5xldrx3rl6rljoofrz/1tbiTg30MFUDGbq93wAAsQ
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
 drivers/net/wireless/marvell/mwifiex/scan.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/scan.c b/drivers/net/wireless/marvell/mwifiex/scan.c
index c2a685f63..b1d90678f 100644
--- a/drivers/net/wireless/marvell/mwifiex/scan.c
+++ b/drivers/net/wireless/marvell/mwifiex/scan.c
@@ -930,6 +930,8 @@ mwifiex_config_scan(struct mwifiex_private *priv,
 				    "DIRECT-", 7))
 				wildcard_ssid_tlv->max_ssid_length = 0xfe;
 
+			if (ssid_len > 1)
+				ssid_len = 1;
 			memcpy(wildcard_ssid_tlv->ssid,
 			       user_scan_in->ssid_list[i].ssid, ssid_len);
 
-- 
2.17.1

