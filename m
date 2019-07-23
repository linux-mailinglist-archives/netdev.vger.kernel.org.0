Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 572AA71662
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 12:43:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733227AbfGWKnV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 06:43:21 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:35790 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726920AbfGWKnV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 06:43:21 -0400
Received: by mail-pl1-f196.google.com with SMTP id w24so20465772plp.2
        for <netdev@vger.kernel.org>; Tue, 23 Jul 2019 03:43:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9qJHZmG7k47DbsZM/zOH4hhB24JCD7grBB3fphjPHIs=;
        b=qLLdQO5y/nqkInhrZMcwYFgy740wD4XczPjfC3PqHn2XEj6hQ7RWsWn8yBkT5+RPmM
         wxBya0+RCkdNBMajFcBe4UrEIuagEQG3LikkrP0AOT/G3qUgpaDqIO2E1x03TYvScwEJ
         m1C1nWcoWK/Ig1xuHZYmQR+81ALkrAEJ3vxgFhOa4LgvuZBSqDNyiyyzPaHE5+2rjUeE
         HFfDl9RbEUL1GH+OeHb3XFw5FfdkugwZnupogwRg6xRiVwRcxt5wuDuqgTtX2rw1pSVV
         uqW1dCA8/jHu9KiAJ+EP0Aq+afeuGp1zfT0nOA4mr5HfcXzS4Crdzw8uigRoD4Yweap7
         qNdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9qJHZmG7k47DbsZM/zOH4hhB24JCD7grBB3fphjPHIs=;
        b=FtbKE/NkbM0se14BwFGa1Du/LXXmv2XCm/lzXKZdqFgHhzdUbgffLh/qhuO7OQBcSr
         8K9FZdYR3lR41hOJiXlI6Fp6lCcd+bpTQW4fMDXc5GK7EProaMO6Wf//q7/Oo2Omh9nE
         dF6LLBWNTHFFYrWxNfFGpGcujebP2jqxgR4uha3ZyBtcYBM2oNU83tTHxPS4/M6LO0Uy
         SYk8epU2qAl0go6tk2e0mrtbEMNOA0A8hceB9HpCvb6fLHrUql7NlCRWi4OY9IiOQjwY
         J1o3l5Cbwf/ZZZHB2Ve8uLJtqpvL5WsmMTqxvjVV+e47OfnJEBIrGDvUqAPrPWoX4rxX
         LE9Q==
X-Gm-Message-State: APjAAAUsLitQDvTjnFSN35wo/lrG7/SJ9VnPo3bALlpNFTJNsruig8wH
        6DudkK8KIMmcTUKx1uZtNgY=
X-Google-Smtp-Source: APXvYqzxSQ1GLjRRRWp5tnmL69SF3jY8gBJ6ahGheTgTsxORt3ZDyNxO7tEqhaJtVlnmXDbWigcTBQ==
X-Received: by 2002:a17:902:23:: with SMTP id 32mr80029674pla.34.1563878600447;
        Tue, 23 Jul 2019 03:43:20 -0700 (PDT)
Received: from localhost.localdomain ([122.163.0.39])
        by smtp.gmail.com with ESMTPSA id u23sm43661364pfn.140.2019.07.23.03.43.17
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 23 Jul 2019 03:43:19 -0700 (PDT)
From:   Nishka Dasgupta <nishkadg.linux@gmail.com>
To:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, netdev@vger.kernel.org
Cc:     Nishka Dasgupta <nishkadg.linux@gmail.com>
Subject: [PATCH] net: dsa: mv88e6xxx: chip: Add of_node_put() before return
Date:   Tue, 23 Jul 2019 16:13:07 +0530
Message-Id: <20190723104307.8068-1-nishkadg.linux@gmail.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Each iteration of for_each_available_child_of_node puts the previous
node, but in the case of a return from the middle of the loop, there is
no put, thus causing a memory leak. Hence add an of_node_put before the
return.
Issue found with Coccinelle.

Signed-off-by: Nishka Dasgupta <nishkadg.linux@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 6b17cd961d06..c97dea4599a8 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2721,6 +2721,7 @@ static int mv88e6xxx_mdios_register(struct mv88e6xxx_chip *chip,
 			err = mv88e6xxx_mdio_register(chip, child, true);
 			if (err) {
 				mv88e6xxx_mdios_unregister(chip);
+				of_node_put(child);
 				return err;
 			}
 		}
-- 
2.19.1

