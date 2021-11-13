Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C95844F454
	for <lists+netdev@lfdr.de>; Sat, 13 Nov 2021 18:20:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235849AbhKMRXJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Nov 2021 12:23:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235762AbhKMRXJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Nov 2021 12:23:09 -0500
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CBA1C061766;
        Sat, 13 Nov 2021 09:20:16 -0800 (PST)
Received: by mail-lj1-x231.google.com with SMTP id i63so25260864lji.3;
        Sat, 13 Nov 2021 09:20:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WNFzHLHqOcYwmclGfKEfsHkU2uoJX/3AP6GHSxwEVks=;
        b=X2Kz6tEB5RBi+JM569YM4+JRM4AVOfx2umGJdmYreM/J5JsdNvhN1w1MVbpEsn2EYb
         hY43cGtVYKsE9SmBbhPDLIUHAjQLAYzaR4lpPqT5KEVvUg28XlGczYaCm5/h1YYPA/9L
         j42rAKjgXqnkzdX+gyU2pSlesqWceQ56FMzOlvpK735Q555sfDD+S3VymYv+YuPG9ybG
         4NEHy6+WJRAEgd46yltkTLynGk4eNf3n455c65kanXcu3PsQcZJPaRhtbqWKM/g4r01e
         gjkEluMch8Bjg0UU63pPBOWwwPlPLa7SDxvUSHnOcLRjlfT2RuDf81cSxnZ+BOuwsZqp
         RyIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WNFzHLHqOcYwmclGfKEfsHkU2uoJX/3AP6GHSxwEVks=;
        b=QLoHdBh0KM/V6DkgVPjKWqm4Ff/WsM8OacT4z2aVMX3evIv6N1zedHY/bYl4ZlzBAO
         xCsQsihJ29d1+c7CNX0Yb+OsC9jTsYt9ocyNxusX+winQ3EzHM2ZSpoTwL6/79rvccQj
         /H/QSkLUXr5qERStmKR5ACYhmX4MIQHSloqNrkmK4rRRwT2uk59RSPH0HOmFn/HD/IAQ
         S3Og6wOzu34epB2MAloT2DeFrGX9izcq7/ZRiZTt1sFPfjJZk0ehUj3fUcJge5Xh9HuZ
         PeziF+XFRKRQu5tqjnWdLU2j+QQ2ZyAA5IR+wT8kxVVD4GAYSnlND7KVOYmGF9MUhqe5
         Lw0w==
X-Gm-Message-State: AOAM530kCeTlKFUwaQS88LIqP9DGwTd5ebME7TpHSnyUWbbSFLQtJnrk
        H8m4BHd49wkeODbNiAwPTks=
X-Google-Smtp-Source: ABdhPJyRu2pvsDQSnaCkzJ93ktRFKQxNuzG1dIY4Z3WZStOaVuetD+5AY++UgFMZshP+ri7CPongQg==
X-Received: by 2002:a2e:b013:: with SMTP id y19mr24230385ljk.132.1636824014893;
        Sat, 13 Nov 2021 09:20:14 -0800 (PST)
Received: from localhost.localdomain ([94.103.224.112])
        by smtp.gmail.com with ESMTPSA id n14sm894579lji.28.2021.11.13.09.20.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Nov 2021 09:20:14 -0800 (PST)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     ioana.ciornei@nxp.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Pavel Skripkin <paskripkin@gmail.com>, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH] net: dpaa2-eth: fix use-after-free in dpaa2_eth_remove
Date:   Sat, 13 Nov 2021 20:20:13 +0300
Message-Id: <20211113172013.19959-1-paskripkin@gmail.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Access to netdev after free_netdev() will cause use-after-free bug.
Move debug log before free_netdev() call to avoid it.

Cc: stable@vger.kernel.org # v4.19+
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---

Note about Fixes: tag. The commit introduced it was before this driver
was moved out from staging. I guess, Fixes tag cannot be used here.
Please, let me know if I am wrong.

Cc: Dan Carpenter <dan.carpenter@oracle.com>

@Dan, is there a smatch checker for straigthforward use after free bugs?
Like acessing pointer after free was called? I think, adding
free_netdev() to check list might be good idea

I've skimmed througth smatch source and didn't find one, so can you,
please, point out to it if it exists.



With regards,
Pavel Skripkin

---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index e0c3c58e2ac7..abd833d94eb3 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -4540,10 +4540,10 @@ static int dpaa2_eth_remove(struct fsl_mc_device *ls_dev)
 
 	fsl_mc_portal_free(priv->mc_io);
 
-	free_netdev(net_dev);
-
 	dev_dbg(net_dev->dev.parent, "Removed interface %s\n", net_dev->name);
 
+	free_netdev(net_dev);
+
 	return 0;
 }
 
-- 
2.33.1

