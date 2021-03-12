Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 135C9338277
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 01:35:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229470AbhCLAeq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 19:34:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbhCLAeU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 19:34:20 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47145C061574
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 16:34:19 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id n10so14738240pgl.10
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 16:34:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ecmGcBcPtcC0qLRj92pOo7aiI2XbXGDbepHsnlPEhKY=;
        b=uRnnhsFaMWAuEO+6ZLYgb7Ky3o276oe+fpImfQ7mGCqrZjRvbNC40jZz17/VKxRYmE
         s4LThJe/rkdzvW0lpBwXo7ONoa5gUfymb53oD8ExaiLZPnB4p6Yi+QslmdugmcyOmloa
         v4ZghTUyGQkQiC1vXePXjvmkmlvJbVGDgsn/fhXC3Yeyv4WX35nkSJT3qFyqHiKPnMNN
         dgO25n6iq+LDF4ycj+/U7wJu70ljdAnSrNwqZfvOWZLrl1rhaLXD3FqkAGKygcPtLOCs
         mFWhf0TN3EJF1eSgTUWQYa8Rgzfi7k9YCKLeOAVODYejJYxQWGeiwmgSXgn/rsh1fd+e
         QqVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=ecmGcBcPtcC0qLRj92pOo7aiI2XbXGDbepHsnlPEhKY=;
        b=APqGgmFF3wXmA/BoKJ24BhNfKi33tedvr0TdjVweayAT9PGZFQoGUCEbX4uRmCW3h5
         WvkNd0FeCZBMvabDK1++gnxDt5nBs0Dhn4PyPWAnpCs5JgwE064pToBY6EjjMOZYCnKw
         SIs0MbjXhY6xYXpHaP2CsNL1PfuGUgB/fAdk32lKmDprVeZOA1EwvMLqxGqunxNwCIoZ
         a9X3sQzKCyvUUMBUGXUT0LejAwHIkNonuOigBoxgh57EAxSgDKDBzR6ss8VWZgHZn/4T
         MjDMTdXm3Xkb4sq68JeY8adJHx6hlPPf/hIsuX9licSsQU+Y5J75p34P0hhDxsor+tnu
         2dvw==
X-Gm-Message-State: AOAM531pmjJzXG7xlBRmC+Ids0JF3Opiwzf7bLICfVs5t5qJZQOCnLW4
        ha/QHXjIt9kMQnl1oc3oNrsQhAHcri7zJg==
X-Google-Smtp-Source: ABdhPJweyJCHaXbghHXDfc7eUQSBdHSgMgCaf2TV78WVhiSADU69z04oUzgwHkgQakmuC5i0vr8FxA==
X-Received: by 2002:a62:92cc:0:b029:1fa:515d:808f with SMTP id o195-20020a6292cc0000b02901fa515d808fmr9791956pfd.43.1615509258719;
        Thu, 11 Mar 2021 16:34:18 -0800 (PST)
Received: from localhost.localdomain ([45.124.203.14])
        by smtp.gmail.com with ESMTPSA id y20sm3497134pfo.210.2021.03.11.16.34.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Mar 2021 16:34:18 -0800 (PST)
Sender: "joel.stan@gmail.com" <joel.stan@gmail.com>
From:   Joel Stanley <joel@jms.id.au>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Dylan Hung <dylan_hung@aspeedtech.com>, netdev@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH] ftgmac100: Restart MAC HW once
Date:   Fri, 12 Mar 2021 11:04:05 +1030
Message-Id: <20210312003405.439923-1-joel@jms.id.au>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dylan Hung <dylan_hung@aspeedtech.com>

The interrupt handler may set the flag to reset the mac in the future,
but that flag is not cleared once the reset has occurred.

Fixes: 10cbd6407609 ("ftgmac100: Rework NAPI & interrupts handling")
Signed-off-by: Dylan Hung <dylan_hung@aspeedtech.com>
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reviewed-by: Joel Stanley <joel@jms.id.au>
Signed-off-by: Joel Stanley <joel@jms.id.au>
---
 drivers/net/ethernet/faraday/ftgmac100.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/faraday/ftgmac100.c b/drivers/net/ethernet/faraday/ftgmac100.c
index 88bfe2107938..04421aec2dfd 100644
--- a/drivers/net/ethernet/faraday/ftgmac100.c
+++ b/drivers/net/ethernet/faraday/ftgmac100.c
@@ -1337,6 +1337,7 @@ static int ftgmac100_poll(struct napi_struct *napi, int budget)
 	 */
 	if (unlikely(priv->need_mac_restart)) {
 		ftgmac100_start_hw(priv);
+		priv->need_mac_restart = false;
 
 		/* Re-enable "bad" interrupts */
 		iowrite32(FTGMAC100_INT_BAD,
-- 
2.30.1

