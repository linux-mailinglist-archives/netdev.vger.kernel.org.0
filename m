Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1AB01B1CCC
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 05:28:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728249AbgDUD16 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 23:27:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726628AbgDUD14 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 23:27:56 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29AF8C061A0E;
        Mon, 20 Apr 2020 20:27:56 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id a2so9838573ejx.5;
        Mon, 20 Apr 2020 20:27:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=BqEXAPPk1jy4+zZW3X0pD4iZxuCMYKcirx3g/O09ZGA=;
        b=UIr+qPQDabB1+J4STjMBX52rkOaYT1tWZnxetfPo7SMjATGAP1gHaPhLQDzYULeONn
         UKFK7E9m8Cz3wu87KdeHDfcijC27Fcc6Sena+bXltdbEYkccpNSjicyuQXOFyZN0mNT+
         BUTg7zIX3IELDaPcqQ/DaJfpROwDygtmiNo2kzJAa4y+5wajwZ19+CIkN2Tl6GsOfP5B
         zpKYRRANd55Fwiz54CH1YJKdopWeecJJOyVeo7d9/Re+aDfpwPXfAQLxisJ842kvwu5K
         Gs66DHjcg65tF9CEtn2QqGuIQijdZqhfuZ1Kdtk/LO/kSqSLEeJMA4I6yFV4Khv8i4jl
         RU3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=BqEXAPPk1jy4+zZW3X0pD4iZxuCMYKcirx3g/O09ZGA=;
        b=Vu+rOj5gkRlHIcIV0EAd8I/krTNveuPIXPPZaqp7szXQjkhbHvzYWL7tUsN8iiFVwV
         WguPTPS2sQzvJTtiqe7BLBUyNXuE4AX0HYl6aPoQYUTLxqJJgAU9XHLzG2w7WRqKeufk
         /ubsMIwAKYkWUP7cFsJxWXbXOOSGi8sAPTkBdHdoS2FRHqwrY7kxpA+10VycDnFe0qjj
         D7uO6xkdTK0u3EtR3ukMaBsWTuxHWxRPuWXFEmh7ljz3rgTWySEpASCJy1DxP+MDWd7K
         iZba5ANdGG4PdUrWuqkzigzBu1C45YSrpG0iPYumdTPOEDD4hGUdVq06nAOGZ3fcDIf0
         0a9g==
X-Gm-Message-State: AGi0Pub4osNq6WS+lFkm7K4AIUvcjp30lQQZXClrVQcJAdZ/7lvQavxf
        3WnAB548xOrmciyOH8GOOi+8Fjgs
X-Google-Smtp-Source: APiQypJTI8Ov82C5pBaGnh5uXDlyuyjEW+nFA9etX8P9txz7/Rgr8x9ld5fRfonqnFAdl/gscmidVg==
X-Received: by 2002:a17:906:18a1:: with SMTP id c1mr18500775ejf.344.1587439674615;
        Mon, 20 Apr 2020 20:27:54 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j9sm216836edl.67.2020.04.20.20.27.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2020 20:27:54 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        linux-kernel@vger.kernel.org (open list), davem@davemloft.net,
        kuba@kernel.org
Subject: [PATCH net v2 2/5] net: dsa: b53: Fix valid setting for MDB entries
Date:   Mon, 20 Apr 2020 20:26:52 -0700
Message-Id: <20200421032655.5537-3-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200421032655.5537-1-f.fainelli@gmail.com>
References: <20200421032655.5537-1-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When support for the MDB entries was added, the valid bit was correctly
changed to be assigned depending on the remaining port bitmask, that is,
if there were no more ports added to the entry's port bitmask, the entry
now becomes invalid. There was another assignment a few lines below that
would override this which would invalidate entries even when there were
still multiple ports left in the MDB entry.

Fixes: 5d65b64a3d97 ("net: dsa: b53: Add support for MDB")
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/b53/b53_common.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index fa9b9aca7b56..e937bf365490 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1561,7 +1561,6 @@ static int b53_arl_op(struct b53_device *dev, int op, int port,
 		ent.is_valid = !!(ent.port);
 	}
 
-	ent.is_valid = is_valid;
 	ent.vid = vid;
 	ent.is_static = true;
 	ent.is_age = false;
-- 
2.17.1

