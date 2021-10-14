Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A5EF42D2AB
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 08:29:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbhJNGbj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 02:31:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbhJNGbY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 02:31:24 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84874C061570;
        Wed, 13 Oct 2021 23:29:20 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id x8so3439379plv.8;
        Wed, 13 Oct 2021 23:29:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=n5SnxvhmY+qTRILLCzaztY5PSjGFzaDoDn+bV8S3cgY=;
        b=ZVJLFTxXpbZlHXGhzWOAW0ZgukXn/BcWxZcMXnLe3lSgvCuDecQK4rDC1FiR5DNNYS
         o6DsfgABOcQm39yOjdWLbGFZL1OA53fn7N5C8Xq8VCmR0YHN1Di+WlxoU/LoeDeaPhB/
         Nco9gx4kfdafhWeryAeC9GicsYYGkX02NPWEMgFAOAowxiDwZIZImJi+FNTVOobgaQdw
         NekzqVew0rCucgQbwknB+w0WhpQBxf1Deice9SArFSCEyqeMdJlO2XPpA4nTqTHtqhtK
         1qI/512+z/eZAtlL+pRBARHRpVGYWj5RfrGGK4ncUG4XrgInQZmoysgOYsyHCBEocCI/
         J/9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=n5SnxvhmY+qTRILLCzaztY5PSjGFzaDoDn+bV8S3cgY=;
        b=p2TVCpU7vhKQY3lQlcJ3TDyLOhZJ+uRhHQuY6eL+SxZ8eGVNLsGPa5uDxKTUIfPGGq
         7949BEnpIIlLy7Am52pk9xUs8fou6bEwbzQKD9AAgXqBA1BiE9yK5WQZ1Ja+R2bkzhj3
         H4AQ69slUhVTq9pOdkcWP0P7ydcd0z1ZHxkDlWlvGCefRdS0IRDIEjd/cgi8wvAEOwi/
         XxJl4Ty5i5udRMLWz1/Jc0NlXrZnFVesiPI7qVhllRB1R9FbRoAPlQY2TcFTF7pMDldd
         Qp3tExpZ2PhsvBgPs+Vrlkfqrh0hgkUM4tqM3OGBF3v6Aj2DyPGIFQbtZnjDjfwDtp3G
         Srkw==
X-Gm-Message-State: AOAM5319/NdlF+thxGU9PEkRCvo6VTz5oE/uCBOuQVVPpg/sS/rKnrOJ
        gXQMHy2B3JgtlkehvUidQA==
X-Google-Smtp-Source: ABdhPJxr7qNWbYDpMwgqOQ0O/nEjHG9wzCmIqSUfEjlh+p+/T+oIrofLbPZ7u+jrggvcZzc43H5dqQ==
X-Received: by 2002:a17:90b:1d0d:: with SMTP id on13mr7346518pjb.36.1634192960097;
        Wed, 13 Oct 2021 23:29:20 -0700 (PDT)
Received: from vultr.guest ([107.191.53.97])
        by smtp.gmail.com with ESMTPSA id x7sm7769503pjg.5.2021.10.13.23.29.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 13 Oct 2021 23:29:19 -0700 (PDT)
From:   Zheyu Ma <zheyuma97@gmail.com>
To:     wg@grandegger.com, mkl@pengutronix.de, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zheyu Ma <zheyuma97@gmail.com>
Subject: [PATCH] can: peak_pci: Fix UAF in peak_pci_remove
Date:   Thu, 14 Oct 2021 06:28:33 +0000
Message-Id: <1634192913-15639-1-git-send-email-zheyuma97@gmail.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When remove the module peek_pci, referencing 'chan' again after
releasing 'dev' will cause UAF.

Fix this by releasing 'dev' later.

The following log reveals it:

[   35.961814 ] BUG: KASAN: use-after-free in peak_pci_remove+0x16f/0x270 [peak_pci]
[   35.963414 ] Read of size 8 at addr ffff888136998ee8 by task modprobe/5537
[   35.965513 ] Call Trace:
[   35.965718 ]  dump_stack_lvl+0xa8/0xd1
[   35.966028 ]  print_address_description+0x87/0x3b0
[   35.966420 ]  kasan_report+0x172/0x1c0
[   35.966725 ]  ? peak_pci_remove+0x16f/0x270 [peak_pci]
[   35.967137 ]  ? trace_irq_enable_rcuidle+0x10/0x170
[   35.967529 ]  ? peak_pci_remove+0x16f/0x270 [peak_pci]
[   35.967945 ]  __asan_report_load8_noabort+0x14/0x20
[   35.968346 ]  peak_pci_remove+0x16f/0x270 [peak_pci]
[   35.968752 ]  pci_device_remove+0xa9/0x250

Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
---
 drivers/net/can/sja1000/peak_pci.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/can/sja1000/peak_pci.c b/drivers/net/can/sja1000/peak_pci.c
index 6db90dc4bc9d..84f34020aafb 100644
--- a/drivers/net/can/sja1000/peak_pci.c
+++ b/drivers/net/can/sja1000/peak_pci.c
@@ -752,16 +752,15 @@ static void peak_pci_remove(struct pci_dev *pdev)
 		struct net_device *prev_dev = chan->prev_dev;
 
 		dev_info(&pdev->dev, "removing device %s\n", dev->name);
+		/* do that only for first channel */
+		if (!prev_dev && chan->pciec_card)
+			peak_pciec_remove(chan->pciec_card);
 		unregister_sja1000dev(dev);
 		free_sja1000dev(dev);
 		dev = prev_dev;
 
-		if (!dev) {
-			/* do that only for first channel */
-			if (chan->pciec_card)
-				peak_pciec_remove(chan->pciec_card);
+		if (!dev)
 			break;
-		}
 		priv = netdev_priv(dev);
 		chan = priv->priv;
 	}
-- 
2.17.6

