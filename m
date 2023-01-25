Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B08F767A7F0
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 01:45:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233454AbjAYAp1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 19:45:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230151AbjAYAp0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 19:45:26 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on0606.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe1f::606])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B29D2442C5
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 16:45:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dTQ/kOck0T16o2icbmSRlgRUxcAcBxANaaKnNRTIiaOZJtIc2w4JC5GlFz3yRDhcbw+XWtjDmoBzZIE49x6CeeVg8IXXh3pwYL1MYGpgYvbTfjjwhRMz71Bx0rg6fPjtJ3FW33RTGMhqolg+8dx1UyeJzDhD8hdB+jLAzjkF/OE4U1P4TNCmR55uS+Fc2mQIV+DTfu0S0hoGjjKuAG+4c8FI1XrmThoUOhcTMheRQSMiJGPCZ9SMxd4IUU/t9HIV1NU8CjE1H9fSRnZm0InRT7uqEgYA3rRD4XUKARtBZo+39tDBSQKtsy5YioRG4ilSfHG8ybNpKYNK+SBWR1rbzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NA/HqnjzOGhZx+AC2eQWX0A87QlxVsGizpVTHWe2ewg=;
 b=c6qXxMuLkiiQEX0QT8tuENOb44OxfVYQGi5lyszwqR2/nt7s5de1phtgVtcOsO3Hyv5pU79HscoiQ5i44p4ky0oAgMyTcKXAJ1ZUNcqg6kCPkrvpAsLJn8rRenMj1gthcPZ7HJyrNyjiHiLqgOEUcSd0Rf3LJM9jWrUQfcfIBkSOeLTL9eCYWwKjvzl1Xtv8sZCNb62amb3l2Nqo5HYAkQ6kpIhoZJB9X0CuovawSDlfApYBA12VWarBHkxuIekw4iZW354ulySR91xpaAwswOR5D4XOdzuhKxtkWTrZqpPzCvhQAP6MVKGxZ/QF6/jEukYFdBPlHW5dwePfxr1qpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NA/HqnjzOGhZx+AC2eQWX0A87QlxVsGizpVTHWe2ewg=;
 b=IOiQ+3swcuhjxj1rdtnX35sWYXKk20EWaP6bfksRlFYIknWnbkes6JS3ZJ7m9gZNrFH8WXJve1g0XVy1OZPzTri/komVUT0W+K60/ZLteq66lKFhVfkOvONzj77Zqpdw22NWOGFOSLxef2AUyQjNnJWaKrkDkZK3SXqGwtbhf5o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM7PR04MB6968.eurprd04.prod.outlook.com (2603:10a6:20b:dc::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Wed, 25 Jan
 2023 00:45:20 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6002.033; Wed, 25 Jan 2023
 00:45:20 +0000
Date:   Wed, 25 Jan 2023 02:45:17 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Michal Kubecek <mkubecek@suse.cz>
Subject: Re: [PATCH net-next] net: ethtool: fix NULL pointer dereference in
 stats_prepare_data()
Message-ID: <20230125004517.74c7ssj47zykciuv@skbuf>
References: <20230124110801.3628545-1-vladimir.oltean@nxp.com>
 <20230124162347.48bdae92@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230124162347.48bdae92@kernel.org>
X-ClientProxiedBy: BE1P281CA0076.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:78::13) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM7PR04MB6968:EE_
X-MS-Office365-Filtering-Correlation-Id: 285a2d3a-92f7-4da3-7e94-08dafe6d6f33
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PcCfqrTQbpXkk2M3yxK6jNx2N5a3GsXye7+uyDQQ+pHZ+hpnSmlifeMkwpVYCV4L2sYQTALwgQsWetcO05Msi0Gx8LdS3QTMTtaB7uSCTP6vs8EHsx5NeIwphXqj10etsqfwkVzM04THOxf6Yd+6Ol0AZ1CE2cqMsTlhyuj0zluWnn69AGDaA9BbHlipm9KV8/VdRk7PGln2lBRiZCBoBs465J7aRF23W225fYmlxViGUNhj1kJrgxrRiboUYII5xssC/EHKUBZah4jT52um8Gta+85iyq6b7jOoa4bGC0jyjqZBUwlyvWxBwiIwqbCjGuAgLYGedPuhZsobvW9J5DvfddbGqvXB/Uw1zqga0VJWounvv3Rnlsw8ppRE8rCWP4UrOE6skIO3EJ+u+1RZxiSVbwzqQs/O5mUUmf1EmqHl/tsvgKVk/EqeY9yVSelvsPY0bRSQpF3rVGMlR64jwoHC3QeleB6dXV1DHQC2JuDk4+lj/+XUPkGeS7caX/9s9fY/+mw1x8+GMuZCbT64fm/mjOD+Rz6L4l4p4OWcbzNGGdMBtJa5pMtSRDHgT33pWn/oYn0nXDVX16q/2BCM7yzHNdmBcVfSDoK6TTSOh+8lVW5evtZFfcNIbNcRHV4NVI6+wMdVcmFe0QyzXQvQJg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(4636009)(39860400002)(376002)(346002)(136003)(366004)(396003)(451199018)(66899018)(6486002)(478600001)(33716001)(6506007)(26005)(9686003)(186003)(1076003)(6666004)(6512007)(38100700002)(5660300002)(86362001)(66476007)(66946007)(8676002)(316002)(66556008)(83380400001)(41300700001)(54906003)(4326008)(6916009)(8936002)(44832011)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7lDgPHQdcUjBg2lVmXwJUtgSextzpT8/ZT35vinW85T2O5UkZpOjyKSENQ+q?=
 =?us-ascii?Q?DkzzfhCIUjESqUa0g1TDqXcQUlygpQYfdcv42VCcDmbhxhsbjgR5LnysjJla?=
 =?us-ascii?Q?6Fr5NjFfq8+FiTyTs3aQ6+srBYyxznstxKWjkgZrkrmCNqk0THlSPHBj8xTo?=
 =?us-ascii?Q?Sr7PiOPQ38eez/4XWB4tom/n23SZm95Fa9efoOs0ZM2fGy6zWWnsD+gIXjwn?=
 =?us-ascii?Q?S0YOTH12cMriGcWIirBR2yMR/3FOgGyS6frwOyV02gLMQNmPVIUUYI4WxLL7?=
 =?us-ascii?Q?teA6ZjPO7oqSzFXf0RHhhyMWCXw+WcI/7bLy6b0wO0dc3noCBaeU2MRtkht4?=
 =?us-ascii?Q?80emVn/1t6w9BwFL3/0Txi9NdjrRkgvHguU7pvQzvLA6Q4DjnzuezSlnOQkP?=
 =?us-ascii?Q?A8vWLag99B0vQ+IP2uUKI0e0jcnoaxQSP3ZqSBW9gSScwwq0UjBdEDKDqjge?=
 =?us-ascii?Q?fd4gYNaS/I5QaTY9M0YpWk9FX4Davn20J8ETfeCODwFVqbyhnOslXO4hDG5g?=
 =?us-ascii?Q?EA617GoSax67FFcqDsj21hyFIY7af6u5/iaCXtUIKSfyxe76hfS+XEcUSVSP?=
 =?us-ascii?Q?DhxxH564IjZUDb+4OLQn0e7iD0ayP9G6FekA44YZaKTAXeU0Q7kTIEPimNY4?=
 =?us-ascii?Q?MwmHWbznQbCARM/ZDLoNzBNKDgPVNvQFNe0BaY3oCDSzuDJUYo7JQJrsTs2n?=
 =?us-ascii?Q?F0gX8zPk9Sb1WndKJzkvz/ULhHRZCqrYCsQrYpMxKr4kISBZre+k4hjWBENU?=
 =?us-ascii?Q?9/KRPAmDI3wq8tH9zGSVEOME/TrZ+X3fmOP7/0+KE6Tmp4Fp0zdyFa+CKwRB?=
 =?us-ascii?Q?rzQ76YYdHYb1Ty+SB0jbIJ7dgGLMKfonAs5/HSgubfs2EKc9uH0cw3l1hNbg?=
 =?us-ascii?Q?huyW6yVGLyrrT3DCHqa312AV97FZixtZB0NkjT9H8B68B8R096QNgIWcvy3H?=
 =?us-ascii?Q?ha3PSVzmNMDZU1EfQxj5WEM9tiDufEBeeEf5YXd/ySXmWiXvxubN9HLjG9t7?=
 =?us-ascii?Q?lDUvPyR0lZe9QVol8AFDqKQjmAp0fzXZ8jNoy0ewxH1T4//IiwmCGmrm+8Jx?=
 =?us-ascii?Q?g06hv1DtGPNbEYQEnmMxapqlOizwd/g+ShkcptC2JYvfas7KDGXZYxJ3ANxv?=
 =?us-ascii?Q?9cduNUkzVIOpLIDyMz8YcGITLoA/JSiuqrPoqzq1LqABP8el0hBEx3bSXSre?=
 =?us-ascii?Q?WEEqhu75iIsI4/MCNW0iGSOGUEUN83C2r3h408axvk46l85pCcFcCWQKOwGZ?=
 =?us-ascii?Q?w7lYQHX+WbeoDq8SN224rSpwC2QITRmMRsYbUSo+3lvaWZw2hZHG3UmJlG95?=
 =?us-ascii?Q?zqioSxgcgoslS/ryeWVzKKGxeZ6NGXYY4C01rUn4QnijvUK6y13fHOmAKJGG?=
 =?us-ascii?Q?yly1B0DFQMz/ta838zVuWyWtRVcq550jJJug1JQgkRNPB9I3Rq3I139qP8/a?=
 =?us-ascii?Q?gMeijpQ7/VhvOEjH4eAHkQDyktwhp0qO3R0t+1XubEikBp2vXDu57Tgzf86g?=
 =?us-ascii?Q?6IgjzbobISpg+7sym1aJpEkpkFxk0Oi2poEEaLVBqHtHwYKJnI3Z0UImdeff?=
 =?us-ascii?Q?IvgdmI7BPV5vQn4tThUd0fSkD7cVHa3OYEKpCRmApBD17bmWWNSfccnCd3aD?=
 =?us-ascii?Q?Zw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 285a2d3a-92f7-4da3-7e94-08dafe6d6f33
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2023 00:45:20.5475
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ifIzlvnrz4KZPPTVWyWUSFCN4Rc4Zku7wKXMY3YxBPtrHQQKMTvzuJXe825sBQIH4oUVRDN/h9/ZtUQnKUrzVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB6968
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        T_SPF_PERMERROR autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 24, 2023 at 04:23:47PM -0800, Jakub Kicinski wrote:
> On Tue, 24 Jan 2023 13:08:01 +0200 Vladimir Oltean wrote:
> > In the following call path:
> > 
> > ethnl_default_dumpit
> > -> ethnl_default_dump_one
> >    -> ctx->ops->prepare_data
> >       -> stats_prepare_data  
> > 
> > struct genl_info *info will be passed as NULL, and stats_prepare_data()
> > dereferences it while getting the extended ack pointer.
> > 
> > To avoid that, just set the extack to NULL if "info" is NULL, since the
> > netlink extack handling messages know how to deal with that.
> > 
> > The pattern "info ? info->extack : NULL" is present in quite a few other
> > "prepare_data" implementations, so it's clear that it's a more general
> > problem to be dealt with at a higher level, but the code should have at
> > least adhered to the current conventions to avoid the NULL dereference.
> 
> Choose one:
>  - you disagree with my comment on the report
>  - you don't think that we should mix the immediate fix with the
>    structural change
>  - you agree but "don't have the time" to fix this properly

Yeah, sorry, I shouldn't have left your question unanswered ("should we make
a fake struct genl_info * to pass here?") - but I don't think I'm qualified
enough to have an opinion, either. Whereas the immediate fix is neutral
enough to not be controversial, or so I thought.

The problem is not so much "the time to fix this properly", but rather,
I'm not even sure how to trigger the ethtool dumpit() code...
