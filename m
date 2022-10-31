Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4731B61319B
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 09:21:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbiJaIVR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 04:21:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbiJaIVQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 04:21:16 -0400
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2133.outbound.protection.outlook.com [40.107.114.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30E28B4BE;
        Mon, 31 Oct 2022 01:21:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PdvQAlkSwbLU7EcKYLPmlnY7viHKgPixgmOsYCk5Ko/3Pz42YSPCDycFUiWcvAUhKqdRUNOhqpWcMGxmufmsZb64FKP3QvVTH1ge4IjPjLIH6RmdOvB379/3zvRbH3pEiUfcqjMObzTP+Gq9ErWQ6nCZBS1LbOvIRghG7mlHwOwYae0sl9ssUdG/+BXakMPbABjZtv8PTqDfivweL7/r0QM5kdOOHqifb3CX50wQGBPDwk3Aev6kvfr0W1/Q8+0hgcRYPFbsaEHtEbBLG3gnazKyeOKOQ9oUHrycndidQ/r+hB8HSUt/DV+uRbkZmdi5ezYVKykNd1sDzP5v/9Kh8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CuMrscYp5l1SNsb8SgC2tTbYo4FAPp24H3jZUNcmzqg=;
 b=iIsHJuwOqfon/gVC0LjWpnh+JdTzKrm0VM6Uwek4arbNiY91R1oJt8j6jzFWiGONsOkLDHvq99yCCAmcmENu5cfzGFlWNMyfgmTdAmwjnGPYv4FUbKZtX8mZ02j4g2IN+TlKVt9yKAEcNqwFlPyqMjGgYMsya5mRIczM5Fg1AHqFYcBYcI9/a3J9jiq5qC4KUudph7mIdTFgbGSdnh/rQtGgSk1sfzVsQCvXcEM6Hwg2AZ96FK+gVmkewpMU6Wh4OvGzzB5R6B7osAPGQcLVAG1pUjeGdw5C91nwUF48tlL9mn9hZ9rIBi2uF8K6bGk2uVfnz12CPDZWIw7TFbnYoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CuMrscYp5l1SNsb8SgC2tTbYo4FAPp24H3jZUNcmzqg=;
 b=PoMaPSxMnzo7JxDhdZeipc8mWWENTipuZur7PTkPiqk1sO55oTn/SwBhNdQhTIe17Cr4SdZ0E0Iqe2Un2aVfmzO3gX0DflZVKfLLnvWAOrlLfXdrTt6WMgHtxtz3kaFOlmI6S/i64SW2Eys9/3JvnRzWFZQIxWzGn16YqWR8rpU=
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 (2603:1096:404:8028::13) by OS3PR01MB8066.jpnprd01.prod.outlook.com
 (2603:1096:604:170::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.18; Mon, 31 Oct
 2022 08:21:11 +0000
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::e28a:8db5:ee6a:34a8]) by TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::e28a:8db5:ee6a:34a8%9]) with mapi id 15.20.5769.019; Mon, 31 Oct 2022
 08:21:10 +0000
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH v6 2/3] net: ethernet: renesas: Add support for "Ethernet
 Switch"
Thread-Topic: [PATCH v6 2/3] net: ethernet: renesas: Add support for "Ethernet
 Switch"
Thread-Index: AQHY6po8IVUtcFUV90m9uUp0suhIEa4lrMAAgAKBSxA=
Date:   Mon, 31 Oct 2022 08:21:10 +0000
Message-ID: <TYBPR01MB534180187D899534F1634CBFD8379@TYBPR01MB5341.jpnprd01.prod.outlook.com>
References: <20221028065458.2417293-1-yoshihiro.shimoda.uh@renesas.com>
 <20221028065458.2417293-3-yoshihiro.shimoda.uh@renesas.com>
 <Y11rVIKtUDf1i5xP@lunn.ch>
In-Reply-To: <Y11rVIKtUDf1i5xP@lunn.ch>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYBPR01MB5341:EE_|OS3PR01MB8066:EE_
x-ms-office365-filtering-correlation-id: c6c1e2e3-ff49-443a-f66e-08dabb18de45
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CEmR7qmOnBGFZ4dFYGGG9Y/HXEX0MjtJK1A3gOV6sulIPNebxTR810HSOYxufvhx5Nf80HRwYRIu6IS4wiuVgzjW79acVUrnsxYdacmNNfV5DXmlbIgFcG+8iGkjZHa2HfLtaan0X6Jr8GEr7Lzbw7SxskVVuQMKnnoq4TBC6BJZIeLBU0+d/KKHq80wPjwra3l5V2b0qlo87HP/3r78K/sV9pW1Dvj/OIdubL7db4LOA3fcjb7a/eXrppKVrTESM8CxPDS52ioDhVa1wToiELSQzUYEahLOoCgcS8lWFgf+L05GJbf/rMFybbTEgZvDkNnK3xEvi1oE1ylB7evMm6L1mqJdo6+5nTN448rKobeVzZHplSe9dAU7Z4RguBgGn7BMXVeCQ0CWuhdlU1CiHQGv/GWcLDq/IjypYPLISdTuSIIQ2Z3VLlc6gzNhpXxkAHruLVlDxd5YU/MVUClqXsKii7nRm3YoXQjBkgHucesOqNPgX4X+0VHrMzWtR6U2j+CxOZDkW3eigl8VYH7FLyubSLVF1ZehDlnNUK+Y8cnPwtxhkht6f2bEFLV+iBRgXst2E9R9rAy1wyQIFq23tR5YgUwUcafc5IdVGmrS8fs/xl452fo3OUoKLKHwplHSRkyieK1CMpUtpB7QDKr2Zkh4f4rBw0m2nH+TQA3RdXqqJEeO/DfbS0nVHsgafQ+5C2F8oxbHKzOZwoWT2lWpXvtbEj7Qb+BABkkZClYpck+C0y9QXnp436RwTRyCj1wIiCaW0aJCNyljyImGmqRbBA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYBPR01MB5341.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(39860400002)(376002)(136003)(346002)(396003)(451199015)(122000001)(38100700002)(9686003)(38070700005)(41300700001)(83380400001)(33656002)(8936002)(52536014)(5660300002)(7416002)(186003)(86362001)(2906002)(4744005)(6506007)(7696005)(8676002)(71200400001)(55016003)(76116006)(66946007)(66476007)(64756008)(66446008)(478600001)(4326008)(316002)(6916009)(66556008)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Wn0N77eQG3X5wulAoLDUi7mwZCIWOEWo+J7V3yNMNQXMOhJecyK/DTvtSep7?=
 =?us-ascii?Q?2hn246oyghckSKs/GqkMLqx8T4uegTIdKlC7HmU2CDT+Scr2W0tivy5zsj/i?=
 =?us-ascii?Q?9nW/ZHTFtL7nJXZsQykNs6Z/bzURrh3I3izsI7CQ7De1jY7anGNsD79s4GzL?=
 =?us-ascii?Q?XbSlTAcK7N5nzAEBas0v3FCDhJn+ZqsiBtR+btMbrSIBeiBt+R5DcYrBiCX/?=
 =?us-ascii?Q?NN3Yo6XFh1tL/L94zT/WRcVrAyKiAHT12ZHwxs+eeAsaJzM/XrRQvvMF+Ry4?=
 =?us-ascii?Q?Mkad1Scc4PIN70W5w126fVHuoCiGXjhFTLUHmAmyf8SGiDNxvTCCthVxts1G?=
 =?us-ascii?Q?P1rbXHoqd6Ll2ycL0YmImzv/Ad3vN+9x2Qh6w3PFV4s+TSgdozU4Gp7XuCZ4?=
 =?us-ascii?Q?7wRbSXWvY1eYDXtFldaan26IylP+IsLpFVrWTY0fF3YB5hp7EYLwiXkAhX/q?=
 =?us-ascii?Q?4EhSPpdXyFKvQzT/Yws2Z4qeTXga3QRoZ+IxhfKJZr33z07LMLMtKSGpU/+1?=
 =?us-ascii?Q?+kQHGMf0KTITZIu7N5oZhM+mVhXnnQBXrGgLEqkB9xUf4WX8y1V5hSAxTQU5?=
 =?us-ascii?Q?zXe9tCGOuVi61v0bW8nnPrcUtfD9ifHn6KQKMvJ7LAIwKIY3I9ZFxDTfxkDv?=
 =?us-ascii?Q?c0cYMNQMXQvP5TXT0NuVleTU+VvfNB4mJRHU04tRuBwXfjSYZvYf//GGbMLP?=
 =?us-ascii?Q?SB8FrlCINQQjIJrtaAxl35FYiik8FLMM/5MLkRYIiJ6BYv/i0MbIDPciEU4s?=
 =?us-ascii?Q?QgLfcWi76OqyR9S+L//ZZdQwr94eqt4vpz6UW2qFamf8pBIgMtqKTXCk6rK5?=
 =?us-ascii?Q?e9pd1ARTwF2YQldKFni3T2iEgYKy7LAp5M4+3GJ2x0jil8JCuHfbPLlYSWKu?=
 =?us-ascii?Q?xBsxZe1smfeno7K+OEcMZ3lDW3E5PrLXz6Z27yg+9tamX5AMjbRet3vcfu19?=
 =?us-ascii?Q?mYdAa7BWKyGK+5q2kh+A34K4JhD+WfWolZCp8PwSSBSEk99uK+6GQOq7SzKW?=
 =?us-ascii?Q?EdcX9zLxB/twgO2qAMof4TBUaOdTy7btSn4SU23zIJ+xPDcP30BX+rx8Ubf5?=
 =?us-ascii?Q?U9vSxbaSmbXNTeLrNQ9tXgb1SiXRl1j7Lkhv9FzVwrcV2+m6gp6VlAzSGCNK?=
 =?us-ascii?Q?WE+DLDiemCnbYvGp8/5eLjmIA/ZzIn+2yix/J5G4R32UEC755DrQ4HSzBrlP?=
 =?us-ascii?Q?f/TaDdN1pFFZiPOXgKIaxTmCrmZsfs8ic+M1xP7MUQGxNuz/c3F6bme6DRR+?=
 =?us-ascii?Q?ZBge1njWv52UfTiUuy1C1gIoOoxKyRwnV0qN7tGKIALupMyVCgVyDo6NeeRc?=
 =?us-ascii?Q?hzaLQhJOzFVJ7rgF5GIpAmHk1g5v/11jBxI7nv+FcTSAXSREfxj5fX/PqUI8?=
 =?us-ascii?Q?vqE3A9Xjnhn1M3Cjpfiamh5OQEm8cQ+KL8VI/kd07WlQfO3E9xgyoz4Jmwhz?=
 =?us-ascii?Q?c8+u1fFSsnRV3AGlcFZ7vfQsaw8JShXCi0oYtSefAJSP2W2bHToHQDADwEwx?=
 =?us-ascii?Q?1RfgG31KdNnPd96m05J5Ye4DiC7P6CyU6CDAuoDIGB6Dm3OFT35AMQluNyhW?=
 =?us-ascii?Q?QV+NF4zf0rsaxOvA1tFCPljTlJCFx/BKWtjU7U0hzwd2imruKp0NP1PAaGB9?=
 =?us-ascii?Q?AGzILoMICpgwhEMcgLSHzdQ5DXlDBZfbNHvgeUmBz6UM+BEO2Td4wKK6T5h6?=
 =?us-ascii?Q?B9s7hg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYBPR01MB5341.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6c1e2e3-ff49-443a-f66e-08dabb18de45
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Oct 2022 08:21:10.8614
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ElofkWL6gBR6tWXU8/TnmiKh0IAHAqElt/qhbk+qwJ1gcqxyQ1+dQyXhg/YJtYF+1LMSSbax1YQzO7HyXYWf4XidhzE6Z5h0izxurH2OEM71dxNN0t0uOztVsL0BwKBS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3PR01MB8066
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

> From: Andrew Lunn, Sent: Sunday, October 30, 2022 3:05 AM
>=20
> > +	for (i =3D 0; i < RSWITCH_NUM_PORTS; i++) {
> > +		err =3D register_netdev(priv->rdev[i]->ndev);
> > +		if (err) {
> > +			for (i--; i >=3D 0; i--)
> > +				unregister_netdev(priv->rdev[i]->ndev);
> > +			goto err_register_netdev;
> > +		}
> > +	}
> > +
> > +	err =3D rswitch_ether_port_init_all(priv);
> > +	if (err)
> > +		goto err_ether_port_init_all;
>=20
> As soon as you call register_netdev() the devices are active, and can
> be in use. E.G. NFS root can start mounting the filesystem before
> register_netdev() even returns. Is it safe to call driver operations
> before rswitch_ether_port_init_all().

Thank you for your review! It's not safe. So, I'll modify this driver someh=
ow.

Best regards,
Yoshihiro Shimoda

