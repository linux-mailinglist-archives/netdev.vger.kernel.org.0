Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 332D94B867D
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 12:10:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231337AbiBPLKu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 06:10:50 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbiBPLKt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 06:10:49 -0500
Received: from EUR03-DB5-obe.outbound.protection.outlook.com (mail-eopbgr40052.outbound.protection.outlook.com [40.107.4.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1A0BEDF08
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 03:10:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P8iAXhQsdKDfeRGqRbY2D2n7OuaTAsr4wXGvZKl3U8Q2Ly39ZjQ945gXbXTPZBdpcLt2WOR3W+eA6ScIJEcZqQ0xXAo2Ya5rH06dlQleBvSqb10yKcNGKWTlt4VEY52AECkM8IAg1ZQKwz/+XO37xO7E6mz+wx9rLB6lYy81xBMy3H9w7yLAnIvE2oqP8ztz7jiF5SedbrmqFe4HW3y0Nn/ncEBGcFJEiW0sa25LEeCQorpQcZWV8p8dZp4ofLsmSSvvrLXTuKWnfyzreP1BBeNAmaXvVRS9NioP1V95Awz46C4aj3DuXh/PzVGcmjhiuHP3tpQxChoafc8bu93RFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TFIMg1cYF902Jaar+l58S5VoR3ttDjitNGl7b8C5G2Q=;
 b=fZgEvZmCRmquDVHD5QOEl6vsboF99+/bUgyEy6/yPbad08LoC5ZkBo7fwXTSzTq7eOeAk4Y89/Lr8SSWJVXdD2gQZvEa96RLLzh96ASUtBSOHPA/YJdk2VtFmSbsmdV53x6VSXx3Z7Bl1yLgKakxoLeJo4rEyU8ZacU20WaRh5neB2VD+HvCDI7ZvP/yG97P0cHXwWd7Wu0MuwBD8+4eEyLUjAkmAFqDzc47IOrS7PYGvzKQth5BjOcUr56ws8RgB1LLQBxuGeyLU4MflbiW+Q+ORKRE9Dt2jckq3TrQ1AXwWghMJUD+JfgHvgGHQAx/fWvKOIQIQoC+zmzhoMjFrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TFIMg1cYF902Jaar+l58S5VoR3ttDjitNGl7b8C5G2Q=;
 b=FCQid8sD8Fnrew24L9LlDBvXYn40JMFGYmA2V2XhEnnSglitIzHCdHsYB3zsPKMOsVbmpvdtGenklZWLFHuCauKL4ZNbUBKDUzjVCPfwlIME5k/in8MHnaAEHEqoANwPLTL3GGk/sdY2LaZ/vc4qeKHKkFfOQo2SXIhFTFh2Qrg=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB7621.eurprd04.prod.outlook.com (2603:10a6:20b:299::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.19; Wed, 16 Feb
 2022 11:10:34 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Wed, 16 Feb 2022
 11:10:34 +0000
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
Subject: Re: [PATCH v3 net-next 02/11] net: bridge: vlan: don't notify to
 switchdev master VLANs without BRENTRY flag
Thread-Topic: [PATCH v3 net-next 02/11] net: bridge: vlan: don't notify to
 switchdev master VLANs without BRENTRY flag
Thread-Index: AQHYIo3QhPXKTZfVQ0W3AWMMfTjX3ayWA7OAgAAC0oA=
Date:   Wed, 16 Feb 2022 11:10:34 +0000
Message-ID: <20220216111033.k3dmnoc72kuqfzzn@skbuf>
References: <20220215170218.2032432-1-vladimir.oltean@nxp.com>
 <20220215170218.2032432-3-vladimir.oltean@nxp.com>
 <630eb889-743c-c455-786e-ce2e58174ea9@nvidia.com>
In-Reply-To: <630eb889-743c-c455-786e-ce2e58174ea9@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7be82d01-6cb7-4432-78fe-08d9f13cf417
x-ms-traffictypediagnostic: AS8PR04MB7621:EE_
x-microsoft-antispam-prvs: <AS8PR04MB76214B9C57B3F5EEACCAC3ADE0359@AS8PR04MB7621.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /qmnvNxY9LwGGsGG6DVTizysNlr+OUHkQfBCp4kxK/WajhPcrpvK/92n667FEfTVkL1eIDaFDO2Tb79arLOI4vr9ha24a16w8YP1iZCI7CndtVjHsjbNnwNPF6QzjdOPqEIqTVCqf2PibpI3aY8L7H1XZ3mgXEifhRb/wmZ82H8GGWfdhFStiV1pcDZaBOrQdYiE4t/jzQxNT4SLC+P3FxbM7hgHzzyUZbJrpJR+d/kkqP+pEkiRPdKFtViS1EleeLiqdPqrbZm5wEzrUHq/R+JuXq54ELWM+incp1IXCK6y5DzYO1pNGQUL4B84g/53zeBjjdxIk0yBr43uggi4nkRWzyjJt9cIs5AVDEFsm3S8OREJnTxyT1hfpR3X+iDWcKAkbCV501ts1dd1A9oihZNhnevOcYxhLiKaYmJNUu33tTpSVo5rMhjEnvxaEYYj9SS6B78bExfpKTNOBGf8b/yLJ0ZToTr9sqLi3Benix3jqdsf6cvSPOx8yvY/LQ8WLOGvxEhyIpn0TvMgqVOQGHDT3dYOrvvEa7AqZBl3NM263tK4B/fv6oW+BbU9HGIdg5MrweApkSNJ4uB2hstKEEp04nrly5t6i+4n62L5XrkOGAU0ZSl7yAxDHBeCP8L4Ysb8FzRQEO3G4sIFJCoVePdAuTgRv265TWQYVZw5iIdVGAtqQRGQRa090b3QjO4bkTPOqz5gVlWYa8y0ShDWlQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(66946007)(1076003)(186003)(8936002)(26005)(2906002)(44832011)(38100700002)(66446008)(6506007)(4744005)(7416002)(508600001)(76116006)(5660300002)(122000001)(6486002)(4326008)(8676002)(86362001)(71200400001)(9686003)(66556008)(316002)(54906003)(91956017)(66476007)(6512007)(6916009)(33716001)(38070700005)(64756008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?9jKpwGKhdeO34/UJOoRY4C/6dBUI+zt24aHI481HLgp2mDAkYqCfeIswR590?=
 =?us-ascii?Q?Oh/21W7WfYr2N7m1+f2shAjhO9hQzhoL4VshX4h2e4Q52cmElUuQBB+e0Evc?=
 =?us-ascii?Q?0G/4ihafr0m5vPPQrL9i41dvX01/ZcOYQ7eHOQLtHuz1R9mkU7blGcI8CUjv?=
 =?us-ascii?Q?7+tK27MOlzdM13FmkHkX6RI9usQvcp2RCAXuH4dRynCEbIKkoLImKO3xLuh5?=
 =?us-ascii?Q?PjsdUp2XIZduxX0NEVIJpYUmT0KDuVI/i9U3NePjXNc0Sv5Ayjk4dcOEKVRi?=
 =?us-ascii?Q?2FOFxQgjLrdNCBWwkareOdWdXEIS8gRvSxD4s1CFgRYnPGCtXVpYYnDgCydd?=
 =?us-ascii?Q?lpApWMY5fZpstxR6WxhgoioCqwEB0LANRUfRVsJAl7qO2ue7S6dkM9HJjHm2?=
 =?us-ascii?Q?3zVB2QzoU6LgIDwrTH6Zl/qlekU1M6SVjOcBwKSpEg0Zit3cx/ZHWpJSlsn1?=
 =?us-ascii?Q?tyuVsGhBklw32OTk6Jg7gXDUfW2QUbcyv8KUaXhrXwplVCTqnEOlT4Ox/shw?=
 =?us-ascii?Q?XGYSocEQ5G2cU7Uvwgz49oZ0m5nVfmlhjN6jDdyWxPiwmluu770t2DyeDEIz?=
 =?us-ascii?Q?7oBskfFJ4wkLqpzlO1v+vNYVcKcGU4wWzbfGlhNNSBtyt8Pynp6/9JWqaODj?=
 =?us-ascii?Q?574V+u1CqzI7eiTWJ5smaCpARfMk9t/XGfVdcLX6QviouI2Fm+vAvSYHVHni?=
 =?us-ascii?Q?ViGYfOuKP6EooAvbnArzgMEGkBwMadJLNxMK8lb3mQhWkU8Bv47f3TRYHBWY?=
 =?us-ascii?Q?HHiod3Mr1/wyBlmfoahqRt3XdVSqt0QjFrGI1Gs9Ow/t/0oYJpodCahzqRlg?=
 =?us-ascii?Q?XkpahpfJtB09qjCNkIANI0T1J3OoDryX4o+nktWqJyYVUWM+RYJgNdr4MUiK?=
 =?us-ascii?Q?3V2BZIL5h/XucJOUc4rTavYPrzV/NZ2IMqm9KYgM3KdmY5rlgB3OxWy0cBpS?=
 =?us-ascii?Q?XAfPPyYTKk8gxjHCQsrHXQLqnjeYgLeHmYCcXClPxf7DChh00tKU5T/78beL?=
 =?us-ascii?Q?dEo27avsdr6YfzLAS4043na+PwPEG2qOJovScKFeBU1i/KJIonW/lWZlt7ch?=
 =?us-ascii?Q?5i43OW/WEm+6VgEQPFs7hCWDFuWYZxSNpgWWAtl3XDlVVMfQUcaKMsYjcZjQ?=
 =?us-ascii?Q?18ZpfvgwDZ9EBrT36w0ZN0PwDtmYKO/sGTM2nwFnoOxsjvWUYhcuGTG9gG4U?=
 =?us-ascii?Q?P92ZHqE4lzqKbSnCxnxl4symU1ys/I+MU5Zn8q0Qm9TP3DGpE53O+7S5qX1o?=
 =?us-ascii?Q?rf5zEsumngb3hJe6O500UjkKLgP0sqZz190RN209pPSZJEmDJfGwUAqLwUL2?=
 =?us-ascii?Q?VSsUn9WoUKMqyJ9qou43e1II2TlNZoRAL316hI2ytsnrmAYgR2/tQnH7ry7i?=
 =?us-ascii?Q?w//JdIHHiyCmE4m1bZ6U9qpA/Xel7wrCMasw+nGJWT/g6/anIuw4QPnCqxR9?=
 =?us-ascii?Q?Nl+TN6ABxLPx08Rj+sRQhSGf0MtrpHDI/0bG03KCYkWglClc8N/bB/h+b74j?=
 =?us-ascii?Q?Pm0/t4WZWxM5pR3KbcV/JlYx2ST5Ytk54ByPSqs0Cygzw3vxiJDsTUebK8L3?=
 =?us-ascii?Q?DpcmVgiRFioEK0K0uSn40k+nQ5Xp1bJX8P+c9WstWStBJdlPYaYTJ011P5lT?=
 =?us-ascii?Q?TrTFXlDZgUF4ghzjPVIAQNH496ib9wOSImuity/Wf2Yc?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1743FA9110484848A65F61FAAC642685@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7be82d01-6cb7-4432-78fe-08d9f13cf417
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Feb 2022 11:10:34.4834
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Kzl2JOAJsvo2T78QU5Tr9q2kd5Mb8fHZvt7oNmsrN46V511FNyFo2rV5wF3/vsPM6i404MMuIDe8HqB/rddEog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7621
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 16, 2022 at 01:00:27PM +0200, Nikolay Aleksandrov wrote:
> > +		if (br_vlan_should_use(v)) {
> > +			err =3D br_switchdev_port_vlan_add(dev, v->vid, flags,
> > +							 extack);
> > +			if (err && err !=3D -EOPNOTSUPP)
> > +				goto out;
> > +		}
>=20
> At some point we should just pass the vlan struct to the switchdev handle=
rs
> and push all the switchdev-specific checks in there. It would require som=
e
> care w.r.t kconfig options, but it should be cleaner.
> The patch looks good.
>=20
> Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>

Here and there we're passing "flags" and not "v->flags", so passing the
net_bridge_vlan structure to br_switchdev_port_vlan_add() would require
committing to it the changes we want to do, which is pretty much what
we've been avoiding since v1.=
