Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FDF75F7F12
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 22:44:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbiJGUoT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 16:44:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbiJGUoS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 16:44:18 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 152DBB2DB2;
        Fri,  7 Oct 2022 13:44:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SsoZRHOZ/vgb8kwwow5Zq+mVvffYxuX148FQAXGLX2aWxKQUmR2U/x9LqOgqnXd39tqocZrAioad4aMZwyQ49tHWSz84E956X4tj1l0A7USVi+maflF9pEb8AVdPU7jMHg0ismwxzsmcoedxCKqgyyfeLrrmqnglPWNRWH8Bb6HmS6xXYb0sM2S7+gOp+llCO8UMBnfXVBN6FbhT1ENKOYrXDYvaMIalc7Wi1SR7QTJKTdlm5fxjHa5A5bugbhl1vyzeSOMaUVGD5TnChjepgZtZGDPln85tnEigiN48owZZDoMXXV6EQI49w1qEmBNaTs5+Ye7MKraHgJbkKDkWrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QVhF8p4/ugTT6rThdb1yJChll+6LmkcYadKmXF+dzy4=;
 b=dDcfvJhF+dKSF/1LuXPQgqZRKxHfhiARRvV60t4DW3Y8UsShxR2V0ub5jkjSm4xQxZzAZHVWhb/0+fEG0fKQ2mahgs8nKqq2XeidNgjSza4dIjwA1+DhV7EhQXTvugGu5SDczHMn/F6gfvcZJnDcuSAORFPyIS09IEJmolCv1yxu3T0+CPG2PiXJWznJ4O9UJy8A1XWcSxzML7maQD8StDhAB298AMmSO4587d0qow0V4PcBMy3tWAjOp5ISAIfHaCoXgMjoKamEUV7ZxbXLaNAZ1DvFwR8ZSR22G6LUs7515qY/IAkWPCh8FtKuen8Ih+H8RAUCCGRufLL3x2aKDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QVhF8p4/ugTT6rThdb1yJChll+6LmkcYadKmXF+dzy4=;
 b=N4UcDlnAy1OpXbpmX1a7tlLpoSn2e2Vhhd6X6QG6Re2hurVBYJhh3RdW2MMOAIlRjUkOVygxZ9p4Jd2Gw56fnpZoJTsEdbhx6VOImA4JB32dTmIUiYPi90scw6IQxsvDlVLP8LHFyKmL2mE8/3y4LTMgbqGOkMe31w+c2U4AJ+U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by DM4PR10MB5942.namprd10.prod.outlook.com
 (2603:10b6:8:af::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.28; Fri, 7 Oct
 2022 20:44:15 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::ee5e:cbf9:e304:942f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::ee5e:cbf9:e304:942f%7]) with mapi id 15.20.5676.028; Fri, 7 Oct 2022
 20:44:14 +0000
Date:   Fri, 7 Oct 2022 13:44:10 -0700
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
Message-ID: <Y0CPmuxTRr799AR5@euler>
References: <20220926002928.2744638-1-colin.foster@in-advantage.com>
 <20220926002928.2744638-13-colin.foster@in-advantage.com>
 <20220927202600.hy5dr2s6j4jnmfpg@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220927202600.hy5dr2s6j4jnmfpg@skbuf>
X-ClientProxiedBy: BYAPR02CA0040.namprd02.prod.outlook.com
 (2603:10b6:a03:54::17) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|DM4PR10MB5942:EE_
X-MS-Office365-Filtering-Correlation-Id: dd275cd9-6a18-4d43-579c-08daa8a4b254
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FLZDQeQS17j2Meog4uI5KHJAFWUxPsArpuxpD5JarW2MFrF26aM5TDmdpT4k509K2RbK+vymUCSlS2Q+OX1TVWaoaiGXseW89dXXSRsTkDQd+iXJW/muflxHWk6YUW44ypn1rYpdIHsfMziUyn2fZdZzer0fCVrLljRu/4hClDbknIMWADMTWu251V+I0hVuGfCGJ5IktIjjPVuo6uqnx421YyV+uwHX7dKf++T61dcT2rgUGHt4lY/HHHm04rF0Cv/C5ki6MRXjQaH+eCmVT96oIcl46hpZdZvt+s1swJMuB7yzGP2+j3PghADwc0T/TBYpyXNtZksiZdvydmeYPKcyfYWU8FS8/VRZEhdTDdoiXvZN9Tj37GI2IXqKEreU7Yq3s9RH2ya+MRX7ou/O/pajsugmnYT4kayOu+Qi2dcjEj0/Hov8oNBbXF9vy4yP6U3ao81I0dm+cQHb1o7tJlazcefiqFB4gCn9p5aOaNz6v82na3fxk/A6DAPFgO/otjhyvRBWX7vmL2Ew80K8nyqe+pI8uhE+ng3QXf70TwO8NrGxirBXMaUI5FtZfc3pe+5z0c6bX+/NLBDg1suIamAOQsjwYvxQXA5gFV8QFPPWCfqQpEGM2uW2Rm4yUxXiN1KmbqzlTd5+NsU7avWtp7xfOPFBZskoFVxaxgA8bFeqheMbDAY5lk+JTNYad3G3tzFk51F9xYjKm3q28Jmgbg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(39840400004)(346002)(376002)(366004)(136003)(396003)(451199015)(2906002)(66946007)(41300700001)(186003)(6666004)(26005)(33716001)(6512007)(54906003)(9686003)(8936002)(86362001)(6486002)(316002)(6506007)(7416002)(478600001)(44832011)(38100700002)(6916009)(5660300002)(83380400001)(66556008)(66476007)(4326008)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ciWgi5e06fG57ADKU8zKxBf7gYm7HrHz5OaBmX6KATNKQhfl2QvwzZjOme/h?=
 =?us-ascii?Q?jChinKMuRTdDzo8r6nDDxj3kB5Xy4qWdVZ/uuPAW1WoWtGvO3P3gm37F+R/A?=
 =?us-ascii?Q?JCGOm+7WGQt7MSmoa21zV1AEZmEJ6hbE6cpln/4BX8tcMjJarGWfnYfYa0St?=
 =?us-ascii?Q?jGnYmZ3538hCxOOpjCYfAuQCn3HSZbxhI3aEx0c8+m2EzVUZxNSrDrQA2V1j?=
 =?us-ascii?Q?cFBKiTJfOQBdt1hseRqVzFY2vak2UCbYBuggvLJ+ghwhd29NbvXYvLYSKAMc?=
 =?us-ascii?Q?JgBHRi+twEliVxvMRjAd2xHfMQRYVbzfs75hZWsXSM34UqipczlnpBDfT6IJ?=
 =?us-ascii?Q?TgXCK5kvCp0ebDMUCqVcqDYl4wQtSqIzJkTlMsl5hNLbVMW1Q8Dy9u6R4Ert?=
 =?us-ascii?Q?YkSgRL53nX+lQMilEnxPXtOck+l+myKhtLFH+jIQ5smVTV+yKU2S3mO+nl9O?=
 =?us-ascii?Q?7vdqa4rafBpHvQzyfKShrqaDBRxAPXbpR/0gLI2Su9N1NolimHuhzYT4alYU?=
 =?us-ascii?Q?BMb5J4Rlj/Zd0gkKdGHlal9sW6tCSoSzRolou4SFh1vRyTl7BgGbNFQkI+4g?=
 =?us-ascii?Q?1Yl3R90RRExhbBQ5r5NtU1Si2HcRGZdojbbA9iqjycXfaCbeAvxuGylZA9pQ?=
 =?us-ascii?Q?y84tTwAZpUQMhguji3P7nLX5FXaM3BU+vdDdho47pA3QNKDKcxftX/6/dkXW?=
 =?us-ascii?Q?hMlihSFPsZyDsDsWipJSvIq3lh0Rm7Zai0d8nHkZqG3aBUWlKM3TvhEdOTb1?=
 =?us-ascii?Q?pCZc8TB6G7H7mnX6CVQQcXp6rgsn/WxcMD6GTTp2umfs5p9byULRAZuhlq5R?=
 =?us-ascii?Q?I2OsBBF52v5zJ2c2hlztCAq4j3vVe2U7R7wtTmponN3CMllaLgeQk4/O+XG4?=
 =?us-ascii?Q?BIlOmvJrLMwr8bGkogHJxbE87diZaOIVYg/Evmr7CEC7L+cmpCISaWd3WfPz?=
 =?us-ascii?Q?aHqBKDbiir5qMXrw2Dc+RsvaHovUuGEETsBRhAVoCO4IWu7ofmH1qbmGIVn7?=
 =?us-ascii?Q?R1dZiHBqRBXpGHysVPRpXaDKLYm8zPD6CILPPHSRa3Uai5vkLIYQvcfvfIA2?=
 =?us-ascii?Q?sjVaPXQ1NiKamb36sppqmCG99hQPSoAjtGahdwZ82Wi/9SbRoMPcflNPPCJT?=
 =?us-ascii?Q?rBPtXXFVpU7eKjWdjh1i0rnwB1JXI1uR1Z+rpc6HzTp/KZTxOQ4IY6F5U8rM?=
 =?us-ascii?Q?/NFrCax1//9uasY+HI3Jb9YxJmGymnaTliy/Z6vk2ZDUpZ0H2O1efTsfMSSP?=
 =?us-ascii?Q?PqbhEdZX5aVKNCp42dFdyFxrxNB8871uANJSeBQmDFuPhDrMdowDTkbQ0NQN?=
 =?us-ascii?Q?/Q/c2vpDpk2ioMsFAF0CxUiEDERf7f/X8xfsoLpB/36qrzhtO87xiWwjwD6p?=
 =?us-ascii?Q?GNJLMzrzfkE0TgP+1MsjystfYyq1WJnpHyWIVfD+uQjqUiboxfcsYoIl12hL?=
 =?us-ascii?Q?IW7/m1YtN0wGEj6RB4wh+odH/NpYSE1PYsfIZPHvpYjho5oEBcwGP/wpe2mL?=
 =?us-ascii?Q?jNuzjGdB7zIVSWY2cnaZzbEVF0UMJEEjnIv48BBUPqbwDZ9WrANsBo9COAYQ?=
 =?us-ascii?Q?hwWTMKffd4ru6W+21QomkH1rrnyIlCaHxl1xaCf1P7iPM5A6+hvGF2ZXOTyH?=
 =?us-ascii?Q?6A=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd275cd9-6a18-4d43-579c-08daa8a4b254
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2022 20:44:14.8664
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 09saHnr0y8aMyWF7n9WaPxG4ntWqOlNZI5Nn3aQ7hU93upjRoIH1xBNMp+VVyK5hVEdm2JoyuYeXg0DFcZniPe4fhbb7+oNFwD9Tx+2j3fE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB5942
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 27, 2022 at 11:26:00PM +0300, Vladimir Oltean wrote:
> On Sun, Sep 25, 2022 at 05:29:26PM -0700, Colin Foster wrote:
> > +
> > +    The Ocelot family consists of four devices, the VSC7511, VSC7512, VSC7513,
> > +    and the VSC7514. The VSC7513 and VSC7514 both have an internal MIPS
> > +    processor that natively support Linux. Additionally, all four devices
> > +    support control over external interfaces, SPI and PCIe. The Ocelot-Ext
> > +    driver is for the external control portion.
> > +
> > +    The following PHY interface types are supported:
> > +
> > +      - phy-mode = "internal": on ports 0, 1, 2, 3
> 
> More PHY interface types are supported. Please document them all.
> It doesn't matter what the driver supports. Drivers and device tree
> blobs should be able to have different lifetimes. A driver which doesn't
> support the SERDES ports should work with a device tree that defines
> them, and a driver that supports the SERDES ports should work with a
> device tree that doesn't.
> 
> Similar for the other stuff which isn't documented (interrupts, SERDES
> PHY handles etc). Since there is already an example with vsc7514, you
> know how they need to look, even if they don't work yet on your
> hardware, no?
> 

With regards to the interrupts - I don't really have a concept of how
those will work, since there isn't a processor for those lines to
interrupt. So while there is this for the 7514:

interrupts = <18 21 16>;
interrupt-names = "ptp_rdy", "xtr", "fdma";

it seems like there isn't anything to add there.

That is, unless there's something deeper that is going on that I don't
fully understand yet. It wouldn't be the first time and, realistically,
won't be the last. I'll copy the 7514 for now, as I plan to send out an
RFC shortly with all these updates.
