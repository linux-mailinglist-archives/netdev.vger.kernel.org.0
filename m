Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5187469D138
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 17:18:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232319AbjBTQSU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 11:18:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231923AbjBTQSS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 11:18:18 -0500
Received: from EUR02-AM0-obe.outbound.protection.outlook.com (mail-am0eur02on2084.outbound.protection.outlook.com [40.107.247.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CE7D4C2C
        for <netdev@vger.kernel.org>; Mon, 20 Feb 2023 08:18:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ot2inEG8jSlnSwHK8bwm3mmx1AyO7l9Q2Ptg79S+o+wwFFuPhImt1r+xmlNytbLhfAvk4JtooWc6bH+O1js2/SC93BvBABpmNk7nxayBqYrOk72OfL3/TrfJ8n3ytLogRBBjLXYCqcEQ+QNrxRs+K2EMPkEig6//gt46YQCYfyEk3GyBsqec8ic6XN98CBXkvVvfL2y6wCv60cPW2KSl8Qd76HRJ2EQBf+N/JccxVZ51yWmbJ8v+VTtBj0YpzMApwnLhTYqPG+9Q4SIwOK9/y3xpT4NrmodN35wU5RZBMJr7ZlBpHQXCt1LKALNh2uxiNxqe3QtMz7MBFvr5NoZR+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y9RsDthnLZK2riWNn0uoprTGBxw6I7x6wI+P8X8YY+I=;
 b=XfpvSq8zzVBGML1Z6jWrcTsCtJIAMk/+kMRwmqLqwYJOL1yDmkq4p9RUBqmiMA0NEinxxPHiyANlx1IRv1ti1+upmdHN1Utn9PrN1GnmhUs6gFQCuV3GK8/hm+VW8CLQxanl/eM2WdReCUadGi77HLDqRHfdxXG/b4XGJ4KLu3EexLC5Ww43+MW/DumjFaZtyPYwutTeHncnKpcxkckAnRN39P7iV0lVk18VEkuwW/JdShP8BCFSCLr2lWEAIWaHPQqUiFyPL5ngd65BU4ni7LgWlzdpl4mLa8PteTuFVxDpIV1+GCF9Eu6FpmH0BCQsr4ZLadKZ/V/sfqiCiKM2wA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y9RsDthnLZK2riWNn0uoprTGBxw6I7x6wI+P8X8YY+I=;
 b=SJFkA5L3Bd9gYt9LoBDS4APvPHYto3pzw+cUIn8Lh21OOSN1v6fUapcmK0dC7mNjPMQZBlkSIeRXE31R2PW7LT8Z5T2+T+ZKzH7s9IDpUXZMszB63RLMpYKZUAPDfJtK2t/29ay1aCF47HQcwtEKs9iITqm2p7WwRPvD4UTEgTc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DBBPR04MB7722.eurprd04.prod.outlook.com (2603:10a6:10:207::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20; Mon, 20 Feb
 2023 16:18:13 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6111.019; Mon, 20 Feb 2023
 16:18:13 +0000
Date:   Mon, 20 Feb 2023 18:18:09 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     =?utf-8?B?UMOpdGVy?= Antal <peti.antal99@gmail.com>
Cc:     netdev@vger.kernel.org, John Fastabend <john.fastabend@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Ferenc Fejes <fejes@inf.elte.hu>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        =?utf-8?B?UMOpdGVy?= Antal <antal.peti99@gmail.com>
Subject: Re: [PATCH iproute2] man: tc-mqprio: extend prio-tc-queue mapping
 with examples
Message-ID: <20230220161809.t2vj6daixio7uzbw@skbuf>
References: <20230220150548.2021-1-peti.antal99@gmail.com>
 <20230220152942.kj7uojbgfcsowfap@skbuf>
 <CAHzwrcfpsBpiEsf4b2Y6xEAhno3rNKz6tWuxqRAUb0HyBT6c7Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHzwrcfpsBpiEsf4b2Y6xEAhno3rNKz6tWuxqRAUb0HyBT6c7Q@mail.gmail.com>
X-ClientProxiedBy: BE1P281CA0149.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:7c::10) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DBBPR04MB7722:EE_
X-MS-Office365-Filtering-Correlation-Id: 75856041-1bcb-4e53-1828-08db135e10a2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WHGuJAXwKJ9qp40QTIHRIqSY/b9oCIMQGGA8Y0EOJZ1JpVIlcqmiPeDmnydH6C4wW6RcahBNaRniHBJ4kZxVMGG35hDuqmkqVx0Usxnw7BCuTnh+/JsMALsLBcEXgiMSr9hl//oZWVj2gUrgIGMBof/vHo73J/CbzUPYLkJoza4lnXAwkjk9mNv8eNCqYHKDWth9x0yNiNn9+byYXzrEj024VbLAPScmgsI5LIrVy0YFAzLVY5Y5iezJievjyWlv4Y+nlRglqk7yjZAIqEuUFrqwulwj7pT1gu50UGWcLbR0ICeYUBd8+XI+4vFz5X21lqlnOvWgh40QbmOeLe+w6mMRcoqjQVAUWSSoWuWRUsy0Gruo3rFGhc1rcndXxZ6TM+xm/fH8VCVmfexB3qElCXms/29JeyM4fDcECwnhImPYvEQe6ZAmlX1Hbp+8L7JCZlt1TxbuP+7M0NEkdlWVNGe6Z4xE3s9Yf6L/sEpMY9QnoNZdRe9DHwrz8Us+P7OYtmnA0u4/kEe252XPECAU6YXwFQ4+TI9hJxi6SeAfejMG3nf8/mGvt9vpjsPieVuvWzYUnuvrykFtK9WhM9YZFNQVHXLq/AsjEPWHl1tXUMhS/LXvgzEq3R47Ksv2HyAOGpY6N1HgUX8qDJ9H02rzbg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(4636009)(396003)(366004)(39860400002)(136003)(376002)(346002)(451199018)(38100700002)(86362001)(66476007)(8676002)(6916009)(5660300002)(44832011)(2906002)(4326008)(66556008)(66946007)(8936002)(6666004)(1076003)(33716001)(186003)(9686003)(26005)(83380400001)(6512007)(66574015)(54906003)(316002)(41300700001)(6486002)(478600001)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S1F6aXN4ei9hbW1PNGM3d2d0ZmJNQmEvR0NjYmtKZkxVN3Z2RTFvSWp6NG9O?=
 =?utf-8?B?ekZFYmo1b3poZ1ozWXdidE1OSGp1Qmpnd1R0WTJFNkpXeHhHZnJROWh1QUVo?=
 =?utf-8?B?N3pnQXd2b0lCanR2b2R2RXBRMkxvUGNIQUpXTG1yUHhibWtzTWJnWGhaR3Q0?=
 =?utf-8?B?Z1NreHVnUW9hZS85MWZuTWdQRFIwNzZCMk5JalM5QkgxRlRaaDBabmlmRjl0?=
 =?utf-8?B?UGZhR0hqaCsrYmcrcmlwVEl4ZmJUS1VEYzByMGNpbjRFMDJzdTFkUndrQ3JR?=
 =?utf-8?B?VjFndDRKbGx3WTdNUXBjNDdpNW9wQTYrLzFGRVB1UXpld3IraU1EdTQ1T2pY?=
 =?utf-8?B?MlpVQ2JiUUhmcnJlTGV0NGNNR1pTMER3VzViQnRaN3NZMXl2QXZjV1BCbWFs?=
 =?utf-8?B?cmdTOGJiYTEzbWk2QlBiNWpxWE9ldDhGejNCWmdWbm40MlA0MmZtSjNJb2xI?=
 =?utf-8?B?M21wWjdEOHA2ZUdXNU92OE9neVc1cytLZXFNdFhQNVZHYVliNkVOeWZVZ2lh?=
 =?utf-8?B?Tm1GUndtTFZKQXFvdnFEOXZ4d1Rrb1RKNjVDMUtzVTZwSGlVNkl1RUMzSzJi?=
 =?utf-8?B?eDRNWjlHbXFwVlcxOHJhczJ3TlYremtPZExLVVpWY0IvQjAvWmpjaDdBd04r?=
 =?utf-8?B?MkY0VFJXaVYzdjFPL2Z4bXVTUEkveHJ0VE1LazlTSVNOSTd2ZStJbUx6c3RU?=
 =?utf-8?B?dGxtVVFNNThuMWhqZ3hPejBrR3I5VzJ6Rk1JVlJVT1JmM0h0dUo2OWtkTS82?=
 =?utf-8?B?L3N1SHZDTWpjNFZWZ1FNSGFEOFZqRURRK1BCYnluMGhnSkFJVXB6SU9ZKzRY?=
 =?utf-8?B?czdFYXkraC9zSmY2VUNLRitPajJhNFYrOE4vTEdKRWtzU0lNdlBDTUgrSUR4?=
 =?utf-8?B?Ui9Rb3BhSWdlRmVtc0l6azhZTUg5V1FJOWt1UVB5cDI0RmRqd0xaRWtaZGwx?=
 =?utf-8?B?amM5TVRiTzRORXpsNzZWQWUrUEZsakFGRDQxdjFVWWVyM1NCMk5sQlJNeHo1?=
 =?utf-8?B?c2ttTEVaUGhtbHFOa3AzUmJNOHZiWjFXbDlLWGdFam9vMHlScGkxR1NSWDZx?=
 =?utf-8?B?MGkxQ1RqSlJ1MDB6Y3U0N0lCYmpwTEZXRUpUMFVkK050Kys3eXVJRnFOMmJp?=
 =?utf-8?B?VTZNaXJ2L0xkNUl0clVxTUR5bTdjSjRLZlAvOEl6b2xVNzNMclUrdUlpdFJk?=
 =?utf-8?B?SXVmcW9vOEEzU0o1UkVXSjNVeHhhNkw4dWVXaGFzYjVVYjdxTmJ1aGFLT0NN?=
 =?utf-8?B?azNiYzl2SFR3M2NyL1ZPOGxwWDdtTDRCdzlmSG0vRVNCbG9DczRrSTFRbU43?=
 =?utf-8?B?bUNkNHltZXI4QmF3TGdOTlRpNjVVczMwTkJSV1pYKzVqdGlZaldJZGFRQnA2?=
 =?utf-8?B?OTZOK1JkSno5SWpkU2piNzRwcHl3MGk5NC9KWTBSZ2ErOEFyZ28zelZGcU5Z?=
 =?utf-8?B?TENyaGFZMXRxRnpoUDMzOEhpQWg4QjBpazNiaWhrbS84dHd4WnBsMWNLSDhx?=
 =?utf-8?B?ekVtUTNzU2hidmpldi9ZejJzQkg0REEramZuWmxMdXJ0bUJwenpzQlZ6RHYr?=
 =?utf-8?B?eW81TnR4bzZDNUkxMWg3Z3FyL1ZrUE02bHgrSEl6WWkrUThCWUxISmEwSmJz?=
 =?utf-8?B?ZHNtRzliYjJKMFlhcytLQ0x5cEdHWmRYaTVjRWpTaEEwblNGQTlud0JHMGdq?=
 =?utf-8?B?dUcwZkJxMU4vZExXNE5SRS9GVEpKTkdicHRCaW85OU1xMWZiQ1RlcmRUbjJ6?=
 =?utf-8?B?TzB4Szh5VVFjTjFORkphd0ZKNVd1aXJLVmNQQnRNZ2l0SVVQL3Vlb0hVUGxJ?=
 =?utf-8?B?clFyVDZVTzd5Y2JST1dyKzlYT0F1cFcvZUZYamFINVlQT3BJYk5ZYTg1cXVj?=
 =?utf-8?B?MUZBWXZPVUErK05GaUU1UlhGNnpNN0Z2MHREeURKd0lReDZvbkF2bTErMUdD?=
 =?utf-8?B?dER6VFJZNW5NMVgxUy9hQmUyUllWalRoMWsxQ0VVNjhaZFBEUTcwNU5Zd1lY?=
 =?utf-8?B?QXhiZW9CVStkUDExN2ZkZ3BwUFBpUDJmUVNiamxTaEVkdXpqcE04ZjRVc0Y1?=
 =?utf-8?B?dkF4QytvK3lJcUJ1UlRadGhNZEcxVnl2M1A4NU9ZSUdjbXBKNWZQVVBXNnlC?=
 =?utf-8?B?S1VYTmhhLzN5ZzFFMlNJYTl2UW9qTDY0S091QVE3ckhQS2J1V2NTdy9VZUdG?=
 =?utf-8?B?Wnc9PQ==?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75856041-1bcb-4e53-1828-08db135e10a2
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 16:18:13.2156
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BuY6IEVdvbU05rIH1yrRDSVhyxWogwogwuBke2+1DnYkta8aDvywsYPP4RfNc+LzKyiPevyDtudYcBB5X6GOJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7722
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 20, 2023 at 05:01:57PM +0100, Péter Antal wrote:
> Hi Vladimir,
> 
> Vladimir Oltean <vladimir.oltean@nxp.com> ezt írta (időpont: 2023.
> febr. 20., H, 16:29):
> >
> > Hi Péter,
> >
> > On Mon, Feb 20, 2023 at 04:05:48PM +0100, Péter Antal wrote:
> > > The current mqprio manual is not detailed about queue mapping
> > > and priorities, this patch adds some examples to it.
> > >
> > > Suggested-by: Ferenc Fejes <fejes@inf.elte.hu>
> > > Signed-off-by: Péter Antal <peti.antal99@gmail.com>
> > > ---
> >
> > I think it's great that you are doing this. However, with all due respect,
> > this conflicts with the man page restructuring I am already doing for the
> > frame preemption work. Do you mind if I fix up some things and I pick your
> > patch up, and submit it as part of my series? I have some comments below.
> 
> That's all right, thank you for doing this, just please carry my
> signoff as co-developer if possible.

Absolutely, this is implied.

> I agree with most of your suggestions.

I've applied your changes on top of mine. Can you and Ferenc please
review the end result? I'll take a small break of a couple of hours,
and continue working on this when I come back.

$ cat man/man8/tc-mqprio.8
.TH MQPRIO 8 "24 Sept 2013" "iproute2" "Linux"
.SH NAME
MQPRIO \- Multiqueue Priority Qdisc (Offloaded Hardware QOS)
.SH SYNOPSIS
.B tc qdisc ... dev
dev (
.B parent
classid | root) [
.B handle
major: ]
.B mqprio
.ti +8
[
.B num_tc
tcs ] [
.B map
P0 P1 P2... ] [
.B queues
count1@offset1 count2@offset2 ... ]
.ti +8
[
.B hw
1|0 ] [
.B mode
dcb|channel ] [
.B shaper
dcb|bw_rlimit ]
.ti +8
[
.B min_rate
min_rate1 min_rate2 ... ] [
.B max_rate
max_rate1 max_rate2 ... ]
.ti +8
[
.B fp
FP0 FP1 FP2 ... ]

.SH DESCRIPTION
The MQPRIO qdisc is a simple queuing discipline that allows mapping
traffic flows to hardware queue ranges using priorities and a configurable
priority to traffic class mapping. A traffic class in this context is
a set of contiguous qdisc classes which map 1:1 to a set of hardware
exposed queues.

By default the qdisc allocates a pfifo qdisc (packet limited first in, first
out queue) per TX queue exposed by the lower layer device. Other queuing
disciplines may be added subsequently. Packets are enqueued using the
.B map
parameter and hashed across the indicated queues in the
.B offset
and
.B count.
By default these parameters are configured by the hardware
driver to match the hardware QOS structures.

.B Channel
mode supports full offload of the mqprio options, the traffic classes, the queue
configurations and QOS attributes to the hardware. Enabled hardware can provide
hardware QOS with the ability to steer traffic flows to designated traffic
classes provided by this qdisc. Hardware based QOS is configured using the
.B shaper
parameter.
.B bw_rlimit
with minimum and maximum bandwidth rates can be used for setting
transmission rates on each traffic class. Also further qdiscs may be added
to the classes of MQPRIO to create more complex configurations.

.SH ALGORITHM
On creation with 'tc qdisc add', eight traffic classes are created mapping
priorities 0..7 to traffic classes 0..7 and priorities greater than 7 to
traffic class 0. This requires base driver support and the creation will
fail on devices that do not support hardware QOS schemes.

These defaults can be overridden using the qdisc parameters. Providing
the 'hw 0' flag allows software to run without hardware coordination.

If hardware coordination is being used and arguments are provided that
the hardware can not support then an error is returned. For many users
hardware defaults should work reasonably well.

As one specific example numerous Ethernet cards support the 802.1Q
link strict priority transmission selection algorithm (TSA). MQPRIO
enabled hardware in conjunction with the classification methods below
can provide hardware offloaded support for this TSA.

.SH CLASSIFICATION
Multiple methods are available to set the SKB priority which MQPRIO
uses to select which traffic class to enqueue the packet.
.TP
From user space
A process with sufficient privileges can encode the destination class
directly with SO_PRIORITY, see
.BR socket(7).
.TP
with iptables/nftables
An iptables/nftables rule can be created to match traffic flows and
set the priority.
.BR iptables(8)
.TP
with net_prio cgroups
The net_prio cgroup can be used to set the priority of all sockets
belong to an application. See kernel and cgroup documentation for details.

.SH QDISC PARAMETERS
.TP
num_tc
Number of traffic classes to use. Up to 16 classes supported.
There cannot be more traffic classes than TX queues.

.TP
map
The priority to traffic class map. Maps priorities 0..15 to a specified
traffic class. The default value for this argument is

  ┌────┬────┐
  │Prio│ tc │
  ├────┼────┤
  │  0 │  0 │
  │  1 │  1 │
  │  2 │  2 │
  │  3 │  3 │
  │  4 │  4 │
  │  5 │  5 │
  │  6 │  6 │
  │  7 │  7 │
  │  8 │  0 │
  │  9 │  1 │
  │ 10 │  1 │
  │ 11 │  1 │
  │ 12 │  3 │
  │ 13 │  3 │
  │ 14 │  3 │
  │ 15 │  3 │
  └────┴────┘

.TP
queues
Provide count and offset of queue range for each traffic class. In the
format,
.B count@offset.
Without hardware coordination, queue ranges for each traffic classes cannot
overlap and must be a contiguous range of queues. With hardware coordination,
the device driver may apply a different queue configuration than requested,
and the requested queue configuration may overlap (but the one which is applied
may not). The default value for this argument is:

  ┌────┬───────┬────────┐
  │ tc │ count │ offset │
  ├────┼───────┼────────┤
  │  0 │    0  │    0   │
  │  1 │    0  │    0   │
  │  2 │    0  │    0   │
  │  3 │    0  │    0   │
  │  4 │    0  │    0   │
  │  5 │    0  │    0   │
  │  6 │    0  │    0   │
  │  7 │    0  │    0   │
  │  8 │    0  │    0   │
  │  9 │    0  │    0   │
  │ 10 │    0  │    0   │
  │ 11 │    0  │    0   │
  │ 12 │    0  │    0   │
  │ 13 │    0  │    0   │
  │ 14 │    0  │    0   │
  │ 15 │    0  │    0   │
  └────┴───────┴────────┘

.TP
hw
Set to
.B 1
to support hardware offload. Set to
.B 0
to configure user specified values in software only.
Without hardware coordination, the device driver is not notified of the number
of traffic classes and their mapping to TXQs. The device is not expected to
prioritize between traffic classes without hardware coordination.
The default value of this parameter is
.B 1.

.TP
mode
Set to
.B channel
for full use of the mqprio options. Use
.B dcb
to offload only TC values and use hardware QOS defaults. Supported with 'hw'
set to 1 only.

.TP
shaper
Use
.B bw_rlimit
to set bandwidth rate limits for a traffic class. Use
.B dcb
for hardware QOS defaults. Supported with 'hw' set to 1 only.

.TP
min_rate
Minimum value of bandwidth rate limit for a traffic class. Supported only when
the
.B 'shaper'
argument is set to
.B 'bw_rlimit'.

.TP
max_rate
Maximum value of bandwidth rate limit for a traffic class. Supported only when
the
.B 'shaper'
argument is set to
.B 'bw_rlimit'.

.TP
fp
Selects whether traffic classes are express (deliver packets via the eMAC) or
preemptible (deliver packets via the pMAC), according to IEEE 802.1Q-2018
clause 6.7.2 Frame preemption. Takes the form of an array (one element per
traffic class) with values being
.B 'E'
(for express) or
.B 'P'
(for preemptible).

Multiple priorities which map to the same traffic class, as well as multiple
TXQs which map to the same traffic class, must have the same FP attributes.
To interpret the FP as an attribute per priority, the
.B 'map'
argument can be used for translation. To interpret FP as an attribute per TXQ,
the
.B 'queues'
argument can be used for translation.

Traffic classes are express by default. The argument is supported only with
.B 'hw'
set to 1. Preemptible traffic classes are accepted only if the device has a MAC
Merge layer configurable through
.BR ethtool(8).

.SH SEE ALSO
.BR ethtool(8)

.SH EXAMPLE

The following example shows how to attach priorities to 4 traffic classes
('num_tc 4'), and how to pair these traffic classes with 4 hardware queues,
with hardware coordination ('hw 1'), according to the following configuration.

  ┌────┬────┬───────┐
  │Prio│ tc │ queue │
  ├────┼────┼───────┤
  │  0 │  0 │     0 │
  │  1 │  0 │     0 │
  │  2 │  0 │     0 │
  │  3 │  0 │     0 │
  │  4 │  1 │     1 │
  │  5 │  1 │     1 │
  │  6 │  1 │     1 │
  │  7 │  1 │     1 │
  │  8 │  2 │     2 │
  │  9 │  2 │     2 │
  │ 10 │  2 │     2 │
  │ 11 │  2 │     2 │
  │ 12 │  3 │     3 │
  │ 13 │  3 │     3 │
  │ 14 │  3 │     3 │
  │ 15 │  3 │     3 │
  └────┴────┴───────┘

Traffic class 0 (TC0) is mapped to hardware queue 0 (TXQ0), TC1 is mapped to
TXQ1, TC2 is mapped to TXQ2, and TC3 to TXQ3.

.EX
# tc qdisc add dev eth0 root mqprio \\
        num_tc 4 \\
        map 0 0 0 0 1 1 1 1 2 2 2 2 3 3 3 3 \\
        queues 1@0 1@1 1@2 1@3 \\
        hw 1
.EE

The following example shows how to attach priorities to 3 traffic classes
('num_tc 3'), and how to pair these traffic classes with 4 queues, without
hardware coordination ('hw 0'), according to the following configuration:

  ┌────┬────┬────────┐
  │Prio│ tc │  queue │
  ├────┼────┼────────┤
  │  0 │  0 │      0 │
  │  1 │  0 │      0 │
  │  2 │  0 │      0 │
  │  3 │  0 │      0 │
  │  4 │  1 │      1 │
  │  5 │  1 │      1 │
  │  6 │  1 │      1 │
  │  7 │  1 │      1 │
  │  8 │  2 │ 2 or 3 │
  │  9 │  2 │ 2 or 3 │
  │ 10 │  2 │ 2 or 3 │
  │ 11 │  2 │ 2 or 3 │
  │ 12 │  2 │ 2 or 3 │
  │ 13 │  2 │ 2 or 3 │
  │ 14 │  2 │ 2 or 3 │
  │ 15 │  2 │ 2 or 3 │
  └────┴────┴────────┘

TC0 is mapped to hardware TXQ0, TC1 to TXQ1, and TC2 is mapped to TXQ2 and
TXQ3, where the queue selection between these two queues is arbitrary.

.EX
# tc qdisc add dev eth0 root mqprio \\
        num_tc 3 \\
        map 0 0 0 0 1 1 1 1 2 2 2 2 2 2 2 2 \\
        queues 1@0 1@1 2@2 \\
        hw 0
.EE

In the following example, there are 8 hardware queues mapped to 5 traffic
classes according to the configuration below:

        ┌───────┐
 tc0────┤Queue 0│◄────1@0
        ├───────┤
      ┌─┤Queue 1│◄────2@1
 tc1──┤ ├───────┤
      └─┤Queue 2│
        ├───────┤
 tc2────┤Queue 3│◄────1@3
        ├───────┤
 tc3────┤Queue 4│◄────1@4
        ├───────┤
      ┌─┤Queue 5│◄────3@5
      │ ├───────┤
 tc4──┼─┤Queue 6│
      │ ├───────┤
      └─┤Queue 7│
        └───────┘

.EX
# tc qdisc add dev eth0 root mqprio \\
        num_tc 5 \\
        map 0 0 0 1 1 1 1 2 2 3 3 4 4 4 4 4 \\
        queues 1@0 2@1 1@3 1@4 3@5
.EE


.SH AUTHORS
John Fastabend, <john.r.fastabend@intel.com>
