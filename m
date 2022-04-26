Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7723351085B
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 21:05:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346125AbiDZTGu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 15:06:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353888AbiDZTGP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 15:06:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 051A91999C6;
        Tue, 26 Apr 2022 12:03:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A6C92B82250;
        Tue, 26 Apr 2022 19:03:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50567C385B3;
        Tue, 26 Apr 2022 19:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650999782;
        bh=O726eevFd4aa9bv4B67BLbuQbMjvTTVMMcyh219BVxE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mopUpv9RaVceM87dOZlg+cy0dRZYR21ZRO8jsiyYnLOaa2kgIj/1pf0JbzOLNZMi8
         VXSa02/JXo13AbrQPusaBd+msXXnsqXOlICuuY85Mi7AANrxffXB4Jm6iym7e2Bhoq
         p1xDUTXDRZZ6cRlB1EEqXvYJMA2GcSenN9tkQ7Dfoppu6Kj8iTP9t++CX4uCBYMhWs
         WhCTQ8llQYB0qrYW6nxFb/f6b4teVSQsS4ZHd92FZXA8HnxmgOPSaEhanteTFqcwtU
         Mzy1iLm6J7HS7U6QImcnV+m2+Y3qQfOJklIgzUpht5w2AENt50eJYBoMYdlpREcI8u
         kDwCLr9VmzmJA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Duoming Zhou <duoming@zju.edu.cn>, Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>, jes@trained-monkey.org,
        davem@davemloft.net, kuba@kernel.org, linux-hippi@sunsite.dk,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 4/5] drivers: net: hippi: Fix deadlock in rr_close()
Date:   Tue, 26 Apr 2022 15:02:55 -0400
Message-Id: <20220426190258.2351902-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220426190258.2351902-1-sashal@kernel.org>
References: <20220426190258.2351902-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Duoming Zhou <duoming@zju.edu.cn>

[ Upstream commit bc6de2878429e85c1f1afaa566f7b5abb2243eef ]

There is a deadlock in rr_close(), which is shown below:

   (Thread 1)                |      (Thread 2)
                             | rr_open()
rr_close()                   |  add_timer()
 spin_lock_irqsave() //(1)   |  (wait a time)
 ...                         | rr_timer()
 del_timer_sync()            |  spin_lock_irqsave() //(2)
 (wait timer to stop)        |  ...

We hold rrpriv->lock in position (1) of thread 1 and
use del_timer_sync() to wait timer to stop, but timer handler
also need rrpriv->lock in position (2) of thread 2.
As a result, rr_close() will block forever.

This patch extracts del_timer_sync() from the protection of
spin_lock_irqsave(), which could let timer handler to obtain
the needed lock.

Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Link: https://lore.kernel.org/r/20220417125519.82618-1-duoming@zju.edu.cn
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/hippi/rrunner.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/hippi/rrunner.c b/drivers/net/hippi/rrunner.c
index 40ef4aeb0ef0..3a73ac03fb2b 100644
--- a/drivers/net/hippi/rrunner.c
+++ b/drivers/net/hippi/rrunner.c
@@ -1354,7 +1354,9 @@ static int rr_close(struct net_device *dev)
 
 	rrpriv->fw_running = 0;
 
+	spin_unlock_irqrestore(&rrpriv->lock, flags);
 	del_timer_sync(&rrpriv->timer);
+	spin_lock_irqsave(&rrpriv->lock, flags);
 
 	writel(0, &regs->TxPi);
 	writel(0, &regs->IpRxPi);
-- 
2.35.1

