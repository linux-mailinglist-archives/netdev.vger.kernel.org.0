Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A155E6E976A
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 16:43:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232270AbjDTOnH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 10:43:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231394AbjDTOnG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 10:43:06 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2135.outbound.protection.outlook.com [40.107.92.135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1173D40C0;
        Thu, 20 Apr 2023 07:43:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hgACX7DVKvsnP4GDZcxRRsWyQC68Z9fuL/qCcTXNFdjekvtwhQUcILZN3xkoWhnlUt93CEVdwoBiLQijJkG2716D4LL8LsMTjZzvq1Z7wuqDrhrZv6ayg5JJef8pPRL3gqpYfBOtkqD1E5HjbRS8VkTtLUIBdih2Y64VdF9uLZPub7lbR5xHQHSDuVUjvi+2EA/a9jxOi35fFpxOg8nnAxsZWGKN/raPcVFDUtAx4TUiwnwfVc7MABRZjLYPCD1kFwBDt54uRu5XSkTUFVDWb/k8KcS6W3IzHrgztW/yyizisBU/D3ZG816/NkuWJ7U6BPWtFWSdL0ZXSQ9VpM3D3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6Jc7EbFD8MBeACeRUgQ0HsastDgnPUKlgLvCa/0Gq8k=;
 b=QCXKfm2zmSEDwlGKmcBsmX0JcC7KhWgi3QM3+SkFithVyiqRMy39gWsUqtQRdd3J9XSTkqc9AlLD+HueZdetgu3qCREgX7T/i6roabgM/bj5meR1og/qEjTVpdnYhmEjcGhBEDQgEN2Z/at9mf5qkeuib5o9s3F04Jia7oWEvC/NVAt1mz5xzHjaaDimvXKPx6JyqMssNNaRKOrI+WcqYG3mGEP8d5VmymMBFcqpk8qD25oi7g7C6A2fElIUYvMtah7NR6HpEa46izn5mppZy2u2Op0KjyyrKk2OwSzjs7A703PZUbmH5ufX3qxgB0tcMbqXAkIpNFKc1n+Kk9bDcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6Jc7EbFD8MBeACeRUgQ0HsastDgnPUKlgLvCa/0Gq8k=;
 b=i+4Rwv3KQ5+U5RX0EcbUgX/QEArQGmkUAku+SFP14KLCXc2L3H8aPuwcTv/gMs0j7PJZnQsvj7NWgWQrt+7EZ1AWJ36l6/FgTNrpvdVPK3MxoukJE8okdbBo4YE4pZ0vTFoPngOxIKVo5OA8cuD/m8Jj0VAZuDF1//saLt7PxT4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB4410.namprd13.prod.outlook.com (2603:10b6:610:64::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Thu, 20 Apr
 2023 14:43:00 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%4]) with mapi id 15.20.6319.022; Thu, 20 Apr 2023
 14:43:00 +0000
Date:   Thu, 20 Apr 2023 16:42:52 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Michal Kubecek <mkubecek@suse.cz>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Petr Machata <petrm@nvidia.com>,
        Danielle Ratson <danieller@nvidia.com>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Aaron Conole <aconole@redhat.com>,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net-next 3/9] net: enetc: only commit preemptible TCs
 to hardware when MM TX is active
Message-ID: <ZEFPbNCNDWy0c8eK@corigine.com>
References: <20230418111459.811553-1-vladimir.oltean@nxp.com>
 <20230418111459.811553-4-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230418111459.811553-4-vladimir.oltean@nxp.com>
X-ClientProxiedBy: AM9P195CA0018.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:21f::23) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH2PR13MB4410:EE_
X-MS-Office365-Filtering-Correlation-Id: 83a748a0-7ae7-4991-cce9-08db41ad89da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pgUA8lutEQa+uvOIe+22nfZJC/rfeBr+Tu/w4Pw9XBxHZZuQ8MwAaZuoxxzF565N8/QgKofiKCMHCrSJGYRVjk68i0c53AnLSiURsyJDj1tc0WSlAufKEcaMXGa3iUt9IA8y6RldFlaf2GVSPCjLAt0RUjF75InAITb7AB+4IF9BAOYW+z7EdmEDnYusmfv0k9rziST6yfLGc5DY3Q1JSJpyNjSOpOe444mv2Z0sGkCqi2n1OsQ/SNy/rkBL1cXcI8J7sSFuYk+QVZ339HuT9bhMri7epeHAZL2xz4TLLfGFCOZiJRGBXCDuDSnmcMFYDyoyaSjZ6JDCLoADbFHppuYfjDTpDOtEuJJlSxyHA9K+18O/PZr+R5ot07kns3xJ/7ePJOg4Tl5H3jcp1zrWNEE1g2/SYYHIIzUTa54crV+5xUqwvf2p7L3fAmQSWqzF0DfDfW+A+udCJyZm57r4m0xrRhfsuLYmYkePzVkiN53ApTk4mT3SFu0ay92aHbovS2XHtj7KWO8h2DuGRGC1xVsYGjs+7c30krt/wr9vUPhJk5ANklhqlnvG00ifBpx2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(396003)(366004)(136003)(39840400004)(451199021)(8676002)(86362001)(8936002)(44832011)(7416002)(5660300002)(83380400001)(38100700002)(186003)(66476007)(66556008)(6506007)(478600001)(6916009)(66946007)(4326008)(6512007)(54906003)(6486002)(2616005)(36756003)(6666004)(2906002)(316002)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XFiAvAusw2Y4CqdKvJHnggsu4ToHB1YhzY1IsyrTW5AgPdNjjIh1/S72X+rh?=
 =?us-ascii?Q?mKw7X2qlvVF/OULMKOwThgrkjnO5O3n5xS6D/yxY1BsyNp47e62KeHLtJM+d?=
 =?us-ascii?Q?aBsNRefZ+03aJlBmqWjQY1IiJwz8A1uCzCba1NSlK4MA3ak6fPHK/nIKvtqO?=
 =?us-ascii?Q?vspWuaXs6Ufbmyv90JlyR84Ra3eQ+lJYUSnA1Rg6ZlOsOcDqJTR3ZD4KTtNF?=
 =?us-ascii?Q?Sz6ydkpAKOu6ONZLntpp+27PjOvoN0w3/6rI8KW6Ad5YRZuQXdtad9iDgwSc?=
 =?us-ascii?Q?HGiv5J6XVxq99NvCvujjlwQRNfbjn1y6oIVVwSfHV5YTiqIEsMLPYbdTS2zq?=
 =?us-ascii?Q?SuV+KUb7YLrb97e5qjgGhmQtlXPxJEjGf1vxPqywIrRjdV5udXrL5ofarYUq?=
 =?us-ascii?Q?mDS5aVPxw4Ks4U6qBxpqnjSWhcFCW/hreUu1IgfpFMZXNu3/V3KwFQ3E0jzU?=
 =?us-ascii?Q?oLts7r2OyHnEb6Q3i4fN3RYNGRA/7jNrp4B73khOe3chtpwUh7Ndh+bUVRtT?=
 =?us-ascii?Q?VcIej4/O4jGN+XXT46xZJAeLHbrqTC6t0C8KyDpYPYDsnYBfmffxSwvxPovt?=
 =?us-ascii?Q?gRbgDorvIQuz7cp1EMbDwwPGIGvIyovZunWKWMcy1MaInesioneC6Bbv1j1W?=
 =?us-ascii?Q?oVwMZutbvTUkNKEfW8sZwZhgtmwGZEj3ND+EC97FslM7fSpznsKT02CCzi4f?=
 =?us-ascii?Q?zsRoCgsJ1J00NtpBTgEhm0xRH3gYSFiUHuxxhlwOVv8CQLvPQTTPSndGHiI1?=
 =?us-ascii?Q?uS5Z7mPS6IsoNmHw+mVEKAaqFPKJHnn5XMdSTkgy+MIM4BlePlfo8X5GnPMR?=
 =?us-ascii?Q?xhS7UMNynyyLHLZ3HwoppRWlqZ0ParBjNfMNxsmfaQbf97XZatvWXa8z0D4p?=
 =?us-ascii?Q?DwYJWrXtgFAvppLlxVSr3JE8BxzBrUHV4GFY6Xk3Y8Vc9aA18LhKs4+7o5uD?=
 =?us-ascii?Q?4NyBxmNGTxac+jLGNWs3FrDWo80ZFAvWhJfc+/IAWKRbJYkNzRh/RA7xjVQ5?=
 =?us-ascii?Q?ZNnmznFY7hHWII9L2AWgNcXMhS4o4fbe0xgHfex2w06fWPl7HhFGlVMCM+1f?=
 =?us-ascii?Q?4sMd3pF43wUfojVOanmX2xYEDiUc/Eu+1asmcaMNyEx9QSJQsObQvw88dry4?=
 =?us-ascii?Q?NCagDD22AC0xkM5+v+31cxY543piD9Dy3KQHGInevnEbl3MSdZDtXQOGBgoS?=
 =?us-ascii?Q?Xxs6mWObMxMh7fXJliQE9u9Z8VHfX8/aeIJC9prtDWhR9W76rfQkR4U8SKxe?=
 =?us-ascii?Q?9dW2kCvkBZz48jfKnmhBEql3Rx/5CDkRrJwg9hQ5NhAJW6Wxa5fzHIWBs51J?=
 =?us-ascii?Q?/zTLkrXB83ZkMMg1uCFvJg1zVQ91V07Gbj3543SCytJ9pC0v+Av8br2Sb7up?=
 =?us-ascii?Q?a9yyGLdcjaKWtbmARbywpGdcQ/wX1lVxx2nX/VvA4CYfUnZsWuZFgOW6jist?=
 =?us-ascii?Q?jYP40OyLb0u9eLmzs4U0ACdQlFZ5uvo6NtTQp20A0xLGuX7Mf4RkyWiSmGPH?=
 =?us-ascii?Q?NL4DbAtxlANoLTTDXLqGA7JBXwtJqHGD6I6PIeSX+m/Nrqo3TBbBMlx+ZZDE?=
 =?us-ascii?Q?1VX8qKv4vnuqxFZAda+ampwDAAyHrsYpt4dlqmY7EKCw0wN6X3T/26v3p6Xn?=
 =?us-ascii?Q?9qw+XTYfeGaq8jDEV5M/oWqkr5ta8BsgMneHnPMlr8AxSG+4WmUGP1xs6aI+?=
 =?us-ascii?Q?gy22JA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83a748a0-7ae7-4991-cce9-08db41ad89da
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2023 14:43:00.3678
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hwgXh9IrVupIWUBd6tTblgbS+Hv8r74vqGnWc/FAwQrmesfpZ0KT9gDP+fShy9wrEgsTK7B0m3w6h7FMPxSAuatWyFboHxOIKBrNk6TspOs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB4410
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 18, 2023 at 02:14:53PM +0300, Vladimir Oltean wrote:
> This was left as TODO in commit 01e23b2b3bad ("net: enetc: add support
> for preemptible traffic classes") since it's relatively complicated.
> 
> Where this makes a difference is with a configuration as follows:
> 
> ethtool --set-mm eno0 pmac-enabled on tx-enabled on verify-enabled on
> 
> Preemptible packets should only be sent when the MAC Merge TX direction
> becomes active (i.o.w. when the verification process succeeds, aka when
> the link partner confirms it can process preemptible traffic). But the
> tc qdisc with the preemptible traffic classes is offloaded completely
> asynchronously w.r.t. the MM becoming active.
> 
> The ENETC manual does suggest that this should be handled in the driver:
> "On startup, software should wait for the verification process to
> complete (MMCSR[VSTS]=011) before initiating traffic".
> 
> Adding the necessary logic allows future selftests to uphold the claim
> that an inactive or disabled MAC Merge layer should never send data
> packets through the pMAC.
> 
> This change moves enetc_set_ptcfpr() from enetc.c to enetc_ethtool.c,
> where its only caller is now - enetc_mm_commit_preemptible_tcs().
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

>  int enetc_qos_query_caps(struct net_device *ndev, void *type_data);
> diff --git a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
> index deb674752851..838a92131963 100644
> --- a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
> +++ b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
> @@ -991,6 +991,64 @@ static int enetc_get_mm(struct net_device *ndev, struct ethtool_mm_state *state)
>  	return 0;
>  }
>  
> +static int enetc_mm_wait_tx_active(struct enetc_hw *hw, int verify_time)
> +{
> +	int timeout = verify_time * USEC_PER_MSEC * ENETC_MM_VERIFY_RETRIES;
> +	u32 val;
> +
> +	/* This will time out after the standard value of 3 verification
> +	 * attempts. To not sleep forever, it relies on a non-zero verify_time,
> +	 * guarantee which is provided by the ethtool nlattr policy.
> +	 */
> +	return read_poll_timeout(enetc_port_rd, val,
> +				 ENETC_MMCSR_GET_VSTS(val) == 3,

nit: 3 is doing a lot of work here.
     As a follow-up, perhaps it could become part of an enum?

> +				 ENETC_MM_VERIFY_SLEEP_US, timeout,
> +				 true, hw, ENETC_MMCSR);
> +}

...
