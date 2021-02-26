Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9343532633B
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 14:22:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbhBZNVf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 08:21:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbhBZNVe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 08:21:34 -0500
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B56AEC06174A
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 05:20:53 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id z11so13741920lfb.9
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 05:20:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NREg3gILyLrpsyMQMWOrmQAbb3M8wDVuhh9EAPyW4KU=;
        b=WmYLLsKdJpKlOUBYlelDDnAWZUkkBWf7XidbfIirHfT8IEveN0cB4m2VGf8oxA8dJZ
         uSWLzz/0SKK3H3JaDIt5Wh+Haaf5zJyS36gp/AlnYDO3zgoprhGzdzDelMrmWxaGEJPd
         tYrOKgkmynuMeDCfSYGNTTYwag9EzK4MvK/9u9JU1CMeOJMwFONQV6alcbzSfeyNShAg
         YcQYMpRvmhVgfSbjESQTPf5jtmIM5BripJgHxv4NNAmgHszP9glnCe4p4kN1HyhoZS9W
         aOqL0WeAv0CFBG8c4qkG3HEcCBbsgFU65KBqVvB8wMDDev1Ol5AuanY61RpVMVlranTl
         JP9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NREg3gILyLrpsyMQMWOrmQAbb3M8wDVuhh9EAPyW4KU=;
        b=laE+bpg2HRZlFuFjXfAMYEc9GIHHVsGqCJ65SyX/yMf19vrMj/1NX+uy6lg33wau+G
         IquuE3U0iggeIBRMi9PP3h4C0LjZ38unlJqA65Ai3s+aeo+/1RErNFEd/gPFamMQbmFs
         wGBQhSw4ZzdjIz5AFeUzb0aVVDEZgMv2Kp4P9VjxsSK6OT/XrGo9894pHnRK/8fQaXX0
         /nmLduWpMAtxWjYFLc3tcHXRsO17qXy0R3xnnLfGfmMwbwTSJjuvUs2lMZotAQbkOrRZ
         xENDVdVcpOnhJW936v+CTe4tJUIsLj1YNfLMU9xwY7J6sy32kndqvsWx8651aJbXXhTZ
         EwFg==
X-Gm-Message-State: AOAM5305EGQaE65/vikDg9uXuMMfz40ezdYzgaElxNJBG725I43HCARb
        G1Ngai0onHGRmiNfTlkXwjc=
X-Google-Smtp-Source: ABdhPJzh473N2cMbzraU6K0hGmAWnGpFclxj9BKH3J8EZcCqpet6QbqjQ+K6J0PREUWitM9wJQyo0g==
X-Received: by 2002:a05:6512:31d3:: with SMTP id j19mr1786527lfe.495.1614345652264;
        Fri, 26 Feb 2021 05:20:52 -0800 (PST)
Received: from localhost.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id h24sm359471lji.35.2021.02.26.05.20.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Feb 2021 05:20:51 -0800 (PST)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH net] net: broadcom: bcm4908_enet: enable RX after processing packets
Date:   Fri, 26 Feb 2021 14:20:38 +0100
Message-Id: <20210226132038.29849-1-zajec5@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

When receiving a lot of packets hardware may run out of free
descriptiors and stop RX ring. Enable it every time after handling
received packets.

Fixes: 4feffeadbcb2 ("net: broadcom: bcm4908enet: add BCM4908 controller driver")
Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 drivers/net/ethernet/broadcom/bcm4908_enet.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bcm4908_enet.c b/drivers/net/ethernet/broadcom/bcm4908_enet.c
index 0b70e9e0ddad..98cf82dea3e4 100644
--- a/drivers/net/ethernet/broadcom/bcm4908_enet.c
+++ b/drivers/net/ethernet/broadcom/bcm4908_enet.c
@@ -592,6 +592,9 @@ static int bcm4908_enet_poll(struct napi_struct *napi, int weight)
 		bcm4908_enet_intrs_on(enet);
 	}
 
+	/* Hardware could disable ring if it run out of descriptors */
+	bcm4908_enet_dma_rx_ring_enable(enet, &enet->rx_ring);
+
 	return handled;
 }
 
-- 
2.26.2

