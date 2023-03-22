Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1B466C48AF
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 12:11:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230145AbjCVLLq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 07:11:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230013AbjCVLLo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 07:11:44 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2104.outbound.protection.outlook.com [40.107.220.104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 764B5497FF;
        Wed, 22 Mar 2023 04:11:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ReumzJq7dOm6+5/OoSRk+kDWG17yTT9JK/LLgPxH2yTgFOOhRxhinZ0v4A9JKCBDTop/m/DeeVIgg8NnqHpR9HF8rMZ48MulWlYFG/LZY/gd/nXGIvWDryvRJgisRP4Zi7Q87LfkXb8Z3eboVxMC1WLr4LFa9/6+tAJq4LJ6PRCVOJy9j/2kPx9ZZgcXJePzf7R50x0x5IWNwSJZeUGr+b/Zl5jJQJXHSyL2wu4Im5iQMPlKOOZGDwVocjUjZfy3HaOBcCNTopO4CdOeDtVU4QlffcDrJ375GPBTn4TO+D+l5IotPbURzrBDnepz15PAY0h2QdxRGRGBeahmmF0MHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dIDZW91tZ7C++Ri7Fh/J6PoQebRzr6JpQo1/tItK3Kc=;
 b=XXkWbrY4sP37t4vQCLJ8GJXYK3IqQJEhLgNBsbBKdIC0X9TJ/vO9sDF1lkzp+iOMymQjUCS3MbXVCb9YnQqjFhtXhz1yB8GOxezq/wQpu55oTvR8u8LoefvZZdeuTc0mUcOnIZ5iEpTY7GNfRCompdc1s3MYH9SiuPNJB+4YOmylb9l7W4pVo66nGeH7+tJcbKWXHKm6x3b5rNGPhJSwq0YnKPvFYD7LPFAwfU0AEbjwfxd5E9ePVnIvhyUDYMNUZwoWZ6eS3/vs7YHTBQHomyuMZQCSa6jzWY8RBkJqbiEh/ay5smKN1SYKOfGBo4LooY8iWDYUxYoJXHP1wbdRcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dIDZW91tZ7C++Ri7Fh/J6PoQebRzr6JpQo1/tItK3Kc=;
 b=U18HgZ5b377mi4r0cJQxoDSsTLu/iybhpdTFoa9W04Ihet3z9mwRpkncCG5Oj/RdxorSFwnbcX/SPeOEYp8X3Dl55dWKXjyLsmv5gZSwTNauyo/9d4jU9GzPXnpGcUltJUz+s4CDoQ1ziAxRiv7529VYGK70AKbyAvvEEqRXdQQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SN4PR13MB5295.namprd13.prod.outlook.com (2603:10b6:806:206::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Wed, 22 Mar
 2023 11:11:41 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.037; Wed, 22 Mar 2023
 11:11:41 +0000
Date:   Wed, 22 Mar 2023 12:11:34 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     =?utf-8?B?w4FsdmFybyBGZXJuw6FuZGV6?= Rojas <noltari@gmail.com>
Cc:     f.fainelli@gmail.com, jonas.gorski@gmail.com, andrew@lunn.ch,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/4] net: dsa: b53: mmap: add more 63xx SoCs
Message-ID: <ZBriZvDmrnInq7f6@corigine.com>
References: <20230320155024.164523-1-noltari@gmail.com>
 <20230321173359.251778-1-noltari@gmail.com>
 <20230321173359.251778-3-noltari@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230321173359.251778-3-noltari@gmail.com>
X-ClientProxiedBy: AS4PR09CA0015.eurprd09.prod.outlook.com
 (2603:10a6:20b:5e0::20) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SN4PR13MB5295:EE_
X-MS-Office365-Filtering-Correlation-Id: 90cc9423-a8e9-422a-30e5-08db2ac63662
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AIpq5KMehfdjAMcAcROk9khJTvfBtSbibnH89/VrSNiEFezVghfmGmo7V26h4KbF51xxqmFbz90Xk8FRFroMZnrVMs9PJRg/89GrtZKh7bTExz1jEiITmhwvsUqGgQUYX5eGg60Lcj1z5g6083rGZtLBQ8FBPIrGaiNmKwhCxIEHTLRPqawvjEzbLLBV34Z/zqQpJlkOfbHVI82DWgCVin03Puul7nTAnWczzSBk0eT37j3C2+UzdkX9GtS7DNr/d6Xb3x0DjlcQoOVFIzmzUEjkaWMrV9UtXEPQ6ShIv6EWtEGsCuVM4zJjfXY3AFLn9lwYoumUGOCn7tcZ3tY7LHcG3exiSFge6D8CefV1tCTivymtGmMoX+BmpCju4CMJL+TQFzQ/kTS7cbfWMAVrsebfH8+4k6RjTZLVGZVWvtKWGW/BRdM9Ya6HkodFoqsqnJcxTCgScB1CgM2qYzIBEXnly4l5T4XL8mTyUJfEvh7TiUocZQC5+lRBG3YQ4nhOfzIMhENIvFskiQTFN5wrLw0s8ulO9Tc2OhF8QvaHu3to1fXiazbEhGj9DpfMAaLFYtbCk9eTMPx/+KeC9VctZYD0YFkRXAAamfPwGeZu+1yWizj8xSzGYdmw5keYvMcT+9pgjquNvzqrhCjsbOPFsA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(6029001)(4636009)(136003)(346002)(376002)(396003)(39840400004)(366004)(451199018)(6512007)(6506007)(6486002)(6666004)(8676002)(316002)(186003)(66476007)(2616005)(66946007)(4326008)(6916009)(478600001)(4744005)(41300700001)(5660300002)(7416002)(8936002)(2906002)(44832011)(66556008)(38100700002)(86362001)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZFUvc1Jjd1RJd3RiYlpkUFpIbGpMT1B4Z2l3RVdrZFFFR1UzZlVKTFNyZHhu?=
 =?utf-8?B?ZUVrWmk4RmN2bURRUHJBL2lKUHN3eFgrTzJWVVpnckU2Mjhyd3NKNTlaeHlR?=
 =?utf-8?B?UTFiQWpjaGJ3UkIzL2d2Q1JBSXFIT3R0Tm9vREZtWUFlMDg3SUthZFdlcVEv?=
 =?utf-8?B?WFRzMlJMUkpzZ29NaXh1ajRaNjdzcm04Z3FsZHh4UGJJU0pXM2xlQXdRRU9z?=
 =?utf-8?B?UUI1bktSeVBmVVRWM21HQ2JkcUgyVUxETmZXUjExeXVwejUwYTlRWWxINWR4?=
 =?utf-8?B?bWhndlRsMFBabGNSSDUxRExPc05YOXRrUEVydFRFUC9yRHJlZDJQakJQcHA4?=
 =?utf-8?B?MjBhVENEY1ZSMEZGN2ZhazRNU3lncFRhc0pwOXVQSU5uSUkrbHBsVzdSY1VF?=
 =?utf-8?B?MXdIN1ZBY1p6eW15OWkzTW4yOHdSL0VQSzUvb1hxcWpXVktEYW8xaXhFTmhE?=
 =?utf-8?B?d0Y0UUNpVmp4ZzE4MEFQV21rSk1kZWxtUnF3bG4rSmRSVUZTbi9VR0E0YUdS?=
 =?utf-8?B?UzV6SmhhUkVBU2U0d1Zrdms5VXN6OXdzSVpOWHVybjhLOE9QbmdyUVRxMHFO?=
 =?utf-8?B?S1JIT2hjaEhlRzZUZmZXcGtaV2c0MTZySFlXc1NEakxoWjNUbFFBV1NhL3c2?=
 =?utf-8?B?akZFbGhka1d6RnpXak9MZU9tanRUVFRiMkZFY3VYckNQb0NlUi85Tmg1ZXVa?=
 =?utf-8?B?RktRQTlGVWJGZ0NJaHBRU1NXWlRQU0JXN0IyQkI5N0ExN2J5TVFJa292N1lH?=
 =?utf-8?B?UmtIeEFaZDVFWml2SmttaHNPNUplK29CejhsQ2pkcE1tS1dkS3hvR1gzSDVh?=
 =?utf-8?B?Mmw4WVRYZnVSS2Zxd0RXeTR5dGJYNHgvbnFVNE1meHk2K2NVM0ZsZEpwUUlx?=
 =?utf-8?B?QmV5OHFPKzZsUTlXSFdQUzBIdWJ3WmFZUGh3cWhBZHhyODlwdUV3QWN1L0x6?=
 =?utf-8?B?RVowYnB2c0M5SFNyeW8vRFFDQlBPNTdnTmZSSUllUVRHVFV0amtuZ2JEOFFZ?=
 =?utf-8?B?aFdjR21qbTcrSGlmakhsSGVmWEFoWWxpOVI0OU16M1cvbys4NXF2Sno1Y29x?=
 =?utf-8?B?Z1lKK3VSUWhZeVQ5eERpQzRMUk4vU1FwYlEwSDZXRFFjMzNBS0pEVG9aZC9D?=
 =?utf-8?B?dnZpMmZFalI2VVFnZ1cxbmRvb0ZZRXNXSTU2ZWdjRVNXV2o4NURQTWdzM2ZN?=
 =?utf-8?B?NlYwUysvZlNkL1JrdWVnVmhEdU93ZEJJdXZpcWhVRFUyZU1OUzkwaTlFWTdV?=
 =?utf-8?B?akwyN1RsazJvSEh5Ukk5cEtENVRRM0QwbS80b2FzVXpMZGRCMzAxcFMxR0Rl?=
 =?utf-8?B?c2hjNDl5MXJGZWlCNTBPUmh0aW9IVjBTeTRnUlJwakRPemJBQ0FZcW9PY2dm?=
 =?utf-8?B?T1FpWWZ4KzJzeFdCc2hha1hNTFh0QlJPeDEzZjR0Qk1adm5IQTFHeTI5Rmh4?=
 =?utf-8?B?d21QK01LOXdWaktBVXpPY3VyQVZaMTVVSXRZWWpZa3dxcXoyaDNoQUdFUzc5?=
 =?utf-8?B?NSs4UmhJMFFmUVExNnV0bFFPcllyT283WE0zcHJuVWdVREZRNFptZG8venc2?=
 =?utf-8?B?bm9tSnIvVk9QWG9FcGQ5Ry81UDg3MFFDSDFzcWdYc3Q1N3FZNHlQYlEva3Rt?=
 =?utf-8?B?M2NIZEo2NERvNHhGYkgzM3NsOGhXcEdIaWFYb2NHOHFEVm85SkJrZGdLbVp5?=
 =?utf-8?B?RnBKbCtMVU9WQkJzVjV1eDQ3WDNkNHEraGhMWDVVVTB6RmQvUVlRNy8yZUp1?=
 =?utf-8?B?YVVBU0ZxSEdDelF6UW4zSzhuYjdzWEd6ZmV2bnd6WkVBeFVnSHhsZTRmSnN3?=
 =?utf-8?B?UVVuVUJobFdGY0pMdCszRktSNVdxY3p1TkpkQ1p2cXZOakFFUDVwaUVUdXRM?=
 =?utf-8?B?bFU3K1k2SmMxWWo1NkpnOXFwbGJwNVpWK3Y2dHM1U3RYTmdUbjZGK3NzMFBZ?=
 =?utf-8?B?SGxrMndUWCtDMnQvM2dONjRJNkdtaDBIVnBkaDRmaE5YSFNPTmQrOWg1S3VI?=
 =?utf-8?B?NkdtdTc3R0U2dG53OVhIY280cXpCckV6Y1Rmc2haU1Erc3lGdXNXSHB2SS9T?=
 =?utf-8?B?MmgzM011QjRpWFFpcURXTkk4Ry9tS3p0TFBQeXl5ZGtEVTdlQndTL1ZMOVBB?=
 =?utf-8?B?anByT2daZ2pmSjU1QTVadG44QmtIQ2RZMEVVTFpWdXZNVStxcTVxc2RBMDMx?=
 =?utf-8?B?Uy9HdFJzb3BBenZGZms0bm9pVGx2VXQzN1dNQ1NVUnFXR2doN25zeUhQYnVT?=
 =?utf-8?B?YjI3dG5qeVR0enhIZHJhSTB3Z1h3PT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90cc9423-a8e9-422a-30e5-08db2ac63662
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2023 11:11:40.9696
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4jMdZcHyJlRSRx01ZUKDwSp9tIficFk66+qyqvxUnIUuuPzMTdHfT8BJcWtoXWL5tOEgKf7Lw33fR1GWc2F7DUtdO5E02tvDFEyx643h5zM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR13MB5295
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 21, 2023 at 06:33:57PM +0100, Álvaro Fernández Rojas wrote:
> BCM6318, BCM6362 and BCM63268 are SoCs with a B53 MMAP switch.
> 
> Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

