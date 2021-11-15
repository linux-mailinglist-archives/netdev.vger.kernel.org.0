Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28AA445108D
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 19:47:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242619AbhKOSue (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 13:50:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:54314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242957AbhKOSsQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 13:48:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 24870633A0;
        Mon, 15 Nov 2021 18:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636999674;
        bh=/5/zjtkUvb6/znEQCpD5bOx7lEhiyL1xiej4AeDcJX4=;
        h=From:To:Cc:Subject:Date:From;
        b=XjEOPOoyZn6DhnTqMNdurpr2P7vbTo+DZ3w0worprVF3OM/W7k6BSGzdTzyXfebPh
         ueYIR5hSeG3Y0ss671GsnLwbJCuFNFMP3sXR32023H/FBQkn+FAsWgsHWTl7hOW3PB
         bA4mV5rT5yvI9HqieVzPcxPrIprbzsBIp0Byiob5aAHeD4kVnFleXrB4mPVapC1tkk
         dy1yg4h3W+Nqo2jDeVq3bkWNOrxI3fq2oCC8TEe6E+Hb9idmglV10RExwOilaDmoX9
         02J0/5WeGXaR+kV4nak8vNGIH7uLEQJHfP9HjjT6IvXGbpHmo714TE5dfofeXffL/o
         BJyjW25/Q6JNQ==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Amit Cohen <amcohen@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net] devlink: Remove extra assertion from flash notification logic
Date:   Mon, 15 Nov 2021 20:07:47 +0200
Message-Id: <1d750b6f4991c16995c4d0927b709eb23647ff85.1636999616.git.leonro@nvidia.com>
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

It causes to the WARN_ON to trigger warning about devlink not
registered, while the flow is valid.

Fixes: cf530217408e ("devlink: Notify users when objects are accessible")
Reported-by: Amit Cohen <amcohen@nvidia.com>
Tested-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 net/core/devlink.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 5ba4f9434acd..6face738b16a 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -4229,7 +4229,6 @@ static void __devlink_flash_update_notify(struct devlink *devlink,
 	WARN_ON(cmd != DEVLINK_CMD_FLASH_UPDATE &&
 		cmd != DEVLINK_CMD_FLASH_UPDATE_END &&
 		cmd != DEVLINK_CMD_FLASH_UPDATE_STATUS);
-	WARN_ON(!xa_get_mark(&devlinks, devlink->index, DEVLINK_REGISTERED));
 
 	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
 	if (!msg)
-- 
2.33.1

