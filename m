Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A266547937
	for <lists+netdev@lfdr.de>; Sun, 12 Jun 2022 09:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234702AbiFLHuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jun 2022 03:50:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234689AbiFLHuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jun 2022 03:50:21 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2094.outbound.protection.outlook.com [40.107.96.94])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51EFA49FA8
        for <netdev@vger.kernel.org>; Sun, 12 Jun 2022 00:50:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RRh8rm4npN5jdXbM4fDdPXxx6jwvGyiSOBUPr9IBX1KQor/MydOm/7gxx894ItTIxhEaYqnUW9HS/vIYGjgjBDF3p3n5fHMuJvYHvMPaYfH3OQf63J0jNKj8kTWapZ9W6glaBJaXxS55JJE3SDmaECzKYumeWRUorki6grPS4cQYQGWA1VpVN4wL5Ow9YKD7Ay9/l8xMMWpu2PzNi2V0vAaWzz3h0CKZ8WppaDNnDnEqUwAqVAtd/krajwnX7gQ6IvCPLCiWXF9ciKy/oFLBTpsWXXuNnfUk1Y094KtPB5WO2saaGkKr8mood9Lg/OnNNtGN7byLkk+h6tCSkBFhsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AMNsyqX6F+U0Lli8XG+uG5asTS0l0iXKgfDRsPCBb8I=;
 b=Jgds8NkD6K+oveGi2PXE6LSnlYDX9JQ583qY1QHymGiGcFP37uTIVJi1ueovXMN5kMnq/vnK3RaJnooKGg2kiUUpLKKwW1YXKMhfcmhIyfQSJCyMT9oGx6v1dyc4BGtDaKy3G8OuxJmPLFmhi2as+/DWqlcqslY58vLudTxUJ7lBUDzV1sToSDRoV18lTJ4TqJAkgQqya9ik6ROB9osBe1oJOHVjSxzv+UlStkak1hdmWqEUQaEhAspwtT+ynVlRatRXcRnZGZrs/RaW+Kdfu0i1q/hoSxB8WHioE7t8fXfYVnkYNUcHLpdPUF1aWMz2QaYuFs95KiOVk6TdDvPyAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AMNsyqX6F+U0Lli8XG+uG5asTS0l0iXKgfDRsPCBb8I=;
 b=PMRFerWNZ5Cuh52K17/ITuSutRSxzTtEZlcj8NDNaR6DWU38K8XikwdXiJ5jfqk7yxpdswlu6lCI7Cp1OJpKI8f74jKrblE00WLzbu7rgFAWeWucVsbj2Hr1VA1UdKl0BjzDMVueRTp0fE/p+ciK8QPB5UPFBGFtFufkzWGPRy8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB3953.namprd13.prod.outlook.com (2603:10b6:5:2a9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.6; Sun, 12 Jun
 2022 07:50:17 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::b18b:5e90:6805:a8fa]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::b18b:5e90:6805:a8fa%7]) with mapi id 15.20.5353.006; Sun, 12 Jun 2022
 07:50:17 +0000
Date:   Sun, 12 Jun 2022 09:50:10 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Bin Chen <bin.chen@corigine.com>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Shahed Shaikh <shshaikh@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com, netdev@vger.kernel.org,
        oss-drivers@corigine.com
Subject: Re: [PATCH net-next] ethernet: Remove vf rate limit check for drivers
Message-ID: <YqWasmTu1nGoO9Mz@corigine.com>
References: <20220609084717.155154-1-simon.horman@corigine.com>
 <20220610222232.31c3e0e6@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220610222232.31c3e0e6@kernel.org>
X-ClientProxiedBy: AM8P189CA0023.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:218::28) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fee691e6-d684-4299-a7b3-08da4c4830de
X-MS-TrafficTypeDiagnostic: DM6PR13MB3953:EE_
X-Microsoft-Antispam-PRVS: <DM6PR13MB395330DCF331E145C5E63F50E8A89@DM6PR13MB3953.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Cce7Rn4C/E85qIhK1N6dminlpK+mvMxOE5EcokpRBH8izrtEtE2oaesg3F5qzBLt4XxRqP8BG7ZMYxMw6FP+m945Aer/xkkfh5HoyjzHpraCPvcp9lUOgRjFKsm3CTASQkwZu6aXwe1qShgDvV6SRNPrDz09HaWFifkgshv5dBpxxa3b54BEA4eMEvyPH60MlO88mhB/ERnVd1FeVXXaLosEB3o5xDIITtsY8HZKgYRkwvYOC5CmUoujndqwSzCzOSuah8k/VqDYBgh47vQYTUUs6pnUOqYc9tuTJZ/9sZ2JLpuKFIVG6+d0CO7LqecfBgjUfXOGy0OrZcKBLUHsLM6B8jnzAc2xp+/4zZfzQOWxXM7/YB6KWucgAbi+smsca3VxJaSjSoVr+nuNpV3wxJt+XILjU+TSoTRjQu/iIEhNX3EnVpYxPqFk3L5nueGk4J8LojCQC4pVAQdbj8TwN51xbThVVqGqgkjwGMwYieM0OqAByPgTE6yASeTLYFWynHVycDD/fgGpTsKZgDIfl9sS5m8mMclKSTfZv/4dHRS3o8WV7PNvD+J/TMvoQD1NzFFEiWf7Kv2YEMvMTL3J+tbU4/Ry6hECCLIERBifkmigNsacPuCFtpMEBPmhTHZ3qLMsGlrjI+2uCSGf/gkKOw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(366004)(39830400003)(136003)(396003)(8676002)(4326008)(66946007)(66476007)(66556008)(508600001)(2616005)(6666004)(6486002)(83380400001)(36756003)(86362001)(186003)(107886003)(8936002)(7416002)(2906002)(4744005)(5660300002)(6512007)(6916009)(54906003)(52116002)(6506007)(41300700001)(38100700002)(44832011)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?l0EUoCI1+yqvE4DFJDeyL3CMEuqSDoa3/PIauO2xhqP4nZ32AxIgorchkFdr?=
 =?us-ascii?Q?NRDzJMNQ0nbDWH1HZ1MPDNMAmmP6iv4JDLB//DZVt3+aJCuwXyBvzmFQ241k?=
 =?us-ascii?Q?QubnfWJRlEU5XBABnVbKmv2ihqrj9rLpokcaPuWrN36oP14S2gGDZApB81/5?=
 =?us-ascii?Q?Xd7EL/obyCserAhLPsaE3TDBu7fncDCSyZ4g/IMgPxcwfJgEx7m+LEGC4RRo?=
 =?us-ascii?Q?jYSPKkOVxGqJKgkbkod0lDWelAX0qzJ3wzQHtZXNtLFPP1btINpNagWSdokt?=
 =?us-ascii?Q?jNTStxDY0lUdQL41B2OJR6Y0X5y9rOOvyZqySChkFu3Q9lxsIPmWKI+BdAcr?=
 =?us-ascii?Q?/1BapgRvTe1nZcfZsRQW5aiJFXFWk2UP9qruroOvLqfmfHZ7SlLqpqY9m09s?=
 =?us-ascii?Q?Djfbqy5mXQG9QMhNxRJlW9DhJSOWRdDqxe8eWwumM5q3J+xgKnGWpPnlcapq?=
 =?us-ascii?Q?9/aRJaH4oyxsl/F/Os/eIUJM6iHpxXhIF9hhS0X3FfQ1TmcvmjyFRsJgJgrZ?=
 =?us-ascii?Q?R3pb0rKIuobIe623tKgodV5lQLjWDw80fDRiliMW3uWHt09WeJkHfjyj0Rdq?=
 =?us-ascii?Q?POEFMelknWHbFFvkdeYoZgYj3TEvejFws5OxUayWBrF7gAEeKNEHc8C6oghO?=
 =?us-ascii?Q?JjcsiufyTAN7C24RdDuzv+in1qKUqTRHQzI7RoCGWW16/ODhQOIVS8mnskqr?=
 =?us-ascii?Q?WcKy5EfJqUJxKEtwJUAYjCmUIrM9lLuX0iZHiSU7NcsJ2ANWoyrIC/5n+GWZ?=
 =?us-ascii?Q?YbbUMuubk4G8DbqOlj8GEB3qgMDC8VhgQ2XAfqpPWfUu7U/rJruXgO5c6tef?=
 =?us-ascii?Q?knAWLp2//OVhZlzF03B4scHH3/mEaYmHqjALw37rYV5xPS4S+QMQX10AKjlL?=
 =?us-ascii?Q?jHPnWtqH0ehZh9bIHDH+gWT3bhbzMpu9hw4x8RnWfW7KvOGEiRjBhCHgFGWo?=
 =?us-ascii?Q?W/9azn+22TNply0FIN5l6AbykadpYxN2bxr8pXbEGk96IXddU6M9pJAPaPXq?=
 =?us-ascii?Q?gSFUYspRLxO193psALm6TQDhfdacFb7MkGeOMfpRTORbwNWUycZNtyg5Edkg?=
 =?us-ascii?Q?DXQEQ9KW892g2/43KLZxRQ74w+qTBfN0r3mHu+7uAjZ+5j0U/pqE42NZQ8OY?=
 =?us-ascii?Q?/ztAidq8W1h2RBHFZhaCogRAGAau05QA/h8VU5kNITNspu9FKzpwAjjOBapJ?=
 =?us-ascii?Q?HReZmm/A3FX5Y9+r9rrJSuicCfOc92/9R/ClmP2XJlrQI0fZ6oIduIlTCZrE?=
 =?us-ascii?Q?iSmMWRSZaYR6HHFmUoa4OKFVtoNupPvnGtrGFlhx8eC2f3s/ojJ93an+X6CS?=
 =?us-ascii?Q?oiXdQ9hIrRvlEBtn6TmKpasucXaFRz2oT+zNNt0iSRNBnuMITvEJCDJ9cEL1?=
 =?us-ascii?Q?GC11xPIiSYFueDpsW0D7Sjl4UPatUUXkYEZefjhWmEzC4w/O5RaiXUHjkfr/?=
 =?us-ascii?Q?FC4Qy3Ee+EQovQ/BzaGO/ZXsvm61lgioSDPNr+8DV5jOMRHHK/06v+sODHnr?=
 =?us-ascii?Q?3pqKqdpHsCQZfy7OlowaWftYmar/zcTY+g220R5g+bt+KG/1J6UiSCk3OI/4?=
 =?us-ascii?Q?/LOk8/HIoVuD6D0d6Yu2wSZoyYH0d4fi++/bASUaRve9IYfjsL0IKI5gCbiY?=
 =?us-ascii?Q?j0ZgpdhwDl3WWxXH74FeKlonLtqkV36/qV4i5gLw2g88tKFgP7xjiDGIu40j?=
 =?us-ascii?Q?pusPRhqvmGkAzb0yDrjMeTc45defNijsc50jUaPxVlYWyvu/btckd/05khcn?=
 =?us-ascii?Q?QwvIfhxb7zk6VTK3qmM3wEMTYqMtkYus4BVriXyrp9mP+Yc9pkbtk5+Zy4pj?=
X-MS-Exchange-AntiSpam-MessageData-1: iQE89ZpHxSFhBhVhrJLbNmJJoGLm2gGobiw=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fee691e6-d684-4299-a7b3-08da4c4830de
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2022 07:50:16.9475
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z2YHyaYbs+mvgoR8M81/aSvNiUu0KUbf1Y/dDqaXA5HHjchILCDSFASNzv/D30DpiyXJoHMRwuAhUWXogyo4sGoxrOcK/pqW58luK069IZA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB3953
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 10, 2022 at 10:22:32PM -0700, Jakub Kicinski wrote:
> On Thu,  9 Jun 2022 10:47:17 +0200 Simon Horman wrote:
> > From: Bin Chen <bin.chen@corigine.com>
> > 
> > The commit a14857c27a50 ("rtnetlink: verify rate parameters for calls to
> > ndo_set_vf_rate") has been merged to master, so we can to remove the
> > now-duplicate checks in drivers.
> 
> Thanks for the follow up!

Happy to help :)
