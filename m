Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2EEC6BBCBD
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 19:53:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232623AbjCOSxi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 14:53:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232624AbjCOSxg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 14:53:36 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D905374317
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 11:53:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TYqc/JcND/XPa8yNfo7FbzBld0J79APZHqnjx0S5RtkN8OJ+qdA2kxVrJ7OvVF4Uw4I9w1KcpAfChZJEY7792mxnGf9wlRTavWSBfyaOYUNYG4NBF/OlFBHZ2tzjSk5OI7Z/Wasr7i1E//C6ZYvKn+eA/OIRY11tHsNsxokTOLlOpxQviZycxggpbThKwSMrjJU3girrJd9XhhPdWYIPo96OHsfs9smFuuwiPZCjNpKiaJXiTX4iLobHTEydHyCr6YrKMwlZD8r6ejZ0KSoqKgJD0k5679Sm3GPTpRCCwfytz1xllOMCYcQfbsq42BL6CPGXw2Duilw3h5u8FkEIvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wUTVsYtEbL1sJx8fI16VbeLmlSSickHHEKNpZcdOu68=;
 b=NeXnw1G/nFxJHELR5lIAwGfI/iaJWioR/j3bZPIcvkJI7dI4pEIp2zUHvK9oWHmboi3VDRe3QbY181diRXlJGD7PB5kWdowee2QGcehbw30cMQeO+GDwka697D4vp+BskEWxmyjT1fZrIZr3dar/K5FV6O61C2isB1eAxxtrnPF1qF+P+pFu+XmR9wfNQIUdyTZoXBFFuZaiwTfYmmbaTKQupTpL1EHWk2vMAB6ZgDMw1JO5r7u92S8u6oHat/MI4vBdrua5WL7BwvMt0YSy/Os3Hqe60D1eeVvNQ3sCsMVGqpZN+JkSTB7iwCCC/Vx9ktay5xTWvtr9HhoSlGmSdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wUTVsYtEbL1sJx8fI16VbeLmlSSickHHEKNpZcdOu68=;
 b=VqJ5dRY/v9byinTx7W2LCJ83NnSQ2COFd+7mqbZQ9ZbmPdwE5Cd4+dxgGvrKjAWCDuqDxXNC0+phdMWHbHx7MfIHv5G0qpgSy4VqtXO544nmk+kCPS/j8rymoD0AcxsdB1lcafAbyHyOBAHiabtgppNAXNUXiGBsxDr2PH7ZgNs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CO6PR13MB5305.namprd13.prod.outlook.com (2603:10b6:303:148::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Wed, 15 Mar
 2023 18:53:32 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.030; Wed, 15 Mar 2023
 18:53:32 +0000
Date:   Wed, 15 Mar 2023 19:53:25 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com
Subject: Re: [PATCH net-next 4/8] ipv6: constify inet6_mc_check()
Message-ID: <ZBIUJX8Yo520uTDs@corigine.com>
References: <20230315154245.3405750-1-edumazet@google.com>
 <20230315154245.3405750-5-edumazet@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230315154245.3405750-5-edumazet@google.com>
X-ClientProxiedBy: AS4P190CA0016.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d0::10) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CO6PR13MB5305:EE_
X-MS-Office365-Filtering-Correlation-Id: c3334222-260c-40dd-4007-08db2586929d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +1Wqu6iFPrIQ+0ersnravsbDDuGencZt/ywb42gCLYWKji1eslojlQ0BSy0E+1FA/cH+gd2DuOmwEWr0F/9M5RfssQlDXg4XTSg9ixZ5kwQa7Shhv00N18UihpkepInbe72L+dmqcNgsNAC1U9JnhW44zBwpVH6XvgK8gMcUvluybWX95dERn/4hQiJmdXsqJg2aEW4XbD8u+cRpI3wp7ixMdHNVGXtD8EQjQ2Y7bd26s/2omtfRjqpeHDhDe9z9Bd68uN4cO/gbe+jNPGgbpccEl42acYR1qUVapNy2GnKo3Ux/p8f2ReMSKeYL9/iq1UDf3CCkbM1qQEDBd2Yf91N8YQwH2Liw0nr7odDaXGymbZzUBlOJw+PHiFNFGDTUrBQzfkUy7QOPYO1CDGXpq7I8+XYdHPaHYYs0Tl679/6hhX1FlUk78oC+GKelpsJgQ12SHqG2mF3+jC64RZpXrN4EcOZ00kONh4dSNho6A+osfoCV0DaHpjFNG1L2woiIfv/HM+bcJYwdRrMH1Ck17VFKvxCadf6vxbSdxGdm/M1lHWsWRwjAeGAlq3fyghs/igtT1C3/vKQAL+h8stT3m+uFUdiC4J2fN5fBOJFAC6dyRBYCjQgitL7PncHceKw3HtyrCyZEYKXr63P0k1O0Rw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(376002)(136003)(346002)(39840400004)(396003)(451199018)(38100700002)(2906002)(2616005)(316002)(478600001)(6512007)(54906003)(6666004)(86362001)(6506007)(36756003)(558084003)(41300700001)(6916009)(4326008)(66946007)(66476007)(8676002)(66556008)(8936002)(44832011)(6486002)(186003)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4kPtgbLuzBxtSjOpWU6+13Jb/H77mYfhUxcphY/hNAJGPg2UHEKfBL+k2kQq?=
 =?us-ascii?Q?lIjHm0ZKSEIFHSdkBJRR+api1lrOgfFwKsPejNFa2iifSWv320NteyDWoE4L?=
 =?us-ascii?Q?VJ3LuE2FIZSij6JtXf1Nkz6ACt9GQjG8guj6cHLqXgIkjz0bIpijV/6uUNmD?=
 =?us-ascii?Q?NsvpynpE/dRyRKKyuZtBNfD5pQzXPyI8H2TOyNK65MYJwUlEwezpryzrL9as?=
 =?us-ascii?Q?we0+vmTkKFp/3PZthbzkXBovVe+zalHD5sRK4ZskJzR4ZlvAR2tci/nTTX4V?=
 =?us-ascii?Q?TN4J5YNL8R5v1LJ3M/evvq3BLmAuIYiY6KXKc0VK0rah6pJECf/3lWRuhgOp?=
 =?us-ascii?Q?48/8zPuHF7clljlt03hbRDMBIHT9E4qnAqNgyVzz8i3ew2s9ACO0ds2rX6cv?=
 =?us-ascii?Q?ZlQ4q0JSoLBNr5JyO6IRUbGbkcgKFNu9DZxPDYmb+5z8xDf8ryqWGI2h/msG?=
 =?us-ascii?Q?+5/uF8kn8XYu2mEVP5lRGJRQHh4bGs8lpl/8oCWUzaascr3ogN4lc1fuxiq9?=
 =?us-ascii?Q?1oIT+eIHNbrd28wZv/nWAd+xaCIdvIevbprbcJuvMsvKnV2iXfjdjd3wz86X?=
 =?us-ascii?Q?fS8ovcc01uGkKaS2gta2TRo6x8Hr/2NVom70szTmH8k2QXbOlFJBMrdxdMDg?=
 =?us-ascii?Q?sATRab/zBST4FX5rcEN8mxSMiLp6/bXIHts+3tbJBkYHr2doIZppDWtZP/Rg?=
 =?us-ascii?Q?Dbk5zmBIZVuJkqYC3WfFqPJHWEbsxWw4TjnASAhxq5MOOV1npFqhkBYAOiM3?=
 =?us-ascii?Q?+5ujomjkXxOyMyuTtJX1QAMwBbZqcm+0rhI+Rd7a2MlJIiMM051KPiqHMWfo?=
 =?us-ascii?Q?kepKjkKfomh+txkWRRliktsh6huEc8880k/mO1OGscvIrZuL/jrLrHsR3zes?=
 =?us-ascii?Q?rqes82PeW0hNreOdh+ZAGRxF0Xkp1zBA1oE+l26hvQ/uB5eynTe+WXNi4hHR?=
 =?us-ascii?Q?S2VFpkR9BvmOUAydi1ZwbRaxcP7GG2Ccm6iFzzEADF1W9NTuGEwOLYQmOMJ3?=
 =?us-ascii?Q?UH789syxbkMoamZRfIVuI+z+E8ppU9cbHWuOePCNaPq7ETiV5FvCWwXRr5dS?=
 =?us-ascii?Q?9Mo32xS5s9r/Bia8/8Ch212drN1FvGiJmp71hc62HKtZRRch3y3zOAdPflTO?=
 =?us-ascii?Q?vEujjMOq4YHo4np6j2L8mUjSfuIkrXDQDpkC9NX3TYwyOWiDKYtTizMLd+B8?=
 =?us-ascii?Q?BaFcEzQOJfgZXS6MmKApJloyieg7qH+URddTSUzbi0VUEdjr93UMM7T3wt1P?=
 =?us-ascii?Q?xO3bm1Fp0uS+7ivMZ1BRcyoyyxvK3P8CTdW49lJzHV+r10YzrXygLwEn9AHG?=
 =?us-ascii?Q?24pG/s8e5SYRawS12xrI7srDUKKwhNPiMxXSH6rua4hHu8Ouzrjm19G4eYNl?=
 =?us-ascii?Q?nalcS8P7RLvU9nfYOYlRjSB+84wQifRc+G3w2/yyUt5o/M2aozZBraLMHjNJ?=
 =?us-ascii?Q?4CyEzovBuRZZqChSsS2hB7sTHF3bX7VSxmaqN/Res+rhVhUs/dFvo9Q+Q0lP?=
 =?us-ascii?Q?2/RPYw5sNeWAgYNHlmOfmpmKjQxWkA+uj/CZCAB+rNwT+R8AImEktNVkfW4d?=
 =?us-ascii?Q?L3BIbAkdPuOabnBUja0Kq+4HfoRhuBsKsIomnLcIRrrjEgwwplwBEVxv3WrT?=
 =?us-ascii?Q?/2oReEK7YsVoK+vZz2ciEuf+xZSlDndaPi1bbxHdzNQj1Q8eUQ1lpeX5eh8G?=
 =?us-ascii?Q?u1yHYQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3334222-260c-40dd-4007-08db2586929d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 18:53:32.1473
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rJ2J+nthQry5HakXj8Ur7HyTW+WqtvCPOyGvva96ej4vIe0D3KmiNYSDXDFvkAQZbhFvr8mUaMTiA1fZ/P/mO9qMmD25Jfv7tzKyJo4CJk0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR13MB5305
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 15, 2023 at 03:42:41PM +0000, Eric Dumazet wrote:
> inet6_mc_check() is essentially a read-only function.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

