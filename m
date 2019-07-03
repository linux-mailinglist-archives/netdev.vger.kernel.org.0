Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C38A5E518
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 15:16:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727239AbfGCNQC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 09:16:02 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:38813 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726430AbfGCNQC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 09:16:02 -0400
Received: by mail-pf1-f193.google.com with SMTP id y15so1276098pfn.5;
        Wed, 03 Jul 2019 06:16:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=/N6bhv7n5rk1xSnhXzu5sWrDYu3AD9vXv7D2iO8sl+I=;
        b=nADW0EpdVCqFBqlWCB+D3raoOeTtpbpjdsZivyFYxE9wrNuGMroi3Dbdqn+CDkARsC
         HgNko1T8oWX0lCrgtMu/MFM7ZH6G2N1PPGjXoRKXm9RtAq1Mfs1uPZyT4H+dR3a/MWqW
         GRQT+xDeE70u0gO/4HzkvhRUNaEracqrmW9w3ADEAeno/aroPvo0lN+j8onfWXCd5lVn
         4RMKyXahAdY3jomiCTOG/ngNcrxNm5zonJm7kys25w+1oiC/zfMClQcqd908xUhNYoOT
         LFkCKYjSzexFi1ixuZPaRJu40/VK2Q63KXkCrbcYsduuBnTD1Z6Ofy86k+oPnpaqZMOS
         ZMoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=/N6bhv7n5rk1xSnhXzu5sWrDYu3AD9vXv7D2iO8sl+I=;
        b=OCODlUVZ9xXYLCJz/rUppfObwjQrHoKkvtzsGGazmk8OBnjDFYGXPOnc3jBsUR5NSf
         Mi9wLqQQk3Hiy6n4h6Ka0lqLSmXYnzenvd3cHnqJEFBLZy1C6RjTfQ+T3hJgLRya4hfS
         vbOBC1qtyP+qONSpkfIMAjUHhkf3H/vSW52eVcY/WiO4MFIWfWpWAcb5zEl4JDsllxIY
         qR1acat4DfuqpikXKiA5ZjtGe0nQP9QEUOlFQyQ4GgRnh+1wjYsYyyPoVtdnsvpmwxRt
         rarvkH3IFvNYzavenujXHtHmdiC6GuPnPdFiEIMc/UM9lFCvSIxhqlvM2ceacIAH87R/
         CkdQ==
X-Gm-Message-State: APjAAAVIY+tjNVzdUW57PJQyqn7MpXSHGWamCwuZcarEc0dtzUwclZdh
        2DF+Pm6ucMEkOcqIlQ4IKauvRumb3Vw=
X-Google-Smtp-Source: APXvYqwauB2XShUYH/QSH+xCmI/kvQbp5/gZMfeCOo17rCDj5koY6RTu/aIw6+Z1YQUpXnQ202BEcA==
X-Received: by 2002:a17:90a:b104:: with SMTP id z4mr12756193pjq.102.1562159761898;
        Wed, 03 Jul 2019 06:16:01 -0700 (PDT)
Received: from hfq-skylake.ipads-lab.se.sjtu.edu.cn ([202.120.40.82])
        by smtp.googlemail.com with ESMTPSA id u5sm2181765pgp.19.2019.07.03.06.15.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Jul 2019 06:16:00 -0700 (PDT)
From:   Fuqian Huang <huangfq.daxian@gmail.com>
Cc:     Tariq Toukan <tariqt@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        Fuqian Huang <huangfq.daxian@gmail.com>
Subject: [PATCH 14/30] net/ethernet: Use kmemdup rather than duplicating its implementation
Date:   Wed,  3 Jul 2019 21:15:51 +0800
Message-Id: <20190703131551.25316-1-huangfq.daxian@gmail.com>
X-Mailer: git-send-email 2.11.0
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

kmemdup is introduced to duplicate a region of memory in a neat way.
Rather than kmalloc/kzalloc + memset, which the programmer needs to
write the size twice (sometimes lead to mistakes), kmemdup improves
readability, leads to smaller code and also reduce the chances of mistakes.
Suggestion to use kmemdup rather than using kmalloc/kzalloc + memset.

Signed-off-by: Fuqian Huang <huangfq.daxian@gmail.com>
---
 drivers/net/ethernet/mellanox/mlx4/resource_tracker.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c b/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
index 4356f3a58002..e971a6bdf0d5 100644
--- a/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
+++ b/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
@@ -4437,14 +4437,13 @@ int mlx4_QP_FLOW_STEERING_ATTACH_wrapper(struct mlx4_dev *dev, int slave,
 		goto err_detach;
 
 	mbox_size = qp_attach_mbox_size(inbox->buf);
-	rrule->mirr_mbox = kmalloc(mbox_size, GFP_KERNEL);
+	rrule->mirr_mbox = kmemdup(inbox->buf, mbox_size, GFP_KERNEL);
 	if (!rrule->mirr_mbox) {
 		err = -ENOMEM;
 		goto err_put_rule;
 	}
 	rrule->mirr_mbox_size = mbox_size;
 	rrule->mirr_rule_id = 0;
-	memcpy(rrule->mirr_mbox, inbox->buf, mbox_size);
 
 	/* set different port */
 	ctrl = (struct mlx4_net_trans_rule_hw_ctrl *)rrule->mirr_mbox;
-- 
2.11.0

