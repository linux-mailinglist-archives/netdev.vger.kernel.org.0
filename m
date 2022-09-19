Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C70CC5BD50B
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 21:05:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbiISTF3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 15:05:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiISTF1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 15:05:27 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2133.outbound.protection.outlook.com [40.107.223.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83DDC3ECD4;
        Mon, 19 Sep 2022 12:05:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EqFp1ZmxZoAInw95eSJW18MS8tKGTQqWGYmvVeM71xJX2kEgXJDD5Qg+aTAzAtpRdoGA5QNW1oqQRkMhaUT7mWLQCVnPNP66Jia6WxEV4RNZZhG1fgqtwqITNCIUsHVCDEey5aNsOkp2f7VNJOOiTogGN+MUB2SD7iIopal/rVCG5s70vbweg+21AtBOK7C9tKc2BKjbW/gKJeekmo83s/k57ZWSBdl/lKOvStZ6s6c8SVmmRkkNkGMBGcWP0JoNu7FUfPzxDIrFOdPEdzoqgidMxGpSfUuEzfFiiNi/GEBpacbG+a9IS3r5DYKamCWiQtatOjF5GgV05RONtHQeBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gOK5mkZ5BsJfw0ZsOzK19DwlYbqQ5E/x4iZWB0UPbF4=;
 b=GO/lcfzC1aC6m1jl3svNdkZci9olUJZNSsALcDcjtm7fyBlYWKDwHJR+UDeohtFPQNZHEAWhR+DAF29cBql8IEQCQvLV9eNRtemgJfc/PTElO24pzpoAkP8xBTtZ2sluUVnxIUzcXOsNPX8O7pIpuqo9YwZb1eBulwy0dNqqhKJQBuNNygWzkrsS7e2uzG2anCnEkxMlfPdSWsk86et2oLBZvcgjt6WzuH343BKkYNZxIj/91zSjvVn65XuhZaZNGKOf2MDkPfVosLjqVH7vir9bbPQ5lRWh5fEEwYZzgzcdz0QIg57GFcqwRitUwG0BCP3LvSOMO+0sf7RTvZI7fA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gOK5mkZ5BsJfw0ZsOzK19DwlYbqQ5E/x4iZWB0UPbF4=;
 b=CWnpfYTtWbFSJjgJyCZnlfhLsX2UtZx8ttAmjNFLxehjroJX5qL1FSPmt9U2b2bLrg4qdFzoTa06kyk7InIADazHvGeuMpLzin+rShrO61mYqkyhiizy7iV1y2cS16qvJhZULms1kjMA2pFixMF9xzvo5Eam+cB8JqoTnJ1awxQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by DS7PR10MB5117.namprd10.prod.outlook.com
 (2603:10b6:5:3a6::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.21; Mon, 19 Sep
 2022 19:05:23 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::5811:8108:ab44:c4a8]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::5811:8108:ab44:c4a8%7]) with mapi id 15.20.5632.021; Mon, 19 Sep 2022
 19:05:23 +0000
Date:   Mon, 19 Sep 2022 12:05:07 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Terry Bowman <terry.bowman@amd.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "katie.morris@in-advantage.com" <katie.morris@in-advantage.com>
Subject: Re: [RESEND PATCH v16 mfd 1/8] mfd: ocelot: add helper to get regmap
 from a resource
Message-ID: <Yyi9YygQw+Z4wE43@colin-ia-desktop>
References: <20220905162132.2943088-1-colin.foster@in-advantage.com>
 <20220905162132.2943088-2-colin.foster@in-advantage.com>
 <Yxm4oMq8dpsFg61b@google.com>
 <20220908142256.7aad25k553sqfgbm@skbuf>
 <YxoEbfq6YKx/4Vko@colin-ia-desktop>
 <20220919101453.43f0a4d5@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220919101453.43f0a4d5@kernel.org>
X-ClientProxiedBy: SJ0PR03CA0357.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::32) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|DS7PR10MB5117:EE_
X-MS-Office365-Filtering-Correlation-Id: b375bd7b-ce2c-404f-5eb2-08da9a71e76d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vL1dSuy9UM3m6eavE0sQ1enENxA8tqX09tkRICKF1dp3h+3gdnTKlrgAVfbUemdsM8EKdMDGVwP7LkxkAR68YRXegJfMl4HTqxeoCsHWnuAKNs9Ko7BhiAmKSJw2Enfj7JLFa2KdiGG+qolPfRc2AsVIMAbP+YU+22oo0OyQvhNAjH+QV5XQcfvZ/wPsfnp7Hn3qL5SZ8wjx84ZlRW8hFMUudvJkNwszs9nhxn+KgEKptmDMNZ2ju3q0gxm4IDlcP12q1wHxlHkcd1IpCPQw9gN95xJqTelOWOWxMLaQk/4oDMkOFeQCaUp8GNhJBb1BQtiNoqo4L0dARPYN/XNEiSFPgr66b1gP0MDiF7nO+Gzajq7s/4j6G8RKnsVm3GFRAjZScA4oQ0240Q+ihFCYIV9jwb7pA/i6UB38HN4lBVtO4f+YJDZ152JTQR7Xhwln3l/+sokX/riyknh8jYOEnaK5EOCt//wEGwE05QgMsDxstNHNH5IimpVv1DAMnpofIGthKDyfwr6lvrk4m0OReDzQ7uAltjoZ+dAaSCwKleOpRLnGJ6efbBa+5Nd0JaT3wjV/k/humB2AiEtmQDYoM6FESXIuBSu0fp9DiKmX9aR8aGvij0tP0GdtxRtNVipl78AyToLxHQ3s7S7oxL21afBRea1YN6Aosq6irJmKh84cZ+htS882ChnZ0BIL6G5krITC7cuH5ZTLvylcnC3AKsD5mjGg7edKuhxz3bXFx6hZoTrfh2aQV03c38kWveW4E/suKnoxQ4mBJOlvfixK4g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(366004)(376002)(136003)(39830400003)(396003)(346002)(451199015)(4326008)(6506007)(2906002)(38100700002)(86362001)(8936002)(9686003)(6512007)(6486002)(26005)(8676002)(66556008)(66946007)(66476007)(966005)(41300700001)(6666004)(107886003)(478600001)(186003)(5660300002)(6916009)(54906003)(316002)(7416002)(33716001)(44832011)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SQrpDKL43m5zHMxySfw02N9TwvsmJlCx6TBm+IW6aWylWFi/haS6P/VZbQcY?=
 =?us-ascii?Q?YRPEbiTP/rGKzwf731GpOFeweSztLbPuiDkAwx8O8UYhxe9lQDSGFk5Pt7cN?=
 =?us-ascii?Q?oIL23WJzOEYBB/YwiyNNy7c1vXMKQaRjDjxAaH255oHn3TR5QJQEOsIRblfL?=
 =?us-ascii?Q?1fGtvs01luJzKDRa0JmK35+jirhjHn5Ziw31fWubsLWmw2LN6qk1OPrm31lF?=
 =?us-ascii?Q?X170d77X3j6wO40NoKE1PGp0eopATPGQRQ1d2citxpmVzKHFsNnGm60FKgol?=
 =?us-ascii?Q?fn2liDZge4RNSXNv+AP8EPjLE6imKfdeqo5sf7Vntszk3Bwj1C9oFJss/AFy?=
 =?us-ascii?Q?/5xqhr2I2m8sSNDLQHUl3B1cWrkIZhWdA3t1yDhcAxvV8kr9dwJrHJfn3qVP?=
 =?us-ascii?Q?aIVGoF6qdTjaZCUEwpAtucOzEz7QnXv+OhriokFcUbPqB1Ru/V58h+JoBuzl?=
 =?us-ascii?Q?w6035kYZ+8Z0H7ndjvoJqkuZjB4opW9KiaMoLrNFosDEsOeguulcY+0cIG+p?=
 =?us-ascii?Q?pMnUcDZxk6x1cuZenjH4bBkuaL46yLrIOO3lPkb8sCOi9DDlPWeZ+JohIRbs?=
 =?us-ascii?Q?iVcJ/EVO/pMtXXDiP1d4d68ktsd+SGIvoA8PZGEbhchVDCIgKL4rOMdC6a/E?=
 =?us-ascii?Q?TfNuB3gUvCIt6fZ1LpAaxfbTrW0GWsgX2zXIM4vup1s7wny3P+xGpdy9Cogo?=
 =?us-ascii?Q?wqEzm4sKy133Xwpk2aRVfduGlzQ/85OsiTmc3N63BE9omTyuNmel70i34rGn?=
 =?us-ascii?Q?AytNuGq1azrShF7x07sqsh9fl9l+NGPOl414jtnA0SWMUuGrl9lbCPn+/tpp?=
 =?us-ascii?Q?FUceKdEv54N57Bjq+vOpw2uNOhH+kBwu7SHWB8GP0zraundu5CWcGVeXe3GO?=
 =?us-ascii?Q?e0SsMDABgEFSuhldbVvNHot0NiEU1HXZt3FbzisWX50VYtXaOz4SFPmWe1q7?=
 =?us-ascii?Q?TE5/U6DzOERKRHg7zufEQoWLzsWUmD7FYIglPxl/DXYMW2hjyvJS0J2iDjwm?=
 =?us-ascii?Q?lvF5iYG5UWqoYMlfMc4N3BOnDXJuEXHtbGqClJFXz0O4REDfXjXEjSWOV1D+?=
 =?us-ascii?Q?NmL2K3xMWTJRkBofMy0i9Yi2L8UMtpivMd/TT5ljua4N+FLcOWDZ4U+U1Xc9?=
 =?us-ascii?Q?R9F8KGYMPb67syexa7xM1nM+gyD3ax4Uy3ztrQZHwQzPJbW7m9pWZlaaOYUd?=
 =?us-ascii?Q?2B9IBmPFgH5E0uLrYtQ1yaGyjizDTXLCVA1mwn6qlkqznaqUB7+oW5wj8rE7?=
 =?us-ascii?Q?MJKP5df69s1+PBO9Zy5ro5pCD1BP4yEBhJQNXJSENKlVuc7+UyaNqpiWNrzT?=
 =?us-ascii?Q?AVlPG7GgIPzrhZPeH9wly0iDe6fjiIV+V82+/ujOwtmzvQ9osv8tuRBvjbkw?=
 =?us-ascii?Q?S4MPYETE88FvB60eHZyF5XMzzFgYjXPhhOx0eJwT4GtGlH8sWMZStG8+uoK3?=
 =?us-ascii?Q?mbEcxLVm3msfW/6WX4xypfZEmA0Ziy6GnAUAD1AAEXeGEAkCr5AJ7rv7MALk?=
 =?us-ascii?Q?zo2aE7OxHVZiAUv4Yd9L8ykkCyCFxtxZfuvAE/+lwDJ8029k54j/6q5Y4sjB?=
 =?us-ascii?Q?52nIn7H84jVmY4NAPl/bBRoQyowCyQ6GRVrNPvomthd6K5y29/nS4GP0jGNt?=
 =?us-ascii?Q?9A=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b375bd7b-ce2c-404f-5eb2-08da9a71e76d
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2022 19:05:23.3689
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tpnq6mCUDeWRHcxgcAfhmj3y4fbGzGfssTZufQg0LDi1GcskuhYXet2ho5T73zsZsEUpDR8waUuS/A5K9aWbYbfGSnRu2N28S4w2vhA60NQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5117
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On Mon, Sep 19, 2022 at 10:14:53AM -0700, Jakub Kicinski wrote:
> On Thu, 8 Sep 2022 08:04:13 -0700 Colin Foster wrote:
> > My plan was to start sending RFCs on the internal copper phys and get
> > some feedback there. I assume there'll be a couple rounds and I don't
> > expect to hit this next release (if I'm being honest).
> > 
> > So I'll turn this question around to the net people: would a round or
> > two of RFCs that don't cleanly apply to net-next be acceptable? Then I
> > could submit a patch right after the next merge window? I've been
> > dragging these patches around for quite some time, I can do it for
> > another month :-)
> 
> FWIW RFC patches which don't apply cleanly seem perfectly fine to me.
> Perhaps note the base in the cover letter for those who may want to 
> test them.
> 
> We can pull Lee's branch (thanks!) if it turns out the code is ready
> long before the MW.

I'll quote Vladimir Oltean: "It mostly looks ok to me"

https://lore.kernel.org/netdev/20220912155234.ds73xpn5ijjq3iif@skbuf/

If you pull in Lee's branch I would certainly make use of it in the next
2-3 weeks. I would probably send out the patch set for review in a day
or two.
