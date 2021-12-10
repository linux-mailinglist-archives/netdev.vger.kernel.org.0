Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A028470BCF
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 21:22:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344190AbhLJUZv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 15:25:51 -0500
Received: from mail-eopbgr70070.outbound.protection.outlook.com ([40.107.7.70]:59303
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1343918AbhLJUZu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Dec 2021 15:25:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nrxLagAEV6mBLVq+h6/im9Gu8AKZ8Mge7pVnCZn9q6sBl4wYCbXIaW7UzaGLa1tZ0/Ekw/z/0rRfjoADxw6qfPLxOC5M8jKghaIHe7aPXPH3ChMBinnLpBOY9onlNLJMLPsYdWQar1niwSzGtrq6W+MllWZLc7tswFBeZqRFIUdfJKNVRJ9NncQaYC/a/JT/F1eU93NIQh388b1uyVrayjiGAJbhIzBBN/4Of07fVmh/tOXNHWKfnLthBPOoKfLp9ktsGxySuypXpw2Np8uRz69oNXaFpgooLy2IMblCwv+25bD7M7EEIBrexvlzlQEQU62uGwOwoa5nxLKYdFNbUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cGYTsR47w25JTdh2SQTKgn/9L+p8X+NhxIcIr2Ht1Ls=;
 b=jJWFT82JkNNqAwOQJrNd0oEI+bwT4xC16rE/8uIhyT8fB+EInzdFryE36n8G9l7LyQNwJCq7eDbjDa+ZzsSI9QHvPCJTeBVkLxUB3KDZvlr5jTWgIXd6xrsP3SmHjx4eEVVqZv/46KkxtqhNWMbVWVm2AQMVY56d05uI2SImm2V+kn7C6uhVEtvo2h6QC8BKD3ZIQsvSlTrGz+MHylxwoeSbfAh6XWbK6/RLrmh0KgR0OV5evEdDD1sJHql+U2NMXBOn9QiPnU6+gx1cQiB3YQnlVUZUI4mTXas3mu4G3L2/nKMuHdti3yO81AtXaEI7eUOMKabaz+qxpFnhkkEFHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cGYTsR47w25JTdh2SQTKgn/9L+p8X+NhxIcIr2Ht1Ls=;
 b=kyWBzYuHp39Ze3uEvhavTb7sQJKJYz49r6FnuLp4X8KCDVfB4F0b4wsjrD9QACkoREkmO7WkfMZFS5y8g+ajb51+uMbjqwW4+2ra6KugDK6k53UE3RyRsWK/GJSHzyHuzPRn+jeYTL2MxVHJ7Ez+YxrlYrHFrZw+QMBaJzhMtlw=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3838.eurprd04.prod.outlook.com (2603:10a6:803:20::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Fri, 10 Dec
 2021 20:22:12 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4755.026; Fri, 10 Dec 2021
 20:22:12 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ansuel Smith <ansuelsmth@gmail.com>
Subject: Re: [RFC PATCH v2 net-next 4/4] net: dsa: replay master state events
 in dsa_tree_{setup,teardown}_master
Thread-Topic: [RFC PATCH v2 net-next 4/4] net: dsa: replay master state events
 in dsa_tree_{setup,teardown}_master
Thread-Index: AQHX7SPBzLI9pc62CEWhffAXLLagcqwsLPGA
Date:   Fri, 10 Dec 2021 20:22:12 +0000
Message-ID: <20211210202211.honcf4lugvknjwna@skbuf>
References: <20211209173927.4179375-1-vladimir.oltean@nxp.com>
 <20211209173927.4179375-5-vladimir.oltean@nxp.com>
In-Reply-To: <20211209173927.4179375-5-vladimir.oltean@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5551c86d-472d-4bda-053f-08d9bc1abffc
x-ms-traffictypediagnostic: VI1PR0402MB3838:EE_
x-microsoft-antispam-prvs: <VI1PR0402MB383833E03145474E19D78D3AE0719@VI1PR0402MB3838.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3173;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PKKeFUYxkpEKlOWLIsEvcH9XB6qmKRqToM1DK7sYrJL1lIaxkzI1rfRxxUavvVgD8T+MjTMzopjOKs54EOp2I9wrpxcnwrY2bAHT3XfJDiKYExeHqGmRg4mPbPCYhquCU8cOuqsS7Ut1HIKbuFaYcvxhP2P/wwPH+dD/8wC+EQ+vdTsKZE4c4knQbyanIJnxPxIRZdmeG8ixn1DCpc1sj9y8cxUbjvNseYXSY4LHdSCL4ZLvTRDg+kf4y94Q58uuUcC0V4WMVPfs7ukf9HHKIEWGz0lpfH5d0yWFhAtVh+ZbaG8Fcvrfy9CJXngdJemd9/8pya8zeE//wpf9Nbzl1PZo+eFB8EGZ+cmI6EbtvESYVGsEWsoAknwbCaSwArB04I5iYgUNdKLUY/JZ7lNnCRiqvfJHPmIV1++M+cbHZP8Pp5OiUHazXMus0WtByKNPtxaKrJL0le43Jk74RlpL2KHh0B0utmJVxE+qcGoUZ5Kp5tMefng1B4dDsxQiGRUXd25n89vMbRcKAKojXJvgN/Rz7Ml7fOZowjbOMtS7vF58uGXjdKO0Gja854eRTRXN9xZbNm+KnI2PxETNc/htzADAgbsZ7hPt8M7v0o4eM+fM5AlI4Fx4+CRK+kZ+nOXnh5Gi34OBCxKh/SvC/gF/od61H+51ri/LrrH+4owKxWibP2fDXit9BbpTpNqLUTfw65kRrpSzl2PKaLlR6F7mZg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(71200400001)(33716001)(6916009)(5660300002)(66946007)(6506007)(38100700002)(76116006)(83380400001)(1076003)(186003)(86362001)(4326008)(91956017)(38070700005)(122000001)(9686003)(6512007)(8936002)(316002)(54906003)(66476007)(2906002)(508600001)(8676002)(26005)(66446008)(64756008)(66556008)(6486002)(44832011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?WPgKTMw9x1PTXh2zkBBlF6UU2ASnptPndrye4i2bI45a1itXnYsIkgNIldik?=
 =?us-ascii?Q?WuOu1mE0wPSG6IzIGPcT8q61DTBTOV6BTqvWBexyUhp48453KtOetIkEFAkk?=
 =?us-ascii?Q?CxJqqoCBmGUvszA7T4GLG50fBAQPoOaxfXS3aKfm3ChzsB09+2kq/lTtq0QV?=
 =?us-ascii?Q?lC8FZUSi8i6mTF47PW3PvBJzcky4631688oq5YbA2eBpjPPYeJFdFpfmBC9f?=
 =?us-ascii?Q?6M1EH3NSp8y+JH/Zx/tjPGiwXwKnHZCs5Owmw40NrTHK0PZTi+Zslv9TWazP?=
 =?us-ascii?Q?bVd6xILCGpBL8q1wQld5mjx+2uFppTIj7ZuIFuiJ+EN3BYb5zsAxdzDT9Dg7?=
 =?us-ascii?Q?lyQxY86z8QQYovlWYIp2v3W3PA/DwcP7gS+IaJFxYoQMe8TXEnQpBAYR8PgM?=
 =?us-ascii?Q?QEvAw7Rt1xkyHXBcLa5u6L6wsF3ZJQYmMXFDFJjUa9O/3FCDOdc+sIDmy8yx?=
 =?us-ascii?Q?vxTmJjtKm4IRx/Az6IvDTQwUZDhh1ATSkQktXFcUk+FqB5Fh74a7NWLP6n+U?=
 =?us-ascii?Q?27uNoLshKJiXSiupN2RGerIhz44LScGY758sgJAQfHpZxN67CmK2/J0dcc2w?=
 =?us-ascii?Q?ulbnQRh+qg42Q+gmctwGApiGTWBMAZSRLiJy8Mq6iidhyQUMyaOu0M/i75r2?=
 =?us-ascii?Q?izqrSYr/qy3a1k0P8vfZ0OqU0M8i/ryZt2ztmgv9YvetJpqRaYqBGHGq3VLu?=
 =?us-ascii?Q?zFdShkq5hNbt8GgBaMGantzo+iUsQpyVTl+ImSf2ZuQ8XQ3cRNGDisY3VSz+?=
 =?us-ascii?Q?JK2ZSOtebnRQwrGxqpHl4sEW3ZUPlw+EPOaZT28i+W4VrIMbnBzmPoqzlaSh?=
 =?us-ascii?Q?CkpRLoEcM+DfncHiptVmBc4FQ5t57uH3Hdf7SkZU6l6bUbc6nJYzOJvOKFjL?=
 =?us-ascii?Q?aJ2Nocqy4ZdqnmyDEIWXUZxWCNoz8nMcKZNAQJVX2yxteIi5XaaCZ+FhH2er?=
 =?us-ascii?Q?SMvF0jIEW7YFpPRMMXs8kgAp0pkp8aAcxFRNdPAgnlHEjZMbDtqpQAjL7yG1?=
 =?us-ascii?Q?jwC/V+Dhbh+F+iq709vgmpHOfpZE66Rq0m6njIErl8Otco1cR8Fzi3QzdaZO?=
 =?us-ascii?Q?2pSy55mmKlpVchR9Dn7SMlZPEfDyz4//rpRg9ai0z8kcz6IdWJBdn3li65Ag?=
 =?us-ascii?Q?AdP5WW/kOYctr+YLsV083aqWXWvWmyCvHhG1IU1/xhNvcdvoV5dsu5koc6Yd?=
 =?us-ascii?Q?gFu87pHcLmix8KQEban85T7IUNmCO9Lbe68XH125Ucjwmv9ui9Qhjst8Mf8k?=
 =?us-ascii?Q?+bObeIlcsgzc3S5pwf+QhvCxkc5bnx0GWVq9pOWrml7X111I1wSgo/T5etWI?=
 =?us-ascii?Q?18+rVv4Cld5OQ5kJIiCoslIjrwETuDZ5UA01m8bAUXUY5tqzSr3XOD0VmO6R?=
 =?us-ascii?Q?rZY0KxeoRMSxQEDmlunENbLBcK1t7w8aFCisUIEoCRkhTRVNXltmVS8TJVbd?=
 =?us-ascii?Q?4kuW/smiArHTU4GF4u+YfT04DEKbHI9meeX31IZ4DzK6yWJEEzAGILnMGSBr?=
 =?us-ascii?Q?XM89Ghx/jW1YHSG/26hI5DiFQWbQu8kts+FPlsEmT2dYnM6NSbXE2TEtJQcr?=
 =?us-ascii?Q?n5qQHZpj7XpDFg9arDYCzaG6fZVEUaUfIewgn9CfCEHxX/7SM45jd5Th2sya?=
 =?us-ascii?Q?Dal95fXKIo0Jk8rcBrEFsOM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <57A9D63A9C2D17409DE3477F9E05E09F@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5551c86d-472d-4bda-053f-08d9bc1abffc
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Dec 2021 20:22:12.5459
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: coqG7o8L+9rU8gs2YIom8iuTNHc0dkE7pOZ3liyMYaAU4sB9DlWnuONe4fcz8CqWhQok+TetLs5c/6QZsR5vJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3838
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 09, 2021 at 07:39:27PM +0200, Vladimir Oltean wrote:
> In order for switch driver to be able to make simple and reliable use of
> the master tracking operations, they must also be notified of the
> initial state of the DSA master, not just of the changes. This is
> because they might enable certain features only during the time when
> they know that the DSA master is up and running.
>=20
> Therefore, this change explicitly checks the state of the DSA master
> under the same rtnl_mutex as we were holding during the
> dsa_master_setup() and dsa_master_teardown() call. The idea being that
> if the DSA master became operational in between the moment in which it
> became a DSA master (dsa_master_setup set dev->dsa_ptr) and the moment
> when we checked for master->flags & IFF_UP, there is a chance that we

s/master->flags & IFF_UP/the master being up/ (the condition will be
more complex, no need to spell it out

> would emit a ->master_up() event twice. We need to avoid that by

s/master_up() event twice/master_state_change() call with no actual
state change.

> serializing the concurrent netdevice event with us. If the netdevice
> event started before, we force it to finish before we begin, because we
> take rtnl_lock before making netdev_uses_dsa() return true. So we also
> handle that early event and do nothing on it. Similarly, if the
> dev_open() attempt is concurrent with us, it will attempt to take the
> rtnl_mutex, but we're holding it. We'll see that the master flag IFF_UP
> isn't set, then when we release the rtnl_mutex we'll process the
> NETDEV_UP notifier.
>=20
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  net/dsa/dsa2.c | 26 ++++++++++++++++++++++----
>  1 file changed, 22 insertions(+), 4 deletions(-)
>=20
> diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
> index 6d4422c9e334..c86c9688e8cc 100644
> --- a/net/dsa/dsa2.c
> +++ b/net/dsa/dsa2.c
> @@ -1019,9 +1019,17 @@ static int dsa_tree_setup_master(struct dsa_switch=
_tree *dst)
> =20
>  	list_for_each_entry(dp, &dst->ports, list) {
>  		if (dsa_port_is_cpu(dp)) {
> -			err =3D dsa_master_setup(dp->master, dp);
> +			struct net_device *master =3D dp->master;
> +
> +			err =3D dsa_master_setup(master, dp);
>  			if (err)
>  				return err;
> +
> +			/* Replay master state event */
> +			dsa_tree_master_admin_state_change(dst, master,
> +							   master->flags & IFF_UP);

It would be good to add a "bool admin_up =3D (master->flags & IFF_UP) && !q=
disc_tx_is_noop(master)",
to avoid the line getting too long.

> +			dsa_tree_master_oper_state_change(dst, master,
> +							  netif_oper_up(master));
>  		}
>  	}
> =20
> @@ -1036,9 +1044,19 @@ static void dsa_tree_teardown_master(struct dsa_sw=
itch_tree *dst)
> =20
>  	rtnl_lock();
> =20
> -	list_for_each_entry(dp, &dst->ports, list)
> -		if (dsa_port_is_cpu(dp))
> -			dsa_master_teardown(dp->master);
> +	list_for_each_entry(dp, &dst->ports, list) {
> +		if (dsa_port_is_cpu(dp)) {
> +			struct net_device *master =3D dp->master;
> +
> +			/* Synthesizing an "admin down" state is sufficient for
> +			 * the switches to get a notification if the master is
> +			 * currently up and running.
> +			 */
> +			dsa_tree_master_admin_state_change(dst, master, false);
> +
> +			dsa_master_teardown(master);
> +		}
> +	}
> =20
>  	rtnl_unlock();
>  }
> --=20
> 2.25.1
>=
