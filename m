Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9A89576B0A
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 02:14:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbiGPAOv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 20:14:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229594AbiGPAOs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 20:14:48 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2085.outbound.protection.outlook.com [40.107.20.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE3DE66AC9
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 17:14:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OtFCjRB1cLyNqeMZSUxMSfHcKzh+NdkfPu49vCz0ZSlgNVUDYHVsXegptZdFOpzHikGqXi0TjjTgSx15RAJOOTKpbgBvLEvqYY/j4bCCDBdrtHfnt//WDPD79wXJaULHtuStOQ86LQ39YnGXpF3td3+6TwS9eGZSHflwGsa2oSuOOzSZEPFQOqscxNOanWLHVin3eq4C7tVdKst0FUR1TjZfSEH//O+00u68OJk8JKt9/TZxHP3iBM0S8EvUE374R+ZQdBQo9pKweaY8m2HYL4yaWpdbNdqRvYonVPQ3PsyInRDyrT8OjtajZf8tnbCoweAuWcMRaYDk2Hkys8m0BQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9mIOLOEPZdDByxKgZDzgyiHsuswUDnEW73xg8c5j9hc=;
 b=WnES9n9mWpNnSoWBQHvoVmubaKq7DVAQAUcpXPDzegEmNYKqfMG0EO67dHil1GXtlHQ0Ts1GbSISeIvx4wyIX3WfTddODjTGKceKaqaA33NVGmCYOy+cs0w4NuIgaXAAPX/P+rWUW84pMfTGg8C++ae4TbsXZStvqo2CbbBSvY+oA9L/+fRCS25UpZ2SQqh3jW93XPwB/tlbyblfHddIr4ofPy4ei4r+CM90e8teRFiMJImiuyKCezUCsUbl1eOZiO7PhTAJ///lbUXrdHkM76Mg/JHrexXlm7/a+rxrPXrS3J/OHCKnsuTFx5yjegrcB7e/zA8E6bq4lxpnUKs/Yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9mIOLOEPZdDByxKgZDzgyiHsuswUDnEW73xg8c5j9hc=;
 b=WtougoA/HFbASlcC7FoFOyGyub2nsfz3afimECXINOORKBDLuIR0KWrnrB2yjcduuPSpttp+ldgzB+Gb87CJvCUp2Fh7NmXiSkbTracO4cyqQopD6/zF+TfTB5No7hTQbDpuXtKjjbXYw2uzS4HZtqtx1bJ1o4Be58WI03q7c3c=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS1PR04MB9430.eurprd04.prod.outlook.com (2603:10a6:20b:4da::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.12; Sat, 16 Jul
 2022 00:14:44 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5438.015; Sat, 16 Jul 2022
 00:14:44 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Brian Hutchinson <b.hutchman@gmail.com>
Subject: Re: [PATCH net] net: dsa: fix bonding with ARP monitoring by updating
 trans_start manually
Thread-Topic: [PATCH net] net: dsa: fix bonding with ARP monitoring by
 updating trans_start manually
Thread-Index: AQHYmKJbDVvU92lcVkqDHlTGpm7yu62AHOkAgAAD6oA=
Date:   Sat, 16 Jul 2022 00:14:44 +0000
Message-ID: <20220716001443.aooyf5kpbpfjzqgn@skbuf>
References: <20220715232641.952532-1-vladimir.oltean@nxp.com>
 <20220715170042.4e6e2a32@kernel.org>
In-Reply-To: <20220715170042.4e6e2a32@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 39353956-8497-4082-22e4-08da66c02fbd
x-ms-traffictypediagnostic: AS1PR04MB9430:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MSGYW/CLc6yL+ikWlvCZJQnkUvf8jU4oOKSCX1nwNcTgVNMCjeD7q0qti2herDzuz6Eo5kLK8Zw8kCgcrhpF/R79BNtuz248zJe67bEj4kHY27NXvT5L2l1NcD/z0ccSUIChv/ef4XjINc/M+1UEWCz6p7awvvKPXdR06KMFUCO/bO8DF0bgezkthLz0j7CLpWaWUqeLU4uCRL0LVtN4kP/OygBJlkXoS1E9NYZaqytb1e3EKnS2DaBbkkr/rhE+6KJfFwIU6T/z6x1Jm5ciUWGjQEoYFn4NAYTNLZ7ZAL+MdaOzu9iqRrVoGcHm6pOGdVkqS4mR+MZEPnHgaseTBivPu6PPoLblYATKW8Llhi4fJVdmwaoosPNrULGKKxVyFDBSkPBzzV0s7px0ecRS3vfeD6pkLei8vWW1i0HK5OEe6Kfk50LNFuZDnIWT8fA1hjzX8VcOA/L/WSfBtIo5Sb128zHvruPFU94L5ePBBiiA+vPfisZYJg3OtcPVMTEvegB6PyMxorkpbWfoG9MEQpQx9+9fe2katlvBPMCl00ShtzgZ2GWjtM2bvfKzpW6aFzTUl0kNSNWJFtkEwnS01gWBAZUdM6M5jjOzE4obmK89O7MLyeTVCutnVPzaVvX3P0jl3n9Y6p1lU4u/0u0JCCzIFhwx1fP66eMKDIicLTvoen9JvEmBpgmNRGZkb3QfV2932FpxYml4SQybwfr0bH26i/MOyJgPL7PxsFQnt8ecNp/xCHLJvizGVG+uJHimMmsFEQRabYTVkQcvzZxroVPMT7qG9duvi2kmHayH2a3HIJ8x9KK1fY6mL1TpyIH0
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(39860400002)(366004)(396003)(346002)(136003)(376002)(33716001)(9686003)(6916009)(41300700001)(4744005)(6512007)(26005)(7416002)(54906003)(6506007)(86362001)(478600001)(38070700005)(122000001)(186003)(6486002)(71200400001)(83380400001)(316002)(76116006)(8936002)(91956017)(5660300002)(8676002)(64756008)(66556008)(4326008)(66476007)(2906002)(66946007)(66446008)(1076003)(38100700002)(44832011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?lwnMBV3QUm3M0A6mLvVCSyscGGsn5YhyWgnfVO8BuOr17fZ/U8k/JzIek2FB?=
 =?us-ascii?Q?vrStlMSjnEoveSqQwI/2Q0kAwpW1H8jrafIa4TpQUeJSZ6lcgTFtivtTb1eg?=
 =?us-ascii?Q?chGf8BtKt+j85e65jT4ud0mPr4pWIJLZU/iQtuIGGkDVk2XaSOGf+d7AeZfZ?=
 =?us-ascii?Q?CrnNWz2AUvP5DJsjYMtvyKSnZKBtSXfLe955GAKuTeB3dUce6kmM1ALfUEnf?=
 =?us-ascii?Q?lSBDQ/Uk4tygbFnupJxlYXj2Cw+Dj35RWOFZsdPTJWmTtaVkmKnTgQgEOFVi?=
 =?us-ascii?Q?5XU7DWlTml3nxDXw3FUxK45OFq5TdEADVyB5UhgaRcm/G+j3E31As1qPNDmE?=
 =?us-ascii?Q?DcnIaQVV3cBjyEokKsbvl26IIdKrsTdwRzBq3hm5ObsC2AshQ8Ga+E73VDRg?=
 =?us-ascii?Q?5tjy6UDIoXY1mmTgj6x35b3i/eDHaqDiH5VoaXhky8zpLUX4YXukMon+gr9+?=
 =?us-ascii?Q?RDOlJm/tFVBVj2IYkiyT28j/531qG98dloQ1tqHT85b7eXS1N+N5Q/9P5zhx?=
 =?us-ascii?Q?SCrXZrA1Gsw8KSdlEOTOaPQp8DPpP6fiUd+VpQVH1q4ktsz83qlqnI+uTmb/?=
 =?us-ascii?Q?XKQB4r0b/mommsJwo8mPsplYR/JW3clIw//2W3Q90TjZWWiZaRmrrb5NR9hG?=
 =?us-ascii?Q?nXizOMliq8OcvpUvYIM+DvRthyL2Brwh2jfmJkm2jaVwge/u4tMZzE+rAZ1N?=
 =?us-ascii?Q?nq1gOa43eEZ7ylKBrq+Ksu0R0FrQ+7m2YTXJarz8spJL1rfxxWQNcKeubEAn?=
 =?us-ascii?Q?JZNQevbMtrfIcANtl3HOLH7Uww285x/9kq/xt6CXCwlEQwMGt6y2ivA2XMbn?=
 =?us-ascii?Q?lmGz5EDQqWmfHQVAWSS1R2uIDRdf/92wWFfCtR9SDzoNiq/BNuyeEE5yT2dc?=
 =?us-ascii?Q?9tRwOBV7yc0zgbP2sfMP7JtGRszvC479tcmymhbEr54nISnfntEWijzzgduQ?=
 =?us-ascii?Q?a5KguAl/biHFzZLX9fpUI10aiqpqy9SCr/EFuTfmmrGFJq8BmsuJtK7JZ6v3?=
 =?us-ascii?Q?xGHHxf8Y1hedQJROzutB5aXeWaYhTgGWlehCqm87+BbU3fZMwgaYMglH3AdE?=
 =?us-ascii?Q?AzSfdA4aef+USaFliovnLk36m6eYNOyLjkggoM28lcUVQmP/zet2ta5PKVf6?=
 =?us-ascii?Q?Iq/IIvAfQSaLRqjc6Ltzfy4NNuAgl/zmwCahP4v6VOiCRBl2t6rgWUBTVv68?=
 =?us-ascii?Q?M3XHDCQZtm0GKUzV9vSL8cKnc0npEbpkqND+75uRLC4Gq41fdTB2m1GFhBBz?=
 =?us-ascii?Q?fWwCHoqvFqtS+X8PVMEjXNkr5f3/RJUoBp7kWk5YtK8m6s3rdDq7rvM1/5Wc?=
 =?us-ascii?Q?oaDBn5jka+U8t0Y45/KKRoyEhCmAmpZ8sRFE9Lmjz+N9edDFmfSi0DJR2Bfk?=
 =?us-ascii?Q?/jjeD8QJJIlzL6EHM2U6VuFIzPSgu3PXXDUD4Oj4ilRWBTF5ehHl63eBStoH?=
 =?us-ascii?Q?t0K85hSjNVjZlvAOxQCPz6lwkC/h8tRXRPe/zQgFD04atzf75clncRunfi+Z?=
 =?us-ascii?Q?H5cI7uCixrsH/UJCtgGlo7Yp5CvykOkQuBzQhJw9nbaZtHv2tQ590GBRF7eM?=
 =?us-ascii?Q?hoZwHZwXhSVzjWRLtiUAKLwbKWrouzdbw5uMZhM6aSemQIrBC/BHnfD1iE2O?=
 =?us-ascii?Q?DA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B576497C0405CE49BCD3F1F5EA961706@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39353956-8497-4082-22e4-08da66c02fbd
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jul 2022 00:14:44.6868
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: P9nBxoL9Z3nvkVPT4gja+MmaJBaKnAjp5maH9YazlHBb7w//E55dxQpcIiDYPUDm6R2u6BPqd6Ubp4imQB1KoQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS1PR04MB9430
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 15, 2022 at 05:00:42PM -0700, Jakub Kicinski wrote:
> On Sat, 16 Jul 2022 02:26:41 +0300 Vladimir Oltean wrote:
> > Documentation/networking/bonding.rst points out that for ARP monitoring
> > to work, dev_trans_start() must be able to verify the latest trans_star=
t
> > update of any slave_dev TX queue. However, with NETIF_F_LLTX,
> > netdev_start_xmit() -> txq_trans_update() fails to do anything, because
> > the TX queue hasn't been locked.
> >=20
> > Fix this by manually updating the current TX queue's trans_start for
> > each packet sent.
> >=20
> > Fixes: 2b86cb829976 ("net: dsa: declare lockless TX feature for slave p=
orts")
> > Reported-by: Brian Hutchinson <b.hutchman@gmail.com>
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
>=20
> Did you see my discussion with Jay? Let's stop the spread of this
> workaround, I'm tossing..

No, I didn't, could you summarize the alternative proposal?=
