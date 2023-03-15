Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C6316BB92F
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 17:11:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232869AbjCOQLD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 12:11:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232845AbjCOQKn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 12:10:43 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2124.outbound.protection.outlook.com [40.107.223.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A1D51B30A;
        Wed, 15 Mar 2023 09:10:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YbJMbp7I1E/aSqUJqF3ZIQWWDWBAxhpooNDxW0laOIfRNO3Y/BoHV86/gA9+0lebBx87yTEwDkjglxL6ba3RjNRxLqCY0gyy2iCpsc24hdNEXR/oBxVTWcOw81xlwe68kKL61vBV0gmXnhbYbKQK2ppwXBCPt/kzyqEeStfhp9Q/yfH+sUHcgrCcnRLCnFgC7YjDIXnL/RriYg7++qBqOxYgX9m5PCabQ/pma1VGRRn8DZuhcyPHiEAF0HDJDjqZToxYfhQBtQWH0Y+UzNebBn2SxFTSCwE7lzpj5HxPjjy97oUbcyppL2XLSBJSr7Her0jYhzfy08gZkLa8cfpIfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VorMp1n37eNLkJ4G76x514tq1H98yjVSpwUmDi9VOxw=;
 b=BXd2G7XDxDcFw/rSpD+RNPJ3ciKJh56PLHSeTkRFa6b1s4/bnEwwHC1m999I26DBlR5ieHfpPVdI8nAX8gGyefztktx7oStCiRV+BKv/GKvwjbDKSPMxXc6IVJQbRvcT1C6GScU018JO8NtvxMRRrjnlbPGDKIxl85cpcfLrdDRbm0kb9LVdfbGLjx71+S9VAzpEt4rINm3UN3adpvl4rElPCq/YPWlrlsCCdaZ6z7QvZ9klCynvJMTZr+M9at7eSmRqcgHGAZ000XmOP6x+D//SUs8uVf7bC0J1GhoMs7gWxqF3FBBXTz3MKE3IRCmsyLanqvtlKRwyGupdBWA27g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VorMp1n37eNLkJ4G76x514tq1H98yjVSpwUmDi9VOxw=;
 b=umHYg6WIE8N70sK2YCDi0s/bIcrFnd3WF+IKDZA3147IG7rXaGDXZPvU4MNH9y/ZKWNO4p99d+b7LIyUQ2uM1ZyowXmcCaNZQHxVdkTvBs1stzCLvGDPyvrIbkiMWka1cNddYZuy+XHqbHwmm4vHrPL8R12R5Thsn3Bt6LLY9b4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY5PR13MB3763.namprd13.prod.outlook.com (2603:10b6:a03:22a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.29; Wed, 15 Mar
 2023 16:09:58 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.030; Wed, 15 Mar 2023
 16:09:58 +0000
Date:   Wed, 15 Mar 2023 17:09:48 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, marcel@holtmann.org,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        gregkh@linuxfoundation.org, jirislaby@kernel.org,
        alok.a.tiwari@oracle.com, hdanton@sina.com,
        ilpo.jarvinen@linux.intel.com, leon@kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-serial@vger.kernel.org, amitkumar.karwar@nxp.com,
        rohit.fule@nxp.com, sherry.sun@nxp.com
Subject: Re: [PATCH v12 2/4] serdev: Add method to assert break signal over
 tty UART port
Message-ID: <ZBHtzF7cCvKyRGrp@corigine.com>
References: <20230315120327.958413-1-neeraj.sanjaykale@nxp.com>
 <20230315120327.958413-3-neeraj.sanjaykale@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230315120327.958413-3-neeraj.sanjaykale@nxp.com>
X-ClientProxiedBy: AM3PR05CA0140.eurprd05.prod.outlook.com
 (2603:10a6:207:3::18) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY5PR13MB3763:EE_
X-MS-Office365-Filtering-Correlation-Id: d8c52d54-bd84-4315-b171-08db256fb975
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JHTO/P9Lq5Hjb45WJOZcHKEgtGiJlv7185DWscNzIBD/rIklYi1kheYhRM1QXHyrNiQcI82aZVxehT7zwfz+sJugRkgC+9B2Z4OfOM9hh7xQ7+F1iwUae6cXCmbtzvX/sSUPwD+TSVQHT1HBYRelkgBp1bz/LF4czRLfRTG3nxbWlyCHKg7PL+z1i61PQ0fKwZo0uCnLaZ95ZiSyk1me4RKmYYIQpMPy4ad8kWmMLV7prmHUqJ87az0M2Unzu2cs3iSgt8iW3VK6H2BWCuhnpzBc7sqWYAD7x+FA0y/rHpGnqegKKYW8IscNKB2KjbYy7OmI8XDhuu1S5gk0DM0+N3xP9TyquSOuF1+n07R2BOAvR2yl8ahZL81n9BROTmtUv6EHC3VY6EuwG3J/NhFVlhOpl+Azt/F4LobksrRv/nI71hpdUbQ8SoELS2ISB3Z1WuZ2J6yijE9m30TGIvbekkBmkWm0cNG2ya9FjLgXemutuKpTc1WsrfZCxZnhDZWILVFaYeBeGJZUkMaavsMCrLN1VIdK0G0VPa7xoLkjBxLGhz83938WLqHLYemIQ0JgO88HCG1DwXIpCbYhkNI7LoBttvcqVGHSJlYXMh0hA9GLrok8WBb5LBad31F6mpbDx7Iwo4XjFOVlOOczVCas/Mk5zmRuoGX36qSsW7RhZkA2cekSERf9on9noHjzK9iO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(39830400003)(376002)(136003)(396003)(346002)(451199018)(36756003)(86362001)(38100700002)(2906002)(41300700001)(8936002)(7416002)(4744005)(5660300002)(4326008)(2616005)(6512007)(6506007)(186003)(316002)(66476007)(8676002)(6486002)(66946007)(6666004)(6916009)(478600001)(44832011)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?u4Jmiors0x3TyqL+RXS33Bt+0yMVPdRtzWWVGYVRPBPgw0r3vNIUmU07FWnL?=
 =?us-ascii?Q?+iI7Y01qwf36/yCKA3LES9CGigvbrynsv9748zKCx/eZjgY9Er0TLZXqPqjD?=
 =?us-ascii?Q?sn/nuhCX9RFM1WY/Z2Ryvaon83HcYGmq7rcyBIAx3jpc32RGnCZfBI3cfNQ9?=
 =?us-ascii?Q?c+KmTmIpTniqSZ9JjHGB9PrHpSZ9TQmtOhrh22cTPLSZ52t0H4qfS/IHoUND?=
 =?us-ascii?Q?dJ9xRCD5VjaIVgf7t0wmZEfpimqbVzoJ84LT8JiBLoPelyGZ09K9klTjYZLR?=
 =?us-ascii?Q?tCKz3PbSHqlGudzLTSc2pxOHW43yLK2yIolHUGjG8IBuMx+kyzTIVUlxgqng?=
 =?us-ascii?Q?wNFZdZ2MMnTYVTBByZuZ4Ar/jDCgFmVziQvusA2dM+xg9RkR59sxlmHZSDaI?=
 =?us-ascii?Q?p7u92dav8ugN3xQFWXyh3bv+Mq9ROGSLDMwsv9l82xizhhiI0uzx9m9XxOiN?=
 =?us-ascii?Q?wj2D3Jq2kVQsoTLknSeQQM31by++PGS+9blkCc88EmyNTHHDKWR6hmxny5XQ?=
 =?us-ascii?Q?JfqaR+Fs74JpCWmOga7Q3jCaM6GmlKEEN3RYBooLeyjHpikSHUZQf2YwJtkE?=
 =?us-ascii?Q?frf2ORELBPaNGP12G+VK+ZJejD3HGjhLXTLjEgMixGQLrRO0GrJa5eRPUZB3?=
 =?us-ascii?Q?GZpyPjzD12zBfS9jraLtPQPFkc065I7giaBVNnFyWEX70hDFSoUA1JOVbSdT?=
 =?us-ascii?Q?LGX+LLQvo6oLJTbo6w8yYUPyOkY0kflTGY4otBmxCuV5mYwFygaYPJdv8oLY?=
 =?us-ascii?Q?rE9LH3dz/JIZRyGeydyAoa4lnMQUZtTqpCSSf0QzNoEpY12qoQznvriV6iNp?=
 =?us-ascii?Q?sbstecJzbTgE0Q5qEsobc8fZU7qZNneQwLHiv6QAojN5y+YTwiP0iVwHUwP1?=
 =?us-ascii?Q?CCQCUzUKDMEeOH4A8v2wvDkcMh8LZ90S/KbEQdo5iiyTw1lnODJhGjed1oUa?=
 =?us-ascii?Q?XDexk8Uq4hZen3bxI9UFeno53kGyA3Hsp4UejDLa7U0XbzAl3OtrihM09ynK?=
 =?us-ascii?Q?iMyE50SctDi7e/o5ueDiBUGN30xxePjCX5juVeOEexFUtOJuCTmGp8i+S7AL?=
 =?us-ascii?Q?gO+bIfmiEJqnE53WqaeN8UppRyaS269Rg+VCUHM8CO3PbW4yJ9p4cLbu0khx?=
 =?us-ascii?Q?r7+iZWcrQ5SvZw2b7Tp96n3uVSfFBglSOcLQ05TdYET3kR6BkL5q49RMFR9F?=
 =?us-ascii?Q?4YAg0Tp6LvPIJFbeSW48C4vf9QueN17VqrGi9PcQFVi5lJHnuo/MbGGzpkRH?=
 =?us-ascii?Q?LgeIwNlLwGam+qlYaDEh9Uj6Z19HOZEpQCiTENK8JolXaiiIF7ZJMRbWc5B/?=
 =?us-ascii?Q?IthJgAS/kJRHCOxx340pPGlewTWj1zu7xDcbWDp6pPofzY/bN9EO8xNhKv/C?=
 =?us-ascii?Q?LtuDaqLsTmwMcnON89KgQhd9pp6iy44bEAe9DvURwdkhMCmpKuXlkWNvmY53?=
 =?us-ascii?Q?JzDBLnZLtU66E/0O7KshDlvtDhn0fyIZpYmy7xDf0x09aJ2s6dQ5Bpt35bY9?=
 =?us-ascii?Q?ogmWoCHUCx0epS+ejhaYfxIpy/Zm7ws8WbTsyqOHfJsB0VXaPh9++mdfvluq?=
 =?us-ascii?Q?lFhJAfSEr9maMHOQmOFfxNSO5lMettLGhfsuMRsHexULpo35dW1a2DyD99iq?=
 =?us-ascii?Q?uLnGrpNs7mDpr2P+L7tzWmxhJ86Tb+mroaZN7KT7eygKhj0QPqQ/C7sTJx0b?=
 =?us-ascii?Q?LG9c+g=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8c52d54-bd84-4315-b171-08db256fb975
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 16:09:58.7715
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XvJKLSqNUucQTi9/BB7ojU5bFjqvuvJguiV271QRaIdjZ0jWku752CHYsD/pCsFP0ULRP+Id8jrji6U3XZsg2VJozDPc1Un6qeUDj12RScI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR13MB3763
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 15, 2023 at 05:33:24PM +0530, Neeraj Sanjay Kale wrote:
> Adds serdev_device_break_ctl() and an implementation for ttyport.
> This function simply calls the break_ctl in tty layer, which can
> assert a break signal over UART-TX line, if the tty and the
> underlying platform and UART peripheral supports this operation.
> 
> Signed-off-by: Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

