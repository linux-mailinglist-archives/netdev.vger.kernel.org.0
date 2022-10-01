Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5E4E5F1750
	for <lists+netdev@lfdr.de>; Sat,  1 Oct 2022 02:22:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232873AbiJAAWs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 20:22:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232871AbiJAAV6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 20:21:58 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2100.outbound.protection.outlook.com [40.107.92.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83C2FA3459;
        Fri, 30 Sep 2022 17:20:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TJYmJVHfn6c7WBgv/ambMRz4uMSQKnfiPEyHLDNB12pyOPE0ElOxy5j/7VNhy4Hkl0DPrtcXTNVvIVP9EmMPSJRLIEQGz17Km39pNhdfAUD7ghC4dWuNmJLjHcLccGGQZ+ZPb1LPFoTX+cU08UfGTQnhZq31gzWwJuJxucSi6lQOM/Px1ae5k6tHEnnZnvdT3lCd1ojrVvdQ+MNG9AlqFMhbAbxb41PnowY+YV7yAXY3FlkIt9z0QWUASGNjZuAFri/0BApQ67EVgHphgE4ucriYN85gZuSVIPV4EdL6Ea6Knl4WnBubojfRGuY0BKRG4XvBYBbeV80Bn+5nHOLQ0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sOsXWYOa7T/twVucNcSo/GVgqfIeSLu5tRZ2iLCHyvQ=;
 b=JBW8SuAtpiuUDjmPuAkBA0v03JT34CSx72FYv+/sB7yB8lrSZU09MjK7IrINfRZ92dkz6WizTmQqMWIoBq+OU8zVH5ntpwCWL3f13F2mG1Xt1plkNzNCqPv76E8kK/bLQVTPGl5st7eJ4axGH21SHtqg4SRO/hNIOodsFy4K2sGP9gL38mC+N4HobdHGxZVoZXx6nwouZ7YHT5zBjfUqnrusQzkwGCZzbccKynquawidp/UWvxyzZLsmDZVf0b+1WYQVgsqvaK3GRE4nVQsOM+Ce6No+3pkKPti76BUz2uIyS/N5lWhk+TdeaDF+RsNGZJt3+bjaWg7xXYpdYbNVFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sOsXWYOa7T/twVucNcSo/GVgqfIeSLu5tRZ2iLCHyvQ=;
 b=hqG4gQuadsrLIOWjra3xVUD1SjQqik51S4Q4XjviejcDboF1q8y1nOGNWjKhtpvTkh7LBS6VCSdBsyfHkqloAXYUNbQtesdVrSi4l+7aAdMU0hHa53n0hgY9O0lqplAPCcOL1rAyy1cWaiJV1gshox7d6/mjG6tUmLEqfB1cV4Q=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from DM5PR1001MB2345.namprd10.prod.outlook.com (2603:10b6:4:2d::31)
 by MW5PR10MB5805.namprd10.prod.outlook.com (2603:10b6:303:192::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.17; Sat, 1 Oct
 2022 00:20:27 +0000
Received: from DM5PR1001MB2345.namprd10.prod.outlook.com
 ([fe80::e965:d82e:8c42:d0c]) by DM5PR1001MB2345.namprd10.prod.outlook.com
 ([fe80::e965:d82e:8c42:d0c%7]) with mapi id 15.20.5676.023; Sat, 1 Oct 2022
 00:20:26 +0000
Date:   Fri, 30 Sep 2022 17:20:22 -0700
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
Message-ID: <YzeHxmYMjMoDqIHe@euler>
References: <20220926002928.2744638-1-colin.foster@in-advantage.com>
 <20220926002928.2744638-13-colin.foster@in-advantage.com>
 <20220927202600.hy5dr2s6j4jnmfpg@skbuf>
 <Yzdcjh4OTI90wWyt@euler>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yzdcjh4OTI90wWyt@euler>
X-ClientProxiedBy: SJ0PR03CA0168.namprd03.prod.outlook.com
 (2603:10b6:a03:338::23) To DM5PR1001MB2345.namprd10.prod.outlook.com
 (2603:10b6:4:2d::31)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2345:EE_|MW5PR10MB5805:EE_
X-MS-Office365-Filtering-Correlation-Id: 4d519742-79c4-4d16-e68f-08daa342bd41
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XJl9+Ov782QB34PM25QXapUyMofjUU+BujlvXIwFYkvnHWyFkNlOToH1pV+9QgFPImOgkhioxct7ppzEXC5zu0L+Pfx9JEwqHF0xvr2CPfIqnf67eaIusAd/5bKUDfoeEpliFLYNPEF0fGypUwwKhNCGJf/Jp3mUSks2GQhCM+BvDcc0QW5W+Fe6ZwMYl5IZYPbb1K5O15WvQVi37VCJCpytqDRYYtVCg35o6hih1pl9GU/dx4qKZi2w3KsBhmLheUPsjfWDrE6/F8bX23deE/m19vWwIlRiahyBCsthH/qoWUo/AEHKRpM77Mwsgz4NZQQnc4XOSYCOxtiIWlqEdhsBTqt4UTlAllURYBAtcOrMUuhsVKSrOy2rdLpeIG11gZby4lQ5Wzh9OnlF08MJ46cSGg9sn2WisR95kTCR4HPpYuR9RAtFklcQdx9TcbT35Y8F9zuzxNeJX+GQL09BiF+mLRzVxndnNZblprrBLBpoyI7wiecvacYV+Lcvx2vIGKRUbKzYKrx0uwYD+rPoKgnRNvKXZop1MRg5YjmMdT65UmRjSGCZG8TRY5XyspZajFaYTAAlzm3IXaoXJlXRroTIlrgovRn1f+xJXvLKzkp/Cs5LHVR1Ye/yW3y3h5rFGebPYfIZ+kdYxahJ22ZNDTv8rQdIGC1ddJv3aGBd3REOwSIsYXTTy7re8LL+P1NjDEzW9yMH6dIe73n+IjqWQQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1001MB2345.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(39840400004)(366004)(396003)(346002)(376002)(136003)(451199015)(5660300002)(83380400001)(6486002)(6666004)(2906002)(6506007)(478600001)(33716001)(316002)(6916009)(66556008)(8676002)(4326008)(66946007)(38100700002)(44832011)(86362001)(54906003)(41300700001)(7416002)(8936002)(66476007)(9686003)(186003)(26005)(6512007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?j5FyacRw5Fl9VdR6wdlBISljHrphLFQpxoYlWBrlqCn8CDo1Wc8+X61JY2tr?=
 =?us-ascii?Q?/fi4ClfEJJ6LERc+xkiJtRboKNcUvAy4/YFJcx+1Ll/BF5wZ/eJR8+yjXq3H?=
 =?us-ascii?Q?n8rYABWTaqc5RMh/gkIW/W2UDPRq86MMrlf1xoHLHpWnUPTVolx5p09abwHC?=
 =?us-ascii?Q?XEmu4QUs4A8oO4gj0kGHQ+b3B9bsI6PDiNQKJrFHUJPt6yc6C2OUPOZfixQk?=
 =?us-ascii?Q?Me6UiQzLHGhf41D5bk+vpS2efK8Laj0seLwIcDSKfdd4hGfHOohGTg2TRjb1?=
 =?us-ascii?Q?gzfnHfkW97ozYcAywD39aat1kYItZ3zsqWoA3/OMRGUYQ5pdFBa0wjC9ipi+?=
 =?us-ascii?Q?Fk+OYlRzzbTvn6sRM789bQyE7nSI5qJvYehNNpHwKqR3nv1JVPfvi1cT9kjp?=
 =?us-ascii?Q?WZMMmVVMggsUpaNHIAXAWT4khlpWgC5ofbuJgI+zwdOsTPs5oAavIPtB60od?=
 =?us-ascii?Q?MXjtbZPkS3ic7CQMM41rxRqc4BAWT/lfpVALb3TSyN08xptJEKOeXFDNpdCB?=
 =?us-ascii?Q?NvcypORplQJIC0PRtqIX4R+XL7jx7hmjSb6a3N1AvNb6GI3E+GereTB6wdn4?=
 =?us-ascii?Q?SwrQE6kTu1fPYYT++DEav4fkt/4KfxqkG6w5QMC8FTTxbeqZYlF740FgTrOS?=
 =?us-ascii?Q?RgiSY1EPwdwpqkKTtW9UAP9CZMXbtiVpk8n7n8HE93CuLLMDF41WSdgIw6Md?=
 =?us-ascii?Q?N1frj2Hp0gYZQsYRi0iXVJvGZhDFpfhJEWIJhfyii8ouT08fz+DPOHTWqgFp?=
 =?us-ascii?Q?EHfWcqDOHstYFYPI3Wkby+jlM5+WvB1bLi3zG+HWDNEtj3d74Y0qxfXENLTa?=
 =?us-ascii?Q?lS7a7P4YjzyEx7glc0sO+hlHopaKhixd/L2s3JabdTbdlWTyREUnlmiItPSe?=
 =?us-ascii?Q?xfitq9WS6FjSztNj1R69zxCY2Btymq3aPQpz5h24hYSmwfx6qhkG27gnZ8Rs?=
 =?us-ascii?Q?KRQ7ScAwr86dv+N6njXjUBK78sv8gguC/3P/H34x6JUWTPUABdo5bg5vz7bN?=
 =?us-ascii?Q?/qIN8IKWfoLDJvOFEW0BOfhyrSBbJ+xvfw1GNzV3c7/1lo4lPNeT+jJieZSo?=
 =?us-ascii?Q?AHKjuRJ7DxCsniVBRMomqPp8Xw8cHQCswytbwcIbl588lq0vt5jfbzxGG0ow?=
 =?us-ascii?Q?PnDQ5OP3XuOoA7oYDG7sqJ6HnWelYUqeCNi1ljzkgFLzoqVbRkK2h8aeCGE4?=
 =?us-ascii?Q?VPTEBKhc3vKYGJPzcfkI2VOojuar60lrxjHvaKOczmS41Cuqn4+TOm1/11qT?=
 =?us-ascii?Q?iG4UoXc80fglJhEsxc4M5P3otGkmvzX/xn6YSyO9NF05II4lJT4n1PxLXdUV?=
 =?us-ascii?Q?/F2srZbLgFDoHBi5A4FODAvbgb81WMF3WePZOQiT+x1YQL3cI5J/uFC1Xi+/?=
 =?us-ascii?Q?O6UPzuJ8sUY+A395MezB7g8Z8GJkic3OndjAl70duoZgZsfIlyP2FlP6iAfr?=
 =?us-ascii?Q?5i4ZCGPkzrd9BINzxZxXPq7qUtj3DkN59Uwua+V52fj9M9q9gorIHEiNOafd?=
 =?us-ascii?Q?X5suGmJkN4fFtv4OBLaLHFdlg6inKUQb3nffx2vM664tLqjAoAJCMcjFc6hU?=
 =?us-ascii?Q?zNWCNJizOs4o/stOzbpiY5yFrs/mi2cNLm5cw0CPmtbByStFfw13ftDQAjhL?=
 =?us-ascii?Q?eA=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d519742-79c4-4d16-e68f-08daa342bd41
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1001MB2345.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2022 00:20:26.8009
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4VSYZbsMy8YTBYgnXWlUCs+ECPidnasJhme9jSREsPDKA0DxPWlUwcfuV/iQbLkARyfyLmp/YWzHjL49vxmL0sqYU/LeP6eGCZ4EZQW4PRo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5805
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 30, 2022 at 02:15:58PM -0700, Colin Foster wrote:
> On Tue, Sep 27, 2022 at 11:26:00PM +0300, Vladimir Oltean wrote:
> > On Sun, Sep 25, 2022 at 05:29:26PM -0700, Colin Foster wrote:
> > > ---
> > > +      - phy-mode = "internal": on ports 0, 1, 2, 3
> > 
> > More PHY interface types are supported. Please document them all.
> > It doesn't matter what the driver supports. Drivers and device tree
> > blobs should be able to have different lifetimes. A driver which doesn't
> > support the SERDES ports should work with a device tree that defines
> > them, and a driver that supports the SERDES ports should work with a
> > device tree that doesn't.
> 
> This will change my patch a little bit then. I didn't undersand this
> requirement.
> 
> My current device tree has all 8 ethernet ports populated. ocelot_ext
> believes "all these port modes are accepted" by way of a fully-populated
> vsc7512_port_modes[] array.
> 
> As a result, when I'm testing, swp4 through swp7 all enumerate as
> devices, though they don't actually function. It isn't until serdes /
> phylink / pcs / pll5 come along that they become functional ports.
> 
> I doubt this is desired. Though if I'm using the a new macro
> OCELOT_PORT_MODE_NONE, felix.c stops after felix_validate_phy_mode.
> 
> I think the only thing I can do is to allow felix to ignore invalid phy
> modes on some ports (which might be desired) and continue on with the
> most it can do. That seems like a potential improvement to the felix
> driver...
> 
> The other option is to allow the ports to enumerate, but leave them
> non-functional. This is how my system currently acts, but as I said, I
> bet it would be confusing to any user.
> 
> Thoughts?
> 

Also, for what its worth, I tried this just now by making this change:

err = felix_validate_phy_mode(felix, port, phy_mode);
if (err < 0) {
        dev_err(dev, "Unsupported PHY mode %s on port %d\n",
                phy_modes(phy_mode), port);
        of_node_put(child);
 -      return err;
 +      continue;
}

This functions in that I only see swp1-swp3, but I don't think it
should - it is just leaving phy_mode set to 0 (PHY_INTERFACE_MODE_NA).
My guess is it'll need more logic to say "don't add these DSA ports because
the driver doesn't support those PHY interfaces"


[    3.555367] ocelot-switch ocelot-switch.4.auto: Unsupported PHY mode qsgmii on port 4
[    3.563551] ocelot-switch ocelot-switch.4.auto: Unsupported PHY mode qsgmii on port 5
[    3.571570] ocelot-switch ocelot-switch.4.auto: Unsupported PHY mode qsgmii on port 6
[    3.579459] ocelot-switch ocelot-switch.4.auto: Unsupported PHY mode qsgmii on port 7
[    4.271832] ocelot-switch ocelot-switch.4.auto: PHY [ocelot-miim0.2.auto-mii:00] driver [Generic PHY] (irq=POLL)
[    4.282715] ocelot-switch ocelot-switch.4.auto: configuring for phy/internal link mode
[    4.296478] ocelot-switch ocelot-switch.4.auto swp1 (uninitialized): PHY [ocelot-miim0.2.auto-mii:01] driver [Generic PHY] (irq=POLL)
[    4.312876] ocelot-switch ocelot-switch.4.auto swp2 (uninitialized): PHY [ocelot-miim0.2.auto-mii:02] driver [Generic PHY] (irq=POLL)
[    4.328897] ocelot-switch ocelot-switch.4.auto swp3 (uninitialized): PHY [ocelot-miim0.2.auto-mii:03] driver [Generic PHY] (irq=POLL)
[    5.032849] ocelot-switch ocelot-switch.4.auto swp4 (uninitiailized): validation of qsgmii with support 00000000,00000000,000062ff and advertisement 00000000,00000000,000062ff failed: -EINVAL
[    5.051265] ocelot-switch ocelot-switch.4.auto swp4 (uninitialized): failed to connect to PHY: -EINVAL
[    5.060670] ocelot-switch ocelot-switch.4.auto swp4 (uninitialized): error -22 setting up PHY for tree 0, switch 0, port 4
(repeated for swp5-7)

