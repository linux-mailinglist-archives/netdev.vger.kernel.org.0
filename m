Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF6F4699895
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 16:18:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbjBPPSK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 10:18:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbjBPPSI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 10:18:08 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1E4D6183
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 07:17:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676560670; x=1708096670;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=3H/WMGwI7OPHRcSGLlWOtV7BXd5cvJM+Gdvsd4gANb4=;
  b=YsmkddzQZYJ4N+2k+iUOPGJM3S34SSHLEr2OMjr0li13f8RYIjOz+CGv
   l2fngc/UWEpV12i/jQH5sp+fC6chiTvke56SF6hiLk1s3vByrnmjUI+ef
   ONLcBz6FIShXeo1diyFHUOIbWxFfXtz4BR7DQekmvx9eheppNYUSxtkLk
   FoNVgTd6khVoCSIqHodzW9jZS6v+ZNgMnUNyYloVjaiXSha3e6qd6kK+N
   QNE5ANhSbThTLPkDciwoqtO+xuO3OPdXLNXxQX/5Mu2LzBTecbNvBmaAs
   MqYQBtrFwpDHm3W07qb9TsgbDSWNsxM7RHZZos0ySGAtj+JxBh5M+BXhP
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10623"; a="311369364"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="311369364"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2023 07:17:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10623"; a="779377647"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="779377647"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga002.fm.intel.com with ESMTP; 16 Feb 2023 07:17:49 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 16 Feb 2023 07:17:49 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 16 Feb 2023 07:17:48 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 16 Feb 2023 07:17:48 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 16 Feb 2023 07:17:48 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XfLFQo3WM1l2kmNrR+N052ZrSLfNKwbHLuPMN5qn3GpunmquWr8ahSLcCwHHlo+kb9mKTKpVz7UDYoMTH7JE+peVKE9y0iOvMXwOkKyBW8CEy93+xrC3i1TCsABEoH/L4rFGWXiUrJfgmPUUt77dNAV5WQE5dX1lCWqw0Ik2/gOk2ldz7E8d7Gk7zWM+smDPaYqhwumpC57MBLaTYQL05giY3WxFNRHtVA8nrTfLydzQFS9XCoiQgJWYUCvqXdzryKF1UJ0cTdDauRau0Vd0V2pW7iK/Co0Gp5re1SX1mfi4w77n0Y4yg0xXzPyWKuZUBfbBBtb2wJ9kgVlhSBW1Zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hqyMYgQB1HR6naQ+3O5qG6NjNeaT/Xxx75eHzDXU9mM=;
 b=oWMUBmpmJmWbP8Imdz5ddmRzZBQlEvNLKMUaewR6D4gPxU++8RQlA8TtNf9sgVxe8b687kdphaxS/0J7D4pQE2zIgO5rAKvqJl2oZgl15FXJcZeG+a5ysTSA4q+3r7O312BieklGUCDp4UxSWoo8shVsD8F3IXQGERZFGKGgrzHe9/HbOGHVozDoNeQ9cf3A+wM1qILIJgB3sSoJXLSoD8CGIdQPkIzf9d4dhdTzKQ7dgd6o6yCGi1crJrOBmz1rMkBU1F+TsaXZF3FwedEzzo+cXExtWQaX8xgBTQwIpwTp/pYKpg5a33BKwOCrdB9OjLDZTDRMClS9qYfyL4/IvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 DM6PR11MB4723.namprd11.prod.outlook.com (2603:10b6:5:2a0::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.26; Thu, 16 Feb 2023 15:17:46 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::39d8:836d:fe2c:146]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::39d8:836d:fe2c:146%6]) with mapi id 15.20.5986.019; Thu, 16 Feb 2023
 15:17:46 +0000
Date:   Thu, 16 Feb 2023 16:17:39 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Saeed Mahameed <saeed@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "Saeed Mahameed" <saeedm@nvidia.com>, <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Parav Pandit <parav@nvidia.com>, Shay Drory <shayd@nvidia.com>
Subject: Re: [net-next 4/9] net/mlx5: Simplify eq list traversal
Message-ID: <Y+5JEDnno1JwkCFC@boxer>
References: <20230216000918.235103-1-saeed@kernel.org>
 <20230216000918.235103-5-saeed@kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230216000918.235103-5-saeed@kernel.org>
X-ClientProxiedBy: FR3P281CA0206.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a5::10) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|DM6PR11MB4723:EE_
X-MS-Office365-Filtering-Correlation-Id: c15305ad-8644-4da7-dcaf-08db1030f567
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DS6QdthBAL8CwUVVd5g2kYGKvcpY37QpAqT7iBwhvJ8pFsE79L1Q5KEvz3PbelnoPLNfVxNcCVHBovM5VxPkbCqCEIRPS7mB1YEBuCxsJyL8d9iDtg1PVS+nvf03yfkWhES94itGYYjWiJl1rNKPmDkFmk3tHaLuDhnPrSBh0OiAdIv6YIhIEua5XGxV8mrFA+8fVuQRujwnE4EKnrRA75jniLJnXk5YXFvHDk7EnuktD4eW7pu+yY8MLS8jYJvETDiqN8Dtpzq25rAekSlIlQgka35mhW0lex9fk2RGsk8ZEo8+P82/Ol3QNH+6HsNLjKIlFwJ1BrwNnoYSF79UglsGjtBZQPsaRt3HbGjlkEPRrEuAx0EvITNyHe8tCNLFOg7iJaqXxTIBIbdDZLgJ5HwZ4FrdP8LtUqdSLFmA8lRTdzjmmw9XcP4Gd1zVyUrrSsfFgErI9o9+XmAsZQHm6DyRpED/wQi+yMSYYxQiYQtmX7NFEQjgyNvCY0bwAqTH8TUg2ZU73kqc+B2E9cRPRj2EzTSM7wXm94KDIQP2dxWrcm0JxoSAIxmzrv5w5xbujOs31WsSKpjz11KR5ZR3d2DAKDHoTQBKn5yBgnEvzGEtwFOSkYwSShpS0vcJaXUsMx/qfqU4m5M1HA71bp4VxlW7ag6SpxCuu60LjFRVedCneuDFWGJehn/d9vRFixdZ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(366004)(376002)(346002)(136003)(39860400002)(396003)(451199018)(316002)(6486002)(86362001)(478600001)(2906002)(38100700002)(82960400001)(6666004)(6506007)(186003)(9686003)(6512007)(54906003)(83380400001)(26005)(44832011)(33716001)(7416002)(4326008)(66946007)(41300700001)(5660300002)(66476007)(8676002)(66556008)(6916009)(8936002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wSzxjOXZkaWyuchWSvwk400eZte4w3o1JbIyTQcgLPnFsPVHyf21k6mN7Wfs?=
 =?us-ascii?Q?wIHdCcLlA/GLrewGStg5e6WNf9UFF2Wlt9egeVvGo5ikfgxl2hU3qm2Ibs0j?=
 =?us-ascii?Q?P5fLHAhg4AJm2efjRJPScRenoZnnlQSNuaXRdAU/+2/BnVsBvJwSJzzeissX?=
 =?us-ascii?Q?rDQh6byUuf7MjbFYGEkwMWmET9xeNY8/M9LI1CpIwKUcGiMvuU/UHmpG/ke+?=
 =?us-ascii?Q?WxOsnRgtAiCQQhsC190LQcuoQpA8fKtmvdOp0HgwnEgC6pnsmITyFezclMRo?=
 =?us-ascii?Q?cVV4qLWflclwlrGKjR8JCVfUzUQx5+qqaw2sjR3iZlov3r4GCP16sdOVbMbA?=
 =?us-ascii?Q?kOgUpbDMW4kn3NLZqNZ/3kDEW5QwI1nI0y8Ur/BmsZxxNBWhWOF6O8hiaGq/?=
 =?us-ascii?Q?dBNIKcvWO/rlqVMiC+/Sz8NeH4MV/hQnsgvbKqgZ1/dK75D+HoAQ1W/yOzLk?=
 =?us-ascii?Q?K1jyUE6BYQ3bdBtLvZ/MNxoQptjjkMTU0cwB7V/mwnHfDbcgeWe23VYDGIFH?=
 =?us-ascii?Q?JLJhzEhh9q2w7j43YLpPnJJvtSLKbRaRutuA9lagiyNqMo4pD7zub6VHzKDH?=
 =?us-ascii?Q?kfRa+BUu4PEZxh1KyFfDBxknSMoIKrIO7PXBRXRHu6rJUv0woU0o0Wi8/sdR?=
 =?us-ascii?Q?RI7lSBP+6MAErY/egEQnJFq6HDMqh7ZC2CPQEscMfoUnZ3vv7Ctoz8yPHO1c?=
 =?us-ascii?Q?Lr6WBX+92VEGxgEbfEE+MP4oooH1gPO0r7ziN3bRsYGLaZzBjYOoCzATbB6U?=
 =?us-ascii?Q?dj+CRI9RVjBha6aHjBvkZFWfj6Q9Xf3wgmw1p1fv4pDlRG1xN1Aj8thkjt+U?=
 =?us-ascii?Q?Lj9ByNbWXFKLMReQrv0Qs8fJ5g/hGPPqa6ODSzTT+QtmzCIAJyClJaYL0Ewb?=
 =?us-ascii?Q?8xHI/VZbq2XBuW93zI6vxC2Q9tljAucUiqHYnWQSR2KXwGpW+x3XZ+hQzb66?=
 =?us-ascii?Q?SN/cWB3Ti1jaVQakoW9I0iE7mSCJSW20WwyYY+nlSTnQw0H3j2eQpHUfuWwF?=
 =?us-ascii?Q?FLbTE+6kjrnZ1r29Mdwc7xVmxU35e5VxY50aHSwHqEvOoBjTECUdnc7SI+Hn?=
 =?us-ascii?Q?7FqKMosPdPKFUCnEHLMuzA3itkp9dhLRyTVX63RHHfNkXuu/0Ev6/Nyr0EhR?=
 =?us-ascii?Q?9jLQPT9rfomN7Z2E/tNP16bOuNFHIdPyLwsigvzmk5s9vi7e8sdXmslYF479?=
 =?us-ascii?Q?CmtdtrtguPhr54wdljFwVGRADezn7gYBIlAzDxKISXIWIPmzDeR0ydLoIUkX?=
 =?us-ascii?Q?9QMqVNL0pq14PprQW7rJaCyQUM1NHSW+JNgNedLDUpgGU1aUcaAmrdY/Ua+Y?=
 =?us-ascii?Q?Tsbfah22vCyPW+x7iIq9EdudrmONciVJcq7x5ifyWshA+li4NfWzosnUeIHZ?=
 =?us-ascii?Q?RD0mSjjxivyQniB/1+oEtTBUW1okeMUZqY9Vu06IypFQ/7N1aD5WxtPUGo/4?=
 =?us-ascii?Q?yUXiqtJ9XczUOwdD1/8qtLp5ovv3pTiXR6fSfqUYgIL6cwdq3xi7I1uTGJ0u?=
 =?us-ascii?Q?ZZT1cqDVdqDErJbpw90DTkeE9OJz4CBSpl9YuGeV6PH5qS98o4GiqGYm3F+2?=
 =?us-ascii?Q?DKYqyBg6cxdJYDN12LPXljfU9Qn6EfzR1YqEd6lBQn+E6qC6wTEwcqesJPhB?=
 =?us-ascii?Q?GPwOmn497ha5lqneP3vtdoM=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c15305ad-8644-4da7-dcaf-08db1030f567
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 15:17:46.6318
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ngLRkXC9Tbg25vNz8ap3y8nv2kp3iurgRvU3zYmqmOpLW8OUhjptxdz03o1Wpl1TmsV2dGgjpu/DmVM/Am6gIbOs2nk3w+xluXxtJ+oIReg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4723
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 15, 2023 at 04:09:13PM -0800, Saeed Mahameed wrote:
> From: Parav Pandit <parav@nvidia.com>
> 
> EQ list is read only while finding the matching EQ.
> Hence, avoid *_safe() version.
> 
> Signed-off-by: Parav Pandit <parav@nvidia.com>
> Reviewed-by: Shay Drory <shayd@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>

Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

> ---
>  drivers/net/ethernet/mellanox/mlx5/core/eq.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
> index 66ec7932f008..38b32e98f3bd 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
> @@ -960,11 +960,11 @@ static int vector2eqnirqn(struct mlx5_core_dev *dev, int vector, int *eqn,
>  			  unsigned int *irqn)
>  {
>  	struct mlx5_eq_table *table = dev->priv.eq_table;
> -	struct mlx5_eq_comp *eq, *n;
> +	struct mlx5_eq_comp *eq;
>  	int err = -ENOENT;
>  	int i = 0;
>  
> -	list_for_each_entry_safe(eq, n, &table->comp_eqs_list, list) {
> +	list_for_each_entry(eq, &table->comp_eqs_list, list) {
>  		if (i++ == vector) {
>  			if (irqn)
>  				*irqn = eq->core.irqn;
> @@ -999,10 +999,10 @@ struct cpumask *
>  mlx5_comp_irq_get_affinity_mask(struct mlx5_core_dev *dev, int vector)
>  {
>  	struct mlx5_eq_table *table = dev->priv.eq_table;
> -	struct mlx5_eq_comp *eq, *n;
> +	struct mlx5_eq_comp *eq;
>  	int i = 0;
>  
> -	list_for_each_entry_safe(eq, n, &table->comp_eqs_list, list) {
> +	list_for_each_entry(eq, &table->comp_eqs_list, list) {
>  		if (i++ == vector)
>  			break;
>  	}
> -- 
> 2.39.1
> 
