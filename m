Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FD446E4718
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 14:04:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbjDQMEq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 08:04:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbjDQMEo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 08:04:44 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on20730.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e89::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A53710C4
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 05:03:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eIBhQLhkoV0a9hwdH4ysv6HlvkiD46H78WI59EQ7tpU4BTWhR+5ruCVupDk1ieXuSeqJ6CZM6GPJE4gzcqSo7pjku0BIWt/NrU8LwyaPLyANtRF8/VST4UJzdM7EkdVROjtyIVJ3MggyTBZOIwaQLW5nb8UHFqdCdLsXPcVMARxzPy35XFY3oJvjV8Y9FPA/XxzRU5Z3jveft4krCsCBbymhY2lbs6b0zkVedgXzYNHNyj6dtRRnYf5DVW1KUM6kPzASKG+AFNE+P0QW54imb+EVKiN9YAxlDg81cjU+coCZ5LQo1oTgmqIwbEMdKk83MFecVIABh7/y86/GRJ1Vkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CN8M5NbYBYB00h9qXUBgMdoJuGjqMyJzjRbWLDf/3Tg=;
 b=Fzs9fpxJOzFEyZC01jdid+cBAD4fg0ALirwuxwAI01YQf/4Q8MUQXJuRx6T8kmDrFtDJVAfIqnbKCrKvjaY30/EQiAdudl2uGdjJhKMmHy9PoHPinNCB0KQ+Hnoplah6ztArHgb5eIUa5O+O/u+xIMSZ0v9UVWSWnEekPUC30FlfsYEHsfi5y8kA/9qKX5b1TjBUQofUVZqMCiFhzz3pYIThdGkKPWgkMFBLbgoiWca7lY4cYgQW6FY4nZJe/rQ3w7Mmx2vU2G1hCb+rBsEKCQ1kbXEbreankehUIY+eCryOwNtLvRT/AJCBjAHunnZgE2aOha7A0HNH562lDn5jAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CN8M5NbYBYB00h9qXUBgMdoJuGjqMyJzjRbWLDf/3Tg=;
 b=WSKru3h2w214Hjuo2ByH7kpFO9Ak4NVc7NgmsaLimiwKm47ohekDBJlzZYF8CGl4bBz5OLNCiww900tBA7HI6VfZ5oQy+ryLOjPsx2F6wWKpYFrPBqXNKGwoKyWh8+z8gK5IHjz94WSoyF8sU5OfMkdjIvNvUK8hsVEV4y/T3Wc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH0PR13MB5219.namprd13.prod.outlook.com (2603:10b6:610:fb::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Mon, 17 Apr
 2023 12:02:18 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169%5]) with mapi id 15.20.6298.045; Mon, 17 Apr 2023
 12:02:18 +0000
Date:   Mon, 17 Apr 2023 14:02:12 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Michal Schmidt <mschmidt@redhat.com>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Karol Kolacinski <karol.kolacinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Michal Michalik <michal.michalik@intel.com>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Petr Oros <poros@redhat.com>, Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH net-next v2 5/6] ice: remove unused buffer copy code in
 ice_sq_send_cmd_retry()
Message-ID: <ZD01RFPbKxhdQ//9@corigine.com>
References: <20230412081929.173220-1-mschmidt@redhat.com>
 <20230412081929.173220-6-mschmidt@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230412081929.173220-6-mschmidt@redhat.com>
X-ClientProxiedBy: AM3PR07CA0114.eurprd07.prod.outlook.com
 (2603:10a6:207:7::24) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH0PR13MB5219:EE_
X-MS-Office365-Filtering-Correlation-Id: 2de23448-ccab-410f-a424-08db3f3b975b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U03NpwshXJFDtI+MRuRD3uogiGx1+Et57MI57Dzcsb2/wLSBUwq9YcYt7yEXhi/B9DMA1Tu0k+o8duOSfUBxOfVeROie3sgoFtzQELiZa4c1feVnhCcbYsYJgosPd357yUh+fU7BqPNJ07HR7ojeC/VbRv06Idwzreb0UxFBPzYvFKqjBF5Z2v3jrL/M4SIdskFPP2Q0TfxKzw8vM9biB9lbfOPEwfnwrH4+Pg77aKJsJW2Q8MEz7nl4/la9goP80OCk19Rw3Gix3P3C5An6arYs1xc7+RiJqWJbuHvlqLVOId5KgWFCZKcdNkzzFbo0n1Pr+sHzjIIh/CctvMQf7YSR0O62+vdy5+YKqc3EQikTZY4pGGhdpNLTe7ekW0oJoxFao4bmPArAJ8Ih8OOcoqXH/tNPwfWO7HK0zbX9s2sswtk3ZIvHozt/NVMIsM48tWtYNICbqjX/ttcHoM/6thVh+DYQUkOctDBYx0VqXg6d2ruJacUuJbuFakidpB8LHHHbyTslZOiKfHCIH0EEb1HOPCbSfRw411sKMCNXaAml410REqvo5BLbEfK9udrc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(39840400004)(136003)(376002)(366004)(451199021)(66946007)(66556008)(66476007)(4326008)(6916009)(478600001)(316002)(54906003)(5660300002)(8676002)(8936002)(44832011)(41300700001)(7416002)(38100700002)(186003)(2616005)(6666004)(6486002)(6512007)(6506007)(86362001)(36756003)(2906002)(4744005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nRF6ormKfCn4kHMRJua5xzQMqWTD1yOdLSOomBb0hobZ5BbqWMhJcN+aMYNh?=
 =?us-ascii?Q?mFp/YLOFlIwFBhYwIZJYcLzs0By83G5QzkM5UY+1V0xyY/wMzXumzg36IIDr?=
 =?us-ascii?Q?3RbrTABC77ml4Wai/yB143nAtPDamQs4AJ44PTxVRgVT2FCoE/Eu4HIH2gyT?=
 =?us-ascii?Q?0+3O0Dcc0sEDNmoE4U201qM+c5IKqqGAq5WBrfJm+8AdqBuFTroWEdaY1WqK?=
 =?us-ascii?Q?CkIgQI57w+z46ymGZ0Urp97M7d5jOgc+w6eCGjH0DCn5OQozUW6HGByMkgT0?=
 =?us-ascii?Q?HYfTppO0OFyPAFoisfAtoeyeScIN4UOfwtoRrWtQ2y8MSI/Zo3QfNPP0NHb6?=
 =?us-ascii?Q?cNBmIxNif4E4HGEWIaMsRPlR6gDQMGD52i2IvAgTvWsrBCvejYP7Yv6vDU1m?=
 =?us-ascii?Q?hZWFpjWTHhWYqOdBxl6LpoMZjD6f1HxolTMpjSXh7qC0YOmAsjVWtkLKpSJg?=
 =?us-ascii?Q?by4DAvwqdAflB3AUl0DQrh/G/sFxSQfAA6XYCwx+aObNv+mt3tHc1iWC96+5?=
 =?us-ascii?Q?32ICvjZb0iAUOqN/aTAQqaaYnVmyLXTwm6Y2FV6RoBBq5Xo8wwD+OM1z9soa?=
 =?us-ascii?Q?19+3K9t1C35DM57b+MtZBfeE8zSgNKWoo0RxCM9Kmslyc3i672IYa1HISD+g?=
 =?us-ascii?Q?EGBsIJEHuYqGFBkRReofTerAlFM4dGdO+67oinl03Xsp6y1mjemlRhfltJHP?=
 =?us-ascii?Q?sqe5Vo4Fpo8GdlmmIi1On4Bi7UrHrgB/JlNHRTGzei9nnJ5LEwUT4EJ2qIu0?=
 =?us-ascii?Q?/aEBsSGe0fheKd2Nd3Hy8x+WLVWHr5s2AzUtNntWSf4wJq5NRPFvI0os+Q1G?=
 =?us-ascii?Q?EZ6saSWc4AJ3b3VFwJU2AK4Fyx89wVWH81Hurinf9m1NOh0tg5zw1Z5Rc2i4?=
 =?us-ascii?Q?qFfojw6di0oM2H8QYX93W0imj0aMo37/t0ZlwIoa9ddIzgTsuOsOMwKGMvjD?=
 =?us-ascii?Q?+AT95eNXTO28r/o0ftKGCGc4ABk/jpjyEGaHp2syMreLVUlHkzf7DwTZ5BKB?=
 =?us-ascii?Q?RxGLQ2tXGKM1eoqKz+5IMbL9jr/69G8BwxjVQA/MNKDw9fo3jnwhuBS4FE0j?=
 =?us-ascii?Q?lWrnok95gA3yVuPZRZLheczwWHQOe/si/4T+u0AD6I7Y5pitqqD4kIw2Yp2D?=
 =?us-ascii?Q?/1ubFhksttOwX3EUIiJWZqAWPQYkCMqc29Jsc0nWpWBAnMYTkDFdlEjTH2wL?=
 =?us-ascii?Q?wV5g3QUk0EyFliuTO47i+KchHOntfVwoyH4LC12QBUz8XbYrIlDBCWsCjIYy?=
 =?us-ascii?Q?9K+IYBO1DRyr3PidVmuVp5pOTrMxQ4IEON4kvKcScDPBI4Q2iWFfWHaXTt0Q?=
 =?us-ascii?Q?YmbtRFTg2aPux7H8SzJadNiPy/YC8YRhwruCBdgHgUv/wMt9fL94QmvpSdBX?=
 =?us-ascii?Q?Yv69bk1Kjg9XsmobzuI0fggVTSpeX/ennYUDUyXdSAcY+toZBrGXHeiDD6fi?=
 =?us-ascii?Q?+DT8dAiKeozrj/oSy2yEdQdhOYOGIYrilwE6+KJ/jYTEUm0qPxLcj5c4gXRk?=
 =?us-ascii?Q?yTYTp3GNN8zdsLgICPx9SJfY7kT0eg6OJynT7OCYrZEGZpQsCa2Wija5X3ux?=
 =?us-ascii?Q?fCFgEJH1q31leI/A2paW2OeaTvMIPRptriG2nclHnvsUVy6bmYtEhLdsOyvu?=
 =?us-ascii?Q?iu605j9CRpdjVqVsS6DpShWcy3pm5/wpaGYrroNq5TH1/8SzIe1LlZZNf8oI?=
 =?us-ascii?Q?MbwYQQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2de23448-ccab-410f-a424-08db3f3b975b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2023 12:02:17.9198
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fVQRLMGTWh9Tkf3mN5FvnuAMYXsMpCSQe+icKwiBdsV14qrY47/3bivHdsCRudG95OuaN6hDPgwZhtTK6pDMLspzYAuaKy8fGs/esxbK51o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR13MB5219
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 12, 2023 at 10:19:28AM +0200, Michal Schmidt wrote:
> The 'buf_cpy'-related code in ice_sq_send_cmd_retry() looks broken.
> 'buf' is nowhere copied into 'buf_cpy'.
> 
> The reason this does not cause problems is that all commands for which
> 'is_cmd_for_retry' is true go with a NULL buf.
> 
> Let's remove 'buf_cpy'. Add a WARN_ON in case the assumption no longer
> holds in the future.
> 
> Signed-off-by: Michal Schmidt <mschmidt@redhat.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>
