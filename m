Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E8B042ABEE
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 20:28:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232387AbhJLSaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 14:30:20 -0400
Received: from mail-eopbgr1410091.outbound.protection.outlook.com ([40.107.141.91]:43776
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231565AbhJLSaQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 14:30:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cxZu4u36GjUnhhMALoncl2Zsg5c0P2tTiS6YjD0wp0NFvLAsgztn4I9D9LWoOXH6ga/q9ZQRZMrJtCkVQRmFp35lMfRwNzR9ZPbyMhu1PQwWDOpkMsjaK1ihgYemNyf/MZHqGFopfbcpgra4941WCb+a47D00bfJwNBzniJn/nxp1/uSEqdiauyPkN6o3neikQPSQgvFiDPV6ZafaL2PLoWDWR4g9XYkPKrJRy3oXEyFRv+IsL93j5le4+9rJQBEupghqJbXgVEGTG/xy5yr56NMcRxt9tnohyOObUWOOb3Fj0WA1HgfuEQ/FG8xw83oNZAKtK07KVkMd2sOWVMI3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VVByhudFzQnhaYc4SqoKVLIl8cyzXFG7uCAfbtJl1kE=;
 b=MQeTxCZ9s0vyTmMvwMlOVj/iEXFR6F6Ribk/32wzjzRjtyb19w2CJ/2wf7Cd1C94tcXGJxPxemHXurxca/n49sDYP0vb8S4F/tbtS3X9VdDPSPPuDJUv8dQd00K5ZtmIDOl0O9onEYP8bIIoK0tjFGmMoi6sMabqkw/3tYug/wGnnfxDykOQAuwD6g2me6dyNrxKdhVXPVPpJAPcfy5abPPEj9/gMg2GRkWsXGHavnK7GettaQveI8TleYp8AbAtt9USI9XC2dKQPIs5BmYlcaOpPHDI/tKTKpEJ1lI7dKmSOnOvpbGcU0f9tyltjDP9pSjGw09hZpOXwnVAAFSPjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VVByhudFzQnhaYc4SqoKVLIl8cyzXFG7uCAfbtJl1kE=;
 b=o9TKe26ibpIPlk6xRE5boyUm36KavVtYIQK0aIa3bpAMmKO8HVg5Ygr8mL/XyZ393r3lf8uJM9AaMNOrbvJFFuV9CDQtgIjf1TqUyTFIcNQrdU2lUj5Dx87cR2lrK7sTSQW8h6p1LohLTA6uE/6H6gzvPheV8xWJ4Im0vc57ecM=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OSAPR01MB1700.jpnprd01.prod.outlook.com (2603:1096:603:31::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Tue, 12 Oct
 2021 18:28:07 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::9ca6:1cf:5:9fc1]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::9ca6:1cf:5:9fc1%3]) with mapi id 15.20.4587.026; Tue, 12 Oct 2021
 18:28:07 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Adam Ford <aford173@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>
Subject: RE: [PATCH net-next v3 00/14] Add functional support for Gigabit
 Ethernet driver
Thread-Topic: [PATCH net-next v3 00/14] Add functional support for Gigabit
 Ethernet driver
Thread-Index: AQHXv4dKgBnK88kVVkGc1kUz1FHm7qvPrEoAgAABg9A=
Date:   Tue, 12 Oct 2021 18:28:07 +0000
Message-ID: <OS0PR01MB59228B47A02008629DF1782A86B69@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20211012163613.30030-1-biju.das.jz@bp.renesas.com>
 <20211012111920.1f3886b2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211012111920.1f3886b2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4308e518-00ea-46d5-5133-08d98dae0992
x-ms-traffictypediagnostic: OSAPR01MB1700:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSAPR01MB170071F2E4CF6ED98769CFE986B69@OSAPR01MB1700.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GHkQcsHnKwtIBAyQhTmEkZa1BcW/1e/6ottvRPT9HIu/QvLuvoU1nX7Gm7dKIPxCgal92PeCE6m+GSkwz+HoTV+qb/pU/69Yuy7Gq225mbKpYqbXFguDLokMAyIUoptG4RG3NmiRr3hL80z3V0MIL5MsNjRTQM8kahZ69A3JLDHuSMiYrTv2RjojUuMTKHLU5+1YeW7YcA0qKcUs8PifKWDHfppnBzUPth+HqL+aJFs2Y8iCE7OZc17ryRIyeuRhhcT0D5MLWZDPw0TgJyawXDBlT053rSTQU3BVP6YxEm8uypOLuSegdF3oabd+RNNfOyQZYoctzAsH5AOQKWc3R2movzRudOQ9V+ZJxJFL10LOppuuS0IbdcqhyRhcPff3FVrzLZTWbn/Z0DLAkArZr8rKrg6sWgGMCLohkaKVQpb+pZZj7eVzX5TuGsJt90HQaivjwdujRdNqA+K9HgwPthXeeypmW1wby9+rhAvBNNsQlr2CdeGkqH8taBHAnP0pGCU1gFs9IijEQPKT0lrUKTuXYYTno+AbxCB+yFI7ihtIrJzz8rqMAqtqGRfkT0f5dJ/2rUbVTe83nBOGt1ufeVDfcSQ+cBO78unUdR8JkUXMBYcJncXLdFpGnVN7mbglvLtKLucdYFDVLQQA0v65z/J01jdGV4uL6Zfb5FLMDGqilDhcE9065gp2C5oNHMj53UZejjUQvt3tq+1R+ti36Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8936002)(86362001)(26005)(66946007)(83380400001)(38070700005)(107886003)(76116006)(5660300002)(8676002)(6506007)(186003)(122000001)(38100700002)(52536014)(7696005)(4744005)(33656002)(6916009)(55016002)(64756008)(66556008)(66446008)(9686003)(54906003)(2906002)(508600001)(66476007)(71200400001)(4326008)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?fqYjF+ygVHNEcM2IrfMAWicDz4OpWX/Fv2nCikUiAkpGpo1TBM8o4lWK7G+r?=
 =?us-ascii?Q?OzZwldAI9zdsUbuI1IqdC0EugOv0P3J5njRAShjAyezSfuwFZLX5ucG5BdGU?=
 =?us-ascii?Q?+Oqa/dH0bzTjdrX74GU7PZmEI6xW2W62Bn2uuaB6+np2F8eMRbAI14w6zpcD?=
 =?us-ascii?Q?/Q1KF0rE5onivcT2wkAXd31P0Zf8Y2zayh5zwizVtfAsfa3/2iT2vX66kLMP?=
 =?us-ascii?Q?WiwXvpLLcyMY4NBMDFWYxMNr2rcn0iSyxnJ7EuriFP8o4ugYHRb8bUNs1YwJ?=
 =?us-ascii?Q?14nqT25DxqY1UgAzTQUdLAukQPWnWPoLLmY1ri7beMyHN8tyZtfXcQcDgLl2?=
 =?us-ascii?Q?gnqQc4+yYYlHeHKBHFawJ+sZ25i2q2KS7jfOSpxnlD/P3XN+cTNrP62YTsvX?=
 =?us-ascii?Q?hRIF5redbnxDIVqACezolQTVN87zyAZdC8c7I42zI/AT28uL5yJPra4zMqR8?=
 =?us-ascii?Q?y6StbJ9gqgOV6TYZtqrq6dSyo+J3SXvqSlYxACqOtjciHpwv/+ihamEKeVwm?=
 =?us-ascii?Q?1so1RKqJp6RtPh8qI4QEnhshE9vHsRSGmuNnzOaXyZcsm/plD2Y1uTacAvqm?=
 =?us-ascii?Q?fNsIMJKIGugwQJHr61Fej8Z8hGFDTC9whefHUHNWNV/zEBdNFUnm+VsgG+5o?=
 =?us-ascii?Q?ryOuD2jKfkrOZwbU51MlU80ugIBNiC5AakZrxVT5hwyN08mgkHMoGyfZVg/L?=
 =?us-ascii?Q?O2WFXDyZMRhJeNa8r1EBs0igMcgQ8ovLFaZCMZLd0Np7um+M/Ys8gc4ENWSF?=
 =?us-ascii?Q?xGPt1xHcInQAjtRzzH7MJAimHgZzMQ0QJh7uYRtq1Wl/F9L5C7HNKYw+N7e1?=
 =?us-ascii?Q?krAJ49aEp2PQSl6JnEls0t4lEjah6J/CxZPMgg6U+DCY1s7zIexHcEQp1Gsk?=
 =?us-ascii?Q?vi1hlzLYFwr4aJN6xTldkwXbgL0e+xGdAj7GRIncs949kWfcDS01Tl4gD6sO?=
 =?us-ascii?Q?QZDQQipHp35mVpX8y2Uio4+r+4c8NbSNhey+Y2Mu5xpgQR0pyc8oBLuNwmaI?=
 =?us-ascii?Q?NAuyxNXwW0ZcqBXu7U8AL2p8o4JVQnE+woI6ufJnlowcsPHgyCO2nRrhT8mr?=
 =?us-ascii?Q?uJAwOpJNm4TB3CuOF1O89ykYO2YC3xkDUTeDiRL09KQ3t6kZ/0PLEYqC3qDt?=
 =?us-ascii?Q?WC46YqHIy2IReM/hfP8UQq/Sg7mcMQMJ1gV2y2k2vFn1IVyqElMQ6QiJdu4B?=
 =?us-ascii?Q?saLlGPbtHUtGXldF6jKJjq3Fdw/PIIQXrmFUSFsHqPOu/emDL3cTSezsssYX?=
 =?us-ascii?Q?v+e1FCzc602nk4/IrhDtafXUg2mSzz0QDwmARJ30yENs/LbG41SpaPcARqkm?=
 =?us-ascii?Q?HA0=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4308e518-00ea-46d5-5133-08d98dae0992
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Oct 2021 18:28:07.2164
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FNw/VYsBVNSg8obIzZnsY/8qE3y8cDcwn2e4vcB7RzgnAm6Rj/4OQgCAG1stYF9T7pqoQmySS+RtVN+bFcm3vKJGsAMF+Byg1CHJSzV71Zg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSAPR01MB1700
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub Kicinski,

> -----Original Message-----
> Subject: Re: [PATCH net-next v3 00/14] Add functional support for Gigabit
> Ethernet driver
>=20
> On Tue, 12 Oct 2021 17:35:59 +0100 Biju Das wrote:
> > set_feature patch will send as separate RFC patch along with
> > rx_checksum patch, as it needs further discussion related to HW
> checksum.
>=20
> Is this part relating to the crash you observed because of TCP csum
> offload?

Yes, you are correct. Sergey, suggested use R-Car RX-HW checksum with RCSC/=
RCPT and
But the TOE gives either 0x0 or 0xffff as csum output and feeding this valu=
e to skb->csum
lead to kernel crash.

Regards,
Biju

>=20
> I'm trying to understand the situation before and after this series.
> What makes the crash possible to trigger?
