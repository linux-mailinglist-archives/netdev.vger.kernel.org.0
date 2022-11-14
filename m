Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 033D8628586
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 17:37:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237549AbiKNQhx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 11:37:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237540AbiKNQgo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 11:36:44 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2050.outbound.protection.outlook.com [40.107.21.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7671D50F07;
        Mon, 14 Nov 2022 08:32:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AMisxyshclXPLnE424Gtvt9vKkpooMU98swAy5IHtR+MwYKYJz4k9Uox5q8HwRMFcKa1h5ntZ5QH2gWcfH9zylRqFSqDAJ8f0fhx8jdgK6KF/Whlq3xnxuQ6rrvlEfKiwZgEJLNiU/EpF6H1XPVYtLaI3bddO6vGxvdiEFgX1d5QgPZb5Pjn2Me/8gWNDRG+yh7yInmKaILo2vln9zCIb4s5ICGlx0manGedmq+/BOhqYtazfy7Iy+8HFVzhru7kzn8IEyCmioUaXzo5/NtblsJS40qLrcLT7otR7URUbeCIGnFgsRdZ1kJblTklfo8dnb6U0hjxzKXZmluWDyfjxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N8Mqhc7Sndk6617/xZg+hOgTz7ghFTAOcFb+JoFVJ6M=;
 b=X5TS0eyFTFzyRpHwbL0F0J/y/+lhkLIai5FLEHnS0N0Yl00EuxYqNxRXvMbFcw1YDqV/bFvJ2Mlmq2AT4QBxTe8kUudKE1yr7yRUbh64P5EjR24UaWC8ewShCjiEUR2mPcAu2+kAmrRoDsLLsGoAMa9Hzr8XH2/m2eEv8u+yB4BVxA1Wf6RRwWB4Ph5Ce6xij3/+pm7rFvOw/bHr2yogc6jXP/RhDk4TF6r4NmzgAbplU3/FtCzoye25Fpbm+MXw30z6iLHJbq8/XfzfKoZYE3OCclP8iqxw7k7PONdMtIDYQp5Ni2RPZJqNzgOstH2gjMNuphNHz+Ca1NkmnN33MQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N8Mqhc7Sndk6617/xZg+hOgTz7ghFTAOcFb+JoFVJ6M=;
 b=mwr3z3yX8t+bEFrVahzQ+1IeIXFhlJqkhNos+pBzRD5hXrg8v41+IA9gwJ5j/YZQNV2AMN43B0fZwdGNtK0B2Gd7Kr8p/ps7bizt38F3JXbLPc3oQEXOy7xLZq0JRN3NW5IeMYrGAwIm8maflBtferF9AEmU98/kmLaE3T/xnTY=
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by PA4PR04MB7565.eurprd04.prod.outlook.com (2603:10a6:102:e7::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13; Mon, 14 Nov
 2022 16:31:47 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::6b44:4677:ad1d:b33a]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::6b44:4677:ad1d:b33a%6]) with mapi id 15.20.5813.017; Mon, 14 Nov 2022
 16:31:47 +0000
From:   Shenwei Wang <shenwei.wang@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "imx@lists.linux.dev" <imx@lists.linux.dev>
Subject: RE: [EXT] Re: [PATCH v2 RESEND 1/1] net: fec: add xdp and page pool
 statistics
Thread-Topic: [EXT] Re: [PATCH v2 RESEND 1/1] net: fec: add xdp and page pool
 statistics
Thread-Index: AQHY8+NzKrQRZ3k0YEy+QDrsvHgkC644DoaAgAAaV3CAADZxgIAAUdXAgAXC4QCAAARvAIAAAdMAgAAPjpCAABpqAIAAAKYA
Date:   Mon, 14 Nov 2022 16:31:46 +0000
Message-ID: <PAXPR04MB91854E3A8555B067FDEFBED089059@PAXPR04MB9185.eurprd04.prod.outlook.com>
References: <20221109023147.242904-1-shenwei.wang@nxp.com>
 <4349bc93a5f2130a95305287141fde369245f921.camel@redhat.com>
 <PAXPR04MB91853A6A1DDDBB06F33C975E89019@PAXPR04MB9185.eurprd04.prod.outlook.com>
 <20221110164321.3534977-1-alexandr.lobakin@intel.com>
 <PAXPR04MB9185CDDD50250DFE5E492C7189019@PAXPR04MB9185.eurprd04.prod.outlook.com>
 <20221114133502.696740-1-alexandr.lobakin@intel.com>
 <Y3JHvo4p10iC4QFH@lunn.ch>
 <20221114135726.698089-1-alexandr.lobakin@intel.com>
 <PAXPR04MB91850496D46660D3B8394B7F89059@PAXPR04MB9185.eurprd04.prod.outlook.com>
 <Y3Jsenmh9dbAauQS@lunn.ch>
In-Reply-To: <Y3Jsenmh9dbAauQS@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PAXPR04MB9185:EE_|PA4PR04MB7565:EE_
x-ms-office365-filtering-correlation-id: 87e27e6d-1f44-4a1a-106a-08dac65db950
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vI0LS76bMU9NRJ4MF0Dn9UaZq8TiG/43qLagAT5/Nr0oGSsJ94m48sdXrg+yZOjDCguYFNqC/mQxxUo+Kz99HvVZVaUweiTKoIxe5jE/n82d4kLrfkYci9tJcjaIohq9LkJaOrw0aw/0xmeZ6m5dG4wqILh49b2lOG/h/Te1RCNHJUtN4gvdz/EvNAKPgr+UblEb4tTenMOR1uVo/BoLY0LJiR9CZf/TISlNNspkExoVTI8koaRtavEY69SXOBMwc0K3Pfd+vW1Ovnz3/7yToMOCMIG7z+OIz4PRwLWTvUZJsHL+d8PGa83v7DiDAMcaQiEsY2fyh+QV+2LM98MWHMNc8x2y5TlxSWDN+99PvJ7VVNps/kKXWV69t2KU3I+6e6dynC8eGn2Fb1rXA5xXQG8CcWxtW9HwikesJ4LLWUudRxGncaWBMegu9V6NA942o7YmDCsvByvjELoo5wK/7KVou2bkqsa9u70QxFo0Gr4G9vweMZvGHUpC3v/LNX0urRJUkELr0ba0SFdsEbYPA2MnQalu71Gn2G6OZh4ZfyjqUtQftblleQN8admkFDvUWOlISMoBO8eAiL68rm4VRDieDzYsz4GSQ7plm3lR4OBOW33BteBDBaZxP4FoT0krO6D0BI6pM9PyZoZzJmn2GycW1rIO4cUMVQ6WIFq2ClEmcn/xOJjwhG2VLJr/ujm0n7REUMJH+Dj1oQjd9f25zp/Ua0xGu5nHbU2rDIcMNG37M8/ugRwQG4DAs3fqmV47pjTb3N3Iq2PZ74CtEwwzwA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(39860400002)(136003)(376002)(346002)(451199015)(71200400001)(33656002)(38070700005)(478600001)(54906003)(6506007)(7696005)(6916009)(316002)(55236004)(64756008)(5660300002)(8676002)(7416002)(26005)(186003)(4326008)(9686003)(66446008)(52536014)(41300700001)(44832011)(66946007)(4744005)(8936002)(66476007)(76116006)(55016003)(66556008)(83380400001)(2906002)(53546011)(38100700002)(122000001)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?AACzuL4VTJYUFrtH9VDvHUawEVn2YWB9/n74UeyBrPo8S3Quy0ZGpkF+Qa2Y?=
 =?us-ascii?Q?/9Mm0D506KymN6JAVU8mhZzfq9mvn4DpRnXxfIxZcW9ZHkS2VhS0AQOK6ZCL?=
 =?us-ascii?Q?Eh0vTFRozYRFEaPj9txyax8TpDNU6qnArEHuYuQ+UKjQYWZsMSCXv9ZH/0ol?=
 =?us-ascii?Q?N49GuBBD6oAN923HYJuIBrK05qa+lPIdZ5BWvRRpD4OH0nyB/wagBnWiNUHL?=
 =?us-ascii?Q?L+2K0SZOAkMyhedWrHRKotmrD95UUEXLKQpAPG+7WrG1zCaXVLL37SBCBAcu?=
 =?us-ascii?Q?Mp+wB4BnjH0/f2JXeiV967HZ23xG4JL8DM0klGTSY0/wvNfIBldCKujAs9pM?=
 =?us-ascii?Q?rrZkyYlb3i/BvNREWMeGi7mfyMMFPHmpWfobG5k8DHrgE8+fkaN3msvbFjMD?=
 =?us-ascii?Q?n4g+CkwJKHNtSF7VofUCb0oo8jpt8wgrI6Z0p3mgilvks/HNwncWeDfHjvVa?=
 =?us-ascii?Q?F5BGmAXZb0sFf+ytWpj+VSSS7FlWp9YhOVifkUI6youRLL70TMYBKPuHuTIn?=
 =?us-ascii?Q?PHY1Dj3Yoc3XZHpp5Ed28Xaz5Z0t+FPE4RzNqJyAsQifHa2MLrBWRshpDYv9?=
 =?us-ascii?Q?GbSLgwIHwQDAvrs1t1tQ1k/SBn2oEx7wj7kZPErBkQ5QAi39lVqkBHJcmGtn?=
 =?us-ascii?Q?uw1IVim+9WmxLdQRTGF6G7hrhU7eYxsU+MczFPRIJkH/SdvDZKs4aqM1rxQG?=
 =?us-ascii?Q?5b8KHnUJc/5cVSdxQ89bND8s3g1WLnpQbHERhJy2/JSAmquJkgMkO0fjbNSd?=
 =?us-ascii?Q?7C4yvFrZqReIHKj4EtC0dS+HavXkU6PEogS7/K8mVL9vgG965wINeh2KltpD?=
 =?us-ascii?Q?MGqognma3+6zLFvp2/GOszzGHA/5TYCNIDYjDvpn62xv1oNYpmMt0/Vd503+?=
 =?us-ascii?Q?Jqx97OtXUsu0FmI7/rythisHAJR1QucowH3/2SmVH1rzPpNsuI4oOdIaFpnl?=
 =?us-ascii?Q?lr5sRu5the8o4DSA9ntRgyHeRYWPxj/UA+adnRRPlQGqXa7dmucJ9a+2Cgkb?=
 =?us-ascii?Q?7MCghCi3bwGMcadJa9qPKc+mKHeidZuio0NCH8wHspvrXjYwgedKzj868szT?=
 =?us-ascii?Q?18OCb1aJuvKnvhFgI8sgC03XynwKLyw/3SBWTxcimQML55vcuxzlM9BGn1Ix?=
 =?us-ascii?Q?4p8kfP9lj94FtVbV57q2/YmfHBD3kweFcb5OSzmKfUELGdpRd1rutkEk7SOZ?=
 =?us-ascii?Q?et4PWlajg8w5vteSilx4+Ajqw/XJiMq34CPohpGPMXWm7bHrJjZhP23zXv9x?=
 =?us-ascii?Q?2rot3B5+9a5XbcM45V0AjAsUPiWpBlq91z4eCoRNSOVzZEmNGe25C/qW9Puz?=
 =?us-ascii?Q?Z6GTo6pHNdCZ3nxku8xpedZ79uona5c72GsyI1yuITDdDaOSbk4rAREinMtt?=
 =?us-ascii?Q?NSKcwXMItceGWQKdRdPL8xaur+4V7v7TZB8axk/Es1VYK1OwJruJIwQyqxeB?=
 =?us-ascii?Q?l/TX41fGyWU4mYQX8XTqV9F46Dk2Ezer1DKCSd6snSXH6qOWKMjW2Xebrssv?=
 =?us-ascii?Q?PE5S9OmVi5aNjbDzwH0+ke8BeMZVWCRAwBt4NKzZYa+ZikD/VeVbW8Xi2HdK?=
 =?us-ascii?Q?w9eIDWQ2wx5+QcieZxd3pYvTdtAE4u0lUx6pOvko?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87e27e6d-1f44-4a1a-106a-08dac65db950
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Nov 2022 16:31:46.9176
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2UFm/vXU05Kb+oihVVLJViUxGTm5+Bk4nZfOeQn4i+pEmji2al7H+yUOjZz80aelXBQVeIbT/ivJCpuQurMkbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7565
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Monday, November 14, 2022 10:28 AM
> To: Shenwei Wang <shenwei.wang@nxp.com>
> Cc: Alexander Lobakin <alexandr.lobakin@intel.com>; Paolo Abeni
> <pabeni@redhat.com>; David S. Miller <davem@davemloft.net>; Eric Dumazet
> <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>; Alexei
> Starovoitov <ast@kernel.org>; Daniel Borkmann <daniel@iogearbox.net>;
> Jesper Dangaard Brouer <hawk@kernel.org>; John Fastabend
> <john.fastabend@gmail.com>; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; imx@lists.linux.dev
> Subject: Re: [EXT] Re: [PATCH v2 RESEND 1/1] net: fec: add xdp and page p=
ool
> statistics
>=20
> Caution: EXT Email
>=20
> > I did implement a quick version of u64_stats_t counters, and the
> > performance impact was about 1~3Mbps on the i.MX8QXP which is 1.2GHz
> > ARM64 Dual Core platform, which is about 1.5% performance decrease.
>=20
> Please post your code.
>=20
> Which driver did you copy? Maybe you picked a bad example?

The implementation was not optimized because it updated the u64_stats_t cou=
nters per packet.

Thanks,
Shenwei

>=20
>       Andrew
