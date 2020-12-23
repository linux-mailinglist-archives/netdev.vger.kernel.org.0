Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 216382E18A4
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 06:56:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727554AbgLWF4J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 00:56:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727373AbgLWF4I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Dec 2020 00:56:08 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A995C0613D6
        for <netdev@vger.kernel.org>; Tue, 22 Dec 2020 21:55:28 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id c22so9906741pgg.13
        for <netdev@vger.kernel.org>; Tue, 22 Dec 2020 21:55:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=luZFFagd87vDIlnKDKZn89F7j3Vyv8O6SeaQb577baY=;
        b=DjAbJLLcDIf5eydQfRUEtGL4NrNMYD6ew6cWB/NkrRhSROFfr9cgZDODRriJoa0u9i
         z730UgZzt9X6g3xhOKfqjW9s1HUY3HU/lYREOoT4wIvt03oJploSmR43Y32jpab8ZXWg
         0w0EvhPbTk1s7ivYjGV3wUKnyUz13KXUQ6W5gJHLj57T/ghnAlA4A4UoZO7i9EHnhkIP
         k7PdvD03mtSzB8necuZ1t1R4C2bOODb3NQIG0EfUZRdlfq+K5fjVYZtMs4FP77/JnE+j
         oiQleGpUPZE9nnQdv6zt1Mcbp3Gozls50qkZadhb+NCg88528EcCITGFfan3BZ0ZGCor
         /jng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=luZFFagd87vDIlnKDKZn89F7j3Vyv8O6SeaQb577baY=;
        b=KOaH3UK6yeEm7tLFf+twvxM02ozhOwywNtBIxtXU8XIudWlXFL920UwxP8sfqc04YL
         9szXb0kWJd+XyvrynL94oBsvpPIC8LbVlkySihlqokFrVcAE1YZqHJrcU51cajjgEi8q
         CO1ExkTW/1mrvi+hss4+20Y8lW3cOY3ec64buXcDz9RKJhVJ/D7eSX4K7/AiR9UEJWgQ
         4Ydp1paTPjjAOMtHIzwUNDoS3sFrGgV4DfeMpiEqvP/Mjd6f5pswy8iAJkD4J3ELgG4z
         6wW47U3iz4kmH2qxhR02vA8uUT6keMoww+SHjM9AsL0QKAE/bUmoNFYuOnuObB/B9xS8
         sApQ==
X-Gm-Message-State: AOAM531/sQrjhnWeHOQY7fCeEVf1+Jo2J5Ith1F3Q9TU5pw/R0QHUVtG
        UiFyVgglcf/eu3dw69wepLp+jA==
X-Google-Smtp-Source: ABdhPJwd+SJvLoKr81bJQE3UHfFGwhLCqBn9EnA7MyPUR7TcXqmnJ1SMYeVUrBbd7iQcnxx5+UaCsw==
X-Received: by 2002:a62:303:0:b029:1a5:a6f7:ac0d with SMTP id 3-20020a6203030000b02901a5a6f7ac0dmr23111393pfd.63.1608702928015;
        Tue, 22 Dec 2020 21:55:28 -0800 (PST)
Received: from localhost ([61.120.150.75])
        by smtp.gmail.com with ESMTPSA id a31sm22979810pgb.93.2020.12.22.21.55.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Dec 2020 21:55:27 -0800 (PST)
From:   John Wang <wangzhiqiang.bj@bytedance.com>
To:     xuxiaohan@bytedance.com, yulei.sh@bytedance.com,
        chenbo.gil@bytedance.com, joel@jms.id.au
Cc:     Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Gavin Shan <gwshan@linux.vnet.ibm.com>,
        netdev@vger.kernel.org (open list:NETWORKING [GENERAL]),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2] net/ncsi: Use real net-device for response handler
Date:   Wed, 23 Dec 2020 13:55:23 +0800
Message-Id: <20201223055523.2069-1-wangzhiqiang.bj@bytedance.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When aggregating ncsi interfaces and dedicated interfaces to bond
interfaces, the ncsi response handler will use the wrong net device to
find ncsi_dev, so that the ncsi interface will not work properly.
Here, we use the original net device to fix it.

Fixes: 138635cc27c9 ("net/ncsi: NCSI response packet handler")
Signed-off-by: John Wang <wangzhiqiang.bj@bytedance.com>
---
v2:
  Use orig_dev instead of pt->dev
---
 net/ncsi/ncsi-rsp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ncsi/ncsi-rsp.c b/net/ncsi/ncsi-rsp.c
index a94bb59793f0..e1c6bb4ab98f 100644
--- a/net/ncsi/ncsi-rsp.c
+++ b/net/ncsi/ncsi-rsp.c
@@ -1120,7 +1120,7 @@ int ncsi_rcv_rsp(struct sk_buff *skb, struct net_device *dev,
 	int payload, i, ret;
 
 	/* Find the NCSI device */
-	nd = ncsi_find_dev(dev);
+	nd = ncsi_find_dev(orig_dev);
 	ndp = nd ? TO_NCSI_DEV_PRIV(nd) : NULL;
 	if (!ndp)
 		return -ENODEV;
-- 
2.25.1

