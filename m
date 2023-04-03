Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3A746D4364
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 13:24:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231965AbjDCLYS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 07:24:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230175AbjDCLYR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 07:24:17 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2058.outbound.protection.outlook.com [40.107.20.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8DF761A1
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 04:23:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mt8rB0PCy4epUHHYCzo4hNq5Ju4PwmAdbG7OtjqT+HuOToTs+cAqwAs+Y4riRjNj+Qx/S5FA6iuT8Y5Ca7feCQsanK3QTww0tzPZKMjG2tao3C/JAljB1BV4cW44Ve5IV2Y4CasPnGLVFAy9yI0NhVVDpYwpAkQBfyIAakYBC29G5MCQFuZWc86xS7Syeud5t68OAd76RfjF0c4V3qPR3cMOrpfUWlcl3LD9oOKl63VVTJTtXq2bISSh13TrfwjHINIn3SnLDn/Md434Iab8c9jUlObQ1c0GKEapNCrz6yyjZHSHWeHjPZxL6BQji66AX73YheMjKx99ZiD5guXzXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V8ydtJzi6yS21EzU57jbejHrdagxaKkzaJfwNZJ4imk=;
 b=CB5EJv4emldQAXOia8regM8MwTAMemMMmDOevRvod7+3bgnyDByUu5Z6t+df6OhNlzCFeOvKEO4v1w/CxUz9CAWmpS+rvcGh34Q3Shr+tU1AF7eUY+wJdJvtPM+XmL44i3vCoy4C4MnfP+HiUbRgziQ53y/W3zqHzYNQD600ZhPcEsASMCq/APr24zXl+b0JPFo5XDW8s4n7rXf4FCzmdYC74+tIAs82NMQYZDvWfoSKgUcb3iggHBfgsMWcQSm89XCjJEBhVdK3S8IfOMYIE3ZFD0m3PfIugeTdrdmgdotusMWGPnIpRyO+tAfyDlhgkTZNME+2BxNdGZejVWwXiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V8ydtJzi6yS21EzU57jbejHrdagxaKkzaJfwNZJ4imk=;
 b=UpmHn6dLTrEAhq86f9Or7BEgN2k5EmuPV6eH/tWN1mKRwZ85zrWtMam+rSMUriI47FBH9tj1gVhVwnRMzkz4Mqr28Eewj+pPLTq/59hzSie2O+D9c287/L1HZ9eUtrXfCOgbsKsLilkJ1DV2robsF1y6RBggg+Y6nsKXJj2JAZs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by DU2PR04MB8679.eurprd04.prod.outlook.com (2603:10a6:10:2de::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.33; Mon, 3 Apr
 2023 11:23:52 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5%3]) with mapi id 15.20.6254.026; Mon, 3 Apr 2023
 11:23:52 +0000
Date:   Mon, 3 Apr 2023 14:23:48 +0300
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Ferenc Fejes <primalgamer@gmail.com>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        =?utf-8?B?UMOpdGVy?= Antal <antal.peti99@gmail.com>
Subject: Re: [PATCH iproute2-next 0/9] Add tc-mqprio and tc-taprio support
 for preemptible traffic classes
Message-ID: <20230403112348.patphgia5en6v2ec@skbuf>
References: <20230403105245.2902376-1-vladimir.oltean@nxp.com>
 <6546e93dca588c3c01e56466e6f5ae10e37870bf.camel@gmail.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6546e93dca588c3c01e56466e6f5ae10e37870bf.camel@gmail.com>
X-ClientProxiedBy: FR3P281CA0029.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1c::22) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|DU2PR04MB8679:EE_
X-MS-Office365-Filtering-Correlation-Id: 9337dfc4-2086-460b-8f15-08db3435e74f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4ATGS69KCjYv3m5YfhE+EJVFKTRt4NIju7opL8T3mLiAH4H6t7146Yh1uZBxITrAY4u3seYSWlckqIdZRjugkwsNWTKbZbKp3g4HZwLUO248BMCZ5evNIFXuvOkXBmUpQrs7lV9OXaoSUYf4dQlGHQBEhRt8XSm0Idk62LjuNvXha6yJqlY221qU848VnOf7xSb70LoFVi1uQ8FcpEniGB9/Bm0ffTai+2HNnA+OVD8jf5EJ8O4kfGXhpXILOq0KrA1yodPSCAjn6VpY18vbRgD7yeeeAYGfbJEmHXpruf4D2t5SseLQ82csindqEtmCJ93HZ6X4kUhimcP+C3w23da+K8rYusDOaix3Le2TH5LNENBDGVJqj16H7RqtZezLoOeCe8RjZzcC+aepnOKcrjWp+4R9i7hE/pE9qdCdVdSI6iQxSJQuiVUsOQGLn9fT1T1R71nfz2F1x6rYC1EbWzSFakH7e5vhsETF4h00LqsNp3EexViBYXQ4N9TCaLkfs0HIFmfNB9dRaMgb+3xB/Km4sW9yh7UlxCFr012dpJb5aP9smH13iFJo+fAD7deNkUBhiyr6SCAiA1T0qu5llw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(136003)(376002)(346002)(396003)(366004)(39860400002)(451199021)(6916009)(66946007)(66476007)(66556008)(8676002)(54906003)(478600001)(316002)(8936002)(5660300002)(38100700002)(41300700001)(44832011)(4326008)(186003)(66574015)(83380400001)(966005)(6486002)(6666004)(9686003)(6506007)(1076003)(26005)(6512007)(86362001)(33716001)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?RHBUO3JoopywM4CYAloV5R0tfmtN97O1Tjm6HFXVZRrFDHcB8oTg28rMoK?=
 =?iso-8859-1?Q?EkbO6x9ShGG2juH3PttEvmKMA96hKbi9YnvsBBlqPjyGMTXZ+5QvwgpqWD?=
 =?iso-8859-1?Q?5EtZlgPlG6e55wfrd7G5yvli0kgyy1r462XqE7GikX5/oZQMQR+zE9QW1E?=
 =?iso-8859-1?Q?/7eGWkhCi9EtrYO0dw4Koly2NlhmetppymJgSau4OHr/HMnYrNuibFOqRS?=
 =?iso-8859-1?Q?j1N9VFON1x3uqe8WQ9e6RFCnUDj2kGXkahkghNNJmeeLyKyZHDyON/d9V5?=
 =?iso-8859-1?Q?nkvy2ORg9rNgSVDURpJsX1uDxTwyDMHIy4lcQjPuaqLEVhRjoBfwVniiOO?=
 =?iso-8859-1?Q?CXiBT2aOWiujlCmVvFM5q2yvgwx5QRBhGhyr/KqzzRzC3Tw/KQ6jnGcJve?=
 =?iso-8859-1?Q?+pEV4/kHRMrt2nap/vidwvNIGLTNxca9u/ngbbFwIPyEREh+keCTzSQUm4?=
 =?iso-8859-1?Q?sDxcyLUYzx9eiIQxhZaXY8yjtVVvOvvZqviqwGSrsHrSxq7VY5qs/tjBr/?=
 =?iso-8859-1?Q?78NZoO83Rmeji2YXUwO/WozZwg1TSAnPCv7tYsz9AdzSImHtiC+Ncgg7rb?=
 =?iso-8859-1?Q?Jot7+Q0cks4nbG5Q9i7zgHTT1A2wUt6F8lbj+hB33OeENYS6FWqTJvGLjy?=
 =?iso-8859-1?Q?KG6FP/x/M5naPgXjrKDD6EUw3F6ErRHnFUF+gFX3eM5y46H3XOlLGrUo4w?=
 =?iso-8859-1?Q?ZdJD1jljhMtbpIBklvST+XltZAuYFKOHEy1fxPc7NoD8Gn1oj2PXbQ3yT8?=
 =?iso-8859-1?Q?mo3WRTXcy5m94PlGwMN8JWltes1dK6FoJvYPu9j35NblOKBzNTHsc9yOUo?=
 =?iso-8859-1?Q?0Rd0GukQk/a7S7oZ7/qyGDDfl3VIf1/hjWhQnAjifVuvumNHeghfciLLvI?=
 =?iso-8859-1?Q?1fgDmdrXNKADIkDH1Ju/+fqNU7An8uKq+47P+mW2pFVlc5/xuCQt1Bysjh?=
 =?iso-8859-1?Q?CAB1tdydw7r0ZucO8KJTFAGAcVw311lcBozj4bCoDsg5rdmKleQH0e9/Cn?=
 =?iso-8859-1?Q?Z1APiW2pw97IDTfbvkkU0nKttqIgBEegBrmMSZup7+pIvh4fNgcGXejOea?=
 =?iso-8859-1?Q?APFZpY9hsXi5zp5Ca+4+C8TNyTH+WVXlMGmG4+u9A6XBrBUx26QhHw6P9i?=
 =?iso-8859-1?Q?8o/+OHwXL1sbArfV/OTlYC5NjOTafuCcgshYiMbqtPyxEKHZr6OWYSuIr6?=
 =?iso-8859-1?Q?mryJmkp+GvzCeO9HCTiqAyYqmOnIws/GTTUkVw/6uq16p50X1/K+6AeRlH?=
 =?iso-8859-1?Q?aVxEu0WnU1bn7OFmBBFacYdtvyiKgKhdfTS5BX6LEqm1AZiYjL40hQeeVw?=
 =?iso-8859-1?Q?e5WP4XQmh5NkY8NUy+Y1FnL4pEwhc6TDKAj6ZVrePp29MeQAdoVdy1a0Cf?=
 =?iso-8859-1?Q?HwlKOgUYbQuV5NBq7PKEaKfmb/QBixmnE13BF2pI5a/p1rStT4ul72WM6E?=
 =?iso-8859-1?Q?gJ8cuP+yXsu1Ygt5PmfSIZmZtQmthsnksQkaxlV/UXgejKHF+KDlb0TzqT?=
 =?iso-8859-1?Q?Sf9lb1iPXQC4LXG9sycS9dQ0qFR4b/b7J7RyVyWO6rNPjbP59BQlet3m0r?=
 =?iso-8859-1?Q?eckyrz2n25TV3wW0PciV0MqGFRQ50lViG0kQpsZ3z2RYzhFRDiJhDgKvjQ?=
 =?iso-8859-1?Q?G5oRTqJkSy397chKFW5ko5ZMUCHycxEKfG4ICJrPVFvjeBInEx+w196w?=
 =?iso-8859-1?Q?=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9337dfc4-2086-460b-8f15-08db3435e74f
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2023 11:23:52.3198
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mrId4o7Iw9T3VMr1xtrohyWy+M3JXuZjV+wod0y2MStypaCieYsQgeY4cfRpmDcoqKhIUP9Y8cFxPGGE+2mmfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8679
X-Spam-Status: No, score=0.2 required=5.0 tests=DKIM_INVALID,DKIM_SIGNED,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ferenc,

On Mon, Apr 03, 2023 at 01:18:07PM +0200, Ferenc Fejes wrote:
> Seems like Stephen merged Péter's manpages patch [1] but IMO your
> version [2] is a better overhaul of that, also Péter ACK-ed to go
> forward with that version. Looks like you rebased this work on the new
> manpages, you have any plan to submit the changes from [2] separately?
> Probably Stephen missed the whole discussion and about [2] and I'm
> admit that putting acked/reviewed into a mail inside the discussion
> might be misleading (probably thats show up for the original patch in
> patchwork). Sorry for making it complicated.
> [1]
> https://lore.kernel.org/netdev/167789641838.26474.2747633103367439718.git-patchwork-notify@kernel.org/
> 
> [2]
> https://lore.kernel.org/netdev/20230220161809.t2vj6daixio7uzbw@skbuf/

Yes, this is true. I still have the delta between Péter's merged version
and my suggested changes, but it needs to be broken up into a gazillion
smaller patches which I haven't done yet. I now also doubt the value of
some of those changes as standalone patches. I wanted to get the preemption
stuff over with first, and this is why I've submitted only what I have.
