Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A69F292703
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 14:11:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726421AbgJSMLJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 08:11:09 -0400
Received: from m15111.mail.126.com ([220.181.15.111]:42118 "EHLO
        m15111.mail.126.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726249AbgJSMLJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 08:11:09 -0400
X-Greylist: delayed 1849 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Oct 2020 08:11:08 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=0gw4hOkCV2VI5B0MD3
        VgbMMqagNWtz7m5fojK0FM+mc=; b=gcCXOxi2JLLFkWlHbXMBgnFWugp6U+5DI7
        etV9poOpJclwAcDI5R/0yDiyXGbq3rRtrttrZ0zHiixCG0Lru6lgYK/ftY3V9rHE
        O8w8PgZZ93xV2rcq6G0sW0QYudo+UGFnftczVRmCWZkYS1xDoyKQ5Z8mA734f01l
        0UgPemG0o=
Received: from localhost.localdomain (unknown [36.112.86.14])
        by smtp1 (Coremail) with SMTP id C8mowABHCkrmeo1fTJVBKg--.33783S2;
        Mon, 19 Oct 2020 19:39:19 +0800 (CST)
From:   Defang Bo <bodefang@126.com>
To:     davem@davemloft.net, johan@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Defang Bo <bodefang@126.com>
Subject: [PATCH] nfc: Ensure presence of NFC_ATTR_FIRMWARE_NAME attribute in nfc_genl_fw_download()
Date:   Mon, 19 Oct 2020 19:38:58 +0800
Message-Id: <1603107538-4744-1-git-send-email-bodefang@126.com>
X-Mailer: git-send-email 1.9.1
X-CM-TRANSID: C8mowABHCkrmeo1fTJVBKg--.33783S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7XFyDZw13XF43Zw4kGF4kJFb_yoWDKFXEyF
        WFv3yv9w15XF4rCw47Aw1SvFySgw1fWF18AFySkrZrZryF93W5urn2q39xGF1fWw4jyasx
        XFySgryfG343AjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUnw0ePUUUUU==
X-Originating-IP: [36.112.86.14]
X-CM-SenderInfo: pergvwxdqjqiyswou0bp/1tbitQfC11pECOkg1wAAsv
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

check that the NFC_ATTR_FIRMWARE_NAME attributes are provided by the netlink client prior to accessing them.This prevents potential unhandled NULL pointer
dereference exceptions which can be triggered by malicious user-mode programs, if they omit one or both of these attributes. Just similar to commit <a0323b979f81>("nfc: Ensure presence of required attributes in the activate_target handler").

Signed-off-by: Defang Bo <bodefang@126.com>
---
 net/nfc/netlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/nfc/netlink.c b/net/nfc/netlink.c
index e894254..8709f3d 100644
--- a/net/nfc/netlink.c
+++ b/net/nfc/netlink.c
@@ -1217,7 +1217,7 @@ static int nfc_genl_fw_download(struct sk_buff *skb, struct genl_info *info)
 	u32 idx;
 	char firmware_name[NFC_FIRMWARE_NAME_MAXSIZE + 1];
 
-	if (!info->attrs[NFC_ATTR_DEVICE_INDEX])
+	if (!info->attrs[NFC_ATTR_DEVICE_INDEX] || !info->attrs[NFC_ATTR_FIRMWARE_NAME])
 		return -EINVAL;
 
 	idx = nla_get_u32(info->attrs[NFC_ATTR_DEVICE_INDEX]);
-- 
1.9.1

