Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E8746B2AF2
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 17:39:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbjCIQi7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 11:38:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230294AbjCIQi0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 11:38:26 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2102.outbound.protection.outlook.com [40.107.94.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7EFF23674
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 08:28:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VF6oIK5pKQ3wEcgF9zTShIaSCflJf7UUR303C3EWe2hjopCJsN8BmmQfqWL3Q36o4WkpJTxPm3i/NgNekA3MO5Zff3wVKk0F3ni7N9hElynplJqmhNHaEXB+OcSMqJBZlMFIEQyHAY6qK8GGtfibWcxpYYOcXuKlJw3ct2FwPof38wTakWtVQ97LzGcbijdr5chPBiuRs5kgnHYaLakSPON6OKe6/iEu+SbHTb07oNghsddQWYvE5uMBmNJnYcSfS1TiKKLFWhYOtIN4Nt179peLwe3dsqMUJfVyE05qyAUSgjs+deUSXuVH5eTPv4lo3Xo8QZM3g7PfrUj+k3aaqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b6gwlhPb7zWGlumfgTDLuyEs3ne58cYOU7V+3rQjK7I=;
 b=RqM6uGnlMQvzyVZRKwKUWbpt85ByihBXj8G8luTiL/2K+eJAiAwCHCDrhe1yJKFJCVn4dM0oggnDx6xbfzRfT94VLW43O6hRSaqxepz3gXR2qiTAqtw0E34SXqrLWiZdlw7RqMQCm4xIqDG3PSHtmMDu4YKqGoV92bxYDGKDegiVLDFpnDRTVmBfIkC63022C+HnS5jz0lhAAqRLdGrep5CjKpbz6+PbigjVckxmLsLfpMXQbfC96Kshc+FKUb/dWWCnw+J5vtTC9UD6LRNL0MfEugXhcXR7W1mEAX0IAmcFMxGos+BlG4qX//JYkX3jH9zPl/7dzJTTaq+/q2fx7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b6gwlhPb7zWGlumfgTDLuyEs3ne58cYOU7V+3rQjK7I=;
 b=NioWpV9y8peO9hJATfTaDm1PAytPdEm6VQfQp+nJTJPZmaW11YVyj485KbNSXpoi/2A2PW5a5PzJ8T7gfkWhOaOikIrqh6KGLkDEOR4niWs9LdzebSkpNBcFJcij77E+bahnNrMnvTcD8Kxoh9DfnlKbPhOluzmnWwroNiDmr24=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA1PR13MB5037.namprd13.prod.outlook.com (2603:10b6:806:1aa::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.18; Thu, 9 Mar
 2023 16:28:39 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.019; Thu, 9 Mar 2023
 16:28:39 +0000
Date:   Thu, 9 Mar 2023 17:28:31 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Shay Agroskin <shayagr@amazon.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        David Arinzon <darinzon@amazon.com>,
        "Woodhouse, David" <dwmw@amazon.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        Saeed Bshara <saeedb@amazon.com>,
        "Wilson, Matt" <msw@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>,
        "Itzko, Shahar" <itzko@amazon.com>,
        "Abboud, Osama" <osamaabb@amazon.com>
Subject: Re: [PATCH v4 net-next 3/5] net: ena: Add an option to configure
 large LLQ headers
Message-ID: <ZAoJLzl4vRjHOFyg@corigine.com>
References: <20230309131319.2531008-1-shayagr@amazon.com>
 <20230309131319.2531008-4-shayagr@amazon.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230309131319.2531008-4-shayagr@amazon.com>
X-ClientProxiedBy: AM3PR05CA0096.eurprd05.prod.outlook.com
 (2603:10a6:207:1::22) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA1PR13MB5037:EE_
X-MS-Office365-Filtering-Correlation-Id: 2d460323-64f0-4bf1-f317-08db20bb56f5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6j15T8qHlPlQNsszuCoNB1BkJ3KCuKaCgbz5LegqmVKxQ6GZ8H0d5Jq+soqzNXHp2nbXQAFwnRQ6+d2vC2bi35Stm5Ca0Qo/LsF0aQQfGRodceh11fMT5NIhrtK6tu0CcG+5ykLJM99XHWGe/rK4JDroCoYxhcKZIG2Hw3hwDRHMdI6DCPmT68lC44nhf7VY+W+vW6aom2mynnQLD2fhP+zHW6MfVOW0oSMry0d9PdGgS9dV3KicIak1+2zftLH/nB6q58q1jAOmYUsRM4E2/3H8FkBW3L71aX3MdhginLVGRNWiAHIIng8dJFe1Eesf/GI4WGk35xfdGgyFW1KbbvKPmWRQ0dp/sMUufl/Zds8d4oRslAVEIpT5Mw0xTGtZpMNnv0nWh/AtIJQDCt4v0VKiZ2cNTM9ld8vbUAERsP0oFXvbif0qlRcLJAjqfKmjVCiyP9Dq6PWwUYErJtc2wcdizYuLR2aeH9MZy9TW0SN9XYzQRMcel8B0VGl0kXDgsX/rYBK30N5tSYhdZcucnaa5zIWQ6HjkJ3ZMhdfbc0aI3/rUN0exB6BLm2od0JAQCSOnQuSCLrgcK9h91xmU1FVCGww+HPPwDdb7/J/Fgswhw02joVNG54sJWOb/ds9pMAdcOoiCV/XDZgXFyCy/iA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(39840400004)(376002)(136003)(346002)(396003)(451199018)(66476007)(66556008)(66946007)(316002)(41300700001)(8676002)(4326008)(54906003)(36756003)(38100700002)(8936002)(6916009)(2616005)(186003)(478600001)(5660300002)(2906002)(4744005)(44832011)(7416002)(6666004)(86362001)(6512007)(6486002)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OAB1LW+54PwmtXXoO/+d2dPS+UN0ozc4fp4jz2LeoNrMzMR2JhZUJH3W/YHU?=
 =?us-ascii?Q?zWldXcXLqMTRoYhkQh4Vxy/1Qi19aVapwXAwyYvRcaiCQmgdKy6WOJxC79DV?=
 =?us-ascii?Q?bOH0VSVsD7q0sjvnKOiEuMG1XTzWXMrc79K0GZd02SGqPSQtpoXfm0fPqUlA?=
 =?us-ascii?Q?dF+odzLQuHAcK7GZ7B/db96gKHsuJ18BEwxbjLyRGkjWPSjWWv++7LUxEvRu?=
 =?us-ascii?Q?Tl8+9WwyCd5qnbRTL7QwcNthw+3QG48YDm0xSaYkXu1vGj3ppIIK3uwqw1zl?=
 =?us-ascii?Q?aWY2GeGIJMLl6yt2p0GjzZCV3iEHmJbIatwk9Ld5UMSm0jKB7I0pPjsnC4XF?=
 =?us-ascii?Q?+NxBXVk6Iaotezb4B39/hRN8VN6lee+f0MJzNnlMKzHjZsQWjrQ50/m16x0M?=
 =?us-ascii?Q?LV7ElLUoTUccplWTql+wQBpaExfgPUjbzoc7DqGeMDzhKh2qukjeLEMc9+6b?=
 =?us-ascii?Q?2OreqgtsSInY8sj9sjgPEU1RprNTJLQduxGu3mesVoN564XWf8iRSFblXrPl?=
 =?us-ascii?Q?xTyABl60kF+/cqs9o7WClQB9UIeVIK3mhzc6Qok5cWYfxKMWoeMKgF+/w/oB?=
 =?us-ascii?Q?0gcST+cf4ECtOvX++enKdFoiqnMDX9eXctNJ3QzYXGW43po9JTq0be0ZqfNU?=
 =?us-ascii?Q?dTNl3+gZaJO13+kmnFtnO0dR10yLyZQveHF10S5G7u0cAF+aiG08hKXbS4i6?=
 =?us-ascii?Q?FfyEAOKuw6bFdoOlXrltkvs1oGLSUSdkbzeYP3KnZrqKFpoVXSQdbJ+V6yRO?=
 =?us-ascii?Q?HYlBcwvEovfsBI868UO/g58HCe4ucgK1wiz6REMZlStcVLadECMdU3CbTwps?=
 =?us-ascii?Q?EweTXU+ybjh1LO+Z5FqO3Z4T/tKunjZYOIsJ73i8+DoM2IjJrpnPapQUcvza?=
 =?us-ascii?Q?aOHa30fD8ts1GxORXO0nFUFWFhuOzW9PHykm+8awZSWGNsPDKvJ/q9p/CltR?=
 =?us-ascii?Q?t1mX4vj5NfGISux6v3F6TlHpArzY2iRv1fsc/Wg7it5apYLJqpS4qzWuobCU?=
 =?us-ascii?Q?OK5aLtWtN3iq/1bA+1rAPMgNUfswWySJvbjRUDRmaSjr0wR4FwC5SsQqsnws?=
 =?us-ascii?Q?vuhuicZ6qEQ/dkUnAMcjRz23HpSoJR41LRLMEtrwhVBG/gsxnZyy8DEIzA0j?=
 =?us-ascii?Q?vc8elI189TM0zgar3oyY/Kl+JgyTd+WSyWfcIQC+3TynJK6WUTKNmNmCKY+t?=
 =?us-ascii?Q?bnJYatDKMOr/HmAHeL3PNaMFPGZFT6puk8PuRsyl3MCfRwWrf74r62bFZQhk?=
 =?us-ascii?Q?3PErIltstBo6jSt0Rn1DMZAcSElhjKmrT/bnJVgVCLgbEVmryNFgYjarAIvN?=
 =?us-ascii?Q?+bu7OOha4HL5zKEeN7kGF0nL+KXYsgMgiPYDxvyit8ulehjvfEP302JB7TDh?=
 =?us-ascii?Q?+sg+p0ghwdDf1Imqrx/s+89hhNgiYp2EjaNBlRSk6HNC8hVBLLmXw/xf5q7e?=
 =?us-ascii?Q?b/N4opqPCPE7LT6wHDMO2/HMls7d9LkTHvNt/z1xprC5EqMwV+riWQG/+T1Z?=
 =?us-ascii?Q?B6ntkTjYfLIqpNGTJxC4GAPCxADxzI5Udcto4F4XHAb2afDwifF9lO0yyuD0?=
 =?us-ascii?Q?KFsIJDqwn2sC2Fcmk28WUhGFZFah1gYTDIXjMRe+lx15KRhitNJLEXHUSwVb?=
 =?us-ascii?Q?BFejzTzrxy6ThtZFoIdjc50F0qLdmZIPlOVEFI0qy5fmNTBlYbaUkOAf1KWa?=
 =?us-ascii?Q?yZbKKA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d460323-64f0-4bf1-f317-08db20bb56f5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2023 16:28:39.5020
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ug2Wvpl31kK3FfmwQLeY55xFypMNWVu7tIQHQCbdT9d1NkfPejPD4LvF6IYLdTIJ2RbDbmj7L3om8gZssB4O/mUqu8FGeEshZTU+ap8SCfQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR13MB5037
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 09, 2023 at 03:13:17PM +0200, Shay Agroskin wrote:
> From: David Arinzon <darinzon@amazon.com>
> 
> Allow configuring the device with large LLQ headers. The Low Latency
> Queue (LLQ) allows the driver to write the first N bytes of the packet,
> along with the rest of the TX descriptors directly into device (N can be
> either 96 or 224 for large LLQ headers configuration).
> 
> Having L4 TCP/UDP headers contained in the first 96 bytes of the packet
> is required to get maximum performance from the device.
> 
> Signed-off-by: David Arinzon <darinzon@amazon.com>
> Signed-off-by: Shay Agroskin <shayagr@amazon.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

