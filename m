Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8AD05B6185
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 21:13:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230202AbiILTNT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 15:13:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230049AbiILTNQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 15:13:16 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2126.outbound.protection.outlook.com [40.107.223.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B64C631ED6;
        Mon, 12 Sep 2022 12:13:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DZJOCgYuJN31RI/qXloFDPg/8FRvNz5m0Auwr2xhjbmzmguE6+l+cAWBLI3tMMtvQx5+iHCAup+4ZApIt4y1epY2RY4/1yKlhQkWR0mRJBv9+neXwoZIl/KGg8tLTM6SvbgYzNZN8CvIC3gpVqaEkkoAERYM3CBwWgluERTv4sAYT/E8Astaa43hPdZa7Irj8G9OdNWUfEZGJOaQ+IYGa30pGReZuF2FCQ3sU8kcTSKWSCI1mSadujYYOB5eHs/rXx1hW7H1aPwkyTjWWEBEqlRyRI6quzH6EtWlYLEzR2jmh5pvJvW8ZreZDNcVckYY9/4sNsWBuhFQwFsccB0oVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QI8v1GEkLqIXutCUBnyJ8Yq813pLLOckjyRay4wj4hE=;
 b=AEfGQCMm8jORWuc7wn60+u6xnbNV5T/DvhOy7xk93FD34uzjbOzTbcN3koB2s3uIKqMa5GxoxIpDBOwspDj2dz35IVF2pzWM5ux1ed1PyRj0IrdbBer5f59q83s6Hof8oTFe54/j6GE+TonZLL/thkyPx3lJLZNmkSvTEAZSG456v76LrleiIXBvu8c79pPkAKjF3wwME/qkGaYjMZF7U5PALSWmK74+vqHatigdcdz6g35S3/6u7e6IOquQLsEXwNPADOlc+h5IyjqeYSkPbez3XGj9FT3bMxWS9dcWbfivLDr5pCxNx4qG89Mj/cUl/uzn+L87yjAN53zdHjCt1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QI8v1GEkLqIXutCUBnyJ8Yq813pLLOckjyRay4wj4hE=;
 b=l6k4OUfOiTtM7m4o2Lbf2RHvFONhjXF4NZTOMm++sROncEuXQzVkiN/2hbZR1NGbMtW7FXG5nj9RFkZV5dW2DbAA9HOrNJ9PZbN9a5M4bxCL9kyXeDAWWTvsWYvxR5dP5irQzUdKbd7WBsJwq4UHJDzMoauE20jP5tQJ9Hi5Jsg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BN0PR10MB4997.namprd10.prod.outlook.com
 (2603:10b6:408:12b::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.14; Mon, 12 Sep
 2022 19:13:12 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::38ee:4bfb:c7b8:72e1]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::38ee:4bfb:c7b8:72e1%7]) with mapi id 15.20.5588.020; Mon, 12 Sep 2022
 19:13:12 +0000
Date:   Mon, 12 Sep 2022 12:13:07 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Lee Jones <lee@kernel.org>
Subject: Re: [RFC v1 net-next 8/8] net: dsa: ocelot: add external ocelot
 switch control
Message-ID: <Yx+Ew796ZnVAn5YG@colin-ia-desktop>
References: <20220911200244.549029-1-colin.foster@in-advantage.com>
 <20220911200244.549029-1-colin.foster@in-advantage.com>
 <20220911200244.549029-9-colin.foster@in-advantage.com>
 <20220911200244.549029-9-colin.foster@in-advantage.com>
 <20220912172109.ezilo6su5w6dihrk@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220912172109.ezilo6su5w6dihrk@skbuf>
X-ClientProxiedBy: MW4PR04CA0284.namprd04.prod.outlook.com
 (2603:10b6:303:89::19) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f5513ff3-1cb0-45f5-7b4b-08da94f2d5e8
X-MS-TrafficTypeDiagnostic: BN0PR10MB4997:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ekNWmQ51n0QRe+lVg0ZZ6lnbLk0uIVJQnl1A3czTui5p63+61Z1MU3KSJsIx5MuaRePgDU6RBtg2KgFbPSbVFWIVy974lLCAWZTTE4rIYpdmIIy0AReFi1JWWqsm4ns8Wlp8QvHPR0kQhIAa56IDIjUEo8XE5PudGYRob6DPYDguzIrrC4AkrsK6lAbxyNQXkUC2bUBMIkwD+A2TZ/u98jW0++zwcqwbocfTRQjU/hkQ2JsEolSix6J/gMx8i/Kb85roB20AFRKWa4jwLCc4jXe9AQ9BRvSDzCpONx/A+ikzy+5dDiK1sm63gtqVUF7/FSSr77Kl629GobdO8Np+YGOWaU+NxJ3tIwGOQpqv4TRM1KGDUC6gmB1gJOZJL18PTZfQkqcCYmtKfaq7m84rvtw9gR0rFcLFre4XB63FXhskN3pePtgrF0EAcsVzcwapOcLzxaKaPLc0cntMzbo2jagoGp40HfU0UWD46fKCLe3Tu/cE01YhyEaaPRJYSQcpotO+1GSPbbrgzor6thGFx5LqQtYpXYEQ1dCqZPabs5G2l3K8TBqCI8FIsi7BOclj6hOTd+jipcqdBT9Itwc4X4tAPcwQKJwgTQh19f13ar8qjkk0dINPdIODDtj7TBpQhAjnb6DJ86q9J5xh0SODU48cK4cPvuS78pAZPRM/AZc0wTFGU7rEGFmftwqEe7tK6+uH9vD2Z+u1Zp3CEUZj0AxWD0CxxyL94IIsVaTuV8PEdIxbYnzI7/m5TxrnkCTOY3w8Ap3pv6HW7zmOhowSQQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(376002)(346002)(39840400004)(136003)(396003)(366004)(451199015)(2906002)(8676002)(86362001)(316002)(478600001)(5660300002)(66946007)(6666004)(6512007)(6916009)(33716001)(41300700001)(66476007)(26005)(44832011)(6506007)(9686003)(38100700002)(186003)(7416002)(66556008)(6486002)(83380400001)(4326008)(54906003)(8936002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rhQ7OALoEYPTnDAg41f20cSr9IXE35oBHewugeLoLRE64Kl8idRg06ec3eWh?=
 =?us-ascii?Q?PFIPc7ABxI+Ob/ET0iRTXjD02bTZ1SErZduXbiNN4OnHNMaJzxbuVCBFCAEl?=
 =?us-ascii?Q?hN0DIgnQlBQFxoY089bYwM6IMgP987eZOQ1x0DDK/lg6DWEOzv3AFUn2frM2?=
 =?us-ascii?Q?kGysXuG7LMn4ufOS9uuEXKe/AiD4Af4ik6csTE246d3lBvPBuhZCDYRYDzuQ?=
 =?us-ascii?Q?v1nUN7+Twlv/J8zBANke6VI1HBVaOd0mWodHx5AhVbYQXOtenXpdP0o/uSFa?=
 =?us-ascii?Q?gdcZzEO3U/RzgM/0GnHyXBbzxXlPYJ+eyckKsuPKZ70ogK5+WnP/IQz6P7El?=
 =?us-ascii?Q?hShldV/Fwn/CrFBCx027DABCnTAYadcsXrCH+ZvjGh9NyRE6BdMR+kyuA65e?=
 =?us-ascii?Q?dRRrhOAZRnZnXPutHMjuoj2/euFUtDH+NJ+OjT6zQhLd2OnsD6qBO9pfHnpZ?=
 =?us-ascii?Q?ZUdmPR+VpOG1zb8KlA/9Rjf251dfxHi95XxQObIVswMMyEP123QfnxlHaGEw?=
 =?us-ascii?Q?WHnS8clZ4OVjaK9g5ea7UifJ7Ddjc6ud7+oK7YwVi8MFrCtEr44cuJTJoSai?=
 =?us-ascii?Q?d29HLYbm8EFew6SBDPSI9h6Yr1nwYXAZB3Q/QDFdamC+2TXBgqENNWlyaBYR?=
 =?us-ascii?Q?EpVZfCAckM5v+RIJZ7pdJIsd6EbaPBc5St2Z2AhDr06zsvQVWsPLiLcyCNyX?=
 =?us-ascii?Q?H+uEZPRJhjE4t42TdE1OpEVsJacZnSHrv+tMcdpuaoC+vndvR7EhW/eElCc4?=
 =?us-ascii?Q?RFqJ+2KYBdY3pnMqU6fXVvNOaQeIXbzYes/r+oBWIyiBxaQjFJ2d+qr9HEUW?=
 =?us-ascii?Q?CqYHv9xUi7SdiX+tOxVxaQdIGs/yq1mmZHzbir6lJRUPFOLlAhJrSwR0K0sc?=
 =?us-ascii?Q?qYhUyOIAlVnFF7Wp3/VteBtoZ2/Bb+LYcGEEuEgb4+pnUfVwxtoOZuhd4Wxm?=
 =?us-ascii?Q?jllLShy1B+I06lQ81QYqg/YFYuJ8l5KUVxiQt6ZcE1pT55DNA8ywue5Djq3M?=
 =?us-ascii?Q?McBgbI+9aYgsovo7+fdMvsDo7qAe25W+DUAmk0an4G1bvjtfCen90mT11be4?=
 =?us-ascii?Q?zSuJ4ykNNV8PAMbaWsROun65sFz7Z9AWlC1am29DvxqXOzb3OSFKPhM8ANsH?=
 =?us-ascii?Q?e3UtbmccGEgYHPKxDf0emc4vPYXEUm7Xwywpa/QmmlIp0WV6LNFXpuHQFmbp?=
 =?us-ascii?Q?AwKM9VB6ETVRWS5dyN9HSYtc0yh4Ej1M2+1i4NDaQBiI5jt113O3Ec4Gu9iS?=
 =?us-ascii?Q?K0ATPNm+4vYRMmVgzxQF0RMGi9QLS4/HB85+HCEHCl6QEcR2g0UkJxOmsLzu?=
 =?us-ascii?Q?sGo0Aet2Ghl11QgYzknsBKcZnizYpoXJAeEw1QRM0mu6js3jz4vPawFW9dfK?=
 =?us-ascii?Q?0L9E6XhF76bWg4Eor8gh0TJgnnBvANUGlVXZ9HsPUl2CWzz3S3zkPbGvBXVC?=
 =?us-ascii?Q?zVBM2CuIQeEG7M4/+KoRoXt/Roahb/UwziDRWGNi7Bei/hLTJ6B6bWBv6XF6?=
 =?us-ascii?Q?RANACaMC0hhajSz0XbdSg6m97W0FqIJeCcVayU9sC098gZ012x9Y920HBcY/?=
 =?us-ascii?Q?hOgyVj/bfYHwiTP8UGevhiR8FohytFfAhmCcIIcq/TH5183JOvIdYWCrHp6Z?=
 =?us-ascii?Q?owKf+C4Q4fn4e3F6Xx+tsPQ=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5513ff3-1cb0-45f5-7b4b-08da94f2d5e8
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2022 19:13:11.9844
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0Rj0kTfFbYaVBOj2Qpd9F16H8SoGoOjyEoaFOvGZFavWDnRFu/NRnjag/HiPWwoVVqvybbgUzlh7SqFP55RC7OLQiLIdbXTVihXnGWJR1Vs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4997
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

On Mon, Sep 12, 2022 at 05:21:10PM +0000, Vladimir Oltean wrote:
> On Sun, Sep 11, 2022 at 01:02:44PM -0700, Colin Foster wrote:
> > index 08db9cf76818..d8b224f8dc97 100644
> > --- a/drivers/net/dsa/ocelot/Kconfig
> > +++ b/drivers/net/dsa/ocelot/Kconfig
> > @@ -1,4 +1,18 @@
> >  # SPDX-License-Identifier: GPL-2.0-only
> > +config NET_DSA_MSCC_OCELOT_EXT
> > +	tristate "Ocelot External Ethernet switch support"
> > +	depends on NET_DSA && SPI
> > +	depends on NET_VENDOR_MICROSEMI
> > +	select MDIO_MSCC_MIIM
> > +	select MFD_OCELOT_CORE
> > +	select MSCC_OCELOT_SWITCH_LIB
> > +	select NET_DSA_TAG_OCELOT_8021Q
> > +	select NET_DSA_TAG_OCELOT
> > +	help
> > +	  This driver supports the VSC7511, VSC7512, VSC7513 and VSC7514 chips
> > +	  when controlled through SPI. It can be used with the Microsemi dev
> > +	  boards and an external CPU or custom hardware.
> 
> I would drop the sentence about Microsemi dev boards or custom hardware.

I'll do that. Also I need to add a paragraph (according to checkpatch)
about what the VSC751{1-4} chips actually are.

> 
> > diff --git a/drivers/net/dsa/ocelot/ocelot_ext.c b/drivers/net/dsa/ocelot/ocelot_ext.c
> > new file mode 100644
> > index 000000000000..c821cc963787
> > --- /dev/null
> > +++ b/drivers/net/dsa/ocelot/ocelot_ext.c
> > @@ -0,0 +1,254 @@
> > +// SPDX-License-Identifier: (GPL-2.0 OR MIT)
> > +/*
> > + * Copyright 2021-2022 Innovative Advantage Inc.
> > + */
> > +
> > +#include <linux/iopoll.h>
> > +#include <linux/mfd/ocelot.h>
> > +#include <linux/phylink.h>
> > +#include <linux/platform_device.h>
> > +#include <linux/regmap.h>
> > +#include <soc/mscc/ocelot_ana.h>
> > +#include <soc/mscc/ocelot_dev.h>
> > +#include <soc/mscc/ocelot_qsys.h>
> > +#include <soc/mscc/ocelot_vcap.h>
> > +#include <soc/mscc/ocelot_ptp.h>
> > +#include <soc/mscc/ocelot_sys.h>
> > +#include <soc/mscc/ocelot.h>
> > +#include <soc/mscc/vsc7514_regs.h>
> > +#include "felix.h"
> > +
> > +#define VSC7512_NUM_PORTS		11
> > +
> > +#define OCELOT_EXT_MEM_INIT_SLEEP_US	1000
> > +#define OCELOT_EXT_MEM_INIT_TIMEOUT_US	100000
> > +
> > +#define OCELOT_EXT_PORT_MODE_SERDES	(OCELOT_PORT_MODE_SGMII | \
> > +					 OCELOT_PORT_MODE_QSGMII)
> 
> There are places where OCELOT_EXT doesn't make too much sense, like here.
> The capabilities of the SERDES ports do not change depending on whether
> the switch is controlled externally or not. Same for the memory init
> delays. Maybe OCELOT_MEM_INIT_*, OCELOT_PORT_MODE_SERDES etc?
> 
> There are more places as well below in function names, I'll let you be
> the judge if whether ocelot is controlled externally is relevant to what
> they do in any way.
> 
> > +static int ocelot_ext_reset(struct ocelot *ocelot)
> > +{
> > +	int err, val;
> > +
> > +	ocelot_ext_reset_phys(ocelot);
> > +
> > +	/* Initialize chip memories */
> > +	err = regmap_field_write(ocelot->regfields[SYS_RESET_CFG_MEM_ENA], 1);
> > +	if (err)
> > +		return err;
> > +
> > +	err = regmap_field_write(ocelot->regfields[SYS_RESET_CFG_MEM_INIT], 1);
> > +	if (err)
> > +		return err;
> > +
> > +	/* MEM_INIT is a self-clearing bit. Wait for it to be clear (should be
> > +	 * 100us) before enabling the switch core
> > +	 */
> > +	err = readx_poll_timeout(ocelot_ext_mem_init_status, ocelot, val, !val,
> > +				 OCELOT_EXT_MEM_INIT_SLEEP_US,
> > +				 OCELOT_EXT_MEM_INIT_TIMEOUT_US);
> > +
> 
> I think you can eliminate the newline between the err assignment and
> checking for it.

Yes, you've pointed out this habit of mine in the past. I'm sorry you
have to keep reminding me - I'll try to commit this one to memory now.

> 
> > +	if (IS_ERR_VALUE(err))
> > +		return err;
> > +
> > +	return regmap_field_write(ocelot->regfields[SYS_RESET_CFG_CORE_ENA], 1);
> > +}
> > +
> > +static void ocelot_ext_phylink_validate(struct ocelot *ocelot, int port,
> > +					unsigned long *supported,
> > +					struct phylink_link_state *state)
> > +{
> > +	struct felix *felix = ocelot_to_felix(ocelot);
> > +	struct dsa_switch *ds = felix->ds;
> > +	struct phylink_config *pl_config;
> > +	struct dsa_port *dp;
> > +
> > +	dp = dsa_to_port(ds, port);
> > +	pl_config = &dp->pl_config;
> > +
> > +	phylink_generic_validate(pl_config, supported, state);
> 
> You could save 2 lines here (defining *pl_config and assigning it) if
> you would just call phylink_generic_validate(&dp->pl_config, ...);

Fair enough. Thanks.

> 
> > +}
> > +
> > +static struct regmap *ocelot_ext_regmap_init(struct ocelot *ocelot,
> > +					     struct resource *res)
> > +{
> > +	return dev_get_regmap(ocelot->dev->parent, res->name);
> > +}
> 
> I have more fundamental questions about this one, which I've formulated
> on your patch 7/8. If nothing changes, at least I'd expect some comments
> here explaining where the resources actually come from, and the regmaps.

Yep. That discussion should address everything anyone might want to
know. Wherever this lands, I'll make sure it is clear to the reader.

> 
> > +static const struct of_device_id ocelot_ext_switch_of_match[] = {
> > +	{ .compatible = "mscc,vsc7512-ext-switch" },
> 
> I think I've raised this before. How about removing "external" from the
> compatible string? You can figure out it's external, because it's on a
> SPI bus.

I believe you're right. I'm sorry that slipped through the cracks.

> 
> > +	{ },
> > +};
> > +MODULE_DEVICE_TABLE(of, ocelot_ext_switch_of_match);
> > +
> > +static struct platform_driver ocelot_ext_switch_driver = {
> > +	.driver = {
> > +		.name = "ocelot-ext-switch",
> > +		.of_match_table = of_match_ptr(ocelot_ext_switch_of_match),
> > +	},
> > +	.probe = ocelot_ext_probe,
> > +	.remove = ocelot_ext_remove,
> > +	.shutdown = ocelot_ext_shutdown,
> > +};
> > +module_platform_driver(ocelot_ext_switch_driver);
