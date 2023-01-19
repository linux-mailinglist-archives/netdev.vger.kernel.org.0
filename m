Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE2D467384D
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 13:25:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbjASMZe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 07:25:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbjASMZc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 07:25:32 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4138C1BE7;
        Thu, 19 Jan 2023 04:25:29 -0800 (PST)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NyMHj1KtJzJrDy;
        Thu, 19 Jan 2023 20:24:01 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 19 Jan
 2023 20:24:53 +0800
From:   Yunsheng Lin <linyunsheng@huawei.com>
Subject: Question about ordering between cq polling and notifying hw
To:     <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>, <xuhaoyue1@hisilicon.com>,
        "liyangyang20@huawei.com" <liyangyang20@huawei.com>,
        <will@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Message-ID: <0b411583-72f8-54c1-dc48-c270e1ed8ac7@huawei.com>
Date:   Thu, 19 Jan 2023 20:24:53 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, ALL
   After polling cq, usually the driver need to notify the hw with new ci.
When I look through the drivers implementing the cq polling and using record
db[1], there seems to be no memory barrier between parsing the valid cqe and
notifying the hw with new ci:

For ib mlx5 driver, it always use the record db to notify the hw and there
is no memory barrier parsing the valid cqe and notifying the hw with new ci:
https://elixir.bootlin.com/linux/v6.2-rc4/source/drivers/infiniband/hw/mlx5/cq.c#L637

For ib hns driver, it supports both record db and normal db, and there is
memory barrier when using writeq to ring the normal db, but it does not
have memory barrier for record db:
https://elixir.bootlin.com/linux/v6.2-rc4/source/drivers/infiniband/hw/hns/hns_roce_hw_v2.c#L4136

For ethernet mlx5 driver, for the tx cq polling, It does have a memory
barrier, but it is placed after notifying the hw with new ci, not between
parsing the valid cqe and notifying the hw with new ci:
https://elixir.bootlin.com/linux/v6.2-rc4/source/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c#L872

Do we need to ensure ordering betwwen parsing the valid cqe and notifying
the hw with new ci? If there is no ordering, will the recodering cause the
cpu to notify the hw with new ci before parsing the last valid cqe, casuing
the hw writing the same cqe while the driver is parsing it?


For ethernet mlx5 driver, even there is a comment above the wmb() barrier,
I am not sure I understand what ordering does the memory barrier enforce
and why that ordering is needed:

bool mlx5e_poll_tx_cq(struct mlx5e_cq *cq, int napi_budget)
{
	......................
        parsing the valid cqe
	......................


	mlx5_cqwq_update_db_record(&cq->wq);

	/* ensure cq space is freed before enabling more cqes */
	wmb();

	sq->dma_fifo_cc = dma_fifo_cc;
	sq->cc = sqcc;

	netdev_tx_completed_queue(sq->txq, npkts, nbytes);

	if (netif_tx_queue_stopped(sq->txq) &&
	    mlx5e_wqc_has_room_for(&sq->wq, sq->cc, sq->pc, sq->stop_room) &&
	    mlx5e_ptpsq_fifo_has_room(sq) &&
	    !test_bit(MLX5E_SQ_STATE_RECOVERING, &sq->state)) {
		netif_tx_wake_queue(sq->txq);
		stats->wake++;
	}

	return (i == MLX5E_TX_CQ_POLL_BUDGET);
}


1. Doorbell records are located in physical memory. The address of DoorBell record
   is passed to the HW at RQ/SQ creation. see:
https://network.nvidia.com/files/doc-2020/ethernet-adapters-programming-manual.pdf
