Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24E25671AE9
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 12:43:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbjARLn2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 06:43:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230003AbjARLmf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 06:42:35 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2119.outbound.protection.outlook.com [40.107.244.119])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68C9D66007;
        Wed, 18 Jan 2023 03:00:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H3ChiWNQFqhZF6alcOkjJR+F8FkkSQR/wRf4Z8YMf8gMBHRrevHkRQGSrHUSV69/n10AWOUdzY1eZXcDYepp9pMzq9z6ytHCDLPsPjd8io6SQZwiqVFo++jMzD+OoQWQEzDKYd3LarZMcRaRbrAz9bZ1owf4p+kr5Zm2BcOCQ/sVEC4Tqt1pLgiYrnxjIib+/9qphTiK3KKMX0pmWAGDvFitbNJ+7mmgz7+NzOX97/Xw6KluOgzWjmiWvRt7rtBUzMBmv7m4AbddVMLaXRB3g2NakNszjeVnnu0zSrO/OLlw7ElmzoCqNQuNwR+YHWLnfdvViR9akIZ1EzCbEQ7Zjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ewE0sPJ/CbZsS7VV2/IgLYdZ3VK/kWXs4bmEFWV7JiU=;
 b=X9afCx9MNznRhUG/7Jv1S5qS9jOPMjy/X5egGo73QL2+yAEHOLGkiGz91QmKdkQJGRa15jAKUtI8RnSnDjsHg2W3SG3QEx+LAbdSx2SOJKbWpcCG/Sk2PErlDGNT5TIB0WEK+4o9aBIoL/QIJ16tpgyjRtMuC7oWAbMpHsYpincVSqaEqAjDxANYqP/9AP2GBuBpwsEKPy8KkO6D+TEF+g6i23Ls1J1hjUxLPyf+Z7iHhMHn5yZBk+kYCJKeQjlvHR8kWl9K+ei8WU7LMVUvpj3pQqDAzlZTfvaxPMs0Yar7V0bZMVPEBzoHKTFhr0AWepm/eMVdqoqvS1umZgMMCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ewE0sPJ/CbZsS7VV2/IgLYdZ3VK/kWXs4bmEFWV7JiU=;
 b=q2Ki4xySY/0eClQTV6Q0IFxjyzDGiII92v6D2i0awTnTyt4ZKxR6ESxaEHlZ6Z+uTst1HGiKnbZkurwZn7moln4hVI6nFKr5hoBmVyVoypzFERs5GO07HixHkU6jf4KXGJbZ9NZTHjHFo6taHygJ7paTGQ2gbyP86j+22YqVLwE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY3PR13MB4963.namprd13.prod.outlook.com (2603:10b6:a03:361::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Wed, 18 Jan
 2023 11:00:14 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%7]) with mapi id 15.20.6002.024; Wed, 18 Jan 2023
 11:00:14 +0000
Date:   Wed, 18 Jan 2023 12:00:07 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Daniel Machon <daniel.machon@microchip.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, lars.povlsen@microchip.com,
        Steen.Hegelund@microchip.com, UNGLinuxDriver@microchip.com,
        joe@perches.com, error27@gmail.com, horatiu.vultur@microchip.com,
        Julia.Lawall@inria.fr, petrm@nvidia.com, vladimir.oltean@nxp.com,
        maxime.chevallier@bootlin.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 0/6] Introduce new DCB rewrite table
Message-ID: <Y8fRNwO71ncHNLxB@corigine.com>
References: <20230116144853.2446315-1-daniel.machon@microchip.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230116144853.2446315-1-daniel.machon@microchip.com>
X-ClientProxiedBy: AM0PR07CA0013.eurprd07.prod.outlook.com
 (2603:10a6:208:ac::26) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY3PR13MB4963:EE_
X-MS-Office365-Filtering-Correlation-Id: fa7c0fea-2c5f-4420-6d31-08daf9432cf3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gd1AaGXvopWQXP9jVTEjRo1xk8att95eQy5PFKbO3Bwf+G/CSZA5cRCXAJDBa0LcHnqAMoD7RbPsWChyz901qWnSF1/wOSVJfA05lZKS2H32z3B0A38TSFGYqRHYjmDzTHYAG+c8kLUOeC9WIJi2Rx53Tv4ufX3nGsJg6AjJPZZMdeFJH5uW4QMpDmzxoSZ8fLgmxriC+eCWxGV+tqhSUduxl2a9wAbe0VOc3wTo4OmZXy+FYbK/IC2tcx+CxlZL3ASKDTSfcFjgNYR7VTi2RbbLo1Qq+bVfo8rbR//ve8wJkHysrQLYn9cNESXQD0K/LCDeV5M7Y1tu2ID91MIdXm/3lP91cz5DQtbmIO3GoTLsyFVvG9PV0r/tefSZl874HyZxnsFY3rPSfIbRaiBN4EAgkNc5Zjp7Ye+b6G4az1foptyW/5vovdLH4Mkt5VSGtXrQUSxxb1+nURicvySSaYKsoemqn5DfrA4yys3xsR/iwuajbApNAf6UV6e8zHnoMMKeAcPTaCKOR8HwqMoydL9yaWDCAdXJs9d5SzruoThz0h8xoQBeFxGzmAw2w1IVcgvyZNYv5k3igsZwcCbB3rl0h1gzVy66ZX/Q9isahDZA/APNma5W6qrOM0xjm6QRljUYN0emFIqn23aNAeEi0K2YTYOw28EH9+atX+CO6jwykdblFQW37FqWzNGVdQtf
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(39840400004)(366004)(136003)(396003)(346002)(451199015)(6916009)(8936002)(6506007)(66476007)(4326008)(8676002)(66899015)(5660300002)(7416002)(41300700001)(66946007)(66556008)(2906002)(44832011)(316002)(186003)(6666004)(38100700002)(2616005)(36756003)(478600001)(86362001)(6512007)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jHIAAxwY/jcazR63CE9S9cu6QG98dMjmggbs1OETcHWccyE7Q71SUmRX70Yu?=
 =?us-ascii?Q?r3LFiPdfTTZ6Cix0dZfRS/5KNe+XKTw1XWzmkLpmFTNLAjLPocCUnPkzzR9r?=
 =?us-ascii?Q?GqhGbxRfiIegHp64kmPiJAYyhFraCXTiuNBYOX5xTpNY7kQezjz2DKviA4yB?=
 =?us-ascii?Q?gljrbAqizJK1QsK8HBfBMHSezqwtga7b5+8u/GjS6t23BHMCKX2mEMsI4CjY?=
 =?us-ascii?Q?htuDNxMV5zpu6/PBb6GaNgRFnAX4TpNLdZ/79qEsBCg9Y2vKag+uoBCgwL2n?=
 =?us-ascii?Q?o88YgmfV41nyDuUfe2Z/bbqEAZkHJ3r+BUA5Va1VL0N0wnWWIibEA/Z/nEVW?=
 =?us-ascii?Q?ZSUNR40q85s2ZBpgf4JbXU+aiZ5AUW3PxuKYg1EKyyDnZLUQyATSDLv8JYic?=
 =?us-ascii?Q?ZtAadi4OYCD631K9f/9JjxoCxWFm6dx6Ys8s6czJxMO69QqLfZcwfppIhLss?=
 =?us-ascii?Q?0tygQCYSwcxG94VBjkZzcKY1JqyGRDYfsRdhwyBu5RxmZE6pHOHevHF5Kb4+?=
 =?us-ascii?Q?Oiw2tKMIJDxsfgi9G2DIlwv1tKILVJpXKtyu8uNk4SXZGzaR9kATs9lzczb0?=
 =?us-ascii?Q?/cPAXve50K8ePHj1xVEU1J4Qav5u8D7meMSQSluX5VGzc7TRJimxr389wKmP?=
 =?us-ascii?Q?KZv4tyQNbDKZmXBuLHGKfZXAumptVVJKjmeHXw29HjYnJT2zR9qGpuS35iNl?=
 =?us-ascii?Q?wSBqB6CidVjskUXy7+jsDdXfE6lUMhA82tivvY4uDmlwU2D/glX1CsC4z6OE?=
 =?us-ascii?Q?mfGzqZqHNfOaaVi4sTOEGtUeQ4h7cN2EMl939mNrXQiDVJcve228gsX4LwAA?=
 =?us-ascii?Q?Z6YXS7/6FVeeOcrcBlXwYpndDOWIAc8A6Jlgb0eAU7k82uYhtlMrEXgWjZUN?=
 =?us-ascii?Q?gd9akjlz3URNDW6lWzHvOpisQnYqgsjHpMnfZHtkwI9RvSo9TiUxEfSJObGf?=
 =?us-ascii?Q?CUQVJ2GAlTrHTTu0UVzMuETHHFKEbxmdyUYwvWyPFaWTqBZMt9NMjqrE2TRV?=
 =?us-ascii?Q?d3BZsir5Oyx2kQFyk4XxL5yWt4KMNM4bnDrpy0jPWw2y6A33XwIrxY8i2l9s?=
 =?us-ascii?Q?17H3hcMgC6Dg7t0TxZhGTuuQ+P5sqKY1rTYMQo/CNTDJSxdZNArZJAMKBJJo?=
 =?us-ascii?Q?ndXzmLa4BhPBi6FmNhmbyzGTS2UCxBN68OwJFVvaRti2E2KYj4DrrTFC0o+c?=
 =?us-ascii?Q?4TAZyO8g3uJo66XcMvbp0P5j7uLIraluyBSb5NQ/i/bozcjx1IHFY34JFmCm?=
 =?us-ascii?Q?r9o1GorVD6oQzraJ9ShGZ7P9gkZO98ylEgnwxV5BuWz0avTCSfONRF3kAPaI?=
 =?us-ascii?Q?KPJfDXfXYsS6Bsyh0kOK9oo42Umq+6SPlSR4K8nNy00IdM0AphWyKIt9An7R?=
 =?us-ascii?Q?dcgXK7mgELTdHLR+Jp/Hz1/7hFFP4+aRypuAuDxdhlM+pjan/qhDDuFmWQRl?=
 =?us-ascii?Q?wXEbw9MNKXq5U1TVyJIewL+gNHLyq7L+MvHCFffP2f30CBH+vivgyfpBRBSE?=
 =?us-ascii?Q?q7ftXc7XhVoheVm/lblEEWof3oYHbakSjidW2trQEKkezAy4ktx5nEwc9NpJ?=
 =?us-ascii?Q?ZwD6twOQsz9QiP/RPYwCoTvNQlc+cRFpqGpYNIdfdON1CFX6q34g1bH4O7fl?=
 =?us-ascii?Q?A+YUYteFNu8X6T7lu416byonklULF1ZgoJ5ar1esWc5zK7G84Nk7i4zXu8PQ?=
 =?us-ascii?Q?khjNLQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa7c0fea-2c5f-4420-6d31-08daf9432cf3
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 11:00:14.0653
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uXxlYXWa2QCa8ooQeWzAe2zA+hRsYZ+I+ZQSRAMHz4M4NddiDJpJwj2NiXSmim1yGtlSjwP1L2ToW9GU0XNgMF2SNyRZDreVcGt6jmgCS8o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR13MB4963
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 16, 2023 at 03:48:47PM +0100, Daniel Machon wrote:
> There is currently no support for per-port egress mapping of priority to PCP and
> priority to DSCP. Some support for expressing egress mapping of PCP is supported
> through ip link, with the 'egress-qos-map', however this command only maps
> priority to PCP, and for vlan interfaces only. DCB APP already has support for
> per-port ingress mapping of PCP/DEI, DSCP and a bunch of other stuff. So why not
> take advantage of this fact, and add a new table that does the reverse.
> 
> This patch series introduces the new DCB rewrite table. Whereas the DCB
> APP table deals with ingress mapping of PID (protocol identifier) to priority,
> the rewrite table deals with egress mapping of priority to PID.
> 
> It is indeed possible to integrate rewrite in the existing APP table, by
> introducing new dedicated rewrite selectors, and altering existing functions
> to treat rewrite entries specially. However, I feel like this is not a good
> solution, and will pollute the APP namespace. APP is well-defined in IEEE, and
> some userspace relies of advertised entries - for this fact, separating APP and
> rewrite into to completely separate objects, seems to me the best solution.
> 
> The new table shares much functionality with the APP table, and as such, much
> existing code is reused, or slightly modified, to work for both.

Thanks Daniel,

FWIIW, this looks nice and clean to me.

Reviewed-by: Simon Horman <simon.horman@corigine.com>

