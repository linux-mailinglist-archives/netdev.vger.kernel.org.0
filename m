Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7084F5B8056
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 06:38:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbiINEic (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 00:38:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiINEia (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 00:38:30 -0400
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2094.outbound.protection.outlook.com [40.107.114.94])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 198E3474C6;
        Tue, 13 Sep 2022 21:38:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jki2N5+dJO6gRHSoUAy53Fh6yO+v6nW47r/vGDKbpIC4Q2wk93gRTSWsnj/3FB7BJgHIzxAIIy5oepJhiRxqPXwAWecgNNWevag0VnjVS19DcwikTS2+XfkJZkj/j5Daq0NvOnpStNse2RU6lNjU85dVHGEp9HkUTW0baBZMFBePi3zfS8F0fribVjTwWQ9E4UFfC0aSbyIv+hqm59uZapuZ09dxs+h8PBQ8/LneNAIrPPcA0qeepWABLu+zphrjESznpNDQ3GlLR452ZMVv5JoAXKqrMP248B73xOja+nc7FyTxvgwq4BdqJ2yIc1Wdc34uj+ToD2DAD2CwKW1wcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zh7A/ScBAp3RzE+cb/5odXg8mvrfywdDaJbdKMmE7f0=;
 b=BNZmJsbsfoRZiAVroF+AqwBOIturEmkvr9qEGCt4nVWls9QSQ7S3Bzmawl4jNpCFoVc3b6L+mW8yfAtApNzPGfevFebf6Ws4ecsZGWvTHmkXTtiIF2gK9w4n2DlH9AHKN88RwiefLf5wuj5vkv+rZ7qZ2rohA2zP9IPWeliDCPLl3emyfTXS0dZ7kjjmJwwrE7cLD6jm1W/wOwzjP6uPqq073qTQyt7wMsGTp7WhVWQMRy0iaP8yRhc6StCzw1EvWt6PCH+rNbmZltn7EI54HHU2huvlp4AehfJqiAS3zntNQSlbrtPSp6/XWVtD6hnhq0rC0Hg4qyeGZLxS2N9N1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zh7A/ScBAp3RzE+cb/5odXg8mvrfywdDaJbdKMmE7f0=;
 b=ltPFvTVhGpYJvzC42080gGECHQbZLSc0PeuCXVK32u18n4lhGn3eaPdXY6gJm/sqr5vYT/Hkvocrmu34wsJeGPQQpceIG16KNRXbQ/69GmGCebTNdBceesXdKW9dGxGXaLrtU/hrWoM/BCyHcydTzpQfrzQRwX8qRm3EbNpDGsI=
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 (2603:1096:404:8028::13) by OS0PR01MB6068.jpnprd01.prod.outlook.com
 (2603:1096:604:ce::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.12; Wed, 14 Sep
 2022 04:38:23 +0000
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::194:78eb:38cf:d6db]) by TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::194:78eb:38cf:d6db%4]) with mapi id 15.20.5612.022; Wed, 14 Sep 2022
 04:38:23 +0000
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "geert+renesas@glider.be" <geert+renesas@glider.be>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH 3/5] net: ethernet: renesas: Add Ethernet Switch driver
Thread-Topic: [PATCH 3/5] net: ethernet: renesas: Add Ethernet Switch driver
Thread-Index: AQHYxE/FihGBdu/LPk6xtXUSKRtI763cchEAgAHJTvA=
Date:   Wed, 14 Sep 2022 04:38:23 +0000
Message-ID: <TYBPR01MB5341F0C51EB2EBEF5A7107E7D8469@TYBPR01MB5341.jpnprd01.prod.outlook.com>
References: <20220909132614.1967276-1-yoshihiro.shimoda.uh@renesas.com>
 <20220909132614.1967276-4-yoshihiro.shimoda.uh@renesas.com>
 <Yx+9OrYDxKjVUutF@lunn.ch>
In-Reply-To: <Yx+9OrYDxKjVUutF@lunn.ch>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYBPR01MB5341:EE_|OS0PR01MB6068:EE_
x-ms-office365-filtering-correlation-id: 40bd4298-d12d-4835-f3d7-08da960af536
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ePOTyebhAeHG01x7xqz0FQyCchjFg4G/SRAbrIAkN/MLgrSjaHZ+WD8Ro6iFR+lFqDQiSnu8j2s9F49frt5ys/9L2PyzFa24ZjtLyWxwwduWnulI35xU7NeGwKzCfno4b7HXwD9N7ZWI/ol+QGzTHReqsalj61gSxjBJB57EouR57u4nvHQZMGSOUxa1q3RgJ7EGoowU5lIrZ6ygNc5hkfq/PEdw4wKFsH26mkiPTA0FtiGy8ctizvqwibfd4JaOIce832U05ZwRFy2ak2kfpAGNTmh+FO1fY4DgLrozL6X1lwCAGN2q3R0CwMogy0rFqf/U98Exc0Ehjcfx9TrO2ZKOP+QPNk7zDOlBwQPqCofR6V9OX99t9WjXR/LoHcJT8DhWOiK/dyn6EMbxE7FoqghuywYtqMdyPweYE/bXtu6Gg9KbU0fgDTpesIlihqBz3ALFx/4FPWIsNJ7gioe7Qx/Kln+tR9896eKRuCA3UwNS++g9gzPhpB//AniZofueMskRzfoZ3NoRzhd2ZEWkw0lGC4QpYWy812PERH0w/e7Z6xEaRGwqN+41xPDSGgEB9m7HUqR2kYIP1e9QqSiINEustKTZG0WrdjB05lwcHbFh5kVaEeSM+/HUbfHlIBQxto+j54XQaFNwvMn9iLLH6TGCODowSlZV1MDF7+30Sr8AXHDPBfCplIUYg7tLOpze/87kdod5l+6fwc8AVZCj6dn7SeK8w5YTE0PAGdQCcVzvLKTMVREbYqm9CYESw/CBjKLzlElmmeEjqKz6M/dFVQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYBPR01MB5341.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(136003)(376002)(39860400002)(396003)(346002)(451199015)(186003)(71200400001)(9686003)(86362001)(8676002)(7416002)(6506007)(66446008)(8936002)(7696005)(38070700005)(122000001)(76116006)(66556008)(33656002)(41300700001)(316002)(54906003)(478600001)(5660300002)(52536014)(66476007)(83380400001)(38100700002)(2906002)(30864003)(64756008)(6916009)(4326008)(55016003)(66946007)(579004)(559001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?0x/+StI0I2XRVUOHuqaykBy8WDVCNB796nOM4lYoT/BU5yMHi7kwv6gDmccx?=
 =?us-ascii?Q?B+9Z8PSf/O3wZPZtXYqJfRszwPCi0eZY+J57tskVJFcyPfQlGS1B6+Ac+v2f?=
 =?us-ascii?Q?5jOm5WHSlnmwEGLjeEdxYWv5l+bAt2ByndTa7031wAx0cp1h0ywq3OQFur4f?=
 =?us-ascii?Q?2/FxJ0XbYP+zwakJ2mrBxIaLc76P6a+SLqQWkOfXDbnAhTdKDTn/ebocYMb5?=
 =?us-ascii?Q?43nyEHuKRN4N5fkWhqqwzCr9pSbOioG830qnIdKDemJLUbg+c4ncQ1D0tOfx?=
 =?us-ascii?Q?uLhU1LkojfMQUnvFHFF4JCBp6eBKfccVQESNgzzQ+Y4LpImeoPx1L8eqSpPM?=
 =?us-ascii?Q?Cen8Ru0P44BpTBkmq5e0wfgC3VJqt0AvMkiE8XasTzJuayHz87IHKVtTgnVs?=
 =?us-ascii?Q?J3DWRlb3f4NmoMVgyezYLB20h0CYY00dre/ytfd7mzNtTOIGHZPXwtzGfXwj?=
 =?us-ascii?Q?SRZWoZjbgauy9W/x4MW8xb9uIlxX9OQLtOMY5b4Jx5eY8et644hvHRaHQbMq?=
 =?us-ascii?Q?vsYoOkVfecBoa/rOl5mGKPQ6QEgwXNNe1FhL+C8ya3VYHWZNpvrvS2MO7tYo?=
 =?us-ascii?Q?gXdXs2GRe+62MCthU9m2xJNjr8BT3cKUxjITZQocYzbthqUfG7UVpzfGj0Yx?=
 =?us-ascii?Q?w1vScfOFxRDX4BvYuZfiTT9bpKTMDVKVIM/7vzSTC+3KnEAyU/nSNiSUz+I6?=
 =?us-ascii?Q?OQtFtk55WSkhcv8wmRSFLKN5y0+hQVAeihoFZzCyqOXIAoBH0pMbmjIys+vl?=
 =?us-ascii?Q?pVML6HXhwR6gI4PlUKsa4iL7dToEw65KR/c+ObfR1JupjZqctmJHW+driAka?=
 =?us-ascii?Q?HG3+3mPmNyoSPiIX7IgfbEb5v8mgjNxhPmbPbQi6i43BbCqsD0DriKr+qNQC?=
 =?us-ascii?Q?+rbazcUu2s3yQY7NAlJXVIhpPAVLp5Z5gABeC/ywpQuGBkmg4P2F0P7rkjnE?=
 =?us-ascii?Q?6ejAJQe44Za8OrijYJGg7rt5iwsf56ohLzKp+w322JZ/sln9qm5q2pRlk4hM?=
 =?us-ascii?Q?j9U640WSNdgEFjhFtrPiMEcLyNeqRWWqBJQTCyLfx5ze4dgzCE2Q2c2DmoAX?=
 =?us-ascii?Q?gOFeI5KLMFVgdHJxzT7v1bdnTiM/GPyjJ66wjoJi6jeUzFUhedgGcspOE1xP?=
 =?us-ascii?Q?FWN+QWzEnbsd1f1WCtXC3IRfFizXIyHo4lyQS4FAElr6MeU9xZxfxAGF7uuj?=
 =?us-ascii?Q?FenkMnU9qr6wWd4a/aiDBv0hR6jsJIVcpozvqnL+K25TQR/O8UphOFeCwDe3?=
 =?us-ascii?Q?z13C3DnyyHXgt2zGR5pAHyBK8ja7QafS9fyP2oFxIbWlaGJcHLYllze/xQLv?=
 =?us-ascii?Q?ZxAYntZRBMJTiJQJU/9GZG/WvWcWw6gP7VvSc6A1XNBPrQPWbe6Y4wS54+rm?=
 =?us-ascii?Q?4kJooeFkisxah1Eh5TESMJ2dq6s5b14qqHcbEhTo9h3SQaNw8wJFm5KVswvc?=
 =?us-ascii?Q?tuhkJuVr9BksfE5V4fjnJsviKhhOV/GgDY69X+155OetNNHTjG7yVRw1BiKX?=
 =?us-ascii?Q?DwB4u0mbQv+nEiZSNltWLnqpb90m/9NRb6fACwTMSXH5NG2Gyqr2yvnKjV9L?=
 =?us-ascii?Q?bIG9C7YAF4RYF5sJiknNTj/CAaKbcYKk6CSF6+rpagphxbxMlibzs102xINK?=
 =?us-ascii?Q?dBrwRWbC1zE2kwBqlmCmIUbWbGj3Yc+14cxmCdLYU1WERhqyQdclKHr9wRqk?=
 =?us-ascii?Q?de0sBA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYBPR01MB5341.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40bd4298-d12d-4835-f3d7-08da960af536
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Sep 2022 04:38:23.4048
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FKcIiG9VIDzx9rFWJzUDfiOrn5ti1ctTStfuPt04T7LUS4vZanbE20Lw40TjFleFGBuS/4puVXrULTyuTxXAfcBZJui/9xKMmO9IAhqjtYHZmj1Gis95Kk0IIeH8pTui
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS0PR01MB6068
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

Thank you for your review!

> From: Andrew Lunn, Sent: Tuesday, September 13, 2022 8:14 AM
>=20
> > +static int default_rate =3D 1000;
> > +module_param(default_rate, int, 0644);
> > +MODULE_PARM_DESC(default_rate, "Default rate for both ETHA and GWCA");
> > +
> > +static int num_etha_ports =3D 1;
> > +module_param(num_etha_ports, int, 0644);
> > +MODULE_PARM_DESC(num_etha_ports, "Number of using ETHA ports");
> > +
> > +static int num_ndev =3D 1;
> > +module_param(num_ndev, int, 0644);
> > +MODULE_PARM_DESC(num_ndev, "Number of creating network devices");
>=20
> No module parameters please. Find a different API for this.

I got it. I'll find a different API somehow.

> > +static int rswitch_reg_wait(void __iomem *addr, u32 offs, u32 mask, u3=
2 expected)
> > +{
> > +	int i;
> > +
> > +	for (i =3D 0; i < RSWITCH_TIMEOUT_US; i++) {
> > +		if ((ioread32(addr + offs) & mask) =3D=3D expected)
> > +			return 0;
> > +
> > +		udelay(1);
> > +	}
> > +
> > +	return -ETIMEDOUT;
>=20
> iopoll.h

I'll use iopoll.h API.

> > +/* TOP */
>=20
> Could you expand that acronym, for those of us how have no idea what
> it means?

Sorry for lacking information. This is an abbreviation name of the block.
Complete name of that is "R-Switch-2". So, I'll modify this comment as the =
following:

/* R-Swtich-2 block (TOP) */

> > +static void rswitch_top_init(struct rswitch_private *priv)
> > +{
> > +	int i;
> > +
> > +	for (i =3D 0; i < RSWITCH_MAX_NUM_CHAINS; i++)
> > +		iowrite32((i / 16) << (GWCA_INDEX * 8), priv->addr + TPEMIMC7(i));
> > +}
> > +
> > +/* MFWD */
>=20
> Multicast Forward?

/* Forwarding engine block (MFWD) */

# The manual doesn't mention why 'M' though....

> > +static void rswitch_fwd_init(struct rswitch_private *priv)
> > +{
> > +	int i;
> > +
> > +	for (i =3D 0; i < RSWITCH_NUM_HW; i++) {
> > +		iowrite32(FWPC0_DEFAULT, priv->addr + FWPC0(i));
> > +		iowrite32(0, priv->addr + FWPBFC(i));
> > +	}
> > +
> > +	for (i =3D 0; i < num_etha_ports; i++) {
> > +		iowrite32(priv->rdev[i]->rx_chain->index,
> > +			  priv->addr + FWPBFCSDC(GWCA_INDEX, i));
> > +		iowrite32(BIT(priv->gwca.index), priv->addr + FWPBFC(i));
> > +	}
> > +	iowrite32(GENMASK(num_etha_ports - 1, 0), priv->addr + FWPBFC(3));
> > +}
> > +
> > +/* gPTP */
> > +static void rswitch_get_timestamp(struct rswitch_private *priv,
> > +				  struct timespec64 *ts)
> > +{
> > +	struct rcar_gen4_ptp_private *ptp_priv =3D priv->ptp_priv;
> > +
> > +	ptp_priv->info.gettime64(&ptp_priv->info, ts);
> > +}
> > +
> > +/* GWCA */
> > +static int rswitch_gwca_change_mode(struct rswitch_private *priv,
> > +				    enum rswitch_gwca_mode mode)
> > +{
> > +	int ret;
> > +
> > +	if (!rswitch_agent_clock_is_enabled(priv->addr, priv->gwca.index))
> > +		rswitch_agent_clock_ctrl(priv->addr, priv->gwca.index, 1);
> > +
> > +	iowrite32(mode, priv->addr + GWMC);
> > +
> > +	ret =3D rswitch_reg_wait(priv->addr, GWMS, GWMS_OPS_MASK, mode);
> > +
> > +	if (mode =3D=3D GWMC_OPC_DISABLE)
> > +		rswitch_agent_clock_ctrl(priv->addr, priv->gwca.index, 0);
> > +
> > +	return ret;
> > +}
> > +
> > +static int rswitch_gwca_mcast_table_reset(struct rswitch_private *priv=
)
> > +{
> > +	iowrite32(GWMTIRM_MTIOG, priv->addr + GWMTIRM);
> > +
> > +	return rswitch_reg_wait(priv->addr, GWMTIRM, GWMTIRM_MTR, GWMTIRM_MTR=
);
> > +}
> > +
> > +static int rswitch_gwca_axi_ram_reset(struct rswitch_private *priv)
> > +{
> > +	iowrite32(GWARIRM_ARIOG, priv->addr + GWARIRM);
> > +
> > +	return rswitch_reg_wait(priv->addr, GWARIRM, GWARIRM_ARR, GWARIRM_ARR=
);
> > +}
> > +
> > +static void rswitch_gwca_set_rate_limit(struct rswitch_private *priv, =
int rate)
> > +{
> > +	u32 gwgrlulc, gwgrlc;
> > +
> > +	switch (rate) {
> > +	case 1000:
> > +		gwgrlulc =3D 0x0000005f;
> > +		gwgrlc =3D 0x00010260;
> > +		break;
> > +	default:
> > +		dev_err(&priv->pdev->dev, "%s: This rate is not supported (%d)\n", _=
_func__, rate);
> > +		break;
> > +	}
> > +
> > +	iowrite32(gwgrlulc, priv->addr + GWGRLULC);
> > +	iowrite32(gwgrlc, priv->addr + GWGRLC);
>=20
> So on error, you write random values to the hardware? At least change
> the break to a return.

Oops. I should use return instead. I'll fix it.

> > +}
> > +
> > +static bool rswitch_is_any_data_irq(struct rswitch_private *priv, u32 =
*dis, bool tx)
> > +{
> > +	int i;
> > +	u32 *mask =3D tx ? priv->gwca.tx_irq_bits : priv->gwca.rx_irq_bits;
> > +
> > +	for (i =3D 0; i < RSWITCH_NUM_IRQ_REGS; i++) {
> > +		if (dis[i] & mask[i])
> > +			return true;
> > +	}
> > +
> > +	return false;
> > +}
> > +
> > +static void rswitch_get_data_irq_status(struct rswitch_private *priv, =
u32 *dis)
> > +{
> > +	int i;
> > +
> > +	for (i =3D 0; i < RSWITCH_NUM_IRQ_REGS; i++) {
> > +		dis[i] =3D ioread32(priv->addr + GWDIS(i));
> > +		dis[i] &=3D ioread32(priv->addr + GWDIE(i));
> > +	}
> > +}
> > +
> > +static void rswitch_enadis_data_irq(struct rswitch_private *priv, int =
index, bool enable)
> > +{
> > +	u32 offs =3D enable ? GWDIE(index / 32) : GWDID(index / 32);
> > +
> > +	iowrite32(BIT(index % 32), priv->addr + offs);
> > +}
> > +
> > +static void rswitch_ack_data_irq(struct rswitch_private *priv, int ind=
ex)
> > +{
> > +	u32 offs =3D GWDIS(index / 32);
> > +
> > +	iowrite32(BIT(index % 32), priv->addr + offs);
> > +}
> > +
> > +static bool rswitch_is_chain_rxed(struct rswitch_gwca_chain *c)
> > +{
> > +	int entry;
> > +	struct rswitch_ext_ts_desc *desc;
> > +
> > +	entry =3D c->dirty % c->num_ring;
> > +	desc =3D &c->ts_ring[entry];
> > +
> > +	if ((desc->die_dt & DT_MASK) !=3D DT_FEMPTY)
> > +		return true;
> > +
> > +	return false;
> > +}
> > +
> > +static bool rswitch_rx(struct net_device *ndev, int *quota)
> > +{
> > +	struct rswitch_device *rdev =3D netdev_priv(ndev);
> > +	struct rswitch_gwca_chain *c =3D rdev->rx_chain;
> > +	int boguscnt =3D c->dirty + c->num_ring - c->cur;
> > +	int entry =3D c->cur % c->num_ring;
> > +	struct rswitch_ext_ts_desc *desc =3D &c->ts_ring[entry];
> > +	int limit;
> > +	u16 pkt_len;
> > +	struct sk_buff *skb;
> > +	dma_addr_t dma_addr;
> > +	u32 get_ts;
>=20
> Reverse Christmas tree. Please go through all the code.

I got it. I'll fix all the code.

> > +
> > +	boguscnt =3D min(boguscnt, *quota);
> > +	limit =3D boguscnt;
> > +
> > +	while ((desc->die_dt & DT_MASK) !=3D DT_FEMPTY) {
> > +		dma_rmb();
> > +		pkt_len =3D le16_to_cpu(desc->info_ds) & RX_DS;
> > +		if (--boguscnt < 0)
> > +			break;
> > +		skb =3D c->skb[entry];
> > +		c->skb[entry] =3D NULL;
> > +		dma_addr =3D le32_to_cpu(desc->dptrl) | ((__le64)le32_to_cpu(desc->d=
ptrh) << 32);
> > +		dma_unmap_single(ndev->dev.parent, dma_addr, PKT_BUF_SZ, DMA_FROM_DE=
VICE);
> > +		get_ts =3D rdev->priv->ptp_priv->tstamp_rx_ctrl & RCAR_GEN4_RXTSTAMP=
_TYPE_V2_L2_EVENT;
> > +		if (get_ts) {
> > +			struct skb_shared_hwtstamps *shhwtstamps;
> > +			struct timespec64 ts;
> > +
> > +			shhwtstamps =3D skb_hwtstamps(skb);
> > +			memset(shhwtstamps, 0, sizeof(*shhwtstamps));
> > +			ts.tv_sec =3D (u64)le32_to_cpu(desc->ts_sec);
> > +			ts.tv_nsec =3D le32_to_cpu(desc->ts_nsec & 0x3FFFFFFF);
> > +			shhwtstamps->hwtstamp =3D timespec64_to_ktime(ts);
> > +		}
> > +		skb_put(skb, pkt_len);
> > +		skb->protocol =3D eth_type_trans(skb, ndev);
> > +		netif_receive_skb(skb);
> > +		rdev->ndev->stats.rx_packets++;
> > +		rdev->ndev->stats.rx_bytes +=3D pkt_len;
> > +
> > +		entry =3D (++c->cur) % c->num_ring;
> > +		desc =3D &c->ts_ring[entry];
> > +	}
> > +
> > +	/* Refill the RX ring buffers */
> > +	for (; c->cur - c->dirty > 0; c->dirty++) {
> > +		entry =3D c->dirty % c->num_ring;
> > +		desc =3D &c->ts_ring[entry];
> > +		desc->info_ds =3D cpu_to_le16(PKT_BUF_SZ);
> > +
> > +		if (!c->skb[entry]) {
> > +			skb =3D dev_alloc_skb(PKT_BUF_SZ + RSWITCH_ALIGN - 1);
> > +			if (!skb)
> > +				break;	/* Better luck next round */
> > +			skb_reserve(skb, NET_IP_ALIGN);
> > +			dma_addr =3D dma_map_single(ndev->dev.parent, skb->data,
> > +						  le16_to_cpu(desc->info_ds),
> > +						  DMA_FROM_DEVICE);
> > +			if (dma_mapping_error(ndev->dev.parent, dma_addr))
> > +				desc->info_ds =3D cpu_to_le16(0);
> > +			desc->dptrl =3D cpu_to_le32(lower_32_bits(dma_addr));
> > +			desc->dptrh =3D cpu_to_le32(upper_32_bits(dma_addr));
>=20
> If there has been a dma mapping error, is dma_addr valid?

No, the dma_addr is not valid. So, I'll fix error handling around this.

> > +			skb_checksum_none_assert(skb);
> > +			c->skb[entry] =3D skb;
> > +		}
> > +		dma_wmb();
> > +		desc->die_dt =3D DT_FEMPTY | DIE;
> > +	}
> > +
> > +	*quota -=3D limit - (++boguscnt);
> > +
> > +	return boguscnt <=3D 0;
> > +}
> > +
> > +static int rswitch_tx_free(struct net_device *ndev, bool free_txed_onl=
y)
> > +{
> > +	struct rswitch_device *rdev =3D netdev_priv(ndev);
> > +	struct rswitch_ext_desc *desc;
> > +	int free_num =3D 0;
> > +	int entry, size;
> > +	dma_addr_t dma_addr;
> > +	struct rswitch_gwca_chain *c =3D rdev->tx_chain;
> > +	struct sk_buff *skb;
> > +
> > +	for (; c->cur - c->dirty > 0; c->dirty++) {
> > +		entry =3D c->dirty % c->num_ring;
> > +		desc =3D &c->ring[entry];
> > +		if (free_txed_only && (desc->die_dt & DT_MASK) !=3D DT_FEMPTY)
> > +			break;
> > +
> > +		dma_rmb();
> > +		size =3D le16_to_cpu(desc->info_ds) & TX_DS;
> > +		skb =3D c->skb[entry];
> > +		if (skb) {
> > +			if (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) {
> > +				struct skb_shared_hwtstamps shhwtstamps;
> > +				struct timespec64 ts;
> > +
> > +				rswitch_get_timestamp(rdev->priv, &ts);
> > +				memset(&shhwtstamps, 0, sizeof(shhwtstamps));
> > +				shhwtstamps.hwtstamp =3D timespec64_to_ktime(ts);
> > +				skb_tstamp_tx(skb, &shhwtstamps);
> > +			}
> > +			dma_addr =3D le32_to_cpu(desc->dptrl) |
> > +				   ((__le64)le32_to_cpu(desc->dptrh) << 32);
> > +			dma_unmap_single(ndev->dev.parent, dma_addr,
> > +					 size, DMA_TO_DEVICE);
> > +			dev_kfree_skb_any(c->skb[entry]);
> > +			c->skb[entry] =3D NULL;
> > +			free_num++;
> > +		}
> > +		desc->die_dt =3D DT_EEMPTY;
> > +		rdev->ndev->stats.tx_packets++;
> > +		rdev->ndev->stats.tx_bytes +=3D size;
> > +	}
> > +
> > +	return free_num;
> > +}
> > +
> > +static int rswitch_poll(struct napi_struct *napi, int budget)
> > +{
> > +	struct net_device *ndev =3D napi->dev;
> > +	struct rswitch_device *rdev =3D netdev_priv(ndev);
> > +	struct rswitch_private *priv =3D rdev->priv;
> > +	int quota =3D budget;
> > +
> > +retry:
> > +	rswitch_tx_free(ndev, true);
> > +
> > +	if (rswitch_rx(ndev, &quota))
> > +		goto out;
> > +	else if (rswitch_is_chain_rxed(rdev->rx_chain))
> > +		goto retry;
> > +
> > +	netif_wake_subqueue(ndev, 0);
> > +
> > +	napi_complete(napi);
> > +
> > +	rswitch_enadis_data_irq(priv, rdev->tx_chain->index, true);
> > +	rswitch_enadis_data_irq(priv, rdev->rx_chain->index, true);
> > +
> > +out:
> > +	return budget - quota;
> > +}
> > +
> > +static void rswitch_queue_interrupt(struct net_device *ndev)
> > +{
> > +	struct rswitch_device *rdev =3D netdev_priv(ndev);
> > +
> > +	if (napi_schedule_prep(&rdev->napi)) {
> > +		rswitch_enadis_data_irq(rdev->priv, rdev->tx_chain->index, false);
> > +		rswitch_enadis_data_irq(rdev->priv, rdev->rx_chain->index, false);
> > +		__napi_schedule(&rdev->napi);
> > +	}
> > +}
> > +
> > +static irqreturn_t rswitch_data_irq(struct rswitch_private *priv, u32 =
*dis)
> > +{
> > +	struct rswitch_gwca_chain *c;
> > +	int i;
> > +	int index, bit;
> > +
> > +	for (i =3D 0; i < priv->gwca.num_chains; i++) {
> > +		c =3D &priv->gwca.chains[i];
> > +		index =3D c->index / 32;
> > +		bit =3D BIT(c->index % 32);
> > +		if (!(dis[index] & bit))
> > +			continue;
> > +
> > +		rswitch_ack_data_irq(priv, c->index);
> > +		rswitch_queue_interrupt(c->ndev);
> > +	}
> > +
> > +	return IRQ_HANDLED;
> > +}
> > +
> > +static irqreturn_t rswitch_gwca_irq(int irq, void *dev_id)
> > +{
> > +	struct rswitch_private *priv =3D dev_id;
> > +	irqreturn_t ret =3D IRQ_NONE;
> > +	u32 dis[RSWITCH_NUM_IRQ_REGS];
> > +
> > +	rswitch_get_data_irq_status(priv, dis);
> > +
> > +	if (rswitch_is_any_data_irq(priv, dis, true) ||
> > +	    rswitch_is_any_data_irq(priv, dis, false))
> > +		ret =3D rswitch_data_irq(priv, dis);
> > +
> > +	return ret;
> > +}
> > +
> > +static int rswitch_gwca_request_irqs(struct rswitch_private *priv)
> > +{
> > +	int i, ret;
> > +	char *resource_name, *irq_name;
> > +	struct rswitch_gwca *gwca =3D &priv->gwca;
> > +
> > +	for (i =3D 0; i < GWCA_NUM_IRQS; i++) {
> > +		resource_name =3D kasprintf(GFP_KERNEL, GWCA_IRQ_RESOURCE_NAME, i);
> > +		if (!resource_name) {
> > +			ret =3D -ENOMEM;
> > +			goto err;
> > +		}
> > +
> > +		gwca->irq[i] =3D platform_get_irq_byname(priv->pdev, resource_name);
> > +		kfree(resource_name);
> > +		if (gwca->irq[i] < 0) {
> > +			ret =3D gwca->irq[i];
> > +			goto err;
> > +		}
> > +
> > +		irq_name =3D devm_kasprintf(&priv->pdev->dev, GFP_KERNEL,
> > +					  GWCA_IRQ_NAME, i);
> > +		if (!irq_name) {
> > +			ret =3D -ENOMEM;
> > +			goto err;
> > +		}
> > +
> > +		ret =3D request_irq(gwca->irq[i], rswitch_gwca_irq, 0, irq_name, pri=
v);
>=20
> devm_request_irq() ?

Yes, I'll fix it.

> > +static int rswitch_etha_set_access(struct rswitch_etha *etha, bool rea=
d,
> > +				   int phyad, int devad, int regad, int data)
> > +{
> > +	int pop =3D read ? MDIO_READ_C45 : MDIO_WRITE_C45;
> > +	u32 val;
> > +	int ret;
> > +
> > +	/* No match device */
> > +	if (devad =3D=3D 0xffffffff)
> > +		return 0;
> > +
> > +	writel(MMIS1_CLEAR_FLAGS, etha->addr + MMIS1);
> > +
> > +	val =3D MPSM_PSME | MPSM_MFF_C45;
> > +	iowrite32((regad << 16) | (devad << 8) | (phyad << 3) | val, etha->ad=
dr + MPSM);
> > +
> > +	ret =3D rswitch_reg_wait(etha->addr, MMIS1, MMIS1_PAACS, MMIS1_PAACS)=
;
> > +	if (ret)
> > +		return ret;
> > +
> > +	rswitch_modify(etha->addr, MMIS1, MMIS1_PAACS, MMIS1_PAACS);
> > +
> > +	if (read) {
> > +		writel((pop << 13) | (devad << 8) | (phyad << 3) | val, etha->addr +=
 MPSM);
> > +
> > +		ret =3D rswitch_reg_wait(etha->addr, MMIS1, MMIS1_PRACS, MMIS1_PRACS=
);
> > +		if (ret)
> > +			return ret;
> > +
> > +		ret =3D (ioread32(etha->addr + MPSM) & MPSM_PRD_MASK) >> 16;
> > +
> > +		rswitch_modify(etha->addr, MMIS1, MMIS1_PRACS, MMIS1_PRACS);
> > +	} else {
> > +		iowrite32((data << 16) | (pop << 13) | (devad << 8) | (phyad << 3) |=
 val,
> > +			  etha->addr + MPSM);
> > +
> > +		ret =3D rswitch_reg_wait(etha->addr, MMIS1, MMIS1_PWACS, MMIS1_PWACS=
);
> > +	}
> > +
> > +	return ret;
> > +}
> > +
> > +static int rswitch_etha_mii_read(struct mii_bus *bus, int addr, int re=
gnum)
> > +{
> > +	struct rswitch_etha *etha =3D bus->priv;
> > +	int mode, devad, regad;
> > +
> > +	mode =3D regnum & MII_ADDR_C45;
> > +	devad =3D (regnum >> MII_DEVADDR_C45_SHIFT) & 0x1f;
> > +	regad =3D regnum & MII_REGADDR_C45_MASK;
> > +
> > +	/* Not support Clause 22 access method */
> > +	if (!mode)
> > +		return 0;
>=20
> -EOPNOTSUPP.

I'll fix it.

> > +
> > +	return rswitch_etha_set_access(etha, true, addr, devad, regad, 0);
> > +}
> > +
> > +static int rswitch_etha_mii_write(struct mii_bus *bus, int addr, int r=
egnum, u16 val)
> > +{
> > +	struct rswitch_etha *etha =3D bus->priv;
> > +	int mode, devad, regad;
> > +
> > +	mode =3D regnum & MII_ADDR_C45;
> > +	devad =3D (regnum >> MII_DEVADDR_C45_SHIFT) & 0x1f;
> > +	regad =3D regnum & MII_REGADDR_C45_MASK;
> > +
> > +	/* Not support Clause 22 access method */
> > +	if (!mode)
> > +		return 0;
>=20
> Same here.

I'll fix it.

> > +
> > +	return rswitch_etha_set_access(etha, false, addr, devad, regad, val);
> > +}
> > +
> > +/* Call of_node_put(port) after done */
> > +static struct device_node *rswitch_get_port_node(struct rswitch_device=
 *rdev)
> > +{
> > +	struct device_node *ports, *port;
> > +	int err =3D 0;
> > +	u32 index;
> > +
> > +	ports =3D of_get_child_by_name(rdev->ndev->dev.parent->of_node, "port=
s");
> > +	if (!ports)
> > +		return NULL;
> > +
> > +	for_each_child_of_node(ports, port) {
> > +		err =3D of_property_read_u32(port, "reg", &index);
> > +		if (err < 0) {
> > +			port =3D NULL;
> > +			goto out;
> > +		}
> > +		if (index =3D=3D rdev->etha->index)
> > +			break;
> > +	}
> > +
> > +out:
> > +	of_node_put(ports);
> > +
> > +	return port;
> > +}
> > +
> > +/* Call of_node_put(phy) after done */
> > +static struct device_node *rswitch_get_phy_node(struct rswitch_device =
*rdev)
> > +{
> > +	struct device_node *port, *phy =3D NULL;
> > +	int err =3D 0;
> > +
> > +	port =3D rswitch_get_port_node(rdev);
> > +	if (!port)
> > +		return NULL;
> > +
> > +	err =3D of_get_phy_mode(port, &rdev->etha->phy_interface);
> > +	if (err < 0)
> > +		goto out;
> > +
> > +	phy =3D of_parse_phandle(port, "phy-handle", 0);
> > +
> > +out:
> > +	of_node_put(port);
> > +
> > +	return phy;
> > +}
> > +
> > +static int rswitch_mii_register(struct rswitch_device *rdev)
> > +{
> > +	struct mii_bus *mii_bus;
> > +	struct device_node *port;
> > +	int err;
> > +
> > +	mii_bus =3D mdiobus_alloc();
> > +	if (!mii_bus)
> > +		return -ENOMEM;
> > +
> > +	mii_bus->name =3D "rswitch_mii";
> > +	sprintf(mii_bus->id, "etha%d", rdev->etha->index);
> > +	mii_bus->priv =3D rdev->etha;
> > +	mii_bus->read =3D rswitch_etha_mii_read;
> > +	mii_bus->write =3D rswitch_etha_mii_write;
> > +	mii_bus->parent =3D &rdev->ndev->dev;
> > +
> > +	port =3D rswitch_get_port_node(rdev);
> > +	err =3D of_mdiobus_register(mii_bus, port);
> > +	if (err < 0) {
> > +		mdiobus_free(mii_bus);
> > +		goto out;
> > +	}
> > +
> > +	rdev->etha->mii =3D mii_bus;
> > +
> > +out:
> > +	of_node_put(port);
> > +
> > +	return err;
> > +}
> > +
> > +static void rswitch_mii_unregister(struct rswitch_device *rdev)
> > +{
> > +	if (rdev->etha && rdev->etha->mii) {
> > +		mdiobus_unregister(rdev->etha->mii);
> > +		mdiobus_free(rdev->etha->mii);
> > +		rdev->etha->mii =3D NULL;
> > +	}
> > +}
> > +
> > +static void rswitch_adjust_link(struct net_device *ndev)
> > +{
> > +	struct rswitch_device *rdev =3D netdev_priv(ndev);
> > +	struct phy_device *phydev =3D ndev->phydev;
> > +
> > +	if (phydev->link !=3D rdev->etha->link) {
> > +		phy_print_status(phydev);
> > +		rdev->etha->link =3D phydev->link;
> > +	}
>=20
> Given that the SERDES supports 100 and 1G, it seems odd you don't need
> to do anything here.

Indeed. However, unfortunately, the current hardware cannot change the spee=
d at runtime...
So, I'll add such comments here.

> > +}
> > +
> > +static int rswitch_phy_init(struct rswitch_device *rdev, struct device=
_node *phy)
> > +{
> > +	struct phy_device *phydev;
> > +	int err =3D 0;
> > +
> > +	phydev =3D of_phy_connect(rdev->ndev, phy, rswitch_adjust_link, 0,
> > +				rdev->etha->phy_interface);
> > +	if (!phydev) {
> > +		err =3D -ENOENT;
> > +		goto out;
> > +	}
> > +
> > +	phy_attached_info(phydev);
> > +
> > +out:
> > +	return err;
> > +}
> > +
> > +static void rswitch_phy_deinit(struct rswitch_device *rdev)
> > +{
> > +	if (rdev->ndev->phydev) {
> > +		phy_disconnect(rdev->ndev->phydev);
> > +		rdev->ndev->phydev =3D NULL;
> > +	}
> > +}
> > +
> > +static int rswitch_open(struct net_device *ndev)
> > +{
> > +	struct rswitch_device *rdev =3D netdev_priv(ndev);
> > +	struct device_node *phy;
> > +	int err =3D 0;
> > +
> > +	if (rdev->etha) {
> > +		if (!rdev->etha->operated) {
> > +			phy =3D rswitch_get_phy_node(rdev);
> > +			if (!phy)
> > +				return -EINVAL;
> > +			err =3D rswitch_etha_hw_init(rdev->etha, ndev->dev_addr);
> > +			if (err < 0)
> > +				goto err_hw_init;
> > +			err =3D rswitch_mii_register(rdev);
> > +			if (err < 0)
> > +				goto err_mii_register;
>=20
> Each port has its own MDIO bus? Not one bus shared by all ports? That
> is unusual.

Each port has its own MDIO bus.

> > +			err =3D rswitch_phy_init(rdev, phy);
> > +			if (err < 0)
> > +				goto err_phy_init;
> > +		}
> > +
> > +		phy_start(ndev->phydev);
> > +
> > +		if (!rdev->etha->operated) {
> > +			err =3D rswitch_serdes_init(rdev->etha->serdes_addr,
> > +						  rdev->etha->serdes_addr0,
> > +						  rdev->etha->phy_interface,
> > +						  rdev->etha->speed);
> > +			if (err < 0)
> > +				goto err_serdes_init;
> > +			of_node_put(phy);
> > +		}
> > +
> > +		rdev->etha->operated =3D true;
> > +	}
> > +
> > +	napi_enable(&rdev->napi);
> > +	netif_start_queue(ndev);
> > +
> > +	rswitch_enadis_data_irq(rdev->priv, rdev->tx_chain->index, true);
> > +	rswitch_enadis_data_irq(rdev->priv, rdev->rx_chain->index, true);
> > +
> > +	return err;
> > +
> > +err_serdes_init:
> > +	phy_stop(ndev->phydev);
> > +	rswitch_phy_deinit(rdev);
> > +
> > +err_phy_init:
> > +	rswitch_mii_unregister(rdev);
> > +
> > +err_mii_register:
> > +err_hw_init:
> > +	of_node_put(phy);
> > +
> > +	return err;
> > +};
> > +
> > +static int rswitch_stop(struct net_device *ndev)
> > +{
> > +	struct rswitch_device *rdev =3D netdev_priv(ndev);
> > +
> > +	netif_tx_stop_all_queues(ndev);
> > +
> > +	rswitch_enadis_data_irq(rdev->priv, rdev->tx_chain->index, false);
> > +	rswitch_enadis_data_irq(rdev->priv, rdev->rx_chain->index, false);
> > +
> > +	if (rdev->etha && ndev->phydev)
> > +		phy_stop(ndev->phydev);
> > +
> > +	napi_disable(&rdev->napi);
> > +
> > +	return 0;
> > +};
> > +
> > +static int rswitch_start_xmit(struct sk_buff *skb, struct net_device *=
ndev)
> > +{
> > +	struct rswitch_device *rdev =3D netdev_priv(ndev);
> > +	int ret =3D NETDEV_TX_OK;
> > +	int entry;
> > +	dma_addr_t dma_addr;
> > +	struct rswitch_ext_desc *desc;
> > +	struct rswitch_gwca_chain *c =3D rdev->tx_chain;
> > +
> > +	if (c->cur - c->dirty > c->num_ring - 1) {
> > +		netif_stop_subqueue(ndev, 0);
> > +		return ret;
> > +	}
> > +
> > +	if (skb_put_padto(skb, ETH_ZLEN))
> > +		return ret;
> > +
> > +	dma_addr =3D dma_map_single(ndev->dev.parent, skb->data, skb->len, DM=
A_TO_DEVICE);
> > +	if (dma_mapping_error(ndev->dev.parent, dma_addr)) {
> > +		dev_kfree_skb_any(skb);
> > +		return ret;
> > +	}
> > +
> > +	entry =3D c->cur % c->num_ring;
> > +	c->skb[entry] =3D skb;
> > +	desc =3D &c->ring[entry];
> > +	desc->dptrl =3D cpu_to_le32(lower_32_bits(dma_addr));
> > +	desc->dptrh =3D cpu_to_le32(upper_32_bits(dma_addr));
> > +	desc->info_ds =3D cpu_to_le16(skb->len);
> > +
> > +	if (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) {
> > +		skb_shinfo(skb)->tx_flags |=3D SKBTX_IN_PROGRESS;
> > +		rdev->ts_tag++;
> > +		desc->info1 =3D (rdev->ts_tag << 8) | BIT(3);
> > +	}
> > +
> > +	skb_tx_timestamp(skb);
> > +	dma_wmb();
> > +
> > +	desc->die_dt =3D DT_FSINGLE | DIE;
> > +	wmb();	/* c->cur must be incremented after die_dt was set */
> > +
> > +	c->cur++;
> > +	rswitch_modify(rdev->addr, GWTRC(c->index), 0, BIT(c->index % 32));
> > +
> > +	return ret;
> > +}
> > +
> > +static struct net_device_stats *rswitch_get_stats(struct net_device *n=
dev)
> > +{
> > +	return &ndev->stats;
> > +}
> > +
> > +static int rswitch_hwstamp_get(struct net_device *ndev, struct ifreq *=
req)
> > +{
> > +	struct rswitch_device *rdev =3D netdev_priv(ndev);
> > +	struct rswitch_private *priv =3D rdev->priv;
> > +	struct rcar_gen4_ptp_private *ptp_priv =3D priv->ptp_priv;
> > +	struct hwtstamp_config config;
> > +
> > +	config.flags =3D 0;
> > +	config.tx_type =3D ptp_priv->tstamp_tx_ctrl ? HWTSTAMP_TX_ON :
> > +						    HWTSTAMP_TX_OFF;
> > +	switch (ptp_priv->tstamp_rx_ctrl & RCAR_GEN4_RXTSTAMP_TYPE) {
> > +	case RCAR_GEN4_RXTSTAMP_TYPE_V2_L2_EVENT:
> > +		config.rx_filter =3D HWTSTAMP_FILTER_PTP_V2_L2_EVENT;
> > +		break;
> > +	case RCAR_GEN4_RXTSTAMP_TYPE_ALL:
> > +		config.rx_filter =3D HWTSTAMP_FILTER_ALL;
> > +		break;
> > +	default:
> > +		config.rx_filter =3D HWTSTAMP_FILTER_NONE;
> > +		break;
> > +	}
> > +
> > +	return copy_to_user(req->ifr_data, &config, sizeof(config)) ? -EFAULT=
 : 0;
> > +}
> > +
> > +static int rswitch_hwstamp_set(struct net_device *ndev, struct ifreq *=
req)
> > +{
> > +	struct rswitch_device *rdev =3D netdev_priv(ndev);
> > +	struct rswitch_private *priv =3D rdev->priv;
> > +	struct rcar_gen4_ptp_private *ptp_priv =3D priv->ptp_priv;
> > +	struct hwtstamp_config config;
> > +	u32 tstamp_rx_ctrl =3D RCAR_GEN4_RXTSTAMP_ENABLED;
> > +	u32 tstamp_tx_ctrl;
> > +
> > +	if (copy_from_user(&config, req->ifr_data, sizeof(config)))
> > +		return -EFAULT;
> > +
> > +	if (config.flags)
> > +		return -EINVAL;
> > +
> > +	switch (config.tx_type) {
> > +	case HWTSTAMP_TX_OFF:
> > +		tstamp_tx_ctrl =3D 0;
> > +		break;
> > +	case HWTSTAMP_TX_ON:
> > +		tstamp_tx_ctrl =3D RCAR_GEN4_TXTSTAMP_ENABLED;
> > +		break;
> > +	default:
> > +		return -ERANGE;
> > +	}
> > +
> > +	switch (config.rx_filter) {
> > +	case HWTSTAMP_FILTER_NONE:
> > +		tstamp_rx_ctrl =3D 0;
> > +		break;
> > +	case HWTSTAMP_FILTER_PTP_V2_L2_EVENT:
> > +		tstamp_rx_ctrl |=3D RCAR_GEN4_RXTSTAMP_TYPE_V2_L2_EVENT;
> > +		break;
> > +	default:
> > +		config.rx_filter =3D HWTSTAMP_FILTER_ALL;
> > +		tstamp_rx_ctrl |=3D RCAR_GEN4_RXTSTAMP_TYPE_ALL;
> > +		break;
> > +	}
> > +
> > +	ptp_priv->tstamp_tx_ctrl =3D tstamp_tx_ctrl;
> > +	ptp_priv->tstamp_rx_ctrl =3D tstamp_rx_ctrl;
> > +
> > +	return copy_to_user(req->ifr_data, &config, sizeof(config)) ? -EFAULT=
 : 0;
> > +}
> > +
> > +static int rswitch_eth_ioctl(struct net_device *ndev, struct ifreq *re=
q, int cmd)
> > +{
> > +	if (!netif_running(ndev))
> > +		return -EINVAL;
> > +
> > +	switch (cmd) {
> > +	case SIOCGHWTSTAMP:
> > +		return rswitch_hwstamp_get(ndev, req);
> > +	case SIOCSHWTSTAMP:
> > +		return rswitch_hwstamp_set(ndev, req);
> > +	default:
> > +		break;
> > +	}
>=20
> You should call phy_mii_ioctl() here.

Thank you. I'll call phy_mii_ioctl() here.

> > +static int rswitch_serdes_reg_wait(void __iomem *addr, u32 offs, u32 b=
ank, u32 mask, u32 expected)
> > +{
> > +	int i;
> > +
> > +	iowrite32(bank, addr + RSWITCH_SERDES_BANK_SELECT);
> > +	mdelay(1);
> > +
> > +	for (i =3D 0; i < RSWITCH_TIMEOUT_US; i++) {
> > +		if ((ioread32(addr + offs) & mask) =3D=3D expected)
> > +			return 0;
> > +		udelay(1);
> > +	}
>=20
> iopoll.h

I'll use iopoll.h API.

> > +
> > +	return -ETIMEDOUT;
> > +}
> > +
>=20
> > +static int rswitch_serdes_common_setting(void __iomem *addr0,
> > +					 enum rswitch_serdes_mode mode)
> > +{
> > +	switch (mode) {
> > +	case SGMII:
> > +		rswitch_serdes_write32(addr0, 0x0244, 0x180, 0x97);
> > +		rswitch_serdes_write32(addr0, 0x01d0, 0x180, 0x60);
> > +		rswitch_serdes_write32(addr0, 0x01d8, 0x180, 0x2200);
> > +		rswitch_serdes_write32(addr0, 0x01d4, 0x180, 0);
> > +		rswitch_serdes_write32(addr0, 0x01e0, 0x180, 0x3d);
>=20
> Please add #defines for all these magic numbers.

I should have added comments before though, the datasheet also describes
such magic numbers like below...
Step S.4.1	bank 0x180	address =3D 0x0244		data =3D 0x00000097
Step S.4.2	bank 0x180	address =3D 0x01d0		data =3D 0x00000060
...

So, perhaps we can define like the followings:
#define	SERDES_BANK_180		0x180

#define	SERDES_STEP_S_4_1_ADDR	0x0244
#define	SERDES_STEP_S_4_1_DATA	0x00000097
...

And,

		rswitch_serdes_write32(addr0, SERDES_STEP_S_4_1_ADDR, SERDES_BANK_180, SE=
RDES_STEP_S_4_1_DATA);
		rswitch_serdes_write32(addr0, SERDES_STEP_S_4_2_ADDR, SERDES_BANK_180, SE=
RDES_STEP_S_4_2_DATA);
...

Is it acceptable?
Or, perhaps, adding the reason (The datasheet describes magic numbers)
is better than adding the #defines.

Best regards,
Yoshihiro Shimoda

