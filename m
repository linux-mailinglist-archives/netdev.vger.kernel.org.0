Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF0746473FC
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 17:13:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230115AbiLHQNt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 11:13:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229807AbiLHQNs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 11:13:48 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2109.outbound.protection.outlook.com [40.107.96.109])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B236AD30D;
        Thu,  8 Dec 2022 08:13:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ACJUuB5fR74Ino1EBhSm34LutQY0tBgJXB7pJf1zDYIsAjQsci2PL8pOq89qyXYsfXAU3pKEF9P7kW9YUimclFTK1gsisOTbiVtpNDMhy/azkf7RcZ4fsu9hsSsfc/fFtrcwQ5mIqHbDpea0aDIl5r4Y77zaKlmfLYsx/YfMDGfK99pi0DjWdVlq6jYAA9v9Qnp439V064O5l3uaeiBilUSBPaUkAWVO9cpbZd7JwMiveA0zCWV+cBTKv+WKdsETE+vm5uEYpjAo1OlHgR22AkGtbsuLiE8sfo6WTmITJuVmEJKDdUwodWKN/3XElfliECQpTyANPh9uX3013HZx2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JIWDD314JO/g8OHDMEjvf5W4VfdicIHFpHuQGaI5YBY=;
 b=UFkEBSzCAbbEsxD1UYBsdZCAJ4FjnRWtS0diRPwlQfoMbZgTt+vxP37GQZLcoxHZAV/1dEriOR062ed8dGac1ECi+vWmYPZ1Zi5iLWAlFxsW1NVjjAnSFMU54aNi6s3+5CnIUPrlK8KbI7zsfy2HBl5Xu20UE09ZkAlKrqKc4z+zByBZAE6e+vIXJrFtb+t8mw9fDXJ1XaCjFxRUtBGkb+iXTOOxnqW7+jyT+cWVagLGMtdqsfKbdG09PLoVbEKTTd/YGb8OY/QkOUwz1mzdtPHdYRkxozcXe8YZPqbTV/8pHWvQxjPEhhPX8juHh0ew7wvcLt5JMJtl9ERy/mD6HA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JIWDD314JO/g8OHDMEjvf5W4VfdicIHFpHuQGaI5YBY=;
 b=C7yvzyN0+yERnRNNQoDrO5kq8yUHE9qWXcBlaEz1ISbTPpLd25fl8Zl7DKrohLODMmbT3I7B0GgDbQiJ0MM5EwQw9CKAvVNAQ+1dJRoEmo2pPd/lVrBawNAFH47nx9wZ1j3b33XvCJJcR5pK4zKOuYCf40BRTXVpQJ+Th1uqcXk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MN2PR13MB3694.namprd13.prod.outlook.com (2603:10b6:208:1e5::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Thu, 8 Dec
 2022 16:13:42 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::483b:9e84:fadc:da30]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::483b:9e84:fadc:da30%9]) with mapi id 15.20.5880.014; Thu, 8 Dec 2022
 16:13:42 +0000
Date:   Thu, 8 Dec 2022 17:13:36 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     yang.yang29@zte.com.cn
Cc:     christopher.lee@cspi.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, xu.panda@zte.com.cn
Subject: Re: [PATCH linux-next] net: =?utf-8?Q?ethe?=
 =?utf-8?Q?rnet=3A_use_strscpy=28=29_to_instead_of_strncpy=28=29=C2=A0?=
Message-ID: <Y5INMK4YaZAT2syD@corigine.com>
References: <202212081952034833496@zte.com.cn>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202212081952034833496@zte.com.cn>
X-ClientProxiedBy: AM3PR07CA0105.eurprd07.prod.outlook.com
 (2603:10a6:207:7::15) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MN2PR13MB3694:EE_
X-MS-Office365-Filtering-Correlation-Id: d08fa7d0-9de6-4371-ba4a-08dad9372c9d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EizKCwbkd2KnMBH18IuGJs5uMejPZJnLpzq8v0ZoKb0LEm8o3KUuUuFF+YgDnyDbWbb8DAnOXxAd1mM9InqqGBKrViYkDH30jDSAyrZ4o+YWUr3u1kX/n6B087ypH6sOnui8i2VLdhM0QN4DnoUrwBSCYvv2+drvDK2OMK6meE3mFVCdYmsolF741Ev/Dtz5dbpYgnoRdYirfFEqCd4EDNT+m1XhtzWtPvQi8vnFsbyiYXTOjibVL1Mq/B2BYDYux2h8LGQHNRtw0m53M3etE0d6OxapUhE5kaPkpXFTw6SEMJlWG69nWt6/g3Uboy4exrQUud4YL1R82/kfRTjOO3ILjAlaNsBCMb17QrnhWjzatul+vRck+mSwJN/IXzuyXpaC1e89GhV1dBUB5c1TbDrY2/VrMul0GpbbohtLNxc5BheYPDqfv9xCYVA6noxv91JK2YOIRbJpLv7AAseMMKDEENY6GMSRuVVIXcT50+RVO0HpN40l7Ym6fxR8VqRjpoiWsAQmWjURUJ/q7UIDna8AJ9rKJgCTTe+VrPaVcrAwNrYlSi58vEAYzVIiIfL14xM3sskQBD3qXYH4nEVOb9DwrcX6eTm202gvyWqZ3knMH76iPgBvfKY6MTrBWuOZDWECrhvkNCKJm6rxoMuVLPaTDsNVR4BvmadoFgeISCbA26plAkduz6MHLx0t/W/4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39840400004)(396003)(346002)(366004)(376002)(451199015)(44832011)(86362001)(8936002)(2906002)(5660300002)(41300700001)(4744005)(4326008)(478600001)(186003)(6506007)(6512007)(6666004)(2616005)(66946007)(38100700002)(66556008)(6916009)(6486002)(66476007)(316002)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bHPPWsGne9Ixmclqe5cOzwGpVB7S93aGYVVjgj+WTIhUfSJg9mq2cI28iCzZ?=
 =?us-ascii?Q?RGDnmMskVvt/P32iPilo2PZ0CBISRU7hjVAJFJAhc+kAj9Vm+OMMsHrh6vPh?=
 =?us-ascii?Q?cBkH2CZ5LgDRcNpQ+oPSqttvsNS3tzboRIlI6fGY2hM3znp6HG8Efno2wySd?=
 =?us-ascii?Q?1gmVfBPm5dvfAa/5rplhZrpv+Kvon91I7KbjIPAuXy9YbN7yCJUcSOrzjvc9?=
 =?us-ascii?Q?O+tjqCw+TVE9gS9BWD0YDStmOQC5CaxrdSpTHjTWprCwxci8aqkT6dBNSsug?=
 =?us-ascii?Q?ueICidA7yXGUMRp02Oct4hxafiKek/v6BxSs4GxWHxwnIVARELz+PgSRVjHr?=
 =?us-ascii?Q?spGOE4VMAEFXJxizXJZdAESdTm1S5GMQQNI5T1xO/8OGKfirN3BGYTk9it0d?=
 =?us-ascii?Q?Ic2/Dm9puLc0Nauob1xJ79np6jVJjiUlfnqIR19kbtxXn2ICfzJTxhH6KSKI?=
 =?us-ascii?Q?cumFjhkdISba8+KCiyH6r+6JA0NUxYQoWRapGULtF/OjLR0oE0YxYa9oyhy8?=
 =?us-ascii?Q?MNLYqfl5vkUgl0F2aEc6DkK4vk644k35VJVUNqMeGCPRRvc8ilTiZWVFfb9J?=
 =?us-ascii?Q?qwf1eR4CpYWzYhu64e/hd8zA47xiQ+2lY2wzNL6/abBgkYZeMJCK2gi8adY/?=
 =?us-ascii?Q?86KXK4TptSPFBV8UkBRE8NjcftpvBVa+Y+zvkTxnFkgrsNsujcT/cburRC0m?=
 =?us-ascii?Q?CnQt4nK5UvC1n7XeX21MlxjASp2QFReuX238RqwhRVYBHtohQVNeIpsPVOgp?=
 =?us-ascii?Q?6TjIN0eA/6GC9UXhUVwDi4EACFjeVWOjjD04FPTPGG5bgdbFGFfy7mbuL0zv?=
 =?us-ascii?Q?Njbd5wtzj+8j1IKkHdZacPjV6h/IzUVucY2ySJGUNMtM46jVHd7wgvuzX5JE?=
 =?us-ascii?Q?SBT41Yah7bLu0US89HZDRpz3ELurAPZpYTZcSpiixKsuUzwCQsMxy7rgVFcZ?=
 =?us-ascii?Q?Ne+a5htrY7GWm0o7xDSqQkn0wXZBNq+I4sQ37Jb6A/xn+4KUsW7zaS0i/vh7?=
 =?us-ascii?Q?1d7/RAl4fgAADiqtqshRCvXP5MhOCOqDgVa4LfXHg8mMM+1HIU4pTgDOqpBt?=
 =?us-ascii?Q?8QJN2L4EIzl4GPF0pdXRKOTLCcIws8MOh6hTHWHByRgX7w/catgH9xWedql3?=
 =?us-ascii?Q?HdfuXvXFOQHyPYXI3l4DROy8KLbyL8LTPQx+qN0ikGnwllu0RI8BO1iLkO/B?=
 =?us-ascii?Q?phFReO/e4+vlZ023TaB1znkU+XgQxPowc8l0tNY6mU42hoTDFs8jVxuEtom7?=
 =?us-ascii?Q?IKq74T59vZmlPTX49T5Kp80AvgQSBkQPp0CSNX+pO/NRTFYHmEJ/F/O8Y3hI?=
 =?us-ascii?Q?FAkd4sB/LfcQ07+Sh18ZtkecOG4OPVeV3ikz0oYJu1m3ud/FzJrPes9NLll7?=
 =?us-ascii?Q?XT4XvWH8OOHkO20CP0xcqG7Zp5ab1cqq/8GJ0Sc8DLSIK2ZZ2tGzbj6Z9OIa?=
 =?us-ascii?Q?P+F6kKyuFEl5HQ/A/DjnxS0rIa7f9FCPhbgOzgiynuyXCpmO/mJPRCujADUH?=
 =?us-ascii?Q?/T/siDwJnJ0NxRwgtsdGAx4Yh80kCsEM1F93KkYvJAa9rFp0IfrIpqNo0AaX?=
 =?us-ascii?Q?TGeD3FyWMbFqpQthdI5T4elwWjULyiaAlF8/b+mKbGVMtcFfy10wJeG03/VC?=
 =?us-ascii?Q?/lLohY224FksWfYZFDhr/4MEuEhzSiSA+uR82pN2iURFqZxQZmuPv82gXPsm?=
 =?us-ascii?Q?O2jEhA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d08fa7d0-9de6-4371-ba4a-08dad9372c9d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2022 16:13:42.3184
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wbAxVwJgrap0Uck1kvUXtK2NKNOV91lMj1oUcaeNSCi5WeXugqVmgpjUcCuNvMQWapDyS9OrsfGKCVhtabRgfm983v9+G0f41OQaIAk9hBA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR13MB3694
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 08, 2022 at 07:52:03PM +0800, yang.yang29@zte.com.cn wrote:
> From: Xu Panda <xu.panda@zte.com.cn>
> 
> The implementation of strscpy() is more robust and safer.
> That's now the recommended way to copy NUL terminated strings.
> 
> Signed-off-by: Xu Panda <xu.panda@zte.com.cn>
> Signed-off-by: Yang Yang <yang.yang29@zte.com>

This change looks good to me, but I think the subject should be:

  [PATCH net-next] myri10ge: use strscpy() to instead of strncpy()

That not withstanding,

Reviewed-by: Simon Horman <simon.horman@corigine.com>
