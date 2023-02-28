Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF7FC6A577A
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 12:07:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231397AbjB1LHN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 06:07:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231370AbjB1LHK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 06:07:10 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on20704.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eaa::704])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 594A93ABE;
        Tue, 28 Feb 2023 03:07:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xafpwj9w2kMuhpDXceESyvUpMnH9YcXeLxBjer5L746NwWLRhW/PUFb7+7UfS/IaGVz4+bxsZb+fkzS0eAemUM/zbkuyfbTaSkqhsFiRnhOY6DafGJapjckWUoSW6uARXHCPgnuY9z89tPG1qjz0p0hXs7jOeKPeKhCRRTRtoWSS4i/VDzyqf7xbPeLEjQGrXoIFYPfpX9ePnf3M4tYlTBnI+RNCTWkGAru1ig60TINn2JFQYUUj83HEphTKfE2zNmBtYggTdLnRcqJnEZl7P1LuMUqXKMW5Pv9yhuBcSa3lQrulUoq6qCX2B0gBlzGgF1CGx3Ae29amqRNYFVQtEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NG1ywQoSlO86h4Q1huOevlfor7ETKWJN1TTyQBt3Nns=;
 b=dF4rkmwbRXQRtQOchGM+dKSVh9XDVf6kNkIDSuyOWuAivgh5oGlI0uefoArMoCz13YS02OT85kDic1Fqv6fmlqcVp73iBG/z4nCfh9rAuniszCxxYqcfxJhuDtcR+zq74DAIWTGqnnVeJtqvboHyygXrTj3DzBhbWVP+2paQQudw5/oQQtimHnEB8ioumgbfXbKqrmmbEliecqmtiOV7kVkYxjEiw8G3fba23aPBxlYPMrc1ZAc8suQVJ15S/BhzBv7ACgrErpv3oGgodeEIfEOokJKguSOL6EJsrWmupZYfU+frcDGuiAqbTDcFAE6Bh7McWWn2mQ13ZRkHvIVLoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NG1ywQoSlO86h4Q1huOevlfor7ETKWJN1TTyQBt3Nns=;
 b=hhUhk4pfhbaXu9dSbDMQ/wVYgLb4Wy52VqvOX8mBHKmovyAHJshyogiaSNvayJdWuB0AnB97P0vG0VpSKASNS5GNnYnJXEgZXkjsQD63k8L1okqUQsBwI70ge8n2pvHkmvS3dR29ouyKidp4bD1getqPRlVs9M2R1yJx+GqhjMY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB3831.namprd13.prod.outlook.com (2603:10b6:610:a3::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.27; Tue, 28 Feb
 2023 11:07:05 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6134.030; Tue, 28 Feb 2023
 11:07:05 +0000
Date:   Tue, 28 Feb 2023 12:06:58 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     pkshih@realtek.com, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>
Subject: Re: [PATCH] rtlwifi: rtl8192se: Remove the unused variable
 bcntime_cfg
Message-ID: <Y/3gUquaPNlaLaKt@corigine.com>
References: <20230228021132.88910-1-jiapeng.chong@linux.alibaba.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230228021132.88910-1-jiapeng.chong@linux.alibaba.com>
X-ClientProxiedBy: AS4P195CA0040.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:65a::28) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH2PR13MB3831:EE_
X-MS-Office365-Filtering-Correlation-Id: 172e84bd-92e0-4e50-47dc-08db197beced
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bLzXbb2Zhz7jLJILpQgh4xZ1pbdHuBf+sY0PFVq1UBJ4UXtoYJDI0GKtVzIaPyYQw0Ghf+Ge4bPY9u2ldlhcF8SQojRdfH3j/GK63BwZP35KByvB2waEbLpjLd4YofvIS/r8X2pEH5Wgku4WGYZ680TLoAF7TmPSQx88PMD9M8zKC/aq7UUggZerzv4UtsWfT3+qfnRClfdQRLk17rdUb56WkjO4Vvm23vfIzbUp9QHpc7WPk94bQ0PLfDx7YJaUTjdNPi14wAhiRivg0xoVa97wwqUlC1PJGFijqFNcNtridLOLvIvkjH4F0YxkFP6mBPxQaDsBLuwaA0Fv13kwE6LJ1Q3+BssazzZvqwtPN2Iya5ARpLvSpYGNMZ1GOMrz1Cj9MUoL5DO/figIVVlYc4lG+OtLjr5epL5w6JfIGYmrMMgYN7pD+KrO7iHfCjUqS2RzoQqijCGk/s407zOuY68A25ULLmL4gSkXRBc32jWDbBk80g0TvFvH23kpEIty4iHcJjt45Alu2u9eoudEpLvfKlfcXP6kBWT0PIzB2m17aEyGc1XF3AJ4fQOpqG0wvPedZPmikAvX96nxeiHfiDSCxqSPmkX6TFPtrwm6gthKn87aCFBTbu7xl5EPLmt5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(346002)(136003)(396003)(366004)(39840400004)(451199018)(2616005)(478600001)(83380400001)(86362001)(8936002)(6666004)(316002)(6486002)(186003)(966005)(44832011)(38100700002)(6506007)(6512007)(4744005)(66476007)(41300700001)(8676002)(2906002)(36756003)(66556008)(6916009)(7416002)(66946007)(5660300002)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xSXpNVs0kAhX9pp/6OIar0Rw867T8kX0qmhulSU5MAqTyKIZx8RDPVSEJyNH?=
 =?us-ascii?Q?zRF0TVo0tl5Agm7SfT+wcbKJTn83dgaYkHnHmSM4ipGDCHhg1q4CoXMVXoLq?=
 =?us-ascii?Q?vtOdQR5eBgZjcsDmySzK+PSW8SirH1GccxJ4/1Hcz6Y+XcLCmx50KRUIzxdB?=
 =?us-ascii?Q?3tzIQN9cOrGlU0kQjeD45Hsmy+9OSuLb0ufC10obx/r5/IJ0Q8Wv4fryZeHY?=
 =?us-ascii?Q?a3uPjFEugKn6tbvnqZ2i3TqrR2bYVErwxaVMVa7RvMW6bUnvdmHTGD3x4M7a?=
 =?us-ascii?Q?BetDj8/y6gmTX/oJBiF7j+6gk6fFkVrAHCWO4azpSMKT4a2K54h+0GZjNf+L?=
 =?us-ascii?Q?NPnqOK1oVFHcurAJxyeIxojktCmi4R5UA0VBcvKo0bBK/WSnjHQ8rjhjCuh6?=
 =?us-ascii?Q?tXUOqxHicVl2EhOkHWxd7yG2l2qczjX35yJaScFG9F4yEzh6ZYT4B+9NpZjX?=
 =?us-ascii?Q?BkAaOuwwk2bTl2GXpiYs2wJdJnbrg+Uy82NJf6R5UQCBHw5dpW9JjAAsTGh9?=
 =?us-ascii?Q?2yo5a3Ar/hUx9oP9R3cMGfxuvdcw4cXrhgq4tRezzMedwHTMHH9075QlqQ3F?=
 =?us-ascii?Q?0Kt6nbsllxUq9XmL208CLFs9Za+1qCLI2UsVXHZDNPXhogStPxAIKjB4jlJs?=
 =?us-ascii?Q?A3906zw3hamLLYMmbBPBU8Zx+U6jKJyhLe2NM7ITOxrd8VMbhbpiKuES9wpv?=
 =?us-ascii?Q?C1BKwDn400m7yAQBwzk9kYm88h4cvtpawmmoJkKbkJkMZUqbzj/DZT1c/zci?=
 =?us-ascii?Q?MmD2D6jqwpjyQyEPa/ZRGXi1wDSSClVYg5++4kKap0Ib1iOzkTcsYZk4PVI6?=
 =?us-ascii?Q?j/dHlneZZHq67l4TyN02xk8arX2xoqMoaQxTAKHQig02A8qk2m4skIvhxLNm?=
 =?us-ascii?Q?Nb5va6WSigsQMToz2tnSe8WXukr92GJvfygwQu8kB22cfqhYTmB2o76Nlt5F?=
 =?us-ascii?Q?Ly+EUmbMLUGF9huT7X00BvklIi4E7HbTT4WgJG9Z1fiu3CTKOmXsWbNdAQNS?=
 =?us-ascii?Q?E6u+4BAMtJVeSJBXS5R0mHujoaG0c3BUALYu5m1dQVjBhIWkCxSOgxboJGwm?=
 =?us-ascii?Q?dqFnW5fEySHW+lxnM4VP0GM0esQbiG+sLxtyjf7HRw5QyGF3xDUrsGAqNprz?=
 =?us-ascii?Q?kCT/0wi7CLK1BOVzdm9ah9Btw2RqfF+96vTWqLI9QLnBz4oKpO9bJtvYvXIy?=
 =?us-ascii?Q?FQT0aDwhR+9ySWKyZJVYerQOkWWwsQHjxEAT+cf50U4TR6pxpcj3QzOcbztC?=
 =?us-ascii?Q?ULHtGx/vcNrMuMzNSKjDiQKjqie5SoeEO2+sjikub+o9Yyvnqfhqd8R8EVFt?=
 =?us-ascii?Q?OykkNEAZSgimNK+Qmpf0QyFbq6k+SYvoP1ol4JnvYdR4Y7CT4XJ+aRWsJSOS?=
 =?us-ascii?Q?ZDJAFJtFljdgY3yLMRcUjeuOrIcWe8UW4riHm9iPPBpbs5WR1fQzjVjApsT8?=
 =?us-ascii?Q?LOMb4dbkcu7rxTJHicypJqC9ykc1DeDtrjqS+gIQO5m3s9G1dL9szF7txvab?=
 =?us-ascii?Q?CUIYpM3ZIHPpg7GiSOsbysdE6V8uG2ew5LywJYAFJTHKo8Dm9qK0910WHpNN?=
 =?us-ascii?Q?2KE+0GSuVgL8wmQyUt2tQAXGyPznKa+3wMX841eq/uTgJclUK2KZhBzXsZ5r?=
 =?us-ascii?Q?JottzWMQt5IYe9HHvkxfPzkG3ioDdOloLYwb/ty06ADA/lUq3aS8BOdOGZ+8?=
 =?us-ascii?Q?dxwY8g=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 172e84bd-92e0-4e50-47dc-08db197beced
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2023 11:07:05.1577
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jPGT0cRDHEu0lHxrOA/AozMheFDLLYEvNZxS3nPIC7jSzuuBpjjfbdrZ8sAEvZs6ykDjqGCZ90L/LswKYOniSQ5Uf3mgezOER/kH/2dsafc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB3831
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 28, 2023 at 10:11:32AM +0800, Jiapeng Chong wrote:
> Variable bcntime_cfg is not effectively used, so delete it.
> 
> drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c:1555:6: warning: variable 'bcntime_cfg' set but not used.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=4240
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

Hi Jiapeng Chong,

this looks good to me.

Reviewed-by: Simon Horman <simon.horman@corigine.com>

While reviewing this gcc 12.2.0 told me:

drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c:1555:25: error: unused variable 'bcn_ifs' [-Werror=unused-variable]
 1555 |         u16 bcn_cw = 6, bcn_ifs = 0xf;
      |                         ^~~~~~~
drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c:1555:13: error: unused variable 'bcn_cw' [-Werror=unused-variable]
 1555 |         u16 bcn_cw = 6, bcn_ifs = 0xf;
      |             ^~~~~~

So perhaps you could consider sending another patch to remove them too.
