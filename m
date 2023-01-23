Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EE37677A15
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 12:24:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231716AbjAWLY2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 06:24:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231492AbjAWLY0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 06:24:26 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2043.outbound.protection.outlook.com [40.107.20.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3839234D1
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 03:24:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WZ+FKgeuLaHbhC1RoQrcbLZCvISbAV/KQ+DqCTWJiX4GSagfTbruN8D52FTmSVc43VQQLZ8Ad7AvbHWWZ1iDDCw/j9+pF1YRXpks69HAFhRZ9TdRdnXGsjeg2sZ1l8rR8J5mdF22iZVggKRkFXSe2ka1oEQ3JYni5fHD8VXyrt46FELquuGv/qPcn2DqEZpCNjO/IKcrWDXfCdLmicdW0X+ewejRJLFvcl3m6lMXJd4kWxF1KUFVTKYqb6OqhdZ7qyAkfezX+G9ymkyAwTLcp5NoTofwQ0KdVFxn4kVP0R9mk98YgryBhKWeE39mTD8IGOrmB7tmFvfomcooGeZAKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iPY9z9zzMkQXYN+b1xHE853UfJkvfm6U49jxzpFc3LI=;
 b=NLMpZymnwGBVgWGho7IpiSBCBi7q0A9aqNuhASWlP0OXHhL8KWgTrz1Cj7uM84RMrrOl88EIOa6nHuaaNnQgN16QXJkDvbUyAneRo6k97uguEMsGw9cwjKOC/QSyxptjafWbS+hMjCtCWTSmgTj/O/j9ahbrPPawPK5cNb0OjCOQzf4EHv6yAo/gB7TV6vQ1hmvbY7Fw/T+6MVCJabcD1ptTtQBOtJAM6cuDLJ30WWZwRlohgktJHrDreT3MJFfR6uQR5wUZDoVBGUs61SaibFv13Y9FCHcgPsjfo8VlgU94HkopzpoBXsHCNVvN4Sybj49Lzl/tIQYmRX7Hyt3m/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iPY9z9zzMkQXYN+b1xHE853UfJkvfm6U49jxzpFc3LI=;
 b=VCRVVPbfdZHkkeSKzLe13WvGLwNmB9L3WVv4/+tc537IwVgOYuU29lYMlxlXgmZfMmaEaVUFdM+RFjXWbjBJKTkdyQYH93BkndbBP+HXU7rVxd9ExNtzp3uXJTMeR6Y3O1cMWEqvVIhduMiPtMgBWlauBtp/iX7sq1Gf0+58yzo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB7845.eurprd04.prod.outlook.com (2603:10a6:20b:2a7::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Mon, 23 Jan
 2023 11:24:15 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6002.033; Mon, 23 Jan 2023
 11:24:15 +0000
Date:   Mon, 23 Jan 2023 13:24:11 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Subject: Re: [PATCH net-next 3/6] net: enetc: add definition for offset
 between eMAC and pMAC regs
Message-ID: <20230123112411.ofw6cx3qv6uh4txi@skbuf>
References: <20230119160431.295833-1-vladimir.oltean@nxp.com>
 <20230119160431.295833-4-vladimir.oltean@nxp.com>
 <Y81kbbO+X21uVFMb@corigine.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y81kbbO+X21uVFMb@corigine.com>
X-ClientProxiedBy: BE1P281CA0262.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:86::16) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AS8PR04MB7845:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c31ac67-db72-4daf-12ff-08dafd345c15
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b7jW6kml+eTIjYhenILnAs+p2lgccLI7OpMXLCN+fxzb7WXZvkirH5H/PAM4WnP47Fz2FWcIjfH3+erzMbjRGnofw47JbzTjO1tUMTOO3AQeGAjuartuaFYoIp78PvrRXa01Br5rU1HOA4jFZ+at2+2xZAcJmVoK6LzeU9MOM2NI26dQ7LhgML15sPvbTf4fpMlPzFJhHgQI5cbPQqvf4ehEVp9z2Qaz6GSairJcG1LFURpxyzdoRml3ZTU589M/tW/Ha9BWYF+TzOvmCFBeDpdXsjmspuxYa/6I5zQ/N1j44Cgn8eb1DBf41Dm2gX0nVArdQ/0nPgqewt+2dr7QMRnR3cHTTawQOzJljuSdCWUAgSKx8AshpymawKONXRvmYI+18na2tQT/hlU5HcrBUXOaQ1+635jFcv3/0OYpE6jcxIH++e1KfaKZwh2j6SJabhIDIQoqrTsqbeiTbff5AcQNqwQlulyprRH7NKvxKoMlemWATFVf6ddiTyL8X9l/hs4W6EHqg3rsWRor5vdhSJxNksaolo2efOq+XoGapSD26wvIf7mp6ChrvzYmu5mP6sD2vIX4I5c+hlsSPZWfFZ37ZWGqBnJ40Dm06WNVu9GUN8A/OQF5BaqTVRv7qb6kN6YGakZoPxZt0pX0e2d+3Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(396003)(39860400002)(366004)(346002)(376002)(136003)(451199015)(38100700002)(86362001)(41300700001)(44832011)(2906002)(4326008)(5660300002)(8936002)(33716001)(6916009)(8676002)(26005)(9686003)(6506007)(186003)(6512007)(6666004)(66476007)(316002)(1076003)(66946007)(54906003)(66556008)(478600001)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1/oLLrQegxXAJRO9iSrXhh82GoBSWq6BMuyrnS9xu9n+3GftZj4pkWjLe0Lj?=
 =?us-ascii?Q?e1TUUl9SqMffC/LQ9eafAeb2ohkhOPAmF6oqDiVD8FquHO03gSdVphVIEchB?=
 =?us-ascii?Q?9LtHu9GCFe24e9Uzj6NbPXxinisdODhP+GaTer05llViwIg2fWoTOFTQ+vqn?=
 =?us-ascii?Q?pET02DG4MVyyLSv0bWQ3MS+tEobhCsekmfTbZog1w/mYfXR4cZ7cVd/ToG9z?=
 =?us-ascii?Q?qkzq68aYvS501B3ij3J8aA9r1BrmfR58NKhGX7qdvkj+sejwDNTKhojOetcU?=
 =?us-ascii?Q?70EGYnzYWJK1e+t2toXhhEoDlQl8ukCd/+TBu/jA4Anj2VeN0KbOTRaJycBE?=
 =?us-ascii?Q?4YOFmLfPmOxdzblY0QH76V2qIk3ZaW4nLyaEoEetrUBcEDuTO8nWH6PDk6OX?=
 =?us-ascii?Q?jumggbgbEyEV43osC8AjteIGvDhRuHrcS0OEksBgf8r+19OZFpsPJ83wlWG2?=
 =?us-ascii?Q?LvwHbcg4db3klAwEyOYQ0FfKY4H5sXpTeqGf1Z/up3v+MVifhd54382/JKRN?=
 =?us-ascii?Q?f3ThNhyDuESFlrg5ZvporJErNUfGstqUNXiKT187krR5IebK5Pd15QrI+kPU?=
 =?us-ascii?Q?h+Ps1ARa4ogEbHpnNXlAAdE0UZCqhrYsCMkTdAjGkWhl9+/IDGjVtn/dZ6iV?=
 =?us-ascii?Q?wKOKPPoQ1w1fGi+Eg4R7LJKJo8+GTTwueyb5epv8Lj90uOQJWpz9o7J9tb00?=
 =?us-ascii?Q?fiCZui6BJYXWmiQkhvGrJvbDfIhGspf5uYSfm0u46mcm40DYrfnl1J3zLDZD?=
 =?us-ascii?Q?0jTAuy4r9/znTCh4H9bArv8meV9/pbON2oiydrCMeB3yoC5vPxDfKcVtOtsi?=
 =?us-ascii?Q?zFiPpprUUVtTcw3pX8IGsQSS5eKR8kpvhZj1DIjMKUPUw3B2XTgLvMqbpxG1?=
 =?us-ascii?Q?xbMj3hQjy8+Am8E9kuZVHvCiiDRYuaIvpFKcAdAJxsViKeuICHuwaE8w6P7g?=
 =?us-ascii?Q?kSpHI80YqbB6gJM7FaqM9TZqzTNoOvdl3A19cySgoSFJXvY6Wr8IRw8M4S9/?=
 =?us-ascii?Q?zfp6h/s791kjZhCRMx1EFL7+XcBk35gny2lXz2ctcb86JjwyIJZ2PdfT3HwJ?=
 =?us-ascii?Q?pYlUtS2Z0Hq4HnMBKtaY5pEY9fW/aE+9dBL9n3a83OMlx0H9sSD3Msv5gzZi?=
 =?us-ascii?Q?ApBddKTo6PkhGGCOfWCyI+UAdXBtz80FN9KAML4w3MyXyQIALCmvhFBze/MF?=
 =?us-ascii?Q?zkw0iLrVUAKyfdsnvLFMsdiBO3Ihh+n71l7gCUTNHgJ8kvYLUyPNNbPQkkmb?=
 =?us-ascii?Q?gLgQIIoGQyN8f1QQrRa9T7pkt0Ked3UR1RWl5hUBvNrBQLRw3ME2lFC2Dved?=
 =?us-ascii?Q?mC3BBqVCiEXt5wLQ/55DPEfVbd7l9C/AP5GoaJ4AqTuZRkfBacqeeM6DTKqw?=
 =?us-ascii?Q?G7Iex7r8iQK2icXoezeiLsFENNvdIEh+/PxG1GWS+GlyrAPRUd74EEQ2+KOL?=
 =?us-ascii?Q?8UTrPSqMkRyLmPIgZqXcyF8P7boBlvdX15dMv/HKFqvSwqx4ilnQBfVDdyOM?=
 =?us-ascii?Q?evGYjDDhxU2iVURLGSYfWyGYFE1GeFm8iHd/MvRLH18RITmdRJ4234yvQ/Em?=
 =?us-ascii?Q?VR4mwg46JSIwLocuXoy+MBVsT5qXES5zWg2ZtkAGfdNQBn9vLwrBgLauHnXv?=
 =?us-ascii?Q?tQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c31ac67-db72-4daf-12ff-08dafd345c15
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2023 11:24:15.3545
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ztA5BW1ZFGXlzIpEh1DtdVWALYzL7/xxk2RClfOA57/1dh3BLzBg+J/RZaWzPXs/ixpo5pIC3iC2AwlUd4LnZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7845
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 22, 2023 at 05:29:33PM +0100, Simon Horman wrote:
> > +#define ENETC_PMAC_OFFSET	0x1000
> > +
> >  #define ENETC_PM0_CMD_CFG	0x8008
> >  #define ENETC_PM1_CMD_CFG	0x9008
> >  #define ENETC_PM0_TX_EN		BIT(0)
> > @@ -280,57 +282,57 @@ enum enetc_bdr_type {TX, RX};
> >  /* Port MAC counters: Port MAC 0 corresponds to the eMAC and
> >   * Port MAC 1 to the pMAC.
> >   */
> > -#define ENETC_PM_REOCT(mac)	(0x8100 + 0x1000 * (mac))
> > -#define ENETC_PM_RALN(mac)	(0x8110 + 0x1000 * (mac))
> 
> ...
> 
> > +#define ENETC_PM_REOCT(mac)	(0x8100 + ENETC_PMAC_OFFSET * (mac))
> > +#define ENETC_PM_RALN(mac)	(0x8110 + ENETC_PMAC_OFFSET * (mac))
> 
> I'm not sure if it is an improvement, but did you consider something
> like this? *completely untested*
> 
> #define ENETC_PM(mac, reg)	((reg) + ENETC_PMAC_OFFSET * (mac))
> #define ENETC_PM_REOCT(mac)	ENETC_PM(mac, 0x8100)
> #define ENETC_PM_RALN(mac)	ENETC_PM(mac, 0x8110)

Hmm, I appreciate you looking at the patch, but in the end, I just
consider your proposed alternative to be a variation on the same theme,
and not necessarily a better way of expressing the definitions.
This means I wouldn't consider resending the patch set just to make this
change.
