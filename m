Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 028766005D7
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 05:54:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232850AbiJQDw7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Oct 2022 23:52:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232842AbiJQDwz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Oct 2022 23:52:55 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15097520A0
        for <netdev@vger.kernel.org>; Sun, 16 Oct 2022 20:52:54 -0700 (PDT)
Received: from dggpemm500021.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MrNPB5rHwzHvdQ;
        Mon, 17 Oct 2022 11:52:46 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500021.china.huawei.com (7.185.36.109) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 17 Oct 2022 11:52:37 +0800
Received: from huawei.com (10.175.103.91) by dggpemm500007.china.huawei.com
 (7.185.36.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Mon, 17 Oct
 2022 11:52:37 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-mediatek@lists.infradead.org>, <netdev@vger.kernel.org>
CC:     <nbd@nbd.name>, <davem@davemloft.net>
Subject: [PATCH net 0/3] net: ethernet: mtk_eth_wed: fixe some leaks
Date:   Mon, 17 Oct 2022 11:51:53 +0800
Message-ID: <20221017035156.2497448-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I found some leaks in mtk_eth_soc.c/mtk_wed.c.

 patch#1 - I found mtk_wed_exit() is never called, I think mtk_wed_exit() need
           be called in error path or module remove function to free the memory
           allocated in mtk_wed_add_hw().

 patch#2 - The device is not put in error path in mtk_wed_add_hw().

 patch#3 - The device_node pointer returned by of_parse_phandle() with refcount
           incremented, it should be decreased when it done.

This patchset was just compiled tested because I don't have any HW on which to do
the actual tests.

Yang Yingliang (3):
  net: ethernet: mtk_eth_soc: fix possible memory leak in mtk_probe()
  net: ethernet: mtk_eth_wed: add missing put_device() in
    mtk_wed_add_hw()
  net: ethernet: mtk_eth_wed: add missing of_node_put()

 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 17 ++++++++++++-----
 drivers/net/ethernet/mediatek/mtk_wed.c     | 15 ++++++++++++---
 2 files changed, 24 insertions(+), 8 deletions(-)

-- 
2.25.1

