Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9409B33A80C
	for <lists+netdev@lfdr.de>; Sun, 14 Mar 2021 21:45:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234068AbhCNUox (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Mar 2021 16:44:53 -0400
Received: from mail-db8eur05on2043.outbound.protection.outlook.com ([40.107.20.43]:21076
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233841AbhCNUox (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 14 Mar 2021 16:44:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hKlGyYtr/LN93UdJi26VSSb7e9s6T4WkzrvzYKMe51lQ0ZRfJAHvcBHXm2Uf0/BIT8Xr5e8HYsiaJnuLqiAH68KR5/j1XlXDmO3Yi4VTwpaSKoayqiXyPBrfxLHypBJBbRjq2T6PvGxg0/IZBrAIpHjy2rn9F1IR/2KYVSe3e/dpl0OfFo4hLd56t7uup5F47yROoBkwPUm2BeXjPhq6kksUmUqJ+JdWq0+1vIuDNpR311FQXuEy7t+VV4RcfX81C60ZVPvwfbi0rZuOU/tomNgRD5w0DN54ela3W4G47iI/px6SXLPntObd6VWDcrcyz5Xawdh5l40uP45iQhas5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fOysdS0PiBZCfn6DjtRhp1zobRix6Vyp8YezZTutdDg=;
 b=KcoEr+93AYjbbbtLgpJkyeNmPOLdF35CZkstEYMFrFQFTOMTETiN2OHuP3/Px+lSl9LBoOaGWqVTbxuiiNxBUfCePwuh5fPnFs4iJVMVq8v1lyd7oJPQgWqDumMJu8knnNoQjB+8pbdlPrJKpi9h4X/WnPHloixvROtQX7h7r+TShTLHuyaW9cVtgwODA0Gdk/scEW3ZwzEpv1sLWDGAYFl+HqiRsV1epKl193uPc0m+2EFblojlQdLh07jhbPM5QlYc0yh3RMRd1l2PC3pYJ7aUneFUj/djBO12NNcl2q6w5xZ4NIEOGMGwmiJIYadcSLL7Vt5bvzFFVwE9WOIBdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fOysdS0PiBZCfn6DjtRhp1zobRix6Vyp8YezZTutdDg=;
 b=Egfu2tOD9CFUSu48NnCuOprO4prXKu1VTNPZ+9rlQGvptDBlzChjgn+uz7geEp4Oyao9rhrhAPKVt9EBDOLTxb5tSbbXi4fxYipwZ3l/VHGPuGBXU6TGB9Pclo1U0uf7wdqWvIi4QCEMLfFoFOSiiL5QHNIrRHAq1+qJ7qDRHFk=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB3966.eurprd04.prod.outlook.com (2603:10a6:803:4e::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Sun, 14 Mar
 2021 20:44:50 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::f0c0:cb99:d153:e39b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::f0c0:cb99:d153:e39b%7]) with mapi id 15.20.3933.032; Sun, 14 Mar 2021
 20:44:49 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>
CC:     Alexander Lobakin <alobakin@pm.me>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Guillaume Nault <gnault@redhat.com>, wenxu <wenxu@ucloud.cn>,
        Eran Ben Elisha <eranbe@nvidia.com>,
        Matteo Croce <mcroce@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] flow_dissector: fix byteorder of dissected ICMP ID
Thread-Topic: [PATCH net] flow_dissector: fix byteorder of dissected ICMP ID
Thread-Index: AQHXF3uQyZi7bwyzZk6kuQ6U6xCLZaqD8FEAgAAGeIA=
Date:   Sun, 14 Mar 2021 20:44:49 +0000
Message-ID: <20210314204449.6ogfogeiqfwwqfso@skbuf>
References: <20210312200834.370667-1-alobakin@pm.me>
 <87wnu932qz.fsf@cloudflare.com>
In-Reply-To: <87wnu932qz.fsf@cloudflare.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: cloudflare.com; dkim=none (message not signed)
 header.d=none;cloudflare.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.219.167]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e65dcd64-4d7a-4341-640f-08d8e72a0319
x-ms-traffictypediagnostic: VI1PR04MB3966:
x-microsoft-antispam-prvs: <VI1PR04MB3966643E083E71DAB69A4A14E06D9@VI1PR04MB3966.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GrCPlz9a5EY0exvDwi1ZC7dT0+NGrHlC6B5dSUfnwHW5NYd+/nFhYnRqbZ7b5rTK/8LV8Cbrg/pxqxOtPYJsmyfM6MEKcAajRCT9+mofZXo5hpwYaacfSJsM1cBltp1HVlHKWR+MawIsQdzg8uvRNgNNBUDQhtcNkgxHBF98fbnStNoMbGH/PCiArg//XU/Xy7NKEyTp2MU8tQp7DF8oA3/Jxc7B3qN+drMkV0wudEaKJZcfgQUG8jx3wr1uPteTcghS1kxPUuuu5Z8uB6/gbGsluKmJa6O0HND+YR1C1Yu1gB63xwO/K4SEPqh0x//a/gqXzFrhjK+dFgMKXkxHF4Iq/LJfXuUoFEKh9uv5omkLQewy3vtzw7IwNmvmHSDxepJ0fmzKsZzcRllMTRzD0SPsmE2BiaLXMrwI/VVByXjd5HWcOmvAMj2fRDMCHHoGrKmEWoggIi6jF8QWZ6MeTM9knzDnYwsaOOzARj7x0JJH88Vl6Q9gdKS4UgGpIPfgujE34dwDSIw85GW7bI9mHAmzk8dPodRXRPvrB1Ey26J9rYDnf5uiWRK67S8G1ebs
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(346002)(136003)(39860400002)(366004)(396003)(376002)(1076003)(478600001)(2906002)(64756008)(54906003)(316002)(71200400001)(83380400001)(6486002)(186003)(66476007)(66446008)(6506007)(66946007)(53546011)(66556008)(44832011)(26005)(86362001)(4326008)(33716001)(76116006)(8936002)(7416002)(6916009)(8676002)(6512007)(5660300002)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?Aa4miYFZxMGpBtugx7w/7f/SsXziirYz08ekmyT0WSquRZI83CBMp3VUZvMm?=
 =?us-ascii?Q?Q2T6sNsIgJKcpJVxiWBOsjyXz8BBYWqXZn6nRKYu53yY3shwPrBB5Aw/XoTZ?=
 =?us-ascii?Q?cUKc+kq3KbDb9AnmD3hl/YpJGJtPC9WU4uwkwxFJEkU9afcNb6zOPXCLfWg+?=
 =?us-ascii?Q?MY+fuMNBYgwcav+s2nTd3v7MTGfCDyQnFZgjGXKGiNE6d41RimZMQrd5boCm?=
 =?us-ascii?Q?vtpDIDbEihVIJOW7ReG2TnbU5kDI7ygiAFV48RaZjclF3BY47p6MoASAb4Zl?=
 =?us-ascii?Q?ukEhFO6Ae7rmiazaQwkEAsF4CRa9/lepvhyCgDW2rYZJunCCNFKzk0acErzJ?=
 =?us-ascii?Q?Zw9BwrVzlM87F6yjRCLBFxdw7qhz1EuQrHEXCdF/F2UaDf/cb0EDYZgJNUn/?=
 =?us-ascii?Q?4bRM7gS0TljSUX7WU8uVhx2gcfbLUKn6jps91dzufhmhoAN5clZ+4+Qy1+m/?=
 =?us-ascii?Q?ubbWny1Xc4Cpj51YbH7qW/v7jl6jrEpRbjJ8szWJG3pcxre3vMeANxWuspDc?=
 =?us-ascii?Q?kK/nSkYdPCzTsFIu1FZPiJBAH3cHDdS3hNc7l0ft3is4K+eHc8njvYSkEt+l?=
 =?us-ascii?Q?BgUG825BycnD4vZ7ZwUgyhXme1npTh47WkuBVB35z1lMU2QA7tOTxJJKm04V?=
 =?us-ascii?Q?H3wllQ34fKn4+gq3JhVsDN0W757r7dXXMYnTyPzTUonkxdgNomTJCuiURZlu?=
 =?us-ascii?Q?X3QtzF2xkPgGosW2QrKqMO9Ao74+jgITUhvsht/QOfJ2NgWo0YvWJ1VgYm35?=
 =?us-ascii?Q?4VY3rIkYAYrLrz1AJ89dc75c2rQa7c1vn1cUm7GbrjMQGeWgvTQ6nv0Kl/BD?=
 =?us-ascii?Q?wDU2+46deIbWGnCnXKWi6J4/XhpY37SM0NdgzDySIaxzpqnnjUSfL/JOtzIa?=
 =?us-ascii?Q?5/if2UXBXoVIN5oSZ2FwKhkP6d+vT3FqJA/BPMEev2Hr9WuPaNujSDiaeglB?=
 =?us-ascii?Q?R9OovPCtWcPUkc+gpIB/byqG8BCb+ifGN02gALiEljOzMj8FEjleCpUnU2nm?=
 =?us-ascii?Q?hePDQBAQgmXTZAmPjLlYv6JfBuilf6xI2i/KAMQAwIa8ftwHvV4OD6/PXPPj?=
 =?us-ascii?Q?6Oe3k9r1QwFESfhdMTkMrYOvN9xfdLRC2jN+j3h9ncvVSPBnhYmTrkZSPBlI?=
 =?us-ascii?Q?wYX9Bvb9pWKJyZJVKqZiVajKXN2bosYpH/OuY/IABRCNi6Yq6oBKLmHmKHap?=
 =?us-ascii?Q?0wNzgsWUYVPuPW8y/5gcs0ZFwmOqWfJxKY7c+9PRURTEPuJS3jlvwvX9An/V?=
 =?us-ascii?Q?dr1BGMdsNsqnk2BUdftg3+UYaJwpZSo1RlCH7A92j7x0kjE3nZitXkN8K5aP?=
 =?us-ascii?Q?MXVDS26/eVqza1V8N8Dad5UfjOO/Q2c9ZVnjNu8fUDNjvA=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A5D8C7B788D29A4FB171BCBF08F01914@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e65dcd64-4d7a-4341-640f-08d8e72a0319
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Mar 2021 20:44:49.8504
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qguH+D497OvPvB7JIRtXtl/2/riUz9xesQnarb/1iYEC18PjWfPnX8qF6N7KtzWcUm640zGx8XlJYVHnBCyI4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3966
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 14, 2021 at 09:21:40PM +0100, Jakub Sitnicki wrote:
> On Fri, Mar 12, 2021 at 09:08 PM CET, Alexander Lobakin wrote:
> > flow_dissector_key_icmp::id is of type u16 (CPU byteorder),
> > ICMP header has its ID field in network byteorder obviously.
> > Sparse says:
> >
> > net/core/flow_dissector.c:178:43: warning: restricted __be16 degrades t=
o integer
> >
> > Convert ID value to CPU byteorder when storing it into
> > flow_dissector_key_icmp.
> >
> > Fixes: 5dec597e5cd0 ("flow_dissector: extract more ICMP information")
> > Signed-off-by: Alexander Lobakin <alobakin@pm.me>
> > ---
> >  net/core/flow_dissector.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
> > index 2ef2224b3bff..a96a4f5de0ce 100644
> > --- a/net/core/flow_dissector.c
> > +++ b/net/core/flow_dissector.c
> > @@ -176,7 +176,7 @@ void skb_flow_get_icmp_tci(const struct sk_buff *sk=
b,
> >  	 * avoid confusion with packets without such field
> >  	 */
> >  	if (icmp_has_id(ih->type))
> > -		key_icmp->id =3D ih->un.echo.id ? : 1;
> > +		key_icmp->id =3D ih->un.echo.id ? ntohs(ih->un.echo.id) : 1;
> >  	else
> >  		key_icmp->id =3D 0;
> >  }
>=20
> Smells like a breaking change for existing consumers of this value.
>=20
> How about we change the type of flow_dissector_key_icmp{}.id to __be16
> instead to make sparse happy?

The struct flow_dissector_key_icmp::id only appears to be used in
bond_xmit_hash, and there, the exact value doesn't seem to matter.

This appears to be a real bug and not just to appease sparse:
ih->un.echo.id has one endianness and "1" has another. Both cannot
be correct.=
