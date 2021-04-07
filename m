Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CC89357863
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 01:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbhDGXU3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 19:20:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbhDGXU0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 19:20:26 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78617C061760
        for <netdev@vger.kernel.org>; Wed,  7 Apr 2021 16:20:15 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id q6-20020a17090a4306b02900c42a012202so302297pjg.5
        for <netdev@vger.kernel.org>; Wed, 07 Apr 2021 16:20:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ZaJ/MDzWKqGaXCPj2y4btco5CAAlwR9jCavNfe6fR7w=;
        b=X2ZZbO2eo2TFbBmj8YXW1z8jcN8JA1Op6/nM1OE5gdNVWbuH+rGDqzVeGqJuxWkw6/
         OyZBHpfPTOlybB/q0lyOCuzjPh8Wgvm6SAuflpywAIqFKso4JTXLh0ok6YzH3NbhYNDi
         q+lhAo7XQase4OmWcGemB97BPuG0pfjPQ+yDEwTyqbde1i9DmN6G7wmyCmfrPfYwkqok
         Tb4UfvCZB16+ROrlVTvf+5uPfmOzJxfnVuehcEhnXFH+giIywNIE/pEt5uyiXCrFsFQt
         kkyaWr5/q9wmGdzn39Hdez7X4/so0TJ8fgPUKsgjCz9omjjpz2tZAIpbQ/HUk0CHY/v3
         sMPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ZaJ/MDzWKqGaXCPj2y4btco5CAAlwR9jCavNfe6fR7w=;
        b=JVtyJaUSiLYYINcIXDcf/MpzayxuzSxOCL0LRcMZ/GiUP/0nKMLfHTBbjFVGUvtOKj
         ekNQ5fiMe/Sg9vKONIBH5lOMDRIY0t3fs5iu8p1WJDGh+m65TdAm0exS0G+TwzACv+1N
         b6pBXww48NxpXr+ujC/lSWkYGhMseRy/nR2Pq1wduQK/dD7Nfl+cyA7XQwJZghQh2wB3
         FFoHMp+lSS3hD5SJ1gMMpbf+sHS+amgI9D+AA/gaH4L3fQa7/TBBnTzxLkLf5kvvimq4
         3fix/xBj6+OpwC1ick2wotBa76hc8k3q6wRlOM+MAXW8tSTxkJNCtEJpcd1ZWowZWMJJ
         I52Q==
X-Gm-Message-State: AOAM530kpfMYbt/1o04c/koRPI3/CjTYWxTjV3W4KbF9JnUEgWv8946q
        WgdjS8k9udmls97CkqIxGgrEnWsPu7+Shw==
X-Google-Smtp-Source: ABdhPJzAmZqGq1xtHg7GCPN03kjmyIpEIV7dCKkYfhEILbgHBZzRPD/l4JVdLNXW/zlnjoown2aJqw==
X-Received: by 2002:a17:90b:1998:: with SMTP id mv24mr2645283pjb.67.1617837614777;
        Wed, 07 Apr 2021 16:20:14 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id g3sm21422171pfk.186.2021.04.07.16.20.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Apr 2021 16:20:14 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        richardcochran@gmail.com
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 3/8] ionic: check for valid tx_mode on SKBTX_HW_TSTAMP xmit
Date:   Wed,  7 Apr 2021 16:19:56 -0700
Message-Id: <20210407232001.16670-4-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210407232001.16670-1-snelson@pensando.io>
References: <20210407232001.16670-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make sure the device is in a Tx offload mode before calling the
hwstamp offload xmit.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_txrx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
index 3478b0f2495f..765050a5f7a8 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
@@ -1233,7 +1233,7 @@ netdev_tx_t ionic_start_xmit(struct sk_buff *skb, struct net_device *netdev)
 	}
 
 	if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP))
-		if (lif->hwstamp_txq)
+		if (lif->hwstamp_txq && lif->phc->ts_config_tx_mode)
 			return ionic_start_hwstamp_xmit(skb, netdev);
 
 	if (unlikely(queue_index >= lif->nxqs))
-- 
2.17.1

