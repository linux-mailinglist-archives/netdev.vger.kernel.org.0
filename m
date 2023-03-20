Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECEF26C1C04
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 17:39:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232343AbjCTQjY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 12:39:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231912AbjCTQiy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 12:38:54 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2090.outbound.protection.outlook.com [40.107.96.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6987728E4C;
        Mon, 20 Mar 2023 09:33:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G4fhe2qUEOI7Ghl5xTczecUsTJPqYDJyURXzXrbUsxe+PhXTaaW5QJ7PAi8B3muPBu0uUV6q+XLPoCocUVPg6qDLbRxR4SZWHhDyAbfkwQcWUYLdv19NJJ4iPu4vPnavTMYjOAasHWsHm5wozYhNSDujMreygsjKstes75SJ0WsEBo25vuSQhbAyah1tSMCZEX/np/Ce+yYJmgu4RP9pDLDejivls8ZWngcrxZpjAG9agbn2PfG0uP7XkldHikSJHCpNE97vsAdOhDSG1s4ls+cQcRHB6qFY7tiooSuFUpkMpfjht1KSKRC2+ZDOJxLvUPnaL5Z3CiS6Kbqz5etJpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h38VN2H5HvdtLC2LqG0tFSX4zHHRIk9syjo9uZNHVTc=;
 b=et4hd74sqkBbt4rdidtOTSojTWkk8RbPtDw/7j/ulQOvuXtN1FiodYlp2szY5pSwTc3p3GWefR18jBXqL73NXJgxDGcsLptyS3SazK/lDaLMRCzj2aacjTYUSBQrV9X5esieHMi9NDzkYqxwXY550FbE4d1gI/2BM7PEV/USe5hMmaPjGU0zY/4gGgKnoGaAgtmcV5MPatewBHe5CnDH7A1nJ3Ub7Z5fHA4tJmutHF+kOTc85x+emI5AesbvNgqin4DfQFpg1sV1h5bVz6IgYOuma9GvxW/6ZNpc8A9xAi9d0AwobUeWjIsGoDuuTkhxThLKEjVuLKTwSAKhsF0euA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h38VN2H5HvdtLC2LqG0tFSX4zHHRIk9syjo9uZNHVTc=;
 b=FxUUb7gHsNEeEkrDXR7Se9aJuMTUoKBsJKxRrlKGBw0l4ZJ48X12kxdrBougvHzbufDmA1xcKOSvdjQEp8KUE47s/rUly0CmByijNuJJbl5Hs6V9C1ZnaMGJd2be2Gpv08v2afmAat8XEnEoO4VJBhyqoaLaY6DwCR8+nmBO0Ic=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY5PR13MB4549.namprd13.prod.outlook.com (2603:10b6:a03:1c6::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Mon, 20 Mar
 2023 16:33:29 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.037; Mon, 20 Mar 2023
 16:33:29 +0000
Date:   Mon, 20 Mar 2023 17:33:24 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Wolfram Sang <wsa+renesas@sang-engineering.com>
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2 2/2] smsc911x: avoid PHY being resumed when
 interface is not up
Message-ID: <ZBiK1Ii5eKmuIp+x@corigine.com>
References: <20230320092041.1656-1-wsa+renesas@sang-engineering.com>
 <20230320092041.1656-3-wsa+renesas@sang-engineering.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230320092041.1656-3-wsa+renesas@sang-engineering.com>
X-ClientProxiedBy: AM0PR01CA0102.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::43) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY5PR13MB4549:EE_
X-MS-Office365-Filtering-Correlation-Id: ebfa1be3-ed3e-42af-b0b6-08db2960d678
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DIhqBbqARQ+lEOiiW/SzNdw54W9+VV7Po8kTfTo/P1XElGT5wAoRb2RxOV2CT7MU0KEFWkSLlhwLyXAsLkccKPP2n5oeY/Ig7p1BYSStE9Z9B6ByRT3KEJ22bk20Xs1SWFwLlSNJKmTp3GFXfyGbDng790WHDCADgvgNmoan4I4VdOF8m+uJ1xNQ27hCYODeWTl1mBFQNZBtrXEbGXAX6sqFlf1CR/HCllHqQk2/A0k4w5Z4GxOoJPgCJoGsQNCoRhOOiSH3+va2P0FUUAz/lCPVXv0s1f6o32lpEL2m24g0DeT4gwNET4TH7AFxaWzaQvD2ct0lZLfWFvp0XlMxtEiq8HaaPKSlXN+4Q4EWIU9V9QgJsLBn5AaO/SK/7bku0j8rfexuE5EmDc0/AwOXSwUpBGHB3qGpwkdev4m2+9HWLp4mTnKm4IkcX3sXp4vLJv8kquWVNIrqVVrc3YrgkYdOQZIyRhMv8/Gl39hckPEkvKdRSLvxUQ2OFdatMfOKYoz2wEA3NwYhmJvM3r/8N65gq2tssEIcogwApnUn/3R/qHRp82nmuzcpm+hc11hGiG/Gfl0Od2l0Gnosc7gpA2y8eUzxr4EK9COaiVZJqEmlsKj93RdQedWSYaP5ijsYEI3WoHOPfRvT6LZiNeUDW8eTtJB1pczbHpzEOUQ+8fXdFxAdfv8+IMq8MGNt0Kic
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(366004)(39830400003)(396003)(346002)(136003)(451199018)(41300700001)(4326008)(8676002)(66556008)(66476007)(66946007)(2906002)(36756003)(38100700002)(7416002)(5660300002)(4744005)(44832011)(8936002)(6666004)(6512007)(6506007)(6486002)(2616005)(186003)(86362001)(83380400001)(316002)(54906003)(478600001)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MbZq8FXUZg2u18dVklClku0AkrDd9HtPYL3lfTg9eKba2n/nmOtu7f7Ts7i+?=
 =?us-ascii?Q?+qknf/rHZMoayBKs+S0XfdYUi/nLmPHW2z3Y+/EAYKRTxXn6nHQ8WzIerm8h?=
 =?us-ascii?Q?qwBlycXAGDSwNR2mc7miKVzwRSOAWbloPPQlGqZoux3gY53RGs93FQ8KXCNx?=
 =?us-ascii?Q?IKgvhtJKPF777JXWNxPYbsSo8C+dTirAL0alD3tCEeiK/Y+7zBfCDxBcmUc+?=
 =?us-ascii?Q?uwEm0N64POJygMk+78ByvLeZMml7Dq1z3DDfaAfcamPM5vJ2DckOQKmVQhqY?=
 =?us-ascii?Q?QGWWb7ESgCaj8YKuPf/lsHLzXG0GmLh7ZVb0Pp9R0Dot7RAKqB5nQQ033k0L?=
 =?us-ascii?Q?yHmOiWs+mTEeIDugzoyhknRb0te4S6d4Se4HOHioCGL/bPmH0fwZ18mW9WpQ?=
 =?us-ascii?Q?BrdJcqL5P5trZ4AgNirb3HOqDZ/rc6NwZvlnFHprNTaDefjgR6AhyxUPRM4m?=
 =?us-ascii?Q?YICCYWGwrzynT6Hw1tQDTDegBEECiOrBQJWalIGppak0jGN105GUO23yc0qu?=
 =?us-ascii?Q?yCLW2h14kZrvQw86Ju58ho9+t8AM/XdZxxZjgISVBRo+RUOzsW96JdBLrMYI?=
 =?us-ascii?Q?/vmhtj3L6RRzZjbQPimR0jwB/X1xNcmGKUJeU+ly4ZWhg2Jrxe+rPtEgo4pp?=
 =?us-ascii?Q?1s3+FHcE7GgnPwsRv9Nh5hsy8RcOupu3gDFyHY1DflpN7yU+FLZaOhNXIdcE?=
 =?us-ascii?Q?zhoemE5q1PYKUj93MR1EBHFHHT7vp8Ztv5gXPcPk10nS+AvYJP3fCZMy04TN?=
 =?us-ascii?Q?cEZy9S8U7Pv9xCHuNGHfqjxgAAAHvOayVItjimuRsngsb2ubxOuN0w6mv5qk?=
 =?us-ascii?Q?Hj4sdoZU8yUsvB3UTgA+tNgujF7fGZKNAN5hnB80H6Djt8LTShIXy4aFOT4X?=
 =?us-ascii?Q?qEvK5HEd7BhMDbTPAHcvGmQeFE0P/qo+mR1TNvkyU8Oxa0iriq7N3+PYXESw?=
 =?us-ascii?Q?D6HIwC/MnU/NZr0iedcN8LS8Ii1wsOwnRP0tkid2nL/JeIp/3EQo7KZjXUFo?=
 =?us-ascii?Q?YLhfkecdWtPv6zOIn7Y5OUYACv7hFiZB4ucX6cuABhZbu55QWHQ+SDHi4Fln?=
 =?us-ascii?Q?qFXj+iHFHKkAne3MpllUaR3sqRoKIbYp7IGsQB8Bo0qRzNlpL8esZitTVCsU?=
 =?us-ascii?Q?SIZLr/sgJVulB+ONyzW0Epqb45xVRjBaDa5hUBLMPxgX5zYUSood1LAcMZq9?=
 =?us-ascii?Q?IsoNb2x3fI1WD/biWL/ZpowAIrp79E7a1opsWhPh+uy/02/Ws8GBQ+1EeXUp?=
 =?us-ascii?Q?cLVmm3uVQp/xMWWTAH8picEnj59iHqgCddZn43tWruy0SExoWi5A51ZBRD6r?=
 =?us-ascii?Q?awjF88BFLnIiCiJqIgiHmDzlmRSC9Pyq+5ijQWsrv9WfYL/iF8PJq9Tb2QA6?=
 =?us-ascii?Q?bHP5HVLtFnuu2Y88XcBykoYNZepWyI7OwReSVHbjMdZ0FXZFvVFgy392pscD?=
 =?us-ascii?Q?tWU2TvqzJYQMzIV+YDmqn3uzql3/npC0NvN/8wBi4DLZJED0nV4i++QzkLu1?=
 =?us-ascii?Q?q+sXwgq7hP6ibQTuKcuDepBERTCpfMPMmYf19XElpA6zN8R0TB6ou/6Aukds?=
 =?us-ascii?Q?5WwWGR6REHjqsZQJbQiJwn0sHuwRF7wTuAwJjqkElYhkjn2YIfHCXPxFIHK+?=
 =?us-ascii?Q?xAaP/it30+nUrhjyfuKkK2iDutuDANwMjsgl/S0ruRBBoeHDV8SmZI7fZ+Gl?=
 =?us-ascii?Q?1L57NQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ebfa1be3-ed3e-42af-b0b6-08db2960d678
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2023 16:33:29.6932
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L4XkpwwBt0Ub4slH1slEDORcYvXOhZRp5JNtrYUqJoZjBjibyE2gf/0gdjHl3gInual25Txa3ngm7ANkcy9DFmP5nFH8Hi+DDeaygvOHwtE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR13MB4549
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 20, 2023 at 10:20:41AM +0100, Wolfram Sang wrote:
> SMSC911x doesn't need mdiobus suspend/resume, that's why it sets
> 'mac_managed_pm'. However, setting it needs to be moved from init to
> probe, so mdiobus PM functions will really never be called (e.g. when
> the interface is not up yet during suspend/resume). The errno is changed
> because ENODEV has a special meaning when returned in probe().
> 
> Fixes: 3ce9f2bef755 ("net: smsc911x: Stop and start PHY during suspend and resume")
> Suggested-by: Heiner Kallweit <hkallweit1@gmail.com>
> Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

