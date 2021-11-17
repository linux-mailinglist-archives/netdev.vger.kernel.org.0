Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 531AD454924
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 15:49:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230232AbhKQOwY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 09:52:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:59530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229751AbhKQOwY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Nov 2021 09:52:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A184D61269;
        Wed, 17 Nov 2021 14:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637160565;
        bh=F/4hvn++wm7w8Ex8n6djxKfi0refSoyymMEBm3VvVnk=;
        h=From:To:Cc:Subject:Date:From;
        b=fNhJO40CCbds1zbwPMo7Enf/AtoGJyxjFeH2GpB4N8mW2PWWyi+AmsYlmMoBFT5B5
         4I+JwQiShvSCVw7thKJZW9OT8v9vHlcRRLg2VWeMGWNF/WL+qCSriBMZzZOr5l5ZMP
         1DUS84WPx0PViNLV9SjuxUL+jIjsRn/btJiZU4hrE8XETFWx74RP9elDUq99jEpzOu
         fNQcEgEbzwHvLJhwNC+KP2jrtV8PD1D5yorAMl0DSwpCZPLNZDOH2mzWeodV6bAKXp
         ImschFs3x7C0c+KNpeX1X1dWvSWklASeZI/RyL2ljE5WgYxQFTlR8vjqfELDEUeyom
         WJOfj4lUSpNbA==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Danielle Ratson <danieller@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Amit Cohen <amcohen@nvidia.com>
Subject: [PATCH net v1] devlink: Don't throw an error if flash notification sent before devlink visible
Date:   Wed, 17 Nov 2021 16:49:09 +0200
Message-Id: <1009da147a0254f01779a47610de8df83d18cefe.1637160341.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

The mlxsw driver calls to various devlink flash routines even before
users can get any access to the devlink instance itself. For example,
mlxsw_core_fw_rev_validate() one of such functions.

__mlxsw_core_bus_device_register
 -> mlxsw_core_fw_rev_validate
  -> mlxsw_core_fw_flash
   -> mlxfw_firmware_flash
    -> mlxfw_status_notify
     -> devlink_flash_update_status_notify
      -> __devlink_flash_update_notify
       -> WARN_ON(...)

It causes to the WARN_ON to trigger warning about devlink not registered.

Fixes: cf530217408e ("devlink: Notify users when objects are accessible")
Reported-by: Danielle Ratson <danieller@nvidia.com>
Tested-by: Danielle Ratson <danieller@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
v1:
 * Used Jakub's suggestion to silently drop flash notifications if
   devlink is not visible yet.
 * Used right person for Reported and Tested tags. 
v0: https://lore.kernel.org/all/1d750b6f4991c16995c4d0927b709eb23647ff85.1636999616.git.leonro@nvidia.com
---
 net/core/devlink.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 5ba4f9434acd..5ad72dbfcd07 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -4229,7 +4229,9 @@ static void __devlink_flash_update_notify(struct devlink *devlink,
 	WARN_ON(cmd != DEVLINK_CMD_FLASH_UPDATE &&
 		cmd != DEVLINK_CMD_FLASH_UPDATE_END &&
 		cmd != DEVLINK_CMD_FLASH_UPDATE_STATUS);
-	WARN_ON(!xa_get_mark(&devlinks, devlink->index, DEVLINK_REGISTERED));
+
+	if (!xa_get_mark(&devlinks, devlink->index, DEVLINK_REGISTERED))
+		return;
 
 	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
 	if (!msg)
-- 
2.33.1

