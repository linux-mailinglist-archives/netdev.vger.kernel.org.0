Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D14A688899
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 21:54:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232541AbjBBUyp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 15:54:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232740AbjBBUyo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 15:54:44 -0500
Received: from EUR02-DB5-obe.outbound.protection.outlook.com (mail-db5eur02on2078.outbound.protection.outlook.com [40.107.249.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C65B7D6FC
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 12:54:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XG9Jr8a8e8q8/6DE+f011c5p+j7+tfRO6/m65E228id/zKtI4jpkwg6XfvDkskmkExdFJa1AWlURo/WkDK4SLcD5CgKsCBPfvQDbxpNNbOxBLRTVgQ2N5HAYyltCI8r5pT45gCgi0rkoiYOfJHM2M4f10TyuuKuACuxFTCXXYcsHs3wzDYXPG9ida76UPUJswxKNbWzDVuPYC3Pq71kUmjA+w8LFbh1D1OUztvlYtPlVrBCEXr7tHxmTuDI0X4EXgiEFt3yncSajxz4NHBhnkGlACKLCC/qP1yMIdiUakIc7ptnRj5w7u+9xb/VEBNqt6D9pGd/tBbhC2J12AuNV1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5L3K7Q+Vyr3mohZ/JBiIhTcokGRzBk9dPb8hXoekj2w=;
 b=ncuuF5lSkQPwjyPu5NGQAOLjhedxNj2k1vziSaJKgSsAXp9Ykqdr/44O/u/hTnZ83nF9uoBkdNmYqE1a9nncnlPXFsoC2AQe2NEzB6DwSLlIE9i5U1D1G+xbyaC6jYwDuNTtNb52x3kbL4b2nCAujowmE3Ugu03vYV1qagluwNTnf6U0amvCho3fcl6nteVRcXfO9slJ/L3I3xbDJ+InG14RQGdhZFzh9e8kwkx9KSYBVL1iCYxN5rzOwAHHseOdv1bwr2RAgAWREOOwUi7P8QSwC4kI/AzqZmfWeELYrBDUrLSkcbf7oYv9gaN0rF0wmDqUBP0GwJcaoaw6ukb3zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5L3K7Q+Vyr3mohZ/JBiIhTcokGRzBk9dPb8hXoekj2w=;
 b=U0ncC3aV+am6pI7rNHSo5xM1mRUfB9WvjYC3B2sREKsv9l1iVNAhgISREsFcF2VlB8ynrFqRE5KXEOmbktwtXb/97UNagosaMQ12nxpnmCG276YZ39iARZ6pgHV3LNrxcuAKRhK+xenT6bPG8CNx1qSCeFsGC1ndDLeczSsDf+Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM9PR04MB7506.eurprd04.prod.outlook.com (2603:10a6:20b:281::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.22; Thu, 2 Feb
 2023 20:54:39 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6064.027; Thu, 2 Feb 2023
 20:54:39 +0000
Date:   Thu, 2 Feb 2023 22:54:33 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
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
        Igor Russkikh <irusskikh@marvell.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Daniel Machon <daniel.machon@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Siddharth Vadapalli <s-vadapalli@ti.com>,
        Roger Quadros <rogerq@kernel.org>
Subject: Re: [PATCH v5 net-next 00/17] ENETC mqprio/taprio cleanup
Message-ID: <20230202205433.mm5r2bplaakcuzpj@skbuf>
References: <20230202003621.2679603-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230202003621.2679603-1-vladimir.oltean@nxp.com>
X-ClientProxiedBy: AM3PR05CA0085.eurprd05.prod.outlook.com
 (2603:10a6:207:1::11) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM9PR04MB7506:EE_
X-MS-Office365-Filtering-Correlation-Id: 08ba4d8f-b7d9-430e-2c1a-08db055fb30c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VyEazerGhScsngiPHdA99aviQbpiL6ENc5TxDwqvzL+TbSv+t8mG6oVNOOyL8ZxM13pw0JhmRSbde0v6nLzvrvzz0AAm0k45YXoDhtauKPNdRFZSMnzXIR64Bmse/35w1FtAdrYlL1uqqISdbzW1rwCZaGzOvJLaS72QJEUVsqE5KjTLL8ZwD9Yb23jAodFJ9isuxsma3UXRhTA27daSKMFnhZgxbFoaEmWZHgKVIe81feR88cYIh0SmgXqtZlkAUQKEPnutIJai5CKnsC0dFlsu6XIH89UAQeIk9Yyw6tEbVzy0bYoQwRRYb17Hhw8AvUvCmWEIBNcjpBQc0RsU8dWudbv0/G94M/zaTosKNWkTBmvtPtqM1mxlOi+4w9LCTsoafG/6kegsYmX8FE0pplIPf9IMX2Tw8EiDUL4BFiRCm3A281EP+RsuWXgNTDxXZb8t/6dU2VB8JAJAuW+JAUvSBdgYhnypCitS8f2rnltjGI3c0YX3SRiea5/0mwTVDPAOmL8ladGH1HarbADnZ29MbitfYt/wlmxecwNGeis7cP/f8p0hVexWU2IdJqsO8uLUtbYaddC1SAjmS4iowBbnpRWNi6T+9W6gZdu60cAzinap7xsX46bpn+eo7bRtbYuzge34rWvVGn2RxOZlkg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(7916004)(396003)(39860400002)(136003)(346002)(366004)(376002)(451199018)(8676002)(4326008)(316002)(8936002)(66556008)(6916009)(54906003)(38100700002)(66476007)(66946007)(86362001)(41300700001)(186003)(1076003)(6486002)(6506007)(9686003)(6666004)(6512007)(478600001)(5660300002)(44832011)(7416002)(26005)(33716001)(2906002)(4744005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0zhf547S+xQgI6zu2T2KzJl9Qm45Z/zfmbkXR8w2UYuaGjf7UWnVunKS9909?=
 =?us-ascii?Q?eviRykErfVXYyjWKLHlSx1PUXdYe+C9SmcTJmd7VCdkJG0fc/xK1k8/x705N?=
 =?us-ascii?Q?jVigKovaedx6Vr79YgsL+SMISDqPnnazIrHWHSKTwkmzWtzflApU1VISxSEw?=
 =?us-ascii?Q?rUh2Qugba4MJdL4Vm2aXJqERLi6OE/+T0m0DS6jh3JXxdUoC5Q1389RW52Eh?=
 =?us-ascii?Q?kDovL8nP9ff7hU6tZmdIluRdT5g9EnG8l4Dc5Lry9pLrJQG01/GC7nbpo9Db?=
 =?us-ascii?Q?HY62yAOXkwpjp4s2I6FsWJ2W46due5+o75tYr7d/lSsoGnyi84QvUVM9X+xj?=
 =?us-ascii?Q?sTNjAV/8lTiJF8gDIL2lDCGS7SYEq4opNhLHcbLg6EYN6tzHZqMKuutzO5H7?=
 =?us-ascii?Q?dyD8dOIfLeZ12r7+1oSHHsVEfCdgx3P26/0xrfSHb/NSde0/feb+MNAFdqli?=
 =?us-ascii?Q?TXt5uww+ZCgzKzk/ght7t0d3OoTnbbiCPDHu/kMWnkoVyVfzuiF5lOxtdHnJ?=
 =?us-ascii?Q?FPTVXLTORkRhFLYZdvMsgAhgTVfzLCkEPaJeMZpi8uJVQY52XFVxszP0GnD4?=
 =?us-ascii?Q?TatM3MweSht0rm4zyb8xzaogltlrDg0tkC3XYQs1TctfmMN5zMX72Gdtx9I+?=
 =?us-ascii?Q?Nfsn8rl9CKFm3r9fljNbrF6QrIN8g6OtAX7/HM5aVQzalxwKlUF2frMfPQG8?=
 =?us-ascii?Q?9Brx3vPxDiP7+AAnI9MrywJzanmoPw4OOWnIuvvF0cNw22agUwcv66XF6RrH?=
 =?us-ascii?Q?NvdR4B6kr9SsgUcPaI6RkASkLZuFpSb93LsV6JOLC9wZ3JN8TvvuuFRGTkUw?=
 =?us-ascii?Q?U4CuWWP0e2r5DsHKXksDIeg2Wi4BUrl5BqE2/+WqllMms908KFug0o1aRPkc?=
 =?us-ascii?Q?7ehb+yb72dXZfHrXwzhr0lZD52KWXxsI3mtIMvTasAfnrYeNacYFDSPLxvW/?=
 =?us-ascii?Q?Mbqq2QA+2fDPNpW36JryO1MhTQYsHJ4ctx8THG9a/J6CJYzvAczppWz1h+c6?=
 =?us-ascii?Q?h1C8woHzs8VF8i8hCisJH3W+uclQTy8xHmyxUjgzJuHnu3pkaek9QVo+jDDJ?=
 =?us-ascii?Q?Q/ApBMVKbDpIYIhh8udrdAx0KBadb48qhU21KEeN/IayfpEnnCZXVBKb2w/c?=
 =?us-ascii?Q?nODbaL61sjH93rfaaKpdAFz6+E0FYPhcIgtm/A3cbrJ5bS7fy3AtF2tMhTR1?=
 =?us-ascii?Q?yCxOWmO3wa3bz0o+5W7v5wJzitXJb5x91OiWnCml7nDP+/CK9WGU7XL/gh54?=
 =?us-ascii?Q?WO5cLOiUWwcIDPsapf4zDD2qWPM953Dz2R4RVT/glWLd8qmEAfu/p1lEdWAn?=
 =?us-ascii?Q?QmMW8tm8XwBntnEcX5wmyKMuqhTilRdCc1Vez1RG+cC3bURropCQwzYq+O3t?=
 =?us-ascii?Q?poptL4Ef2IzCOdjg5cFTUZHlwYiis3i5F9XbAKswPzTPq/w4HxLdFYExCIe2?=
 =?us-ascii?Q?NeBaTjCtAzvArIqrhsjQmH8Jquns6TinVUNxjuVT4lF5BRmVn9H9fmAUfZY6?=
 =?us-ascii?Q?tq5nzAIFhlj4B0eXVI7xP3yKCtecxf3u8n5jzR2Hz0G2uL4wO371teqaq+9S?=
 =?us-ascii?Q?DEAOIAJzPh5sLsdCtCj2bkjv72noaieL7QrXp0DVlJz9OVK4svCG6Va9PQiI?=
 =?us-ascii?Q?qA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08ba4d8f-b7d9-430e-2c1a-08db055fb30c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2023 20:54:39.1070
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zztA+Ss2N5b7luGoiMxMO9q4ytfdj4QfGVmeoBhFpO5e8jIXdfxWR4jPu5B6ukBulDOWqtDdrJd5MSPb1L8ttg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB7506
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 02, 2023 at 02:36:04AM +0200, Vladimir Oltean wrote:
> Please excuse the increased patch set size compared to v4's 15 patches,
> but Claudiu stirred up the pot :) when he pointed out that the mqprio
> TXQ validation procedure is still incorrect, so I had to fix that, and
> then do some consolidation work so that taprio doesn't duplicate
> mqprio's bugs. Compared to v4, 3 patches are new and 1 was dropped for now
> ("net/sched: taprio: mask off bits in gate mask that exceed number of TCs"),
> since there's not really much to gain from it. Since the previous patch
> set has largely been reviewed, I hope that a delta overview will help
> and make up for the large size.

Please mark this series in Patchwork as Changes Requested.
