Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5855B53D638
	for <lists+netdev@lfdr.de>; Sat,  4 Jun 2022 11:17:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233862AbiFDJRZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jun 2022 05:17:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233875AbiFDJRX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jun 2022 05:17:23 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2111.outbound.protection.outlook.com [40.107.220.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9197C18363;
        Sat,  4 Jun 2022 02:17:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NLj4MoolHyOBui6m1DN/S7jm8qqyyEHSNOaKyEDtzO8Xz/+MpmHRT8ZA78wsAo8FIH+bvnpSvhqPG6Rv3zVZobPhyQhwMVHib5Ig/OiCSyrMdZTIUHCEcIwIBr7XSDay2n5msuWTEJ+n0cZ5sQaB+eF8Zdu0ODjahiPNF3gFF4C1u1lE9VAuX0RgctbbDyrY7vssDSCc5lFWMe5b2p7gxKDK97m5mYN/rNElK7JDwJzYRQ4Eiur1U473l9fG16M3y2wHLaBdyuyi+uA3yQ0UVvEfH+UB8P+HnkE82EvOdsR9DWCdqtYAEwf8Ird823Of9LeBL9sOWy5qgVXVQvJVcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QANfk8E8Q2x/7l0kNoC9tECn80DI3jMegtQ2NfrdXVs=;
 b=fZuS67bGsFbnt3mVXMvCRIF1vz6X5XTOYPWJlhtbIkmnnwaPsvKZvncnaUtglsnhT1TLqdvK30XR0d6shzfyfthNxqhBQf1+cBDS32Qf3XynpYHMeX2c+zHU/a6oyfvDr38p4oZJPpWfhLDbjYaIQvWzEDk6HLXLjRMso8qk0rFWlTZzINUj8lQK1QsS72wd00EMF4UMQGmR3XnG+2Et1J7g4Lhs+CTIWuEKHL0cziZEFKz30WaBH5rvQm5vXD3POpew1EkH2Pm2TkbrLAISpCdJ4aIblmP+uH59rL106eCu/7gczidkNM60uQBftvTtkkrGll3csdACsmG8tMID9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QANfk8E8Q2x/7l0kNoC9tECn80DI3jMegtQ2NfrdXVs=;
 b=kODU5thUkFEiYgeXIyY58Zn4xgtlOxr5oW7/8A2DNgXReeb2xBndUk8aAtgLo5yXt3NWmi2zuK93hzgzv5QRDNJrhkSuP72foiUGKZohFImBB8ct3DqVJsZHFXK7TaHlVP/KvBzJykMMaLR+PEnD7WA1Yi1hXzqCCKkuIWeLa0w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM5PR1301MB1915.namprd13.prod.outlook.com (2603:10b6:4:36::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.13; Sat, 4 Jun
 2022 09:17:17 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::b18b:5e90:6805:a8fa]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::b18b:5e90:6805:a8fa%8]) with mapi id 15.20.5332.006; Sat, 4 Jun 2022
 09:17:17 +0000
Date:   Sat, 4 Jun 2022 11:17:11 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, oss-drivers@corigine.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH] nfp: Remove kernel.h when not needed
Message-ID: <YpsjFwNv5s14sdhD@corigine.com>
References: <e9bafd799489215710f7880214b58d6487407248.1654320767.git.christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e9bafd799489215710f7880214b58d6487407248.1654320767.git.christophe.jaillet@wanadoo.fr>
X-ClientProxiedBy: AM9P195CA0010.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:21f::15) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5da09924-d7b1-4f53-ee87-08da460b0541
X-MS-TrafficTypeDiagnostic: DM5PR1301MB1915:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1301MB19156ABD69D44927FD6DB1EDE8A09@DM5PR1301MB1915.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pOemFl57D1GEyBwmzCWtf3GthcbLHaXf+Q38qGlcihPfaf3HtHekwNKuCFb/+YpJh0MDnojcYocEsswQnb66JRIw3mKZjwaefxIljXMKv+Iojoz5bZ+iS31r7yNhZVHVEuRYB3NapuyaycMR2LdD0mEBbM4VzjVwNaI5xJ8Ct9I8zOlY6bP0aed+qa9XQK2wevE7+xaOghekuRAtqPKdKsN17cz0pdCY4/iq83PmQpXc6kZJgom38gATzh/qhc6QIfGRSmjgU9eBTykqBv4dwUjZXZpVeT4/N99eMX7XMOvhBFjSsxL+C3iSHV2iS9rKUp0yWKRyuiJLyHmILtjzRQ75/ajGrIXCqXxO559pS8g6QGod/+SKsmrXhOcxJNanu40CgVy1jCcKgD1WhqafkflDX6BXmpE8hcu1S2u81x52rV8Q7z3kMA/HbqqWBphCz/qk8L6Q7Zhuf6psF3Od9tNtIzeAgv5mFoz+HxrKWBeCO0bqDpSeWhnQhvTuyxHhPJY6TKCehqtRoOLTMeFC17nb5MjLa7hYadAmEAOdRyA4jDwa3bVAcY0kmJ6HwcWVJhbnFJ5GM4bHQgJWBF+qxAcDD92ssfLjRfD7xZD6Kfp39w3WlNbfnmhZ5PdrpZ/+dNnUk61an1tgkAa6uGkmJX0P3oie/9zGkvrArc+A9UE4FKXUMZxVpVz6nuMeFh4u
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(346002)(366004)(136003)(396003)(39830400003)(52116002)(2906002)(316002)(38100700002)(8676002)(44832011)(6506007)(5660300002)(6486002)(6916009)(4744005)(86362001)(66476007)(54906003)(36756003)(6666004)(66946007)(4326008)(6512007)(8936002)(2616005)(508600001)(41300700001)(186003)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iEcyKQGQYrvOSh9r1yE23782+1ZJ5DkvNZ7qq2NJe+ZQKoKvrguEELl1PFRI?=
 =?us-ascii?Q?+JVo5c6j5KV5VqnjIMorX9pqtqXufb4TwhABFCM4EG5Hgd3JMlv6KrYHFSqV?=
 =?us-ascii?Q?AdbnMCGEsQNfxVc3cJgmJMAcAnBjoZDBEQuDe9FE8HoVU2zhdyBhma7HVm5p?=
 =?us-ascii?Q?EfJs3DNfG/7g7HZt5a7ENUeWn8Y9XtYub4zIlPCQMJTqDqN0EhEqUJ12SAQI?=
 =?us-ascii?Q?RdmetLNKsRC4OMAJ+mfC5OX5eEWiMfllEi5RZ1BvmVi/I9MclFtaDBIFQsJK?=
 =?us-ascii?Q?RJeJWcYh19eA4y1H4+K78VAhUmPfJZpWH/VuWc5j28bOEK5a/aK6V+Zh71Kx?=
 =?us-ascii?Q?J3n+KoBllqgWdv9IJ6bzR8L2qNp+nY1KxA8dhlUh8sDNnl38mD5aXDYLyXXN?=
 =?us-ascii?Q?L0wHaewIqGbd55/M7rfHxA9aTJjR+G4P7HjpRB/bMdun45LPikOi9YjprWPn?=
 =?us-ascii?Q?/EqkN/i6XzH9vMntbBok7+h+q0n/ETxP8ZMC34jTvlgXwJNEPJ1/QtwnhbWY?=
 =?us-ascii?Q?Lcco8mL4/tqvLN8CpzhaHrI8e4JoNUOVsHU72aVs4urpaYP7OsW8VH8UfoM2?=
 =?us-ascii?Q?yhsqrPZ0HEN7aCbOjwnHvwDqbjSwGgfeMDUYxKaBr+7fvVY+ptsaP3kbaikU?=
 =?us-ascii?Q?xfD4EiMIVhkowg3wdMRIBTBMy2wfdten0jxLtG3U/rYu/YrArnYgH8Aa7u51?=
 =?us-ascii?Q?3i58q2b4im42Z7lS62+Odu03g85gHR6Oz8rHnFmo3IRh0ubNAhwwJg+Gr69/?=
 =?us-ascii?Q?SsedeLezOaFoz9J0HWf/44ywqqNIvXhFZLmuoo/aObwEdhEmn9C1aWGJw36J?=
 =?us-ascii?Q?vbLylCO7UUYMSfgtNl9qvriyhbDuvue3awRd8UH76m95Qmqep8vomwDqESl+?=
 =?us-ascii?Q?B+YjoCS+4wegrM+S1mChD0F8eHeDdWtMlzgF3Qkbk2YrB8+M6hLEiSi/LSlp?=
 =?us-ascii?Q?z2UpXjSnNcwlXgyyaD0sQvk/pCaMRjgR0M4Qj3SQF0tsStyBbMMGcWGOtW7a?=
 =?us-ascii?Q?Fz+WEEQ9A4bBghoqWUMqbGLd3tfYAGlW4XBVvMEm+/G5VwVwlZIiwLSEAVUH?=
 =?us-ascii?Q?ZbF7eEyKkqlaCe23V1LDEMl7PPgHQuSX1migj1b0ql7UdrtiAJNHsLeka02v?=
 =?us-ascii?Q?JeEXTsng3shzj9yBUF5QbJH/ArOkSPzulHnFWEeElleQZEg/nI1Z8uRPjFrL?=
 =?us-ascii?Q?BCKi9cIRoZODUGJI3KR4yY1DtlrImb6mkQmkO1PhyT93Dy8RtYEbZAAKqOZd?=
 =?us-ascii?Q?p/LfxmhnwQuorNFb9rTFqot0/bhzAw/SuK4Wgm5UGwZmP6PMgE12SkhgUqCy?=
 =?us-ascii?Q?G63SJB/D/IBBOFY3v/sN9wKoj6k84B/TeMPaNKySa5qUzSMrFcfHFB7VBGlS?=
 =?us-ascii?Q?ekqVitKCbmwYuFPKWHg86Vhp9BSBhXUtgjfmhIkb7KtlvPehmrR32U/c1x5J?=
 =?us-ascii?Q?6S6yVNQnVM/zriwja6bbWp1tB1J2fb6MxRW+JuW91z9kN4uK3mUlHvJQ1RwY?=
 =?us-ascii?Q?vfbbfjJXf+UgRHDfnrMRiy4Ze6ZVSXfnOqWaIzY+mwpdERcOUn0CkuJDWgEF?=
 =?us-ascii?Q?jd/Wi2MR37z5WQqYNIcvfImidlDPzdT0h1FeB9s2PlkCQ+5F6kPHkKbf9K4p?=
 =?us-ascii?Q?iWULUauzIeZukl0rSzWotsJcKbu0sABGGiqJFht/jQyYp8Ya/IBqVv/8blWe?=
 =?us-ascii?Q?b4NipMCe0G2NRE08hzdMyDFwYqeDNXTMxBnEzos80dRaKsP4EMBf1KIZQHu4?=
 =?us-ascii?Q?mxCyv2j4HKRCR9ZvItJGQGi/d8A+0bLytPTwnu/2OnwHJWxTsf5Xu8d1q4Z3?=
X-MS-Exchange-AntiSpam-MessageData-1: 8r7Z9EY5orquUsb/EqtGCuWHslCzhbhS6m0=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5da09924-d7b1-4f53-ee87-08da460b0541
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2022 09:17:17.4387
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jtWeeEYHpTYg176AOoTviP1mSPqGgeFfV4FBHQtzEHpiHKJ47VcVkrpfHLpjmecHR/9yhaDZkAu27OK3fssWByB8rm71WSuo607gJz5ApQY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1301MB1915
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FORGED_SPF_HELO,NO_DNS_FOR_FROM,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,T_SPF_TEMPERROR
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 04, 2022 at 07:33:00AM +0200, Christophe JAILLET wrote:
> When kernel.h is used in the headers it adds a lot into dependency hell,
> especially when there are circular dependencies are involved.
> 
> Remove kernel.h when it is not needed.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Thanks for improving the NFP driver.

I think the contents of this patch looks good.

Reviewed-by: Simon Horman <simon.horman@corigine.com>

I also think this patch is appropriate for net-next
("[PATCH net-next] ..." in subject) and should thus be re-submitted
once net-next re-opens for the v5.20 development cycle, which I would
expect to happen in the coming days, after v5.19-rc1 has been released.

I'm happy to handle re-submitting it if you prefer.
