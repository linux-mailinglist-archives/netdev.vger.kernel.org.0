Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3ED012966E
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 14:25:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726763AbfLWNZL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 08:25:11 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:34193 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726676AbfLWNZL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Dec 2019 08:25:11 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 33177afe;
        Mon, 23 Dec 2019 12:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:mime-version:content-type
        :content-transfer-encoding; s=mail; bh=PR2EZO8ufGYRsxJoOzfwo7jvX
        u4=; b=wLe3r14OcAm7t4tv5liciSiyFaX8aDUzz9GpVXEbPSL9j6jGPHGZh0bu2
        RSusyyCf6irJqgVfNCT161fHlrfUPVPUkk6ya66R+lXfVDk1mn5Th8l3sfjGpVCu
        SGKBKyDmVP7N7rYjjWc5xyzr+DLtjD6FFAUj2Xt1erL7eMIoDnJukTXCrS4Q9WUn
        8utRd7vFMeHbeHlhgTXn0GvXarfKZc4dXml1JZk4QH9GW3S0hxS+xDg79/cAxFbj
        GgHGoIeZWFa2Ah7ndgNcna6f5fiuXTJKaytsrD3rQMgAqitAbKOtw6Ji4uCE0cG4
        ZUJfAX1OHKxR8Q46a7vQDUdJ1FCuw==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 05becb2e (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Mon, 23 Dec 2019 12:27:56 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>
Subject: [PATCH net] of: mdio: mark stub of_mdiobus_child_is_phy as inline
Date:   Mon, 23 Dec 2019 14:24:43 +0100
Message-Id: <20191223132443.115540-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The of_mdiobus_child_is_phy function was recently exported, with a stub
fallback added to simply return false as a static function. The inline
specifier was left out, leading to build time errors:

In file included from linux/include/linux/fs_enet_pd.h:21,
                 from linux/arch/powerpc/sysdev/fsl_soc.c:26:
linux/include/linux/of_mdio.h:58:13: error: ‘of_mdiobus_child_is_phy’ defined but not used [-Werror=unused-function]
   58 | static bool of_mdiobus_child_is_phy(struct device_node *child)
      |             ^~~~~~~~~~

This commit simply adds the missing inline keyboard.

Fixes: 0aa4d016c043 ("of: mdio: export of_mdiobus_child_is_phy")
Cc: Antoine Tenart <antoine.tenart@bootlin.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 include/linux/of_mdio.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/of_mdio.h b/include/linux/of_mdio.h
index 79bc82e30c02..491a2b7e77c1 100644
--- a/include/linux/of_mdio.h
+++ b/include/linux/of_mdio.h
@@ -55,7 +55,7 @@ static inline int of_mdio_parse_addr(struct device *dev,
 }
 
 #else /* CONFIG_OF_MDIO */
-static bool of_mdiobus_child_is_phy(struct device_node *child)
+static inline bool of_mdiobus_child_is_phy(struct device_node *child)
 {
 	return false;
 }
-- 
2.24.1

