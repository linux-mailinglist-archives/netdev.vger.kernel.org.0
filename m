Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 502AB33E281
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 01:08:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbhCQAIK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 20:08:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbhCQAHy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 20:07:54 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50067C06174A
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 17:07:54 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id n17so14178674plc.7
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 17:07:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=nI4irxW3sNA0G60HlslxS//AlB8n0m0ePwvyf7ppyPA=;
        b=NrTZKGZN5Gxv/MiVSwQsmJvZ7qIly1BsP2Qaqv2eFaZWQIDjZ8VzTxzRgcJgnYLfsA
         Ipy8SrudUAi3Yfziv8YJgjmZTZbki0hNDnhHU1zZ6MrsIMTl4qjiTgCf11bTIVjW8s7u
         iQ+qxO0Ht6cGU2Ag+BCbGdvkvf6Y750lwhFqYhVbryajxgbXXTVclWUoigwj+whR2fNY
         6bRMFnAPKR4clVpXxemIFoL45c1DcvT1F4eXZqX/6IMfzQGHbmg66daRRwgPpDmENI0S
         PNK8af/Mucn2fF5NWMx0SQfUyOFZIt45wayuvc6uuzxW6iNSku9/cwBqF0h/2vkFeHmH
         8UJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=nI4irxW3sNA0G60HlslxS//AlB8n0m0ePwvyf7ppyPA=;
        b=ELOEZm+HvZ7taFohM+QjfLcTaCvg5WJM27m8EbVHP323kRSxftFrWaIqwh7sBGVVBr
         pMraW6JTLsDpeH7O/as/Nw1q2cmmEOpDl1xWOiRw6CDnJXaG1NEwawuqRzvSq/YjaVrc
         X5pRXYqvhEg0jS0/2BbwtozrErqeC5UqeCSd/0Ik8CQeAqxYJFD0oWmmPtzKu9Jf/2Fs
         j3THzNhOoaMeczBl1Y4KCMDwNVSALMyeH53vUOb7lBlA8kyYLudVWx4xpHzH7M9IdZ40
         0hO2vUA6Wy0V+ry7tEZ0GJN80e01T1QDCvJfpdua2yVCB7yrvatnC1yX/O6rBC57ftKF
         UpHg==
X-Gm-Message-State: AOAM533dAoFbTmLpCV5ACkc9WL36JfPtxw3fxA9O7zK3NFZ8EvVSdd0X
        AeJBdeLvariQaM1/wimedhbkBscW0lxivw==
X-Google-Smtp-Source: ABdhPJwtpmLAFkyYaywoDgAjhoSab8QFV7l4PJzogQMsosJ75Ckbm9ko4hket5vaD6KhdZY3HU57zg==
X-Received: by 2002:a17:903:2286:b029:e6:6499:8c2d with SMTP id b6-20020a1709032286b02900e664998c2dmr1667628plh.17.1615939673604;
        Tue, 16 Mar 2021 17:07:53 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id f135sm17520306pfa.102.2021.03.16.17.07.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 17:07:53 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net] ionic: linearize tso skb with too many frags
Date:   Tue, 16 Mar 2021 17:07:47 -0700
Message-Id: <20210317000747.27372-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We were linearizing non-TSO skbs that had too many frags, but
we weren't checking number of frags on TSO skbs.  This could
lead to a bad page reference when we received a TSO skb with
more frags than the Tx descriptor could support.

v2: use gso_segs rather than yet another division
    don't rework the check on the nr_frags

Fixes: 0f3154e6bcb3 ("ionic: Add Tx and Rx handling")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_txrx.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
index 162a1ff1e9d2..4087311f7082 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
@@ -1079,15 +1079,17 @@ static int ionic_tx_descs_needed(struct ionic_queue *q, struct sk_buff *skb)
 {
 	int sg_elems = q->lif->qtype_info[IONIC_QTYPE_TXQ].max_sg_elems;
 	struct ionic_tx_stats *stats = q_to_tx_stats(q);
+	int ndescs;
 	int err;
 
-	/* If TSO, need roundup(skb->len/mss) descs */
+	/* Each desc is mss long max, so a descriptor for each gso_seg */
 	if (skb_is_gso(skb))
-		return (skb->len / skb_shinfo(skb)->gso_size) + 1;
+		ndescs = skb_shinfo(skb)->gso_segs;
+	else
+		ndescs = 1;
 
-	/* If non-TSO, just need 1 desc and nr_frags sg elems */
 	if (skb_shinfo(skb)->nr_frags <= sg_elems)
-		return 1;
+		return ndescs;
 
 	/* Too many frags, so linearize */
 	err = skb_linearize(skb);
@@ -1096,8 +1098,7 @@ static int ionic_tx_descs_needed(struct ionic_queue *q, struct sk_buff *skb)
 
 	stats->linearize++;
 
-	/* Need 1 desc and zero sg elems */
-	return 1;
+	return ndescs;
 }
 
 static int ionic_maybe_stop_tx(struct ionic_queue *q, int ndescs)
-- 
2.17.1

