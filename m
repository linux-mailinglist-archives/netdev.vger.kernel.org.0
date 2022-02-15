Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D33B34B6F08
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 15:46:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238722AbiBOOgi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 09:36:38 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238551AbiBOOgi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 09:36:38 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2059.outbound.protection.outlook.com [40.107.21.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C8D642A1C
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 06:36:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WDIxSwWB6aSOiYMh868z/FxlQivyedRbFO222soxsBXzUotUy+j78zC4AZMU2CLVDBto8neueNin3mQlJHFDaj7w3xgUk+HIGBW0w4ovekpGjjNRenB7SKckHFIEzkObckxMnLTcznt6tnYDfX4G6AprAHoGsQ3plKC3cYH1G/dNMA6tl3lxigAQOH+1Ca8ZNMvghQXgQeIlKZ+YM31myO/svwnmhhuAVotJ+FdQ8kxl4fDHIv0K2fxTLTKTKqU+UacPw3a2vOvH9u0ZXlSydbDetctYp9djNwVmrylQx5Q7rDzeZdGVH1YrJ4tYamKSjcHZB2964eXhx9j3rsVODQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+vyPELfoAgksDJjGCINRK45GPzmjI0sCkjbHBiTWlrQ=;
 b=M/g4LzXcY7fnNIJEbeyVwlFsL56hS1gP9QlBHXCnqRKs0kvl47rcD5jLA5khoEi9cfxpqHXyn2hdGWUEDyD62lYd6hZpLPlHJ+03snXU9AM76KbQgqj7L3uDOA3aihvtJrG2waLkTR2MFX6rG5Qf/6JwznvsTs6x8bh93ej+QOwhupI8tK8CsNo5cmv+ALuTnO8Jbo71DXwg5YEwhl57VSEPHpCWGBLPrAelRT9iW+jzjg4mBcTJG2u3S/QHHUXefWVNcP1zH/Z5Ib6xHb2Gh3UoRHBKuW0y+EfSC30g/fZ2XI68CVvfBWbLY0VcUk6iDuVhd7TfJgipVXEch304Ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+vyPELfoAgksDJjGCINRK45GPzmjI0sCkjbHBiTWlrQ=;
 b=RqSE3TbSSAU/UzoV3SsmssUmQPyDSnNKqFxDEWpompZUWZDVUKZBWE2KyATs6hIE/7htF/yhY/0O5WeOhs8ByWVIhVgSSmgaNMcnB+pYmEHzht/geuceS6p4rt34q/JC8K8OCxrjiTFJdAv85McQuKflJmuQorFuxwkNskpIKYQ=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3567.eurprd04.prod.outlook.com (2603:10a6:803:c::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.18; Tue, 15 Feb
 2022 14:36:24 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Tue, 15 Feb 2022
 14:36:24 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Rafael Richter <rafael.richter@gin.de>,
        Daniel Klauer <daniel.klauer@gin.de>,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: Re: [PATCH v2 net-next 1/8] net: bridge: vlan: notify switchdev only
 when something changed
Thread-Topic: [PATCH v2 net-next 1/8] net: bridge: vlan: notify switchdev only
 when something changed
Thread-Index: AQHYIfsSmRmY0oOnV0uNWER612b7d6yUT04AgAAQq4CAAAUOgIAABQWAgAAKo4CAADopgA==
Date:   Tue, 15 Feb 2022 14:36:23 +0000
Message-ID: <20220215143623.wg436nxsr3yxj7as@skbuf>
References: <20220214233111.1586715-1-vladimir.oltean@nxp.com>
 <20220214233111.1586715-2-vladimir.oltean@nxp.com>
 <bcb8c699-4abc-d458-a694-d975398f1c57@nvidia.com>
 <20220215095405.d2cy6rjd2faj3az2@skbuf>
 <a38ac2a6-d9b9-190a-f144-496be1768b98@nvidia.com>
 <20220215103009.fcw4wjnpbxx5tybj@skbuf>
 <5db82bf1-844d-0709-c85e-cbe62445e7dc@nvidia.com>
In-Reply-To: <5db82bf1-844d-0709-c85e-cbe62445e7dc@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 72b13fe4-3903-480b-5070-08d9f0908aa9
x-ms-traffictypediagnostic: VI1PR0402MB3567:EE_
x-microsoft-antispam-prvs: <VI1PR0402MB3567C36F9D581B1CEB3A7FFFE0349@VI1PR0402MB3567.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: skMJL+P4GUqkQPbZn8oCBKe6LKw5FKDRyPOmP4afk0OWSTea7eomzy6p8Rd5GjZ6vpTFp3BIqUeDXjwyKUS2HYzI/OEPkJLpIpEFrbEwpHAOn9cZR3EBNmsZsgG6bqAAwDSFRqz76S79u2RL29KyrlE4G68ygf7ozuX8MFjfRyWZ1CG72aA9SocMXFGT4DIkcf+NfCrmKwMU7hOCD0jR9BpeQyHxY3EZmDgY/FrPtJuOdjusUqS7bEZxKuTCwXfyGEhBX9uqZ7StlJLWVyUQZeuyLaVa8Os2qDJnF4hgXGNQGj6YdxtwnCBAp8z1+Qu2jmMRRQ2y5A69Iau1jb9xWMzOF431KXStCx5NRi+XonEQdEvfo025XT4NHX2UyMLzRee6Cch2Hchb1ir41IZ732+YybNVRy5TkpjaHuh2s5wt2V4f3rbuPWIjRLC4HYd7afuMtUN/D3EhJdLnpRUwh6yg4xpRxC7vDT11phdTyA0DHRA4XD1+RuOu3WnT5aPkjM6f7/Z+qBcq5l3WEWWRvPlXKP/qR0B6Vy/TpM83naLCU/mclu5tubxKCisGnSVdIoVU09qZTqOIxIqKDYCamNjA4tFQMEwjl8lAq4dMrywVTrbgPHEWmULcK5wEcAb8JFp/6ObAn++f7Elm27tJpzAx1ndSbtMTgRHRrF/DFpH7TFmkKqPqxEsRUiaRA0tDspvh+gAaBeMSrfqyA6fcNA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(76116006)(86362001)(38070700005)(66476007)(38100700002)(122000001)(4326008)(6916009)(64756008)(316002)(66946007)(66556008)(8676002)(66446008)(54906003)(33716001)(91956017)(44832011)(1076003)(6512007)(7416002)(8936002)(2906002)(5660300002)(186003)(26005)(6486002)(83380400001)(9686003)(6506007)(508600001)(53546011)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?gjz4iwbdhgLg+FSzvxuPzRI14VlwNJBSIUJIKjflv29qPvYYO0jmcoQXP5qN?=
 =?us-ascii?Q?2ZM3Mhu7KdGBCbcBwFYWK5tuOpVuldQ5JIAFDhEXNHV9uJ5y11lQRt45cbEm?=
 =?us-ascii?Q?m3ejANHWLuYRLPGExeCu+4vN9FPZYMhH4Ov4d1mQnqUjAhJBUKHvovwpufPy?=
 =?us-ascii?Q?9/vwJ0hDVhWS4k1Cm8qaiCsqUY9qasoFRMyrCqTPtrkkhYizG9bCbVhNycN7?=
 =?us-ascii?Q?FsFLrgcwV2WVZUp67P9BkNFuLkDKbwO6AroknjelbCiIXOyV+TiTYf0YDOiN?=
 =?us-ascii?Q?uGBq/HrUNU3qVOOn3L4GdIuQFeq9xtNETQFqjNMNfWJuyhpZcUYEt+28Loxj?=
 =?us-ascii?Q?0E/dG8qmWaPtX8CTI/vKIZBr0tPMJCPpTYVJLM0I/t5LLjWYKrTHxe5aeeVL?=
 =?us-ascii?Q?l3dkV/qvv/+F2aA3+o7vRiC3Az3+T89XQNtRePERVy2jVJFNPJIaoiz3qmLG?=
 =?us-ascii?Q?BKqt47+SWDrxyyWb5UBdLTjrAlix7QrVq1LfYC63oEhLzhyfPKhuhwN2yqpA?=
 =?us-ascii?Q?arV+Y0BznYA1Ww6y+gj8M/lMDW2/kXppHA2S1NGv7dpaJr9cb08KE310YXoV?=
 =?us-ascii?Q?XG0eaMAg3AwYb+R2oH5aP8Redr/Rl3E31BjrB56A+QiRf+UN5ipVdXQZF4tC?=
 =?us-ascii?Q?fOenU1sav8KbawMeWDNAw5FbMQ8efqPQttYHGTyqaQAVwRLp21X3D0Bb4eUO?=
 =?us-ascii?Q?SEA1H/MhWOXnoJ4g1DtdElLcmiLMXqHtp9bas8Y3z/nrxqhWEDSFdq6NNk8d?=
 =?us-ascii?Q?S9vhbklsAE12trFeFDXmIsi1nGOjqqbaQNtpM6WqswXitK6MlY/P+dHXR/z9?=
 =?us-ascii?Q?cDXnYnhXAETogbGbR/HuJS6Tlyqn9VIm31D4RtS05tMwLzEN8Ka+osT4WZ/m?=
 =?us-ascii?Q?zypWigLG/LoMTiq1NB8A0OmHSkJ5ooVYYmN2l5NDwUXCBoMG9YnErE2MsY4N?=
 =?us-ascii?Q?Nb81OsXSX9KBpr6syP1+l+FW91WXM6PzwDpfls7/SBAL+VlGiJFRbekK0rwL?=
 =?us-ascii?Q?AoLeJGNMrhiTB22kn/v+4EjCEE1S22r/pBg6S9lZ/Nk82YzObayUDruAhjZl?=
 =?us-ascii?Q?EsPNZnnOOIU72C7OViVYeFWLv1r+zTaJVCX77pdQYe7GUwGj/3xD9IhdsrsP?=
 =?us-ascii?Q?9XGfUfI+f7Toq8C3VXcgSrTYcyCaQCKTVgD0OIO6yABy2CpHHLhphhjriVF7?=
 =?us-ascii?Q?UXl06M/6nHtY0/kpiBKw0lh9R/8St/i5NBoZe4hCo1vCOf8fzV1bxJaAeTXk?=
 =?us-ascii?Q?At9y/HZPYwDUNhGLf3pGKALlqtx5/B74RcyGBqFzxss68jY43VE2cRFTkxU3?=
 =?us-ascii?Q?xv6/gbtuFqDrYwfOUr55FhCRxk3LDhXSi5YGK/msiMGS9MuK+WYrWaJAKY8V?=
 =?us-ascii?Q?ht5dsdY3PS1u6SW8F3aiVcu1WycV1NcaOmRVnjU20APwwizovGAjtqPB0mY0?=
 =?us-ascii?Q?8W4C1KeOmIKsL0nRQcZx/yBdkBamID8sKFUn5jEHBNVJXydStQroHYmvoTUL?=
 =?us-ascii?Q?2wgADGkp8uELkTildd5EE6cm8ow3YfGVyAk+DYXJJ9q6buVvZJZJqcOqXjdV?=
 =?us-ascii?Q?UqW4yT1MD2EE8SR90PeXvVuLtrfamXGpahlhWJPWvsie4dbSigNXMVwkkOSj?=
 =?us-ascii?Q?5Dh0aG1fHpv6IguthI4ltc0=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7A54735D7A922241B7CA0B810F35295D@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72b13fe4-3903-480b-5070-08d9f0908aa9
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Feb 2022 14:36:24.0382
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Sy0SPmHay4+CHBtHt74SGrbcc4D5BYBKGszhsDh4Q0YhkDXI+Y7oD7sSGDPl3MVoU+F9oExzpAGokXxnIU3CZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3567
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 15, 2022 at 01:08:13PM +0200, Nikolay Aleksandrov wrote:
> On 15/02/2022 12:30, Vladimir Oltean wrote:
> > On Tue, Feb 15, 2022 at 12:12:11PM +0200, Nikolay Aleksandrov wrote:
> >> On 15/02/2022 11:54, Vladimir Oltean wrote:
> >>> On Tue, Feb 15, 2022 at 10:54:26AM +0200, Nikolay Aleksandrov wrote:
> >>>>> +/* return true if anything will change as a result of __vlan_add_f=
lags,
> >>>>> + * false otherwise
> >>>>> + */
> >>>>> +static bool __vlan_flags_would_change(struct net_bridge_vlan *v, u=
16 flags)
> >>>>> +{
> >>>>> +	struct net_bridge_vlan_group *vg;
> >>>>> +	u16 old_flags =3D v->flags;
> >>>>> +	bool pvid_changed;
> >>>>> =20
> >>>>> -	return ret || !!(old_flags ^ v->flags);
> >>>>> +	if (br_vlan_is_master(v))
> >>>>> +		vg =3D br_vlan_group(v->br);
> >>>>> +	else
> >>>>> +		vg =3D nbp_vlan_group(v->port);
> >>>>> +
> >>>>> +	if (flags & BRIDGE_VLAN_INFO_PVID)
> >>>>> +		pvid_changed =3D (vg->pvid =3D=3D v->vid);
> >>>>> +	else
> >>>>> +		pvid_changed =3D (vg->pvid !=3D v->vid);
> >>>>> +
> >>>>> +	return pvid_changed || !!(old_flags ^ v->flags);
> >>>>>  }
> >>>>
> >>>> These two have to depend on each other, otherwise it's error-prone a=
nd
> >>>> surely in the future someone will forget to update both.
> >>>> How about add a "commit" argument to __vlan_add_flags and possibly r=
ename
> >>>> it to __vlan_update_flags, then add 2 small helpers like __vlan_upda=
te_flags_precommit
> >>>> with commit =3D=3D false and __vlan_update_flags_commit with commit =
=3D=3D true.
> >>>> Or some other naming, the point is to always use the same flow and c=
hecks
> >>>> when updating the flags to make sure people don't forget.
> >>>
> >>> You want to squash __vlan_flags_would_change() and __vlan_add_flags()
> >>> into a single function? But "would_change" returns bool, and "add"
> >>> returns void.
> >>>
> >>
> >> Hence the wrappers for commit =3D=3D false and commit =3D=3D true. You=
 could name the precommit
> >> one __vlan_flags_would_change or something more appropriate. The point=
 is to make
> >> sure we always update both when flags are changed.
> >=20
> > I still have a little doubt that I understood you properly.
> > Do you mean like this?
> >=20
>=20
> By the way I just noticed that __vlan_flags_would_change has another bug,=
 it's testing
> vlan's flags against themselves without any change (old_flags =3D=3D v->f=
lags).

Yes, I think I noticed that too when I put some debugging prints, I
wasn't sure where it came from though.

> I meant something similar to this (quickly hacked, untested, add flags pr=
obably
> could be renamed to something more appropriate):
>=20
> diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
> index 1402d5ca242d..1de69090d3cb 100644
> --- a/net/bridge/br_vlan.c
> +++ b/net/bridge/br_vlan.c
> @@ -34,53 +34,66 @@ static struct net_bridge_vlan *br_vlan_lookup(struct =
rhashtable *tbl, u16 vid)
>         return rhashtable_lookup_fast(tbl, &vid, br_vlan_rht_params);
>  }
> =20
> -static bool __vlan_add_pvid(struct net_bridge_vlan_group *vg,
> +static void __vlan_add_pvid(struct net_bridge_vlan_group *vg,
>                             const struct net_bridge_vlan *v)
>  {
>         if (vg->pvid =3D=3D v->vid)
> -               return false;
> +               return;
> =20
>         smp_wmb();
>         br_vlan_set_pvid_state(vg, v->state);
>         vg->pvid =3D v->vid;
> -
> -       return true;
>  }
> =20
> -static bool __vlan_delete_pvid(struct net_bridge_vlan_group *vg, u16 vid=
)
> +static void __vlan_delete_pvid(struct net_bridge_vlan_group *vg, u16 vid=
)
>  {
>         if (vg->pvid !=3D vid)
> -               return false;
> +               return;
> =20
>         smp_wmb();
>         vg->pvid =3D 0;
> -
> -       return true;
>  }
> =20
>  /* return true if anything changed, false otherwise */
> -static bool __vlan_add_flags(struct net_bridge_vlan *v, u16 flags)
> +static bool __vlan_add_flags(struct net_bridge_vlan *v, u16 flags, bool =
commit)
>  {
>         struct net_bridge_vlan_group *vg;
> -       u16 old_flags =3D v->flags;
> -       bool ret;
> +       bool change;
> =20
>         if (br_vlan_is_master(v))
>                 vg =3D br_vlan_group(v->br);
>         else
>                 vg =3D nbp_vlan_group(v->port);
> =20
> +       /* check if anything would be changed on commit */
> +       change =3D (!!(flags & BRIDGE_VLAN_INFO_PVID) =3D=3D !!(vg->pvid =
!=3D v->vid) ||
> +                 ((flags ^ v->flags) & BRIDGE_VLAN_INFO_UNTAGGED));
> +
> +       if (!commit)
> +               goto out;
> +
>         if (flags & BRIDGE_VLAN_INFO_PVID)
> -               ret =3D __vlan_add_pvid(vg, v);
> +               __vlan_add_pvid(vg, v);
>         else
> -               ret =3D __vlan_delete_pvid(vg, v->vid);
> +               __vlan_delete_pvid(vg, v->vid);
> =20
>         if (flags & BRIDGE_VLAN_INFO_UNTAGGED)
>                 v->flags |=3D BRIDGE_VLAN_INFO_UNTAGGED;
>         else
>                 v->flags &=3D ~BRIDGE_VLAN_INFO_UNTAGGED;
> =20
> -       return ret || !!(old_flags ^ v->flags);
> +out:
> +       return change;
> +}
> +
> +static bool __vlan_flags_would_change(struct net_bridge_vlan *v, u16 fla=
gs)
> +{
> +       return __vlan_add_flags(v, flags, false);
> +}
> +
> +static bool __vlan_flags_commit(struct net_bridge_vlan *v, u16 flags)
> +{
> +       return __vlan_add_flags(v, flags, true);
>  }
> =20
>  static int __vlan_vid_add(struct net_device *dev, struct net_bridge *br,

Ah, ok, now I understand what you mean. I'll integrate this, retest and
prepare a v3 if there are no other objections. Thanks!=
