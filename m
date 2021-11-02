Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8156244291B
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 09:10:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229852AbhKBIN0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 04:13:26 -0400
Received: from spam.zju.edu.cn ([61.164.42.155]:60706 "EHLO zju.edu.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229497AbhKBINM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Nov 2021 04:13:12 -0400
Received: from localhost.localdomain (unknown [222.205.7.222])
        by mail-app2 (Coremail) with SMTP id by_KCgA3q_Z18oBhxp9fAA--.22102S4;
        Tue, 02 Nov 2021 16:10:29 +0800 (CST)
From:   Lin Ma <linma@zju.edu.cn>
To:     krzysztof.kozlowski@canonical.com
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lin Ma <linma@zju.edu.cn>
Subject: [PATCH] NFC: add necessary privilege flags in netlink layer
Date:   Tue,  2 Nov 2021 16:10:21 +0800
Message-Id: <20211102081021.32237-1-linma@zju.edu.cn>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: by_KCgA3q_Z18oBhxp9fAA--.22102S4
X-Coremail-Antispam: 1UD129KBjvJXoWxGF4fWF45uryfCw4xKryfJFb_yoW5tF1xpw
        1UCFyktFy8Wr1vqan3Za4qgFWSyr13Ar9rXFn2grW3Xa4rtw1UZF93CFyFqFs5WFyvqF9r
        Zw48JFsakFyrAwUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUv01xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
        w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
        IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW0oVCq3wA2z4x0Y4vEx4A2
        jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS0I0E0xvYzxvE52
        x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUGVWU
        XwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI4
        8JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY02Avz4vE14v_GFyl42xK82IYc2Ij64vIr41l
        42xK82IY6x8ErcxFaVAv8VW8uw4UJr1UMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I
        8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWU
        twCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x
        0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_
        Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUb
        qQ6JUUUUU==
X-CM-SenderInfo: qtrwiiyqvtljo62m3hxhgxhubq/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The CAP_NET_ADMIN checks are needed to prevent attackers faking a
device under NCIUARTSETDRIVER and exploit privileged commands.

This patch add GENL_ADMIN_PERM flags in genl_ops to fulfill the check.
Except for commands like NFC_CMD_GET_DEVICE, NFC_CMD_GET_TARGET,
NFC_CMD_LLC_GET_PARAMS, and NFC_CMD_GET_SE, which are mainly information-
read operations.

Signed-off-by: Lin Ma <linma@zju.edu.cn>
---
 net/nfc/netlink.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/net/nfc/netlink.c b/net/nfc/netlink.c
index 49089c50872e..334f63c9529e 100644
--- a/net/nfc/netlink.c
+++ b/net/nfc/netlink.c
@@ -1664,31 +1664,37 @@ static const struct genl_ops nfc_genl_ops[] = {
 		.cmd = NFC_CMD_DEV_UP,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nfc_genl_dev_up,
+		.flags = GENL_ADMIN_PERM,
 	},
 	{
 		.cmd = NFC_CMD_DEV_DOWN,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nfc_genl_dev_down,
+		.flags = GENL_ADMIN_PERM,
 	},
 	{
 		.cmd = NFC_CMD_START_POLL,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nfc_genl_start_poll,
+		.flags = GENL_ADMIN_PERM,
 	},
 	{
 		.cmd = NFC_CMD_STOP_POLL,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nfc_genl_stop_poll,
+		.flags = GENL_ADMIN_PERM,
 	},
 	{
 		.cmd = NFC_CMD_DEP_LINK_UP,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nfc_genl_dep_link_up,
+		.flags = GENL_ADMIN_PERM,
 	},
 	{
 		.cmd = NFC_CMD_DEP_LINK_DOWN,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nfc_genl_dep_link_down,
+		.flags = GENL_ADMIN_PERM,
 	},
 	{
 		.cmd = NFC_CMD_GET_TARGET,
@@ -1706,26 +1712,31 @@ static const struct genl_ops nfc_genl_ops[] = {
 		.cmd = NFC_CMD_LLC_SET_PARAMS,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nfc_genl_llc_set_params,
+		.flags = GENL_ADMIN_PERM,
 	},
 	{
 		.cmd = NFC_CMD_LLC_SDREQ,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nfc_genl_llc_sdreq,
+		.flags = GENL_ADMIN_PERM,
 	},
 	{
 		.cmd = NFC_CMD_FW_DOWNLOAD,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nfc_genl_fw_download,
+		.flags = GENL_ADMIN_PERM,
 	},
 	{
 		.cmd = NFC_CMD_ENABLE_SE,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nfc_genl_enable_se,
+		.flags = GENL_ADMIN_PERM,
 	},
 	{
 		.cmd = NFC_CMD_DISABLE_SE,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nfc_genl_disable_se,
+		.flags = GENL_ADMIN_PERM,
 	},
 	{
 		.cmd = NFC_CMD_GET_SE,
@@ -1737,21 +1748,25 @@ static const struct genl_ops nfc_genl_ops[] = {
 		.cmd = NFC_CMD_SE_IO,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nfc_genl_se_io,
+		.flags = GENL_ADMIN_PERM,
 	},
 	{
 		.cmd = NFC_CMD_ACTIVATE_TARGET,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nfc_genl_activate_target,
+		.flags = GENL_ADMIN_PERM,
 	},
 	{
 		.cmd = NFC_CMD_VENDOR,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nfc_genl_vendor_cmd,
+		.flags = GENL_ADMIN_PERM,
 	},
 	{
 		.cmd = NFC_CMD_DEACTIVATE_TARGET,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nfc_genl_deactivate_target,
+		.flags = GENL_ADMIN_PERM,
 	},
 };
 
-- 
2.33.1

