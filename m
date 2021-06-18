Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69D943AD027
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 18:14:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235405AbhFRQQw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 12:16:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235429AbhFRQQq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 12:16:46 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAF0AC061760;
        Fri, 18 Jun 2021 09:14:35 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id j2so17559551lfg.9;
        Fri, 18 Jun 2021 09:14:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iCNibqVduxNAGNvNvSGxKnoXkViyWCeY8Yq5EDWpyBo=;
        b=MNcVghv8BjiS2ohbcW8P99fw9nhuAv1NUOyyqKLz0cICZVwHPc4iCXO7x0GEBZvbbT
         fo/pGytutKhto+A11baqvyBa3LgnB+MK0Yl4ogyLoWQ5xgN9A22Un0fg1mYicz1txphA
         6AR5oRl248U5IkPEOHeknPg0GV2dlX0Bx3Jgir+vy7+KJ+CBOlwQ82G6jfu6pdll+uJu
         k5c28vlyiPtZbuPJtaT/dWrmk7IDxIQGigGmbKiQ+aDhFHw3PrIuolUFPY6mN0+HEKdu
         nPDkCTiNTSMiIGgTpwTLXkw2uyuSo+J1OU6PSKO9PlGBEGLSFja1OKrJwTog9MyO2C3A
         VRFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iCNibqVduxNAGNvNvSGxKnoXkViyWCeY8Yq5EDWpyBo=;
        b=aUgRWyFRfpsf2ypG2zR21fL5lSDwJoj31WIpAVrQO8Ogn4dIF0YDEe3RILuAYI82M4
         g/9WA0xcCAL299b94k4/7xto+Jysb4r7Wh2h89Y5rpJzxe+6dWOEY4CCAXshk6mRD/3E
         Y6OE/Fax61DeNQTcI5K7yXBPidnliWKFdAUQjqkng8OEyaPiXxl1xLqA9HOrND1IEsjN
         jUiTCHuFHMA+F7l4asL/SeDrmgt370o3Y9Tk4keCrkWV0n4SAJ7Rf5W9iPb7oTkG1LC0
         zXWQhiFx4tS26q07hZeQNAD/a6G6EDguwdIpY7fU3WIDdC1kuibijCvTbA6PkXyGC8ik
         KZ4A==
X-Gm-Message-State: AOAM531zjiHksehrYe4eB6rfrxEiwLK+i6jWXrXEwtaTtxTQoLPVx3gu
        zWP75IsTCCFJKNSQ0/Omff4=
X-Google-Smtp-Source: ABdhPJwC9F7gO/yzdkBKWZXY3kEnos4KgIUY50ScQMqfTt5fgU7x6U7le62lri07CPV+9gLDkKgjBw==
X-Received: by 2002:a05:6512:1184:: with SMTP id g4mr3678397lfr.567.1624032874041;
        Fri, 18 Jun 2021 09:14:34 -0700 (PDT)
Received: from localhost.localdomain ([94.103.229.24])
        by smtp.gmail.com with ESMTPSA id z16sm951813lfs.24.2021.06.18.09.14.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jun 2021 09:14:33 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        michael@walle.cc, abrodkin@synopsys.com, talz@ezchip.com,
        noamc@ezchip.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Pavel Skripkin <paskripkin@gmail.com>
Subject: [PATCH 1/3] net: ethernet: ezchip: fix UAF in nps_enet_remove
Date:   Fri, 18 Jun 2021 19:14:31 +0300
Message-Id: <b04b3823c002aac127c16472b150466afe9b38a9.1624032669.git.paskripkin@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1624032669.git.paskripkin@gmail.com>
References: <cover.1624032669.git.paskripkin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

priv is netdev private data, but it is used
after free_netdev(). It can cause use-after-free when accessing priv
pointer. So, fix it by moving free_netdev() after netif_napi_del()
call.

Fixes: 0dd077093636 ("NET: Add ezchip ethernet driver")
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---
 drivers/net/ethernet/ezchip/nps_enet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ezchip/nps_enet.c b/drivers/net/ethernet/ezchip/nps_enet.c
index e3954d8835e7..20d2c2bb26e4 100644
--- a/drivers/net/ethernet/ezchip/nps_enet.c
+++ b/drivers/net/ethernet/ezchip/nps_enet.c
@@ -642,8 +642,8 @@ static s32 nps_enet_remove(struct platform_device *pdev)
 	struct nps_enet_priv *priv = netdev_priv(ndev);
 
 	unregister_netdev(ndev);
-	free_netdev(ndev);
 	netif_napi_del(&priv->napi);
+	free_netdev(ndev);
 
 	return 0;
 }
-- 
2.32.0

