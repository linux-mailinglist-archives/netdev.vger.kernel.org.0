Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1944E6C6C68
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 16:39:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231622AbjCWPjp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 11:39:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbjCWPjn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 11:39:43 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2054.outbound.protection.outlook.com [40.107.20.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F1A71E1EC
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 08:39:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WN+lAN4G7F0vrkZ610JwhBk3elJEtX9c0hCpEuXIRYq2/sAQG3f2BAXslNJ4x1wFciF5WKTo1GGnG0XvaBIqF/XXk2fLq/43scjdpNTkQGu5U3uslZmYvf/zl1RlekZ5riSXz8nzoIHqlCwef0o39JNk9U4JuPw/e5Q4cpGdKuhfNn/n6Vt3iN0xrEC28/h4TpU7fTQbj1Xol2ERFQPTF+vlGKQvtUOdJBbN71JQ7fSE8SycPUOx4vKowlO6uUExQTvMUki/REfQiyf43TBB+JzD+T6IfiTbMA76HqVmKM2y75dsn/L8/88H0NiuTEhmzuea4uqNzqgUJVulNNqWlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aeJ2ft/+czpIS+aYodC7qIBVjbIXf/1xZzUeKokEaSA=;
 b=kkp4MN1KANT/K1zW6hg3pI/ZGvmwGO6VUGk8/uQirU2Xhq1nrQBPmvcI2VwvnPeO0boM6FISrHXQ+7NJ9etzP+aKrZWrwPAdGIzy3FQ71UmJLvmB+K4IrX8h2+2e9QQ96kBOJJ0PwG8qeHDrFEHa2I9FEZeptXevRvMAURgBs3znhQpk1xoEyom9NaXU+mjmfNabONiiTCC7tdzRTcUoNR41P5/AfX/V2zN3btF+PZc+MKe3G0enEXi0yGXkq5VlwVCN0RJdBzGblbyeYJqHlv5moCL+CpS5tAPfhiJGS7jk0T0/KdEslkjQLGTwegdZrm34XFP612Nk27u2g0ITKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aeJ2ft/+czpIS+aYodC7qIBVjbIXf/1xZzUeKokEaSA=;
 b=d7+iRQZo7bcRMWndwWvDMdjkq/LvTcbyyNviGwDjevf2LSLFdiXyfb1sX0NuXvvR2C18W9+WyJ1Vz1rCbwOB5y377wZD17vnRpscixCwr17qgKehqnGAHKB2Ox/+EtCuFxCzYoaY1Cmw6Z4q9aSnKecbDjhVl7yQ2DqPDsg8isY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by PAXPR04MB9230.eurprd04.prod.outlook.com (2603:10a6:102:2bc::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Thu, 23 Mar
 2023 15:39:38 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8%7]) with mapi id 15.20.6178.038; Thu, 23 Mar 2023
 15:39:38 +0000
Date:   Thu, 23 Mar 2023 17:39:35 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Sean Anderson <sean.anderson@seco.com>
Cc:     Madalin Bucur <madalin.bucur@nxp.com>,
        Camelia Groza <camelia.groza@nxp.com>
Subject: Invalid wait context in qman_update_cgr()
Message-ID: <20230323153935.nofnjucqjqnz34ej@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: AM3PR05CA0140.eurprd05.prod.outlook.com
 (2603:10a6:207:3::18) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|PAXPR04MB9230:EE_
X-MS-Office365-Filtering-Correlation-Id: e7bf8073-91d1-4b2c-d96e-08db2bb4cff0
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 75HeIes8Bn6VWteX4KMrVETlBli8UVRkr++9AUUiwlLuF1xbRewT6U+NxsDM32MS85iV7qH62w6m/hKKYqm6uZChI6QZsawHN+5yxJ3vTt5dwqvyJY8clolDNOC6PdYfoMxEQfZQfB/XoX2e3tjP/NGomTexiNM8smMxNmkGIcGIi8wPTz6FF/eZkpzRduOwxREEJ50NRXx46UGRk9Ls9APbS0cV+m+87cz4St/OoPit4FSGZZbiaJCOS9Iw2YKEfaM+yUJjiTWWwsoR3Giod2WXaaRKPHbjwYjBd4NMcg3K7wfrS76tEYZjJKrqguSM8PQ07ZybdJpr2Te2cf7SA+67VA/FpxHl/ngiRtV8crx5wCalwOVSSTmY2D5nrF7TPg7+UJo8RXkncOZqNQ9uI1dAkE1nNGzbkfyjN3bLyTIZ1fIlV+dM2oICpb3NWXeeyt2SbawO7Nxdi40aHJDAPb2jaiEhbZpmGRSfqXQoPV21q0TVmCVCLiqeDV+8cUAdtPpkgsopb5Q/aDTNedCrzsc7PXsc2IAbCKuFRSbGQh4B13oLIurP9SnCMi2Km3A77Es6OCDxnE1LgHB/zBsLvsISRl2MaMYrh4RRf9l7ao9kMOkU4EyrwojUAfJjjp8ACfX5HhmxndubdM4BPzOtXw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(4636009)(366004)(346002)(376002)(136003)(396003)(39860400002)(451199018)(6916009)(66476007)(4326008)(66946007)(66556008)(8676002)(316002)(54906003)(8936002)(44832011)(5660300002)(41300700001)(6512007)(6506007)(1076003)(26005)(6666004)(186003)(9686003)(83380400001)(478600001)(6486002)(86362001)(33716001)(38100700002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WQ/HjyTh0doTH3w/VwaSr/CC2EuKqyCFcV48iWrvbxAaKfpNUMed+l+kZefb?=
 =?us-ascii?Q?yH3Sdy4yvn3PKS6kMgmUn3SqywiHr+8VyX4QXbsQyFCJ8fh8bUOQSuNA9BTe?=
 =?us-ascii?Q?dTntMHS841a7sPDtOYWalZQ/dMKiOGLaTPNWKIChOrgvJqiL8vsc5Y+/09W6?=
 =?us-ascii?Q?U1OsXhnbGOzpMKgIK7iMxdNKZz1a5LaHuGMZczbTMkEiE/JZaD/IdAVJzeiZ?=
 =?us-ascii?Q?9FTztpV+/BVt5L0zRMFLLsB+wF1Xhm/gaP5H0mXNKvgCtVATpatX6tsHOYJD?=
 =?us-ascii?Q?J9YLVOSeWymeUHYhGFwr1oAT/fw8lrAsR9dgE5pgGkbWxZKlPL6QGF4BEYAD?=
 =?us-ascii?Q?eRVt+c6btQ1TVvJ4Q27M9TYDmy4IRW6tGUMTDgMZFdvnTAblgtlCAMYkkJjq?=
 =?us-ascii?Q?iIdtpgrDCphQwPOgzHZUlQ97rfMJ90cxVPlrcxQYDtnz4t1Kp0Tyv8VSsNkm?=
 =?us-ascii?Q?z0XWCIPDXg3xOJTnD2HwDuPADscO7RZ9faqzmwSjvgwTtBbHLASnxT2yKQM+?=
 =?us-ascii?Q?yBn4PeTC0di8ORL14oA2No2hNdqXJZoi/2wfimPNpuUDwBgtdeDlk7ETxgAn?=
 =?us-ascii?Q?VJnC4s4whUyRdQddnlPXS1rZS8btNQAawBlzNnIj2sw5W4255feP/gUnZsCs?=
 =?us-ascii?Q?P7uP7UYL9oMUHMAO8zKP6CFzCWRiu2IVkboSezqlN6StmzmPfFQNBEIijtOH?=
 =?us-ascii?Q?glJftVMG9cNpzkZSottIMmMXvRbIHhTHCWC6RsQ708zxYgathWYg8QXC6Xa+?=
 =?us-ascii?Q?/XfDKHZF0UcKnB6Wu5yIO+jARTi+8Yeh4rr6V4KX9zpaqt+lPctch/9Tt+Q3?=
 =?us-ascii?Q?tt4OKNa/90T4pEZHPZhQkYWS+J8pieufYlMT3xnekY82CuJ+ZxIbiqYCOnDJ?=
 =?us-ascii?Q?+JlpvZWek8X4rOweWJ5u14CWqqyMsCi17pP3fUeDOzZZloFLx+skKqPhfKQI?=
 =?us-ascii?Q?WrKh7YO0l+T6/bNOO26T9M8ZCFcvj76neU7RgqYRG+Z6ErPCgxzpeywDEKgg?=
 =?us-ascii?Q?WoXPlP9VA2nleOewnNidlDEGe7HczuAzENVNJn96/cBctElP1nfNeuEnB1m4?=
 =?us-ascii?Q?dWsPwcXkDAX+vi6jGC4Q063VM1syIbeJNfKReTviAhREzwZY5ASvigjwLLUq?=
 =?us-ascii?Q?U1+M4TqTDbj47BZ30x6kgnqGX3KAIgCmlLWaeLnWIX/qdR94MR/Vf9I924jZ?=
 =?us-ascii?Q?9iP+myzSxRPqpXPLEwqUBD6up9930X4/mu7CAik1uoO/4T5V5floHGd/5O5j?=
 =?us-ascii?Q?Gfyf10KMtVWFJmCgZKEG/jM1wa3Qvb1PvdaDu5RtNYvHsVenNYFUWKIq38bk?=
 =?us-ascii?Q?n8NipBlxUZJFE1inV3pIrVIGGbbyGaljVv+ZXd/BTLuI51poGw+TsXzAq6qV?=
 =?us-ascii?Q?b8sIm7S/rKgVQ9H2PagAGZl+QXePu+Lvy9Mo26Zr4MeZMlQVdyY2v3ufwWAR?=
 =?us-ascii?Q?3chIEmb0Koz6CAtbXl2L6PlBYwk3TbDmoERWDYpiaC4E4kPI06POxqe9kEjk?=
 =?us-ascii?Q?4PDRrV766537e8s5CalXWa/U/OuX6GoZdSIXZNOikiCcg+8SQRs6c/CYBd0S?=
 =?us-ascii?Q?x+6km+lZhFgP7w6xhPjF2F9e9pJN/1g9qZC8ZvVR2CotoDDJiKaWVyCAauVE?=
 =?us-ascii?Q?sA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7bf8073-91d1-4b2c-d96e-08db2bb4cff0
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2023 15:39:38.7395
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kegpWYujLx27bjhsaGv/33vObNpZ4qn39H7GhNK2R1WOAiJ5RJe18aUWaL/BuVazt3uil0LWnJ5/xJuANnpTyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9230
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Since commit 914f8b228ede ("soc: fsl: qbman: Add CGR update function"),
I have started seeing the following stack trace on the NXP T1040RDB
board:

[   10.215392] =============================
[   10.219403] [ BUG: Invalid wait context ]
[   10.223413] 6.2.0-rc8-07010-ga9b9500ffaac-dirty #18 Not tainted
[   10.229338] -----------------------------
[   10.233347] swapper/0/0 is trying to lock:
[   10.237442] c0000000ff1cda20 (&portal->cgr_lock){+.+.}-{3:3}, at: .qman_update_cgr+0x40/0xb0
[   10.254270] other info that might help us debug this:
[   10.259320] context-{2:2}
[   10.259323] no locks held by swapper/0/0.
[   10.259327] stack backtrace:
[   10.259329] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 6.2.0-rc8-07010-ga9b9500ffaac-dirty #18
[   10.259336] Hardware name: fsl,T1040RDB e5500 0x80241021 CoreNet Generic
[   10.259341] Call Trace:
[   10.259344] [c000000002163280] [c0000000015263d0] .dump_stack_lvl+0x8c/0xd0
[   10.273180]  (unreliable)
[   10.288587] [c000000002163300] [c0000000000e1714] .__lock_acquire+0x24c4/0x2500
[   10.288598] [c000000002163450] [c0000000000e24cc] .lock_acquire+0x13c/0x410
[   10.288608] [c000000002163560] [c00000000156983c] ._raw_spin_lock_irqsave+0x6c/0x120
[   10.297764] [c0000000021635f0] [c000000000938990] .qman_update_cgr+0x40/0xb0
[   10.312820] [c000000002163680] [c000000000938a20] .qman_update_cgr_smp_call+0x20/0x40
[   10.312830] [c000000002163700] [c0000000001609c8] .__flush_smp_call_function_queue+0x118/0x3f0
[   10.324241] [c0000000021637a0] [c000000000023f04] .smp_ipi_demux_relaxed+0xb4/0xc0
[   10.324258] [c000000002163830] [c000000000020bf4] .doorbell_exception+0x114/0x410
[   10.338529] [c0000000021638d0] [c00000000001dde4] exc_0x280_common+0x110/0x114
[   10.338540] --- interrupt: 280 at .e500_idle+0x30/0x6c
[   10.338547] NIP:  c00000000001f104 LR: c00000000001f104 CTR: c00000000001f0d4
[   10.338552] REGS: c000000002163940 TRAP: 0280   Not tainted  (6.2.0-rc8-07010-ga9b9500ffaac-dirty)
[   10.338557] MSR:  0000000080029002
[   10.355087] <CE,EE,ME>  CR: 24042284  XER: 00000000
[   10.355102] IRQMASK: 0
[   10.355102] GPR00: 0000000000000000 c000000002163be0 c000000001c0a000 c00000000001f0f4
[   10.355102] GPR04: ffffffffffffffff
[   10.363650] c000000002187f50 0000000000000000 00000000fd236000
[   10.363650] GPR08: 0000000000000001 0000000000000001 0000000000000001 c000000002138f80
[   10.363650] GPR12:
[   10.373940] 0000000024042282 c000000002cf4000 000000007ff9382c 000000007fb2d3d0
[   10.373940] GPR16: 000000007ff9381c 0000000000000000 0000000008d77cf3 000000007ff190dc
[   10.373940] GPR20: 0000000000000001 000000007fb2d460 0000000000000000 000000007ffb5338
[   10.373940] GPR24: 000000007fb2d3d4 0000000000000003 0000000000080000 c000000002187ff8
[   10.373940] GPR28: 0000000000000001 c000000002187f50 0000000000000001 c000000002138f80
[   10.558780] NIP [c00000000001f104] .e500_idle+0x30/0x6c
[   10.564012] LR [c00000000001f104] .e500_idle+0x30/0x6c
[   10.569156] --- interrupt: 280
[   10.572210] [c000000002163be0] [c000000000008a54] .arch_cpu_idle+0x34/0xb0 (unreliable)
[   10.580234] [c000000002163c50] [c0000000015691d8] .default_idle_call+0x98/0xf8
[   10.587471] [c000000002163cc0] [c0000000000bda0c] .do_idle+0x13c/0x1e0
[   10.594014] [c000000002163d60] [c0000000000bde08] .cpu_startup_entry+0x28/0x30
[   10.601250] [c000000002163dd0] [c0000000000024f0] .rest_init+0x190/0x22c
[   10.607963] [c000000002163e60] [c000000001d57958] .arch_post_acpi_subsys_init+0x0/0x4
[   10.615809] [c000000002163ed0] [c000000001d58254] .start_kernel+0x8e4/0x934
[   10.622783] [c000000002163f90] [c000000000000a5c] start_here_common+0x1c/0x20

Do you have any clues what is wrong?

Thanks,
Vladimir
