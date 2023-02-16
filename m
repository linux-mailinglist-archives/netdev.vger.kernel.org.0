Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F5ED699956
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 16:58:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229803AbjBPP6Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 10:58:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbjBPP6X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 10:58:23 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2084.outbound.protection.outlook.com [40.107.7.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C3784BEA5;
        Thu, 16 Feb 2023 07:58:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JwoiMUxOtAybbJfC8pADsS9DuXSU1DmwfMbJIDHC85sjMYqGktzPYog3Dxpwe11liePL0YQnovAvAQT3O480SNCleVp3TqeXdK13jWWrBng3sSGal1NJkPeffZawskS7rI+zW3iHgKEd5mkC5XSG2RUQhr7OTBc17MUi+yBhIs/Wq+/notjqLxWfXvPVRYXnIeGd6g/mUR+4BygjzSRTIOG5Pqj/wqARMQz9oBjqKXhNGnOLMrB9KM/ucZQBo6jKvC4xsvqp8MTrvxcyyZj6RzSQHki7fYhQkS3TKBy+QW3JC+Z0wESSws1mCbGqIR6fSUcCYW31qGmbFgqyG3C4QQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d6W/Adja2JlEuK2+rD7Yeh7KY36+Rskqr/Xmkby+R9k=;
 b=BBD3lA0fqFGT2UCWsuBa/kwya6GVcDu7ddOzMqJCkbF0PfYpcDQFCnXd+Uypxe/QXvtMfFLdhxozqyoMw7vOuaqWzAAWViPnJAkP6dCRKoM9PIY0avyr37hcsPiN1NitF4VbKIHOlNHxEJIs6mknoIXLKpvne3rXToFUOAcHBQxDADsOlusbjA3xvRG6wk1+1S/0L5zzW8ROp3EmiQ24cTfNqJCVs768UsmX/nyV2ium4BBvqJazD3JAPpgUvBojF4LNn5/BjLw3arCfpsnXKDE0E6YlZWUdoxQ7xFzuEZgNlJ7iX+rDK8m3OrSz8Nird8tY1NUdvX3hyfgXxYkfig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d6W/Adja2JlEuK2+rD7Yeh7KY36+Rskqr/Xmkby+R9k=;
 b=Umup/OpKXGg6/KYgIwqNRvdSSp9XYJ0tSPyIQAUZMfwIYScpHTCa3jbpg3SQKNeCRbggpA8NYkA4M02xeDUlk5YOkfzA9+bWl6MYHO46noTyHzo3/sHK0lipjucETqs7DqguPvwcmmkgeM2v5WVO0rCX9Hyc5zR199kNeG9W4MQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DU2PR04MB8725.eurprd04.prod.outlook.com (2603:10a6:10:2dc::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Thu, 16 Feb
 2023 15:58:18 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.6086.026; Thu, 16 Feb 2023
 15:58:18 +0000
Date:   Thu, 16 Feb 2023 17:58:13 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Ferenc Fejes <fejes@inf.elte.hu>
Cc:     peti.antal99@gmail.com, "andrew@lunn.ch" <andrew@lunn.ch>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "bigeasy@linutronix.de" <bigeasy@linutronix.de>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Yannick Vignon <yannick.vignon@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "idosch@nvidia.com" <idosch@nvidia.com>,
        "gerhard@engleder-embedded.com" <gerhard@engleder-embedded.com>,
        "Y.B. Lu" <yangbo.lu@nxp.com>, "jiri@nvidia.com" <jiri@nvidia.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "kurt@linutronix.de" <kurt@linutronix.de>,
        Rui Sousa <rui.sousa@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>
Subject: Re: [PATCH v2 net-next] selftests: forwarding: add Per-Stream
 Filtering and Policing test for Ocelot
Message-ID: <20230216155813.un3icarhi2h6aga2@skbuf>
References: <20220501112953.3298973-1-vladimir.oltean@nxp.com>
 <302dc1fb-18aa-1640-dfc7-6a3a7bc6d834@ericsson.com>
 <20220506120153.yfnnnwplumcilvoj@skbuf>
 <c2730450-1f2b-8cb9-d56c-6bb8a35f0267@ericsson.com>
 <20220526005021.l5motcuqdotkqngm@skbuf>
 <cd0303b16e0052a119392ed021d71980db63e076.camel@ericsson.com>
 <20220526093036.qtsounfawvzwbou2@skbuf>
 <009e968cc984b563c375cb5be1999486b05db626.camel@inf.elte.hu>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <009e968cc984b563c375cb5be1999486b05db626.camel@inf.elte.hu>
X-ClientProxiedBy: VI1PR0501CA0019.eurprd05.prod.outlook.com
 (2603:10a6:800:92::29) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DU2PR04MB8725:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e87c0e8-6edf-4e6f-2586-08db10369e74
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c78n8Y/NxCYrV2lXELKpRM7VnPyT4vCEnxm8NWKymsoPVU8tpOavqd4b35kS06NqWTVvQi8GiqnuH0kNR+4nu+LrXo6lKGAA94v0I1UP4sKg/0gnQ7XNO0FLa2qF/Jl+yDxGQ8mWmpE+fgzvuny3RxYO5mYE8RPAs3vfC6X7WqjRuGcnmDYiiWCHDEOPCDlQjIqCJ3KD38nDGsk2I2nPPI01hg5lFmyAJ9K/ZN/dpqXm+qtBtG258NhYGrY1Av9SqAf4yargTDQTOEJTRNBKfaWK4vmUbtCubPBRTAtnjH4ds3h3YrwBVmZkaVWUFtYDT8I1dpKj5ms5a/oVL3Z7RCNerAMe0J9jabdOfQHhxO65rk3XapByURQFhTw9a9mx4FdH8NeLofxjpIKfqdF3BMWKmJd8bfvXNSqTgGURyOx0eJlB96Mn+khmd7bWdZ1GuBNrtTHmJipfB1JmVBnM/+Vkqm+YZtsvDFEBXf2xyu9mYfD8uLczU4S5ffevJW2HXS4Ht2507OXAPoQdaU3IGXWaP0SI1YLmeCbhERtp/7B1klbxvGH7hUv4RKOwdDMCKdCQTu0R9yN6IdQJ19sgIvoQkICXAAUVlYwL7eFFbfsFk4NvnOEU0tiFcGxh6FY7+qWaee4pMOEY5giMqGuUbg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(4636009)(376002)(366004)(346002)(39860400002)(136003)(396003)(451199018)(1076003)(296002)(26005)(66946007)(316002)(478600001)(54906003)(6512007)(9686003)(6486002)(6666004)(2906002)(8676002)(8936002)(44832011)(66476007)(41300700001)(66556008)(5660300002)(4326008)(6916009)(186003)(86362001)(33716001)(38100700002)(6506007)(7416002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?Lw+4/epC3vImvHii7DA6bMMPhWxVAnZrnMpP3rS+7DCxx0amTcmOhVeeZn?=
 =?iso-8859-1?Q?IaFX+U4aLeWZGGONX1+JUwbXmZYrqod/d/ciVJzrJJrFAsRCZTBa+UPrDM?=
 =?iso-8859-1?Q?grug5NFhaMphES3UjQbGWr79cgcRGf/WCtf3Z8z2YsBwEZmdhsVo3zAcQ5?=
 =?iso-8859-1?Q?hTZ9kcWGrv7jIw4ryqvhSkkgXFV36XiECgEuPuZ7/dapBOctLYj7Mkwroc?=
 =?iso-8859-1?Q?p9g/FE0Uxg1Ld8wbcCPmnqBKljQtmw28IewLYh8nnJHolTjkbqu4zO+hCk?=
 =?iso-8859-1?Q?MeROFpsLobLCOaBPHFADKriuaTfxrBnixv8kbX8817iY78PrGq1aFgFoJ8?=
 =?iso-8859-1?Q?GqjLf6jkMYo93S1YP7wjHKeE0zrbE6OvJ2qO36QrYUmRJwpsFh0jDvlYvq?=
 =?iso-8859-1?Q?IRqqAgp6iPMudquTgRjsjiHCXaOLJiGBUMN9rjSkbFChaLUldoW15Ktlxw?=
 =?iso-8859-1?Q?LhPQQ188s1jZo6a4QK/dx+fFv/GeKk4h7xlqV1YEKZCBL10htfNFdzNGnh?=
 =?iso-8859-1?Q?adB4xSbGUbL+MsFjPvJ6+iMcrp2w4fYQFIBvFPYJtBM1bNlerSrUn0ohuQ?=
 =?iso-8859-1?Q?/0Jb9CTzkzawD13ewP41VQzEcisTeGMjjE+2qBzilwwtJ+AVRqIEkNGEjh?=
 =?iso-8859-1?Q?ZFvsjnlMhOcgGJ1ad4ZOxB2OjVaCxgUB4eZgUMcGS5fkzgaFacMnO8Bz10?=
 =?iso-8859-1?Q?unISNEmd5uHPLu0C5xYi2XUixIaaQfvAvbihasROeWmuZKpViQZ0F8GCTY?=
 =?iso-8859-1?Q?CUAJRb01iR+QUUaFJ0ULLtdIRgbjptRfWpR6+Fnk2XmmPVMbTyq4NrdMkS?=
 =?iso-8859-1?Q?YB4x8CaH1w/YEPtNgpDvOQOWxPxPqi0HBtjhcAl7c6TRCss+4q67WABI1H?=
 =?iso-8859-1?Q?asKFyiECzb8+YMXWFmS86iANdRD1+kb6n+SjS0Muaxp4ohnN4HmkV7qHiR?=
 =?iso-8859-1?Q?vHHuHYrmqIkC4wfqk2pmZN2OyGKBsBCajOouPlKSiWXFAP1f4vD8b79ZKM?=
 =?iso-8859-1?Q?tfWXsEzCEJk5/bZK0advR+u8yNquTH88Q2n4bs2LvKi2CZLWQli+O2885W?=
 =?iso-8859-1?Q?bpEIL/H6J3I069+y7MyfE3gb5oovRBmvspuTeX/uhaBYv+aryCexUiYRnT?=
 =?iso-8859-1?Q?SahoF8JxbXzPztAOTqoutcGFagUXKy/00cElNnqfKuKBUyh2n/7AfbZ2Bg?=
 =?iso-8859-1?Q?xfDwXdoihrVCL5oM0pKXDi2xPpFKlL3rjsbLbBs7AF8hmLjrS0GROGqNRq?=
 =?iso-8859-1?Q?RVj/nCFcmRSffICjMZRxeDSPsE5U2es9T4jSSLkG1JzwQl6NDC5IB6t/vC?=
 =?iso-8859-1?Q?H3rFOtw/AfGBoKbOT/HYBBY6V06INCpIUnE5JXHP933WxLgjPVOniL13uK?=
 =?iso-8859-1?Q?+vZKC4fjUNRJEgc/QwZuIDCffzrXF6Nkz9i4vuJBGxopUA59HjLI6IGuhB?=
 =?iso-8859-1?Q?K2ZKJUWmN7Ul67aTmt5waOUsmvWkoBMUvBzdK5PSsiOB7oKt+BqM2RzmIv?=
 =?iso-8859-1?Q?Z1TGPq7ApOCMVnWRPH/UyixG3VX5yRLUYek8Zu9Q00ODbCIyMBdxyxVNWJ?=
 =?iso-8859-1?Q?7etciadhUiQKub4Pb4nMMw1VuxFkaw8fzHt5E8lsqGM1OqEZPXgN/EWM9J?=
 =?iso-8859-1?Q?I1pbrOYKGV36GRwfQ/8CiNQ7QFWu5nArjZCfoMiFS3hRHkpBfrTZLsYA?=
 =?iso-8859-1?Q?=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e87c0e8-6edf-4e6f-2586-08db10369e74
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 15:58:17.9340
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9UK8yyM6IHbfd/4eMj8MFziVofQe/dmyzpzA5qGXiWZTIO5o/z6DS71/uq7IWfKupw1Zutwd6ZK/DoH9rzGx5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8725
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 16, 2023 at 02:47:11PM +0100, Ferenc Fejes wrote:
> > To fix this, we need to keep a current_ipv variable according to the
> > gate entry that's currently executed by act_gate, and use this IPV to
> > overwrite the skb->priority.
> > 
> > In fact, a complication arises due to the following clause from
> > 802.1Q:
> > 
> > > 8.6.6.1 PSFP queuing
> > > If PSFP is supported (8.6.5.1), and the IPV associated with the stream
> > > filter that passed the frame is anything other than the null value, then
> > > that IPV is used to determine the traffic class of the frame, in place
> > > of the frame's priority, via the Traffic Class Table specified in 8.6.6.
> > > In all other respects, the queuing actions specified in 8.6.6 are
> > > unchanged. The IPV is used only to determine the traffic class
> > > associated with a frame, and hence select an outbound queue; for all
> > > other purposes, the received priority is used.
> 
> Interesting. In my understanding this indeed something like "modify the
> queueing decision while preserve the original PCP value".

I actually wonder what the interpretation in the spirit of this clause is.
I'm known to over-interpret the text of these IEEE standards and finding
inconsistencies in the process (being able to prove both A and !A).

For example, if we consider the framePreemptionAdminStatus (express or
preemptible). It is expressed per priority. So this means that the
Internal Priority Value rewritten by PSFP will not affect the express/
preemptible nature of a frame, but it *will* affect the traffic class
selection?

This is insane, because it means that to enforce the requirements of
clause 12.30.1.1.1:

| Priorities that all map to the same traffic class should be
| constrained to use the same value of preemption status.

it is insufficient to check that the prio_tc_map does not make some
traffic classes both express and preemptible. One has to also check the
tc-gate configuration, because the literal interpretation of the standard
would suggest that a packet is preemptible or express based on skb->priority,
but is classified to a traffic class based on skb->ipv. So I guess IPV
rewriting can only take place between one preemptible priority and another,
or only between one express priority and another, and that we should
somehow test this. But PSFP is at ingress, and FP is at egress, so we'd
somehow have to test the FP adminStatus of all the other net devices
that we can forward to!!!

I'll try to ask around and see if anyone knows more details about what
is the expected behavior.

> Your solution certainly correct and do the differentiation between the
> cases where we have PSFP at ingress or not. However in my understanding
> the only purpose of the IPV is the traffic class selection. 
> 
> Setting skb->queue_mapping to IPV probably wont work, because of two
> reasons:
> 1. it brings inconsistency with the mqprio/taprio queues and the actual
> hw rings the traffic sent
> 2. some drivers dont check if skb->queue_mapping is bounded, they
> expect its smaller than the num_tx_queues.
> 
> The 2. might be solvable, but the 1. is more problematic. However with
> a helper, we might check if skb->queue_mapping is already set and use
> that as a traffic class. Is that possible? I dont really see any other
> codepath where that value can be other than zero before the qdisc
> layer. That way one flag (use_ipv) might be enough which tells that we
> should use the skb->queue_mapping as is (set by act_gate) and preserve
> skb->priority.
> 
> What do you think? Again, sorry for being late here, but I'm following
> the list and see that recently you did major mqprio/taprio fixes and
> refactors, so I hope your cache line is hot.

I'm afraid it's not so easy to reuse this field for the IPV, because
skb->queue_mapping is already used between the RX and the TX path for
"recording the RX queue", see skb_rx_queue_recorded(), skb_record_rx_queue(),
skb_get_rx_queue().
