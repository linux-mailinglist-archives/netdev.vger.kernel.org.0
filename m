Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A347F51D7D5
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 14:31:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392020AbiEFMfV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 08:35:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391989AbiEFMfQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 08:35:16 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC44468FA2;
        Fri,  6 May 2022 05:31:33 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id 15so5999748pgf.4;
        Fri, 06 May 2022 05:31:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OR0QudyXd7dTFMqBDM0iNZWHvsdf7jzrh9EtBnlpCOw=;
        b=AI+UjqJoYuIsWWkqQoenZbhZ9MYH6/qKQpuUORvT1O4a8UboDS5gCKeVoM74KkjsbG
         ZQrKGWOn5iWbzcL3qvwJSKH9JbLXFpg7bbIUHxN8kQf+z5oLE/BjaZQ83TCP3pq88zsK
         cxQMZglmNAJQ5Rmowy9ZcKViuWiHx8mIXtIMPTKhuXpOgwqs5dm6cA8J1wYc/ikQDx23
         I5+i0m1G0S9SYGy03qGjOR2IeYLKksKfS3NtSCN3ryhG4rKvm2Su5QCmJWguFhrh3/QK
         z8PPSJXXX78HD0w4N2SvD32ufgT04IkCgyEFi+YuY2s7Wp5nFgMmQSUewz6EdiOyNNzJ
         52ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OR0QudyXd7dTFMqBDM0iNZWHvsdf7jzrh9EtBnlpCOw=;
        b=fjzg0yuhMZA5Vvn/PqpKyVQ7mCBXPMKIJHhWNts8vl994VEBQY7FlWBn7/05QTCS40
         0IdhtITOVUorK4AmqvqU5C4Keq2lRbfERVqKWQUYVrOSK5vsTFe8bEbSRgebet1bKiuS
         y5rvohhuVwC7koyG65K7K0uHOJbotbTuvJhWsx4IQ8qjwuGPOq7kH+EA4WDH0hb8snXY
         Sp9UdYpibbiahEC6mDG3UFFomdX3jPycmZd+30n9ad81L8Os6z7ucLEcDCbNgdB7N57q
         3AeHxad3sGQBiuG20lg5btETaT2YpmuwR2d+dMzVWdRahVFc+Lf9iQ1zuGzEfu5wrK7g
         1IcQ==
X-Gm-Message-State: AOAM531wlPH8hXr40wPWuwOGRgSkx6kbmKRa9BPlj9VggJfSmnIhShdf
        rBk1a9WUjwjHxlq9MQOJnao=
X-Google-Smtp-Source: ABdhPJz5P32nOVPmiNkHlZ/n92+kmj7Qe0NV+h49mZM0O/oOO3OLdYJy9UZg1wWXzlv16xy+pdtZvw==
X-Received: by 2002:a05:6a00:1353:b0:50e:982:6a4f with SMTP id k19-20020a056a00135300b0050e09826a4fmr3361499pfu.50.1651840293245;
        Fri, 06 May 2022 05:31:33 -0700 (PDT)
Received: from localhost ([166.111.139.123])
        by smtp.gmail.com with ESMTPSA id c6-20020a631c06000000b003c66480613esm28980pgc.80.2022.05.06.05.31.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 May 2022 05:31:32 -0700 (PDT)
From:   Zixuan Fu <r33s3n6@gmail.com>
To:     doshir@vmware.com, pv-drivers@vmware.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        baijiaju1990@gmail.com, Zixuan Fu <r33s3n6@gmail.com>,
        TOTE Robot <oslab@tsinghua.edu.cn>
Subject: [PATCH] driver: net: vmxnet3: fix possible use-after-free bugs in vmxnet3_rq_alloc_rx_buf()
Date:   Fri,  6 May 2022 20:31:18 +0800
Message-Id: <20220506123118.2778522-1-r33s3n6@gmail.com>
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

To fix these possible bugs, rbi->skb and rbi->page should not be freed in 
mxnet3_rq_alloc_rx_buf() when dma_map_single() fails.

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
 drivers/net/vmxnet3/vmxnet3_drv.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index d9d90baac72a..f17e9871ba27 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -588,7 +588,6 @@ vmxnet3_rq_alloc_rx_buf(struct vmxnet3_rx_queue *rq, u32 ring_idx,
 						DMA_FROM_DEVICE);
 				if (dma_mapping_error(&adapter->pdev->dev,
 						      rbi->dma_addr)) {
-					dev_kfree_skb_any(rbi->skb);
 					rq->stats.rx_buf_alloc_failure++;
 					break;
 				}
@@ -612,7 +611,6 @@ vmxnet3_rq_alloc_rx_buf(struct vmxnet3_rx_queue *rq, u32 ring_idx,
 						DMA_FROM_DEVICE);
 				if (dma_mapping_error(&adapter->pdev->dev,
 						      rbi->dma_addr)) {
-					put_page(rbi->page);
 					rq->stats.rx_buf_alloc_failure++;
 					break;
 				}
-- 
2.25.1

