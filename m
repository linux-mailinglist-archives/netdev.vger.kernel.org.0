Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 981554FCB07
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 03:01:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344862AbiDLBCs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 21:02:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349945AbiDLA7r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 20:59:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1342387B0;
        Mon, 11 Apr 2022 17:53:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C5C460B2F;
        Tue, 12 Apr 2022 00:53:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCC59C385A4;
        Tue, 12 Apr 2022 00:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649724788;
        bh=GEnbYpG+qlLDkKaghPTF8kMswkCQsM5G0G3tZu8Jsos=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=suj5VRvWEg5JPN9/+GwB/x5PbTDcES3a499AJZ17gN4omj99NxcFDOaQ775vKQ1Oq
         xUIMhpJTRcglxM9KUGFYgsDJ66nBDCwReMyAq0PNeY/zzh+t1BRejmJOfDzk8Kmt1D
         wK35GyKA+JiolVVj58oVcB/SxMlV/vwGRV6T4uKmhj2LlGomz7ciNB1GhlKpGpLZSU
         6RZql8UKnbYpzst+lhx4u5eFUWAje046X/qL9lNmP3SA1fO2lm1172NVuNY+KA9ybo
         1neEOnXDgBhW3PHTijplm1nbE4l585e7YgTzH7+QmFHhpBi35geEybJpsE2Swax1zh
         RJ7z2KZP9qOnQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Duoming Zhou <duoming@zju.edu.cn>,
        Jiri Slaby <jirislaby@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        pabeni@redhat.com, gregkh@linuxfoundation.org, mkl@pengutronix.de,
        dmitry.torokhov@gmail.com, bigeasy@linutronix.de, arnd@arndb.de,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 7/7] drivers: net: slip: fix NPD bug in sl_tx_timeout()
Date:   Mon, 11 Apr 2022 20:52:48 -0400
Message-Id: <20220412005248.351701-7-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412005248.351701-1-sashal@kernel.org>
References: <20220412005248.351701-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Duoming Zhou <duoming@zju.edu.cn>

[ Upstream commit ec4eb8a86ade4d22633e1da2a7d85a846b7d1798 ]

When a slip driver is detaching, the slip_close() will act to
cleanup necessary resources and sl->tty is set to NULL in
slip_close(). Meanwhile, the packet we transmit is blocked,
sl_tx_timeout() will be called. Although slip_close() and
sl_tx_timeout() use sl->lock to synchronize, we don`t judge
whether sl->tty equals to NULL in sl_tx_timeout() and the
null pointer dereference bug will happen.

   (Thread 1)                 |      (Thread 2)
                              | slip_close()
                              |   spin_lock_bh(&sl->lock)
                              |   ...
...                           |   sl->tty = NULL //(1)
sl_tx_timeout()               |   spin_unlock_bh(&sl->lock)
  spin_lock(&sl->lock);       |
  ...                         |   ...
  tty_chars_in_buffer(sl->tty)|
    if (tty->ops->..) //(2)   |
    ...                       |   synchronize_rcu()

We set NULL to sl->tty in position (1) and dereference sl->tty
in position (2).

This patch adds check in sl_tx_timeout(). If sl->tty equals to
NULL, sl_tx_timeout() will goto out.

Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Reviewed-by: Jiri Slaby <jirislaby@kernel.org>
Link: https://lore.kernel.org/r/20220405132206.55291-1-duoming@zju.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/slip/slip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/slip/slip.c b/drivers/net/slip/slip.c
index f870396e05e1..ba26fa0ceba8 100644
--- a/drivers/net/slip/slip.c
+++ b/drivers/net/slip/slip.c
@@ -471,7 +471,7 @@ static void sl_tx_timeout(struct net_device *dev)
 	spin_lock(&sl->lock);
 
 	if (netif_queue_stopped(dev)) {
-		if (!netif_running(dev))
+		if (!netif_running(dev) || !sl->tty)
 			goto out;
 
 		/* May be we must check transmitter timeout here ?
-- 
2.35.1

