Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACD224B3B29
	for <lists+netdev@lfdr.de>; Sun, 13 Feb 2022 12:34:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235613AbiBMLey (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Feb 2022 06:34:54 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230480AbiBMLey (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Feb 2022 06:34:54 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70040.outbound.protection.outlook.com [40.107.7.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D9C05B88C
        for <netdev@vger.kernel.org>; Sun, 13 Feb 2022 03:34:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=INyMd1SArUnNMdj0l4nEbZivhRi/YGlkgSba0ZGQQoY1nrKJq726hjDpIy7wuJdelMh4RkROoaP9q+Ni0FTlrXGCj3tkT3yHhLrPhGSxciy7izyAspqFmkceCYH8WZCTQRaSZtd8uDnJPk0R+0IOyaepYSsTj9uy6XTmJNxN89Ql0raBPLhUdD5ZotmxxnHBr1xIohiRBG8Ai8ZEPdHUnfe/HuNDCtMMPIKry1LsPhNX8xxJjCje/ZmxMfGlc9VAKTbXFn1kdz1ZcBOWDymAmveBl1v0S2aldomSjnr+DDOCH5715+im1Rjc1mqcNNgXf56mjG/28V9ds6afNk0pFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1xkpQ+/0WWku26kNHv+DCbFwoNNbPdRZoMAwyGc1srw=;
 b=ocG38D/Jgw9g9Yr7W8yTV3vZX/7Edf3KOyuPt1SoC+i0nikrKUgfViPWoA9KZY1QR28kMd2k/Ev+jo8jY0wxfq0MNaX+pBCBMW71mhWhEQX1dN16wNw4Ag3Xu8GNSoxLYtAGHTvVYk3w4m9kaAS4X9+EegqcOVxBlv5DZN+gHJAZCK0S9jhwYYsVFGQlXnniI7zj11HWXa1TcIwPK7wrfK+/4DXtnilqD/vb8IZj9Vi65Vasm3wB1QQwfk0GJ8SZ4+Fukjjj8M9QMvRlw3xqTRh4IVnP+peyV8QInsu954pSNEraqbPC55cAACkFNw4y+wgPU15a6LrY/24DdH+gHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1xkpQ+/0WWku26kNHv+DCbFwoNNbPdRZoMAwyGc1srw=;
 b=oAgfx4Et0hhMTotv0ZRRJU8ToXlexo20B8JIclhTnvdRsPKKJwAXDAI61psQ767P1a5wexFk/uRRteKGGt6YXUTFpcIKF3eeu/aWNLqEP2y9iMnlRcDi+hjrd51jB6FTIZSSN1ckK3CVxsGc4s95f2jVH2J328TRpiXgoQTNQKk=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB3119.eurprd04.prod.outlook.com (2603:10a6:802:10::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.15; Sun, 13 Feb
 2022 11:34:44 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Sun, 13 Feb 2022
 11:34:44 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Rafael Richter <rafael.richter@gin.de>,
        Daniel Klauer <daniel.klauer@gin.de>
Subject: Re: [RFC PATCH net-next 5/5] net: dsa: add explicit support for host
 bridge VLANs
Thread-Topic: [RFC PATCH net-next 5/5] net: dsa: add explicit support for host
 bridge VLANs
Thread-Index: AQHYHfxZ7OUNGWiSLUSVqwQMKllhOayQsMGAgACuqYA=
Date:   Sun, 13 Feb 2022 11:34:44 +0000
Message-ID: <20220213113443.ios6fj253y77x4yf@skbuf>
References: <20220209213044.2353153-1-vladimir.oltean@nxp.com>
 <20220209213044.2353153-6-vladimir.oltean@nxp.com>
 <87wnhza7xs.fsf@waldekranz.com>
In-Reply-To: <87wnhza7xs.fsf@waldekranz.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 081b8b74-a6b8-4ca4-a85d-08d9eee4d4e9
x-ms-traffictypediagnostic: VI1PR04MB3119:EE_
x-microsoft-antispam-prvs: <VI1PR04MB3119F210D373F1EFA6A9E868E0329@VI1PR04MB3119.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fL3URkNnFJQQyACpCvpbW+AvLVP1IuL8nyN9y/UBSu2l5ALbcMXUjl9DCMHin1AlnCTUWrcpHk6kTdW/inCThoL1rnmJcPCZwLZrBoSyFyJ1GyG78Jsru5ymUX2D1Dz7FE6iPwps3PGawNIihyQKSeot0UhBrEETN8AFnQO5JueS6q+WN1JDMpvSD6v/Bfgjo+7GtmsohmAhQ6n93grN1z+jeBU/P/ab3wr9u7PBYZb/Ke0ZzaPsHGbLPuN/uUcdWC9B9XV2E7JeSNgg7m79VFUEEA30FnhiXq97B9z9EI4HaVvZTRj2pxJLFrnr8ItbdDj9B/cSDHjVtqOlXvXnSAuMtz2AhpQP5LPzd3TASr9UP+vjOEbhYhx62kPsOW5N9mpanGRtAcyB/xfMcFANL+yCQgHwOwU34AYQ7xCD83jiCgt7qbRzG6s5NqCgtAL9yOmaQLyuaDYSdb/LMAa6LJ3PTVluCkIzVTLbxmuSjoNu99tz3awl4VeCAqa5MtVYfxBcaPIRRKYT60zsX+ilIKYyOorz82ODNXEa/QWMf42gAMxQTmpd2mjam40UL87o5jHpzhEW9fCmMC8gbofDOOhhO17I6Fh/AlvMuuBYIV3q2VepzCGfgG6KHPBkPNCFNTSEWQC3E9YQ7mX9JC8iajFJegZ9WnsySmo+bWNTtVaMDSJ4YZApUgrb55+mEaZkq8x3VkyJW5KK/toMucpLPA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(6506007)(6512007)(9686003)(6486002)(2906002)(26005)(186003)(1076003)(122000001)(38070700005)(7416002)(5660300002)(86362001)(33716001)(38100700002)(83380400001)(4326008)(8936002)(8676002)(64756008)(91956017)(44832011)(316002)(54906003)(508600001)(6916009)(71200400001)(66446008)(66946007)(76116006)(66476007)(66556008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?MXx84FY0TuEFlAJ8AQOK+tcVA/sdZtCPCaTtLgVFLANVDbpVCKEJs2oi+Blh?=
 =?us-ascii?Q?k3wcSHbzGfnV69umoBbZ66p3Gno4+3pwlMMrruQ+IaFnxlYf77TUgAgxJ3SR?=
 =?us-ascii?Q?Xp0OwgVcnR6Ngx18bp3P21exkPPgXjEqKxRm5BAHCBIFh2ony66PJNYJ0JcT?=
 =?us-ascii?Q?xAO01csl66ZYRe0mIdxytLGexfEu+zKyguHJe5m2xmn8PG/8o85HbwnGEkOz?=
 =?us-ascii?Q?YlS4o0ZtI4YC++ettS92f8CZuDH0tr/EW5nBUFovC8AnNiAaLTquFgNyboQm?=
 =?us-ascii?Q?xDpmFLXhDQ7AbYxNEGU7oaAnQ3Wc++IQLhci1u4hfN1SXvEBvHgcarvf5HYE?=
 =?us-ascii?Q?DIj8s1ZpHgaWVZ9m80/cKIpM+9jBp8V44F5M/0fjICXb0E4TRhqg782QjeOJ?=
 =?us-ascii?Q?i+R4Q2QbOpKxS71Hl1HWMqjTh1Kv1BTQpxr7ABDvVFSifuprmyi4Gh1fmXAI?=
 =?us-ascii?Q?MhtNgH7376NZqRgFY3G6C0cC5PPbxfegAhWWhYNJQm8ttZ2MFnsNlrCWIlWC?=
 =?us-ascii?Q?gFSfL+bZAW+1yJ/FpDiiS4yaQ7T8Yot02VjLn+tCgaNFq+PmoS6zO7defzvq?=
 =?us-ascii?Q?hD3awJIBlbCDKBPYqTzbiZ1eKkZWfQ1OAKD0ybFVJZmmdiMbRlTnBOfwsWGo?=
 =?us-ascii?Q?Cz+wmScpUOlTrSYjrKifXsuJ0PPSpmgLuQWhg+QVmuydi+GiLnGityEL+3s4?=
 =?us-ascii?Q?bc0gBCXv1MQyraqngkHzhcBSGF9j+PNJkd+jPVcw90GggY0L2HAQPJU7xjb5?=
 =?us-ascii?Q?rO17ldgW1YZqgDTA+IU7PJQf5+ZeN33s3dudA9vsh4iJ/nPdDD2dsX5Y9xsK?=
 =?us-ascii?Q?isRSzypMrfl0V0+p64bdbNaj7CpSFDTcjVdW0O/MadOxrL/sYwLz3vuaJ7t2?=
 =?us-ascii?Q?Ju1SfufbnsQkXdThVCbk+6oqM+dnNEtwHBuQaHi9M7rNP0Y1wPd9tz3mQ7Xr?=
 =?us-ascii?Q?QtszlUvC34aLh6s78Q+4NbZGxC8bmTYIIycbFeuPXTu3K2NDuhowSLNMA+OR?=
 =?us-ascii?Q?WUoxLzMn5FKOYg8jHNCbCuMwsVmfZ4O79R1MJnmHCCqjBslIfqlXnXmabz5S?=
 =?us-ascii?Q?XGcUn1rSCpE8uzK47mOPHtgQvMfjgSz3zlcRR9wXsUz2//74p7T7eAWDxHPj?=
 =?us-ascii?Q?+I7cQAT8D9aOgahodd9pawPb+xO0jWmSe0UDZs290wlyIv7wKVfqYOB3WRlK?=
 =?us-ascii?Q?8tOjdg4Phg12pJMgb56aOJ7CMBC5GyQHzxZ9EbpqyCGQtQl8UG2mKFksS/97?=
 =?us-ascii?Q?Iw+oW+k2gtXL0SDeJ10OjoDZe/buGO2PtzJ041f1D1bj5wuDwOXlV7PuHQGy?=
 =?us-ascii?Q?1mcKMluw4OLGQy0bHFqlWFdfVaGAc0M3pCdWVIoKqYxcaYhNnZqN6VqK5vVM?=
 =?us-ascii?Q?OXNbQpVlvOomIAdevdOcywOzUWgMahbyVyQLnFHeC476aL+1TkiChA4UvBz/?=
 =?us-ascii?Q?qDoKcA4jf4M/Ti6NQ/lrzl9beHUs5VPRfifSMyDEVQGiyJWJ6Nh0cHmWkLSg?=
 =?us-ascii?Q?VCD3dzhLCdP8XOaeuqzPs2MeAt3mnvv76CAEHD+nAPCuw5AjVUe51lQORl98?=
 =?us-ascii?Q?UOSv/KJ2ZNNxmKXKDug6teDBujAiabjryN9gA39Jv0hDBGY+GgyG5YkGTjkD?=
 =?us-ascii?Q?t8zyU97C+7AUaI/cgtkQuck=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E4B5D3ECC1EBE942930BAD37A3F88BA5@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 081b8b74-a6b8-4ca4-a85d-08d9eee4d4e9
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Feb 2022 11:34:44.1204
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uMcNnp8jmMs+aPtDsnZ9MYPZ4p2TURDl/UbwFzER2lY/GtGTDK1HsZusQzuo+9AZVH68r9yrulDlhCmxrxc2Yw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3119
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 13, 2022 at 02:09:35AM +0100, Tobias Waldekranz wrote:
> > Therefore:
> > - user ports contain only bridge port (forwarding) VLANs, and no
> >   refcounting is necessary
> > - DSA ports contain both forwarding and host VLANs. Refcounting is
> >   necessary among these 2 types.
> > - CPU ports contain only host VLANs. Refcounting is also necessary.
>=20
> This is pretty much true, though this does not take foreign interfaces
> into account. It would be great if the condifion could be refined to:
>=20
>     The CPU port should be a member of all VLANs where either (a) the
>     host is a member, or (b) at least one foreign interface is a member.
>=20
> I.e. in a situation like this:
>=20
>    br0
>    / \
> swp0 tap0
>=20
> If br0 is not a member of VLAN X, but tap0 is, then the CPU port still
> needs to be a member of X. Otherwise the (software) bridge will never
> get a chance to software forward it over the tunnel.

This is a good observation and it can be done - just in the same way as
we treat FDB entries on foregin interfaces as upstream-facing FDB entries
in DSA.

It also has implications upon the replay procedure, because if we want
this to happen, we must replay all bridge VLAN groups, not just the port
and the bridge VLANs. Again, similar to how br_switchdev_fdb_replay()
replays the entire FDB.

I can start working on these changes, but in parallel I'd also like an
Ack from Nikolay, Roopa, Jiri, Ido on the approach from patches 1-3,
since the whole refcounting thing depends on that. I think it's fairly
safe, but maybe it breaks something I haven't thought of...=
