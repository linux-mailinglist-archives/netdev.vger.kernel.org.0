Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D128D6BB6C5
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 15:57:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233295AbjCOO5x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 10:57:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232339AbjCOO5f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 10:57:35 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2071e.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5b::71e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09E464C17;
        Wed, 15 Mar 2023 07:57:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WwFy//QfivXLNRenISiwahwZPn3u1pXPSyghD/uy/c6/KFp5gkfDcifQQKh69Mg4u/f6VXIW6YKbeFMQiSpcWhiDc20vcZc24vOjaR89Xgn9+AHVO0tsniLoQ8WfKUIbJY2s6nLwRSjn4TlOuRhsnJ6jsWJBvRtz3DAnkw34ySqtDiXkEuGJarjEORta0Q20WtV8KPHDHzO2bF8Cq9Rsl7p0GNNUJcUskI5HtxjwFhlvXZgZlpodyVwk9lc3iMwcmjwl+YkSiYuQGCYzixbjHcjF440T8j54LLmsrLdbngSoPTNXZ+nGHrGWufh67WrRyMHRL8JwI5hHSjzhKZyxig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KJy6t9fDVbIQTUqHywLZb+xqlfua5oz4KgaCNOPSDNc=;
 b=dqsIwqN6Hl3iYw+DP/QDVxfegxCC7Prhy/gkF91dGqWPhnYZ6+S9l9XmcKelEn8YWlTFdxwsLop+4QOHcvWfogom8YL3RVoQpkMcBb8P+4trdcoK4DLlGa3m68glxTm3jK2ke+28F1V93wgc2He7+HQ29LaQu3ud9VuThWFSeuGktlYPuaSymeembm2Z0DkO2UmAPAkT9laQup9MZmbmpcCbVRAq4Yp6gibAJW5XuP6+ZlUC9ox5n4MaZBKOJGaFC0VL/loCRm98/uvWb4vN9PCaYIq46BvMMWQ4rCeFfqAyPiWgaX7EOB8TuZb1xjITeB2X1GQqRuivYqnFCltvxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KJy6t9fDVbIQTUqHywLZb+xqlfua5oz4KgaCNOPSDNc=;
 b=qYwz53W54idqSYEypKNYjXtD9GXGgTaE5ovwUTqf6nYlNlQHwd8IOu0FO1d1jWwSQIHNP7EoGvQ1wM5Hhdn6Px0vEK1yLkU5FSwaI+2xcBiwtdbCbgCWub3Rz08Kq18BU6yHawiRH9OR4W3Q708F0kykNHaBHxMuRIjTYJmgFuk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB3621.namprd13.prod.outlook.com (2603:10b6:610:99::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.29; Wed, 15 Mar
 2023 14:56:09 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.030; Wed, 15 Mar 2023
 14:56:08 +0000
Date:   Wed, 15 Mar 2023 15:56:01 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Alex Elder <elder@linaro.org>
Cc:     robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        andersson@kernel.org, konrad.dybcio@linaro.org, agross@kernel.org,
        devicetree@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] dt-bindings: net: qcom,ipa: add SDX65 compatible
Message-ID: <ZBHcgYp4YRng/VP5@corigine.com>
References: <20230314210628.1579816-1-elder@linaro.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230314210628.1579816-1-elder@linaro.org>
X-ClientProxiedBy: AM3PR05CA0120.eurprd05.prod.outlook.com
 (2603:10a6:207:2::22) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH2PR13MB3621:EE_
X-MS-Office365-Filtering-Correlation-Id: bd7bf288-7f97-45b0-ad2d-08db256568ed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k0vF+I/zxoL1XU6dRuZmF8UOBFdITEaqjwvp/ufLwonbX78rVgfe1poAEJO6Uncm/N2WBeRT6X7l8oCsa+z+ynZSocyxqlQwvTY6uR7qpD2tQn9NhXLnap8pqPZ47zBPc13ttS3wm0n9A3j0u74TDON/iKh01HFWXQPBCOAzgS8jA5tzkb09Np9XML+IAISxTejsWaRISmf9rtXMVtkDiVZ5X5amRXycdFEn8DcLwBVjFFjvKTHQGZTo1ujCGan0nuw8WyLCa69vpSqqArY+2zNhZOcF6i9tdbHF2bFoedQ9b3libUzPd3RHrNDqC89mkJTOtiwL/1vNAOaqGAYxsDyAPZagGarS2UrK+6YOPjYNkHVnteqS42VDVgu2aLrMzqhDjqFcXugYyrFMYQw/jFTBCZvOcke4L1brX4S8kDSsvg8VFh+B0NlSMjVPtPcMQblbEP7Edu+yAXPCU6coAv9sHWMCHfiSsnUo9bavWWgs8++VIzmzxvcbK43kegrfmA04DPRuf6KyfKgNI2isWE96uecTZE/C7uKqsNlzVZeT5RUPMenFI34Vnr/yrbQG/xQB8v3JMARM23PGo5lystTFpRBsMyju6UxcVQnliE6e8vkOEgVo46amq39P3NdSvat5lbA5560Iw5M2wQ/Sj0u4ngnV8PNMbatYc/bTnR0jqbbbDMQNW7Wq8rRdF+Kv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39840400004)(396003)(366004)(346002)(136003)(376002)(451199018)(44832011)(36756003)(7416002)(5660300002)(478600001)(6666004)(6486002)(6506007)(6512007)(2616005)(186003)(66556008)(8676002)(66946007)(41300700001)(6916009)(4326008)(8936002)(66476007)(558084003)(86362001)(316002)(38100700002)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ryl3yvgNDnPkx50kS6i+F/ngGWo2ztL0pEDuC0R/agkFltzp2Kz5NC3OXgRi?=
 =?us-ascii?Q?RCfeLJnyoAvx1hmDZJ99EmnJ7oHVfwXWMdg8cXs9E1jEh2RRVbJZftRWBGSQ?=
 =?us-ascii?Q?q6Gj7Ygva+umvp05aG8nncQf9Q+71qHfrKw0s2ci9uwuQt66fFG7iWLjXp9q?=
 =?us-ascii?Q?p5J1SqTjbfj2dZy+xaFnfOTmHAU5UwVCCL7Jsnbcf94SDJH+jD1nQoATSXoH?=
 =?us-ascii?Q?GNeV3JP8hXUZDR1ZL6Xba+315iFy/WDU116L7toNMuS0pCLYYt+UvQVxp5lL?=
 =?us-ascii?Q?YobHU+MtUJ+yO4FlaUEkeBqyp3aUvl/9cw10iUQg29OcohJzzw9TonpdDqh7?=
 =?us-ascii?Q?oq5ZXg64xW0CNmMNQih8zU/kiwn8TMhAFihSqp/TV++6b633JW7UvGvSW8Vb?=
 =?us-ascii?Q?JLgHmo2VnzXtmVmRoBl1yaZlWg12QyZqn0wCaEUCNqpm76Pu8/V3Ntf6Z01m?=
 =?us-ascii?Q?VuAI4wcISCjgSMNBUlXQaia/znBy60InCLtYZGu2xXSHyUzjPwkUeyGck9/F?=
 =?us-ascii?Q?ULaqnWknHdSa70NSKPIsFoDSQT9mYvVQ3Xay0paCH2+CTptJFJ3UvUxInZLh?=
 =?us-ascii?Q?3b7bGBNrrRdpJXPZ2ggdeMrzOCKhpTcdLU72pfKiJ1J9mESZg3lhzL6fBeoZ?=
 =?us-ascii?Q?a8zWv4cxjqmiFGmqU9h0ICghLy1fFj4VFJqonxtyLkF8T/mQpCX6dQHQSVUQ?=
 =?us-ascii?Q?dWvhudvAICEYttrg6iiZHb9CHhhPpYynMq41PKrKvqHB7aXAhOsH9FWyawLm?=
 =?us-ascii?Q?C16jFOdbb5njr0gL+7xbksw6a8clVs8jb37993SieQT8FPT6w6FamvZJiUyx?=
 =?us-ascii?Q?pxeGji3XAacm4QaKEJyXXyZVaxRnBVhM6TFr8ZgIK1Wlpw0ubgtL79GcCyac?=
 =?us-ascii?Q?ysRLMFvAQ2UKiIboj3AY2MC9K1j7XYwZQoIm/7TX2kk1PLX+BNsmXostg5sN?=
 =?us-ascii?Q?3q9J+5DV7zhsBfrBDX+sMNUMOGlAAUPSVB5Iak2rYB0G6Lb61/PhLwRyUp4m?=
 =?us-ascii?Q?6CFiQNZfZIEdxl3BNg7l4X7bd3M97DdYbyUbwDODp4m1OVKOMIMlIeRtyVTm?=
 =?us-ascii?Q?hF5PVJmUysafcYFXev4RUvaFhXzMbxHlpkQ5ssfxNekEEdSXQsXyiuXVtHwv?=
 =?us-ascii?Q?Ri4vtYf6gHB36BJizzqgY6gTee+4eGfCs9aa0SX52uW+odBqFDaLMYsTlQnj?=
 =?us-ascii?Q?J+E0cVr/EWhCxuZT52qi6nAQea1AAlZeC3UrmY7CaK9mMfVpSAhP0AnCLtii?=
 =?us-ascii?Q?HFxi7tnqPz/3Bj5Q5vSwNWd5jgbExVwL2aq+luRpCpFxBj6CS/vCQJN9E2Is?=
 =?us-ascii?Q?171Bs6YPYaMMrxyLv3Fg0TUrS6RBpV1zxaklBuheEFco/dGGskX8AYPAD3PN?=
 =?us-ascii?Q?zMlAUgWB5xxsjFyJh0RqsB2HEH2Bbm+pmshUCZhk96OCUCsfcKlaPSMNmfTC?=
 =?us-ascii?Q?cLWy8exJnsCmoMb9dk3Ws4lIbTaPwE07M7D1NepfVJ0SCD3LPa6IY3qMPm1G?=
 =?us-ascii?Q?iYi4e0wbLxeA4u/D81skjMaR6CFOhVIQagPQebXr+IN8ifqm/XrUg1JuIZTI?=
 =?us-ascii?Q?4VSih2xzqhwZCt/HsFR4rXY1CGJjf0KtEjtXB2ur6K7eLPg0DCax3PfOjmBy?=
 =?us-ascii?Q?bvJTMTnO74yEVpEduk6zeCcu6AAR3qevOb7Ite3Izo0ymg0uTL5kH7sdBsyq?=
 =?us-ascii?Q?9+FENQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd7bf288-7f97-45b0-ad2d-08db256568ed
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 14:56:08.7888
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T6j0x8X/K/xe803bPidbplJEWie2C6KsCVsYEcH/UlnCzs8URq0fnBVYZmdjqD528CfTdE+XbPo95hy4YJPjmBR05SbZUnhYGBCOevGys9c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB3621
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 04:06:28PM -0500, Alex Elder wrote:
> Add support for SDX65, which uses IPA v5.0.
> 
> Signed-off-by: Alex Elder <elder@linaro.org>

Reviewed-by: Simon Horman <simon.horman@corigine.com>
