Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF6A73DF363
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 19:01:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234192AbhHCRBj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 13:01:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237540AbhHCQ4K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 12:56:10 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9C8AC061798
        for <netdev@vger.kernel.org>; Tue,  3 Aug 2021 09:55:57 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id yk17so29683165ejb.11
        for <netdev@vger.kernel.org>; Tue, 03 Aug 2021 09:55:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YX0tPqUP8lnGLjyXtWNv7Fjs5lqIGLwPOAH1PTRfU9Y=;
        b=X5JkuM3YZZztO/XOfM/aRedPFb+jyN8d3JhkIozoLvD4hkx4Xo/i99NK9jJAEA6RsG
         EOUScylVBmamLnTJ0oVRC+y+cteQEoy4Bkd07TyEz8ayIaZp8cm1Ci5HVuqoJHaekmu2
         sfCsl1WBuK2QDeFt9/W6znTS7R6MfXkmq01HxiAm0abmDK6Pp6Eeffia8BSENBKrLORi
         ouBLoLzEu5t1IyVK3QXp7NbgXWxUTM3rnqP+MsdItFE2LW2QZE1Q3/wYZW1yUgZ3tFO5
         vup+t0frreGsxSX1aKrHcHab28vsHR5p6Y88SwDTWCQ3S68pwxL2rsNgjXLHKswpYcJ+
         ewnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YX0tPqUP8lnGLjyXtWNv7Fjs5lqIGLwPOAH1PTRfU9Y=;
        b=DTV7XuW4YXwBBs4iWmFYe2re9iIZvciRvj0o24gqdKZenCjV9xQ3eLfgmRWWvzWEbx
         19eyqOl+t2Av8vBxgsf+GtIy9zud/7GUhtjUXeMSb19/AjtuqDX43opiqbYkrSJvhSaJ
         T71iQsPY3fB+LWeCYNhIm6/uep5f3zcNJ35Kb7UnU3JPqntsu4HNHnA5gc86DRcwW3HB
         ETMpsLGGDrvlHI6U1ICkRoV9su3NKtUlzg0VmB2qmE/vniO55YEjErREPiirGEPfT9nh
         2wVB7a2a0Q3XYG2Mc+6AeB84W4tPDnY/4TUkEAjGoZHWc5XikmQZxHfJxB3N8GAStTCX
         y/Rg==
X-Gm-Message-State: AOAM531lzTTJ66/xq2zdIePRvxTHuqenWKkunIbC1KcEf66tSkHzF1ln
        zpoYp2OfkTiD5f2ozQ99XOE=
X-Google-Smtp-Source: ABdhPJxqspBkCLackoqUF14JnD9ikL2qZQpee7yc984r/6Z2Yj07j3D8rDaYyTEd3yUYpH8BppbLWw==
X-Received: by 2002:a17:906:388b:: with SMTP id q11mr21236007ejd.113.1628009756499;
        Tue, 03 Aug 2021 09:55:56 -0700 (PDT)
Received: from yoga-910.localhost ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id e7sm8754630edk.3.2021.08.03.09.55.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Aug 2021 09:55:56 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     laurentiu.tudor@nxp.com, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 3/8] dpaa2-switch: do not enable the DPSW at probe time
Date:   Tue,  3 Aug 2021 19:57:40 +0300
Message-Id: <20210803165745.138175-4-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210803165745.138175-1-ciorneiioana@gmail.com>
References: <20210803165745.138175-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

We should not enable the switch interfaces at probe time since this is
trigged by the open callback. Remove the call dpsw_enable() which does
exactly this.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
index f8b7601dc9e4..36a6cfe9eaeb 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -3281,12 +3281,6 @@ static int dpaa2_switch_probe(struct fsl_mc_device *sw_dev)
 			       &ethsw->fq[i].napi, dpaa2_switch_poll,
 			       NAPI_POLL_WEIGHT);
 
-	err = dpsw_enable(ethsw->mc_io, 0, ethsw->dpsw_handle);
-	if (err) {
-		dev_err(ethsw->dev, "dpsw_enable err %d\n", err);
-		goto err_free_netdev;
-	}
-
 	/* Setup IRQs */
 	err = dpaa2_switch_setup_irqs(sw_dev);
 	if (err)
-- 
2.31.1

