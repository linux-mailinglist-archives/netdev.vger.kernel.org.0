Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D43F761455A
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 08:59:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbiKAH7f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 03:59:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229795AbiKAH7e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 03:59:34 -0400
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2102.outbound.protection.outlook.com [40.107.114.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E20249FE8;
        Tue,  1 Nov 2022 00:59:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KFxhLJb3dp7aiXZuMawF5GNBcCQ0BufkhCuwXCsXyrX35rbSHA2pM+CHEtXHfIP0hIecQmaQ2ET+DmkQn5RMhGC3PwBxPkthvw3IhtAyOXzI1Ud+Nj+VJ0h1h6prxUZCRnDoKMDb9RfvUxtdavzTlqD+jCwE53BVc+bCVoZye13TvFIUU2mnt8HvtYNAkHwnVkGH/vFQ4tTL8fKdz+veCoMeQTZmHGC924gGvckAFkbWFuT9cw0/wdwRyo8MerbaPuh2kspz4eMOY+BMoz/rnrxBTloB4wTtB8LsQh21cM0Wa4TstxORCBZ7oMGLQTTjAhHDVsn0LhRCoGysOSNrvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YNQnSQWeoDqu5YYjHoljVn2ORUD4UbH0D/iPHUS57UY=;
 b=UQL6aBgvMOoho7WrAE8V6KXQmB2Rb27R9kqET9uEH9dRjCr7th+aouBT6nINUxownoKa1rAztFUq1KMSwAvS4sBQwBX68s4IjmkcU/6+uwoHLepy4jdtNAxPR0EBHiclRFQjfvjqiyKx9LidG9xWpijGHeXEG6iXcjs7RhOvFp9cAHHUZvsugKqjCPvyHvEH3k1ijGa6qcZPYfdK1an9Xvz8ncyozLRxv37Vbad8q2RX9CI/6vrf8G3RdQxIbRi6wrt7u9MX3o9uTbO7E7RKr6MYH+kJ6ZfSORMmzDGwOiOzr729HFJIp8DtEh1Zood4Aa6ipt9OBh4JWDsCniGyHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bp.renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YNQnSQWeoDqu5YYjHoljVn2ORUD4UbH0D/iPHUS57UY=;
 b=DV/WuUVFmv/3ePqlbGQJgGxXUNKCLTNhtczxaUFsAkzS8pZ3WUZoq+3LwPBYJsSZIabN325f/diqHS0137qP/pZ81N1gttXB3s4ZeyrEabjyaRrwubG+NDN8BUBglDLsJtOru27Sf3jmD31Bsbbr58m49kYICSf294LOYcQsum8=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OSZPR01MB9440.jpnprd01.prod.outlook.com (2603:1096:604:1d3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.21; Tue, 1 Nov
 2022 07:59:30 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::5b24:f581:85bd:6ce2]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::5b24:f581:85bd:6ce2%3]) with mapi id 15.20.5769.021; Tue, 1 Nov 2022
 07:59:30 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Pavel Machek <pavel@denx.de>
CC:     Wolfgang Grandegger <wg@grandegger.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Sasha Levin <sashal@kernel.org>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] can: rcar_canfd: rcar_canfd_handle_global_receive(): fix
 IRQ storm on global FIFO receive
Thread-Topic: [PATCH] can: rcar_canfd: rcar_canfd_handle_global_receive(): fix
 IRQ storm on global FIFO receive
Thread-Index: AQHY7TW7D2EMMc+mzUausq+Kiyen/q4psPKAgAACydA=
Date:   Tue, 1 Nov 2022 07:59:30 +0000
Message-ID: <OS0PR01MB59222BA2B1CAA6CDA9B4137486369@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20221031143317.938785-1-biju.das.jz@bp.renesas.com>
 <20221101074351.GA8310@amd>
In-Reply-To: <20221101074351.GA8310@amd>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OS0PR01MB5922:EE_|OSZPR01MB9440:EE_
x-ms-office365-filtering-correlation-id: 63cbcb09-509d-483d-b3b1-08dabbdf016d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9onyGgXBYoFgpdRSjoFjXk7OL4x35BTwiSJENgrrttIOFZu9Sq4GnxHFxHeU2z1XVbK2BBOwVnwYQ3H/eXF2G855u9iH9VOX+ym+FQSP9LTneW4Ki7QYofBnTK6TKvgjGEPN1JKwHGKkwGqtyLqY2DACxEpxO6IAiUS5B/tHyy6ArQoOCKsVQw5S2k20dsgN2nRjwZc4vNmD3Lw9RsWZFk+to6Lxx2DA0XpoPWZPQt2C5GY5UQZvSIa4YLs2FGWifkgcFK0kYzAQLntE6uEY5TY1bKW95P0eyEW25Lvvq2otzus7jeuz3S6XLqv7WfoNVZrXxKy6HJ8EM+jU4pHVkNlDcT484LVKbenE26zcIYsyFCd8uOppTUuRWc6kbLBzwEjJ/7XtFLJmdupGcROFu8ZDG7SroE96fFb8UZpZk2o7IhhQkKuAYsplbv4fNTuVHoUMZkDhCJpGCwi29DGrDEvsiGh+66feO5Lo8FadG4o/98KJ2/78zVdoEFVIOPyNtZiiHdNktWJqXwKYYGVer/zIPU4YFNffYkuQEi/S1QcOT2kA2014gbm+pssrYTAj0icwbyK8chsMOe6PpNncbETuBetCig11L2PM3Bj3yw3VQ9TMFsHtD6azVDo99r4xCSAeU8Jk7X7gy2RUC8CoOSQ+G6KNNd2ZzlJj8LvQ2kCrgRuINClNowbSof/VHoZEQKrDGIinW6WrmIlb9vUdVH/Zg8vbJtw8aNouE2M0xHaq4UJyywrmdOUYThoVE11o6s/rTpO4PLbR7w68e65D0KCGNxpzFo2YHTzv2rQ9JwI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(396003)(366004)(39860400002)(136003)(451199015)(5660300002)(4326008)(8676002)(8936002)(38070700005)(41300700001)(7416002)(52536014)(33656002)(86362001)(71200400001)(2906002)(64756008)(83380400001)(966005)(55016003)(6506007)(122000001)(478600001)(9686003)(26005)(38100700002)(186003)(66556008)(66476007)(66446008)(66946007)(316002)(76116006)(7696005)(54906003)(6916009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?xHEDxvGaLbQHTPZ4NqtkRHtB45sCWSWZFqlFED8WIQcDv5BYc8YAz/otc2uZ?=
 =?us-ascii?Q?xEQzmTU96s4EMpecvuwa7nSr4ybqvwy9N3aN09WUh+FB3v347n0qrmCbq76Z?=
 =?us-ascii?Q?Lgb6udMkIY4nsKIK/THmDl7PJg/+2O8xDJsDQD+92lMu49lCNwADeNhbvool?=
 =?us-ascii?Q?UFxksZArukqzYpdDQNUGxupGSPafO0jMVaEQbPnvEEjkFWzrNRAqnwB0Krqi?=
 =?us-ascii?Q?AIQexljj3+v4Uybe8lLjoIbo8CkAzbr/doqYKJh96XJvV0OtlFt1E+Cjz3Lw?=
 =?us-ascii?Q?VCnq8KR9G71enIICkYkzKneZlFWuvhVxyr0jasrVIgGhK7d1Fz8RWEBERLkS?=
 =?us-ascii?Q?232+z+xwJogAgsel+JeCwsES22bya+2QpXUS65PqjKDpc4QV9YDMkzBXxxlb?=
 =?us-ascii?Q?uNKu9V9M52Vlgj7V/MJhgbDfqUNADss6/XQU0xPdnBrJCEkReys74H6sNRQn?=
 =?us-ascii?Q?6xcImD2EwWs7EEZGSAdztKa+M2lFktc4+ZcvpOYxPJsdYmQjw1ntrFNnWFBd?=
 =?us-ascii?Q?H0wDBCsJBz77DzLhdxYw+oQMy8Hs5E8jQ2afwrXK/cXN91Rtj0v1Ca7y/OHs?=
 =?us-ascii?Q?cGHZBSmz3z1yTe5is4BlUTeQKLG1Jx3s3kUiq6wpvUy/WsvZ+tlB9fp5jtX/?=
 =?us-ascii?Q?0zswUM58f3kHDWPbh4sil9Zx5AXoOXA9LGCDdxh8j6QUBJY0MqrDQqxEVV3W?=
 =?us-ascii?Q?BguqXAfVFKrj6VUYehB1W8WNesQ44lziPr0hqvEUdAAz2mrxXnysxeJ5JOcz?=
 =?us-ascii?Q?NKMyrQ3eRohJJKKFDBkqX7deuvzD2IEDolAZ95G4cT9OPkAc60v/ZKD7lsPk?=
 =?us-ascii?Q?ZTFNNy95Kc4s75lVkTnOtShGECa8X8wkas+p0wPfLRq22fs85MPhfE6VY8it?=
 =?us-ascii?Q?B4wyXaBjaSsEOCD+2beqg6Z9KzzZZP+po6G3C0EfeLGy0bT3RtH1kFxnCxUk?=
 =?us-ascii?Q?Lxnn3vKs58de/Mw70O8OF4xjD8pFZscZ4wVLjoZigiNqsFj0GP8Y2puqOa9Q?=
 =?us-ascii?Q?BDLg11VCxG0IwJkhdpilWFOwldPg/1jOjR/+kc3p428XOrYtuBaN89myDg80?=
 =?us-ascii?Q?vz2hfRC/BsZuQivSasjb6I2bvkFW29VJWCKZlak1VP5V7XX/n+/CWa9qVA3S?=
 =?us-ascii?Q?kmsSWuAhbIAHhjn5nrk3A2taADNibTdZHYT0ZTzSiR5amekFY3HLsTiqLUPT?=
 =?us-ascii?Q?0aQdNP2beWW9Z1aEGt7hWDGBMpm8KM7hn8QOL36ltQQlnuT9LJOzCHrpKxmM?=
 =?us-ascii?Q?s64Acq0FkWI0PZ+NRJhJFeNAy19ShA8wldKDb3bx8vuBDyl6IcOvQsZf1+CM?=
 =?us-ascii?Q?EYMRWWLgCJn5ZeKxxlE8REPxBVMNv6EHOBmAngD2uwRpBQleYJE6JvFUTro9?=
 =?us-ascii?Q?Pc3Yspg5v3zkZX6YQ1s9H38eQ0zhVe0lol/i+sjh0ufN3auLj22FPP+GfKA0?=
 =?us-ascii?Q?CRypm8QAzaNC7iQfgsmzsWg+v+w/EwBRP82qkf/wgsQL32w5iTz67+0sXhPC?=
 =?us-ascii?Q?KlXyykxZf3Rl/PamyTMBqJcSVA8f5lI4vNAtFmcTo7mBGF1Iouck+kKk5xmf?=
 =?us-ascii?Q?oVau3x+SKMB5Q8eh+QdD+Gg/V5Vc/kiAr1wUGVyBOSnK/TXo8PaCfsW5VXn7?=
 =?us-ascii?Q?yQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63cbcb09-509d-483d-b3b1-08dabbdf016d
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2022 07:59:30.1945
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8n6pLGcROGB53GMyNi2jsMTZyg6s1FsBSDJ1JvJA1yTfCuQfNHWNiQynLfASm/QWthwtC2e1xSOaT9lFyJZCvCIDdXwP3vlV5dZVHpMtFMQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSZPR01MB9440
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Pavel,

Thanks for the feedback.

> Subject: Re: [PATCH] can: rcar_canfd:
> rcar_canfd_handle_global_receive(): fix IRQ storm on global FIFO
> receive
>=20
> Hi!
>=20
> > Fixes: dd3bd23eb438 ("can: rcar_canfd: Add Renesas R-Car CAN FD
> > driver")
> > Suggested-by: Marc Kleine-Budde <mkl@pengutronix.de>
> > Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> > Link:
> > https://lore.kernel.org/all/20221025155657.1426948-2-
> biju.das.jz@bp.re
> > nesas.com
> > Cc: stable@vger.kernel.org#5.15.y
> > [mkl: adjust commit message]
>=20
> I got 7 or so copies of this, with slightly different Cc: lines.

I followed option 1 mentioned in [1]

[1] https://www.kernel.org/doc/html/v5.10/process/stable-kernel-rules.html


>=20
> AFAICT this is supposed to be stable kernel submission. In such case,
> I'd expect [PATCH 4.14, 4.19, 5.10] in the subject line, and original
> sign-off block from the mainline patch.

OK. Maybe [1] needs updating.

>=20
> OTOH if it has Fixes tag (and it does) or Cc: stable (it has both),
> normally there's no need to do separate submission to stable, as Greg
> handles these automatically?

I got merge conflict mails for 4.9, 4.14, 4.19, 5.4, 5.10 and 5.15 stable.
I thought, I need to fix the conflicts and resend. Am I missing anything?? =
Please let me know.

Cheers,
biju







