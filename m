Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2944510851
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 21:05:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243997AbiDZTGX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 15:06:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353806AbiDZTFu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 15:05:50 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A76A719A4AF;
        Tue, 26 Apr 2022 12:02:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0A873CE20EA;
        Tue, 26 Apr 2022 19:02:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C23AC385B0;
        Tue, 26 Apr 2022 19:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650999759;
        bh=xCiJZCZ9ZeZ92LkRF+pni1gvqdOIeeTL+TY9tYDqNAY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hsGdXgn1j08bU7TQSxiH2Ms1QZ+gIL3C6m4Puogyk3iaN+G9Ho8IadtsKIVV3iUzz
         Q4+WnDdAxbxQ1ivC+fD5ACwQugrDDMfHxcnl4iowo8XErQOCrypw1EElF9kZxS8oLC
         /kdskgmZB9WqVEDDl5M43Jj7WMCcu7S/xzxLR1UQbneiSqwbDYk+DffetNDl9xShLx
         rWbRubkpiuVJzM8onPeRjGddVA9ZJ031PU/G/FWhuNWkvvi/0HauL8WpZhLP2vksGL
         CV/Tck/hEibm1XkGkuAqlwNf804V8PEuKsUAy4qCWC0KPFV2wwZ/AjP9r88toeET4P
         WrDbf6FD27dew==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Duoming Zhou <duoming@zju.edu.cn>, Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>, jes@trained-monkey.org,
        davem@davemloft.net, kuba@kernel.org, linux-hippi@sunsite.dk,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 7/9] drivers: net: hippi: Fix deadlock in rr_close()
Date:   Tue, 26 Apr 2022 15:02:28 -0400
Message-Id: <20220426190232.2351606-7-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220426190232.2351606-1-sashal@kernel.org>
References: <20220426190232.2351606-1-sashal@kernel.org>
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
index 22010384c4a3..b9646b369f8e 100644
--- a/drivers/net/hippi/rrunner.c
+++ b/drivers/net/hippi/rrunner.c
@@ -1353,7 +1353,9 @@ static int rr_close(struct net_device *dev)
 
 	rrpriv->fw_running = 0;
 
+	spin_unlock_irqrestore(&rrpriv->lock, flags);
 	del_timer_sync(&rrpriv->timer);
+	spin_lock_irqsave(&rrpriv->lock, flags);
 
 	writel(0, &regs->TxPi);
 	writel(0, &regs->IpRxPi);
-- 
2.35.1

