Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80E7067EF66
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 21:15:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231519AbjA0UPN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 15:15:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbjA0UPM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 15:15:12 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2109.outbound.protection.outlook.com [40.107.92.109])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07C012CFE4;
        Fri, 27 Jan 2023 12:15:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V+YL3NKOAvrG2VP3POD5kNxAqHW2eeDiB3TLN703l2LoCi7qm6dc6SXGjeEM6fyKcoiVVgzMZrwKKoeM4uSjRojBZ1k8kIovhb+QqIWVJfvGU434CfX1liJveajaffynI93/3whcC4l9Ue8+TCA1Zqrg+UG9ecPHYxmo0jC4KU7emGF/yZJVCrbsCocvpjnXC2eIZa23k7vIPtRRYU6CXB8/LFRfzCZDeNhJUabEUW6TV8/X8swCdFgebE945TTdN1MfDOlq+3mvf5BjDRV3slKHhSKXhbbeSg3NtkQE04C8dMh1JfFEB4P8R4886d2iu8mCSfy0nMcz25JI/C4v4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tfPanqKChRTF0MwBKyiaQdVZKfAGZ0nLMgK8UEisnLg=;
 b=F0eaj2BjxYjkX+Iq+PYm7qfCVKf6UzlkgZmAeIQHBHKpWT8T+2ibCseC+jG4KsLMzfW+N2f1PudbG6GZUgosGj5MEsIbNAwFg684iXzOyD24Np7EdN9IDQ2sseLY8eFuQdnLPxLTx0ENmjsR1zciqcfRhJmB9BptHLtWhCUHeIgvdNMTGrmzDKQ4va8E3SM+/5BUzMxC16BOtvxZF/bCXb5FsHrfc8jeI5xJwlgH62bqrgVelKZEOFW0Ggn0qSeiXjqVmuk3uKpb7Gk8ww4mact6B9WN/9AD78alfS1JgAJubyCFlwVrpSesS5DwAWpmx80TjRE/7drbaWUOLxCcMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tfPanqKChRTF0MwBKyiaQdVZKfAGZ0nLMgK8UEisnLg=;
 b=bOZ/gZP1bUdH5u/ezmB3iADVJleZWCJh9bevdd2+v1dBb9B1DwdWnQ80hQcF3zZniOCeMGRjiN51tOncSff541hCwANLoi4tGitnfaYkkXgRyjV5tvXqcMVkAfp0BCSm20ySm1IAq30ENdZ3CALBHyHe6u8rvBgDdPRoQOpZeC8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from DM5PR1001MB2345.namprd10.prod.outlook.com (2603:10b6:4:2d::31)
 by IA1PR10MB6217.namprd10.prod.outlook.com (2603:10b6:208:3a6::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22; Fri, 27 Jan
 2023 20:15:06 +0000
Received: from DM5PR1001MB2345.namprd10.prod.outlook.com
 ([fe80::221:4186:6ea3:9097]) by DM5PR1001MB2345.namprd10.prod.outlook.com
 ([fe80::221:4186:6ea3:9097%7]) with mapi id 15.20.6064.010; Fri, 27 Jan 2023
 20:15:06 +0000
Date:   Fri, 27 Jan 2023 12:15:02 -0800
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Lee Jones <lee@kernel.org>
Subject: Re: [PATCH v5 net-next 13/13] mfd: ocelot: add external ocelot
 switch control
Message-ID: <Y9QurbpHk5NP1kYu@euler>
References: <20230127193559.1001051-1-colin.foster@in-advantage.com>
 <20230127193559.1001051-14-colin.foster@in-advantage.com>
 <44004691-4f1f-a810-b499-9e447f1e0ff0@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <44004691-4f1f-a810-b499-9e447f1e0ff0@gmail.com>
X-ClientProxiedBy: MW4P220CA0012.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:303:115::17) To DM5PR1001MB2345.namprd10.prod.outlook.com
 (2603:10b6:4:2d::31)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2345:EE_|IA1PR10MB6217:EE_
X-MS-Office365-Filtering-Correlation-Id: aa8d6bfe-259c-40f6-9936-08db00a32e95
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EnO9kIcC2EpVbWxMUD64bgl2rcj95viwzyzYefH5UCnzjk4bhtZWxTt5dnVnsF6UnUzGcSMc+pmvGnur35nP1vTtv8ZtLfovM60fD7sF2ztUGgbYkNe8jz2bR01SzpID1Hi6xD3yyO3YOXu51v/h9+JfafvfmZjy4k5QCtjDfi/M8yo3OzBG7hF998kwIIp7/wYPWIBS4mPoAeIWMNzzm6dFllWoULadFyh+7CPcDAHoYw1xi87awXn9OUEWc7lLqrI5zOCK3qrnM1YC3N6R2R/rj2Znel7ahpoxDMZhlRRrA0ftr6xYBOKpMY/Uh57tJpTna8q7uQm3TBU67vJr7AUuIKXiAkPN1k5oSlS4MJOf7IQ+GVtQQTRqDYt7n0bsrcY9lx1qWXoK/9agP20jrJ29wEiN8ndRo/qkC2E/zujqqGb8Dr22DL42FJI9ct0WWGcDcVFKwQruaKgi56VGdHxxbIPAJlWEWQWuAazxpi3GGfCKgRih8W1HL/HXCqibi1LXmTsgNZTNGOmq1GFS0Mk4T8mpH1tN4zM8ALgv8Zn0oxHlTfIkFxTaF1e2uWCZ8wXrcTNstKtQSgk52oK2HBnKHG7zOru3+PPHnoUjjUCbwfcqE/v7jLZEQKYzyJZxmK++xiIFjNgG6ejnVSq6VQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1001MB2345.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(39830400003)(136003)(376002)(366004)(396003)(346002)(451199018)(2906002)(8936002)(7416002)(5660300002)(44832011)(41300700001)(6916009)(4326008)(8676002)(316002)(6666004)(4744005)(54906003)(6506007)(6486002)(478600001)(53546011)(6512007)(9686003)(186003)(26005)(66946007)(66476007)(66556008)(86362001)(38100700002)(33716001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IZDVZmpnaFjFGeovFuAvv31ZYw/pYCP6q06ovrYfYqDfG7n8jZG89X6TTZ+z?=
 =?us-ascii?Q?ZyeSopbClsTljmhtjDv/7jpBDjfgT51SQXagprhfCTQob8rxeQ9C3RPL1r+A?=
 =?us-ascii?Q?cWX3NPD1ozYLQxR40Ol6vzBA1ZglUFZ31nRCAq64DPOE2AuuhhyaZfr3wF+Y?=
 =?us-ascii?Q?DKSdQrWXNblpIYOstvQPl6X35s+9lMm4+vvObRutF1TCm0efLQlaXNtiUcHF?=
 =?us-ascii?Q?n4/LziyUOQ4Y0E5WVEDgyAnDbHXvSMJ5GfewYjwRE2/V3oa94tyjMPWSrMjt?=
 =?us-ascii?Q?1HHo0EAMrTI2a4mVvxlV6DXK4VErRLeS8uMGSBjy3gCUX0QA+dRmudIk0a21?=
 =?us-ascii?Q?MJmxTc+bmUS6mjSIGohwtU0Wo9M9b+ztHQwplYZ5hF+nRmSJaiUC/6osgFa+?=
 =?us-ascii?Q?KgrzuQiJcaK3op0rrUXDtlwqVlMX7XmC8qs2v7sIVlVOgKXG5iOFk68Y+k70?=
 =?us-ascii?Q?zYO/hG/Ls2yImdCE/D4gZKarORS5tKqC0wJ9XkbD+vRraCPcjDWPIbJ7gZsZ?=
 =?us-ascii?Q?ur5DFbTcqaj6BWS4ljHYk3j7tEdTNK7tzVvJfxZFah15caf8DNVe2Rbbj22Q?=
 =?us-ascii?Q?eci7Z5+njnRCg0xWhp29GYIGGeIPnwkDLDUW+W1IIAB5Ghm2i71cCpCtoH5m?=
 =?us-ascii?Q?u5perC0najEoshwVJ/HnlOgxHk9jMwdYxsVYhambOw2jIpzEmWsnJFF8nDv7?=
 =?us-ascii?Q?ULB3+Org8VvJ12iu/ra4+CTdKKxgAA2pDIyaORRo1fI2LQ1U8ySa6nkxh9R4?=
 =?us-ascii?Q?SBU5/QvmLS9+MI5T529JlO6OxKcl5LBQ4d8Dlt+7sZQsSyVxha9fBga53Eds?=
 =?us-ascii?Q?73Qin7puhOwEy/mWsPdUDhFLCp2FGxgQs4C7vvZt/F/QadhdZSV0O/8oXNzM?=
 =?us-ascii?Q?xoyrz4z+mHOKI/vNSLq1WsBQlpUcagHgtROXGDEcPtHL26ttHD+Ye7LYaJ4Z?=
 =?us-ascii?Q?Y+6JXgSD3r0uIRU8QxqSP1MXtjWnv9ChuQZ8J4aX/bHf2nJ8U0Vtvxn33tkk?=
 =?us-ascii?Q?mSg4PF9V9bxuezaVe6g1EWjsBYW6mN0domeuNZq2zAdFdxjYRB92XCFPv8dy?=
 =?us-ascii?Q?bdN3U0p+sjg1F6yp9jgL9AvvDrp0ukECokKVt6MRdk0/16xkSRVpqmRBzDAp?=
 =?us-ascii?Q?9hKrjzdilREEKZxWvYKki3AiPqh+Sr4zywh2MUTKktiVecUy2dqjkzluF8Ux?=
 =?us-ascii?Q?EaK4e7AHWAM2U3dJW430x+7kG1lFxvbtJE3sUSM2BQX2wbikdXmC5DKMMtol?=
 =?us-ascii?Q?UCrQHRFfYLbsO7sQAR/nf1PS6XndgmE2rFh7xqXpa8vJZfsLX+jTBcM6XKyD?=
 =?us-ascii?Q?8bRQSpb1PTh86u2YF94Yt/C4xOgFPQcTSHRWiy8pjMu5vYsNzm1E5srBQvDq?=
 =?us-ascii?Q?QFQhaVcL8MEIMqocMV3AO9hV3CoZRGlqltgv7CNixz94SmynO7h9dCs1/79U?=
 =?us-ascii?Q?at+CjWiG33gRdZaeBHxKPTMdgCmHHQQpV+J4C4m7cKMmc/NhLs35X104zkf1?=
 =?us-ascii?Q?gGe26pAKMuM7QJXz18CkgvvD5laN1uHfyzpFnApSt0vOS7BdqERtLvpe7kcV?=
 =?us-ascii?Q?3f6LirQgT9D2qS/ziakrm4Axeed0I7E/FuiyR5fXKLTxg/dBUShMex5z0DSW?=
 =?us-ascii?Q?a6AHPN/MNspP28POdrWuTq0=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa8d6bfe-259c-40f6-9936-08db00a32e95
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1001MB2345.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 20:15:06.6469
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PkxkjowaVpsc3lM5PiQcAju9DdzDmEI4bGLZSSnxz82uJv0lTabvfqMAeRQgUt2PqD2zol1diIbL/wK4Fi59JroqiXSPkXXR++TFxnoB6D8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6217
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 27, 2023 at 11:53:58AM -0800, Florian Fainelli wrote:
> 
> 
> On 1/27/2023 11:35 AM, Colin Foster wrote:
> > Utilize the existing ocelot MFD interface to add switch functionality to
> > the Microsemi VSC7512 chip.
> > 
> > Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> > Acked-for-MFD-by: Lee Jones <lee@kernel.org>
> 
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> -- 
> Florian

Thanks for all the reviews today Florian!
