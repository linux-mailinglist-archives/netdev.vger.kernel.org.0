Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B4ED69452A
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 13:04:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230473AbjBMMEB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 07:04:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231280AbjBMMDl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 07:03:41 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2042.outbound.protection.outlook.com [40.107.22.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B7B31A67E;
        Mon, 13 Feb 2023 04:03:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FpktIN7y8HUBgHVcXfTyeVP333qYf341O5bv/iMUiMHW7zDiwc1uwmcKJt+rqFbY5ZcwkXo14k+Uy0/1TgRGXs+ul6+tl6Q7KI3rJTWTkEK8Ae0NndGjF1GIZrhuybp+n1R1LBypojLeSyVx/LiIwZE2q/O0NMwkHz+MLyftohAMnt4Up2UxS0chSHnsmd5FJ8bygOI3NjhBj91OYzUDl8Klvqzgl+YHtA3lYw5vYAblkn3hoW2Yklnrbm0vDh5vPgorLetvm+Xk5yOrvGGDfo3cSVwJG3gvkzp1WWJP0xaB5q3NH8mUSgbZS0u4+GM1Zy4KOEbuibBwHGgkVS4e5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cqcF39LUUqboC8qjB53X+ucVKnz/7ZHbix4BC4/j20I=;
 b=awwCvfmWtQxpj0eFbpB1Rkw0xnQldKMcp32qmR/qJB51ec3DDTRG3/hDuiKMwTiuuphFWR01KcwqdetvgojwujH523Uar4RPFjmqjat8xnmSaByC75xrT0P/5cdblZauWjSMw41TEqP0QyLNk8sOvNyQwTcfFk5h7WGGzU5Dqrg/yvzTUycUiowzlmUrOUr+7V4lmRA6rYtGy1k/b0Y+zQcBza6xFzILakqp8NcA5GrdYE0hVS1vizAk+I88OpA7RvTSfQg3n7DM9kun/5aGlExOrRNL0jDaW3lJeYXQsFQ9BDxPmZeg6RIpRyD/6SMhsX0xxLZg3u/2u/xpzyRiCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cqcF39LUUqboC8qjB53X+ucVKnz/7ZHbix4BC4/j20I=;
 b=QLarAuB/KoUIJDOcwGCVLACLAfCRd7AH45RN9zoYNp4OIf+sH4Mautu0SUqNdeq943Z29lF/aFgAwi+Qd7eq9LxZiGji9LTjUfZ59+R/gVyidoWCXYywhP0Vo4+IlFUVaDXssSl6k60noVgjKTHo4GAzqtv95FHScuL1idYQc60=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM8PR04MB7841.eurprd04.prod.outlook.com (2603:10a6:20b:244::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Mon, 13 Feb
 2023 12:02:08 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.6086.023; Mon, 13 Feb 2023
 12:02:08 +0000
Date:   Mon, 13 Feb 2023 14:02:03 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Kubecek <mkubecek@suse.cz>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Rui Sousa <rui.sousa@nxp.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        UNGLinuxDriver@microchip.com, Petr Machata <petrm@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Aaron Conole <aconole@redhat.com>
Subject: Re: [RFC PATCH net-next] selftests: forwarding: add a test for MAC
 Merge layer
Message-ID: <20230213120203.7q36ntssetcrnwpa@skbuf>
References: <20230210221243.228932-1-vladimir.oltean@nxp.com>
 <871qmtvlkj.fsf@kurt>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871qmtvlkj.fsf@kurt>
X-ClientProxiedBy: BE0P281CA0006.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:a::16) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM8PR04MB7841:EE_
X-MS-Office365-Filtering-Correlation-Id: cab8a1db-311e-4a5b-346f-08db0dba2159
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GvixSS0rea3eYD/Zqo3Oz5sU3XVKr6P2nb9vEkGUV/zntNGmi7HYEGLWpASDshRLciBWAMBOr9c3tXPUB3ecIAxkKRHJcXXR564eGPk8BEJYomFeL93z5qL+8NBRB/vnHOp0r5Pd5qPJX5To6gCRQzGRodMEO4HAbOy+678QSAeMWcjXogOE9YaQ7Pu3DzKPbN6U/03DLaTV/aeM/U/m3nOKLiJ9HivGnR5QabLr90BKPCCaVWYZnx6ScMaDdoY2rN5UjUwlH84db/8Njt7KlCMutDwBIrfug9aoltWGttMW9gej8MlJgWVsJgLpIupoHb8a0amkeXsp1+oUPadBw2sfdFCyTWeE+1rO73tWYSmLJN4M1Vw814ClLG34lg3mYG4p1/ts6GwCqYzKPxW4pF7no2dUOKmOj2Pdr823DVEtGhmBTLwgZAo4RH/8bwUCyPv3Y4scgSDIFNwUhP/vml/MENpf1bUxDH3CUy+ZJiR3nbD9jkG9kQZsjEgr7LQNmnbuUh+6zmMd+D9ahw6pEfrUUSDJ31HQyQE6Bb0H8a9TgJUdiDgk5vcE5m8LwKm6keZGWC1MfpErfCEUnHstn8V8643ik7BaxrkOSMJq65BTCJ7zuYlEBKHuyq4QpQAkJQz0/n+PoRVTy7W62RU6JfLFQPyKYZwfKuDz5F2/mXE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(7916004)(136003)(376002)(346002)(396003)(39860400002)(366004)(451199018)(86362001)(38100700002)(33716001)(4326008)(8676002)(66946007)(66556008)(66476007)(41300700001)(316002)(54906003)(6916009)(7416002)(4744005)(8936002)(5660300002)(2906002)(44832011)(83380400001)(966005)(6486002)(478600001)(6666004)(6506007)(9686003)(26005)(186003)(6512007)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3/EXntOQVfpzCeGxtRBGJsIi2VCNjnetO4XxS27i/EibMQui1yT5DtCXELlQ?=
 =?us-ascii?Q?BZpiYd5x5vM9VJMjwypKC3WfuCvY0+OIT2wvd0EbMKxo4klMWlrqK4/RlHSz?=
 =?us-ascii?Q?lHYGoq5hL4FUvBsPFE9hwPwhOCAk0gE3sxvMi5EjDh3jgsNSiMDXWfieqtb9?=
 =?us-ascii?Q?dRB29MVD9O0C7ellENxuOlA7X63mUK/j247HGLYoGrzROug7rQX0R+0rExJp?=
 =?us-ascii?Q?rvucMqnN6yaYzLDWk/m3AlmzjfAGlp2xCabZmk55KMsqRZIdr07w6R887pbC?=
 =?us-ascii?Q?rhrz36M28iO+iS15dovQNfk6GrWGuEtPu9KplLIi0DIxp+AnrMqUGA8SkbmH?=
 =?us-ascii?Q?z9Jm8bjvn3sVumD4HbCctGH0zEYPy2OWR/CRwzxgO9EfYMq5UBJ3ezRlAEsE?=
 =?us-ascii?Q?f+Pk2NjoW90CjJDc+aiFU0nKPcdkHq5FjLka8luHhLLIe0PjUI9nvC6tyz3z?=
 =?us-ascii?Q?QzX+zQWrkFn1t5FZsmmEXUM9emUYrxYLtIXJn1h2M/EJ3nvCxhqRzhfK8Y6Z?=
 =?us-ascii?Q?hdU8aFJklNYsi64YMz1cYPsFmpwukhoa/SSL7O7kCWiQQ3E3WjHfmmH5GYSm?=
 =?us-ascii?Q?iHgWUG/cLbnzmIJ1naAcRCEzWqoZHwRaVxE/oDULJru/U2HfvDEmSpsabb/q?=
 =?us-ascii?Q?F3BqsyOnfj1NrZ25kA7D4AE+jvjjMt3cArDNr7/CEvmeM2aaoMZ8fxEh5GB4?=
 =?us-ascii?Q?61rh9wZCSDOAXrKKZricC5b/LJztpvjiArLXF2eUrjsEzMkhhBesBUuZXsQ2?=
 =?us-ascii?Q?PLghUj3AnuXVYdeLJF4vzCDueb7aNoPqGJryBhW3kQ2oBYhPlT7lg16TriSz?=
 =?us-ascii?Q?72gYM822W5kA6ZM6spn42fo9V/haZAlU2ep8ZES/crnV1bobn2AsDkUYIoKB?=
 =?us-ascii?Q?WJu2qKKOrKOiC3DVmWrF7AfuD5pLSuWiaTEXws+jkFwt0/zKPPA4n6TzaQXr?=
 =?us-ascii?Q?EflW7ttlS9FmcTSDGSqQsx5Z5Kh/ajI4VdiDwJ+D2nFUfKMA1g4V529qniQe?=
 =?us-ascii?Q?m1T+Om6q3jBkI7sh80jCCj/aL6h1lJcFE8Slco33brKC9ORif2ADkQN9xmZ8?=
 =?us-ascii?Q?tHCNSnvZglPHTebJgd5UHoFpGRxnJhTc5+BOeSjAigKBu8/ViRbXUSv5aR1x?=
 =?us-ascii?Q?9EcvS1gHZT3mOVL4Qa217aCkP/xaRNSZKkphwXW7OwIIL7kDJMY96qzwxFVC?=
 =?us-ascii?Q?AupkB3kfdH9pRWEJI6LbtiUUa9qlMg+rDVtRSgychzv4hv/OR6DI1z+KNVBb?=
 =?us-ascii?Q?sqGgIMsb4nmXuUArcnEuzSTxY9OJTxcRAyybBo44sWoCVbRkj+D7xMyBNLDm?=
 =?us-ascii?Q?cNzh2T3syWcqjmoTTMeQ6eVcGH50AAyNc+B40k8jqG9Mq0E7MZezoDCIuihH?=
 =?us-ascii?Q?sJp6/14Xw+F2HNRmVtkDDC9PkpcucLvKvYVdfTYdUye+HmNkHh5bG52QIyrs?=
 =?us-ascii?Q?u4u3gr49T6BPFwXOeGLPZRwtwEx/gVnq8FNhD8VMLDROJS44+MVYR/uRJjgQ?=
 =?us-ascii?Q?6p6XkPZRmMBK5d1wNsmvaGt5kVoCRk3lw1m4Zh/dxgRBNCGgO2M4k2NQjvp3?=
 =?us-ascii?Q?+sGeWTpd9bPaftw0OyJINyHjirMuKMTjOP2xntzEyGnE/0EnV7sY1SNI79JI?=
 =?us-ascii?Q?3Q=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cab8a1db-311e-4a5b-346f-08db0dba2159
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2023 12:02:07.9504
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mxGyRrW5OKu/eU+OnZ1E3CTfrcJwUZZX44K0xL74ZXvOJHXTWf+N69xEI+VR2CGoFXU6AwdWM9oKdz7Rogrg8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7841
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 13, 2023 at 12:42:04PM +0100, Kurt Kanzenbach wrote:
> Looks good to me. Is there any way to test this?

Only with driver level support implemented.

> I see mm support implemented for enetc and Felix.

Yes, those would be the Ethernet interfaces on the NXP LS1028A SoC.
That is all hardware I have access to.

> However, I only have access to Intel i225 NIC(s) which support frame
> preemption.

I suppose this patch set would need to be rebased to the current net-next
and adapted to the merged version of the ethtool API:
https://patchwork.kernel.org/project/netdevbpf/cover/20220520011538.1098888-1-vinicius.gomes@intel.com/
