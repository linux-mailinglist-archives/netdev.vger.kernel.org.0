Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CAA86DAAE3
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 11:31:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240378AbjDGJbT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 05:31:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230261AbjDGJbR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 05:31:17 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2109.outbound.protection.outlook.com [40.107.92.109])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F4757EC9;
        Fri,  7 Apr 2023 02:31:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cjho4gDJnvo5PSRoOgQ1e+rWHoIvNjKaBs4PalXGc7DbpweANvG1XNr55g4Hoa1MCMje6SKtz1KYiT5oJQHFcF1zI2Lh+ESdNVwMvdNCw6NCxt5Nm4RJ/CQMTKOBOumDV0+/kfZRWgB1Gtq6ZDG6SB9SAknuE6fWpegk8bj5KM9ii9w7wrQqrqC2ZAmmyAok+Bn2DInDT39ARLZ22h54K0NvK0T3RW46equq/6APKdUa+AndYMb3w5kF8Loof/qZI3skydR2mcTzkGJJupqiiSW7Is1RTg14xlP/yPQABS4UkhGpQWHo4eoteiP7F1YL0gb+CDShi1ZQOnyP0f4NFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/g1U8Y3AFXRCzY3+Ft2E/3dXoZ//WdRH4eYeGX4CfdA=;
 b=b4qM5betYa1c+ppPp7cmv3J0HzuN78U2b2jpUT+o6u3FvLUgZxBRzifsfKmY0wke0HFTXZMu1Fbqr7hQAGCcAk6l8KeKMrJeAvjhDmxHT8kuOwLN/XCbdkAC8AgUaacUdsGpxV1QRuHD8hbMVsBPdlrRRJL4IwnqF7f0S9YcXg5/dlZG++7yUFhJeG0EfcOHDLqAMaGzaWlDG84lPsl99shiIATO85C4HyGuPJNKBy1c2C3bmLC2ryIG0xRo7FkpiSSalcGoP/UQCk7piX1EqBrvyistRBrXEeKWOQAm+a6dEbakHQkQhtPtN3T0HSuZn6Kxi8744hgZKi/QvLEkvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/g1U8Y3AFXRCzY3+Ft2E/3dXoZ//WdRH4eYeGX4CfdA=;
 b=oiMmmDC2DVVVexIK1PdaH2akLKgYSC6w2bl100HEGc/4mMyt1ebYRFzMU2QBHi7L/HUxPEnAUDarljolqzJNq/upGydTk8PzBf6efZzmHVtStai8Jm5VhcYkgQDpRLmGWHNhprqJVqR7fZOJZL6x5l85S2b683jph+rGUfCaUOE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM4PR13MB5881.namprd13.prod.outlook.com (2603:10b6:8:4c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Fri, 7 Apr
 2023 09:31:14 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169%5]) with mapi id 15.20.6277.034; Fri, 7 Apr 2023
 09:31:12 +0000
Date:   Fri, 7 Apr 2023 11:31:06 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Felix Huettner <felix.huettner@mail.schwarz>,
        netdev@vger.kernel.org, dev@openvswitch.org,
        linux-kernel@vger.kernel.org, pabeni@redhat.com,
        edumazet@google.com, pshelar@ovn.org, davem@davemloft.net,
        luca.czesla@mail.schwarz
Subject: Re: [PATCH net v3] net: openvswitch: fix race on port output
Message-ID: <ZC/i2jZWlhyShGor@corigine.com>
References: <ZC0pBXBAgh7c76CA@kernel-bug-kernel-bug>
 <20230406190513.7d783d6d@kernel.org>
 <ZC/X7Dqv+X2vwLgM@corigine.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZC/X7Dqv+X2vwLgM@corigine.com>
X-ClientProxiedBy: AM8P189CA0011.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:218::16) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM4PR13MB5881:EE_
X-MS-Office365-Filtering-Correlation-Id: 03c77904-933e-420e-43e5-08db374ad3ee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: esKxcvYCH+eqgC79ZkasjHQCmoA5tS88UOlLRAaaWTaupkMxQg4ZYgSxAoBT0j3alWtL8lrXx8VMV1if6lXK9y+gEuePdI2v9OQL9mnfq0/fp4D5Bv0kOe+Fs3lqFLor/0n7wXFVOmCcxFWNxKB7h2GmfYgJYWD9kAO3aZFqyAhHcc1ek4TTvSPB+xN1x8UR12sTPKnlHA21QnnTVZmdosV77ugvhl9ZiE6wQoewUAYK0y3PeAqYVNpDABr4+0GpH4KoC/ICqxrVZd5ljeZ20NIm7J2QchgCVH0G8TbzpHw+cKPQoUDq96s+h8LDXygoeqvgnOdhO7lVKlvPk0XM2u/B8NTGJENhgLnx4z1LTeaEdNiLGHXxoEZNtudBhVQGzYepcK1l8+zWf6drwtffE7Df0surFg9rO/EIOX/ZguY6ff8JLj7CoFQkh71baODkz5vRvNNajJDB1eWXvFmd6TS+pOZTQ05H1n3Aq3KsN2fy7qg4lDwNadCl5swYtdmxSIRaqa6aeyib3k1+B++Jf3ec+1HpTl+86qZWCX5CKu/pYFcZGQ3r9FkbUlL18xd4EQ/zVUz7rPWR63P/L7dh8SYg6EBmBNpvzutQ5K4LxZ8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(346002)(396003)(136003)(366004)(376002)(451199021)(478600001)(44832011)(66476007)(4326008)(6916009)(8676002)(5660300002)(6506007)(7416002)(8936002)(316002)(66946007)(6486002)(66556008)(38100700002)(2906002)(41300700001)(6512007)(6666004)(2616005)(86362001)(36756003)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?s9Zv9MaYvZeRJhOqJrx/mcY/OkPdzeWeJEqCvD0BEBF1fTNlL7kKNIT7o1/v?=
 =?us-ascii?Q?EOGlzqIDBrLKsnDdeTMIC3kofWibE13fBW4cunltbHu+hDgaT1beebVNNzb3?=
 =?us-ascii?Q?3j1iMKB0ynbDZqdsGOLHM4TTKVXyplgIjyWMRE5lToe2yaK3YzO5CEHcf+gE?=
 =?us-ascii?Q?wG4dbyeVbX3J4Wt0UaYyeGXY/Yom2DzzHLcWFi7qPZ6rY96ZWQS9DM6+dHZf?=
 =?us-ascii?Q?mg4p4RuFWQK40VfTd5O8lrrYuz6hhQfilhZtjhmVVUUG4ZBPyTkBxcycVQUo?=
 =?us-ascii?Q?pFQuyrqmfWvFn2kgcxnbwpRdnwSpGlHS7i2Vmv9B+7t/xuF62V+qJbuKMRGT?=
 =?us-ascii?Q?FuEuxDTNgHTgIe2kWcN5WHUr4qqkPV9Q5GC66YRe8Q/pSXZMIM5MoB+oL/Xe?=
 =?us-ascii?Q?iK5C2Jtd5e+s5bUkAcGdGYMRx7kUMzN4Wcq3EYXv49QcKOx7n8p11PJzzb3X?=
 =?us-ascii?Q?IDoiWj/98PjP39t2dyrpMlVjX4mVk8Gx72iQU65EmpHUwp+7PBz42zPeFlJh?=
 =?us-ascii?Q?3vuZ8ngL1iND/2CH6oSnY5SAz1nJJ0FSVQfizYriUlQa2Je2CSRMu7IBXQeT?=
 =?us-ascii?Q?w40/J67B6UP/XmWGDgwpIJiU5EDMP0ppyYCG9FzbNdaK1yezM7TByFoXXgeG?=
 =?us-ascii?Q?PzJG1F8/HM25F/gW1m89Y8Lm0kCf2rrKcEJGneOPTfeMJ1HPblWmKtJsewyH?=
 =?us-ascii?Q?STSSABIbZuXP9dK7n4/wy58bw6ZNk0hh/wBTBrS2fY8U76Qfx54YxGex8jUU?=
 =?us-ascii?Q?NfXWDhqpSu0OWgMpLASQZpGXaCWpAs9/RAXPy4Dvhj2KHGcrZ1vu9hnOPdXq?=
 =?us-ascii?Q?K5/aWzynfnaqqTAOO6RHHMK79rqrZWu7xaLdpBH3Obx9OxhvxDuoajWa8tl2?=
 =?us-ascii?Q?F96Nq8xoN/ZLCYGlvEfwMjRF+eGBVjBdN9m4h9kx6Pxs/FPdZZnJFawwQWAe?=
 =?us-ascii?Q?AWFV2APT47XbYUEpYCJBWS7hTCKJbsPbFDwKq6+jp9ggXBtTw/JNtr/ybO5U?=
 =?us-ascii?Q?NTMC4w8WjfcMwByHpOaHETwu5BemcxEoleFlQwhv/w/m5zSW/AIfmyZuQvKq?=
 =?us-ascii?Q?mk2Dy9h7fIT98lVLBIopkdjTGcm1MdjxCXtmnx3N69vCpu0PpgdgA/xLHnj8?=
 =?us-ascii?Q?iDcxR9Tj6OpW/ATaXVTyR4PpykARvmHvR5pyw1LRFWHkNZFO9kSWqPeYaFE5?=
 =?us-ascii?Q?4ZOdludnk3DUQNomvCf6INdiCDXBRLP8eu+RRQwVi5so+YVWJTgKYs7aNDGe?=
 =?us-ascii?Q?zeWwxd6ZBfswRT3YzuEJG8Y7vF2ihFnX1FAPqVbDmNb48MB+v5I7PSQctO0I?=
 =?us-ascii?Q?V9Od1hLXU4u1apx1DzyVziOC70lXSjktSjPjgJ/eBwT0SQRwO+ePlZxlDw4+?=
 =?us-ascii?Q?QrSmZyFCZHxCIrL+1LdrQr/Vy5rEM3lg+IKtXJ4urpgaJB9tKGpHTotX7t5w?=
 =?us-ascii?Q?IhgAK87qgpQRGoKdsUKSonOJl8llFa3bz6ecVz4lY9e5XbHRUbj2MMohTVCu?=
 =?us-ascii?Q?JAwM+6Hz0nX/g8JsfgW5cTSfuTf2Fg9SEZiOg25epG/yFe+ZTZPjS+la5nW6?=
 =?us-ascii?Q?Bv+qk55Hg0+1c+MYbOX+T10FhsCgIoSNuSDdJzR8Fj8nT02dKigylYNjzSs0?=
 =?us-ascii?Q?REhwJZogA/Y6Y7QZH3GlY3gWFb0VVdwMI2nblf5ebKlOO0jCpUm8Qa0XFGE9?=
 =?us-ascii?Q?j3NcUQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03c77904-933e-420e-43e5-08db374ad3ee
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2023 09:31:12.7315
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HtzL4MJ0/U+LnIu+xtWh87SIWzPhZv1OHltREw/5N2f7slz2g5rt0enaVwYjLm0KnQpL0oiNJnOxykGv6LgGjCVWbdSSz64w1ZaXJzY69YM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR13MB5881
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 07, 2023 at 10:44:35AM +0200, Simon Horman wrote:
> On Thu, Apr 06, 2023 at 07:05:13PM -0700, Jakub Kicinski wrote:
> > On Wed, 5 Apr 2023 07:53:41 +0000 Felix Huettner wrote:
> > > assume the following setup on a single machine:
> > > 1. An openvswitch instance with one bridge and default flows
> > > 2. two network namespaces "server" and "client"
> > > 3. two ovs interfaces "server" and "client" on the bridge
> > > 4. for each ovs interface a veth pair with a matching name and 32 rx and
> > >    tx queues
> > > 5. move the ends of the veth pairs to the respective network namespaces
> > > 6. assign ip addresses to each of the veth ends in the namespaces (needs
> > >    to be the same subnet)
> > > 7. start some http server on the server network namespace
> > > 8. test if a client in the client namespace can reach the http server
> > 
> > Hi Simon, looks good?
> 
> Thanks Jakub, will check.

Yes, this does look good to me.

Reviewed-by: Simon Horman <simon.horman@corigine.com>

nit: somewhere in the patch description, 'inifinite' -> 'infinite'

