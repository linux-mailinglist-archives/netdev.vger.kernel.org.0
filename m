Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08FB869E474
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 17:25:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233534AbjBUQZc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 11:25:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbjBUQZb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 11:25:31 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2090.outbound.protection.outlook.com [40.107.237.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FEF023126;
        Tue, 21 Feb 2023 08:25:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lq0fa4dZMBthgQ5yRbkzwngKQYdUjIs19DXnmHpXX/2h0b7JIXE8BaPQQ3icNX9neUR2r2gznKMg9YLbNZXoRbg04nz9tUzEzbeO2xbwqZD2k724oynQfT+N1BTcWB8qyF2tWPF1LtBehXrPsajWtGG9HPvsTvjJ/bMRNM+wUTta/LfefTnsEIAuG8oXYkbuDdS+phgdQiZ1P2OS2yS6ZNRX21n+kmagib4faxCLK8084Wb5xixT9QEtS/6ZVFfVFnVUgsu9FEK/mVpq8ZMUy9D9oytHbroOd0VMmXlzFU7mHY+hNi6jVimsW1xVG39arI+nh0qPE/+pKk5OTildlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2CWwhA3915MEPV2nIVVTL/8cezDYSH77tF+DPegDgOI=;
 b=e6KACv8e0k7bmbhSRCgfw+zgqAt15IBSsngaeUzLXVYOxlwiGdZKENK1c+Qk313ZCH+BJHI6xv9x/S2dvNBrZcL/nchMMx/1PraKw3V4wf8rQvQdaFhSecz/+pHjRi5c6SYT+elL5LKmqgAwn8LaL4IEXYNMSPfrjluKU2xdnzrhsIWUyVEPoG4GFgHfV2UcMyLcCj8TRnRUBD0dLqbNAQydTpSuEbDflCiYLfIpbJ4JmevXAv3/9bUAxkqAR4xfCUnrP21cyZTe6aYCaVP7VA/keoA5yPuGWXpjc82JF4zJLU5MlDgdveIwDJbrTYlkBN6eZJD3NOJo2QHjbfhsOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2CWwhA3915MEPV2nIVVTL/8cezDYSH77tF+DPegDgOI=;
 b=LbPHQEJHlmcum911IpFPjfKFyN26hpaYEGhyM3LFkTF3GGLG/x40YSPN+E8q+JpVACadKlryZXqekbbI413U8kdBA2ufDgqrL9WTSItloim3mLVtynxEk3oU/KXDloHlvQTdlwfcjesn9zpW2yslpCW+WEYvIRYJjlDfdLXtDKY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ0PR13MB5335.namprd13.prod.outlook.com (2603:10b6:a03:3d6::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20; Tue, 21 Feb
 2023 16:25:23 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%9]) with mapi id 15.20.6111.021; Tue, 21 Feb 2023
 16:25:23 +0000
Date:   Tue, 21 Feb 2023 17:25:17 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     "D. Wythe" <alibuda@linux.alibaba.com>
Cc:     kgraul@linux.ibm.com, wenjia@linux.ibm.com, jaka@linux.ibm.com,
        kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] net/smc: Introduce BPF injection capability
Message-ID: <Y/Twbebt2p1TEsrl@corigine.com>
References: <1676964305-1093-1-git-send-email-alibuda@linux.alibaba.com>
 <89600917-ec58-3a30-dea7-bae2d67cc838@linux.alibaba.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <89600917-ec58-3a30-dea7-bae2d67cc838@linux.alibaba.com>
X-ClientProxiedBy: AS4P190CA0005.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5de::17) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SJ0PR13MB5335:EE_
X-MS-Office365-Filtering-Correlation-Id: 2d11b99c-f5f4-409c-5b79-08db14283baf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uy7M5+9CaUWrWB0H5Q3CcoXCOQuZOM1yriosGDO5Zq+VBDTCldsB3/VES1BF/xkWmyqsX+vmkU1G1WJR2byjzCozDxx2F++vB+zD+0RvbL5/NTrcEn20ji8JSNL49llzjP3shU7opz194MP2qaluv6gYHDHM/frOCa7d6B9JFHD9bdavStCQ6D7/FHA7lF4PpdnKQfzKnmpmXdNYR7LNMQHVKPBc5xcHi2HKR9Ir4XUl4n3FiDGi+2YWv5w1Br4Jv0SDzDsDX975i1cUDqgTvy7nAnDS7AKx8G/R10VYzHGg4n7JdZJDZecMeHcOBzTgOEF7RJc19o80ESEN65OaHzCLmTKI5ULJbHmgnPIYV0cjXhhyS7dDL5da1DV3z/KTtMzfPSEGAAAnpserTa1ZnFZtWVz4ItkMe3Ro9btGsoMgpcYcRkTMfWVsv0ygqu/PdbszmTN6QF8jcONQe5HJYfbJO5mmVfFOkHd0UiKLJqoO/yTFN/iO0LWklXODn6WsGGlE30jP9n0XGiFzPGb8FybL2DYLET+yfUkeNSimFBphpYoSm4y9OcDgJdxXIznVRoIqQk4PDqhJSZ7gHElERvXDx0OwKgDiWiA0qIwXG4/O7kVzxiaH1k+EQyyUf8CuBQ7WYp85fq7jyYGtphoPcA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39840400004)(366004)(346002)(396003)(376002)(136003)(451199018)(36756003)(83380400001)(2906002)(38100700002)(86362001)(41300700001)(2616005)(8936002)(44832011)(5660300002)(4326008)(8676002)(6916009)(316002)(66476007)(66946007)(478600001)(66556008)(6486002)(6512007)(6506007)(186003)(6666004)(558084003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4/UEiG3UcKCFLwyFI8dJasPNwkI7Fqrg0zj+HkA0exB6Qr2oLlkMBzY1cHOt?=
 =?us-ascii?Q?lYY3TbyQXh1iBwwgnfvdbqU4ZtQtQ68p3BpXyMI+3BooMQnbwKjHy+prddnz?=
 =?us-ascii?Q?i2jRTQvWyciGw6ifib3wuHl/kbuJs8B/qyDL1BOzzaEg0id+n9/opsrNDJOP?=
 =?us-ascii?Q?NS53f3CP6sUbtuTkD3ShtzUxa0GkRmAAY6t8suIu/ztYTN8BYSOuALdJ3wFP?=
 =?us-ascii?Q?hDPhZhyChB1kYE5anHaAbKPlteCtE941j/KSCl4t59ZbDr8NQxgJLD/pqUZ9?=
 =?us-ascii?Q?QrMFePZXgo6EUbW2PGglsP6Y4fbjbKXTZZoPA5dowrrLp2kABnQ8vQisvtVE?=
 =?us-ascii?Q?MUzJ05Ots5RuwQ+OlKyvo6xSxCkVmPTA2/NJEGmybcZeoyvF2RuJdv589cJo?=
 =?us-ascii?Q?rcheJ2PVivv0PW7xaQ3rq9RZJQofFIzzQfRPQbVMwoJP4XUwQcw2PSxQErjn?=
 =?us-ascii?Q?3wyDOpCNiP34VDDMJKhrL34KfxG+YQsPjvf13kZcHt+4vPE7IL9uyu50S/bP?=
 =?us-ascii?Q?cnaqAXU3imjskee5bD629kvhfBjrcB7kBcDvxuE99ELAJqPBwYcCUlgQM0c7?=
 =?us-ascii?Q?UEZM7YkHgh5eS3I+nmJnBLJuYM9+tqSm2xspzmzVdMzzTBQM/JKT2V1y616J?=
 =?us-ascii?Q?muAspSb8+29NLu3RH4R5SiFFu5qBazapJ8f++QsBdKVkQbiurvKD2KwVr2tk?=
 =?us-ascii?Q?H31+fghT1ehgoRL/mbusNVeH9swyA7+d1oat+Btma8PTgaWyBS9Pr7dDKSTn?=
 =?us-ascii?Q?thp84+subpRwSffIBEaYBY+IDuclT+qwkclWhUOArb20lmV3DaeF2qb54E6i?=
 =?us-ascii?Q?qOYQsuXHq4KfcPOPLBfJnI6y611hQCyokdJIw7enhRK6wVOvipdkRWwD5+2e?=
 =?us-ascii?Q?IT7syr++tzrwvOLsTVqN+ewwwviC9LhzxmCo/B0QEpxQrCtNyNvpQsO992Mz?=
 =?us-ascii?Q?Umui1KZEfzwZG6YAKVW2jgED3qByB8ZtPVnA8jCGkaMajQLLrFz/hqzcXWz2?=
 =?us-ascii?Q?FVBSWOuwnJcypuJbSvfOKx7HSM5pbfcXQEsEl7EZLDr1F/t34IDZ7i8eGMUY?=
 =?us-ascii?Q?TN8U0jVOMHbLq5ij3B9f3UwOt+ZR4wNKdDVOsdjtgoYT2pesoqPmiAHLjs0a?=
 =?us-ascii?Q?2NEBLLoOOHvB9n/koySTymIAxzqhiy5NDCu1imu4pe5lztsUZ9bAtIySxmzF?=
 =?us-ascii?Q?16+3QDQotNgq8nET1Ez1r3guEhhJtmPy0RA701B14gVet6cITMXWFk6k9eD8?=
 =?us-ascii?Q?x6k9FTLohpA5Y70meOEDPEXB+ap008L7GhOmF0NTibLPQ7+c9vW7z/Mpj4mg?=
 =?us-ascii?Q?ULaEavq1ghNhj9EfmF3KtP1J938OymQqSlTbkAJwZ9Dk9eaoW0tWvgvdJ1go?=
 =?us-ascii?Q?ZT2JyO+/Ws6Xn4qcC18lZCtoWBZSWdiTJZZZaU5ztcGOg/L0+CcNQ1l9/4N+?=
 =?us-ascii?Q?1fLf39O13rvYufor9Ce5Bd2GIp5ZnglQipuY27Pg5hbIKRUVumnEdtiHOYiO?=
 =?us-ascii?Q?XNbd16Tn5fqFN42fW5IupsyoqYgbE4eSElOcWjQnfPiPB4kLQHpaMITH2wTN?=
 =?us-ascii?Q?dE9u1wiK33j1sz1MitHc9uGNVXpcWOgIwmGwq7/zdrRuExXxH9KWWXJlJoQr?=
 =?us-ascii?Q?ETPFuihuPTva93XgdEfbcoAdyNNRTxtBhfkS6LewyyJCnKEUxWPZNxoc/4EM?=
 =?us-ascii?Q?6SMcFQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d11b99c-f5f4-409c-5b79-08db14283baf
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2023 16:25:23.7995
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Iawz3kY4BuFkEVKwm6qbgOAF4JynDt4Lxf9k1maosAg6SAF8Lkkg1zIq4Ee18PVliMMBgEzTozxmC5zHbnpZKUPn5POc1e0Nc74kR+Fhx/w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR13MB5335
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 21, 2023 at 03:29:59PM +0800, D. Wythe wrote:
> 
> Sorry for forgot to cc the maintainer of BPF,
> please ignore this. I will resend a new version.

net-next is closed.

You'll need to repost it, either as an RFC, or wait until after
v6.3-rc1 has been tagged.
