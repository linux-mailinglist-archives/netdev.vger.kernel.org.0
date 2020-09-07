Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2B29260727
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 01:26:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727792AbgIGX0H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 19:26:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726929AbgIGX0G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 19:26:06 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 609E3C061573
        for <netdev@vger.kernel.org>; Mon,  7 Sep 2020 16:26:03 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id c10so14079233edk.6
        for <netdev@vger.kernel.org>; Mon, 07 Sep 2020 16:26:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qOe9Z+eIzPeBSRDTKJc25mcni3JXKr4Z82tTC9XnlDk=;
        b=A4OkkcGj0fBZu5RMF7s8+CndPjYjVGqln4KOvxj7gyNCeQt79B94LDFavprWw89diX
         lNmChXNNzBvBdkHP6uo95pwhbh4P6AR8sd9T1+kbxE9vsKSFwWlJICUGePCNYOJ8T47f
         MAvrrd47tGe9ZorKNwbF7DTtxSP223YpkjdW5vQW8ZxQcItBn6TGGrWy1OC+G26E8Qp0
         Qz7g5gKEW0d/LgO7YbL9cXCyekdEOTAzis5Q0fX5zSTgrtxlWTLC5syTqeDDYgJ2CG5D
         yfOYeCS7qpfdKUixZ6jv/IBWzMuyAnHKdv3AMYEyb61o++jqvDZo4UgUoofr31HfRYBp
         ssjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qOe9Z+eIzPeBSRDTKJc25mcni3JXKr4Z82tTC9XnlDk=;
        b=ILVskgKIb63qkGyP280dJgBMHloMe/Mwchre0M2yjNGWT7G5YUAEI9dkqK/l81RsMl
         xhPdJAAYoVS3379tGNoUtePMbT7pw/V+zrR2u67o5NrZ774yz3fnUCSoTk/AFJ7fX8Fi
         Aa4hwU+vazAgAPXesJvEUgaCCxhLUhTnp+bqPiAIc70u+L1OHW9+QjUhVQ0NzndU57S5
         WDU/L2v7WRWoMKrJNUBUlr/Z01McmmFVOy+GyIl/ExcwWbW2frJ31dXt/53yKAdi2cBB
         tc10A7jRGGpAu7QbwLybvYeWa/M1MCtuZ33DhKbhtkaYIySO5elxyC7eVaBWtvre/iAY
         NLRw==
X-Gm-Message-State: AOAM531OBdtt7DyrFoUODUeMRaxtM6usdpMeIjWLk03A4h47Ys0k0N4g
        pkuVl64eJzay4dbLSqfkpR8=
X-Google-Smtp-Source: ABdhPJzbsDtGfWnboSPzxTsneYWKrkADp+HI3UJYtV3dC0nAa3630/wXbdBCmpwtRLsJwaka3/n7Uw==
X-Received: by 2002:a50:ccd2:: with SMTP id b18mr23851948edj.51.1599521162186;
        Mon, 07 Sep 2020 16:26:02 -0700 (PDT)
Received: from localhost.localdomain ([188.25.217.212])
        by smtp.gmail.com with ESMTPSA id a18sm16499273ejy.71.2020.09.07.16.26.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2020 16:26:01 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     kuba@kernel.org
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        netdev@vger.kernel.org
Subject: [PATCH net-next] net: dsa: don't print non-fatal MTU error if not supported
Date:   Tue,  8 Sep 2020 02:25:56 +0300
Message-Id: <20200907232556.1671828-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 72579e14a1d3 ("net: dsa: don't fail to probe if we couldn't set
the MTU") changed, for some reason, the "err && err != -EOPNOTSUPP"
check into a simple "err". This causes the MTU warning to be printed
even for drivers that don't have the MTU operations implemented.
Fix that.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 net/dsa/slave.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 27931141d30f..4987f94a8f52 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1784,7 +1784,7 @@ int dsa_slave_create(struct dsa_port *port)
 	rtnl_lock();
 	ret = dsa_slave_change_mtu(slave_dev, ETH_DATA_LEN);
 	rtnl_unlock();
-	if (ret)
+	if (ret && ret != -EOPNOTSUPP)
 		dev_warn(ds->dev, "nonfatal error %d setting MTU on port %d\n",
 			 ret, port->index);
 
-- 
2.25.1

