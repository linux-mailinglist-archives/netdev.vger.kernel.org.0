Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB0A06D07C9
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 16:12:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232130AbjC3OMt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 10:12:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232056AbjC3OMo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 10:12:44 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2092.outbound.protection.outlook.com [40.107.100.92])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8BE3BDF3;
        Thu, 30 Mar 2023 07:12:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Up0xps8Uwuj2w8KvttcBzVw9ZJrNE9hFZXZv7xN0O0/Z3mI6mm3peMVqKL7J3GEnqdgzrSi7+t1FxbNnAbWvosTe3XmpActQF38Ot1QX0oeC/SbGXfR/8+iI5gU0rc00zIkKTtDUjBS/J/telsyFYktRL3MKp/Zf3AI3kYv8yIZ5sL+HJUbsmjj10NfWVj8aVuRlh5bttOsfKERYm9dD+IwG8XR/qAFfpP6EBoDPqy3NPUF9rf5X0i4Ic8SSz/gx8kWZtfnar+shHpn9C+DL6cKXbkDYCwQooUXI1QUiDm6XLM5kBbS/6g4R1BNCT2fJ1dxqHpOM/+2ofaMII2pt8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xavBcw6pZS+/JKkqew8dSvBDjaPo0z6C8vKsfijliKU=;
 b=Vo/U9uwDTbaxwIlFIC9NziJeJdQdqSiZ3ISmvbx4JR/vaZTCTo4gYxZCpLkUv9zL7zNVpjmgZhxtFA8jMBeTNi4vuVGsiAibU0R1mRMTWrmtcEVCFmfk6OdiPSog2Wf1wfbdoTjewDfolu8bBpqz88A2oeD3mwvwETfW+uKC4QpBIclkos+LQmjUsPkq9HC8LDNeCf1zne/YIoxpEXH2A9Wf6QOVM5dQj9b+uUhYjz7jCPO09Yal8GR7RuTe53+FoOdIFTpo2rfS61orC59fditQrw5m7T4BGgNhDdySok66SmNY/YuAT/7w50Bbv1drQ8hAzQu72gLxXPcr08ngDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xavBcw6pZS+/JKkqew8dSvBDjaPo0z6C8vKsfijliKU=;
 b=kQdbP/nkwpiJK0kHb6OKbVVteyE1Gawt0sJ83mIWV/ugGhu878bAfqYmSiqY63MhA9J6kFFLb2hw8EUmSl5H61mjmfHfsufQ9mjc6mWLs0803A7EfI3GBV+Rin8qQB1obl8lpG04Eln+ilKszE3Uh8612mKA2VyD5dm7zl+YzII=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CO6PR13MB5356.namprd13.prod.outlook.com (2603:10b6:303:14c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.33; Thu, 30 Mar
 2023 14:12:33 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%5]) with mapi id 15.20.6254.021; Thu, 30 Mar 2023
 14:12:33 +0000
Date:   Thu, 30 Mar 2023 16:12:26 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     Larry.Finger@lwfinger.net, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: Re: [PATCH] b43legacy: Remove the unused function prev_slot()
Message-ID: <ZCWYysETADTNGsQ1@corigine.com>
References: <20230330021841.67724-1-jiapeng.chong@linux.alibaba.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230330021841.67724-1-jiapeng.chong@linux.alibaba.com>
X-ClientProxiedBy: AS4P189CA0030.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:5db::17) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CO6PR13MB5356:EE_
X-MS-Office365-Filtering-Correlation-Id: 80ee707b-4e2a-4608-bfe4-08db3128ce66
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: woYYyWSGe23QAXRJkfcSDqkgzvdZ+tkbROzV/cK/TZIRBatt2xHuhyC7+EAEmCEFbwMtg5hQMdvicNtlwt68eD6JJ1Pe1h3/FW0v/5xiWIhHPJyBU035DFNDWxczlGOkTJN6a4yqbap4D0RIZMIJ7u7DapzVGOquU96wphVcT3gRX2yGL9erD2kSEK3WDVbXRMs3pF/hj54hNkhs7ShBILJUxarykcWkh/VPdC+7AwOBVP0EENIJrtAhZ+bBJGs8xkwLHm6/uhTRBBs3ftFwBaAPRq9N/uaWmol5e65w3yYlewXu+7QIDfI/J2HN4rCyejtwoXPFgmE68QrMNM0AeH9fxS7Q1nJALLttpOkGcuvB9E0kx4zshKpfylCJznLCQbhfkSZ+aqGO9Ty0VWyLHl9AnXYqPFjPvbwzA6lH21XXpwIVrYQGyLNc/mRS8ixGOIbtYzZnMTrzQ/hkhU5qpAO43AD+D6qHNhwbN4gvJk9pcNFl2/+EwZEJgEBheNCPHgX3DcP3z3T38tQ0lpSuIs/TyCGPHfJuHx9Ex6SQm0w=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(366004)(396003)(376002)(346002)(39840400004)(451199021)(38100700002)(2906002)(5660300002)(44832011)(4744005)(966005)(6486002)(316002)(8676002)(66476007)(66946007)(36756003)(66556008)(6916009)(4326008)(478600001)(7416002)(41300700001)(83380400001)(2616005)(186003)(86362001)(6506007)(6666004)(6512007)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?L+Ku3/4b/G7shlwF5vN4VasY2kH7kKpBL1sGmI7CLEjG10m4Se3BUuX9s8hA?=
 =?us-ascii?Q?CtCjJGO1sg3VKSHmpm/1mHRHULzrzEcQrkScpvCkwf5H/3it1p28JZvOplcA?=
 =?us-ascii?Q?nTo7jmbCsy3ZyeCPGULHtZ4py1uNDKS8cp11IeedGjbMpdQ+G2spIsqZAFBo?=
 =?us-ascii?Q?HDJ1sNg11cTFhuarr1zhxP8dovxwMeMIe6z4RBLOGjM+18n74SpWZ+mxquxr?=
 =?us-ascii?Q?fl5zZ+KL5J1akGwvsUNHQBk/UN33AjggTSm4OvLLcM/zUQF2cv5ixhoyUFDp?=
 =?us-ascii?Q?PFgXi5UVo02Q8c5Z6zuXTxgxXpkX/cQ6x3lSX7w+bqr6rlz4WtLslYRr9hq1?=
 =?us-ascii?Q?dWeF8YWS5vO3DsaTgWErj6wWXoTdnNxv5BLGrz3PgZpp+gE84DjJg4fI7L84?=
 =?us-ascii?Q?q76BbF8t0trCj0FsiFYri7pkgE5QbhdZsD/nX6YX/+HfLGFxHone59F2R5TC?=
 =?us-ascii?Q?K56yyU2cfbYuXa9nT6hy0ze1yzhBzH/A4pAvj4G7tTB7oieoR3VNDJ8EnpWS?=
 =?us-ascii?Q?zZ38ymwgzQ/bdr0PzjBl1YIvAUGzwdZy7PABWIDn3mkPOOLinW6LAlgjy6JM?=
 =?us-ascii?Q?83UVZ+SzL12WP+RXUfrvcLRPjEp4jwoKda4IE52FJU44LdXoNA10iOA8+U3w?=
 =?us-ascii?Q?ZM//HWINNYG/zAU9SSuy4mdpm+xb0A00EQfNfxHtVX4qQ963igHBynHuYUYU?=
 =?us-ascii?Q?FpQBTP4SXGfpLQQ1M6cIOnI8jffAWJ8mOwEc8KM1P1bN7chO0AXSNSelGqvi?=
 =?us-ascii?Q?KIXdnYkpwAG40jNEKPqu4adq0PN14Z2fui9w4KQ1kkJ4/6AMQorHOwng3T/g?=
 =?us-ascii?Q?Mfl16keT0t7OFCYiTZNsmj4hCim8CqtXldmKQbELLJPF7yvFBXovlyN2mH9z?=
 =?us-ascii?Q?Mn0BiERW+PAverV1xAT7Sxjey1Z7F6SOxfI9/A+Swv10Y77xEh56uIei/UvK?=
 =?us-ascii?Q?l0dJDfjCBdi7mnrPhFwfJq6n7RxdylEPZpnvYvjfoY/JBuwSClXFBsnZphJq?=
 =?us-ascii?Q?BEfOwA24WZnIpMHM+2NNNwIZFnQIJlgAyIbnZH3l9/67d3M+0gphk85bCAvs?=
 =?us-ascii?Q?cPrVwYUwO9s877o7yg0flnXp21CTDp6QN6Wun1hH0tyus2KDMaQwnhB1WibV?=
 =?us-ascii?Q?do3ARBoIZqgiTMa9IINuxd4j7jdldBcpHR/yXnLmSIDo7Oj21GdnbhyXQf2I?=
 =?us-ascii?Q?mRysuLxlZmQZW09gSzQBbUDcgrOxtHzPOsgQBKc7dh/MqxdvwqOO/kp8qTfs?=
 =?us-ascii?Q?MNAcppKfVeyglNL1L0KpQGT2w/y8xPBIL31Yiq3IKm5ZhhV/zA+UnXMwPWKn?=
 =?us-ascii?Q?py3ywszhNgk1LADgQQleM1h1nLTdGelAHje287wENQVbMaCt9ucRYgB1gFpr?=
 =?us-ascii?Q?8aCrA93t8iaAs9tSI2V15LsxkgLqRvUvrHGrwqDnEevdKthg/9KP/bpFmCev?=
 =?us-ascii?Q?9MgmJQe0aJdgEZSPAfK/Yv3qariiqgzjjWaR3q4ehuPKS8cD80OWVwwklEYZ?=
 =?us-ascii?Q?Z1WiaxDJ8tF5CLMUjrgXZvr8JdVHz/cThF3gXqtt/K0IQEv90w8v0/TTDRYN?=
 =?us-ascii?Q?JaJY23UxzIxalfORya9mvpTy7P3XXSmpj2MqvIbXKqeROx0SvStGa7eGmLFa?=
 =?us-ascii?Q?lT0xPT0spzFVV4YuEiwKMBa+95ZrViFMXoUZbPoWdVCUEi5XAqdv+ork21WM?=
 =?us-ascii?Q?hDHhlw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80ee707b-4e2a-4608-bfe4-08db3128ce66
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2023 14:12:33.6362
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L38jpiIGCnv6hQcfr6jywFWKGCopkIhIU9NLAPZlk5whTlMP1EU1emBJAcKdJ6J0j9msNlYcp0nG1wmygzy7ufoLxmFVgRa/vLln7aBTXiQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR13MB5356
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 30, 2023 at 10:18:41AM +0800, Jiapeng Chong wrote:
> The function prev_slot is defined in the dma.c file, but not called
> elsewhere, so remove this unused function.
> 
> drivers/net/wireless/broadcom/b43legacy/dma.c:130:19: warning: unused function 'prev_slot'.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=4642
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

