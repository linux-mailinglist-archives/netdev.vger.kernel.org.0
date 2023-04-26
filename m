Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 041B46EFACD
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 21:14:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231341AbjDZTOh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 15:14:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234988AbjDZTOf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 15:14:35 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2054.outbound.protection.outlook.com [40.107.22.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BDF13C28
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 12:14:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RgwTqjFHnlRH1HQbEE7SMy5lZQFAacfjkT+TGIxuGWLVY2KYAZFfP6ZARebRt7C3u8DQkG2qvuQApjeaCp3nG7pY/mj3ZS3ymdRkQ9zCbTiz/5q82vdfOK0bj3hrZry4vvRbkG8mJk+aDv+f4md26HRv+pbGIhX1R7Iah/sEhFjax5j2jRflc0VG6fgJvMfNyeXSL3G+e7hA++VXCLqIkxsYDI66sbCEsZ6cbHQISs3jkEfCM6I9UKvLtq9YMb1I0MftN7+NTg1bWpIjGX5wMrqWsYtHeJvUAIZsclRhA1BA9oTp4tYpRbsGORwI0FQEnXi5pNvwl+wt5MnGv6oeGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F0GkEFKW3xb8NQu1l1riYuNnhgVhvPkQF0yxtpZ8rLE=;
 b=j7cZ84w1oGdL77DV7/7bD1tIsXvKtNXsMVwkgz8WsRfMU1Gud5NJG5dJRSdkZFBNVKk0Tw1fddNPhyj74oc08Vlq9mKqvFMfZVtZo6gojpcV7lc887xvwzhx1gYL56no2xjE4QprH27AdpwKruhLEyvoigl3FT/U12N0spof7CB35oi9gyOyystA7Iz9vByIGJIBz2R/xnKkMFPyu5uBW3dfMbQ2YPsr5j67dB7wu7vJuyEnBbZPomKrh1zcGVMOwWCsa3Sc9nFRP8uLjKunpdPN50ET5jyARJfPDlMywpJPvZqknwf+Nszp6PDiLO+Sooo58j7C83b07Ph8Adj6GQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F0GkEFKW3xb8NQu1l1riYuNnhgVhvPkQF0yxtpZ8rLE=;
 b=HgG9RQuIz/Xk0b0ELeBR6ai6cegITWEg+yTarnpwowcBVWF2RnyTgKq+EuXVKr2dQNRL0ojH59mpzDq+RowlOy0DYneKGwsO+uemgs1yRXt9/Ay+IOHLn3QerdXqRlX+smLGDVciEBs/5ic2ggZ6hFvJ94NtdzUCNVnpMeBITRQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AM7PR04MB6854.eurprd04.prod.outlook.com (2603:10a6:20b:10c::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.21; Wed, 26 Apr
 2023 19:13:40 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::245a:9272:b30a:a21c]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::245a:9272:b30a:a21c%3]) with mapi id 15.20.6340.021; Wed, 26 Apr 2023
 19:13:40 +0000
Date:   Wed, 26 Apr 2023 22:13:36 +0300
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH net-next 0/2] DSA trace events
Message-ID: <20230426191336.kucul56wa4p7topa@skbuf>
References: <20230407141451.133048-1-vladimir.oltean@nxp.com>
 <d1e4a839-6365-44ef-b9ca-157a4c2d2180@lunn.ch>
 <20230412095534.dh2iitmi3j5i74sv@skbuf>
 <20230421213850.5ca0b347e99831e534b79fe7@kernel.org>
 <20230421124708.tznoutsymiirqja2@skbuf>
 <20230424182554.642bc0fc@rorschach.local.home>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230424182554.642bc0fc@rorschach.local.home>
X-ClientProxiedBy: VI1PR0102CA0103.eurprd01.prod.exchangelabs.com
 (2603:10a6:803:15::44) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AM7PR04MB6854:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f04aa61-c11e-4d35-e18b-08db468a5814
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0enjv1d7NUA2bEYiB9u1TuBcnsnMEFHLcwxqXJ+MOdoBfKjc7No2AWKroDsMaPBZz9VwzHCBCCyu4bbc64vdCjvifuCeNsV/uT6x26+gn9p8SFq2EW3dopXri7gH9fDwcAWlzzBa7gJv5fmll8jJ7rgTLqaGuT4BKM2EbrLXeeQ3cVCtK/eSeSLvXnyElWKVOYFpZDDDL3QTYeeGOrjcYmUkB0zjPy0YbgCEBUNAQR9rAc36BJait3Y6nFO27GillcKuakZ6/lc678qzF5cHvwAkqfkwCNfLAum6UPWPD2XntQvqNeyNOsWggT9szsG/yXFws3MC86JgVU2UOp2KEeH4MQCAZRZFoMWMORSyJFEq4kdQSkDmOBuiioqML1zosHu2NBqxq5NXUUZmihQ66f4GF3B2XbUNkkXM0bnx8t1CcCxW8DuTWglzuFfMrOBC1nMo/ILlQ9B+NMQSjp5Sjp5SQ1fwody0qFlNTj1zdnfRLtrGUjrqc1NAuEJvfO68EWmZdT0Z2p28H7UgFYGs7oJfV/B3v1jrjwYeql2ogxQQpOeynwugJ8XE2tKVK4uE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(346002)(376002)(396003)(39860400002)(136003)(366004)(451199021)(44832011)(2906002)(38100700002)(5660300002)(8676002)(8936002)(86362001)(66899021)(33716001)(6486002)(6666004)(26005)(1076003)(54906003)(6506007)(478600001)(6512007)(9686003)(186003)(316002)(6916009)(66556008)(66476007)(41300700001)(4326008)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?l816X2I8VsaBTpLo9lK7d/N6AYoDuBFWVCTNfxr9zX+gYByjqFZ3kGKgDHEP?=
 =?us-ascii?Q?dgTC8L85DiDzuR000HPLY0pg2zpQ+gYWpAs+lZiWrriMzIB0KVBFoUJ/wOh7?=
 =?us-ascii?Q?Z1imv9lhVTLoMUMywj5ptx79KyjJAGFsqhAdythDuHQ+fIqEQu8XdQ1446bB?=
 =?us-ascii?Q?BWiLQbCLXPmAJCi7TM2vEyFwcKjayh0ktzRovBSPqWtQdZWzDTEERs5fx541?=
 =?us-ascii?Q?10j6+OnNhPKCyGodVt81U3laMEDP2Ws9DaagMd43e2s3qDcYdP3Z27b3/1AW?=
 =?us-ascii?Q?/kmz3zvuTga4cmTAfMBOPEFDATr4eetgzB5T9rbL5FcwHhptbotH1V/n9SDv?=
 =?us-ascii?Q?/LGP/kfRgoN9+3Z/mMXBFzY20rrP6/HUyGodjoLQG4Tg64doDCsfIZBjgo6z?=
 =?us-ascii?Q?y5C/WNLVroSbB/OQT4pQNgaceUU/jjvCtdrB93f0GnE0Bey/6o1CoCNH+27B?=
 =?us-ascii?Q?i4UG5crTjpDuTVskK6RQlii29x69/GVhFdutZeIVj/Mi1cTTPYmVENulnKAX?=
 =?us-ascii?Q?0zRoM0ezhcPFBwcsF5Lxd0G6lRY2IWMQtQO8RGsmv4j1ML3gMRZUV3yV0vog?=
 =?us-ascii?Q?fBiea1tiPtCxC0d/BSU8NxltP1kCSbTjlWKA7lMOpp/2iN+1Emu9ekoHy1tD?=
 =?us-ascii?Q?SddnCvnpXIBfgDCK7GOJrekgKAuqtJF+jwLJUW/53w0/6mddn3WoGoFsC7+H?=
 =?us-ascii?Q?XvCp/m0NDg9xPWowaRM5MyckZ+n82VNFRsWW9YwaceYpgQyBTdtPDHeTGYub?=
 =?us-ascii?Q?lU7OLQEvAgNqjqwi4qH1t2JQLgNj1hGM+btlMUhMKm+XZAg0X3G2pWIcee6n?=
 =?us-ascii?Q?ZUQIWmUtp5+r2adPKrQA4FkkQs4TmIZawmAwBqXgtO25yn6dgRXZOM1nIzMj?=
 =?us-ascii?Q?7DsmlGuenQGV0K1xdFlzo/2LT/v4xnmSRqTfwelK1CS1N+GmP7zYJ2mMg+Ot?=
 =?us-ascii?Q?JRTbCGZkFdgC5zmaj9f0OqxDNF6CLFT20ygOfjGxBUu62BW9SZW6DunqluKZ?=
 =?us-ascii?Q?THIJHFykCBxJEX0AxGBioCkctT/vUJUTINZUoZj2cPkYVSMRiBbdrENMbdUY?=
 =?us-ascii?Q?mLP1ITwh33RsUb69ITFbELXDbeyysUg1GS2HxL91ckypNw8R/XmTjJEdEwXs?=
 =?us-ascii?Q?BQEEP8oNkIvqzhThbc3IEe01CluqaLJ2Zfd25JFBKvTf3G/eSMNPOohU3HoS?=
 =?us-ascii?Q?GEtWRvnpY3FzAIvWCE65pvLT/2QdbfrMRQZJj4GILYqEMatKoxLjriDQuye6?=
 =?us-ascii?Q?JG212i0Xqbq3n5Q9NeuAeTAiXeWNQAkM4+bwyPMbzNiWURnKbSZWzoYuS6IT?=
 =?us-ascii?Q?nAP7MPyfbN8nU+KyTTgNcklVRYpbSknoqyPNdTJpUmNgknmywkqkA6Tn9UTI?=
 =?us-ascii?Q?paFTTUPoTOwtM7gsAjkrTKBLEeQCaCxrcEUWJ2gft/MDPI4bBTNkZ2HoCwLM?=
 =?us-ascii?Q?D5335uuPMUglzl2x3kywakwjKdlB/AC96RNHYmzQQvIqM8C8CRcBIGJ20LTW?=
 =?us-ascii?Q?J3yLPJyeBTQYE4cb5exxb7H+17amlZRI4wloqAWQRdfQmk250MpnzZJO6IwT?=
 =?us-ascii?Q?qgTJN8BeSh++gM3dYTR9mkc5UdOAMnE0RqiLh0PxrclPK5VTvDj5ozvhOLNf?=
 =?us-ascii?Q?3Q=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f04aa61-c11e-4d35-e18b-08db468a5814
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2023 19:13:40.2874
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E97rhlttUJzM88+B7bjr+W61ZZ7BAGKDx32iP/d2EawaCm/Y8x75GRHgc5AswJTJB7RQYbr4sfqawnjJ63ULFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB6854
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 24, 2023 at 06:25:54PM -0400, Steven Rostedt wrote:
> On Fri, 21 Apr 2023 15:47:08 +0300
> Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
> 
> > On Fri, Apr 21, 2023 at 09:38:50PM +0900, Masami Hiramatsu wrote:
> > > If the subsystem maintainers are OK for including this, it is OK.
> > > But basically, since the event is exposed to userland and you may keep
> > > these events maintained, you should carefully add the events.
> > > If those are only for debugging (after debug, it will not be used
> > > frequently), can you consider to use kprobe events?
> > > 'perf probe' command will also help you to trace local variables and
> > > structure members as like gdb does.  
> > 
> > Thanks for taking a look. I haven't looked at kprobe events. I also
> > wasn't planning on maintaining these assuming stable UABI terms, just
> > for debugging. What are some user space consumers that expect the UABI
> > to be stable, and what is it about the trace events that can/can't change?
> 
> Ideally, tooling will use the libtraceevent library[1] to parse the
> events. In that case, if an event is used by tooling, you'll need to
> keep around the fields that are used by the tooling.

Ok, I did not plan for user space to treat these events as something
stable to pick up on. The Linux bridge already notifies VLANs, FDBs,
MDBs through the rtnetlink socket, and that's what I would consider to
be the stable ABI. What can be seen here (DSA) is essentially a
framework used by multiple hardware drivers, but ultimately still device
driver-level code.

What would you recommend here? A revert?
