Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB3BB531A1C
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 22:55:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229700AbiEWTVd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 15:21:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229773AbiEWTVE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 15:21:04 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2111.outbound.protection.outlook.com [40.107.20.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C47E6213F;
        Mon, 23 May 2022 11:56:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WyzGlQY6WFn9XzcEE6Yj8hDV+J0lIC8XlFFsHJsYxEo2uj2MXNGOY4YuEdUMsV3seqDERc4cHQs6mR/Gk2QvAxUtwqc6GZfNqJb5ZI5By9JjDYSxiSZZhaAk/FFWHUXxD/UenhYbojYJpVQ9z8IBeNWTLQnqTqoYMOILt7a8j++WhTEN46UraHc69FkM0xlk3vCzZjClJGA7EynRG8I3feO+CFi8QA9ajOWDsG5oQ1Mq5IQTRzPpN0zAql8rAYi4FgRd3BYkxHENVdYh4c1WR+0zK5b4ZmZewd9WsGvevEyl1NW9rrmaLh/mkJ+X32dw4czP2aj2B11M4BUwNCj87Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gQ+erAAGhfeYHC9CDVTxlzK4gy2r2DKjrV9I7RIoy5o=;
 b=QXlS6LQAJV5oFNDvXpxrrWx53psowIx9cUX4hyxdNt7MbP9uL4F4KzoF+S2wJES7O8Tc8QxrXFPc1XHM4wfR08JurP7PxTAQeioSNPanpjDzHl1umq/Y26iUTSKfalOVHgUof+qYO0hGWB2o8vsaJ9fU9uKFRXZD5XT/Lw1IJ+8o/X4VsZh0eGdakw5Ry5GuuLHuoYIKsNQyVR0/8YiMtYooI0Og5Hsj7RE6t2qicV2ESk65sK5uD1kWmiMl4Ppc//SNs4azUbV+ktUS7iPYZ1uy4IyEW2WPJb1i9/gX2TmXldj+wXYiIDL/TbXjGIZa1+SXmrzfnl9ltxZUWIRJ9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gQ+erAAGhfeYHC9CDVTxlzK4gy2r2DKjrV9I7RIoy5o=;
 b=jagJRce1x31qdOxow2hMgnqIUCB67UbFjgUwQXTdgO9hEzL+5C8qi14RRD/vKcI6Yb8fpf7XjG0o6/gySHd/RAaDUTXClRyUHyfXHMHjJE9uDVmSkw2u3kf8xq0gcwZhS8q5/yI2s5DpSBGn7FYHcvZago0oAMv6N6tkQAXqMac=
Received: from GV1P190MB2019.EURP190.PROD.OUTLOOK.COM (2603:10a6:150:5b::20)
 by DB6P190MB0248.EURP190.PROD.OUTLOOK.COM (2603:10a6:6:3e::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5273.18; Mon, 23 May 2022 18:56:26 +0000
Received: from GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 ([fe80::b51c:d334:b74c:1677]) by GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 ([fe80::b51c:d334:b74c:1677%7]) with mapi id 15.20.5273.017; Mon, 23 May 2022
 18:56:26 +0000
From:   Oleksandr Mazur <oleksandr.mazur@plvision.eu>
To:     Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 1/4] net: marvell: prestera: rework bridge flags
 setting
Thread-Topic: [PATCH net-next 1/4] net: marvell: prestera: rework bridge flags
 setting
Thread-Index: AQHYbtU23bLV92Cqc02oMy6D9cy/ma0sz26/
Date:   Mon, 23 May 2022 18:56:26 +0000
Message-ID: <GV1P190MB2019161DB961FE1EC006C478E4D49@GV1P190MB2019.EURP190.PROD.OUTLOOK.COM>
References: <20220523184439.5567-1-oleksandr.mazur@plvision.eu>
 <20220523184439.5567-2-oleksandr.mazur@plvision.eu>
In-Reply-To: <20220523184439.5567-2-oleksandr.mazur@plvision.eu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: c4b948fe-6c5c-5c42-d500-56cb467040b5
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d70110aa-1b89-428c-fdda-08da3cedf045
x-ms-traffictypediagnostic: DB6P190MB0248:EE_
x-microsoft-antispam-prvs: <DB6P190MB024840B3A79505DCBDE30959E4D49@DB6P190MB0248.EURP190.PROD.OUTLOOK.COM>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aPGtx+KCMgidzGq+0jBMXe/4CLc/VVPRf+iX2JtdisuivqBeKBCFxjjQnY0FpVYofaAvh0lxhSTdAsr/GyAEWurkTwoTiVdWnbca/dUkB2T1Ur71UwGfXp3OGwIdlkTZqke/ro0Y6csjlPCM+AIUDGCLgwU6UsMCiIeMLZZJPbesAdt7nQeuFA8G6H/aS5RizvFyaq802ACIklO9xNO+5auDKFBS/ZAQgPa2f3+AbO0Ccby+7EHsen9iRhoU2XKyJjutrXxVRFtuHIqiT27QWIAvFP0B6Q5ruvmSr+yaKbR7Nokizo37s0QS4Kx9o/GmWOdYFrrnPw5/KyCswmxvNVY6e2RVo5I1pnHEMNEpwgyuylMeCyxMy72VaAu4aFeoIzro6tm+gc+Q+saWUTmGR3LuNjhgzcPYaE+Uk7I3X7JnmKB4dW64aNEwIqvXDEAIAqpwS1DjR2I26ojdjKtU0+RrMbUEV0lLfPAugGBXfz/B9oZj2RbsHmCgRXPC/BetYtM3YjTNUtjU4JtiARQKQBF2aULZ3fpAMtXGK15334BE5NjJCcPjFVmUny/lB8R4TQUnmToTmLIh9qm8+JmaoWKiylmtXYXyvPv8dsC9jQYGs3XpSnIJLDxC9zeaP9KMTMnsjIc+6OctCgL1GJUVH6CkomlaqipkGIBVFl/HYkzFWrC1GU0QYBHQXJZ+oWu1
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1P190MB2019.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(366004)(346002)(376002)(39840400004)(396003)(136003)(8936002)(6506007)(7696005)(5660300002)(122000001)(52536014)(4326008)(91956017)(55016003)(86362001)(38100700002)(66446008)(316002)(66556008)(66476007)(54906003)(71200400001)(38070700005)(508600001)(64756008)(9686003)(26005)(110136005)(2906002)(41300700001)(33656002)(186003)(8676002)(66946007)(76116006)(4744005)(44832011);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?iyva6PIUX5UAi9MbBjDRTKYh2QmUF3n0YUWd1maFBKiKukjb/YcbY5lm87?=
 =?iso-8859-1?Q?ocSbWSkOnA0h+Wr0mm5ZBy5qgg6JWtAklI2erjXZ3qkY4MfPJvDxMRpS8U?=
 =?iso-8859-1?Q?9Dhb2Paeyq+6jVHevupxgHTfg1tBAJBoqckum7ScDs9bwggMQALhrk/8jD?=
 =?iso-8859-1?Q?n7b6mw3noib35oyzGAcUsVkjveWSpKjajrA4T8kQ5RohshYHJi6rEYArax?=
 =?iso-8859-1?Q?5cV4MWopVLt/mtb4QPXSmOOryR/hqEQlrg5LVDeoyM3CUKzgzNu/fB3tq6?=
 =?iso-8859-1?Q?z0HRgR0umd1g1NtO/CRAiisqCu2LEmsRfmv2S+3dHLzeNWbXV2eQ4vQ+RE?=
 =?iso-8859-1?Q?UFrkE4M/ZFoExwMK8W0Wy4NJ+X8Y8pfV9T4JYmFgXmlgUf4AVreSi1pRzZ?=
 =?iso-8859-1?Q?71oxsLTiZzO20Ysb6NH3dFcOJgjlgII34/ry5h1TqJlBxdNN/uvIHpRSnb?=
 =?iso-8859-1?Q?UOPowrg5qZzF5NcqvLOah1dihlM0/nrxQd2eREReUYaEZP5aKbm+PRwG53?=
 =?iso-8859-1?Q?gSdZyAbWLV6NCb3MfMtD7V2W+z73ikgjZWgmJlt45rUaT6L4Osl3F8ylAQ?=
 =?iso-8859-1?Q?e+huOxZaDYd2lUliPuXXRz83xDvjVWGDuvU0Df/seDO76ouhTRScUuOVS0?=
 =?iso-8859-1?Q?UlvQCG3v81Y44HDtzk3pkDJR+bED9zL5RQpWZzrtIvtiRtSBQpWDx9ifX5?=
 =?iso-8859-1?Q?vgA3rbuzRspQU7QKgmazG4MhexGDzE6ova2A6RhcmFLW82nxA9UbWjbRXU?=
 =?iso-8859-1?Q?rxzTjOemyqPPbK76N1dv7X2LgvrzhA3Mc6ST0Nhl8aJSvgjvHvYdDDjOm6?=
 =?iso-8859-1?Q?onhLpbk2yeaW+AFmDtxB+EuB/+tNFfPqeE5CSnot3PScBSrcAvQtLX1J8F?=
 =?iso-8859-1?Q?pcNfYijNmlBuTCdACeGoRD6mfA6x9JoMwwBsuJiIJdHqplsbBdxVGNir6p?=
 =?iso-8859-1?Q?U84hNZX0bU0rnmOQizvpkJ0kr2L8njkMTchCpuUL3YlJcQkqxaYFAn61Jf?=
 =?iso-8859-1?Q?IlwjE0N26mwFv+3qEgu4vppNy9moHPyf7LXJ7sRytz8oPpW4a44JJvsVSB?=
 =?iso-8859-1?Q?8gb8z9R8YssmKrKIcMdQmmt6R2/03rxyBPxxvo/IM4/Z7+WSaNgHXat/aM?=
 =?iso-8859-1?Q?8Vyj4F1SFjX+tySDAlRPh5TdMNWspk8XbRPsWaY17uFuGeaMRTl36q/zQr?=
 =?iso-8859-1?Q?CQEZiX6aK3cG0bL4uijc/BqzpEDkOxTFb4R+Z6lIUZNzegBOynx/VMcwj0?=
 =?iso-8859-1?Q?3+/gpBKXwyU8X0Ok/qTCp9WnmPWYR0GMnwIX3M6DrUrkNmu1qTkZUqpbqN?=
 =?iso-8859-1?Q?YjuKo0QhNxuW/syIE91Pl23TKMQd1nuzCCqEhbYLBp5oXvuVapRCfwKYpF?=
 =?iso-8859-1?Q?mO3VVskJ6O6efeBw/vX/uuJgOb1Y3FfF8jMb1FuXJwyWMJDRZ91Zj2hVrU?=
 =?iso-8859-1?Q?KknkeLN1/C6fa4D8FqTShgxE2TQXf37I+/OVXBOApo0me3MgvAl4rG6T+2?=
 =?iso-8859-1?Q?EK5HHPaFUdt2Ak18BbuwyPslidJoGed56cmC4J3OfslCcLbU5pXXzY43bS?=
 =?iso-8859-1?Q?MC7i5+lOneQ+Sv8orMrFQl/++3W4hj4EhnpYxKvPJnlyHQAiisO9bedGjc?=
 =?iso-8859-1?Q?0k1TYtKuo90fPdjdatb2acxoZMuR8oiW55FDsjIIyGFQkSayWiBDUEl5HI?=
 =?iso-8859-1?Q?oXYIVNhfJLEdx1k3fMSzR7BEjBl+sWehX04WSkp5C6dbrtCux4PmJp/z1q?=
 =?iso-8859-1?Q?j1LwZq8aU7ic8/Yl54A8EJOClOUsafYzIcb101cIp3fAy6tpArqghnh8r/?=
 =?iso-8859-1?Q?NJanELJCIA=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: d70110aa-1b89-428c-fdda-08da3cedf045
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2022 18:56:26.2068
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PZbBVYJzO+FhkGsKXCcVsip26L8BrIP99S1l9upXnnHxEZhFHn4av2d9hUEi49+Tgk1Mxz/IyU2VYfQKBMpxWNyfGZFgMvbeQSl30kOEcGM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6P190MB0248
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: [PATCH net-next 1/4] net: marvell: prestera: rework bridge flags=
 setting=0A=
 =0A=
> This patch series adds support for the MDB handling for the marvell=0A=
> Prestera Driver. It's used to propagate IGMP groups registered within=0A=
> the Kernel to the underlying HW (offload registered groups).=0A=
...=0A=
=0A=
Please ignore this particular patchset series as it's incomplete - i've sen=
t it to public by mistake, and will send an=0A=
actual - V2 - complete patch-series that was meant to be sent out into publ=
ic;=0A=
=0A=
I've had a script that added receipents automatically by mistake, as it was=
 meant to be a test-out mail;=
