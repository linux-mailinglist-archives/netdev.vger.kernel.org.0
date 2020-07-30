Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0844D233066
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 12:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728880AbgG3Ka3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 06:30:29 -0400
Received: from mail.fudan.edu.cn ([202.120.224.73]:36992 "EHLO fudan.edu.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725892AbgG3Ka2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jul 2020 06:30:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fudan.edu.cn; s=dkim; h=Received:From:To:Cc:Subject:Date:
        Message-Id:MIME-Version:Content-Transfer-Encoding; bh=YGeAc6Wc56
        nAYNAcYe8hVIlpE0CdSjlL19b3AqomqcY=; b=JslT8cGb/VHBVQv9qxu+d4+OXK
        qyWG8oe/foQnMOklextsOh57TG1OuRq+FeCS4JLlTNMkY8WxFdFA76QKUKzcM0aR
        MvI3wJhgtjgiuDi9ypxvrfaHxF21pXKQ+1V2+lRqwBoteL1JHHXxYvfkqvGVfkoR
        5/fHbSo0YvJhQwweQ=
Received: from xin-virtual-machine (unknown [111.192.143.50])
        by app2 (Coremail) with SMTP id XQUFCgD3_zMnoSJfM9KfAg--.21996S3;
        Thu, 30 Jul 2020 18:30:00 +0800 (CST)
From:   Xin Xiong <xiongx18@fudan.edu.cn>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        KP Singh <kpsingh@chromium.org>,
        Tariq Toukan <tariqt@mellanox.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     yuanxzhang@fudan.edu.cn, Xin Xiong <xiongx18@fudan.edu.cn>,
        Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>
Subject: [PATCH v2] net/mlx5e: fix bpf_prog reference count leaks in mlx5e_alloc_rq
Date:   Thu, 30 Jul 2020 18:29:41 +0800
Message-Id: <20200730102941.5536-1-xiongx18@fudan.edu.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: XQUFCgD3_zMnoSJfM9KfAg--.21996S3
X-Coremail-Antispam: 1UD129KBjvJXoW7AF1DCFy8JF1rJw1rXF1rCrg_yoW8Cr1kpr
        47Wr9FkFZ5JFyUJw4DAaykXa4Fka90y3WDWF1Fvw4fXrs8AFs5AFyFgry7uF1UGFW8Gw1j
        qw429ws8AFn5AFUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUB014x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
        JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
        CE3s1lnxkEFVAIw20F6cxK64vIFxWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xv
        F2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r
        4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I
        648v4I1lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc2xSY4AK67AK6r4DMxAIw28IcxkI7VAKI4
        8JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xv
        wVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVW8ZVWrXwCIc40Y0x0EwIxGrwCI42IY6xIIjx
        v20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20E
        Y4v20xvaj40_WFyUJVCq3wCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I
        0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUO5r4UUUUU
X-CM-SenderInfo: arytiiqsuqiimz6i3vldqovvfxof0/
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The function invokes bpf_prog_inc(), which increases the reference
count of a bpf_prog object "rq->xdp_prog" if the object isn't NULL.

The refcount leak issues take place in two error handling paths. When
either mlx5_wq_ll_create() or mlx5_wq_cyc_create() fails, the function
simply returns the error code and forgets to drop the reference count
increased earlier, causing a reference count leak of "rq->xdp_prog".

Fix this issue by jumping to the error handling path err_rq_wq_destroy
while either function fails.

Fixes: 422d4c401edd ("net/mlx5e: RX, Split WQ objects for different RQ
types")

Signed-off-by: Xin Xiong <xiongx18@fudan.edu.cn>
Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
---
v1 -> v2:
- Amended parts of wording to be better understood
- Added Fixes tag
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index a836a02a2116..8e1b1ab416d8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -419,7 +419,7 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
 		err = mlx5_wq_ll_create(mdev, &rqp->wq, rqc_wq, &rq->mpwqe.wq,
 					&rq->wq_ctrl);
 		if (err)
-			return err;
+			goto err_rq_wq_destroy;
 
 		rq->mpwqe.wq.db = &rq->mpwqe.wq.db[MLX5_RCV_DBR];
 
@@ -470,7 +470,7 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
 		err = mlx5_wq_cyc_create(mdev, &rqp->wq, rqc_wq, &rq->wqe.wq,
 					 &rq->wq_ctrl);
 		if (err)
-			return err;
+			goto err_rq_wq_destroy;
 
 		rq->wqe.wq.db = &rq->wqe.wq.db[MLX5_RCV_DBR];
 
-- 
2.25.1

