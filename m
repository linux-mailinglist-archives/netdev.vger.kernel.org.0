Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCF5648E48A
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 07:57:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236663AbiANG5e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 01:57:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbiANG5d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 01:57:33 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7296C061574;
        Thu, 13 Jan 2022 22:57:32 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id u15so12586075ple.2;
        Thu, 13 Jan 2022 22:57:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id;
        bh=CeW82cN/yWeM4soYMOpczvaS8ZMGtp9sZLogjHvilow=;
        b=Pfut5mRowwVi9GukwBx14hY3j3fpblolc1Npg5de2Tk8JNa2OL/p9wWb+7+Hgv4ENH
         8ccALhoYtRzF3FlObOXmxtT43vEfSWCU/Kho6oAvEe6IKK7aSxQ1cR3LOhTRg3yqJTsn
         Xua0B7O0NH9FkE4fju5mMPpGdWBw5d4KBvFp6ZTl5L5+DJiyhIGN6Cbm4gLbjSp1zUa6
         2/W0kQqFXSX2Ej9VZyfTJwtmAvusWip9P1aaiVFYV4omtGI10M3a2WAMxUm2okL+jt7x
         ZeKA2Yk+ygB2Sdn7pvu5OTp3dPLphRG9QyoBf5VWxCSfnKw9Z5qR3OTl9HqrSefnA80p
         29cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=CeW82cN/yWeM4soYMOpczvaS8ZMGtp9sZLogjHvilow=;
        b=PbeC1hEt2t0R1Z/V8BYsSYMMbFD0P5CqPjKKY7+XDryFOfMBAJU7WLZZqmGv/1i6t7
         fshtXHRqUUsy+VmD0t3+j8av2g2TbPulV54IW4wkFV4SIRQ24+7w25YZ7LQKWVxIxXSZ
         eGAGKOpFLMCHXYwc0HUHIIplXbQ/u9nxHjBW+acw0KLM+sEg0HVG0xJ51h3XzBTVyOYr
         w/3hYPjZSP4cRsV73Iku3pZ1s3ipeKEtXZiFzXe4DOrvSXwy0zzEINw9ijW5VE8pFn4v
         REP1H4Vt9Atx/vfMA+SHNYAusDN1KmqPTn2GwEpMd8wBZGgQodc6qnuOtR0rW+4i31rW
         C1AA==
X-Gm-Message-State: AOAM5320j3ehWQRLajs6lZruhU4T+jpI6Lnyu1rM2mmc7S8p3/MGs3QM
        8AIwJIPU3S7Ewl1FAjY/CfE=
X-Google-Smtp-Source: ABdhPJz+MGyPao0B0Y4GD6SKQN79HjWmTopccwi/RbHI1PGg1+UUwuZTABqw6tkyqvHhAM24TEhsZg==
X-Received: by 2002:a17:902:b58d:b0:149:9c02:6345 with SMTP id a13-20020a170902b58d00b001499c026345mr8452544pls.21.1642143452444;
        Thu, 13 Jan 2022 22:57:32 -0800 (PST)
Received: from localhost.localdomain ([159.226.95.43])
        by smtp.googlemail.com with ESMTPSA id kt19sm4194355pjb.50.2022.01.13.22.57.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jan 2022 22:57:32 -0800 (PST)
From:   Miaoqian Lin <linmq006@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Miaoqian Lin <linmq006@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] lib82596: Fix IRQ check in sni_82596_probe
Date:   Fri, 14 Jan 2022 06:57:24 +0000
Message-Id: <20220114065727.22920-1-linmq006@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

platform_get_irq() returns negative error number instead 0 on failure.
And the doc of platform_get_irq() provides a usage example:

    int irq = platform_get_irq(pdev, 0);
    if (irq < 0)
        return irq;

Fix the check of return value to catch errors correctly.

Fixes: 115978859272 ("i825xx: Move the Intel 82586/82593/82596 based drivers")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
---
 drivers/net/ethernet/i825xx/sni_82596.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/i825xx/sni_82596.c b/drivers/net/ethernet/i825xx/sni_82596.c
index 27937c5d7956..daec9ce04531 100644
--- a/drivers/net/ethernet/i825xx/sni_82596.c
+++ b/drivers/net/ethernet/i825xx/sni_82596.c
@@ -117,9 +117,10 @@ static int sni_82596_probe(struct platform_device *dev)
 	netdevice->dev_addr[5] = readb(eth_addr + 0x06);
 	iounmap(eth_addr);
 
-	if (!netdevice->irq) {
+	if (netdevice->irq < 0) {
 		printk(KERN_ERR "%s: IRQ not found for i82596 at 0x%lx\n",
 			__FILE__, netdevice->base_addr);
+		retval = netdevice->irq;
 		goto probe_failed;
 	}
 
-- 
2.17.1

