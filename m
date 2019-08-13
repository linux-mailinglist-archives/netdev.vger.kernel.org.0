Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0C238B234
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 10:21:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727720AbfHMIVr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 04:21:47 -0400
Received: from mail-yw1-f65.google.com ([209.85.161.65]:34522 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727029AbfHMIVq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 04:21:46 -0400
Received: by mail-yw1-f65.google.com with SMTP id n126so2089847ywf.1;
        Tue, 13 Aug 2019 01:21:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=N1mXJQ2lz0aRkdfGXRBshymJFFzUA0I3F3Yqy4okoXg=;
        b=sDEC9jOCbIKkPp0TzegpNpxfDvgn3a42c1vLMpmhnxWIHyNjbmMwgWHyyDTY82mWPN
         fO8721aEdAeZ5drLQuJA1NYVUxATnefwB+hfr504cxnUN4ygJUbhzZJfF7A0J/FV7wxM
         887KrGIWneVFG33Ys7gtaLqRkFGS+fnHUPoko0kKPWM7nQ5s1TDJ3CkwXW9xCQhzI4wx
         BlkK9fd4ZxrcwIpyafUTC6NScwTrLnTBR6FyNGgy90NxXldMgNNBvQ0I6Qk5H/DXZAv/
         9OgpfNgV5E8zIp5Pm3XXM3bnj0NUCCjesBaCZk1TOeVxDLHk81OPidUOnGqzk7v6okTQ
         /aLQ==
X-Gm-Message-State: APjAAAUnEKFfW2Gt3O/nnt07FSz5/orQw1F2KeCuWAGMk3YbtkFEestl
        8nH2yx4R7zcjqGZ6TfiiX9Y=
X-Google-Smtp-Source: APXvYqyPouJgRLPpOk5Cb16OCm+QfPrUGH6hJ02VgOcpRRLNa8WM27qEhatFszW+EAewH5D502r0cQ==
X-Received: by 2002:a81:a34c:: with SMTP id a73mr14295421ywh.379.1565684505739;
        Tue, 13 Aug 2019 01:21:45 -0700 (PDT)
Received: from localhost.localdomain (24-158-240-219.dhcp.smyr.ga.charter.com. [24.158.240.219])
        by smtp.gmail.com with ESMTPSA id z6sm25027153ywg.40.2019.08.13.01.21.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 13 Aug 2019 01:21:44 -0700 (PDT)
From:   Wenwen Wang <wenwen@cs.uga.edu>
To:     Wenwen Wang <wenwen@cs.uga.edu>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org (open list:MELLANOX MLX5 core VPI driver),
        linux-rdma@vger.kernel.org (open list:MELLANOX MLX5 core VPI driver),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] net/mlx5: Fix a memory leak bug
Date:   Tue, 13 Aug 2019 03:21:35 -0500
Message-Id: <1565684495-2454-1-git-send-email-wenwen@cs.uga.edu>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In mlx5_cmd_invoke(), 'ent' is allocated through kzalloc() in alloc_cmd().
After the work is queued, wait_func() is invoked to wait the completion of
the work. If wait_func() returns -ETIMEDOUT, the following execution will
be terminated. However, the allocated 'ent' is not deallocated on this
program path, leading to a memory leak bug.

To fix the above issue, free 'ent' before returning the error.

Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index 8cdd7e6..90cdb9a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -1036,7 +1036,7 @@ static int mlx5_cmd_invoke(struct mlx5_core_dev *dev, struct mlx5_cmd_msg *in,
 
 	err = wait_func(dev, ent);
 	if (err == -ETIMEDOUT)
-		goto out;
+		goto out_free;
 
 	ds = ent->ts2 - ent->ts1;
 	op = MLX5_GET(mbox_in, in->first.data, opcode);
-- 
2.7.4

