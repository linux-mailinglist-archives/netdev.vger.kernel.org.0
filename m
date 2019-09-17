Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F899B5837
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 00:47:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728235AbfIQWr2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 18:47:28 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:40309 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727011AbfIQWr1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Sep 2019 18:47:27 -0400
Received: by mail-io1-f65.google.com with SMTP id h144so11555632iof.7;
        Tue, 17 Sep 2019 15:47:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=5VqlgmEcpDNl3x/hruHj+kY7JbEaNQvrbJRA/5fQs/E=;
        b=SH7v1obY8TSWmiqpJkDPSLoUDZaN8KB1U7FuZ3C7BoG9V73ytTD1e5J3TX/EYvjTa+
         gFaQxzstHpK2DzA/lN/L1+M8c8bjyDNVLUKfC8GMO51r49kXCuckpJOOvW5f0hw7fEIZ
         RFELv/7kR0jXb5w2sH9v+AlqDmbnvkOMfd1D3fdIiWLUbVHNfLmQaNBI8JRiZrbnpPrD
         a80xNSDVon+UpKY7wQO1wbaZD7qESJZmVOfFld+hRaXBu6ot/Ms2YERsvPtun1WugM+K
         a0FBfDwhYuQO6ipb2VuA5O3tVz9ux0EG/tvLvUAcpIPV0/4Nm4msaDO1HfhNFKBlhooy
         qqMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=5VqlgmEcpDNl3x/hruHj+kY7JbEaNQvrbJRA/5fQs/E=;
        b=bhZPBQ0YURdscVNY6LiE2xPsjgqfZx+mn3gxSCLjkin0ZroD+qWeD018aW+mmCAUcC
         ZI9uZGEcn0rfs90w9G6TeerDkUQCvVjUmNscfga8Lmvyh2EdqsvD5DHyu4iH9YxnX4HL
         Pdwe7g5iL9R0D8it/sg14LGaUL7p2/NnNeFzT/Mlcw2yYrsKDhrdeJacpBSOeUq3zXhH
         uvc/IS+koyoj3AKZLlpodPwz4QFk78vu5OZaZswvdUloVwwdpZi9P4Mx/0Z0OnCcjQJ4
         NhgxA8wDNIrcVo7hfEILBZavkBod4BqeKH1mdK+FWRVwydpZmTG40yyTToAPoQI+C4+s
         N1wA==
X-Gm-Message-State: APjAAAW4R1QnBsd5yETMZ7yi1djt4yX22pJvSHmzMXMncfw42U1u9r3K
        0duScv6+bg1QODbFmpF3qEw=
X-Google-Smtp-Source: APXvYqwbItfkQfOpXkoUPdAzexGLX/v678OXhG99WTPyfexi7c41btMn7SPpVuj7QJ8qK1yuACv7cw==
X-Received: by 2002:a05:6638:681:: with SMTP id i1mr1248426jab.127.1568760446971;
        Tue, 17 Sep 2019 15:47:26 -0700 (PDT)
Received: from cs-dulles.cs.umn.edu (cs-dulles.cs.umn.edu. [128.101.35.54])
        by smtp.googlemail.com with ESMTPSA id m9sm1533647ion.65.2019.09.17.15.47.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Sep 2019 15:47:26 -0700 (PDT)
From:   Navid Emamdoost <navid.emamdoost@gmail.com>
Cc:     emamd001@umn.edu, smccaman@umn.edu, kjlu@umn.edu,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Harry Morris <h.morris@cascoda.com>,
        Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ieee802154: ca8210: prevent memory leak
Date:   Tue, 17 Sep 2019 17:47:12 -0500
Message-Id: <20190917224713.26371-1-navid.emamdoost@gmail.com>
X-Mailer: git-send-email 2.17.1
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In ca8210_probe the allocated pdata needs to be assigned to
spi_device->dev.platform_data before calling ca8210_get_platform_data. 
Othrwise when ca8210_get_platform_data fails pdata cannot be released.

Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
---
 drivers/net/ieee802154/ca8210.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ieee802154/ca8210.c b/drivers/net/ieee802154/ca8210.c
index b188fce3f641..229d70a897ca 100644
--- a/drivers/net/ieee802154/ca8210.c
+++ b/drivers/net/ieee802154/ca8210.c
@@ -3152,12 +3152,12 @@ static int ca8210_probe(struct spi_device *spi_device)
 		goto error;
 	}
 
+	priv->spi->dev.platform_data = pdata;
 	ret = ca8210_get_platform_data(priv->spi, pdata);
 	if (ret) {
 		dev_crit(&spi_device->dev, "ca8210_get_platform_data failed\n");
 		goto error;
 	}
-	priv->spi->dev.platform_data = pdata;
 
 	ret = ca8210_dev_com_init(priv);
 	if (ret) {
-- 
2.17.1

