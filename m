Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E12E5879E5
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 11:33:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234193AbiHBJdl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 05:33:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233888AbiHBJdk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 05:33:40 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2129.outbound.protection.outlook.com [40.107.237.129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AE6B3F33F
        for <netdev@vger.kernel.org>; Tue,  2 Aug 2022 02:33:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y0tnI6FXzAAlKXKRRx+IYpyvNByHV9O1DpVu3KqAKA7jNzZ2TIZDfreJFjZD2NOaFCCmzlaIrniTXrqN88MpT0fqQDe/ITLnPmnCcnDGjVfpIxMAbho336SObpYh+u2BbC+oERivStmUMddSk3D/yAzDere3DeNfHfcaUZgr+nhgp0IioUnDVamo60Ti2IDPG869kl2vKJMnflIMA4lKcYO/YuY336Wk+M79/ifDYdgiY1n0ZeiyXs7h4mbma57BjCJPwB5R/Cg8hHdb869LRKU+CMGySFLV1fSclzZcIzv7QIjhXIgU+IAOU4sQ5JUm/H8OYLKDxItWjqx4OEG7Qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P5wRP5nc6ZxL1XilXu+JqgiUBmdojgjNQ4GXXOREjlk=;
 b=SnpblIavyBpyEamZqEHjcQFdu7EqafsLYceV+0Idz8WxlIB3VhK8gsiNTalR0WGOo1AP0v5rHQQY2WwGHltqJKhi6oss/lnIl4SqY5/ftjg11/rE9dNNKLgtq7TBR3iUJWgzCe6qM1/EUxRq6dVnrTgk3O/llvtnK2wxKhmRXsYYmslf5I5ra7uk1P0Kb+CB0Iyn7fU8JphfrNfu/ocu2xN7aXo4QttGbO00/K/OTAwfMtH/xBROjFxa+SjoyGf/RlxLmW8XI6sTCXv4pJ2EB1amXHeomiWaJt1rEeGjFLh9jOl/2lRGuQTJvmf87LpDSZ2Un4t4PJwmhKdjJLMeJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P5wRP5nc6ZxL1XilXu+JqgiUBmdojgjNQ4GXXOREjlk=;
 b=dd19Xdc1OH87gGEWx582GZ987l8RTltCWxrT3enytQYq4Louz8jhr3zPJS5Bvfl4FyriObwz+FtjWuBnsHsjkdr5pv6CqNIINSLm5b3df8znlu4Skyn9LVtbeXKwwrkmi1clR4PJs2z/+cORkuGdKGlu0qTXQ1jYAuDgGqmD6Zc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BN6PR1301MB2081.namprd13.prod.outlook.com (2603:10b6:405:34::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.12; Tue, 2 Aug
 2022 09:33:37 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a1e6:3e37:b3f3:7576]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a1e6:3e37:b3f3:7576%9]) with mapi id 15.20.5504.014; Tue, 2 Aug 2022
 09:33:36 +0000
Date:   Tue, 2 Aug 2022 10:33:31 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com
Subject: Re: [PATCH net] nfp: ethtool: fix the display error of `ethtool -m
 DEVNAME`
Message-ID: <Yujva/q8AMVUI2f0@corigine.com>
References: <20220802085916.63988-1-simon.horman@corigine.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220802085916.63988-1-simon.horman@corigine.com>
X-ClientProxiedBy: LO4P265CA0066.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2af::9) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 02ddd2a1-efd2-4f69-041d-08da746a1374
X-MS-TrafficTypeDiagnostic: BN6PR1301MB2081:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qcV0BpHges9DEfEjqh/v2CDRtxoAsP12juMzr0nqGtEwgxSnPAmcVHcMBxkjnNG5SMJgyEbEYMtWKQ0jz8nRbxgOnhCo1vX1k1LKOinb/Ob5gvg2/af2zx9d/C8z8WO1J0JLjVTGAhxwh8ZrD+bfG+B7LcsQ2a6994X1O8FouFOnhgwbP9I8KVQsjRbixAmogXRPgcHbIz9l7EZlSXEKpaU2+02hu7yYSYEx4QQygRYhrjg7a7lF0qGKfmIdUTc4pBPro9CzvISVw2HHvjsjz/GqFHaM+bTyW/Dr+kF1KD0ZdAo5FPuglYY3kxaA0sz/cE11IO0WAK7vfcazMZeF3b1dbscuQqR9zTWD84d6KIc5HoN+rawzxhc3xtS33/ucpuWZb9PnreJkJPxNUwnh9qR5q0TPB739cGK/HXwP6sdq2uEaV2Fo0s+1KaUe4iUWOYBXg68zdM04Eu+AmXoP3hFa2qZid79E82ifp83aeosrSJupp6oVVBO0ij2naijrlAYQvc+73mZ0Zmam2N1w4fOwbIcaC/AaAlpZnSQonVkjvccChS/PEwVaUHvEDDlPoQaj//YzQp7VkSrTSXJnkHIzLB28AK92Vkffgcb8YbDM7cXC7SQ/Me/dwr8GYXP7ihLyn7sz4i068dCICnB3AP3ABuIxCI+DmkiX/JJvWNG+RsUiwn4o9BD6a5EhE+bqK0uwo4pyogu3sCtMLjKRzqHYGQGin+uXF9li0+4ViIik3JJtGvHHkWjqvSlbfuv4viLSCaKw0EzjjYAi7u/w4Svgp4s5m+X+QcE7yFD5F1cOcHbrzrlTeIQ4UngjD6Dgn4GQ4qxjks10P4ecJYtJpg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(396003)(366004)(376002)(346002)(39840400004)(26005)(6512007)(2616005)(36756003)(5660300002)(186003)(52116002)(38350700002)(44832011)(38100700002)(107886003)(86362001)(6506007)(41300700001)(316002)(66476007)(6486002)(110136005)(66946007)(66556008)(4326008)(8676002)(6666004)(8936002)(2906002)(83380400001)(478600001)(81973001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Xxnw5WSPYYGU+p6Qt33tzBeeyuPu5wggcbKP8udeHPn9Utq/ZQ2VsZNQrw/g?=
 =?us-ascii?Q?c6GtRo4BqHS/6hQ7dydSQo1n/OgpwS6VidDGS1SJH6DvtUdcBcEBJk/jqJCd?=
 =?us-ascii?Q?11OoztNNzaz4/JsgU070pno+zWQW5Hj+gU09y1JYLHKUi9BrXwzi5TqQVM6T?=
 =?us-ascii?Q?PjxAaIXJg3mECaI+WVLCvGuJFXrwXqMpuDO38uY5xGVz6VZxBC7ocX0lHSrc?=
 =?us-ascii?Q?lpRMdH9TGX94hUQ5FALwMWoEjKjbosD20U2Vr3LjRmSLL7L3bHRWFvd4M6u0?=
 =?us-ascii?Q?oi9TFhWG/LKyuT/H1npIV/lHQTH1GO5HKAsBW60dAPaW1HedQeb/xa3x4e++?=
 =?us-ascii?Q?lkk/sHLNZwDZ6kmjBZ5y2nIT4dluj3DGQUL4zrtl3GgZ4HMkHvP+CTTp5Qt2?=
 =?us-ascii?Q?XR/yyXf8fAulmX4lM9r5V0x8UwwN8R2yckkFHda0lzRcPb0so4TjWqBef2Od?=
 =?us-ascii?Q?Y6Sw+wjyB98nmc3VfpZHAcEUpJw9ucwxPDC3iawJEJK2hJryd1cEhUHJPqzH?=
 =?us-ascii?Q?wwHwKAROT6YPPWFQE1JHh9vWchtJqScPHx8L2LYdWHs30P+PdEivknvvdKDN?=
 =?us-ascii?Q?n+NinOxOANBj6E7zWyZ5qhEs+XixyZxPgKbLoE5OErl/vJIfiSJo9S+yiHCj?=
 =?us-ascii?Q?PVCRMD+g4pYGfBpDLIMGzlZo4TesLXo7hWszSNrPc8cQ+2pGKh5UIXuBIJoK?=
 =?us-ascii?Q?KhPoBCZpy9koAp3n2/5z3RnM1W8As9ZVrWJj5PrAI4bv469JyPDoGWJ0K8nr?=
 =?us-ascii?Q?GPRwYiRQW0QW8nTOXOWFJp3fscit7cxlHi9jXoHiyatbfuwSUR+xC+YooVUh?=
 =?us-ascii?Q?qlDOXJlky/tdRTPztOoVKIO73lSOpGEE180u5iPJZJKBrTMj2M4NtyZjvrnl?=
 =?us-ascii?Q?JZLjzl974ezSVxBLskXOi6gkMLrB/TTTDN7WWl+yOVKy93hKgEMAkwY8o+5B?=
 =?us-ascii?Q?WkmOWtMPK9dUMK+04pROVV9CguZ8BWRMlPcq6M7eSF81cuM+XHcd5D+gwCT3?=
 =?us-ascii?Q?Sbv2Fddqd6VT0/r/X+uEmGv3/3k/K33ZOYpAmoEBogneCGrUCtzGNxmwwQnY?=
 =?us-ascii?Q?CRAHPp0zL95z/Fa2p+lM3v3AWbKt79mzClVC2H8b5yHaUajFTkxrPZXqhy9Q?=
 =?us-ascii?Q?jJ/xY7DQiPaPpMrfA7lIU5trPAFQW6w7CBvtLXtSiNYpupyoBU8msvZl94Jd?=
 =?us-ascii?Q?v6vOsRwV1zLOOm/uOsoldS7Vbdb+TUvH6f1UQGSAC78sw1mYZqoh67dXpRVZ?=
 =?us-ascii?Q?4aZAmg8ggo8jwUCPf6GOcwvvLW1rqPNdPqmgsvI7VstGJ9OZG7yaJQ4dJdAG?=
 =?us-ascii?Q?99+esgG9ODNeDYfPg7mAmkx1X+i7CbaA7FrwWtD6fiiPeQarHJqjkKoo/NyZ?=
 =?us-ascii?Q?xe3lKZswZ50zxiOsVfUkIkCOlHfkncGz6YO4TBHrV12b87itB2qOOoSWdPLY?=
 =?us-ascii?Q?KTPiaMbzjsMvt3dEHpB37MT9iJZf7VcePju3byfuM0tGJDtfaszeN7HMuTG8?=
 =?us-ascii?Q?u+iIi5QMut7tYRIDk7wI9m20xuYqFyFpBcAc6yhlQMOZZixc2+dzfEoKmybY?=
 =?us-ascii?Q?XbRHZWEq5NVBkfQG7A9o1gEH34YvUq/IayB0vQalZrpqXf2snhbJUWwNXEl3?=
 =?us-ascii?Q?Mg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02ddd2a1-efd2-4f69-041d-08da746a1374
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Aug 2022 09:33:36.8853
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fIhI90JCYTUPLdLiOI5X50rcOc/qw/8Uce5ugy3r+QuTsTBzoqGVnyrxN+GThWErTj6KnkCXY+YnMLNoV5bwYfbw4je75SF00cD11PMs4KQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1301MB2081
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 02, 2022 at 09:59:16AM +0100, Simon Horman wrote:
> From: Yu Xiao <yu.xiao@corigine.com>
> 
> The port flag isn't set to `NFP_PORT_CHANGED` when using
> `ethtool -m DEVNAME` before, so the port state (e.g. interface)
> cannot be updated. Therefore, it caused that `ethtool -m DEVNAME`
> sometimes cannot read the correct information.
> 
> E.g. `ethtool -m DEVNAME` cannot work when load driver before plug
> in optical module, as the port interface is still NONE without port
> update.
> 
> Now update the port state before sending info to NIC to ensure that
> port interface is correct (latest state).
> 
> Fixes: 61f7c6f4 ("nfp: implement ethtool get module EEPROM")

Sorry about this. I see that the fixes tag above has 8 rather than 12
characters of the commit hash. I'll post v2 to address this problem.

> Reviewed-by: Louis Peens <louis.peens@corigine.com>
> Signed-off-by: Yu Xiao <yu.xiao@corigine.com>
> Signed-off-by: Simon Horman <simon.horman@corigine.com>
> ---
>  drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
> index df0afd271a21..e6ee45afd80c 100644
> --- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
> +++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
> @@ -1230,6 +1230,8 @@ nfp_port_get_module_info(struct net_device *netdev,
>  	u8 data;
>  
>  	port = nfp_port_from_netdev(netdev);
> +	/* update port state to get latest interface */
> +	set_bit(NFP_PORT_CHANGED, &port->flags);
>  	eth_port = nfp_port_get_eth_port(port);
>  	if (!eth_port)
>  		return -EOPNOTSUPP;
> -- 
> 2.30.2
> 
