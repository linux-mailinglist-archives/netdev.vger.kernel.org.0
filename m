Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F08096EC1A7
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 20:49:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbjDWStN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 14:49:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjDWStM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 14:49:12 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2107.outbound.protection.outlook.com [40.107.223.107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F3FC1A8;
        Sun, 23 Apr 2023 11:49:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ejLLHOQ+2COBLhTMFO+9CSp63+31c7vXn9g3cG05BrJyjep5qYfDZdzfAniFm9LEfUe5+/BeNOF7NYIM62+kimvLVzfwrIBbrEzo9HqEEecQKkhdsjcHQ3I5zQgUH+9l0c3xIOdAijIKM7byfoaSU+5zpKm5ciYUwfVXXjZNgSyKYosR5w6B4YrxHE3CUTVE0TKJRRSJ/y7YLgXLuvl54eRXPDtB1iclZCAwKHa5YZOi5i4RZjJiASSbjeJwR4x5eASkYvwUL//UkXS9Ht0W0NTel8Qv+bowodmuJkihCv97D8xgJmKIy1VfcjwJZDCXibyGjCLCSPsb7iTbouFkEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3zLwFiA1xNzgURljinB4TnAG6ljf1MccsWxeGyOZvCw=;
 b=kzzmUprXy5zblx/CTo+NgizhqgysbXyukRzlalGtANO5ItMH25tbXRWqFZNBvrl4D3X1F9oKQP5H3RSaqZuqoztnEQcvoqlnCO1uDiyUtNsuvGyX+Q6xZPg83s1IITyiYywX0acDp2AsUVQ2SlpGDGXjbAypa9mNRNpb1yFkEp5Y9Qx9+UgGfkaTVqJ6e/azOQDa6cTBxNev9iMgBknOR4oDBf/2E5pKZpE70zPpTcPu2HR9M0Sc0T+JzE/fQReqJoDGTqdOdc/gQ0ZmfkMFeJZtdeg114pfLhCxb6AALG1YL/GQgOYVZU24OONc1DspJXffGKUpY25IVsIis8JmHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3zLwFiA1xNzgURljinB4TnAG6ljf1MccsWxeGyOZvCw=;
 b=l9R8yB8pu76p1D7ysdTMcCakxpMtfmv9aiJyIAYKl3LZadhvyKVp8j8ZHbXWOmqjXY3WBV3pgxdTMatcvwZxd8G76iiY2DPTwvCVXaV8wvQvNATgxNumXXf9DJGSMAq+AQXU+6lLA7QlzIbWYUaUcyuAKrm4s8DLEQkkgsXggfE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MN2PR13MB3664.namprd13.prod.outlook.com (2603:10b6:208:19f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.32; Sun, 23 Apr
 2023 18:49:06 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6319.033; Sun, 23 Apr 2023
 18:49:05 +0000
Date:   Sun, 23 Apr 2023 20:48:52 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Gencen Gan <gangecen@hust.edu.cn>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        hust-os-kernel-patches@googlegroups.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] net: amd: Fix link leak when verifying config failed
Message-ID: <ZEV9lKkZBiTiIjjl@corigine.com>
References: <20230421183304.155460-1-gangecen@hust.edu.cn>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230421183304.155460-1-gangecen@hust.edu.cn>
X-ClientProxiedBy: AS4P251CA0025.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d3::12) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MN2PR13MB3664:EE_
X-MS-Office365-Filtering-Correlation-Id: d20b8675-3a56-462c-6799-08db442b69b3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bd+bGhxdPjJ+2/59g5qQzAds5ZBBC6xO0uCakDtDUshzJpEULOVFzR6/0GMFgCxlSgvpFOjF7Ffq/iOgYj3M+5TxmKu778oDaCVk7T2XFLTDT91ZYyMycBafY7DzZotwNoCeOnGNf74PRRzZPF6KkXzJ4G46PXbdkCyqEGIt7T+wjPsvrrFalPe2Gu9O1Psklfys5wqKJYEzHVA/pGFaFXyHmg2ePOW1p6TcmRz69AlCdpUKgRjpbY5C8bNT82rGP1WWubtxO1ea1eVGWoTjrksDMs+fELp2MlXW1gyedX6KQ16UOdJncEX/vRFUOvmeOqwQDSYAkhGm6uxR2I9rEPlFFAu1pt+YzKKMRm4ijF/RJzO8xbMXE6x/2I96g6WsZ+rHMehJM2i6rFik2hMdd1G0YV14x3L8v9sdegj04vF0ZOR1hgAmV6s7WxlO8VOUAoy19qe7nDSC8FpPwkdOQfYUXk6/pMhRK+mRRWonkaBpHidT+jNDRCkjTtlTbcwb6mXycKyyn1WHpXc+x3pT2pISbAPs7Z7OPTwdSYUq6ey7y1I9w7dbZznT0V4LrmJ7vNLZWINvAbl+sGX8io/2w8GKRqDgwLW96k3x88bSfEM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(366004)(396003)(39830400003)(136003)(451199021)(478600001)(54906003)(86362001)(36756003)(186003)(6486002)(6512007)(6506007)(4326008)(6916009)(66476007)(66556008)(316002)(6666004)(44832011)(83380400001)(66946007)(2906002)(38100700002)(15650500001)(8936002)(41300700001)(8676002)(5660300002)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UQywaAMWJokj+CYKOXzcbaSzkFsqozoRkzIRru/Fo3TT9qfl6Sjp7xMnMyAG?=
 =?us-ascii?Q?J4PgVOoKdaFQ3haV9cttGNt+VzsBBgkOmyWawlS2aMDd5CCSyfBgcQq9ntgv?=
 =?us-ascii?Q?dSi45VJgkG2M1EPGREiCoOleDZLxSKv5bSzA/2xFHLBCCqCJV1KfQx8gBNas?=
 =?us-ascii?Q?gwpF9Mi5aEJbpJFKwHIaPgV6HnO852mK5u1n0hgJM6Dhj6JD8UYlx5lGPLiN?=
 =?us-ascii?Q?UNx1d08FP4CJ5zmVuXaFylXE+n1ghKtT9Ic/aI46X6HA3QDFPMnAG6ReBaip?=
 =?us-ascii?Q?G/GoF+HiL9N96QreeiVSElU/fFahy1osM05Vv73dP27XVttV65TrHOfNswDg?=
 =?us-ascii?Q?GMJW9xmNJW2UvSkPK6g6Bh/54mMBQ6oGF746G3My0mShc/iVeRgetiZKdcvy?=
 =?us-ascii?Q?gXZVM4hSBNz1HNcF4BeQNQgQpsIOKeXxPz8Gc7qSfCM3I6lO35c5ZyRL2u3c?=
 =?us-ascii?Q?m+NnlRWUaz2fcjaHlKddiPyYPJWtYvgW6wvohhEM+SOk0HsT+kP7KJRvSrK0?=
 =?us-ascii?Q?OXUJFfExljEzcOyegCCl4tagYr9z7AO/UClawM27fAA5LXMS4F61iWb1oYdI?=
 =?us-ascii?Q?lsKEF4geRbAMpzjsPrRvwx8PtXgybwih6WP92+PLNmKLbE8OzV6J4PmXnPBz?=
 =?us-ascii?Q?jeaDgxiTrgoAxH/LdmNGz9GP4Tmsf4YbWGqYw5Utx7rcL/bkKweLs6gwVym0?=
 =?us-ascii?Q?bmk7C1PAm5n8zJVEP2vaZBaOrsqWttMYUYJwHgE7YB4fqrYWLi2Bav1IlK5s?=
 =?us-ascii?Q?hI6+oZkEgqJUcHrZExz6T0/31X1Ca3+0mVt5z9nQn5mGIB+PoxZHJFUGh5fF?=
 =?us-ascii?Q?HFDoHDnCtpXcRG5VXR6P/GqcbrbOPyYJCEpZDX00Vw/p4f4E5FuQZ/clt2aS?=
 =?us-ascii?Q?aHTAHTgPfMQq6DVbaMg0b6/VJH7IV8Fg8uaG5PdTZXo7XDKCXTkIapCYL6zj?=
 =?us-ascii?Q?a6tFUu3CYcKAw9zl3EQ4fBvrJoC0/jU9Hg2w4BPkwlR5UNLB5yJP9Gha1rI/?=
 =?us-ascii?Q?r5qSenniI0xm9iNEkQ7/9V1i457qt3v62uL840vDI7sPav10iM0Y3YPJRmBn?=
 =?us-ascii?Q?K50vjJtbiLostwezocZanSIZt5whwRp5YHa0lFt+9RoSe9oKObBJTSq2Wzvl?=
 =?us-ascii?Q?o22PRK72Pe2mK44eZPRifn3f08CLFKjyu7+mP7bBNyEaKUd4koKNH72d24MD?=
 =?us-ascii?Q?E8W++VlkDofnVUyswthP8mLxFSqq0vyOyMNG+v/LTYiV8POdBYi0yF5ZbA3g?=
 =?us-ascii?Q?FHNcZvM9D5QZsKrXpef+8ZW0cR2ZKsl4iBM+GcViK68zncJg6SeGpsd0KLOp?=
 =?us-ascii?Q?W6apQchA8sfd+Yjue45ojDSefbPVRfKCPMWiTcCL+aIsCC9mT4R4vopk79ZJ?=
 =?us-ascii?Q?OEsKc8b6N1q5Y5gXtwOjktvJnDK5QQpfwaTHyoDYfeIq//oiEJM3GY6/R7/4?=
 =?us-ascii?Q?6tpv5gJDu/B50NnhS3Dbg615nowbvdpANm4Q6WJ4JI/ubbOGCs10kXrZD1LY?=
 =?us-ascii?Q?N5nF6fwgwiy5QuTjTwBEuA4EHOx+IO1u3O6Rp+C9AY4k+fjaifz0saI1RzpH?=
 =?us-ascii?Q?Zri2yWcJEELpHrTBP5wGt/J6Fk87dsb578NQiwweuB62x7e3BTG0OetJ6u5D?=
 =?us-ascii?Q?iHXlMPmOtEyGPlHdLcJuqyZfGsbmvUhqJzp3tdn7AU+TXnKkgEE25D//I6fw?=
 =?us-ascii?Q?5l5pWg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d20b8675-3a56-462c-6799-08db442b69b3
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2023 18:49:05.2808
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VH/yqpHpIYOCxcqWOi/wOumfdRfKsYjiN8gkRy0MFK3IwJyUMuxS216Sqgi+GsjdGTBeP3+JCgRW7ZVnnBlN13daPOOs/OpmhnMQQRHDbHM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR13MB3664
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 22, 2023 at 02:33:03AM +0800, Gencen Gan wrote:
> After failing to verify configuration, it returns directly without
> releasing link, which may cause memory leak.
> 
> Paolo Abeni thinks that the whole code of this driver is quite 
> "suboptimal" and looks unmainatained since at least ~15y, so he 
> suggests that we could simply remove the whole driver, please 
> take it into consideration.
> 
> Fixes: 2b3af54dc373 ("net: amd: Fix link leak when verifying config failed")

Perhaps it would be better to remove the driver.
Perhaps we can take this fix then consider removing it.
But if we do move forwards with this patch then
I suggest the fixes tag should that below, as:

  a) The problem seems to have been present since the beginning of git
     history; and
  b) The commit above doesn't seem to exist in net or net-next
     (I assume it's a local commit id of this patch)

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")

> Signed-off-by: Gan Gecen <gangecen@hust.edu.cn>
> Reviewed-by: Paolo Abeni <pabeni@redhat.com>
> ---
> v2->v3: Add Fixes tag and add a suggestion about this driver.
>  drivers/net/ethernet/amd/nmclan_cs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/amd/nmclan_cs.c b/drivers/net/ethernet/amd/nmclan_cs.c
> index 823a329a921f..0dd391c84c13 100644
> --- a/drivers/net/ethernet/amd/nmclan_cs.c
> +++ b/drivers/net/ethernet/amd/nmclan_cs.c
> @@ -651,7 +651,7 @@ static int nmclan_config(struct pcmcia_device *link)
>      } else {
>        pr_notice("mace id not found: %x %x should be 0x40 0x?9\n",
>  		sig[0], sig[1]);
> -      return -ENODEV;
> +      goto failed;
>      }
>    }
>  
> -- 
> 2.34.1
> 
