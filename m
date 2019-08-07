Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B7A983EA0
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 03:14:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728407AbfHGBN7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 21:13:59 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:1083 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727679AbfHGBN7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 21:13:59 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 06BB1416E3;
        Wed,  7 Aug 2019 09:13:55 +0800 (CST)
From:   wenxu@ucloud.cn
To:     jakub.kicinski@netronome.com, pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next v7 0/6] flow_offload: add indr-block in nf_table_offload
Date:   Wed,  7 Aug 2019 09:13:48 +0800
Message-Id: <1565140434-8109-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZSFVLTkpLS0tKSkNJTk5NSVlXWShZQU
        lCN1dZLVlBSVdZCQ4XHghZQVk1NCk2OjckKS43PlkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MBw6Ahw4LDgyTU0aSgIaTj0z
        VjxPC09VSlVKTk1OSk9LT0hOSE1MVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUlJQkI3Bg++
X-HM-Tid: 0a6c69a3c0742086kuqy06bb1416e3
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

This series patch make nftables offload support the vlan and
tunnel device offload through indr-block architecture.

The first four patches mv tc indr block to flow offload and
rename to flow-indr-block.
Because the new flow-indr-block can't get the tcf_block
directly. The fifth patch provide a callback list to get 
flow_block of each subsystem immediately when the device
register and contain a block.
The last patch make nf_tables_offload support flow-indr-block.

This version add a mutex lock for add/del flow_indr_block_ing_cb

wenxu (6):
  cls_api: modify the tc_indr_block_ing_cmd parameters.
  cls_api: remove the tcf_block cache
  cls_api: add flow_indr_block_call function
  flow_offload: move tc indirect block to flow offload
  flow_offload: support get multi-subsystem block
  netfilter: nf_tables_offload: support indr block call

 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |  10 +-
 .../net/ethernet/netronome/nfp/flower/offload.c    |  11 +-
 include/net/flow_offload.h                         |  37 +++
 include/net/netfilter/nf_tables_offload.h          |   4 +
 include/net/pkt_cls.h                              |  35 ---
 include/net/sch_generic.h                          |   3 -
 net/core/flow_offload.c                            | 240 +++++++++++++++++++
 net/netfilter/nf_tables_api.c                      |   7 +
 net/netfilter/nf_tables_offload.c                  | 148 ++++++++++--
 net/sched/cls_api.c                                | 254 ++++-----------------
 10 files changed, 464 insertions(+), 285 deletions(-)

-- 
1.8.3.1

