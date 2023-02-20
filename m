Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EE1469C8E2
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 11:47:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230443AbjBTKrg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 05:47:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbjBTKre (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 05:47:34 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2048.outbound.protection.outlook.com [40.107.20.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EE7D93C7;
        Mon, 20 Feb 2023 02:47:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lvCbw8ceYrJSMGHmPWtiVu1udTPZuyGjTmP2S2QxeTiVDxJzhhWYUQISY9RpHBCs2GN5KjWk8B04ZGhEM/rbmzrODNP0efGlSQF85GHBpA0Bj5dTrJdLoYSKT6p8uNysqOdobIa2C+Air371CjdNkBxXotGSkVOFTjnHUMvwyUVqwJLOMWHF3+Fx0eD5fe4xs6fx22+8GcJ57z9daMICmcLLyfaSaanVPiokKWWeWyy3qhVXD50Yyj80XvJJ8HG1fhSlhWFtU73dk6GHG5+OFO3uXVR3KZXquU1dUDL3DIRGF+OnOSKF9ZhDHqOAOpx1EeEOcLa4N8PeMRzS6LOm+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lvyz78S2f6VeyKuLbYT6uvxr8LCLVMqn+3NoUfS+bro=;
 b=oWkf/5DXhpvg3Uda++rTZ+gDpRG34zRTFVLyyKws8kHMmW3i2QfAOZAdoz6pBCeGGz9Q/1/vmkcfxwEgOGXSE13rHR07/3h7vBQt/xYxkrOi4ncQjlXfUJlcLgfShCvdsfFbIntQwNioYV9UnefW7593R44nY87Bxy5pE56FhZjXnIBbj6pVadrisEMQo4ha37Cqcqk0ycxdDvakJDjAY9jB1DVu3P5fMRhIdhvdqUQqt0EdvbDDMRVJ9svDrdryCPwHvTDMX2FtkXpkhfEVYXMdIYwT+Vtz/GAkSLOgpnNf/vG+8k9crsC155S17niWh6qxgXFmRZb0vw5v/X145g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lvyz78S2f6VeyKuLbYT6uvxr8LCLVMqn+3NoUfS+bro=;
 b=GHIlbWUzATrt0PsjaTa2KdBg+7LFhmC5a+Sw/T5P6jRnhEbr2j79IZ5IAlXxd/ILjrizC++CNOdBu510rRiFV4CY8Gv3YkUxL0ctpMw638SeGw1+M8IkwW67BPCmyAOWnYD5b2SD7oml9HH4S8k0S1BWsFf60QVcyi8DPzpOfRM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB8785.eurprd04.prod.outlook.com (2603:10a6:20b:42c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.19; Mon, 20 Feb
 2023 10:47:30 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6111.019; Mon, 20 Feb 2023
 10:47:29 +0000
Date:   Mon, 20 Feb 2023 12:47:26 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Ferenc Fejes <ferenc.fejes@ericsson.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "amritha.nambiar@intel.com" <amritha.nambiar@intel.com>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "claudiu.manoil@nxp.com" <claudiu.manoil@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "xiaoliang.yang_1@nxp.com" <xiaoliang.yang_1@nxp.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "gerhard@engleder-embedded.com" <gerhard@engleder-embedded.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "kurt@linutronix.de" <kurt@linutronix.de>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>
Subject: Re: [PATCH net-next 08/12] net/sched: mqprio: add an extack message
 to mqprio_parse_opt()
Message-ID: <20230220104726.hx74vuwveeguepxc@skbuf>
References: <20230216232126.3402975-1-vladimir.oltean@nxp.com>
 <20230216232126.3402975-9-vladimir.oltean@nxp.com>
 <c60720e1a6a9768b063ba709ec536f0d89a31ff9.camel@ericsson.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c60720e1a6a9768b063ba709ec536f0d89a31ff9.camel@ericsson.com>
X-ClientProxiedBy: VI1PR04CA0105.eurprd04.prod.outlook.com
 (2603:10a6:803:64::40) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AS8PR04MB8785:EE_
X-MS-Office365-Filtering-Correlation-Id: 7517d0a3-f5e0-4b40-eb65-08db132fdcf9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cRW6gmeiEExvHb69U+ItcsY+FJqgMEjoEmVsPuJcaRkmdBna0gCCMhj8/M2z/UgeMvdWiwbaA1waoM7Jv2KzAZEd0DGs9ff1Ir9KpGeY9MnYXtDozhKoElAtT1Jh0CFZPgVArI+FB+u246SNQj0ZPsaDNZvlDQpuYuYUzEwRgqoUdoPvEQZ+WuM1P0CyzJqeOktDhY9AJv5bE+tBiKCibU3rUhVnQh/4O2GQsmkeKFjnqkBcZSKkWXIwSv1DZ1Qx3gHcvcrAw5/lB5ZwVA56C1WSPQgfLBfY/ni7mpRr7iygMpOgPh++anGwhBzwkL4jvYipQ1pGKoUN+psr40l24bUV143+GmnfKmafhw++pzY3/MgGIevX/xWHHiLoRnleJRYWC9YtCoJASa0DF7c6iNSN5bPll0+whwUH+s7y0BIcuzxtjwjR+gncgcnUzssSngItQ0G4wtvxCSeaTe9+7NKDh7lvDejDCPhzofSm7kZAr6Ekcb+5gh6KwpOJCnncBqmm7GciAgTQr9pwsIkUk9Iwr5vyd5m5wWwgPX3zQtDXcM/9aayebSRH/M7DGvlljvavR7nPIK1HCxIlNz6bE1gC4Dk6YwFNpl7tEQuh4cSC11ppaeW7JKanknq5kMtqq+UilwLukhV6TTX3BGL1TQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(7916004)(376002)(136003)(396003)(346002)(39860400002)(366004)(451199018)(26005)(6512007)(186003)(6486002)(6916009)(8676002)(66476007)(4326008)(7416002)(5660300002)(8936002)(66556008)(66946007)(9686003)(6506007)(6666004)(1076003)(478600001)(54906003)(41300700001)(316002)(33716001)(38100700002)(86362001)(44832011)(2906002)(558084003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nEYgUYgi4UpxqnjLJcNJNj4yXpPDb5RDzOppJ+wPI+OzZab88s3SpzBo7NBY?=
 =?us-ascii?Q?rCH1MHhbnW/YZxup6u9Ei3NTZG9Ywm3cRTWHOtsZfoRhM4rSAEdu+CpeMDb4?=
 =?us-ascii?Q?RQS7K/5wdg7nCfQC8LkotoFKTQVgQe8V/5nB8evYTe37Lkcf1w30c9XTqwVc?=
 =?us-ascii?Q?DvxERxNR5kXcSlA8l51sPApzPb1ok9N8lUMx0rZYnHVjYU8zYd7P+WIS4vvL?=
 =?us-ascii?Q?F53lXQuAclXN7UjZPqw+VtrPkiBGusLXf3e8o3gG8QAP5K0izdpyOhf2H8Ki?=
 =?us-ascii?Q?D9kiSfyvE4gEkJhyN+eHpteGLei4/8hI10hvqoTFw0TZXUp9n9ThXU62QQcs?=
 =?us-ascii?Q?TwaT9sFCq9KmY2CwfwDw3pfQpoVrXSg6AvqExFq4g5zjL4FlqfaixKCv+x3N?=
 =?us-ascii?Q?gaVFqlzXkKE0YxC2qa++Focm+UUEVts8VtVoCfiXLxbp1jTTbkgOUg2qEF2p?=
 =?us-ascii?Q?G6BJ+ORW8FjzQWnCSnz1R6k5SKEY0aShUFzd1qpqRQUNS3qnSEhcYW5P/JQo?=
 =?us-ascii?Q?QOd9Jftv3dU18SJOd7CLgcTK7WXS7S+xY4MBjOjh/wlbkqbtnnp2OnRRqGeJ?=
 =?us-ascii?Q?201c1uWt+LXvKgFOAjg1e4zI1+FF3rRsyNLGDVd11h9we2XWZBptuJpw8Avo?=
 =?us-ascii?Q?CYE9glxIonAPyMQkipXh8/fxViyAW1yMoA/PgnxxSCsw1pziTxA554pFd3Ym?=
 =?us-ascii?Q?+R2J59L59F17ggh2hLu7ylOMYefi9F6Tg1KxHYlngvm/8i8I3qDrzI066gnM?=
 =?us-ascii?Q?ErkB38NNzpyeBXmEW+RmEnOfdXF8ogGTnE1aDrzTyh2Bv00kyjVq5Me96W6x?=
 =?us-ascii?Q?4sWmrqaNqJwX8ClQx1+IooNW2cAeUFBvqH2nYoaGx5mH187yHppJDwkjz/Bl?=
 =?us-ascii?Q?xt52J+ifprdFrvYDVXfVIBssVQnKVzQoA0Jfe3fIJV/NMsy09SUboIponQ5g?=
 =?us-ascii?Q?TTjpK9Dq6Hx5HOnXh//8O+Is/P7p4iXcbaV7gOpK6FnNMtmlB1YR0/G8w3I/?=
 =?us-ascii?Q?lLP1AnvnXVlJCSVzKbyTN65XPvLGGjy8CE8OU9QmM1oO6nhwX9OpQtQOPzQ3?=
 =?us-ascii?Q?/TMrYR25gu0gro0IBYAAsOm+i7Z9DcK0RrrnmJsRYMWU91LbEcGQGZ0xi1FQ?=
 =?us-ascii?Q?TkGoq8VSs1OsweSrdFV+81NBEINLRKsSEvFEdwmARlHSZCNMU/5NJPhl3N8R?=
 =?us-ascii?Q?5OhMa41Skrr4CgcZZ9bwgPZCYYRX6NpkliznnHxriBkqWPrzzVciMpwqciHI?=
 =?us-ascii?Q?e2ASHdQ/a+e+ET6bWauRxTfUHWlXsUjBp3Ya4BrkJcsswdnw654xNracXB+y?=
 =?us-ascii?Q?eSQChwEhfRtzgX4zrf/CGzOINz0Sdc5uCHWLFn+lY3G+kFleBirSjj42ES8I?=
 =?us-ascii?Q?9e4R7m2QtXX7SMogJT9l/a3TGfWh/kPLHygWjNgsKZszN8QmH9TjtEs4xb2m?=
 =?us-ascii?Q?71Jrc2aG7p82y1g8GNAbf4WFYvRZzTXc7RXoEhVeLo1tp3uzrOritM6I2h4I?=
 =?us-ascii?Q?0NHwGdLr7FNSr+tvP8TojBN6C8mpEG+IsuxT1/DJzyQEcZ5YIVfnXPH92il6?=
 =?us-ascii?Q?G1F+K0mCOaCa4AOgfhNvGF85cSYYROGeskgupNTJmBEDdm05UGqzSHwpzdIM?=
 =?us-ascii?Q?EA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7517d0a3-f5e0-4b40-eb65-08db132fdcf9
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 10:47:29.7470
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R9FrWpbm/X26MLtIdLz7YEdBHSYEba4ASXufU08iGmttnAr/ag79SEtmE4kxvgzkCz7jYWEK1OXYnOaEGRxU0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8785
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

On Fri, Feb 17, 2023 at 07:24:07AM +0000, Ferenc Fejes wrote:
> Much better, great improvement!

Would appreciate a formal review/test tag on v2 :)
