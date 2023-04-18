Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 168DD6E66EA
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 16:17:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232176AbjDRORX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 10:17:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231545AbjDRORW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 10:17:22 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2109.outbound.protection.outlook.com [40.107.102.109])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D609AD3;
        Tue, 18 Apr 2023 07:17:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OHaThSro5gV6KnKeyG0caF3Df4Glnlx8YCrlrTWuPZqkoK9l1b6jZ0vZYe+ee7IxVHT/TTpYBqr0c2WhwrqROmj/18kga5jgvqVce128d2K6BB9ynJ5yxAROh5+7cg89ZTR/SwoRVR4F7g85XLp85hB/02C7kMsqI8pZRUHQ8lqemTnDXnA14QFVSVdesGdjUNRmOtslgVMAuZuLZtLk1vgXbOJOlONDgc7OX3Le6dw4OQ23I+JiFpu7g2xFVM1kVaOaHn3Cqz+U9HDwCTYNlXviehcmDZXliGoOlN242k8Ee8OFDZNNThFyqSXk2Y5yEGAYHkh1upqkezAw0AXQ5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jhF8k5oV0/utwMtZSGAzycwMywgHgHKH8/OmfAM+0BA=;
 b=mhSacyghBz9blS+Z63gsMLa6EAXMYdJ3wLYIqogXBWxLheKUbMdqJW+BEkssNy0OJjHnUTEniIrs3z+38gtfJW/0+8HwXjgiB808XtgamkMQyEOvbjcdSmbVPzZwgsvruTpcUtASKIJlgRN3uzzPmx70PZKYzwASy8xQCr4m8JDZfnhnPwBeF/lXwqcCq1J2aZh15JYtHYw9HR/mRZ5I8rgyUcdFCQMAkk/xalhY4vDxCgcajRmpFFKHdXaTwrzQxL+1xJeCf7Dpkv9tYi9whRY8RspoKw0zDEKuCUCU/LtSZChD24Rp5rosj0j5aAL2FqbKT1IWrMqq9Wh3eB8VoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jhF8k5oV0/utwMtZSGAzycwMywgHgHKH8/OmfAM+0BA=;
 b=Pc5qTF2C926GYlP8nvIxFVHaPVrWNZOKjJB8lm2amcFX+Ks4vOkT5hLPRvFNQwmzaCscd+aRDoW4z1tCFx0mAPmAXI2KpHSDhJm4jqv6w/6GICr9mTRPVe6Xm37jnVzNInTTrZEYrEfPQdpOUEh1IdjF/ExHhlydVtzEG2ZO1dk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW3PR13MB4043.namprd13.prod.outlook.com (2603:10b6:303:2d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Tue, 18 Apr
 2023 14:17:17 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169%5]) with mapi id 15.20.6298.045; Tue, 18 Apr 2023
 14:17:17 +0000
Date:   Tue, 18 Apr 2023 16:17:10 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        lkft-triage@lists.linaro.org, llvm@lists.linux.dev,
        linux-phy@lists.infradead.org,
        "moderated list:ARM/Mediatek SoC..." 
        <linux-mediatek@lists.infradead.org>,
        Guillaume Ranquet <granquet@baylibre.com>,
        Vinod Koul <vkoul@kernel.org>, Kishon <kishon@ti.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Netdev <netdev@vger.kernel.org>, chunfeng.yun@mediatek.com
Subject: Re: next: allmodconfig: phy-mtk-hdmi-mt8195.c:298:6: error: variable
 'ret' is uninitialized when used here [-Werror,-Wuninitialized]
Message-ID: <ZD6mZv2n2yUZKA1G@corigine.com>
References: <CA+G9fYu4o0-ZKSthi7kdCjz_kFazZS-rn17Z2NPz3=1Oayr9cw@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYu4o0-ZKSthi7kdCjz_kFazZS-rn17Z2NPz3=1Oayr9cw@mail.gmail.com>
X-ClientProxiedBy: AM0PR05CA0090.eurprd05.prod.outlook.com
 (2603:10a6:208:136::30) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW3PR13MB4043:EE_
X-MS-Office365-Filtering-Correlation-Id: 184862bd-940d-4cd2-7bec-08db40179d1e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2+qUp06GAFeH6HLOaUyUpW0NDaaz9b3SVzoe78ao64JOTlYaT+IVNGEOVwqcc7w+SCsiQLHry9LPeYrurVlREGH4gLobVgQynAL7YqWj1KKa58jYqetWzgtbkMBrzGgoWXFLw4Mn3+AbQFYe0DxSkveioM3LYmTcIN+wORIkKwcstLlm3lZNeEPUoGiWRont306+SBcftdFUUK9tm7ErTC62YgB3hlUXOFwX0iXtM8BobeN8Yk8F7ySuPivV0hhgpccYLyikYx1+YAn0Na4Aa0pjZ8CFpdhciOWw/xVYK2f2+0uTaYcUEWyIIOOC+xv0PvvCZYMgjBs6+Zox8MvMDCXhpXjfSV/jtHsS0yFQtGrkM+ZjNiTQ9lJTERSHK22qr0zyUyOVF9lmUCYrLR0uVE90ZP5EBkL9X01g1h40WCaowCu8Uk2CNpnJd4u7R13KrAls17F/YOyj5AyZfoQ7r6dLcINj4zlvwj13BnrEacBuQ76pSaCu2mXz1/ue9MmMrwaoeHUaL98xylLOOqcJCZVlnaGEiI9nKAzzpANZFxk7qLwkyU9uKDGB8+bPkhh3Gib1QA8sKf28H8nhnSfVqBVrm9MK9ciaZ0jsxMx7TCI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(39840400004)(366004)(376002)(396003)(451199021)(36756003)(38100700002)(8936002)(8676002)(44832011)(5660300002)(7416002)(2906002)(4744005)(86362001)(478600001)(6486002)(6666004)(54906003)(186003)(2616005)(966005)(6512007)(66946007)(6506007)(66476007)(41300700001)(316002)(83380400001)(6916009)(4326008)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ifEvLNH6OdSzX1YmiP5hiQTo7ZerqkjKrsvWMMyXarE+lJAeno0EvZaD489f?=
 =?us-ascii?Q?UH2ky7WiM0lJortTc8cEeZCYdF4PTSpKkVBQybZ2X4/8FC7CaYnwiiow5a0f?=
 =?us-ascii?Q?eJn2khdIzpbeDX9rmsVHfFLyYo+MycB4I2CNMRkHPOi8N4gSyPEuB7unYNJv?=
 =?us-ascii?Q?6Q4H9gj63NOThQ1xdwZeAQh9E7FhK3IXMc5AwH4yyeaGLpwq5cLAYXsgP9JZ?=
 =?us-ascii?Q?wDVAFghNZ3B/N5TbYCQHatu0U4rltKbnrKWGMt0erIO2rO/u5SYXv/r95utH?=
 =?us-ascii?Q?UcMFMdJ1dwdcD8b9zOuowySVwBytje9jF9pWhddmah/GDKUFuV313LSU5hiC?=
 =?us-ascii?Q?/sXsTae0WmX+2RQwaPtETRndq/5p6sl7EWSDuSmYnZ+wrJf5MhC2KLiN5Kwy?=
 =?us-ascii?Q?4spYsTtcvN2exqOLs5tG2cP8WF9iaVNUJsKgvwtpqzMNLPG3z0ZkVQaR9TjZ?=
 =?us-ascii?Q?nB8o4pqdSI0nF/JEmdc4SfgxcV4sLzQzF2yB9qiEuTPDyPcOrjGFOogWFYZV?=
 =?us-ascii?Q?2KnHyPyAQhXhly/CG5lG0GlforhLfyttxCQiP6vqGyqisC8U2Tgj8QKgPZi+?=
 =?us-ascii?Q?/I5Ll+Wgq6q+5b8yQ2R1uo8Zz1rfrHxMo9pzbgVgdwDxbdgJoZzpwXlIPu2P?=
 =?us-ascii?Q?sZkDiNC5yCqKV5ieNY0QpV4lmU2MY4oJDjpu4AG1lzQV4wbqI7770lJ2Si2G?=
 =?us-ascii?Q?U44U60o8G/+/97pRabhsCf+jGuVhx4+E7yCy10oIiLsyUDgPJhKi3p3CUxMz?=
 =?us-ascii?Q?djHnyWDyaYHLwdF7qMF8ez+euCGkfuaP2JcA607SVdlGI55ksbzfH3P0B4Q2?=
 =?us-ascii?Q?f88IloAm6p0LlH/Efae9O2KoWBNiJBz5aNn1aP6Q8aGhBDGCFouqXde7kgjy?=
 =?us-ascii?Q?p6eRLClsW+XM/HHDUhayvt6SvE/dndVqnZY7ZGTGtoNggo8NQ2odobCl7eq1?=
 =?us-ascii?Q?wovEskpaM8eTsbmp/HjCnOHqJ6LGNOKmLvl4aa9aKdRWgh+ImO27U/t5eSRF?=
 =?us-ascii?Q?DRqPHrgBourlf3xswWmT9DiVLoFasd6+mSvUSEWn5VP8H8ohx3tTZ4Y9yXa9?=
 =?us-ascii?Q?xYJIECOp5dnBzLIYFUA8nhc4c19DEVdJ/vXcQjBOVB/Yhjy/+ACUmaPK/u34?=
 =?us-ascii?Q?LZVJoZtUT4kAncayfFzBOubuWwWDHBq45MBAcFoqWb7mZympjHXUpEXXIKWJ?=
 =?us-ascii?Q?/DD88kFm/36lDjrLA8tjiQeWjaSMMOWSdt+FAfl2P/ZDx/Aeay6h4k8dPerM?=
 =?us-ascii?Q?bFKYPRXoNIUWlpQWUuos6jdNeoTgRL2S5clX6M2ADFlS0fjqPXlW08D2ytqT?=
 =?us-ascii?Q?wpg1y6N8Ra/gp/9JNk4zROOoLqCxNEr1IOcFS4b0VRGRbom0veISSwyefx/b?=
 =?us-ascii?Q?uxhX7Agjpcw199OmUV1LGCpRYl2rvBRsRUIarzq1ecfFXWl36ZuB/qVsmBGO?=
 =?us-ascii?Q?1Fi3zsbhyuurU25hR7k2vLLPYq8RXWDZgcoPC0Hg8H3PazSRFE7Ay/l5SAnI?=
 =?us-ascii?Q?FFwwgsyUivCENQVIM/7/QLx7sGQRUPAlPel84vYGajzbEZIFMAq2QNacMj8o?=
 =?us-ascii?Q?eSJ3oVNYRugyUibQ3Y0wParouE1fPK91Mv03Xkuran8CmvMKbXgB5AaV5kWD?=
 =?us-ascii?Q?A+NMcrfK6qheK7QmzRnsYPYBrhSfUxN4D6Kd3tL6P0fJT8hyqnbeE9b0iNOS?=
 =?us-ascii?Q?F+Chgg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 184862bd-940d-4cd2-7bec-08db40179d1e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2023 14:17:16.9798
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QmYulTcqj7EgAma7/vdam3mxXucoHafi7nqJJDp3TbBqTvf5WKzfR0kcIq9psQX0a5e2d2DK8N9R4B5K8v/l8dJ6UY62w4ECPfeyF2OXBXs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR13MB4043
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 14, 2023 at 03:14:27PM +0530, Naresh Kamboju wrote:
> Following build warnings / errors noticed while building allmodconfig for arm64
> with clang-16 on Linux next-20230414.
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> drivers/phy/mediatek/phy-mtk-hdmi-mt8195.c:298:6: error: variable
> 'ret' is uninitialized when used here [-Werror,-Wuninitialized]
>         if (ret)
>             ^~~
> drivers/phy/mediatek/phy-mtk-hdmi-mt8195.c:216:12: note: initialize
> the variable 'ret' to silence this warning
>         int i, ret;
>                   ^
>                    = 0
> 1 error generated.

I believe a fix for this has been submitted but not yet applied.

- [PATCH v2 1/2] phy: mediatek: hdmi: mt8195: fix uninitialized variable usage in pll_calc

Link: https://lore.kernel.org/all/20230413-fixes-for-mt8195-hdmi-phy-v2-1-bbad62e64321@baylibre.com/
