Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B16B37B439
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 04:44:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbhELCpV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 22:45:21 -0400
Received: from mail-vi1eur05on2072.outbound.protection.outlook.com ([40.107.21.72]:55840
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229952AbhELCpU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 May 2021 22:45:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fjE+k0mKv3bcdH2zs/rjk46W21wGTImCjnH13j91NJC0c3gJWHvqTUpceM3VjSG+YU55FMWd7AWayQHkO5GiZzciGIPfVs+ZwB5lBg7Wejrh5i/D9jGfZNXFzSM2++/l22vNgXJ6tG9OoEZ5JgG+kQMZVKDXl/nl5P8Ks7J4eL1kvwbt9oVLpKGfFH+w9w6DVfd+JEq6dZC45XXxkrbjYKXP27/yTYKlTozlJIj295k0MWFhxsqNofkRC/joKZdHnXwDGAQ9WVmjPWcScloTTktjx54vBpuzN4Vh4fPH5NG8k3/NXFcnK2qiaxLof3YFAAVULS6LdrMY1YBiSZU7PQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GxC4J3J2n2lcwpKAo4ZHoImXghP447nS0zt/HXuafIo=;
 b=WIKfWgBntfDwYNTpuIwKsl6uQwHAmEmUBWtGZV/yQYxt6uiVe2qyYP6uAJbk2VAqZXq2BttmH7QWoNUsDascgZ5DbsaLFMuGYaz8whC8+O0ZvvSZm0Ww/PDZbP13NPbV9j3r+SQV/8cEHLdlVW/IFDMfNjuBaNtgGhq40mDgjq6GLpxbpHxmcT8ZDHyd93Muz00Adx8HYGr6KcbSLWlEozgi5hRnJ9HxFzJgU9uCRwiQj+bGUoCMu0MELM9lKqcdxWCj8a5dw5NP1qF4i2MYgqL9NExe2vGMGB0m56vzzeZ6Qmiboxq44RDeHqnDEhRLS2Aoq0vDMbjBEG4tGW+B1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GxC4J3J2n2lcwpKAo4ZHoImXghP447nS0zt/HXuafIo=;
 b=On8wEefg15gslXMhTvI3OqDmJIVTVX5CVnYNcfFVjt1GvKUyC4Mg4X5GRoNr8IBbGFmk0NoGmAr8wHSCPA+k56Q/ZTrQbwbiGzeREICrUrLJ7fn1p59A7f24AhpXyobiUzPX/WcotH8tCfjpmdS4DDmLL0s80Hk3j6U0cgNy7Ok=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB8PR04MB5884.eurprd04.prod.outlook.com (2603:10a6:10:b0::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25; Wed, 12 May
 2021 02:44:10 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf%9]) with mapi id 15.20.4129.025; Wed, 12 May 2021
 02:44:09 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net 0/2] net: fixes for fec driver
Date:   Wed, 12 May 2021 10:43:58 +0800
Message-Id: <20210512024400.19041-1-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SG2PR03CA0095.apcprd03.prod.outlook.com
 (2603:1096:4:7c::23) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR03CA0095.apcprd03.prod.outlook.com (2603:1096:4:7c::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.12 via Frontend Transport; Wed, 12 May 2021 02:44:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 70e2fb77-d1b0-473e-574c-08d914efd18f
X-MS-TrafficTypeDiagnostic: DB8PR04MB5884:
X-Microsoft-Antispam-PRVS: <DB8PR04MB5884A31FE222DF2630F0A88BE6529@DB8PR04MB5884.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JH+XcvZEdAeVv6m07pNR7e1Y6y++rY/ojVKE0AcPfWetOS9trWfm3s69/QivwctpAWuEaAEBhCJ8Yh06sAgFnzUAYiqM/9qQ8aWQgphbRAUDRWYI9446Ut6Hfzs6j35tQngGcDURmE07N6yu2f8PjoSdgONpn1r4WX8hb01nURE+GpkWOxo1xLJHaivo+dtOS2lhYgzKCiRqIqLYDfmj+nH/LMF+NJAlkfjjaoYgjNhneAHSEUu7OUtLuamxmqxI2xneT4X/u6hR2rWR7q4AcsB0tHSXjCRCCVBX81ic/Ny3OhRl4cpV/8Pgl8oObFGvQM67M118r2lxqR5jv/A9fEwlbBm3MSwqYpem3S1dxhB3kCb4V/aVC5dwsMKLcoB7qwp20rpz/p+/at+SqCDlL9FhQOIWg6W0a0Ic2dn4I60GxyANuabQdFdPQ5OpczQbrqPvmh74SKaa6UGRmgE71R5SOfsZxSbQgPaDYyRt9nGoegO1xlTvtAyDJAUYRXGqCMO3x0zXLDFoOt+HJYL92Vls+U/FG5SvNqB2rPBJKGol1jh/Lq9BuYlcsTEqkeZbvFn4A1jO3iqL/MLrHEBv4JnPJuKWmraSB7D96PypjgfGW3ug1H+QS6nzoql3tRi205J2PHiUUkBl56e15teRunARwce0ml2GkwN8pfYF2WKMG1s81hdLhdeTZgSyfQBp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(39860400002)(396003)(346002)(366004)(478600001)(2616005)(52116002)(8936002)(5660300002)(86362001)(956004)(4326008)(66476007)(66556008)(8676002)(66946007)(6666004)(558084003)(1076003)(83380400001)(6486002)(186003)(6512007)(16526019)(6506007)(26005)(316002)(36756003)(2906002)(38350700002)(38100700002)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?hXRA+2i2mBEGMVPuneY+SqqkJJYqRjveUkUSpF7pVrzjmH2JaGUPsdHiL+9N?=
 =?us-ascii?Q?3gNB8pNOd+aUkte7JukhzfLbIjoMvNk/74XhfMJwV+z8/3OvXNRC34lY6mxq?=
 =?us-ascii?Q?78qEkTnE0RVZceM9JrLNaXEKf9w6XDWNxJB9TtuWIpEtLjW0LSqo5G1xk5ZI?=
 =?us-ascii?Q?0a/TiXNxRBu2x37NRn3DxYLECHZKXtyspS99wccoNhtRc6A566SUYBkmVswN?=
 =?us-ascii?Q?3+xnnlCBGJm3avqG3zJdaKjVlnFx3yTjWUe/xGoRJjn0D4PEuPEbacJJWtMo?=
 =?us-ascii?Q?iWp9BIIYL07eiSqJqiFbnim4rUi+TxEQs8/klZ5I79/oKlb0mAg/5zxQwoU5?=
 =?us-ascii?Q?C1v1CUUlFkMkrqY/f+eq2ULO/ATv2wgQcp2v4DibYddEWdwrWyYSCKkEoT4/?=
 =?us-ascii?Q?qJpPdnlVFIjg8uae6FOCENJ8euBBmkKqe5Z+KDuL5426zwVP50GkQAxIFvJz?=
 =?us-ascii?Q?/4AQAsmF5E+wxyzs3+vb4+q0WEgKYJYiuNqiU2p9HTrcFUmPEIE/jCo0knm3?=
 =?us-ascii?Q?E2gmFsb6gReur1bpIh2Ap/NAB24SPG6y8CnjyWlazL3n3xadLKcs+H9NVW/V?=
 =?us-ascii?Q?BGgsprqSKv1zWTj4v+CYw+0spW9DGvZh3Ug1ai23Y1Qpry5slHsv+jb9xYbd?=
 =?us-ascii?Q?IuxgVWPqAWaBKEipJUnRqyn/Rn3Qi8WgebZkDK8cjoS7utEbWSZUOmRkTj3E?=
 =?us-ascii?Q?4Cup4RkH8qL341KxKpn+lZXTXS3xS/Qg+mdn2NvTinHoNiOEha8P7UatO/7T?=
 =?us-ascii?Q?V5xwdhffDGFW4GhxT+QiD21LHOjlr7a56GdmnN6jHp1F0vx/5OsNW2CIjRAD?=
 =?us-ascii?Q?e5LEnMyEKmLp+of8LuyqGvArd0ShApdVv6j5V85/AcDaMiqDzBkGJF8/P/uT?=
 =?us-ascii?Q?w+LfcgmMzbai+0Teb1hxugCX+Vd1r1lXYycasd60c0grYgnVERj6xsmjp5Ky?=
 =?us-ascii?Q?rNj4jvshj/x1ijL3gZZpxqWfRYX7jr58cBYgarE+bywDzAReS4RUTSvL80/k?=
 =?us-ascii?Q?gZ/dLh0eEU9bspoH0IhDUKTAdW/B/Jj1+YyUZLIy4ZCajXPR7buzY1w6/oAO?=
 =?us-ascii?Q?v2PmBM9nmwfO+Sfh5EeqzP9kY5p/Jh/XMVO2e0TKSLn73qNoQd2Gk5egaAoy?=
 =?us-ascii?Q?+muFSADwt6e4LfPSHqwto6aVyTBKS5B9pZDnVXGF+wj1o+Lj3iYl8msjADm8?=
 =?us-ascii?Q?12t2O57O+GfyU2+3JiptANgR6MxOwzHDGI38CmrgxM3nwmSW3LHx4leFjFGP?=
 =?us-ascii?Q?4HcfNU9GDdsf9+y7q3qZRMUPhCGntxTdxNW9kRmD2tO1laA5jk0RdRfqnrEh?=
 =?us-ascii?Q?k/2SEex6y1Kq/zys3of2JyOx?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70e2fb77-d1b0-473e-574c-08d914efd18f
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2021 02:44:09.7965
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ePTjGX0tK2ukfLFBTZf0UTfgvCGxVuIa6xyAziLQ0sIQmHW7yoZcMFkSMFR+owcdhCM6Yf5CrSyUaqmOr3tMwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB5884
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Two small fixes for fec driver.

Fugang Duan (2):
  net: fec: fix the potential memory leak in fec_enet_init()
  net: fec: add defer probe for of_get_mac_address

 drivers/net/ethernet/freescale/fec_main.c | 24 ++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

-- 
2.17.1

