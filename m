Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C10545E2F8
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 23:23:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345722AbhKYW02 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 17:26:28 -0500
Received: from mail-dm3nam07on2100.outbound.protection.outlook.com ([40.107.95.100]:55328
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229735AbhKYWY1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Nov 2021 17:24:27 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dy3JXiKtIPNojW8eXVfGPlyJXxU4OOBSJ0DHoQSi49KwhmuNAFj2VVbbZFSP+jLULckp2Bv6LO6T0q2VKrvEBb3BZIu9rKFmyW9aQsBSXX7LnJ1o6f0NxUDfIc4XAq3KwLOnbsQ/QJWMQv2SrzohU/N6c41W0LDkZEnq0lLIg01QmcyTvQ78RMOYVCjGzUgrc5arna2tfJc7UqaBpxFFsuKxJWw0d7lbqffvmYuUi4jTcKegpljpnZsAU10QvK7qT8sXWyKGjC0Hh0u3CurOP3Ke0um5GxxOPjl3qGdIHxKQPW6yItDhN0czliB5cyLcfeEf5iMtZs+oICdxwIzc9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mFhPCcYB5dDgiEYEHw8dEcAkihNRCahF681l+51DIQI=;
 b=VNrjd/ylBFq3MY6Zf1nbHD/Lx45Ie3/3R3GeYrWAdhyhaDI2z0LwkNBQqGQGSj11iH6q6HwSziyFnAB4sNJZKPsSmOp4/72ntMmBA0Q3RxASS0XcKw41C8lbCyTYqaHAJMLVgtQKEJgUWQBMdqYYkkraZcBc5w2Th5oL1PvqdLOgTBsg271byXDTLZ2to9oxWAoeUZ1HnOfOefoxPc6vmdLSxjH//yd6p2+04pToi1HuYJO1iStEi1ee9gTovnJ9emTzFlgcWqt679O4atE7eIVGBHdTQgVTVrpJBkgIQjkNOyRkpzMzxuCfVJK60fi9b1s39L8wgHNNw6osZY+fog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mFhPCcYB5dDgiEYEHw8dEcAkihNRCahF681l+51DIQI=;
 b=x0CTP/wsoWVYEyYX6+KJgNhM0mMmpN/j58NnuysajT169G0SfeLBMQoAi3Y+y8P+bukoPWrVO2ZPD7IUoVvFnOVEsyg+LVYruPjH4OGfPDcMdFWbMdp+iej8CqX8HuFCbolc1zF+CX37NK/sdnZJi/Fmcz+qvHkUoY+kOTWoqAA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CO1PR10MB4482.namprd10.prod.outlook.com
 (2603:10b6:303:99::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.20; Thu, 25 Nov
 2021 22:21:13 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f%5]) with mapi id 15.20.4734.022; Thu, 25 Nov 2021
 22:21:13 +0000
Date:   Thu, 25 Nov 2021 14:21:06 -0800
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH v2 net-next 1/3] net: mdio: mscc-miim: convert to a
 regmap implementation
Message-ID: <20211125222106.GA3750811@euler>
References: <20211125201301.3748513-1-colin.foster@in-advantage.com>
 <20211125201301.3748513-2-colin.foster@in-advantage.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211125201301.3748513-2-colin.foster@in-advantage.com>
X-ClientProxiedBy: CO2PR18CA0044.namprd18.prod.outlook.com
 (2603:10b6:104:2::12) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
Received: from euler (67.185.175.147) by CO2PR18CA0044.namprd18.prod.outlook.com (2603:10b6:104:2::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.20 via Frontend Transport; Thu, 25 Nov 2021 22:21:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f374830c-49e7-4b9c-5368-08d9b061e3d3
X-MS-TrafficTypeDiagnostic: CO1PR10MB4482:
X-Microsoft-Antispam-PRVS: <CO1PR10MB448241E37D2710050975C0D6A4629@CO1PR10MB4482.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2043;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NaSa41+Pd/yndvO9E101jvO0ri82pd7yL48WQObgRE3lKyHd5eKs7xr5K6D56T8xwpoTTneXP7gO63AZamNLwQOOEcSzOfBdJFOp1KeoZuXc5lcsPYcEOCq9lyem4bkuBcgaMp5rUCtdz6Dn/7JCwqmKGFLYPSgqa2FTw2qblSVbfSuNtvwpsOXe8nWYLOwCJ0F3wXG3UZvAnBQWTH04qcrHRbqqd/4PLKVYK7YfUhTLRUMB12LqXZUymxo784fzR4dkBCDFt33XJ1CpDWlFFvRdtHynjRYUFSDz9AAl9mUdoZf/rjp8cejfAhXny1IZbrf2O1AvKaaOoJM3y1IeBiVRwpfoRSiqMFFD2jUDGBEJ4rkF3PWYMvQMJLPJRioChHdBPRaAbtJtFXH0MXdvsJ1LtNIbi7+Wj+zEAfKhBWRZC9qqALnD3nBHjCCyyLCJAAQLv4h/8YPXFPHOa+X0zE6A7g7t4NRCoOgEVVihEgZnggUpd2yuJkdeWXmrTHBCIMslJyPJBFTDtqU/D98LlYdbc+ayee/VwlNVKhMlS5fy87/mqFOwFbQ1mxBgqldjcgW+xh43aeJ7//xzJe0poPsPZ+j0ujwiLdAibgSvb6bYIq3/1WZODaj0Mz+UbN8Fu0B//c5GSTSvvey42coewN6fAw1ildKUoxyTiR13i52CqDQInvmDs0gn5oow2d8RqeBebmTTdMCbK3amUOPvhA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(136003)(39830400003)(346002)(366004)(4326008)(33716001)(8676002)(956004)(33656002)(52116002)(44832011)(9686003)(6496006)(1076003)(55016003)(9576002)(38350700002)(83380400001)(8936002)(186003)(316002)(5660300002)(66946007)(86362001)(66476007)(7416002)(2906002)(26005)(66556008)(54906003)(6666004)(508600001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TgTcyWK9g9vskl0WEab/R8rpE26JamGk4rZjJTKcdJQwfrEctRBPQRRbPDXZ?=
 =?us-ascii?Q?Jpv93+jGr8CsCw3aJzrXT9qgj5EhCA7f4Eh32ZvbdHGvMzYqxtRW1PwlHqhJ?=
 =?us-ascii?Q?ApohO32aWdf/EGvCM5PMk3gZRgRlkM03Z+bQsTEY0R+Oor1Lu/9uE3s+eTu2?=
 =?us-ascii?Q?1lAO5r/6rAlXQ6zNVilCTxHvESlfqKIrtRgeu8zG+/dGDN4Q7WHDMdiC4Ofq?=
 =?us-ascii?Q?WWoqhJGVEMmM/5D4mby1TcBh4+yxFt+Lhk0CFtXm/QV72jNpvie38EJVWgyV?=
 =?us-ascii?Q?92AISqFcQeqNkfkSRSMQqAlqzZzzqfcKSa90Q96JpDQVN31wgpHHPb1nhpjS?=
 =?us-ascii?Q?wlnHR6bDNGDfDloBZZIWA5dU9CDzf9jdkZIF1rMpEt3xRvbWY0dW6LtGdNaq?=
 =?us-ascii?Q?5DC4VzfAxAf/rf8795zSrMFwzkSlc6QOKzt8yjb0rX9cfJjNNogKG0lvBHMY?=
 =?us-ascii?Q?JgBYJhDxFLjAUAjEQjAeJsEa6iXO1oNul0Oymkapg4dbQCurGxwO5PWdZDbu?=
 =?us-ascii?Q?cqcCQapfvZr2Wag8CMYjFGc4RycVunk9FBMlbquxFy9tFKnWK39dLGB2GVRm?=
 =?us-ascii?Q?3wsDgk5jlJPKiqrXhn3F9PgjhmR7JhN7Uu7wQws00bdKog5RjnSZHMrLJvCu?=
 =?us-ascii?Q?hPIOVnvsEOm7ajw8eLnw/IlHBC75rxf8Hr439mGPt0+w2pzwpQCT96FjNkp1?=
 =?us-ascii?Q?cjziS0L7X5kHGubpisfiIoSCvruXNyTzi/CO0+H+W/Nrvd0QSxYEf5E4Ck4M?=
 =?us-ascii?Q?s6H9RoCWD+54+3gjz4+wZWtQtDbY2xsUTvUT9mImEhcnk/2gsB70JEad36bu?=
 =?us-ascii?Q?MfpsTTG+y8szQdfw+Kj0WwcBRcZAfqmZhaXOPrHsqEsdPHiVqSNYzpMhpJDY?=
 =?us-ascii?Q?m2XuO8dq6+QPHmhXSWur4/9ET7VSbnSVHZxJsxUNwTmc0Pm0jUOH8aqYlVpP?=
 =?us-ascii?Q?Spg3EjFEyhoMOla3VKUFLHcPOeJFN+D+iydGrmqge5JWlI2Y94Qt1zsr63pM?=
 =?us-ascii?Q?QyS8kOroojn00hidy10C/HgYnGKtRj+5oB/z7etY5FgrDpPKi4qDPf4G69Rm?=
 =?us-ascii?Q?Q+zJoUaXlnWH9w8aO8XDBAxxl/iWxKn/9ujjW3PWfpnl10QOzO1iEh92gRAO?=
 =?us-ascii?Q?jnnC9A+vSbsbdXVQrp7l4KfuZSodyp95DesYxuLkXop/7OY4dc4J8d8el5YF?=
 =?us-ascii?Q?GfxBgjoyYCAkEMFkcXCdw1PBD27AzifOXiLlj4BUNTGCcKH9nUVoaTOvf60U?=
 =?us-ascii?Q?10mxuAh1DtF0x9I+fTSOsoEvcmk6dInahgGUUQM7q00xjEv9rtuZdx0F/V3k?=
 =?us-ascii?Q?hvH24+1SKF7jP1PaAReMTVMgfoO4eCyip7D2AtQkNXd4NsmYXG4GcYxXEr3+?=
 =?us-ascii?Q?tQ4b8rB73zm36BzDwcvMtzYcMt1stjPNHIJPf2dTefUg+M7klPkTM5S/R0TD?=
 =?us-ascii?Q?7vcJjBdBFdX9L9PEwcG+24hw183+PbNbuHjh7JBRdel50W/dTQ2N/1GamTtR?=
 =?us-ascii?Q?Y8q3TMrNPRsaFiRhyHE+UDUZMqmkkqqu6JvMwvj/esrQBS28ylgrHuIwPrB+?=
 =?us-ascii?Q?rVEYI86De3cFPMwGOaTbw/3LLwzSDyUluPhOChAX0VW7HXR64vasSX2lGvlE?=
 =?us-ascii?Q?r4Ej0zQVKY6ACUee/gSiNNq4blCNNG+tye6cn4bUSh4VQ7brrB96Tjji8SGN?=
 =?us-ascii?Q?b53CYw=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f374830c-49e7-4b9c-5368-08d9b061e3d3
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2021 22:21:13.2238
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p4iPfGJc08RJt4uK4HEANCb50dp8myYsjQq3HgwNDTZ4l40QiwSSqb5IUBVtdI4VdUruy7+6vRtODs5XfgaBgJhY5r/PC3kF3EIer0wHptU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4482
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 25, 2021 at 12:12:59PM -0800, Colin Foster wrote:
> Utilize regmap instead of __iomem to perform indirect mdio access. This
> will allow for custom regmaps to be used by way of the mscc_miim_setup
> function.
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> ---
>  drivers/net/mdio/mdio-mscc-miim.c | 161 ++++++++++++++++++++++--------
>  1 file changed, 119 insertions(+), 42 deletions(-)
> 
> diff --git a/drivers/net/mdio/mdio-mscc-miim.c b/drivers/net/mdio/mdio-mscc-miim.c
> index 17f98f609ec8..5a9c0b311bdb 100644
> --- a/drivers/net/mdio/mdio-mscc-miim.c
> +++ b/drivers/net/mdio/mdio-mscc-miim.c
> @@ -14,6 +14,7 @@
>  #include <linux/of_mdio.h>
>  #include <linux/phy.h>
>  #include <linux/platform_device.h>
> +#include <linux/regmap.h>
>  
>  #define MSCC_MIIM_REG_STATUS		0x0
>  #define		MSCC_MIIM_STATUS_STAT_PENDING	BIT(2)
> @@ -35,37 +36,49 @@
>  #define MSCC_PHY_REG_PHY_STATUS	0x4
>  
>  struct mscc_miim_dev {
> -	void __iomem *regs;
> -	void __iomem *phy_regs;
> +	struct regmap *regs;
> +	struct regmap *phy_regs;
>  };
>  
>  /* When high resolution timers aren't built-in: we can't use usleep_range() as
>   * we would sleep way too long. Use udelay() instead.
>   */
> -#define mscc_readl_poll_timeout(addr, val, cond, delay_us, timeout_us)	\
> -({									\
> -	if (!IS_ENABLED(CONFIG_HIGH_RES_TIMERS))			\
> -		readl_poll_timeout_atomic(addr, val, cond, delay_us,	\
> -					  timeout_us);			\
> -	readl_poll_timeout(addr, val, cond, delay_us, timeout_us);	\
> +#define mscc_readx_poll_timeout(op, addr, val, cond, delay_us, timeout_us)\
> +({									  \
> +	if (!IS_ENABLED(CONFIG_HIGH_RES_TIMERS))			  \
> +		readx_poll_timeout_atomic(op, addr, val, cond, delay_us,  \
> +					  timeout_us);			  \
> +	readx_poll_timeout(op, addr, val, cond, delay_us, timeout_us);	  \
>  })
>  
> -static int mscc_miim_wait_ready(struct mii_bus *bus)
> +static int mscc_miim_status(struct mii_bus *bus)
>  {
>  	struct mscc_miim_dev *miim = bus->priv;
> +	int val, ret;
> +
> +	ret = regmap_read(miim->regs, MSCC_MIIM_REG_STATUS, &val);
> +	if (ret < 0) {
> +		WARN_ONCE(1, "mscc miim status read error %d\n", ret);
> +		return ret;
> +	}
> +
> +	return val;
> +}
> +
> +static int mscc_miim_wait_ready(struct mii_bus *bus)
> +{
>  	u32 val;
>  
> -	return mscc_readl_poll_timeout(miim->regs + MSCC_MIIM_REG_STATUS, val,
> +	return mscc_readx_poll_timeout(mscc_miim_status, bus, val,
>  				       !(val & MSCC_MIIM_STATUS_STAT_BUSY), 50,
>  				       10000);
>  }
>  
>  static int mscc_miim_wait_pending(struct mii_bus *bus)
>  {
> -	struct mscc_miim_dev *miim = bus->priv;
>  	u32 val;
>  
> -	return mscc_readl_poll_timeout(miim->regs + MSCC_MIIM_REG_STATUS, val,
> +	return mscc_readx_poll_timeout(mscc_miim_status, bus, val,
>  				       !(val & MSCC_MIIM_STATUS_STAT_PENDING),
>  				       50, 10000);
>  }
> @@ -80,15 +93,27 @@ static int mscc_miim_read(struct mii_bus *bus, int mii_id, int regnum)
>  	if (ret)
>  		goto out;
>  
> -	writel(MSCC_MIIM_CMD_VLD | (mii_id << MSCC_MIIM_CMD_PHYAD_SHIFT) |
> -	       (regnum << MSCC_MIIM_CMD_REGAD_SHIFT) | MSCC_MIIM_CMD_OPR_READ,
> -	       miim->regs + MSCC_MIIM_REG_CMD);
> +	ret = regmap_write(miim->regs, MSCC_MIIM_REG_CMD, MSCC_MIIM_CMD_VLD |
> +			   (mii_id << MSCC_MIIM_CMD_PHYAD_SHIFT) |
> +			   (regnum << MSCC_MIIM_CMD_REGAD_SHIFT) |
> +			   MSCC_MIIM_CMD_OPR_READ);
> +
> +	if (ret < 0) {
> +		WARN_ONCE(1, "mscc miim write cmd reg error %d\n", ret);
> +		goto out;
> +	}
>  
>  	ret = mscc_miim_wait_ready(bus);
>  	if (ret)
>  		goto out;
>  
> -	val = readl(miim->regs + MSCC_MIIM_REG_DATA);
> +	ret = regmap_read(miim->regs, MSCC_MIIM_REG_DATA, &val);
> +
> +	if (ret < 0) {
> +		WARN_ONCE(1, "mscc miim read data reg error %d\n", ret);
> +		goto out;
> +	}
> +
>  	if (val & MSCC_MIIM_DATA_ERROR) {
>  		ret = -EIO;
>  		goto out;
> @@ -109,12 +134,14 @@ static int mscc_miim_write(struct mii_bus *bus, int mii_id,
>  	if (ret < 0)
>  		goto out;
>  
> -	writel(MSCC_MIIM_CMD_VLD | (mii_id << MSCC_MIIM_CMD_PHYAD_SHIFT) |
> -	       (regnum << MSCC_MIIM_CMD_REGAD_SHIFT) |
> -	       (value << MSCC_MIIM_CMD_WRDATA_SHIFT) |
> -	       MSCC_MIIM_CMD_OPR_WRITE,
> -	       miim->regs + MSCC_MIIM_REG_CMD);
> +	ret = regmap_write(miim->regs, MSCC_MIIM_REG_CMD, MSCC_MIIM_CMD_VLD |
> +			   (mii_id << MSCC_MIIM_CMD_PHYAD_SHIFT) |
> +			   (regnum << MSCC_MIIM_CMD_REGAD_SHIFT) |
> +			   (value << MSCC_MIIM_CMD_WRDATA_SHIFT) |
> +			   MSCC_MIIM_CMD_OPR_WRITE);
>  
> +	if (ret < 0)
> +		WARN_ONCE(1, "mscc miim write error %d\n", ret);
>  out:
>  	return ret;
>  }
> @@ -122,24 +149,40 @@ static int mscc_miim_write(struct mii_bus *bus, int mii_id,
>  static int mscc_miim_reset(struct mii_bus *bus)
>  {
>  	struct mscc_miim_dev *miim = bus->priv;
> +	int ret;
>  
>  	if (miim->phy_regs) {
> -		writel(0, miim->phy_regs + MSCC_PHY_REG_PHY_CFG);
> -		writel(0x1ff, miim->phy_regs + MSCC_PHY_REG_PHY_CFG);
> +		ret = regmap_write(miim->phy_regs, MSCC_PHY_REG_PHY_CFG, 0);
> +		if (ret < 0) {
> +			WARN_ONCE(1, "mscc reset set error %d\n", ret);
> +			return ret;
> +		}
> +
> +		ret = regmap_write(miim->phy_regs, MSCC_PHY_REG_PHY_CFG, 0x1ff);
> +		if (ret < 0) {
> +			WARN_ONCE(1, "mscc reset clear error %d\n", ret);
> +			return ret;
> +		}
> +
>  		mdelay(500);
>  	}
>  
>  	return 0;
>  }
>  
> -static int mscc_miim_probe(struct platform_device *pdev)
> +static const struct regmap_config mscc_miim_regmap_config = {
> +	.reg_bits	= 32,
> +	.val_bits	= 32,
> +	.reg_stride	= 4,
> +};
> +
> +static int mscc_miim_setup(struct device *dev, struct mii_bus **pbus,
> +			   struct regmap *mii_regmap, struct regmap *phy_regmap)
>  {
> -	struct mscc_miim_dev *dev;
> -	struct resource *res;
> +	struct mscc_miim_dev *miim;
>  	struct mii_bus *bus;
> -	int ret;
>  
> -	bus = devm_mdiobus_alloc_size(&pdev->dev, sizeof(*dev));
> +	bus = devm_mdiobus_alloc_size(dev, sizeof(*miim));
>  	if (!bus)
>  		return -ENOMEM;
>  
> @@ -147,24 +190,58 @@ static int mscc_miim_probe(struct platform_device *pdev)
>  	bus->read = mscc_miim_read;
>  	bus->write = mscc_miim_write;
>  	bus->reset = mscc_miim_reset;
> -	snprintf(bus->id, MII_BUS_ID_SIZE, "%s-mii", dev_name(&pdev->dev));
> -	bus->parent = &pdev->dev;
> +	snprintf(bus->id, MII_BUS_ID_SIZE, "%s-mii", dev_name(dev));
> +	bus->parent = dev;
> +
> +	miim = bus->priv;
> +
> +	*pbus = bus;
> +
> +	miim->regs = mii_regmap;
> +	miim->phy_regs = phy_regmap;
> +
> +	return 0;
> +}
> +
> +static int mscc_miim_probe(struct platform_device *pdev)
> +{
> +	struct regmap *mii_regmap, *phy_regmap;
> +	void __iomem *regs, *phy_regs;
> +	struct mscc_miim_dev *dev;
> +	struct mii_bus *bus;
> +	int ret;
>  
> -	dev = bus->priv;
> -	dev->regs = devm_platform_get_and_ioremap_resource(pdev, 0, NULL);
> -	if (IS_ERR(dev->regs)) {
> +	regs = devm_platform_get_and_ioremap_resource(pdev, 0, NULL);
> +	if (IS_ERR(regs)) {
>  		dev_err(&pdev->dev, "Unable to map MIIM registers\n");
> -		return PTR_ERR(dev->regs);
> +		return PTR_ERR(regs);
>  	}
>  
> -	/* This resource is optional */
> -	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
> -	if (res) {
> -		dev->phy_regs = devm_ioremap_resource(&pdev->dev, res);
> -		if (IS_ERR(dev->phy_regs)) {
> -			dev_err(&pdev->dev, "Unable to map internal phy registers\n");
> -			return PTR_ERR(dev->phy_regs);
> -		}
> +	mii_regmap = devm_regmap_init_mmio(&pdev->dev, regs,
> +					   &mscc_miim_regmap_config);
> +
> +	if (IS_ERR(mii_regmap)) {
> +		dev_err(&pdev->dev, "Unable to create MIIM regmap\n");
> +		return PTR_ERR(mii_regmap);
> +	}
> +
> +	phy_regs = devm_platform_ioremap_resource(pdev, 1);
> +	if (IS_ERR(dev->phy_regs)) {

Oops. I'll fix this in V3.

> +		dev_err(&pdev->dev, "Unable to map internal phy registers\n");
> +		return PTR_ERR(dev->phy_regs);
> +	}
> +
> +	phy_regmap = devm_regmap_init_mmio(&pdev->dev, phy_regs,
> +					   &mscc_miim_regmap_config);
> +	if (IS_ERR(phy_regmap)) {
> +		dev_err(&pdev->dev, "Unable to create phy register regmap\n");
> +		return PTR_ERR(dev->phy_regs);
> +	}
> +
> +	ret = mscc_miim_setup(&pdev->dev, &bus, mii_regmap, phy_regmap);
> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "Unable to setup the MDIO bus\n");
> +		return ret;
>  	}
>  
>  	ret = of_mdiobus_register(bus, pdev->dev.of_node);
> -- 
> 2.25.1
> 
