Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 239DC69AC24
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 14:08:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbjBQNH7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 08:07:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbjBQNH5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 08:07:57 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2049.outbound.protection.outlook.com [40.107.8.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEAE86ABCE;
        Fri, 17 Feb 2023 05:07:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BYndy8mhm48rieHQA/0+LywTsBR9U1U+0TTTFGHcGYGFkhzP2zlHNgVO1VvMyFgqjmyk7VJkKrWlXEjS8AFy/D+CEEpohaMC1sSRsAGF5R73casiiG7k13O0cHttzi3kNCyyfct4NMVf6L3lDMd3Eyei5oUTBupjAFqpvIi2yC+vpifWqtifBQ9lzXUtrssVyuSIDo9Vi8cMkhH5ONfihbx+mHdepn4Sh47/HNe4wIw6ztnYqJQ16p6e4OIHpY5qxrm0WrW8tM8MYSavcAp1OEcqzg54Oxxf+PeWlUhWYz2uuLS0A7hGbWfDoEI/GL/2yJ3Th2vwaXa8b21v7qk/WQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xuu2dIADrg7e5h2BNiu1HOiIMt6pus5PTuSHQ9Uo5f8=;
 b=exy6couPv+Qcy+aq4RMsKecr+BNhkplOuq+m8cPPGu06bkT5TP3/KZG31P3b1KwP+K3oNoPpseoI9EYkTO52famIu44eLHSxvFwm02mN8DZREB7Wqs3V3IvtwfWFq6+y//5Bxg+BeWZZgIPQrGDiF3ONQJE0XsYZq0i0bj8ohdtFEbixoMkn4LdZBuH73tXPnzPQuolkFhwpjcKva8eIIwd14uQ44CGkYXTFVfonj5/BoykblIKSzrW3hI5+EjRKP7tpz78z1BLImiWF/rHqmyjaz/h7HkR6oJBqoj3SGjyh+bpev7TkwM0MjVx/CX9kU7ILZI4oU1Aorzd8ERhYEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xuu2dIADrg7e5h2BNiu1HOiIMt6pus5PTuSHQ9Uo5f8=;
 b=h8dTg2BQU2htiic1RzLnRtCM2EtPZ4UH7cv094z2OlqcyQzpt6xErEut/Wnq82BLauPlznQ7kdCLI8XrgMjT09cHsjlOv2KNOrld9dbn69Ed6xnSLUMm3NzaX5B4mupwmJ5IWC21uF6ps3v0xtWEEdmOVB9+oWjCxFSNuQ8hZlU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM7PR04MB7000.eurprd04.prod.outlook.com (2603:10a6:20b:104::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.12; Fri, 17 Feb
 2023 13:07:43 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.6086.026; Fri, 17 Feb 2023
 13:07:43 +0000
Date:   Fri, 17 Feb 2023 15:07:39 +0200
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
Message-ID: <20230217130739.flqby6ok3wh5mklw@skbuf>
References: <20220501112953.3298973-1-vladimir.oltean@nxp.com>
 <302dc1fb-18aa-1640-dfc7-6a3a7bc6d834@ericsson.com>
 <20220506120153.yfnnnwplumcilvoj@skbuf>
 <c2730450-1f2b-8cb9-d56c-6bb8a35f0267@ericsson.com>
 <20220526005021.l5motcuqdotkqngm@skbuf>
 <cd0303b16e0052a119392ed021d71980db63e076.camel@ericsson.com>
 <20220526093036.qtsounfawvzwbou2@skbuf>
 <009e968cc984b563c375cb5be1999486b05db626.camel@inf.elte.hu>
 <20230216155813.un3icarhi2h6aga2@skbuf>
 <1284d04958725d772750d6e3908301c8f8a379c1.camel@inf.elte.hu>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284d04958725d772750d6e3908301c8f8a379c1.camel@inf.elte.hu>
X-ClientProxiedBy: VE1PR03CA0047.eurprd03.prod.outlook.com
 (2603:10a6:803:118::36) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM7PR04MB7000:EE_
X-MS-Office365-Filtering-Correlation-Id: 134dd87e-76db-45a5-4aeb-08db10e7f492
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: m9jLWydDnZSYX0FAkUSVugsnS7tpFWxhT3PuwRqx2PHyDEalpxveg4ujSpbpO3qG2tveBknE/CFWRPQ+ghW3hAbDdYtPhFTl1yMBqamd6CWDFMbUiIJLGE01z7ACqJZV9vdYiMjmvijV8+TE4gPy9FgMBY31MXox4xVSWsJeNcXy7CBAjSdjpl6UX7cibFIBqwW1wFicayca531FgL7Jl5UNRmU9VAx83R03wwV9Rnj0/MV/9iVK2U537Xgh76qs2SJQZ+Fbs4HG2L8av68sTSF99FA4PPrcqLNSbb+kPc+ul/sMvxIS3P2hOY2mhDvtz+BHM61vBRT+0GnZGmxGtDhD9fuGWz30zDP2uy4zIMqVTVVHskGNkHPaGc5Q7HAhoIRYHe4gzvcC1ys1STVK8ZqK+cUr9dof0O8iFMAcFoPQ2dZjU1s8hI21rQckrNxkcltwPzKzx6noNgz9bIVegfPyxYbE9Ccs24TullfXDm1ZccrioD80FlTAKzjb3bCrGwRYlPClFcz9ftLz4nRluTxXOra6fvoQsFqXW6li1wmJoATHfsdxfoMhfVJuoldl4zZ1EwHsjUn8z7Qy4RB1eeGC+3D2byrkiFsvy9KYbhW6B4A5qNGimDtYxFLwuIs0lLbV6VvILhHylK/iQbp8Qw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(4636009)(366004)(39860400002)(396003)(376002)(346002)(136003)(451199018)(6486002)(478600001)(6666004)(83380400001)(86362001)(38100700002)(6512007)(8936002)(9686003)(26005)(186003)(33716001)(1076003)(6506007)(41300700001)(2906002)(5660300002)(7416002)(44832011)(6916009)(4326008)(66476007)(8676002)(316002)(66946007)(54906003)(296002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?b/j7Enlk9ClMLB7Nscf9YqmjK+neDdYpWNy++nMPKNStG818vxv9hIb6urlN?=
 =?us-ascii?Q?p84EniKAjwfqEsvaW/zWBm0LLdnfaX3CEC9C+ng6wUQ5eDEyxzT4Hdg5LIlV?=
 =?us-ascii?Q?dSpazt4cDxFLwjgFO7gButAAxecAVZvZF9hM11f7uod9SseNYGCRW49fJAZK?=
 =?us-ascii?Q?+MpyK0jVcmM4jwyt+2CZJiiAMwm4hgv1EjyPIh70mgG/6nefeXcTnaspTDnp?=
 =?us-ascii?Q?6KeRjuikUGWBOjUeA2wywfA8ZhrzD2q3BkdnlTzvg9Kx/Oly5FMju99bgN6j?=
 =?us-ascii?Q?Nt2+8e2k439iMpw1okPaK0uGRteWRorTQZdiFzLHK+ianoskl0vUCIKz7/uL?=
 =?us-ascii?Q?iPoJaUTE7LmnRMSqBmQ1AFJm2hnTKiZYv2bb03XG3sUES/vTDMT5d62EcfaX?=
 =?us-ascii?Q?ICz/iwkRNu9TShzTRCq1MwaAC5BoMuETU+zghDtBoov1MSeSInvQ2KQDllh5?=
 =?us-ascii?Q?g1HLpvDBKBT1DtR0RW2EIB+Ur06HejBTNAalg6Kjyg9IqA2mIu8VfbIDv/hy?=
 =?us-ascii?Q?sI7P4FAb+9Z8U42GJWSiT2dcFO3bFMzz3gknvpF53QcqptrQGeqIZ26Zoazn?=
 =?us-ascii?Q?BHnClAPX7W3C3SMUwezmDKFXOGo00eDbvPtCLdpHLZuG3wpenJrQHKlnapNA?=
 =?us-ascii?Q?ZpkFnxUoHptR3A/p0racmR8Kf+4lm6by1IkYlCBBfPsAmTCpGrc1wHwtc7hU?=
 =?us-ascii?Q?9rBvA7tt62Y0kZ6jBWbS6SH2oi+jT26/Td0xDL0a60HYih3goEsZirmc6+c1?=
 =?us-ascii?Q?diy89CxyUy8CK+FZJ712rusbzNTMKRN7SQeTtVlTGw3fUxnNLvZQK13DIdnz?=
 =?us-ascii?Q?VeoZ0GUtqseoJsRAITbM/1OK9WD+DN1kE1BT+nMSSqLtwRoQrF1RM92uyDTX?=
 =?us-ascii?Q?JnkvP/oan9ySt45Bks064crHw1a2Z18GcDSmDr/ChKGh/8jnZ4LP/3kGn20r?=
 =?us-ascii?Q?QfFKk2KVt8nFvZiI2IOTD9BZDgrZGNicgFTb8c3ab9ZJb7kHWF5c3mZ02DIK?=
 =?us-ascii?Q?WqEemfQFXSzMIM7rOyLGv3cQs4TpIgvEba1gZgQ/5Sv56GYdgHAvF/q6WBg8?=
 =?us-ascii?Q?q1b6hAHCrAJjHOapk0VmZmS4uTL7eDJ0cxHtNFTlkxMisXv/InxhRAAsjciJ?=
 =?us-ascii?Q?SfjbdMk2Th39541y3kk4NHARpS82wb2mm5bURJpA2UIemuWfkYHNep63+Gj1?=
 =?us-ascii?Q?IalAVFv8AbaLHqVNHLtT/sPnzwjiaQ2ErptMkeho74IZQr2+AgLjGg4iKgqQ?=
 =?us-ascii?Q?mLiaMJocj89LyviYhPXhUDY2e7k8UnioGsGuFLGa7E4MH8bINAmUfMHPLLyN?=
 =?us-ascii?Q?MIEjJQov3XOhezQoCnno3Ft6n5kBVQcVNnMUYLfBuCYj/rUYFtHhFOBwrT+E?=
 =?us-ascii?Q?ShCaz7q5cRzqXCRwxS0Waf3hMAHM+tFnxNVNt8K9WCHzXwzmrYOieHxOzZRs?=
 =?us-ascii?Q?Bp9+Tjsg3eIY6jFON8ZCBVr7P5WR43ivrW4Kh647n9Quks1eDX/+8PHnUxUZ?=
 =?us-ascii?Q?7P2zIApGxR7nt/tRPuw3oxtOX4Jc6d5S2I10DJtMh7F9CwoeZUpGsFp+jIsm?=
 =?us-ascii?Q?35GYbgFNPO8RSV9q0qDRUXlfKMhSruCk+/Y+N2yzvE57xHF8mNGbqCnnANkF?=
 =?us-ascii?Q?9g=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 134dd87e-76db-45a5-4aeb-08db10e7f492
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2023 13:07:43.2899
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4v33b1isHubOi/jkmJxEREqrgsyLkEEKj9zruk7EjK2l777LuzaZtpg2/P8VthHfbNdGbN6z5g337le/sGDmXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB7000
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ferenc,

On Fri, Feb 17, 2023 at 09:03:30AM +0100, Ferenc Fejes wrote:
> I agree, it takes time to guess what the intention behind the wording
> of the standard in some cases. I have the standard in front of me right
> now and its 2163 pages... Even if I grep to IPV, the context is
> overwhelmingly dense.
> 
(...)
> I'll try to ask around too, thanks for pointing this out. My best
> understanding from the IPV that the standard treat it as skb->priority.
> It defines IPV as a 32bit signed value, which clearly imply similar
> semantics as skb->priority, which can be much larger than the number of
> the queues or traffic classes.

What would you say if we made the software act_gate implementation
simply alter skb->priority, which would potentially affect more stuff
including the egress-qos-map of a VLAN device in the output path of the
skb? It would definitely put less pressure on the networking data
structures, at the price of leaving an exceedingly unlikely case
uncovered.

> Oh, alright. I continue to think about alternatives over introducing
> new members into sk_buff. It would be very nice to have proper act_gate
> IPV handling without hardware offload. Its great to see the support of
> frame preemption and PSFP support in more and more hardware but on the
> other hand it makes the lack of the proper software mode operation more
> and more awkward.

I'm not sure that cyclic queuing and forwarding done with software
forwarding is going to be that practical anyway?
