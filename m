Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 294773DCA6E
	for <lists+netdev@lfdr.de>; Sun,  1 Aug 2021 08:53:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbhHAGxi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Aug 2021 02:53:38 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:54084
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229491AbhHAGxh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Aug 2021 02:53:37 -0400
Received: from localhost (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 960963F102;
        Sun,  1 Aug 2021 06:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1627800808;
        bh=MVGbXfOBpRdXMHQEhJc+YLSbXDPSW0OXV8jd1Q2x+hM=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=WusTwY3qqTmd5CRJbDUmnk8MBCUWFgpYr/X5xzPAIhimbvP3w5F6Yb6kF+LG99cDV
         R2eCs0EOLQqkklaAOXHJZ933MWwKP/Eide1v3uSVvyb5ACkdZ8oSdQ8UiTpnEcq8yK
         6M4ZtKyBu5cjKzraQOUUUt+ilqNFoQaRR9/RiR8sZDx2w7vQW+YpmH/0b5bY43iOYY
         isB2s1/nUua4P2TO0WZLF78RQVizcVWahKcWI1z4X4GA/r1fGSDp6A98NEAy1/gzPu
         5uSIQOnCQ5lsuA0HAGbk4Cx1WFGI8KwhdSBAW0pFKPZ4Bb9Y8TrwY1u6apbb23bE1K
         w3tSWufXitxgw==
From:   Colin King <colin.king@canonical.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] netdevsim: make array res_ids static const, makes object smaller
Date:   Sun,  1 Aug 2021 07:53:28 +0100
Message-Id: <20210801065328.138906-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Don't populate the array res_ids on the stack but instead it
static const. Makes the object code smaller by 14 bytes.

Before:
   text    data     bss     dec     hex filename
  50833    8314     256   59403    e80b ./drivers/net/netdevsim/fib.o

After:
   text    data     bss     dec     hex filename
  50755    8378     256   59389    e7fd ./drivers/net/netdevsim/fib.o

(gcc version 10.2.0)

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/netdevsim/fib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/netdevsim/fib.c b/drivers/net/netdevsim/fib.c
index 213d3e5056c8..4300261e2f9e 100644
--- a/drivers/net/netdevsim/fib.c
+++ b/drivers/net/netdevsim/fib.c
@@ -1441,7 +1441,7 @@ static u64 nsim_fib_nexthops_res_occ_get(void *priv)
 static void nsim_fib_set_max_all(struct nsim_fib_data *data,
 				 struct devlink *devlink)
 {
-	enum nsim_resource_id res_ids[] = {
+	static const enum nsim_resource_id res_ids[] = {
 		NSIM_RESOURCE_IPV4_FIB, NSIM_RESOURCE_IPV4_FIB_RULES,
 		NSIM_RESOURCE_IPV6_FIB, NSIM_RESOURCE_IPV6_FIB_RULES,
 		NSIM_RESOURCE_NEXTHOPS,
-- 
2.31.1

