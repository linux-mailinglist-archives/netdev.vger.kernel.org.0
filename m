Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 300FA6C7E51
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 13:57:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbjCXM5Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 08:57:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231150AbjCXM5P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 08:57:15 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2048.outbound.protection.outlook.com [40.107.21.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C53B1E5CE
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 05:57:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VokTJDg50VPOmNuuNnYhw0yeO6DfY8EYkM09uT5qAX/Tytr5hJPOQYcPGi7cIYZaSpoiD24WiIpjddp/T8um3vbGNl7+Nx3q+dJeGcHB9RpCW/fkJ5YR3SAZb7qAC4yxw8jYBDLnLu2fn2TWKpZzGfA8sqd4Vydfl11xc1rzSgonfPuoT5WsRc4cSqbhOLWLL503RSO6/xlKKIaUGlT5d1pEmLUUI68T8de2aPZoQa9xxfx4FtU1t/E2d6n12fWBwcbfysp171j8Z2GLjAPDILBeFOubmUwa6Bl6+cJ6FwG5Og268E6SU9Yme0iiLLwGmaRM/mTAduZxYFZ/l6Es6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YtolrSwbFUg9El4N1JV9i1aOB9DfZl4AYRjo+y7pPi4=;
 b=iRshlTMO2rdG1y5W1rJDrZJudcw7u0erWHlm7rhFU1E4lZR10IXErLYqm+4CLIOGfnj7DGew+tt5BLPvkHT2lSwv6Z9lhPfn7llzpXqPp2CixOpqObd2TLLmnaigUnHhCMJDRyOontubyMbwbutOgCBsvUy1vR76uD3TJbUVuw/BW6rUCOZCQb80jL4saXuOPnkUzHcSnk9MWne8tPB6PmSgwj3iDHggjC9xJ0qZSEPlTV4WcXhJTqWVsBpmdraIFktFawQM6GX9rlcTQV9rODWaiU7iNLY2dJlacdV9iR+tpxgcrNWFUZTUbbLd9YY+TDHx2W/+2ypPR2Xai4mwOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YtolrSwbFUg9El4N1JV9i1aOB9DfZl4AYRjo+y7pPi4=;
 b=BoiO6n5pOkXHEeXBxfUme9JSCI1vdzwB5WLqhrTGF2kObwGBbmJC/jF//8aADw0lBoR4b+3B0Hvl61eU7X65xOulRjpP5tXu42dR0R/ruf9ddM0+nohly/I2aXlFECOlZBJqR7E6q7bAx2rza35IPV+HX/NW4Sa5E6iMtpw7x7U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by PAXPR04MB9594.eurprd04.prod.outlook.com (2603:10a6:102:23c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38; Fri, 24 Mar
 2023 12:57:10 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8%7]) with mapi id 15.20.6178.038; Fri, 24 Mar 2023
 12:57:10 +0000
Date:   Fri, 24 Mar 2023 14:57:06 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     netdev@vger.kernel.org, Madalin Bucur <madalin.bucur@nxp.com>,
        Camelia Groza <camelia.groza@nxp.com>
Subject: Re: Invalid wait context in qman_update_cgr()
Message-ID: <20230324125706.ettgc22v5lnu2uh5@skbuf>
References: <20230323153935.nofnjucqjqnz34ej@skbuf>
 <1c7aeddb-da26-f7c0-0e7b-620d2eb089b9@seco.com>
 <20230323184701.4awirfstyx2xllnz@skbuf>
 <e0c086cd-544c-e1e9-8a76-4f56c9cb85a1@seco.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e0c086cd-544c-e1e9-8a76-4f56c9cb85a1@seco.com>
X-ClientProxiedBy: VI1PR08CA0184.eurprd08.prod.outlook.com
 (2603:10a6:800:d2::14) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|PAXPR04MB9594:EE_
X-MS-Office365-Filtering-Correlation-Id: 83134c9e-aa90-4384-55b5-08db2c674783
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y5JFLf7tU7jRv56oKEyP93hOnDB5NPfgxBRVcNpdqkcLljxgSjnxanqp9e8JJbgAVN7NbnAK3T/wk8/hp/EuYEO8XsBt8KuaZBmBjK8lOqxe9qn1VGwf4vdz1yKPuBLVo0jzUWq0kcaddLpxAbPby5TuQd8alsVBOlloe1Woc7d7hcJaXaI6g2uY4HtlGRiZ/uGg2iHV/CEEU+QtyDLuhSDzcf/IdTRe1CPqcbdVqZ7F/oZ43K7GTso9kulEQEYG1tOjz5411wt+FJ8V6FO8eO/+Q7qi0benWzEPeG52nXoy0XDo7ff7mBxZtCYTku11Ap9otUiLjaIPUIK2HR+NDS0TMyzkCRk5h5YePwiR2kkr5OFJdW0EN+gJxzPDR+QGcohWMCCmh+59lqRKheIhnFi2eaCEIrCxJOqCeoZyW7FraYlG1Ui7Zl5LzRR231CrOnDsqLvuqawxtj47BlMk8h4o7zUVhyr4LxAeMBkQaacp9HlA3F58swMv7kzMpGTbVkBy5CUFqOmHiMAG4OEPfRkCxv6xClBkQoZ4DfnJU936tTwF68zRI2rjHcJSd71F
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(7916004)(366004)(39860400002)(376002)(346002)(396003)(136003)(451199018)(41300700001)(8936002)(66946007)(8676002)(6916009)(4326008)(66556008)(66476007)(33716001)(478600001)(316002)(6486002)(54906003)(2906002)(5660300002)(44832011)(86362001)(83380400001)(6506007)(38100700002)(6512007)(186003)(26005)(9686003)(1076003)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?h6jjWa6iaKuhVMaJPqiRZacVRGnBBZ2VEE0i2kXiilYYJ811PwBeoVPYDqdD?=
 =?us-ascii?Q?PbExIysQMssA2Jo9RH1awjFqYHgjSuK7DTtBEsToUvXcGg+v659dV4AWRSe/?=
 =?us-ascii?Q?i5f6CVaq4QIkFj+zpUmfoBUcmSPWyaySHrb3QJ9jDSPg48PZMq2fxZlElda+?=
 =?us-ascii?Q?5esxnUmHYOk3Ao6uHtaE+y1sT3hvl2joGyXmwA17VWyQsrUf3cieTKGEHse9?=
 =?us-ascii?Q?peUlvtRR0Z7a4LAnFICJIhHO6sYoNcpqlcImemh2PcIKeMl0jhe8hGDlwf+s?=
 =?us-ascii?Q?/XTXJoGE3lh6FKQc/AbKfeGH/b2l2sFn0fkvoBGF009ItYRqlDyYzGFzaUAH?=
 =?us-ascii?Q?U9hXkQ8F0ttEy4saPrhifbhYiarR7g71UT89SRoLg9MPEAetOzs27Cen6zpi?=
 =?us-ascii?Q?JGD77wLqn9bkxtcK7rQfF2jzc2C979DZodFiWxwCptS5vd+IEkSGT9eDFa/o?=
 =?us-ascii?Q?Rrwp1zyfmjEEOZrg4FYynM3phoNpxA2bcFG7C+rEp4A7is2OitjKQ1c8M0iV?=
 =?us-ascii?Q?4h6fUpUmuY8exuKHRwn1hRbSAb/IdkSIseEez5pDwHRU3R+OBzSNf7KFCSFL?=
 =?us-ascii?Q?cPuZi5KveWc9mS9ff+Wfd351ebSBv/I2eZVE4U+krctx1VVAoJImsv1yH0gz?=
 =?us-ascii?Q?6nn3GA4pItHE7YvU/uPbzx6SXVcI7ThfXJ0KrAiWLBTZ52Pqo1b5iU3QJWiT?=
 =?us-ascii?Q?A5trlqNm0rmM9SnpcolmjYe+oJpJQQxVZl14BHCRVOFyDexEzr+JhNMU9HET?=
 =?us-ascii?Q?Q7ZN2mYyK1CNr8EztIwl38S/YJO4+D5B/yH6VDPxc0wCgeNFn0ju/wtKWREG?=
 =?us-ascii?Q?/e/Jzoinuelo60mc9rbBjpKipjZ9YA+qeggR+xKEpXeJEwD+DKKWXZXVZYK7?=
 =?us-ascii?Q?+2NiSyGU9uhKh0uYT/TpU8QvngumrrvKC31xXRhcDMGyNAtW7nYU9D+KU3Fm?=
 =?us-ascii?Q?OMSVVOG6WybnaMwm+JlYs7RYdaaydrcZnIp/cUKQfF0pH88XKN1zg+9FHZbH?=
 =?us-ascii?Q?MWW30GNJ7GqgZqe5n9NkrlHuJsNme4ECGFO96S9/WnTbdXn0E3vUk8CF0hok?=
 =?us-ascii?Q?RZqfZZGmIK9Tf2Md7oBna5JlrgwN4gBTGairUXswCgxTb4qJZPLET+WFWTyy?=
 =?us-ascii?Q?9PVXuuK6d6/PWJO/LMRUw5zd3+mVW81ZjUFeYm+sBCl1j6ElFfksPvQevO6h?=
 =?us-ascii?Q?mrsUIA1LyqcU53dmIbgQj13Mvz7CYLZl4fkACjZJp/w0V54qrIyTffJApHbf?=
 =?us-ascii?Q?SJ9d1QrERzY3vg8t8yo98iMHd+PXiqFrhelrqXk8Yw9bC2UdRzf0Uzc66SDM?=
 =?us-ascii?Q?j4WBaWyLsPyTZt8xKGGM+BfAfU44Q8Q46IjV1QWFO4pMwNEpmeMVcXQbc3Jh?=
 =?us-ascii?Q?/i9UQIuINeeIdcPO1ziqnYDwbzPnxJBlf+akbT/NsVg+h1w1dOMwr4vaTEnb?=
 =?us-ascii?Q?/SStFr6b/qV0SLCkN6w19WArhLJ3BDxbPZoeeb/vqrMn9PtdFqzzL391Jtsl?=
 =?us-ascii?Q?P9xeHLDnOMxkXRt7uZFe5wv8HprcoX0Oa+Vr+9baeZK2w7o/OVyK86nPptXB?=
 =?us-ascii?Q?VCL9H8U9OXrOSR/CfGNZGMCiCl2lxqSF0bGzIcUZVN/vr4TOduN02pz/5jYR?=
 =?us-ascii?Q?jQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83134c9e-aa90-4384-55b5-08db2c674783
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2023 12:57:09.8756
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tIZbC2SjGb+glNPfGIydSgDriVJNuHNKF1WreGLBCxthVgF7jq10lKagJRrUCHZHZjiRTYukOVLBEeqa3hlSIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9594
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 23, 2023 at 05:41:04PM -0400, Sean Anderson wrote:
> Well, it's either this or switch to another function like
> smp_call_function which calls its callback in softirq/threaded hardirq
> context.

Okay.

> > FWIW, a straight conversion from spinlocks to raw spinlocks produces
> > this other stack trace. It would be good if you could take a look too.
> > The lockdep usage tracker is clean prior to commit 914f8b228ede ("soc:
> > fsl: qbman: Add CGR update function").
> 
> Presumably you mean ef2a8d5478b9 ("net: dpaa: Adjust queue depth on rate
> change"), which is the first commit to introduce a user for
> qman_update_cgr_safe?

Not sure what is the objection to what I said here.

> > [   56.650501] ================================
> > [   56.654782] WARNING: inconsistent lock state
> > [   56.659063] 6.3.0-rc2-00993-gdadb180cb16f-dirty #2028 Not tainted
> > [   56.665170] --------------------------------
> > [   56.669449] inconsistent {HARDIRQ-ON-W} -> {IN-HARDIRQ-W} usage.
> > [   56.675467] swapper/2/0 [HC1[1]:SC0[0]:HE0:SE1] takes:
> > [   56.680625] ffff1dc165e124e0 (&portal->cgr_lock){?.+.}-{2:2}, at: qman_update_cgr+0x60/0xfc
> > [   56.689054] {HARDIRQ-ON-W} state was registered at:
> > [   56.693943]   lock_acquire+0x1e4/0x2fc
> > [   56.697720]   _raw_spin_lock+0x5c/0xc0
> 
> I think we just need to use raw_spin_lock_irqsave in qman_create_cgr.

Ok, could you please look at submitting some patches that fix the lockdep issues?
