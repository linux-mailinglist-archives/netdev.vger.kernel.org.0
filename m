Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB02A63F0CE
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 13:47:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbiLAMrC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 07:47:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbiLAMrA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 07:47:00 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2129.outbound.protection.outlook.com [40.107.212.129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA6788DBC0;
        Thu,  1 Dec 2022 04:46:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=afoSxyVMA/CsWFOfYw9M+36KGroeMeR2VsziqV609pcrq/r3xD4Rd5kfZQ4cyatADY1qqnCx3l+X3/mDGz6BzTmsrEWxABgSzsnX4jxqvqreU/YSrObVAIGC19/3TG8xauxfjk3sivMsow64SjELAtEYRULEc+WfmjpiSrTVT1sK0O1pb6ruGNF5UmEf2MkCkR4r5HfmAH4vkUEnZFoUUOoIHFm5D5UhMhlyGwvp3fXDYPV1wonLp5AB+QFpT7wbk0E1eq0JJ9P20cNgsAa7V3vSxXIBHiDABPBDvMLDfZDmxwSQYrZypvogzslvtkNqz3M23/RjM4Ao3L0gQWcRDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nlkbSy1y2B7Jr/HntVQXBMCg5MuC3tbkyjmI+PzuAX0=;
 b=cXHcsc9JGhJigldUIu+brN43l89QFrhE9ZJK+LHS4c/u6paQSmq2OhXq5PNRz7H8nZBU5q5i7dnygDrsb7F181ijwfe/Hz6foNWDZ/SDQh/RU+tUk2vsAZNiBLT3kJt2x4+PCTzwbYLhYdQZVGauBxKeE56jp4pldQYH4EJIszz6KqDmL/xVWipsYfFzvXdvVT+ZM/Wqi9UO2E5wAYlk6XXUzhilbJkO+dIklK7UcCOPZdNiAdPBi5cgsdaJkgQxCL8IN02E3FgBnvNsgb/3lHfY+qPkBwSzVTdBntGcophxRvS3FYbxpUUcURYp+Cgj73c3wGwX7r6jyWninO8vvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nlkbSy1y2B7Jr/HntVQXBMCg5MuC3tbkyjmI+PzuAX0=;
 b=aFRsacsZ4lpEC/s869KB/RfPMtDYYK24+kn+1c8/AiyIKab8zBTNLS7AEDwCWe81zksMuce3xC0HCw14qczeOEnbjFnpKA+jc8wmA+I5JuYiXExR2oIAX2Vs+wbAnQhXUYWfKExaJ5ca4uASzv9cI/dmCqg4qtJ8WrTASuK/YqU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BL0PR13MB4481.namprd13.prod.outlook.com (2603:10b6:208:1c9::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Thu, 1 Dec
 2022 12:46:56 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::483b:9e84:fadc:da30]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::483b:9e84:fadc:da30%7]) with mapi id 15.20.5857.023; Thu, 1 Dec 2022
 12:46:56 +0000
Date:   Thu, 1 Dec 2022 13:46:48 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     wangchuanlei <wangchuanlei@inspur.com>
Cc:     kuba@kernel.org, dev@openvswitch.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, edumazet@google.com,
        alexandr.lobakin@intel.com, pabeni@redhat.com, davem@davemloft.net
Subject: Re: [ovs-dev] [PATCH] [PATCH v6 net-next] net: openvswitch: Add
 support to count upcall packets
Message-ID: <Y4iiOBzus5v5aOIP@corigine.com>
References: <20221201084601.3598586-1-wangchuanlei@inspur.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221201084601.3598586-1-wangchuanlei@inspur.com>
X-ClientProxiedBy: AS4P195CA0026.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d6::12) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BL0PR13MB4481:EE_
X-MS-Office365-Filtering-Correlation-Id: 8eb72c82-8f5b-4bde-c149-08dad39a203c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mjSlRjXM7o65DIYTqKxMNCmm9veEAhP3/C7+ZnFJzxG0vIjudgCw5LqyGNFLLJP+8mxCmqoBusy1zF54IZRYP1L0XPP8wI07KdiU4TyJDsp7ADBAvgUSKJ0BZrTbLT9E2wB9oz3uBd9DO4NjX4LdkSFIQvFIWT0QaVv84ktN6p7BM1PwBclXbHoP4QyWR601iyWHGk+3QcpGy8NRJAOqRXRjQv6KiODGg2L5iTYdPCUrC6IFWsEe40XYmvJULXCG1Ies6iBIg9ymPDMADICUjk6yh4ihF/z1lg3Y526EcLDDma2fSp1yDjvhkfCxVl8ojTTodRy28paw+qh+9zVrUp5G3YJ7UhCEiEBp8JQrtRsJjYC14XGtx6I4tnv8lWDwRrT2eK3XytjuejhjGpLNr1Lyp5Mvf8DT18tiuJBigNuu0IIuqGY1DYHaaUfG5L0sU8jziBSSfvZWz20tQOGj31YW427buWL0mSNibLvHPqkdroGe308YEDgHmCpUHBfsC8MGXd9J/8dwe6E4ZSNMgWVqI27hgCfSGfpL+Lvkk5QaX+RiKw5C7rQNhyy6yeTEYmYZZNnW9CvFe8CWzZK9qWbJa3yTJy5G+MnYIV7f1EYeoINXheNqBM2e5fX+9F/ujNJ6Qj1M46LxZYXvEhcnrSYmjkqkisKLWdWFOJwzdPQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(376002)(346002)(136003)(39830400003)(451199015)(316002)(4326008)(41300700001)(8676002)(6512007)(186003)(66946007)(6486002)(6916009)(6506007)(66556008)(6666004)(478600001)(2616005)(86362001)(966005)(44832011)(38100700002)(8936002)(2906002)(83380400001)(5660300002)(66476007)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?A8kVj6iQl10FPcB4sTbD+h/Xx6oYJFXQvD4oDr3q2XpqcF8NDpmejBjzA6EA?=
 =?us-ascii?Q?vRqNOdIVyGVeaxSkacTmjB35Q3mvMOPk52OJ88ydFgNfay2rlj7tH1NoZYpQ?=
 =?us-ascii?Q?cZp6jy7Rap6PLRrEN+zr1w9DubDN16epCH19n+KvH5mNtTeeNm7tQ9/XPz48?=
 =?us-ascii?Q?cPRJXmCIp9sys4+i0XBp0UZodbU1/d2AqfC1msWnn3Zvm4aDOO5UssQkmmZ6?=
 =?us-ascii?Q?mllOS4tsi+5Zds/Nm93jxkpxhIh7Ya3ZMFINcNIf2OAkjpvuV8NH8Nrt+P4j?=
 =?us-ascii?Q?lV3hdweQLW5lYb2JSw/am0lqHyIIEvH9Ff9YABclNR7JGkKuuorYaiLexwIA?=
 =?us-ascii?Q?ZmosjHTuFDYqYEyazXL6LXXka5cJ3hrbdR/9lW5ui1cuB9+ncbZil8DSuQ8m?=
 =?us-ascii?Q?N6ecm8HpG+er/6TjJTQS/edSBqfnAQ78hL3VOORZdQV9koS4pIfamRG+DPQc?=
 =?us-ascii?Q?jel53ASxO4pFlLgbBgPb0TkrBcgR4ZC6/SXrfByt+bbKC9i1asAIijJgF6ps?=
 =?us-ascii?Q?Cb9Uo4UDweuivMV00kKKlWqAAbcy8rtuXNUgB09CD8vyEUv44VT+cuat/RhV?=
 =?us-ascii?Q?7AhhZ1VV1ykkkTrNrxzA1+uRUixZl0UiY+OT8YfKIYyu6rBRkl2DtE7sIzxi?=
 =?us-ascii?Q?d1c7ag7uuiwHuZRgC/rbsHA4XF6g3AlJGqZSwlHnL7XYQhotHgTAvr6qabEi?=
 =?us-ascii?Q?FwoEX7e0yoCl9FM49R75VQUfWq7iynICyBUoYwKKE1SG1a5dmmgmj2xQyAYK?=
 =?us-ascii?Q?MO++XN9MjK7YjK6qDfXg22SKS+wrU3tga8Jo384NDsuAlfONyQt97UVGAUmC?=
 =?us-ascii?Q?zWjY+/Tbl17cgY44jjU6LNTNhVD9JLaWHxYGHab+cryTcjCJywVCeErpBEcl?=
 =?us-ascii?Q?XH+J6/FqozvT7P2O7AoaYqFRbpZc2Gi4raF+ZnPkukecVw5ONxWAaiNJI4xX?=
 =?us-ascii?Q?X+JB3jmZrW2PjRApPpaOoX55s+x0jDvR2dq6lTYrgAIpRBOGd+NTMVsewY/g?=
 =?us-ascii?Q?xO8BUGfFKwXBIhISCEt/YZB9mypxJtSHFknXY3QkWl7g9lxw35s9bqUWwI3d?=
 =?us-ascii?Q?3IechsvZ25+hWM6WyJ15bHBNxySTkh0R21qSbZ9kd165IgoSygCbg1ZRSrNL?=
 =?us-ascii?Q?XpJhHcYJ4LNzwbwVsQG4fN2KQSFP6GYDpficqldJl1cQEWPMy987kKiILt8D?=
 =?us-ascii?Q?9+9jf1rdFiBk5pfL15lEVxNRv4qIISeBXC90qzKmsFMRuk0UU56h239euHGd?=
 =?us-ascii?Q?68Ts5FAg0HDhr8HCfp5a1q7A5OUfPHkY3N/JiWzTGxqyqemE/7R6Xlu2PXqn?=
 =?us-ascii?Q?QJkYAK4UBKu7F2B4Ygwmo9Vw5zmtjm4PouSo1TFKmtOUAmFh8RkFSTBtCBJU?=
 =?us-ascii?Q?6DZKzBfu+AHRQFJw4GuVw8HQ0Kximt0qgU7etPcCshMub47eprauybNmp71U?=
 =?us-ascii?Q?+U3afjEMC3ljWa2DUZqu0PqiXwAmpkfYa4eRgXRGNx1p1jUkBq+NYV+0G4Cx?=
 =?us-ascii?Q?2oNv+I58JLWvgMJgs35dWTnRLq3ARlkm4TaHw6IMyR8CMT65td8YYIXZlsrb?=
 =?us-ascii?Q?zs7bFx6XV13E/XH1ofAhfyBKxCJHcO33aATCOlrpxBYpFwQkekbck5NexnhC?=
 =?us-ascii?Q?KDaHAa3p57dXy0uLxZaRj7ujgZHULfSVqlVRYUVGX9O2ZRP7pPlvdjTCqqxZ?=
 =?us-ascii?Q?V/2Liw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8eb72c82-8f5b-4bde-c149-08dad39a203c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2022 12:46:56.3458
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5CpevlpZgKHlf+WEMBnDk3B5zcE+hvK9qdMXR3LKVvE5KX+m8+5yjAZxfe5jY5LeUOrndTq3MF9NGduCR4hkxzJp2tU75DpL6JxlNrwp6vc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR13MB4481
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Thu, Dec 01, 2022 at 03:46:01AM -0500, wangchuanlei wrote:
> Hi, Jakub, 
> 
> 	Thank you for review, the comments below is a little confusing, can you
> give a explanation?
> 
> Best regards!
> wangchuanlei
> 
> --------------------------------------------------------
> On Wed, 30 Nov 2022 04:15:59 -0500 wangchuanlei wrote:
> > +/**
> > + *	ovs_vport_get_upcall_stats - retrieve upcall stats
> > + *
> > + * @vport: vport from which to retrieve the stats
> > + * @ovs_vport_upcall_stats: location to store stats
> 
> s/ovs_vport_upcall_//

I believe Jakub is asking for "ovs_vport_upcall_" to be removed.
Or, in other words, to refer to the parameter as "stats",
(which matches the name in the function signature below).

> 
> > + *
> > + * Retrieves upcall stats for the given device.
> > + *
> > + * Must be called with ovs_mutex or rcu_read_lock.
> > + */
> > +void ovs_vport_get_upcall_stats(struct vport *vport, struct ovs_vport_upcall_stats *stats)
> 
> _______________________________________________
> dev mailing list
> dev@openvswitch.org
> https://mail.openvswitch.org/mailman/listinfo/ovs-dev
> 
