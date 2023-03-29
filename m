Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4533D6CF179
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 19:52:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbjC2Rwl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 13:52:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjC2Rwk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 13:52:40 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2112.outbound.protection.outlook.com [40.107.212.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8547DDB;
        Wed, 29 Mar 2023 10:52:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d16Irew6W1OEghtWqn+fmWVBcVhZ6i3CMKshMuTf1s0nYmBo/92NLQcHRU0DM9kpPW4jNRLR9PkV8r6bmplgGsURsjP+Hbug9mjC1/Q0G09nupyESzykI/PEPSf2eep5Dnly7WpTSagMAQ4fcNglixtvmO4/aUd5i3mUEHcv2/z/MUJL2ET9Ym6d01zeUkzO7e2BxOpqPVLI7tUwVcG2K9HkgLHQK9KauzrcuH0T2Ign3Tr9Pj3KMud9cVdIp10F/EX0ZVsR/b57n3WvjI8T8WSRuL4IpeDQGA2C1crptuKDXnZkqBE+J8UyDJcBnU+KXTIZgaqAakr0HA8BXZ+tUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gQYw5sV+9xITwk9YAqAawLpGzscfoz7ir8JOQr21hCs=;
 b=Ay/NMfME7KOHzNhK6uBw84TvLQ+f/ILqEH1KiXBb8b+9CEqo1M+V4vs1jzO6xJYoPIhACJwjNkWyC+ajpUfDfzH7+2Gn620Jf4nylNGARIAEDD54yn0TZ8XSKwOEH/43+eBFQmk39MSKVj+lPmyi7Cecm8GJE7DelLdEao0XJXBtOMzk5iFG7kkxJKWK34w/J5iHUz+/QAF/CduK/fi8DX+EsKxNjl3M5b0w9FW6IH91JXtTonxcqdqHCSERHa3Dmeoo50ZFT+DojpJl0Eh0H4r2NjP4ltPGVsUacQ+E9RlEylneV+3lmUbYr7k+wt9Ha9ISEgCQbDvtlsKpjeST1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gQYw5sV+9xITwk9YAqAawLpGzscfoz7ir8JOQr21hCs=;
 b=PZ3JF0sJDwJ2UHJAu/s61HPxgyiZ5Rl4NGxEG1PRXKqYPFNygHkUEpGIMb/7xAnHPErqnlHRMdfcM5Y6zv0UWxTgNcW9OEY38yX1wb9BRsquNI8j//i2TIeuEY+eWSzctPC+JQpjVDYoLPD3/9ePUL7V+Xr4treqI83LwO3khcU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW3PR13MB4153.namprd13.prod.outlook.com (2603:10b6:303:5c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.30; Wed, 29 Mar
 2023 17:52:33 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%4]) with mapi id 15.20.6222.028; Wed, 29 Mar 2023
 17:52:33 +0000
Date:   Wed, 29 Mar 2023 19:52:27 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>
Cc:     marcel@holtmann.org, johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Re: [PATCH v2] Bluetooth: 6LoWPAN: Add missing check for
 skb_clone
Message-ID: <ZCR62737I2hEPoCK@corigine.com>
References: <20230329020810.32959-1-jiasheng@iscas.ac.cn>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230329020810.32959-1-jiasheng@iscas.ac.cn>
X-ClientProxiedBy: AM9P250CA0001.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:21c::6) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW3PR13MB4153:EE_
X-MS-Office365-Filtering-Correlation-Id: ba202f02-c64a-4f9d-35b6-08db307e5f9a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6FgGRb1e88/eM+uQNb56oCmfwnen0x6loctoaIGmTbsaogYVCharnK0qpA7DbtThl5rSPP5RCmGPH0QwzzcjN4AOd5Q/XICKJ8jDt3Zg89ggI9UgXq+aUBP39Ix+2Eyn8vRcJA2k8xluntL4JovmGScRcQCXybGZ0NRezKsYNAIeGIgtbZR7FIR8z/BVWsjBRZIUTqSu8KcPfl2KdyGX8qIzLF7Hg/G2gaNFJj/WqP1tDNqcttwONRSTrGlt7lU9eTg8jFb5bohUmdi6U3+Bs1ztBoKQqwJ1PIocO5vPljPygR2F52cTSZ091GgEWrmNAv42LfT9Rw3uSGynqGm40hbDZHPlCIBzu7dTbV1N9HtDOh00ZgGNu1ZwCQ8/LuxwS2fA6Kxe3PvYJNkx4rdNO4Doz/PvTanntAr+kN1jcJj4Wf3ek03EHz6trDgQ6trGiJA5Is7k8wZpiYMMNBrlAel4w5MZF3xcjhKeiyYKXSPBXiGmDiV/AidxJ80sV4RbQ24YCSo6Sx1TeBrxLNmalq9Fp8TFrMi3W5hH3lpikxZKnIUDckdbY2F77qEPic11gMQDqbeDKby5BwAvNCMv7n0/oi2MAnMxxaUwhtphROw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(366004)(136003)(39840400004)(376002)(451199021)(6506007)(6512007)(316002)(6486002)(4326008)(6666004)(186003)(66946007)(6916009)(66476007)(8676002)(66556008)(478600001)(41300700001)(7416002)(5660300002)(44832011)(38100700002)(2906002)(36756003)(83380400001)(2616005)(86362001)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8XcidRTpivgH3gj2IeWyVr3wdRY6an3CICqCkJ869pR2CZUfojU6ti9Yjgao?=
 =?us-ascii?Q?iryuLpaeSZdP04UqBHxBhw7CIhOhdKI3ME8bDa23Og/fKUw+NPidNdhoS3Ep?=
 =?us-ascii?Q?Pxz9jSvDHeXP2w4PaIbmgp/ZMLfT9UFUVK2W4PzJLYS/NNkoQTNrHItnWr0+?=
 =?us-ascii?Q?yjIIwn7O/si2/uwRBK4841KLcz+s39MujpN6UYpuDaiYincshY0QpluRa/3y?=
 =?us-ascii?Q?ZwLHdd4ryeOt7U1RJ1wSFNKFNYTBzOxAj4NFHa7v5Gt/bQnw/xe0ZygoNtAA?=
 =?us-ascii?Q?uGogUFQZsSRGpM9+zQMftrIqlVFYsa4WzBs5c/OBpmTQaUqcybgXAiYey5mu?=
 =?us-ascii?Q?X7VPfGpnZFhtQ32mhfmU5IM+JcOP+u/ZbVzi+M051k8xKj9K7yp/ro/Lb47v?=
 =?us-ascii?Q?sGVjE2L64PXkEjv6cLmUFnVtkWvoVyxtsNaRM/3ydLP1WihzCuAZvoDZ6vMh?=
 =?us-ascii?Q?xI966JvucCZTQzSm07/wIcRJh7mUi8o/07DNHcBCwd0UxSWqp7hM8Nxy7w3a?=
 =?us-ascii?Q?Ct0A8ZuH7vp5zL1iPNJI0bOvFPeSp4lHWuyLrai17Ysy1QHXIc5VK90z4xFC?=
 =?us-ascii?Q?0Qnm74cClut1ojcL3akgwx+hk0AvSfikUurm5XhJJtZV6cTm7EFNdyPB1+aJ?=
 =?us-ascii?Q?24z7TJGGzSVR6c+dsMjQ9B8F9n+s28qINFpq1v8PQtdiZAiNUOcrno+A+CbW?=
 =?us-ascii?Q?Xyr/5gpe/QaOXgrvbvIjTYRpQzoTB5Y5pvWLvyDNZDW6ouZer+Fenv+zKzwJ?=
 =?us-ascii?Q?yjcKPqniYLxayYVAn1c+nEs1Z1soDRTvFg+13h8k4j6sIwY/RKq7jeLIk+D/?=
 =?us-ascii?Q?U+kIcsWMu+OvPVwdXAHRn7aMnVgzWp8O1Y5AqVJ7alekRM0qgLmg81VOPwNS?=
 =?us-ascii?Q?pz9OoyMC/W7rSJBJSOT1WoDCu6Cyv0hhrCWY7lHZP69zy1QVJS9nIFWtC7As?=
 =?us-ascii?Q?WXNKRRNIqYrOg/XTmH2BBaAQivdupD0BTVUr1/vmT2gjpFepM0KomiATqzUy?=
 =?us-ascii?Q?loR+Fivuv+/AnOCMN5dFUg6/NotTcqaqFrU3E375zGbMBg5zMLBkb6B0Fw33?=
 =?us-ascii?Q?ufJDeQLF+1cansa0ZJkqMMl7MvH+cvX9sx6ltBcIr8vrGfW/JxEKOLmGKI++?=
 =?us-ascii?Q?vP/KsJz0u8JxW8FoUSn2kh2AdjsUEQ0x4kdTmlJxaE0P5x3a8FSU/a4p78op?=
 =?us-ascii?Q?8jRMJplQ2mb3TAHBtuotWIjkAeikkwUPv0lJAciUl6LlxE2GMGUOGoTNR2hH?=
 =?us-ascii?Q?Ce/m862UogXnPrYdXlFoatn4b0gDIRejA2x6o5b7JMmkaeaPFWsRCsshFhos?=
 =?us-ascii?Q?nnRGZk+XZe3znCE1cqvhjRKW7jzDx4o+VdEhHi9jgOBuCZBENUNI0zUNj15F?=
 =?us-ascii?Q?jTIy9ogKypANgRH91IIKef8LWAiFHljkSv7PLUtgU3RkH5n144z6zBBDmbv5?=
 =?us-ascii?Q?V0RoTp50GFhWmqQXlINGkCnBmbIkw38rwhUPUF2El5C3eRIn/15Eu8uWPzUy?=
 =?us-ascii?Q?HJ7N0IM0802R6bVMPJUvOFJBxhfjQ6Z/Z24Z3peLXfK6tg54tcuJumeRcLyL?=
 =?us-ascii?Q?PUi/kjjSZNR51bpO5bFt+UGdUL7vDRtNPL32amGddgvUZxALb2xaHsh0ShGI?=
 =?us-ascii?Q?VGRpwvtKdvkWzAd4Jci4qT0cgR/YVDoCtsHKxvWJB/HJeSvpssyFvJDd3ayC?=
 =?us-ascii?Q?zOGV/A=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba202f02-c64a-4f9d-35b6-08db307e5f9a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2023 17:52:33.2771
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nhc35eE4RQQpiwSNOnY+bvSEgadZZbQhuZgZE3hpRpV+vIz8/l9UbVwy+V8zUouuOIw46IKfiUqzpvcAzFTsUnEYpB6uDaShSgge9oPywcE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR13MB4153
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 29, 2023 at 10:08:10AM +0800, Jiasheng Jiang wrote:
> On Tue, Mar 21, 2023 at 00:09:11AM +0800, Simon Horman wrote:
> >On Mon, Mar 20, 2023 at 02:31:55PM +0800, Jiasheng Jiang wrote:
> >> Return the error when send_pkt fails in order to avoid the error being
> >> overwritten.
> >> Moreover, remove the redundant 'ret'.
> >> 
> >> Fixes: 9c238ca8ec79 ("Bluetooth: 6lowpan: Check transmit errors for multicast packets")
> >> Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
> > 
> > I see that the error handling is imperfect - only the most recent
> > error value is returned.
> > 
> > But I think this patch introduces a behavioural change: if
> > an error occurs then no attempt is made to send the
> > multicast packet to devices that follow in the list of peers.
> > 
> > If so, I'd want to be sure that behaviour is desirable.
> 
> I think it's a matter of trade-offs.
> The original error handling can complete the remaining correct tasks.
> However, my patch can avoid resource waste, because if the an
> error occurs, the rest is likely to go wrong.
> For example, if a memory allocation fails because of the insufficient
> memory, the next memory allocation will likely fails too.

I see your point.

> Maybe it is better to use different error handlings depending on the
> type of errors:
> Immediately return "ENOMEM" errors and continue execute if the other errors occur.

Yes, that might be interesting if we can clearly
differentiate between the two types of errors.
Yet, it brings complexity.

Given your explanation, perhaps the best idea is the implementation
provided by this patch.
