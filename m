Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1DFE6C9311
	for <lists+netdev@lfdr.de>; Sun, 26 Mar 2023 10:11:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231171AbjCZILh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 04:11:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjCZILf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 04:11:35 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2117.outbound.protection.outlook.com [40.107.95.117])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E02F059E4;
        Sun, 26 Mar 2023 01:11:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gu6AjCS10tdJclcW4DeRc3IsnevXCprPc8/1z5aGnQgmjPQBhGcooAVwPJ956EmQz+Nw783kNNJ9Iyx6dFsIxCQcJ3u5DL/pZVGv0ngecEUy7o/aYE72ntrPtTbBTfbSMWJ5kdGEu3vYKs6hEmgCMgFnFyeYntbTRY6GsI8Xa20fkxfbRK29iVPj9yhdn66bBMQS0dXGXu/dQyK5GVs4paMI7TELxGC10hJCDK5MR51edS81FoJoQ/XJ6DeNgkSCFAdB1kU+XKIlXt2CHyKd8NecjZuddOSBxBMPF0cUGiI2wqZyWO+je94otDnLufJ39YNaE/brXYLRu8gFIGLJ5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S3Fw8TbizqqX4nAuYI7MOryBipdAHjL5HfrijeTf1T0=;
 b=aUPYmPzfYTHhlGgqKzAXvjcg1qhzdof92SimdolF5U+sgm4LnVQ9eNiQltTSTr573NRPKSiHk5CAaslHMHd0LQzjNW1N5GQGs2gXV/Voe250cuP4niUhoz0mLjIR5XIQ8i5hyDPubRn5zD9nqqC84qnEAuiKQ4X4nJv1n/48SwSFnK2hJRLY0/heVY4f/bFoyRuZtvwCFhz+Vn7W/OeV98srzn57FkQODpRvXFE5Th7GSxtQCqzvQ8tF219eoLB9gU85koYL4wtkI3ybGYSWye28J/CgDqvstu4wkYRioZQeTWs1WgY/qS3npRJAMDsSQmdlopMpewZ7sb+f0zfuFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S3Fw8TbizqqX4nAuYI7MOryBipdAHjL5HfrijeTf1T0=;
 b=idfYUUtZyHce2HbgXN9w8Qt05WPIkvuFSAzLdki2tT8/4ERh7XBuvnWlz5uRYOVJkz57FLvI/EYlPQ0r26m20F06e7K1ybY5uN519Ki6FD8zpOD1paNHZT4zy1Muk0CM3T1zDoFTBD8yWPEdX0YqZVvrlJn9xtP6yYFJjUimirM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5665.namprd13.prod.outlook.com (2603:10b6:510:110::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.41; Sun, 26 Mar
 2023 08:11:33 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%4]) with mapi id 15.20.6222.028; Sun, 26 Mar 2023
 08:11:33 +0000
Date:   Sun, 26 Mar 2023 10:11:26 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Wei Chen <harperchen1110@gmail.com>
Cc:     pkshih@realtek.com, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] rtlwifi: fix incorrect error codes in
 rtl_debugfs_set_write_reg()
Message-ID: <ZB/+Lhyxg7Ur3/c7@corigine.com>
References: <20230326054217.93492-1-harperchen1110@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230326054217.93492-1-harperchen1110@gmail.com>
X-ClientProxiedBy: AM0PR06CA0105.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::46) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5665:EE_
X-MS-Office365-Filtering-Correlation-Id: 508d0550-3f15-44b2-8f5b-08db2dd1b607
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UcKXjFu1T8b0kukEswFP+dhZSzKi5BV9OtK3gJFZabiYz+xBVebIFjG7MVM6XHkTkljz3fyvZXn3ttTOy9h/rY6a+7jwF6sbCZJimUW5FFeQHVxaXIWsyey3vldXLsf7hHD05CprwRXJQuLCPln+HB8Dj0UR4zpL7yOHhLHasOLe10cV6ieQDjWoyGBOqknn5CR5DwEcfzYeb1VJ9jHxclLwnU0RnUY/9AbRYAgoUrvYCm1wnECFGvWX/n54+D25fGnmYfvtQT4Dy7LsnrfdMUqWDyvG6vIPgvbSCEPZkC+tPeO1xB2GTm2AxhTSUOlsfSmhVuIkRsghjgrLseNgrgX1RsHMO8AhFgiGDTExc52gB3p7VN4+H4TLmwHk9F+DqAydhNBkc1ftXAXqQcfDIjuwlMe8hwA7LcDYSPF9VOHXveUI/EJ3JZZCZQFiCv9J8QzJO9KlTQBXtIo/PBSg3lIoXkEaxGW4c5ma0izfkc4m/YyN9p1EJ+XeNh3bTA7GuzdPQP215eG85LGyFckadwATwRBZaOiH9PmK+pQ4iZKcm0z76oLpXZLGk9viI+nN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(396003)(346002)(39840400004)(376002)(136003)(451199021)(6666004)(316002)(86362001)(83380400001)(2616005)(6506007)(6512007)(186003)(6486002)(8936002)(41300700001)(44832011)(38100700002)(36756003)(478600001)(6916009)(8676002)(66946007)(4326008)(66556008)(7416002)(4744005)(2906002)(66476007)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7jaJbmhUXs5n+lcCSLqhzNiqcVn/RFDqTp/dBF7KXHUVi7WSa2NpNc3frUme?=
 =?us-ascii?Q?8sWxaCoZR6lK6jnVrmqOLkxq9ud5TcVPJ7zxOPewDQ76Y6fI6SaEI3gB6Zn1?=
 =?us-ascii?Q?dclmCkUoORLreyZL9DjYhN1TW/8r31DhYUdqlZM3hEezCy7QLddjptQnZBzL?=
 =?us-ascii?Q?VD4aWDd3iire4TtRAZUAN7xsp0TxKULOs4RAUIHebWsgF64ZVa23lQ8MD4TV?=
 =?us-ascii?Q?3GNFxcD9rVP3mcD7mV8HRqZxgTsli7aLlmBPjku12kVIs68GsNFGpj+V+Lzc?=
 =?us-ascii?Q?Yev7vVLR4O7NsLx0GyptQJuMAk6ilLn+gZaffVMCF4hY1EvLs3ojtV2DRQ7k?=
 =?us-ascii?Q?qwS1csd3m9+0xwDj4FJn1ldkGpXNnSewPflSZWJALLfUjovyGKw3hDWHVYMy?=
 =?us-ascii?Q?8jEl96wa8gTKhijIqccjKVEAe97eBRFi41JQpTGAR6E5hkrRiiPxaU15+eaI?=
 =?us-ascii?Q?kOhP/DYfylw1O3CVZlKE3z7Zi6immz/DZwtBxYm5ukaIU6UhQqCkRZtgEZem?=
 =?us-ascii?Q?doO0HN9ooM4gmfSINRqHruA9bZK11TBm4IDvP+COf8FfL6AGm1gm7TvQ0Zt4?=
 =?us-ascii?Q?5mHPTOj91+bqUscPXcK6QUycw39wQ8FuHgSk3063SNDqRdl/xBanWykiZUYi?=
 =?us-ascii?Q?3JRYEAJb9PtXLyqy3xMmvSz3oGgO74KbxnikKtsH4FL7KP+iIgPKxyjitVd/?=
 =?us-ascii?Q?6uEOiohw7y9jFBe03NVI93IKk4JSe1HL7KfqHRpukVaTsp3PxeMchQ6y2uXn?=
 =?us-ascii?Q?pUbd+SoBuQXOZV2wksVfC5oiDqhU9KuR7rN2LEB2zjaDwYynBW4pg5wnRcCc?=
 =?us-ascii?Q?BSdX5L+8KYYd9P/2t12M+UMl95sQg6KzVFffWGp6uKpXFoCU/YoLymI7/9Ff?=
 =?us-ascii?Q?q+Z5EAxxtX3rEMZwy85mmQLsXKUgXRsbH/Kpk0XfTFVvhHrSX/53LeEifvIm?=
 =?us-ascii?Q?onhtK0UyWOsMQMoFu68Eh57f0KXBEYb6QnHGeE0Pxop23qQwBHeH+dL92zQE?=
 =?us-ascii?Q?hPIZ1hn0FrjeeJeJmrBswUm0161eVCAoW/EKQ8ioCtS6wADLesuuhkFA1EsO?=
 =?us-ascii?Q?Snl8GhKK9dJ83VdgvQijhhFIy4WkAdzSHe/NPSzG+K2IX5Nt/J0ecj2xSZQa?=
 =?us-ascii?Q?ZKzTYIw0jpBW3D2GQLrtKUTZs+/i4+iUOyle60FHP1Z2lMGTGs7VzVU9iaK8?=
 =?us-ascii?Q?tLBYY8TngyWkiVeRMZKEEGIE47ZIh7O7oSQal1tx6ONXsaPuyfwv8Hvw3k7o?=
 =?us-ascii?Q?lowu5ZxoRJS3AzKt6USm4xqYykcUIY7rPj1o3bO8J93TJGVYzhsIzKIOk8eB?=
 =?us-ascii?Q?iQp+pjVBYuZj8ghQ8bWAXtzHvcw+23rj1SxRztISmpFKsAgqiXMReWiP2Dtq?=
 =?us-ascii?Q?Yp+GH821zKEtyE8/MNtlMgdzOCP83tSGF8DOlS7BsO1/CojM3zzVkpSUz+p/?=
 =?us-ascii?Q?xhDzKuqzeZThcdQ97N9c5MXhEsxbewe3uhlwxay8lO2yFFd7LlxQINnn9lli?=
 =?us-ascii?Q?c0wRxjFimU+HFv33wPWjG3P4Y7qsE1ib2hZOKUDhPPesO+l0bnmyQigTncAl?=
 =?us-ascii?Q?b1nsk1VB4hmM+GfiGqQKTmv9qLKK2v7spSKg94RsaEEeholQB/Tapng74xxu?=
 =?us-ascii?Q?c71rzVPY0ax80J3a6rcJVjuAL/xMHZDftkgzsyN2EQLMZBxKdlWheuAkiWTj?=
 =?us-ascii?Q?aCvpgQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 508d0550-3f15-44b2-8f5b-08db2dd1b607
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2023 08:11:33.0352
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kN3G4+cZcVhKU/ZwF1vmPXOGT/5kNHIZND5PoqZ3u48zwrXtr3pu4JjOJm9HUZ+fOtNmTJkRbjTsGKmw7WfNvMKfRvAA2Fyd+pTsJc47X0E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5665
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 26, 2023 at 05:42:17AM +0000, Wei Chen wrote:
> If there is a failure during copy_from_user or user-provided data buffer is
> invalid, rtl_debugfs_set_write_reg should return negative error code instead
> of a positive value count.
> 
> Fix this bug by returning correct error code. Moreover, the check of buffer
> against null is removed since it will be handled by copy_from_user.
> 
> Fixes: 610247f46feb ("rtlwifi: Improve debugging by using debugfs")
> Signed-off-by: Wei Chen <harperchen1110@gmail.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

