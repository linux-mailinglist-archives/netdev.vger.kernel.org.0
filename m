Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B007568A9DC
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 13:58:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233185AbjBDM6E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 07:58:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233206AbjBDM54 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 07:57:56 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2094.outbound.protection.outlook.com [40.107.92.94])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F14025BB2;
        Sat,  4 Feb 2023 04:57:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZCslTq1i9uEDyPSCe8wgRYFPRWNyXPcIDb9yC060r4i9bjKJECggksViZClsqUiJSHutrDYP7VIWps2BtFn3ss7G+LnmANBzPR/zMqwYK/QL96iKjHKe1UWHUUUm8yc4a5d0PQ2XcVwn4JbWpGKm1AtZ2erXabw8PU81vj8CnU1Kz/M5we67dDsd4ardfWVVFVFDNoYvXabeyaiH2m6YRZB+rJxg8IYmHfS7Dz6X/zWX5YwUI/oNNL5Kbr0M0T1C4igz2K/N31JQRaufUQNWqRO8DY9QA/BlXZLueDHy9YYqjgnv58Mo0XHn4ploW9CpMe24vBDJwiMAVPxBgWg8KA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NjVPcCulQOxOGilm2umqRN/1ZvR/nKmuyG80EnrWchU=;
 b=MN6kflItQ3UA10rufRqqdM66XCxo2lkPLK0zLyFJ+XbJ0EzjgvbHIn7nqbA0WkeYk1BEgP3fEDZITGOmRW3KimezMOp+1/K0YjGF/laomz0bPPGrC6gH4awR/bC0LNZLxIfRzOHE3aVUoq3F5Eowz/jxjalRvQ5sQFeECkzyOqv563W7TehenRcoOhY/Elogi1SKB3ny359uBcn1vQMSxJkkEKiGYky0mf/uFR9pFf4nx2xw/28kduW0cM5UxC6zAVCSs2jTh65E8zjfalyD3JMOGJxFrRAHxUjktq3GgnxjaCrNUYCozHstM9HkYBe5yVFz9Y5Dpbyz/sFhE5yBZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NjVPcCulQOxOGilm2umqRN/1ZvR/nKmuyG80EnrWchU=;
 b=YAfC5P9HztE3oep3d3L0+tbAsVp55YRh1TwQ4UsCYQ1YQZzm1EE55sk9k4wbFTt74QzOILtLmxemqmPHKcusxUMoe77xy/SOoA/3FYp23dAoldDhYkUHcn8SldGCzuTpUeQMcOblm3rkQZdXgaz1NyZENIB5NiFxFbPIDzL8Xc8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BLAPR13MB4675.namprd13.prod.outlook.com (2603:10b6:208:321::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.31; Sat, 4 Feb
 2023 12:57:43 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%6]) with mapi id 15.20.6064.032; Sat, 4 Feb 2023
 12:57:43 +0000
Date:   Sat, 4 Feb 2023 13:57:35 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Daniel Machon <daniel.machon@microchip.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, lars.povlsen@microchip.com,
        Steen.Hegelund@microchip.com, UNGLinuxDriver@microchip.com,
        joe@perches.com, richardcochran@gmail.com, casper.casan@gmail.com,
        horatiu.vultur@microchip.com, shangxiaojing@huawei.com,
        rmk+kernel@armlinux.org.uk, nhuck@google.com, error27@gmail.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH net-next 10/10] sparx5: add support for configuring PSFP
 via tc
Message-ID: <Y95WPz7Ct5yLE0Fj@corigine.com>
References: <20230202104355.1612823-1-daniel.machon@microchip.com>
 <20230202104355.1612823-11-daniel.machon@microchip.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230202104355.1612823-11-daniel.machon@microchip.com>
X-ClientProxiedBy: AM8P191CA0025.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:21a::30) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BLAPR13MB4675:EE_
X-MS-Office365-Filtering-Correlation-Id: fb89923c-aaba-4d3f-dcd7-08db06af67a5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +eWMNwEq7EozoEwWdhdtIft1PKyW/VOifodcEPOIzpv6t1xxYnEvBp51Enc2/EJlLVef9Ucj4gr+fojvatVkK/1Ip4O2MdEl9WqrnQOarVXW+H1ZkjaTS2UrvQHDlYD7CedygBGELVONi0Fu6q9aqaDG/3FGBSHA9jpp7dXshKLneID8qBwqGpH0T5gYCavDqG3cAUprfEhvbmNszsCHKaopZBoh9GIZEL+8KmmfQUtBh8xA6n41Ygt4Rag+oeonAuxilNnig7PzqLQ4pjSKWOFOkfpaGxV+NolROtMRgRnw9avzqdu+60MxMA0GbHOi5no43eRmYf6SyCfi7IwVx1BNKq4NT43McVa47EhWHRIzwF+CpqAJDxngofAJDT632XE+Q3D/946UlrJbld4RZpgxCiskKjU647JbV1WYr0+a3BAWYSs1hl8ptnUlZUMjONvJ7rgNJfGUe/zkXmCgi1Bd33y6Z1Hi9VvjwGPoYPnVXJmzzb0Btd58Yycnh3oquDHUXn9Rxa1K5KmMqk4Y+PFe/eoWwIIa/pqmRJp24H5opVDxALI0bf2WyfqtlzSoL4R01wRLF9gjCDazFYFJB62JHYL/WShibMxv9slndr4REwr+sOrSbBaDruKWhYEbMH6k9RhXfnJXIayUP45Q1Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(366004)(376002)(39840400004)(136003)(346002)(451199018)(316002)(8676002)(66556008)(66946007)(6916009)(4326008)(5660300002)(41300700001)(8936002)(66476007)(558084003)(36756003)(86362001)(38100700002)(6512007)(6506007)(6666004)(186003)(44832011)(2906002)(83380400001)(7416002)(2616005)(478600001)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hIjNEMsuAIjs2r1ObJAfTMdl7iGJ9zU8IncA7TKCOgyeBBTtiWjiAHTJgxhi?=
 =?us-ascii?Q?0XYHTMsf2lQMnZc8dH6eqD6lfEny4xo/LcOuN8TkJ8+rWu3h5UaNQ9VNWKfg?=
 =?us-ascii?Q?fDdq04fv7rntvX6XAh3OBPOKQhVKdhxhof8YTRa+vZAfoczM2JuC2d0wyo06?=
 =?us-ascii?Q?iWEE8lXew1m8XeBcOkGFh6UIs/qQeC5bKY3khK59o9l+b1NhqY1TBX63Q/hI?=
 =?us-ascii?Q?PJ9uPYBQmtGprB314uNq52HVY8v7B1VbtjXayaN5K00WKrOcDVRTZi8k8lBs?=
 =?us-ascii?Q?Q1nJykpo25slB3HiU7QFm3Q8R/jdeiSelMBp+wrU+zlGiu14E+CcAFZ+MFfZ?=
 =?us-ascii?Q?hNfwyrBO3gaIib4Vm/RVaZSd2EAUoDJWahwSBeETurL21swhSvJQc3yuwqwU?=
 =?us-ascii?Q?84u7y99aLaNB85rWPYhnXOt0pxyxgsYsSGJmtoQjpNmvi3J2khzaHf3vkg/e?=
 =?us-ascii?Q?1rBS5neh1NUJprqfVk39e6xtvyD1/qn65T3jIuDj00ioV03zOj7ZDKAO4xgQ?=
 =?us-ascii?Q?RMm46gr/AHy3PSeBZ65n3Nmr12lPD6s51fWiGoKeXTV59AVJ01j2U5xVRqWP?=
 =?us-ascii?Q?C8oDwP2cXUf0B1aQ+Q8Rh5IKGZNThk/6DLq6Pq65NZPL/bBv81bs4On0Jjhs?=
 =?us-ascii?Q?y+Aq9pIUI9y/+33yk2RzvEZUggnxdRV5PebrxoFwvDDfir85fP5AKSb0DeE7?=
 =?us-ascii?Q?NkQiNdgUwRMKCzBoAtmfvzieuQwlCGCiH5lTTuzGBsgQCGS6+d00fJsKQidz?=
 =?us-ascii?Q?KWRJ5UG+Kt/yanTCmdikae2fkhhCs3wugcOKLW7Q5GnSz73XyDCs8gY9Me7t?=
 =?us-ascii?Q?/A5rw4eHYbjibIoyA4yn31D1op0kePoEf+QsRB15KZEuTBcsFgSER1WypILG?=
 =?us-ascii?Q?RbQK09bixSIpKJ03ziSnzNOiEvIrgct+/8hHa92LT2koAvyG/Z2SH4ZlWcet?=
 =?us-ascii?Q?nN0BWyNRZBGuHW3hYiKF4e2obhCTDaeZSjrTdhrH7CsRm8qne2QJGXVUVD/Y?=
 =?us-ascii?Q?zli6WF/nkC09GREs6ypNSRh02IlprdNz0qn5VEM4TLNsh65JgQ2ljCtH2i9M?=
 =?us-ascii?Q?K/dZryJH2JbcNvLQPDzJhvgaNygEJDGQUycUQLb1B3UToZg2mS2rbhZ8OrEK?=
 =?us-ascii?Q?vlWAJwFKJdUlV1GANElsCFN5H7WFg0stEeH4hjiZItk8q2NuhhakBFXR7EOj?=
 =?us-ascii?Q?ZRkfRdzLJZ8Ql8bbMsi3oEnCyEO1QnLxC0xE9tD2MAHCbW2UmwSLXPGFZcM7?=
 =?us-ascii?Q?HqRfLFbe5X8Mehh0E7mDXSr+YZoxU+xdIyNDrGz8JbrtJrtuygM8M/EYx09k?=
 =?us-ascii?Q?sSiu/O5o7pBMLmK4wlCXeJ2Nvqb8g3gi4MUYVHa6Wi7DnHUKEnB49lqJt5Y9?=
 =?us-ascii?Q?QsBBO8f0vj96noIlKeuDr0W90mvkcpPTxidYHqebCV58Hcu+Alm8ON+b4Gdc?=
 =?us-ascii?Q?IC6aZO4ft9rGyjKpy99uZVESgYAZwLhRXsnsxrz52QWBVCCqOjFaN9NlAEdU?=
 =?us-ascii?Q?+8NNC68fKkQ4L8sgz8dhiHQJN4qU3o+lxf1aIi3FId0+fdoB+H78wwxlLWDn?=
 =?us-ascii?Q?GBYcWu4Q+URhqRUeARPngDXcB7WPBdhBaIrrdt//GpUPLJbrFV09BoC/Tuec?=
 =?us-ascii?Q?oKj7D3BjNT5+rUcQDTr4XlWitraR1v1vP0NifRq9yi8HsNY55xo1SHjloHZr?=
 =?us-ascii?Q?DdGQ+w=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb89923c-aaba-4d3f-dcd7-08db06af67a5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2023 12:57:43.2666
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: swwuqFoquyvFTK600b6zc61bLWZTVR4+LDqoR/u3uWBdb/DIAXwt9HuuemO9yDMqObUejaBqZC0JUQgbROkeJ9e0B6RjU35n+kSDePMQNvU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR13MB4675
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 02, 2023 at 11:43:55AM +0100, Daniel Machon wrote:
> Add support for tc actions gate and police, in order to implement
> support for configuring PSFP through tc.
> 
> Signed-off-by: Daniel Machon <daniel.machon@microchip.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

