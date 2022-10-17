Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3732B601D94
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 01:31:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230199AbiJQXbm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 19:31:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230299AbiJQXbl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 19:31:41 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F5BD6D578
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 16:31:38 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id q10-20020a17090a304a00b0020b1d5f6975so12427370pjl.0
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 16:31:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yH97LH6OluVceBz+lo8Tc2DYRYhBJs7r1HfYU5fgiMM=;
        b=PUJQzpX1L5MHBjCRNFV3QiwPZ/zYbzQx2plMuCIlT9MJdClS5hCJXc3om27X3QM8vJ
         iZmZCbYvDBeMHr9Dad+Zf8eft5KUSyzTFCdIk6McNiAZY7OQVFH0UpF1RZTXVhfoYdqO
         16HLowVqxU4OF3lr5Q5i4dMUJMyiOFUiWf4ltyhPS785dUqCN+t6TN6+3rguZ0ZU+JUf
         j6gpGsoP094Zxg+ra2HDW/ml1JkQMtj2DfgmWP71Xe3xjw5ZJuPpn2DJESR0jTMHUVtM
         USEar4Kp4wEvfdIhbNV1EO7IsW/D+AB/UumoozbuL4VxZs+16j/5qUX6h+qoZr+bjdom
         pVJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yH97LH6OluVceBz+lo8Tc2DYRYhBJs7r1HfYU5fgiMM=;
        b=3dRFi4kyB9K9JQaNwyEKTDqIb2z4oiiB/YJ4B30YI/QLZgxpiFKwOYeVl5UGblMJeh
         xPTD+2oM4s9c82qByR72N+uTYOPp5KB13tVjZgLxUGMNjdZAbJ6aDiMfYCf+uoO9sI6g
         cGBa7ggwoWZ59Eoan2yh8y+sjXNTyyaNhfg97XpHHWdCdbrIhuTe2JyYBJaoymSDJlF+
         rGIgzoJ5yCOfwoYp1Y/D7XyKwV8OFpeDz4/6191zTjl7nd37KhfgvDrWQW3A+AwLNOgG
         pb/lsN0X0Q2qW6mNPHqCfoSPzl76S/8UTYKFKiC5o70vwNfpmd02FiIJ02pJa1VUNed7
         NXmw==
X-Gm-Message-State: ACrzQf3gUFPkxMkcJNid7DRitBqzZPffCEx0QEz0Uvqa2YcW74H1BBOF
        ezShSi8yBiapOK1tU39RsHbb8JmE+gP5TA==
X-Google-Smtp-Source: AMsMyM5/nkY8JBteJI2v6nsRa35Ja7bWNmhNrpla1COzLCDrnqExCWWWCtTBxYpaXcO9+jF21jgaAA==
X-Received: by 2002:a17:90b:1644:b0:20b:aa58:125c with SMTP id il4-20020a17090b164400b0020baa58125cmr277507pjb.110.1666049497617;
        Mon, 17 Oct 2022 16:31:37 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id q59-20020a17090a1b4100b001efa9e83927sm9939371pjq.51.2022.10.17.16.31.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Oct 2022 16:31:36 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     drivers@pensando.io, Brett Creeley <brett@pensando.io>,
        Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net] ionic: catch NULL pointer issue on reconfig
Date:   Mon, 17 Oct 2022 16:31:23 -0700
Message-Id: <20221017233123.15869-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett@pensando.io>

It's possible that the driver will dereference a qcq that doesn't exist
when calling ionic_reconfigure_queues(), which causes a page fault BUG.

If a reduction in the number of queues is followed by a different
reconfig such as changing the ring size, the driver can hit a NULL
pointer when trying to clean up non-existent queues.

Fix this by checking to make sure both the qcqs array and qcq entry
exists bofore trying to use and free the entry.

Fixes: 101b40a0171f ("ionic: change queue count with no reset")
Signed-off-by: Brett Creeley <brett@pensando.io>
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 5d58fd99be3c..19d4848df17d 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -2817,11 +2817,15 @@ int ionic_reconfigure_queues(struct ionic_lif *lif,
 	 * than the full array, but leave the qcq shells in place
 	 */
 	for (i = lif->nxqs; i < lif->ionic->ntxqs_per_lif; i++) {
-		lif->txqcqs[i]->flags &= ~IONIC_QCQ_F_INTR;
-		ionic_qcq_free(lif, lif->txqcqs[i]);
+		if (lif->txqcqs && lif->txqcqs[i]) {
+			lif->txqcqs[i]->flags &= ~IONIC_QCQ_F_INTR;
+			ionic_qcq_free(lif, lif->txqcqs[i]);
+		}
 
-		lif->rxqcqs[i]->flags &= ~IONIC_QCQ_F_INTR;
-		ionic_qcq_free(lif, lif->rxqcqs[i]);
+		if (lif->rxqcqs && lif->rxqcqs[i]) {
+			lif->rxqcqs[i]->flags &= ~IONIC_QCQ_F_INTR;
+			ionic_qcq_free(lif, lif->rxqcqs[i]);
+		}
 	}
 
 	if (err)
-- 
2.17.1

