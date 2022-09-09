Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E20925B3EE3
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 20:34:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbiIISeJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 14:34:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiIISeI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 14:34:08 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2096.outbound.protection.outlook.com [40.107.237.96])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E242D861EC
        for <netdev@vger.kernel.org>; Fri,  9 Sep 2022 11:34:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W7ODo3Rp+Mr89m0QSTlWPr+7BTPACKS7obVVi8CcGycdDioiv+KQhENDrO1jJINaOS6lDPvzWOlUddWO/PBSvQEnC99h7THbPoJWXgwJdAXeJEi8ZCAH+SAWE5kxl1B990hUQKLNW9HdIXwxuYtcyogWNJYHDz5Rg+6Vx4ZfrVbrMZ9DdOEn7kNf0ug0ZO3RBUGDcGmtUwxt8rDokHPkE6JxJOB7FwuqSi90Hsyc/ojARSZ07IVKFODlRaZSCEyO42CRroOVMhTRkehWjtxZmU3mkySeInyMbZ5IkbY8KxuvQjA6BmNhxx39MijmnLV0exr7WKP/eQF9X/XXffengg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GmuqPCQ4IC/jsjMq8dmowZK9gKemnmELuoCVXK4W1/w=;
 b=bsPGpdoFsNysKqyNEhcgNikWUQ8rWQZlJJaBL54HWW30vveZHgPyE0jl28r58tIoi3fuxluBKZD7eRO3Fm57YqDXPMmSlwPF+zkg5jxRUyqLfbbpLON/AgSOc4hJ9t6Y0WyU9b+6LDkMM3moDw6aik5wSzlr2QVcgcyZ4bz0LRCACjJJNZPAPR4FH7eHdYxBkTdXVcUDN+PhkTPsCTkxGP26eZvhUzmBWa9bqBKeBDiXBhYRVUfnffGlb/q/s8mce5PPfcy165scFK8wJ4vM5ED3COWTsU0KVkTwH/XegzDeDb4sUvJZ16zEqVxAno4YRzAdLvgavwKMhdq9/QaCdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GmuqPCQ4IC/jsjMq8dmowZK9gKemnmELuoCVXK4W1/w=;
 b=r9MPymj9LajUj9P49zaGvGth4k1BSzn0O3IJY3p+b0wOBEJC0ITkOM40RGkHz6C1HB5lmJiLuMycAjfZnJIMCl7M0V+qkr5w3M7hGV7apDDkONNApUm/LkvLuuZMW77HGPLS88+6821RN9jAZ/zKp9+/i5x1sIUOxccMpr2wsH8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by PH0PR10MB5778.namprd10.prod.outlook.com
 (2603:10b6:510:12b::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.12; Fri, 9 Sep
 2022 18:34:02 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::38ee:4bfb:c7b8:72e1]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::38ee:4bfb:c7b8:72e1%7]) with mapi id 15.20.5588.020; Fri, 9 Sep 2022
 18:34:02 +0000
Date:   Fri, 9 Sep 2022 11:33:59 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: Re: [RFC v8 net-next 15/16] net: dsa: felix: add phylink_get_caps
 capability
Message-ID: <YxuHF4UrUEJBKmcu@euler>
References: <20220508185313.2222956-1-colin.foster@in-advantage.com>
 <20220508185313.2222956-16-colin.foster@in-advantage.com>
 <20220509103444.bg6g6wt6mxohi2vm@skbuf>
 <20220510002332.GF895@COLIN-DESKTOP1.localdomain>
 <20220509173029.xkwajrngvejkyjzs@skbuf>
 <20220510005537.GH895@COLIN-DESKTOP1.localdomain>
 <20220509175806.osytlqnrri6t3g6r@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220509175806.osytlqnrri6t3g6r@skbuf>
X-ClientProxiedBy: MW2PR2101CA0017.namprd21.prod.outlook.com
 (2603:10b6:302:1::30) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9e3b351d-5a8c-4f20-9557-08da9291de33
X-MS-TrafficTypeDiagnostic: PH0PR10MB5778:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +baMw4k/2rlQHm4UGAiP1ySdCEBeeOuU550ieq64039B1ug2aV12/zPvb3crMXTKCVrQfbW+R+ZJqfEACMRTTppXe71bcF6ER6V9FZAlCsVX4jCkvPvYbsc9DLCHwoAlGvw+XDAz1IizizFGy7XXvrNNGljuHlVNlAPeMn9hKx5bSt9bsDiKtssOwqfNYKZuz2+ChOjaB6bdl4y7I7GiQ37ni5o5eco71pb3MPry1KxmPRiipzVivBXZ3sOVZerQGM917XIc8xarJal5vFlra3b8NE3EIzXvKHv5vnKKSpshP3+EDgNli37jLFGbJZtJeVdjXyZqpBiP98OIrADE/qz9DS/05tmsTenpikSD3Ly9US66nycHXM5WR0YjHhdX1Td1lIU/Exj2s2YIzXjWMKnGjEtkQvL56k0/pCCk1bqWOCDX/y/urReqOP8Sez0mpmDhw77Th6ZY0WWcc79DILANgDorHC0VtT7DZW3WE+fTB1RtnSbCA+H0c4gqlD1OpMhlkSb0CZq7fOUZRvejjHfHtbThwF6r7OnxI/hH9KlRy+8YirVZUtooUPZ+/MHjOg4DWvac/y1dEoZxyNoiGXiOLx8M77OHg3g7fD3gfNOcUWz2n1IXwEVFBM2Kp0Jak/4NAAg8PYw/l4Gl5OYqRKaZTWsB8GIz6hlHo7OXDWYDTZ3wXZvlHBMLSK61ALbo/v9xXxkODXIGGLlM+lW0hQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(136003)(39830400003)(396003)(376002)(366004)(346002)(66946007)(6506007)(6512007)(38100700002)(2906002)(86362001)(9686003)(186003)(26005)(83380400001)(33716001)(8936002)(316002)(44832011)(7416002)(66476007)(5660300002)(8676002)(41300700001)(478600001)(6666004)(4326008)(54906003)(6916009)(66556008)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wpXoWxTnu0UmaFP8MWXxYqO7/tIjzNvk8vGyb5ZmuZXietOkYWKOcFy3zv4T?=
 =?us-ascii?Q?SS8jfLQWxCctJOBXOTlt+0SnmLfxpAupUa+xj3jMC853SRm+qLoiSwm07fF1?=
 =?us-ascii?Q?yJIWa5KeRA5VcBoGW8y9ouJSWFmrCHGlL8gZVNhJOof7yk6IcZPr02usSY2F?=
 =?us-ascii?Q?4O4kIiN+y30XZXf4E/r5hQyRxac+xgH2+Ky1RcAnMvgzvKw2xmfDXxIUevg6?=
 =?us-ascii?Q?0rF09KFka8JQ44iUItSypT+4d0nyAmjREQi8Rkhs8yY8tHS7PWyYoQ/l+/vF?=
 =?us-ascii?Q?JmJQi14iMwHdZfEacQq0ed6PxSFlQSLskIaZ5mw18lfzze/67KjwxgICmPXr?=
 =?us-ascii?Q?3RyUOOwr0dQKJGqYii/KT5QeaKVENCcIWqEcA2obQVf6XTO5sLrFK81MWNdc?=
 =?us-ascii?Q?zuDDWco3O+GQJX95suFCBTIF9/9KVQ350tcBw8LBU7z6CdAHFHmSJth67qQm?=
 =?us-ascii?Q?4otDMfGjDgOEjK0vKSfbsc9QR7K28D9Zt/oEDp01gz6t070FbcMI+M3oHhJo?=
 =?us-ascii?Q?BFnWzatJWe63W0zzEFwhNO5sK5Pr0ba+MhyYsG3u/usfGnPYHGj5/SMBmKj5?=
 =?us-ascii?Q?KD6RQ08iNdYyinm3LKvHqnTRkmG1elSqxCZEwXyTjDiMi40M8QUbsTRFLABX?=
 =?us-ascii?Q?qKh6rhMOn+R1O01bBDqgR4qnRDpFwKQjOUD2jpQflMya5DtNUYu0Z9IR1Ogw?=
 =?us-ascii?Q?SKdLiWZbA3oNSWvpVN5z8n2Jd+pC4Joi0iuWzCeshF4471LULGHSk1C7x3w3?=
 =?us-ascii?Q?l9CUP0f/CerUKdepDKwapWvg8OmpBd8c391a/NJNSqFGwbx5aWb6LBUdsvJg?=
 =?us-ascii?Q?6BtvUAvvl7W3//RxGHwWz8+dkBJ1IGzkpw/RzWEPq2JCm+B1mPUQmhCXCAJK?=
 =?us-ascii?Q?2dDIq/BZuQEqWuCFrF3Iil0+gXS+mdGiN4lwreQLU3j5VjX9IC2KsztArZqh?=
 =?us-ascii?Q?OSGfGRgY9jrEGaqiVcVcsVdIM4ZG9KpUhyfUfQZRVVpeLhitQpCKVa77LLLh?=
 =?us-ascii?Q?tXrDb+zO4rECMqvgm9NpIirHhAJCpDYAcQ6nQloXyoR8IK31U9etpD3yCXfL?=
 =?us-ascii?Q?pfloZz4oZvB3g2h0+JJgRfBKkBcXbzBnZ7j8kzbhk7DqT4d8l6t18XpgWTMh?=
 =?us-ascii?Q?1ryqOyZLXL5inh++kcwc64EnjR2FvTSufOs7g6BelUi1UD0b8HpswKc9It1Y?=
 =?us-ascii?Q?8PTuB98NTRXovSWkEVt0NqhWTC5TsgYL3zkxrcKu1yF9WfWUtdVOr50sECvy?=
 =?us-ascii?Q?TRF5B2o7jI0IQGUrWtWYB5upiXusKrNCWoLia5Yc+l1rfDplnGPK328Etwbp?=
 =?us-ascii?Q?vwuzIuFlKAAhRNkuOI9FPmoIDROwqTxnrf6lRmrxeIDVzr9mOBzI752cHUPc?=
 =?us-ascii?Q?WF2E53Nm8ySW4Psx745KKSX43Q1SRT8vpbdk1woz+dmadUs+neshZBwjCV0b?=
 =?us-ascii?Q?Vmnt2Znf1+XL82uXUMr9jKHFoszwilZbPLt3JoJnN0a5e3Ip4IsxHMwfaJQ4?=
 =?us-ascii?Q?+hk2Gp1Y32FhrYN6u/TRMy+GwFQgXO2CE+NtG4IJZ12aFJUvdhJC2aBU3Sgs?=
 =?us-ascii?Q?/bulMVH6mXJAKHz6mPn/0IJrG1PTKsP+T0ut3ATHKuhf1IHt8LkGds4sI/6R?=
 =?us-ascii?Q?xg=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e3b351d-5a8c-4f20-9557-08da9291de33
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2022 18:34:02.5775
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rJ0YTxtGjJg7AygfxOgictluBSjBUTD356skQvWDo/St1cUlJnc++6QggAw3BMRRdnUfZ5PKj4cUqJqZt10YNCU409ehaHTgi1S7UsCOtyg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5778
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 09, 2022 at 05:58:07PM +0000, Vladimir Oltean wrote:
> On Mon, May 09, 2022 at 05:55:37PM -0700, Colin Foster wrote:
> > Hmm... So the main reason I needed get_caps was because
> > phylink_generic_validate looks at mac_capabilities. I know I'll have to
> > deal with supported_interfaces once I finally get the other four ports
> > working, but for now the main purpose of this patch is to allow me to
> > populate the mac_capabilities entry for phylink_generic_validate.
> > 
> > Aside from ensuring legacy_pre_march2020 = false, I feel like the rest
> > of the patch makes sense.
> 
> But still. Just populate mac_capabilities for everybody in the common
> felix_phylink_get_caps(), and use the generic phylink validation only
> for your driver.

Resurrecting this thread, now that I'm back into the networking stuff. I
removed some people from the CC chain who I think were MFD / GPIO specific.

v1 of my upcoming "add dsa capabilities to the vsc7512" will build off
these suggestions, but these DSA patches were dropped in the MFD set.


Restoring context: my oritinal patch was:

+++ b/drivers/net/dsa/ocelot/felix.c
@@ -982,15 +982,23 @@  static void felix_phylink_get_caps(struct dsa_switch *ds, int port,
 				   struct phylink_config *config)
 {
 	struct ocelot *ocelot = ds->priv;
+	struct felix *felix;

-	/* This driver does not make use of the speed, duplex, pause or the
-	 * advertisement in its mac_config, so it is safe to mark this driver
-	 * as non-legacy.
-	 */
-	config->legacy_pre_march2020 = false;
+	felix = ocelot_to_felix(ocelot);
+
+	if (felix->info->phylink_get_caps) {
+		felix->info->phylink_get_caps(ocelot, port, config);
+	} else {

-	__set_bit(ocelot->ports[port]->phy_mode,
-		  config->supported_interfaces);
+		/* This driver does not make use of the speed, duplex, pause or
+		 * the advertisement in its mac_config, so it is safe to mark
+		 * this driver as non-legacy.
+		 */
+		config->legacy_pre_march2020 = false;
+
+		__set_bit(ocelot->ports[port]->phy_mode,
+			  config->supported_interfaces);
+	}
 }


Regarding felix_phylink_get_caps() - does it make sense that
mac_capabilities would be the same for all ports? This is where I've
currently landed, and I want to make sure it doesn't have adverse
effects on vsc9959 or seville:

static void felix_phylink_get_caps(struct dsa_switch *ds, int port,
                                   struct phylink_config *config)
{
        struct ocelot *ocelot = ds->priv;
        struct felix *felix;
        u32 modes;
        int i;

        felix = ocelot_to_felix(ocelot);
        modes = felix->info->port_modes[port];

        /* This driver does not make use of the speed, duplex, pause or
         * the advertisement in its mac_config, so it is safe to mark
         * this driver as non-legacy.
         */
        config->legacy_pre_march2020 = false;

        for (i = 0; i < PHY_INTERFACE_MODE_MAX; i++)
                if (modes & felix_phy_match_table[i])
                        __set_bit(i, config->supported_interfaces);

        config->mac_capabilities = MAC_SYM_PAUSE | MAC_ASYM_PAUSE | MAC_10 |
                                   MAC_100 | MAC_1000FD;
}

(this might be two patches - one for the match table and one for the
mac_capabilities)

Seemingly because net/dsa/port.c checks for phylink_validate before it
checks for mac_capabilties, it won't make a difference there, but this
seems ... wrong? Or maybe it isn't wrong until I implement the QSGMII
port that supports 2500FD (as in drivers/net/ethernet/mscc/ocelot_net.c
ocelot_port_phylink_create())
