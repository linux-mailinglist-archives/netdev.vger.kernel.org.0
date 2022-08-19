Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B343599AA8
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 13:18:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348595AbiHSLHN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 07:07:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348690AbiHSLGi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 07:06:38 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60074.outbound.protection.outlook.com [40.107.6.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28CC7FAC7D
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 04:06:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kufNHl5n3x3LtLGd1IvZ912ycAWkKGctkqy5rhiaxLKmM3JA7hjv1CCOR1DAor5g1Gkpshl/IFaXO8ArWZNOiQuDzOvX6q3B7FEOU3X6hc5tSTztHpbDv3QYojVznxQeqSWV3ZyrV3QZzQzAI8nzzzyKDPWO6Q6qs5UDN33v1SX+XWMHHa+WfuQmiRrpATwW7vBO4CQK3B/S1dtp8Z2iGOL3BIuDOnaNxSZ/YaqE5N+KLBW85JSaqzq7OxXFh9/3dIrhocvNJMEqhEAP7dS42WGGSRGptVXDOKnbF3HCLdb0dzTALYFjYM7ohqO5UZEen69VpNJ7yOvaGATyg/aFGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GuO9d0JyW6X384h6j7vvWuNhGtcyGWaKg0QXSSvlGng=;
 b=byouVDjUBwETBv9WFY7IG/fxhYH3vsgP3m+bU1C4o+rQBSZGPWRHUWLyMawdyW8fUp1eGvEp/J5XPerTo/oO4OC/lH1UjTk8FKhIhh6hXLxhHDAhW1+15ehkFsNG3Uir8Sm7o3IjFqp5CCcmNc+o0r20265MG+vwOkMQgm1wGIo4SH1zUxE6bdEr28HNcd6ho+y3WFBy9ALkVTZ2X3FNvfRocPDxAl6o/xfCyI7vw0yZQ+qBJq817IJPM1SX3Opdo2ULUz6xHRul0oR8GanDfY9P6kMBQCV4fBeQD77Qh6KfaybxV1NWvkm4+eq5fDr0n5um+r1ABx3F82awmsBP0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GuO9d0JyW6X384h6j7vvWuNhGtcyGWaKg0QXSSvlGng=;
 b=NY4/P2gxKdodH+3CW7bLxt/vgmMidarME9ip4AdCZ/G0jVAg8d+kkA9RdVZMMC+2o3SFqut3KScobP5QKQ8d2qv9MEb5I0YYKpkUUiSm5GuSk0H7ty+hvNAeBIjV588VwtwgvrABLX1+MkBo1FwQI0o8oIISI6m6r/ymyePCaeE=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4046.eurprd04.prod.outlook.com (2603:10a6:803:4d::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.18; Fri, 19 Aug
 2022 11:06:24 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5546.016; Fri, 19 Aug 2022
 11:06:24 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: Re: [PATCH v2 net-next 8/9] net: mscc: ocelot: set up tag_8021q CPU
 ports independent of user port affinity
Thread-Topic: [PATCH v2 net-next 8/9] net: mscc: ocelot: set up tag_8021q CPU
 ports independent of user port affinity
Thread-Index: AQHYswnglvLyEnQT3EOaMpXlfQkMiK21me4AgAB3bYA=
Date:   Fri, 19 Aug 2022 11:06:23 +0000
Message-ID: <20220819110623.aivnyw7wunfdndav@skbuf>
References: <20220818135256.2763602-1-vladimir.oltean@nxp.com>
 <20220818135256.2763602-9-vladimir.oltean@nxp.com>
 <20220818205856.1ab7f5d1@kernel.org>
In-Reply-To: <20220818205856.1ab7f5d1@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9aa2a38e-8618-49f7-7b98-08da81d2dae4
x-ms-traffictypediagnostic: VI1PR04MB4046:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zjZb1+98CKtiOHsqlnt7JaYhGO9pfJar7U+tjrvaPk7qG7kdUkvtXVIhQq2BFBZZub98XF6TlTJodK3bVZRgIxhniq2Z0webDftyzDRN5SKmE6byMD2k+Czxjxop4hbf7JBATRe2yNdc0UT6GFVRlOcMgvpAQw55H8CWURPTOGfN8jAQJd4saisUKHD8L0j4pZbIprZMw5vnxh1nX/3FmsQPX0zJ9HxEjlydADgmAgk7IEb1A88Vr8JH+LHwLNf/jXAkttfkSjHcZmC+hegMBiwPEOYmS+WFKypPXWkygCm9BF05Att4iIQt4wvFw8cL/rjmJvOW3NW4lJV8j6gxKYvYMmXgFW3Xl3rHcucdkUHwkvalY65VPVFj/oj78BNv0K8MBcsFyuegjeL2BmhGpSGnpJ0J+EEueQ6Th8MAoBXKkxhFk5hiVB8xYfMuVd50BbtZMP1QQLw6uN8xvpDikwReFcOgn1hJDtIcfHHc2skscryTilX6Z1Gkdi/Xjof4P96oZOQL/WHGOMBD9fhgO8e3kze0XuS43pLsUp8i276mrEDGsJNZ7lpG71K5J5UxeR9IiAl5jQ1rt8PHlE5NJCyEfWb3mkaHwXeKKN4kbokVthDBhQG2BB2GdVyesQpunAFSAXIDcvonLS72RoS7szBE3PfOP75qF97mKJGFQEXMBYRuQOoGW28OpAtH9Wk13An5k2kpoSZ1JaLrc6MkMPf2yNgoB9nE7bXQJE38FulSRcKGjSTzgb4evepaf2Ut
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(346002)(366004)(39860400002)(396003)(376002)(136003)(316002)(41300700001)(6916009)(54906003)(6486002)(478600001)(71200400001)(33716001)(8676002)(66446008)(76116006)(66476007)(2906002)(66556008)(66946007)(64756008)(44832011)(4326008)(4744005)(8936002)(5660300002)(7416002)(122000001)(38100700002)(86362001)(38070700005)(6506007)(1076003)(186003)(26005)(6512007)(83380400001)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?mSF3YRomtP6DcfHZ2f4oUPKEt9u1H4DU18NLnGjGq7ZjilUjFYIFF2QdhU+Y?=
 =?us-ascii?Q?RCQXg6OrJJjEg4h/L9MzjTY0EH9xN93uD4jhsRaXjLEkgYNXlrzu/hM8LZ5v?=
 =?us-ascii?Q?o7+F1vcud4BR5ghRB1CD8DiAhw9ehEG4myK8ivOMrLvtHgqwxoWr10nsNR5H?=
 =?us-ascii?Q?AfggmKzTqX6/EDHiEB+PqETIsXyobAT83eEdVjQusVulnYHoCOFrC31t44jx?=
 =?us-ascii?Q?7YpoLV4pRSm9mqZv5IhzzGcpOUnC0AMD41vSS4uJcilolPg2BN2VxJJu2poF?=
 =?us-ascii?Q?YJIUtk7F3o20iRIuLcXXSftMMOmKC3/sY2MJlbJxF40ovQbjoggzV616Yoy2?=
 =?us-ascii?Q?kU55YoAPc01c+RDecdIjTgLSGfx2fSNONMS7R7eUq3QMLxUZs3lEVLFFMfB/?=
 =?us-ascii?Q?fvyW/56KC16v4Hypi8DNg/HJ+IDWthfoAR0FPiDl3H/0tijpzKyJPofQXBlg?=
 =?us-ascii?Q?fqAZeDTYftMIUsd+RAFd/b+ji1vYMpat+tx65u+NpedLdlErgUr1wvPLKGqc?=
 =?us-ascii?Q?+DZUEX7RDMyRvMfqkJ4e3zKKrhlSjBQkf6pLBrI4YnUdzJ7lruxLjVZitn0Q?=
 =?us-ascii?Q?m4M7XsBpo7qujO/ZdwhZyHMkB6I40p00RQMHdapB+/tTJVuyohZUa/g36oY0?=
 =?us-ascii?Q?u9zcPgKBTcSZwtY+PVJKYBKon3KiWKnTkHaOeW5T6zI8kqmWHKBijeHxuf7/?=
 =?us-ascii?Q?6FmqX0GgmMfL17PFubwxuViY1xPDkRUISFT4uboN/Bmv1f+yStZt/ejZZYCp?=
 =?us-ascii?Q?k66T3BvR7B/m1ki4+4aWnqTiW2vy80cS7xPBsbnd0Kzemz18XAD4OFNbz+3m?=
 =?us-ascii?Q?Hp7DQy/c2g6Pjqgw+ajcnj6EJXUSmxZajdS9o4+bnqYNSfk99ckbYyH7iKiX?=
 =?us-ascii?Q?dNtVf7/uo6ITi6WVglwS1EFfXUj4nXpa/nz1z04IEXxe0RAXCC77m8Sjzjj4?=
 =?us-ascii?Q?e6pW3COpvWSjTWhRPtDhfimbhTT9OcfhJwhY5xjvcjxJ97R5UtVfVKiR4MwC?=
 =?us-ascii?Q?O6eVfQRvX/Est6wHnhu2reSBjjBuo66hYATkVm6dl4/OVdYJXEjG/XO46RKn?=
 =?us-ascii?Q?vAfSwERy0y8g1LyQ8XfQi/L88JhSr/h/n0GJwmLu33amfE8HCFLV7YPo5+QB?=
 =?us-ascii?Q?YBX9Wu1eIJMrApUv0JPoMk8aW4o6cseRBOfaxSipdoDItVa+v4GwASPn0dIP?=
 =?us-ascii?Q?A/1t5NFXe0B/d8c2frHRbscVXaZNtgf89wyZBiDBmvIcPjbSqsbbnBe6s4VG?=
 =?us-ascii?Q?0qcczNnMcEJ6h07sAMmi7BLqtorIpa2F2iAzQlQsAJfbA6boNMMYTt8ihJYB?=
 =?us-ascii?Q?epdXHk73QVFrCZIXpglt9fZgLuunwv5b188gwacgQ9+HADMjzGCgSFhMcKjY?=
 =?us-ascii?Q?3DYYGATiPlS8Z/2a+x7groAUTnYspMkj4fNngEfwrz9cN/dvGKcQcCpm3+2Z?=
 =?us-ascii?Q?f2+ltKqosKAxXpITt3ub1PHwT0PzInZKRife2O4ohtnabXbsKOh9Pi0sIu1s?=
 =?us-ascii?Q?b1RnOmaBSLDbnC+nwqHDSe8U+X3YgODH5YIrl66W2u8qSyQgJz31M2q6P125?=
 =?us-ascii?Q?mkx36vYBzbiKfW/bMsrE6rFzZH7weXGP3cE9ILO7eU8X6fj0pFkBFUvGNnqc?=
 =?us-ascii?Q?JA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <69176CAA41105B4C9D399B9E8FFD54DC@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9aa2a38e-8618-49f7-7b98-08da81d2dae4
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2022 11:06:24.1243
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iYLP/jBIj7iLUxNlXoaTQu8lTjk1nL4oWMgFyp7VR+Oyf48UD8RFU55dOISuRdex7VtKgtUyiP8SfEd9+C2i8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4046
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 18, 2022 at 08:58:56PM -0700, Jakub Kicinski wrote:
> ERROR: modpost: "ocelot_port_teardown_dsa_8021q_cpu" [drivers/net/dsa/oce=
lot/mscc_felix.ko] undefined!
> ERROR: modpost: "ocelot_port_teardown_dsa_8021q_cpu" [drivers/net/dsa/oce=
lot/mscc_seville.ko] undefined!

Damn, I forgot EXPORT_SYMBOL_GPL()....
Since I see you've marked the patches as changes requested already, I'll
go ahead and resubmit.=
