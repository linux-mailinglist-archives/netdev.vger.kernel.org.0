Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 300005F99E1
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 09:23:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232410AbiJJHW7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 03:22:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232411AbiJJHWj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 03:22:39 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E64995BC3B
        for <netdev@vger.kernel.org>; Mon, 10 Oct 2022 00:17:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VRjvXIrA0rUZKlx69mXfM07sD4GyxLQqieumk5T5k4WW0Vo+eptZHjG8vyJORk5Rjc1lURApEi60zTEjWsNNRUnUZZYBxJ1GuzFvHSO7aKtD7ggT0pHegmqdGUUiFf00zthtRzDcc7tfqIKq0zhQU6+PjB3ebXjCJpfnuzPMmTuWGCVSwhpT5gIKsUVozOo7KV5yZsVgB2fIJgK23c9tpAIxbUxP/DCMFIBUOLCZMl9dd6L7SO7eBMOQmn75P19ArjDsFfd8nNn7x6WJ8kgefq4VV06GFuSbpKGQ8vXCFS65k0+lPgHM+FPciel6WNmHoA0ta+eiPX0p3mW2w+iQ9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VBSqbKkqJH20bamy6Jdo7joHPfpPh1PWZcV9tg7rcC8=;
 b=WeZX2KepsrmgSoPSy/nmyMScks1qn4wZ3m6faVbt+w1QSemUz8025FxiVpKG6UZLb5eegTtGHNyWGT4LvZ7kf3/aDTOMV68aRarz3oh4VDshbVUUAs4xL+rwtLfC5eYsqR/q6P7n83mZPE0o36dwjjleJptw7kSYlZj2lFOPg7q9V1pHZak2Usi2fUxNJQfqm57BV4Ctv4y2+dFY5c5+abyg9mmULwMJefXCRd5+FKt7975xkgCr8dfkEimGeJjIsJ76wemw3yElDrAFOzaQJpHa8/JwPYgNCWAJiF6xl/6hoMOqcYasduZTsMSKwmHgEAaTsAl18M/zCTvzsGvrvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VBSqbKkqJH20bamy6Jdo7joHPfpPh1PWZcV9tg7rcC8=;
 b=vO43QXrvqViS0Wbsc8nZuKe7/g00H/ogBD+04NtnqKaq5xkFes3LRjpnu1irKY6dpT4keyqRJ2vC8OFDjRPNY1NL+ZxS0MaR8CBLGfYG8xmSHJPoHabiD6d2zhNWBHPh3P7aAgIvDSgn1+h5kIc9AOjHJ6LrLQGpccNaEEtk8BQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from DM6PR13MB3705.namprd13.prod.outlook.com (2603:10b6:5:24c::16)
 by MN2PR13MB3648.namprd13.prod.outlook.com (2603:10b6:208:1e8::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.11; Mon, 10 Oct
 2022 07:14:42 +0000
Received: from DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::3442:65a7:de0a:4d35]) by DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::3442:65a7:de0a:4d35%7]) with mapi id 15.20.5723.009; Mon, 10 Oct 2022
 07:14:42 +0000
Date:   Mon, 10 Oct 2022 15:14:34 +0800
From:   Yinjun Zhang <yinjun.zhang@corigine.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Simon Horman <simon.horman@corigine.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com,
        Huanhuan Wang <huanhuan.wang@corigine.com>,
        chengtian.liu@corigine.com
Subject: Re: [PATCH net-next v2 3/3] nfp: implement xfrm callbacks and expose
 ipsec offload feature to upper layer
Message-ID: <20221010071434.GB21559@nj-rack01-04.nji.corigine.com>
References: <20220927102707.479199-1-simon.horman@corigine.com>
 <20220927102707.479199-4-simon.horman@corigine.com>
 <YzVWsOP1R/FGPYgF@unreal>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YzVWsOP1R/FGPYgF@unreal>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ClientProxiedBy: SI2P153CA0032.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:190::23) To DM6PR13MB3705.namprd13.prod.outlook.com
 (2603:10b6:5:24c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR13MB3705:EE_|MN2PR13MB3648:EE_
X-MS-Office365-Filtering-Correlation-Id: b77d1edb-f8b6-463b-57ef-08daaa8f1a3f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uwjjsprs0xiJ4rEzz8L40XP+FXdiwS0hgC/EuTEQCD/yaFKRutfMHJ1hFkURTe6IPTpZABPYtz3Xm3E3oWlgPzKOBZCr9Qn9ssVYuSkyPfegqZN3VSTRqdscz3Dw8oaU4Pt4UK6E/+ha+szRgHpfosCiLShEZXvnWJfKMS0lZrv3R9jj9V5dlXJaR9ZNSGvmCTbOoY1HJw9hCI7EP8oTp/X254laudh/E+mDgb3cpuMN54UiFzwOwBT9HZSnMlrv/lYBp2mOc6IWanNEAHlzdgU89KPmWxTyPXJxB9fXAE1BKDcXVS1uglm+1mFZjTQLjjrGx6Y2d3dM9+kh5WuL5kCWgadW2tHYvme4msKf4YlS39WB0XOm47wNcL+ny9H4QXxX0T6cIrxW3bggUQLGHwWPaos9ZnMwl/frjn2YRh35DnD9h5qqUv4P644vNFGJOaNIWkG4cRgOsuBAR8qYuPovQ+EJ59fARLPKT2/QcTCkDXHu/xG3VY8ddIyWQpCsqcKJ++I24qbZ7yT3ENHM+T02BS4YH48jseIH7J1/wDThSjAFnZLX33yiFKrIj5M3D8WGvJk5eoMghGWLqgjlx6p5eQjKDlTz+Pmr+Lk/DB1HxT1tyVREJhN22lV21LdlqybdpckfbYoIQDwNXrAgVNITOscXi/QtReXO99h25zTVhdJtCrw6ZRTofDsHJQ3uyZYrJTkBBDdBe2cmpghIqPzblPMzOCm/CgKIHe4/AweUYJPdIvX27Xphx8zbwG22/RPzXibBBcnS3JDeEeeM7Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB3705.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(39840400004)(396003)(136003)(346002)(376002)(451199015)(83380400001)(26005)(107886003)(5660300002)(8676002)(8936002)(2906002)(41300700001)(4326008)(54906003)(66946007)(316002)(66556008)(33656002)(44832011)(6916009)(86362001)(66476007)(478600001)(6506007)(52116002)(6666004)(6486002)(38350700002)(38100700002)(186003)(6512007)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?02RIrUgH2eVPtCAYsV6RccBKvm/1z+DsHF/h+lp6YN1V0Q9F8DcTjmX9I2CX?=
 =?us-ascii?Q?2e5bmDxfNs4aTkTW8KnUi7cqfUatsb6Fxx7qfB96zfF+wz7EbPEZG/jzPFxO?=
 =?us-ascii?Q?0eMknEmR1gRVStZ3ZuN45IJJZCkB2ulUlBJ/LNbpxivgGJi+b3ztd4bsFKaF?=
 =?us-ascii?Q?6Fdw0KPo7113HNqjcyO8uiHP1a7SKPSTn28Lk48bhEo+hGI8GVHl56CcUq0G?=
 =?us-ascii?Q?/lpQuOpnoWGszSHYxAAkoZvkRDlbLwRjuDLRBVIqmumPgvB2Efv4EjT6OGdA?=
 =?us-ascii?Q?UgSwEV+BYWyg+66+J470dxV0sZgSZg4tjEZbrx2jcNUs8PFzYUlS0ZROdrx7?=
 =?us-ascii?Q?j+2uGmQ4JfutqICx2vQD/QKYpAY5R1Vy0oGvLfELsP/X/3tyOCI3c1yw4RhU?=
 =?us-ascii?Q?EUaUo0OJfiJvf3Z+QMSkyPEyVDua5jYSFzX9pyWLJAGz/SCiDb6MupH0gX3E?=
 =?us-ascii?Q?mrlOxDS3TSslGWaV5vRbvLZrB23gEAA0SuRvdIMuj+WqWIaekxLdfdDxIjGT?=
 =?us-ascii?Q?MRXGISEsbxQz5mJFsKTriO94OsoiZcrzgqVP7SqKyPlIb9x6hI5BHE1P6G48?=
 =?us-ascii?Q?sXzkTiHtJWwlFKo1Uii5UjMENS7b8QFxfdcja3brH4X80nML/UyYPlkz6h6Z?=
 =?us-ascii?Q?IdAI5Twmtgtoy1SAyER507yDGKOD27cyDrt6kWuh7fdP/oXBkgnZBXnyYf/O?=
 =?us-ascii?Q?fcdihYc0YaYprz+qjvxyfd5oCmpw/5K4CYJ/KD/zf1GEElekgXK4R8E+K4aS?=
 =?us-ascii?Q?QpnLmKFTrr0MYrC1AMpBOpYTMcVBgWb+15L0xwFtC2FSqd1G6KWMJijfvpqj?=
 =?us-ascii?Q?9XO8QM9MM767ftOl+GuXpsssFP31QotXdFn0ep09aN5s+43j/fXewLLsWmJP?=
 =?us-ascii?Q?gw8Ldgg0s9SBzHduRjmVXXPs2jXWYlawZRLyYBrhpi0CYmsEx8qwgJp26d42?=
 =?us-ascii?Q?g72KyzHlJjk0CJIrfnbc4iFivgEdkcXtoqC8Gdysf0UJ3ZOpNSNlEjeEUw9A?=
 =?us-ascii?Q?qyTrDBD2niJvZLWy1Mg7cEbwE7dSLAtCg8EYXumtdIRnKJF3VCHSPJhhqBu+?=
 =?us-ascii?Q?Hnx8FESNysUGl1utPQ06lekUfYA7rTC/EWSU3Vz0rPnegIXo5HUiD/TLg7tb?=
 =?us-ascii?Q?J3EESRJBYeDoliRD8HAQPH5oqmuo6SZIKl2JruaQhBV4vojMAZy8vuEAdtEN?=
 =?us-ascii?Q?Sp/jLESiojmrvWxi9Pn/qrqmKeFNjlYkxZRQTOGqGMBwc/ia5fo19KXBF3Ja?=
 =?us-ascii?Q?4J7Nx+jOA/1GKFzEm9La1qMAKdSEurtKDnNNy5KBou8Ns2hoXnuR+CO8sxxR?=
 =?us-ascii?Q?kT/DNvwc2HvLszjgkWeQ6grSYvq7LmnLfPe6POKwXzNAQq7EeidvgJ4cgujZ?=
 =?us-ascii?Q?lmYg69tMQVA3/pVwuN+u7/cKiuBXsLlt6ahDfjViQ9m8O7OCflR2ZkMG8bwZ?=
 =?us-ascii?Q?6X3+3ruoB8ipwwLeP8zGzewVH0z8KLeYxHc6jk+wFzz2VNRlhyBilhACvcou?=
 =?us-ascii?Q?VUIW9xuOiLKFXjvWwmQx0j4YvoTEvhCyzTcSyRKfPloetc0MrtMI9oe9z/IF?=
 =?us-ascii?Q?hurmo3MSuUo9Mcy8bHMqNnTHkW62v4Z+jsojZWtIwpSNbMC+VAX9v7tcmGgM?=
 =?us-ascii?Q?9w=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b77d1edb-f8b6-463b-57ef-08daaa8f1a3f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB3705.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2022 07:14:42.4843
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UcWPMnMbCmw68el/kR/dq46JgUsstF/g4iNIyQWSZ1RKq/TD+eGRJP4qnQU5HOBG+G/+Ien714jTNwSKg4sTv9EAtXKJMmKRzlkCOUxDFQM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR13MB3648
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 29, 2022 at 11:26:24AM +0300, Leon Romanovsky wrote:
> On Tue, Sep 27, 2022 at 12:27:07PM +0200, Simon Horman wrote:
> 
> > +	mutex_lock(&ipd->lock);
> > +
> > +	if (ipd->sa_free_cnt == 0) {
> > +		nn_err(nn, "No space for xfrm offload\n");
> > +		err = -ENOSPC;
> 
> Why don't you return EOPNOTSUPP?
> 

Here means no available sa. I think ENOSPC is more appropriate than
EOPNOTSUPP, and it looks like xfrm will fall back to software mode
when driver returns EOPNOTSUPP.

> > +static void xfrm_invalidate(struct nfp_net *nn, unsigned int saidx, int is_del)
> > +{
> > +	struct nfp_net_ipsec_data *ipd = nn->ipsec_data;
> > +	struct nfp_net_ipsec_sa_data *sa_data;
> > +	struct nfp_ipsec_cfg_mssg msg;
> > +	int err;
> > +
> > +	sa_data = &ipd->sa_entries[saidx];
> > +	if (!sa_data->invalidated) {
> > +		err = nfp_ipsec_cfg_cmd_issue(nn, NFP_IPSEC_CFG_MSSG_INV_SA, saidx, &msg);
> > +		if (err)
> > +			nn_warn(nn, "Failed to invalidate SA in hardware\n");
> > +		sa_data->invalidated = 1;
> > +	} else if (is_del) {
> > +		nn_warn(nn, "Unexpected invalidate state for offloaded saidx %d\n", saidx);
> 
> You definitely need to clean all these not-possible flows.
> 

Do you mean clean those sa entries? We clean them by invalidating them.
You can see `xfrm_invalidate` is called in `nfp_net_xfrm_del_state`.

> > +	}
> >  }
> >  
> >  static void nfp_net_xfrm_del_state(struct xfrm_state *x)
> >  {
> > +	struct net_device *netdev = x->xso.dev;
> > +	struct nfp_net_ipsec_data *ipd;
> > +	struct nfp_net *nn;
> > +
> > +	nn = netdev_priv(netdev);
> > +	ipd = nn->ipsec_data;
> > +
> > +	nn_dbg(nn, "XFRM del state!\n");
> > +
> > +	if (x->xso.offload_handle == OFFLOAD_HANDLE_ERROR) {
> > +		nn_err(nn, "Invalid xfrm offload handle\n");
> > +		return;
> > +	}
> > +
> > +	mutex_lock(&ipd->lock);
> > +	xfrm_invalidate(nn, x->xso.offload_handle - 1, 1);
> > +	mutex_unlock(&ipd->lock);
> >  }
> >  
> >  static void nfp_net_xfrm_free_state(struct xfrm_state *x)
> >  {
> > +	struct net_device *netdev = x->xso.dev;
> > +	struct nfp_net_ipsec_data *ipd;
> > +	struct nfp_net *nn;
> > +	int saidx;
> > +
> > +	nn = netdev_priv(netdev);
> > +	ipd = nn->ipsec_data;
> > +
> > +	nn_dbg(nn, "XFRM free state!\n");
> > +
> > +	if (x->xso.offload_handle == OFFLOAD_HANDLE_ERROR) {
> > +		nn_err(nn, "Invalid xfrm offload handle\n");
> > +		return;
> > +	}
> > +
> > +	mutex_lock(&ipd->lock);
> > +	saidx = x->xso.offload_handle - 1;
> > +	xfrm_invalidate(nn, saidx, 0);
> > +	ipd->sa_entries[saidx].x = NULL;
> > +	/* Return saidx to free list */
> > +	ipd->sa_free_stack[ipd->sa_free_cnt] = saidx;
> > +	ipd->sa_free_cnt++;
> > +
> > +	mutex_unlock(&ipd->lock);
> >  }
