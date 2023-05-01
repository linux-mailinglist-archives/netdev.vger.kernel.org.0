Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 585C86F2F08
	for <lists+netdev@lfdr.de>; Mon,  1 May 2023 09:15:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232140AbjEAHPQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 May 2023 03:15:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232131AbjEAHPO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 May 2023 03:15:14 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2121.outbound.protection.outlook.com [40.107.93.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 496C6DC;
        Mon,  1 May 2023 00:15:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ig8y3Fe5d6rYymbQeRW0vT4gZ8VEux5JlC3QIxsZ7nfQrupEpSO4dutbvj3RWa12m8/ou/CZEYnPwp+mx+6nhS0o7lmCcQw8Vc8lAUoLfAqn2KwNrkWQKk/9BKMofr3X3fE+QaWWYsWBCPiVqyW30yqUEhYPQZdHIpX2AUuDqGX69sD3YCPoIT33FiMm/lMea7vsQUEaszIP7B3qIeIcyzjRskMOtDijynLt+bDVWEX2t7/cAwIg8bwLX0Mr5BPmvA1l3gN6eZSQy328rZ3zSw94sCu9MTqdN4vErwuMk2MzIrfewokoai/dQuIbroF0mWr0biwskWcah2rJqex7dA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HZ8lhp6TCY4qEFioEPyo2FXIXP+qu/eqinEUMg37dOs=;
 b=TAJQpSgnTPegZA7Q2k0TeSB6kBFbP6GPzVUB04LdqFHypooWpqMHel1hyUq7pX6kg7kqxMEA10Nw4sSf7SYAxRie9Nl/dCFGEmhpLkRObuCxd+YqC/PrOFfXnObozmnWw0wtdHhBqAq6LivRJoAFsExePfHM61JsZG9q0XPewbjQq0EfMmyazAUcwmQ43zzZr0vX4m/eSmU24FLjovlEEH7EiUF8e2f/y71OJSQwQk4asfu5p9NLXc94msI8g2YuyDYpQP/nBfHZ1RBTuR8GCMUK1WwoiqV6ZQ7/7y0M5+4Gme9f7mRNfGlZ1bawDq6jlzu3JyxOCQyv3XNZnhkVzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HZ8lhp6TCY4qEFioEPyo2FXIXP+qu/eqinEUMg37dOs=;
 b=A4QjWAVz/VYtoHNB+2HQfhLRl29rPlcTUIqqp+QQW5PpDi2pOzYP2H2YkjyO451IShzu4QxBfG65+w8bMG2sv8UvrYnjRtUsVjo95BzVWJuqqoeR3Fh2lw+HDbmhJ8PZ2WG/2PcmFA+bxYL4hnIiMtVaD/pf4apxZn2SlgzCOZI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM8PR13MB5207.namprd13.prod.outlook.com (2603:10b6:8:d::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6340.30; Mon, 1 May 2023 07:15:10 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6340.030; Mon, 1 May 2023
 07:15:10 +0000
Date:   Mon, 1 May 2023 09:15:02 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        j.vosburgh@gmail.com, andy@greyhouse.net, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        bpf@vger.kernel.org, andrii@kernel.org, mykolal@fb.com,
        ast@kernel.org, daniel@iogearbox.net, martin.lau@linux.dev,
        alardam@gmail.com, memxor@gmail.com, sdf@google.com,
        brouer@redhat.com, toke@redhat.com
Subject: Re: [PATCH v2 net] bonding: add xdp_features support
Message-ID: <ZE9m9mXMVBFa4sKr@corigine.com>
References: <e82117190648e1cbb2740be44de71a21351c5107.1682848658.git.lorenzo@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e82117190648e1cbb2740be44de71a21351c5107.1682848658.git.lorenzo@kernel.org>
X-ClientProxiedBy: AM4PR0902CA0016.eurprd09.prod.outlook.com
 (2603:10a6:200:9b::26) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM8PR13MB5207:EE_
X-MS-Office365-Filtering-Correlation-Id: 557cd8cf-95ad-436c-cf84-08db4a13cc81
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e/XUWoXyVP6UD+b9ZMm4HQsUcCPlJFDfluqrO9aG3fKqDpjRyyafEvrZNYttZFAmLvMJyNa+2RR8FVROe/neFb0hLw64LYjrbzKcpeT+x0yL+ALIxioNlftla4PDD94hca4IhTWbsYRahOGFQgl/QHX034IHrA82BCtQ6def6PWBIr+yrB5XA/6dizriNVlExBJzyyARjlVXba5+KmV91CT+dtm6j8NBoyoE+P8U1Qpb6jjPNyLaIb0eaptjJfRZklKbyazz83+VkOdlkjxK5xkRSaAXGiFrU6UI+Ru4ZKB8Si72BrgTvZwCRZ3/8N/ngsU/MyFftxPxruGfdBPdeGCdlq1Vf8h0z8vk4fT1sYE6vhZJdOdjBqsAmJoIIxlU0JsBlSVo4opCGgqKIITkOGbPuRc+WqAaK85rzoeQN2JvABF+zocCAEAa596vKZnMkkKT4pSZzrsWqwl9rWdBzZYMAdkwdKvASecCVryuwbcD5mtP0WNYr2Gl2JdpMYpLeEiQijSUoDcoKIDabxu3ViEnF0eHOBEFzGhL2/CkEHCflrC8UsxW0r1+vO9uxOE+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(39830400003)(396003)(366004)(346002)(451199021)(478600001)(4744005)(2906002)(66946007)(66476007)(66556008)(38100700002)(8936002)(8676002)(5660300002)(44832011)(7416002)(41300700001)(4326008)(6916009)(316002)(2616005)(6666004)(86362001)(186003)(36756003)(6486002)(6512007)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/F25pgGJ8O/lNIRHrMFD5YdxlH7djZPujYXiNF1yo0QwXLnhMiT7MefXb5Nx?=
 =?us-ascii?Q?GKeWEeimxw8poX5PZGMBGggTfx7icSLUlCgw5XtUrrVLStNj5Sx7BVTNscE5?=
 =?us-ascii?Q?y20jMyqQi7BeOTcG5GCJ95q297rghehvbehTLiDYB1/vfMqRorH5Aj2w/Ok5?=
 =?us-ascii?Q?uhyyziMQ9EM75vwMofmhltp1GsoAdvtn1s5ljQEydszwVBM0nj5wf/Uz8J2Q?=
 =?us-ascii?Q?qNOqVf1rFqc9djQjTpF3v0AewH9R7mLBP9tf+1Tx/+Ac35Jum0U4du0byuTg?=
 =?us-ascii?Q?oRuKCHblVEwDQdNy97NCxV5u+T3EKJDanDiGUAOVE81az5hJp/W4XI4+tBOZ?=
 =?us-ascii?Q?USPw0gZPIciXMhsve992/bTqqSIeKrSE0YUINdgfYUThs0Ar/hbKbW/nHDc0?=
 =?us-ascii?Q?d7CDdkm2dtcEKA0I66bnelh3DVTwu7OU0IJUE5tPZoWVw6W8jitGXUqfgth5?=
 =?us-ascii?Q?LYrmOHBkDFAscgWdQFnCbUaaBoPPFEPJbdJW1ZdOV/mhgAAvof9KS1FTRisR?=
 =?us-ascii?Q?hjYYw4HGNIBs336gipdrIP8OBM1GhISBh566h1SA0avwBmVRRlcYyKq3j6+Z?=
 =?us-ascii?Q?qc2O/CGKzRlXjy641p4kqK/+MlfPqLZPGC+76Pnej8mXWjErK0sJtQPKQHu/?=
 =?us-ascii?Q?PLmPS3jTpDOkzqmoASDseCWrvH40MU+yKq9xY4QoupjcQ7GrqcFRl3D+y1Io?=
 =?us-ascii?Q?IbsoYRw9iN6nfwqCsSb+oQWZNruvBHjiNvvPGXRiwg0mUm5JNTvfL4KEZCRf?=
 =?us-ascii?Q?bqfgww+erj2OaFqFOb5sZArAnNWzq/zuEXJtJyTof+p4JYIxFeVhnOU4mVP0?=
 =?us-ascii?Q?SWkvJezammQA9LyreJr33ovwFabc/OD1JvYCAOD9v7//o2VnlucVzOY9jgND?=
 =?us-ascii?Q?wjDnqVvZF/FjsupoW6eXYBQK+wtJrl23XXdAYMTN+/XbJHBorgIJLrysKFPE?=
 =?us-ascii?Q?6lWJvF1p6BGnnyKzYrsT+dLXTncZwvENaKRmuUXvnYot9yNQC3fpqSGZIjOG?=
 =?us-ascii?Q?zP1TvjHtSveOX3RBCKX5NdfGs1+lzsD9UamMqva/cWTmztap2GRqw5kzI4cF?=
 =?us-ascii?Q?+qXq/I7ephaxdcJuPMwnekV1r9hRe+CHaZ6UNsKpLE6xuzU1AbxzMtECjpdI?=
 =?us-ascii?Q?auQKjmuIzR1iErDALwfovAdVYZf9+z8Am2aTI3MhyHr/o8+vjhGGUvWJ7Tnb?=
 =?us-ascii?Q?O0F+A++54nzDYO8Dfmr0YeCXxmLbGjPLKq7IPQOX8wQhgmzkQDIkxfOVq0yK?=
 =?us-ascii?Q?dlQf8u+AnIOqn3s576S5BoBUgEJKldrQ4nHJ7yl/iv+OcCKoq71U5LZebZ8b?=
 =?us-ascii?Q?WCfkTfGQ1aMS5/jCDShhBds8ZXMzWLHggkmj0Y4jRk1j4OLnBMNoRZrVgnQZ?=
 =?us-ascii?Q?2md0wVkmSpjThBcfd0Ue1lvNN6IZCO1YF+mU4h+3qBn7qWtS0U+YU69fPnBa?=
 =?us-ascii?Q?bR22h0HhS4sQDSq6WnSEAoAx2EeVjn7oUDgCZBncSIfy5tua45nhRFSPJVJV?=
 =?us-ascii?Q?YkEJLU9pDfZtTa1GXEZL+vGHRRBBNbOWjNKsWfVWSY0fs38p5sH/mz6h3Zpq?=
 =?us-ascii?Q?G800vhsCX12LJ6rKLK8F6odhpeHK2+BIfesyQMGz9O2VWlGiPICoQqZQ/G0B?=
 =?us-ascii?Q?tU3oBz97s/KHZWL5H3yxu89gCwH6GxYkrb3mZ5OyC3deUQ9Xs1zure13BMfj?=
 =?us-ascii?Q?2SvKTw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 557cd8cf-95ad-436c-cf84-08db4a13cc81
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2023 07:15:10.2493
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wex+i9m19rFEfyLhojMDVyVkGJssZroCQUu0SxhIlYy3j0lqGxum94koUXEy3xpI6Hm2m28wyDsRVXBWNYd0UrumCeiUVBz+Euwyv1ssokY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR13MB5207
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 30, 2023 at 12:02:44PM +0200, Lorenzo Bianconi wrote:
> Introduce xdp_features support for bonding driver according to the slave
> devices attached to the master one. xdp_features is required whenever we
> want to xdp_redirect traffic into a bond device and then into selected
> slaves attached to it.
> 
> Fixes: 66c0e13ad236 ("drivers: net: turn on XDP features")
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

