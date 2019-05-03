Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B15A13055
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 16:35:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727982AbfECOfI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 10:35:08 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:46602 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726377AbfECOfI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 10:35:08 -0400
Received: by mail-pl1-f193.google.com with SMTP id bi2so2778848plb.13;
        Fri, 03 May 2019 07:35:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=kMGLnhggc8cifwRrjEK9HALOorMf0mLsznAzU3ByQJ4=;
        b=shNY8wGsdG7K1gn0sScFEu/UG87+cKxU8rBCXtb8tyo+rAKekJK+7uISp4XTWWgBA4
         mMR6f1lRqLExLgSCD47O08vLxUrzx+Aa7MtEwDM1fYTizYyGG991dxO+1rGubS8CeqGL
         fuH0M46aEiOtlQIEybjoTs34L1vO9NcvFKaJCb2f7xoKFeK2vROY6owPj1Y4VdRET597
         yXFSgXFQfIIaA0gouVJTOTy0z/eoMMxy5g+gNiK7bm0B/v3ylUmrwBMUtJZGJKxh2owY
         9r45sdCvSgKdqpkckoiMVZ/5UPCn26BqC/8kYXBAKiZXhrY+0dj4HX8W3Z4OJFLiRSYl
         +Mqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=kMGLnhggc8cifwRrjEK9HALOorMf0mLsznAzU3ByQJ4=;
        b=THODU3yHnS6lIzCyLc7fLHCvaSx4wHo7PvB6T49dntdaiNT7/fKDjxF/LkLbg/R5WE
         tdpok1VV5QXs+ICr18LB47m/jbDrY4a4qdibk2LYh4XEmM+wo1/lKABrLJQZ6lHIhPgM
         TVJGbbjhiQ29eCd/ouM4ab6aveRpC9T02Zm19mO8T4A2QSktLtGn/Oi5xBsE8bkNFdnD
         AZdwiO4lsYR62g4XxpZ6aKV+78WwSwBdUQ4NESKYE9Ksy+aP9mFEDkCtVZtDosUYhBjW
         dO3sC5L2g/nc95lyMIINgPuWpVfyZwG4HYH3qMMIQYxgVz7huQnkgv7oj2+eIGBOGdx7
         xi+g==
X-Gm-Message-State: APjAAAXVnd5TddQHcRq7xplxLVZaFw7QoXDTAaHANQv/HkfOe7P0z01v
        btCgJ/I0+thB1GsUriWQG2g=
X-Google-Smtp-Source: APXvYqzLw5RFP+moTLdaj7O6UqQIbnzuJQcywkHNCxDgZyn604CU0+GbY7CVtCWF8KqN+EQLh/fuSQ==
X-Received: by 2002:a17:902:8c81:: with SMTP id t1mr2372272plo.333.1556893714461;
        Fri, 03 May 2019 07:28:34 -0700 (PDT)
Received: from oslab.tsinghua.edu.cn ([2402:f000:4:72:808::3ca])
        by smtp.gmail.com with ESMTPSA id s19sm2789351pgj.62.2019.05.03.07.28.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 May 2019 07:28:33 -0700 (PDT)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
To:     jeffrey.t.kirsher@intel.com, davem@davemloft.net
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] net: e1000: Fix some bugs in error handling code of e1000_probe()
Date:   Fri,  3 May 2019 22:28:23 +0800
Message-Id: <20190503142823.15319-1-baijiaju1990@gmail.com>
X-Mailer: git-send-email 2.17.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When "hw->ce4100_gbe_mdio_base_virt = ioremap(...)" fails, the driver
does not free the memory allocated in e1000_sw_init(), and also calls
"iounmap(hw->ce4100_gbe_mido_base_virt)" that is unnecessary.

Besides, when e1000_sw_init() fails, the driver also calls 
"iounmap(hw->ce4100_gbe_mido_base_virt)" but 
hw->ce4100_gbe_mido_base_virt has not been assigned.

These bugs are found by a runtime fuzzing tool named FIZZER written by us.

To fix these bugs, the error handling code of e1000_probe() is adjusted.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/net/ethernet/intel/e1000/e1000_main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000/e1000_main.c b/drivers/net/ethernet/intel/e1000/e1000_main.c
index 8fe9af0e2ab7..7743c4d9723f 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_main.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_main.c
@@ -1227,12 +1227,12 @@ static int e1000_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	if (hw->flash_address)
 		iounmap(hw->flash_address);
+	iounmap(hw->ce4100_gbe_mdio_base_virt);
+err_mdio_ioremap:
 	kfree(adapter->tx_ring);
 	kfree(adapter->rx_ring);
-err_dma:
 err_sw_init:
-err_mdio_ioremap:
-	iounmap(hw->ce4100_gbe_mdio_base_virt);
+err_dma:
 	iounmap(hw->hw_addr);
 err_ioremap:
 	disable_dev = !test_and_set_bit(__E1000_DISABLED, &adapter->flags);
-- 
2.17.0

