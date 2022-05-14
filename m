Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A606526F2E
	for <lists+netdev@lfdr.de>; Sat, 14 May 2022 09:15:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231861AbiENFHM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 May 2022 01:07:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231895AbiENFHH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 May 2022 01:07:07 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B8CB1E3DE;
        Fri, 13 May 2022 22:07:01 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id a191so9296988pge.2;
        Fri, 13 May 2022 22:07:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SigB9f11EQfIOAqP2aQrKOQCd2JCoLuTputr/km7CW0=;
        b=Qb6PzWSD6BuR82XISVRMtcdvCzQZ1VMW4t4d+0nM2ufAUl7Y63XsVv3hsRGfV3iCNJ
         0OUvHnysHxgwRCbEVdTcNv7FTDEkg9Mn5YPqkJdD+Olcl7o2CmgWSOk7nwjYdH+drevk
         wfCmP0wJGVn6WQEe5znJdNn9IgQZENnU8YfcUIN0bsPQFbp2E1eXVaZsLbSbIjSl7nYH
         ImqPDoscQqugkktTg1w4/E/DaVur7QidvlLTjafdV8eHBElFX0KEw/5iYxSaNzJZZ6wi
         krcalwFV+pJyrMVWKCdsQKIqoT5yykr8y7/9vBA5dCR3utnQpwJfbt306S60B21+vzZF
         Flmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SigB9f11EQfIOAqP2aQrKOQCd2JCoLuTputr/km7CW0=;
        b=sxcnlJ1qDO1aqYnjkyJmT4rK2MmYl0/ytpt/qXJTDHLrkU2r3UPH7kRErrKqqxPePX
         sEtT0MGQHbBbh0+F1aalhAP1/jenejtgJfJsOLJf5PVp0Kpv1MbujaaJlCJIEwbqFks4
         dj2pii15uiTIFL2rW0XCrSvNaY+kLSJ+kUmF5Dou4kz66V0z38kuk2PHX4NKIsu6bzxV
         K3rkvKH62Xh67zn/qyyNMasClD2T1FMP9FBwBAs/1X1PaTNdWU9jEXvlEBde7rIavA2p
         MYZ2CHlnY+sxa87nBirKqppk59CcUwWp8Z2oDgKkKmwhRs94b7TIQxcNzxXlmI+0dXT7
         2kaA==
X-Gm-Message-State: AOAM533sDZwalbKjHyp5V0QY+8+og5mOh9yyyCf6Fbnr5vBd9M3/SN7x
        JXmZv1Y1xD02NqsHLn6iUcU=
X-Google-Smtp-Source: ABdhPJwGyVdMZrWjNIi5gD65sgzkRCJAbhfnCVwW3hNvWQ2iiAOJuJ2u7z76xGKin75e8R0xe62leA==
X-Received: by 2002:a05:6a00:8cb:b0:510:9ec4:8f85 with SMTP id s11-20020a056a0008cb00b005109ec48f85mr7824277pfu.24.1652504820567;
        Fri, 13 May 2022 22:07:00 -0700 (PDT)
Received: from localhost ([166.111.139.123])
        by smtp.gmail.com with ESMTPSA id m9-20020a17090a7f8900b001cd4989fee6sm4387518pjl.50.2022.05.13.22.06.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 May 2022 22:07:00 -0700 (PDT)
From:   Zixuan Fu <r33s3n6@gmail.com>
To:     doshir@vmware.com, pv-drivers@vmware.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        baijiaju1990@gmail.com, Zixuan Fu <r33s3n6@gmail.com>,
        TOTE Robot <oslab@tsinghua.edu.cn>
Subject: [PATCH v3] net: vmxnet3: fix possible use-after-free bugs in vmxnet3_rq_alloc_rx_buf()
Date:   Sat, 14 May 2022 13:06:56 +0800
Message-Id: <20220514050656.2636588-1-r33s3n6@gmail.com>
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

Fixes: 5738a09d58d5a ("vmxnet3: fix checks for dma mapping errors")
Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Zixuan Fu <r33s3n6@gmail.com>
---
v2:
* Free and clear pointers right after freeing them.
  Thank Jakub Kicinski for helpful advice.
---
v3:
* Change targeting tree and add Fixes tag.
  Thank Paolo Abeni for helpful advice.
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

