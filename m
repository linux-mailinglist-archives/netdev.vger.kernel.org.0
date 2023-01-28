Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD3EA67F983
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 17:23:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234355AbjA1QXG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 11:23:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbjA1QXE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 11:23:04 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2125.outbound.protection.outlook.com [40.107.101.125])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 006FD7A83;
        Sat, 28 Jan 2023 08:23:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a1rB6u1Ig/6UsXxNLP1etck5jCA6FE1hS9kAHFXqlm2Gq/pBZfjyvpyfnrPoDGBWgPLb4RCtWkIOzVEYq6d+IIFk85/i0i0vukNzqY6qYxJz+ZGXm4PcMme/cuHjeMTUr3jlRzLqf8ECVX3gMXy9J3low2gEGRVshs0haL4+zaz9K0O2KfA6fBF3sdySBvI03pFRGny0vOQJ7TivNPIE32Rt4qE+LywCyWL1AdbW/opZ83W5HEII8euAsUezxR39MztCS7FTjvQBn9/vkqwVVWS39Hg/51sUhkqm9JJf/R7Irrb+86LB/0N426ks+GBpass4OfUb3YplWevBXm/Yyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YEsia0EMwHINvPnZHtuousIB75XAm4Jsj5JM4PpbHVs=;
 b=Xo3Ez4qgS3sQ1tq9zN+m0t6pRI3ybVqzqiOmcH4U/cF88J7nLbAfom+mn68gwY0Mm50ao0ZDHJf3sBISpSAYAxbbTbxtwlZ6hzFRpbY08hdpceVc3uwdXtyJFl58XaK/BvTgQN34tx/LzWS0QC3AVN/4U9M5sKzht4NAinmyAPfGnt2FKsmXqx/K0lG/gerEzmq2zw+Xr07N85SPF2Yeq9N3ZYtS8J3NGf2ZA+tt/YqQjQRiLfnnlgAP32j3nvFmRILdTYO38KKjOVJUsdaIOCGy1sXGBoA8CECd7kWeFG8Fb8oSLinDucawGM6JOR/Kmjg7ccI2Q6VjRlsjF/A5VQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YEsia0EMwHINvPnZHtuousIB75XAm4Jsj5JM4PpbHVs=;
 b=ZfGFISbyjNhKuD8+wJPc5RoFAGiQQjWDbumIsQdsTTeI0lq8EOAGFqGbVug0zFm7nK0lK3lmWnhwPvoH79FLqnlMsMUU4leSl6JsY2OZdueMOhSGuPFQ/+4T0Rt3pAg9Vx5W/l9SwyjKDywEi3AwdzbEL3mRoFolJYCu/mm1AK4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB5988.namprd13.prod.outlook.com (2603:10b6:510:15c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22; Sat, 28 Jan
 2023 16:23:00 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%6]) with mapi id 15.20.6043.028; Sat, 28 Jan 2023
 16:23:00 +0000
Date:   Sat, 28 Jan 2023 17:22:47 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     michael.chan@broadcom.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: Re: [PATCH] net: b44: Remove the unused function __b44_cam_read()
Message-ID: <Y9VL19GH23h7WRF2@corigine.com>
References: <20230128090413.79824-1-jiapeng.chong@linux.alibaba.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230128090413.79824-1-jiapeng.chong@linux.alibaba.com>
X-ClientProxiedBy: AS4P250CA0016.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e3::8) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH7PR13MB5988:EE_
X-MS-Office365-Filtering-Correlation-Id: 266ce44f-e2c3-42ec-1e29-08db014bec63
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ryphaGJ4lM3NhVQKoXV3Kg90/Uui6JE+fidAPMugpkQuijrlQ2e8bYme77wDnU8+57HWVTzrJY3QQjs+LmQ2NFF48vKFF8xZEjvamuLnkeliwlBX/Z6uLIsPPGgdMFP+Kb8InWOpY1kdOrFEaqN0Qk304/ZaZiDiuO90eHdQ6nM8J1WaSsENJkFlLlg1t4QjXxUy/Y8sPz/SiKrnjWZankSX2wHyWfiJjTur45miCepDsdoBeaX65CIk4m8M4mXj4c1thX69XZLcCYMDGISQaQ9KtfbR8xu3LK3GqGThtbJ3yF92HarbrW4UZ1xFKQs5RecVxBJfL9CCLBqUsqtzdE9pF3HbZlisZr6NZOwZ8VYxhgWJ5l46N5fJ40kTV9PibgJpBFRoFEw8D03o0FCtqD66xpLefXfE4aokGwLyhDAVEy4lCtlDDDV4KbyQVSinZH7iy75QhyWlMJuDjFI+SfiSW1d7Kdugjt5CdqxiCcVCwCT2FqPfsnVQ1eoJJ2KjvPR33l9Vj6XJJiWEAeovIdDBFcnoMVQh+GL2DPnaKHnry7vbsFRqHxMChAazPj+gVAHTZhjBSWb8yX2dE0AIrPWh5WZPaPeEUnPwTL4YJQ1NbsCJGhIOzSCsLj0ieTft/ynvulOPRCJ29/02czKFake3wlHXTuQR6Tz0q7lzWec=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(39830400003)(396003)(346002)(366004)(376002)(451199018)(6486002)(186003)(478600001)(6512007)(966005)(2616005)(83380400001)(6666004)(41300700001)(8676002)(38100700002)(316002)(6506007)(44832011)(8936002)(4744005)(66556008)(5660300002)(86362001)(4326008)(66946007)(66476007)(36756003)(6916009)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yeejl0GQ73/D/zpnca3PJrO6IVd2pvllzXXTXHlkRn8nhJmDe2cq5FLMHHbk?=
 =?us-ascii?Q?TXShqmUTHjvRwmtzgUiU6us1GTCnpRynYCvsiIMmyFfFmELyGKDaSuoRbz9X?=
 =?us-ascii?Q?wKQinro3DjAd4qKhLDdpda4K0CAdlFfgw7qOugmebJ1Hzb8K6XhcIkFOl42E?=
 =?us-ascii?Q?1NRiHkxgGCG+ENt7T5CggfUwNB1rpuYgiMppjX93EyVyY7cTe8sCrqNTCcrt?=
 =?us-ascii?Q?MuXmfUsilpLI/T6aHErKlnkVL21yCq0D0pO1Muo9OA1/W/Gka+nkFOfvlDKF?=
 =?us-ascii?Q?+OmtEtKxabUJeLaCxR8gpj8yMMWqvKKapqzwZfWmNeogCIc0+1QKrqlO01UL?=
 =?us-ascii?Q?R7YVkmdl1zVpsuG3HIeun0g7Z+oQAMkvFPoAsQQRm0TWVNh66mY5J4GC7vwB?=
 =?us-ascii?Q?hIo/g4k7Txvy2znfSTK1qtLMVcqeCB4ByUJ/Zu4t+0WRyB8KoZKo5zInagii?=
 =?us-ascii?Q?6xYVhl65J4EOAU6KF8g+IMU0o8QSVP4++eh2ZaVedJeB20I/eu/+pZCY56uN?=
 =?us-ascii?Q?4YAP0F6XePwEl2seZqUFNzyvAvsYKo/zH77qaMt+M2k7H8LKUGdtLsxDWrC0?=
 =?us-ascii?Q?2KG5y7Y5Vf3V2rnEu4Qaiht0oeScEUiv4wb6d0QPdqF+LysAwEYAXpG1qAbw?=
 =?us-ascii?Q?BEJ65paEh9KsOYABV56Zu6ucieSeH/LGBw2t1IsnVkENFRJHOwRwL2F9ax7i?=
 =?us-ascii?Q?xb4BxZ1RDLBXaVGkQEU//D1SltZRz7hL6mU7BIF8bUrPLYQe2Bke+LgT40kh?=
 =?us-ascii?Q?ACR/3IEcLO0P5dVwEJ9SEHg3GzV+5hTz14LKkk4rST0tDP/LkbJN0Gh2wq9w?=
 =?us-ascii?Q?UVbqtaR8HY7wb9x7Tpsrgs/Adn8LpX3vHDId4MwY8QgFPoJZX7UtFbLv35yk?=
 =?us-ascii?Q?yYyYj+iJniazJJ9qLv/oiUvSq0BnpeSTOdpAWUZb1NNTmrpx4wP6+oH8Ma4Q?=
 =?us-ascii?Q?2qvyl2BU5fAxSFgCn0R5FJjPRocCgMg8Mx2ZYdEccd9fncUBj7hVVjGqIudI?=
 =?us-ascii?Q?2akmimxJqnu8AUw1cCKLIH1s6E9cIBAWAO+7Nxo+RgUNNsGMcvvImDOynZX/?=
 =?us-ascii?Q?GH9eftebYGBaPbpOviMtHNUW5Iov2svWzohQbee6LDoH6BwE2VgoFrKUOy2N?=
 =?us-ascii?Q?FnoDCu9WC7wylZOIvwMD3u4wP4J+hx+f0cm6EZLuCpDcwTa16l4MkR9lTbBl?=
 =?us-ascii?Q?05euhuL55mRN3Q6Va5t0BIZGIE2wAs2ajpvVGk94FMCgetyBzG6+hkY+24U7?=
 =?us-ascii?Q?xJOGBxWizzqT0mDSxRVUnuB9iGwGAQ98ZMRwteuGRQQHceExHLDmtmKS0aZE?=
 =?us-ascii?Q?5+h9S5uMJuQVD0+IpquNLu2IGFplb1alJKs4oiDL84gdVl27XWI9INmVHn7G?=
 =?us-ascii?Q?WL9nvevK9K+L9gX1+tQ0VaFUVcUJXzEP7VeDFktjrqv+L6/8nIiyaW6jfJjb?=
 =?us-ascii?Q?e6kGAResguNZWx8wVccwOm3pJE3y+1D1oZhK8J5hq69gASNfBpVhm8teu5Im?=
 =?us-ascii?Q?CK7x2AuN+/63BoX6HvInFWWyPWO6vyIKxvFUaTdMsu0VISnxLqnoZ29qa6VZ?=
 =?us-ascii?Q?O9I3S7QSz322h2Dn+rLinWglz8B7dFY3Fu4K/DqDiZRphksmAj5+43r6MtSl?=
 =?us-ascii?Q?4TPMcH8bSFzABBoFVgy19KB+5VujHw/Ji04njY66l4as3p4XmMeYDL90UAin?=
 =?us-ascii?Q?A8sgzw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 266ce44f-e2c3-42ec-1e29-08db014bec63
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2023 16:23:00.4713
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d4gKWSD7xi9mI40xEbZIKLS6PbYMhmK8m68rtlKYo5qOP4m//eIsDvcCuL3Sl9VqVpERkKMMOaKlEH0TlPxGwb5nEzFe/qFqpgDFjEqnIEw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB5988
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 28, 2023 at 05:04:13PM +0800, Jiapeng Chong wrote:
> The function __b44_cam_read() is defined in the b44.c file, but not called
> elsewhere, so remove this unused function.
> 
> drivers/net/ethernet/broadcom/b44.c:199:20: warning: unused function '__b44_cam_read'.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=3858
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

Thanks,

This seems to have been the case since '__b44_cam_read' was
created via some refactoring in 2007 by

753f492093da ("[B44]: port to native ssb support")

But I'm not sure this warrants a fixes tag.

Reviewed-by: Simon Horman <simon.horman@corigine.com>
