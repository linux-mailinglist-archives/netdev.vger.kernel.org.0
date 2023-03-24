Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D60116C7DC7
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 13:13:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230071AbjCXMNN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 08:13:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbjCXMNM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 08:13:12 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5971F113EE
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 05:13:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VednhJCU58PKZLhRosRs3c7ieLjifgWpMX76gf7vR59c7T3zbmTJrvYq50KW0vsqkPjgUV7FD7M3CUQN7JZzSJNgcKyIU9juhFUpNHnnd25TyihMoM8/vurbdVCm8fbZzqEEWTONt6DZy36hcm/aHgYPDs1n8iG9k7OMqqgG93gooA6v+2ZXWiEUYoImD11yfeTJPSPvBfAYUuwCRpERy7FR4PrkgDJYbfdeEFnvOX55rHs4SuaxZcwQdqm/ZZpxQUT946qputobkZJJLB2y1Gt1WLpujqr+Vp6FGSz9ZIpjfghxjg3yIvJwKsWF8O+zhkiUb1i4cQTpZJdwz6gy/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xPHqNMXgvi+pVxFNp/6IqPK6YbrNvj8VcsZ8rRNqZ0s=;
 b=HuWn69zHS/TnWwycTchcOnak3xEXlsT+CGO/0Nr9P3nervax0FFioecoJ/RCFB48QlyBqxUcw9RVbnBESyRnlHjQiGzuGJjzcZxvfKERwnwVSLfIRFbRIGRRXLbntZTjBoW77z+P7UQ0y9RrgU8CQsvGw2ddZ8RjJO3F5XcCuj3RQyMc6FMuhLeWaiiCRDPm9FagzZvwGpTD6uEaQBlCP6HdC2Wua/h04h1RzWxb2DVVqDulVrY2gJmyYNCmXPJEq1Le24u7+J6Ft6RnxBh8Ei67Uea1uePHxEm92Zv4yFLKdxZJqJxzeSfxT4/M1OaBsbRlnWH9mT+z5xJZfhH6aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xPHqNMXgvi+pVxFNp/6IqPK6YbrNvj8VcsZ8rRNqZ0s=;
 b=e937k3d56/zwA8wkNIchMvxqoSL3b2Cu2E6/MvbZc9DDvD8QfBxjfMWcedOv8kssX/SaMSpTKGm40Lj2Hq4QyMcxqLaea3mzDGgujPh8/K9ODtcoRHRqbDnxdWd1GdpWrYdCY5MMpLGxYgKjZEhIbDTn16acwye0i2eRf9nKr20=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB3831.namprd13.prod.outlook.com (2603:10b6:610:a3::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Fri, 24 Mar
 2023 12:13:09 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.040; Fri, 24 Mar 2023
 12:13:09 +0000
Date:   Fri, 24 Mar 2023 13:13:04 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH v2 2/3] net: ethernet: mtk_eth_soc: fix L2 offloading
 with DSA untag offload
Message-ID: <ZB2T0E0rV5AgCwIj@corigine.com>
References: <20230323130815.7753-1-nbd@nbd.name>
 <20230323130815.7753-2-nbd@nbd.name>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230323130815.7753-2-nbd@nbd.name>
X-ClientProxiedBy: AM0PR03CA0029.eurprd03.prod.outlook.com
 (2603:10a6:208:14::42) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH2PR13MB3831:EE_
X-MS-Office365-Filtering-Correlation-Id: d1538d01-6e03-4134-a1ec-08db2c6121dc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xvJBMfmfNOUexjrk0IBoWwPcCfRXyBb8EKqQNPvp30+enIYnk/UZrWueB8IIhxgMUraVw0uDIL0jkRN6F61sw2G/nUCtqlAJ9cC0ZB7xyt6KH9ie3BSuqr0XO8aOy18cT+8Lw4PI4kLbxGjMDiMcHF+5KgOGrYF/8v/VfSUvsULHXq10JGwIJMrVEshlxnZG6TbxYmHdUNKV4LtqpJN7KItVFNK4Ljt4G/mRk9JpwGeFvglRN0dXlrasbJz9/wGM7HHUE1wXoxaPDqZpI7UrqvqI5O/PJ4Mqo5qhlzUQKZ34C6gp8HS3VlzWLUdEwXjHBkaWq7PNvD8iFq2mz8HGWwJMdC/uTPDiScsudzQXsl1jntye532o0SvdSS+/rYnqDQyaUDkWGGY639PqoFWdRP0gCM0UP5nU/29F/25yyx3bb6OS53vbgDD1BKnIdRZcrPkC6PBD5sHVgdhgA0zeYLSPCDxmhyweLJZGKnMmc/52TsMz8l36R0uDjVnoIcz+doHZk7zROh/ccOi0nocM4BYqyhNn06QgaJVw879RTJWD1CIhw/WKJsxyvHcmacXZyAohP55YLMF5HN1yKaUUpSUBrgfe8mfMSBIkclYCnBQyDFI0UUG4+pR62naCgLY49GVphHCbzDtFpVxLFaOibA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(136003)(396003)(39840400004)(376002)(366004)(451199018)(38100700002)(2906002)(6486002)(478600001)(2616005)(186003)(83380400001)(36756003)(86362001)(316002)(6666004)(8676002)(4326008)(66946007)(66476007)(66556008)(6916009)(6512007)(6506007)(4744005)(8936002)(44832011)(5660300002)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ztJCCL2jcQt3a3ERtUTKt+imTQoUh8xVAyGSX9maUV4ecF5L6Eun7DHThKzK?=
 =?us-ascii?Q?oz4jcCIIazMhjgwew7V3QT5E4UksLyMp+JMqDuTwVVzog1wbrdFkZfpWW0CN?=
 =?us-ascii?Q?w9dx+4OOMVMEmvudo1sBhjnhNgW0a1z6FNb7lHa5Sg9RpzVvtj/M4BLCOoOA?=
 =?us-ascii?Q?zF2JUyFMV9FTBT/qTnA4w92mU3egzvI77fv4KEUqwE9vMxHmcL6JLiaKbCRI?=
 =?us-ascii?Q?xjSWTu2Mlv7ptcaOWPuaBlXuNOHkjJhv5/ZdMoarvezK36jxol0UKAcSNloz?=
 =?us-ascii?Q?JU9UxLwTCEqgPmm7hXmq7V93Cc90wqxx3ITWZY0OA1vdPpUfhLIEhG6Qa+ev?=
 =?us-ascii?Q?FXvgw4P3e6iqYphbKX1A7EGHKjcj5jcShTeCBeZR+vZeDhK3WbN/gND3rDDr?=
 =?us-ascii?Q?2VUgfUIpCaCJsGUTE0Ojp+nsI2Fijwkot+CArpfeUhDMJGSrprhtp47qMtDb?=
 =?us-ascii?Q?r7fHvXBBrf7W6IsMTMTe7GA4OF9eYBhcKXRbcH28klFu/+TDmcxK22bNeNk5?=
 =?us-ascii?Q?eJSVC6ZcfsK4PnNJqxO5/d/zIZMeK5X5vjgXqtGvnA/x3fs9N4U2rtbd5Xcf?=
 =?us-ascii?Q?voPRg5Rgii2zeaAGXRdr8bsh8f5zz1Y93IuHohxGQcjbngqj1qvtQe2Y4CvJ?=
 =?us-ascii?Q?nQfmihDYjxSl8+Yrq5nFZ2wUNX0LNAVrtQ0JGAq+e8u5vQ+mzSd5pmmn3ahF?=
 =?us-ascii?Q?2rBhqwoNDt3pFbgOl39WTA9vvkIhvXCpv8XqPCZRbg/w+OUTglej0z5ob5Xu?=
 =?us-ascii?Q?1gT/esgcOP6GHpbCb9zqm95jZ3JhrKQyhGr6QQXGh3kY2DIf2TbKywT99aK7?=
 =?us-ascii?Q?3qiE07I7nUfoOJQhxkMJL6fxZ2GxE9986/bn1TYpi1TdtrnysCHxWD+yqCT2?=
 =?us-ascii?Q?SCNV8Tf3jK/Ce7WyVoLdXDbO3qkTyqgkQyRKlc2QwKPsWZKjFsOAKvwsszCv?=
 =?us-ascii?Q?rv9rAjDaDfT+M5Mo95Po/rYrcon+l5izvOL6eloQwZ8rR395m0k730m6IF5p?=
 =?us-ascii?Q?3udo5H71JEX5ABoh1AIYnuYJgSHD62RzMBhbjv6zIKpYIJWPj8Wd6f4t9JaF?=
 =?us-ascii?Q?VzQ0e0H7V0SSXu97OH5C4giUNQjgUYDOUV4Aokj7QvUFAxx37EQI9ZO1x4Yy?=
 =?us-ascii?Q?rOJvJhS3XvLzr4Tf3jiTBwHM8jNiCSC0vXWIBWf8NDFa5ScYYBKZ6IqcCNXo?=
 =?us-ascii?Q?X1AA0sQ3nBgmmR+SYQrUX7iWuVM+GXAUv9HnYMKJ/3ynOBiYRwYKmj7uPCjq?=
 =?us-ascii?Q?e6MPN9Iq/DL9SLBpoxmfI6W7R5PtPAxur1MDtjBri45RoBAa6tiI7Fd+hwJy?=
 =?us-ascii?Q?HZ+Yaukhaq0Kwys3xHseGhfcL7220Q3OOytrrQWTtwjgA67Nm7cwZl3u/YSO?=
 =?us-ascii?Q?m3duJKEEO9Aua49yJT6vBJ8BJOodyKoTKWQiN/qQVX7HuvBcPu3m6pHEj73n?=
 =?us-ascii?Q?Mt+dzJQxkeu1dLe5YXuhrrrLtIvQMHH5MDjw0/y4OSjwpVJRH0tyxnAfM23+?=
 =?us-ascii?Q?jwXi/qILJuDQu6Qve4l1FJQmH1RLt8yJGcC0s3VjhBMFBYq0qaY5iYOMekcB?=
 =?us-ascii?Q?VkW/oayMXBRzmKmorW19GV9Z9AbjBT5Kyu4LzpckERgYxdrndnHlUvV5iUI8?=
 =?us-ascii?Q?KH3bNSi28bfMyfSmzlgvmmnvKbYpWreONH2rNXvz8ZggDHo+Wre/bEyvNxhI?=
 =?us-ascii?Q?NI0jBg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1538d01-6e03-4134-a1ec-08db2c6121dc
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2023 12:13:09.6645
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RQ1SrvqJaX2enMaFkEDjBclzC3o5AZ88DASxT3ngsGy5pNhQ5FTR8UckqkDzmRN6jzAMLFlP18hidAGrvu/1VMy5fg572eoTE4gZvjCWeh0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB3831
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 23, 2023 at 02:08:14PM +0100, Felix Fietkau wrote:
> Check for skb metadata in order to detect the case where the DSA header
> is not present.
> 
> Fixes: 2d7605a72906 ("net: ethernet: mtk_eth_soc: enable hardware DSA untagging")
> Signed-off-by: Felix Fietkau <nbd@nbd.name>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

