Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD7F169C042
	for <lists+netdev@lfdr.de>; Sun, 19 Feb 2023 13:58:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbjBSM6a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Feb 2023 07:58:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbjBSM63 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Feb 2023 07:58:29 -0500
Received: from EUR02-DB5-obe.outbound.protection.outlook.com (mail-db5eur02on2076.outbound.protection.outlook.com [40.107.249.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DFD3CA25;
        Sun, 19 Feb 2023 04:58:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ck8kkqj7e6XPRrsMrLhgOozuNR4+/bB6zfGEIhc5Ibx/5QylLjvRS1+CI10+ASBGZkf+xjlQ+uIyrF67YAOm9mf2Vo/RpZZoHpS9pHQAUmzhb6QoWf5jSqFckM/svkBzqsGEybUHxo4o0UhCu6pwTglT47zZ59SZOEg5NCgiO5sUCk15WIcWRl/HNY9FErL00hBJTq309iOFww0fK5vWAoFrexNtEZui6Ipc7Ougolj9AIefUJrC/EAST49fFOey8EaVZ90tcKM03/UaJJ1puoFtwCaqycwanXdwSNdbG/p2Scv+88PQQKCZ70vuEvQ9NYGxI+v+llPY8tAGrRnMrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bszKJ6+d1or2c+iYjh9Kwf7DOgNdrt5qWBYTV3Vof1k=;
 b=N7DEbEgbKZKeJq1FNX8xeIWILByJtHlzGRyBykJ7itz1cgn9E7F3P4vHZqH/mABtAZOe9ySqLtcw3QFK0darV/IyN39u/1zPL3Iffej2xnfOpMjWpoyA+ibUcPUOPxGNmUEl90QIXebgl2gha57wkk4m8sFxpg5S7uuB9SCA2V5Mzilx5+sBAmFQJa6perwIJa0i7LWhU+MQp3nCCECFqq/nesBq0hVz+5mny/Q0e5/O0WZccU8/5t40z1Chlrl/85qqzi2Pk0EvB6n/hadIBstvcVzRXutUtj1nUmF/hRtmFVEHy2/3vdTlc0O37QRF9p7y7Cwz4GIzHyRkkpu4Mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bszKJ6+d1or2c+iYjh9Kwf7DOgNdrt5qWBYTV3Vof1k=;
 b=MBGM2BNINEvqzCb5+5D6vdJNVjzILOa+TFcqCj2loa1bJxg/3UiOVibYbbo+J8J0egyWptqZ9ZWamp57ATY/pPVWnrWDlfcFDtFMA/jjRIvZy+K6l1pu1x2epmH3BdjtroNfnT+CLG847DhLr4kX4x57usAaB/KZhieXGFsVUz4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM9PR04MB8588.eurprd04.prod.outlook.com (2603:10a6:20b:43b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.19; Sun, 19 Feb
 2023 12:58:24 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6111.018; Sun, 19 Feb 2023
 12:58:24 +0000
Date:   Sun, 19 Feb 2023 14:58:20 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Ferenc Fejes <fejes@inf.elte.hu>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Amritha Nambiar <amritha.nambiar@intel.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        linux-kernel@vger.kernel.org,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>
Subject: Re: [PATCH net-next 00/12] Add tc-mqprio and tc-taprio support for
 preemptible traffic classes
Message-ID: <20230219125820.mw3uchmqr4bvohle@skbuf>
References: <20230216232126.3402975-1-vladimir.oltean@nxp.com>
 <20230218152021.puhz7m26uu2lzved@skbuf>
 <dd782435586a73ada32c099150c274c79e1c3003.camel@inf.elte.hu>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dd782435586a73ada32c099150c274c79e1c3003.camel@inf.elte.hu>
X-ClientProxiedBy: VI1PR09CA0163.eurprd09.prod.outlook.com
 (2603:10a6:800:120::17) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM9PR04MB8588:EE_
X-MS-Office365-Filtering-Correlation-Id: 1df90fb5-eacd-469e-533e-08db1278fc64
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 55tUI4Zj31AQG9d4OXsqgKOugSyg6COC2nA7bJRKg0OzsiiH+2BxkH/Vg+NAbZWgaInpPSP3Cvb7XaSksamlgJqnhWoqtFf4GI74/AO7HngNjF4ywkI24qvcoZTnxCc+LK7nfifRDg30qjUY9nDr1ciXVD6RArOp1Chb3oQuOBBV4A7GbhrA7QEJlgThUxyxfYQTGOoIGiUbAGD5x46X7TQtAI5TBPyWckI/6Qc2CAmVS239OCO4p78/NpBzQyFI+Sc9RaFC94v9YsLMDD29XEfvQjTmcI4yiZJFy0KIiLeAa3EKZBl5mXSw8VpYk8Ru7twUho1NWkcvbYAR32tN4IoOj73PL3kIGiDYWljtuQSypioWT9p/EKsLB4RSRP04fso22/A9H1ga4cWldkiXGbshq+iKnMB5xk9oYNG72KseXRq1zmg/FXdakP5053GfY7FQzZQsD4fHrONSYLlkIC6LipP/AzHV+bwM/qQ9PpuqrMNgy6OtDet1zXlJ8SoywlpOPEWtyK464xCb6uwgo+LHDarHP+7sBrHqFd/FN0JhnkbMSsvvKsE7dd0KJIv889BdxSrsrIVG0n57WONudayy0jTSiwQ1cAgadyiQZAxfdvEPG2fTeV9lcIKyCuDobagptsVc9UnO/JQ4ohQXaw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(7916004)(136003)(366004)(346002)(376002)(39860400002)(396003)(451199018)(44832011)(2906002)(83380400001)(38100700002)(86362001)(66946007)(66476007)(8676002)(296002)(316002)(54906003)(6916009)(66556008)(8936002)(7416002)(5660300002)(4326008)(41300700001)(6666004)(6506007)(26005)(6512007)(9686003)(186003)(478600001)(6486002)(1076003)(33716001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ddwJDTHtZNQhGwVZXMQtIcW0zPIfmq3uNBJmx3Y6I4tCbJot7SY897/9opKI?=
 =?us-ascii?Q?Yjw58Fk7UhRqOfJj+gTKA9gvrCpBg39/8ifwAt72QAqBp3SkiL+/Sp/izgCg?=
 =?us-ascii?Q?B060ITYnyofb7EAGTe27hrquAJr/hRcAlxQbteiO92vVZDR+nO5ir2Mpmn5p?=
 =?us-ascii?Q?SARq295EMRTAL/vxV3HuacRH2ORwUsplBFU6EB4naasnf0SudtPHM9wz+hMs?=
 =?us-ascii?Q?4pRlk1lzAYIzMHeugbFegdVk0gQVvHEPT65Wy3Q02IatsPrOuIIXbXBz1AYu?=
 =?us-ascii?Q?cYmbhiEYlmli6MUzk0k82JdEPtdZHNqnKqpGWytX0Z7/2eHF2/TuvVldyH2C?=
 =?us-ascii?Q?FkMQWsXNlqqT5PyLbVaeST66kRzplALcpPPZ+HaMAduXQTsRhneX7H7sNVlJ?=
 =?us-ascii?Q?EQY5QVxDsyXt4GA/uNkWwuOvJP+tszP7BFqAOMyVRXlysxUKDU4ehQtVG71b?=
 =?us-ascii?Q?n6kVpJ2sazXm0T8PHe5/CHMqPuzlKsvBCmT8KDJUCjzRZLvD0/YKAg7i9um3?=
 =?us-ascii?Q?hwwthuSaAabjCgbAuD9C0wvRvwDHOwIICQGwutu5L7GgXP4lBieQOixx18Cd?=
 =?us-ascii?Q?hebrxySpmZ9keaTnXZOx5qUMuXHa8Huy3UFo+fKBfw/aYnm1JA+7fTzZdBfy?=
 =?us-ascii?Q?FHKuIe9gu2lV/OltIElrkyroFfW1A3Jz3RwA3cYZ2a+LTzfK+mCuLRl/8BzR?=
 =?us-ascii?Q?ssTF19Umse4cnYSEHAHibX00Z1BMjY60ubrYiBo2KwKMniOCpqIlxbux0kiS?=
 =?us-ascii?Q?3uSgpLj2qWst3dPH2MkaiN3l51mK+gYKdIjiTWogb7ELiA7HuGEYS3IlRRa2?=
 =?us-ascii?Q?l/Yv5185ecONwH6accvLiCETSbBptBGA5jmf6HCZJQwOt4LB5lS76yttNZwd?=
 =?us-ascii?Q?E/JdgrW/4h9yXyzV+CF38+QTeSp9y+6KmFPUmwvHIOCpEbxZmnbzYYxhxmgt?=
 =?us-ascii?Q?cFeZmo30EodKmiaUJVyRbgvbP1UTudEO+kPp8f66okTWXNjJH+i1O5GB1v6o?=
 =?us-ascii?Q?GBV04wY29J0vRMTP6Y02SOITbdOlk2jSAGWRxNe9uPwTeb9zlVzxFoPtEWg/?=
 =?us-ascii?Q?blOW4i/iYiYi4crGuoXGdwbqHEvOyi7Y5uu613CPqmHwiTDMXCYbQO/r5n5p?=
 =?us-ascii?Q?K4jnqjJB7T03PUNa3pClnV1S9sa55Bp9Knla7P5LQlBQtXFeleGyckng907v?=
 =?us-ascii?Q?15N+jDIqluy/HsNJQ2fByLinYTNIPbjQ8IG9JcmE0oomeF+xFPLdjEHWg5Z8?=
 =?us-ascii?Q?kzZdbIZsda5G/3gbf3VPwb+8Aj2Q5n04sldwF4ub81nsyErufD1kAdMhpnVy?=
 =?us-ascii?Q?wJbSQ/8pl7A28Cf/JUh0zKchuVZTytFZwyEGJLFSo32m/eCKWHbkuvb2gXjG?=
 =?us-ascii?Q?ff9Jukk3HxNXZIBTmI2S3iPxPFgNGG8fFtwrV1mXljV/CAlYHEDs3Uya8/vI?=
 =?us-ascii?Q?ObtyGQQvc3NcH38a9O5eXVk3veu4qzgMafGnZgfHk3YG+OG8tGiqchNIfLHj?=
 =?us-ascii?Q?oNDYXm5k2vtoJ3IW6VZIdVKf56CyD6EMGa3FtALZUvmn77cePAmHdU1DV/GI?=
 =?us-ascii?Q?sH/IsGwKDbP5vO9D1Wp/MfOlc8bWiUtq89M+rZRjQU2L3UT+pJIlav3Zgnqf?=
 =?us-ascii?Q?LQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1df90fb5-eacd-469e-533e-08db1278fc64
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2023 12:58:24.6303
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RMTcHRgJwX9Fw4+zMRuXhs+ohuonmwk07VOhz79tAsg4HJ53EHUmbXMqMmDhopTkUjvvRPI0hq1Uf++zFjBZFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8588
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

On Sun, Feb 19, 2023 at 10:47:31AM +0100, Ferenc Fejes wrote:
> Do you have the iproute2 part? Sorry if I missed it, but it would be
> nice to see how is that UAPI exposed for the config tools. Is there any
> new parameter for mqprio/taprio?

I haven't posted the iproute2 part (yet). For those familiar with my
recent development, FP is a per-traffic-class netlink attribute just
like queueMaxSDU from tc-taprio. That was exposed in iproute2 as an
array of values, one per tc.

What I have in my tree would allow something like this:

tc qdisc replace dev $swp1 root stab overhead 20 taprio \
	num_tc 8 \
	map 0 1 2 3 4 5 6 7 \
	queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 \
	base-time 0 \
	sched-entry S 0x7e 900000 \
	sched-entry S 0x82 100000 \
	max-sdu 0 0 0 0 0 0 0 200 \
	fp P E E E E E E E \   # this is new (one entry per tc)
	flags 0x2

tc qdisc replace dev $swp1 root mqprio \
	num_tc 8 \
	map 0 1 2 3 4 5 6 7 \
	queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 \
	fp P E E E E E E E \   # this is new (one entry per tc)
	hw 1

of course the exact syntax is a potential matter of debate on its own,
and does not really matter for the purpose of defining the kernel UAPI,
which is why I wanted to keep discussions separate.

For hardware which understands preemptible queues rather than traffic
classes, how many queues are preemptible, and what are their offsets,
will be deduced by translating the "queues" argument.

For hardware which understands preemptible priorities rather than
traffic classes, which priorities are preemptible will be deduced by
translating the "map" argument.

The traffic class is the kernel entity which has the preemptible
priority in my proposed UAPI because this is what my analysis of the
standard has deduced that the preemptible quality is fundamentally
attached to.

Considering that the UAPI for FP is a topic that has been discussed to
death at least since August without any really new input since then, I'm
going to submit v2 later today, and the iproute2 patch set afterwards
(still need to write man page entries for that).
