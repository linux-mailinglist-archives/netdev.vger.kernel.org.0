Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 125BF5F4CEC
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 02:08:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbiJEAIu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 20:08:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiJEAIs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 20:08:48 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2131.outbound.protection.outlook.com [40.107.220.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9334F6E8B1;
        Tue,  4 Oct 2022 17:08:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QumN1A3BZpyDbyL+i3f5YwMjH4RizlM+5tjkQSeGe/k0dMynfChjooqhZHDBI5l5PdFRXzpMgj+f7cE6HQTtT+dSFpc5d5AgISZy7Qjtxu0e1EGFh9VEAEX1r82BW6WbDKVGsHc0FmlwxE6+cJJAwVnApaTLcfESAMlJTwuB1TpyAapqIATYVREOnl16TfTD/A7aJr2OMMh9JAYuG6tNBEalziNyfpIobCg21M54LMrDqQCfkw1CHNQu3+3v5fvVrpAiwaU/tf1z20Z7JCqtHPx5knASqiHMqeEv7RwNOFy20FnTRCHRxxDf44wai2XI4KxfCVj3ihL7STPgC30Cag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iYExmqY75AVXf4/LvUvI6rNCzDD0nloxrL8vM7JWdQU=;
 b=CILHE0Pve4W5Azd30VRQ5VFvCx/vrCiRwVcgcO0Y2KhD5YODVF2OKrUht3T41wlrPi4jrgA9F5+CP64mncYwLv5F8qzXYOb/qcPz6p3zfwdFdKpWJ1hvdkz4iOW+hx/JXsdF2S+cCPMNwtHK28HkUapiO1j9UQIxsMsP/LkmuG6lmKWHwefErMY/oDt1/4ELmbw8Dcd94qIa71FfFmJIdq447XFL0TEgl2hBggPbXKBTpzY96DK3NS55n3LYspKXrZEZSdqFlfl0Ah6ngNigjWKaiE1A/s2ToPc7PyiTAZHPXN02UQvGEEsOktqIdQOQ/TKnk/5Gjr2FO79ET4nQdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iYExmqY75AVXf4/LvUvI6rNCzDD0nloxrL8vM7JWdQU=;
 b=ptNzkT6mmfcfT3TO4hH1/cQqcsrqg4eq9x8HZAPy2Ui+HOXfmdZU2UsYCrZXkjR9SViyTDH8FWJLUjTmho/tKMvd+givuobMQFG2AnL2rNSrn9slycyKFLd8m1W1WpFU+vi1fiVXzEoEe/vwTXfJJIObwyaKtyhefZDGzGsyMsE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by DM4PR10MB6111.namprd10.prod.outlook.com
 (2603:10b6:8:bf::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.20; Wed, 5 Oct
 2022 00:08:45 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::ee5e:cbf9:e304:942f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::ee5e:cbf9:e304:942f%7]) with mapi id 15.20.5676.028; Wed, 5 Oct 2022
 00:08:45 +0000
Date:   Tue, 4 Oct 2022 17:08:41 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
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
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH v3 net-next 12/14] dt-bindings: net: dsa: ocelot: add
 ocelot-ext documentation
Message-ID: <YzzLCYHmTcrHbZcH@colin-ia-desktop>
References: <20220926002928.2744638-1-colin.foster@in-advantage.com>
 <20220926002928.2744638-13-colin.foster@in-advantage.com>
 <ec63b5aa-3dec-3c27-e987-25e36b1632ba@linaro.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ec63b5aa-3dec-3c27-e987-25e36b1632ba@linaro.org>
X-ClientProxiedBy: BYAPR05CA0022.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::35) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|DM4PR10MB6111:EE_
X-MS-Office365-Filtering-Correlation-Id: 79f0a969-94d1-44e4-bf86-08daa665c4bd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +dbNJbP3ZmtcuY7qMGa6n+Jc9QcRFnwgjRUGY/k5qut0KG6gG5896ZWyWOVRJgJGrwHCaTOPYIKG0MjCabdFujlPG046qkBhTjUz5u36AGnvRynRvAIMcRX+ZXh85CXvRoug+TP5P9dfLMDYMHogRWi3fPTnS1XL5oo/NwkPSqWQLBuMVGowwSXOhPxTiJ+cUDv3Dt1M8wk46udlB7LEnBkR4hQ5SBESC9tyBn/zTq5Yt8lb4Qq130oFK1nAUEp9Rm4lJi0E+BgfANWXAzcMS8odf2PuB28jfMXCJBXiFhe1fsV1m8kcPJsBNXfrR47O/4puYuSVNPFkPQKZ1FqlxWB/NoeF147QAmEqaMQJ81KORZveeTNoNFo8WWGjs8T8VtnHQNCBcc9AfMJ5aWkAY2q6ZOioZm9p+mAfwST4tP89mBOzZLwkE+YnWNf1jy2eIaCcf3SchX2+du7n1dnzLqht0/aXvCy21Jxd5qD3aKG5imqBQzCaEGz359XsqfE98eYTv9gJn065m46CaTBn9sllwbYUEaCu97wIEsOok4Rl4965LAZYd79OiuA03Wx5lOz5i0zeSOjaAW2BjL/mj5IZHnBye7ALmr1BzMmW79IFthrcnjfbSnkGxMtpk8Jfgzp6o3LgfQuw7XfHgVd2HkBr7GETgTZwXxZ6Gz++T/KM4+kISbfuV8avfTcB5DRWexg8W8LrGoBmkMPj5ei33A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(346002)(39840400004)(136003)(396003)(366004)(376002)(451199015)(44832011)(83380400001)(66946007)(6506007)(66556008)(8676002)(41300700001)(26005)(6666004)(4326008)(5660300002)(66476007)(2906002)(86362001)(7416002)(33716001)(38100700002)(186003)(478600001)(9686003)(54906003)(8936002)(6512007)(53546011)(316002)(6486002)(6916009);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tzSymp4QUZPbbLImkmgvj+StmNMY5vJrnaOjFL0tnuZEEjM1e+0BxYVUijzR?=
 =?us-ascii?Q?cG07hVszWjqufrp6sduopnvyyKqlUtvTMAMG4VTNVz2aBq+6ct8SgUc5wQm1?=
 =?us-ascii?Q?4+R42rvkm+ugaUocZrD+zYT41PhPXOL75J8qfBFovOXarslHgpJLTg68XfbI?=
 =?us-ascii?Q?Rfas4A7gp9E0JYcmw1K7zMbEIt3wV908c20ZoioXppKX6tDVdI7DdXgZ5FXD?=
 =?us-ascii?Q?ZEJ81r46xjm7dF/8IwHiTpiqrXbWd/F2jXljmTVQcBaFxEDW/qTodXIoIBc3?=
 =?us-ascii?Q?9iuggkfDEWr+sm3azIEj8DZA/hBdkxMBn2soV/guLm/qrUM3+OayMUHidJTf?=
 =?us-ascii?Q?t7iTIkpVsAkDTuuS7jBTgXE5zxFCUMZT28lSHT14YAOHjL8SE3BCaweXCndi?=
 =?us-ascii?Q?Dvc91wK+jaKnHKBJAJ0cUTlg08EVSQPZUdfpEYBG23MsARzon7k5VbE1rqEd?=
 =?us-ascii?Q?223K01CZGXvvvbyHcLXegFuEUFJjlR04kmE1khC4oCV6CF2f+jB4tfH+AXOp?=
 =?us-ascii?Q?SeQ/qrKwzskHCAD75O5g7ejbpz4iUsYmuPi9Ri1+4Gp8BjzEiiV33oFwrpz3?=
 =?us-ascii?Q?PbmX8J2gsi1aNa/yylFIHntGKkq9joUs4Q4mypvGXRfzvCtWFXrcbx0TNRHH?=
 =?us-ascii?Q?beA8fLAkI/t/Wx4700gWawocIrHNt7WLChJZQ1RUrfiEtafrWkhqgcEHeppn?=
 =?us-ascii?Q?vXAviwtyr/jCC++rgic15Wf8iMX17ATINsSutBMft9uTHIyhLMO+zLlKu6qW?=
 =?us-ascii?Q?fDEvUMCXZX0wXoMtQcxYuv4QdsLCrQsqL/BK+nAzot9c8zltj1cEubZihhY+?=
 =?us-ascii?Q?h0MPt5umNhTUDVzyVZukiJsyuo08aiGO7FIU4fKccjcObryEVr75Wx9rNMTA?=
 =?us-ascii?Q?UiThKEm8TedWUBZl9yczMo3zQbK2JlRdEDK14d7JvQOgtgeIwd4SgNDqlOop?=
 =?us-ascii?Q?UjJ5iunUxc08r65jMHClhhG+a5o5eEdWjT9LCLAuFWvPwO9dlcB0YTMADW8h?=
 =?us-ascii?Q?VEo/ImEYzSGadb0V/yBWgUI3CJYBLckaDqTNgIO1Iow4dRO83Q53Lvd+O2/b?=
 =?us-ascii?Q?hvhNPQXXf6EsTLs1zXeiLTwTiPBAUI2gcd2HpsozrQJ9UOI0u+bJ5uvfPPbK?=
 =?us-ascii?Q?I/rL+zsnWYcgmK52gYwZ7svSIKFjgWO4WJE27Xka+iUDicoKEqUVeHhS0MBz?=
 =?us-ascii?Q?QoE488NJ+KqG0H/JrF2682M8DAWYa6DmnHWgPqu3ebcTCUxfT0fr5PFYbARL?=
 =?us-ascii?Q?ohpebI80BnozvyAcTApZH4+ybHMjZjXrLhCR6qvAM4o7mTeb5CnF23338pSA?=
 =?us-ascii?Q?Gg/54qY+759bdzQ0ub8W8X0YKC8J2BEUKixKze9Al1tkYa+QTcW9MUWrqsHS?=
 =?us-ascii?Q?2DRzu3Re7zQADQx4NMv1mZ3v+uIPK6JFM1fpFXRuUBf7/7D8IuRLPTdPmwy8?=
 =?us-ascii?Q?d3uWZGNsaqNl52JEQEQ73tlIFA8LsP0iVZeTw6AgsIrktItuqZouZS+yClLt?=
 =?us-ascii?Q?qZbJJVCUG9TsdMJdS+Mhr4QypMSF7L2oWEkDbEVVB2zZmlJp6ptqTAE0c7M3?=
 =?us-ascii?Q?PbccMIPmRxTdn9X+Ot4BcdQaor9GddEgrIdUacODxp3cDb3G4m8T6NJZknh+?=
 =?us-ascii?Q?wQ=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79f0a969-94d1-44e4-bf86-08daa665c4bd
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2022 00:08:45.3086
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ey9NUlyhQkPTl/phCcDsz/aGv9oPpjNJjCnafSA1T0ajdujL4t++CXmy5Rf4+3I7TJYqv5hfa+CprmWVuH5wGrU3J4mrEWXYY2Z4LwsynTU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6111
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Krzysztof,

On Tue, Oct 04, 2022 at 01:19:33PM +0200, Krzysztof Kozlowski wrote:
> On 26/09/2022 02:29, Colin Foster wrote:
> > The ocelot-ext driver is another sub-device of the Ocelot / Felix driver
> > system, which currently supports the four internal copper phys.
> > 
> > Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
...
> > +  # Ocelot-ext VSC7512
> > +  - |
> > +    spi {
> > +        soc@0 {
> 
> soc in spi is a bit confusing.
> 
> Does it even pass the tests? You have unit address but no reg.

I omitted those from the documentation. Rob's bot is usually quick to
alert me when I forgot to run dt_binding_check and something fails
though. I'll double check, but I thought everything passed.

> 
> > +            compatible = "mscc,vsc7512";
> 
> 
> > +            #address-cells = <1>;
> > +            #size-cells = <1>;
> > +
> > +            ethernet-switch@0 {
> > +                compatible = "mscc,vsc7512-switch";
> > +                reg = <0 0>;
> 
> 0 is the address on which soc bus?

This one Vladimir brought up as well. The MIPS cousin of this chip
is the VSC7514. They have exactly (or almost exactly) the same hardware,
except the 7514 has an internal MIPS while the 7512 has an 8051.

Both chips can be controlled externally via SPI or PCIe. This is adding
control for the chip via SPI.

For the 7514, you can see there's an array of 20 register ranges that
all get mmap'd to 20 different regmaps.

(Documentation/devicetree/bindings/net/mscc,vsc7514-switch.yaml)

    switch@1010000 {
      compatible = "mscc,vsc7514-switch";
      reg = <0x1010000 0x10000>,
            <0x1030000 0x10000>,
            <0x1080000 0x100>,
            <0x10e0000 0x10000>,
            <0x11e0000 0x100>,
            <0x11f0000 0x100>,
            <0x1200000 0x100>,
            <0x1210000 0x100>,
            <0x1220000 0x100>,
            <0x1230000 0x100>,
            <0x1240000 0x100>,
            <0x1250000 0x100>,
            <0x1260000 0x100>,
            <0x1270000 0x100>,
            <0x1280000 0x100>,
            <0x1800000 0x80000>,
            <0x1880000 0x10000>,
            <0x1040000 0x10000>,
            <0x1050000 0x10000>,
            <0x1060000 0x10000>,
            <0x1a0 0x1c4>;
      reg-names = "sys", "rew", "qs", "ptp", "port0", "port1",
            "port2", "port3", "port4", "port5", "port6",
            "port7", "port8", "port9", "port10", "qsys",
            "ana", "s0", "s1", "s2", "fdma";


The suggestion was to keep the device trees of the 7512 and 7514 as
similar as possible, so this will essentially become:
    switch@71010000 {
      compatible = "mscc,vsc7512-switch";
      reg = <0x71010000 0x10000>,
            <0x71030000 0x10000>,
      ...


