Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4962687D5C
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 13:32:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231364AbjBBMb6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 07:31:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230004AbjBBMb5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 07:31:57 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2052.outbound.protection.outlook.com [40.107.20.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8386DBFE
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 04:31:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QKCKMtEmmPzfhVq5sdHml+wBqihHJCndPKSIP5GkZvuNBWGJqUhvN/PZJgdW2g0/kHcuV3FR5G4ePHL2Yk2hHF1dVGs35USF3bQdWJnVj5piALcI4JFKmDYaCswqSNybi6hZDdJfHNLAaeD0458r+Vv4Ea4PpiCLFga82WImiSzvYm2psGJO97j8B7C81uGjlqsrUoGsZUAbjdsiReWNOf5NtiScZD028SvWf2pyJe6w8sO9636zA/xOrVGEhC4OoHgNZINOsDxtHZvAjEvwzrOSbDhL+btyJ0V5qWaOvGzN4FLonhXZ4r7XgLR58YriLbEqWzykTGOa0mHjfbmRTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UsPSwSIMoi+jb64lgH9Wwnl2bTEfKgmkGvIir39m42A=;
 b=OsHhIBjeB7+8cZjqj8nOwpHpMzReEXaeqzP4n9KsB689xNhz2iTzV6HUrzRKDuEStbWnj36ZTfrvPl3sGRDeGV6qjzwnAc8l5pNYukrWJzNVpPwxMA5BKzQ6WqQL5YMb8Xs3wJXvts1lUeV1bS5BN5bg8xmsPmehzM92Kr8/tt5ZJaZrUPXtmDkaG3oUlSr8j32/cYpmzcbbXdhpawIUtu1NgF7z4mWccLXCxZJx4qJcusDbnFt3SzXLcNOgfaVdnBsSjyiqgU0B3uy4Q0JP6Gpazgt5BT9SGQAwyR0Q+JxYkxZd6mC/5tCe1uOFLU1ya2KMwktkqyZbXwSFTJ8nqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UsPSwSIMoi+jb64lgH9Wwnl2bTEfKgmkGvIir39m42A=;
 b=layZsnn43mwwpcx5168IWe9xQXgZbMb5wS8jhClFpZGfpUSZUCau3aqlnnh6Mf4udzNAPxrjTfAQB0oTyJIWpKEp2gvXWJ4V4D1z44O2UQSd8AeNMBOYtT6WItqMrxNOq3ml6OTf0nPaQMr/9iQONkjBRYsOXg1N6Qy1Yr1cvuk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by PR3PR04MB7355.eurprd04.prod.outlook.com (2603:10a6:102:8f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.43; Thu, 2 Feb
 2023 12:31:51 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::4c1:95d7:30fc:d730]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::4c1:95d7:30fc:d730%4]) with mapi id 15.20.6064.025; Thu, 2 Feb 2023
 12:31:51 +0000
Date:   Thu, 2 Feb 2023 14:31:46 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Roger Quadros <rogerq@kernel.org>
Cc:     netdev@vger.kernel.org, Pekka Varis <p-varis@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Simon Horman <simon.horman@corigine.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Siddharth Vadapalli <s-vadapalli@ti.com>,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: Re: [PATCH v5 net-next 14/17] net/sched: taprio: only calculate gate
 mask per TXQ for igc, stmmac and tsnep
Message-ID: <20230202123146.paegzm3rwi3ithmy@skbuf>
References: <20230202003621.2679603-1-vladimir.oltean@nxp.com>
 <20230202003621.2679603-15-vladimir.oltean@nxp.com>
 <20230202003621.2679603-1-vladimir.oltean@nxp.com>
 <20230202003621.2679603-15-vladimir.oltean@nxp.com>
 <8fb9048b-059c-f965-8cfc-e5fd480481b8@kernel.org>
 <8fb9048b-059c-f965-8cfc-e5fd480481b8@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8fb9048b-059c-f965-8cfc-e5fd480481b8@kernel.org>
 <8fb9048b-059c-f965-8cfc-e5fd480481b8@kernel.org>
X-ClientProxiedBy: VI1PR0102CA0049.eurprd01.prod.exchangelabs.com
 (2603:10a6:803::26) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB5121:EE_|PR3PR04MB7355:EE_
X-MS-Office365-Filtering-Correlation-Id: 59c86701-be88-4b63-b648-08db051975de
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EoVaKTQPUW7w6B164xY3zHHZ/KYekc4ojbYL4BXRaCYNUceYB2GuIDE/jBIzwuzC8PyCHOV/LWwvHVPt4JIZN0gHVCz2ULntGBVrpWp5TwMmNh5kzUkzf6yCnWiNR4aRO3B/LzMxTJH8ZERP5ttnaTDUFmc73p0eK8bDzxwQqm5fze/DNC3ZeBw6SdVH6YKv/E7sXw5zuhio/nV96PWN/rDjL1CtCZz7ahNPOEyiLc15GttBR2gTfvE0EdTvDlGPljyf43suk1cdBoRkXN8xK/CZJ3B+OUUXr4x0o0H+i5xXw3+YzuYHnbJsGWHIuLwLbyT7oHoGKHXdPrgd059WF5CkGEoDIIJdoc4xcb8Gvd/Q3MnZXLBjqyi3J1xKVf9ouPbSezhyBlUDToBMsHvlOMd5+lCk0170zVsXFaitdE3V5g8zzybBeh9tvnJTRlI7H4xzmH/fYJ3wYFeb+Muc531QlVAdz4CHzz/dM0RDyOU0WUmDyHRY5/khBjWqyeSv9+TUv6/cMVF2BuzNQ+yD23bgfe+FZkYbY5W8jjUiWiNQsZIZtqn6zfgIlNGQN0lW3BI8rPHamWwBo3XjNphU8EU1N/jUy9DvBweRtlRw2BKXvlpd2HamZwTr2aD0MzzxFOe44oEmha6Ocvc17RZFo1ahv76o2n8jCz9ZtneE5WVRkklYUm992JN93PS08SGL
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(4636009)(39860400002)(376002)(366004)(346002)(396003)(136003)(451199018)(66946007)(6916009)(66476007)(66556008)(6486002)(8676002)(38100700002)(86362001)(4326008)(6666004)(83380400001)(966005)(186003)(26005)(6512007)(9686003)(1076003)(6506007)(41300700001)(8936002)(33716001)(5660300002)(54906003)(316002)(7416002)(478600001)(2906002)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wq3oWwT8/u48qsyNK+WIcj38LG5fbOa1cOL/rJjfUVZQxWvdq6yLWG9E7P8u?=
 =?us-ascii?Q?I/Lw4TtkKNoIdMzhWL7od4/yBMR9MdA2xysZKJ52kAnjvWsTeXUYytpBSSmU?=
 =?us-ascii?Q?TqSbxVbx7vuZL4Q9z2GS7QA4TZ8Z/Ceq1r/UA8RwbFIBZ8/0Sb1xZrsqQI6o?=
 =?us-ascii?Q?iGXqPhev2xITgnjf5oFadr78Z5b/tj5gBtyXUwEGo1Hq4MKqRxG/hXSUz8e5?=
 =?us-ascii?Q?r1PPMERYcaDoYzAQl1Dg20Vz3ldnqpvFXLomE0XzHIN0dt/LaNOMNombHSUW?=
 =?us-ascii?Q?hQtBiuILZIYq3H5S8ctYe5FNGHSlyH2s7So4jvrNkyzH03yaO6N1j0iXwYyK?=
 =?us-ascii?Q?UaHEzWTv2T2s5bt9kbqjtunktg49VX4TCAaw9laQIo6y3NSDKxekGxmYyj4V?=
 =?us-ascii?Q?NNNLgi8B1V2bcLbL1ggm2SBl4cLXRBhtHsswsay+0kHXuY262yJd4qmcJDp4?=
 =?us-ascii?Q?ScoJGXSPhxwN3wArRPP2R9IDLl4aUp+CEHwotGxMPOoMBzwMOYUshVYQ64OS?=
 =?us-ascii?Q?Nf9mg7uTvLo+DfkJo/Wp3dIFnrWFffmcafUkl9dtgF8r1diDt2J7JV1iw+uz?=
 =?us-ascii?Q?Ov4lrsTnZ1zCcRx2ZFSOzg06v6OgJwZnzX+D33k35Yi9gdPkqvO3WM5KJ4sH?=
 =?us-ascii?Q?OMW1M7HOVhyhReFSBYGy+cbZJW3T6fUGgAHcbWnezKEcqpGVcvr/13uvW/W1?=
 =?us-ascii?Q?EBRYaXkbh6AHrpwmsQAeQo8f7NCXLtVT2KYi4Rhar5c0XYcnBPlD/VH7yFz+?=
 =?us-ascii?Q?Aov4Tm004R/F5y1CaWy5rQF/CjHo3wjRQQ99WL+vNGSoEpndiKu1XJQkmFhA?=
 =?us-ascii?Q?ky2UuQsMnOo/RCtlTny0mRLfLCdOq1O7Kg3dUFu1Ctb5Crp0wnFD1stn+lUS?=
 =?us-ascii?Q?LARgmESCTcRYfGQG5BGfHUUADexk4LA3x8NwL/v9G20WnKztM/b2IAyLTyYp?=
 =?us-ascii?Q?sQ5yksAn6i1StX70mAG/JLGI6D6RU7IyefDyDv97tgJpzE1QJHpT3KZB00hO?=
 =?us-ascii?Q?chChly5fqqz1EH+fnuhWBUJ9NShn6kfpKrWd7JaePZQvnQxspSwIuTmDMUiT?=
 =?us-ascii?Q?SvKVih1k8EUhj86ybx7nH7GSpeKblG1/5oYI1Db6/roaBd7NK4fwOpgGTiqc?=
 =?us-ascii?Q?FuPXPET22H7eaCuDJtoKP3EphCfoLFfjZNx9ZBVWKxPhbsvBDzYOJxRBEQCm?=
 =?us-ascii?Q?/o43wXONyko7rslfXx1GImkfavZNPv/aoGJt2NhJpauP3DzRWVLZHRF4WEEl?=
 =?us-ascii?Q?nFSC4FzltfyotjSefAyJbVwYgYY+CYCBOlJDn58pG1ywv43Sb8gX+ckXZJJh?=
 =?us-ascii?Q?0DBoM50EYCkqmuXGI9U6MWffLG47TFM7CUrKu6K/nJE4kWAY+o6PncLjkSTX?=
 =?us-ascii?Q?yh5Ar5i/zpq/3S1hmRjmokUCF876rIbu9fEJv7DeagkW6fVGhSWwx3L0/6OU?=
 =?us-ascii?Q?ReT320D/KD4cbRTK5b5Vh7MRsb4Uzk1DFMeFmFdEjjm9czufARIBSqjbVtou?=
 =?us-ascii?Q?4beJqjUviQtoai3QMvaWZEIHdS2MGH2V/K7zd9jUi5nb61nkN+2owX9RYbQL?=
 =?us-ascii?Q?xwj2hQmFvtMzRsPnLRcbW03GXMxqeIYXRZab2bdXmwckEpGNHMFAKuXg//Md?=
 =?us-ascii?Q?ig=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59c86701-be88-4b63-b648-08db051975de
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2023 12:31:51.4939
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SMmrakY5/ymXv+JMz9R3KBBPnc1X5bn0uXz4LUGGgRvzJWOt6KDO3e5TCCBL5etWya9TsiPvjiZx9jjP82CdnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR04MB7355
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Roger,

On Thu, Feb 02, 2023 at 10:04:53AM +0200, Roger Quadros wrote:
> Here is some documentation for this driver with usage example
> https://software-dl.ti.com/processor-sdk-linux/esd/AM65X/08_02_00_02/exports/docs/linux/Foundational_Components/Kernel/Kernel_Drivers/Network/CPSW2g.html#enhancements-for-scheduled-traffic-est-offload
> 
> It looks like it is suggesting to create a TXQ for each TC?
> I'm not sure if this patch will break that usage example. 

It won't break that example, because there is only one TXQ per TC,
and the TXQ indices are exactly equal to the TC indices.

#Where num_tc is same as number of queues = 3, map, maps 16 priorities to one of 3 TCs, queues specify the
#Queue associated with each TC, TC0 - One queue @0, TC1 - One queue @1 and TC2 - One queue @2
tc qdisc replace dev eth0 parent root handle 100 taprio \
   num_tc 3 \
   map 0 0 1 2 0 0 0 0 0 0 0 0 0 0 0 0 \
   queues 1@0 1@1 1@2 \
   base-time 0000 \
   sched-entry S 4 125000 \
   sched-entry S 2 125000 \
   sched-entry S 1 250000 \
   flags 2

The question is if the driver works in fact with other queue configurations than that.
If it doesn't, then this patch set could serve as a good first step for
the driver to receive the mqprio queue configuration, and NACK invalid
TC:TXQ mappings.

> Here is explanation of fetch_allow register from TRM [1] 12.2.1.4.6.8.4 Enhanced Scheduled Traffic Fetch Values
> 
> "When a fetch allow bit is set, the corresponding priority is enabled to begin packet transmission on an
> allowed priority subject to rate limiting. The actual packet transmission on the wire may carry over into the
> next fetch count and is the reason for the wire clear time in the fetch zero allow.
> When a fetch allow bit is cleared, the corresponding priority is not enabled to transmit for the fetch count time."
> 
> I can try to do some tests and confirm if it still works in a few days.

If you prefer, I can respin the patch set, with am65-cpsw kept with a
gate mask per TXQ, and you can look into it when it's most convenient to you.
