Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 682333DD2D2
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 11:21:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232990AbhHBJVH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 05:21:07 -0400
Received: from mail-eopbgr130043.outbound.protection.outlook.com ([40.107.13.43]:12223
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232965AbhHBJVH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 05:21:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J8pu9tc5CX2lmJAZ9BHOW0v4jSbXxR0l62gI4U+DAuZjV6Hh3V5v+HS/ChmfxTWYkNG8NqbYxiBF+q/dDYkOyJvuCtPGM94mTQyO+5LGgJ8pwMq+GBI4fi8AMxpk+81QRY7+a4C82gXdTOicp5C3734qQspgxFMyaxI5wmfsZMOzsDLsSykNIsWDxSXqp2LcDYRHiitLcPfKq+Rop8/FW5dBS+YgzNpFJMdfjnlMipBAAm5uoX31VOJTYlm9fK3xLSimoo+BYe+/lexPDnMwPHCSRkqUd20Ur+IGBv3fRASLouGumGbmuxDlqqwZeN/CaS1b91FrqCHgEMGfpRiATg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8EGF/Z4K5qmejHv0aEFL7njXnRA6bcE+UEVa1yoLJls=;
 b=dLI6sYEdYfZDqwPU4qmR6YH6P0kjiliBJ+DariexZR7HST0R8sk4eBUEaDf+U/jRlKFrtIUAjd4FdSRyrUPH5a5HUI8CIDuYIqpIqzgHUduoc4kkSPUYqkvTMrvlj9D2/ReQrUyFMUaVyKrXY01ZLGb+D+FuhudtRUt/X7d7hBfN+IEqTwGA7t3c9GlhuEjR0sFv54vyHy//tMwxGWFAkSEhiz+e+DZ6ftlXwgRPiZCBwcxowkv2+N+NKNWKKPw7ieEujgsQ4QN98O47IpiWFtuHmgfCDH0JzQT3TOnnbz87AGSgK3iocVl7DvBk4Hb9Tu+mxNt95R2Oz+BmrIf/iA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8EGF/Z4K5qmejHv0aEFL7njXnRA6bcE+UEVa1yoLJls=;
 b=C24vOmK6XGpONuBvWEtD8r2yqOaUT59wSY6VXzi7K/GmPFJS2RgTMu6KoR/K635Q/KUQOVLEoYmlMeYa8KdHIr/5/NdIWw5+P6rIiiS/uijFEj0IPgYdHqJIlIWmqVkNsaOKVpgDE20ZrIDqvVTKHBAtPQY6gCeHgTS34H3+yX4=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB3198.eurprd04.prod.outlook.com (2603:10a6:802:9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18; Mon, 2 Aug
 2021 09:20:55 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4373.026; Mon, 2 Aug 2021
 09:20:54 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        "syzbot+9ba1174359adba5a5b7c@syzkaller.appspotmail.com" 
        <syzbot+9ba1174359adba5a5b7c@syzkaller.appspotmail.com>
Subject: Re: [PATCH net] net: bridge: validate the NUD_PERMANENT bit when
 adding an extern_learn FDB entry
Thread-Topic: [PATCH net] net: bridge: validate the NUD_PERMANENT bit when
 adding an extern_learn FDB entry
Thread-Index: AQHXhyttiQTxBmfp1EqsG/8ivlTylqtf1ZuAgAAbcIA=
Date:   Mon, 2 Aug 2021 09:20:53 +0000
Message-ID: <20210802092053.qyfkuhhqzxjyqf24@skbuf>
References: <20210801231730.7493-1-vladimir.oltean@nxp.com>
 <ff6d11a2-2931-714a-7301-f624160a2d48@nvidia.com>
In-Reply-To: <ff6d11a2-2931-714a-7301-f624160a2d48@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 48e30c92-9f20-4d64-81d2-08d95596d403
x-ms-traffictypediagnostic: VI1PR04MB3198:
x-microsoft-antispam-prvs: <VI1PR04MB3198C34CAA2740AA8EC4BD0FE0EF9@VI1PR04MB3198.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2276;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: o/huRhRJ5jvy9buFddE7duQrSq3PKHLP8ihkgEmW5gvtgDrdy7JdmrvxBGo6UR4tHp69+JlcKGQWWVzVHIjiuFkxW+VJBvfhJ5rr2tf6Tl3RTB+ADY9ue4T1JOCMZ9bXsU84zD98D0cE2fjSuXSGtwRsNN8Y32nOcIQf/WBPE4TUwBYrE2orcOBRCxM8SRgMUts5W/R7Gaf9ZJblB2yyXgC4NYcAgQTE3pryu8VeQX06srwgjktqxNdsCodNerJLecKayNRRAoI/DLfohWr0gv2fZ9fn2awBQXzXUbI4eJowkbgm9COg7BdY5H5mj6ug/tE7RjtqA7QlK7vtNY6ebfQOVzt3DlrCQSKfun1Gb/8D9t9d0pZmBdEftcCjW/eQVUrKdvDLVZxZrBhm+Rx3iTuRCn5L7x36nTQGu9E7NJjYDZh+Nu0taFmz+Qzc6qf5BkGDvoMp1XkIO+1VP+IEiMXpfu3BhZZhf4+eI2Ux6ghnXlEGBkko4B8irhG9TLZkfWqacr+2xZAj9A2kr9WRobrMlrtpJ8/tIjCifsCZMRVXfZVOsTzcfPp8Ljdt7HRfRY4PlyY8GOqi6ONPO/lR4GTS8Vcom2zzB38stg38iq0m8Al7NQshfH2ZyumGpmIVRY1S0ia8phSlf/jcA6h42xnfQIDFTMPx3shsc3voWGCq6O7cYzLpCfzRX//KwUfftiJy7qmiZcMIIfrQQTd27Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(396003)(39860400002)(376002)(136003)(366004)(346002)(2906002)(1076003)(33716001)(122000001)(6916009)(66556008)(6506007)(54906003)(66446008)(66476007)(5660300002)(53546011)(86362001)(76116006)(4326008)(66946007)(64756008)(26005)(38070700005)(38100700002)(186003)(316002)(83380400001)(7416002)(478600001)(44832011)(8676002)(6486002)(6512007)(71200400001)(9686003)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Wuj3/yRomY8s6yX/bvZ0FqtTq2llkjpC+0yFCrLfGxxhiS4MD6gCGJvkF0+V?=
 =?us-ascii?Q?DytmKNqLIJeKO0WbMaBA9G5txYt/7Ng9V1yWAzmeI7n7GlG/JJ/t/hc3Gc63?=
 =?us-ascii?Q?XsZ7vd27uahrdqtUnEVuGnL+HfLHsEUjKDSWcu2XBarR8bk+uWXN6AYB5Oik?=
 =?us-ascii?Q?l0FOVstePzKM4IqN1n1vC6TuOpOloYKTIkWLbO85hOBdgkE73zOTxjPPS3fx?=
 =?us-ascii?Q?cLJ0NjVV3bN6+JgTVr9DPog2bXKQfsFTw4PoE0TBTigZ+LMLmAHUsTEDxAET?=
 =?us-ascii?Q?TpTezy7d9yliEQxWjrA6j3e4MiEufWVCcv1SMjU06/OX2lGufpCKAfWRTUQM?=
 =?us-ascii?Q?0gdfLoKeJ+V3EX2/9OabAEQGjVYzBqd4fuYXVRcGn3M6n+nmOI5NWC3RvBFE?=
 =?us-ascii?Q?DGrVx52jE5PmOCprIDHDh2CGwp0Av0lx9LGXw6yqmvz3tAbdO9XMde4cIsfF?=
 =?us-ascii?Q?x9Bmwpo3n8rTcsPxqcY+mCiclCb1R961nZqcTOLc5/7NOtRN5k1Z3mIDmpq2?=
 =?us-ascii?Q?lb1lPwiLnVI+4KETjyLJuZr9rChplRZ86TH5+docKZ45XA5m7wZ1AKp5f+Ti?=
 =?us-ascii?Q?jtXnalq/1h6QDO55gOCqGY58Z4O1vKZlyWqXueK4dnxjD/w/9W/4Mq5MCL0/?=
 =?us-ascii?Q?5fCiUi7uHCNbFuWJ42iZCOf2euKhRfH0tBiM1pRPW4Mmo//mD/PhWfZX/3In?=
 =?us-ascii?Q?9+Yceju3mjqpZ1yD7+h+rSUzmoDgnv9VhV1NBq1YaWBROYthD7DBO7u+2ejF?=
 =?us-ascii?Q?QylnEtK9cG8da4U2KLVtdxYBF6by2X68RqoD3PTYESxTkf/HBkoN838CfBsl?=
 =?us-ascii?Q?sanZrFsnK9hw+PCIDhAbu7AS9nUoeXt59x9z/e4Whaq0k3gUI/Epf8RSVgW9?=
 =?us-ascii?Q?Id25PkRftC/bpnVV5CSQ8UZ/wL7F2Q7fWt0IdVzH5bx459IC26ddWFfzSryL?=
 =?us-ascii?Q?kMhvXmf5YkcAb/SHj0j6T+saXAsDkYt7BK1TpqzlGPou4edFrI2p+mXsDzng?=
 =?us-ascii?Q?OPyrTDLZrh020uSVK20wmUdYH3cAP3n23Cqp228TWi7WIyX5yRHKseALTchx?=
 =?us-ascii?Q?7YF6js7qQfundX+kuq/0t5VEr1Aqdbwz3dFTyLb82UVRIMvhcY4Z9V4lV3/F?=
 =?us-ascii?Q?7RGogdEoKwPFqUUfQP1ABQtQV3B4aW1eXxnPT8l20zu/7tCqNmFuBDKKnM8C?=
 =?us-ascii?Q?d4hHO0YZ9cUNon6/IoyRK6jwD/bJ/6n4Fx8iJpv/aByj/cyfqD6zLmN2bESb?=
 =?us-ascii?Q?+CcO4giAD7uMw+DXkCWbHZLku+LV6snhFPJqvDJwHPBu2+zXg0KsPfYPBin4?=
 =?us-ascii?Q?/LramIkHHbWnzx/nHp9ooxgf?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A0C97A562CC2C14ABFDC193E1BCC5402@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48e30c92-9f20-4d64-81d2-08d95596d403
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Aug 2021 09:20:53.9491
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tFiRFJDj3XkEiDTunZiP6Zwcf3xhSd2RrMuqkrVlffY1tE5tYByYXiai0+OtfgPgj8jYHgfS/pv9WRTE2b8WnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3198
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 02, 2021 at 10:42:41AM +0300, Nikolay Aleksandrov wrote:
> On 02/08/2021 02:17, Vladimir Oltean wrote:
> > Currently it is possible to add broken extern_learn FDB entries to the
> > bridge in two ways:
> >
> > 1. Entries pointing towards the bridge device that are not local/perman=
ent:
> >
> > ip link add br0 type bridge
> > bridge fdb add 00:01:02:03:04:05 dev br0 self extern_learn static
> >
> > 2. Entries pointing towards the bridge device or towards a port that
> > are marked as local/permanent, however the bridge does not process the
> > 'permanent' bit in any way, therefore they are recorded as though they
> > aren't permanent:
> >
> > ip link add br0 type bridge
> > bridge fdb add 00:01:02:03:04:05 dev br0 self extern_learn permanent
> >
> > Since commit 52e4bec15546 ("net: bridge: switchdev: treat local FDBs th=
e
> > same as entries towards the bridge"), these incorrect FDB entries can
> > even trigger NULL pointer dereferences inside the kernel.
> >
> > This is because that commit made the assumption that all FDB entries
> > that are not local/permanent have a valid destination port. For context=
,
> > local / permanent FDB entries either have fdb->dst =3D=3D NULL, and the=
se
> > point towards the bridge device and are therefore local and not to be
> > used for forwarding, or have fdb->dst =3D=3D a net_bridge_port structur=
e
> > (but are to be treated in the same way, i.e. not for forwarding).
> >
> > That assumption _is_ correct as long as things are working correctly in
> > the bridge driver, i.e. we cannot logically have fdb->dst =3D=3D NULL u=
nder
> > any circumstance for FDB entries that are not local. However, the
> > extern_learn code path where FDB entries are managed by a user space
> > controller show that it is possible for the bridge kernel driver to
> > misinterpret the NUD flags of an entry transmitted by user space, and
> > end up having fdb->dst =3D=3D NULL while not being a local entry. This =
is
> > invalid and should be rejected.
> >
> > Before, the two commands listed above both crashed the kernel in this
> > check from br_switchdev_fdb_notify:
> >
>
> Not before 52e4bec15546 though, the check used to be:
> struct net_device *dev =3D dst ? dst->dev : br->dev;

"Before", as in "before this patch, on net-next/linux-next".

> which wouldn't crash. So the fixes tag below is incorrect, you could
> add a weird extern learn entry, but it wouldn't crash the kernel.

:)

Is our only criterion whether a patch is buggy or not that it causes a
NULL pointer dereference inside the kernel?

I thought I'd mention the interaction with the net-next work for the
sake of being thorough, and because this is how the syzcaller caught it
by coincidence, but "kernel does not treat an FDB entry with the
'permanent' flag as permanent" is enough of a reason to submit this as a
bug fix for the commit that I pointed to. Granted, I don't have any use
case with extern_learn, so probably your user space programs simply
don't add permanent FDB entries, but as this is the kernel UAPI, it
should nevertheless do whatever the user space is allowed to say. For a
permanent FDB entry, that behavior is to stop forwarding for that MAC
DA, and that behavior obviously was not taking place even before any
change in br_switchdev_fdb_notify(), or even with CONFIG_NET_SWITCHDEV=3Dn.=
