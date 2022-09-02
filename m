Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DD665AA626
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 05:07:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234960AbiIBDGe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 23:06:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234953AbiIBDGa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 23:06:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22FC1A0605;
        Thu,  1 Sep 2022 20:06:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A1A7761E9E;
        Fri,  2 Sep 2022 03:06:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD7CBC433D7;
        Fri,  2 Sep 2022 03:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662087983;
        bh=ktc2AGz8VxbQZeTJBK3+0EQcOGJ74PqaTCAHZCGvWXU=;
        h=From:To:Cc:Subject:Date:From;
        b=B2WVj+spuTnyX+CPKeDtGNCD7fZ+TtBnCMTiOvzvE3dv/ufrJiy3aCsyCzGuw2ECx
         E0ci2P2gqizbeQD12QcWZertUB7wSTt7w9B7xpB/viW1XwFwLAdP5wciIznewS8bIb
         0QWLe4doHeyBW19CuoDM4geQA5bwvyAHrMWP+77qbHpGO+7zw+hXq/GuEkU8cMtDxD
         kBhJnztMlklqO0OsivJvwK9tRU6x/nglF9Z1wL6b6+nSkeS8r8Sqrl9oFv+EwG2rB9
         UhxtB0sqkzVHN4FvdrIUXI41WsijM/RCLXG8/PpnQUzK3ywrgAO7rEX8jP+87hcpxB
         rhzzQ/iCaEldA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        leon@kernel.org, sudipm.mukherjee@gmail.com,
        Gal Pressman <gal@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>, alex.aring@gmail.com,
        stefan@datenfreihafen.org, paul@paul-moore.com,
        linux-wpan@vger.kernel.org
Subject: [PATCH net-next v2] net: ieee802154: Fix compilation error when CONFIG_IEEE802154_NL802154_EXPERIMENTAL is disabled
Date:   Thu,  1 Sep 2022 20:06:20 -0700
Message-Id: <20220902030620.2737091-1-kuba@kernel.org>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gal Pressman <gal@nvidia.com>

When CONFIG_IEEE802154_NL802154_EXPERIMENTAL is disabled,
NL802154_CMD_DEL_SEC_LEVEL is undefined and results in a compilation
error:
net/ieee802154/nl802154.c:2503:19: error: 'NL802154_CMD_DEL_SEC_LEVEL' undeclared here (not in a function); did you mean 'NL802154_CMD_SET_CCA_ED_LEVEL'?
 2503 |  .resv_start_op = NL802154_CMD_DEL_SEC_LEVEL + 1,
      |                   ^~~~~~~~~~~~~~~~~~~~~~~~~~
      |                   NL802154_CMD_SET_CCA_ED_LEVEL

Unhide the experimental commands, having them defined in an enum
makes no difference.

Fixes: 9c5d03d36251 ("genetlink: start to validate reserved header bytes")
Signed-off-by: Gal Pressman <gal@nvidia.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
v1: /tmp/0001-net-ieee802154-Fix-compilation-error-when-CONFIG_IEE.patch
v2: unhide instead of changing the define used

CC: alex.aring@gmail.com
CC: stefan@datenfreihafen.org
CC: paul@paul-moore.com
CC: linux-wpan@vger.kernel.org
---
 include/net/nl802154.h | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/include/net/nl802154.h b/include/net/nl802154.h
index 145acb8f2509..f5850b569c52 100644
--- a/include/net/nl802154.h
+++ b/include/net/nl802154.h
@@ -58,9 +58,6 @@ enum nl802154_commands {
 
 	NL802154_CMD_SET_WPAN_PHY_NETNS,
 
-	/* add new commands above here */
-
-#ifdef CONFIG_IEEE802154_NL802154_EXPERIMENTAL
 	NL802154_CMD_SET_SEC_PARAMS,
 	NL802154_CMD_GET_SEC_KEY,		/* can dump */
 	NL802154_CMD_NEW_SEC_KEY,
@@ -74,7 +71,8 @@ enum nl802154_commands {
 	NL802154_CMD_GET_SEC_LEVEL,		/* can dump */
 	NL802154_CMD_NEW_SEC_LEVEL,
 	NL802154_CMD_DEL_SEC_LEVEL,
-#endif /* CONFIG_IEEE802154_NL802154_EXPERIMENTAL */
+
+	/* add new commands above here */
 
 	/* used to define NL802154_CMD_MAX below */
 	__NL802154_CMD_AFTER_LAST,
-- 
2.37.2

