Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BE2968DEDB
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 18:26:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229776AbjBGR0H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 12:26:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230519AbjBGR0F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 12:26:05 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2106.outbound.protection.outlook.com [40.107.96.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF3D5126EB;
        Tue,  7 Feb 2023 09:26:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P7L4aO7DZ754z7o2edb63vU3smcVAlVrw4l1cvU/3vjLfJth7myDyDcvcmyWgATWavNeFPCBKZnze50tW2oiDWTCQOAvZZBuD17R7ZJlHB07N3U0IYCpSYWuNoZLNsU7qwCiPlf2DAT7TaNopBwtouFP3xirrigdgcJh0/CYkQRH2NFvH7vz35Be++So5r8NdBRgYsawwWexW/rUiK+aLWxA/2GUJJqEV2TZl+k1wJv23TKPSku1EXCWyA2czHB8/2vgJkwkcjOUYTx3ilkP/GS3KmamWtWwSqOIuPJcBdbkJvrafy8lZyXXyFXH55v0npx7/nWAWeAH9lIt+1izEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l+s3a/+gsf+03KekP/UgvQZWg5UnY+qCrvRjCrdfVKA=;
 b=nbHzSNIHNUJUUiDzeGLQJZZ/Zld9DTMdk4GVR452wtyi5Aw2L2b8mWPUGsYnRmLLoG2t6kzTTlEghyY0TlXDG3b+GcS+/zeIJ9bPkkIz3HhhgUCCSsjj8WoXSkoF83YU0tiaww7PifiLXivvk0aqBWJmhZQ6LRF36kuRqBEuUnAxQCZIkUGUu0Ct75nIbLEOiyfOIlr4+3NNTzuSuUjrQ6kYZNWWS8Nw9sJ9RFypWuoYmaWajg5Yq6nV83IL/eCz3bfZIu1rWQ/cvsKTE3qFEAllyWxpTNSQwCTmXg/wREs++4WcumBx/RZ/4pH/CZEo3GuJcqzg4b9IHQOA7yI3tQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l+s3a/+gsf+03KekP/UgvQZWg5UnY+qCrvRjCrdfVKA=;
 b=pbvOD13HjZGH6LoRtdcTcBbSrIONDFOAPZhlc3CPOTANQ+rjXTnilzmiWQIDc6LtlMZqnQjO+mkFg/8jFrf1uXp0DSID+Pus1H988mnjZ/RrWtAy1zhymoPek4KViUAyJRyI6L8FuJuXuPZ5K9YStAu0zVScFP+7y9BhUJ7usH0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ0PR13MB6028.namprd13.prod.outlook.com (2603:10b6:a03:3e3::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.36; Tue, 7 Feb
 2023 17:25:57 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%3]) with mapi id 15.20.6064.034; Tue, 7 Feb 2023
 17:25:57 +0000
Date:   Tue, 7 Feb 2023 18:25:49 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>
Subject: Re: [PATCH] ath10k: Remove redundant assignment to changed_flags
Message-ID: <Y+KJnbJImJGQAnoS@corigine.com>
References: <20230207052410.26337-1-jiapeng.chong@linux.alibaba.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230207052410.26337-1-jiapeng.chong@linux.alibaba.com>
X-ClientProxiedBy: AS4PR10CA0015.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:5dc::11) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SJ0PR13MB6028:EE_
X-MS-Office365-Filtering-Correlation-Id: c2ac5942-f6ee-4e75-9015-08db09305f3f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: st/w9PK4FMYor1TKRi+Xvrr/d7DCWOu/MAXwFE52i3uGRr0Dvj/LdK7RmSpXm42sP4qQ+smTLRCOwSG94/G+vNs+ZkVHLocdZc4s9DZvPN+2Ggb0iCv1S9qbznXMZfARAZX/rOtLR23xbqg9JfVxDRa2Js6nRjL2xXSedXYHkKLS9HWor87wazf3gPnER1ilC8r/PRzy68p/4ba+5z14HPocJtAjpl4HZl7TViRenau8ckQ+TObKUXPw7/jW0qQSpto1Y63wn8EJupP5gOynZee/S2Z+WM1pu6j/MB2/J5/0Sxw/4Cj1VuNrkT0thyx3ymA84FXkJIRsJHQwFWOJ/OyJYHubnispNWPpCYxolJ8fahTp5FZRLVM7bd3Y5ind3PP9GTfm1Fi7xKg+k5aT9CLozWBjN0oTG/fkDGZi6Ylbg9jAtXFBxzGDJyJN0jR6LgvgzxnYGn1FWiH/jGkKHueteLYIxExKnQ+AoQgEDWZUIlPoTw3WX8e0Xemao6XbNRLOOPgLWd5GHZdYZbLGt0wBU9PKcu1zIjMkSNIfV5m8Ztj98PEiYP5V4Lxc2ULMqlB2QuspANjfJd5sDhTGTQ1wjvVlvCnjncv0mIz/KAhxyjr47CwUTqG8J7zyoBX27MD0CPukYIJkj68VVvasGvV6r+8GEacQMY4kGHLMg1ukmkqxPemS/H7lUOjSP2zKAX1Iq2nmc5Z1Sq5y4qQ0DUdTBo08+wPghBWu2g3rq/6hq2CGvXO2R/sfgAgEYdX8OA0VXrdIL0anC2PjXB0whw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39830400003)(136003)(376002)(346002)(366004)(396003)(451199018)(6666004)(6506007)(6512007)(186003)(26005)(38100700002)(2616005)(83380400001)(6486002)(478600001)(966005)(4326008)(8676002)(316002)(66556008)(6916009)(66476007)(41300700001)(4744005)(86362001)(8936002)(7416002)(5660300002)(44832011)(36756003)(2906002)(66946007)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9EQI7uuRJyK9w42CnVAgf/YCF1WndA1bZFKBZT3EwuRyo6FOMAfUs3ZMNb/b?=
 =?us-ascii?Q?cxEGh076PpaWQyiXS0ai9IKFBWUEPHkm/agWcfLjZeaZMiDqH20t1JJxz87a?=
 =?us-ascii?Q?CdP4qkzsKpT4HtsLQaLCXxxLFG/hxNH+1egKz1pJagx0mnK7BUGlhD8x2aiF?=
 =?us-ascii?Q?a5wZZ+vDqQNC0IlFnAvd8NIDVVszpX3fuqAlyc/2pXblTMH/AJxMLmJQzVY6?=
 =?us-ascii?Q?ei5lwICySwI+L4VxW17+Rd8de2hNltLze1tTQd/mpA1cyGpB6ikxBb90J/47?=
 =?us-ascii?Q?zu+wCDrMOAw56X5etoVCyGAjPwb0dMXVlqbNq1CSZKAGHF3uYWdj8hB1oGq7?=
 =?us-ascii?Q?UeL6Me4LVOguGZIHXO5TM2aZCNsaFKiFwYqejEqK+YJo1Nr7EgUAekJ5IUpD?=
 =?us-ascii?Q?i6vzRGXUbjmnVHbzSQIlU8Y3a7hseTjlC/lCEm1P+CYwPdrWJq+nkAK8kdPH?=
 =?us-ascii?Q?8RTA8aD5QOxH8VLkLfGWrHYP/zMkLi7G+x95evZ54Z88BzOK0biK3soNu0Ko?=
 =?us-ascii?Q?K9sXeVR+8dkQkaUGU9FyRpFiObtbxEBWKkYMfU/vhsNvu1tHxiZOCzCfkOLH?=
 =?us-ascii?Q?Z8fTwwcwo2Ywk/9H7Jet89kNiM0u3GLxtoLsaOfR2OeUf+oLPWg5TJY7HCvY?=
 =?us-ascii?Q?r7LKmWYyxaFvO15hxnqxLg8zuCyqGdyJzzFDi5v8pmeZY28+m51sXqYSS4VW?=
 =?us-ascii?Q?Kv4aVGxfHsr+1GhsJ5zSfKNjkgpDvTJiSeeWGLFhy1ppNDUBJP4RMIiUPnYc?=
 =?us-ascii?Q?pVbKOGP47Nrghk1j4gh7zOLyThqPLmG/qKOIHF4e+r57NqBQ4Qwgr7NQ6L+U?=
 =?us-ascii?Q?PfDHPIEuXAyv+57/ffO40uD3DIDy2Elq58VbnqvtYnCpqlsB8AaXATfONPlF?=
 =?us-ascii?Q?dXBk1U1heTuyUj/rSo0WbPIHoGB4l01x5kLs+iU69GPITQK/A8PT/YQ2Seid?=
 =?us-ascii?Q?KCDKPtv3dgPW+X3WzI3y8WBEorhAFdMVhNJS72eEFOea/76mrM8f2Q9uWgU0?=
 =?us-ascii?Q?P6SEPBShS17Q/Dsk1orQ1SWb7zL+Up6mw/hqNP60FyT1A568Byo1bXIqYSKK?=
 =?us-ascii?Q?+lwbcJPr+Mvk3NlMhDALiRZcJx3ZXyhKFdtExvrzQUsBVQEpoE/fSyR8d7HM?=
 =?us-ascii?Q?Yrz5GuJlMcauhnszB2ssg5hQ4xNEtEjpIFCyislAZy1BRyDdMTKULimnULl6?=
 =?us-ascii?Q?iL1aZCeJlTgRyOHhB8CO39OKSQjXZkWytJyPMDh3JJ76bed4FOs4JbYAZuws?=
 =?us-ascii?Q?5jX0Yizcs3nUCgaQu4fBmwBfS12v9mAcqZGliqlLMY7SOJBBU0z8mhBeE/Fi?=
 =?us-ascii?Q?6TdmLy133KzpFyiPztLvqzQ5Fm82chulBsoD2rZfAO3/6Z11VMeg5G3wgCq2?=
 =?us-ascii?Q?DrxNa54NDFRyfrrUotkL9jPviYewBYko2dFQFU9tOWAwFpN/SddhxCAXFP0s?=
 =?us-ascii?Q?Pd+dngpLJPKjTUCKRXOH1wBNVhUueoz/Zh1SJQJG6hNmYXQgMTG+L13mZNxr?=
 =?us-ascii?Q?vKQlWUMXVuc4nz0Yg5mOUk18bwdiwmeKIGcHxaX+90BUQjfJfdz1bVThuAZv?=
 =?us-ascii?Q?RKe6vuAEcOjYdblquQvUdKYe32/myHDtkxDAL8j2dcI/lgJ/JWTXQnrXzt7w?=
 =?us-ascii?Q?QQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2ac5942-f6ee-4e75-9015-08db09305f3f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2023 17:25:57.4775
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KHyObuL5D9MVMVFzoKk8an5mz6L7detm0QZSGfksZdnW455p+zcVP6ERpw7sa97/JpZl3SP4nonEVB+UCq2T7FIZi/SqKvy/hanuCiADTug=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR13MB6028
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 07, 2023 at 01:24:10PM +0800, Jiapeng Chong wrote:
> Variable changed_flags is assigned, but is not effectively used, so
> delete it.
> 
> drivers/net/wireless/ath/ath10k/mac.c:6024:22: warning: parameter 'changed_flags' set but not used.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=3963
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

