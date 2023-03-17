Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FE386BECCA
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 16:22:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbjCQPWD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 11:22:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbjCQPWB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 11:22:01 -0400
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2058.outbound.protection.outlook.com [40.107.105.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DDDD6422E;
        Fri, 17 Mar 2023 08:22:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I4RYyCDLiQBDxeELwHDsGiEzDyEV5jQ7UWMU0KE6brWnvIXwqMALVLZYr6LHRJtPbAU4SSSZEqAU9ePVY5YvzPgDV1cwNRtAbKr1h5WzN95kr2mkt1ySAfh3IHOe9qDi/AS5EJZUkvpHymSMgtkRuOWzMSNhjX7R3wLu+309QhqseXiUb4URVN2CBmJTfLIMV+FOms38hnbyFGDGqT5Z+88tuvpd+ui11i7Ofb28RayTntL6fPQd4CPc7wDzx5qEUPOuiWplxYFRpZ2TGw6770XuuKPpl/R365pPnSI1jNLccl3g3tOShPF8pYAse+DpadNGbapHnKJfJD+78wWdZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ynh4JVF/ku4v8boG8wlhiZMLMompADwYVzICXXkKU60=;
 b=POcZ9FSmpCG3qQ3jsQQAdJ/4yJk286wtz0JuPE7AK3bIroaARFetq/eVo/jMTeyU6EAxWXZz092oKLj4aaXPD71k8Ub+Biu96Xp4Ys9axFs6UOTbLRF0Ap6g4AUEOSASOOVxafAR2tmPYmqfGKUY1QJYCijN4DwS46KEIrDOchYXOIWbmBFU6qmtrqBgAM3NIZK0ck4x+9H+KmW0DI0Uf7aqsaPO4yp64nnJJ4tzrYfWzhA+J6JSJxMPrHAKnLmKKbq7Y79EnuY7BTzk/tKntm3n8cphif2rKHY0BigKOfCacp9KojKpq7hWHrzvyDfD50dptsWtxBlYACkxcOdyeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ynh4JVF/ku4v8boG8wlhiZMLMompADwYVzICXXkKU60=;
 b=NqoT5zR2ymTC+QSVGErtnd/nLKVwbgOtitxbWNCjyBIv9T2qSF/52ICSQOt2xUX9KLC+qEj9k4qQ2oj7zdK7VZ/gvn1tD6SR8c6RZSKIhb9cChAeavkWWh9YAPDJJi8dkmmIk8G+Go8fllLemPHflwjofrEKUAs6iXdLZbSCkkk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6459.eurprd04.prod.outlook.com (2603:10a6:10:103::19)
 by DUZPR04MB9968.eurprd04.prod.outlook.com (2603:10a6:10:4d8::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.35; Fri, 17 Mar
 2023 15:21:56 +0000
Received: from DB8PR04MB6459.eurprd04.prod.outlook.com
 ([fe80::e555:cc9e:b278:15d9]) by DB8PR04MB6459.eurprd04.prod.outlook.com
 ([fe80::e555:cc9e:b278:15d9%7]) with mapi id 15.20.6178.031; Fri, 17 Mar 2023
 15:21:56 +0000
Date:   Fri, 17 Mar 2023 17:21:50 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     =?utf-8?B?S8O2cnk=?= Maincent <kory.maincent@bootlin.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Michael Walle <michael@walle.cc>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-omap@vger.kernel.org,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Richard Cochran <richardcochran@gmail.com>,
        thomas.petazzoni@bootlin.com, Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Minghao Chi <chi.minghao@zte.com.cn>,
        Jie Wang <wangjie125@huawei.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Sean Anderson <sean.anderson@seco.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Marco Bonelli <marco@mebeim.net>
Subject: Re: [PATCH v3 3/5] net: Let the active time stamping layer be
 selectable.
Message-ID: <20230317152150.qahrr6w5x4o3eysz@skbuf>
References: <20230308135936.761794-4-kory.maincent@bootlin.com>
 <20230308135936.761794-4-kory.maincent@bootlin.com>
 <20230308230321.liw3v255okrhxg6s@skbuf>
 <20230310114852.3cef643d@kmaincent-XPS-13-7390>
 <20230310113533.l7flaoli7y3bmlnr@skbuf>
 <b4ebfd3770ffa5ad1233d2b5e79499ee@walle.cc>
 <20230310131529.6bahmi4obryy5dsx@soft-dev3-1>
 <20230310164451.ls7bbs6pdzs4m6pw@skbuf>
 <20230313084059.GA11063@pengutronix.de>
 <20230316160920.53737d1c@kmaincent-XPS-13-7390>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230316160920.53737d1c@kmaincent-XPS-13-7390>
X-ClientProxiedBy: VI1PR0101CA0045.eurprd01.prod.exchangelabs.com
 (2603:10a6:800:1f::13) To DB8PR04MB6459.eurprd04.prod.outlook.com
 (2603:10a6:10:103::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB8PR04MB6459:EE_|DUZPR04MB9968:EE_
X-MS-Office365-Filtering-Correlation-Id: e4c372e6-6f75-427f-f265-08db26fb57c8
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QZ86Xo49oNWATKhP5asJNbPF5lLYLqP9f1Ilv6GkH2XVBFVmPo2gm68Ojc6BwiRRTPpuKbjPLj3q7XCH78RfCuFZ3dt58UlHwfwjFwf+ERKic7zQb5rPNXT9x0prWWJwwq1Gv3GQPt6Pg91jWb2YREPwuHcoLMPzi7oe8RxoggJzOKybM2FtmWrF+1FVfMFIKS77QvY0Df7U1Vmu5X4xNUB3VefAXOkS2gRW2WRvamVV3YsLb1VVZk3abkuY8gnkUkz8MtdOSRhmDDiuzc8ANjnIqoWSLXjpWU04ybJfiHU0HN2X9GAtFJS6DOXVZ0JyzzIclwoqIBWfo8jenkJEhaoTiS+T8fqbM/JdrnV9yiPRQzr6+VkGLXUIElvEKGKf6o1Rzwp1qdNVeGxA+2Y6sSza+1xsRZtqoKL9ykPRiSkK/4wgwppq3BnGOVdd4aMbffYm9mfXE08IowDhbW1ox+mWiELejKdny2JD4csvnmPtddl+pgf5lxef9jmAWpWMFhY4cH1JaEbC2pJUbGAbgjdARmk36DmT1IdHRShbfbclUjMXLH9/BBEYxywfKmcFQ7WlvZ/jCcCuzZuQ2XDkPnbmRK6MqXY0CxuMVUMSWTuKqr1MRzs5mZMfucvUND1wqrfz4+RQ6HSFvd1uJ9Ns9A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6459.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(4636009)(396003)(346002)(376002)(39860400002)(136003)(366004)(451199018)(33716001)(6486002)(86362001)(1076003)(6506007)(9686003)(6512007)(26005)(186003)(38100700002)(8676002)(6916009)(6666004)(316002)(66556008)(54906003)(4326008)(66946007)(44832011)(8936002)(66476007)(41300700001)(7406005)(478600001)(7416002)(5660300002)(2906002)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?/kIXJ85ebMrqdkj46hBZa+zXHsalL8EdVFzMdhUTpG0N0UWCd+QsOnXwmH?=
 =?iso-8859-1?Q?9kEGFNYTLj9wpdthEmPovZcvrE+xTUp6y2skvrhgyUVvhbWeAjp0I9OYAO?=
 =?iso-8859-1?Q?3wSWYrHsqCzJO6qbI3Zg0Q1925tlAoT9rANfJNopLstL4wxSR+8YOyN7wH?=
 =?iso-8859-1?Q?lPHgbNQAzI5YC5d2GiwwQ52FIKUikCnW1U5lieOMe0uL2H4A8apTaGa/3I?=
 =?iso-8859-1?Q?VtOOsVWxSTluisGCwwR28DcDjA44wnRTzvFyDzv/QYX32K88UHuyOivJsI?=
 =?iso-8859-1?Q?lC2PeoSYtLB6cO0O4JKc3LkPxjUtNCDfAk2n8cn358hSBQYFFjFBwhN7Hc?=
 =?iso-8859-1?Q?35oURpTV253S/VRI7D5PRGwTFKA2va06Kz3yJcK9EBkFVcFkHON106e1hY?=
 =?iso-8859-1?Q?x2T1oB/p7x4KDKv/Tkrwx3LbfmmAT095aVB5WbTWUHMwM2hM7SzSMIJZqu?=
 =?iso-8859-1?Q?v36SXtsrYE1PL6ouLnXIJG+XCg5cmJFDtn2TbBbaHEUgC1k3qL9ILV/7pp?=
 =?iso-8859-1?Q?X/h+PZghiS7bUnsvKnBd1rdIaQygRwu7ZT3vkpmJMyq2MH7t5cVS3NX8hs?=
 =?iso-8859-1?Q?l7zSwj1qaVWMVd8t9Z8p0Fm15DH9T/AVt74lHdc7mHSa+2gyIRiA05By+q?=
 =?iso-8859-1?Q?7mxhyG+uvRuLMsXYRAwVvrSpwLjMyyc4UY3Qxo00MgUesJ3bJHGlef17uX?=
 =?iso-8859-1?Q?LvhmYRT28/eXTqTXKqw/DXYYo3t/6TGL2Lupd0uBpedKWPul3N4lZn8FPo?=
 =?iso-8859-1?Q?tsaZXdw3Z5v+wYznYVMZLZA3i4Q73JDtJYsBQecLbk/mQzrP06p9tNDkGQ?=
 =?iso-8859-1?Q?nAdrzFro/QNuW6TVb1GJF60UbdxuKzT9gn85yLDtfcY4ErYylrHcupS6aD?=
 =?iso-8859-1?Q?jFsEFUS7Fs+x+UY/7zvPMN1W5v5mbEjX6JUvOMEDJXCspjXPIw+Z8MtIkJ?=
 =?iso-8859-1?Q?iaUJczDbBgG6D0CmrZW+2GQSpijrFgk/HiXTr2MXVsv/6IqWLSeZjhBImB?=
 =?iso-8859-1?Q?Xi2Xptnwtv9MnHpkhAiWyGyDLGiUe2KwMsbbAUB38boVCjMg68AUQpaZ6h?=
 =?iso-8859-1?Q?ZPX3uZ0TDv2XPToGv8BkXdfoFZCu8piLpbwA2s2sGi/dpUh6VL7qxxqgdH?=
 =?iso-8859-1?Q?HLRH+dDPBr27In914VPTg3xXiDBvC1B0m25KDgcQy4i5ux+o4COqbyq7rG?=
 =?iso-8859-1?Q?j7Ep0JrUShA0OvtjRDtl5d9YSS2oM+/tF+20ytEMfyRYcK9A749dPrz+5g?=
 =?iso-8859-1?Q?K5jwM5XermgGAkf7TSTKmy7S7VMhDwKFiQgN6eko2N9WkwdrwjjRFqlBCj?=
 =?iso-8859-1?Q?APuBN2YnqxhGvAu+VrqlqRTr38xYFWmhzfiHPNkZec1vSyS8c+tttw/aAm?=
 =?iso-8859-1?Q?3+Og9DScr2UTIGqtKf1FhXi0zsLiHEUyWiVVOGTzI0jtvEnrq9u7+fPbCs?=
 =?iso-8859-1?Q?CKhi70+xNE7fyB1Re47ZWQJxUISmXayRc8NJvnNqsfJCWT1ro6fNQHXNQM?=
 =?iso-8859-1?Q?H0sRUPBCZtQZVvorgQg0qcH5y1gy9liggux3BJ6Hq4tacgS5Gpbu7yexpk?=
 =?iso-8859-1?Q?ZQ/2nFgsO6lJQq3xqb3ABK88qzs86+3mTDwubgfLqJR0PlFjSrO4l3tiC8?=
 =?iso-8859-1?Q?KLZV2IYsS4Kd6RJ7RmMmXsvxR/23FX2RFo/0nyQ2ynn4fElWaGAM8pkg?=
 =?iso-8859-1?Q?=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4c372e6-6f75-427f-f265-08db26fb57c8
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6459.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2023 15:21:55.9490
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3hGvgJqbPgz63ju0olefHTSsfQE6HQgPt0l+0P+nZaX9c+Yu5VcgyoOWIXA20kjgs3w4LsCDCVKN2JopDrK8/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DUZPR04MB9968
X-Spam-Status: No, score=-0.4 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,RCVD_IN_VALIDITY_RPBL,
        SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 16, 2023 at 04:09:20PM +0100, Köry Maincent wrote:
> Was there any useful work that could be continued on managing timestamp through
> NDOs. As it seem we will made some change to the timestamp API, maybe it is a
> good time to also take care of this.

Not to my knowledge. Yes, I agree that it would be a good time to add an
NDO for hwtimestamping (while keeping the ioctl fallback), then
transitioning as many devices as we can, and removing the fallback when
the transition is complete.
