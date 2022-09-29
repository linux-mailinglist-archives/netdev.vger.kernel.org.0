Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE6D05EF6B9
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 15:35:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233674AbiI2NfO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 09:35:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234988AbiI2NfJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 09:35:09 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60068.outbound.protection.outlook.com [40.107.6.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA29C4BA78;
        Thu, 29 Sep 2022 06:35:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lNIoPLoshTeaxEiMroJpfkfB1XKL27GXDyV5/BYcWbTEgWkSp9UC58juTHXetxRszLE3OhISX5Gxaq4qAKqq1VG1nHg2/22fNUXlzhEeKaI+dCkMrlBk4CX849/TWVYTI4U4hrQ6qjhjlzWbzzG8FMl1nmX/kQHEKvqROydMvdu4p+h1X1r2lA+eqodzIvNPhpMLomhPENs+uxxVfTZf5BfbsIZzR+rPyoVul5Tv1ta0q5vFSU+nJPDFy2PHJFGRS7Th2aopx7LaBSWpD08POPAx26/k0PZRnFMC73gs1HLNHwOdSTJHL7k+qZrPc+YbdO4w5GGw4/pzD9Oah7VTyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Lha1ZC1TEfPH5fyC1Ixux4rF8XHGTtKWWI0rdFRzBU0=;
 b=Vv+wBpUhxup8uYzvcGCi2YLAQUThKUZ3PBLBp2DkgYLbR6SMjMyd1E1uMutuFKPrIYatS5nilq8lW5MGcLBu1Mz/pH9kCQ2nwvAOfBy7zWAfS6SC7tKEr6/na8DY5uGaoFJHPFB836434+JHeUU/c0nXb1QPA32vP5quHx2FmHqAOtXv3L/WoC+xERIWcdxtQPbVOhhwQPUnFjlIaIy+tjKv+JHsQ3zn+zJOhTKL9e7spKUqpZZuN52hewxVcB3S+ZEYP1rRxolQmFFiMtpjZ3UPOSHp/lABKiaX0ML9aX3DYw5D+n6jD9YeJpGI5di2W05oRC+xwV/h8yT4ZGz3tA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lha1ZC1TEfPH5fyC1Ixux4rF8XHGTtKWWI0rdFRzBU0=;
 b=a4RCFasHFG4WDkvGqh/NPDtDkrqBnNnKoSE4Wsg+eOFPaOAhyoo+oDbhhdQzfdscF+iH9vhgLGDZYVf7yxzT7S136JvYWd7YSsSLDiHfHaKMX2p4Qy3dw9cSWPuhOV+efk/YM6/BQDzvGXcO5RP8g1vnJY3VtzLeWaeD34LY0Hk=
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by AS8PR04MB7686.eurprd04.prod.outlook.com (2603:10a6:20b:290::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.20; Thu, 29 Sep
 2022 13:35:05 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::a543:fc4e:f6c5:b11f]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::a543:fc4e:f6c5:b11f%9]) with mapi id 15.20.5676.020; Thu, 29 Sep 2022
 13:35:05 +0000
From:   Shenwei Wang <shenwei.wang@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "imx@lists.linux.dev" <imx@lists.linux.dev>
Subject: RE: [EXT] Re: [PATCH 1/1] net: fec: add initial XDP support
Thread-Topic: [EXT] Re: [PATCH 1/1] net: fec: add initial XDP support
Thread-Index: AQHY006sqGpD/PA5gEmZiYlRlE0jhK31pSmAgAC11xCAAAviAIAAAMVg
Date:   Thu, 29 Sep 2022 13:35:05 +0000
Message-ID: <PAXPR04MB9185B9A02BBC7A861C6B75BA89579@PAXPR04MB9185.eurprd04.prod.outlook.com>
References: <20220928152509.141490-1-shenwei.wang@nxp.com>
 <YzT59R+zx4dA5G5Q@lunn.ch>
 <PAXPR04MB91859C7C1F1C4FE94611D5A789579@PAXPR04MB9185.eurprd04.prod.outlook.com>
 <YzWcdsGkq4x8VWbY@lunn.ch>
In-Reply-To: <YzWcdsGkq4x8VWbY@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PAXPR04MB9185:EE_|AS8PR04MB7686:EE_
x-ms-office365-filtering-correlation-id: f4062e7b-5a28-4180-ef98-08daa21f6b65
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: m88mGo/sG76T8Ji6+57j8ngzZ5sDqdMHwZiV29AhvM51IN3UtGXjzDhWyjiPyxrd5x7xEun2R9IUVE8AwJ6Fpsp/dvztOKNY/D/Vy2GUimfQ5qogoqN5UVXMN6yb4NdW1xezisZ+2y2W12NZBeH/GkSbM1ulwvlBT54fkTyW1xJEKJ0coL3P56RYhIiGXLzgUGg/D86fGEBcSW0mFGHrOzhRzQm10vD8aQ63NdEpvt0hWPfotVGs2SPgEinC0qpmVEXUx0MJCK0LzZtzyVIvNQ/PGtdQsd3HL/DMq/PE7cdByxunxZD2hKPH+tTsOKjzKt2c6aA3VwTlvtGEcCCC2mkdU2NbNaXqz6EeAhbT0DWtePxZZVOKoJ8WeakXE8p4uWIy50U4BjPkARCNXMqtp0tuFfr6XMyokvcCABPV/9iETFzZSfDpydFp/xG2OF8o7JsjMUO3aAVhDFaBHLnpkqOg1xdIEMdUpTTrPj9yO+9XSdTziIYJaXKSseHjfr2Hjyiu1BqXUmIi6wfaYUDI/Omm25qdTbqK6yfGrBT2eRmkrUmXVvCNmmMdb20dtaP1JF84TmEkVKcCs1WOvaLPsrlTbLnpiAAjD+NqylvBPRRz9EAuGmlUH+9JuAnZfbQZIunorIl1/oKDRmKdEt4Ee/8Powmz2K6Uz4IEg1Fw+UDdCfOeK9BCpSe86AwIwE41V3znESJsfUyjqHWo4Wxs9JljaGiXMhUVKmy1c/+WLFQhq/7xZvLuMDDMKdluTbUrmn7LLfMLPiaWZL29I4HQZA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(136003)(39860400002)(396003)(376002)(346002)(451199015)(44832011)(33656002)(5660300002)(7416002)(8676002)(64756008)(6506007)(7696005)(41300700001)(4326008)(122000001)(55016003)(86362001)(38070700005)(38100700002)(83380400001)(186003)(478600001)(71200400001)(55236004)(54906003)(6916009)(26005)(53546011)(66556008)(52536014)(66446008)(9686003)(66476007)(8936002)(2906002)(316002)(76116006)(66946007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?eBWfgDdpIm9y4GRHi94ThkSFuFmr9/txykrHnR3F73ekNIK/Whv4IFjJGVeP?=
 =?us-ascii?Q?ryssDEXvnzjUFvKv+19Kq0110dneij4bXIpMOY9iDg/hDyX7gdDd6roSx17m?=
 =?us-ascii?Q?RzMRuA5ge+sFizCFq4XTTO/KgUyU46nZLWoKLZruwDg1a+vowWEWg7EiDElY?=
 =?us-ascii?Q?f1ILcKEFDuT6PdvHNT/vBK4P0ZuhsPd2Xy4b2Ff02Kf4S38DbPzVfOuyx3jT?=
 =?us-ascii?Q?x0WMFwG7paSq0+iadt3O1hi86aPUZM8/P72T3Cjqca9GmEpquRhuQyOFFi/e?=
 =?us-ascii?Q?uf3SRSw4hgYBT04WVtU7r1aBWiEHsi0WMVYnzolnxEN7g3yr2g/0ieXbN6UG?=
 =?us-ascii?Q?qziNpSGwlcwZIrOy+VSb6z4+4hfQmk3yiCBqamvFWrnbc7qeuEb5vbKhpnoE?=
 =?us-ascii?Q?Waq3kUA2DnKN+1hJ9MEtH9zXdS//WnRhi50OnlrFVhobIBDMUJwEJKTLjNim?=
 =?us-ascii?Q?4jzIMf/jT3Zl0Zf8hMPaFyKaVUxOuAVRQHsZhLP+/qlwrkhwYktr+lkYoUQQ?=
 =?us-ascii?Q?cjFcnHPJTAmGcBa49Tt18MpVcWJjmOU101kQTyhi2KRyYSRN4xpV/2UmQMBe?=
 =?us-ascii?Q?liiROO8L+IftR2VyRSD2z/Z5JxDSEKWc267ImYdljQAdTCOGv3DH8/3lykol?=
 =?us-ascii?Q?eqblM7P6f1soXsGFR8qP6zh5K4doBAyme+N+jez+vItSDWZPGO3GODEOD/Gu?=
 =?us-ascii?Q?u/17B3N+eUfGsT1FeRca47hilUjUMWxxbiGwBWFTQjQr8UAyvlMrAXKPVL3+?=
 =?us-ascii?Q?/Cxp9lFgrp0vBBU/KyzPeWFkQ9EmpoCdE93zRRTld8obqpIa6hjWYrf1a4+W?=
 =?us-ascii?Q?5rmJvUftBmmEhtpqCE1uhYVealNqG3jl/1L2T7Bo9Y+EwDA7wiayq0Ic5Qc3?=
 =?us-ascii?Q?LHzE9Fyy38FFvyCiUZevCILmg+VkUvdHMqLphHx83Hl85vjMHWuSrd/8aYV6?=
 =?us-ascii?Q?MiiGKzeYmMe56JfETykdno4rcYZbnmusxkvM4DglVFZTKKfDOeqHSgdt26wr?=
 =?us-ascii?Q?w9zM+yStmdVTNHXngxZqavyCq9nO6YE/DZ2eokZ0MSCeQfZxxIDN89c6CaLo?=
 =?us-ascii?Q?e5i8ZPr5C8nLINcfbv4Ga1RXjntaZc9tb5Ods9HeIr/mYvTmGafkzhMznwyg?=
 =?us-ascii?Q?lJDF+SezXHq5oFWAAffB49XdN9AMNY5YutBhIJm1ACLQHXywn3RXuEPLWUTv?=
 =?us-ascii?Q?sRDpgYXWN4N01DR9eeh9jZbgf6bT4/IGhKPLHRoEa6qsViMgeMxhY/LDNW9p?=
 =?us-ascii?Q?fhZ3GYcHBJpBUXEr2bMpZdpeZ+uoNzo7U7SXBWbmCAN36R3zWZS15mK8BTt/?=
 =?us-ascii?Q?UdnTRjbf9PaHNiSqK19/lxusLRWnJg4y1qhTALR7aigfGO4j0fcS2vcPUpJt?=
 =?us-ascii?Q?oq/fZo8NAwUSwVnntOXds3LiEFe/m21bleJZ1fMJUlcXmg6cxJKegjvnn/Bs?=
 =?us-ascii?Q?8bptdnQj//hNwdstoGc7KHq460gM9OAMgKdcpUEYDcj9hv5PKH9EDMREhoRS?=
 =?us-ascii?Q?H1TAAm9VEGqJq2YaNyXAKSePfsYmBPIO7j0WnAd4VHghzdXfYEF1Ur0U8wPg?=
 =?us-ascii?Q?AjmnfKeHGmDEThKnqxtYvqzFi8R/M3EHA2JFI8gR?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4062e7b-5a28-4180-ef98-08daa21f6b65
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Sep 2022 13:35:05.5718
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lvbnMXM7IKCRFLNIPTZIYwyV6NT6h2+LSrAI5mz9hr+FVQBNlNvvLi163eiCPj0YHrzPukOHS8UACUIF2u7nrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7686
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
> Sent: Thursday, September 29, 2022 8:24 AM
> To: Shenwei Wang <shenwei.wang@nxp.com>
> Cc: Joakim Zhang <qiangqing.zhang@nxp.com>; David S. Miller
> <davem@davemloft.net>; Eric Dumazet <edumazet@google.com>; Jakub
> Kicinski <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>; Alexei
> Starovoitov <ast@kernel.org>; Daniel Borkmann <daniel@iogearbox.net>;
> Jesper Dangaard Brouer <hawk@kernel.org>; John Fastabend
> <john.fastabend@gmail.com>; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; imx@lists.linux.dev
> Subject: Re: [EXT] Re: [PATCH 1/1] net: fec: add initial XDP support
>=20
> Caution: EXT Email
>=20
> > > > +struct fec_enet_xdp_stats {
> > > > +     u64     xdp_pass;
> > > > +     u64     xdp_drop;
> > > > +     u64     xdp_xmit;
> > > > +     u64     xdp_redirect;
> > > > +     u64     xdp_xmit_err;
> > > > +     u64     xdp_tx;
> > > > +     u64     xdp_tx_err;
> > > > +};
> > > > +
> > > > +     switch (act) {
> > > > +     case XDP_PASS:
> > > > +             rxq->stats.xdp_pass++;
> > >
> > > Since the stats are u64, and most machines using the FEC are 32 bit,
> > > you cannot just do an increment. Took a look at u64_stats_sync.h.
> > >
> >
>=20
> > As this increment is only executed under the NAPI kthread context, is
> > the protection still required?
>=20
> Are the statistics values read by ethtool under NAPI kthread context?
>=20

You are right. The read is not under NAPI context.

Thanks,
Shenwei

>     Andrew
