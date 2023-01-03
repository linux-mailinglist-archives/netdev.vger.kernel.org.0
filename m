Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65E0765C9CA
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 23:54:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231156AbjACWy3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 17:54:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbjACWy0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 17:54:26 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2112.outbound.protection.outlook.com [40.107.93.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 178281208B;
        Tue,  3 Jan 2023 14:54:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eMqHhF/bYn2b5iwjaHuBY+OMT3evbmsrTN/qIBNx2aVYDM0GyXUFcsiLO9LRmpefiDlMfc619dNC92amJ/NY800yy3gjElrD2sPzynq+WYaJRZ7pBO4Yv5Epb2/Ah3J6Q6YxB5RPeodE/U4VJVa6fCDuORv9xF0+YnwVcKTCsjFo7mawBpat2RfcxivBZmm6agXFBPLLlNWhVuwbGGGRJx3PQmQVH58wWJ2A4y29AhvJJMEk7zf9khVjaZM7e+E48kZw0sw58owd+Ls173YLFUUKqWbM5LWVVzVr1uJN6QgSsQZz8Yrqn946/la+6QCuZMU/hFBqQzgs3ly82+uGcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mz/XvbLesxshNUePRiwF2vnkFWQG3PyUHR7fQAjgjxg=;
 b=atD0APrxVVur4ln4WrHYmOUrR0YB4QHGJ2jJ+l8gBFWjv1cvGRbGtdTJ2MG/fAsNLYRHcENOtTscUbAe0t7V4WoIa8iL9Va17IG00wh/Io3fME2hceOZEXphRe9twegui4XUawipM8D+0BsQrX2tCBTMcXc1grWJQAdQwdnqcQgqHb2wiJYmvMpKx/4oV2Z9ev7TB6oiWyD0/QxOXPnVUV/gT79IvCjW7KN034cE2pjVNihlk0fAdHqdLDdXENKpfKVtBkxYQtPMrOAcCs544hZY6W2e9RPy2WuZdTYzg1mHYh+pr3BbF6OgulePdqj5IDPlWvassFrJcrK68DxTFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mz/XvbLesxshNUePRiwF2vnkFWQG3PyUHR7fQAjgjxg=;
 b=XEpnwIh1XM7E8aAouJ0hSaSC8UZ3Lpcp8j+kRhbW/p9ryhciNYtUXl+lfxW3t6UXo4o2S4q65h9f4bduPy2o/qdImf3iGh0C4h1TzSVU8xhKMIz5NKnFN2hs7nxhcakeiQx9bTLlIublM+0hKIdEdnsEi9m1TDnrBcOVz+vqIfA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BY5PR10MB4356.namprd10.prod.outlook.com
 (2603:10b6:a03:210::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.18; Tue, 3 Jan
 2023 22:54:21 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c%4]) with mapi id 15.20.5944.019; Tue, 3 Jan 2023
 22:54:21 +0000
Date:   Tue, 3 Jan 2023 14:54:04 -0800
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Rob Herring <robh@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Marek Vasut <marex@denx.de>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        John Crispin <john@phrozen.org>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        =?utf-8?B?bsOnIMOcTkFM?= <arinc.unal@arinc9.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sean Wang <sean.wang@mediatek.com>,
        linux-kernel@vger.kernel.org,
        =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        linux-renesas-soc@vger.kernel.org,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        Jakub Kicinski <kuba@kernel.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        devicetree@vger.kernel.org,
        George McCollister <george.mccollister@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: Re: [PATCH v6 net-next 01/10] dt-bindings: dsa: sync with maintainers
Message-ID: <Y7SyDO5wS058dyZp@colin-ia-desktop>
References: <20230103051401.2265961-1-colin.foster@in-advantage.com>
 <20230103051401.2265961-2-colin.foster@in-advantage.com>
 <167278470815.4157827.15557237476346780909.robh@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167278470815.4157827.15557237476346780909.robh@kernel.org>
X-ClientProxiedBy: MW4PR03CA0246.namprd03.prod.outlook.com
 (2603:10b6:303:b4::11) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|BY5PR10MB4356:EE_
X-MS-Office365-Filtering-Correlation-Id: 148d8f9b-91c0-4947-b30d-08daeddd7388
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UOf78SkyLcDEpEeOB6aR3phFmGuzAFdQX1Afc0wqPlunJcxe9jZZdg9MuvC6kIEk447GXdy47OHf79tzO96qQ2Pk3j1R4JgvIcXAM0FIvA+iI0CRgk9EPZS/Dsc4T6RydVJi0f0V5U6go3XMc9Pw9nwmVWIMx6fLjRrpFC43w/0EIhTC6fyJFpQIMrndxfeBlZa/OT0X/6e99FH/Fip5l4rcAiiLwpiKBdpBEKTXQkC1xEMzvoMgjRXbOtcP2/T9WTB1uAuVWxqaWyRCE0xkZs+y9IuDZGwrypyzXvXT2cyFV0ug6BaQth86G+Gzza/95ug9cDFPeo4gKMSIrOvvAqvGOdfvicJTMEJxVaYKpx11MI66mgJDp6X2gnid3Ibf3zmDnD1RTSzomkoG2BhTxCnNEiQkXyUdYhtr5cO2X1lLDDz8t4jp0mg5ZHtGYzSMDv/nR2csuX5XFRWdwnECAUJvmr9RwgMtlyC9gNlD55ryD1+7vuyhEIpJfc7XKpv+3YVKi9XUXXlVXfJpef7XO31OJEmvO7DuCyFcrJUzXzzVVjs1SasjQh70kY/JH8tFVmVkooh041Llf1jG8lefA4O1DI93jjh6fb80zjSo7einhPvaKpeq9fJF/RCeiDWoetP+BdQEQoZWcHRnwirYPJo2rR+TGN1emCNjyBLo4Vm1ZQbvm29Bw4lMg0pb/zmc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(39830400003)(366004)(396003)(376002)(136003)(346002)(451199015)(6666004)(66946007)(2906002)(8676002)(4326008)(41300700001)(33716001)(66556008)(66476007)(6506007)(44832011)(316002)(86362001)(8936002)(6486002)(38100700002)(478600001)(186003)(9686003)(6512007)(6916009)(4744005)(5660300002)(26005)(54906003)(7416002)(7406005)(22166009);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7xqNw/bPrvuK2uYkpmoGOfJrwGY1DAZrqTuTUmR+oWyYj1UdKKCrYXYn2O/x?=
 =?us-ascii?Q?IBfaFLaRn9PvHoj/fXUX+89ULt3zWorukrqpETBEX2TMikwgXqGo8QOl2ooU?=
 =?us-ascii?Q?gGGjF0+XwMI2f13WBsI2jPH17KYYWwfhrpba1FLBueJNOVJnifINVFBJ9rxF?=
 =?us-ascii?Q?PVZcw2CgxoER+XRi3zE0Ujjz+7Pe5xmYCtVgkimjQ7cYfyBGOp1MSBh7C2WX?=
 =?us-ascii?Q?TvCz/Y8OUqoGOHobJaFw6MbYOvLCZJ46uJI4Von7BqESW2yQmA0wSR+2qP2H?=
 =?us-ascii?Q?x8WwY52udxdl/95KG7Kgx6Vmlk240CJe+UL/5NUp1a7ovIglOoMgCojwhLEH?=
 =?us-ascii?Q?+tL5bLnNyB+I+UCs1MT9SGVTTn+3C5A/x/QNdjTF/IMY3ZopBC3InyqFUI9U?=
 =?us-ascii?Q?G60hx7KzGUrZGTET6FM7OGpI7IVcL1J/5p8uc1BepBwmZde0LYuCkQqW9EGg?=
 =?us-ascii?Q?BSvjAVCwjHLoVmbjVRylVPwZ1A9tFo3JWkRo9VzGyvdZ9mFEzIoi+ec9IVXx?=
 =?us-ascii?Q?HkY12gYBYa+4mya3nBvRJc1ukmIYho01FkbzxGMtYocseTWJ5SVMpJ6InPwb?=
 =?us-ascii?Q?I/xGcHerIJMkTX6yUSda+dIdxIjtjnfJm1gn8VZVYfJmIIa6VhIDPcNFtZfO?=
 =?us-ascii?Q?FdtTERQWAKe6vC6C/plJTJvVege5M/5MGPCkTFHLYip5RWE2LfI/ULE3p64w?=
 =?us-ascii?Q?wXnIdhQ6yR7D6M6WW8+cl2jbuZBZKXVH5bSQeSbhLl8c/8D/8rkk/Qhgjwsg?=
 =?us-ascii?Q?4umOWcAhB1dX37V9Npg8SXSqtjnVIhW3cyhMfYAh3Ucq+oN6jRyRG2qeDkFq?=
 =?us-ascii?Q?OwFbJjDrolJgPqgU21AB9labP/3iAFg9jj0vIhLp+nFWiWkpKKE53GLaOkl7?=
 =?us-ascii?Q?JfvvTOwBJHG/mYr107H06iOjeIfgux0gvdtLwx08Rltiaegx9tC6W/FhqQ1r?=
 =?us-ascii?Q?kGorov4liUREe6RwHXH5UH10RUz1TctPqAdMcy4mY4pZ/Q+ZBpzVdxslBpYK?=
 =?us-ascii?Q?zK9/KBGXiwyhUDAITa+Bdk4wI04TERRJIBGDAbSkAXVDAeLsI9qibRDwVqAB?=
 =?us-ascii?Q?zzqAHVFvMHcr3q5qy6GDYvmdapRPZPdf20wkNdLcTXpJHHTajTD1skAy/Ntx?=
 =?us-ascii?Q?sKuenxDwtoyUIi/nHqUpDyOMpGpmgzxTVpIBdBexvRZrrXXjF/TlgUy60eNK?=
 =?us-ascii?Q?kVuOwYyTRJjTPNpv31YVd56sjxPA/HTXA6CyLFXzOIDFo+bVQundg/s0FgJP?=
 =?us-ascii?Q?2z4IFAJwAxLKEMCpZKrFKCRMbVkWaD8q5JMqBDgTQfpslW3HuIVQN/la34Gk?=
 =?us-ascii?Q?/MnWI+FMfbNjjb6rv7Ik4piRv1MP77V4R/u6jKgUqiDek+eETgEiLWkKYtmy?=
 =?us-ascii?Q?A3+JfCURIxrwe3Ssp6AKzpZoRGv02xlwQTZ4NDo1CYdC8BXKjmBZvmqtBNMn?=
 =?us-ascii?Q?h4WkDNilvLbGsTykIxaalmQLmVXuOR5k1ZtY99RdSgvTCUBiQ0eU8wNlZgIp?=
 =?us-ascii?Q?6D09gB2lGwgrlqaeCt5Yu8kAh/jUOFZu0DKx0k5mKT8YyePtb2bSh+NKReiy?=
 =?us-ascii?Q?1y/71WmM6YHVyeeoSpuu1r7polC1JuVhzjE5jMmxFEHkv0U/fZBtb2q4WaJo?=
 =?us-ascii?Q?Og=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 148d8f9b-91c0-4947-b30d-08daeddd7388
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jan 2023 22:54:20.9959
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E9fChPc4SDfJhXGyYqvmF8F6hACVxb1hnZMP8Oa2d4e/L3zT/Yrgb7otEQmxwwUptwe4+HkkjMWvVhqlVOiuRNUoDSrfNZm9QJSTM3gQyU8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4356
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 03, 2023 at 04:25:31PM -0600, Rob Herring wrote:
> 
> On Mon, 02 Jan 2023 21:13:52 -0800, Colin Foster wrote:
> 
> Please add Acked-by/Reviewed-by tags when posting new versions. However,
> there's no need to repost patches *only* to add the tags. The upstream
> maintainer will do that for acks received on the version they apply.
> 
> If a tag was not added on purpose, please state why and what changed.

Genuine mistake - my apologies. I see that I missed both yours and
Vladimir's on this patch. I'll be sure to add all of them should there
be another round.

> 
> Missing tags:
> 
> Acked-by: Rob Herring <robh@kernel.org>
> 
> 
