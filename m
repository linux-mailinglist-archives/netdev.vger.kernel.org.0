Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C56FF5200F2
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 17:19:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238189AbiEIPXe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 11:23:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238151AbiEIPXb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 11:23:31 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2101.outbound.protection.outlook.com [40.107.244.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E369D216047;
        Mon,  9 May 2022 08:19:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b4IJHZKfDs52Jckz4JS/0Zpp75mRSxAMrnemKTAfXtwb/vH5pCuXssa4HazAHIE29Lq/qQcEPvtIqJ+p/3Z2ru4+ydJoHp57bd+njH17B3zBXZoNXRhHmgii1Dxky78914PKApSlNcD6ggqexVPpexPN0eKlCz6dGrfOC/sE9tevuvplAwHMnk9K6NvizQUwTpHgc9znPy0EjS1YBwA6ta7K9Flm8HFr8mNfPT3RGxbwtM3WKZBggxqBaUdqBMpFpZLF42pUPV0qd4BmVcnMdAkExd4+gXjGG6hod2EvExILdh8GAkkP3Fg8nbAegfx00cYqFom9JTTbd0Zvj0Vf3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BZeLJnCRNV+NIRfoQkRrxtCvxMud/O3Y+k7ZnZvfUQU=;
 b=UgEveS2T0A71SHBtlfpOd5Pq8QFe5Yq62LjLTpdOowW9cq4C2+dDjc0NyndEZSYtongzdSpuad30j6//RolaRsswC0UNWo6Nup7tCkTA0B+XCI3vcIWKkEDCuioFoVXRkT+gQzoMIprrxog0CUTZvUIxOzWTWvSFkLpaOdVm1OobLyvoJuWphXGysjoR8uSfeLAy47PrLUGXUznkqOlPVFAF6rF6cE89m+h8dQDbTPfv9HrJ6hqyCGZVEA4/dFXPVECym0YQPE/I119CS9vgzDhUWIcaKd0OFsmOb7ePnhrgsWndRNADR3K68iI9PNjwAkv/t4vSYwCA4YSLb1Bg6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BZeLJnCRNV+NIRfoQkRrxtCvxMud/O3Y+k7ZnZvfUQU=;
 b=gGjKeX1XTZV41dmgqHQQVb5JF7F4RoH1QIQ0qfX4WlhiExS1nlWjCnPxlPcWc158dp4I1HOatVcuoT9Dpc8oUItBLnhroFPIAy9GTE+KsfFfjcUxYoCed73EJPScpT1OLzMoygJx4/i8V6bj19BOYkX4sn2Hb6o3ajd2nBe/S00=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by DM5PR10MB1353.namprd10.prod.outlook.com
 (2603:10b6:3:9::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23; Mon, 9 May
 2022 15:19:33 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e%3]) with mapi id 15.20.5227.020; Mon, 9 May 2022
 15:19:32 +0000
Date:   Mon, 9 May 2022 15:19:31 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org, Terry Bowman <terry.bowman@amd.com>,
        Wolfram Sang <wsa@kernel.org>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [RFC v8 net-next 06/16] pinctrl: microchip-sgpio: add ability to
 be used in a non-mmio configuration
Message-ID: <20220509221931.GA895@COLIN-DESKTOP1.localdomain>
References: <20220508185313.2222956-1-colin.foster@in-advantage.com>
 <20220508185313.2222956-7-colin.foster@in-advantage.com>
 <CAHp75VcWWDvakG_OLkTgZYbNeoDH5Bw5U0t-NqmzcYyd44uU_g@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75VcWWDvakG_OLkTgZYbNeoDH5Bw5U0t-NqmzcYyd44uU_g@mail.gmail.com>
X-ClientProxiedBy: MW4PR04CA0260.namprd04.prod.outlook.com
 (2603:10b6:303:88::25) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6e3f68df-3c3e-433d-cbbd-08da31cf5167
X-MS-TrafficTypeDiagnostic: DM5PR10MB1353:EE_
X-Microsoft-Antispam-PRVS: <DM5PR10MB13536FA1E96DC858E40F3675A4C69@DM5PR10MB1353.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GNBGIkK09lpUwSp7OkV/y1fz92EwAkavUobxWutn1n5FKjycOOPLiiAX+ZCiRpOthfaL7l2E+TnbJeFilCuWLddokA6MixB0MZeK3ai4jUk061ltG0whavT2SHnGK0fA+H6WL50qqZLuqAIdjo+VNHQIC0xugFECa9cwkDVX4MEAi8r7XyrERWa1h/XveBZQYyqaN/N18cBXinRkLHExLo16uH7Ca9skWqcIV9j+urIKABnSrdHRq8uvxKEzuhJJAgychlAYO2LqioI0jUhk7fNQPqpmp+50TGOQgnqpv/oqB2IZlJllX3LMo0sQ3YWyZ3vYXnP8pLX8trmWOEsQ9qIQK0Rd9lqR3dn053Bnbv50he3BYQgwjt6tr8elF4c+T/FAzQ/K2GFmgmGreI9uzexZvXThub6sX9iYlBBX2f1rjhLWHRLQBO30XI+HW8/3oeqLtnukjkLoHWBwdUh+3Eyt0TU+NydYJijCzyRE3TOAyeYg276S+tnTz3cJkRrBBnEQLSCn2UFQ7iMFzpJmw3zzBGNS/MsCExjQ4hXzzIXr9GASkep7lxoceIfTPXGZUBoJLetysByNm9AvTZSV4zT7x3otvUZIh4OvHozQe8yWhEcHAvEsbhYmBnmDL0gE1FKCF1wkd3C0Op1nZhRh4GUPPyiTETT8UenIFj8WrDp6NtTH+TEqxgq+LH9DdUDcPRcTC60PLnAOdznMe5VOzA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(376002)(39830400003)(396003)(346002)(366004)(136003)(508600001)(8936002)(6512007)(8676002)(186003)(9686003)(66556008)(2906002)(33656002)(66946007)(66476007)(52116002)(83380400001)(54906003)(6916009)(86362001)(53546011)(6506007)(316002)(1076003)(5660300002)(44832011)(6486002)(7416002)(26005)(38350700002)(38100700002)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?X+bxyhRqytagOM3pXL8Bnb0Jkl7izZRVIi10lH1MlXZ/PQN2J++F+M7kLKIc?=
 =?us-ascii?Q?32Xqu0QilEupG5sOSBq2cJmzGAys2rRKyjOoh21OqY1DHm7XIyGQtcEKrSEC?=
 =?us-ascii?Q?U+SuB6JeV9NnaqTaCRjhjNPlYbmzk1llR4fQsX9vALqANaJ+B7WeVoBy1MgX?=
 =?us-ascii?Q?XqfPl7eOUKNCjAPf4/sYor3QEzzVCHJDiLyNDtxHy4y6nCV2y3N+N6wpQ5RB?=
 =?us-ascii?Q?GY6YMOFeITzhqpt4UHikNf1xfBFi0jdPukBfhi81K1bbzK8UpFfyVtgROwY3?=
 =?us-ascii?Q?6D2bv2Z7JZ8c8F/PvMO+VGTItmHFw+Q8UvceJOr7P5bVYAU85avWpn0DJyS7?=
 =?us-ascii?Q?do0qdHrC1guH7hDgWNFRnD3DGT33xl/kJDCXcHr2eHG/Dz4Vt0MftZG3GqBv?=
 =?us-ascii?Q?ZKTPPDaQEp9MceSvNK7CVi8mFHHtt+m6MBs7dmeMgMtwNMYQGuxGP9Zm27Sx?=
 =?us-ascii?Q?syYeyhUHU4nJ/Hz6PvvCv2MrgP4IuJSySq+HJuqy93hSH2FGzDbdYSRBL9b+?=
 =?us-ascii?Q?xcsQ526hMu7zTJ5vrAZ5TofwicBU8cKf9nlkqHG4mJ6j1Fr/+8fvPek0/8CM?=
 =?us-ascii?Q?lECOvDnzCl9yvdfkU9hUNDDQjELpPIkeFhRIqHKp+mrij9lsTjWHUVVOc8P0?=
 =?us-ascii?Q?SNWOusKwyBc+EVVPA8ganQUBy7pepQ5bqSxA0aqcI5Sf4zmUywHPjJKkcu+Q?=
 =?us-ascii?Q?ZhWaTy37MNzgenuhj3BcuhKjLKw+HI8FbYOifo+VnRy70WN2EHUnzIfSw9qF?=
 =?us-ascii?Q?H5nlgLI511bKjnN+OuTKWye5/+w0hu4FSwD7Vkww/sSoDqO60LOtFmh78CVV?=
 =?us-ascii?Q?bIaJIX6Keg8juyiAHXP4GbOfcN3rHbzRb5w6RXxHDcaKOvDuC45BNZ5iTsmx?=
 =?us-ascii?Q?bzm/9hBV0ZyIBqEhC3EZnLEAZcIPDwTumoXx8RtEXDtfYnLJMzYdLAKr3Htd?=
 =?us-ascii?Q?jYe/FRGjGfk3xU3HeeQTBH8bEKq6EPAPVYVINVk28GQan0mWobxQdEj1l5Xe?=
 =?us-ascii?Q?rMbGpLXgw3hHRsLBXbCUV/xh6jXRW1zUigp6uk7Ae84efr4/MBIs4Z+b0s2F?=
 =?us-ascii?Q?ROUsw8iuG/ebJytpu28KAvYEx+B7JbEAxqLschhggONZz+bRb6CGlKnybR6n?=
 =?us-ascii?Q?We/jWHVLaS/jAwEM9v/1uOls5Z49rELfkFpsiHxCpnB2fOkuVWldsMJ1ae9Z?=
 =?us-ascii?Q?Lo/YWESFh96qF6NoRbG9oxJRTxvkgWzx33um9kpk6LYpfvwmjd3Hkf8RhDYt?=
 =?us-ascii?Q?XOOrkxoS7mYtlmS0Q/BUtV0LNl3QhNS6ohP0d+42N7SntgMx3POcs1KbUTma?=
 =?us-ascii?Q?qbKzb2ZfFJCTOZaCscvFQWrywASozlrM40+0LmxDXMRh+VL3K6z6qBhC+8N0?=
 =?us-ascii?Q?Ve6aWswK12zAJaNQV/V007WYJhXiMEPEpRxurjPSgWTxS+tALTp1DRAxT97r?=
 =?us-ascii?Q?DEQdxteEpUrAtsKzr37KJGJT1vn+lTi3hlcERVuMDGDTmA8hU1Z2owg/s+bD?=
 =?us-ascii?Q?+BW+7mlNgeL9JE/wRHSNFHisrYpjggG7VCT+oOLufs/Ue9GpT+Gc11TCXKbh?=
 =?us-ascii?Q?LhmrfJIDYfWOgHaiYV1rKTAYGLtU39+PO6A6bZCWnaU4hKQ46cbSuKFwNfY5?=
 =?us-ascii?Q?oWHfG0GB3GZ4gL/cpxqzhjWRpat666dEzakjaol30EY3Hrty6SBt1DmMr2XE?=
 =?us-ascii?Q?xvpjcFG/sqVcMdVO1hZnEZ7l+SomnZcEBg7LekMuVzK9fAzKKWgrMuba08kd?=
 =?us-ascii?Q?t3LqoVsd9kqHebQRysybJMA7Pmce0V8Z9a+ip60AtT0g0XK2JPld?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e3f68df-3c3e-433d-cbbd-08da31cf5167
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2022 15:19:32.3219
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aV+AZRPXG2vkBajhT1xs876Wj0wUEqWT/mq+ZU8S+20x/hPmQjERnatcMHvzd7S1pVJe06vQnAxJybORACAMGoYPZTqolOrF00pM/If1qsQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1353
X-Spam-Status: No, score=0.0 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        DKIM_SIGNED,DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andy,

On Mon, May 09, 2022 at 10:44:42AM +0200, Andy Shevchenko wrote:
> On Sun, May 8, 2022 at 8:53 PM Colin Foster
> <colin.foster@in-advantage.com> wrote:
> >
> > There are a few Ocelot chips that can contain SGPIO logic, but can be
> > controlled externally. Specifically the VSC7511, 7512, 7513, and 7514. In
> > the externally controlled configurations these registers are not
> > memory-mapped.
> >
> > Add support for these non-memory-mapped configurations.
> 
> ...
> 
> > -       regs = devm_platform_ioremap_resource(pdev, 0);
> > -       if (IS_ERR(regs))
> > -               return PTR_ERR(regs);
> > +       regs = devm_platform_get_and_ioremap_resource(pdev, 0, NULL);
> > +       if (IS_ERR(regs)) {
> > +               /*
> > +                * Fall back to using IORESOURCE_REG, which is possible in an
> > +                * MFD configuration
> > +                */
> > +               res = platform_get_resource(pdev, IORESOURCE_REG, 0);
> > +               if (!res) {
> > +                       dev_err(dev, "Failed to get resource\n");
> > +                       return -ENODEV;
> > +               }
> > +
> > +               priv->regs = ocelot_init_regmap_from_resource(dev, res);
> > +       } else {
> > +               priv->regs = devm_regmap_init_mmio(dev, regs, &regmap_config);
> > +       }
> >
> > -       priv->regs = devm_regmap_init_mmio(dev, regs, &regmap_config);
> >         if (IS_ERR(priv->regs))
> >                 return PTR_ERR(priv->regs);
> 
> This looks like repetition of something you have done in a few
> previous patches. Can you avoid code duplication by introducing a
> corresponding helper function?

That's a good idea. Thanks for the feedback!

> 
> -- 
> With Best Regards,
> Andy Shevchenko
