Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04EA76131BF
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 09:32:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbiJaIcS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 04:32:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiJaIcR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 04:32:17 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2045.outbound.protection.outlook.com [40.107.20.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CF075FAC
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 01:32:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dn6vvV27odqjmBwxj9fzT+MAwkew8op/1zJHoXuJCj8Gi9IaUi/zVUrFATt75dmGWJuLuF7/HYHmfJ2pJQubiAbjZbXLdKtoXxQOfYwj1eSnRuUB6sKCDQIHvfOHDjzbqrmnJGnf1S/4XR5EG5MX0VUIIvGcTjgmzX7YxP3cVU+Lj+DG6axxAnmLp1rUssDoukFA1FIHmdh0KE/KEbqgpVWdfazNKrItYCjLYkQi7mKWXYLvNyIgP/Cqnz9J27j6sVHRzbRth9KQ0QP+ONM2rrallmkyxzOhjGheAnpD3872uGcLbKwbrBqi9CQDrqLKCtVF7A2U79S7KLkfi99+rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uE9E4lgEDewYRSChq0WRD2OZ4H3ZL80r0nYUv89nFJo=;
 b=hHTF6tYux/RGtv7JyYRzLUx4MoPbllSCM05wtuzvc7WJsoJnf9noeXErii4TYa3e3Vq78F1Pqvx6weNxudg17C0A9MRHNwZfrbKGmCelZomMXSCENCHZD+zWF91KdyxCXpHrTpmBZZ520Tl5/G517Qeq/q+dmd/ZjvHs+QygrWAmt9JGwz7r+8q+eMb+IwCfRPjqQGEuHhE452REHYpqAZxt75ltARO4sEH90rzXbTHeRTMLmsHLjXGzICt5QsJuYYuqH89FE/ikEoaCJslEGq8wIINrCI293MSSKh+scNql6f8szAX1xVx/TTFwGdlS00+7NwTTO9d5NSZscy8f3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uE9E4lgEDewYRSChq0WRD2OZ4H3ZL80r0nYUv89nFJo=;
 b=SoYrm1lEulMbcHZulJUHXJhjHR1QwibRx9+gPvH/dwvGu+rz+de4wb+fDDsnX/fBR3YKb7cs5e3H0dKym0T90a8Hjyc/oYEXZeJp9IGGYbEAvI/OwG63ioHTa/qQPz1cHQVwx4ftQ4xjrce7G4723W5r+9Ew6ZAEME0gXTz52f8=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB9PR04MB8331.eurprd04.prod.outlook.com (2603:10a6:10:244::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.15; Mon, 31 Oct
 2022 08:32:11 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::df5b:6133:6d4c:a336]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::df5b:6133:6d4c:a336%7]) with mapi id 15.20.5769.018; Mon, 31 Oct 2022
 08:32:11 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Ido Schimmel <idosch@nvidia.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "jiri@nvidia.com" <jiri@nvidia.com>,
        "petrm@nvidia.com" <petrm@nvidia.com>,
        "ivecera@redhat.com" <ivecera@redhat.com>,
        "roopa@nvidia.com" <roopa@nvidia.com>,
        "razor@blackwall.org" <razor@blackwall.org>,
        "netdev@kapio-technology.com" <netdev@kapio-technology.com>,
        "mlxsw@nvidia.com" <mlxsw@nvidia.com>
Subject: Re: [RFC PATCH net-next 10/16] mlxsw: spectrum_switchdev: Add support
 for locked FDB notifications
Thread-Topic: [RFC PATCH net-next 10/16] mlxsw: spectrum_switchdev: Add
 support for locked FDB notifications
Thread-Index: AQHY6FjUVuDB5/kMGkqgz4g+zKbN+K4moPuAgAGU3AA=
Date:   Mon, 31 Oct 2022 08:32:11 +0000
Message-ID: <20221031083210.fxitourrquc4bo6p@skbuf>
References: <20221025100024.1287157-1-idosch@nvidia.com>
 <20221025100024.1287157-1-idosch@nvidia.com>
 <20221025100024.1287157-11-idosch@nvidia.com>
 <20221025100024.1287157-11-idosch@nvidia.com>
 <20221027233939.x5jtqwiic2kmwonk@skbuf> <Y140a2DqcCaT/5uL@shredder>
In-Reply-To: <Y140a2DqcCaT/5uL@shredder>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|DB9PR04MB8331:EE_
x-ms-office365-filtering-correlation-id: 3c5ac156-228a-4045-1f3a-08dabb1a67da
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aaHLHWY7rC8rsWlwvXkyHC47/EretOCIUQjORthsxJ1qR7BDw3zLw+6MdVPHvgc1rguh5kxJDZJhNxgKuIC1CAEi+AKx8tDXgyVWv/KW3K/fFJG/fmWxrOVkY80eNfS3HKOEBAIEu7isrk84UQbF7sDORbXV8EPTQaQVrE35iKwhxztCA7oUT2mORJUOapqt0QkmmE+CpoaXiBeIqEODcaxWNPArKo6v08U5MKPmYA5pGd5DWLcIhpYwRmebUXrHNYmNb/IRjONp6jD8EVmT9oxp9btC0CPhq6NS5fu0NBqugPd11OvO50W4ezwyLt2tMCC1f3khjQfCZycmikRS05AZOJxr3SxHBTxEt+OOpI/Q/igmw5NLoFgsJafcyB8YwtEJBsjrPX9w7tFEahpg0CCn6Dd/IHILGCjFuECwXIlUUJzv0ir3Qxd40O37VeypUFxsd2bRp62B+dsNc2xBRYE6DOf3qfro13i+2jA2sJY/TlRmVAitJ/NDS+4EkOcONbceQE7LRZBQ4vKCFgaQa4IM3ctsK6UOB3+VWBxgkyEyh8eOlR4EUw5tHfBLNSY931fEb0qlYaWysmanJTj7Qq9kiAxeGkfBZW5hrKvwIhotlaJ21UszaYZrGVxWLauovJvEKAQXXEWTD/J3Gy8DJVRCiSY29eWXcc27JoPERqk5ndO1g6pdPh4VVsUVJ/2kGpIurQJjagw0WZswh79c+PZCCZBoBmHgb5bS0NUwUJshN/gHIaDt6WUuS1O0MXNlAxprtq4fQVd/tse2wKgHDg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(346002)(39860400002)(396003)(366004)(376002)(136003)(451199015)(478600001)(71200400001)(38100700002)(6506007)(6486002)(122000001)(86362001)(64756008)(83380400001)(41300700001)(8676002)(4326008)(26005)(54906003)(76116006)(66946007)(66476007)(66556008)(66446008)(6512007)(9686003)(33716001)(38070700005)(2906002)(5660300002)(8936002)(6916009)(186003)(1076003)(7416002)(44832011)(316002)(4744005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?wXt1sJYxueb/GPmf/J2SoB7edQqKJMVcOi1gCf8hzw0x/tozHzwYxm3TETvJ?=
 =?us-ascii?Q?6MeufdGNRop4aZsdw06CpVwFC/wL3WuqPn9H5PonbsjUnX2D5DlOsXbZ/6I/?=
 =?us-ascii?Q?kky1oeWs/Y+EsO+ChLFLmXGSd7kgWvFeseuIM1NWe/OwYTbSeUQMW9vs3aJ+?=
 =?us-ascii?Q?XcxECtcZz2c/0/R32HSt9eFANHwOoaB/IHS0Dri3/rWfzT6N0OqSjnBL3mUh?=
 =?us-ascii?Q?ktiziDnvNhoLzayOSbzwtc81C1THE3ZOsw9v/jZzLKzj8GFbLDrfo7r/dKxP?=
 =?us-ascii?Q?bB6hG3wdj19hjGuyRFgUsAMl+qNr8rm04rD4R9DjsCPYbPTqAkdcpLRzgZUJ?=
 =?us-ascii?Q?u3QJJUmmbopMqQXCRyGu0HkwBkHlxYMu4+y038DkiJu9KWwBdI6vxyhhAQ2z?=
 =?us-ascii?Q?WQUxcXXFziDY4fRo8MfpP7YjXViCHbM/6IEZCXH9aFhZC4yUBBDDg4HQJ94n?=
 =?us-ascii?Q?BJpFGyKB5xQsrKHu9OwAwfJUl9qr6kji4bqISKowAQur3KE0h6ub2BSvnJZ0?=
 =?us-ascii?Q?gSC7G38r+0IatdHYG7Ur412r2c3qEL+2at8YmcG4xUOoEDO3B5X5j7966jy5?=
 =?us-ascii?Q?KLa5sWBMhi3v0+LhUVkq8gQTtIzsVSatf+h5a07KLJGCIewrXWlMMQ6vplOj?=
 =?us-ascii?Q?WjsYDEjx52592VIFEat9I5MwJ24smdcaExh0AuNwMdkOZVXb3A+XUtb3A5OX?=
 =?us-ascii?Q?wscdnzM+AXLUYJ8ZdnlBJ5wwbdHa+gElVofknf+RANWj0tKhNgy3ATiZ8QtE?=
 =?us-ascii?Q?1LXAl+ObxlAU2pSbtgbOAWat14jt7pRg5flYfXuBjnx09vrNfjM0BikbpeGb?=
 =?us-ascii?Q?imgxmbbo21YPV0GDksgwlGxKmk+zWTpPVnmlnSgjOwtzPXeNbM90njqPQW3H?=
 =?us-ascii?Q?zdfpi0/m8+Kus0OyUBnKGOClwL64Dbk/so8ydwfXgeN8L5o3bKDTeU+MUZhp?=
 =?us-ascii?Q?NVdJxnuGi9Iz8Bg9wpb+NB8YCzpIpCMg5yjiDK5SLq2iX5L7j/hSS1E0bqFV?=
 =?us-ascii?Q?diNke3PMtRFjdMzZBNjKTo/ObpnOOwxNxrNdCI/Kt5cPnKH6mM+ku44VLOCg?=
 =?us-ascii?Q?Eo8dIT6j2WE7b5qIrGZR499O/zjxrw8pcBsO4Vv5krONLdDls6HEOceH5ocW?=
 =?us-ascii?Q?zNAkoydhrBPn8P0K4rxe5XH7Frwk+jUyD4fFDBKP4GuDEC8g+JcUJ/6f3v6J?=
 =?us-ascii?Q?SuPcHRHb5NRh/UK4HTaRKUrxWbusPqGwLnhlcUgD6Xu2Y8Z3gW6i0ZaLPmdP?=
 =?us-ascii?Q?2/Vt1UZI+bEhEDMdSeNWrzGtH1JiFXoPAy3aEz3zq4XhHjrqOOrSaS3Gytqx?=
 =?us-ascii?Q?MKJzQzK7SJfJ0Baw1ftOArPzCMwlvpQCzGz6hETdg/yz31W1LVZCr3b7zBnp?=
 =?us-ascii?Q?6qedzaSDVMsRx7npvEcjEDrOBjDBpprbFCG8g0lbH6dAzYjSImR0yVtVRmA0?=
 =?us-ascii?Q?b17fbosqZOvC7kuXgBGCifgLdtWrGQdFbhfC56KjmD5epiWlpiSnZmAnBpAj?=
 =?us-ascii?Q?2L69zKu+i33UH3IsmgNQS+t6jcXo+myXCwNtM4pe3QX1ojmSsUfQXi6GquX6?=
 =?us-ascii?Q?UNoBolFTxYGCDcezbboKFEBSLZzZ1rumi4K/AqvdnYRX/qt47+P2VDgu/b+n?=
 =?us-ascii?Q?SA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E227BB77C4ED9F41968F92FD51D3F3BF@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c5ac156-228a-4045-1f3a-08dabb1a67da
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Oct 2022 08:32:11.1925
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Q7GoJGp+Dk8LriTmNamj6s1195AJ5buGb7z6qxA4odJXXxNEAG9F7uWJ4ulhD/qAB9J45b3qoaCQ67AFVI4tmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8331
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 30, 2022 at 10:23:07AM +0200, Ido Schimmel wrote:
> Right. I'm quite reluctant to add the MAB flag to
> BR_PORT_FLAGS_HW_OFFLOAD as part of this patchset for the simple reason
> that it is not really needed. I'm not worried about someone adding it
> later when it is actually needed. We will probably catch the omission
> during code review. Worst case, we have a selftest that will break,
> notifying us that a bug fix is needed.

For drivers which don't emit SWITCHDEV_FDB_ADD_TO_BRIDGE but do offload
BR_PORT_LOCKED (like mv88e6xxx), things will not work correctly on day 1
of BR_PORT_MAB because they are not told MAB is enabled, so they have no
way of rejecting it until things work properly with the offload in place.

It's the same reason for which we have BR_HAIRPIN_MODE | BR_ISOLATED |
BR_MULTICAST_TO_UNICAST in BR_PORT_FLAGS_HW_OFFLOAD, even if nobody acts
upon them.=
