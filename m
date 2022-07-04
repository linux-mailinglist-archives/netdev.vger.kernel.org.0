Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B1FB56501F
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 10:58:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232960AbiGDI6C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 04:58:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230499AbiGDI6A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 04:58:00 -0400
Received: from out30-44.freemail.mail.aliyun.com (out30-44.freemail.mail.aliyun.com [115.124.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06B85BCBC;
        Mon,  4 Jul 2022 01:57:57 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046050;MF=mqaio@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0VIJ0-QK_1656925073;
Received: from localhost(mailfrom:mqaio@linux.alibaba.com fp:SMTPD_---0VIJ0-QK_1656925073)
          by smtp.aliyun-inc.com;
          Mon, 04 Jul 2022 16:57:54 +0800
From:   Qiao Ma <mqaio@linux.alibaba.com>
To:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        kuba@kernel.org, gustavoars@kernel.org, cai.huoqing@linux.dev,
        aviad.krawczyk@huawei.com, zhaochen6@huawei.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 0/3] net: hinic: fix three bugs about dev_get_stats 
Date:   Mon,  4 Jul 2022 16:57:43 +0800
Message-Id: <cover.1656921519.git.mqaio@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These patches fixes 3 bugs of hinic driver:
- fix bug that ethtool get wrong stats because of hinic_{txq|rxq}_clean_stats() is called
- avoid kernel hung in hinic_get_stats64() 
- fix bug that u64_stats_sync is not initialized

See every patch for more information. 

Changes in v2:
- fixes another 2 bugs. (v1 is a single patch, see: https://lore.kernel.org/all/07736c2b7019b6883076a06129e06e8f7c5f7154.1656487154.git.mqaio@linux.alibaba.com/).
- to fix extra bugs, hinic_dev.tx_stats/rx_stats is removed, so there is no need to use spinlock or semaphore now. 

Qiao Ma (3):
  net: hinic: fix bug that ethtool get wrong stats
  net: hinic: avoid kernel hung in hinic_get_stats64()
  net: hinic: fix bug that u64_stats_sync is not initialized

 drivers/net/ethernet/huawei/hinic/hinic_dev.h     |  3 --
 drivers/net/ethernet/huawei/hinic/hinic_ethtool.c |  3 ++
 drivers/net/ethernet/huawei/hinic/hinic_main.c    | 56 ++++++++---------------
 3 files changed, 21 insertions(+), 41 deletions(-)

-- 
1.8.3.1

