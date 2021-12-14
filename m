Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B9BE47422D
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 13:17:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbhLNMQ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 07:16:56 -0500
Received: from mail-zr0che01on2122.outbound.protection.outlook.com ([40.107.24.122]:35264
        "EHLO CHE01-ZR0-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231613AbhLNMQx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Dec 2021 07:16:53 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dFAq/+s30ebAiLLW2bXysNp0Q4gTGWUpH/eU0coocZ2guv2rnwCVHJOrDbrnWrCVy1mChD2aIEZhcBCuXNa9ch4aKOgG/pT9nmjUNM8n9lw7rZduVTY5fEwQwN2vGTJiY41eoAryo582TxpveP13uAJQ9tosUUG3akuHEO2sIjyaKGSfdnH4XtfL/3xc+asq9JVHgU4C/bc9HNTUzGN+y77y5l+F24trdJvM+cBKlNKaL6ngGsmO6w/MDHcvnAhoaXbWcnwzFuqvpyc36uOdEP12Aglrn6hpiy5u09o0IlcLpR+SaxiwEsxc9N+a2HLJFLIP2cYFIynAHor2Mguejg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RhUBnY7Ec2wSAESThYhy2vQfHFzgU0xLciGy/vyZ5YQ=;
 b=NhVsOSfELeCpn/7lB+Krhxa+56JLaCCGlKmxmNabMTHmnlHXwRRMEYf4XD3f0FkwHx+/BcjGdwJj7NBmVqaBjBj/abLUaXTQNn1pGhRJrQgU4e+lATU2WBylfuTneyvX+wbEJXcfqDanRPLyt6IKGRvF2gM5Voq4WpGa4a7Grbz7Dk6FNdfAd9qXDmvaqfop3j0Gr6LxLUP8uB+jzONA5vqQnfssUVuHGtu5L7A/XFj+lONQ99cQVWHUbsDMqihzJBAoUbeV5WXWlJEy5piEjCyZV0vd2gV9IDtJized12M1EWAfdWfu6y6Kz0TA1KVRhz7gMBbIEwCh0mUE+UUffg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=toradex.com; dmarc=pass action=none header.from=toradex.com;
 dkim=pass header.d=toradex.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=toradex.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RhUBnY7Ec2wSAESThYhy2vQfHFzgU0xLciGy/vyZ5YQ=;
 b=g0Yce1MqsA0CB07TuvgUoYA5l+HMfyx/vUW3Xo8RcE4xrv7e/HZW4a9EhOHFLzYrcs+oout1bod0J1FCgodcCYC9K0hM/W7JOYiTtkQQ9toADfN/2rcSnM32BbjYyh1nsOH4cEYGgsyigkplcxtC7mhjSmXluFgtz5bvBFFpfNk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=toradex.com;
Received: from ZR0P278MB0377.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:34::14)
 by ZR0P278MB0234.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:36::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Tue, 14 Dec
 2021 12:16:51 +0000
Received: from ZR0P278MB0377.CHEP278.PROD.OUTLOOK.COM
 ([fe80::e5c4:5c29:1958:fbea]) by ZR0P278MB0377.CHEP278.PROD.OUTLOOK.COM
 ([fe80::e5c4:5c29:1958:fbea%8]) with mapi id 15.20.4778.018; Tue, 14 Dec 2021
 12:16:51 +0000
From:   Philippe Schenker <philippe.schenker@toradex.com>
To:     netdev@vger.kernel.org, Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Francesco Dolcini <francesco.dolcini@toradex.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Fabio Estevam <festevam@gmail.com>,
        Fugang Duan <fugang.duan@nxp.com>,
        Philippe Schenker <philippe.schenker@toradex.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/3] Add Possiblity to Reset PHY After Power-up
Date:   Tue, 14 Dec 2021 13:16:35 +0100
Message-Id: <20211214121638.138784-1-philippe.schenker@toradex.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: ZR0P278CA0167.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:45::15) To ZR0P278MB0377.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:34::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c33c5d13-ce87-4e0d-ba4d-08d9befb9c04
X-MS-TrafficTypeDiagnostic: ZR0P278MB0234:EE_
X-Microsoft-Antispam-PRVS: <ZR0P278MB023484D4E3A0E458FEE79520F4759@ZR0P278MB0234.CHEP278.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Bqwad8yDcjSK0vOBRxdCVwHQCVIaV8TslwZBUmlmHFPgQ9umbBqkNXsq+/BQL54rPTzgtaq6sQv+Fd94OQl93xD2wv57i3osC5objT23NSECQVfxGseZhbN7IvyS40mTNq0CXRjnelo1Fxx5stq6uGehi+cTugKMQ4EDulbLykridhllgftG4dMou3jgGoZS1Zfm0srXokG9XOt5lEenlnqh7fuT/+bfSMw51dYi2ieCQnVy8kAKg7SJTK3kAxteLbPfhFZ0gvM4ISEiTFZrLVwd26WbF3m9DvTRINPEhwnpJGJc/PEwnNIrhZUH0E+rYJzLdmmezFO57uCOtbH/MdWkoOawgMvQVgOa+tMYm0zUwPIoVeD2zWyguiKQIfeT4qA780Ct6kZEvEwldJwlEWJNq2AHaA+5NOD1QYQsWGZD9/MLyIP59XSF+853utmzNt325ARB4h3wq3a1WlovBmUyMR2avbkv0mrf3f4Y0zdEIMLuabQaUJK6qfcUNm8B9XQko35WWEHSaUq88alEHQGR3Y5zKyAWSTkRMf7jNNJghiYZc0L90R5Y34a+IUbMRvM4V9ETM5+UdED+bKWOH3dpA0GWZEsBd4FdLVtzRrD9fhGzM3gyXjgJVv1laXBwOGdvFDbKojX+zOo+iAG8PngEoi3mczUWN9H1OX799aQyG5JA9xj5QPRN33H+4aNaZRvQQAQKdaE5BhV6u+fvNLdx3dtHuwyqclcOXbLlZXWQcDER94oN6ws0+J2FkKqHyPQIjpKLkDntYBAwRTU+NexJQTHz6dWyf2cxdb5xzNQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZR0P278MB0377.CHEP278.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(346002)(376002)(396003)(136003)(366004)(8936002)(86362001)(966005)(6506007)(66946007)(52116002)(316002)(6486002)(54906003)(5660300002)(2616005)(1076003)(508600001)(38350700002)(38100700002)(4326008)(8676002)(186003)(6666004)(26005)(36756003)(6512007)(44832011)(83380400001)(66476007)(66556008)(7416002)(110136005)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5G+T9GFe5UNveJPdvOtX4YXBDqgljeuuRPCDMBon370Wdg/uHTUlwXrAv70+?=
 =?us-ascii?Q?3rxS1PqSDDIQXAJ1UhaO3wCqsXEQOJ6nNniea6AnDxSgRcwq4J1AtlWF46d2?=
 =?us-ascii?Q?fEnMf+t+HWdSiDTSKEM9vljvcC15WoQFjNr8yakH/Yrbn1RGYIcvlx1eAN/H?=
 =?us-ascii?Q?H3uZQaZCMLMzX0X0UfEiAfBGwZuRqRbj1rSbBwKUGpYt+Smu1pWSt51IStIL?=
 =?us-ascii?Q?ticc4zka7jZlI9pHhmgjOy8HAGE+QaDNhhtmASjYFpPikvnuy1uptYWkGw9w?=
 =?us-ascii?Q?grdaYpBUM9bBEOwQL9ZIku4a+9SaqHaqujZw8A0Lj3GZwO9k1GWvKSMOT7+y?=
 =?us-ascii?Q?xxmx3VIPKHBeAr9YJXoyF8c8EKdTGjFhkyUSoHtpUKfsZftBMbnKB5Nn7SfU?=
 =?us-ascii?Q?CceB5+zFXmmPXFrzBjBCdsQjh0vn9HJTmbgJFRL1RN2ZM1RtZYkd1Hh+Th+d?=
 =?us-ascii?Q?AfQhnWLiN9D97lhBL56OlZ0G3ZzqCqEz8Kl5pEDx8kvH99WS2TsckXCfhBdF?=
 =?us-ascii?Q?SCaVOcrU6waBLd9bZrJ69Tc/aXOrnAnSoAE1rIn/gWj3IiNilIlaXPrIea3s?=
 =?us-ascii?Q?fy+e/X/E8kB8qe2Y6+y6HvH/AvGi6pDHick8vOxvGmU+xtmfbMMZTiaKW+wh?=
 =?us-ascii?Q?4O8BJMvJNT3/o0KLlqFi4wEAPwCxCN8mxzYvjahXcpdebUyeEUK8tAD53nTf?=
 =?us-ascii?Q?f23jtySVdADm1znrM7nkQGBK78rDdKqttVp290G9kedyFZ7J7BXdiGEdlZB0?=
 =?us-ascii?Q?859tqt1t4I5tWnyATzJ5tfsFFGk82LmtbDQRLjywvEmvkSDvWPtLvqwj0crn?=
 =?us-ascii?Q?PLgPnGeuAGpU5hWpdwYfTMkF4KgbA8ZHypW5Gmq4uWFexQ45w9HRIAI2Whri?=
 =?us-ascii?Q?bji5IU2meHSmeM20ygsl7CGt2qaUWQEbKdAY7UU/7iLhHOVYyNraCJotWKux?=
 =?us-ascii?Q?D6e8OIldNG50XjYZUcI3gKTjbgxbRC22YNtoLcUpDhAvFPxACymnj6clEZLM?=
 =?us-ascii?Q?i9w/Eh/C0qtblRB7RI5clkNU8O4BgZY7x8QLIWo5R2b6r8jKk5RZQg+yoqMh?=
 =?us-ascii?Q?eNCU6H5yd0a0FQmZRM8KeyaIezknVbK1J3TuYD7cMYdXi1Bmg1ANgHx+gdC5?=
 =?us-ascii?Q?SwbaCqjE0mtdwjzgKLhEMn/NHwLEamAraiuTwKwZMduASZMQ5Jb+Me/d6Hmi?=
 =?us-ascii?Q?3n/fEKW7bsRj5ROOF1uiCgdheZK8XtyPP8wiIGJ/CNaEBIY22Zh5GaD21YxK?=
 =?us-ascii?Q?tSEALSO7ds0rk3XASObiNaoLbGRdctrB9/ybT2mXOR/jKPxN3AisoW0uPN3+?=
 =?us-ascii?Q?KSYZOTjg3XERwVuLhOGYbyC9hPDXHQFjhqtHdCEAbELJ3Rcnz0JsIpHJBnWx?=
 =?us-ascii?Q?z9EBRsKhVGwUSbu3dvV1k4qfnv4vKrbK9Vi07d8aZclBq6whlwkXSAObMbMR?=
 =?us-ascii?Q?6hHTD91BvHGX/WmxeuX7et2aVWvF36YSTY3UzoSfJJhceFiEyuqe34I9jiV5?=
 =?us-ascii?Q?K/W5MIHVrx9U3G1LNkVJMC4KUu50nIY8Jr9D4TVcqJhb2KbWnhiXbbT4pQQ8?=
 =?us-ascii?Q?8UBdzOJ+VjqaCgAo+f7lRCZIX+/cNQ1Af3T9LTFRrz79tFDpM6bHh3IbGvii?=
 =?us-ascii?Q?2Cnsn1oDFdD/V52LxQJK7lPFgCvs94zRNv82VhgGopSfbpvepH5qhESeXUAV?=
 =?us-ascii?Q?d49zSw=3D=3D?=
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c33c5d13-ce87-4e0d-ba4d-08d9befb9c04
X-MS-Exchange-CrossTenant-AuthSource: ZR0P278MB0377.CHEP278.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2021 12:16:51.4663
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MmnB3UhWbTcKVlUmEpxW3YnRvdbXGFNn2LoP1BAxrLz0aeBIUitCNnNE7wcvjyZHX2c2xT5u5Un2UgqITi8X9Qo4B1VFfcZlzo9M+enOyc4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZR0P278MB0234
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We do have a hardware design in which the ethernet phy regulator and
reset are controlled by software. The ethernet PHY is a Microchip
KSZ9131 [1] and the power sequencing requires a reset after the power
goes up.

In our case the ethernet PHY is connected to a Freescale FEC and the
driver is shutting down the regulator on suspend, however on the resume
path the reset signal is never asserted and because of that the
ethernet is not working anymore.

To solve this adds a new phy_reset_after_power_on() function, similar
to the existing phy_reset_after_clk_enable(), and call it in the fec
resume path after the regulator is switched on as suggested by
Joakim Zhang <qiangqing.zhang@nxp.com>.

[1] https://ww1.microchip.com/downloads/en/DeviceDoc/00002841C.pdf


Philippe Schenker (3):
  net: phy: add phy_reset_after_power_on() function
  net: phy: micrel: add reset-after-power-on flag to ksz9x31 phys
  net: fec: reset phy on resume after power-up

 drivers/net/ethernet/freescale/fec_main.c |  1 +
 drivers/net/phy/micrel.c                  |  2 ++
 drivers/net/phy/phy_device.c              | 24 +++++++++++++++++++++++
 include/linux/phy.h                       |  2 ++
 4 files changed, 29 insertions(+)

-- 
2.34.1

