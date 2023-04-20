Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AE876E9A21
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 19:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbjDTRAR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 13:00:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230117AbjDTRAO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 13:00:14 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2059.outbound.protection.outlook.com [40.107.7.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB0631727;
        Thu, 20 Apr 2023 09:59:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IwuDzvCMyEAZ9L1nBOTPeTnhAhgslmT9KKoP1D7eUgqsXGOir0bltB05r5IOWzeSRzn7O/7T28a5lw0yWQax1CyBTGsjbOyV9qkg0m5rBbPaMFaddUWeUVbuFnxjlbySCCamBEkVuItNZ5P7BMjmrUmGKNGrtOPLQL499MbsrPuy0S3xem2cuHKSCpsbVZN1G/cjlJB1scCdnkRATV+fyNCj6UpdnWPVmTm4XhcSfN2PwzHjfU2hdW+goSgd2Bz+XPFF9MAmQ5h6yJX8szL6mqQM3M0bxUhGgYLOmMpITVuNCnciEB+WEbGQEDbVD3SxVZvXNDw4HN7AYQMRRS9iaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RNPfC0lZGld1/NJDpJCgzALfBB59Ua/r3e7R8W2LfFY=;
 b=Kwd7nSvcYSE8FHl93LJt1pCY1qn5TvwORaae2nCDZdY/urygzyQTav5HE7KSNjaHuDS39cGu+Vo0Ehw/E8KtpbOyCHgz9rhvTlgXKtqQAx8Xv28ldno1Tg00jgTyRYA6I/xbacqQYDHNgkrP2QLV3vLrX0ZkuIExBnV+OJ6h5bLYjUoYyaj7mz/7DAcwG612EIj3sKNnUv3AK0+TrEhcf886dRMDts/gjfJGX/C9A7rxfRBkn3ZwvUW2EdLvDSMmLVHweONIWNFFjutqcaptpeYwdBgK5T0vle98wBa7jE1xokLLzwF0xoU5MFqaS0AdgZIEGqXVsxfZThwMFbKkGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RNPfC0lZGld1/NJDpJCgzALfBB59Ua/r3e7R8W2LfFY=;
 b=aDBwq3ySVXudaWFqZT3GE4e3gW0PWtvP0YOGDdXY10q80K+NlqwjL1o/YRerizHQdSbro4HOUM46fqpHxcZnAV5XMVsfBQRpBfDANRSdca0a4HBYB9XZgsW8zYR3XmKY9HYL41mx4X9I6EVxxiNQK7Fin3AybQXmThx7CFh0nt0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by PAXPR04MB8557.eurprd04.prod.outlook.com (2603:10a6:102:214::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Thu, 20 Apr
 2023 16:58:57 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::245a:9272:b30a:a21c]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::245a:9272:b30a:a21c%3]) with mapi id 15.20.6319.022; Thu, 20 Apr 2023
 16:58:56 +0000
Date:   Thu, 20 Apr 2023 19:58:52 +0300
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Simon Horman <simon.horman@corigine.com>
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
Subject: Re: [PATCH v2 net-next 4/9] net: enetc: include MAC Merge / FP
 registers in register dump
Message-ID: <20230420165852.op2bn3c7kdkhekvx@skbuf>
References: <20230418111459.811553-1-vladimir.oltean@nxp.com>
 <20230418111459.811553-5-vladimir.oltean@nxp.com>
 <ZEFOSGwKhIyzwWmB@corigine.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZEFOSGwKhIyzwWmB@corigine.com>
X-ClientProxiedBy: AM9P192CA0005.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:21d::10) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|PAXPR04MB8557:EE_
X-MS-Office365-Filtering-Correlation-Id: 45ee3639-de8e-41cb-9ee4-08db41c08790
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ld9TU6GsUZIY4x2zzSSY+bh0FtCQzGMPKWzYJYDyV5xtUE90u6MlWbHaXBLClXmxTKHstGU5y63DdVNfc1FLSNFfp2EEe+t5J69OsbIna3LTZVPM8brNUE6YLWg4953OlAKgv7uZtsDbId/O7YX0jyXLIq/+9LRAn+3Yiu5nB1LgKpAiS4thqYB95UXgsQ95T3OsompN6cJ1ncW4xxoGUSXbKxWwmNXSrng48bN0SxhT61OGY4mxht9pN/FTo5BlV0en145qGI/usPKJLb+A35siOVfmA4+u3P3PEFelOKDXq7OAuizimu/Ol26CRfPWkg5/3kfDLNedGIuogZ5BhSvF11bGNWNYtIRqJ1H7qlhuie6h9VNT/yVAhVkNOps3FeyDfSCTcV+lJXIahTTmXD0TTCQoJPtqciVYMLFPVM2Uw93k9VHZPa0WtuCQEau/EjWNLvcTN8cq2Q7mmXfSvtu6uEIFg6H4I8F4IKJycYWKe6pyYQOX/fZQhVnFKSWyB55ecz4rz/RFUQhXQNLkHktQshQol7M/raiPtP+Miz8sbkQRrrH8bK9Ep48j+EmL
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(396003)(346002)(136003)(376002)(366004)(39860400002)(451199021)(2906002)(8936002)(4744005)(38100700002)(8676002)(7416002)(44832011)(5660300002)(33716001)(86362001)(9686003)(6506007)(6486002)(6666004)(26005)(1076003)(6512007)(54906003)(478600001)(83380400001)(186003)(316002)(4326008)(66556008)(6916009)(66476007)(66946007)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pW011I9AyjPtnpMZw1o5h9MBbRuF71FRqNvXgOWWAgHf3WULDZySUsCuUhrm?=
 =?us-ascii?Q?5WeNrxc9GT/0uDG8Y2Nar1bNbE4XVK7bxs6yM9lRn1XC/jWwgpwqzbRMn+/p?=
 =?us-ascii?Q?AnpBcpoTk48p8ZUSuFHjpjCc9Li6pJiXOdy9+UZ+b2uAdzJQMCkpoQgWXHn8?=
 =?us-ascii?Q?LknA80bgKYW5Ikj2TJA0F6He4IM1P8HT4cWthIZ70wPet/FcQy6QJRf9G8UA?=
 =?us-ascii?Q?AdeH5ORjOZ70O5VZWPxVxFATRwWaomlsN1GnDgrAso7l+at9RWdb4k6gWl6F?=
 =?us-ascii?Q?SWDyOrJ1hPYwu88Gyi89XnB5qlp1LjuwmT8moljG0wnBkavhfPvAI84j6QTD?=
 =?us-ascii?Q?CvwtQE8feebUgfIYwyZn3UOaWAh1mTi5QFagVOWLDub0dntD9nOl04T3SmJJ?=
 =?us-ascii?Q?pS2ikqKB9zdNbMFqupHnlHFWQmNFGjoSFX7wDQ/qmRExmURNCI5wqp9ythK/?=
 =?us-ascii?Q?yq+U32XH/JQ+PHkce4fzjROL7ilG31WEzy1O1eNNyBcqvFWh1QGyNyn7AbhM?=
 =?us-ascii?Q?XIhWQyROs+N2bpl6hF87lJT8uoL3/FxaZTv5mCN3D/+Q0ewII8/rEIg6UqxU?=
 =?us-ascii?Q?KXWlLuJWsfokDhQoHQizqQV9ONFyHdjPPwBOhO1q4GhocYEcFHGuCCLzhZUl?=
 =?us-ascii?Q?7eP9KYT+lKNPehiKSzscV7SDB1NJqbubNiHhR3+e+IQbWLJlChpGcpHlM8sv?=
 =?us-ascii?Q?JsUwLHRCuJw1pN8u7MFPleQFsobtN06Y6fVllcujuSORNIFDptlfe8NuQVbs?=
 =?us-ascii?Q?bTBn5b31Z08r1boL6xaRPxX5VmUeMtNNB96uAqOaHwXQS/h9D6hSzTYxXBBN?=
 =?us-ascii?Q?A2LzBTcfLDL1WWh6wM97N5rxVQPnSO4EyGTdW9SM8FFGSxofe7NU8orVWYeA?=
 =?us-ascii?Q?yptBwbqiBlXeksGuoJiOv0kOxIC2qx5KhjotNruNbYQHdLRLVMraIzyzxCpr?=
 =?us-ascii?Q?ztxp5f+tQ4iPPBAj2ARXqScW6MrSAx6c9Z8w+n8F07Qreafzsi7bjiyrpXWW?=
 =?us-ascii?Q?0Ugn7gBXNZ6EfN3gHUdQtxf/4xq5HUAFtnc6TRCdwHjoTNEZzUFDlWsaZGr4?=
 =?us-ascii?Q?CZzZoidJUA+Mtbz9KE6/wF4jOHVBTLZzj7KWqRQ3Ss455sN0v2HLFmkXNYF9?=
 =?us-ascii?Q?5ixoTTYRVhVwZMlyT8wkjk70MW4SuBtQakhSRznmN+pZEZdhkkCy6N38O0ii?=
 =?us-ascii?Q?P6fktxMzsaKA2HF4EA3FiCEoQXp877dPOKvoPC4LIhDP9hec2jAsh1716Iqd?=
 =?us-ascii?Q?CQYxXFfH68xdcgd+FSE5USwsxFbAg7Iv8fnY26T/8B9+poTVjOFCwu7JbmLw?=
 =?us-ascii?Q?XyAvxhRFtyBx2rP4I+cJ2xUjzvUYESJUjQodRXckMx5Yp00T2IMfk8yOJRf6?=
 =?us-ascii?Q?fmTmwtEtldXEow+Gnil4AtRPSiLdudmAgJFY5/DR4VyFZgCr7tbMvsgZEYi4?=
 =?us-ascii?Q?w+fPIxqyIOc0hXtp+otQAwNmfJsJ/vi03A7F8pMrMubZeCaQTfbYV3r9BRk5?=
 =?us-ascii?Q?2d2kADCz0Fz0pe10qoUVKwfcSR8st7SU85SLzufEXi+wC16S/G+n4crzHopi?=
 =?us-ascii?Q?5xb5JVFkwaJwEB2avVZLsuSP2fu8Q7dl6HgQgqOZiO91bGX44Ui4Imx+5yp0?=
 =?us-ascii?Q?cg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45ee3639-de8e-41cb-9ee4-08db41c08790
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2023 16:58:56.8579
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xNm/n+EIjYmeylsklNvjHGe1P2/uCABivhbKthgGkIFEW4S4I+YE3B1bSwg9VecdCd1iaD7R1JAibl3xT9CkhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8557
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 20, 2023 at 04:38:00PM +0200, Simon Horman wrote:
> > +	if (hw->port && !!(priv->si->hw_features & ENETC_SI_F_QBU))
> 
> nit: I think you could make the condition.
> 
> 	if (hw->port && priv->si->hw_features & ENETC_SI_F_QBU)
> 
> which would be consistent with the condition in the next hunk.
> 
> > +	if (priv->si->hw_features & ENETC_SI_F_QBU) {

Maybe, but it generates the exact same object code (tested with
"make drivers/net/ethernet/freescale/enetc/enetc_ethtool.lst").

When I'm debugging, I'm a bit of a conspiracy theorist when it comes
to operator precedence (& vs &&), and so, "A && B & C" doesn't read
particularly well to me, and would be one of my first suspects at
hiding a bug. I do know it would have worked in this case though,
and that modern gcc/clang usually complains about suspicious/
unintuitive precedence.
