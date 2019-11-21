Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3236C104C97
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 08:30:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbfKUHaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 02:30:24 -0500
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:63378 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726265AbfKUHaY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 02:30:24 -0500
Received: from [192.168.188.14] (unknown [120.132.1.226])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 0A17C41CCF;
        Thu, 21 Nov 2019 15:30:15 +0800 (CST)
Cc:     pablo@netfilter.org, netdev@vger.kernel.org, markb@mellanox.com
References: <1574147331-31096-1-git-send-email-wenxu@ucloud.cn>
 <20191119.163923.660983355933809356.davem@davemloft.net>
From:   wenxu <wenxu@ucloud.cn>
To:     paulb@mellanox.com
Subject: Question about flow table offload in mlx5e
Message-ID: <2a08a1aa-6aa8-c361-f825-458d234d975f@ucloud.cn>
Date:   Thu, 21 Nov 2019 15:30:14 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191119.163923.660983355933809356.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSE5IS0tLS09PQ0lJTUJZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6OjY6Kio4PzgrLQ8*PTUDGhUy
        LAgKCitVSlVKTkxPSElKT0pNSU9DVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJS1VK
        SElVSlVJSU1ZV1kIAVlBSE5NSjcG
X-HM-Tid: 0a6e8cde67e12086kuqy0a17c41ccf
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi  paul,

The flow table offload in the mlx5e is based on TC_SETUP_FT.


It is almost the same as TC_SETUP_BLOCK.

It just set MLX5_TC_FLAG(FT_OFFLOAD) flags and change cls_flower.common.chain_index = FDB_FT_CHAIN;

In following codes line 1380 and 1392

1368 static int mlx5e_rep_setup_ft_cb(enum tc_setup_type type, void *type_data,
1369                                  void *cb_priv)
1370 {
1371         struct flow_cls_offload *f = type_data;
1372         struct flow_cls_offload cls_flower;
1373         struct mlx5e_priv *priv = cb_priv;
1374         struct mlx5_eswitch *esw;
1375         unsigned long flags;
1376         int err;
1377
1378         flags = MLX5_TC_FLAG(INGRESS) |
1379                 MLX5_TC_FLAG(ESW_OFFLOAD) |
1380                 MLX5_TC_FLAG(FT_OFFLOAD);
1381         esw = priv->mdev->priv.eswitch;
1382
1383         switch (type) {
1384         case TC_SETUP_CLSFLOWER:
1385                 if (!mlx5_eswitch_prios_supported(esw) || f->common.chain_index)
1386                         return -EOPNOTSUPP;
1387
1388                 /* Re-use tc offload path by moving the ft flow to the
1389                  * reserved ft chain.
1390                  */
1391                 memcpy(&cls_flower, f, sizeof(*f));
1392                cls_flower.common.chain_index = FDB_FT_CHAIN;
1393                 err = mlx5e_rep_setup_tc_cls_flower(priv, &cls_flower, flags);
1394                 memcpy(&f->stats, &cls_flower.stats, sizeof(f->stats));


I want to add tunnel offload support in the flow table, I  add some patches in nf_flow_table_offload.

Also add the indr setup support in the mlx driver. And Now I can  flow table offload with decap.


But I meet a problem with the encap.  The encap rule can be added in hardware  successfully But it can't be offloaded.

But I think the rule I added is correct.  If I mask the line 1392. The rule also can be add success and can be offloaded.

So there are some limit for encap operation for FT_OFFLOAD in FDB_FT_CHAIN?


BR

wenxu


