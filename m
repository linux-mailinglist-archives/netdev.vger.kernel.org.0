Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB1DC25351B
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 18:42:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728048AbgHZQmg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 12:42:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727980AbgHZQmX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 12:42:23 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C13C6C061574
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 09:42:23 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id m8so1271525pfh.3
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 09:42:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=b95V2uQSQxoMk2ke897SOwfl3yK+HzDEOhz3RteTQpg=;
        b=4zHDf6sbD8Q29J4tUVwa7NOuEiLUTkv4yBZZc1L+TB5D9BzdIfygR8GjuJJde5THLo
         OqPHkUenOk9+Q0wvqv+W1O6tYG3RzEgv9jL9F8ozylPS5VUoVtWtjqkdLPR9f0qqfe+t
         MInPanjtixBh+1wnrdICEi2Lo2o9fKz11ZTBkpDvwG19wPLnaM1Sbue/FSy5SFU0F4mW
         jKCwoEjWm6bwyauwicBynpXLBqOAAR2D/3EPVglR0ioxbjWonoOcuy6IqSmH0u2NTq6t
         JZl8GVpB47pUs/d8UvL2XnXn+ur6YL02MLSevgX9wXTYe6LO/fX1yghjeknRWKJur7Ja
         p4Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=b95V2uQSQxoMk2ke897SOwfl3yK+HzDEOhz3RteTQpg=;
        b=VruSxxpu5BxiuXox4K8AXD2vvWS7EUW6K5qFXIHd3L8rBHtFrIsQYFD6YVkOIqq5Q3
         Vv+pF7mvupxCCfZnloBteupG9o1Jmrh32Jmwmr2leSfgv42gs0BQYzUfucV4k03O3XHC
         UZaKFC02RZ5rCWk/MS+J+lJWA8hFThfjoyT5ODfhCEWthxdNiXFHYYGquz2i1nfD6vSQ
         81Lk6y/Gf78tdilABBwIW19HOoac9B9PCYsAJZzHcEIfY+DDn2MDb9mrvXzK/8+S5SW4
         BocEQg+NEqTOes7+Cw+AeChq4cqjs60Nvo/b3T5yqT+mWiw4Y1L5TxBfWeMKTeQawmbq
         wQ6Q==
X-Gm-Message-State: AOAM531Yi0Pe18AznbNamz8gVQsbVjC0q1aaRwYDf+tPkvnsQQ75Wjur
        /VMXcBPzLMcM5P12W84HWiynnqFtKCsc2Q==
X-Google-Smtp-Source: ABdhPJycxjzNXbZcMRxdDjpjkYzbJxMMgjB6K1RVg6FMM56LtSuXEG2D9h+Qi+xFikQP/bYnCPJ0Dw==
X-Received: by 2002:a62:53c2:: with SMTP id h185mr12773164pfb.53.1598460143045;
        Wed, 26 Aug 2020 09:42:23 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id h193sm2986052pgc.42.2020.08.26.09.42.22
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Aug 2020 09:42:22 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 01/12] ionic: set MTU floor at ETH_MIN_MTU
Date:   Wed, 26 Aug 2020 09:42:03 -0700
Message-Id: <20200826164214.31792-2-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200826164214.31792-1-snelson@pensando.io>
References: <20200826164214.31792-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The NIC might tell us its minimum MTU, but let's be sure not
to use something smaller than ETH_MIN_MTU.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 26988ad7ec97..235215c28f29 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -2079,7 +2079,8 @@ static struct ionic_lif *ionic_lif_alloc(struct ionic *ionic, unsigned int index
 	lif->identity = lid;
 	lif->lif_type = IONIC_LIF_TYPE_CLASSIC;
 	ionic_lif_identify(ionic, lif->lif_type, lif->identity);
-	lif->netdev->min_mtu = le32_to_cpu(lif->identity->eth.min_frame_size);
+	lif->netdev->min_mtu = max_t(unsigned int, ETH_MIN_MTU,
+				     le32_to_cpu(lif->identity->eth.min_frame_size));
 	lif->netdev->max_mtu =
 		le32_to_cpu(lif->identity->eth.max_frame_size) - ETH_HLEN - VLAN_HLEN;
 
-- 
2.17.1

