Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E24368136D
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 15:35:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237179AbjA3OfF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 09:35:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237883AbjA3Oev (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 09:34:51 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2073.outbound.protection.outlook.com [40.107.93.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D63913F;
        Mon, 30 Jan 2023 06:34:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=djEFT30QkoJBYpA/gZAl6HAJZbyNdqzmnCH3ofGUGt7ioleaeOh5phjZ28BFRsqFDe3szh9/DKu2BPXBSiR5O7W7sLlaAcOqGRQKW2IScRwQMId8Kx3btD/6lo9q12MVLNAg5QmA98PZPCRW0Ha3sKdnyu9kzvJgtzGzjF0zyp0TZwKJCOHOZFUi1m/NbxnlunMqg0C6LIAxZnJIZC68NryQ2zmHpDoG1mZbR1JZEb58sD+5cbNmwD0IGksIkvTTVVI84M9jOuRB4jB9DTo4/+W/RXs8kZDOazyqaqK8VNi5WfT1uT8Besla0Y1zSdd/DU19Bev3EJ3+CS41zuC0Gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=38noOuXBRVv1yORAes3OgK5ciZ1M5aWFJaSDbjCqkBo=;
 b=lX47hkSQvZbdqR+zwJXufh4NhyKIkCLgPFD4G5AQmgKnWM1/q9jvW13d81RXjW7YkXbYMpw0PiowfqU0OU/ScCw50V3asn1izCJIi8tywFe/QZQWH7eg6hbinOcyNxyE1AfykKzS3MiyWZqsU7Cu5yzRWlQxouRzq8nG2I/EM6EspTnMQvtHEm1nF1gHYAxMRUmxoK28NJqbxThCT5LRC+G4lRG/gf+JQhOSUM57XwoohcxuTFsLxL6dEvLYc80aCLsYR/MMp2FudBlA4/zAaSEuUcqDfUPHlG79tWd4N5ON5a2vTrEofQg1c9L9Xzr3PebN7icROGhP+bIhKZUN7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=38noOuXBRVv1yORAes3OgK5ciZ1M5aWFJaSDbjCqkBo=;
 b=aIBUMCqSJk4Lf1HmhXUCAAcof/dzSKDqKd0HQtaYDFJlqCXBefdSN41UKYY1/fzO+YdDOgeFKFZZNIQaZd7tFklXf1mnMr8RvDyWAbELXdtU9lkDaUsxOZFitztxf9+RMm56jPjkbcEoBf9XYgU0d+6urdEHyJAsBSR9nzvjHG1DRMfaCBXgqAhthgIWFdbKimNzLXCPUXeZBvyfLwkeioXyYnYGUTw5qirNxn8FBIn+2GQRKq+7Y0EW6y0msCGNHiLzyTM0Ir66fLguVhXJdqNKaK2NoHv7+k5mgZdAcCj08iqQMdelYuKVgG2XZy0iTDdOt7paDk7gNRS7jIcNiA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5040.namprd12.prod.outlook.com (2603:10b6:5:38b::19)
 by CH2PR12MB4101.namprd12.prod.outlook.com (2603:10b6:610:a8::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Mon, 30 Jan
 2023 14:34:09 +0000
Received: from DM4PR12MB5040.namprd12.prod.outlook.com
 ([fe80::9444:21e0:2a65:da95]) by DM4PR12MB5040.namprd12.prod.outlook.com
 ([fe80::9444:21e0:2a65:da95%8]) with mapi id 15.20.6043.036; Mon, 30 Jan 2023
 14:34:08 +0000
Message-ID: <e8c35d5d-d855-a38c-2f3b-6887df208360@nvidia.com>
Date:   Mon, 30 Jan 2023 16:33:59 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH rdma-next 00/13] Add RDMA inline crypto support
To:     Christoph Hellwig <hch@lst.de>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Bryan Tan <bryantan@vmware.com>,
        Eric Dumazet <edumazet@google.com>,
        Israel Rukshin <israelr@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>, Jens Axboe <axboe@fb.com>,
        Keith Busch <kbusch@kernel.org>, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org,
        linux-trace-kernel@vger.kernel.org,
        Masami Hiramatsu <mhiramat@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Vishnu Dasa <vdasa@vmware.com>,
        Yishai Hadas <yishaih@nvidia.com>
References: <cover.1673873422.git.leon@kernel.org>
 <20230118073654.GC27048@lst.de>
 <ac48766a-b861-4fc0-3171-7b23f175c672@nvidia.com>
 <20230130123505.GA19948@lst.de>
Content-Language: en-US
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
In-Reply-To: <20230130123505.GA19948@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: VI1PR09CA0142.eurprd09.prod.outlook.com
 (2603:10a6:803:12c::26) To DM4PR12MB5040.namprd12.prod.outlook.com
 (2603:10b6:5:38b::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5040:EE_|CH2PR12MB4101:EE_
X-MS-Office365-Filtering-Correlation-Id: 382e6da5-a3ce-4b44-b22f-08db02cf0bd3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IXI5IfNS44siFxpUOsoiNJhWzoC9siv+az9dHvPTnPc1TzLoT9amDnayVP5x5jKXW+YPJo+juBLA9fyp6Ebv+pObCQzwDrFKKU/+OKD4MCb1vCQ7wBnWjcWovGBRkX27eQ2sr/b7ZMzh7jlfcfiQfmo68IRhZnbpi6L8cZkRYTgf3kJfV5JS02cGKnRKC0PQmn23FPQV9FPdh6u2JAALRbHoMhORhGTK8DTLAVcbcImQK0vQM48O47Cxa9+rHCVEmTRfMBLdj3vJhVdLz2RivdXTq0lTYoBOlW+KARBI9cWvQAQBn9dgz027AyfhkZRsseK2M8nceWXgJR12K4ED0gm0Af7mZc5dXaWkMErn/fdlhRJc4xOguB9fGB0PXGL3b/X622aDfTPhvVge9oz7ILndILEDdR2cdl+ThjAmO23Ngx/tvG7LWs8sAA1b0uOAJHonKTbdg7O5C+/F0ZR2bJVBZM8PZZfA6vhVJl9YxAAQr66Wkn9T77d6CufLmqC9kZxIXsDSWw3pamuFVDbyMI3QicBzEmCFivJ5W6Jtd/Qs/cbGnxWskP5lcMrVRXXFmM0dks8/VVsL42QmdVCUqtQh6TBYVEyjMj+D2YsZRWnAloD6ySn2zvNe9qj0N2fesUhskdYsb/25j1jMvyYfXMMiyRbgHm8LoqtdeUgADSCmMgFubsBVSOi4FVvRav0zDKqvVn2LD482krrU6tqL1mi342gHOxY8tlvSFpR7X/8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5040.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(376002)(366004)(346002)(396003)(136003)(451199018)(8936002)(41300700001)(31696002)(86362001)(4744005)(5660300002)(7416002)(83380400001)(2616005)(54906003)(316002)(66556008)(66476007)(66946007)(38100700002)(6916009)(4326008)(8676002)(6666004)(6512007)(186003)(6506007)(53546011)(36756003)(6486002)(478600001)(107886003)(66899018)(31686004)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eHgxZDR4ZTJmamFQcENpM1NwUjlSeU1rNDJjVVppc2FLSzdGUHRnb2wrUlV6?=
 =?utf-8?B?TjVncEtBVUh3VVhQMFZ5Qm0xTlBrbVNCVnJPTmM3dm9vNVlKQ016NHlydGx3?=
 =?utf-8?B?N3ZCVTB5ZzFGRWFCakdsdUd6dGdSQ1MwYnExdE1NR0JRcklhMG5VWGlTVnNC?=
 =?utf-8?B?RDRodmRGRHZnL0pPUk5BSUdLRFY4aW5ZQm4vNjJlM1dGV0ZmQzRYVnZXVEVa?=
 =?utf-8?B?eWQyYm5YZ2pMc21ESnlBcG42R0hYc2tvbjFocWtiZkdaVmhNNUt0amNxSjBC?=
 =?utf-8?B?L3JleU1wc2FHYkdpa0k5ZlJOZlRjTFpvR05jZ2xXYW5DVkZZTVZUTTRDSHNM?=
 =?utf-8?B?OW5ISHpUVXRXOVY1Smx0WlFzSjlTV1Vxbk5CeEZoYUdYdWIrc1ZyYy9aaTBX?=
 =?utf-8?B?di9yVnArOEN5QnpRZ2dPdmZPTW9qRSszc0Q2eXYzd0MvNlIxUUhET0hOZjZZ?=
 =?utf-8?B?UE1mMWdMNkJnY3dlbXI1WFpOVXdRUzA4aHFaVUJyYlB2bnRpNTFJRkZaOGg5?=
 =?utf-8?B?Z280NkpNWXpka0FvSW94UFF5T0RXWTQwSWNXZTY1RnUyQVcyM0I1QlRXcXlk?=
 =?utf-8?B?czdvcVFYM0ErMmo2OGZtVXpOUDhNUlFUOHZENUVxem9NczBLb0hVVTNpZHFF?=
 =?utf-8?B?cWVMSmE2ZU9wT2M0YWhiOHZMcnZ1dHlPVDlhNkVYYmxLT1lPRmZiU1RNNVBP?=
 =?utf-8?B?TFE1Y3ZIMG0yTkdzanR1c282eFdTL3BmcGdwdzI1TFNWeWloM0FTNThvZnNH?=
 =?utf-8?B?aFJ2M1Z5bDZURUNNa2VVNGlhU3c2OUtJdHFMMWFnL0ZVT1pZWjJDNjJzc0lk?=
 =?utf-8?B?NjY1cS9NR1B1ejlnUTRjYUJyVXRLMDBHU1JWczFCU25LS2k3bVNEOEhsQzVG?=
 =?utf-8?B?d0gxamY2akFISms1OXNjWDJlOXNveGZIeUxkTTlyWmtVVlhMQlozaVc3RGhH?=
 =?utf-8?B?RDlTZmQzbEtQQW01QUkvZ01NS0lNWjlwRXJIUmt1aENtY1NENDQ1MkFzOFMv?=
 =?utf-8?B?MjlTSkx0c2c2bVQreVlrSlRHV29sbkpweXFQMVJkbnd4MjFsRDRLbm1aYVZQ?=
 =?utf-8?B?Q2t1U2VPbFVCcjhPZmQxZlR4czhsaUtTQ1hVSUdPclI3UUpYWThrVkpxNFJr?=
 =?utf-8?B?ajMvRFdRNlBpblRPSUFoWkpBYXZQTkdqQkZJS0k0Rk1keSt0dkFCQ1BaYWxq?=
 =?utf-8?B?WWJPemJmRHJHdmlVd0syQ1QzUXgvNlUvZVJoQ01DK29sK0wzMU9YOSt1ZzND?=
 =?utf-8?B?S2tHbzhJUStqTWFWdExMZG5DeEQ5UjVBNmUzQWZ0YzlMNzFOeGpxeEpnZy9L?=
 =?utf-8?B?WFVSTnRuQ1V5WDZ6bVhyakJEMko2VXRIMWlsRDhIL2hMeC8vVTNKODkwZHF4?=
 =?utf-8?B?Rjc2Rk1pRFJGZ0J2RHhTdVdINi9XZkxsWW9zSElFK1BweTgzNzRlWUFBanM4?=
 =?utf-8?B?ZXZ5MEo3Nk02eUYzVk04QWE4ZmdyZDZPN2lTOHlkRW1iQjdHazJvdXZ5TFJx?=
 =?utf-8?B?TmNWRmlMaUxrU0I0ZU1sVlJ1U1lBb3U4cGlPUTVWZnpCRWd5SkpOY1ovWjRO?=
 =?utf-8?B?ZkU2aHpYNGQxVytHTzcrLzZ5K3phM3FadzlyS3hBdWNBN0xyNUgrSXhERXl4?=
 =?utf-8?B?RkhHNmptbGZYdUJHdlVMZHN0ZnZhdlE2a1dleDZicVFqRGRtdjlIa3phdG54?=
 =?utf-8?B?UFdmUmVYWnpwb2pFeEtWVnJselozR3NQdmNFS1czWWJYaWJSVjhreWxEa2RK?=
 =?utf-8?B?OXpJWGViQ3NmWmdpV3FLZFViMVFRUHNKRzJxTVFTdHN6U1BZanRkYzdGSCtu?=
 =?utf-8?B?aW1HL1FtMXFDQjhobnA3ZmdkOXdwSkFGanBSeHl5WEQ0cGlhQ3UwNG5naU1m?=
 =?utf-8?B?WGZLTFNHUm90QndVUnVTclhTTGY4RWM4TmVRczllOHJtK2EzSWFMa09OZitV?=
 =?utf-8?B?c3ArWUdCSmIyaFNPOG8veUt6WlhLT2RNYVJFN1gwdmZJU1FrZzNSRVgrRHhN?=
 =?utf-8?B?SjVLYWEyakFxc1l0MndncHJVbk9ra2V2UHEvRjRRL2ZPUjlpWGpaaS9IZzBx?=
 =?utf-8?B?NHlDb3kxUkFOY1BmQUwyTzN2SmhUSG9GTzFuY3Jxa0ptR2cvK2VsOW9CR0J2?=
 =?utf-8?B?V1Y0L3NQT0Z1ckl4eWY0WDlYZGF0b3JhUGNmNEhuZitkQmJtTmZER0RhU0kv?=
 =?utf-8?Q?PrvbeuqlS5LIo9t/ytOPfHuh5yhhf32YyoZC7xa7DuJ7?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 382e6da5-a3ce-4b44-b22f-08db02cf0bd3
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5040.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2023 14:34:08.7965
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gSt9M8ut6pBntc1TPioguN1P8B5qI/AN9zhdNukOk3bvfj4DF6/EDc1/HWN0UrVCp7iLAYv95J3iN0zLMFfr6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4101
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 30/01/2023 14:35, Christoph Hellwig wrote:
> On Wed, Jan 18, 2023 at 04:20:27PM +0200, Max Gurtovoy wrote:
>> Today, if one would like to run both features using a capable device then
>> the PI will be offloaded (no SW fallback) and the Encryption will be using
>> SW fallback.
> It's not just running both - it's offering both as currently registering
> these fatures is mutally incompatible.

For sure we would like to offer both, but as mentioned before, this will 
require blk layer instrumentation and ib_core instrumentation to some 
pipeline_mr or something like that.
We are interested in doing this IO path but doing all in 1 series 
doesn't sounds possible.

First we would like to have at least the mutual exclusive solution since 
there are users that may want only one type of acceleration.

re-designing, both blk layer and ib_core for the PI + CRYPTO case in 
this series is not feasible IMO.


