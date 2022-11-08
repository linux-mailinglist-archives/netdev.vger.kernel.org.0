Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A209620614
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 02:30:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233587AbiKHB37 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 20:29:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233482AbiKHB3U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 20:29:20 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2119.outbound.protection.outlook.com [40.107.93.119])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DA22D88
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 17:28:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b33X5CaYN5oZi+6Z57oHRPc0dqmA82c6xQQQE9iTEhu+FTH3Afz8lUsEzZXP9Z+E9FUULsDwzHXToGrEUPPpCLqUsYp4ObSv0Uckw2aNa40hFD8DZf9hV1Rsjl2CxWPPLPVLKKXnwUUHBB7Q5S5UBQuzL4zkQ3b9XYcREx9dnL0FCjmg3VMZI95NqHU8RyVJR6UYTkT+h2MGgQwEroxE5eTm8fbnKU+jyflx+5mNuOUBmpIxYgXBmV1SwI8GCTQK3iSY3u948AjMjKCfHmCAIiUVcmGQLAZV5QMXBFUxiym3KRm0DbHLhA/G8xmphQpuSoly0uuHQ8AtAGXvfcmQ+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tfsnp3O/W6QRwxS2GKdSApQEI8YyJrXh6XuOs1ajFzs=;
 b=lu0z1dQ/vpMra0hMKwoCvoBZOCD2FJAaYxivX5zwADi5/mFE3E0GmDeQ1lsedi5T7B2R2UFmLAp5nwF/mosN1245VA91jCNlvoyFcshgujNudDsuatwXK1jmB3G5cnXTqcbxcMj0vUQSvugGDhCSMY2hLjr9LgwzBZYle8AcgJHYlpfom/HxT8DFfAYZ2ooMl5bpYB/JNLwPz8m8PG6gFR3hMGc7TtkeNmDz5GeNccdZq59EUIh4CI+zO9zQlJH3p9lbfQBmmg2bfj9uI76zBKVCXNJLWUniUsumTRhhGS52GRyzQldz/l4+jEI0klhrbS/heM7IhnIX8I4p2sk2Ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tfsnp3O/W6QRwxS2GKdSApQEI8YyJrXh6XuOs1ajFzs=;
 b=JgsdwUv58X0wjuesFoXDcm1PqNdzPQ23SSLGzCifCverPpIfdcQFvfCJ3rgLaStdyBxBg87ZQjCrQygOP4Rqu5pkqISGTtWNm0GDO7f6dV/gCBYQqMtWRlrZCIEocxEMpsC1Jibzh2PEBfb7JtW8nNXLYAXoTfF0bFDWbGZ7vtE=
Received: from DM6PR13MB3705.namprd13.prod.outlook.com (2603:10b6:5:24c::16)
 by BY3PR13MB5009.namprd13.prod.outlook.com (2603:10b6:a03:363::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.26; Tue, 8 Nov
 2022 01:28:20 +0000
Received: from DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::3442:65a7:de0a:4d35]) by DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::3442:65a7:de0a:4d35%9]) with mapi id 15.20.5791.025; Tue, 8 Nov 2022
 01:28:20 +0000
From:   Yinjun Zhang <yinjun.zhang@corigine.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Chengtian Liu <chengtian.liu@corigine.com>,
        HuanHuan Wang <huanhuan.wang@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        oss-drivers <oss-drivers@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: RE: [PATCH net-next v3 3/3] nfp: implement xfrm callbacks and expose
 ipsec offload feature to upper layer
Thread-Topic: [PATCH net-next v3 3/3] nfp: implement xfrm callbacks and expose
 ipsec offload feature to upper layer
Thread-Index: AQHY7eGMPasXy6hiXkqW0Y9zNHZbuK4zBIsAgAA10pCAADY4gIAA1XVg
Date:   Tue, 8 Nov 2022 01:28:20 +0000
Message-ID: <DM6PR13MB3705D1657D48FD6C31753E04FC3F9@DM6PR13MB3705.namprd13.prod.outlook.com>
References: <20221101110248.423966-1-simon.horman@corigine.com>
 <20221101110248.423966-4-simon.horman@corigine.com> <Y2iiNMxr3IeDgIaA@unreal>
 <DM6PR13MB3705DADE119F1895CA27EF9DFC3C9@DM6PR13MB3705.namprd13.prod.outlook.com>
 <Y2j81dBpMXrNqPER@unreal>
In-Reply-To: <Y2j81dBpMXrNqPER@unreal>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR13MB3705:EE_|BY3PR13MB5009:EE_
x-ms-office365-filtering-correlation-id: 9e7e1ddb-8ac7-4cd3-9ee9-08dac1288560
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 62jE7H4KcOmJWRJZg+oFLSXQ0zSciAK5toeKl4hknzhjB+anz4X5A9oJDQ20ZRQOdF2QFnK1RE1U72SANgUH7/DlfX8ns1Vgd6XPpLKoL9C8Hgq/zgYzgr8lQsX8lQL2nlML6V5/MnMqBtHFDgcfnHxzkO7sQz5N+ES5tu5+67JsnHr6WU/DQNf3vn4A+xPJYvTiPHbcgRSwnbd42jVDdwjLdzDI34vjFyr9z5MVHT0HgrAFYn32+G484TM1R8xfM7je2OddXwfwx7EITgWNHBA4uHPOyn/GSAOuQb0sd3M93AG0iemeidDnlLUHH9G/4/g+lPsIfd6yk2FRqHVFQgrSIWlvdABYnrtjnPtg0x1bMbBsrAltamkfhPKR2A2EBa2nKsN2Rs9TQ6wOVo0aCOjGIbHT9u4yAIYEI3TdJAjau4M2cFl5+znsdDa0ewP6En6PEca16a5GnWxAx8DSkIXSDcTZzf0Gn9yLnltNW/gGSbkndBtfdOFXVCOc+6zAdNl3RCR+QWsdvChXM5xAl2vFqqzbzDmmRJ9Cu51h8TqqG5BJHmACXjI7Y79H/lrAk58DCb5ly4GYCj4jxfkzPPks1Vdt9g6pK2AnHhoNs0fsMsgqxS4ipzraimOAk6iCv0FOObi/J+iLKVsxqxh04pci5BiYtqi7P80Sg/qIbH+6geStQRPmzQl40Glbw+Xx1JDr2GqRFaVUJPQb7BG9/VvfbulmjWCUK3eQ8kokkuTFTokfOaoqTa4OZpOLlxL0n/TfGILqdP7zs6Vwp2vCO/QDWv8Ki5f2I8MgLomPmdUl8hSxHfIlWtAjY0xQ6Vdq
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB3705.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(366004)(376002)(396003)(39830400003)(451199015)(5660300002)(8936002)(52536014)(41300700001)(4744005)(38100700002)(76116006)(8676002)(64756008)(4326008)(66446008)(66556008)(66946007)(66476007)(2906002)(316002)(33656002)(54906003)(6916009)(86362001)(38070700005)(55016003)(7696005)(478600001)(71200400001)(107886003)(44832011)(122000001)(6506007)(26005)(9686003)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?WUwlRhN/Dt5mgjv9J0N7fJiFJ2M+e1TtLMO3k/wFp94+RF1oVcMtf1QGoiS3?=
 =?us-ascii?Q?s86RC6mPJYYKwS0kGBk+iD031lNolvaWZT3bI21qMRTVHBOKT1Fp1BAzBK1X?=
 =?us-ascii?Q?lIkaq2hTUFSHuiOo/RZbuHoM3u4muSMCTCvfgWqz9niQX1Q6RW+NeVN74Q3w?=
 =?us-ascii?Q?nXUNNTVTMoFC79BQJaOpBS+BV830840PugfnzkovmITAR+h+D1O0f7gEe18G?=
 =?us-ascii?Q?LX1Zf10SCk+s4AJqklQG8QzLNkMjxtc3Ow1V10XOLC/fUG7J8HvVGi7m/e9D?=
 =?us-ascii?Q?01ctD/aZdncRWft2TFm7q9+ktnviOmhAXrP0W7siubv0j3/2lW56QrTOUNqX?=
 =?us-ascii?Q?S8tqSZD+Fc+Pws55QsY/dvb9IebxUZ4vWcS3O1OnC+Otv7yfb/9FZFARLtqb?=
 =?us-ascii?Q?SxA1zgt4KAtke1cJ1X7zUwgVsZ0HEyd9lUNBziSEb7iKVwkYKHVreCr7qTK0?=
 =?us-ascii?Q?bbahPDDDiMqxPLNucVC/ByoqmCi5BRJ3P8pnz7jM6pdOOFFDp5x4P3IgEqhh?=
 =?us-ascii?Q?HR5DYQHRTSm3VCnD6eM6dMMbmIbWxn1Y+1JrdVe1Ns8sfx/X09YTu5gDCAPb?=
 =?us-ascii?Q?RJEdA5jV4Xamj+cP71JnsU7+XrU+pDenG5hBqjn4BYcOG/eRl0BFfiairpej?=
 =?us-ascii?Q?YbW8RWBYFa/TV6uEba+RKo45hKuTXN4hMItbjFAoE9uAjdPR9j33qjlVHIRf?=
 =?us-ascii?Q?l+R/6e3N8RsZh2LmbvIA9rhfCF0v9teTRDBnZIEyZCBtV1VkSwnaWLjMG8K3?=
 =?us-ascii?Q?GVTbVUV0kd6YbHOO42pNmut56rr98fOAetVy84VbVtY9gRx2jgHCSK+6P4MT?=
 =?us-ascii?Q?+IMzCffr2JkCGntaqvSXdkU8Pkn/+3MRKFKLq8J7sk6E7LHwcMX0BnOc3GyW?=
 =?us-ascii?Q?3ONR3oeZEXSJ8VV/8bhZlNCcSvoDCSyOXJWW/15Ojc9j6n91AIsXb/3WQKcf?=
 =?us-ascii?Q?BYgvBCKFK11nZ4LtoBRElz3J1xG4RuSCaiyCpfG19BFOcdWrqoHzBgxix/7X?=
 =?us-ascii?Q?7ZRRjZ7goz3MNxYoywDDtCupgeKnJFHTAbMQ+O5BMniXgSfNoaV/i+zHQean?=
 =?us-ascii?Q?BpxR6gK+MQDk/1umTHbHCVXnczfnRquo1qiCXsUqFJy/tx7jC6TYalpixBmf?=
 =?us-ascii?Q?UJKsgng6icQNX3crFxMi4u35YsZFiH+G23kUintNSAHi/IcBkus0N4Phmxmx?=
 =?us-ascii?Q?Ul3MEHL23ccCSo4DJiZEXU+OJn/mBqxIJ8Wm5dGnW0mfzGp7ji0O7FjRh2tc?=
 =?us-ascii?Q?JPi2kOb/GQMHylFabv01fHeNNCKcYCtCA/BvRKPaxAojuoWB+Yxbkol6BmJR?=
 =?us-ascii?Q?S1530+8UNtvna9XhF9W3JymD4nOZ3alHDw7bnbEThjNdBTrlYAvnr7DVcHy0?=
 =?us-ascii?Q?0lTnjgYh/HvxAuQ9ynqgaGD4mE5DeTWTmdeDX7UAvfupkZH7OTWgY2HyJPlZ?=
 =?us-ascii?Q?xUO+fgC6BeZP9lAcieNGqgD/plSOYjkspR5okH/d5mfckk3p1Y523x+JRCGQ?=
 =?us-ascii?Q?jgiwX/LqpMAh+W8yy72D/D2p814OcEc5Ja87lDjpopbxv4f9Uvu+6VS3hAvO?=
 =?us-ascii?Q?dBupVCmO8yBzRaM9ySu35guGlK+YTh273heTpTgX?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB3705.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e7e1ddb-8ac7-4cd3-9ee9-08dac1288560
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2022 01:28:20.6588
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: P1eWxcSNraEkCO1bvBriozGFsg0+Q59566zcCqocSUFGpdoXUnr3GH0IRNPNRJK4uY5hBZneAsMrHrAc49i+WpK1KFx9tVdKMRngNqydcEc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR13MB5009
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 7 Nov 2022 14:40:53 +0200, Leon Romanovsky wrote:
> On Mon, Nov 07, 2022 at 09:46:46AM +0000, Yinjun Zhang wrote:
> > On Mon, 7 Nov 2022 08:14:12 +0200, Leon Romanovsky wrote:
> > <...>
> > > > +
> > > > +	/* General */
> > > > +	switch (x->props.mode) {
> > > > +	case XFRM_MODE_TUNNEL:
> > > > +		cfg->ctrl_word.mode =3D NFP_IPSEC_PROTMODE_TUNNEL;
> > > > +		break;
> > > > +	case XFRM_MODE_TRANSPORT:
> > > > +		cfg->ctrl_word.mode =3D NFP_IPSEC_PROTMODE_TRANSPORT;
> > > > +		break;
> > >
> > > Why is it important for IPsec crypto? The HW logic must be the same f=
or
> > > all modes. There are no differences between transport and tunnel.
> >
> > As I mentioned above, it's differentiated in HW to support more feature=
s.
>=20
> You are adding crypto offload, so please don't try to sneak "more" featur=
es.
>=20

No sneaking, just have to conform to the design of HW, so that things are n=
ot
messed up.
