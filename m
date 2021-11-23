Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CBEE45A9AD
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 18:09:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238738AbhKWRMd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 12:12:33 -0500
Received: from mail-eopbgr00057.outbound.protection.outlook.com ([40.107.0.57]:53984
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232689AbhKWRMc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 12:12:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aJwBiA8ziYMby5WKwr/gBxIyrjH93ijZ/m6ieIVNaUdm0P0RhFnWWwvfjfii1baf2jTN1RM8MttbxNDOemAPiAfRPihWU3QtsIc9EdIakS/fvUD3Da9EBmF8dgHJY6tfhwV75g/IXm9gG0r8o5SLAaLMxNQvGuOFdDFgQqDxVOOJaaIsHl0iDfxWWCFqZrGYGfEQ4jMAHs8ZKWI09/bnA6q/YRi1vbQJKFEcznTuhXiPIqehH4uS8azU0aDBsan5jpep6AZoH+HwPRe71vyoC3k621R0G5CEh1JTlci4Q1m6NihrHyskAV+17mlqN/fb4d4FHCG6xy1uhF+gaerZvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sFz8A3wXe6ul8zGLV68nnO5cVIPwkGj77v3JaDaAJVE=;
 b=lF9nLvakRCkNKcaKVDySEB71J+3JBDcpNpPRdenBwhFJCtyrM6W0Sz9zQnaD1wTWlIR4v/ThQ9byyQSqtVxZr5u0NP1f41ZCzLwJDXeWFtXc2CZjbNtF0PypHnYn2nFBNYDgenltsH7odcvDVF/I4YhfB7HjEO4vSsUNWwOKpbY7J2iHJEaZqGb4kC2qxw/uaNRzaedLwlzDLIy/hgMN337dELeNHr8dnFmqbCfNR/kgH2P23VCyNAyYv2iSI+N0yZ/AcZ5I4VA2/qpvaD8V4lC/RyealKkyF0cryxeXLpMqikUdpk/j5cN6kGRMQGkazxBD02zbWWeiP5I91BOIJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sFz8A3wXe6ul8zGLV68nnO5cVIPwkGj77v3JaDaAJVE=;
 b=GcHU34rBadAUTzje8qtWsYAZAK0gSnkshj/iWGAuycN/yNyLE6AK3K2o49F/2rVSztwK6MrSDS43PeUM6v1yKpnZyA0xPq/aG8TvM9b/MJBX4TGT7iDOm+m+M7V9ZLqWy2o6X4hKR+erZSx+NjpEsFXcdMm/PYGf/TJQstPX9/U=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB3071.eurprd04.prod.outlook.com (2603:10a6:802:3::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.24; Tue, 23 Nov
 2021 17:09:21 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e4ed:b009:ae4:83c5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e4ed:b009:ae4:83c5%7]) with mapi id 15.20.4713.026; Tue, 23 Nov 2021
 17:09:21 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Shay Agroskin <shayagr@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        David Arinzon <darinzon@amazon.com>,
        Noam Dagan <ndagan@amazon.com>,
        Saeed Bishara <saeedb@amazon.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        =?iso-8859-1?Q?Toke_H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Yajun Deng <yajun.deng@linux.dev>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Andrei Vagin <avagin@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Cong Wang <cong.wang@bytedance.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH v2 net-next 05/26] enetc: implement generic XDP stats
 callbacks
Thread-Topic: [PATCH v2 net-next 05/26] enetc: implement generic XDP stats
 callbacks
Thread-Index: AQHX4Ij/XaaTEUdaCEG47cK497YtaqwRWKMA
Date:   Tue, 23 Nov 2021 17:09:20 +0000
Message-ID: <20211123170920.wgactazyupm32yqu@skbuf>
References: <20211123163955.154512-1-alexandr.lobakin@intel.com>
 <20211123163955.154512-6-alexandr.lobakin@intel.com>
In-Reply-To: <20211123163955.154512-6-alexandr.lobakin@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e74f17ea-6e6f-4040-5d43-08d9aea3fdf3
x-ms-traffictypediagnostic: VI1PR04MB3071:
x-microsoft-antispam-prvs: <VI1PR04MB30719CF0A26B35757B8CBD79E0609@VI1PR04MB3071.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RlWa2d6GjAouN0DWrAYJ2wE9bZKDQBOINPHM1T4CvfJHSGQWhJVpezsgOuMMiBW3TBGlGM1JtxMwT5d3+7zxq2HSeoepN71Kzll4xxRC67afDjofU5O49Iql5o65C39MrTyadJtQHey4o56ddamFIvlB35RT2D21MhUKTXwIvSp7Z/XKfxLZYE2dC9rw9sAszI5o/yik2BSBrBLzLyh8hSYzvLQJ1ZLkh/ZQeWmmuf4Z4bQCtFCF/uUQs8plQ9q7ZwvLtwjNnUT2Gn9wLFETa739dIg2KZMdlGJPAWiFbqi+4LX7vJdo2moCkkXVEQXEtw84uyXyJuIjpHNIAsUggN2iLqN1Khvh59fzZ4c49pTMk+gJdNyeo+L4N5AHg1IlZ+D4IdbC1hzx+bREutqm0fUuvnO+lOdAKuqGtHabZY9EDjSn5JFI9TdozjkPrKxnb+erWLEqOCVzxfH/A5PaRPX9pBLVEagGNybgQd6CGrDVb041TWX8qFUlZtUZH1kodL2ppgSGX78m1izcMIDrNJFhhJQbnMpePpORNuGXKjRG//PVtyzK5alvxYgz5SOfdYUVIYTYoFMjPVNG8OC8gbLeanVhM4v5nYdXFTwKW7euVo6pO32Y99nKxuqoajbkOp2lCaAmRlkewLpGY6IRXTC5ojV6jRc6FlUm36btBfCUtOoueygaukIN84We+3KMPCbrKd6uzp0tHN7xglouHQsEdoIx7ss03WRNS5hlc2E=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(5660300002)(316002)(6506007)(26005)(86362001)(54906003)(122000001)(38100700002)(38070700005)(76116006)(33716001)(4744005)(4326008)(7416002)(6916009)(44832011)(2906002)(186003)(91956017)(66946007)(66446008)(64756008)(66556008)(66476007)(71200400001)(7406005)(83380400001)(1076003)(508600001)(6486002)(8676002)(8936002)(6512007)(9686003)(41533002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?JW8yOrmhlIJ9W7FBJS5OwQSrzUXEchdRLunt3XzgWBHSRd+tJnGMS7+IiM?=
 =?iso-8859-1?Q?5HGB+RE7KlZQGU/inOKrCMlBtw/JxpiIWF2KQgeVDpoxF8PfC4X/tJhgjU?=
 =?iso-8859-1?Q?+DDMx9TXwm97u2nDFphW/BY03PwcSM+UA8of3Mw7ZLvUhLbA4TVyWcdSnH?=
 =?iso-8859-1?Q?SZDYcbvvq2uXCY5ea1Nuc/Udh7ISolPYGQU+eKD2HDbFz9cYF2WV974d7j?=
 =?iso-8859-1?Q?x97KNMsvowD2TX2NQpINjIEG11hzLi+lxaUQddpnZj0DyS1CtW5CY2iWRQ?=
 =?iso-8859-1?Q?IEcUXtDS3f9GsXkNCcgJkRlmEYPlo3qj3f7uuDn+88sxfqJuRfYYzZfIZl?=
 =?iso-8859-1?Q?eFoMlHzhek4wCOe6CR5bzTmp5RcEeCza/4CCEHMZqT/BZ3PySW2TaLGwxm?=
 =?iso-8859-1?Q?0NiIQZyaz/Eg36TQYjzRtInhFVkqrNYwlMJZn11sJ3xqjWc5AnOAxueG4+?=
 =?iso-8859-1?Q?AgE1ZXzYjCsZ1Ed3ZTOlJiqkP8qkTuS1dSBvUNgsCy5TXB+0GFEca0YZm/?=
 =?iso-8859-1?Q?z0D8bnoN4eFEYpKWNdHpQbRBn2X+91QH9Ul8i5Ym3O82bJtP0YfbYraKEU?=
 =?iso-8859-1?Q?40nBLfK8FYdzlOVyeB2hIJTUX7r3rgutBFy/Tm1KqB3m+hNf36vzXstBbe?=
 =?iso-8859-1?Q?8eB/3bNG2mvhVAbTbXCD/fTTbWMxuFRloThL8ByXtzTkZiwA0hMrcAI41N?=
 =?iso-8859-1?Q?EEN1Sc1EjaxTKab8Bdrc4VLsdqNkFWPp8TF1yFwKRNR3jIEp27RrN/0wCd?=
 =?iso-8859-1?Q?J8FV/bP2b+K3+4fA0eH1NKQpxcT8uH/Y8/1R00eajGR0nYyPRxZCfGbZNC?=
 =?iso-8859-1?Q?WmxVxfeaX3/koStWP4zvZnj2Qb7Hy6YwlC1agevDaNd67UO7l8nuvvHcvd?=
 =?iso-8859-1?Q?xYrrVhYG46CjP8D7KGRXyc/7udCAPYFLsHv8vVWjyKg784f2QiFrFOUeiK?=
 =?iso-8859-1?Q?pgBtduUAiUX3XkchgfoDAIDi8btuLzh5CJn40++iyWPZr04w77/4j+fUn2?=
 =?iso-8859-1?Q?2K/OI15nlESHcSOKtSA+x+x4Rqk8iSRP+hsAo0yWJVs+6GqMr4b+jpE3UH?=
 =?iso-8859-1?Q?H0l4/r7sixxKxWa5P9LVxiGU6varfrJlegWSz1m2a7Hy1890cIBoQ3pSMT?=
 =?iso-8859-1?Q?IweZaLOoZsLNCSGFxA29sD5UQDo8Aof5O9m7feJXwUIzmUPnWaFJGeNnT8?=
 =?iso-8859-1?Q?YizqAmUVQysaH0KN4zOYwWuK+kSzNEMQoilb21lMsAZQNuxQkwwqvoXYnA?=
 =?iso-8859-1?Q?fcI/cXZ3smkT2ThfOouSlKq2voFfr03rZGwH+3k0EmmNsJ9AxMk7DTtXPO?=
 =?iso-8859-1?Q?NxflatyjrzlxPqQ8yYTpbYVsnEFt+/950jEJ7lNNOnQm6P5mV3xZhyxiWD?=
 =?iso-8859-1?Q?UnBtfKBMB78G3ip900BO7DaQGvEaaprrjrpe2iQ16HSSqrNFlteclrWANy?=
 =?iso-8859-1?Q?Js9XvNNHCZ4SLBsAr3YW5b8VhKD2EMC6aQ0xV0kpBSZwqq1+07PF83BVWy?=
 =?iso-8859-1?Q?vX14UrTRQNFybOodT887Ib+P4htGioShitSREhWu8PFFMlyTqH1GOi3PXM?=
 =?iso-8859-1?Q?sGDZe++s01TTpPYFp/nr1f5MCOTRZSepUnowI3RXnnzxxDA85H2gLP//B4?=
 =?iso-8859-1?Q?gcsxwfOrBvL5zUGUL72BooskgRqSUo6R3ekA5oEZ1U8WwS8VoIWyzsaYJP?=
 =?iso-8859-1?Q?mxhFSNWr+3ZYSG39zLE=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <2AA94709EC439448AF69418ED7F16FA2@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e74f17ea-6e6f-4040-5d43-08d9aea3fdf3
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Nov 2021 17:09:21.0244
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3QRrG693W66XYh+Xso8p+euLwEA0GaS06tX919y8ci0c/vCVmUmntDvACx4stx7kXc8M4O6Ba7tt7xIHMDa2xA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3071
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 23, 2021 at 05:39:34PM +0100, Alexander Lobakin wrote:
> Similarly to dpaa2, enetc stores 5 per-channel counters for XDP.
> Add necessary callbacks to be able to access them using new generic
> XDP stats infra.
>=20
> Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
> Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>

These counters can be dropped from ethtool, nobody depends on having
them there.

Side question: what does "nch" stand for?=
