Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4E186B441A
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 15:21:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232183AbjCJOVa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 09:21:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232182AbjCJOVB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 09:21:01 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2099.outbound.protection.outlook.com [40.107.94.99])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25CE42386B
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 06:19:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lV6+ATRLERuLI+dLrDGx1TXIv0eD0ZqZrsjWhAVNr6vPOxI256F5LMlAWKYpUPVYTMtTWJKra80QEXQCN7qB8ldOYEnIP5taV+DJWG958sl7gDRyuJMpiwACBLCs4kU7STgHprzfDG1y9vvuYoKqVKujDGueyFM4xSICeypPF1u3qsSbCHk/mUSfLXrB+EFUfq8l5f1P7zOOQBW93T+wcia3TtgYwcdA4JHzbdGOUA2Ub0V0G1J+lIjFWEYJ3Bf52amXkEVAMK4aWI2nKXrw4EONaNCummEkGwXDhFxRflCoLeYM/AxHUEvTFL3XozDdkLhU368n3EBU8buGQZQlJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FnaujDBH7wZLySPsQHc1fT9W/eYGdov2ItMuJ10pxkk=;
 b=kGu+jR1cSy8iF8siA2LX3AnYELGx+LeApdZK6H/ISJXjOoj0f079Ic0DT4Ekr+purFLNWQOmcCh6f+b8Pg8NZcSQaZX0Lss6nyyOWAfSSrUgLKdGs0QnUjoF9v9L0xC+OWjRlhdHTLj+Z6x11hJrQ+2GPL7szdAaVGQa4d5hiSUC2uT4RXLGpSoMqGIb6xN91sxbU+1DEGnod7DCC7BX1mGhWIrVH1uDwhYqCRwqvglens94RAoi16+toZFfebJvwN11KclVZ6SipVQX6Q5BF7eMrNtoeWuwMsg7z3gN07kLHYEYbrm/xfC8FyKq3JqOc0JVjF0jczSuqDmH4zul/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FnaujDBH7wZLySPsQHc1fT9W/eYGdov2ItMuJ10pxkk=;
 b=nTk8/abu/DzXB4gZL7gOtuMFFjrCPh4INgyfEaiTQ4qtX6qtWM6UVFKaAc1MYyZMlcBPVBlUmznbW3d7l5Ok92Hpx6C1BHONxT8malLtBl00N3T64AgwrMDg69gIlrhX8JxpFB2eH1rhBUYBw93PHz+9LP0nUQPeczUDyJPmhcA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4828.namprd13.prod.outlook.com (2603:10b6:510:93::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.19; Fri, 10 Mar
 2023 14:19:42 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.020; Fri, 10 Mar 2023
 14:19:42 +0000
Date:   Fri, 10 Mar 2023 15:19:35 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Pedro Tammela <pctammela@mojatatu.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Subject: Re: [PATCH net-next 2/3] net/sched: act_pedit: check static offsets
 a priori
Message-ID: <ZAs8d3017dkWbHnJ@corigine.com>
References: <20230309185158.310994-1-pctammela@mojatatu.com>
 <20230309185158.310994-3-pctammela@mojatatu.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230309185158.310994-3-pctammela@mojatatu.com>
X-ClientProxiedBy: AM4PR05CA0019.eurprd05.prod.outlook.com (2603:10a6:205::32)
 To PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB4828:EE_
X-MS-Office365-Filtering-Correlation-Id: ac19a064-7387-43fe-2ccf-08db21727da2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s2py79p8CWKgaTyDP5fF+udOJ2EWMPveaMR7R/w57HcPOv7iHXvS9T0CnirJBHUzjTzNqwySBk+n/mAmoGpGIPkipbXXPTElZ+U+99TJ6NqezlqNTp1sHi5Do0rCbj/jh9n7EBbZyu+Hoyg1WVyevJxcD7LcIHq/3kkmW6bB8jceaTPqpp//5AQ2hyeHL9zxbvoAw/iI33w3xkFdOjoUgD6Qd2bXurr0CiKkzuahc2NMilDEo6JMZc6mH3Z0FJZlZ49VBf7V4nZeL6Xw7bdPw8rA1saRf45Juf8buQ/f/ZC0bjPElNBxtkCbA3CtLxmfOXMx6de0DX+56ppImZn4GMilit6KmiXysHefOwvfjiP6jSERVZCuTB3ypp9IWvTGc5KhMxe+z25CrPYEc8hJq22AJOg474buerQ6vo5SJR1qjAMkn5qYqvEBjdWqTIxsWOtpubdWnqrDMBAP9QT8W3vix49qt0oe1Sq7+ZntQ+E6Z+QsxZ4jNXpbcyftBcfyDAhHUmjUSM6l/Q+6PawGNkcqyXPKQBJbFq+6vlQxp3LR86Nu1HiRe4uJTwFiTtfJL1iWKU6G9sGPTNFr4Yi9jCOmx5L+fYgXmMXRj3Og2z9+KTNONNRcTO9QfgD55+AT0cjuCg+S0fS5hufzopZ+OLqKtBRp0mSChkFoQ5Jx8jaJG6tyHLGG7nV1Qmu92EX6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(39840400004)(366004)(396003)(376002)(346002)(451199018)(66946007)(6916009)(4326008)(8676002)(41300700001)(44832011)(83380400001)(316002)(66556008)(66476007)(2906002)(8936002)(4744005)(478600001)(5660300002)(36756003)(2616005)(38100700002)(6486002)(186003)(6512007)(6506007)(6666004)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MY2ddQ5x8FSWvmqmVwSsVTlmfjNxbzkY7oJedjo2qD120O6sPO7XklGZzmNE?=
 =?us-ascii?Q?g2KoE1eThPW+T5EyJ7bvw6rwyJIcP8wppsM+NIjt2WyFNxUwDGiNu/UeSc5z?=
 =?us-ascii?Q?NiMcvgAYBkD3/H4xF2plPXgGGYCwXQIzFch4OIg4PR+ZRwSXDHsZyskbS8Uk?=
 =?us-ascii?Q?+jiE5aptfvTIaEtBQIRWMYko9HaoiBCLds2+fwF/rhMADJ0V7I+rt3euz9ik?=
 =?us-ascii?Q?SnAJUB6MpmnDZ6q+0kvW44U5Tr2QpYYdZv6hyM6wDEJQexrlWGPMSc2NyNKa?=
 =?us-ascii?Q?rGZEIrOWpYxiVmqYhq5PKIr5oRYKnae9pVg4aN/UsEowrTWDYODulKh8jbnd?=
 =?us-ascii?Q?uK2ANn8bKidD/13a0nZxAl1zkUjIdDjp6cafn0Dae0nuwT0i94MzucRCMp/4?=
 =?us-ascii?Q?Z55V2XDJXe+fmXG9yjLR9vn9v+2eJUT3WshLtkzLExzZY/uKXfyFNMJ1PA8Z?=
 =?us-ascii?Q?/EKUwn2g6TkvigIiZuvwoWjon4mwT9xGhvAtPpAayamKcRyk/cCy0LMmZzZ9?=
 =?us-ascii?Q?s0l/vhskO99OyFkLAFeADcLa6wu1FaxkhCuMa7syf4RNnH8iwBJhAflqCmfi?=
 =?us-ascii?Q?hnJ8RrIefGwGnmMlilGrppMqAZioJssg9IPSm7vLZA6+x2L7uoqHqNExAUQg?=
 =?us-ascii?Q?6VNPxju5wZWS8qG9qnNTiVNctn0ebf7JWxxTaW1ciLGVRPYWo9SGbyLxInkp?=
 =?us-ascii?Q?tRxzLYSLBajCF8ZAR/yXY9+rY/tMz10EDxkZGO9pppdSlEDdxMliptTJZPAN?=
 =?us-ascii?Q?LYsZy1T5vAyLEVDEUOUJM8kMIsf1M9Q+V01ZhNahH4l2vb6JzQS26sj6QI5R?=
 =?us-ascii?Q?4i8RLZeUuWMRAi3lwufes47WKz5XcHzGE7FS9sT1P7kPzNDAINEi2gaCPCJU?=
 =?us-ascii?Q?MzEj086Iere0pNIyKwHy2tbf8Yy/q9zGfhGS2ioYD33B+x07dgdoWiW2dDSC?=
 =?us-ascii?Q?3V4Ptm6hfKTrprTzLmDnOQiDHUediFg1jB/uYH0SMM1oTUlrtFaREQvwt5Ll?=
 =?us-ascii?Q?J48kQ2GmLuS5v36WZd1gzBo6FeVEi+liQXi/fUqSxu66zGaeLthuyy5Z4PVl?=
 =?us-ascii?Q?u7hVTAFZNbytdN+HwrASgKMMiEs/nB75+iqtMTbOgLM+3lS91Ha9uVV/kYRT?=
 =?us-ascii?Q?pCxblFoa2x++Bof4sNUk9rBlif//RNobJcPGE62rpv1+0rF2SpFBTYplGxpK?=
 =?us-ascii?Q?zxzjE7KYfMW/sHwlXhqPyxmXaJH0F8yKq130CEMZFeRuohNapo164R7/K73q?=
 =?us-ascii?Q?5GjYCygcARwVFNFxtG5ZhVv78jL/9d48CYN1uzIBdfEVgVJDwkqMIJwdHwnt?=
 =?us-ascii?Q?w3SjFUYG1nQ/GIiWJKgyebwLTsSA1RFFr6coqPRe6GwWMLfwpB7Zlr7fiftU?=
 =?us-ascii?Q?dZlLTEguBjxYa0mpHGEma7yP6UQXMmPVpKQR89El0yH7mpVrMP/RfRD6cinQ?=
 =?us-ascii?Q?njm0rsGOj8P6cRtOROfA7sGuHYJWC8fA9xujPX435MhbQaUjLUwMUR//FlsV?=
 =?us-ascii?Q?bmQNjYBd4ntlJbBSKSSsRBlkN43Pfzi9LWuK5hcQM2yos35U/SZfLW24i4cM?=
 =?us-ascii?Q?X+eCopvhIx55ctSKfpJa4UvD/j8HcEBcsnW2oHQv6f8mXLuzw8gp8fiUajjZ?=
 =?us-ascii?Q?Iwdudzb+iO8AVvPzUsWCbtJ1uMCWEOOP7rEL4v+ZYOqDYFVfsouvUSIAMv8N?=
 =?us-ascii?Q?lekxIA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac19a064-7387-43fe-2ccf-08db21727da2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2023 14:19:42.2388
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S9gzfwQK4ng7vI9RwIM1/mtqOlr2SUfY+p6ig+d4HEHXrUKAuCtIce262QL2my3YPMFYKmNLF+8Pw/jWxaVbKPPbJoZHHhY3qKW2vmKkWr4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4828
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 09, 2023 at 03:51:57PM -0300, Pedro Tammela wrote:
> Static key offsets should always be on 32 bit boundaries. Validate them on
> create/update time for static offsets and move the datapath validation
> for runtime offsets only.
> 
> iproute2 already errors out if a given offset and data size cannot be packed
> to a 32 bit boundary. This change will make sure users which create/update pedit
> instances directly via netlink also error out, instead of finding out
> when packets are traversing.
> 
> Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
> Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

