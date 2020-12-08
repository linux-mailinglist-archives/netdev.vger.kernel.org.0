Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0334E2D2EF6
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 17:03:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730223AbgLHQBv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 11:01:51 -0500
Received: from mail-m974.mail.163.com ([123.126.97.4]:52366 "EHLO
        mail-m974.mail.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729457AbgLHQBv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 11:01:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=uydyfv6dBZLBaJwhlC
        uT4w8P4Tr0sCOHWU4LHFwTKNw=; b=FvkTNMsoyw2zMFZO+TwvC8a8gGdg0kPqY7
        3yiUi3JXiOuEyb+Ma5/U1/2Ot/lvH8b9tBuAMP5y1My6m5FrS+v6jfz7uDk427CG
        RYvp73c+Do9lHGLFlDUm13H0TNhonjfl+FysfZoda+fIQP1XhG1FCkzxh2OqsPLF
        TcuyN2oOM=
Received: from localhost.localdomain (unknown [202.112.113.212])
        by smtp4 (Coremail) with SMTP id HNxpCgDHguszn89frv_Obg--.51829S4;
        Tue, 08 Dec 2020 23:43:52 +0800 (CST)
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
Subject: [PATCH 1/1] mwifiex: Fix possible buffer overflows in mwifiex_uap_bss_param_prepare
Date:   Tue,  8 Dec 2020 23:43:43 +0800
Message-Id: <20201208154343.6946-1-ruc_zhangxiaohui@163.com>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: HNxpCgDHguszn89frv_Obg--.51829S4
X-Coremail-Antispam: 1Uf129KBjvJXoW7Kr43urWUZrWUuw1rArW7XFb_yoW8GF4fpa
        yqgay8Cr1xAr1qkwn7Ja1kGas0ga1jgF13urWkA34rCr1fJryfZFyqgFy09ry5Zan7t34j
        vrW8J3Z5Zrn5GFJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zRKQ6JUUUUU=
X-Originating-IP: [202.112.113.212]
X-CM-SenderInfo: puxfs6pkdqw5xldrx3rl6rljoofrz/1tbiThj0MFUDGb2BAgAAsj
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zhang Xiaohui <ruc_zhangxiaohui@163.com>

mwifiex_uap_bss_param_prepare() calls memcpy() without checking
the destination size may trigger a buffer overflower,
which a local user could use to cause denial of service or the
execution of arbitrary code.
Fix it by putting the length check before calling memcpy().

Signed-off-by: Zhang Xiaohui <ruc_zhangxiaohui@163.com>
---
 drivers/net/wireless/marvell/mwifiex/uap_cmd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/uap_cmd.c b/drivers/net/wireless/marvell/mwifiex/uap_cmd.c
index b48a85d79..937c75e89 100644
--- a/drivers/net/wireless/marvell/mwifiex/uap_cmd.c
+++ b/drivers/net/wireless/marvell/mwifiex/uap_cmd.c
@@ -502,7 +502,8 @@ mwifiex_uap_bss_param_prepare(u8 *tlv, void *cmd_buf, u16 *param_size)
 		ssid = (struct host_cmd_tlv_ssid *)tlv;
 		ssid->header.type = cpu_to_le16(TLV_TYPE_UAP_SSID);
 		ssid->header.len = cpu_to_le16((u16)bss_cfg->ssid.ssid_len);
-		memcpy(ssid->ssid, bss_cfg->ssid.ssid, bss_cfg->ssid.ssid_len);
+		memcpy(ssid->ssid, bss_cfg->ssid.ssid,
+		       min_t(u32, bss_cfg->ssid.ssid_len, strlen(ssid->ssid)));
 		cmd_size += sizeof(struct mwifiex_ie_types_header) +
 			    bss_cfg->ssid.ssid_len;
 		tlv += sizeof(struct mwifiex_ie_types_header) +
-- 
2.17.1

