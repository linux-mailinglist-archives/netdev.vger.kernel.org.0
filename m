Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4616A692193
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 16:06:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232400AbjBJPGV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 10:06:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232582AbjBJPGN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 10:06:13 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2132.outbound.protection.outlook.com [40.107.220.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D54F6CC66;
        Fri, 10 Feb 2023 07:05:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XwKVPP+k9f0AWvaAN7KwGhJ8PQWG6RyPqlbCak6K9E2Ks/fjKqR8f2YH/GwTtyyvUrm3diGWktBPPThR5mIGy0rJqI456nj/Q7eQrT+iXVtPLl1lcYuO1sVSFFVHvXF1pUTZOTcAVSl1f8fl6u7qxgaj/qpNstemBgRw5CkdVIOzbtoMA8v3Kb6DfhSzB+ybLAqDC102b1tTQhX1nVbWPTLvoazwZYDuqJ+KZ3WXN9Wq/3DDj9icH7GLNlsvWbbuqBuT6HjovJasC+Fnm19OTcG6YwKP4hQB9jWWJKo7TDmXtPjyeNPck0snUok5SbxiAkxNq0PaVew9heUEV8JFuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=csmda0qzG4P0o1nYdxHpLmVErZ1eBOGw1539QpkyTEg=;
 b=macjB0VzMfb5QnCXTaiTKVQyPCbvCbjuhLjHgmVnez4I42SfcJFMFPFtI68zJE+xbe+urf07nxExM6+5Zwh/ZAiChgbAslsDJhgbZHDTeZEHBvTaH2udfPH5COO2VBZgHvF6U/QLNuSpMs8gFcfwbHnffpw6HmvmAuSmnQi6CPZBr7eLorhfgK4CEH3iZ0It+SqE7l7UsQ8r2bdI3ejAZL7+LQrP6sgHoYTnBLsPTy1doUrf41PTHWJdPleZjKnc5AAc8LeqZisecDrEwTWQQSOnq+/TuYGScd+fuA1quzVktN4npCWyo22aXz2eoRQweP+nfdwDqZMW3GtU9Fb3gQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=csmda0qzG4P0o1nYdxHpLmVErZ1eBOGw1539QpkyTEg=;
 b=u3dP0VEk/HN37CESZx5tmDz/PoJHzo3zLg12gnsfFpBF7S1EBwb7pweMUgevQduxLWzCxL5G00pwWbaOL5p/99AhA71fBXcnQLx+1mgWghKTfR91yUjc7/HUoGvF8EmQ+BJh7kkUwQD2OBFS4xX4JHU3OajKZcsMuACSP4VtQoE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY1PR13MB6310.namprd13.prod.outlook.com (2603:10b6:a03:52e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.19; Fri, 10 Feb
 2023 15:05:34 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%9]) with mapi id 15.20.6086.021; Fri, 10 Feb 2023
 15:05:34 +0000
Date:   Fri, 10 Feb 2023 16:05:18 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Hariprasad Kelam <hkelam@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, sgoutham@marvell.com, lcherian@marvell.com,
        gakula@marvell.com, jerinj@marvell.com, sbhatta@marvell.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        saeedm@nvidia.com, richardcochran@gmail.com, tariqt@nvidia.com,
        linux-rdma@vger.kernel.org, maxtram95@gmail.com,
        naveenm@marvell.com, bpf@vger.kernel.org,
        hariprasad.netdev@gmail.com
Subject: Re: [net-next Patch V4 4/4] octeontx2-pf: Add support for HTB offload
Message-ID: <Y+ZdLphI/TolrgcA@corigine.com>
References: <20230210111051.13654-1-hkelam@marvell.com>
 <20230210111051.13654-5-hkelam@marvell.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230210111051.13654-5-hkelam@marvell.com>
X-ClientProxiedBy: AS4P191CA0019.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d9::9) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY1PR13MB6310:EE_
X-MS-Office365-Filtering-Correlation-Id: b9ae8796-38df-43d3-8de3-08db0b7841f9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ol0IitDT79kYwGH38zPTnyBReQY/LBaffCn/0JaklPTnA/JO6Xldw56CgIcgSVCGkBx+6Rwvzb1bzNZN1kuVbt6DQpH0ucyZcgfEVpJMuiifvlfncChYO+t2aULxbmvJzjX4Bs9NaArItkDz1hnwVpQVWqQiN75vbzKYDSKhfL8T9kBtCy1XcHz8t4TmL0AbqVuUtBxxxPLf3eQDIRWDq+95I59GGx1x9l0d9IQOXY7NhMNa6UDRMjot+vZpJZ+ZRyOVq90K+8ITCdKt3vKtMta0vUtu+g/YsH3egPMbLeuJpkBYkRHiHPyOsUVZoTu5lqn0Ca2ZCgvMU9vXxk/9hNrK9jvHri2AIRCTiNLwzgHFP4hdz9nH/8jrr6aAHq0OkMhSIYO0YWDcAuc30i+cU7zVbIu95+5zNmgQZtGbI/mRC80Ud05SfWBMJ3r4nQIuIvNsQzU68+SJGHekhEHEwNpjABs7hje34mpzUmyHXa16CQYF4/pvNLuVUzeBvJL4vmOWhGRGGMY8jUButw1MybJaJCYqhHM0ydZkA0vqyLPIshr1oUDtk/gGPzOBbX9n7zqfnCQW1hjTK3fY855ESixV/6ZjaCIIpnRlk50p+FpASfk+jFrLepCm7mzB/PRgAk9VfJh3S9dgM2illp+wrY6BIva8diu92fN8vSFP72SI/2xz3TYcgUftNAuJRnuRBAzSnQKwBW3Gu38+lLIJb79bgZOa7/f9oqh6Is4m3n0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(39840400004)(136003)(396003)(346002)(376002)(451199018)(5660300002)(7416002)(86362001)(186003)(8936002)(2616005)(38100700002)(6916009)(83380400001)(6512007)(41300700001)(66946007)(316002)(4326008)(66476007)(8676002)(66556008)(6506007)(6666004)(478600001)(6486002)(36756003)(44832011)(2906002)(21314003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8PZ50pu2tDWWqSQUgxDf4I8YrQYWBzFZKypTPQNJQaUowMh/m2MXo1S0Q2kn?=
 =?us-ascii?Q?wwXzvOgOGQwuTI0rjIsw4V2aVI5QBvfQ/o8RVPC/lGUNH8kiEoG6dMZdrLXp?=
 =?us-ascii?Q?VDV9ttANDqdCMJTc9lolqub9Hjpmkjw3PfEMV33LPLOj/UAoFIKuvgbBWsMG?=
 =?us-ascii?Q?LsgidEfisqmN0h0ZW4OIa94nJvGe0NCQTxRsbxGmpOYbWvANyyM9nAzF0u/M?=
 =?us-ascii?Q?WYeHtDIr4Tkz5C/q957Go4FeOzT6rd4rgUfusp+wzMC0jIhBcL680fPhvXzp?=
 =?us-ascii?Q?kDsSJqoJplnVMPnONyh1/DbmVt4CH86MVE9U/wAQvF0zo8scY7or5Ix+Did2?=
 =?us-ascii?Q?CnsnmlW3lBbUjQp7pdUVIKaTpli1UUaDpG0k28vk95yfrTHYMOshad2BIEkz?=
 =?us-ascii?Q?5W5825sDm2l2yyMJSfQV0EDG4K4uMSGjQ2WiVGWWaM3c+pU7JRmK1yMcVimj?=
 =?us-ascii?Q?+1v4OKdvk2qWR92ErwDLut0mGxjAu+qCtPxCNMKOQTaxInQh4mdQWfshTE9v?=
 =?us-ascii?Q?0rKufFYKuhbQksrQic0THqWuUtoC7r+8YbwRnT8az5DicaCjunMtiXi7h/Df?=
 =?us-ascii?Q?vYH2VpIp/nXwuvaljbc7clGecxCdrWOKtjE5Dwcc5lOBAgqjDbi4ehSuKYJp?=
 =?us-ascii?Q?I+G1WhDxEgWMUZxpTKwuZrUDpJ890WzGpGR2WsuercSF8WXb8Hr2t8FeF3Lf?=
 =?us-ascii?Q?XZAtSBUTnyhOtC/k341DzGWgNhD09X1hL2KwQ/55RIHYpn4fEhnqT8FHO4qy?=
 =?us-ascii?Q?DlCFziSz8LK0Rx0Aetc2aUm4T9AYZ5HMtkih8AXScbxqKDL7PbVxKZfmzP9s?=
 =?us-ascii?Q?uhhc/Md58avVlqYzRVwkm/Ver8VGVgB5TH6C2qJ/TD/VX9u5VliLPYC/+nkE?=
 =?us-ascii?Q?l2KPEsufm/JeIPTgA1dbRVP592zQyP80MNODISVrIsXXix1DX64nQlVF92/M?=
 =?us-ascii?Q?M/UKry81Ce6KGId95ebzJu6KCj8otOHsXUSMaUXAPcdDzjFQm44VAalN0qws?=
 =?us-ascii?Q?JbpseI+wwPTWFwdVyCZaGT2gbfqFrd8ekmFU9E9uH7lPIvw7aOEnqlifLKHc?=
 =?us-ascii?Q?eX0hKUiBR67DSpnEgtP4GD4h/8pG3mb3P6SmNtnZg5WoSBSiw/VPRxjNqNPQ?=
 =?us-ascii?Q?IuUwqunx/CoXfyHaYliOfcv75xt7vyg/PUJhTPa2rntRVDWeuA21uYQLFii3?=
 =?us-ascii?Q?IVkvHch7lv7FcyVEO3TxUBy6faeVDcTrd6YYND6+EVm1Di6GyMvRwFmEOEcM?=
 =?us-ascii?Q?ddf+tCu9UsAzA1kjikvMfIR+0XUmOlgzs6dc8JJPNhvoBtCKHAlMPIRsYQCE?=
 =?us-ascii?Q?Q9vXlDzaKbKpTnLJ8QLYxfTuaTu9aaJFhbgQVACagjqdhgWHsme6qerIt5du?=
 =?us-ascii?Q?itML/WWdBTOluIo+RiMpnb/8pcclLIlndiiFjoixj5wuWFqHtbUsivBmb6dv?=
 =?us-ascii?Q?UcGamsviNg8s5Tz3R881fwGLwD4Adcyl20MfuOmq8+W8w5DIhqACgUKp9Qsq?=
 =?us-ascii?Q?lHhIqqiDIQG2ewptEgJsAg+WL3gvKsXlGJkXy0275cxqSMXiLyuskOdb9OxK?=
 =?us-ascii?Q?8m4WA6ynAG2xA4MRbR0pFxxHcorwGJAWayKvYrR65f2IxVgjPu73j0Jx91Ey?=
 =?us-ascii?Q?drv0+pqb3a3m4eTbqGu/sx6AbgqKm3w5fYiAvT/pBXGJk+tdADMMvyOSAUIG?=
 =?us-ascii?Q?ea8ffQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9ae8796-38df-43d3-8de3-08db0b7841f9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2023 15:05:33.8924
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uHMz3scIFzGyZbVScHo/QjtJPSTEjbn/1/TwZ8wHi4wIHxn+FLt/W9iqUJM7bftnLhLAzPLP4czBZQ3NZrIvn5HyqjpaRzKY7DOr0YrPwDY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR13MB6310
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 10, 2023 at 04:40:51PM +0530, Hariprasad Kelam wrote:
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
> 
> Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
> Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
> Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
> ---
>  .../ethernet/marvell/octeontx2/af/common.h    |    2 +-
>  .../ethernet/marvell/octeontx2/nic/Makefile   |    2 +-
>  .../marvell/octeontx2/nic/otx2_common.c       |   37 +-
>  .../marvell/octeontx2/nic/otx2_common.h       |    7 +
>  .../marvell/octeontx2/nic/otx2_ethtool.c      |   31 +-
>  .../ethernet/marvell/octeontx2/nic/otx2_pf.c  |   47 +-
>  .../ethernet/marvell/octeontx2/nic/otx2_reg.h |   13 +
>  .../ethernet/marvell/octeontx2/nic/otx2_tc.c  |    7 +-
>  .../net/ethernet/marvell/octeontx2/nic/qos.c  | 1541 +++++++++++++++++
>  .../net/ethernet/marvell/octeontx2/nic/qos.h  |   56 +-
>  .../ethernet/marvell/octeontx2/nic/qos_sq.c   |   20 +-
>  include/net/sch_generic.h                     |    2 +
>  net/sched/sch_generic.c                       |    5 +-
>  13 files changed, 1741 insertions(+), 29 deletions(-)
>  create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/qos.c

nit: this patch is rather long

...

> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> index 4cb3fab8baae..5653b06d9dd8 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c

...

> +int otx2_txschq_stop(struct otx2_nic *pfvf)
> +{
> +	int lvl, schq;
> +
> +	/* free non QOS TLx nodes */
> +	for (lvl = 0; lvl < NIX_TXSCH_LVL_CNT; lvl++)
> +		otx2_txschq_free_one(pfvf, lvl,
> +				     pfvf->hw.txschq_list[lvl][0]);
>  
>  	/* Clear the txschq list */
>  	for (lvl = 0; lvl < NIX_TXSCH_LVL_CNT; lvl++) {
>  		for (schq = 0; schq < MAX_TXSCHQ_PER_FUNC; schq++)
>  			pfvf->hw.txschq_list[lvl][schq] = 0;
>  	}
> -	return err;
> +
> +	return 0;

nit: This function always returns 0. Perhaps it's return value could be null
     and the error handling code at the call sites removed.

...

> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/qos.c b/drivers/net/ethernet/marvell/octeontx2/nic/qos.c
> new file mode 100644
> index 000000000000..2d8189ece31d
> --- /dev/null
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/qos.c

...

> +int otx2_clean_qos_queues(struct otx2_nic *pfvf)
> +{
> +	struct otx2_qos_node *root;
> +
> +	root = otx2_sw_node_find(pfvf, OTX2_QOS_ROOT_CLASSID);
> +	if (!root)
> +		return 0;
> +
> +	return otx2_qos_update_smq(pfvf, root, QOS_SMQ_FLUSH);
> +}

nit: It seems that the return code of this function is always ignored by
     callers. Perhaps either the call sites should detect errors, or the
     return type of this function should be changed to void.

> +
> +void otx2_qos_config_txschq(struct otx2_nic *pfvf)
> +{
> +	struct otx2_qos_node *root;
> +	int err;
> +
> +	root = otx2_sw_node_find(pfvf, OTX2_QOS_ROOT_CLASSID);
> +	if (!root)
> +		return;
> +
> +	err = otx2_qos_txschq_config(pfvf, root);
> +	if (err) {
> +		netdev_err(pfvf->netdev, "Error update txschq configuration\n");
> +		goto root_destroy;
> +	}
> +
> +	err = otx2_qos_txschq_push_cfg_tl(pfvf, root, NULL);
> +	if (err) {
> +		netdev_err(pfvf->netdev, "Error update txschq configuration\n");
> +		goto root_destroy;
> +	}
> +
> +	err = otx2_qos_update_smq(pfvf, root, QOS_CFG_SQ);
> +	if (err) {
> +		netdev_err(pfvf->netdev, "Error update smq configuration\n");
> +		goto root_destroy;
> +	}
> +
> +	return;
> +
> +root_destroy:
> +	otx2_qos_root_destroy(pfvf);
> +}

I am curious as to why the root is destroyed here.
But such cleanup doesn't apply to other places
where otx2_qos_txschq_config() is called.


...

> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/qos.h b/drivers/net/ethernet/marvell/octeontx2/nic/qos.h
> index ef8c99a6b2d0..d8e32a6e541d 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/qos.h
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/qos.h

...

>  struct otx2_qos {
> +	DECLARE_HASHTABLE(qos_hlist, order_base_2(OTX2_QOS_MAX_LEAF_NODES));
> +	DECLARE_BITMAP(qos_sq_bmap, OTX2_QOS_MAX_LEAF_NODES);
>  	u16 qid_to_sqmap[OTX2_QOS_MAX_LEAF_NODES];
> +	u16 maj_id;
> +	u16 defcls;

On x86_64 there is a 4 byte hole here...

> +	struct list_head qos_tree;
> +	struct mutex qos_lock; /* child list lock */
> +	u8  link_cfg_lvl; /* LINKX_CFG CSRs mapped to TL3 or TL2's index ? */

And link_cfg_lvl is on a cacheline all by itself.

I'm not sure if it makes any difference, but pehraps
it makes more sense to place link_cfg_lvl in the hole above.

$ pahole drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.o
...
struct otx2_qos {
        struct hlist_head          qos_hlist[16];        /*     0   128 */
        /* --- cacheline 2 boundary (128 bytes) --- */
        long unsigned int          qos_sq_bmap[1];       /*   128     8 */
        u16                        qid_to_sqmap[16];     /*   136    32 */
        u16                        maj_id;               /*   168     2 */
        u16                        defcls;               /*   170     2 */

        /* XXX 4 bytes hole, try to pack */

        struct list_head           qos_tree;             /*   176    16 */
        /* --- cacheline 3 boundary (192 bytes) --- */
        struct mutex               qos_lock;             /*   192   160 */
        /* --- cacheline 5 boundary (320 bytes) was 32 bytes ago --- */
        u8                         link_cfg_lvl;         /*   352     1 */

        /* size: 360, cachelines: 6, members: 8 */
        /* sum members: 349, holes: 1, sum holes: 4 */
        /* padding: 7 */
        /* last cacheline: 40 bytes */
};
...

> +};
> +
> +struct otx2_qos_node {
> +	/* htb params */
> +	u32 classid;

On x86_64 there is a 4 byte hole here,

> +	u64 rate;
> +	u64 ceil;
> +	u32 prio;
> +	/* hw txschq */
> +	u8 level;

a one byte hole here,

> +	u16 schq;
> +	u16 qid;
> +	u16 prio_anchor;

another four byte hole here,

> +	DECLARE_BITMAP(prio_bmap, OTX2_QOS_MAX_PRIO + 1);
> +	/* list management */
> +	struct hlist_node hlist;

the first cacheline ends here,

> +	struct otx2_qos_node *parent;	/* parent qos node */

And this is an 8 byte entity.

I'm not sure if it is advantagous,
but I think parent could be moved to the first cacheline.

> +	struct list_head list;
> +	struct list_head child_list;
> +	struct list_head child_schq_list;
>  };

$ pahole drivers/net/ethernet/marvell/octeontx2/nic/qos.o
...
struct otx2_qos_node {
        u32                        classid;              /*     0     4 */

        /* XXX 4 bytes hole, try to pack */

        u64                        rate;                 /*     8     8 */
        u64                        ceil;                 /*    16     8 */
        u32                        prio;                 /*    24     4 */
        u8                         level;                /*    28     1 */

        /* XXX 1 byte hole, try to pack */

        u16                        schq;                 /*    30     2 */
        u16                        qid;                  /*    32     2 */
        u16                        prio_anchor;          /*    34     2 */

        /* XXX 4 bytes hole, try to pack */

        long unsigned int          prio_bmap[1];         /*    40     8 */
        struct hlist_node          hlist;                /*    48    16 */
        /* --- cacheline 1 boundary (64 bytes) --- */
        struct otx2_qos_node *     parent;               /*    64     8 */
        struct list_head           list;                 /*    72    16 */
        struct list_head           child_list;           /*    88    16 */
        struct list_head           child_schq_list;      /*   104    16 */

        /* size: 120, cachelines: 2, members: 14 */
        /* sum members: 111, holes: 3, sum holes: 9 */
        /* last cacheline: 56 bytes */
};
...
