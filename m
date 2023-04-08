Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A68E06DBBCF
	for <lists+netdev@lfdr.de>; Sat,  8 Apr 2023 17:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbjDHPYV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Apr 2023 11:24:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbjDHPYU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Apr 2023 11:24:20 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2134.outbound.protection.outlook.com [40.107.102.134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E20ED2728;
        Sat,  8 Apr 2023 08:24:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VFQST9O9yiluhbP3tR2CYeR56upG6q6x//LsZiyZESKM37r6RT0q+NYb0f2tkCKLv37rAtokVs6/QxhBSkCDwDHBIeI4ru33sbqRA0LrzXtIXVvfxFuXXMC8Wt1Hl3ndXz+uxjwM0jn6HZgPw9dRig7fwhReZiNejdxVKQGuWHe2j03e7TPfdOY3GT34MKT8cMQJkIRtyQXZ0zhBySQM7NCnANyytWiaItfwabElRK/Ifb1CQ049GF6m4vXCgnxGdCg7MpCFRxgOo6Wn306m0M7Q7quEhIoHlwLCn0Qe03d+6h33P4G0+Ho7bvcndmifsqVxihRhkVavm5edEK53kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bpx8hfWPHEfMCy4ypCm++x9CjZb+ms9JSYdACtMVzOU=;
 b=eaO7fLAyL8sj8Hp3JJk0QfL/E8Ps/T2zW/IgWXkGdVsODPySXLz9hbR0UKm74vVs8di4DBoF2lnJ6v07ijFJ8xdNYl/BS6NLjIeiOdy66o4DwhPtgzWs76WrnyKG7rc701KDSZ7JWQO+gvc8rlLCiGhBK1ULYEZzluv7dmMQETGrYZXvwGmDzjOQq64ekBBykm9Mzg22B7amFn010u80Y5DNceap+gUDLFkE0mKAzEwki0g7YBR1D5wWkbtZJwuu6eS1QEWd5ONP8YeyPUiNmu1O3m/xaq6ADWkiqSAUyT8xlAmlUSR2la7BFmLJnEKHtDSZ/lDbhCGHU1Ld0RBgSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bpx8hfWPHEfMCy4ypCm++x9CjZb+ms9JSYdACtMVzOU=;
 b=lPdu1oGbX/3FCap8tRwWB8KFt4u3OwxZ78YybsUtsVVU2OHT7rVKiHvSFZAIMg++PMNgWSkp4bj41qZgCsk5g/NkpzRlMmWLGRE8M8bBNHJZR9hr4sEdR78mzTLep5LEh/M7lRbE0HqDTsmsRh1wytU6rzes4VmbLRRqmzQwom0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MN2PR13MB3806.namprd13.prod.outlook.com (2603:10b6:208:19e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.35; Sat, 8 Apr
 2023 15:24:16 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169%5]) with mapi id 15.20.6277.036; Sat, 8 Apr 2023
 15:24:16 +0000
Date:   Sat, 8 Apr 2023 17:24:07 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Marek Vasut <marex@denx.de>
Cc:     linux-wireless@vger.kernel.org,
        Hans de Goede <hdegoede@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Arend van Spriel <aspriel@gmail.com>,
        Danny van Heumen <danny@dannyvanheumen.nl>,
        Eric Dumazet <edumazet@google.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Paul Cercueil <paul@crapouillou.net>,
        SHA-cyfmac-dev-list@infineon.com,
        Ulf Hansson <ulf.hansson@linaro.org>,
        brcm80211-dev-list.pdl@broadcom.com, linux-mmc@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2] wifi: brcmfmac: add Cypress 43439 SDIO ids
Message-ID: <ZDGHF0dKwIjB1Mrj@corigine.com>
References: <20230407203752.128539-1-marex@denx.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230407203752.128539-1-marex@denx.de>
X-ClientProxiedBy: AM4PR0902CA0013.eurprd09.prod.outlook.com
 (2603:10a6:200:9b::23) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MN2PR13MB3806:EE_
X-MS-Office365-Filtering-Correlation-Id: 651fc9f6-dc9b-49ba-c433-08db384550ca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Gc1KftCzgkbd1ZVXoZBSJ4XPO4do/x2uLJPlfAFMYg0qNRUxNZ9/DSWrH18mUTjVhQwTO9JMVtxixgOcLNJ7Cws7QmaTw8hkpFNUVI87sIp3JCZQAgwDZGks51h1SdQoEiOgF/XZL+mO1wA8Sp6P5Dxz77qCkUHk3/gtbMjctVK1dNPiEDTMdcCHsuPwgji7FTamxj0Yba+VU6Wlw4zCv9L0OsIKAiS9vC4mzcueb7ZqErxNci0ODiyRZ/P61ud69OxC6kw5c1YY7kaeAJV/hQD5S4eQmH9NLCLex36nLLuviEMPJ3BugQkJ7cAO1Xbxd5kwzYodboieAmyTP3wPMHvvaGChtCvFX8s/JAMj1Ns7o9QiqZwXnx1GoFLmb4mbP/Dm9EwtpSirnK+NkDgR7yM0O8n4Lstm7GRlxzJ5gC/hHIneZ6vPlGNMXpKKgYhJphaosmiZb3sDTkMKdzZ+X/x+5+RmKF7PTjl67XIDhK7LmkhDdhOuKuXkfrqwPzPws3HPLt4RfUGPdPpzdkR9qZ5LkFIduL7KiAVQKxjnCAD6JGRoeQcM3tLBJEOtA7sd
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(396003)(136003)(39840400004)(366004)(346002)(451199021)(478600001)(86362001)(36756003)(38100700002)(2616005)(6666004)(6486002)(2906002)(44832011)(54906003)(316002)(186003)(6512007)(6506007)(7416002)(66476007)(8676002)(6916009)(41300700001)(8936002)(5660300002)(66556008)(4326008)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wbPbfjcRMeD8wpccSih2mLY7AxQBHA2BOoWugVe/BZoV3vWU/NwssYMY740K?=
 =?us-ascii?Q?gZSXMXADejRWzywcIJQaF6mgnxAiQJ/xvHTyJ9V9NW9QYHid+RSh8LamKXuV?=
 =?us-ascii?Q?LF3vWv8ugvE/VEra52OuCqVnXbMwuEK8b9n98fL4b+jEmsZpa0Z9Rsc/rCEm?=
 =?us-ascii?Q?uCkd/7MhTvdmBSHIzUrUaLASlVL9wvl21w2uZ0XabURVBmmu/gvFxhXcKt0O?=
 =?us-ascii?Q?14A2nh/4/6sJuC1AL0zwP2AGwKqZA7MCEnZNB7bPzEWBpsiN9NjzkDOZkjoU?=
 =?us-ascii?Q?Xn1FhK8rmB6XXXOQiYNOOtkFqKpBzwAmz/ps4BO2E0P9aQnZz//PvgsdZvRJ?=
 =?us-ascii?Q?/lxqvCSjvHi690DPpMHPMFkIpfgM8cXVGkcd758q9GbyCJKW1Jv73qh4RQ+e?=
 =?us-ascii?Q?oqiCcdCVnWtCtefZlp78eVc97HYtJu5SgnYClKH9M34UQxaXWjQMPpgaZpUF?=
 =?us-ascii?Q?IcR/bQUU+TOQCr28dEZX4QZ20X2rAwOrXctCFz49gqDvr5iUJpOm/WavGJta?=
 =?us-ascii?Q?ViYAzn+8ZM78p6YAYIpsrCE95HDh+3OYFf0RNj9EhOUaP+BHJaC/cgMCMyYi?=
 =?us-ascii?Q?xYeq9FzxuKc1Q+1B+CPVhZLsMu2Bm4GSAfw8121kH1I/6f3m1FH4fC67LSRp?=
 =?us-ascii?Q?X9diPF8k2XVF3BvcUaS45eAfoesZBszZauyT1v5fK5Roe01yXdnXbJOw+BQb?=
 =?us-ascii?Q?fr5Ay3DJobGButSa2H0LRhj3suOOAwZzQjmvEfOlo+NDbmliporOkpcSGKYe?=
 =?us-ascii?Q?EKQ+mfdgRgsmexojq4t6Du8E1TFTmtJLfF4A471Dplbe1argPXPolw6XbAh0?=
 =?us-ascii?Q?qV5yvX4e/swb5ur6q8TNlb4yoUxq5I+Llzvd5+KCeSmnUgeQeTxjTBVdw7/a?=
 =?us-ascii?Q?UQ3B8//2TwsedO9WO9zTL0X07EOLq8eaKAObxpxxRA61RDiInOElJgO1FHtN?=
 =?us-ascii?Q?4ml4NYVWMKvgVrY71LHvRI8gS9fd/BhgW6Pd8FGaJ5V8idIhBpFdpQUGDpxv?=
 =?us-ascii?Q?aP3Kj+xOFhlRcJsw90c1zEo15nYNKticCxFS+4Jj21BwDAludx+YLl51VRmH?=
 =?us-ascii?Q?HL6yNPPpdRhp9CI72zG/5hLdJ3bZoHBbsq4GE2IxKoBuQUgVTfa6YInJ1/tW?=
 =?us-ascii?Q?ohDyEYQE06Weug8ZjtyMF8mDofCjV3KQn3otd7JTvGsUcmvL4F9ADeOpgY5i?=
 =?us-ascii?Q?z2Pt/7ZioCRdzW9VTVkChVTxL1dPz4yZpM5XAUSjmsvzFlk4/5LTnseyLN6U?=
 =?us-ascii?Q?8VbdNEu97cDH6sqjPZzp27biyfYnum+Ctfo8Mz1SoJjveVu7P6FSmBaZCjMA?=
 =?us-ascii?Q?d2jHkmrcUvuxwTmZLYR5XWPW18AM1Dofv4HBzVYlIfUA+WeWd5w4gUz7y9en?=
 =?us-ascii?Q?MJYQat2Oo/Oj/JFB7t1/2E9xOeUQuT+FhFLxB5XkpwxwHZuutnTeGWL0xJ48?=
 =?us-ascii?Q?8K0bMfANjagaiSFafJ6AnsC2yUJuTsV9N8Vl3IdaLTQwZ9sgO+Mvo/IWuTUS?=
 =?us-ascii?Q?sIMAgFMBs+G/aSS+Qux1/T+6UnyW6mhzgWkXdfOMIw/SYnW3sUFEVK/SjJ2G?=
 =?us-ascii?Q?jzTcnnWXM1FOtVxGch6GwczfuBpbmq8ziyU09MrRTdBD8lEercanS4P1sAf7?=
 =?us-ascii?Q?arigiI0USIATEh71WSZt8ZpoIiBT3OZESyxNbpNmSocn7VRurI+eGsZkkwNu?=
 =?us-ascii?Q?suDhOA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 651fc9f6-dc9b-49ba-c433-08db384550ca
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2023 15:24:16.4043
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IHS5ZoHfBf59ByNB6lbqLUKQ8RTEfPuJO+bUTlVcRXNiE9ODPjPXxjOdPLxODf8tmtvFtkAPTy5ldeBjAdcYkYKyf8j3+qPUKYSNKMeX8PY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR13MB3806
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 07, 2023 at 10:37:52PM +0200, Marek Vasut wrote:
> Add SDIO ids for use with the muRata 1YN (Cypress CYW43439).
> The odd thing about this is that the previous 1YN populated
> on M.2 card for evaluation purposes had BRCM SDIO vendor ID,
> while the chip populated on real hardware has a Cypress one.
> The device ID also differs between the two devices. But they
> are both 43439 otherwise, so add the IDs for both.
> 
> On-device 1YN (43439), the new one, chip label reads "1YN":
> ```
> /sys/.../mmc_host/mmc2/mmc2:0001 # cat vendor device
> 0x04b4
> 0xbd3d
> ```
> 
> EA M.2 evaluation board 1YN (43439), the old one, chip label reads "1YN ES1.4":
> ```
> /sys/.../mmc_host/mmc0/mmc0:0001/# cat vendor device
> 0x02d0
> 0xa9a6
> ```
> 
> Reviewed-by: Hans de Goede <hdegoede@redhat.com>
> Fixes: be376df724aa3 ("wifi: brcmfmac: add 43439 SDIO ids and initialization")
> Signed-off-by: Marek Vasut <marex@denx.de>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


> ---
> NOTE: Please drop the Fixes tag if this is considered unjustified

<2c>
Feels more like enablement than a fix to me.
</2c>
