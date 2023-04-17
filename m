Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 207C26E4A01
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 15:35:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230157AbjDQNfF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 09:35:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230390AbjDQNex (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 09:34:53 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2138.outbound.protection.outlook.com [40.107.95.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD9D376BD
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 06:34:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S0w0/gCgzzqgxa67r5UpM/xViSZruFQFbV70lGtp4C/Gp4si3PHXcoBjnBnCALC1c1ikJmE836B9H7QUaYaKOp3FnERQNGJ3ZJvwXyEASopuOIHxP7gBKk7ZWD7KVvoVVVTWjbIlXDgLtWc8wyIAssyuP7mt2UjZ95YAcaDiw0j48ax2us8/RbX/ItgpkpZDKNatWqVvl9Mj9XzV97bw/qsNpsWvhwNN83oeoUSe/nNwo5vCq+2sC+S9MyLWyPbu+STNBaUoAquy1MDbdPSU9h8NFvy6nSfhV/QV5AgadiE3T84cwqZf8rzB23PUsyqC9Z9JfR07n9Vw0mzg8Orxlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tu42BJCN+/M5p0fAZ/ecS/AOuXmQbXLwfPAhXgIi0jw=;
 b=JtHqNG7z44T+mbPYsmhfw4AYFcDeGtYZQb+wlizq2/VByTKg+uPT0XytwmWGXS/MUKXd/YI+kOsHB7sv0uzlu4oWRHltRjx6YOAhdr7aw77w8X15Kf7tx0O6pN/GJ+eNk7mIxXDgzbYSuq7RArLzrusUYVE0rvbfHdnkQ27VkW6LzZ5tE5T5nn4MLnOLs9OJtnyZsSomHfSaDKp0HzkgGGeWyh0xKOmyd/zBBBUkdKS03F0dyK7b+6v1nqXSlI/ZApJ+k7AeTN6Am+Q6SaOJgdQNA4HTCFoHn8cyFZI01V4piqGcsbitiHPTFh4K+N6BumvgDTfE9XH6Dqb0VFCOHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tu42BJCN+/M5p0fAZ/ecS/AOuXmQbXLwfPAhXgIi0jw=;
 b=PDUj053fHJcoGV9BbKCY2LbXwvC9AnfhuqW5b7I9KLVGJP/nEcnd9X8Qbh3gEghAjMTgJqacx0ZrGuJnhqfC7MdZRLbes3ziUgJFteao2BxBFNVQpEhQdGH5GhlZsQa16c3WRALOQFzVMLn8jcj/K3WcPolkIZwOmQdb9xIqwlA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM4PR13MB5857.namprd13.prod.outlook.com (2603:10b6:8:44::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6298.30; Mon, 17 Apr 2023 13:34:19 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169%5]) with mapi id 15.20.6298.045; Mon, 17 Apr 2023
 13:34:19 +0000
Date:   Mon, 17 Apr 2023 15:34:12 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Raed Salem <raeds@nvidia.com>, Emeel Hakim <ehakim@nvidia.com>
Subject: Re: [PATCH net-next v1 07/10] net/mlx5e: Listen to ARP events to
 update IPsec L2 headers in tunnel mode
Message-ID: <ZD1K1M8TqGdMwDBX@corigine.com>
References: <cover.1681388425.git.leonro@nvidia.com>
 <b08025ba8fe3e117adebbbb69032e3d97de506bb.1681388425.git.leonro@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b08025ba8fe3e117adebbbb69032e3d97de506bb.1681388425.git.leonro@nvidia.com>
X-ClientProxiedBy: AM4PR05CA0001.eurprd05.prod.outlook.com (2603:10a6:205::14)
 To PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM4PR13MB5857:EE_
X-MS-Office365-Filtering-Correlation-Id: d53d3a3f-6acd-4d2a-90ac-08db3f48729b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H0Oo/Xh/KMpI2w71b/3wRIoK+5o53HUsh5nUoDt4YduIItF0ScMDStrOTtz8LZ+1JcbTsMM4CUJjRA1a/O6GACEtB8UXwxCErHvniJV0XAdtMN76W1e3HuTs/5sNuAOKcBspl4PYitTu/H/Calz2xATrxitpNbAqZkE8UHkXy2ERH/PBYlX/rSH9tjapioe5uisFaLcSTdeAGc8phXzDio9M8ZfnhyEhp3CzV7i7/czw1BMc66QzP9ZdlaCtnVWwRmOg5wSR5P8jhEEc2O40Zj6leqUfl7dyhrO24xYlv5c3+ZJEMTwMxF03NoLsM8zgHh/hwvGOxYR2Qxg31HlpKl7rapejbtUUHfPJK9tJ1kvqK64fkGe+cCSciPoZAsupqZCfzsZRQUqNtr6UVQXZntRhdKxlYm9fck3H42qLRwsjrQ1vNvgvZK3Xzl7VhLz900kNMOoOSniOypjcwhGdlpoyjlhOYsqED0GiWT6LhMu6Ib1QJcgNQTD8MA53xa8JM/P4jtrF8SDPAfG4j31HHmZ6NkdAaPDbXWsSWMClRn6Fbgwf4m+AjrEF2Vo8+203
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(346002)(136003)(366004)(39840400004)(451199021)(5660300002)(4744005)(6486002)(6916009)(66476007)(66556008)(2906002)(4326008)(66946007)(36756003)(44832011)(7416002)(15650500001)(86362001)(8936002)(38100700002)(41300700001)(478600001)(6666004)(8676002)(316002)(54906003)(6506007)(6512007)(2616005)(186003)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Dy7nKg+0BGMjmWoyhJi+hwCg8ydggzgvMhWqXpA5YKZQnwOOkG1W2MPl6tlF?=
 =?us-ascii?Q?XY6zklmygzQT/lG31llarx0pHDnecWGRHeN5QeDGbDmUv8d1nMw4OZjS3wtU?=
 =?us-ascii?Q?YQoNwVtGEKEwi/TdGtg5tlnwDbePw1rM2f1dvqPvV+2+7v2V5OMrWlYde+JJ?=
 =?us-ascii?Q?pklqFs3wtBws01F11Vyrj7hxeq4DAZ5xq9SRlpZqAJIqyuh6POvJbBKva7sF?=
 =?us-ascii?Q?+xXOOrQwEUtT2rtV3bkhx1NMkhJf02JLImNZ5oN6kK9hKrqFGO/FBrKmCJs+?=
 =?us-ascii?Q?f8uk4QbT0UrsFeMaZkKOMHbZuncZZdfcWSo3Ig9ljfJq6EEdSm971kBf1sPF?=
 =?us-ascii?Q?CCemCiwvgehxv1VXd1nLs2EvSk8EyTVA1gcT35F6VXXKjbG8MKtKWRwG4Gkh?=
 =?us-ascii?Q?Ce6w5grYuK5UtyohNuXufQ5ACA/9nRxnRobwqjz1Vbrc6Q7+Cm0FYByj3a7K?=
 =?us-ascii?Q?o1poYW/ne2MFMaUkhCJHDUAR6X+Ymf9EEydfJ6Flsshulit1/AhnVu0p47TA?=
 =?us-ascii?Q?ptffpFiSPOmET+/9/Ho66wFX05mNch9hr+R/delPm51QwQ334wli++lZboo4?=
 =?us-ascii?Q?F86O4IhFK858kPMvEU4fwZarjbxqx2/CSWaFBa0Ylg7x1hvH7Oq4QaX03ale?=
 =?us-ascii?Q?rtAec99UOg8blytdr9QagufNm/4COZ2PB37CbBNzVrczHgvEM0md/wlIbjdM?=
 =?us-ascii?Q?+H9HtBVMtVIIrr0uxVfBvgf1PIYzxq3vj3jxRhfrCii0BmPAYTKrtVi4k1AA?=
 =?us-ascii?Q?1n6y+DeoLiT239vuKUn3JG8XAEUw3ThceYl6OaWi2Aa8VUqnq1kY5mYw29oQ?=
 =?us-ascii?Q?fJQPL4A4LkolkWESjT/W8z8YtacTfxggdvmQnNpEjkxjrVy3ANkJ/Svll12k?=
 =?us-ascii?Q?F4st5YBQb64aK+bAH2aARaH9O9jodiAldepk6QBzzOZcejU3nEDGtlEIEa8f?=
 =?us-ascii?Q?9kA76+LTzOeLhD6w9jo6dS5b7YL3k2LEbqOt8o3iqd64cC6JAwpYj8LZFjZm?=
 =?us-ascii?Q?G6mKTzDz9s2070QJ6bGS2yzOW/QM/g0bjZ6vu5XmHtRkBIt2RZf1ZYJ1vVS1?=
 =?us-ascii?Q?pC2rCDOpSjUEevVK841i6+CN1LGBDnrIqrwWbqsGScNxhWVjcIZHaKipVFZy?=
 =?us-ascii?Q?fRZA5UAm6r56bCKoZU665K/oj/Pis+hMITkYIAsrF9ptI8OqhXMS2b/fMGYS?=
 =?us-ascii?Q?Qbj6MUk7eWqb/OOGVCcDSpKuxK7onSNGYoLN+IWylYT+iMyLblFuPKGzU7ZC?=
 =?us-ascii?Q?3j7+hv6PpEqSjwfC5hEI0IQubMpCIimCl/lzk8RBD00KoC67qnnTMqKXHkkK?=
 =?us-ascii?Q?IGmOpk2sTODMhJEuou/AB1s022X0rCqfYOuAswCA10Q/dLhRJQW48Kmhf2cT?=
 =?us-ascii?Q?pD1RRS9AqwQnRQvTyYxWCOtVG6ZXAjZsEuF+t3OzwCi6BQyL6xyn6ctYD3Iy?=
 =?us-ascii?Q?HiCw9aAhNcJL0M/YgVvZPSC0DTCEDidrSQ6wfOVbHbUrVzJIDOpXs+3544Gc?=
 =?us-ascii?Q?LELCXANKVpxfrckoOzjJDy4ybJPoJ4yEfXvLrLPzr9CU/VIZq+P+D60mqPhi?=
 =?us-ascii?Q?dQoWJHTYdf4S1C+eKU2zOGHelDI7fb8BN4/L1NwtjXIF6nDjyDgPpJVq2O1O?=
 =?us-ascii?Q?6dzYPwF5F/X67ZbqE9irURV6d/75b2FvWscpwxyy00MupuJnsp98XP20xuGn?=
 =?us-ascii?Q?N/Cc8Q=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d53d3a3f-6acd-4d2a-90ac-08db3f48729b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2023 13:34:19.7178
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GuH2PiOWpdXGNV4oGDctJG+5VKAKooX6539sce2YEktMOVlMBdCMOt15uoo2/qSj0GF5OBCYw2n4lsTNrUZq/87Ix4DxZYXQis8ayA3psAA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR13MB5857
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 13, 2023 at 03:29:25PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> In IPsec packet offload mode all header manipulations are performed by
> hardware, which is responsible to add/remove L2 header with source and
> destinations MACs.
> 
> CX-7 devices don't support offload of in-kernel routing functionality,
> as such HW needs external help to fill other side MAC as it isn't
> available for HW.
> 
> As a solution, let's listen to neigh ARP updates and reconfigure IPsec
> rules on the fly once new MAC data information arrives.
> 
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

