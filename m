Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0CDF6E9756
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 16:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232167AbjDTOiQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 10:38:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231801AbjDTOiO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 10:38:14 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2093.outbound.protection.outlook.com [40.107.92.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42ACF30C2;
        Thu, 20 Apr 2023 07:38:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W6grU0LxRgtDFJXbd229Z67S+/DgDnBb/flt4JTSiRkXtcflnOejxa21BXybPgSZmVd0WYgI82yaUTv2ismuW9QIuYkI6ZmarKJ6ufjBsGVj3lW9JLzrLtuf88ljpeyol+56b4hK3sH0CjJEYlA0yuLUqoeUYUHW/AEwOAeQWYi2yGu7IyPGJ5o9i2P/Xphl//vXCtIJhhMtKU91ib1M2MRhv5ppsUAzyQyvvEiukvnAB+IHYgVnvcVGhZlWrgCVP9WCwI8cEHdUeDDjOdwKPOlm8atvsieOS5KKVXIoTe2SYAJsjd1BTYs/9598zkf92jZa7G53544WhOL9WGs0KQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6dJeNtfiBCfRM4VGVmvqkPLiYJCJT7Mwj2iI82W4XWk=;
 b=dZGI2YczBerZDJ6BEBW+NFUZQ49GwbZ9Z/N3U+G/eqWwA9bnyk6lz1RUuqrRNA5XMP4i+4QSvpggdpWJbSd0xD0zgYIGnhlMNV54drIZFnfKP1TXBTAXgUjc3sJoE6SCo6qdhvuAq8v75HGTKQXtR7aOVSOdGxcMRMG5/sQ8TnTZzUNOvdtSKQ+SCsjnDw9sa8Xdphc8EG2mhSxlupunBk/aYnbi9hVBjDhpcFhavYtS+zsW5jOoXgNN2FoX87TzgZXi2jMGc1A0fgOAScX4n6l4AUI5LXDsLiQAHR+8WGeBM3gQ8UHV+m2408ceyvVJ4FLv3KP7uJ2DMGC6hV2cvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6dJeNtfiBCfRM4VGVmvqkPLiYJCJT7Mwj2iI82W4XWk=;
 b=C+4gc3A/g8c/b6oc0bdabPp173vGSYBnGliA+IXt6fpau4Qpa4is4xnXexr7/oQHgnrlZj46jXREAWhp3CTdSOs6R8bHVocyfBr1faqtDxOLgrFWKC8OkcOKkdcFuKlwUsWeZjFh7aC1nanm39rEw0OVyTVpinA+hos1LLfwcZs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MN2PR13MB3789.namprd13.prod.outlook.com (2603:10b6:208:1e4::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Thu, 20 Apr
 2023 14:38:09 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%4]) with mapi id 15.20.6319.022; Thu, 20 Apr 2023
 14:38:08 +0000
Date:   Thu, 20 Apr 2023 16:38:00 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Michal Kubecek <mkubecek@suse.cz>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Petr Machata <petrm@nvidia.com>,
        Danielle Ratson <danieller@nvidia.com>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Aaron Conole <aconole@redhat.com>,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net-next 4/9] net: enetc: include MAC Merge / FP
 registers in register dump
Message-ID: <ZEFOSGwKhIyzwWmB@corigine.com>
References: <20230418111459.811553-1-vladimir.oltean@nxp.com>
 <20230418111459.811553-5-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230418111459.811553-5-vladimir.oltean@nxp.com>
X-ClientProxiedBy: AM4PR05CA0020.eurprd05.prod.outlook.com (2603:10a6:205::33)
 To PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MN2PR13MB3789:EE_
X-MS-Office365-Filtering-Correlation-Id: 756f1dcb-d70e-4cfc-b1e8-08db41acdc10
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: veHVm32z+o2RMmt/aPxH/DuCf9SNod4AVg4Hvuziy0ql/p6vscScqWq390JYef9WqFWNeHh2pPnfgEhH6QT+lL9i+cVFmyRhJrqnz1egkXYjWCq/M8aZZKq4XoWMqkCHLpRVaMV/hvXXiXSgBfx+wUzKyt0VAb1kET4C6q9coKk9DrfUzIYhaImzM8pVyItnqC6PTYTc+DbP9kkYLtqq3Wh7+RVl8Ig6QcHyrCuR/MyMqQpUeGfOFEMkTlnegQuUsJGcfwty0Ckr2G9g+QkDIHW64yyca1hphpwIVjehbkZdCQImsr/+5c45SdzHoz57kSL21CGeh6RJ1wVyepF0qpGI3oIbP3xr752CvGZtmjEGWbwxZtdqyOjJIZ8dFeeOiuaFXa6gYlSDwW279SCbCeDgaeQNJoqcTf2VloIGEOW7P/P2SscQ+AO9zHRWwWdblKNGrQ9dOsU+eqmoAOmS/BVxmKcaTGv2Llu4b0zNH0V2JLkZs2sv1+8fr0PO4rYytajXjJBtHTcSVC455djq3vhWQ06F/kyvl7O5P5YhecNBs4VhiJ6LzxzxvDguxALb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39840400004)(396003)(136003)(346002)(376002)(451199021)(7416002)(8676002)(8936002)(186003)(86362001)(6512007)(6506007)(2906002)(2616005)(36756003)(6666004)(478600001)(54906003)(5660300002)(44832011)(66946007)(66556008)(66476007)(6916009)(4326008)(316002)(6486002)(41300700001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?t11kXV7/KdMrHVjKOvXBltwbqW/BNU4O+Wdd3XQf3BoiNAfNOxxWmak1Ntme?=
 =?us-ascii?Q?cDLPgmWf4yujNIgLVnOQZlSlZK+MufRI5ZW/ntgamQS2nLvXXY4+W+6zjMbz?=
 =?us-ascii?Q?ffLZ1OliethHKin7GKC1GhjAqmq+SniD9l8rOJY0EyZlXueDLh2qBDMSVMvG?=
 =?us-ascii?Q?/Z6j8u3ERZX/c2hmHDiqVQgvySBjqFsalimRaowJmfnseT1THDIOGiCSqzTH?=
 =?us-ascii?Q?OwtWZi8zq8ccc03xXD3UR4r9XRF9jkXYBRtfjSC+AazFf8PIcCYzjglx7Jek?=
 =?us-ascii?Q?KU0pjBwXhbPUk4Sc0iGr5UlNUvyfgrC1Izcat/Z1Z4viGJPobo+F6dCAEvGw?=
 =?us-ascii?Q?AFbcp2eXfeORvqmpVILWy5/iOOCs4uOg+1rhS/fCmfwU4lRxGBKJJ41FdhmZ?=
 =?us-ascii?Q?1kZ8UHj16sJ13QUiJmYb6bEkcRaTbUhFNKvPfQXVlYE6UU2zVUd0bSajTrR6?=
 =?us-ascii?Q?Y1NKOGyYp2mnSZ9IhSJP+F549XhMKCuokwXC6O0KY24qU8Rrb+vrEqrntK3V?=
 =?us-ascii?Q?y34X2eL6+3hRe40PKsulcE/SEx8xmG3ADhcr+dA0yU3gpVVAeoM0NgEGhLF4?=
 =?us-ascii?Q?jqM24CLp+1e2TnbTUeMYvZDCgQdUfPFuUt+xfvFfVT6r2Q2qm2/lWI+k8gWG?=
 =?us-ascii?Q?2NX7LA+4oK06JxhzNh4JfCz7tFuk5caH3LR2n5MvO7Yt+EjsWZzYo94EP8bd?=
 =?us-ascii?Q?mi/TvaeeqMX+u0bd7LtExGsfsMUzVo1vURcMnEHFW3uaR8t+OP3SkZm7Zjip?=
 =?us-ascii?Q?4NhVBLlUtg2CNk8VYVcyLEQ4Amhdu/Vd7VUO2nLWtDjA8IoDyZe5n01wvlcI?=
 =?us-ascii?Q?nVIwLbhFzqYDyxF4V49pO3k5xagEyJtAXZfBrQ7+pXd7PfDnylYxmvy1oxv6?=
 =?us-ascii?Q?Kasy3Dh/hTlqNRAZ88p/0znE3Uxepknc3AMEwF+1uYlzdDcb7fcj7vZCaRD0?=
 =?us-ascii?Q?GEBIBWuWF2h4lFE/xLG4EcxoAd0kLT9Pj3tmmzng3mAhLCRTiKxfg8u2PfeU?=
 =?us-ascii?Q?mwVUA99ByCxeH/dg8Y7OPYCyA3tScJzqJLK/Chzae+6ZfWUFzzoMES+qpXmY?=
 =?us-ascii?Q?6vtRHcENUMPGk/q6Opf/K7D+Ry0rvlEfjx9GeWcRbvS1P3Ee4a8N2KbHZRWf?=
 =?us-ascii?Q?8+CjvlnJTnAmHZIJSNIbUJ+18P8Rx98CYNsLKtLQ8asE97QZ0ZROC7+7gbf6?=
 =?us-ascii?Q?cC6qLG/YjmdSGwdm1qLzcRnSA414iXMH4FIka+8BkT7YUziBCLs+1LajveXH?=
 =?us-ascii?Q?yMDIn+pr/Y4UvmeeZkQPlWoL6hgn7vCXq6O2Ky2gHRo5LctqbgK42DNO7axo?=
 =?us-ascii?Q?L+9qLmyKMYGClxer48cNa7NmofQCaWH0P4D42hiwPrsEz3Tf4lMDs0VsfTlT?=
 =?us-ascii?Q?vb0WX6BJ5/TwgvZgObGlHGXrLLXOdQt/wkZKnPQ1v8hfU4V86YIAMwdEv+g9?=
 =?us-ascii?Q?4jfky6s10mrLsCS9XBYbTEFd2GwcjRs8liYtVlofLuZsQdqltqpO/5G3+Cq2?=
 =?us-ascii?Q?yJhhq3kNGN1/tT5cED0ZlU4AEH2Wtn4NcAJOb6H/OAPjed/t7kMQQJOBikl2?=
 =?us-ascii?Q?h+F37DEg1y9fq0I3WcqLFe02rN+PY7oOZYoNDDd+08NJaVgb8ifRPdpye9Ji?=
 =?us-ascii?Q?4ujEBUmkrGq4Pg8Bg/3h4pj1+xDGri7IcxWGUR/LGtPcaTlRNl/VZllUK5rs?=
 =?us-ascii?Q?Z51GLQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 756f1dcb-d70e-4cfc-b1e8-08db41acdc10
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2023 14:38:08.7500
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Cbq6VRySpuwZ5BTe8UQklRzcMtep/2HiXglczvODyCI97mydbx6ocIfmRixSzBxz/44YIPDa1s2Er2QDpfI5mQoSezG001unuLzm+owVcoY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR13MB3789
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 18, 2023 at 02:14:54PM +0300, Vladimir Oltean wrote:
> These have been useful in debugging various problems related to frame
> preemption, so make them available through ethtool --register-dump for
> later too.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

> ---
> v1->v2: patch is new
> 
>  .../ethernet/freescale/enetc/enetc_ethtool.c    | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
> index 838a92131963..e993ed04ab57 100644
> --- a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
> +++ b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
> @@ -32,6 +32,12 @@ static const u32 enetc_port_regs[] = {
>  	ENETC_PM0_CMD_CFG, ENETC_PM0_MAXFRM, ENETC_PM0_IF_MODE
>  };
>  
> +static const u32 enetc_port_mm_regs[] = {
> +	ENETC_MMCSR, ENETC_PFPMR, ENETC_PTCFPR(0), ENETC_PTCFPR(1),
> +	ENETC_PTCFPR(2), ENETC_PTCFPR(3), ENETC_PTCFPR(4), ENETC_PTCFPR(5),
> +	ENETC_PTCFPR(6), ENETC_PTCFPR(7),
> +};
> +
>  static int enetc_get_reglen(struct net_device *ndev)
>  {
>  	struct enetc_ndev_priv *priv = netdev_priv(ndev);
> @@ -45,6 +51,9 @@ static int enetc_get_reglen(struct net_device *ndev)
>  	if (hw->port)
>  		len += ARRAY_SIZE(enetc_port_regs);
>  
> +	if (hw->port && !!(priv->si->hw_features & ENETC_SI_F_QBU))

nit: I think you could make the condition.

	if (hw->port && priv->si->hw_features & ENETC_SI_F_QBU)

which would be consistent with the condition in the next hunk.

> +		len += ARRAY_SIZE(enetc_port_mm_regs);
> +
>  	len *= sizeof(u32) * 2; /* store 2 entries per reg: addr and value */
>  
>  	return len;
> @@ -90,6 +99,14 @@ static void enetc_get_regs(struct net_device *ndev, struct ethtool_regs *regs,
>  		*buf++ = addr;
>  		*buf++ = enetc_rd(hw, addr);
>  	}
> +
> +	if (priv->si->hw_features & ENETC_SI_F_QBU) {
> +		for (i = 0; i < ARRAY_SIZE(enetc_port_mm_regs); i++) {
> +			addr = ENETC_PORT_BASE + enetc_port_mm_regs[i];
> +			*buf++ = addr;
> +			*buf++ = enetc_rd(hw, addr);
> +		}
> +	}
>  }
>  
>  static const struct {
> -- 
> 2.34.1
> 
