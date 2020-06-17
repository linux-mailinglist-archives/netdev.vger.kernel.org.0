Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 754E61FD2EA
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 18:55:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726906AbgFQQzP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 12:55:15 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:61198 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726809AbgFQQzP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 12:55:15 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id A2D154160C;
        Thu, 18 Jun 2020 00:55:09 +0800 (CST)
From:   wenxu@ucloud.cn
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, pablo@netfilter.org, vladbu@mellanox.com,
        simon.horman@netronome.com
Subject: [PATCH net v4 0/4] several fixes for indirect flow_blocks offload
Date:   Thu, 18 Jun 2020 00:55:03 +0800
Message-Id: <1592412907-3856-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZSFVPTkpCQkJNTU9IS01NT1lXWShZQU
        lCN1dZLVlBSVdZDwkaFQgSH1lBWRciNQs4HDozMjYjDygOCx4DPUIkOhxWVlVKQkNLKElZV1kJDh
        ceCFlBWTU0KTY6NyQpLjc#WVdZFhoPEhUdFFlBWTQwWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6OhQ6LAw6Fzg6DTUYSy8yHQkV
        SQsaCRBVSlVKTkJJT0pJQktCTE9IVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUhJTE03Bg++
X-HM-Tid: 0a72c334b0742086kuqya2d154160c
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

v4:
collapsed 1/4, 2/4, 4/4 in v3 to one fix
Add the prepare patch 1 and 2

This series fixes commit 1fac52da5942 ("net: flow_offload: consolidate
indirect flow_block infrastructure") that revists the flow_block
infrastructure.

patch #1 #2：prepare for fix patch #3
add and use flow_indr_block_cb_alloc/remove function

patch #3: fix flow_indr_dev_unregister path
If the representor is removed, then identify the indirect flow_blocks
that need to be removed by the release callback and the port representor
structure. To identify the port representor structure, a new 
indr.cb_priv field needs to be introduced. The flow_block also needs to
be removed from the driver list from the cleanup path


patch#4 fix block->nooffloaddevcnt warning dmesg log.
When a indr device add in offload success. The block->nooffloaddevcnt
should be 0. After the representor go away. When the dir device go away
the flow_block UNBIND operation with -EOPNOTSUPP which lead the warning
demesg log. 
The block->nooffloaddevcnt should always count for indr block.
even the indr block offload successful. The representor maybe
gone away and the ingress qdisc can work in software mode.


wenxu (4):
  flow_offload: add flow_indr_block_cb_alloc/remove function
  flow_offload: use flow_indr_block_cb_alloc/remove function
  net: flow_offload: fix flow_indr_dev_unregister path
  net/sched: cls_api: fix nooffloaddevcnt warning dmesg log

 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c       | 21 +++---
 .../net/ethernet/mellanox/mlx5/core/en/rep/tc.c    | 24 ++++---
 drivers/net/ethernet/netronome/nfp/flower/main.c   |  2 +-
 drivers/net/ethernet/netronome/nfp/flower/main.h   |  7 +-
 .../net/ethernet/netronome/nfp/flower/offload.c    | 24 ++++---
 include/net/flow_offload.h                         | 21 +++++-
 net/core/flow_offload.c                            | 79 ++++++++++++----------
 net/netfilter/nf_flow_table_offload.c              |  1 +
 net/netfilter/nf_tables_offload.c                  |  1 +
 net/sched/cls_api.c                                | 25 ++++---
 10 files changed, 126 insertions(+), 79 deletions(-)

-- 
1.8.3.1

