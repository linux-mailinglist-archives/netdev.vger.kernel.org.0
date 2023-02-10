Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F15B469219A
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 16:07:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232598AbjBJPHS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 10:07:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232228AbjBJPHQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 10:07:16 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2112.outbound.protection.outlook.com [40.107.220.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5B4334F73;
        Fri, 10 Feb 2023 07:07:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F5ldElKReCf86Sc8q9DGAWqznNPU8ZTsWakYTne3qKPARGaj87S5dv7nh3EhqTJYyBDkpIxhw5uFteFwasCVotfS6kuEQuqrO2c4I/X3uFCnDLwf/fXiCR8GVK7FP/XOfdsMusrqSy11rbgOpzIycgWQsBn9R0OovPv4IPYA+bc3lYOmNRlndqvRy3fD/ANwNph8dh5GT8Y2IS9WPA90PMFhZujnSbDFGdbUYrlAgk9VBClmc5hnaqdzDPfM7e8qmiWC1026Z/+PlRvZn5GkpUI5MZmqn6x2CIk7s2JhAHa6gHD2C9WayJGv2wc0YJsPjCf7arLR8xqG+o7BnfZVow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v4pBAzB3nP54npUnVBj+pzgmLdf1w9GlbsM3T9xwL9Q=;
 b=YgBbPhQytxeYy3YKjEr8jMzUzx4+a8jvTRRwFHuNlnNsabHLkW5xCaV/eYpqeHreK53owpBqWPkfzkDUgFXSwU4fDygEQCDlmEHgM28A/dQNMl1Fv4oZYgLEq0dAsn5ZWCcRBaFQU5EKGzIReOI8emrYvHszzeM8RMZaTiTe7mPb5y3Kj8BfG8MQHW9c/l+Iyrho9J1rbF574FWCiAZCadNcMLgh0frGPFduFAyZQ/qZEXrWdrxs6innCsiVOj09gBITAuwIP/0xnr1yt3LVxHXjZFQ5I3xGkqrsOyxvpff4ATQty6foz6BBA87l2T05sUB8KOnNhGForWJpaYww4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v4pBAzB3nP54npUnVBj+pzgmLdf1w9GlbsM3T9xwL9Q=;
 b=s25hszBnB4j+ARlHfsHhz8ExbHueEXHIh0znse2jXofrukIrgnlXvNUw7YpAoOcJZBgTQSmlb40w7t+aygQf/P9NqQl4BIJM296yRYO7efVfKk4eUdpaD5l85pjwgCuv/mMXhCZniPTOlYThfZVO3SheBENwXPBmLenfqKhKBXk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY1PR13MB6310.namprd13.prod.outlook.com (2603:10b6:a03:52e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.19; Fri, 10 Feb
 2023 15:07:00 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%9]) with mapi id 15.20.6086.021; Fri, 10 Feb 2023
 15:07:00 +0000
Date:   Fri, 10 Feb 2023 16:06:51 +0100
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
Subject: Re: [net-next Patch V4 3/4] octeontx2-pf: Refactor schedular queue
 alloc/free calls
Message-ID: <Y+Zdi48x+g/Ypre+@corigine.com>
References: <20230210111051.13654-1-hkelam@marvell.com>
 <20230210111051.13654-4-hkelam@marvell.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230210111051.13654-4-hkelam@marvell.com>
X-ClientProxiedBy: AS4P190CA0026.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d0::13) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY1PR13MB6310:EE_
X-MS-Office365-Filtering-Correlation-Id: c3bffb91-5cb7-41c2-3276-08db0b787558
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hrsgXajLiiak31Xp2nGsMzZruXOsmQef5rMUrk5J7ru3L3rbFKKu8YkVtXlwIHqP10Hbf+7ePS1ANjRLSygbJbhnvf1JfXi/6RCMwfN+X93tLoZ4XWApxhXqV3Fdq+w0ss83hT9mnGaTWi6HY3nKTOg/sbSP7nltw/swhrX9pNaC2fL9VKIygXQiCcCeiHyV/a1qjh0UXaYRWX8hGWUZHCZe0/KF+2mJHr9tT8S7Fs4i/v63iMT+dpnRitmxMjUATE4tEZVVIgGmpWwtSOkL8l6ChJwF+oZ1KRtdzh1tla1ySAGwu77AUofN23UROVAw0E33hmNfLGCU0u+NgdXa42TDrHIKsXUFWaFw7pr5uinv3dKm2kTlLZ36zcQR/P/DigoQhDNZrAsXBIq9Ge4Doo8A6wnpBJqQ8N0iGehvPC/VF7CHSYn4NgjILYTwj29DC5vFhUFQmJgmcKUQhT9Qg4w/bzKXVKOJ6gt8DvI1lcHcj4ZMf/CoO002GMp/ULemCSLatGtd3xhtVHkC/0B64R2yF+brvs0kaC+aVv+FvRaucHMGe1+wgcQdGk8T0Rwu/5zFYJM8R0dRHgkyi6yuoILbj1pWbxd08zcV2WD8N6Lo8b6XTG6dFu014DNn1bvBcM8ztD+Ud174T4mtNPlVzcvOcOgAkNKR/Ox/fSQ8ZPEYZshjdesihrHe4T+WTdJs
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(39840400004)(136003)(396003)(346002)(376002)(451199018)(5660300002)(7416002)(86362001)(186003)(8936002)(2616005)(38100700002)(6916009)(83380400001)(6512007)(41300700001)(66946007)(316002)(4326008)(66476007)(8676002)(66556008)(6506007)(6666004)(478600001)(6486002)(36756003)(44832011)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ioy45iJPLWGiHtdKaoJFbEKSYq1xDfzk7Esn39kNPN4UR4e4WVdGRifEYaXe?=
 =?us-ascii?Q?XwWN1/wS7DdHLjDvQ+Drn3KUDMtKS/qrSk1i8QjrnhsosDUbwyLHh/oPLZvr?=
 =?us-ascii?Q?UF8Es9T+73iLBeUoya0FvTJaqnQoi4g/2M86Ck1h9dYP0I7TO6gFyJn12RQl?=
 =?us-ascii?Q?G92BW8ilTkz2PA79Wz+YcbuvF9D+JYBztfEWIa4UXnEv/kigNhQsJpYqe6Xv?=
 =?us-ascii?Q?ROhtC5Dlqpo0KMw+BkSOTqgYIG4Z/0p3r763YkOJ11bBCfKz4GmlVc3GqRC3?=
 =?us-ascii?Q?miXeVyFF7iObv65zUnBFkGM/5eg5ZcaE48mIy5tENc6PcZoke/8FYQWkLsPh?=
 =?us-ascii?Q?g4Hk7v6V8RzyB5jpts/gGs41+Jka7CxaFYetcf+dOWbYAsfyqxsZOO+75asU?=
 =?us-ascii?Q?q/2SbC5/1c353mV5wyvy3oe2IK3NVtkL7aHfewaq9ekbxE6w+j+04TZhhVPS?=
 =?us-ascii?Q?vzD3ATler/lIsoyeiTv2JAzoyK7CKQU2OOqDis+5RnPqdQdZYAQS4nB6LFZO?=
 =?us-ascii?Q?4FAPiakVS1/QSLruxg+kpTZALdYT+xBrtOqn0+mnjxvejRB2PbcnWy2rGRSg?=
 =?us-ascii?Q?jMC+F8x0DV0QjPNczi2r+TxpwO25wpiz3d2GP6Wc3lYDt6oLnvXlOwUTCS6N?=
 =?us-ascii?Q?G9AMhPEPdWdYGP3ZbT9+1KVJ51P75eC+MbH1N0sW7DSzi5Wt3vvwxUsXhtPM?=
 =?us-ascii?Q?5skF7/tteaoY+kYPUZqtb/tRMkdBPab8kFywANBNVRIjdaMG/tqdJ7o7Oe+h?=
 =?us-ascii?Q?biVAmqAHnBtzGbx3+2nyyfSaZm08ZwebWFCpG2qM5/Eij/UMFmFltFv/ic/7?=
 =?us-ascii?Q?NXSPwA6IvIPbsGJRWD76cPPM4iRchx+SK8BG3dPanHb0SSd5SDuVGSCD5uVD?=
 =?us-ascii?Q?hdyr1YdFr1FeTE2U8wEy3H9/Z3jTxDNKoTwiL2VTefeyFQgaoqGuULvf5BqG?=
 =?us-ascii?Q?sirSmdIaxXsJGK0Ph13Iz9A5No8ZWo7iWOZGaHLg0eip73fqa3mApCMUOqQ8?=
 =?us-ascii?Q?jT4jyntKkT9hjPNv7LZ2/e4Qmx26Ok6GEy4fRKylLlwD955qKPMFzTRKQvrx?=
 =?us-ascii?Q?iefUgHvkJaL0Pm01Iu8BRloR8jIl/ggZ5HaQmpFq+S54hp7OhmOCLitSyF3C?=
 =?us-ascii?Q?ZqTfJn56Hd8Pjz1HhcfDTxtOwUQSuecv8c8wqzHg4EgTQfPXxa/+pVHwi6Wl?=
 =?us-ascii?Q?3G+VADHSd+raRPSuSMaLaxeoLgEpJSswb1blxwjT0ZWtBlmh3RTA6lkQwWdZ?=
 =?us-ascii?Q?h0khg+e5qk+uAEKp0F490yYGpliGFB9rJuRuvYoI70s5u1ExQmDM6uFxKnpp?=
 =?us-ascii?Q?aBApzPOl8EiERhj42UTM8RMirRpkr7T5DLMllhtXytD1H4KIrPeYyLTDxq1M?=
 =?us-ascii?Q?Fh/rZuts6gp5ei5iPv/GSgMb1FoRHTdipvupm4AH12HyPnqz+IaE/XVUjfMh?=
 =?us-ascii?Q?A8Vf9LsZO7oAmChW6hMfBQ5IIoS5VW9gheTDzE0aUKZykhcBmbExo1MeHYSt?=
 =?us-ascii?Q?q99ZtgrdT6P7idtja08kKpt/1KwKpWxIIS1EDbamzG8oNw7b+Mr54gFXLCfd?=
 =?us-ascii?Q?sJ4H6i+DcFkvWcYhhVhetsWKHLxTAI2NBQLpn+4HPwpVIoSFd/JeEm1Ma845?=
 =?us-ascii?Q?fHVHGi5lGI5NeE6djKCtVybjXk5XkF9EJKt5LhYl/puVsSHmf+Zer9j021bk?=
 =?us-ascii?Q?MrBopQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3bffb91-5cb7-41c2-3276-08db0b787558
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2023 15:06:59.9675
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GhUDS9BN5d+nQE03gVfMKW5j7SsUJz5FKjv7LW33l9SHN2NFPq8N957a73ny/I6W/E4T0gcVjg+1Upm3yC/pa2SGdpg7dmpxZw5JD0rMIOM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR13MB6310
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 10, 2023 at 04:40:50PM +0530, Hariprasad Kelam wrote:
> Multiple transmit scheduler queues can be configured at different
> levels to support traffic shaping and scheduling. But on txschq free
> requests, the transmit schedular config in hardware is not getting
> reset. This patch adds support to reset the stale config.
> 
> The txschq alloc response handler updates the default txschq
> array which is used to configure the transmit packet path from
> SMQ to TL2 levels. However, for new features such as QoS offload
> that requires it's own txschq queues, this handler is still
> invoked and results in undefined behavior. The code now handles
> txschq response in the mbox caller function.
> 
> Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
> Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
> Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
> ---
>  .../ethernet/marvell/octeontx2/af/rvu_nix.c   | 45 +++++++++++++++++++
>  .../marvell/octeontx2/nic/otx2_common.c       | 36 ++++++++-------
>  .../ethernet/marvell/octeontx2/nic/otx2_pf.c  |  4 --
>  .../ethernet/marvell/octeontx2/nic/otx2_vf.c  |  4 --
>  4 files changed, 64 insertions(+), 25 deletions(-)

...

> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> index 73c8d36b6e12..4cb3fab8baae 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> @@ -716,7 +716,8 @@ EXPORT_SYMBOL(otx2_smq_flush);
>  int otx2_txsch_alloc(struct otx2_nic *pfvf)
>  {
>  	struct nix_txsch_alloc_req *req;
> -	int lvl;
> +	struct nix_txsch_alloc_rsp *rsp;
> +	int lvl, schq, rc;
>  
>  	/* Get memory to put this msg */
>  	req = otx2_mbox_alloc_msg_nix_txsch_alloc(&pfvf->mbox);
> @@ -726,8 +727,24 @@ int otx2_txsch_alloc(struct otx2_nic *pfvf)
>  	/* Request one schq per level */
>  	for (lvl = 0; lvl < NIX_TXSCH_LVL_CNT; lvl++)
>  		req->schq[lvl] = 1;
> +	rc = otx2_sync_mbox_msg(&pfvf->mbox);
> +	if (rc)
> +		return rc;
>  
> -	return otx2_sync_mbox_msg(&pfvf->mbox);
> +	rsp = (struct nix_txsch_alloc_rsp *)
> +	      otx2_mbox_get_rsp(&pfvf->mbox.mbox, 0, &req->hdr);
> +	if (IS_ERR(rsp))
> +		return PTR_ERR(rsp);
> +
> +	/* Setup transmit scheduler list */
> +	for (lvl = 0; lvl < NIX_TXSCH_LVL_CNT; lvl++)
> +		for (schq = 0; schq < rsp->schq[lvl]; schq++)
> +			pfvf->hw.txschq_list[lvl][schq] =
> +				rsp->schq_list[lvl][schq];
> +
> +	pfvf->hw.txschq_link_cfg_lvl     = rsp->link_cfg_lvl;

nit: extra whitespace before '='

> +
> +	return 0;
>  }
