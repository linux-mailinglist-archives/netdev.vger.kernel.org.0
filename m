Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C1736CFAFC
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 07:55:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229924AbjC3Fzl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 01:55:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229834AbjC3Fza (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 01:55:30 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2115.outbound.protection.outlook.com [40.107.92.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2907B1BE1
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 22:55:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FqbC19bzizDm0jGB+p50OR9wGVwW3sSS0Rrly3jGAwQglQMcc7JAVyNeZkOPrDEt63WA2dxJVIX3yM/+ejhCG2XC4B9qwndZLbkncud9rA4HFnYwy4HmK7I6L+TB1yVpJa4IG71UR62qOBzsmE0CVVMOnEL0B2yik4uS9qQ4k3wYhePgjdIbB7BJ0AwsVh0/4tPdCWDaPBTwVHLzyUurSB2ADTmDJlKlpbnhiLi/3VHbmT67ZUhjuFsTJINqnISSEqxgL91W9erN82hEDAbH0vK++z0iAui8TlELMaUrpPaSZMSfeyOdhJVKIJwkxnboLDB70GYJRKgnhHYIgLpuMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MFmVTHqdl1N+q3ThSp6EvYotFK5sFccJNk7styGJ1tU=;
 b=Q9T7i9Lp6QK9mz8E1SB2Pjk/+6oAvTOD3JILXaDgJytquib4FIgbVaubusQSdm8c9a7V5xSt0CTR8RSnSg3cPlgCDuTeKR6ni/C5UF2DDjDTbWSQ65zHzVeIXPAb9VRFc3n8dCMzsugMJUodk6Aw+aXEnITVCinBQFe/1/IXFIbVMj0amsPJFLM/JNnE9GPowdyg32oVAEXMC6dYfNvmSeDOxzBlu2vNkvnXc/ZokyO1dsESiSdNDP+HNLSW5jE8ugaeQVuf26voEBXtfC8x8LzJoP1Ya2wD+rSwKSq/CIL9syb6AJ/iGlD+zLARcAeX05zqZqZgDKMsaMg2lwrm4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MFmVTHqdl1N+q3ThSp6EvYotFK5sFccJNk7styGJ1tU=;
 b=QHzhTm+JJ9hICAGWAIus7LXz2BywCHxJ+ApKaz4DD9CaZVhWrVYsSC55wzrzYV1bFt7iRbL5kyfkDkzWztlj+7uw1gixw1dy4hKQT21aAsx2mJJao8A036bIaErb/0jVCZtvekMpfD1Mfb4yAMT1pqk/FppFe4is95o8Tq3zmFo=
Received: from DM6PR13MB3705.namprd13.prod.outlook.com (2603:10b6:5:24c::16)
 by CO6PR13MB6045.namprd13.prod.outlook.com (2603:10b6:303:149::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.35; Thu, 30 Mar
 2023 05:55:23 +0000
Received: from DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::8795:a7ba:c526:3be6]) by DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::8795:a7ba:c526:3be6%9]) with mapi id 15.20.6222.035; Thu, 30 Mar 2023
 05:55:23 +0000
From:   Yinjun Zhang <yinjun.zhang@corigine.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Louis Peens <louis.peens@corigine.com>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Simon Horman <simon.horman@corigine.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        oss-drivers <oss-drivers@corigine.com>
Subject: RE: [PATCH net-next 2/2] nfp: separate the port's upper state with
 lower phy state
Thread-Topic: [PATCH net-next 2/2] nfp: separate the port's upper state with
 lower phy state
Thread-Index: AQHZYk07XTN/U7MQDkW8TxKgBUt5LK8SI4YAgABrcdCAAA6tAIAAA8MQgAAE5YCAAAReIIAACScAgAAdH5A=
Date:   Thu, 30 Mar 2023 05:55:22 +0000
Message-ID: <DM6PR13MB3705CA9B36F8B14C4F5E961BFC8E9@DM6PR13MB3705.namprd13.prod.outlook.com>
References: <20230329144548.66708-1-louis.peens@corigine.com>
        <20230329144548.66708-3-louis.peens@corigine.com>
        <20230329122422.52f305f5@kernel.org>
        <DM6PR13MB37057AA65195F85CC16E34BCFC8E9@DM6PR13MB3705.namprd13.prod.outlook.com>
        <20230329194126.268ffd61@kernel.org>
        <DM6PR13MB3705B02A219219A4897A66C5FC8E9@DM6PR13MB3705.namprd13.prod.outlook.com>
        <20230329201225.421e2a84@kernel.org>
        <DM6PR13MB37058BF030C43EAFA45DE4CAFC8E9@DM6PR13MB3705.namprd13.prod.outlook.com>
 <20230329210048.0054e01b@kernel.org>
In-Reply-To: <20230329210048.0054e01b@kernel.org>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR13MB3705:EE_|CO6PR13MB6045:EE_
x-ms-office365-filtering-correlation-id: b33e8d15-26a8-4b5e-c333-08db30e35a07
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: igJPMcaQkpx6RVLZKr8gC7QNLGDtojSera97Hc8UHAU6aow9EXPCxXJ4sMr15p+5EwLwdN250wDLJcZtmc2rkIwbWPC969t4wXSuPv8aZ+KDamj3Rtq5TzN1UHWB8ypdrrdo1RFpsyqesZZmTWXG7pVynHSeFS1G5lyGHR0BMx8spk5XK++ryVAD0V1Wwe6pcCqEHJk+Q7LidXCS/wd8NEIzBBz3ginXYY/034NqkCw6NBbewdRLJq13dpQAvx98DkeTxpJpKxrS26h8Mv/sfPbSzE/nMnpQWB2EeRhAk/LDUfIqV2wi46Z6w1DRhlAN8pvAThUC/X+lOPDtxQB6YQSoridw5VnJaNlNtZsLTGZf/DXN1KF1TWrlOsQgj8kgSvf6BfeNpbtpH+3wGlq3upUPcZWIdMWMzNdx+k8tC7/mfsFtgLxKFgPvmtHU5d/v3VRpQ8oDjyAqxNy8wBeA9teCOqeJwuUDVOAb62tgoUi3mphWdk6U3uR7u8wy8qQlAbPJO9glMOZbzOn/plCa0Xx+uqEhQ/C1bBTOLnas6QrelDpZ0ljz1pZ5B1IkoB13La00akbh3r9MFHKAYinznM1PsR3NR2W+L/CzRaw3UcFzN9QxCb2HKHDo06U8kEAvjNLBTUhE/txY2l7RXp74lA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB3705.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(39840400004)(136003)(376002)(366004)(346002)(451199021)(66946007)(7696005)(76116006)(107886003)(26005)(54906003)(478600001)(9686003)(186003)(5660300002)(66556008)(2906002)(71200400001)(86362001)(6506007)(44832011)(8676002)(55016003)(6916009)(122000001)(41300700001)(64756008)(4326008)(8936002)(66476007)(38100700002)(38070700005)(33656002)(52536014)(66446008)(316002)(4744005)(20673002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?GsFX2DaTp8jUmRCbodus5ztFbOCntCAhkmWOE0b7nnEBkFbAdr/4UL6juLLY?=
 =?us-ascii?Q?5Zdk2MRSU15rFTv0fyDc/8lYFuvxdBA7ef8qkgILflFqP59bjKofvE0+tVB0?=
 =?us-ascii?Q?bwe1tObKBBM1rw4yn+mEUDajoASRNZ2MKOO8DketVNn2naGmG2fMteMB42Lo?=
 =?us-ascii?Q?Iu5C/UxmYzBbnU41Be25Kvyol7aZRvKCIhsWzVo07LFDYKfQJxYwwqqjEDIy?=
 =?us-ascii?Q?gQr7pis5YRCwZhue6Qt36RCjYipdXg94LDKApbvRNmXaiq0jsYuYsgBKZ0yC?=
 =?us-ascii?Q?e6kNqrTr0IXYyFrNGP/VunYrugscGuh9sHS22+EVL2YvtpnMc1Gnwckt/dqa?=
 =?us-ascii?Q?AWBGB5bIScdkO/6uBUukaQaFK3MOPakcWXjQjol7DrTL+fw8mo9vDEOVaawc?=
 =?us-ascii?Q?CkUrtnfR+EUep0bJWuBR0oHHJ34FFuu0LFcmvWGbGDXwhhlWkyY36KO/7xO3?=
 =?us-ascii?Q?UlamUzNotyhHMJJsozuWVpjSF48vtCGixnnmwtT6+Aw25/TumZf5KmD/R4Cd?=
 =?us-ascii?Q?3goMY2P8MUdlC+n8H+wr6HIRRTFSCHdI3qX8lZPoQjuLIy8O6O0Rb4WqUsRc?=
 =?us-ascii?Q?CE7/14zmf9R7fyAk0qVG957E8bvFMAASJHYE7VZB1wac1y5GsmKUgYNy774g?=
 =?us-ascii?Q?Z0/4s0zr4lqAjx/DXkGfXq3TWIPRWDXg1orkrdYud8MGK3oBCEWo2DvuMCaG?=
 =?us-ascii?Q?WH+MnIpARXQvE7seLHfkiQ23j3aZar6Elxgvj1J9/0+U+9U9UncvWg+eE0jU?=
 =?us-ascii?Q?AC9C0qiIRTiOF+2qc2wgzotAHm2N/GOoTUBD5AmLjV8C4/T632pKbYJ0mVO+?=
 =?us-ascii?Q?GJgW4htVl9cA4fAnTBgNnE+02kHnOxvcuRQdZo5TLzxq+XH2Dyg2BabOq+5o?=
 =?us-ascii?Q?hDQ/ddlSS29gEHfXYZpJw9apsGG39ZfG9QFrBxtRkzmSJlfrKntmpO+HL/ZS?=
 =?us-ascii?Q?HXgGUjiiXZzX4ZxywDQYxLXdDxG6j22ifVvTV7ghSGRfY0mnlKTYRFDa3moa?=
 =?us-ascii?Q?1CBQwLhZ0uOMk+i5eDDdrT2gn5D2Gz0ygFVZvFRsm3E6q8GWpyDzpqdmyhk5?=
 =?us-ascii?Q?25AuWoPh5FrQstZs77sqCV4RaDYQM3oTfcbc2gWoXQod50HvGKB1OiWTSUQf?=
 =?us-ascii?Q?qW0wJxVRofAECAD5LPevzYblDkF2Mo4+LO3gogpodC/T2jUHdHqFv3i2axpv?=
 =?us-ascii?Q?HuYFbhjbTgP+3R17pmj7XEkdrkhbXA8PviNwuGYK00ZqkYOluO7xCEZmgK+I?=
 =?us-ascii?Q?LSMjdm4oO8xzJB9gknEPgZQC+3zOnPA5lzLaS49AtIrWgeW7fa5Lkg18UzxM?=
 =?us-ascii?Q?icdxEryNRSKXekUaX5XWkyTnhMglKuPUMGnXoEJH3Cvp454x8K6O/G9Jtst7?=
 =?us-ascii?Q?n5v+RJmyhkhVzz3VwU6WSgQQTXB3V/R/e8k/b/9lPc16Fav8K2ja2oLu9ZvA?=
 =?us-ascii?Q?p1w82Nq+CYt1H1gcAzRBwzsEW0nf4it2cyHrwk8CncQ3BzAIF1rUAXrjrhAg?=
 =?us-ascii?Q?3lrJ2t1FBBPdLmz0YALn/77yXISRZcNshTtMZTROP46GXwn0WRJzJ3YW3OPy?=
 =?us-ascii?Q?KmgQ8rq1LLTdQrfHvQ+7xBI1apmoUB14S0DGY544?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB3705.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b33e8d15-26a8-4b5e-c333-08db30e35a07
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Mar 2023 05:55:22.9194
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hQG36OduAHplMV5r3Iq1tiwYygWXht5cYXtDCT/DcJIXB86QKGqTCI4fLBbXXHOZZIvAZlcZwRXL2fRxQLY/mjoecwUTHtoqnz7O9P0lC7c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR13MB6045
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Mar 2023 21:00:48 -0700, Jakub Kicinski wrote:
> On Thu, 30 Mar 2023 03:33:30 +0000 Yinjun Zhang wrote:
> > > Why?
> >
> > I have to say most of other vendors behave like this. It's more practic=
al
> > and required by users.
>=20
> That's not really a practical explanation. Why does anyone want traffic
> to flow thru a downed port. Don't down the port, if you want it to be
> up, I'd think.

Here it means down in netdev layer, not physical layer down. We don't
expect the host to talk outside through a downed port, only allow the
VMs that used VFs to talk(it depends on the VF netdev state).

>=20
> This patch is very unlikely to be accepted upstream.
> Custom knobs to do weird things are really not our favorite.

As I said, it's not so custom, but rather very common.
