Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDF4B35E0BC
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 16:00:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231859AbhDMOAz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 10:00:55 -0400
Received: from mail-vi1eur05on2062.outbound.protection.outlook.com ([40.107.21.62]:4449
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231625AbhDMOAy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 10:00:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CF78/tYxKlJ3wUpk2BDoyBOa8t/2/bH8s2euQF95G+IAU+mNU2VnGBQbgoI0DFeh7YQ9Bj4JgTAalztbkG9QO7RIu0hLCGUGialUsu0+SoTUHQemMo16VRXc06i4qMDGYeV9RUFtGHBq6GxbjsSSvAz7We3RecFbkDSN9dE5XdQIs3bkLQJQIxVZtcgK6DDdIV3QfDdeEYk1+pWEeYa36+xdJjWk0+Ziay2e42j9kk6SvFz7kx6zJKDcFI2xsa9hW1tYk2uTBTUomKqW4p/c8tWakTvZZdADTkjdxk5f+/x8KslKRXRSEbFmjUHQw+axiNACqq5N6OJs6aHL2JuZcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vMUTAbsTDdToUK4S+2bPuzFqHQm6DQtiuvm7hGQHKBg=;
 b=cJ5KFKuDeV77W5zWtc5i++BQDd3L0JzQjGFw3I4xoppj1GNlD3/vDyhZ0homKXlluMJpzNZ3CRTjs9cxFFKz2Kk47xabgPR0TgODNa7FKsaNSSmm8B50qEApFOH3f4eUqGouECgv9qqjr5J9Ri/LixPlxlRUlEjIlb9kwlycQ3GSur1sR5MI1+fL1GW804gkz+Khf0a1eyRQDMtYv+OZX9XMxb94oKkW3Ch9jY1P09bV0HOenh81ic5CqfF4Ja76+fkxtow3LOWON019IsJSgQM5LRDxtyYdbNJAYLkzM7oLwO5viQnccpARwU4bChcxIg2pr9A6sn2GOIppme+4CQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vMUTAbsTDdToUK4S+2bPuzFqHQm6DQtiuvm7hGQHKBg=;
 b=nzFLwZMja2jEoDfgEewSr39xfrapPudb6gGjx4ukFsHUYMC5R3mM1hSKnyfrM550LGEh5J0MaL1fYN7XBKoPrJSWsavgd0puSRDdMTg2hsJF+bTel2UuHYSXrojGe1oSKEBMAkL35sIKt27hIq92xziB0L6jWxw8eV9j/lDPPjA=
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com (2603:10a6:208:170::28)
 by AM8PR04MB8036.eurprd04.prod.outlook.com (2603:10a6:20b:242::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17; Tue, 13 Apr
 2021 14:00:30 +0000
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::1552:3518:1306:f73]) by AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::1552:3518:1306:f73%6]) with mapi id 15.20.4020.022; Tue, 13 Apr 2021
 14:00:30 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     "Y.b. Lu" <yangbo.lu@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "Y.b. Lu" <yangbo.lu@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Russell King <linux@armlinux.org.uk>
Subject: RE: [net-next] enetc: fix locking for one-step timestamping packet
 transfer
Thread-Topic: [net-next] enetc: fix locking for one-step timestamping packet
 transfer
Thread-Index: AQHXMBbxZTUSW7BjD0qlD9eaYKYOH6qyeeuw
Date:   Tue, 13 Apr 2021 14:00:29 +0000
Message-ID: <AM0PR04MB6754E9A905834B1198760F1C964F9@AM0PR04MB6754.eurprd04.prod.outlook.com>
References: <20210413034817.8924-1-yangbo.lu@nxp.com>
In-Reply-To: <20210413034817.8924-1-yangbo.lu@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.217.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a23881f2-739f-4a47-32cd-08d8fe847f70
x-ms-traffictypediagnostic: AM8PR04MB8036:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM8PR04MB8036D7D885AF9B9FC21DB753964F9@AM8PR04MB8036.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1303;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mrcwtZeNez/sVZBDn6i7xYu7OBND5yfkjZWM5rJatb3c/+UAu5yWONa6KkPJ9lq8JeGGp/aMsZ66/8HdTgvTCcJSDAuNZMCe6p8FWXWBssu+Mb/pTPWrtKsweo13CEw8SjeGVoj8i0PLLJcnkQSL5dyUZW+nVV9XxjB2ypFriW90u+EwCoT6+dsZa4xPXbK+uy1rGZcc3AtukqGAxCO9wN76ocWwhyN3Rh4lPiGhb5V0xisjvPM9aSzGF0uRwACSkfh2s6XbBrPva66c7k3O3zqR6bYeXtw2HpsGyZCK9HLmSshK2wJ0qpr4GsvdT/OjPsYT8skvcw8JaCkK958pv41rt0yjg+WIlJnqOxeRVQLcWFzlF24Gt8R+lScEwPm+noc/ZBx7svAw6s+uCizzG+PUJXcQPKPMFimiMuaBTDZatd4AK2jAPZiBIgX8fzKVZdMuF6go0f02Ompa1Roz6/US2vhUqWo3W0VrrKOkujSj8BoQvcLJXyN67CDLAbWoIHuNorazIzpePEsN0ckzL2f9IYjya+HM9bZUe1mphUwb/eNrPYWgaQb5KN3F2Y5KjxOiXj26FMxRFf/QQEghlEOttfmWU42xHl5E2CTuujI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6754.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(8936002)(76116006)(71200400001)(38100700002)(498600001)(64756008)(110136005)(8676002)(55016002)(2906002)(66476007)(86362001)(122000001)(66446008)(83380400001)(186003)(52536014)(33656002)(9686003)(6506007)(66556008)(5660300002)(7696005)(54906003)(44832011)(26005)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?hsMg7ZRZgMwFdGQPqnuqXMuXzSg0JpFEQZOcYHtOPvwOIb8f7ZOyhfPn0R9a?=
 =?us-ascii?Q?WU5FISjHsjzhRgEunrNQ99b34+ptkInMRpEFoZAgDmkPRyrX9MC1SndKUmbx?=
 =?us-ascii?Q?cuPAdjV6+RVDGLrsXPCE/mT5o+IxeAKkQdqyVOFc6TAX6NDP9UFIv7J/qsZ+?=
 =?us-ascii?Q?s35PJsy5Oh2buJXu+yEuasAk9aUYGL3yvz7YR8saS+BnD5uCNw077MWAIMLM?=
 =?us-ascii?Q?H3TAxvLEr1gEnEW9f0Bs7mCAbDFYuQMOu+iFJrcPz7RR1dL7VW6pJtE2aMf+?=
 =?us-ascii?Q?CIBSpEVFFdk52EBIHOQUnKZGtMeXUNOz1vugUd7QdzTAp87R6U+dTStW1uz5?=
 =?us-ascii?Q?ML8vM52iDduv+kw97/BYa3K4T5iv+CQQ4MsFezK/lBErtw/OPgUzTnNu5rDQ?=
 =?us-ascii?Q?p6DTwL8UWDG5uYEOv5o6YG+iyA1VFORc+FcNmaD+USdda600F/CcaZfeTChT?=
 =?us-ascii?Q?f5XBofkLZQBuvL3MScNcr9a54yvBHj1bSTSzTetaY//vamWoPoXrYx68X9S6?=
 =?us-ascii?Q?SjG32Jebsj3Pg99RJY2JxtYS0+YBgYs99moSDrxnjExscxQ3bkEpclJ8pZdH?=
 =?us-ascii?Q?YNu62UILRK4q2En1rQIg/5IKo8Dg9n4kT8AQ4omi+GT3nmtuMUJikw9t7rWw?=
 =?us-ascii?Q?OWSA+t3Q1BeJnHNxrSLgYxLWTcNmlGn8Cj+FT6h8v5QXubkle10NQaKWPYTU?=
 =?us-ascii?Q?jXFThgwPQWOU+gAt89Wx9vslLQScM6sPi0G29TkwOA+84fqVlYNEJkR+w60n?=
 =?us-ascii?Q?ReGNpOSBE6CMlx+vpkmcs7DeuCeHqkGE9K1e84UABLSnzCf6nbmNBGovXmqB?=
 =?us-ascii?Q?yQjoOqfT5h1vW4wVIDtiHaFWveRXGdtB6OUI49W4BIwTfsEhytMVJM8xUoJC?=
 =?us-ascii?Q?AeB95Gs43hiRGDjdYuZvpfSqTPJ0k3j9ZlXNWgT33fk7Cd+KbOFAwv4Ux0Ak?=
 =?us-ascii?Q?fukHVLTwrbmtrq9ZEidBcL1U8Zg1BNy+mCHsApPpykNLbqMY+cuHlKLPaHLG?=
 =?us-ascii?Q?fTUd5UwHHiy4Vwadfd7u7YiTsQqQrTK2VyoTFkuGqCMdVvMQzFIcdU2KRY/0?=
 =?us-ascii?Q?C6kidhcM4js2TZRAFIVSPuOympgLBg7jgcOhh+7Z59NBS0FJimPfDIJPb+nx?=
 =?us-ascii?Q?vGOpjQ70ZNlAOSmxThsCKMntIzBE0PUUtaZBUX1zH7JNDhsaDpG6TwjmZOuS?=
 =?us-ascii?Q?87IeJR+TUeemjboUWAFosReKcalrENP3T75tJZy6r75EPx+ODpW1RvZPoEWl?=
 =?us-ascii?Q?xDrGGp0vQH7XRobcK3bggcluEalNCxx3DuQ22Y/MK5TC4/wbiZ0peAaoaFX/?=
 =?us-ascii?Q?aWqRJ01nGCXgHuu6Mxfumco5?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6754.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a23881f2-739f-4a47-32cd-08d8fe847f70
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Apr 2021 14:00:29.8873
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: o4PtL0DyBN3QqFLrUOBKCGtgUBz3wf1vCLNsc7IsPpD2rGDYtr3W601m8hfxtV/uWoAY3ogi+Xt0+SefrbO0lQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB8036
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>-----Original Message-----
>From: Yangbo Lu <yangbo.lu@nxp.com>
>Sent: Tuesday, April 13, 2021 6:48 AM
[...]
>Subject: [net-next] enetc: fix locking for one-step timestamping packet
>transfer
>
>The previous patch to support PTP Sync packet one-step timestamping
>described one-step timestamping packet handling logic as below in
>commit message:
>
>- Trasmit packet immediately if no other one in transfer, or queue to
>  skb queue if there is already one in transfer.
>  The test_and_set_bit_lock() is used here to lock and check state.
>- Start a work when complete transfer on hardware, to release the bit
>  lock and to send one skb in skb queue if has.
>
>There was not problem of the description, but there was a mistake in
>implementation. The locking/test_and_set_bit_lock() should be put in
>enetc_start_xmit() which may be called by worker, rather than in
>enetc_xmit(). Otherwise, the worker calling enetc_start_xmit() after
>bit lock released is not able to lock again for transfer.
>
>Fixes: 7294380c5211 ("enetc: support PTP Sync packet one-step
>timestamping")
>Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
>---

Reviewed-by: Claudiu Manoil <claudiu.manoil@nxp.com>
