Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D41536B4D7E
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 17:48:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231786AbjCJQsH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 11:48:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230204AbjCJQrm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 11:47:42 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2064.outbound.protection.outlook.com [40.107.20.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB0A82822D;
        Fri, 10 Mar 2023 08:45:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZV19TXpgq8fPlkOJPgYT+H2eXBhC7oDDqdmzA8gMi47pHgK1ACsBm997y4HAbu84Mo64w1Ec5cb7B3XNM/5rZd4f1ifp/BH+T2R5VYhiie2SXdLUcM51s3pJo/kWoCSKmzaCU4VraGly+ljZbDzwQFKYUyDzrHa2OBHRpU8vAdLMA2aJ18f1aCDku0XVFpF0tmiJmrwjcNWwaSI609xU4NEJfsQTITP1qHAP7DGmaIsdh7gsVw3w7N9DYZL0fyTKSkOuAtl5FshVzcHd/M+EvmsyVK8R7VC1eMjBnduBYlZHfSiTFw5iQl4dtND/4W8PhtxmLtHtwTWf0uE8KQUbYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=isGOVJZ9naLn1JJzT2t6A+9jGlJwqy0JQk/Fn7Q0mlw=;
 b=dNwB0t6BWy0K4idnT1swPcw9cU6cja0uJeZoDrlYLRSLlp/qOYZ0bE1RDiMKPpkC5UdMFuZQhLM9oot8yYdbw6ywLI3kOu/0GUMy8cycTF4ECipAMTV66sQ7LtEGkLq0FWNsM/HlZAi3D9zJ3/J6zn4kyqQ4CH6ClkIB6PesCgu0aPEU76vO8IALSZhLi03XwIJYd3wUsPK61Tpc6k0wR7/9KjG47CXgNxs2DgqHwojEeZNrHsroplGMohmOF3XYNU5U6PHlat/q7IyMRKaG62rqTshU8xqTkS4bdIMFCMkpfKDZ44c0zq1cliDRzxfMCofDWyL1dtm3yBzAeGXLNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=isGOVJZ9naLn1JJzT2t6A+9jGlJwqy0JQk/Fn7Q0mlw=;
 b=SF4bt7PV3J3UwOmOOhCS1Tj98pT8CXTZJGFRafKFLUJ+BhWMaUCIdF30xMJdLaDeQBh5q4qgrPs6VOILKdJmgdhaNG6hjVd4YIrb7cDN2kb0YYssXXb/Tib9c6RaoRW1KtkEyvZ+fXWcgn0Wn3sHm3dEsJ32Bc72fITHqVdcyB0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by DB8PR04MB6809.eurprd04.prod.outlook.com (2603:10a6:10:11b::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.19; Fri, 10 Mar
 2023 16:44:56 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8%7]) with mapi id 15.20.6178.019; Fri, 10 Mar 2023
 16:44:56 +0000
Date:   Fri, 10 Mar 2023 18:44:51 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     Michael Walle <michael@walle.cc>,
        =?utf-8?B?S8O2cnk=?= Maincent <kory.maincent@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
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
Message-ID: <20230310164451.ls7bbs6pdzs4m6pw@skbuf>
References: <20230308135936.761794-1-kory.maincent@bootlin.com>
 <20230308135936.761794-1-kory.maincent@bootlin.com>
 <20230308135936.761794-4-kory.maincent@bootlin.com>
 <20230308135936.761794-4-kory.maincent@bootlin.com>
 <20230308230321.liw3v255okrhxg6s@skbuf>
 <20230310114852.3cef643d@kmaincent-XPS-13-7390>
 <20230310113533.l7flaoli7y3bmlnr@skbuf>
 <b4ebfd3770ffa5ad1233d2b5e79499ee@walle.cc>
 <20230310131529.6bahmi4obryy5dsx@soft-dev3-1>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230310131529.6bahmi4obryy5dsx@soft-dev3-1>
X-ClientProxiedBy: FR0P281CA0051.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:48::12) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|DB8PR04MB6809:EE_
X-MS-Office365-Filtering-Correlation-Id: 5915ae01-131a-49fb-8bdf-08db2186c7cb
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /V6PuMAnwT2CxERZeuROfmZthi4Btjl3kwwaXTywZAKZYRuAfBDw69UudusJlSLLDTfBIHp+lfZ99kkttXVmF5IQcaIu5gGNJc56QjIQLdw4gUXHRT+F3KVL1dDqOJp6GknuRaJOaDBkhiRo1s58nNCwkqjNcYkRcJsWBhDI9PH203ESfKWYn5cjVNNSYinPSgFvNZKVjTjBptdO+InNVcGDU7GauP8tB9paEX2n2Dm9Oo+BLMNkCXisH44udqMa6L+IFmkfvYEDhgcX2zhwI3yQL4JatHpFX2rLedgbJ6FkKzAijoee3DcjJ5zVoRv/WPtZgQXgwNHW+zEZQ/DmsioWIkveN1nVIYBEbYhLquJKYgVBPY/AR3Fo5Cqwp7/I0UKk3x/CfuRY0LWUUG3DjuGJyr5oioX0hqhpio4CiCkK+PTVEt0CnC1Za5IK+gX5uqvNbccD2vFIZrcQAr8PBbajcPjLSlFDdvypp4mMimdnxY2Q0gLF95Iy24Ue1OMQJ7qsMfqJFTSQbJLeqYzTubHYoU+h3NVIQz8YWY9ejTzb9M0FeQw8ZkYRH+8TPTH/JgnD2g96FKUzU8EhsXeiobNUBVTwc642Mq8f3RA/wffkDRHEt3wlGQHrT9ALR4kQKghHGj8bk+UoDFJmK5mkzrK8CQc7HtOKVJxBVa/xjoI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(4636009)(396003)(366004)(376002)(39860400002)(136003)(346002)(451199018)(8936002)(26005)(5660300002)(7406005)(7416002)(1076003)(8676002)(6512007)(9686003)(6506007)(41300700001)(38100700002)(6666004)(66574015)(83380400001)(33716001)(186003)(86362001)(54906003)(316002)(4326008)(66556008)(6916009)(66476007)(966005)(6486002)(478600001)(66946007)(2906002)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?NFDU0DT04K2W5g4sglIcGKUU+gEuXh3+sm+I/VE+zUZs1CaluobWOFJ7iN?=
 =?iso-8859-1?Q?3eOkWTWxgsPwAyFuAAQ2WqLvrM5P9O3nnRVQg8W61Tb78v1beAAHqZZcdD?=
 =?iso-8859-1?Q?J2L6EEI3gXWeeMiilLvhKQFkwvwLG5l3FAztrLTne+MKQrS5gB4bsyMuJV?=
 =?iso-8859-1?Q?t0vW4RHAjTBbRBjXTXXsFFlhrTLovq50Ubl8Xn6GsBIL7FQnmdf1AIUBNA?=
 =?iso-8859-1?Q?PxXv3d3fyooUdii0Yffvulo4uuTElecFhSMGxkJmiI+h2+siSxnOKXJkYY?=
 =?iso-8859-1?Q?EN5mBOXddy63K2ADB2juQyNdlIhMbjXo8HOoyAZRX40W9E4vdpTAfwgY32?=
 =?iso-8859-1?Q?h+QYkbnIr9I79hbZTTRar48Hl0vN3p7F4g9535nqN0PsPr6cAky4yO2HTG?=
 =?iso-8859-1?Q?c1jbATIRWsgcHfQT0EJnvuaDFt4ZVTI4+K+jSCgnT9PxSuelKi6nN3znWs?=
 =?iso-8859-1?Q?d+CSt80rLUAqd1JSYKHtOlcXMPorvabp4D5mIcnNhZhVAiQL7rl6zrQXtw?=
 =?iso-8859-1?Q?Fym4yqqIs3dOZFTl1vaa9tPbWHU3xm6ixGw6yG+YgnLnTQtnsVzXlfk9XK?=
 =?iso-8859-1?Q?WD5yHu57VGM5DB29t98jLZHii/IWYpxip3vf9IUkZsdt9b0JwLsSi3Agqa?=
 =?iso-8859-1?Q?7MKg2/cVqdWnEbHboadl8BTVOnz1h/CdQDI8SvXLZeqO2nvB4cbqcJOyFl?=
 =?iso-8859-1?Q?P2OMj4y9XZ3LTA6lGC+koSfIC27Q15GOStUNk+lsWlz1LxyNEhsEZ9J8iI?=
 =?iso-8859-1?Q?kJg4PmXp8fQ2fmU7DzMByQoo8Yyi7fZgxEjmFtNm+CG3Un1M8h6JIwm6Al?=
 =?iso-8859-1?Q?0asAeddCexkR0VB66AlELrGeIPdnSS2B79rx/jTwzGJKiAsY6ohWlK5h0h?=
 =?iso-8859-1?Q?mOwZENMyneEzWrPWbVW4WrmZQfugEM7w+ociNdQ0pmBE2makaDqL+Gfw/X?=
 =?iso-8859-1?Q?k1EvEFsdJQ6w5MfNkZJXp+jCueCg7Sjabb0lZeArDR/Q1ohno36PTGB0Tl?=
 =?iso-8859-1?Q?DGxkX+eyePfCH06s/ydUdvv3dTZrM86sVHBtI2aOGUgxrxZc/Kg0VaWbh/?=
 =?iso-8859-1?Q?SWBiqyS3jY7rjfNesO9Fk1UYfk1OODVKVelWKMTyQBd8TiKRwBlcovze6c?=
 =?iso-8859-1?Q?mhj7Qhpm15VHy8BRNHh4kWejyRVUszU6SOhxwihvO+IH/A0Ier8myZmKfp?=
 =?iso-8859-1?Q?5svSoKMAGGWOZjyVpRc+FTbnJBhuDYlfTj1Kc/XmdLuY7AVV725fCdpTCK?=
 =?iso-8859-1?Q?3A1ivZA7PKitu1JepccrtT/w+Bo8Xf5K1uS/83WgM3fpBiP3qM2/XlB8HU?=
 =?iso-8859-1?Q?8LRDcET1yDGBiAFmTTVO7+1wZAmgyxnwPOrQuVb36KrliVOPosAVCHMhYz?=
 =?iso-8859-1?Q?HKkPeUJQge+3+lLIeu21i7V5b1+Abla9azFbohyF2A0LrntG+7fNEFNojR?=
 =?iso-8859-1?Q?TEohmSOzd0Rt6g28guxwwX2x7vXtJfdrLUUyYCT1vjRdLpwLgpLzBxfwMn?=
 =?iso-8859-1?Q?Uu7sfNwsUNxIzFZqP76hUyIkFia1l8cEA5q1M4jQ2Pv2IJVSfSBV2ynF1h?=
 =?iso-8859-1?Q?iWTYf+C49UaWL6Mzjqq53h3kezzi8VTeZdee467VHIngrn6AQSO3Ee6qQr?=
 =?iso-8859-1?Q?2MZ/RQlnUtUQ18QF38nDf7Lp37QMF4kuShji2rzfE9yqWNHf4/ZuUQaA?=
 =?iso-8859-1?Q?=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5915ae01-131a-49fb-8bdf-08db2186c7cb
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2023 16:44:56.6428
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iQy6E60hfc7//tourbNfmYQQle3migG4cagN9R88l3REdVlmt2ichdzm8FxAtXVAjyUH1knHcPUFqxRws0iMSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6809
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 10, 2023 at 02:15:29PM +0100, Horatiu Vultur wrote:
> I was thinking about another scenario (I am sorry if this was already
> discussed).
> Currently when setting up to do the timestamp, the MAC will check if the
> PHY has timestamping support if that is the case the PHY will do the
> timestamping. So in case the switch was supposed to be a TC then we had
> to make sure that the HW was setting up some rules not to forward PTP
> frames by HW but to copy these frames to CPU.
> With this new implementation, this would not be possible anymore as the
> MAC will not be notified when doing the timestamping in the PHY.
> Does it mean that now the switch should allocate these rules at start
> time?

I would say no (to the allocation of trapping rules at startup time).
It was argued before by people present in this thread that it should be
possible (and default behavior) for switches to forward PTP frames as if
they were PTP-unaware:
https://patchwork.ozlabs.org/project/netdev/patch/20190813025214.18601-5-yangbo.lu@nxp.com/

But it raises a really good point about how much care a switch driver
needs to take, such that with PTP timestamping, it must trap but not
timestamp the PTP frames.

There is a huge amount of variability here today.

The ocelot driver would be broken with PHY timestamping, since it would
flood the PTP messages (it installs the traps only if it is responsible
for taking the timestamps too).

The lan966x driver is very fine-tuned to call lan966x_ptp_setup_traps()
regardless of what phy_has_hwtstamp() says.

The sparx5 driver doesn't even seem to install traps at all (unclear if
they are predefined in hardware or not).

I guess that we want something like lan966x to keep working, since it
sounds like it's making the sanest decision about what to do.

But, as you point out, with Köry's/Richard's proposal, the MAC driver
will be bypassed when the selected timestamping layer is the PHY, and
that's a problem currently.

May I suggest the following? There was another RFC which proposed the
introduction of a netdev notifier when timestamping is turned on/off:
https://lore.kernel.org/netdev/20220317225035.3475538-1-vladimir.oltean@nxp.com/

It didn't go beyond RFC status, because I started doing what Jakub
suggested (converting the raw ioctls handlers to NDOs) but quickly got
absolutely swamped into the whole mess.

If we have a notifier, then we can make switch drivers do things
differently. They can activate timestamping per se in the timestamping
NDO (which is only called when the MAC is the active timestamping layer),
and they can activate PTP traps in the netdev notifier (which is called
any time a timestamping status change takes place - the notifier info
should contain details about which net_device and timestamping layer
this is, for example).

It's just a proposal of how to create an alternative notification path
that doesn't disturb the goals of this patch set.
