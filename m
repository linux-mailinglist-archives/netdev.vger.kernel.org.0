Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3BD12D832
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 10:48:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726728AbfE2Irz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 04:47:55 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:44041 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726441AbfE2Irv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 04:47:51 -0400
Received: by mail-pf1-f195.google.com with SMTP id g9so1161565pfo.11;
        Wed, 29 May 2019 01:47:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=TgWBMzeoaoEO+5BjILyNWDtEoQ8YNu+FEzYYyIocJk8=;
        b=kzwVn+489j0EgyGtZJe7IBnMsoNMIAlsRcGhFOoe7UqlQNpgfLcFvu5VE16cEHkHaM
         ACvNDjzN8h/hZIPbOqc/H1ppKdLdnxwOEF/vBfGTJt3EDJn/8YmInhqonNTSbVHPast2
         YkAf5ZyDYXv4r5jkHpT0vb5bx5810IEMkgG+hNPhpyq/xFLN4xuzdl/tpXosEVafooYv
         KKT2b8w4DpNZOVZo2qyfO+KtsgpPJgMiKNuDj7FT130tqOb5k6WisbqhBWXNjYJQFG3O
         nJQdMmNTl/UBeGW3TLSITdeIFQqIz5f7gJz0H2Vm3TzkVFpf0DM/61Pcz9Rz/Kt2dVro
         /EGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=TgWBMzeoaoEO+5BjILyNWDtEoQ8YNu+FEzYYyIocJk8=;
        b=gHavSPLBiu9mAdCh0uKEEdHuzNtPe1XYMqrCkET9754T9lQFELmpDErqg0FFPs7V/c
         49Tm6sW9femEkAKDeeoUDbDW2W01jzeA0FuwSg9bGgbpTFjuVRZPpHVPzf0QWEJCR9jQ
         AEoggDjdyHfVsUFjSRSRfbPbAtnYChfy70vq+A+PppRs/jFbKlp/N26jruwXFeqVhErU
         X2hgSU+RfyQ6giheLKMCpB11V6vhbi/Ukav/a227w296X8QmqXrcxgUM//B+PyJrasCU
         SREPLRCOjfrpvYIfwI//QtE0fQZEJ9NynUqP0tFZDxAcSmLZeUBz2I4p/KljiSy0QnE6
         vkQw==
X-Gm-Message-State: APjAAAUJeCRChVDeBlR0t8thR7Ka7IbvJ/SX97WEpu0fGBjLlrMGYPFp
        vp+AQ+PvXjmDzYyyNshBHTU=
X-Google-Smtp-Source: APXvYqxE59mLhsE+Vd7Je+BFBDHnGy0F4hye4KgMKoXaxr51JgDgxDrpr5A6jhtiE/qAk+9FLSSoDw==
X-Received: by 2002:a62:ee04:: with SMTP id e4mr33779311pfi.232.1559119671409;
        Wed, 29 May 2019 01:47:51 -0700 (PDT)
Received: from xy-data.openstacklocal (ecs-159-138-22-150.compute.hwclouds-dns.com. [159.138.22.150])
        by smtp.gmail.com with ESMTPSA id 24sm3191491pgn.32.2019.05.29.01.47.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 29 May 2019 01:47:50 -0700 (PDT)
From:   Young Xiao <92siuyang@gmail.com>
To:     isdn@linux-pingi.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Young Xiao <92siuyang@gmail.com>
Subject: [PATCH] isdn: hisax: isac: fix a possible concurrency use-after-free bug in ISAC_l1hw()
Date:   Wed, 29 May 2019 16:48:59 +0800
Message-Id: <1559119739-27588-1-git-send-email-92siuyang@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In drivers/isdn/hisax/isac.c, the function isac_interrupt() and
ISAC_l1hw() may be concurrently executed.

ISAC_l1hw()
    line 499: if (!cs->tx_skb)

isac_interrupt()
    line 250: dev_kfree_skb_irq(cs->tx_skb);

Thus, a possible concurrency use-after-free bug may occur in ISAC_l1hw().

To fix these bugs, the calls to spin_lock_irqsave() and
spin_unlock_irqrestore() are added in HFCPCI_l1hw(), to protect the
access to cs->tx_skb.

See commit 7418e6520f22 ("isdn: hisax: hfc_pci: Fix a possible concurrency
use-after-free bug in HFCPCI_l1hw()") for details.

Signed-off-by: Young Xiao <92siuyang@gmail.com>
---
 drivers/isdn/hisax/isac.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/isdn/hisax/isac.c b/drivers/isdn/hisax/isac.c
index bd40e06..60dd805 100644
--- a/drivers/isdn/hisax/isac.c
+++ b/drivers/isdn/hisax/isac.c
@@ -496,11 +496,13 @@ ISAC_l1hw(struct PStack *st, int pr, void *arg)
 		if (cs->debug & L1_DEB_LAPD)
 			debugl1(cs, "-> PH_REQUEST_PULL");
 #endif
+		spin_lock_irqsave(&cs->lock, flags);
 		if (!cs->tx_skb) {
 			test_and_clear_bit(FLG_L1_PULL_REQ, &st->l1.Flags);
 			st->l1.l1l2(st, PH_PULL | CONFIRM, NULL);
 		} else
 			test_and_set_bit(FLG_L1_PULL_REQ, &st->l1.Flags);
+		spin_unlock_irqrestore(&cs->lock, flags);
 		break;
 	case (HW_RESET | REQUEST):
 		spin_lock_irqsave(&cs->lock, flags);
-- 
2.7.4

