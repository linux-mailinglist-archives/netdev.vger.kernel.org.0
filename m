Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69FFA1C38C9
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 14:01:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728678AbgEDMBf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 08:01:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726445AbgEDMBf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 08:01:35 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67F13C061A0E;
        Mon,  4 May 2020 05:01:35 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id hi11so3670311pjb.3;
        Mon, 04 May 2020 05:01:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QzsKXL54QvuRKs7TKdiKfQUShykoR6n5UojyFRWW+gk=;
        b=T/qK5uqmZIKrhIb/DIJ/DfL90hQm6GSUp/elWjJ8CwEU2qBhCwqivOba8xQgLRxeqV
         4NThZBvi/6Q9PniGItMndipp+6FGGntmL7Mfw/1Sw10TUwVFfjOs7bsKcJIESRuqHZFj
         J2JAw3lzujhwppvKwyjnlDiFyaANCQ5/8UFNaIjLPFjDVYJ3lOagRm5Cn0x6O5465ZSU
         gJJcB8mmt0h3PEOy477BilIA4/OymYajsf5XzpM3lVvd2KFuucf+R2fpFlN2to8/cxgS
         LNs12AkViZlBjPjqtv6+/hIgXerlPQKrK09NswZR+cATPtZdSWUsIYphFWfcWC+r3GtM
         jH6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QzsKXL54QvuRKs7TKdiKfQUShykoR6n5UojyFRWW+gk=;
        b=k0DeWH8M9kxoNF8yjTZNEl5vI1go6Hw/8Lzi2Dk+HiWYCkJe5F2zMc0hJoOpJEWS7b
         NKb0hKGCrIGPPflztwXxai+kRhLcjDWjHnlQrK80GQkAocFj8rkOaFUVSjxFxNFI5GZQ
         +3stpvcHYbwknT4yneWZZKnyQcl7jJt0WN87MsMvkbbFYcMeAU3zkQF6i2GLXQRRWM1P
         0/a8SZSzUFtTlk/0PEVwD0xo2tX2qN+SvItYZLS8fyphLWs7b/EP1uTmhma9Zn6c2QZB
         UngVV4nOofydXyPW/N2dV1X+ABRiIgdEQY8xkETr3DfTrVqP3HU6ATD9YU3FoiO1xE//
         qz/w==
X-Gm-Message-State: AGi0PubOxrLlCU3ZK8UwnN0giw4Ihns5AK3IddhTKt8QlFdB/HcspQQy
        Sjc6tQ43Zz77DfzvX48umfk=
X-Google-Smtp-Source: APiQypIeAGR5MGlOZrGOX5Ic3d55EImWrtDHe6ZwOnXBCLEsmQWJCLYn1VHDDJGq+ExRsEaU/QJmAA==
X-Received: by 2002:a17:90a:3086:: with SMTP id h6mr17926601pjb.49.1588593694898;
        Mon, 04 May 2020 05:01:34 -0700 (PDT)
Received: from localhost ([162.211.220.152])
        by smtp.gmail.com with ESMTPSA id 14sm8945087pfj.90.2020.05.04.05.01.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 04 May 2020 05:01:34 -0700 (PDT)
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     claudiu.manoil@nxp.com, davem@davemloft.net,
        vladimir.oltean@nxp.com, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Dejin Zheng <zhengdejin5@gmail.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCH net v1] net: enetc: fix an issue about leak system resources
Date:   Mon,  4 May 2020 20:01:27 +0800
Message-Id: <20200504120127.4482-1-zhengdejin5@gmail.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

the related system resources were not released when enetc_hw_alloc()
return error in the enetc_pci_mdio_probe(), add iounmap() for error
handling label "err_hw_alloc" to fix it.

Fixes: 6517798dd3432a ("enetc: Make MDIO accessors more generic and export to include/linux/fsl")
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
---
 drivers/net/ethernet/freescale/enetc/enetc_pci_mdio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pci_mdio.c b/drivers/net/ethernet/freescale/enetc/enetc_pci_mdio.c
index ebc635f8a4cc..15f37c5b8dc1 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pci_mdio.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pci_mdio.c
@@ -74,8 +74,8 @@ static int enetc_pci_mdio_probe(struct pci_dev *pdev,
 	pci_disable_device(pdev);
 err_pci_enable:
 err_mdiobus_alloc:
-	iounmap(port_regs);
 err_hw_alloc:
+	iounmap(port_regs);
 err_ioremap:
 	return err;
 }
-- 
2.25.0

