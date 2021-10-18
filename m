Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E003F431FC6
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 16:33:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231944AbhJROfT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 10:35:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231634AbhJROfS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 10:35:18 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 192D6C06161C;
        Mon, 18 Oct 2021 07:33:07 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id ez7-20020a17090ae14700b001a132a1679bso4760375pjb.0;
        Mon, 18 Oct 2021 07:33:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=onF4hmW8ZH95EB856Ri4m8yoghjYbaHUCFiH6N60H08=;
        b=UaGejdWHICPQznn/3ylFkZwh7hackIAt1/8i4qImkRk9MnJCzJNadZRrZ7RsBJm5AC
         E5voL2UVHp/xoiV73DX/2Ww7OpJUX7XY7o+8c1OiP66ojXufB6vypyz+aFsQELPTUpeO
         iw6Z66LAvax5nmML9P6IKP1rAFg0gHK3eqEDQ4kDM1rEwmG55D90dX97WwjTgaYwUmhi
         XNhiBGnAUXobA3iaIC0UpwqBK+ODui53g+Qh7WGRGvQlnY7vEv4E2/GFC0D7kvVl5Ev2
         MwHrZt5euDadI65URle8N5o+L5aYpXpLzdluIOnCwpGSKOShTN4Vg+Nd0zbNAJODFPNa
         huwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=onF4hmW8ZH95EB856Ri4m8yoghjYbaHUCFiH6N60H08=;
        b=HZwO2ShCbwy2pbjNlleXasKTD0bn4Ml3nNHhVOj0ixdrrLYBaBoBQY4+ugcGz14Q0V
         Xxl0bCz2+LbAniDGhEoy9jNRePrHGeovQ8F6xmCr5ARdIxbOHMpn4iwPgXerU+yv/HTq
         uilxrDDJyC/5OPe0q0J8gkpDmwMALFKO5Zy3KogUjp+XKj11JopbUKmJ5VWMlRtNoomb
         KClbcjhw4g3NIR3jIjFgTTWddl84Ra00VM2fYfXdychaHtNzenIJlq9uTSTIgnsjOIQI
         aoMmGMIBzV0f9aWw8hyf+wGV6HxbAA+qqJoV2C1EnO3DA3DL1voQdH/VPhJPOZdz9uCD
         T+BA==
X-Gm-Message-State: AOAM532jnTdmc4cbPuzrP/l0mw8rd1zZkAXJeFK3BOc+onCEo0FGMU5D
        WWl8JEz/yNdBEeQtyrVAPA==
X-Google-Smtp-Source: ABdhPJz7iCXevqjw8+WfBIHed8GTuSwGhzDaLOGw285GU6Df470RNLn50c1PIKk7g992CyohynHtHA==
X-Received: by 2002:a17:90b:4f46:: with SMTP id pj6mr33886455pjb.63.1634567586599;
        Mon, 18 Oct 2021 07:33:06 -0700 (PDT)
Received: from vultr.guest ([107.191.53.97])
        by smtp.gmail.com with ESMTPSA id k14sm13455059pfh.154.2021.10.18.07.33.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 18 Oct 2021 07:33:06 -0700 (PDT)
From:   Zheyu Ma <zheyuma97@gmail.com>
To:     sgoutham@marvell.com, davem@davemloft.net, kuba@kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zheyu Ma <zheyuma97@gmail.com>
Subject: [PATCH] cavium: Fix return values of the probe function
Date:   Mon, 18 Oct 2021 14:32:57 +0000
Message-Id: <1634567577-4033-1-git-send-email-zheyuma97@gmail.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

During the process of driver probing, the probe function should return < 0
for failure, otherwise, the kernel will treat value > 0 as success.

Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
---
 drivers/net/ethernet/cavium/thunder/nicvf_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/cavium/thunder/nicvf_main.c b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
index d1667b759522..a27227aeae88 100644
--- a/drivers/net/ethernet/cavium/thunder/nicvf_main.c
+++ b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
@@ -1224,7 +1224,7 @@ static int nicvf_register_misc_interrupt(struct nicvf *nic)
 	if (ret < 0) {
 		netdev_err(nic->netdev,
 			   "Req for #%d msix vectors failed\n", nic->num_vec);
-		return 1;
+		return ret;
 	}
 
 	sprintf(nic->irq_name[irq], "%s Mbox", "NICVF");
@@ -1243,7 +1243,7 @@ static int nicvf_register_misc_interrupt(struct nicvf *nic)
 	if (!nicvf_check_pf_ready(nic)) {
 		nicvf_disable_intr(nic, NICVF_INTR_MBOX, 0);
 		nicvf_unregister_interrupts(nic);
-		return 1;
+		return -EIO;
 	}
 
 	return 0;
-- 
2.17.6

