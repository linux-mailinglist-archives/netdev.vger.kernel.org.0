Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A37CC104DEB
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 09:29:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726165AbfKUI3D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 03:29:03 -0500
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:8372 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726270AbfKUI3C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 03:29:02 -0500
Received: from [192.168.188.14] (unknown [120.132.1.226])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id DA117412D6;
        Thu, 21 Nov 2019 16:28:57 +0800 (CST)
Subject: Re: Question about flow table offload in mlx5e
To:     Paul Blakey <paulb@mellanox.com>
Cc:     "pablo@netfilter.org" <pablo@netfilter.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Mark Bloch <markb@mellanox.com>
References: <1574147331-31096-1-git-send-email-wenxu@ucloud.cn>
 <20191119.163923.660983355933809356.davem@davemloft.net>
 <2a08a1aa-6aa8-c361-f825-458d234d975f@ucloud.cn>
 <AM4PR05MB3411591D31D7B22EE96BC6C3CF4E0@AM4PR05MB3411.eurprd05.prod.outlook.com>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <f0552f13-ae5d-7082-9f68-0358d560c073@ucloud.cn>
Date:   Thu, 21 Nov 2019 16:28:56 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <AM4PR05MB3411591D31D7B22EE96BC6C3CF4E0@AM4PR05MB3411.eurprd05.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVk1VQk1CS0tLSEhCTktDS01ZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Pxw6CSo6Ojg9TA8dF04KPTAz
        HBoKCiJVSlVKTkxPSElPQkhDTENNVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJS1VK
        SElVSlVJSU1ZV1kIAVlBTUNIQjcG
X-HM-Tid: 0a6e8d14252a2086kuqyda117412d6
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 11/21/2019 3:42 PM, Paul Blakey wrote:
> Hi,
>
> The original design was the block setup to use TC_SETUP_FT type, and the tc event type to be case TC_SETUP_CLSFLOWER.
> We will post a patch to change that. I would advise to wait till we fix that 😊
> I'm not sure how you get to this function mlx5e_rep_setup_ft_cb() if it the nf_flow_table_offload ndo_setup_tc event was TC_SETUP_BLOCK, and not TC_SETUP_FT.


Yes I change the TC_SETUP_BLOCK to TC_SETUP_FT in the nf_flow_table_offload_setup.

Two fixes patch provide:

http://patchwork.ozlabs.org/patch/1197818/

http://patchwork.ozlabs.org/patch/1197876/

So this change made by me is not correct currently?

>
> In our driver en_rep.c we have:
>> -------switch (type) {
>> -------case TC_SETUP_BLOCK:
>> ------->-------return flow_block_cb_setup_simple(type_data,
>> ------->------->------->------->------->-------  &mlx5e_rep_block_tc_cb_list,
>> ------->------->------->------->------->-------  mlx5e_rep_setup_tc_cb,
>> ------->------->------->------->------->-------  priv, priv, true);
>> -------case TC_SETUP_FT:
>> ------->-------return flow_block_cb_setup_simple(type_data,
>> ------->------->------->------->------->-------  &mlx5e_rep_block_ft_cb_list,
>> ------->------->------->------->------->-------  mlx5e_rep_setup_ft_cb,
>> ------->------->------->------->------->-------  priv, priv, true);
>> -------default:
>> ------->-------return -EOPNOTSUPP;
>> -------}
> In nf_flow_table_offload.c:
>> -------bo.binder_type>-= FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS;
>> -------bo.extack>------= &extack;
>> -------INIT_LIST_HEAD(&bo.cb_list);
>> -------err = dev->netdev_ops->ndo_setup_tc(dev, TC_SETUP_BLOCK, &bo);
>> -------if (err < 0)
>> ------->-------return err;
>> -------return nf_flow_table_block_setup(flowtable, &bo, cmd);
> }
> EXPORT_SYMBOL_GPL(nf_flow_table_offload_setup);
>
>
> So unless you changed that as well, you should have gotten to mlx5e_rep_setup_tc_cb and not mlx5e_rep_setup_tc_ft.
>
> Regarding the encap action, there should be no difference on which chain the rule is on.


But for the same encap rule can be real offloaded when setup through through TC_SETUP_BLOCK. But TC_SETUP_FT can't.

So it is the problem of TC_SETUP_FT in mlx5e_rep_setup_ft_cb ?

>
>
>> -----Original Message-----
>> From: wenxu <wenxu@ucloud.cn>
>> Sent: Thursday, November 21, 2019 9:30 AM
>> To: Paul Blakey <paulb@mellanox.com>
>> Cc: pablo@netfilter.org; netdev@vger.kernel.org; Mark Bloch
>> <markb@mellanox.com>
>> Subject: Question about flow table offload in mlx5e
>>
>> Hi  paul,
>>
>> The flow table offload in the mlx5e is based on TC_SETUP_FT.
>>
>>
>> It is almost the same as TC_SETUP_BLOCK.
>>
>> It just set MLX5_TC_FLAG(FT_OFFLOAD) flags and change
>> cls_flower.common.chain_index = FDB_FT_CHAIN;
>>
>> In following codes line 1380 and 1392
>>
>> 1368 static int mlx5e_rep_setup_ft_cb(enum tc_setup_type type, void
>> *type_data,
>> 1369                                  void *cb_priv)
>> 1370 {
>> 1371         struct flow_cls_offload *f = type_data;
>> 1372         struct flow_cls_offload cls_flower;
>> 1373         struct mlx5e_priv *priv = cb_priv;
>> 1374         struct mlx5_eswitch *esw;
>> 1375         unsigned long flags;
>> 1376         int err;
>> 1377
>> 1378         flags = MLX5_TC_FLAG(INGRESS) |
>> 1379                 MLX5_TC_FLAG(ESW_OFFLOAD) |
>> 1380                 MLX5_TC_FLAG(FT_OFFLOAD);
>> 1381         esw = priv->mdev->priv.eswitch;
>> 1382
>> 1383         switch (type) {
>> 1384         case TC_SETUP_CLSFLOWER:
>> 1385                 if (!mlx5_eswitch_prios_supported(esw) || f-
>>> common.chain_index)
>> 1386                         return -EOPNOTSUPP;
>> 1387
>> 1388                 /* Re-use tc offload path by moving the ft flow to the
>> 1389                  * reserved ft chain.
>> 1390                  */
>> 1391                 memcpy(&cls_flower, f, sizeof(*f));
>> 1392                cls_flower.common.chain_index = FDB_FT_CHAIN;
>> 1393                 err = mlx5e_rep_setup_tc_cls_flower(priv, &cls_flower, flags);
>> 1394                 memcpy(&f->stats, &cls_flower.stats, sizeof(f->stats));
>>
>>
>> I want to add tunnel offload support in the flow table, I  add some patches in
>> nf_flow_table_offload.
>>
>> Also add the indr setup support in the mlx driver. And Now I can  flow table
>> offload with decap.
>>
>>
>> But I meet a problem with the encap.  The encap rule can be added in
>> hardware  successfully But it can't be offloaded.
>>
>> But I think the rule I added is correct.  If I mask the line 1392. The rule also can
>> be add success and can be offloaded.
>>
>> So there are some limit for encap operation for FT_OFFLOAD in
>> FDB_FT_CHAIN?
>>
>>
>> BR
>>
>> wenxu
>>
