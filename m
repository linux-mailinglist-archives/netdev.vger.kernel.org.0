Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 208A452D62A
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 16:34:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239822AbiESOed (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 10:34:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239819AbiESOec (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 10:34:32 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70052.outbound.protection.outlook.com [40.107.7.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 934D279398;
        Thu, 19 May 2022 07:34:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BwrDTmCmsXLYbqWiVWo9glMlSnWXYEOJNlBY0w2VdLND0Klm9r7bYL7QHphQ7WV/x2Zo13V5PI982tgd5vxue92spf9mnJNJVeIARYwaEmZUxqhUOlEuEimSt1TnnEnHjAkw2WCWIekhFg3zHRDThmvsheIAXQWG2ArBQYmISYOqaUysNbxEoifIN43AbznUO7t3P8II5clnYVijQC8gncAC3cj6Zpt4iTG/qLyIXi3pB8ElslGrq1u/71ih8G6dAub6W5LsNV5PFuWK7eC2cyHDmJWb0osMEFtznrIGazt+9xkE5Za8EJtddOBZaEUjkcXwq+jYHHY00gaNjIKCFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Aw3XkxCH9/s/OiSlCGiguM71wtYaKyL8AoJ2EcvOkPM=;
 b=I/Poj9lG/hgLQKsgNVj7VAtjlDEI58vHV/7qMX66LSdQKmWS9lrbGZeF6xYbVM3zIidyCH+7vrHXwR/7uWRPxYnHV5nLl0VQmVZvmUhSut+7XLMXYcFfEcrHs0Joqd8CinmNFuCXgv1t80HQGErs6maMYOswr6UOkFLP3AiAH5b1AnE+Q7PbcE6TyhTNSPFQJXP2yklj6CKdWV6IGqYcE6QgDODXz7fIeVKazmZ3rs2eDgRPYfTsD+737+8cHqJ8iw74yl2a5F+g3vRULjQuhLH7l7cknDC7tyCrDcHX4EbuO0AVRfdi9OE/rVE1givGX+j1rtfg4nNdLRJdyaxlHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Aw3XkxCH9/s/OiSlCGiguM71wtYaKyL8AoJ2EcvOkPM=;
 b=baUouxZ6J7C74woCIDOPejZv9hGhU0+tEthZ9HuQ/y8FhZuVvzkjo79CUV105+xDK4s5npx2ExtFimE4j8NtHgiZ0EYBwcpakl2bsRrZDxHXRMmJax9xOe9OwwnM68RLg9z/IklwKEFCnwyRNqkrLosKBWeCdalEnZPqg3W02Qw=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM6PR0402MB3800.eurprd04.prod.outlook.com (2603:10a6:209:23::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.14; Thu, 19 May
 2022 14:34:28 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5%5]) with mapi id 15.20.5250.014; Thu, 19 May 2022
 14:34:28 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jonathan Toppins <jtoppins@redhat.com>
CC:     "liuhangbin@gmail.com" <liuhangbin@gmail.com>,
        "andy@greyhouse.net" <andy@greyhouse.net>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "dsahern@gmail.com" <dsahern@gmail.com>,
        "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>,
        "j.vosburgh@gmail.com" <j.vosburgh@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "syzbot+92beb3d46aab498710fa@syzkaller.appspotmail.com" 
        <syzbot+92beb3d46aab498710fa@syzkaller.appspotmail.com>,
        "vfalico@gmail.com" <vfalico@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2 net] bonding: fix missed rcu protection
Thread-Topic: [PATCHv2 net] bonding: fix missed rcu protection
Thread-Index: AQHYacdpSy/qLYlrTU68MLhr+YBOyq0jVL0AgALyyYA=
Date:   Thu, 19 May 2022 14:34:28 +0000
Message-ID: <20220519143427.5cb2a4slbeopd74w@skbuf>
References: <20220517082312.805824-1-liuhangbin@gmail.com>
 <a4ed2a83d38a58b0984edb519382c867204b7ea2.1652804144.git.jtoppins@redhat.com>
In-Reply-To: <a4ed2a83d38a58b0984edb519382c867204b7ea2.1652804144.git.jtoppins@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7060fcd9-d965-491e-9f81-08da39a4ae0d
x-ms-traffictypediagnostic: AM6PR0402MB3800:EE_
x-microsoft-antispam-prvs: <AM6PR0402MB3800A49857F04913B8EE6706E0D09@AM6PR0402MB3800.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HvnAXFN6MDuv+Pc7jgcYhhjPFsYbkFVLOOllwv4XKfA1veBO4Co1Ly9gI14dcwUpH43whhFtKV5flu9TEcOtOfsFQkcHiV1KewFA//po/3tp6bzNQPG0EW4CWRxY6GnzbuL8NMrDaJgNbRITrGu9YpmyuC7CVNjeTIEFtSQazi9dJZasmmktZDJ3HzijDgKUVwnNMMBXnH/TKQMkAVcn0zQPzdSA1RSS8v8aNqxMopp8rIDt+3xVXJFfdDbF5Nto1UujiQ+ijjnSlt/K+4kYmpJiw0O+oaguDbijqZTDt6eJ/qToec2+5++0i3Tma99KIBHSIa8VadgxNDySOAE27HASJDo5iLIpQjNm7xZD2vlJcPkMU5uqmPPp/OveuBcecm5gru2ZRm3lBtX0lqzSCfmXS3gDrQjpE2TEFnKA9Vsls4EOMXhslwQXo2GgSBi9fbsy6fdjmEmgkI9jVTxis0WcvkIqEcWsR2IxzBN/iLsypwxFcU1FQXw5EaTlCsjlD/ih/vyvNfqhkeIpD/tJvtbmetd5bevOOIQmgqWIXzH/Mn9Y242we6Y+MGSQIjyVmFme4L296WtBOKewqYv8isaiNJsY7cqKk8sKf7K/ahuGuE+KuZKAiXCkQBdD3ovWYxYPKU6Eqw2A9GDFIcYGeqKFoCfh2v8q+vzB+FyC4194KldILguh9cNbO06PXcLi83aEY2cDHoeghjR2VFreAA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(26005)(54906003)(5660300002)(186003)(71200400001)(7416002)(8936002)(4744005)(508600001)(6512007)(9686003)(6486002)(316002)(33716001)(6916009)(6506007)(1076003)(66946007)(86362001)(122000001)(2906002)(76116006)(38070700005)(64756008)(4326008)(66556008)(91956017)(38100700002)(44832011)(8676002)(66476007)(66446008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?WtvFgnZPYa+6F6fCOxM1NJtF9d01S6Gk0Am8Nx5D39hctxbnd/q2F0jZe3cc?=
 =?us-ascii?Q?nReNIDkZv7Gf+tcVEnBJpO5lSLwcTFPBEB6RaUwS362MECdxh33ACYeSXSrE?=
 =?us-ascii?Q?tMs+QZehprQ5lVAnK3zHM2iyDNgUk24VABXx1f+3bt3DsInxE3Vc9IRWEwCj?=
 =?us-ascii?Q?yKYR+e2+ZTm6wmYSSI+0KP7op9dnV20I0+LPtKqX+jHlqJdt7k32/Os3TEzS?=
 =?us-ascii?Q?EbymA0obxpsixxzNN+Qoqi56OmGGIx9mA0dCyEEDCurkxmqAGmvt59oVDcW7?=
 =?us-ascii?Q?EnwdBwsUFwNK8jCJ2Ti0oXp8gv6hjLnjAjFXliGVXbHh0X3JyFl2tBK3ffx8?=
 =?us-ascii?Q?4vckRQcMn7BvoO2Wy71h/LmBZnNOqxYxn8iXBYTc2B0ihtQoHQ8n6jWa+l7n?=
 =?us-ascii?Q?TgRDGkJz2hsTe1vQ4Cxx4ZzfDNvdgj6dEkeRcTfudIafvdlwPRkJuI7Xy1St?=
 =?us-ascii?Q?SAbMzwyoYca1vx3xFlVR1jhsjlPpVojnbeA6A37HaKgMBqrOsqcDTkHx8KhN?=
 =?us-ascii?Q?om7mTYSikEL1Iy3olYP97W4Y4V/lUxQKwPq/1/k3bL7LP+v+bbCrlNNxxUxL?=
 =?us-ascii?Q?9JvKJZoe/e+Gws7mGdUMr0PlbzSa7O+QgxCfD3PhjpFDfoGBLYB/FjrjwSVG?=
 =?us-ascii?Q?sSo9ukV/TeYYgvRaeQor0r2p6mqfb/Cp23FsV5x3/29Bsl5eQm1zpm/D62z+?=
 =?us-ascii?Q?x6YsWESVyJ4I1n+uS31VQy+6FqceEWVHcy6HKgSeykegGvuUFskRWbZxfP5+?=
 =?us-ascii?Q?sdpexa5ABpUAMqKDLmI0tjiZK/13LGZbviDpPttOcK5wzaH1nCMRmgIjY3j6?=
 =?us-ascii?Q?ZBkTWX/HRKxloR8pFWvP3fTe8c7Bs+cZk/t7VMPAW53xYBS32z8PP1U5RX2F?=
 =?us-ascii?Q?/6O8oKD5LQg9AD5jKuzW0sab82Cj43krjTrhcimUw0RSIHtdse7d6Cs2C4V/?=
 =?us-ascii?Q?g3OCPdfHC9ixVZANVD+H3X9cz/hoqb5UHOAf0vBFSSnl8TUaNyPHuBFdcuUk?=
 =?us-ascii?Q?csizJiONBlCs+A2CtNczDVE7CURvA8QG6a5G3BS2ud0b5hlHjp5M2OHVoxdR?=
 =?us-ascii?Q?ngDB1bDyQNSKulhrzlMmtfZLuHq2ePjqu3aHx5hdEgRXWKzKkYDrqfnfsReT?=
 =?us-ascii?Q?PzrB0R8ZPrkYy9nLPqvV4JlE5X5n1uUuGVjmRpDnjaPhXzmUEQWYTTC1vh8o?=
 =?us-ascii?Q?qV7+ci5tGBAw+ib7HRT/gUKNm9IKhomm1Fn6PlquS/Gi3KGdUNvGAti7Oirb?=
 =?us-ascii?Q?PAhavzSW+9BbnJFD4Y3VLLkhoA1Uow/B3m/ikSQgKbZnJYuLjfTNmwCz0h8/?=
 =?us-ascii?Q?jnwtTUbNE8yjmtvQl0BEIA84/ScWG8jYjPUca0bSnD6IlftcNZL8X5mVOseU?=
 =?us-ascii?Q?ofhVA7JD+52sNZ8bf2cNvdO6tAYGxikMRR1wekjMwBnFrsHp1SLWBlY8E7JR?=
 =?us-ascii?Q?cbmlqCRyEUcCEqIgWWkFKdv5E54XAbS0JaC43CtDTYptg8ixysoi0lVjQN8u?=
 =?us-ascii?Q?Pff4RfLegm4mQAcSc+XM2Bhv9mJ1fNUitykiI0QWpdW4nKe3cMyz1HT20D0V?=
 =?us-ascii?Q?QrR9N5ADz8zf2yb7sAW6IqFVQX80zNr2dRX0M2WPLyr1BmBERP+EJzJDOo7Q?=
 =?us-ascii?Q?GGKsns+3LNkb/md91LfrRodj3L+GuHWqFkwdGpmDeG0VSl2voz2a/ZEAOqUs?=
 =?us-ascii?Q?98GC3NV8yyZoKmZ/bxfVM/mLc5qmNlZH5rXKg7EzoH+ork17cD86s9SVPxGF?=
 =?us-ascii?Q?n0Z2XMuTzNHcCQC703DB0xuLjqIEpgA=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <62F07288ABB4E9428AA4B5E3E7E74FDF@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7060fcd9-d965-491e-9f81-08da39a4ae0d
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 May 2022 14:34:28.3269
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KsFyLFsP+0ZYw+tcUqlz7JFgdB+4R3hhZYhYrHS+oUpgb6//MP0uvaEZ4cWHuXkYg/sA20nYOempI1FagmriPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3800
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 17, 2022 at 01:32:58PM -0400, Jonathan Toppins wrote:
> Signed-off-by: Jonathan Toppins <jtoppins@redhat.com>
> ---
> RESEND, list still didn't receive my last version
>=20
> The diffstat is slightly larger but IMO a slightly more readable version.
> When I was reading v2 I found myself jumping around.
> I only compile tested it, so YMMV.
>=20
> If this amount of change is too much v2 from Hangbin looks correct to
> me.

Seems to be too big of a change for what the issue is, yes, sorry.=
