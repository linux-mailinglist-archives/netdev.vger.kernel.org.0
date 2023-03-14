Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 239846BA016
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 20:53:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230098AbjCNTxo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 15:53:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229946AbjCNTxl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 15:53:41 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2065.outbound.protection.outlook.com [40.107.6.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4124C1CF7C;
        Tue, 14 Mar 2023 12:53:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VJVi4Xo5tQUCiVCEkAk61y7bEj/fA7KkVKxZYZyFlnpmy+KFYokeP+oj+UxvU/bZ06PL/OE0/BiVfB8FFpfwnLugd50Od2+g7WnElk/L1sIjvO0v2vJcxvAFjfZ3HIZR4IEnLQTJ58zfUK25jOqT4eWXy128VLDn18+MjjMoZS6rKD9AWxfwH/hK5bhHHO003EW20/9KdSXjZQeiunjyKHO2DPBR5hlrVmmvpex67JcKcU6rM23g2l1KjHE6Dl+mv3TcYFzUDlRQ6dyM0+LM7Lw/MPGI6Oi4Ud1UgKyI2eH36BmYl1kBmealpoVR6Asoz66LJTK3bg/CS9Av1gcN6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=miaZJb4PZsa2Hwm97y0rCb7WKkOgjMPcOqjtuUXZxmw=;
 b=oO7nx/NrdBI8o3Jdae3qrML879xlHmb6uKVGTvhD9DQOLXoFA7dyKadF93achxOx3bityMdhqUJxVPs8RodnsDP9+Qv80CntsSP232XrBa2HxBdJIKymbRMzoXcBjFHWsUdypnY5bmICqL2q/wgskqYUTScpSgQFmdSBkOmEcme51Quim/62gn+2Nb7gR9vl4FGOtvKm0Fp+QTpeCK1P/aVpeOF4bi/oFg0Di6cx3TTa5SVqk8i8XgclRFr1bZ0vrYbmExDAkJToqCMrDZTxUixHC7WeE9JMDLZYoGrdJfz01lpE/I2aPvtlbd+UyGDozdeoeFLDyv3YuEO4k/6TGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=miaZJb4PZsa2Hwm97y0rCb7WKkOgjMPcOqjtuUXZxmw=;
 b=fGFHB+3jbw8UtRFRKEOFv58adBkFBSr5awMmd4cEqZszUe9oGGfRTXGbeWEE3VZCblfopKVm3TdjdEtmWHJ3W1TJ+1fhI12muNZQ1Wqh6EroAHB4cuvnCfF7gWGwrdADF9nocvr7WebZSw2V9z9URhHHJh6vzo+Sn6w/dpAFhU4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by GV1PR04MB9088.eurprd04.prod.outlook.com (2603:10a6:150:23::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Tue, 14 Mar
 2023 19:53:27 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8%7]) with mapi id 15.20.6178.026; Tue, 14 Mar 2023
 19:53:27 +0000
Date:   Tue, 14 Mar 2023 21:53:22 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc:     Daniel Golle <daniel@makrotopia.org>, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        =?utf-8?B?QmrDuHJu?= Mork <bjorn@mork.no>,
        Frank Wunderlich <frank-w@public-files.de>,
        Alexander Couzens <lynxis@fe80.eu>
Subject: Re: [PATCH net-next v13 11/16] net: dsa: mt7530: use external PCS
 driver
Message-ID: <20230314195322.tsciinumrxtw64o5@skbuf>
References: <cover.1678357225.git.daniel@makrotopia.org>
 <2ac2ee40d3b0e705461b50613fda6a7edfdbc4b3.1678357225.git.daniel@makrotopia.org>
 <e99cc7d1-554d-5d4d-e69a-a38ded02bb08@arinc9.com>
 <ZBCyqdfaeF/q8oZr@makrotopia.org>
 <c07651cd-27b4-5ba4-8116-398522327d27@arinc9.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c07651cd-27b4-5ba4-8116-398522327d27@arinc9.com>
X-ClientProxiedBy: AS4P192CA0023.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e1::9) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|GV1PR04MB9088:EE_
X-MS-Office365-Filtering-Correlation-Id: e50a914e-ab2d-4382-03d0-08db24c5c72b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QveSU+4/1TzNL1BIUPJeDWTSuMVjO1nDABoe1F+ktkLrsYbBNNFRWZAXf4IJ5U5h0eQ6sA9Fu6Isag78vHXjbndA9rLwa3h16GE6MUYGjJ+/dfoRhxtsMsFOIbjLuNMeKsBgxH3ars60VgQhfn/w1eh5Guy/BHU69LL6P6OwsvoJ9UhSVvusqw3AF1PjV+pcc5LEfYtadX2D7R0iSoNnofIjSXIR720udpc3gL7NvWghmdjJozn/sTQ85dFixf/qHz/uk1blRKoglfUXJcFILj53gvh2XdLVRcHbQmguUlD6TEKLXODP3+wTV0GxJ3JaH6VZNvq0sOMsB5q2jKwbwRyZN9806ylauEnYPtB/s1+Oijmi11z62MyNxe05CSjEe6dY6ZRndUQlVpwIgQWEAMZPXa3FKOe6AMJmTrABM6y7cuV55Hefl/nC3N5a28FJjC1wCUtbNDogyWvM8H9K5n8LSL1ThMvfVtEZyES+GMQ4BxXvZa56AaBeIAYOxk/imjsanMmW7qhIwvzLqu/I/xVcIYJV7VhkIOMLjyx3O7rxLd96/t3DTL3TJas9nYGV23m9kD1N8aMJqWxGJrH8U8NNFRLN0BcfdjXiQDj/1G0gqYR5OJGQUCuBTstTLA11cMKGhppnJ5/H1fJ+mQpbiQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(7916004)(39860400002)(366004)(346002)(376002)(136003)(396003)(451199018)(7416002)(44832011)(4744005)(5660300002)(8936002)(2906002)(41300700001)(38100700002)(86362001)(478600001)(8676002)(66946007)(66556008)(6486002)(6666004)(66476007)(6916009)(4326008)(33716001)(316002)(54906003)(9686003)(186003)(6506007)(6512007)(1076003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b29FSmlhRS9UN1ZFOTF1ejJtV0VjYnppeVI2YmkrS0hMNDdYQkZLbjAveGd5?=
 =?utf-8?B?aXJxM2hIdXZNZmkvZ0VrOXFvMjdHVThzSkloeXRpL1VENXhtcWJBaGkyQmMz?=
 =?utf-8?B?QXB6ejJLdHhleGRRYmlzekdaUy9yUjNSdzlQTTdVV2V0QXVjL1U4MWlUWTRp?=
 =?utf-8?B?Y1hPVjl1d1BxekRYZXB2d1R2aDRLZFlHQURQbG1VS1V2OEJUdXRsdi9KNUJh?=
 =?utf-8?B?V1dvM1FIZjAvM09VN2p2Wk9DMVRGNDZRc2llaFhzenptbHlabDRxajQxMHNB?=
 =?utf-8?B?Wnh5ZEtGUjAva1J1TzdXMUQwN0d3SnpVNHFCT0VjNWVOTkU5STJhdHNGdFhz?=
 =?utf-8?B?bm1VbjZkUDBqazZyelU5Mm94YlZWWm9SK0Nzb3BWWCtLbXpLQkpCeFY4MGNX?=
 =?utf-8?B?OTZBUDRrN1JUSDRLNHplUHg1bk9DeGM1eVd1WXo5UHo2Z29jWHluU2VDSE1M?=
 =?utf-8?B?SGg3ZXFJUEhIamZJeXh1K1NWbUJqdnFtR0Y5dEV4aDdiMHhFK3owUnI0c3hS?=
 =?utf-8?B?TjM3QUdYL29NaDNDS2tLWUdQNnp1MWIzb3NxL1ZiWDd3dXZNZjVoQWtQL053?=
 =?utf-8?B?emVDV2dyU3U3NWFzWDRZYUtjM0Q3dFdiSGFRVDNMOHB1Mkc2SnltN01mMkRR?=
 =?utf-8?B?NWFLK1lwQ1lXeFNjMCtUUHdoc0lMOUZXbGQxYmI1YytmTE53YWJBYnowMU9a?=
 =?utf-8?B?NG0wR2RNUTZlbXdKeWFIdWdyMm00dHdlWUZqOTVxNkdFdFpWNHJXVzBKeVR6?=
 =?utf-8?B?YURwbWIvbkM5ZUM5SjJtaGlmQnNtd2E2RW9hTkJ6NHliT2lxYzhWM2lFMVp3?=
 =?utf-8?B?UjJnV2I1QnJHSk1aQURjdXJZd0Q0OUQzQnNqckYxYWlZMzVLTUltakczc1pI?=
 =?utf-8?B?OHB3Z2FmamFLbXZ4b0NnVXJ2MEhlYVk0Vm9HWHVOVXNveVM0aFhiOEV2UFJE?=
 =?utf-8?B?bWp2dUkyckt2WWp0WWYwcUx0aDlacmgyRGJ4M015WnBydmJCbjNURjRXNTZv?=
 =?utf-8?B?cVl0Y3B4blRVc2xzcGUxMlBXSndSWmg2S1REODNuUXl6WGdJSWxwMnNyOWls?=
 =?utf-8?B?V1NkeHl1Nm83dlBvTHY4YUd3R25lUitMdUJaUU1MNFBtS2JsbXhjYnYvVnBC?=
 =?utf-8?B?Qm5ZNGtxdzhheXVvdlUySDBrNVdKOS9ONCtWdHNRcWdaVll5ZTgwdVdFZGl4?=
 =?utf-8?B?WjFVUVZFaDhXSXJPUk9OR2FOR2ZHZE9PT2hzaWNodXFRWXpXTys5ZnNiZTBD?=
 =?utf-8?B?bmFubmVKRVZCSEpLT2prdzdpSm9sK3VPaDh2MHkwRGgwNFhLMU1JWE94TXVP?=
 =?utf-8?B?RDU1d2J2VTQxRnp6WFhqeUN5Y1VMYnBZUWxxbVQzQ0twN216T0hwTVRWSHhx?=
 =?utf-8?B?ZElLa2JqVFhLYUNIbDM5c3BUM0x1RjFXeGFoVmxIMFRkUDZQRGNRSkE3ekJX?=
 =?utf-8?B?WVZpRS9kL2RYWngrU1AwdzMzOTRLQWI3WWh1UWxBdnBNU0NhSkxwWmkzSFJ5?=
 =?utf-8?B?TklBUWk1TWpzVjh2elZrMHJVZHZ2V0VEYi9jOTZ3ZXE1QmorbXFBZG1UU2E3?=
 =?utf-8?B?V3dWMm5jZmZXeVN6aDZsNFI5N3hTMmkyQnpGcm1BRE84b0xieHo5emgveW4x?=
 =?utf-8?B?aFF0VHh0K0d3ZmNWcFZ6QzlvQVROMHNkcU1WSTAwN05RaGNUalZFaXc1MkVr?=
 =?utf-8?B?ZDBpNDVyQTVkMHJLWldRYmRjYnZGdUVBemtJcWEza3ZqbWRBUjlITlR1SWJY?=
 =?utf-8?B?bGphNFVCenJpYklNWko4MGU4cGNBK0E0VFUzT1dRTU5UYXB3dFBrcTJUNDhv?=
 =?utf-8?B?ejN6UDZGMlhBNmtEZ1hXMG8zMFJkaDRtcGpnZGFkNzVTL3o2NU4rOVZtbmpi?=
 =?utf-8?B?VFhMS0k0c21Ec2NIdVNPQS9CVm82VkdsdStnYUxoSkcvRC8yY3BzcFdVTjli?=
 =?utf-8?B?enBpU2pERHgwczE1akJ5SUJudHB1Yy8yckZDUkEyOHhtR3ErdTdkUzJFVnJB?=
 =?utf-8?B?Y241Vi83Rjlab09EalhjcFlZZFdydTJZY0N0S2tOaDMzY3hyUVpCVnJkc1JC?=
 =?utf-8?B?QmcwaW5HeXFCVnB2cXJyUWNqRUZEb1hLbWVpeHh3RWw4elZ0R3h2RG1wWmpD?=
 =?utf-8?B?ZnlEYU9EeHZIMVhqUEI4RksyU0xWQkt0RHhna3E1UFhlb2czZjFUT0xDVWZZ?=
 =?utf-8?B?Qmc9PQ==?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e50a914e-ab2d-4382-03d0-08db24c5c72b
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2023 19:53:27.4355
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SBiPiLx/UklGNEHRL1LRRAdOXqYzzi8waHFAFQUmuMYd2Ckm2Fifv5QGCb+U7JoYiAYThLnkA1kU0iWFrMC+5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR04MB9088
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 09:21:40PM +0300, Arınç ÜNAL wrote:
> I was going to send a mail to netdev mailing list to ask for opinions
> whether we should rename the mt7530 DSA driver to mt753x and rename these
> functions you mentioned to mt753x so it's crystal clear what code is for
> what hardware. Now that we glossed over it here, I guess I can ask it here
> instead.

My 2 cents - make your first 100 useful commits on this driver, which at
the very least produce a change in the compiled output, and then go on a
renaming spree as much as you want.
