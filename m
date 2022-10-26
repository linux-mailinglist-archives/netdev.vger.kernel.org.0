Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0807060E075
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 14:14:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233683AbiJZMOf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 08:14:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233472AbiJZMOc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 08:14:32 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70050.outbound.protection.outlook.com [40.107.7.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41F685F68;
        Wed, 26 Oct 2022 05:14:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=md9fUixSRxbJ2gOR9p/GYeHbwr0iyINUuW+B39BJMfLiYglAphFkmqG5JFXA5RQZRw3o02/LlbZqvhWN5jVquyHqPK3n7NyQwU5kVFcHSX99+mA9ti8vjSg8LlD27NtmlUg7ICTznIP8mqmMSk1gUGzlv75Kz+G4hMT9MWlHLOmcjSxhYTSTmta1ia7kcnyleUXKtcKWc9eyiLujgMTxk8SpL2tR2oZ7HMTTt9kvUQS313VkRr0hsHb76N7W5IBLL3lsLXtM4+7ppkWUgGT6XXyYSl4114R1XkxwYA4GhbN78Hr7dAVNVu42lrOtWXPgMPmOcBrg9bbQdXcE2H0+0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OA8g5BQrR8jqkyiv2RIlCGEKGnQYB4aZQ7oHPdbQtwA=;
 b=CFBwE+pUkClUJuxI6JE3qHgHNkcq7jcU8t7Pd5pjGmqZgPWBPKqbVYHwwnLjXFzmyxLshfnrnKlMsDp/lsDGTvbP9lKdyhjHJYUC0p5SQSAC0+zXkcKqKgZ3ycgTwmDt9of8VsrFCO+D8j4OGsQldKOTVPJ/bFlB1xzhzvGLd0FudyHazwAg+JBgomQh7pLMg8SPkYGupVDjZDoCfs86TaNkkvrsCPMzsqGJBWbjZVL1MM9mNKnRNtq0GRIucFRY9h07mj57NIRdymrGcFuRNhEt7l+vUXNLqJsZX8yvfM+D40+JNhq6Msq5EoyCZmQX4PKriqOUfNE0KliQKSDd1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OA8g5BQrR8jqkyiv2RIlCGEKGnQYB4aZQ7oHPdbQtwA=;
 b=GXVJzJ+amA9bkincYl7ECtHUXsveggwiq1Ko9g0x5AWhmpA9pvfHzAvozc9VKP0FQZU3buvlP6CZ6DyvnO/y14zLITobTLXcdR6ar8cPeMgcn3WMSEJdRsf3WRQQWjv9Acpa/Ef4OxE5FXLvb6bPFy7v5YUF5DffXwea9B3bme8=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM7PR04MB7109.eurprd04.prod.outlook.com (2603:10a6:20b:117::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.21; Wed, 26 Oct
 2022 12:14:25 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::6710:c5fd:bc88:2035]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::6710:c5fd:bc88:2035%6]) with mapi id 15.20.5746.023; Wed, 26 Oct 2022
 12:14:25 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] net: enetc: zeroize buffer descriptors in
 enetc_dma_alloc_bdr()
Thread-Topic: [PATCH net] net: enetc: zeroize buffer descriptors in
 enetc_dma_alloc_bdr()
Thread-Index: AQHY58z/UOKKnjnr/UCCCxbobVhRlK4fxFEAgADVDQA=
Date:   Wed, 26 Oct 2022 12:14:25 +0000
Message-ID: <20221026121424.2r3ul2bzve5sbxns@skbuf>
References: <20221024172049.4187400-1-vladimir.oltean@nxp.com>
 <20221025233152.idxmtikicu3kmedo@skbuf>
In-Reply-To: <20221025233152.idxmtikicu3kmedo@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|AM7PR04MB7109:EE_
x-ms-office365-filtering-correlation-id: 01b71782-364e-45fd-7807-08dab74b9fd3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2Q3yf4W4CzDRXaMfoWDEbmOn/rPbw6gycfGuIZJEvOJY+efiozDQPMjUngsQlR0gbxew04t9MPAHU8+gvrIpOFukCeTiXSl9cyFP24/hwiMD3Xo0tE5fz20zMnHKSpo57t0OcSkVwXejnXnde55TpAhMXJlC9AY2lZ+nTvh/+xGBNF7l/8fi+Kl8OtG6XnoSDN5SLRTzPCt8rNpaRT73+wWXlMRYn0uGvqBgZ8rO5Yh7GUR2jzBBaIxjqTqtYXiaDwvdtk6ydrlb1OY5lEjlizWfRqajb79mAIZjgjlgNbHJctbgwx9c43rLWW/dpAT0ZXd6E5CvTMugovksOxs4TgCoQoxMJTUdm0/JM8HJjWO1FpiSAXEDyso5AeqfdessUtgcjkBVWT5XaRLA7q0UW0C0Wrpas8BiQBiylX/ncYfZLxQvgGGF23fRw1WKnTlY/fZfOk4Q17ZQdOfpG/zdA5zWrUHSVGbsfNG7oGuK0Bg3ZFKfFI1WJBFiIgc/gJgFtwpbnhyuf+8Y20K2mjX3itf1gLjCLbXUCAdJJRjnNRJWUecjCieSvWQ/3fVFLZR48g57s/tv49seoxlsqhWecjK8pnxunkxcULDM/xsAKwLWEy1w+fqosRMRtY60vFmRHhnrzXyiYJVy5BTpxmrLguoI2ArY78ClemW7sB7OzKdfp4J5cx2b+PO2+1oZEJBbCpD/sTyNwAC8nC8qP7i1AKB5ykCvVLSOvQRyiA1EYiJeUMMwLfJgRILrTNQeyX589pZF7QbD6Y656Ruio1K+EJ6l0URJUcO/7JYteez66xs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(346002)(366004)(396003)(376002)(136003)(39860400002)(451199015)(1076003)(6506007)(186003)(6512007)(26005)(4744005)(9686003)(44832011)(8936002)(5660300002)(33716001)(478600001)(54906003)(6916009)(71200400001)(66556008)(66446008)(966005)(4326008)(91956017)(41300700001)(8676002)(316002)(64756008)(66946007)(6486002)(76116006)(66476007)(86362001)(2906002)(122000001)(38100700002)(38070700005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?1CkwFdFIWHff1+nRBlIdDDqoCnu8dyGDgC6I0WMf1M7k+WM86biEJVzArkIQ?=
 =?us-ascii?Q?u+7Sa8ldDxvYS/Wuzw7f4GjWxMjQM1QlkSMfFxdLxrU9LudMbbDt/jDS6FeL?=
 =?us-ascii?Q?leNVHScSlEraRYmElTufw4jYjy/L64hSJ5m7p6jVGdQmm5FYx5f0axdInyxv?=
 =?us-ascii?Q?rqqHj/lCMo6mXn8Mz2PRcempypCWcg79kkZ/xGvIabLIg39r+1jMnhujWxhj?=
 =?us-ascii?Q?ntroe/7bI4rVHqYs+wH2vez9ucYF0SybUWamRU4ZHjop4nkaxROSSp1vimFO?=
 =?us-ascii?Q?d3WWYsUwf5bwzVHOnRxp60uzDb5UV7EE5qD/5TxhqM3LFvVlFCntSJnBQW+d?=
 =?us-ascii?Q?5vl0Oh681df+eUkyTeoPKP35+t7q0e456W8LocsYK3zXnRBcYPhgqoL0vgC7?=
 =?us-ascii?Q?vncWxOd5vBPXaXOrOGtFG5QRHHjdATudK3JFZNdKmj/ANy/CTCdiR85F89eX?=
 =?us-ascii?Q?JrZBxU2VK+BaA58+cpV1y657GdXAN4ddzZ0Y8AbJ2F52N1PgDFqeNj9Lk/ft?=
 =?us-ascii?Q?zJtCibARIBLU+48RnjqHR4264JSdgmd42ME/B3WZMcxFsO4dZ11bGyEKezLA?=
 =?us-ascii?Q?ErYEu0ZXf/NA1C5IPrPRrNUM5KR2h8j7NBeztmTfoqgn/L6JmOhvLiu8cW99?=
 =?us-ascii?Q?eCwCe1fUwXn50EtfsVcTLnynUpse4eMpcvPzZ6QN/1VwDy8+NQQ5eZDpXKIr?=
 =?us-ascii?Q?BaNGbaw1xvZe4d94JkiqWexUxtBt3Fa933sIhJE5phMiRF3kMuvG0EuhB6XJ?=
 =?us-ascii?Q?OXTk1E4RABZM7pHZPLGZ7lixJKKeLW3XcSzR/Pr7IPqJtaYgopatcZOooDkm?=
 =?us-ascii?Q?RGiYWhtWvk0teW/BuTeikEgKeTtFPX2eGsBLLwhnIEvX7A9YJWEXV80Go+UC?=
 =?us-ascii?Q?Ske3C8u9hbJXUo53RRtByoqAh9VHO+0rypxvtrVq1u+rzBBP+1I1FY+v311t?=
 =?us-ascii?Q?x0aIuyIQHUWSfVP3vpdrNe8W26JuGw5K/pH4Xvjixi7ZSLDoihKn4YJAh341?=
 =?us-ascii?Q?j3mB31LMiV0ZOr3tM2+3c5jYHKTS9hlQRE+WLH/+YW5wU7DhQJ5buoxe4SbA?=
 =?us-ascii?Q?NZDhgaqFjyJXqhysr+K05TlKheqZ0B2wj7SDrDscGFOOb02fqMBtlqU/6FDb?=
 =?us-ascii?Q?zQ4TSrTHKhdzwd9OGRWydNEHzfuwiircP3NTh2pk8/bgW+nPcWhCjzEEkh49?=
 =?us-ascii?Q?fBxreJLKZhTx/KFhj2+K27v8zT2LggUvWOt/OjeT8LQuWAPXCLIM7HFyZ7lm?=
 =?us-ascii?Q?48dUlzn2j1uvij8LuSUCWJayV97yPYlr/sDLAey8TqssEAPh/O/ez5MypO/C?=
 =?us-ascii?Q?A03v37cqy/dfR1gUB1TNU4USP12H5pInbdpYL0xtEr8Xj4vcptydILqiCdpI?=
 =?us-ascii?Q?/eHtwU094lXnim5IWNQ8LtOGUAnZwkb8bcU7X8njYQYFvmS3VUuG0YX/mP8v?=
 =?us-ascii?Q?XPScaHx+LW1uLFN+XYwtn7FYCPSzVQd9J9lKLB9OanKewg1wemyeqGSh74tJ?=
 =?us-ascii?Q?mS67ViVWY9vyb9oLHrWP4ubIC7MX0a5KZvWabRFVm2It7/ZPq+KTfpl3SncO?=
 =?us-ascii?Q?7HDxQ0z/GFL5aEn2aSaV/GAe6CW2nSmaDj+0nrAodiq5ohXDmxXzgNnJpnXg?=
 =?us-ascii?Q?Gg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <02C93D536D904E498CCF09B37C647A7E@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01b71782-364e-45fd-7807-08dab74b9fd3
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Oct 2022 12:14:25.7587
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xaYsGRqDs0OKX5rOAwB6uYJensNGOBNMH5Qw7VhWMiQciux7Ztk1kSlUoXqdZWlCxggSnAetJP/fIG+ZNcu49A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB7109
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 26, 2022 at 02:31:52AM +0300, Vladimir Oltean wrote:
> On Mon, Oct 24, 2022 at 08:20:49PM +0300, Vladimir Oltean wrote:
> > Under memory pressure, enetc_refill_rx_ring() may fail, and when called
> > during the enetc_open() -> enetc_setup_rxbdr() procedure, this is not
> > checked for.
>=20
> Please don't apply this yet, I'm still investigating a crash which has
> the symptoms described here, and I'm not sure why the patch didn't fix it=
.

Superseded by v2:
https://patchwork.kernel.org/project/netdevbpf/patch/20221026121330.2042989=
-1-vladimir.oltean@nxp.com/=
