Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDE0747D049
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 11:49:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244280AbhLVKtF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 05:49:05 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:46436 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239538AbhLVKtE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 05:49:04 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C8151B817BF;
        Wed, 22 Dec 2021 10:49:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D570C36AE8;
        Wed, 22 Dec 2021 10:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640170141;
        bh=q9AiZpmHTBiVf5ICrBjV0PfC2Y0veW5ycB704qqI/Zs=;
        h=From:To:Cc:Subject:Date:From;
        b=g9nP3zltP8RhP2Nr9zqFPLqNoLOJQpCPhbyFygCmLxEykzHnNvZMYt6iQo4o1vS80
         wqmRyQxm0yOCUG7lfwtcrVg2l4IW6CiuVCeF9BJMuTQtpLF6SZL50mMetcHPfy2rwg
         cZv18ZobzWTNcAIauaFCO0KH8Xzjtj2cJFdfP2q1N0IgwiYcepLQX36wk+Pq6r5JU5
         /Rg7cah2dsjOx3DeMK+Nc30X6kilkVHs7JKNdAvZlM7FFSSbWWvclXb4dvpsJLc+CM
         5ZcHpMn/DoNHLBX2weiqoJFEGSaYCo39x6hElaMvAx86K5KtXcnT8wjaZvbydkxf9F
         e4PD4dWH7aUUA==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1mzzAy-0001bF-Nm; Wed, 22 Dec 2021 11:48:53 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>, stable@vger.kernel.org
Subject: [PATCH] can: softing_cs: fix memleak on registration failure
Date:   Wed, 22 Dec 2021 11:48:43 +0100
Message-Id: <20211222104843.6105-1-johan@kernel.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In case device registration fails during probe, the driver state and the
embedded platform device structure needs to be freed using
platform_device_put() to properly free all resources (e.g. the device
name).

Fixes: 0a0b7a5f7a04 ("can: add driver for Softing card")
Cc: stable@vger.kernel.org      # 2.6.38
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/net/can/softing/softing_cs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/softing/softing_cs.c b/drivers/net/can/softing/softing_cs.c
index 2e93ee792373..e5c939b63fa6 100644
--- a/drivers/net/can/softing/softing_cs.c
+++ b/drivers/net/can/softing/softing_cs.c
@@ -293,7 +293,7 @@ static int softingcs_probe(struct pcmcia_device *pcmcia)
 	return 0;
 
 platform_failed:
-	kfree(dev);
+	platform_device_put(pdev);
 mem_failed:
 pcmcia_bad:
 pcmcia_failed:
-- 
2.32.0

