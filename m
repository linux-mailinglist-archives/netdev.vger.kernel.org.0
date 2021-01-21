Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C9532FF1ED
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 18:29:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388567AbhAUR2I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 12:28:08 -0500
Received: from mail-m971.mail.163.com ([123.126.97.1]:40686 "EHLO
        mail-m971.mail.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388553AbhAUROF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 12:14:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=AYW8c1hFNGAaj9OQDD
        5oBHxldGvzZKUCswAuB33aPdk=; b=o3jKWEJbzuUPA3QJUUC63MuhmDl4KvLbTN
        as1xYYqjqNgA2SefQNQ5jAAIkRXvc5NRDpw1OybN/RXHR/p0DnPXU9cv0hYNjjZ3
        5neNNaYKCwk5n6bu/I9Q0lTRE1Yvm0iwcNO6sBqGCj40nFodMFqwjo48GrOIXm3V
        PU1DjmtyY=
Received: from localhost.localdomain (unknown [111.201.134.89])
        by smtp1 (Coremail) with SMTP id GdxpCgCnc2PKnwlgR4NUDw--.1356S4;
        Thu, 21 Jan 2021 23:37:49 +0800 (CST)
From:   Pan Bian <bianpan2016@163.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Francis Laniel <laniel_francis@privacyrequired.com>,
        Defang Bo <bodefang@126.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pan Bian <bianpan2016@163.com>
Subject: [PATCH] NFC: fix possible resource leak
Date:   Thu, 21 Jan 2021 07:37:45 -0800
Message-Id: <20210121153745.122184-1-bianpan2016@163.com>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: GdxpCgCnc2PKnwlgR4NUDw--.1356S4
X-Coremail-Antispam: 1Uf129KBjvdXoW5KFW8Zw4xCr4DJw4rKr1Utrb_yoWxWrXEya
        yxXa1kWrn0qF4rJw4xAa15ZF9ayw4Sg348JFn3KayxZa45uF1Y9r4kX39xJFy7GwsIkFy7
        WF1rCFyrC348WjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUUYZX7UUUUU==
X-Originating-IP: [111.201.134.89]
X-CM-SenderInfo: held01tdqsiiqw6rljoofrz/1tbiNg0hclWBlu9d5AAAs8
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Put the device to avoid resource leak on path that the polling flag is
invalid.

Fixes: a831b9132065 ("NFC: Do not return EBUSY when stopping a poll that's already stopped")
Signed-off-by: Pan Bian <bianpan2016@163.com>
---
 net/nfc/netlink.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/nfc/netlink.c b/net/nfc/netlink.c
index 573b38ad2f8e..e161ef2d4720 100644
--- a/net/nfc/netlink.c
+++ b/net/nfc/netlink.c
@@ -852,6 +852,7 @@ static int nfc_genl_stop_poll(struct sk_buff *skb, struct genl_info *info)
 
 	if (!dev->polling) {
 		device_unlock(&dev->dev);
+		nfc_put_device(dev);
 		return -EINVAL;
 	}
 
-- 
2.17.1

