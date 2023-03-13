Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A325A6B7715
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 13:01:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230428AbjCMMBG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 08:01:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230440AbjCMMAx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 08:00:53 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2136.outbound.protection.outlook.com [40.107.244.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1A90580F6
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 05:00:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KRgVELmnbiUPQVepMl5xlzLd16IEt9eo+Ec8FKIpT5Iulemc7di3f+lq1dl/uVueDkUJxrKWRALLlfcPbeKieNn7BODeCNtAfT1mEhy3ugiVC2hVMi83ww5NWHQ3bK0oF1ZH1uuUA4S+RRSNdOqtd15MVMy86E6NPCkTbCeu9SnbsddN7PU9HVKJrmrSuoTvFp4hpwW2whkpmKIc/DZkfxec3062cQiqwuui1jTzmBkOLAOxjW9dWOCVbQ5pEiZxlAlMsrg3W11Ja23jjkchjgWAV5r6+hSGAep29qRQVbP/SeOgLxOGsXM1T/z3U84Zw3cOX1tKsj4MQ0YN7tt1yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h5syEYdPEkvWqxCeJnxe9E7KtWurwIZQo/T+dC2OOnY=;
 b=eHB0iWsu+pJZLvomU/fFg9rHUb1tHF/6qXzlst9tx/8sp700a1HS3NmZr+IVr6MptWkZi7N6KvYC6Ue7k52XU5Zsp/hvNUc93dD9T+ybAIiTdpjN5PxCJ9NaUWggwe+fldXHn0cFlLGVrErf/vICPkVBI/2mRPdTtDUlM/yqeSoWcdEQY55TVlM/QKDc3XUF1RTGLqNsBw8+RGc6vfu/4hKA5hruFJboJRDMiHfhiefQOe+TvkcpzXXGK0t1jqcdiRERuz5vUkTD3TlKc3J4kHi+D8mqXGEEHznvfJQeQfZC5j5czQVKCPfQLuG5/2iz6pbR+XmG7vlZhNXF5REcLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h5syEYdPEkvWqxCeJnxe9E7KtWurwIZQo/T+dC2OOnY=;
 b=lwqMzp2p2KHEIPl58jIPJs96rREo+QpWNEyUyn+wPZmy8CEEACipgZg5lpneoQ7PYCD835p2Cb9679Jw9n/gQhEPOfwY+USe7rRZxt1iCYlo/yHXrQhX3OJawKDwwnTxcTQN44UIH+ScGGKZTdiEzD16PtsoyWTUVD/zjOYQqNM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5329.namprd13.prod.outlook.com (2603:10b6:510:f8::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Mon, 13 Mar
 2023 12:00:42 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.024; Mon, 13 Mar 2023
 12:00:42 +0000
Date:   Mon, 13 Mar 2023 13:00:36 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Russell King - ARM Linux <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] net: phy: smsc: use phy_clear/set_bits in
 lan87xx_read_status
Message-ID: <ZA8QZBfrg5S4NOc4@corigine.com>
References: <6c4ca9e8-8b68-f730-7d88-ebb7165f6b1d@gmail.com>
 <ZAntvsDrEtx/pIjA@corigine.com>
 <a7ae8bf8-7521-ebbd-82dc-6338f766b59c@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a7ae8bf8-7521-ebbd-82dc-6338f766b59c@gmail.com>
X-ClientProxiedBy: AM0PR08CA0034.eurprd08.prod.outlook.com
 (2603:10a6:208:d2::47) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5329:EE_
X-MS-Office365-Filtering-Correlation-Id: 274af4c3-21c8-41c8-158a-08db23ba920a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: no85Uvdbgg2kbMaZJ2L4/MlkF4fxvF0ibCXQufjckzvzel/D+RQ7LMkx4k6eJeRGfrYV2Obrhimhjrp7NJm2AWODARII+rL5SfTZUbbiRpv/lkasUG+jIuV/NCTQpGHWZJ5dC+9ru9UYcKbmhbh7LJjEyk2SVW3+ozQWflspryZp/05i2YXRUtU8O1m+JiW5Ya5oQaGlNvho1HoQmr2dknCn+MOfGk7gOI1DI9ViGYHH25XO2JdKSzelS5IrDKLq9E1pWNMRXzpmJ50NGDHF7GutiVxeRCBayN7mLBS7hj3JMqjJ6FDXPHpjd9V4G/fVWm+LTT88FPjp0EQMjEQ/a4BYX2pg+hTZsZ8u1fWgVaVsvxuoQZ++V5Ph/mYaQx9MyNDo4Zv5b/XgiqQp0Xs4XDLqkj5Glcw+Cr3umCk43Y8f56hp+t6sa3VaXTrP4kqog4dKKoaIZR17lBlVQiv9aTt+fciDyYYHpHq603CscZDUK5EN1YbQaAVAkAIX3xHT8S83t3ge+x14kuXtv4aCQDHN4b9bl8WpvabzRenI9ELOcI0tqKRGr+ElMnEoAJ9HGq0JLmBzswJ7MHtNJ4BGCu5fwYOm9HS+D4J/DEOZ/ylmcq1OHyhWmHP4hx8feMfi7vjjTOT+yJBuKOAI6NyAmw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(366004)(346002)(376002)(39830400003)(136003)(451199018)(38100700002)(2906002)(2616005)(478600001)(6666004)(6512007)(6506007)(316002)(54906003)(86362001)(36756003)(41300700001)(66556008)(66946007)(6916009)(4326008)(66476007)(8676002)(8936002)(186003)(53546011)(6486002)(5660300002)(83380400001)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ti8fIOJovmkGHtdnlmFxcGKEL3vx53uK+X9OF8yJberbWF3m3Hv2bCKJn0RU?=
 =?us-ascii?Q?/friZ0zFExBMZfvmp9hul+pII5iRQZ747fI6zCHvEZlItUTNjToNq8gfzN9b?=
 =?us-ascii?Q?Z+ICm0M6DUa7LoClnGI+EW87f9yqkztl19lDZOl2WJtJMI6G5nhWog8abGHy?=
 =?us-ascii?Q?pxeC5EbSTBhfSMOeFUBiCNg6PDcV2Sc/WIalSxs8XwTSbRTkxzuqQJzspVsl?=
 =?us-ascii?Q?Bmiauvb5pb2DNTsTjGJ6LIrZ1NSnQ38vc+gKg1S+RWFmaOVhechsvqctma1+?=
 =?us-ascii?Q?TH7yTmVpEzXIcDEYB0khYXsN3zC04ueCtb+0EfOivts3f+bwvW3T97uUlvJU?=
 =?us-ascii?Q?J0Tp4uYjWOSR4FEUCT17KyFBt4UEccRnBkO4wrNt9xNEma5MTKwGACl5jimt?=
 =?us-ascii?Q?hB6WvyPfGVO/UxtvuPNnxRr0Z5X5aROS25Qgz0x1oNXvJuJgSV5mDQe4rwWD?=
 =?us-ascii?Q?i8rdyw7eLtyRMTLC1qNJ+aGtzxRyKnF5SFahrxH8KxZLmys1fr4uBjrxwEqW?=
 =?us-ascii?Q?1uf8UpDLpXnAQcvBWNwLABs943v4QHt4TQrSFqcBT0lqf/CERVOsrcnQAwUL?=
 =?us-ascii?Q?k+hIpfz1DVxQCBFjEHBkHlgCKe+AaFDFZcU4NVG7dJ7fnE/C2l7GCyrj72TS?=
 =?us-ascii?Q?g9/PbRSN4tPqG/qjOXDpitEM04MiGHeTitzPeK88ed6MS6r1QU9nC93UggnJ?=
 =?us-ascii?Q?7Go6w43CaIlOvyevNVuYkSVsKdureKx7Vv4+J41IH2lGdFUf05ThG/Sv7lH3?=
 =?us-ascii?Q?nCvyV7s2ovw61A97UEEOYGU9Jse1+qWiaq5lBM9tQT+8I68R0S6/dyILS28z?=
 =?us-ascii?Q?loADJbkzSFlGY9NuuRmHqbbOZgZndO4bSk/foIV9Oq28d9dC/lUPuCQmKEQb?=
 =?us-ascii?Q?7CIQ8HI2xY7mE+xgPPVN99H6ArL8k6mph0I6JYzdP+YkQejyQEQzgCpTaqGo?=
 =?us-ascii?Q?XpapRWPVzFtj85dvX69SWP5vHo7JIVzc+nXAcBTkXcUfYCm1aYiRpTngN3oh?=
 =?us-ascii?Q?fbvxqjNzEcOJ9fLx4JX96sy68ytJZSxmuFvRVML7ImE4QX3/T7aL0Gc1m+aY?=
 =?us-ascii?Q?XP1SvxjQ1gxAcdbxrCnNiSdjIZos50lZGPCEcQQJb0CcArC/cnBIIiZV19x/?=
 =?us-ascii?Q?Wnhykjg8U4AE1KeV5tP9T3jtqLiiRmmLleAz30g8vtVkBK+ba8V4A9yLF63d?=
 =?us-ascii?Q?3uFxcEkCzryUAbpNV6DXLqC0u14NdLR4UiAMdyYdR4E9n97kBmR7//RSVkqX?=
 =?us-ascii?Q?SZEHG3G+1qfbMI1FCpckpDM693a1nv+4lCxN9QAln/mDOEKn6HsBCYmzEh/I?=
 =?us-ascii?Q?8RJFGAn+N8fqfnBz2ku8jl2fo4xQaCp+e2Jby/5x1fubci85FOYrYYm/3dl2?=
 =?us-ascii?Q?8tRGwKs2LrTc34E38bZa1H++kBJsbhKkq0fAoxVpOg/mOmMJcISdI5nwW6EM?=
 =?us-ascii?Q?Y7YMMXIkWNcZna8bbUyR0xLRpcRcAEJs4QBGA1zPU0/kpMU+/dDvU7No3ci4?=
 =?us-ascii?Q?lwQ3cq0/Pc87CkTlNHaZ+JxUItfhFRglX/id0eWco536VjGuAd2FCapS34T1?=
 =?us-ascii?Q?MC2LqsKQcDX1mQRgm4mDY15UpsSaTLfXadDDSft4YcwhbqAy+h4ldGiTdLm3?=
 =?us-ascii?Q?LIoZSefIAZvnPkgrKcDeM2MdNuZd7LgklALWRpvmLQQdACGeed+MGFn2+0d1?=
 =?us-ascii?Q?BzHqPA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 274af4c3-21c8-41c8-158a-08db23ba920a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2023 12:00:42.6436
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RnYi5IOmHcqJhnp3jvQq3Xgjs7vyVqjXIFh7En4T5B++z9QCVlcq+kY4i5pYTQqvN93d8gXFzZaBBJqZZ/OCBt+hPvgJ/E3UPbtM96N2+d8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5329
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 10, 2023 at 09:51:37PM +0100, Heiner Kallweit wrote:
> On 09.03.2023 15:31, Simon Horman wrote:
> > On Wed, Mar 08, 2023 at 09:11:02PM +0100, Heiner Kallweit wrote:
> >> Simplify the code by using phy_clear/sert_bits().
> >>
> >> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> >> ---
> >>  drivers/net/phy/smsc.c | 25 ++++++++++---------------
> >>  1 file changed, 10 insertions(+), 15 deletions(-)
> > 
> > The phy_clear/sert_bits changes lookg good.
> > But I have a few nit-pick comments.
> > 
> >> diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
> >> index af89f3ef1..5965a8afa 100644
> >> --- a/drivers/net/phy/smsc.c
> >> +++ b/drivers/net/phy/smsc.c
> >> @@ -204,17 +204,16 @@ static int lan95xx_config_aneg_ext(struct phy_device *phydev)
> >>  static int lan87xx_read_status(struct phy_device *phydev)
> >>  {
> >>  	struct smsc_phy_priv *priv = phydev->priv;
> >> +	int rc;
> >>  
> >> -	int err = genphy_read_status(phydev);
> >> +	rc = genphy_read_status(phydev);
> >> +	if (rc)
> >> +		return rc;
> > 
> > nit: this seems like a separate change, possibly a fix.
> > 
> There's no known problem with the current code, so the need for a fix
> may be questionable. But you're right, it's a separate change.
> IMO it just wasn't worth it to provide it as a separate patch.

Ok, I don't feel strongly about this.
Though perhaps it would be nice to mention in the patch
description if a v2 materialises.

In any case, I am happy with the correctness of this patch.

Signed-off-by: Simon Horman <simon.horman@corigine.com>

> >>  
> >>  	if (!phydev->link && priv->energy_enable && phydev->irq == PHY_POLL) {
> >>  		/* Disable EDPD to wake up PHY */
> >> -		int rc = phy_read(phydev, MII_LAN83C185_CTRL_STATUS);
> >> -		if (rc < 0)
> >> -			return rc;
> >> -
> >> -		rc = phy_write(phydev, MII_LAN83C185_CTRL_STATUS,
> >> -			       rc & ~MII_LAN83C185_EDPWRDOWN);
> >> +		rc = phy_clear_bits(phydev, MII_LAN83C185_CTRL_STATUS,
> >> +				    MII_LAN83C185_EDPWRDOWN);
> >>  		if (rc < 0)
> >>  			return rc;
> >>  
> >> @@ -222,24 +221,20 @@ static int lan87xx_read_status(struct phy_device *phydev)
> >>  		 * an actual error.
> >>  		 */
> >>  		read_poll_timeout(phy_read, rc,
> >> -				  rc & MII_LAN83C185_ENERGYON || rc < 0,
> >> +				  rc < 0 || rc & MII_LAN83C185_ENERGYON,
> > 
> > nit: this also seems like a separate change.
> > 
> Same as for the remark before.

Ack.

> >>  				  10000, 640000, true, phydev,
> >>  				  MII_LAN83C185_CTRL_STATUS);
> >>  		if (rc < 0)
> >>  			return rc;
> >>  
> >>  		/* Re-enable EDPD */
> >> -		rc = phy_read(phydev, MII_LAN83C185_CTRL_STATUS);
> >> -		if (rc < 0)
> >> -			return rc;
> >> -
> >> -		rc = phy_write(phydev, MII_LAN83C185_CTRL_STATUS,
> >> -			       rc | MII_LAN83C185_EDPWRDOWN);
> >> +		rc = phy_set_bits(phydev, MII_LAN83C185_CTRL_STATUS,
> >> +				  MII_LAN83C185_EDPWRDOWN);
> >>  		if (rc < 0)
> >>  			return rc;
> >>  	}
> >>  
> >> -	return err;
> >> +	return 0;
> >>  }
> >>  
> >>  static int smsc_get_sset_count(struct phy_device *phydev)
> >> -- 
> >> 2.39.2
> >>
> 
