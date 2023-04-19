Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0719E6E76CE
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 11:54:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232699AbjDSJyb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 05:54:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232576AbjDSJy3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 05:54:29 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2093.outbound.protection.outlook.com [40.107.220.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 836115FFD;
        Wed, 19 Apr 2023 02:54:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FANYZL0xuFO6MQeLFsSDQE9A1EwQ3xC3/d85IfuVc2NG8IRVu9/wNcLZsZFvRs2u6o1LEj2ul68d5Fzgb349OwMSW2h8NsVYT32F47CVxVaRwRfIEat4qRBlxvqMil5DtvSSMZXuqp/Gd1f57vb68LtXwfp2HnVkiaBCtR02WwQjfeeIQJPnPwDMzLZgjGq0CPFa/IOivgaXrvGOnYyEn+ph1V5Ku2iWQzCpURNDX/ivGj3A91yT8U2OfgNqWnwOnonJpXeKZcg0vFHOCU4oFUXRGJkEtBinqzMw3MgNxn8se4i9Q7ecq7W4QdW07KhnZkEU3Au6T17sYn9qJIPozg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jDIyhJv4oN54CwCJK5EeyxdvB6edyIVyGB30CoRzA4o=;
 b=TIT1VTk+RrZitgnGLH8ZJy1pCe8aZB0X+1wdNv33AWfUd9JZImyMXHpHI0zdvWSv9GJBn6xAL+JfxH+I1WDLDoU7Vp1tlBXrTj9PKt6/uKfNRZ0vvcuhjgecGWau71eGb74ZRecgtE/ogcFJXmTLTzH6N/oX+e/N2FcTk4q1+8XqO3Q3Ws6QnwhLp1EYL/OWUQHT+qxLSwkAw7pH4VCw0fIG33jRkQ2LJZFeyJc+1jZfPYmNUtVLTwnrHcLYWXICNidlLQbN6CcmkeOQ6jHzFDO9ilsH+AUSQrw4gac7W08c2SZHs9b8nQlIKkUctACR0wXGInwl9MfLbHx4fWuScQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jDIyhJv4oN54CwCJK5EeyxdvB6edyIVyGB30CoRzA4o=;
 b=qAuf7gyr9NgVRHJjo9OCu/Tm3chxyYKq3RBtS9jSx9ydToFl0245xUQN7M9/ZNSP+h5ID47yLBvWOmlQBGF6kN74yu3R15wUxtQcA1IZI5Dk27icmbiB4Sd03N0rfiAHbYhQbnWW++lJi2ToNZAnV42/NO/RSAQF2lspKoQLb4M=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH0PR13MB5132.namprd13.prod.outlook.com (2603:10b6:610:101::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Wed, 19 Apr
 2023 09:54:24 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%4]) with mapi id 15.20.6319.022; Wed, 19 Apr 2023
 09:54:24 +0000
Date:   Wed, 19 Apr 2023 11:54:16 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Sai Krishna <saikrishnag@marvell.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, leon@kernel.org,
        sgoutham@marvell.com, gakula@marvell.com, lcherian@marvell.com,
        jerinj@marvell.com, hkelam@marvell.com, sbhatta@marvell.com,
        Ratheesh Kannoth <rkannoth@marvell.com>
Subject: Re: [net PATCH v3 03/10] octeontx2-af: Fix depth of cam and mem
 table.
Message-ID: <ZD+6SOCYdXNG02s5@corigine.com>
References: <20230419062018.286136-1-saikrishnag@marvell.com>
 <20230419062018.286136-4-saikrishnag@marvell.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230419062018.286136-4-saikrishnag@marvell.com>
X-ClientProxiedBy: AM0PR03CA0022.eurprd03.prod.outlook.com
 (2603:10a6:208:14::35) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH0PR13MB5132:EE_
X-MS-Office365-Filtering-Correlation-Id: 772eaef7-2f5a-467a-7422-08db40bc0e01
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: m/qW7a+JZdUKfcaez9GQKA/Qdf9+UQx15ay8je6jwBzQRtn857pQEyzRZ1olrCRoPTa0OEYUAiEif60gBUwUOQ6jUi+WKD2D93M8rNYhkXJPVmz1mG+57C8X96IXWdCyIJ3pldd+ofS07MbOui0IjTj1OV6h5He/Uw2SiC3etNC3DF07tZ7Kmkus+85VavTjvVXL4OptP0ZCCXKU8bByFPndyul18EF7OPlpFU3pFONYSH3AzhcWwYUf20rcYcLsXee+m+T3HktWw1FX/cBx+74wbkTuFkzZc1jaD8gT0W2yuyVQIL3D5bpwEBsoRsP0wQr5+TtyT3gaIzNuup6uKDwFC6Cfnnb5lHnh9CAdfZRLkJ99x8nuZZKrl+i4wC8d56z3dCrcdopcCMEQPUXiZp38SAK/UXsuEKOQyuV18bugwvY3gAh3zNYbX4e9DGsaDvnxeOdeHgjOueKCkRPNIlutUk9wOG/MzBITcwgCdqgPRyKS0T1uoD29vHrZK4bKhrJ7PwfsXCYqvQyxAog8ZZ7EWaz1y5LfLzFE8QvxZO+tIjhEnpXnIwtJcmMO07rXKokwTMxaFUK58OTJzmugwmhgpCqOklonKZxpPsL2+oo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(39840400004)(346002)(376002)(136003)(366004)(451199021)(44832011)(7416002)(36756003)(2906002)(8936002)(5660300002)(4744005)(8676002)(41300700001)(86362001)(38100700002)(478600001)(2616005)(316002)(6506007)(6512007)(186003)(6666004)(6486002)(6916009)(4326008)(66476007)(66556008)(66946007)(83380400001)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?X8L4A4zzLgbp60pwb8H0NdNt1czahyca6Bkx1WdDwIjHnZPLvbdyg3q7AdNs?=
 =?us-ascii?Q?SVQDqKqolnr+cjav5n2RPvI+3rD8jSnjjd0Un95Xhsm4FdxaMPrvnCGqV6bZ?=
 =?us-ascii?Q?SEREaF0Y0zEJeHOZSB6OfP9TWQbu1nTHMS8nkNSqNCHaJQ6Vs0nok6GjJDGX?=
 =?us-ascii?Q?m8LFLJdUkJZqP/IONUt565kg1X6ZvMHKcv8kTqmYmyHI+D9BClzM9AXQdONv?=
 =?us-ascii?Q?ego8YVGscZCqs66yKBbDzdQDbUlA1vCvetCxOAqtet2Km96IZT79koKI8LJl?=
 =?us-ascii?Q?d9we+JLuoN6fkOskjntAR7qikbjBoRQsH0V++RCqCDFexFw8KCG1cceLwoKa?=
 =?us-ascii?Q?8lt+HqNoBNuevOETuZf2nUrvxZ4o4fZ+M3mXdeSSnJi6wELau6IGnkyTpIAi?=
 =?us-ascii?Q?7MF+afNdDw7QoBgllAN6L3q2MS3LqO3qukrVIHKWkyOwkA9N/XtF+ZOSVqP9?=
 =?us-ascii?Q?ztHRjxCykowAS5ic9a/gLvO4DR9Y+hbMsNBPmCJxEgGJ+nBpkjeMjYPeoFQS?=
 =?us-ascii?Q?AxUYCn+PN9WVbY65INT8yYuQXK72WnYnFQUOA2HyruMizs5F5aMgmui7SDIX?=
 =?us-ascii?Q?FKE+Iz+eJkQzPhHEDWm9jT4o96hmsuFvt+zNocpajFbAuh+A/sJDHE8c4B6V?=
 =?us-ascii?Q?UCvaSQ2TWJIktGqGWc3wf+YiMtXqM/ZUa4gf4rXfIO9gkUn+nSVyPoL1lXwj?=
 =?us-ascii?Q?vOkoOs1lAV+Btpv1oJSI4sdCRD0DGVXUlipUdMaUe8ru4n8oRq0TvUUvuBT9?=
 =?us-ascii?Q?R+Bx3Aq0ZXZV/n1QEQoTjNC5TkTf83Ea6QSxTUVYheptACpSQlulgMj4A+Vo?=
 =?us-ascii?Q?SCzTWG5SaUOjJ6Ypf/dV2btegUkJLk2FaYjq5s3NBMHWH1s7gpsa0pGA6IzH?=
 =?us-ascii?Q?1x9EGuakr977tZk1B7B9tsIfIgN1KRIfqn7SZCdXboz4eusO+uLNKcNq6Pjg?=
 =?us-ascii?Q?MlM6cwSHT1HXU2wTBLYJKxL2BUbqjmNiA6AZbt9EyzidwnyY5Y29FqIf+gOc?=
 =?us-ascii?Q?GJKGtmdETpIdIUzY1/fV+eQq5+ku/uVxx3Q+akJhbbDLVVBfzZUEoei7oZEe?=
 =?us-ascii?Q?+EbC7xwhkloqQuwnFCHo5u22FPZBpzl5gA21pg6V7Ou6vgOQc1mfw1VXN1ad?=
 =?us-ascii?Q?K28yzF4vFzpsw8ULgFJZ/bFREj8f54Fay1El4VPKN8AzB63x/bkGu2x0zFCH?=
 =?us-ascii?Q?IZT91HvmYhN3KRsfFTDjjoJSdfvTXT4wGTM3P41kah0XooD5IGobtBpZD4Ad?=
 =?us-ascii?Q?mItSmvHNk3NcO3a7d6o0p60irnN8wNpltuVDe5/YFdr1Xe8Xjq6W0XiWqDMr?=
 =?us-ascii?Q?WxUzin1U68zfDWzyK4v61Do3RACR6dA1ID53xccOOy/cIv/4tb5663s7O6M7?=
 =?us-ascii?Q?opI5cbCHMjbvriotAdXMfBh+lvxjomOwJtybuDgwkD4+qIfuYsje061Wxgpd?=
 =?us-ascii?Q?NY0p5xcQoV6LJs9DN3oBtQ6DP4CT7HOWTJP1IL+vE73BBEdoOW28WBVWQPKU?=
 =?us-ascii?Q?+K4sGoafd4Rzh+Cb0aSBAWh/vjXBVG1yMFMoit8+E8mo13SGNmX1I6aASL7M?=
 =?us-ascii?Q?21ZiJRhwQ5PHlf5MWEiCoC+dqrlkB27dIAJFCtyodCDOJs/eM3mXpjI139V5?=
 =?us-ascii?Q?iuEIxXqxP+30fYSpxKO0uplOPd0H9L2QzsrarXBT9MDA5ArcRgP/kVr/pe9e?=
 =?us-ascii?Q?rooWPA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 772eaef7-2f5a-467a-7422-08db40bc0e01
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2023 09:54:23.8683
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d1EPDQn/29ujPeab5n25R48MlS42Rc95Va/cG89c/DMfTgGjmLsx6PIXWXkgGQ0PTQ8ty1eQfwDkpdrZ9Q077PNBSsaZuwxfbnHI3j6OQoc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR13MB5132
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 19, 2023 at 11:50:11AM +0530, Sai Krishna wrote:
> From: Ratheesh Kannoth <rkannoth@marvell.com>
> 
> Depth of CAM and MEM tables were wrongly configured. Fixed
> the same in NPC module.
> 
> Fixes: b747923afff8 ("octeontx2-af: Exact match support")
> Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
> Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
> Signed-off-by: Sai Krishna <saikrishnag@marvell.com>

If there is an issue that this resolves, especially
something user-visible, it might be useful to explain what it
is - e.g. before and after. Likewise for a number of other patches
in the series.

But that notwithstanding, this looks good,
with the caveat that I can't verify that the change matches the HW.

Reviewed-by: Simon Horman <simon.horman@corigine.com>
