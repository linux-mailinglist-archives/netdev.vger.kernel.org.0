Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 466C2660CC4
	for <lists+netdev@lfdr.de>; Sat,  7 Jan 2023 08:34:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbjAGHev (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Jan 2023 02:34:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjAGHet (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Jan 2023 02:34:49 -0500
X-Greylist: delayed 415 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 06 Jan 2023 23:34:46 PST
Received: from mail-m11880.qiye.163.com (mail-m11880.qiye.163.com [115.236.118.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7AE47CBE5;
        Fri,  6 Jan 2023 23:34:46 -0800 (PST)
Received: from caicai-HWPC.. (unknown [IPV6:240e:36a:145d:dd00:75ba:b6bd:3f9b:b978])
        by mail-m11880.qiye.163.com (Hmail) with ESMTPA id E560C2020C;
        Sat,  7 Jan 2023 15:27:44 +0800 (CST)
From:   Yupeng Li <liyupeng@zbhlos.com>
To:     tariqt@nvidia.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yupeng Li <liyupeng@zbhlos.com>,
        Caicai <caizp2008@163.com>
Subject: [PATCH 1/1] net/mlx4: Fix build error use array_size() helper in copy_to_user()
Date:   Sat,  7 Jan 2023 15:27:25 +0800
Message-Id: <20230107072725.673064-1-liyupeng@zbhlos.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
        tZV1koWUFITzdXWS1ZQUlXWQ8JGhUIEh9ZQVlCSkoYVhpCH09MTksYGU9CTVUTARMWGhIXJBQOD1
        lXWRgSC1lBWUlPSx5BSE0aQUpPTh9BHx9LS0FMThkaQRlNGR9BSB1CGUEZQkxDWVdZFhoPEhUdFF
        lBWU9LSFVKSktPSEhVSktLVUtZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PS46TCo*Gj0aHRY4FB8VLz1O
        OjMaFDhVSlVKTUxIS0xNT01OTkpJVTMWGhIXVRcSAg4LHhUcOwEZExcUCFUYFBZFWVdZEgtZQVlJ
        T0seQUhNGkFKT04fQR8fS0tBTE4ZGkEZTRkfQUgdQhlBGUJMQ1lXWQgBWUFITUtKNwY+
X-HM-Tid: 0a858b20dde52eb6kusne560c2020c
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When CONFIG_64BIT was disabled, check_copy_size() was declared with
attribute error: copy source size is too small, array_size() for 32BIT
was wrong size, some compiled msg with error like:

  CALL    scripts/checksyscalls.sh
  CC [M]  drivers/net/ethernet/mellanox/mlx4/cq.o
In file included from ./arch/x86/include/asm/preempt.h:7,
                 from ./include/linux/preempt.h:78,
                 from ./include/linux/percpu.h:6,
                 from ./include/linux/context_tracking_state.h:5,
                 from ./include/linux/hardirq.h:5,
                 from drivers/net/ethernet/mellanox/mlx4/cq.c:37:
In function ‘check_copy_size’,
    inlined from ‘copy_to_user’ at ./include/linux/uaccess.h:168:6,
    inlined from ‘mlx4_init_user_cqes’ at drivers/net/ethernet/mellanox/mlx4/cq.c:317:9,
    inlined from ‘mlx4_cq_alloc’ at drivers/net/ethernet/mellanox/mlx4/cq.c:394:10:
./include/linux/thread_info.h:228:4: error: call to ‘__bad_copy_from’ declared with attribute error: copy source size is too small
  228 |    __bad_copy_from();
      |    ^~~~~~~~~~~~~~~~~
make[6]: *** [scripts/Makefile.build:250：drivers/net/ethernet/mellanox/mlx4/cq.o] 错误 1
make[5]: *** [scripts/Makefile.build:500：drivers/net/ethernet/mellanox/mlx4] 错误 2
make[5]: *** 正在等待未完成的任务....
make[4]: *** [scripts/Makefile.build:500：drivers/net/ethernet/mellanox] 错误 2
make[3]: *** [scripts/Makefile.build:500：drivers/net/ethernet] 错误 2
make[3]: *** 正在等待未完成的任务....
make[2]: *** [scripts/Makefile.build:500：drivers/net] 错误 2
make[2]: *** 正在等待未完成的任务....
make[1]: *** [scripts/Makefile.build:500：drivers] 错误 2
make: *** [Makefile:1992：.] 错误 2

Signed-off-by: Yupeng Li <liyupeng@zbhlos.com>
Reviewed-by: Caicai <caizp2008@163.com>
---
 drivers/net/ethernet/mellanox/mlx4/cq.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx4/cq.c b/drivers/net/ethernet/mellanox/mlx4/cq.c
index 4d4f9cf9facb..7dadd7227480 100644
--- a/drivers/net/ethernet/mellanox/mlx4/cq.c
+++ b/drivers/net/ethernet/mellanox/mlx4/cq.c
@@ -315,7 +315,11 @@ static int mlx4_init_user_cqes(void *buf, int entries, int cqe_size)
 		}
 	} else {
 		err = copy_to_user((void __user *)buf, init_ents,
+#ifdef CONFIG_64BIT
 				   array_size(entries, cqe_size)) ?
+#else
+				   entries * cqe_size) ?
+#endif
 			-EFAULT : 0;
 	}
 
-- 
2.25.1

