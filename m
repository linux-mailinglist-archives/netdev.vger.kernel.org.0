Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD8D06EA5E0
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 10:31:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231169AbjDUIbI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 04:31:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230047AbjDUIbH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 04:31:07 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2062.outbound.protection.outlook.com [40.107.22.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA9E35B8F;
        Fri, 21 Apr 2023 01:31:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e+CVOzuTRQfBYJJ6XtA2cvM5fa3LmcF/al3nZBb5fkHIRi5VFr5GRF6t5jAJQucBhYNZpRWT4yRB81cGLPYj3IpdaFYLFpCqn/XI0gMYh7/BUhqfzXKGEYYCXoAInmuGO+iAqbtYhDxhTZYl37WlVXNFMEcDV8/jRIwbBwGwUP79MSvztz5JGHtEtP1fq3IGw0sKwuzGfjicdMzTs9QVoO/w2xS8H2pv2Eytj9H/24AIXs84eA4N683xPuYiwxDjvRRmhMaOM1czzK96bA+mfaFKM6VjBulj8IckJ6x9mJCgOZEF11AwFPR4UI+1NyGQ5UGNZIeAdSE4KD436yFnMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fo46wYhGSfuRa7mKbyPykIVV4DNISKs3urGrUdj5pv0=;
 b=NVQMdXXg/2Fe/Or5zC1HhEVsaQdVtF4pnaqOVMmGduHVom4EyUJ2Z8QXf1o1HHwkwbaUnZCUvnW7zC/dJlgvwZGuZx02m5T+uyYg9oWV4EUTAX+tLxxWCnDIhurLC6KRJgBvFMZGrtOoBW8yYJp4ivrrueaqXOhB/mEV5R4446W+ZyWHIP2B/AUp0/XPePr+YGvDuqZBk2YElmaqPjll4n37UlPBlHHEOlnEk8ctc2kHkV3+T91lwbGRe6PlrNoFmCg4251IAdLuo7i4aMzi7klVKRxMLreA1o1qh3wuDR49cNTPDOkt6L1ccUCYShQXTEtMqF1mtkOzqsmMcp/uwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fo46wYhGSfuRa7mKbyPykIVV4DNISKs3urGrUdj5pv0=;
 b=aa7K8Yrz/MwiI2mQdaAsn8LVCEJCM8lzEtzBwqATs0n7yhMBMT8WSOFmhE8rVMpNJ8ya582KrMDe3IantCnWxkSP7+sVtN6JfF1LrfuY6H/aFQnkRL2co8527cyhxbSnlFqMh4pyqLX2vb8d8L/SRVB3bWlXJmuZUfgq/BDoetM=
Received: from AM6PR04MB3976.eurprd04.prod.outlook.com (2603:10a6:209:3f::17)
 by DU0PR04MB9297.eurprd04.prod.outlook.com (2603:10a6:10:354::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Fri, 21 Apr
 2023 08:31:02 +0000
Received: from AM6PR04MB3976.eurprd04.prod.outlook.com
 ([fe80::6f90:a64f:9d36:1868]) by AM6PR04MB3976.eurprd04.prod.outlook.com
 ([fe80::6f90:a64f:9d36:1868%6]) with mapi id 15.20.6319.022; Fri, 21 Apr 2023
 08:31:02 +0000
From:   "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Simon Horman <simon.horman@corigine.com>,
        Camelia Alexandra Groza <camelia.groza@nxp.com>
Subject: RE: [PATCH v2 net-next 3/9] net: dpaa: avoid one
 skb_reset_mac_header() in dpaa_enable_tx_csum()
Thread-Topic: [PATCH v2 net-next 3/9] net: dpaa: avoid one
 skb_reset_mac_header() in dpaa_enable_tx_csum()
Thread-Index: AQHZc9tPwYoVarc5N0Og5rLCHPIcdq81byww
Date:   Fri, 21 Apr 2023 08:31:02 +0000
Message-ID: <AM6PR04MB3976E820244F4D104EBF3E92EC609@AM6PR04MB3976.eurprd04.prod.outlook.com>
References: <20230420225601.2358327-1-vladimir.oltean@nxp.com>
 <20230420225601.2358327-4-vladimir.oltean@nxp.com>
In-Reply-To: <20230420225601.2358327-4-vladimir.oltean@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM6PR04MB3976:EE_|DU0PR04MB9297:EE_
x-ms-office365-filtering-correlation-id: 25069d39-ccb8-4a3c-97a0-08db4242bdb4
x-ms-exchange-sharedmailbox-routingagent-processed: True
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /IYKHAve0cemInKg26nNNhKttsEmSa/EBFHuRPtSWCrNtifItJNTe+AhG2tQXWs+K1Wq8c6kVA6AG2YPiwZs9slQWi3/WSL6SEjx2qED8on8pTfh8Zax+dFA5qjDauV1MtgY+8BVo0n3x1LTlo7q264BtX/Akb9iGDD3mwW03EQCLMCR734qWEJb34l7e2BfpYLic24uOzeQMpzpgDE2KkBNFj9s3Ar/AZgZHghSaRzs33ibr7t0QCej9+rt6C74ryYGeCewVjPQFaVqoE3n0ohBF7GI0Mlt5tlzeOXQcG4nrCdlSqPG9me0uFhujmxKTLJBUreAS3qrcmuPGbyjexneaqVbKVv38Luh4Nkdl6YCF1az58bags1K/VP3f22X3CHLmCRU+tGY8g5huPCiPTeB2tNeIvG8bC3YkDs4jASpJaK34e3A9j7G/48tXCt095T2Bg1KQoSkjcY1Ox+lucy7nHG1pSJLmXs91iH0peiN2rJi3gBPEYWusFFtQwDhGJ6e9wa+26aq8rqBXXGHDpA77C1TMXEcUmod+cuRaWBJT1sqKraODJ4AA586WUJFReBXQfAF6Pe3zwKa/dVQxzoiaToci6DzhgkTIJeojYeXFI+c32H2yXhwFyUuPjJT
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB3976.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(136003)(39860400002)(366004)(376002)(451199021)(53546011)(6506007)(26005)(55016003)(55236004)(9686003)(186003)(54906003)(33656002)(478600001)(110136005)(71200400001)(5660300002)(7696005)(38100700002)(52536014)(4326008)(8676002)(2906002)(4744005)(316002)(38070700005)(66946007)(64756008)(86362001)(66476007)(76116006)(66556008)(66446008)(8936002)(41300700001)(122000001)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?XitSa7y3ONwh8w4TIRWSw6AGzo73HtpaMvU/Q+FnrH5fExttyxjrgfg+A7D5?=
 =?us-ascii?Q?D+cbK3x9BYZRk3TEqOh6PkK+8Ygfw2o+uVb2pRqG1CuczgpDxeIhQNtfWWRd?=
 =?us-ascii?Q?l8h5KvxvOgAU+fQMlTWiaqQgYyElc1ZPi7Eq9XCLFTZHE3mleNbV2G1Jl1lD?=
 =?us-ascii?Q?WTggb7KQ03pTLt1xxgpHV7lFV75YbbtGutik0iEWffGByI5lRbS2WC/UzCMp?=
 =?us-ascii?Q?PLDiL7QABpZLXUqEiogIRUNMYn44QziahNdk7BpUfgtxe2YrqaxhdY2lVoe4?=
 =?us-ascii?Q?4LNtcyKQsiKNXfhZV3cuxxe1O+679udjoLg99C0Tx1AKu7qVvxaaExvMH/Su?=
 =?us-ascii?Q?I7wmZ2JDG0OHCi0OY7yeRCS7qrVvsrTPAghv9T2MEH5lRVwQyQWul4Cuh3d6?=
 =?us-ascii?Q?Co0fNvkxMsOEfcuhae5EyC3/cUySs0CQGL/ENPLmoeNSYfe3KPIINhHA2cU+?=
 =?us-ascii?Q?u/TSVC5ThB1c3Wr3of79TxaA5u04gE/3Si7pj8RJUJ1QCwBL0mV3AclgYAkm?=
 =?us-ascii?Q?572UQ5IrFq++5PcTsqXgbADwUvm3KQfiCS17DB2r0NEKtJxdKbtqoFBJqnxb?=
 =?us-ascii?Q?o6j6fy+YqFb88Mh/Qp6QJhfkhGfMLjFzwy6omXndcUpTwti+BOY8jjz+eu38?=
 =?us-ascii?Q?7dqz9fMC/AYMysXJdVpCTa7sAIRlrbZZsjSutn6MdZv5sdYUiJNMLLrMY1ls?=
 =?us-ascii?Q?nfC2tWmUWi6pLgRI+Vp1RblNOddc9aYUOH24RsxIijkRQCIUDAz2VDuhk23J?=
 =?us-ascii?Q?0fXAzhX7+wqWXCMKxFlWUnQJ0PQGUjpRjOxdDGu3/WiRyKUvJ4FZsULKlbcT?=
 =?us-ascii?Q?9QPKqWujbK4mTX7f2rd9AKgZ3staFMjomb2m54E3Ns6ARDd52/7BvapjFQFN?=
 =?us-ascii?Q?K7Gh/8InP4WZpSXdV97BSaaMLvF0RboRWHNjpRQxATu1bVSjkVsNHRlOTcXt?=
 =?us-ascii?Q?3/B+Hxtoow9/lEMIlwLfPUU1lOeNEEp8p7qfu7akZj5Jt2+i42CeGS4xj5aP?=
 =?us-ascii?Q?8MF14S/mQpf17INPo13XRFuCf/XzghKFdnagMesaoIHwywhsTHHBfQV4gw3z?=
 =?us-ascii?Q?8nUTPQ0Kss9vcmC8kOQJD+sxRcaTWydbO3uMuUsLqf4PEIryrDfpEfRX1sbw?=
 =?us-ascii?Q?P3y58+G0pRRDhukR1mkRorNvijdlIqbCuzK3L6y4XfPI05e/EMTroxYkD63m?=
 =?us-ascii?Q?BkVwZg+y29T3IymFJi93pdKJy+WvriP1ltF3KD2O9Nao1Czps8+28GSw1MlB?=
 =?us-ascii?Q?4aF3uSgmYmugJkJlr+ucTjq0V2w3kyr1M/fxTDR50RIkWtV1tog5iCZzquoy?=
 =?us-ascii?Q?GEhg0VNd5H5OND0Yozevu3yeyYdVUmqHQ0Zbje9lw+KHLenJ1v+fGEmGf3io?=
 =?us-ascii?Q?Zhdwd8KOFIWG1DFs6/My1L0fqBntvaSyPMnI7DzKfUDVI6IrLWcJN+2A3GUT?=
 =?us-ascii?Q?EfsKO7Yybp7xHOZvId5Wn6bwlWYihjS2XxXmr/mcBx2vMQ7yiDXqGQtXiX80?=
 =?us-ascii?Q?ku7u4Sdkm4iS/fpNopsXjkw0rJWVgYIMyc9V7nqdeJ0V9TKh5M1QhMycQ/o1?=
 =?us-ascii?Q?3NdyjvXxqtmlSqW+h9GW8nf2b+wIvveUU7MM+ESR?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB3976.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25069d39-ccb8-4a3c-97a0-08db4242bdb4
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Apr 2023 08:31:02.0956
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mz5Aoc/ByP/oJFvmI7+4WjMHyTdAA/gRluCWwYQOu68avlpgF3UD1vh/I3kzKcXD7BFtxrH9VLGp11XrtiPvQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR04MB9297
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> Sent: 21 April 2023 01:56
> To: netdev@vger.kernel.org
> Cc: David S. Miller <davem@davemloft.net>; Eric Dumazet
> <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>; Paolo Abeni
> <pabeni@redhat.com>; Andrew Lunn <andrew@lunn.ch>; Florian Fainelli
> <f.fainelli@gmail.com>; linux-kernel@vger.kernel.org; Simon Horman
> <simon.horman@corigine.com>; Madalin Bucur <madalin.bucur@nxp.com>
> Subject: [PATCH v2 net-next 3/9] net: dpaa: avoid one
> skb_reset_mac_header() in dpaa_enable_tx_csum()
>=20
> It appears that dpaa_enable_tx_csum() only calls skb_reset_mac_header()
> to get to the VLAN header using skb_mac_header().
>=20
> We can use skb_vlan_eth_hdr() to get to the VLAN header based on
> skb->data directly. This avoids spending a few cycles to set
> skb->mac_header.
>=20
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Reviewed-by: Eric Dumazet <edumazet@google.com>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
> Cc: Madalin Bucur <madalin.bucur@nxp.com>
>=20
>  drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 9 ++-------
>  1 file changed, 2 insertions(+), 7 deletions(-)

Acked-by: Madalin Bucur <madalin.bucur@oss.nxp.com>
