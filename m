Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41DA8386BF8
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 23:08:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243835AbhEQVJv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 17:09:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233139AbhEQVJv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 17:09:51 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57551C061573
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 14:08:33 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id g1-20020a25b1010000b02904f93e3a9c89so10891492ybj.23
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 14:08:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=v50cSGZjEdsoPCARPew+NjJwnmy64NtedgjImvVVP1M=;
        b=jZ+eJXrM7I3PA1LGhXm6Dy+GyKWNd/BMlkevqVlVYZBdDGiKOp7Y2lS6sO9XjW4Rtr
         DC2hgKwvo95oVnoVeJri+ozwf/M7VbqRnZ35R+SAqmGG/VGm7YpZKkWZv3Oj/qGKkFL/
         J+jli4SMVDE4IIZOxQQ71XuRhE5guRBOHdaB+Ix69IGUvJs65bUE5Rs5xbYF4T8OjJzz
         rAa0AWRxdYsljOyeFM69NIfcn86IxKMQOJz+vVRNh7OsIs5SQ20XG0qg+YjVQeDo5x0M
         o2SjGSWRkFBntlojiEbWJ1QTwOwyJiVkmdbN0f2sfaUh5qbl30uPoICxWSrcTWpCrwNy
         g7Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=v50cSGZjEdsoPCARPew+NjJwnmy64NtedgjImvVVP1M=;
        b=LvSOHyIVHXhuDMLhC5aI0RkM0z/YWIjySeERnzWK6agZF7Hb/lWMnt2rrWk662k5DZ
         C/3JxuMeCabmf8dxh/lvLSiideJJ1aUKAkCN7FTFFhgGu/NoBTvQyIPF+5TEDYwZUATN
         PVic6fNmvMqqWa8yDWYlNiMlzXCDiO1TFcBkyC3g7BluwR0NbH/NRO9Q4p/7fNc7NQsh
         1NSriAaU5g9T/BwcZyobkreC3A82c6vGaONg7kOVmzpPwDsvxGGZFiitPWmue8E7eZb7
         X53vt/5eFHicB6cHfoqzQkNBETbF+/T//UVgjzV5v4HBJk8dW3kTI8YJ6+ko0FxMQruy
         Iwww==
X-Gm-Message-State: AOAM532NPS16NHHqk2M+2QWc9uJpCZDH69xNmULDNhfW0lEi1TOe5RIp
        t/LNorPZb/UtaTg1b2mxX7RhK+HzVYwZHD18GmE9vpc36PwTfvR3X8XXqRupAtPLR9r7mRvfxv0
        pqi+HyxVHOCcjJKYdjIT3gWj4P4VsgoimZzR2UPO623pnsAaJ/P4bRK+SADtq4PcdrzUK+whB
X-Google-Smtp-Source: ABdhPJzqaPoJMxDJjA7Tgo4d9rSPGHK3EMyVYitzpmrx9QMl72anqaGRbNZezTQwD+SqRT2S+RqwwAhLrjzd6pKU
X-Received: from awogbemila.sea.corp.google.com ([2620:15c:100:202:ba72:1464:177a:c6d4])
 (user=awogbemila job=sendgmr) by 2002:a25:1dd6:: with SMTP id
 d205mr2705035ybd.355.1621285712519; Mon, 17 May 2021 14:08:32 -0700 (PDT)
Date:   Mon, 17 May 2021 14:08:11 -0700
In-Reply-To: <20210517210815.3751286-1-awogbemila@google.com>
Message-Id: <20210517210815.3751286-2-awogbemila@google.com>
Mime-Version: 1.0
References: <20210517210815.3751286-1-awogbemila@google.com>
X-Mailer: git-send-email 2.31.1.751.gd2f1c929bd-goog
Subject: [PATCH net 1/5] gve: Check TX QPL was actually assigned
From:   David Awogbemila <awogbemila@google.com>
To:     netdev@vger.kernel.org
Cc:     Catherine Sullivan <csully@google.com>,
        David Awogbemila <awogbemila@google.com>,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Catherine Sullivan <csully@google.com>

Correctly check the TX QPL was assigned and unassigned if
other steps in the allocation fail.

Fixes: f5cedc84a30d (gve: Add transmit and receive support)
Signed-off-by: Catherine Sullivan <csully@google.com>
Signed-off-by: David Awogbemila <awogbemila@google.com>
Acked-by: Willem de Bruijn <willemb@google.com>
---
 drivers/net/ethernet/google/gve/gve_tx.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve_tx.c b/drivers/net/ethernet/google/gve/gve_tx.c
index 6938f3a939d6..bb57c42872b4 100644
--- a/drivers/net/ethernet/google/gve/gve_tx.c
+++ b/drivers/net/ethernet/google/gve/gve_tx.c
@@ -212,10 +212,11 @@ static int gve_tx_alloc_ring(struct gve_priv *priv, int idx)
 	tx->dev = &priv->pdev->dev;
 	if (!tx->raw_addressing) {
 		tx->tx_fifo.qpl = gve_assign_tx_qpl(priv);
-
+		if (!tx->tx_fifo.qpl)
+			goto abort_with_desc;
 		/* map Tx FIFO */
 		if (gve_tx_fifo_init(priv, &tx->tx_fifo))
-			goto abort_with_desc;
+			goto abort_with_qpl;
 	}
 
 	tx->q_resources =
@@ -236,6 +237,9 @@ static int gve_tx_alloc_ring(struct gve_priv *priv, int idx)
 abort_with_fifo:
 	if (!tx->raw_addressing)
 		gve_tx_fifo_release(priv, &tx->tx_fifo);
+abort_with_qpl:
+	if (!tx->raw_addressing)
+		gve_unassign_qpl(priv, tx->tx_fifo.qpl->id);
 abort_with_desc:
 	dma_free_coherent(hdev, bytes, tx->desc, tx->bus);
 	tx->desc = NULL;
-- 
2.31.1.751.gd2f1c929bd-goog

