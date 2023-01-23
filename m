Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A401677EC7
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 16:09:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231894AbjAWPJg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 10:09:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231547AbjAWPJe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 10:09:34 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2093.outbound.protection.outlook.com [40.107.92.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D057B976F;
        Mon, 23 Jan 2023 07:09:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zj1yfUgNAEHG5jTK4Jo6b+VsB5gBu4O2mmUU3P0rFfVMZ/S4PgMTsLrfCerR0UQmwHRfCM+ZknNwic7nfMddtzmrhVXk1vZ3ITEOD3O+lhcOkZzhpHzsBRJ780sng1dcWUMeYCmYS3fjUhjmeGYqXaVCPrA7gfEtb4RWfzTDJ+CB5zpYgUA5hFaj7MygMPoUu2LDnF7Aw991UmJc+vy4xSPM/nxiNhoLwlTFMj8XkyAi/CelifeqfV/k97ZW8r7T5+YYmSUexBmE38n1/FCEGfsmd1Tq83tOsVbbo4N6mCSBEKhUOaHR49Fc3L3SLGXFw+3jpqjfzofZ9fmoeXd6MQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jvWHuXujh6xffarjGIGd/KE1M14nXyKdFgGEB4SPvx8=;
 b=TT1d5PiQXX68CwbO8G3N684OxlFd4OrJ8TaUcZskEKR1GfYz6Ltvb6O4n2ZdcPWylnmSMXNZuIb52dS1AzK3LXduv9PHhPJpKeGpkLz3g54txBEUggR37CBUCqSAfgYgSJ04fS1Wv6BdmJs9jXdq/La6Rb6qsdgQ9vdbKTf5BwQLO6AuZP2gLOAGw006xWSaerZww4o7BrvYLw3BOeRY8DilctwEYcvkLAToAf4qAMSI6LFRdMeDfAFrklCtHnMEQ3R3nea4dLYazM8+13M2/P+B0EUHjVkiInF1n1MrVa92SkCrLx+WJYfi7ybbNvdRR2i52ckqypwe5z6A78PGdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jvWHuXujh6xffarjGIGd/KE1M14nXyKdFgGEB4SPvx8=;
 b=dvN1uL2wwB0UmqETRyO1RbGbCXcJNz2zKNnDqCbNXr9QI3NcI8Ygpm/u3V0O9cf9KuQumT0XSv+T2BjW/wCob89TT4UU5qJjoBEdcCaTJVe0afDfRs7AvEpJClnLsQS05bVb9+hw/tgpNIqOJNIQVVUAoah4VFxmZvyyyptW8cs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY5PR13MB3636.namprd13.prod.outlook.com (2603:10b6:a03:21a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Mon, 23 Jan
 2023 15:09:27 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%5]) with mapi id 15.20.6002.033; Mon, 23 Jan 2023
 15:09:27 +0000
Date:   Mon, 23 Jan 2023 16:09:20 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Ayush Sawal <ayush.sawal@chelsio.com>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        intel-wired-lan@lists.osuosl.org,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        netdev@vger.kernel.org, oss-drivers@corigine.com,
        Paolo Abeni <pabeni@redhat.com>,
        Raju Rangoju <rajur@chelsio.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Veaceslav Falico <vfalico@gmail.com>
Subject: Re: [PATCH net-next 06/10] nfp: fill IPsec state validation failure
 reason
Message-ID: <Y86jIClrwWJsPk9v@corigine.com>
References: <cover.1674481435.git.leon@kernel.org>
 <99049389f2f4fb967aac8026bd05f36ea13c47aa.1674481435.git.leon@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <99049389f2f4fb967aac8026bd05f36ea13c47aa.1674481435.git.leon@kernel.org>
X-ClientProxiedBy: AM3PR07CA0131.eurprd07.prod.outlook.com
 (2603:10a6:207:8::17) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY5PR13MB3636:EE_
X-MS-Office365-Filtering-Correlation-Id: 6ebb30dd-2b59-41ca-989d-08dafd53d20d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AG8CrpKvw0gbMXZ4dFSFSP5NJag0jnIcnvHzxmtnSFYmcCRxLLqjFA2A++4+EoOAKdk62+WCSRRMB5JKzfdOE+UQMR4P3VFKMLWL3Ednfuv3Fv7oTLup1h/NkRjqHoi/YX7AEZ2M7Uci7F0QPB+udWEMqAk773w5+ITGdrtPxhguvDWx0rFDAwPfVGTszzIVVCNpfG3/nLlIiPD53U/5/qldrro0utsWohI2e4K6Yr6uEkBi81r6D+oxf+zLx58jzR2eTU3i6/Q/C2TNlAHa5++qcvI2Q28T7Kj6tVRFXnRbjCgTSN7kYw8nRhPwB4PVaUXJnyl1YnNihp6MgjxcaEPX65zD+m1M1EqCciaWywXpjqaqCTrf35xOxq1YWV2r0bKBkcLZsG2mvomEsou6CE8yfwyw1DMZjEg4I/1kqlNh0y/d/J/e+Inm/+8i991WdvcD2rM96osLJNCqUSLD8bKFLeoT4D881gDLzpwoJW/6RPmzstctCEkYYM2gHP/eCM63dXPb4KrAdQXZdOfQ+ST7mUuiKMYjXpGbQSS5Dadwi43dJqX/sA2G957A1+Hwy0o6sS7cQhpEVvIof3DkXfcRyu29wEE2bGpHv8YI5wIPYceWoLOYpu1s1bNxQlOfh4az5tcCP5lRLfhPd2ZlDQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(346002)(39830400003)(366004)(396003)(451199015)(6666004)(6506007)(66946007)(66556008)(66476007)(478600001)(6512007)(6486002)(186003)(83380400001)(2906002)(41300700001)(8936002)(4744005)(5660300002)(7416002)(44832011)(4326008)(6916009)(8676002)(38100700002)(36756003)(316002)(86362001)(2616005)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0N0RL1PCqskt1qyOc4u7Wj/bB/uVuR3Vkh2eda/jDmnX6oLi8f5e63+POAHS?=
 =?us-ascii?Q?SVGF6VWBbaNo7rkAnt0lHC3T1BWuvztlXFtHEuOwO9VqCISc/+L71af57Fl7?=
 =?us-ascii?Q?Y8iusWEPTERDT28e1JbOOHR9oOF02M+UETyrL/8LmxqKrDyBWSvExUa9wlhf?=
 =?us-ascii?Q?l/hWhgegEua8oXyOOvSBJmGPcqE2rsIiNqILo9PCrEH7VkYnXIflns/7lSFs?=
 =?us-ascii?Q?uyM2XPb4Y7hfCTGOEWWG5N3pTauutguq03CWXjKZjPWol3VRsRFKrMmBOryi?=
 =?us-ascii?Q?8KZUEkEMlccLLC+kceYKAeHwMOTCYUAGus0kA40nP83q89aknJiKqRlkYqQe?=
 =?us-ascii?Q?B9nb9Bj9vj+RLRSFs2hrsejlPZ2c6bjuZqEz0G0vaRZhEquPNJDizkfh0DJ1?=
 =?us-ascii?Q?cCJc9mAFu8shk2P3QhQNWcra3FCLOE92tv51aMny7nvKT77PIMOijhgZ+QK7?=
 =?us-ascii?Q?/wFmyEYvLczYY83OgILpZVleFJoJ2WbcZV6z9ffW1co8ZU/QIXinGsmG9557?=
 =?us-ascii?Q?3FZVO1sTgwzeFEOjTyE3KlC73QMsm+G8FxPibVLYj2idxjY6FvlI/OX60jf4?=
 =?us-ascii?Q?0XyCLDJZYcyCrH5VSM19xc0H6FqWDrngv3S+ptIZJKv0YGVNOZIOjUvS5fz8?=
 =?us-ascii?Q?QmBnHOhTLg2SEzTp8fsuCM5BqJRxjL+XdgGGRTG42+I0Rek7AFO8CWXfSXU9?=
 =?us-ascii?Q?tAlR9dyiBSjpruSxIEY9ADcI2WmDxjevzzkL4IiM68Ix5bALpFy5dZ1uHyy1?=
 =?us-ascii?Q?V/tZ5TqJtNASATDnD3MnEiQ4ho3w0N+0aqTcKGZ6C7hGaAm9HeUryOlrYBqO?=
 =?us-ascii?Q?94LEU1O6XqubLn3pegeJjk9Cb/HdNOWnM7FYmWnOpFbArp8K9/g8JFwoOhXe?=
 =?us-ascii?Q?KdUNvesioJvNON6rEhN3Tk9vV7q4j6hJGWJdDKRPqRF7fDDYDFbZC7gousJ5?=
 =?us-ascii?Q?S109QpPBoseg6Yjn43PrAHGiI+bJhSXH/qWj90BGHlfg2y6+lqJ0+0S4VOMR?=
 =?us-ascii?Q?1sHD5vezE2gQdxB24NxdxlsM1JQM8Zfrag4BmSTP/KVqoZvafs7QOu5wBzqk?=
 =?us-ascii?Q?siXGA8+R21l3HLvztHQ/cA8GTa9/fPGYFpCinkA5y+J8FLbzle0YaVFqLF6n?=
 =?us-ascii?Q?v7zkrO8eMYO7qAcD57fFFzeM/lTt3uB3wMGipMDpEu+s1U4zUuJoqnY8I7/2?=
 =?us-ascii?Q?naeyRNFGx+Li8fODmvH1iViSM1kD1WXkx2bPKnsGhy3niWsUCW5Z8TVMD6yB?=
 =?us-ascii?Q?5hCe0ysWWSSN6Akua4918TaIHbZzEJex/Olo1PFW/pEksd6qc0YxxfL55nzj?=
 =?us-ascii?Q?pE6Ka55mNCvanIn+3UnOW1XUUe9gf73nm0nYDlr3f57zAChq5c2BEwQr1RxS?=
 =?us-ascii?Q?W0l9H5/CffXweJZ3jDf7OJmLR2XJzqOXyP+H4XN267z4+q2+y93hIqyGranI?=
 =?us-ascii?Q?LjHTZoOUNCvdNsFP/qdK2opuMJxHYmrewfRq+Sj1lu6WktVc1coiD01I2fyT?=
 =?us-ascii?Q?i4e+7tF1+xA5YQAMkXKfvqgUQhi9RxC/d2IIySjtJ+O2VVeSdpxrA4pA781o?=
 =?us-ascii?Q?tnHdVQL/kHA0eitwuSLPsgxBfyu25nPsgI3XAEU05KomqOu+oyGZigpubIUp?=
 =?us-ascii?Q?Evk/G2bzvvpgmlMRhIcdeRcSwK4YUfolBX//OXe2Iitqlruv4VBpJ4Pv5DRx?=
 =?us-ascii?Q?OqLNxQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ebb30dd-2b59-41ca-989d-08dafd53d20d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2023 15:09:27.7690
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P/hRht5xkH8yDphyLVv3JzR4NXRUPv7QQqhQcBuUTVB9obeK5fU8ZV6i/wex6ZHH/6ezTrj8PxHRnD5ME2Euvulw6JD0PqBzU0cZ+Eo/+1U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR13MB3636
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 23, 2023 at 04:00:19PM +0200, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Rely on extack to return failure reason.
> 
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> Signed-off-by: Leon Romanovsky <leon@kernel.org>

One minor suggestion below, but regardless this looks good to me.

Reviewed-by: Simon Horman <simon.horman@corigine.com>

> ---
>  .../net/ethernet/netronome/nfp/crypto/ipsec.c | 38 +++++++++----------
>  1 file changed, 19 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/net/ethernet/netronome/nfp/crypto/ipsec.c b/drivers/net/ethernet/netronome/nfp/crypto/ipsec.c
> index 41b98f2b7402..7af41cbc8c0b 100644
> --- a/drivers/net/ethernet/netronome/nfp/crypto/ipsec.c
> +++ b/drivers/net/ethernet/netronome/nfp/crypto/ipsec.c

...

>  	if (x->xso.type != XFRM_DEV_OFFLOAD_CRYPTO) {
> -		nn_err(nn, "Unsupported xfrm offload tyoe\n");
> +		NL_SET_ERR_MSG_MOD(extack, "Unsupported xfrm offload tyoe");

While we are here, maybe s/tyoe/type/ ?

...
