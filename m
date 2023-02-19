Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CAA069C065
	for <lists+netdev@lfdr.de>; Sun, 19 Feb 2023 14:41:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbjBSNlb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Feb 2023 08:41:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbjBSNl2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Feb 2023 08:41:28 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2130.outbound.protection.outlook.com [40.107.93.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9F2CEFBD;
        Sun, 19 Feb 2023 05:41:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=izkKK/bv45ug7yDctdCeORr7iwBsBdRJGhId6G7HHZu7ELKolpCUfZqatgY+565MUBkXH1klimCFcoJbM4yEfDKWRpQAcc7Kg0nL+ZQKI4koCq7XRgdFmA6XJNTLlQrdmSvUqFv+pcD8drWVQtIJkQYQuJAzdY+YFGtaRK2bgK8U1Qq3pVJA1Avd95wPDcTESBHP/GXvRr9vgI8qDgS2J6yIzlz/vtILB3xj7hBB4REcGTogDY6qD9M1vq+EKGo4md+esqPFlkL5A8d9Nf5wV5ukscpE1EFCIC7kw0rhmE4Dmgt/Dv3T5wCG3RP9b2UAL2rUJVXrDG1AvzV78iw44g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W0qvP3x6sgmffgkfBnG21t4wtrKO+EzDD5IBTKMuV1g=;
 b=AxCeDPFQPjQd2TbaSBEn0Nl2czmdhQfGf4o19da24ejvVf3qqGrRBSdngMwiGI5xdPVS8qWzV8nZGcwylj7Aq4otWcjhMe5w75foQo0TL1FX4kqgbKFrjBskQ5lNxBpf3Om8+s9bt0C8ayfD2ggid/x8QQaa/VHe+kA8rJKCO/e0oAIyHyPCA2MsJyidSVxb71iwLfzZFZecxWJdFlOD4ODDpAnEMF1qxbydlxBeBqmfPF5koM/nfAJeFurJ09y73mHk6regRbT78jKqAfP9qyLqYiVFyEoAScB1aeYENIVtddiQo2dxTjKXYXikKKoUDNyo38RSkADgRD5idbdPtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W0qvP3x6sgmffgkfBnG21t4wtrKO+EzDD5IBTKMuV1g=;
 b=WM1xE4EMWGMmD6SkrkfT7Aw9I2YrbSSt4RJqkSlVY++V+Gjn1BRe4Roz2VkzpzJUQEQVzpnZrECmiCp7r29s7hyMZ7d3+zmGUNDrCuJz1kGEDQeFf+WjbeUzTeM6f4ES85pOxK3nXDKCby80TAND28T8WTZ/Nsu5ww5DDNgW+sg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ0PR13MB5304.namprd13.prod.outlook.com (2603:10b6:a03:3d5::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.18; Sun, 19 Feb
 2023 13:41:24 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%9]) with mapi id 15.20.6111.018; Sun, 19 Feb 2023
 13:41:24 +0000
Date:   Sun, 19 Feb 2023 14:41:16 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Kees Cook <keescook@chromium.org>
Cc:     Gregory Greenman <gregory.greenman@intel.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Benjamin Berg <benjamin.berg@intel.com>,
        Sriram R <quic_srirrama@quicinc.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] wifi: iwlwifi: dvm: Add struct_group for struct
 iwl_keyinfo keys
Message-ID: <Y/Im/G6/Ij26oRhF@corigine.com>
References: <20230218191056.never.374-kees@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230218191056.never.374-kees@kernel.org>
X-ClientProxiedBy: AM8P251CA0004.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:21b::9) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SJ0PR13MB5304:EE_
X-MS-Office365-Filtering-Correlation-Id: b01f7f49-f58f-48c1-36e2-08db127efdf9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JaYIYWKkESli669CT0e+0isHUaYdXE4ahNU2+pteWeSlf7qp2pBnXQrO8HC3ZBmkwP50rXCYJURyKV57mPdaG1SuVA1NkxMQQv2lJWJa+1vVNeMScoEWoMlSWKK6zS9o4P61rTD6x79wg2RfdMsRmBAO0m25hCdpiRgkzXhXZGrOq0uVaonKjyzQG6JbUHxBWW53P0Brg2RazDpqqutHzoiO70Z2NAi4nyrRFLW+HG9FjVFGSgAz3/2vfUL8hWYqXvZrGxOIiZbCeudHKZ38YzhhuzDddImSI/tG4vSXQj7gebsg06RTYvoVFXjMvjJnMJKuHFzIaxfe96c5yBoEaH4wprS4MQZHsDcvHCkDFm62Qk7uYz0DV2tYKnK3O5+ASI5SwEp2iW0Zp5v5iSP0nDn0g5W2qMVReiPwsyrp1VsuqkPb0h0GQ4bQwsaze3nowPPvuR0ITL96IL4L/+0HzyYI64xD2wPa8Qx7yrCduXVoMJH+sRKQvphXXG7TzozkHNMYnGp2Jhs6GfZQX1pb1OxW+oNg3Wq/KJUlPn4UXXjhOuXJyXvi93x0qmpqviaug1y+NXr0C2Bl55WtfFfxfw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(396003)(366004)(39830400003)(136003)(376002)(451199018)(2906002)(7416002)(6506007)(44832011)(8936002)(36756003)(5660300002)(16799955002)(4326008)(41300700001)(316002)(86362001)(54906003)(6916009)(66556008)(478600001)(6486002)(966005)(66476007)(66946007)(8676002)(6666004)(38100700002)(186003)(6512007)(2616005)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xIPpThP6+s4dfNY0Y2BgI2Hx/jK3jBKMsnxFHVPbbQVme8OcRp9dEOk9RYtz?=
 =?us-ascii?Q?vtSRDPVz4OwQIgFHonjVhiP3ZqOGS0EUSsP58oSopznVTLrnGuqYCzyVhS2k?=
 =?us-ascii?Q?F3SylcM8zqv43psNv7CPhKDEnnRmKI9cuHeMCLSWHvW7NVvCKHllUb9inHhi?=
 =?us-ascii?Q?yujuWRQ0FBfee3nwtdbzeTUPc6YJm4oNPFzbY/GtQYriaa3y0aZuHtdp73mD?=
 =?us-ascii?Q?Tk8kT5dxpMj9gtdLSnZ57eRbU7h7vHbQTpw+Wk/NvxEAgpMaRYMb5zZrKeqn?=
 =?us-ascii?Q?ITgs6uSMSK3m5auAVEK8xkT6GjtT5D1vXDl+oKiLtY0t3nkClJIEG8kawqRN?=
 =?us-ascii?Q?/YEYD35wK4nX0rSX6VfBIoDrwskl0E80NvBDiXIIEBPBApVK9QzcAQLQLRmt?=
 =?us-ascii?Q?TgxoAOiiUSYEPaCEEY1TRby1tE/8G5hOx8XkGLnJc1qO+44E3XejBJWWJjGH?=
 =?us-ascii?Q?6O/Violmj2IpoUyfLlpy9z9Ih9xhmcty7sFeONhp1KF98CSim50aIocS8+7r?=
 =?us-ascii?Q?3wCPU/zyZHc9NGpsg0ZT+/KNR7/RZwk42brmn8yYP2e7gQiKC7gRRORm+8iF?=
 =?us-ascii?Q?9ym8V8k5+0jDSC0wrgtQb83yUhYKtGggm5CUjak1J72UO8b0cvdJoQY/IhXc?=
 =?us-ascii?Q?KrXLjMPNX3R58F7dTkUgBLGQ7B/ZzFjiof2K17zGysF4wYTqvhl9OCkW6Yub?=
 =?us-ascii?Q?f8Fvn1hpp+jYWuRtcKIqnUP7v6yyuICVifIK5ETzzTeR8JHVQZG8wL8xgGVV?=
 =?us-ascii?Q?k3VWK50Hqu1SbUxBrMwVpJ/76sLWWj+ry8YJg3ZFqS3w81fmbUZEnfntP5Pc?=
 =?us-ascii?Q?VFlBrXat+9GHNKPKhePyst/MkHWEiEKeJ72jAxVpdyd6x/QR1nSz2MkHUoxY?=
 =?us-ascii?Q?seHJ3tmdwUvRuz01eyJCoyrnQQTNbcuyjDfc9n5uxSAmTD81gsAykIgcn26N?=
 =?us-ascii?Q?ibfSq2EqzpQnnmoP5vibAwbHawWed7plx70ZVyKS+m9bPrnQgG6jgrWA7/e2?=
 =?us-ascii?Q?FHSkkUn1rpDqAq0zmp+89ULd/8rNQWMVh8/gDAm8DzI+klWyHXLDwLyLcOaN?=
 =?us-ascii?Q?uVMiOE0CdcB5LVLgF/WzQNboQaPNUYqN9AqjVT7Nx5VO4M+pGyzYZoVmRJDm?=
 =?us-ascii?Q?LwO2K/Z+smwocFegiq2GjQw2B833lt8Hw9q9HNmT+z4CoBEWH5LNSfMOuddW?=
 =?us-ascii?Q?LtGgAH6E+0dRaoUEAXDPSu6b178WY/7sS4daRzTGjIwJ/KDktt4pAurfhQTp?=
 =?us-ascii?Q?EyWxEOUeERZ2NL7i2QyBZZEXCtu2BfmK7ICzbUP1sMOo/fFF6MGAcHj2cWVV?=
 =?us-ascii?Q?pn8QmbqLBoJ3TxJH8Ocnc7zF3Muyf+0PzdPTaoM+aEYVm+mWpRA32Sk6KIKc?=
 =?us-ascii?Q?l3At4ZxtycEUn7sI1zPa+8zmoFuoWMhq2lQw2d01CE24qcLaNl181j0WPI2+?=
 =?us-ascii?Q?CgFgf+4prryWxM+DVLF7mvVwsNqtRx/ATit3cK1/kguwoBVB1/76taP4m9fM?=
 =?us-ascii?Q?88rTYPPdhWwGtknLpkLzPzgzp+/3Zv+VzwTIi6zMfslWT2t/g/aZ66YPM1pU?=
 =?us-ascii?Q?A5E49zVn+ZKNfLDz3EQHkgYFNOZ6OP0K+WSWIRPqBKoKfrwDvHe1CHk2QDVQ?=
 =?us-ascii?Q?LLkvW324iZjCze+AAKznTWuwPEmxQhxNLJcdlJed8jtTznkANVX2Vd/o8kNy?=
 =?us-ascii?Q?SNaTRA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b01f7f49-f58f-48c1-36e2-08db127efdf9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2023 13:41:24.1496
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FvNUbFA6G4ep4aNwsAB39Y55hUgwUp0ptk2LnRXdlOK86tcz3r/XC8q00jlLB2ZIRI3TnTbOjjEHyoKeYklz/PWH/YAt5sfBAxT4XhkBuHI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR13MB5304
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 18, 2023 at 11:11:00AM -0800, Kees Cook wrote:
> Function iwlagn_send_sta_key() was trying to write across multiple
> structure members in a single memcpy(). Add a struct group "keys" to
> let the compiler see the intended bounds of the memcpy, which includes
> the tkip keys as well. Silences false positive memcpy() run-time
> warning:
> 
>   memcpy: detected field-spanning write (size 32) of single field "sta_cmd.key.key" at drivers/net/wireless/intel/iwlwifi/dvm/sta.c:1103 (size 16)
> 
> Link: https://www.alionet.org/index.php?topic=1469.0
> Cc: Gregory Greenman <gregory.greenman@intel.com>
> Cc: Kalle Valo <kvalo@kernel.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: Johannes Berg <johannes.berg@intel.com>
> Cc: Benjamin Berg <benjamin.berg@intel.com>
> Cc: Sriram R <quic_srirrama@quicinc.com>
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

