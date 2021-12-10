Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8313D470BB6
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 21:17:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343498AbhLJUUk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 15:20:40 -0500
Received: from mail-eopbgr60040.outbound.protection.outlook.com ([40.107.6.40]:26167
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234979AbhLJUUj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Dec 2021 15:20:39 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n+0ISrvvfiAEEjHarcNlQXuGEUu5M/FhxPNIYsrBRGU2PBBb8WXkbdSJT/m63KvC5xaNgUfULZiN+spWBl7lk+6q4YQL1cSzUFbWMSU9E1s9Tdufld/x+UbkE5BRyGJK7O3MHykNMyFm6cHLW5Dor1IYyP/xzk4/GH4XUDjW928ny3uk857YDeW5qiP80DxrHGV3/zg4decx7v//is3ckruZvmdAy2Jc2RMakuOnaRDr0QTc004YrBx+ZEkonAw6bG6o7CzTpp8DS3KazyCpc5hRmKSbEAnAUEnWwDFFOj35ZB0gYzk68DtWBDl6U5xObv7KBIGUsjTgW1j9iCUfBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y5rQrN/GiYJjZ1vnYmKjxlyw26Du3480f8QzUPjQibw=;
 b=muwpm4ScD69h+QRhEo/EU6ovcVUuCgvOiRPbtfPT3YBbSZrDrIOUcbFU0GEsmj362hiDzvvmfipzFYgwkNbSUdSwb3n+3ieEIAr1TknIRQhtyD2MIfIP9YTRPQA6HVaAFHD4dszI9GLFpM7wj0NeFnLuBQQ7WrUEUJUCEQdVs2Kdjy6xyUgBZT7hF+5/RTYh6pgk323Y0/bZmK0vn+YokZDNrViEcSL3ZyIY90dW0WvOhdsgpovNl655hwsaI4fWDOZ+ji0j8ES3GnC3CDNw2zNYREBpzLVmTUhHO4z6Z9Ppip43NwvJBdFFeruKFje5d3Yj3jsePpQcfDJ+HNh/5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y5rQrN/GiYJjZ1vnYmKjxlyw26Du3480f8QzUPjQibw=;
 b=qOFQDBj/ycP9NHaVDIh7pgJUjtDxCEZHV/TiOehY2efh6SC+/Hp5KDxNMU1yXjSkpfiIjak94y6NFhumA+8dsypV1vqc0AkBsf1hz3jdJnFVSkXccUt7cZoHgWAptfGSZ6hYtk7IWxqM9/C1VfjKv41tqNHVgfmtX6fKiKBDmJQ=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5343.eurprd04.prod.outlook.com (2603:10a6:803:48::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Fri, 10 Dec
 2021 20:17:02 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4755.026; Fri, 10 Dec 2021
 20:17:02 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ansuel Smith <ansuelsmth@gmail.com>
Subject: Re: [RFC PATCH v2 net-next 3/4] net: dsa: hold rtnl_mutex when
 calling dsa_master_{setup,teardown}
Thread-Topic: [RFC PATCH v2 net-next 3/4] net: dsa: hold rtnl_mutex when
 calling dsa_master_{setup,teardown}
Thread-Index: AQHX7SPBchknIS9kJEqQR3GxCTFJMKwsK4CA
Date:   Fri, 10 Dec 2021 20:17:02 +0000
Message-ID: <20211210201701.cegvs3xh5rj5mloo@skbuf>
References: <20211209173927.4179375-1-vladimir.oltean@nxp.com>
 <20211209173927.4179375-4-vladimir.oltean@nxp.com>
In-Reply-To: <20211209173927.4179375-4-vladimir.oltean@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 30856b22-2f53-4e80-566f-08d9bc1a0702
x-ms-traffictypediagnostic: VI1PR04MB5343:EE_
x-microsoft-antispam-prvs: <VI1PR04MB53438EA865F27FC5C587673BE0719@VI1PR04MB5343.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3173;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1CZV3QrktGcvAR9YzbYa/xCPJBcUxvyArpKmpcAp39LzLhqJlZwEv7/7tL0bOc9jhm66BPLsihVD/Zmsoc5skPdLYvPisn+E14Y5VUuAZ6TNXXJKYNLguUt9mkQ9R0FNrvnl1drVyBtqkgT1PuSqaDdJCvC+YSCMgVK+U+zt8HHxEjCtsdZi1tG2wqVvWh8yjC74CzxwtPUHaobV4ODAor2m1/z2iRqWWGafJkIY+KHHtwuCyyIFVGycuCck7iX2izn52yD6gjcbBPHQYJRlOinXQIvf01U0s+8qrwe4TBxVrVKGQvasv/dlM6vUg1M80wPJ8h1JOk2aLViuF9z30jjS1JInkzhk3j3MyZAw4DgWJZLN2wVbKgYDAF7G435HSQ40O3WygllG2QAFaStvKSMm/dua6MFmpRfb6/B5rusTdBwtzctM0ZeM9oo5SHQIQUr9A8QHjrApDnSXamBG/zDk723Cwo0Sp/Yn8MAWSg6GzjOJzZIyhhe9fTLYbKYbAY1f0JabwggRdg2HtL+3/usZP5NCMLpuN2Lwzoh1Bvrlzb1YSgw0JToxgP5fljoAwA8zBLNhxjuRp46aJyQ1IX+nSfE1Q2tZTfhljWNPWvq3ArceZNTyxUG30t06LYBP0Yr7UUXgPzxpxI2Htwr+VUSu37Bp9NKnJrgPWivRVpKF0rpwitBG7I4QfWoz3C/hOLKbaOXtfTZjKK21kjTcHQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(122000001)(54906003)(38100700002)(316002)(6506007)(83380400001)(66946007)(76116006)(64756008)(66476007)(91956017)(26005)(33716001)(4326008)(86362001)(71200400001)(6486002)(508600001)(186003)(1076003)(66446008)(9686003)(6512007)(8936002)(44832011)(8676002)(2906002)(38070700005)(66556008)(6916009)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?wtNTfeBBLDVozXxIH20BPlahslykbVnplSai060N0omN+lVVI7uw37oTcCqH?=
 =?us-ascii?Q?26/kaP2DuqOKRhci8fVpyCwuT4OZMdMSGOv1L2kCMJc7hDy7WHWv007OUjUu?=
 =?us-ascii?Q?MrPMIGa41ukvFT4kQMjzAtjJzD5ersVsmlZz4grCxEfVL0jhWIn9eg/Sm8+V?=
 =?us-ascii?Q?wvpgqeTIOH4XEwew4zcGMUddoPB5/YACPyfwStDYu1JLoWNZ759GUUgkzMqj?=
 =?us-ascii?Q?je3j8tjQamzXalSM60e4kSTk1+iTMpfIAXgKFz+abfkKC+L2L+3O101dgl/k?=
 =?us-ascii?Q?MEgmvhataEzUOC0iiUyGJFMZBPlN7PRBjWzfMnWgkCfVwKA15u2T0z138B8V?=
 =?us-ascii?Q?gCS/W7kh0K2DUl4VEtGZzrs9Kwda/++3r788D8nkfZwbtMirkn7dkEEeYHl8?=
 =?us-ascii?Q?ai7ZiAz3W7TIe1sh5dXfsAhbZEMNbavY/A+xT4aSnPe+o0NnC1ixyhC0IvUi?=
 =?us-ascii?Q?iJEjkggz10ctfTU+ZBnEvFeVg0YV+ikr+7r9qfonm2rg1ckI9jR4a+iMmtyT?=
 =?us-ascii?Q?zZheCLiSxf4Er+qjXgxvfTeJ9dAhbhlWrybvQ54qKRM2S4HwSgh4oU+SgTOE?=
 =?us-ascii?Q?7vFfHy2Ws7euu0yuqCDMOo/CsIw/q5vdLOWeY5ZhTi7QB1hxPWDmWzMXoCiF?=
 =?us-ascii?Q?zmETPFYBuewWQ4bSgvgKqO+XFkO+ruSP5j0nY1kbm5pKo54axN1lWw1jmLxC?=
 =?us-ascii?Q?71yoPVDHxzptp6K+qliFn4dASPSwdVFOp40VRRc862Sf3NvNORU2GfExsgYY?=
 =?us-ascii?Q?r3FHaq/gnIUz13UoSitGGB49Gp0+Q65ZUF3PZY6m+t0YOdJK2IFFUjpqnKhi?=
 =?us-ascii?Q?x584FHsFux3q3Tx96MphLggeyi9rc0l6LHhDJK47aD6EreIryIVSguVZ7tD0?=
 =?us-ascii?Q?je5L0p/PVXxyv1eEXzufSkDtY+OapQIBuWRVc36GYiv1RB0jDH1h1mjjv2uJ?=
 =?us-ascii?Q?iHo/+enURcZs33YUX5OWy5xtrMDDnwzVoztdB/KRd/tZBNBKWKE6SMQzcqcY?=
 =?us-ascii?Q?S2j4NHSlY0CDAMEu99Vtst/nr61Hju7PM+im1ZkaYvcGrDpSh0O5kZsRd6Bt?=
 =?us-ascii?Q?dcy/8Kc5fNG7GvO+QXoH81uLnpVis6L1xjySBBArO67wKw4SY9hNssIs9nFR?=
 =?us-ascii?Q?McTec3KAHiSOq1DQF40+OUeAYinZTTlRuE2TGhcIt761tIeu/ahvSgKgNPny?=
 =?us-ascii?Q?5bw9V6OCnwbwiq9VoU2T1T1Dnl338md6JRIH5+l7TCZS5Lvij15XYPA+VbIk?=
 =?us-ascii?Q?IfnKB24Jlt3vjYfHgYYuliwO/O7DJhpmyn7dEBhysTTm/t0hA/JBpJ7nPMXH?=
 =?us-ascii?Q?KYb4F1spIexGoow+4tHutw7JxkutpU8+9XYDHVC8b/rO5UvbgtILA7mfhMGn?=
 =?us-ascii?Q?0NtXqpyDe8umsV2POGtwIYoSMRg4vsk7IH4eAZcMnrohgfa+GxI+C4FZ4VOk?=
 =?us-ascii?Q?0qWZ9ahl6+dyerbJCPciUMp6de7z0dLzH6m0aoiJ4jY7IMwsoTjq9asbcjEi?=
 =?us-ascii?Q?wVEp1Jc/sRVzr+W4mAn2QptSAUD52LSeGL+JBYqQUx8Du5iCXpmZbLncUr7Q?=
 =?us-ascii?Q?doJ/nWbW9oa9bEgDL1lQzsqU/Z0HO+cx3s9poZzk+eN9sWpzV10cnpi5fv1o?=
 =?us-ascii?Q?+qkLd57f9fBQSbRXJo/JBV8=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <91A8363517021540958961BA16A9B063@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30856b22-2f53-4e80-566f-08d9bc1a0702
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Dec 2021 20:17:02.1776
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: J/qtGb61uG0nNAMQXB0KZVPy2iQ6h1LctzUBgO+0clMf/F/Xc0nOqFmeZ8fhjpLNx94JDUTEfzdaWS3A+b4b5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5343
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 09, 2021 at 07:39:26PM +0200, Vladimir Oltean wrote:
> DSA needs to simulate master tracking events when a binding is first
> with a DSA master established and torn down, in order to give drivers
> the simplifying guarantee that ->master_up and ->master_going_down calls
> are made in exactly this order. To avoid races, we need to block the
> reception of NETDEV_UP/NETDEV_GOING_DOWN events in the netdev notifier
> chain while we are changing the master's dev->dsa_ptr (this changes what
> netdev_uses_dsa(dev) reports).

This paragraph needs to be updated. For one, "->master_up and
->master_going down calls are made in exactly this order" needs to
become something like "->master_change calls are made only when the
master's readiness state to pass traffic changes". Then, "block the
reception of NETDEV_UP/NETDEV_GOING_DOWN" must also mention
"NETDEV_CHANGE".

>=20
> The dsa_master_setup() and dsa_master_teardown() functions optionally
> require the rtnl_mutex to be held, if the tagger needs the master to be
> promiscuous, these functions call dev_set_promiscuity(). Move the
> rtnl_lock() from that function and make it top-level.
>=20
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  net/dsa/dsa2.c   | 8 ++++++++
>  net/dsa/master.c | 4 ++--
>  2 files changed, 10 insertions(+), 2 deletions(-)
>=20
> diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
> index a6cb3470face..6d4422c9e334 100644
> --- a/net/dsa/dsa2.c
> +++ b/net/dsa/dsa2.c
> @@ -1015,6 +1015,8 @@ static int dsa_tree_setup_master(struct dsa_switch_=
tree *dst)
>  	struct dsa_port *dp;
>  	int err;
> =20
> +	rtnl_lock();
> +
>  	list_for_each_entry(dp, &dst->ports, list) {
>  		if (dsa_port_is_cpu(dp)) {
>  			err =3D dsa_master_setup(dp->master, dp);
> @@ -1023,6 +1025,8 @@ static int dsa_tree_setup_master(struct dsa_switch_=
tree *dst)
>  		}
>  	}
> =20
> +	rtnl_unlock();
> +
>  	return 0;
>  }
> =20
> @@ -1030,9 +1034,13 @@ static void dsa_tree_teardown_master(struct dsa_sw=
itch_tree *dst)
>  {
>  	struct dsa_port *dp;
> =20
> +	rtnl_lock();
> +
>  	list_for_each_entry(dp, &dst->ports, list)
>  		if (dsa_port_is_cpu(dp))
>  			dsa_master_teardown(dp->master);
> +
> +	rtnl_unlock();
>  }
> =20
>  static int dsa_tree_setup_lags(struct dsa_switch_tree *dst)
> diff --git a/net/dsa/master.c b/net/dsa/master.c
> index f4efb244f91d..2199104ca7df 100644
> --- a/net/dsa/master.c
> +++ b/net/dsa/master.c
> @@ -267,9 +267,9 @@ static void dsa_master_set_promiscuity(struct net_dev=
ice *dev, int inc)
>  	if (!ops->promisc_on_master)
>  		return;
> =20
> -	rtnl_lock();
> +	ASSERT_RTNL();
> +
>  	dev_set_promiscuity(dev, inc);
> -	rtnl_unlock();
>  }
> =20
>  static ssize_t tagging_show(struct device *d, struct device_attribute *a=
ttr,
> --=20
> 2.25.1
>=
