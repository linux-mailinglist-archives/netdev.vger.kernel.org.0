Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A8026E7D3F
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 16:43:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233613AbjDSOmt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 10:42:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233538AbjDSOmd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 10:42:33 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2129.outbound.protection.outlook.com [40.107.94.129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 518B43C39
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 07:42:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IIGUIBPQTKllYCgEzyXXHWT6RVelT6c4Jk1GlOOi3OoqkfZns4f5Mgy5Jqwu5jk2VsY9BMRHfnNmu/AW6Wh/VES1PjaWvre2ZMkza6g4lx38uA4Y88IwECdii2MiorkkWUfTaBDNDZiAY7f+2rHbi21nJi5V7BeL7pPHE0/4GRwrhQAXQVjIdnYrfUSmvsCHaERkXrmjUxlC5PXlSbmZy7liKvYoTGwuMpkrOtfDEXQclLeYvPxnaeSFP1GouGe9r60gLzVzgdIoQ5P8Jh8YBpUutHkVzwzK7PP1WeFS+UAeahQEouqra7ZSG7g/PfAr9LDQV6GZV5ZBkvzWJTYJuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TVwHUia7mLDgiVrqRLo2mNHhqOUVPHFsgMipyQP5hKA=;
 b=HIj/xtpBOh9MHq4l0yse1h++XM3f66jLZdm0kbdN2WMnL2Xflrz6peSSi8Cs8JmXyqMU3zDPXNCHljL9oISViu+SZGb/00x0ieM3FRGmwIFTtFiyAYVJyDDfwiwx2JUP8/Bog5pOcMlyQw2nHuG//0I2UrBZc0URIMHwuf+tXOt1gNpfIy9TP5ODPQuEdmVPCxc5WGSpizJI3VFq3jrkdP/8cLiGzNupTbyAHRqEEa4H3PX9nQxbMJbNpNu1AortPNUhpBT1hEJEmGV2HqcgCtFKwEW2K+DSh0GZChjhC6dHH7uG1xlgfCZpwqAufWMdyjBhcxwj8njK88lgSMV6yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TVwHUia7mLDgiVrqRLo2mNHhqOUVPHFsgMipyQP5hKA=;
 b=i2xxGHUY5BagdHn1T+t0T0kmhbNYPJHw78ati0ZnTxtfUI1xgiPmxVctL6WeSWxuqzSXDL562ACxrx+OR/sqf+WwaWXh5TRKt88TzuA36wNyZI2Z8c4ZkMzqvgNO/fQy/MQvv8N9ycodwHMZCipxWJe4yuXTG175hk1OwzBI3e4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BL0PR13MB4467.namprd13.prod.outlook.com (2603:10b6:208:1c6::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.20; Wed, 19 Apr
 2023 14:42:11 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%4]) with mapi id 15.20.6319.022; Wed, 19 Apr 2023
 14:42:11 +0000
Date:   Wed, 19 Apr 2023 16:42:04 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Zahari Doychev <zahari.doychev@linux.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, hmehrtens@maxlinear.com,
        aleksander.lobakin@intel.com,
        Zahari Doychev <zdoychev@maxlinear.com>
Subject: Re: [PATCH net-next v3 1/3] net: flow_dissector: add support for cfm
 packets
Message-ID: <ZD/9vF9aPb7bx9By@corigine.com>
References: <20230417213233.525380-1-zahari.doychev@linux.com>
 <20230417213233.525380-2-zahari.doychev@linux.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230417213233.525380-2-zahari.doychev@linux.com>
X-ClientProxiedBy: AS4P250CA0013.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:5df::15) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BL0PR13MB4467:EE_
X-MS-Office365-Filtering-Correlation-Id: a99c149e-e30f-444f-97ad-08db40e44224
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sdwhp4m4jnum45E/c3jsYPugyc6PP/YtpdE52qRD0+DlqwOaAKPrL1VI0TAFBgO+kVSTIRWdOPdeVyAWp3hT45bCtX1LkXw++1fxByXBTWAHV19z6PL6OQlfPOAUoEimdlRf/V7G5gvvYYO42r0nDCfTXnEbW0f1xABDBprPqjEUj/gz3L+lqjNONNYER59P6/vEoJ10bYhy6gWuFvHo5Icr7xoH0plpECCuXNNuGQgrmPeh4V+mkHN6LX10H3E0e6X8osZwL7UVsl/jM+A14UnEUmh48/5Wz3jBmx3GTPGZMCmb1nNFkxzWV/9SSObFkvfQTgcmfvApWQ3UgdpSgceuUs0yPf4qG/DZa0r1EkdiscwUaXN2fJjOru3PkPY/Rvpwv/lfjytl2QIsl2k4Vd+ZpVS8zTsTN5XZWGPOtoDba65GMlINobwoXYCu2Z46sKOPzTiUk0sk5E7mFe2ZWD02onHTSF+UCzCxTAa35UJH4ihKyALLCxhh5H74mHWaQfqKBm/pPe51Z8lo01Jrgaqa56KOv+POT1B0bqY+MjD50/7FT4y9+7QxZZDlzv+gh28B4sJ3+DXSypj9dvG1fsSQFeQ4f5YgFA+FB3m9hkU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(346002)(136003)(376002)(39830400003)(366004)(451199021)(2616005)(186003)(36756003)(4744005)(478600001)(2906002)(44832011)(7416002)(6486002)(6666004)(6916009)(4326008)(66946007)(66556008)(66476007)(8676002)(8936002)(38100700002)(316002)(5660300002)(41300700001)(6512007)(6506007)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?r6ffLqwCMPJB/tFQT88BmsRaiTSoFofkO5deL3ZeNFQPHIwHbRI1n3D8bezV?=
 =?us-ascii?Q?IK7/zkRBuCLO5nI3fs+NL65ZkHfRR6lp+4HsacDzQsEUDppO+/K6XPLzkuKl?=
 =?us-ascii?Q?rHlJatVp3SqcsrqYIrgwPa5SXr0DS4gkWX2lI31977p5bVURhGRaHmv6BoVX?=
 =?us-ascii?Q?m7jX3u+UTwiwmlrEoJkVSI0s2vJ1wwnLJu7Xy6DqdpTeu0lk6xMWf5b3x+Ar?=
 =?us-ascii?Q?tbtAiiFuPWeSJlCKa9jsrJateK8snp9UkMlflTaFQjWC1z7+oJnE49gEBXoD?=
 =?us-ascii?Q?Bm5qg7+V7CHbNrS7eAR7Utn8GyWlVxzqUNdSHvgEsHcwW/Y+VW24EU1y5g3w?=
 =?us-ascii?Q?GwDybdXn6jNzRePA+OejfyK+ouuF/sqM9QhrMWo33oYaCltb36gOt4Floh8h?=
 =?us-ascii?Q?SIOHC/a8CGP8SnS1MPBJSHFV07fpdwxYaevH31DsC0LU7E5E6DKxk9L4WW5b?=
 =?us-ascii?Q?mrQw6GYolwUacwbPFn+LsS8y+61i3+OBbtba0sPFEoL6kd3PoGubci914E4M?=
 =?us-ascii?Q?4aGgDYP+UMcoyzpm7SRgHqc/R3ijgTv3MM+57TeY9x2gpV+3y4ci9Pna4a5E?=
 =?us-ascii?Q?hI3/X/Wni02JVWzXLte0eY8PGq7NLtm5SvrPZQrjMXMDHKONqaFzUsv4SsX7?=
 =?us-ascii?Q?e9N8YgzthwWrBX+LOw28X5Cl8MEAP2V6dtrnsVVm5c3FY/z0psn4mqfs4bJ5?=
 =?us-ascii?Q?IazEUHQucKoF4cd6pO5eyKFRBm71cIRQJecXnVBEqTAsDj9VpZYtqv5AabHm?=
 =?us-ascii?Q?LLfFfjzCl/X6HXUv8i0XlSBktgg4IhbSl+G3Pw19dkzFVie/eDvTo6XZ3CGV?=
 =?us-ascii?Q?yst979S2a+CoUtZTzWMwV4OzY73uTFmgO1n72Xl0FZ/ki71LmuHJK3nJ6MEb?=
 =?us-ascii?Q?Kiu8HfDX2EQcmCk7ZFk+FX3BI4uGlaAISDI0b5aj+02wkNaTDvtTCPncmIsW?=
 =?us-ascii?Q?Y80LGOOCOjfVH2D4pHUmttzcmpM8k8ONDqrxylBMHj0sRM1VRi+v9adWerNZ?=
 =?us-ascii?Q?W4/1BlKGZ6pl79KbTMwxAVIwIxABMaxgUuxc6Pjd1BrdT44yl6rva1qK7utM?=
 =?us-ascii?Q?E/uay8UA87t57upOl43nIlpE2eiC3mnA/CcgTCucrbXWuL4O0GFCYAkT6lIW?=
 =?us-ascii?Q?m88v1yPQdCqd9rDIw66FKMpNColAa/g9qoz01/tr0cVL6NdPKx9Uak50sG3/?=
 =?us-ascii?Q?/V/j6ljRGVee4H2hBTanPO7pKh1Chew5mZdKyBzUmiTDYLSqvhFFS8aM+hUn?=
 =?us-ascii?Q?CTQ3aPkMgraxSYFEB63YsQ1AHzFoyPTA3kQ1wLfMyJnYkcm6Fhrb2Az+GX8a?=
 =?us-ascii?Q?dxDhaRMmd8TCDxbpGyfbUtXaOne++m0r60eI8dyWvmeDkgvi71/bo/0mBFOc?=
 =?us-ascii?Q?V5oZZVi3mLkzZB6Ok06UdWQWgQZ9JfGlWvWLiiawnwtsdxcO5t6zQ8/h5qan?=
 =?us-ascii?Q?k/6QCsd3XfDtwT0n6QP7WfMvTaL2btOPhmvG+AkrDu2nAOqOeD/yis6Mxf4k?=
 =?us-ascii?Q?W3N+NyTm1TUrlMILBuj1d2opVX9wTyFQV8ABmSRcaQKD2NaL1tcWe0RBGs2C?=
 =?us-ascii?Q?DjtPRULB2WyKw0QCs/3tZd4znlDlF8eCiI5WMRcdSr+RLfL4wyyEFc+b4lE0?=
 =?us-ascii?Q?DkCXcqM1N7S6QprjC0MQXvxF2YCVzhbzNsN7m5JfInmcY2hQ844o0zmj+BHc?=
 =?us-ascii?Q?gdu4yg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a99c149e-e30f-444f-97ad-08db40e44224
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2023 14:42:11.0886
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zdeth67rAmSKURcmckE+qcGTXGNCVKZJszKg4DS98cL0TyGPZvhkT0Zn9DdsekFrPlw8NR0NVTOWQFgBzltVTzCc++OGvZVbtRqIUuT1OXQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR13MB4467
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 17, 2023 at 11:32:31PM +0200, Zahari Doychev wrote:
> From: Zahari Doychev <zdoychev@maxlinear.com>
> 
> Add support for dissecting cfm packets. The cfm packet header
> fields maintenance domain level and opcode can be dissected.
> 
> Signed-off-by: Zahari Doychev <zdoychev@maxlinear.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>
