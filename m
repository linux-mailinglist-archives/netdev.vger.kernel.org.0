Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8A591FA69C
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 05:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726392AbgFPDTx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 23:19:53 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:38562 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726101AbgFPDTx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 23:19:53 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 3B3DD410F4;
        Tue, 16 Jun 2020 11:19:42 +0800 (CST)
From:   wenxu@ucloud.cn
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, pablo@netfilter.org, vladbu@mellanox.com
Subject: [PATCH net v3 0/4] several fixes for indirect flow_blocks offload
Date:   Tue, 16 Jun 2020 11:19:36 +0800
Message-Id: <1592277580-5524-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZSVVIS0hCQkJCS0tDSkxDTFlXWShZQU
        lCN1dZLVlBSVdZDwkaFQgSH1lBWR0iNQs4HD9IHzkhNDQOEx5KMwNOOhxWVlVJQ0soSVlXWQkOFx
        4IWUFZNTQpNjo3JCkuNz5ZV1kWGg8SFR0UWUFZNDBZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MD46MSo5HTg5SjZKAi5CCSsr
        HhpPCSpVSlVKTkJJSUxMTkNJSEpJVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUhNQkk3Bg++
X-HM-Tid: 0a72bb23c1b32086kuqy3b3dd410f4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

v2:
patch2: store the cb_priv of representor to the flow_block_cb->indr.cb_priv
in the driver. And make the correct check with the statments
this->indr.cb_priv == cb_priv

patch4: del the driver list only in the indriect cleanup callbacks

v3:
add the cover letter and changlogs.

This series fixes commit 1fac52da5942 ("net: flow_offload: consolidate
indirect flow_block infrastructure") that revists the flow_block
infrastructure.

The first patch fix the miss cleanup for flowtable indirect flow_block. 
The cleanup operation based on the setup callback. But in the mlx5e
driver there are tc and flowtable indrict setup callback and shared
the same release callbacks. So when the representor is removed,
then identify the indirect flow_blocks that need to be removed by 
the release callback.

The second patch fix the incorrect cb_priv check in flow_block_cb.
In the function __flow_block_indr_cleanup, stataments
this->cb_priv == cb_priv is always false(the flow_block_cb->cb_priv
is totally different data with the flow_indr_dev->cb_priv). So there
will always miss cleanup when the HW goaway and lead the memory leak.

After fix the first two patches. When the HW goaway, the indirect
flow_block can be cleanup. But It takes another two problem.


The third patch fix block->nooffloaddevcnt warning dmesg log.
When a indr device add in offload success. The block->nooffloaddevcnt
should be 0. After the representor go away. When the dir device go away
the flow_block UNBIND operation with -EOPNOTSUPP which lead the warning
demesg log. 
The block->nooffloaddevcnt should always count for indr block.
even the indr block offload successful. The representor maybe
gone away and the ingress qdisc can work in software mode.

The last patch fix the list_del corruption in the driver list.
When a indr device add in offload success. After the representor
go away. All the flow_block_cb cleanup but miss del form driver
list.

All the problem can be reproduce through making real hw go away
after setup the block offoaded.

wenxu (4):
  flow_offload: fix incorrect cleanup for indirect flow_blocks
  flow_offload: fix incorrect cb_priv check for flow_block_cb
  net/sched: cls_api: fix nooffloaddevcnt warning dmesg log
  flow_offload: fix the list_del corruption in the driver list

 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c       |  3 ++-
 .../net/ethernet/mellanox/mlx5/core/en/rep/tc.c    |  4 ++--
 drivers/net/ethernet/netronome/nfp/flower/main.c   |  2 +-
 drivers/net/ethernet/netronome/nfp/flower/main.h   |  3 +--
 .../net/ethernet/netronome/nfp/flower/offload.c    |  7 +++---
 include/net/flow_offload.h                         |  3 ++-
 net/core/flow_offload.c                            | 11 +++++-----
 net/netfilter/nf_flow_table_offload.c              |  1 +
 net/netfilter/nf_tables_offload.c                  |  1 +
 net/sched/cls_api.c                                | 25 +++++++++++++---------
 10 files changed, 35 insertions(+), 25 deletions(-)

-- 
1.8.3.1

