Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 015CF4B5E79
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 00:58:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232268AbiBNX63 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 18:58:29 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbiBNX62 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 18:58:28 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80079.outbound.protection.outlook.com [40.107.8.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB9F928E10
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 15:58:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OUoWzz1rI6mSYi6M/av1+HjkON2dvzbmH0T8Z6iAUwlR1y73r9dpgwoVZl08+sr6cEMWzqgu6uDW1egEeOS7o1BsxoCoC5/xj/VMdDoo3+iwATaV2YoPQ5jpHSQSrmbgf3/pOaC5As7yXLk3sb1E1dxSAYKr6MVN2JF4c52ULWRJtqw/Gc+D2AuUuC9iuni3nJ9PzvoPPLhpPTku18nc727fsHskk+93k/z+AjB2Brr9+aidYOsUP+o5vX63mOOa5H2qasJ//uR50vIri0wss7tzW6szChhdZZ0OdOsahyfpG9h08D0YGUfs0etnoZUQXUk2WxqcnzR87ikbf7x3Tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rW5Rl/4kWs10D6SSE1vRcq2SM51zuPpDAC/AQpBni6M=;
 b=HeEQdMOPSMyeE81DpWgUOeu5/cHbUDoImdhhluy1RFeQ/1PFtz/ISIfxGOkqEQH1RJ8cLED7CGfBsUNFSOA7ueCPU9wr+iYmhFYWpDDjk93qcnoDCE3Dsqappg/7EP9nads6JgkXULQw0UnFCD0k9+G6QFiYDxW9sSkyZQulrQ8CZf5CT7fdDxayzQMaj5DtfQW+yGOcfF189yYyFOGs4PFAG6Y0pasOts2pCIyxnGg4Df6S6JPDSbLUrQkLy9CyUbA9chNFoiIjQHJnTgm4SpxyYHqn4p9EBNbrW0hDh1DIwmwomDk/NHrKgt8OE8W0yWZbQpyTB0igipaFltr3rQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rW5Rl/4kWs10D6SSE1vRcq2SM51zuPpDAC/AQpBni6M=;
 b=L+/gH28mT/NCNH8rW1du0MQRZgVk5871lO5Hsmzy7J8AcNYYR7I8zYQlmiHiMjIR5PsFxHNIENjett8z3j1B6Lxt6JN9Jcd48d5ldaWAlBYz1ku7Zb0QEoahq3FL4ZNX39D1IFkM1vfzQe6Jjcaj9wrLG4Gn6UIwHmL1/VfKZo8=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PR3PR04MB7403.eurprd04.prod.outlook.com (2603:10a6:102:8b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.19; Mon, 14 Feb
 2022 23:58:15 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Mon, 14 Feb 2022
 23:58:15 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next] net: bridge: vlan: check for errors from
 __vlan_del in __vlan_flush
Thread-Topic: [PATCH net-next] net: bridge: vlan: check for errors from
 __vlan_del in __vlan_flush
Thread-Index: AQHYIfvHoB7x7BUbQ0aVOvRKqlTLFqyTt8WAgAABuAA=
Date:   Mon, 14 Feb 2022 23:58:15 +0000
Message-ID: <20220214235814.hbxwyqrfidnvhyyz@skbuf>
References: <20220214233646.1592855-1-vladimir.oltean@nxp.com>
 <20220214155205.22135ebb@hermes.local>
In-Reply-To: <20220214155205.22135ebb@hermes.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: feab3ff3-715d-47b9-11af-08d9f015dde1
x-ms-traffictypediagnostic: PR3PR04MB7403:EE_
x-microsoft-antispam-prvs: <PR3PR04MB74034B0E276A2211160088FBE0339@PR3PR04MB7403.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YveX2wkVWnTCFgtPk+twbNx5/FFawVhOjd2BLflgPXP63DrddKhSDG9UCtHeB5HbPBDVjo6nkOaj/i+MgUqxvK0NBHMWS2AH3kvBY1afdjCpcUl6EAua39IXKFWCZ4i2IejJCWhPvT6V1drQErWov7pLW9Hg5GdhNLSapCVCooikVD0JpavSEDq9fEoAhnM32/O0PYL0lim8gO3qjowTZmCF5I0fq4cme5M7T2x8K0f4RQVeYv8HNIcSpNu+ulSkqLx16gURCA+6AuCxw59l9yJz5vCwqRBbyp02F7aG6lEJMHAmCH8ceb3ZgjCDbJT+5hsxA3NBw0g1wnZGWa4CkyYCEmS7bzNDTxgTvOBcBlcGjzH9u/vLtKI9TIAMrM9kJsMfHn/vr7NuX9lPN3ZagZDAFf4L4BjGrWTEAAvuGSud2zRGhPklb+9In7B72W2icLdkCqmKDBNl/0Noo+g4zco2EIdiSyv4DGPhNSHvg6E5PpNoX66hi9DYG69oONYIIRZzlDcE7TMWk/BO63sLHu0dwpBLh2nwy2L5rcwTuTAJ7XXbTOIbttpJ8c33K9wO40zTb2W47OJ5XpZ/P/vmOrHpkHVQV/iOoDi+aVug7vIlqgqTQIPyTBoIE2sWFwP4r8s5rWGuEY79w9fBOTHo0XE5x2QtecCUE+WNzO8GU1ey4cveqe7Y3KPGnvBk6tvDhO1YMiqGtICw4D8K/M65Zw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(26005)(186003)(1076003)(6506007)(71200400001)(6512007)(9686003)(83380400001)(44832011)(3716004)(2906002)(8936002)(5660300002)(33716001)(6916009)(54906003)(45080400002)(508600001)(6486002)(4326008)(64756008)(66446008)(66476007)(66556008)(66946007)(8676002)(76116006)(316002)(91956017)(86362001)(122000001)(38100700002)(38070700005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?nCVwG2agaNK2eeJDLbueGt+/CvDzoimQn4EGEWsW//RTZvK952+0nbSoB3vp?=
 =?us-ascii?Q?z7Pwl7U0V4LT6CKk0tBtHrRsdClrfh6HAwyqZZ13mEZ2q5pd2dw3XSFAMbV2?=
 =?us-ascii?Q?3R9JsGQWM7Uwg1y/HMXsLrWNHaEfvCuvSlKJYD3wPXBHrgA7HZXUrA+wUspd?=
 =?us-ascii?Q?pJk0vj0kCziMABQesM6FG5yky4EWr/cVp21NM5ujl0HECoBUuH4jp/OKD3WV?=
 =?us-ascii?Q?AqeZ/6E4MpwtivU4m9tkSWtvEKvxqoYyLVuN5EuewlaSFzTbKMlyzdrlVmBH?=
 =?us-ascii?Q?F/xbZ+M/is/qCykKy5DLnZYOuvCfwD9iy/UaKq0hmHooAxK8NIIYlbo6J29L?=
 =?us-ascii?Q?dan87GRy9YOgUdFGUm02APjRGdxBbBAR2nrsosZXaN0zqHSAgN67L0lVfEGN?=
 =?us-ascii?Q?EWeoluijomwmRxRvUx/7gjVkeW18EV7zirJ08hV7sv6efBgyseTufEYz8720?=
 =?us-ascii?Q?H2nF0sK4w3LI1FmPH8f4S5GJWPwHpqhNbWsuszpn3FQfEeIUWeY1S+5ysYpO?=
 =?us-ascii?Q?YhIwKAG8eojNWSFcObECXUvLu7F5ytOknrdqDUljiCETpqEOnqvFIMzxaRWF?=
 =?us-ascii?Q?2UOZF2OkTJHaKCTfHiuFlDTlhwllYXXIX+of0dq8pTX7W7uL2c5lWlvX9wXT?=
 =?us-ascii?Q?eiqxwLjOB2Aobat7fPpat5XsPsg7PiurI2l+iiqZEniRMwr7DxVRhAGGpYra?=
 =?us-ascii?Q?9pKrnnv4yiuyeW8eiUhcL3fF2SZHfrLjN5FGPtgMQJIhP0HUK5YKXNkBv156?=
 =?us-ascii?Q?VYfqj2ezfq/82k7ZHArB8Su94LPfO18cjZUgAjvpCAX6kiUC3BGIBWoYJAKL?=
 =?us-ascii?Q?iQWwkQ+Hy5vHjCe1kUyqmerxc2H5UduxUgXZPigwp1YddsOB1jQgd2XkGMTJ?=
 =?us-ascii?Q?MxAy2YDlGj+qptNzD6vO1TU6jrqjo2SVUizVvjN3TWpPAKtABvIQTYB9Z3dR?=
 =?us-ascii?Q?P4uF3Gd63vnLWMgXxEoN4Vt+/B3zk0wQVqISpAGjX5TWqPHcaLY5leFyfI2l?=
 =?us-ascii?Q?B8fViBfLk93jeBZP9dvWk7n6jl6oflC0/mzbJjQJo4P1rfir/j3PhOi4oIlO?=
 =?us-ascii?Q?6D/VdA0HJyBej27zIpnQrB4wV3qF95DsVghHNpqgLDUHTX/uDvteh6Vg1aPh?=
 =?us-ascii?Q?fxj0vC9ji945TLO5E1MyjXkro3F+hzpSvUPOfAgnK83qlGK874RVHENcr5a3?=
 =?us-ascii?Q?vXxokafsZrvMHwSTzI0dWpCZD+iPv+v8laQHP+aJ09kmLVaskZpRFdVcLX8G?=
 =?us-ascii?Q?gR8GNFZOv6hyzkIt3c5GBcPM+rrXYtmm0R1VQ4BQeRKCAtIPVS+8EC+0zTQe?=
 =?us-ascii?Q?44H6hUBQEeHoz2ILfLZRjnnTu5BqkF1f6V2l+RvWE97k3cUild0pBSljz5Fe?=
 =?us-ascii?Q?l1Rp7c28uh1NLYmEyJ444LlVEOPevo9yF4BPDEdDrAyelUd+wvcg2MVsE0WX?=
 =?us-ascii?Q?XUVoqjxfYLDa0wKCQrLd1j7uO/v6+q9hLePlFogt0/JT0OQR7S5EsUMWyCIt?=
 =?us-ascii?Q?Oibqsc8EH/ZpGzpi7QCmN8WIkIUqSsQSfELZbLMn9+n8ZAXgk6tkb7Dx0qxn?=
 =?us-ascii?Q?BfMWCuzFR9gWbDAAbAM3ZIVSusFp+sRJ5cFdQYsmKpbbtZWyO32+rBZpX77P?=
 =?us-ascii?Q?c1yXTwNzXm7/bzr6cHBIr50=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2811FBC800AAAB428A99123BBE624534@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: feab3ff3-715d-47b9-11af-08d9f015dde1
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Feb 2022 23:58:15.6192
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: p4BSGsbW1G7eeXNg1wXABInSY3pJNcUdH+pLCfX8+y8mmQko3mdPWKa+pE5Y7Rgv8l9bOlWUPlyKbj++xU5++A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR04MB7403
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 14, 2022 at 03:52:05PM -0800, Stephen Hemminger wrote:
> On Tue, 15 Feb 2022 01:36:46 +0200
> Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
>=20
> > +		if (err) {
> > +			br_err(br,
> > +			       "port %u(%s) failed to delete vlan %d: %pe\n",
> > +			       (unsigned int) p->port_no, p->dev->name,
> > +			       vlan->vid, ERR_PTR(err));
>=20
> Don't understand this last argument here.
> It takes an integer error number, then converts it to an error pointer
> just so the error message can then decode with %pe?

Yes.

> Why?

Because I find "-ENOENT" more legible than "-2":

root@debian:~# ip link del br0
[   72.782294] device swp0 left promiscuous mode
[   72.788968] br0: port 2(swp0) entered disabled state
[   72.799735] br0: port 2(swp0) failed to delete vlan 1: -ENOENT
[   72.823542] ------------[ cut here ]------------
[   72.828223] WARNING: CPU: 1 PID: 472 at net/bridge/br_vlan.c:409 __vlan_=
group_free+0x54/0x60
[   72.836745] Modules linked in:
[   72.839854] CPU: 1 PID: 472 Comm: ip Not tainted 5.17.0-rc3-07010-ga9b95=
00ffaac-dirty #2224
[   72.848274] Hardware name: LS1028A RDB Board (DT)
[   72.853023] pstate: 20000005 (nzCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=
=3D--)
[   72.860047] pc : __vlan_group_free+0x54/0x60
[   72.864366] lr : __vlan_group_free+0x20/0x60
[   72.868683] sp : ffff800008ad70f0
[   72.872035] x29: ffff800008ad70f0 x28: ffff0e14c665c0e4 x27: ffffbfe4244=
daa40
[   72.879277] x26: ffff0e14c665c000 x25: ffff0e14c5ed60c8 x24: ffff0e14c66=
5cd18
[   72.886519] x23: ffff0e14c5ed6000 x22: ffff0e14c665ceb8 x21: ffff0e14c61=
27028
[   72.893760] x20: ffff0e14c611ab00 x19: ffff0e14c611a800 x18: 00000000000=
00000
[   72.901000] x17: 0000000000000000 x16: 0000000000000000 x15: 00000000000=
00000
[   72.908231] x14: 1ffff0000115ad8a x13: 0000000041b58ab3 x12: ffff7000011=
5ada1
[   72.915464] x11: 1ffff0000115ada0 x10: ffff70000115ada0 x9 : dfff8000000=
00000
[   72.922697] x8 : 00000000f3000000 x7 : dfff800000000000 x6 : 00000000f3f=
3f3f3
[   72.929929] x5 : 00000000f2f2f200 x4 : dfff800000000000 x3 : ffffbfe423a=
a5d00
[   72.937161] x2 : 0000000000000007 x1 : 0000000000000000 x0 : ffff0e14c60=
4f3a0
[   72.944393] Call trace:
[   72.946869]  __vlan_group_free+0x54/0x60
[   72.950837]  nbp_vlan_flush+0x6c/0xf4
[   72.954542]  del_nbp+0x188/0x4d0
[   72.957812]  br_dev_delete+0x60/0xec
[   72.961429]  rtnl_dellink+0x1c4/0x4ec
[   72.965137]  rtnetlink_rcv_msg+0x208/0x5e0
[   72.969280]  netlink_rcv_skb+0xc8/0x1fc
[   72.973162]  rtnetlink_rcv+0x18/0x2c
[   72.976780]  netlink_unicast+0x2c8/0x3f4
[   72.980749]  netlink_sendmsg+0x30c/0x5f0=
