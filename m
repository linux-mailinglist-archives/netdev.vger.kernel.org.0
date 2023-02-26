Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 906626A30CD
	for <lists+netdev@lfdr.de>; Sun, 26 Feb 2023 15:53:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230370AbjBZOxh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Feb 2023 09:53:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229961AbjBZOwv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Feb 2023 09:52:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C73A119F1D;
        Sun, 26 Feb 2023 06:49:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B4722B80C0A;
        Sun, 26 Feb 2023 14:47:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 696C3C433EF;
        Sun, 26 Feb 2023 14:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677422868;
        bh=JTXUgg/LGG3Bv9DFiFh/kQ/gaYrlc14G0hjTcoCjYFk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m4r14/2kAvKCJRUSuqya/u8DbmHw+FXo+i6/Ump1fZ0x7NlDaG/x7oZPH3xOMMWzt
         HhTv815O/Z811iAyeId0eb3PYQKM6/ZVgV2KTF/vqZcYh6VaXsoyLg8dI9hC2EuQgE
         ok0eaDRNaHNyglwlFFb/75exxAknAxVN2+HGQLPkdLKWVUctojaM+R89RzCd3D+8vn
         1bb0rApHilBSIvBExMirFQrtu+emjSxmci9j54YlXKwIGvkLbZwnCl0nObrBvXdShm
         OJrTxTJazEaaJaGsC3o5SKqErlmFSQS0pCKqzExDWFkH7fvW2gyut7wISfUkFKT8iE
         SneVQydDmD+3Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Breno Leitao <leitao@debian.org>,
        Michael van der Westhuizen <rmikey@meta.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com,
        wsa+renesas@sang-engineering.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 24/49] netpoll: Remove 4s sleep during carrier detection
Date:   Sun, 26 Feb 2023 09:46:24 -0500
Message-Id: <20230226144650.826470-24-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230226144650.826470-1-sashal@kernel.org>
References: <20230226144650.826470-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Breno Leitao <leitao@debian.org>

[ Upstream commit d8afe2f8a92d2aac3df645772f6ee61b0b2fc147 ]

This patch removes the msleep(4s) during netpoll_setup() if the carrier
appears instantly.

Here are some scenarios where this workaround is counter-productive in
modern ages:

Servers which have BMC communicating over NC-SI via the same NIC as gets
used for netconsole. BMC will keep the PHY up, hence the carrier
appearing instantly.

The link is fibre, SERDES getting sync could happen within 0.1Hz, and
the carrier also appears instantly.

Other than that, if a driver is reporting instant carrier and then
losing it, this is probably a driver bug.

Reported-by: Michael van der Westhuizen <rmikey@meta.com>
Signed-off-by: Breno Leitao <leitao@debian.org>
Link: https://lore.kernel.org/r/20230125185230.3574681-1-leitao@debian.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/netpoll.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/net/core/netpoll.c b/net/core/netpoll.c
index 9be762e1d0428..a089b704b986d 100644
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -682,7 +682,7 @@ int netpoll_setup(struct netpoll *np)
 	}
 
 	if (!netif_running(ndev)) {
-		unsigned long atmost, atleast;
+		unsigned long atmost;
 
 		np_info(np, "device %s not up yet, forcing it\n", np->dev_name);
 
@@ -694,7 +694,6 @@ int netpoll_setup(struct netpoll *np)
 		}
 
 		rtnl_unlock();
-		atleast = jiffies + HZ/10;
 		atmost = jiffies + carrier_timeout * HZ;
 		while (!netif_carrier_ok(ndev)) {
 			if (time_after(jiffies, atmost)) {
@@ -704,15 +703,6 @@ int netpoll_setup(struct netpoll *np)
 			msleep(1);
 		}
 
-		/* If carrier appears to come up instantly, we don't
-		 * trust it and pause so that we don't pump all our
-		 * queued console messages into the bitbucket.
-		 */
-
-		if (time_before(jiffies, atleast)) {
-			np_notice(np, "carrier detect appears untrustworthy, waiting 4 seconds\n");
-			msleep(4000);
-		}
 		rtnl_lock();
 	}
 
-- 
2.39.0

