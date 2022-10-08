Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75BA85F8668
	for <lists+netdev@lfdr.de>; Sat,  8 Oct 2022 19:56:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230473AbiJHR4r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Oct 2022 13:56:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229821AbiJHR4p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Oct 2022 13:56:45 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2135.outbound.protection.outlook.com [40.107.92.135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9343D3EA7B;
        Sat,  8 Oct 2022 10:56:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RM2x+VESXSydpxE64NgFretKOqsH/PKUKMx96OQi/XoupFbQv89dVSOv4+RFUoJU3mlghDFionp40aUy4hXn5vQlIapGiTUXxBGOgDNQOcBDFLiFC7sQKSmfm54pHFYpICeZ29qNfeY3Kt5bLG4OAwBr7bT5pbUGBk9mFqQEdI0hRIs/vmBdqc/7+Y3xFEYsJ5uLPhUjH2Tscel+YHsVG+O2al0Bm/Y/1fBi6UDGQB6AubzF3iAMpiyiO9ceH5RhaukHEVMC3Sc56xfL6ecZfGVCC4aK8dedAG8slkKLsXlE61Y0lRlAhVUx9BBt4QAvjUPy3dyqiGirCDJiyH2bzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ggRjSo9QYCQu+ihfHBlFbYvHzmZfaavari42/7Iuf0k=;
 b=R3+hNU5ddlB8K1Rr93BkPagGj//jKhNIGx4+Xb/xHzPwBuA2C4lOGhpblHEnPXiD7f+bXudLzBtv3zPpD2frmUM02HfyeYWYotSL0ktsDLlAfY/R6/qR6y1djMo52cH809tBMi3rgsBHhd3Zg0rl+TiQzlTyWOR1OTSK83WJ4TklEQlS8Jil1ygWXCjebUfQvCcD7/cnVvdLGGTpBB7NSFZrDRKL5iGGsHiLJ/LIlX6Fcx0G887iMhx2Ab7B7wLkwqmtPsK1Chn0yCpeXOdJbNRj1rFxLW0LyftgdaYEn3kQfsV99sxRbXTJIgpAtn3IbFIARnQHvPPfyyIKXfqVdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ggRjSo9QYCQu+ihfHBlFbYvHzmZfaavari42/7Iuf0k=;
 b=IjWI1485/92GZCy1MWyCBlgo8pycoAw7755wU/i3tMnTP7sDEas6Z9FmSj+/rEMLN+EuhkTsWCY5EDtb2HT3w3PWTvPjsD/xO6quTb/Xzk9xhOjlC8lWWa2ESjxaQPerEKDONSimNTUuNbu3tppYJjYJlijBifIYmR2lgj8igdA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CH0PR10MB4923.namprd10.prod.outlook.com
 (2603:10b6:610:da::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.15; Sat, 8 Oct
 2022 17:56:41 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::ee5e:cbf9:e304:942f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::ee5e:cbf9:e304:942f%7]) with mapi id 15.20.5676.028; Sat, 8 Oct 2022
 17:56:41 +0000
Date:   Sat, 8 Oct 2022 10:56:37 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Lee Jones <lee@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH v3 net-next 12/14] dt-bindings: net: dsa: ocelot: add
 ocelot-ext documentation
Message-ID: <Y0G51aZemGsxMLpL@euler>
References: <20220926002928.2744638-1-colin.foster@in-advantage.com>
 <20220926002928.2744638-13-colin.foster@in-advantage.com>
 <20220927202600.hy5dr2s6j4jnmfpg@skbuf>
 <YzN3P6NaDhjA1Qrk@colin-ia-desktop>
 <20221007224808.dgksesjbiptwmqj7@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221007224808.dgksesjbiptwmqj7@skbuf>
X-ClientProxiedBy: SJ0PR03CA0076.namprd03.prod.outlook.com
 (2603:10b6:a03:331::21) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|CH0PR10MB4923:EE_
X-MS-Office365-Filtering-Correlation-Id: 802ec6fa-2332-426c-3660-08daa956742e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FHSqi1GlqVYGDk0i8nN2bGshLshGx3SjSkc+dwscaXbq/hWB4yzln7gySUfkP+/BpcL7TCb1wH1SByLgTTntukhQQUK8Lfyr3y8BGpzxHeHcIxzleVsNQ/ZmXRjIjfbpAihCEu9aL7spFLNc7OjDR/PO0vAzmifcLSPuA+JZ0C9CdMlspoAIJmwbgeCWxUlnUF2+RLbnLCi4qZboRvLKvlcAMUoo2plvNO+mGFIHDjw5aEqJLEcCZzVJy83YvAPEgmpaGzutN62gXhyqlGm5YJUOAUiblWx2qK+QgLAKuSLEbsKrFmT0OCFsLIoEuqNutVFmCruJumKEGgJk8/enwN44AfT14BtktEFW7KhsvwB/yN7MviW3cV65iDpxQEVz7bmAqIQmQN2EfWfoLyyxsJp13dkP+efJ92zIGrmHeCadl9pH6+1lUWMU36soHtFZxs6SJIm1e4z4q0cnJhwnhlYcaHuBUlW0hDbGdKzQfkyFMgg8TcNTitsewGkjK1nuVbyadniJI206PwsXJiHswh5qjDOvlUeymSuBUpLxcTfWboLN5UdtePQ72gFwVx6Lrou2ZBsoQwIZAB6vxkkNeA8wdKEdmFFhC3pHX4n0U9z3HKPZ5Q5qPkP/YFAecibkxhoZiG4JOihAB2aH8Q2nCNbfwnGVVD4DRVYeWmaXQQDS8xlAvzavO4E/uQASL1tCHfvezPKHXReM3xPlAnA/qpQQ8alQY+WkTCtn3RjKHNI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(396003)(366004)(346002)(136003)(376002)(39830400003)(451199015)(316002)(6916009)(54906003)(7416002)(2906002)(186003)(6486002)(66476007)(41300700001)(6666004)(66556008)(66946007)(83380400001)(966005)(8936002)(33716001)(5660300002)(4326008)(8676002)(44832011)(26005)(9686003)(6506007)(6512007)(86362001)(478600001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?09NBc3zasn290zLDGNThfGYkMQOAY+qlEcYCHKKXXVXcmtFBQ8bb0tRAwQWf?=
 =?us-ascii?Q?k3WUgvyPwr3kHHeQqJDFXAKHpMF+J5Tlgr3O3TygyBiJ0DLjCOSx0VfjAQ65?=
 =?us-ascii?Q?KpcPaLi7q8W2SwLvWjORCYs1LMyaoK7PcU/X2m6Hlm4X6AuG5DwQDfPwNGQ4?=
 =?us-ascii?Q?iVui80FQ7wW3L4wONYRuRvhPtitnwg+eZfTUQ+piH5qx/DgTt51EQqEgxNeC?=
 =?us-ascii?Q?LMkIFqp54zAa/Qe3NEu2hRfgd1PbrEviI454s+AUIo+kDMGdkcNtymvVvRPL?=
 =?us-ascii?Q?7m8EHPMZj6wfnxfavuK515cZuqUKGCFRpUzZzCCp6NwvqXz8hLTy56roCwyN?=
 =?us-ascii?Q?CLnHkc2+btpsylnG5rssYerBvwdPHSwiPIlFVU+tws4wQNgbr6yTZ7d0Z/z+?=
 =?us-ascii?Q?gonoIYrloUw7ewPJPSeYitsizKE3QgGbYjO70ire12N6Ild3edY//Ure+uO+?=
 =?us-ascii?Q?ybHnMA/Vv8XkuWaI+Q0sJ05NMCtM2dhtuwgNawIqZ9XeVizf7v6qgYZs/M0b?=
 =?us-ascii?Q?MOz4QCuoVgOLM2J4sOXY3JuztZK0dleSlSm1+f6HKF9pLeIOfE4xH1aTTmUE?=
 =?us-ascii?Q?5QgKSfsdBZPY6jrOT3j0d2vF8gGL/31DCVtH6gaGWUHt8M3rzxBR8sNDg/Dl?=
 =?us-ascii?Q?TUAmbpVKxUqQrq+XHRHS9euYSlTfJMiRKvY3BcagrQyUpkQwBZ7/olXY9csZ?=
 =?us-ascii?Q?r1u6uTKoDypZ723i/zMjLCV15JkCjauDlSWFGRaxDHVL6AB0CA+MIL9kTD0B?=
 =?us-ascii?Q?H8Zsj0OTcb0sSdZQdtlrDsPlGdqSmlDWbThZC4AAL83tWstmUt4Ti59ZF4WZ?=
 =?us-ascii?Q?1IULpCMZRqlIqiY20vVLjySphgYt4tByqv6sqBTOdcWr+LMYbaOEr02+xMQq?=
 =?us-ascii?Q?kRRZY2VCxd8ziYepj60Cafn7nH2KhTnWhkMYgN0aYEH6hB3eIjAauWFY/XVF?=
 =?us-ascii?Q?i7ezeTM68EnG6d8cpsUvTLIkBTmKiUU/8ALG9494eBCNwwQ8ZDYfQbt8mSeN?=
 =?us-ascii?Q?Ui4Ml4YrhtHEzGT5p759E4TrjNXdq0RZhlrd3lxPUc3G2K70UnukQlWAqG5G?=
 =?us-ascii?Q?L9ZA0P3SzcA/3Sz+CHL/g6SREjrvI7uyAsb8ZqGd3Ric+Q2ovHHJfng2lGDy?=
 =?us-ascii?Q?FAWjQjhNNYdH7k1S9Aey+VanKxxV8eLqtmLD0qX3EXTfskUxB5ozH2+c2Rm8?=
 =?us-ascii?Q?uHVnZ68DaBNfR8j42HciNX0ruPuVYfXizmSmU5sNSvnhWaMscjzb+VsfYbxr?=
 =?us-ascii?Q?Otmjp2kSN+UDdbN86BKWznuZjmFGaHIoOmXXOj2yKr3y9Tv08Yw3d4+bshF5?=
 =?us-ascii?Q?FE1GOvQtcStHIkx4Cdv8JWt61AKBpQXY7bjTdSuhptGGWQ6pUAkFJChe65Fa?=
 =?us-ascii?Q?nXeLcLj8TGxKiIQjqyefrXTZKQWn5STaFqbT4TNB/5/OSen5oFe5p+fAGyZh?=
 =?us-ascii?Q?Wq4iHFMOSSbo8iZ+RLz1DRcLD+7HiSmXOnt5XDjYXDmJLVWF5qAmja9bpGO+?=
 =?us-ascii?Q?ku/d83kjh3DJsQae/UOHT+xkKmBGXzP3N7NtqgBksgmX8QSeVzLayZlIHg00?=
 =?us-ascii?Q?tfzX/9BuF8QU3Zq2C0KrEEi3N3l7Ji/G4gOVm63Xr/JcZCFMcX50al1F2dcs?=
 =?us-ascii?Q?4Q=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 802ec6fa-2332-426c-3660-08daa956742e
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2022 17:56:41.0782
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SjkcIxn49Qshy7oN7FqzJKES/RnCdIBE7/YSdMnNZcPVJ/+G0761ieVMseqXtnA3XebLxXdSEyi+dhKcZgv2Z41jPQxvYZORQ69qcPcppLA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4923
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 08, 2022 at 01:48:08AM +0300, Vladimir Oltean wrote:
> On Tue, Sep 27, 2022 at 03:20:47PM -0700, Colin Foster wrote:
> > > The mfd driver can use these resources or can choose to ignore them, but
> > > I don't see a reason why the dt-bindings should diverge from vsc7514,
> > > its closest cousin.
> > 
> > This one I can answer. (from November 2021). Also I'm not saying that my
> > interpretation is correct. Historically when there are things up for
> > interpretation, I choose the incorrect path. (case in point... the other
> > part of this email)
> > 
> > https://patchwork.kernel.org/project/netdevbpf/patch/20211125201301.3748513-4-colin.foster@in-advantage.com/#24620755
> > 
> > '''
> > The thing with putting the targets in the device tree is that you're
> > inflicting yourself unnecessary pain. Take a look at
> > Documentation/devicetree/bindings/net/mscc-ocelot.txt, and notice that
> > they mark the "ptp" target as optional because it wasn't needed when
> > they first published the device tree, and now they need to maintain
> > compatibility with those old blobs. To me that is one of the sillier
> > reasons why you would not support PTP, because you don't know where your
> > registers are. And that document is not even up to date, it hasn't been
> > updated when VCAP ES0, IS1, IS2 were added. I don't think that Horatiu
> > even bothered to maintain backwards compatibility when he initially
> > added tc-flower offload for VCAP IS2, and as a result, I did not bother
> > either when extending it for the S0 and S1 targets. At some point
> > afterwards, the Microchip people even stopped complaining and just went
> > along with it. (the story is pretty much told from memory, I'm sorry if
> > I mixed up some facts). It's pretty messy, and that's what you get for
> > creating these micro-maps of registers spread through the guts of the
> > SoC and then a separate reg-name for each. When we worked on the device
> > tree for LS1028A and then T1040, it was very much a conscious decision
> > for the driver to have a single, big register map and split it up pretty
> > much in whichever way it wants to. In fact I think we wouldn't be
> > having the discussion about how to split things right now if we didn't
> > have that flexibility.
> > '''
> > 
> > I'm happy to go any way. The two that make the most sense might be:
> > 
> > micro-maps to make the VSC7512 "switch" portion match the VSC7514. The
> > ethernet switch portion might still have to ignore these...
> > 
> > A 'mega-map' that would also be ignored by the switch. It would be less
> > arbitrary than the <0 0> that I went with. Maybe something like
> > <0x70000000 0x02000000> to at least point to some valid region.
> 
> A mega-map for the switch makes a lot more sense to me, if feasible
> (it should not overlap with the regions of any other peripherals).

It does overlap. At least DEVCPU_GCB and HSIO are in the middle of the
mega-map.

I'll stick with the 20-map solution for now. It does invoke this
warning from dt_bindings_check though:

/Documentation/devicetree/bindings/net/dsa/mscc,ocelot.example.dtb: soc@0: ethernet-switch@0:reg: [[1895890944, 65536], [1896022016, 65536], [1896349696, 256], [1896742912, 65536], [1897791488, 256], [1897857024, 256], [1897922560, 256], [1897988096, 256], [1898053632, 256], [1898119168, 256], [1898184704, 256], [1898250240, 256], [1898315776, 256], [1898381312, 256], [1898446848, 256], [1904214016, 524288], [1904738304, 65536], [189087552, 65536], [1896153088, 65536], [1896218624, 65536]] is too long

> Something isn't quite right to me in having 20 reg-names for a single
> device tree node, and I still stand for just describing the whole range
> and letting the driver split it up according to its needs. I don't know
> why this approach wasn't chosen for the ocelot switch and I did not have
> the patience to map out the addresses that the peripherals use in the
> Microchip SoCs relative to each other, so see if what I'm proposing is
> possible.
> 
> But on the other hand this also needs to be balanced with the fact that
> one day, someone might come along with a mscc,vsc7514-switch that's SPI
> controlled, and expect that the dt-bindings for it in DSA mode expect
> the same reg-names that they do in switchdev mode. Or maybe they
> wouldn't expect that, I don't know. In any case, for NXP switches I
> didn't have a compatibility issue with switchdev-mode Ocelot to concern
> myself with, so I went with what made the most sense.
