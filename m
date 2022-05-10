Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8D2252175B
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 15:21:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242997AbiEJNZU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 09:25:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243041AbiEJNXn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 09:23:43 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCF631CEEC7;
        Tue, 10 May 2022 06:17:22 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id i1so16708909plg.7;
        Tue, 10 May 2022 06:17:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PL7sPaFj+QCRve6dBe9Fauw5svHYwmbiQnm9OKBKRhw=;
        b=apT2Ehr+H+5fTQGrpJioLeqa8vOoglU48+tiko2np7d9DQ51eLzs7sKoFarSsUOQpM
         NxyGfKGfhhfJFAo1YvY5j3dE6cQeEmbuFM2Qz0Oj5zjXsY0EIi5INWu+VrzqgTWgwHRI
         04EGSwGLJRlFsje55BtnuHorXGoL3pkdr2w/C7Dgv+NmtQ4z/I4OORNLPYhAeY1s5Jtx
         YsZvGyUtR62KhIaLBNXFJ8KTjTOmpjJakv0iaouAN2Lnx7ra2QxExME+R6TQAfKQEVjj
         /u3Arnit11noQyA5VKfh1jMbpytpEfyAZ/yj7ckbeNhfu8C3Dxa5ns49en0Ufac8H+tU
         rYtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PL7sPaFj+QCRve6dBe9Fauw5svHYwmbiQnm9OKBKRhw=;
        b=f+K/xPN9fKkd1F8Ca/7cmhUhnV09el9t0VKm17/DnSsfr5PRccHSMAM6B9gsVekSpt
         kxExnJlOYtgqNaLEszbtwZ9nPP2Mni1Es4ov2deDDA4pO+JqqREe5RamjyyTQg5c3mPs
         WvaFCC+gzaJShH6m4q0q/5jmrZR2+bH3LnLLHCwo3SFDeKS+/MCCQV/8yhIMY39zXYAo
         eXvkWBdHfOza5lGQLDDrhbtBMT1pygsWTHKXL1YAYkTeUYua77q+BLihJFkaBwkixyeW
         frpzXzC9IF9NAKuXPhr+AN0n/CkviZvJ2dsYNkSdB7vUzIPtFGxKiLchxmHyDtIFo+ho
         o4Ig==
X-Gm-Message-State: AOAM533TDeUO3sDqhddVrM/aAnX34o6WO4IYA71MItAdoBkJkG55Z8OR
        YXGpjVBuxNmDLmC4JpnK9F0=
X-Google-Smtp-Source: ABdhPJx4uVD7n3Qfbq8IHmn2O0S1T1vXYyKJqgceZeBor9rVT7A8gOKft6R+2T494SBGh2vFlvrcwA==
X-Received: by 2002:a17:902:bb92:b0:153:4eae:c77e with SMTP id m18-20020a170902bb9200b001534eaec77emr20558762pls.93.1652188641953;
        Tue, 10 May 2022 06:17:21 -0700 (PDT)
Received: from localhost ([166.111.139.123])
        by smtp.gmail.com with ESMTPSA id d8-20020a170902654800b0015f2b3bc97asm1133455pln.13.2022.05.10.06.17.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 May 2022 06:17:21 -0700 (PDT)
From:   Zixuan Fu <r33s3n6@gmail.com>
To:     doshir@vmware.com, pv-drivers@vmware.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        baijiaju1990@gmail.com, Zixuan Fu <r33s3n6@gmail.com>,
        TOTE Robot <oslab@tsinghua.edu.cn>
Subject: [PATCH v2] drivers: net: vmxnet3: fix possible use-after-free bugs in vmxnet3_rq_alloc_rx_buf()
Date:   Tue, 10 May 2022 21:17:16 +0800
Message-Id: <20220510131716.929387-1-r33s3n6@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In vmxnet3_rq_alloc_rx_buf(), when dma_map_single() fails, rbi->skb is
freed immediately. Similarly, in another branch, when dma_map_page() fails,
rbi->page is also freed. In the two cases, vmxnet3_rq_alloc_rx_buf()
returns an error to its callers vmxnet3_rq_init() -> vmxnet3_rq_init_all()
-> vmxnet3_activate_dev(). Then vmxnet3_activate_dev() calls
vmxnet3_rq_cleanup_all() in error handling code, and rbi->skb or rbi->page
are freed again in vmxnet3_rq_cleanup_all(), causing use-after-free bugs.

To fix these possible bugs, rbi->skb and rbi->page should be cleared after
they are freed.

The error log in our fault-injection testing is shown as follows:

[   14.319016] BUG: KASAN: use-after-free in consume_skb+0x2f/0x150
...
[   14.321586] Call Trace:
...
[   14.325357]  consume_skb+0x2f/0x150
[   14.325671]  vmxnet3_rq_cleanup_all+0x33a/0x4e0 [vmxnet3]
[   14.326150]  vmxnet3_activate_dev+0xb9d/0x2ca0 [vmxnet3]
[   14.326616]  vmxnet3_open+0x387/0x470 [vmxnet3]
...
[   14.361675] Allocated by task 351:
...
[   14.362688]  __netdev_alloc_skb+0x1b3/0x6f0
[   14.362960]  vmxnet3_rq_alloc_rx_buf+0x1b0/0x8d0 [vmxnet3]
[   14.363317]  vmxnet3_activate_dev+0x3e3/0x2ca0 [vmxnet3]
[   14.363661]  vmxnet3_open+0x387/0x470 [vmxnet3]
...
[   14.367309] 
[   14.367412] Freed by task 351:
...
[   14.368932]  __dev_kfree_skb_any+0xd2/0xe0
[   14.369193]  vmxnet3_rq_alloc_rx_buf+0x71e/0x8d0 [vmxnet3]
[   14.369544]  vmxnet3_activate_dev+0x3e3/0x2ca0 [vmxnet3]
[   14.369883]  vmxnet3_open+0x387/0x470 [vmxnet3]
[   14.370174]  __dev_open+0x28a/0x420
[   14.370399]  __dev_change_flags+0x192/0x590
[   14.370667]  dev_change_flags+0x7a/0x180
[   14.370919]  do_setlink+0xb28/0x3570
[   14.371150]  rtnl_newlink+0x1160/0x1740
[   14.371399]  rtnetlink_rcv_msg+0x5bf/0xa50
[   14.371661]  netlink_rcv_skb+0x1cd/0x3e0
[   14.371913]  netlink_unicast+0x5dc/0x840
[   14.372169]  netlink_sendmsg+0x856/0xc40
[   14.372420]  ____sys_sendmsg+0x8a7/0x8d0
[   14.372673]  __sys_sendmsg+0x1c2/0x270
[   14.372914]  do_syscall_64+0x41/0x90
[   14.373145]  entry_SYSCALL_64_after_hwframe+0x44/0xae
...

Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Zixuan Fu <r33s3n6@gmail.com>
---
v2:
* Free and clear pointers right after freeing them.
  Thank Jakub Kicinski for helpful advice.
---
 drivers/net/vmxnet3/vmxnet3_drv.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index d9d90baac72a..1154f1884212 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -589,6 +589,7 @@ vmxnet3_rq_alloc_rx_buf(struct vmxnet3_rx_queue *rq, u32 ring_idx,
 				if (dma_mapping_error(&adapter->pdev->dev,
 						      rbi->dma_addr)) {
 					dev_kfree_skb_any(rbi->skb);
+					rbi->skb = NULL;
 					rq->stats.rx_buf_alloc_failure++;
 					break;
 				}
@@ -613,6 +614,7 @@ vmxnet3_rq_alloc_rx_buf(struct vmxnet3_rx_queue *rq, u32 ring_idx,
 				if (dma_mapping_error(&adapter->pdev->dev,
 						      rbi->dma_addr)) {
 					put_page(rbi->page);
+					rbi->page = NULL;
 					rq->stats.rx_buf_alloc_failure++;
 					break;
 				}
-- 
2.25.1

