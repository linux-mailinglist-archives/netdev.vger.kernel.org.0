Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A71B12685EF
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 09:31:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726136AbgINHbf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 03:31:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726092AbgINHaz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 03:30:55 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9C3CC06174A
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 00:30:55 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id l191so10830085pgd.5
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 00:30:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qT4S1d0PIzJi7Pt12HUmsjoVbhYttOXthzRcyAOM0aM=;
        b=oV++FYTo9fgJw5E37PdECA3/lbpfh1lD8De7MIkz/Gh99kkWYC9cW1AFIFdhhFlf/A
         LbsC9AZ07EL/A4Dma7dfieKMXn/wQ9+A7DGC6ELBFqJ6CBbCbZxhzztLPNpNSlklT6vb
         cxGT5QtvbZyqGE9/Sz8S2ChbuYdUdms8hsnJo2CaGUKAJ45Kmu5rDVMmHwHrKLCSgaxt
         +0ANznepYl6WQAjAf6D73yzCcTB4aN06MQC7hdTIvjcyCqiUUUHIQY+bbpA6M8e17TWl
         7wK+D6afeqHOz7bg4o74YJHIySftAhYXK3FeGLd/m6ysEjd90gJMRZwfGm8GgeTGijX4
         8SQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qT4S1d0PIzJi7Pt12HUmsjoVbhYttOXthzRcyAOM0aM=;
        b=FTy9osIAUVP6ibMmbRT52PRnhZcAOfnKYDVoK2annVGwUR72eqJsaHJmszf6ZgQWYq
         SnFYVXQe1OlLZb3pTiQemfSJZe+khDLCOROd+PKLZTrK8tj0/l+ld41YAUdjKmaygeJN
         /Z/09XR+YF58IlyBBtwG7lNnXLBFAtDc2yVCzv3SlPW2F7cQScPHkr0xxgg9n75Gqw2Y
         KdKso32BykwX2y8cPkMSXb+lRfnm3BdzxqGcRVA8O0GLU7FQ88zB1oSWf/S9WXB2pKi5
         pM1oaadK+NGtLOj76zjwFpDl4iBpdvVgM90ZqlDpYtRxcsza5w2zWPvXokE464aVYLHn
         vn3A==
X-Gm-Message-State: AOAM53245of3RDn/VC+uGsfgPiYU9UQvscubvsr9z+HaSC+ILD972HL7
        tsOxjbydbLfHJ9DI5g+3Oig=
X-Google-Smtp-Source: ABdhPJy1b46v2X7HOZiB2vNcKz30lcVFWAfTmU5ukTi3mVSoc26WpKFRdJodQur24IRFkwhmFXJ01w==
X-Received: by 2002:a62:7c0f:: with SMTP id x15mr12222480pfc.7.1600068655335;
        Mon, 14 Sep 2020 00:30:55 -0700 (PDT)
Received: from localhost.localdomain ([49.207.192.250])
        by smtp.gmail.com with ESMTPSA id a16sm7609057pgh.48.2020.09.14.00.30.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2020 00:30:54 -0700 (PDT)
From:   Allen Pais <allen.lkml@gmail.com>
To:     davem@davemloft.net
Cc:     jes@trained-monkey.org, kuba@kernel.org, dougmill@linux.ibm.com,
        cooldavid@cooldavid.org, mlindner@marvell.com,
        stephen@networkplumber.org, borisp@mellanox.com,
        netdev@vger.kernel.org, Allen Pais <apais@linux.microsoft.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [net-next v3 16/20] nfp: convert tasklets to use new tasklet_setup() API
Date:   Mon, 14 Sep 2020 12:59:35 +0530
Message-Id: <20200914072939.803280-17-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200914072939.803280-1-allen.lkml@gmail.com>
References: <20200914072939.803280-1-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Allen Pais <apais@linux.microsoft.com>

In preparation for unconditionally passing the
struct tasklet_struct pointer to all tasklet
callbacks, switch to using the new tasklet_setup()
and from_tasklet() to pass the tasklet pointer explicitly.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <apais@linux.microsoft.com>
---
 drivers/net/ethernet/netronome/nfp/nfp_net_common.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index 21ea22694e47..b150da43adb2 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -2287,9 +2287,9 @@ static bool nfp_ctrl_rx(struct nfp_net_r_vector *r_vec)
 	return budget;
 }
 
-static void nfp_ctrl_poll(unsigned long arg)
+static void nfp_ctrl_poll(struct tasklet_struct *t)
 {
-	struct nfp_net_r_vector *r_vec = (void *)arg;
+	struct nfp_net_r_vector *r_vec = from_tasklet(r_vec, t, tasklet);
 
 	spin_lock(&r_vec->lock);
 	nfp_net_tx_complete(r_vec->tx_ring, 0);
@@ -2337,8 +2337,7 @@ static void nfp_net_vecs_init(struct nfp_net *nn)
 
 			__skb_queue_head_init(&r_vec->queue);
 			spin_lock_init(&r_vec->lock);
-			tasklet_init(&r_vec->tasklet, nfp_ctrl_poll,
-				     (unsigned long)r_vec);
+			tasklet_setup(&r_vec->tasklet, nfp_ctrl_poll);
 			tasklet_disable(&r_vec->tasklet);
 		}
 
-- 
2.25.1

