Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57BE768D729
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 13:48:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231745AbjBGMsn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 07:48:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231733AbjBGMsi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 07:48:38 -0500
Received: from EUR02-VI1-obe.outbound.protection.outlook.com (mail-vi1eur02on2046.outbound.protection.outlook.com [40.107.241.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B87BF15565
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 04:48:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bFy7HhCFBLdkmrA9B0cbHRcO0W8F/Z/eJEoO4buBxXxmy+7awz81Xr0nkVOoEmMMAyGnCVmQuLOVON2brDmCVB37vpL9c7WD3KDzvwA4rWRWcUcrwmvor4osPJ74AkzJPRSIqA8NcSSkQSvDhwl2FloFHRl6gKTJfqTc0nBXLgk1XR9Cxr5lFsEnemeqbF6qz/F4VhvPkyZAbAnQRNGz4lW4wMIK69yxRXe33WK6qWEc81fpazDshw9J8p1qwU44jzg+9Z84MsrY54M7DQGpQV0c4pf3DlxxHWwjybWsPPW9AqMrncNHBcZa2qdXW0Lq3PhEXqtEMWt4pVma5BUDgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IJuZZGeSI90a9bdJDXDTvnMa6n3scKuocLvfg2HflKk=;
 b=CsjVKf813FVADB6eZUn/ydlw2PWpkQDBL93klDyMM56ufrftT+gXgqLjSL2PSfkNzMrVQPG1/4++tOqbhfq4RlXlCWdL/uGXbqF2swzN9PJNG7m5bh6gNgXdoL/8te3ZPAbsV/G9SLBzhs0wHVZI1vdSlTf86Z/khHCSa8ulzzLFYemZJZ7eDZXRVnEeMBg3SdGEDw2Yapua8TosRHS9bf1MLmgtqGfk0ViyVZDgOTz0cBD0mWlQ91C0QU8f2Pi6dQWI8qNWjEheOB/QAf3iPQz+aeygaqugeqxY3g9ptTIPZecs2E0aelQasPNcGHNOs0jlFFjTJ3hjnG+zabvqZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IJuZZGeSI90a9bdJDXDTvnMa6n3scKuocLvfg2HflKk=;
 b=lSpDIVVxZXsKGHF15HD7h5mYj5SZhqaLqa0pEIszIhDZ1hkqU6+EPv/kQl7FP9bZU5HdfjuFU4RPAdpaJELR+aZuz6mIRRWUX9UlSDMEu4eCaB3jq+Y+OFpO/BhAsQHtfZTj9KLNaqI4WphWFcv41DsQhkatsqhCds5+SnKtaZk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PA4PR04MB7568.eurprd04.prod.outlook.com (2603:10a6:102:f1::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.35; Tue, 7 Feb
 2023 12:48:32 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%5]) with mapi id 15.20.6064.034; Tue, 7 Feb 2023
 12:48:32 +0000
Date:   Tue, 7 Feb 2023 14:48:27 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     patchwork-bot+netdevbpf@kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, claudiu.manoil@nxp.com,
        vinicius.gomes@intel.com, kurt@linutronix.de, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        simon.horman@corigine.com, irusskikh@marvell.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        thomas.petazzoni@bootlin.com, saeedm@nvidia.com, leon@kernel.org,
        horatiu.vultur@microchip.com, lars.povlsen@microchip.com,
        Steen.Hegelund@microchip.com, daniel.machon@microchip.com,
        UNGLinuxDriver@microchip.com, gerhard@engleder-embedded.com,
        s-vadapalli@ti.com, rogerq@kernel.org
Subject: Re: [PATCH v6 net-next 00/13] ENETC mqprio/taprio cleanup
Message-ID: <20230207124827.xgh6h3upxcq7fx6k@skbuf>
References: <20230204135307.1036988-1-vladimir.oltean@nxp.com>
 <167567822122.32454.18057858947281179194.git-patchwork-notify@kernel.org>
 <529aba02-d31d-37c6-dc46-7a129b8f1b0b@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <529aba02-d31d-37c6-dc46-7a129b8f1b0b@intel.com>
X-ClientProxiedBy: AM8P251CA0005.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:21b::10) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PA4PR04MB7568:EE_
X-MS-Office365-Filtering-Correlation-Id: 01cdeca5-032c-4cb7-891a-08db09099e6a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FHrQ+m3KFf75oHzpXQi5LtHthEEkwFvkV5NoBEaj4PsbsXU0NdQZHh7GAi69ejuUAYF7u6/7TiBTrUh/grMulqiH6sQFOB4bOBX28TBpPovpOL4GkgZmRaowWNavW72oG5I24nv5gBanqxJxjOs4dF4xA+fUet9t8n6x7xS2BMAPA9GGypWrKHgHurfTFIiubeogb4ZPeg2UMJ1oSNEqoGfET1GtAy3UAkQEr7A1TBRxpDkUqcsm1G2r0cOm42hsp29wlocmMcRnyv6xz1bjJYUqQHDIPRGPl3iTRY49c7G17a8E9x4XQOQp7iU1fFsNHMusnFc/dqBaG7gLO3fJVse4qr6MymzP6n7oeAeQyr8LWr1+BGQ5CAtmzL4Ksi4HN/brW/WXy5Rlca74+F/gxyYRJdkTytw8dRNJwAp60bDmbvBD0EpE7aDVCG7LYl4/nR9Zm10cy5O8MCtPEEdkp47cSo01F4CnBe3oEz5VCr6zZ3rPTt5gPxmNg4eIfFgXxghhm3z9NF4XBtaDRorOLMePHGOJX1kXYKvyYbsJ+K9YLYin3oT2PGHtaL6ZNLmZrlXA35f59EOgxlD7RonR/Kj7pDWukIKVAECzQm2JlCvdPyZWaWE/X0jcupYXNoOl1u2Ace6cfhQ8/Bn7NNYd4tZIUxHXZhJYD2jFwD0MzeHhHul3w79nq91ECdBCULGf
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(4636009)(136003)(366004)(396003)(39860400002)(376002)(346002)(451199018)(33716001)(6916009)(44832011)(966005)(478600001)(6666004)(6486002)(6512007)(9686003)(26005)(1076003)(186003)(53546011)(6506007)(86362001)(66476007)(38100700002)(66946007)(5660300002)(66556008)(41300700001)(8936002)(316002)(2906002)(4744005)(7416002)(8676002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KnFVfSdluvqTVa/XYlkSRqOa0Gtf2dSkc5GrSuy5k5miUVcAg4gWKrbDKMMR?=
 =?us-ascii?Q?tUOhU1djQq5zfvs9qI3vg03DwzVmaSvnbui/rwCMhAqcVqlnIRQffMt8WySW?=
 =?us-ascii?Q?f8r9wmGtrR4GKYfYxpL3kSaqcaBjYp2yi4haSJ2L+sDVkmMzYhSvazA8xvig?=
 =?us-ascii?Q?1dY76//keqAPzthRBcRjIM+AwlYuQEXOKxJCgHRCDxB1EwlgKJqAUUildwUR?=
 =?us-ascii?Q?h0k9YU6lcG9k4+Q4n97TjBcBnskyQrZYSUMWXpsMFCddvEO8qwfzwpz6ypbZ?=
 =?us-ascii?Q?4PNiMuCQaDvH6HmC1ZSkbKB1GBahUPXAWHCrt3fyCG5P3vZQrobT3RwV3zXV?=
 =?us-ascii?Q?lKkJ2wgaFpam6Hijn7g59y7k/ymbxsuhfv7QjgmT+WC7Ab2JtcEBJqtEQKRs?=
 =?us-ascii?Q?OiIupV0D4JblzDRdrR0jt+yo6Hnr1p4xCw/KI5qag+2SskqboAU8NqgsfBSk?=
 =?us-ascii?Q?YDFR+AOpFbWoiBpeWJkBf3ZFsLUhLtMObfDmcppejuAQEwsbwRy7MU6Scc1E?=
 =?us-ascii?Q?rKzwI27BA+nlzgP3IA2zROgrtSeZ/Y4RYKGbdv7fQnD1IRD9p0hYfk7JoYQD?=
 =?us-ascii?Q?WN8SOlkdZ/sNVDi+0N82z6yTTaPv9Q+xzuV8N6qo96ISXYNAaI/cKKfLzPNR?=
 =?us-ascii?Q?9Hwjvp6c+gvSk9siI/p4OFZlgzmgaw06EjicFkvV74Be/UAX7rx5OXTXP8Ta?=
 =?us-ascii?Q?weOWYOHzDH2Zx/F85XUGmt1ZGGDCZMsBSLBaunRVGnPl4034z5OPLCTJgHR6?=
 =?us-ascii?Q?/pzgA0jQ/CQ7RYGcMwJXUfLe6DJHt5FwFJgtLv3m82UgZ5PrJAvCbXeuxhE1?=
 =?us-ascii?Q?w1n0ZKhpqoRbfeaUgwVAnTzJHvDLdLoAnL5RoAoPRet3TubtyEqsL9QmW0f4?=
 =?us-ascii?Q?O8Oztr6o5L1GqPnNTP0/Ba9duVyQoM3yMeGF4IQpRqENNC5SmcTXkHaCW+DO?=
 =?us-ascii?Q?8i2oFRPpYMTeBptKh9RK9Req7/Pf9qU9FcroCMonWVez2UooCbHDh0BQTOKp?=
 =?us-ascii?Q?NNv+vhAzRCYTvxaYUKUKQeq0jZMC0FR+U0tqDK+9qo6bXYiTPSsdAetECF8o?=
 =?us-ascii?Q?Ubg5qw7sekwmSejaVxTteAhb5n4gtqdI4XZYca8MJ5REg7XZTgEWGSSeBPGl?=
 =?us-ascii?Q?NnbzUJCjz7NNh3vaxjdCQ6Cok2aE7cl3oBXe7vJRdeMbzrI96LF2TI8F5KVz?=
 =?us-ascii?Q?OWC4fE9/Og+6TkxmmerNPomzVnH33u0fNmVxlort3/WigxSYow3402Po+8qH?=
 =?us-ascii?Q?ri0+CHdybReayQkXKcy5WFob3kLRh0v8KkhGzE7TQ+DopW0P1LRisfGsicLr?=
 =?us-ascii?Q?ScH5V568pb3GvPTRDUiNDM8tjFC4+agjxRp5QwOneltzI3xJ8ScBiAzV+dt9?=
 =?us-ascii?Q?sH1ZAudbciToZJ6Ornz0gAesnx1wn5u9+bpAsVrcbPMnxa1lhuU8Hf7cQbr5?=
 =?us-ascii?Q?C/5o1fuE4Xncb4moXONY9p8vaMViHBpixOxilMqAYLrqIZN6pzP3zLoGwpHg?=
 =?us-ascii?Q?BQ5JpiZY1RFzVgkHcsdeFl9FYcnDdF+D012yyOh18QEt7uGy+Ia9CYCo75ZT?=
 =?us-ascii?Q?8lhu3+YLqqrlP/oK/4O94os77F73TV27MrH4DHlvtBHCUhglPBYmzLTW+gTy?=
 =?us-ascii?Q?KQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01cdeca5-032c-4cb7-891a-08db09099e6a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2023 12:48:32.4725
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rOG0ZE6BA5/E0XcbbWZcDD5yTQ7DW1KxkHqmsJ2XtRob+DQLIr2YXeTu4CyrdkqxGxUKtX0rJAtln3k6zjeCSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7568
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 06, 2023 at 09:51:36AM -0800, Jacob Keller wrote:
> On 2/6/2023 2:10 AM, patchwork-bot+netdevbpf@kernel.org wrote:
> > Hello:
> > 
> > This series was applied to netdev/net-next.git (master)
> > by David S. Miller <davem@davemloft.net>:
> > 
> > On Sat,  4 Feb 2023 15:52:54 +0200 you wrote:
> >> v5->v6:
> >> - patches 01/17 - 04/17 from previous patch set were merged separately
> >> - small change to a comment in patch 05/13
> >> - bug fix to patch 07/13 where we introduced allow_overlapping_txqs but
> >>   we always set it to false, including for the txtime-assist mode that
> >>   it was intended for
> >> - add am65_cpsw to the list of drivers with gate mask per TXQ (10/13)
> >> v5 at:
> >> https://patchwork.kernel.org/project/netdevbpf/cover/20230202003621.2679603-1-vladimir.oltean@nxp.com/
> >>
> >> [...]
> 
> 
> A little late since it was already merged, but this version seems good
> to me!
> 
> Thanks!

Thanks. Don't worry, there's more coming :)
