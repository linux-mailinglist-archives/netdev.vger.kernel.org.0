Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BCA56F4725
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 17:27:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234575AbjEBP1y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 11:27:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234594AbjEBP1n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 11:27:43 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2098.outbound.protection.outlook.com [40.107.93.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2572E2D43;
        Tue,  2 May 2023 08:27:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VjO3pUaUrWs+hkdWPwl5eNZ2Ky+xgW/PbTqA4tyyo217UXaEX8eSdg+fOD4MkyIaD8HcxPSsRmYwLXjJi8tRKDVcNCuHLvzB1Ktgi74qT5IZ9RS2VerKGBnPtxSc2IGxykAcCxUFrond40k1VtXXPUrxxTOnD4/HqBzr8KYpLJzzbKqjCifSjxOLoij4mTHCrhvFxi6JgHx2YmhUcW5qSpYJi99HYprUtyHT702rznWL+we3ETGEpsallOPiQ4YuBb4ZSzQszju+Q9gZ58e4THEoDTRieXXYN6HrCwoS5fqCj1Q5czafwPsDT6vw70R3OvXOaon21GHd2QM34sMbHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YljkHRufQt2APkgHoBH2MYLGrkrEa3Ppj9QfKO0wtRc=;
 b=YMJKPjkBdngj5ym/HPixB4Ydh5xhOj6tIjdHkY8qrFQ6KA5lXL8Wnti6fZD6JBcZew2zufG4zeEwsaKE/Zl2nn18B/NiLB8aA/lhwabU6k/J96WQzTTcpJB0gz5l6E9VG++2whqhCvV6M88RnmPrJJToVyqZYutsW6U6QzXQAgNJZPuOlHkFtlaVVDZ5VEAUl5GnOO0HuIy6qRqPkkXzPLmc/+KBTeklBt1MfNZOavjBGaJ+kn7k2XCiwHdD9ngUvpNm12jFS09rCn3Hkt4kFP1cAIe78WDeorZv6OqZ0QnBrsDwVR6uGrhHyJDUV+xYCKN1RuIdZWuhzVCiIpIenw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YljkHRufQt2APkgHoBH2MYLGrkrEa3Ppj9QfKO0wtRc=;
 b=ptyo60gzKsJzc7W+RG/byea/1P3JmJDHdJ8Zc8Y69kiPpZyXomx7ykFeyW4wYHhhoYYRefIuyJVKMyOjZplnexYRrGdCmuZUQimJvgvDqIqbuTl4oDC9uPDdmhYp1dUKRxSk8ufd0JwO/fV6LlD0TRB/gRnV1rZhhmMayXy94Cc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB3782.namprd13.prod.outlook.com (2603:10b6:610:a0::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.31; Tue, 2 May
 2023 15:27:37 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6340.031; Tue, 2 May 2023
 15:27:36 +0000
Date:   Tue, 2 May 2023 17:27:29 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Dominique Martinet <asmadeus@codewreck.org>
Cc:     Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Christian Schoenebeck <linux_oss@crudebyte.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, v9fs@lists.linux.dev,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 3/5] 9p: virtio: make sure 'offs' is initialized in
 zc_request
Message-ID: <ZFEr4X1s4dVgr+Vg@corigine.com>
References: <20230427-scan-build-v1-0-efa05d65e2da@codewreck.org>
 <20230427-scan-build-v1-3-efa05d65e2da@codewreck.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230427-scan-build-v1-3-efa05d65e2da@codewreck.org>
X-ClientProxiedBy: AM0PR02CA0188.eurprd02.prod.outlook.com
 (2603:10a6:20b:28e::25) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH2PR13MB3782:EE_
X-MS-Office365-Filtering-Correlation-Id: 47bf60e7-f2b0-42f7-7d75-08db4b21c233
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9NeVskKOa1WPlb0ixc1N7lgDN1TSmoRBe1zqx71GgJ/uFvOJ00bWlPuKaSlg8a5w7Xp728fX3U4vQOTrnWr16+bVyP56p87XU9urzKb1QOnIfYLVZBIO7MDtV9pLY/dx1Njw0YF0fpXBnTW0B7uiq7rTyrhZB9L0sH9GXP+gvEO6KCf6qpcD79IsJ8/fy6zUU9iNEo7ePRhn1T334/4vNkrd9kGxD6drSllI5rb+um96jcUDslWBJyy3uLXcolM4FdWeS1oQ1wLBRVB0ubq/Hv5kxx3CtUT7m1RJY7R0+inenkKYPFt1tPnW2POxOz8udvNv1AA0kyjj2ioK6WmlGNQ/qT64uuJzKL5UtpffNnDcv5YyBANV7hp2KCkfxRp7kG53LtPLI1LQ1fBk2QW9SxZ0SjSXV/VJTeY0LrLhdYeNRi6eF//yXC7eRD4yEiFeTVNNICS3iMvszTAsLbZiuEgXeJp3LTTCtBR7qE2GIggPFg3HhpwJ0w/hpkj2ecy9DdH9NX82hk/odMlgRewzroVtJ6E/ybkGTpc4dPTrPG6GXObclyCVO8WmQUvd3Zyjq+Ss6q+ZlZFr4nSBt+f7tm1Aj06/jMDkCP+1SRbM81I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39830400003)(136003)(346002)(396003)(376002)(366004)(451199021)(41300700001)(8936002)(8676002)(7416002)(6486002)(478600001)(54906003)(6666004)(4744005)(44832011)(2906002)(83380400001)(2616005)(66476007)(66556008)(316002)(6916009)(66946007)(4326008)(5660300002)(186003)(38100700002)(36756003)(86362001)(6506007)(6512007)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Mxk1lXFonpp8vWyJQ8JEDLbnv4I0XV/t2iQ3W9NFOTYG1N8DuMxAJbf1hXke?=
 =?us-ascii?Q?4rcKwl3yU9NYtPiq1G+kUQlSOPOL2pUB0WR7f1xIEXWeXqCL/6U+Ayhgo416?=
 =?us-ascii?Q?8MY2+3zESExB2dJDGZzkSNOcVTffQsw6WMYHA6pOszhAL0778LH+Auh3PMX5?=
 =?us-ascii?Q?aUdg044KtFzKQvSydMmx7u5Sh1DpAI6cPcF6zkIL8khdfGs5cd1Rsk7E4BUz?=
 =?us-ascii?Q?NksooMQEz6A1VGNjlu+Us0AtvFCUBHbVi8B6wBNSmR6AxMhm2zJBksHZua6m?=
 =?us-ascii?Q?ty/XVZ0++YBLIU1dcTtZAp+SjY97tkk0cRYSvzrN1tNIxUwq0TzMmyzQjzK3?=
 =?us-ascii?Q?wskqExAjfhes2lypgmSZEvN9hbMSp4uDtwetWZe8eItbPgX1BH3ECzoEPc67?=
 =?us-ascii?Q?/6Gt6rwN2VnOLnXCA7gAiwcIoRiHT+yt848uzKf3b/3W4OjUlJkI8t8CN7HW?=
 =?us-ascii?Q?eVDFENGzK7EEwszulLFcAWVKTyd2NP+nvFBHWMTEWathXMSMUvWQ6a369q/g?=
 =?us-ascii?Q?pOQoCfhso9zGC44EbmjZ070353J5PDJQLJd/1QaIpF/+z+BFZ8ZsPviPbuLJ?=
 =?us-ascii?Q?OqTzauokRcKVUYrl0j+UXYfPh3LV872cOodj2/5BCUwAGRm+yaVcQ/whhwsk?=
 =?us-ascii?Q?eeN6Oo1qf/KoVcvsr2dWZ+No37/Su/84xOkuwsTHTSqYJ70v9qTQe7LYzjBp?=
 =?us-ascii?Q?ZnEaJGDRkZiPa/tTwrkJ6bgVrO6XkmwZwouhAWhZ4ZQA/muh3k/K/dayWa0s?=
 =?us-ascii?Q?qxsLTFptVCsG//ufUV8A0AgskJkIQ9UF2Wiw9AluPUl1jYjWqaupzRrirzoo?=
 =?us-ascii?Q?7XPiZjzeJqsQrRUA0Sts0XFCcxaQt0/b0CiDd6M5UvEpFxsOS76ZnmPORYow?=
 =?us-ascii?Q?R5PbKEsCwVoEMhIBtZWp3wp+jsKSVhuPrfBqIKSLepjw5QSkOBfyFTHOlfBH?=
 =?us-ascii?Q?8xhV+g0NfcRmE/0YxiHL9/tzZ2MzXdxz2eZTBw8/Cpyg8Axaarlo9fbBn9GA?=
 =?us-ascii?Q?mjgugpuo9slH95f0IF9Hwvzy0ohUvuG4NAFMreJ3R502o8pzftMPN/XDpGLz?=
 =?us-ascii?Q?YKYq5A6iCsbt0r4a+KLY4vwQ5EehASPZyHCfPZBbMYnbYV7jg2jjgZFJxpp3?=
 =?us-ascii?Q?zCa9TA4CHch4zUaVjzNy4qRvk9mhvQErIvcHOf9AD3epXwNplcgPr9U4Z/6C?=
 =?us-ascii?Q?3WOOp4zsCh4nTxhAWe3WmpqhgKgEC0aEL6JJLO1l3Bc+S0n3+BhzSf4IdQ6A?=
 =?us-ascii?Q?IsteCsIDMumxY9QAe3dPukO9Y9b2F0jHY+d6plTzQ/x3vcsKKYBy+K/7NsOr?=
 =?us-ascii?Q?2Wie119vpp2DP8VWNuajN+UzxFBH7ewcipZ5UvimVyLcuynfFOh+J3E+BrEk?=
 =?us-ascii?Q?p13MAVLB/hylpASyrGnohLkfhYfCedZishoaI9GcjlcKAZFERVIZUlaSqcUn?=
 =?us-ascii?Q?Kkj+HPG8Xvd5vtZDTRz30J+CE7ag89LF0ajpL3UVbtAE4g+SImp2NmaQ3IgK?=
 =?us-ascii?Q?0MCZfu6BQoAws3vrCYRoXeB0pTyR4JJJKgSJEx+qD6Dohu3fuRU2YwFKzDOe?=
 =?us-ascii?Q?Luy5Sm2Sz6VlTxmP/xOcX4dTuLfKqSlWfjMhf1wI6Y3G0yrptaPn3nBCw46o?=
 =?us-ascii?Q?VVhcF7e5IjVfFu21BjUYHjE8Lo+uLOQiK3uYSkgAHAi0crUtRTYgYd3/SMeo?=
 =?us-ascii?Q?FKi5sg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47bf60e7-f2b0-42f7-7d75-08db4b21c233
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2023 15:27:36.8687
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EjJlaxOGzxNXTa7agX4NjXWUYbw0//+1CXMou62eFeHlVT5ji5A0dA+j6yn1Ie33enTLwgo/6QXHmGgD08RPgiBaJ63zhOrYYrBZj4BkCow=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB3782
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 27, 2023 at 08:23:36PM +0900, Dominique Martinet wrote:
> Similarly to the previous patch: offs can be used in handle_rerrors
> without initializing on small payloads; in this case handle_rerrors will
> not use it because of the size check, but it doesn't hurt to make sure
> it is zero to please scan-build.
> 
> This fixes the following warning:
> net/9p/trans_virtio.c:539:3: warning: 3rd function call argument is an uninitialized value [core.CallAndMessage]
>                 handle_rerror(req, in_hdr_len, offs, in_pages);
>                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

