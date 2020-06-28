Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2316220C678
	for <lists+netdev@lfdr.de>; Sun, 28 Jun 2020 08:23:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726027AbgF1GXV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jun 2020 02:23:21 -0400
Received: from mail-eopbgr70055.outbound.protection.outlook.com ([40.107.7.55]:1985
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725933AbgF1GXV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 28 Jun 2020 02:23:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YKnoWAaQWQpQ+e1+FXwY9gXX+7ThWrAVGGOJwJBnFId2Ph2h6XWMDo7ZRoNQIbtCPjsHsSfU39P1NpMuMpIFhVmmUXDrQTjhIT/XfO88jcQaLQv8hcwspr0KvGSVYVGj5PuN0GP8twt5LweMybop4rQsfasRRC4Zoc2hwZVZcBZg+s2qswJKphGNga+5DaqNn9hCFvam8Z3aFMiuy8YOgRbXx8OphcKRdXpVG2AwOsznlAYSsasWRp6ORIVhq0aTt7yJ+7TTghdatogmseKIcaNuQo2Bl38aPRh6siPAICTKYPV/kAARnm5Vr9JSrw5reRxPIG06t7ddgStRpYZ7YA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=prYP0a8uitQ3C+7rvoxdIHmYObUx42VoIyU+PccOu84=;
 b=VlFqsM6xu/Z9gApn4MaBZvVvB3K/6g/vDZNKAUBktKqGKC7To4f3Sb909hsxS8oTbrDg9Q5+5stGgpUjHPDrTpiIJBfr8L5pZHufEHLmKnOK4jXqca4+QYZJXoCBQrgpAiJ+XKyRsUNxKGthV7ZzCRJVqS3ys0lvHt/hDhG5Y7i3FcF1qNdrdQULi4Ldutx7rn7CMM8Eejmrofj3UjeWhrFjxNE2Z/NZovf9t0XKh56bY1/MGDxR/41iZFvJ0c12gB/bbNKY/O4gWvsATBHDLJXa7yH/ACL/vzSEMgzLQk/zhT0tTXZxbUnuuE1AU4W5jUIvcpiDAieyAzXdmnphHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=prYP0a8uitQ3C+7rvoxdIHmYObUx42VoIyU+PccOu84=;
 b=SG4YDStOVX35P0nBFBmY0Mq0n6/wAiHs1gGd5t/7CB2tEK6kX1LnD/YYZbmOitDWv8HHagQlt5gIGlAIxIwEdE235I9QeNA3ku6rXHseGZPNa+Kp1OpoSGyxfCKBRLDJeT6IIMjkQXiLN2AO3B1C+DT9m+uzVEh42A8H72BnZ4k=
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 (2603:10a6:209:12::18) by AM6PR04MB5269.eurprd04.prod.outlook.com
 (2603:10a6:20b:12::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.25; Sun, 28 Jun
 2020 06:23:18 +0000
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::35f8:f020:9b47:9aa1]) by AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::35f8:f020:9b47:9aa1%7]) with mapi id 15.20.3131.026; Sun, 28 Jun 2020
 06:23:18 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     David Miller <davem@davemloft.net>,
        "tobias@waldekranz.com" <tobias@waldekranz.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [EXT] Re: [PATCH net-next] net: ethernet: fec: prevent tx
 starvation under high rx load
Thread-Topic: [EXT] Re: [PATCH net-next] net: ethernet: fec: prevent tx
 starvation under high rx load
Thread-Index: AQHWSyWV3hyWvPwI+E6K+muw3DPNvajtkJeQ
Date:   Sun, 28 Jun 2020 06:23:18 +0000
Message-ID: <AM6PR0402MB3607B4D0AD43E1CBC41214BCFF910@AM6PR0402MB3607.eurprd04.prod.outlook.com>
References: <20200625085728.9869-1-tobias@waldekranz.com>
 <20200625.121938.828374998212486132.davem@davemloft.net>
In-Reply-To: <20200625.121938.828374998212486132.davem@davemloft.net>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.68]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8bf764b7-2e60-4bea-0f8a-08d81b2bbf9c
x-ms-traffictypediagnostic: AM6PR04MB5269:
x-microsoft-antispam-prvs: <AM6PR04MB526904AFF832A02A15681D56FF910@AM6PR04MB5269.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:506;
x-forefront-prvs: 0448A97BF2
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: x2ETjMnPf7taCj4foVxKGEIHSmqIpkl2QHtD+G63CMBpTDvP36htOr0uuYtZbPMGYw4d+wYeMhpqA95vkbUZ1aIHgZ2hZSBheq1xDRsu4Mq+5PB4+TFvWuhRSIIs0CufeERXcHic7RuKDh7d4Ul6oCLSaDNmfYEY1MamJGJaKqv45uIm/C0prC/s336Ro+VlIevWQ/LTZOqXhnTSyTPRTYbCm01BqTeDkci0XYFNL7vL/7CHU9fNAwRAT3GxSdHq4gJ5oW/e/WQBQZgid7plBVXYq/7ipSvBJ/UGMOBFt25HijuZSpzXxSrXJQ5TJtQFu65dlsHSl/eg5pjvWSfnlQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR0402MB3607.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(346002)(376002)(39850400004)(366004)(186003)(9686003)(55016002)(110136005)(66946007)(66476007)(64756008)(66446008)(26005)(66556008)(7696005)(6506007)(86362001)(76116006)(478600001)(8936002)(66574015)(83380400001)(5660300002)(2906002)(4326008)(8676002)(33656002)(52536014)(71200400001)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: kkC2VwIz0gRESZMr2fqEluNHeoya0NbVsva0nvJpfGb4g88lvoOM+CfnHtUrhRy0zdNfLzjNhuVW1UnF3AyXQ8YCpZreWHBIoG41ZVnfQy2W/Wrz+exHA1E8y6HRZtF1FEK9vrvkNWZ72xTygr7xPjluajxFxPIXcDiRQNipEUdUD2AQXwpNtWJMwlKW6Q31365T84rxPZmaqqC7tuMoctOW+i8qGqXLqTnvzV+Gg8sB4fQgBl7qBIeTehph/Bf+aFZp4ookZGS9NetsKbJHT100GmGWR17Y+IGwYTIS3zcmzKbTl3F+Y3y+xzBBnWE1jIJA+AtTotdJo56EG6ZcnSDrDQznezdG3gtD4N+u+4JvVpD2zzFPf0+l06l17ycTn+IMB6gGaJnSYXTttobeKDug6pXiiM+0osG4WdCFr4Qo2kd3ALIdyH6uBe0W0Hg6x1+9F8gxlxTiXVX/XzwsM4FTv9MMrcS6HvaqxL4Y5Dc=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR0402MB3607.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bf764b7-2e60-4bea-0f8a-08d81b2bbf9c
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jun 2020 06:23:18.4371
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3Ti/SzOWvfvpwyFi39d0AzJuXqbV1+ScKqCLz7mrSIjQHfxMXFQVpWIQ5oxvOpfqhAewHOAwkWRfTD8wOsbOcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB5269
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Miller <davem@davemloft.net> Sent: Friday, June 26, 2020 3:20 A=
M
> From: Tobias Waldekranz <tobias@waldekranz.com>
> Date: Thu, 25 Jun 2020 10:57:28 +0200
>=20
> > In the ISR, we poll the event register for the queues in need of
> > service and then enter polled mode. After this point, the event
> > register will never be read again until we exit polled mode.
> >
> > In a scenario where a UDP flow is routed back out through the same
> > interface, i.e. "router-on-a-stick" we'll typically only see an rx
> > queue event initially. Once we start to process the incoming flow
> > we'll be locked polled mode, but we'll never clean the tx rings since
> > that event is never caught.
> >
> > Eventually the netdev watchdog will trip, causing all buffers to be
> > dropped and then the process starts over again.
> >
> > By adding a poll of the active events at each NAPI call, we avoid the
> > starvation.
> >
> > Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
>=20
> You're losing events, which is a bug.  Therefore this is a bug fix which =
should
> be submitted to 'net' and an appropriate "Fixes: "
> tag must be added to your commit message.
>=20
> Thank you.

I never seem bandwidth test cause netdev watchdog trip.
Can you describe the reproduce steps on the commit, then we can reproduce i=
t
on my local. Thanks.=20

But, the logic seems fine.
