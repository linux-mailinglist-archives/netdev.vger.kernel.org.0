Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACCA55E9975
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 08:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233354AbiIZGaL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 02:30:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232759AbiIZGaJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 02:30:09 -0400
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2112.outbound.protection.outlook.com [40.107.114.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 125BF17E2D;
        Sun, 25 Sep 2022 23:30:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YfAyO/ESM7YF2gLsVficMcyS3XEXqs3q0KZYr/9ONXjzRtpylXGK6RODWjPA+uHPKnpyWcfQ15FNo+jOFcytkJCzSM5vE6LzA68ngPl6bqo8cLutSd6oAY9RtZGFuPksU5eJTEZ9cShdc3hS1nYLKY+niwtAYAEjHAtrFVg8GVcXpl2CZaW2ePxrXoL3tWhTtZWDfJAXX7X7XGD2A+xhD2kOs/A6DIhkfImCR0oBrQoZhqBcA0PweM8Z8dxVOLY25szMIiALmyRYGu6E0CmOI1QrUyX2kbiBnoEF4W67/0rwgZ7ansv4CHhWvsEjEI/vsyQFd67tSMZqtlbXRA4msQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5lAYIThU4EXZPrHLjMvUJn1nW13PzdzCJU+YJMiVCPw=;
 b=RrwpivqUf9deL32qwIRfEKwC+vljbE4tMmKuY4kfW4jwEdlWdYA7Bj9lrRHIbpQF+1f9dkFxa4vFo0n9pfLB6awOd30L/02HFbU3isZ6Aj9Wq5SGn7AS00TaeuXQ/d9/Py+Y97R5ZkNU2GJUpwIvTEHCJUDgFmWXS2Q4F3heWvuwho+ssiKdB8VwpFX2osdIHBexwKchUPHpNoEuf9dK9ZvZL2jp0mWsEyfxaDZR1b6FzLLoBBaLRWszwQrFfKGJBtwVBbH6PjZsJj3eBGnICRxN5CJctLpK0S+UVBwv9AgMRN5zlPmZcuDzweIxLN40M4LVRDgRezGtNZWxfvX+Xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5lAYIThU4EXZPrHLjMvUJn1nW13PzdzCJU+YJMiVCPw=;
 b=owvS/boncmRD0VPltjwDGwhM47FGmcQJCVN9CNA1egu8bMHJzKId9Lx0e/77GUlTzM8dMm3XLB3T+Udi5rkDoeH2oGeTMH3vN4K01I8xOC2azR6jflFqMqSpmG3XRha9fqzFtVlC95GsFBz5jRcMT2coVIg6oug0T14PgskhhY0=
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 (2603:1096:404:8028::13) by TYWPR01MB9710.jpnprd01.prod.outlook.com
 (2603:1096:400:230::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.25; Mon, 26 Sep
 2022 06:30:06 +0000
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::2991:1e2d:e62c:37d0]) by TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::2991:1e2d:e62c:37d0%3]) with mapi id 15.20.5654.025; Mon, 26 Sep 2022
 06:30:06 +0000
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH v3 2/3] net: ethernet: renesas: Add Ethernet Switch driver
Thread-Topic: [PATCH v3 2/3] net: ethernet: renesas: Add Ethernet Switch
 driver
Thread-Index: AQHYzkQbCGZNTw1MNUuaNx/SR8stKK3sUCGAgAT19/A=
Date:   Mon, 26 Sep 2022 06:30:05 +0000
Message-ID: <TYBPR01MB5341D7BE09D2E76E03A26110D8529@TYBPR01MB5341.jpnprd01.prod.outlook.com>
References: <20220922052803.3442561-1-yoshihiro.shimoda.uh@renesas.com>
        <20220922052803.3442561-3-yoshihiro.shimoda.uh@renesas.com>
 <20220922194359.3416a6a2@kernel.org>
In-Reply-To: <20220922194359.3416a6a2@kernel.org>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYBPR01MB5341:EE_|TYWPR01MB9710:EE_
x-ms-office365-filtering-correlation-id: 3b878e61-dc07-4e91-23ec-08da9f888d5d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cKSXHhKDadVvagV1XHA82vWNc9cKITyZWZJEB+tTsV2gQfPzp97F9nRjsLWVdH8ODXbgZBtkqtY5mYwhlzLykejC8EmBEm+84Y507VYao6iYGwOFM4Nip4BSfcO4OcExwAgisZTpb+A2qDQu7i0r3cR2LpnyVtX9g8IUYHXEqdLnbecuC2EQYSnCazSeZZx+u1cIzFuzs+w+UBhhdNzx2FbUEvPFaiC/dxF3bXTseJUo0HCb6lh/9LWmvbF87YUUiAIDhkv1lGq1N1C461DxvDwSzz88/fre7t6ab/HC3d6z2uvl0iFKnSPNNEiERpa0IOGM1eF3NzyNO9tJgMnTfFaicz+oiRWmxaYm/7eaKOhHkHjFncippBMrKxpANjELExfeEZo8mtENCjtm8BylqZLlg3xLk9FJx9ll7N+6zY2XixAWZYXAhA3p8EKD+ux496beKHGu2VTFvW7dtQi6tLwyB6B6u1Ob9vL44U7qtFDkXnTldFgrvb7jrcEWFoEG5Hgk6EGJCUW97jUBwRG+BLrP1GFrcAGCNwypmifiZ7dhxq/iaLEhZJHYQ9n3gFD2yJvSjqXi5Jh1pxfblhkhmuXKI9BAdwk2avO1heEtWEBpHlc8eiDmCl/SkVHLwrBAif0/L3DwRD/X6BPafmU/10/D+f0PTiKxRf4KuAjejB8Q4RUscLmt0COP0zHDj3Qcl/C+3GF62Djt1u8xn/cjcy7QDV/a5Uh9l0u3pNC23Hf2p5CIXR6Df53j+Seypk74wMyosJVBSVTB88vKUi6bwA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYBPR01MB5341.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(376002)(39860400002)(396003)(366004)(451199015)(66946007)(4744005)(66556008)(66446008)(8936002)(64756008)(66476007)(5660300002)(7696005)(52536014)(33656002)(38100700002)(86362001)(122000001)(2906002)(38070700005)(6506007)(55016003)(478600001)(71200400001)(9686003)(41300700001)(186003)(83380400001)(8676002)(4326008)(76116006)(316002)(54906003)(6916009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?HvVIl8dNwEnCoxJL1E6dBgvVnStkkVHBuSfmc/tOiQd6yF4F8lX0w4IW9sHQ?=
 =?us-ascii?Q?aqNo6j0qPxSB4whjG0lFSY3LwXxkUJjhveNAbZ4whQ1Sx+DAK53yNVHPomAl?=
 =?us-ascii?Q?aXR9VCUP+/lh/TRHRvaUuFEkJui8QArNqCr7XSigSQeSXTmbdkZJRTXnisl6?=
 =?us-ascii?Q?DyFsA0gzNha7tNR6imXWDEKtOvgl0BHcWBDuwdmKBnJkNKkVip5dnhS18UuT?=
 =?us-ascii?Q?BQudToVy2jnKw1Ktu77dFHDD9jErBD9+K8L1dqbStVqXdx4tv8ENT3lHHCdK?=
 =?us-ascii?Q?VcsHL84IsocTreGj24WFM5UQyTfOVMScfbBEwu6k57y2lqg/XT/LbBXWMAQr?=
 =?us-ascii?Q?P2WJU28Wgm77kCdYbdvlMCo66liBhsCvvG6Bf0s4+rkkkQG8Vyz5bFiORGhI?=
 =?us-ascii?Q?7MrQfVzXp07tNtd9Rg+OMTg1GOHTzqmrb7dayROSGD5V6XUFL+AVEcggD6c2?=
 =?us-ascii?Q?YUG/ADU2wJmc9sWWrrdVvCXHMbA7UcQIInW3zhkZlRCTMnWoGvuKlXcW6iKG?=
 =?us-ascii?Q?0C27Zoda5D+P1dDxjmFUC0rDIWgiCApGYuZ4EBuN1TH3BiBw+l+dOC8tSoNM?=
 =?us-ascii?Q?eyAlqE4bk2sVPbD4ExXeocqGkqf/SY40tmBMHDQgD8Vdn1jnsWPUy82T3+R5?=
 =?us-ascii?Q?1V+aOQ49p6zuwN+i/DOySIoq3qWxLuvNVxqu0FgHytkl4NMtJ2NQ+67+zyfy?=
 =?us-ascii?Q?ZHCrsWFMvfmxxT/S4zrl8c4iNLerCO7UnyQnHfGQ53sfPKecOlHo6qvizBAa?=
 =?us-ascii?Q?dfxCKJS7c+m+T7yZtyjHakwUNY0JcGWgjXkLZSJHU/r4FdCHyArsVE+Ah/YK?=
 =?us-ascii?Q?Vf1yR1aRy2AN/leUkbLYxtTyYSDyhD45sNJIpE/5PE5IVAnTs3TYAOq4L/Rs?=
 =?us-ascii?Q?7Tq4SEhL4ZC8KouL81SlUpB8+p9uJB2rlvgOUn32wqnNfp+5LuLL3NqQwCPN?=
 =?us-ascii?Q?s9yGMN5+GcpFGyaDFZxLk90OxIx64Bax8tyevrak96Du/4YgebTMkdv2K4gf?=
 =?us-ascii?Q?0pbWaytiqFFlNEv2JZZ7leNCQ1I76ZYeYfZgSuOq1hepMoYBMMDid9arUDTX?=
 =?us-ascii?Q?xKxxeVs47qjayD4xAfmA2GM8VCH1oTBmRtTsW2fyW8pfW/2VzDbWm1NDvctW?=
 =?us-ascii?Q?M3tuIoLFv5pHRpex29VTJOzihoej996NDE3ADVe2DHnzY7cAgEfapeew3L8D?=
 =?us-ascii?Q?jO2RGIVQ4XRYZD2Kccdyt4hXhBKVTep6YlRMjQhSvk8ATP+gfwE58K/f1I07?=
 =?us-ascii?Q?aZMSVfsfF+znR/SoPbPYaZIYIsT6E7XCbDRZRifh/ss8FCBiTomgXRkDMaIs?=
 =?us-ascii?Q?Ii0BYaSguNd3X/4l9C9NbGOMxrZyMdEdZUvfbXIkM6Ck4TvY8WXx63oCu9ob?=
 =?us-ascii?Q?nT539xg+mupOozuY/Fjjc8qx4jyYhUd2/Z2A8E95o3qi1T208jNfo1nw8qpF?=
 =?us-ascii?Q?aVYx5kUiOqtvN3eENpfYfXCPTrzJ8oIG3Uf+RjXsrmYo7O5qC4GET8gw78V+?=
 =?us-ascii?Q?Dsp1vRpm8LV1ITkENbVgsltL9LHRGYXD63fC0NLFDrf+vc8AKfjkUdp6yPzx?=
 =?us-ascii?Q?qnQnScWruuhvucXA8QcsItAMXkgss+9dus69Rz+HPR2sDEYRvD7Es7x3Dkzl?=
 =?us-ascii?Q?NG7hOrjoesx6/8mZ8xig1zV904+JgzvhksVUxJS9nvvnaxnWH0Kolk68OQa1?=
 =?us-ascii?Q?qygK7g=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYBPR01MB5341.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b878e61-dc07-4e91-23ec-08da9f888d5d
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Sep 2022 06:30:05.9125
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NBvxcsaDvB3PfaqZNJTmZlS69rYxfqRH4zXuikzFYradmS2DVB2aL+35r1wTb5/bgprqMXvdhNGYsooMBrLyI9npLViSpwRG6BSg56f6hiQuA5OplwiAqFKJOBm0aqIo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYWPR01MB9710
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

> From: Jakub Kicinski, Sent: Friday, September 23, 2022 11:44 AM
>=20
> On Thu, 22 Sep 2022 14:28:02 +0900 Yoshihiro Shimoda wrote:
> > Add Renesas Ethernet Switch driver for R-Car S4-8 to be used as an
> > ethernet controller.
>=20
> Looks like we have a lot of sparse warnings here.
>=20
> Please try building the module with W=3D1 C=3D1 and make sure
> it builds cleanly.

I got it. I'll fix the warnings.

Best regards,
Yoshihiro Shimoda

