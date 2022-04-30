Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BEFE515F87
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 19:24:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242494AbiD3R1c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Apr 2022 13:27:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233111AbiD3R1b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Apr 2022 13:27:31 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2093.outbound.protection.outlook.com [40.107.93.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFC48220F5;
        Sat, 30 Apr 2022 10:24:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JbUqxmtbwx51DdSZ76t85GrOLFUbDPO5BMbo6FhcLM2ADgkABxoWdrgd20g43ZdFIIc2GJZnSaBgA7QhSo517o7AaEgraIoG3GNpDPxuUkIObFOkKxjx2gt5kmDE7fBtiOP/IVYuho7OevEncOUEa0WdGdt1d4R1dg5/MoaZCDKYSYyGyH0374iSWYEKg3XIuVhFV7enEHaGd+PJfm85FCFZ0z7nCGkVeupGuIlaLmngnZ9k2nGWMqOlDySFjj/qe97ybItc2+wJQRutAajKZlNUhRyA1qLJQNM2Chxfr/e1kXhvV9mX1m/ukXuz2sihItpp1LW7KBjJYzTzyTF3BA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Kr/jxm/Drhood4gT3JRbo51t/XzbPymIkfSjzsc8DeA=;
 b=DyRwAej72BQM/K0OTElnYkFbNoFXCaxGFi123enGj0Kv8/pZVWNGAxwCqH+pIoPgWgd7XRXxwN48rug1Y/0XU3F+hvGOGN8HXOkyAXsejOaXkgcU+dHAwn6COQ0/JkXhcz4t74ZMVy07vPDQdpZNUyTKVx3lAylXFs6C4vjpYhCmBc846chpeGYaIrpMg5nwfL7Yf6vjLE5MbS4+LWpeRocCR3jiWWK92NHAqZoI6P9u+9xWf7NOWwUr/3FjSQ+n2EhoPLAlqtPOf3VIrZPA5bwBpaY8DgHD+obKWXNN+sOILa1BQQxURVph4119e3yWCCW0RMTA358ma2Sz+8FTjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kr/jxm/Drhood4gT3JRbo51t/XzbPymIkfSjzsc8DeA=;
 b=YbBeaz1iCFLIR0npN3LnuO5ElN/AYtNBVIXTYuV0V22Ug4dCXtJ/OYEjfZEWBtx6fa8YscjvubnDh57rP35wCc8Ssg9qnKqIabPoyAZc4f8bl4oj/dHxtVPhZTA2b2/15xcvV2QwnXD+dMZp32awpOPRLNxbDiAeKzG4uwZMCs4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by DS7PR10MB5199.namprd10.prod.outlook.com
 (2603:10b6:5:3aa::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Sat, 30 Apr
 2022 17:24:06 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e%3]) with mapi id 15.20.5186.028; Sat, 30 Apr 2022
 17:24:06 +0000
Date:   Sat, 30 Apr 2022 10:24:00 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: Re: [PATCH v1 net 2/2] net: mscc: ocelot: fix possible memory
 conflict for vcap_props
Message-ID: <20220430172400.GA3846867@euler>
References: <20220429233049.3726791-1-colin.foster@in-advantage.com>
 <20220429233049.3726791-3-colin.foster@in-advantage.com>
 <20220430142457.7l2towhbptdvrfje@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220430142457.7l2towhbptdvrfje@skbuf>
X-ClientProxiedBy: BYAPR01CA0034.prod.exchangelabs.com (2603:10b6:a02:80::47)
 To MWHPR1001MB2351.namprd10.prod.outlook.com (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aa06b0d9-a763-423f-9fa9-08da2ace3a89
X-MS-TrafficTypeDiagnostic: DS7PR10MB5199:EE_
X-Microsoft-Antispam-PRVS: <DS7PR10MB5199DFB2BE44F11D11247E91A4FF9@DS7PR10MB5199.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Qi7GKgO34PkqHwn4J1LlFuqXwLxSccxLyniqZpWGW3cgAKns87qPljP/CYgIgvOoWRLyea4rvEA6EFnpVO3fiC2ihXaIkhHugTZVeZnbat+YFiTLHGj9ngwZt/E6hlNXKb4Fk3FbcwTdfWDqy7dYSI3uqZIJpdjmcJrmdtgWgL5jaQPPvcR/rlgR7fY0C4qli98JBIibhcRnOtYZaMVwFq1+c//2yZYfkmhJbszm/JJSd+BrB1ACEjjbD9SSGxFqFVhJDrBqncz10M966RjBJddPasQxY47MqvY23akKQi0SeolU8ZYIVgoL22TxXZQvMirDhh4aZ04Ka8FMF5H/MOKyNlKo8LKUUNsJl/WRa+GPvO27+F2yM46zH/auMRzg//J99m1Avj4I6N+pYvbEluovTHvE5EwWWoeA/z+HaaMqsWWfIg2BgkJP5oxK3uaeNNVbuE5bazmy+WCu9LIfRI1NlaqpZuRCcjgSihJFgpAZEBbDLWokLRu7qLObhR1nXA7O2jstm4/p7mqm9YMqW7efN/b6hAuAQLathp7U5MQPm+74P89iwPQhR2MmZcBF3xQFafBpOFitOWPXzrwOhOKSqSbIvxsl8U2m5COMT/QdU9PpE69NIYI1N+yfTX4DoUkRaFtqRcDe0e3ABoMoAaLXrWmM8+ZcMe6RiGEAT/sO3oCH6VYpPArteFjmR0SCoCokLqcGujqlhes/V41Zdg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(136003)(396003)(346002)(39830400003)(376002)(6512007)(26005)(33716001)(8936002)(508600001)(9686003)(6486002)(83380400001)(6916009)(316002)(54906003)(4326008)(8676002)(33656002)(66946007)(186003)(1076003)(66556008)(66476007)(5660300002)(86362001)(38350700002)(38100700002)(6506007)(52116002)(6666004)(7416002)(44832011)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Qap/MCup4vG3DKYzy0zL0wwUpKB4NP23isRcX3xv7d5KFMUqZ7Y/xpMnKmFI?=
 =?us-ascii?Q?DZoWg2gjBlRNliulopwD/FZZ8Oe7NjPc9hMQV2KuvVweiZlmLdkBY4fD62yP?=
 =?us-ascii?Q?72eqkz0L8ps3Hk20NTAg49+rkll1BgdJ02NmMVLwK2KeUvmnAG+A5AJmfdA5?=
 =?us-ascii?Q?UMmleoCjNkQ/44fu5pFAUE20j06Jhvn6iBjaxAaWEIfKkcHlUV2qa38QvSvs?=
 =?us-ascii?Q?8X30c+Ugiy6sTaVRSd7GggA/RfgzsrcVNiH02FTd8qIWrag/3aXa0sGSNrDL?=
 =?us-ascii?Q?oea+3L/NQD7sSlN7r0B58l5Kho9pgaw1/BcRyWqgIj1000mUHKO0oDAoDXh/?=
 =?us-ascii?Q?izkWIGdFe3EHBCV62YBTxPU9u3gfRyfdUbXpoIlAWR+dBKYZiKcB+Erm437n?=
 =?us-ascii?Q?3iIA1ouNSeJY26b67WgNuo1w07r9uKWSzxKqfpDHY0vd+Ff6EB+q/DqpDqVd?=
 =?us-ascii?Q?8wWONlSlTvINaei8IGpx5Rcea8Sw0TRWhvyRckCJ6y9xJl9dhkPAsm+u8v4H?=
 =?us-ascii?Q?fsSw4MlW4G4tFzNDyvoPOEwN7/D1h2XS/xTIARM4bwY2wQ82xR2fLL6Fh4+u?=
 =?us-ascii?Q?lHOABzhg6V2cC0m95+ETpaWmBTXlx9TuNSxmzWvyMU3/5d1ZnozgpnFZMgCD?=
 =?us-ascii?Q?q7aWJvnMxZDa6PDgPF1fW2TKGbcS2DoMUZO67VbNyrS/t/wD5UXCqDCIIeJ3?=
 =?us-ascii?Q?hIUoiMuCe7h1OdrTNwAYrWpzPtLwWvJg8WYnfDHPHyFEFchqnW/LXizlaViP?=
 =?us-ascii?Q?U/FZQBxoagB7wejNpPWXgKbZvagaEHdVmdcQSOZw1knNJTyi+rDIjlXnL3X0?=
 =?us-ascii?Q?rjg0FNnxvOqeigh68mziHF5A4nnEYNyJkYPg9j24q6Nlue6i5RojO5c/P1Zo?=
 =?us-ascii?Q?v+nYZnF9jP1f06Vf1kFthbEWeLmjaGGyI2MjFCMnasO3OgQ9Yxyr/r7J75Bx?=
 =?us-ascii?Q?w/4e1SbQnQDVw4nyYu2IKO+Z37sZPUKG3hqjj4lQz3RLtuBWsDibH9+TjhDC?=
 =?us-ascii?Q?4nEVWJvr/Wff8sfP0tczURDWWN5kS1taFex6GVjjpSN7oJ3XnfvAfBY3qW4N?=
 =?us-ascii?Q?QxtPQcP5ndmuTzXH8uhEfJXXZuX0lQCOb42m9+aB/IafqWg6bi+X2R9LRK0n?=
 =?us-ascii?Q?NKkNq3rI2vwc/q0OEXyhjQLCE25jLG/5Sq0lAkZ4F0jmMP/dwsezPVF92z+Q?=
 =?us-ascii?Q?zbUxAtDwuaiIKrWMgqwWLtQn94/Z7mVInSGdQUP0yoNvGB43fmKxX0evDbHo?=
 =?us-ascii?Q?C+zpEnqyEBRUPKU6oBbwdYfiUJEUx0u+KD544ijylmipKBa2ko8/Q4BUR8/n?=
 =?us-ascii?Q?jsZMrPjNt96qHwqCFbp/KNoLkeQolQO9xC25b2YHofxvr4bXM6bVSx0S1Etm?=
 =?us-ascii?Q?yGjrF59AqxYHz3jKAqsJgI1DgE2fFihWDZP4Qn0q32VHF8T1tgHX6q/yid3R?=
 =?us-ascii?Q?uStEtVF/dfy4zZfHHCleDacs7DpbiTUDAUFdPRNk4Uys0FHYlI9cVFEnAIJ9?=
 =?us-ascii?Q?HrL+vupym9VYhxc3k4Uecjad1UuNFBacUVDUWoEG/Ph3pxnSRQLlQDVVEbRT?=
 =?us-ascii?Q?wl6pngAOcaxIIo1NsMiWoD6O1p0EN2hDDGWqArEo1RjPgZb1TJnMUzXCEHDs?=
 =?us-ascii?Q?nWjbqVN9cm4BE9VWEC/3yeC38dZ8fbYeTE6xJD2/3MmkWzCNWb/mGzwHopTB?=
 =?us-ascii?Q?qyly28t/Wm2tFxDhP0sX5yd5spiuwZws1X5lzadmN3J598cNsZGWdGT5ipoD?=
 =?us-ascii?Q?9Jlo8yP0KZH3iTYhrQL7aYx8b9xSg8PTVjAcMWyWG/w/DwPeWE8b?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa06b0d9-a763-423f-9fa9-08da2ace3a89
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2022 17:24:06.2729
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +wamVvhfqIVdckv32L94EUKpohzMhmLwqGixbdxYjBUo2fgXlCuhxESmfd6CSazblyg9c43uV6brolbSgHlXQfWO5pZwOGHwf8jXtwACSGM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5199
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

On Sat, Apr 30, 2022 at 02:24:57PM +0000, Vladimir Oltean wrote:
> Hi Colin,
> 
> On Fri, Apr 29, 2022 at 04:30:49PM -0700, Colin Foster wrote:
> > Each instance of an ocelot struct has the ocelot_vcap_props structure being
> > referenced. During initialization (ocelot_init), these vcap_props are
> > detected and the structure contents are modified.
> > 
> > In the case of the standard ocelot driver, there will probably only be one
> > instance of struct ocelot, since it is part of the chip.
> > 
> > For the Felix driver, there could be multiple instances of struct ocelot.
> > In that scenario, the second time ocelot_init would get called, it would
> > corrupt what had been done in the first call because they both reference
> > *ocelot->vcap. Both of these instances were assigned the same memory
> > location.
> > 
> > Move this vcap_props memory to within struct ocelot, so that each instance
> > can modify the structure to their heart's content without corrupting other
> > instances.
> > 
> > Fixes: 2096805497e2b ("net: mscc: ocelot: automatically detect VCAP
> > constants")
> > 
> > Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> > ---
> 
> To prove an issue, you must come with an example of two switches which
> share the same struct vcap_props, but contain different VCAP constants
> in the hardware registers. Otherwise, what you call "corruption" is just
> "overwriting with the same values".
> 
> I would say that by definition, if two such switches have different VCAP
> constants, they have different vcap_props structures, and if they have
> the same vcap_props structure, they have the same VCAP constants.
> 
> Therefore, even in a multi-switch environment, a second call to
> ocelot_vcap_detect_constants() would overwrite the vcap->entry_width,
> vcap->tg_width, vcap->sw_count, vcap->entry_count, vcap->action_count,
> vcap->action_width, vcap->counter_words, vcap->counter_width with the
> exact same values.
> 
> I do not see the point in duplicating struct vcap_props per ocelot
> instance.
> 
> I assume you are noticing some problems with VSC7512? What are they?

I'm not seeing issues, no. I was looking to implement the shared
ocelot_vcap struct between the 7514 and (in-development 7512. In doing
so I came across this realization that these per-file structures could
be referenced multiple times, which was the point of this patch. If the
structure were simply a const configuration there would be no issue, but
since it is half const and half runtime populated it got more complicated.

(that is likely why I didn't make it shared initially... which feels
like ages ago at this point)

Whether or not hardware exists that could be affected by this corner
case I don't know.

> Note that since VSC7512 isn't currently supported by the kernel, even a
> theoretical corruption issue doesn't qualify as a bug, since there is no
> way to reproduce it. All the Microchip switches supported by the kernel
> are internal to an SoC, are single switches, and they have different
> vcap_props structures.

I see. So I do have a misunderstanding in the process.

I shouldn't have submitted this to net, because it isn't an actual "bug"
I observed. Instead it was a potential issue with existing code, and
could have affected certain hardware configurations. How should I have
sent this out? (RFC? net-next? separate conversation discussing the
validity?)

Back to this patch in particular:

You're saying there's no need to duplicate the vcap_props structure
array per ocelot instance. Understood. Would it be an improvement to
split up vcap into a const configuration section (one per hardware
layout) and a detected set? Or would you have any other suggestion?

And, of course, I can drag this along with my 7512 patch set for now, or
try to get this in now. This one feels like it is worth keeping
separate...

And thanks as always for your feedback!
