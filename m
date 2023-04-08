Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 091E16DBC3A
	for <lists+netdev@lfdr.de>; Sat,  8 Apr 2023 18:51:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbjDHQvS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Apr 2023 12:51:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbjDHQvR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Apr 2023 12:51:17 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2122.outbound.protection.outlook.com [40.107.244.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1278126;
        Sat,  8 Apr 2023 09:51:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZngeAx/g3yj2re1uMeh6S2QJkNxMObk5XPA4sha+BHQbGA9g9V4FthjtXMsuGDaj09O57IQdanax6ze+ilsvM9dnh4ALQKMXa7tPGJTVtwEAKH+RO5MgPhqH6LlsLzZPtvV7RU/D3PkgMnslhjgeAIq+Np4gy/CQF7NvdzJPOZR+cPXF6DGz8J1rGkur9Z2qV8fAceZ3lrM2Pb4qCtawcUzKeos65oGXZLQbOJipmPz2QFj5/sSGn1tf5CIQrVQwijXtIuFGlKRd3Zgr9R4BNJfouZM8PfIiOU4osCVOZyc7bVjUxhhWXvBmzoPVGIdtDRfxjN4YIdo6Mg1HryIRng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dNlLMdfQItojpU+da7m2pVsCyMCqAHlDnoEWARkRt6w=;
 b=BzoMM/8YyWW3vWYPEP6l1Zr2KlTIXueCUxpuBw07g1Fo4MA0r+cbwkm8DlDVoubj2pMSHa65WMo5l/iz7PCZ2OMAcMBJ94bJHB3YwCTFtc4LOibBBADUsMSKjcM1QTLhUrS4UFh2kdae9Ptdy3AiyViCJlpDVDOZyXsBGLc4pR+VJaGgD1V84wRvOAC+NoXFZT+QfoD462PrZuZnUhg8sHcfv93R8mX+2mdNNRW2DrPuuRA2oqiTNxd27rsbs9XIJTKRE9/FQsmaiKoWrX+/FJh1p7anfEqNCKs8SUHAk04buBc/lTVLRtQPNphThwexqXud/zt37kOJaAqZzt4/Kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dNlLMdfQItojpU+da7m2pVsCyMCqAHlDnoEWARkRt6w=;
 b=hznRUCDSvx6GYE6eYEL6S8yF8pj3ZP/ZyH9Ccg6SkUbLF+G2Jpmlk7Efwa09Vq9B5STiSjKmA/uY8Jo8n/28S7138J+mNTqF+Hm5kzMs3MyjCg8gX5neYYH8e460q8kds61puf9nSQB81y8xWSZk8l349NSea0NUfTHaREEfPdI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW3PR13MB4090.namprd13.prod.outlook.com (2603:10b6:303:5f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.36; Sat, 8 Apr
 2023 16:51:12 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169%5]) with mapi id 15.20.6277.036; Sat, 8 Apr 2023
 16:51:12 +0000
Date:   Sat, 8 Apr 2023 18:51:05 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Hariprasad Kelam <hkelam@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net,
        willemdebruijn.kernel@gmail.com, andrew@lunn.ch,
        sgoutham@marvell.com, lcherian@marvell.com, gakula@marvell.com,
        jerinj@marvell.com, sbhatta@marvell.com, naveenm@marvell.com,
        edumazet@google.com, pabeni@redhat.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, maxtram95@gmail.com
Subject: Re: [net-next Patch v6 5/6] octeontx2-pf: Add support for HTB offload
Message-ID: <ZDGbee5qBabGUQ/H@corigine.com>
References: <20230406102103.19910-1-hkelam@marvell.com>
 <20230406102103.19910-6-hkelam@marvell.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230406102103.19910-6-hkelam@marvell.com>
X-ClientProxiedBy: AM0PR04CA0116.eurprd04.prod.outlook.com
 (2603:10a6:208:55::21) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW3PR13MB4090:EE_
X-MS-Office365-Filtering-Correlation-Id: 634d8c0d-87cf-44bc-1ec0-08db38517563
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SFjHQn1uuIh0RvJL++z3grIfbOqTIjBNUbjTFf51kwZyM0l8hwke7+Y2wAn5GQa2DmqLWwv8bXWQPP4tnpZRNB8uVoN1U0s60jJyQbGGa7XOoNEGQRHRPnAkW0ECkv/OdNbEqEn5umluJS8D4Pi40A5x3A6JmL4/vyBTxjkvKVyefLhIIhJnSiSED19UFzRfieY6oc+2DNgpwg7c6ly5YC3uN6lhVTG7BN3xudAv6BfVGSMXNOwBRMcNCUajX1OMrKs2QmVSprA4btnZzSgasTdl0IEswC6meuaPUG/AOBfS1se2Tb/0lTe8jsyjTVgRCInScBwsAw0ZqDzx8yVMrFlU7uBHQEN+NN3u0ao5LWM+MZIM+z4aFLNZ6tVCrhC7wkyLxu4MINyRuA8JooV1dJFBpLp8A0EfpcoB6k4Z9m6zy/4Osm2/na+oF9eMAwZgKkJpiom20P37KuZxG3yh44c/7RqG08pkw3j2K7ww61hoHcxluzG1Xz3wCrJ91aifTPDcyFlWG+KR5FT/R3Sgz//pEoK6rCdaoUtdVqhV9Rb13JRl1fNElg0qi5O1oASE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(396003)(136003)(366004)(39830400003)(346002)(451199021)(478600001)(86362001)(83380400001)(36756003)(38100700002)(2616005)(6666004)(6486002)(2906002)(44832011)(316002)(186003)(6512007)(6506007)(7416002)(66476007)(8676002)(6916009)(41300700001)(8936002)(5660300002)(66556008)(4326008)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?U8OZMpEsIXfH68XGTEsRl1EM4CAs6KYhthvrg9/s4mXgC1CYbAhj5OlAUF2f?=
 =?us-ascii?Q?/q++Gn/JdYBct2Qwh+JdWx7hptdaFGLQt9eZmRLt9LBtBhiKo4Cq04ni3emS?=
 =?us-ascii?Q?/tbADaEJka0rG/96Lae/rfYUY9sABnLO2soSBTX9ePkF4kMEM34w3E9j6xoz?=
 =?us-ascii?Q?pnNv//uLd4kTRlp9D2RoutAkYI/7d6NI3I2llKO0hL+ZIWGRk8IuSlI/wWQk?=
 =?us-ascii?Q?Wu1UJb8Swcldx4+Z98CjTj15M+ERRF+tqfpUMhK5OrF58iKhfS4EYj076Sdl?=
 =?us-ascii?Q?r45RTWhwunvenBtkabGORssrxe0myQaYWIi7qDZ2ccImKBVRIAaVJ/BrASjz?=
 =?us-ascii?Q?9RUZMLQy8M8v9m/D5xDKwCS/ONJJch9nxre6M7F3FgshCd4mjD4Yb4xkau/L?=
 =?us-ascii?Q?M/MpL+KZggCA31gqtaHZgjN/sZbpmoosFVieIMQU88odL7gFuCIPzr0AKE60?=
 =?us-ascii?Q?2wGFBfYhCKd9hSQZJ59J7gXrmu1yGj/+5aSOsmnK+l2JI9Vl4/y+mrVaRnmm?=
 =?us-ascii?Q?cZ+paOSwevjqi88OfteegTFYLc4cvMQ6dFyaKRNIxVprREMO+dGmjIXORxHx?=
 =?us-ascii?Q?LIqfMxCFj3sIh2ECfpGUYw8fTDDHsuqxF1S2MutsUuI4/Bso9ZlfUe7v5ALQ?=
 =?us-ascii?Q?CZrfEHMMvORAfrM29CdhVYDoezvzU8l+2P6WgW/EBprsh+bcthOooTGEVwqM?=
 =?us-ascii?Q?HLheKhQ/ND5gGzflEue2j/7gJDtjoEzWIuI2F1HHWglfXiPIaYy3Fa6qMufp?=
 =?us-ascii?Q?HMuXrFU+iSNgICw1yF16/N51K1ECNFDYCTNNbWH03g6WRvmr9aURNRAZDPML?=
 =?us-ascii?Q?ppZkknXvUeVgJbmsu+I93kArcsiAh319+qiNz+zyTmOC/8xMTy5taPyfLPMv?=
 =?us-ascii?Q?GygEgKlXJbi43Jm+4KloOYP6NiDzRg9YAy+MaK0vtW2lQcWcsbRRyfgsUjBo?=
 =?us-ascii?Q?HiZ06U2uZE5cob7SeSBIow4E1RLujGl3lwD4v4KddaQPiPwg2AwlLCg8SqZt?=
 =?us-ascii?Q?YDxWthg+JU+JwqSUnC+jakeKZHk9v1Hmt7dZdcbTlzNffprsJswUTsKZbBea?=
 =?us-ascii?Q?akBzQpTluCeK5x1xsbHixMFDNjtm0JBqS0g/Szg8K1UWMGmjr9IqxqCW0HeQ?=
 =?us-ascii?Q?9WkTDUlhgY1/TVUKzjlV1LGShB05MVx6mefFNG+IkuBSZ7ultXcuJhhqhw+u?=
 =?us-ascii?Q?JEha9pJVmLkxyI0DoZvlngjK4QTW7RDADE+aKztaLPOurTMMXeGxcO7o2n10?=
 =?us-ascii?Q?lffg0sp+CUnta6EXnHmirV3tLDszUc4i0kNQX+bxvSaRTJvs8VICvNbH6Scc?=
 =?us-ascii?Q?sZwvs8w042LX2fNysfsS+485fTYlg71dFa02iAGQuAXrDUs0vTdQv3bJq0WR?=
 =?us-ascii?Q?/Cj2igPL2glth3O+JcF6v9XcJeYiAMVqg5bBmz8p/9rMwaySaVlzP886+qNt?=
 =?us-ascii?Q?15abgp75cFuoBx9vNLcqid7pyZaXYpSfmeFz6F+q1z8q9IWUlza9VGD4sk+p?=
 =?us-ascii?Q?EHeVx60jgd8WJaF/Ik+2DB8KwhwdqYjRHrZyi5dbzHPWQrafYL5QgNKiphtT?=
 =?us-ascii?Q?PtWsBA6ynaml/AmgGT5JueQeni08OUPSq8BQFXl2Xu0tk2WF1QJ9yhjHNxOq?=
 =?us-ascii?Q?LMaeA900ZcHxxbm5OSb3J87V9P+iFgbmPls8XXpJAGF3gb0Ir9y9gjIR4Wz7?=
 =?us-ascii?Q?azLfvA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 634d8c0d-87cf-44bc-1ec0-08db38517563
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2023 16:51:11.9033
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ku4Bdraesg5P6LfoDa4GrtiSerob83HJM3d5J/8pdtnZuwnnPVHsHsruXn/3zFBoJuug+q2NqVxoZv196gW9DIlMHg739kgIWqfPWeCrcZc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR13MB4090
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 06, 2023 at 03:51:02PM +0530, Hariprasad Kelam wrote:
> From: Naveen Mamindlapalli <naveenm@marvell.com>
> 
> This patch registers callbacks to support HTB offload.
> 
> Below are features supported,
> 
> - supports traffic shaping on the given class by honoring rate and ceil
> configuration.
> 
> - supports traffic scheduling,  which prioritizes different types of
> traffic based on strict priority values.
> 
> - supports the creation of leaf to inner classes such that parent node
> rate limits apply to all child nodes.

...

> +static int otx2_qos_leaf_alloc_queue(struct otx2_nic *pfvf, u16 classid,
> +				     u32 parent_classid, u64 rate, u64 ceil,
> +				     u64 prio, struct netlink_ext_ack *extack)
> +{
> +	struct otx2_qos_cfg *old_cfg, *new_cfg;
> +	struct otx2_qos_node *node, *parent;
> +	int qid, ret, err;
> +
> +	netdev_dbg(pfvf->netdev,
> +		   "TC_HTB_LEAF_ALLOC_QUEUE: classid=0x%x parent_classid=0x%x rate=%lld ceil=%lld prio=%lld\n",
> +		   classid, parent_classid, rate, ceil, prio);
> +
> +	if (prio > OTX2_QOS_MAX_PRIO) {
> +		NL_SET_ERR_MSG_MOD(extack, "Valid priority range 0 to 7");
> +		ret = -EOPNOTSUPP;
> +		goto out;
> +	}

out dereferences parent, but it is not set until a few lines below.

reported by gcc-12 with W=1 EXTRA_CFLAGS=-Wmaybe-uninitialized as:

drivers/net/ethernet/marvell/octeontx2/nic/qos.c: In function 'otx2_qos_leaf_alloc_queue':
drivers/net/ethernet/marvell/octeontx2/nic/qos.c:1178:31: error: 'parent' may be used uninitialized [-Werror=maybe-uninitialized]
 1178 |         clear_bit(prio, parent->prio_bmap);
      |                         ~~~~~~^~~~~~~~~~~
drivers/net/ethernet/marvell/octeontx2/nic/qos.c:1076:38: note: 'parent' was declared here
 1076 |         struct otx2_qos_node *node, *parent;
      |         

And by clang-16:

drivers/net/ethernet/marvell/octeontx2/nic/qos.c:1083:6: error: variable 'parent' is used uninitialized whenever 'if' condition is true [-Werror,-Wsometimes-uninitialized]
        if (prio > OTX2_QOS_MAX_PRIO) {
            ^~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/ethernet/marvell/octeontx2/nic/qos.c:1178:18: note: uninitialized use occurs here
        clear_bit(prio, parent->prio_bmap);
                        ^~~~~~
drivers/net/ethernet/marvell/octeontx2/nic/qos.c:1083:2: note: remove the 'if' if its condition is always false
        if (prio > OTX2_QOS_MAX_PRIO) {
        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/ethernet/marvell/octeontx2/nic/qos.c:1076:37: note: initialize the variable 'parent' to silence this warning
        struct otx2_qos_node *node, *parent;
                                           ^
                                            = NULL

> +
> +	/* get parent node */
> +	parent = otx2_sw_node_find(pfvf, parent_classid);
> +	if (!parent) {
> +		NL_SET_ERR_MSG_MOD(extack, "parent node not found");
> +		ret = -ENOENT;
> +		goto out;
> +	}

...

> +	return pfvf->hw.tx_queues + qid;
> +
> +free_node:
> +	otx2_qos_sw_node_delete(pfvf, node);
> +free_old_cfg:
> +	kfree(old_cfg);
> +out:
> +	clear_bit(prio, parent->prio_bmap);
> +	return ret;
> +}
> +
> +static int otx2_qos_leaf_to_inner(struct otx2_nic *pfvf, u16 classid,
> +				  u16 child_classid, u64 rate, u64 ceil, u64 prio,
> +				  struct netlink_ext_ack *extack)
> +{
> +	struct otx2_qos_cfg *old_cfg, *new_cfg;
> +	struct otx2_qos_node *node, *child;
> +	int ret, err;
> +	u16 qid;
> +
> +	netdev_dbg(pfvf->netdev,
> +		   "TC_HTB_LEAF_TO_INNER classid %04x, child %04x, rate %llu, ceil %llu\n",
> +		   classid, child_classid, rate, ceil);
> +
> +	if (prio > OTX2_QOS_MAX_PRIO) {
> +		NL_SET_ERR_MSG_MOD(extack, "Valid priority range 0 to 7");
> +		ret = -EOPNOTSUPP;
> +		goto out;

Likewise, out dereferences node, but it is not set until a few lines below.

reported by gcc-12 with W=1 EXTRA_CFLAGS=-Wmaybe-uninitialized as:

drivers/net/ethernet/marvell/octeontx2/nic/qos.c: In function 'otx2_qos_leaf_to_inner':
drivers/net/ethernet/marvell/octeontx2/nic/qos.c:1288:29: error: 'node' may be used uninitialized [-Werror=maybe-uninitialized]
 1288 |         clear_bit(prio, node->prio_bmap);
      |                         ~~~~^~~~~~~~~~~
drivers/net/ethernet/marvell/octeontx2/nic/qos.c:1187:31: note: 'node' was declared here
 1187 |         struct otx2_qos_node *node, *child;
      |                               ^~~~
drivers/net/ethernet/marvell/octeontx2/nic/qos.c: In function 'otx2_qos_leaf_alloc_queue':
drivers/net/ethernet/marvell/octeontx2/nic/qos.c:1178:31: error: 'parent' may be used uninitialized [-Werror=maybe-uninitialized]
 1178 |         clear_bit(prio, parent->prio_bmap);
      |                         ~~~~~~^~~~~~~~~~~
drivers/net/ethernet/marvell/octeontx2/nic/qos.c:1076:38: note: 'parent' was declared here
 1076 |         struct otx2_qos_node *node, *parent;
      |         

And by clang-16 as:

drivers/net/ethernet/marvell/octeontx2/nic/qos.c:1195:6: error: variable 'node' is used uninitialized whenever 'if' condition is true [-Werror,-Wsometimes-uninitialized]
        if (prio > OTX2_QOS_MAX_PRIO) {
            ^~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/ethernet/marvell/octeontx2/nic/qos.c:1288:18: note: uninitialized use occurs here
        clear_bit(prio, node->prio_bmap);
                        ^~~~
drivers/net/ethernet/marvell/octeontx2/nic/qos.c:1195:2: note: remove the 'if' if its condition is always false
        if (prio > OTX2_QOS_MAX_PRIO) {
        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/ethernet/marvell/octeontx2/nic/qos.c:1187:28: note: initialize the variable 'node' to silence this warning
        struct otx2_qos_node *node, *child;
                                  ^
                                   = NULL

> +	}
> +
> +	/* find node related to classid */
> +	node = otx2_sw_node_find(pfvf, classid);
> +	if (!node) {
> +		NL_SET_ERR_MSG_MOD(extack, "HTB node not found");
> +		ret = -ENOENT;
> +		goto out;
> +	}

...

> +	return 0;
> +
> +free_node:
> +	otx2_qos_sw_node_delete(pfvf, child);
> +free_old_cfg:
> +	kfree(old_cfg);
> +out:
> +	clear_bit(prio, node->prio_bmap);
> +	return ret;
> +}

...
