Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB7D96D37C8
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 14:11:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230177AbjDBMJF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 08:09:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbjDBMJE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 08:09:04 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2100.outbound.protection.outlook.com [40.107.102.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B5651A974
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 05:09:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X+sp99VfqMu3q6uH+JT6q9d6h9P++bcNbUj2nfV+bl1K9QLs7WD3uNu5RWJJPzW1x+18XLHiqdouMpV+N7RAb+3IdxF/xLfE/RqP8E12xAsw2JNv6P75s7TfTX4Zul7aI1CUMhTqVMsAKIPVrq6pi7OwGP/jUqW+hmhZlCQgt19DKy/zU58GebRibI7jYdbKV4HTFBQuYxS1VlNYuHeoUfeO2Tlr+LAHWOkj4J9Z2f7OSM6XvdvlYfwj4RFtcWhfQfi8cnwdqHZ3TcICFkkTxCCIKMyi3rH4V49twim9dbuIsTsS+eQ5lPqkvbT9SVviycqKUJrNRykNI4ogNPAbuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LftXZ1XdDIo7mMw6j4GyCvFVmtPOJtqzVSNZnqpYBY4=;
 b=Ov72k2Fd4ao6evbh2BJG+f+FZ14T1qcz+FeIbLSL+8U5aEIpeOqLvZfQ7qM9aNDunu8QRdFxHFVLZ4+DLktgYYmx9Fl0nozFLW6NK29lXk9DY/xhuxjUBLMfClRxOUgtuXPND9Nlc136zf+S4g5E5I5YPUQz1dcGl1hc+cEieKQPM57Fx1eD6DLwsroa5wKD+H22gqiXu7Fu/mmPAgGn6kpdExx2RiKKwLnmH5TkQrso2IM/VnrCGf7entcmTSrbnxD6frfVOGaedKw1/cA0cBXCwcc4U6jQIpNiUrZlI6wMgHXIcbyK75wYdSTRzAuyddGztz98svbWKCZn2salFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LftXZ1XdDIo7mMw6j4GyCvFVmtPOJtqzVSNZnqpYBY4=;
 b=WpruFF3pOCwkKvL6zfdXpQGnEXWOd1bLynYRMFNW40CWrKKrST4H2YAqhipm0xD5BY4gUznpUHFmDY18SMnMjEswNJlDAJbivjyqpuvLh9L+Ywiz5p21OcQd8Z1RFm66kVaKh5tnBjj59jh3RNyxXpjiAcBQPpDKlf34Q01ZeUc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA1PR13MB5564.namprd13.prod.outlook.com (2603:10b6:806:233::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.26; Sun, 2 Apr
 2023 12:08:58 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%5]) with mapi id 15.20.6254.021; Sun, 2 Apr 2023
 12:08:58 +0000
Date:   Sun, 2 Apr 2023 14:08:53 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 6/7] net: phy: smsc: add edpd tunable support
Message-ID: <ZClwVbl8HeCxcHXa@corigine.com>
References: <17fcccf5-8d81-298e-0671-d543340da105@gmail.com>
 <66446a75-8087-10f4-fc37-b97e13b88c27@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <66446a75-8087-10f4-fc37-b97e13b88c27@gmail.com>
X-ClientProxiedBy: AM4PR0101CA0044.eurprd01.prod.exchangelabs.com
 (2603:10a6:200:41::12) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA1PR13MB5564:EE_
X-MS-Office365-Filtering-Correlation-Id: 0717b8c3-baeb-453c-5df7-08db337309fe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ujv5+wDITIK9B39Zjt6ZJHXAVAbGR5ASit4P5lOFfptNPctZAHksQwUO1wDZ6+KbKHa2HPE8nCO1dNWP+BI3uMnuAhCWZ15UeWP6QysTgBPphBkUl1CgOXrQNYK4qt+8yvp3j4LQxd8rfQbeH7H+NxyMO1/Y3OnLpRXBuBtDanqJGqeOdWOk+rx24H2aeIryxc8hdlAYGgkcJFHEFGJAKfjxOT9l5ezyrfaQWzWTXKt+n2s6Hf9IL7cawyVKxp8DkudR3fl31xUl83Xj9CtzuKNyXaV+2RxhERH68tbapmfVPI619t4HVxz+Vg1YIwsEpiEzfggyCA6RBeCDQ2OhO+xF8COWMLoJzg7rrJkLphBq938pNoPO3aIHSUB+cNj34fvcZflYJeIUzXUVk37/LDXH8cYpAi0z+vouOgvO4izkPJLdVUDFJ9cOJeJ909rZ+Ld7O//HmI4JC+OSRjHBGRP5Tx//k4eO4/9XE7P1ngIuQxjMaWcXwM2deEh5abicU6zFk468E4CZDqqgpD1sydkNoKaYNPy0qjnuRO4/jpLdjqUeJYxXzgtyXy7gHHugRD58TAT3a/sf/r5nmisXyKEWK2OlrYmAfaxhiGNTbGM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39830400003)(136003)(366004)(376002)(396003)(346002)(451199021)(6666004)(2616005)(86362001)(6486002)(54906003)(6512007)(36756003)(6506007)(186003)(6916009)(83380400001)(8676002)(4326008)(66476007)(66556008)(66946007)(5660300002)(8936002)(316002)(38100700002)(44832011)(41300700001)(478600001)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fjEktfZ/3i/NjBVMQr+KOsvFChj4q/Mg1Eh1lddvs9Vfv1a22sTtMTTVIlFY?=
 =?us-ascii?Q?k4c9+jXgK7xTMX8+Z2D76sbic6pbPzS4P5fZ2FEAThn6QVrGm16958DZMtQi?=
 =?us-ascii?Q?uwmE8FOI0c/QfzBGlJW13BEgNzAWp9uoEu5CrzGIXmlItsR44fIZL0ROPVBz?=
 =?us-ascii?Q?wNS7r3U1ukFJgA/rDfSzL7eu7Q2MkPGVTT6hhf/lIBpKKJG7ZCFV0i+c94bR?=
 =?us-ascii?Q?9jPGxWxp4E2/29bzYF3BlmpbAlrMISNvadk0TrJ2PVqgKew7vTu+eaEKNVzf?=
 =?us-ascii?Q?QWr1lwtG31OrULPEAuzWt3eKeY1tJaNvRMacXvxhG6sQkTQrfbplhZzRaZcR?=
 =?us-ascii?Q?HA++75UxJfRsD9MCKsL1mALGpl8CzKSRqpRg+KSi7TsL8Yx0WuG0HwVs3qyc?=
 =?us-ascii?Q?GGqFz/UngFSZOUTEw0GJSmbsHPQSDu2JUQeQpnPlpck1xmYaP/IZeKGcBsXq?=
 =?us-ascii?Q?9AM+tfiSBXRrqWZmOCbDiCSoT5yaAhpZRS2pLj5m8EBE0pkwv67g6T/GkxS6?=
 =?us-ascii?Q?0SYiv4cbBzsZ/qyNz65p/pCvuJ4E5zeDZqL2OSTRPaGwvfVrhzCK/QONhoAa?=
 =?us-ascii?Q?OJdxKdDTmo3hkVnxRRdwLkp7nRoIV8kgglKKHnvwyg2MYwOWj9VS7nldbYzY?=
 =?us-ascii?Q?Hf5nnB6RjHGINYa4jXa39nluUIftPtDVbKXDBVHpmGZyz6Pa65t/m073HTdA?=
 =?us-ascii?Q?JAie8WEz6OyBR7ekh6KX/Ps1xHBiw30EKFPtKZLb9DsgTQf4ldKKcvJND1sE?=
 =?us-ascii?Q?k0ChCGWYKe1EINCEW9zBf1x8VWXE/k1T34jAOTrpSJbmL6sJItL3G1PHNJQw?=
 =?us-ascii?Q?kpb2dOGrQrva0ji/etlULg3LkHFYcblKoWAm2J5ZuFAoqC1JX5lRAgEggkMG?=
 =?us-ascii?Q?NtLc+xUK8ET+gRquLs3nk1V+f4w4xxu/FYAIDZ23t+CNk2S9MpNuwxzij7A4?=
 =?us-ascii?Q?qavsQ/anwcVSYYw5cg2UrcO5pY1Li+T6Z6Xt76P0FKo81+fwY1XndSO9PUqs?=
 =?us-ascii?Q?mJ7tolm9eTxALd3ntBJW28lMss5pPC42Xweoap+bX7Tu3y+srZOFy63aUYF4?=
 =?us-ascii?Q?+7Z700/7O7rtmw7EIiLFPcrfXVA6Bw5z3EiKj7VyXo/dwVtxWWgp/Tnm055u?=
 =?us-ascii?Q?bNQgU4u2393OXUOaTZAluTPx0XZrZmvza02TT3zsr3zU9vnQPwJqjzHokzh/?=
 =?us-ascii?Q?Ofss1/SArotZr07pvm+BVbRa9Yn9r9CSRLOcI9IoTGDSt75JsFt2f9AqZrrw?=
 =?us-ascii?Q?CxTDCETEmDkDwbRzD+DL1V6f1nm4CtLF7VCibVYfPToMWPzryO4/Ir8gMO+q?=
 =?us-ascii?Q?6oNmeGoaaX92BCPVLMqcH2zPE4E+QSGT9cjL6VHZlNiazGgR+ygeOi9NVq8m?=
 =?us-ascii?Q?knQmNLfkD29yS+lw0bQicd6DrbREaXg/kmwXXVnqR0H8tI8ZC6fS/tiuHfOR?=
 =?us-ascii?Q?kxOhTDMBR8OcVZ9v9sEfXtw3NzJ04mCtKUpqdYAdf8yYbVDkCqMsJQuxN5MW?=
 =?us-ascii?Q?5rO1Tm1sgKOkouMrozBkred8aGxG8uwx0IE0owWnfvJIc70lZ0XNQ1FHJxfh?=
 =?us-ascii?Q?AfAlXzvrDE/S3mVISMpI124QeJJAgXS+s2xebuwYJ0+vyRJYcbClhgC6Wz+5?=
 =?us-ascii?Q?VsI03gjdNdPHWN+KmSuxwcQCYGQ2d3CUtQsC5O4E3bDhHrdCxhAdrVZVdAs8?=
 =?us-ascii?Q?jAyhxw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0717b8c3-baeb-453c-5df7-08db337309fe
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2023 12:08:58.6789
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JSJ1aKAUnJGQTXSn4qIJJ9WGVImM2GNVHPq9Bo8Grgjbr8GiSFcCSalihbvA80s4MIS+niPC6RWeL3mk5CdIt213oZOPkmngsnBH74xGKRE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR13MB5564
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 02, 2023 at 11:47:34AM +0200, Heiner Kallweit wrote:
> This adds support for the EDPD PHY tunable.
> Per default EDPD is disabled in interrupt mode, the tunable can be used
> to override this, e.g. if the link partner doesn't use EDPD.
> The interval to check for energy can be chosen between 1000ms and
> 2000ms. Note that this value consists of the 1000ms phylib interval
> for state machine runs plus the time to wait for energy being detected.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  drivers/net/phy/smsc.c  | 82 +++++++++++++++++++++++++++++++++++++++++
>  include/linux/smscphy.h |  4 ++
>  2 files changed, 86 insertions(+)
> 
> diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
> index 0cd433f01..cca5bf46f 100644
> --- a/drivers/net/phy/smsc.c
> +++ b/drivers/net/phy/smsc.c
> @@ -34,6 +34,8 @@
>  #define SPECIAL_CTRL_STS_AMDIX_STATE_	0x2000
>  
>  #define EDPD_MAX_WAIT_DFLT		640

nit: Maybe this could be EDPD_MAX_WAIT_DFLT_MS for consistency
     with PHY_STATE_MACH_MS.

> +/* interval between phylib state machine runs in ms */
> +#define PHY_STATE_MACH_MS		1000
>  
>  struct smsc_hw_stat {
>  	const char *string;
> @@ -295,6 +297,86 @@ static void smsc_get_stats(struct phy_device *phydev,
>  		data[i] = smsc_get_stat(phydev, i);
>  }
>  
> +static int smsc_phy_get_edpd(struct phy_device *phydev, u16 *edpd)
> +{
> +	struct smsc_phy_priv *priv = phydev->priv;
> +
> +	if (!priv)
> +		return -EOPNOTSUPP;
> +
> +	if (!priv->edpd_enable)
> +		*edpd = ETHTOOL_PHY_EDPD_DISABLE;
> +	else if (!priv->edpd_max_wait_ms)
> +		*edpd = ETHTOOL_PHY_EDPD_NO_TX;
> +	else
> +		*edpd = PHY_STATE_MACH_MS + priv->edpd_max_wait_ms;
> +
> +	return 0;
> +}
> +
> +static int smsc_phy_set_edpd(struct phy_device *phydev, u16 edpd)
> +{
> +	struct smsc_phy_priv *priv = phydev->priv;
> +	int ret;
> +
> +	if (!priv)
> +		return -EOPNOTSUPP;
> +
> +	mutex_lock(&phydev->lock);

I am a little confused by this as by my reasoning this code is called via
the first arm of the following in set_phy_tunable(), and phydev->lock is
already held.

        if (phy_drv_tunable) {
                mutex_lock(&phydev->lock);
                ret = phydev->drv->set_tunable(phydev, &tuna, data);
                mutex_unlock(&phydev->lock);
        } else {
                ret = dev->ethtool_ops->set_phy_tunable(dev, &tuna, data);
        }

> +
> +	switch (edpd) {
> +	case ETHTOOL_PHY_EDPD_DISABLE:
> +		priv->edpd_enable = false;
> +		break;
> +	case ETHTOOL_PHY_EDPD_NO_TX:
> +		priv->edpd_enable = true;
> +		priv->edpd_max_wait_ms = 0;
> +		break;
> +	case ETHTOOL_PHY_EDPD_DFLT_TX_MSECS:
> +		edpd = PHY_STATE_MACH_MS + EDPD_MAX_WAIT_DFLT;
> +		fallthrough;
> +	default:
> +		if (phydev->irq != PHY_POLL)
> +			return -EOPNOTSUPP;

This returns without releasing phydev->lock.
Is that intended?

> +		if (edpd < PHY_STATE_MACH_MS || edpd > PHY_STATE_MACH_MS + 1000)
> +			return -EINVAL;

Ditto.

> +		priv->edpd_enable = true;
> +		priv->edpd_max_wait_ms = edpd - PHY_STATE_MACH_MS;
> +	}
> +
> +	priv->edpd_mode_set_by_user = true;
> +
> +	ret = smsc_phy_config_edpd(phydev);
> +
> +	mutex_unlock(&phydev->lock);
> +
> +	return ret;
> +}
> +
> +int smsc_phy_get_tunable(struct phy_device *phydev,
> +			 struct ethtool_tunable *tuna, void *data)
> +{
> +	switch (tuna->id) {
> +	case ETHTOOL_PHY_EDPD:
> +		return smsc_phy_get_edpd(phydev, data);
> +	default:
> +		return -EOPNOTSUPP;
> +	}
> +}
> +EXPORT_SYMBOL_GPL(smsc_phy_get_tunable);
> +
> +int smsc_phy_set_tunable(struct phy_device *phydev,
> +			 struct ethtool_tunable *tuna, const void *data)
> +{
> +	switch (tuna->id) {
> +	case ETHTOOL_PHY_EDPD:
> +		return smsc_phy_set_edpd(phydev, *(u16 *)data);
> +	default:
> +		return -EOPNOTSUPP;
> +	}
> +}
> +EXPORT_SYMBOL_GPL(smsc_phy_set_tunable);
> +
>  int smsc_phy_probe(struct phy_device *phydev)
>  {
>  	struct device *dev = &phydev->mdio.dev;
> diff --git a/include/linux/smscphy.h b/include/linux/smscphy.h
> index 80f37c1db..e1c886277 100644
> --- a/include/linux/smscphy.h
> +++ b/include/linux/smscphy.h
> @@ -32,6 +32,10 @@ int smsc_phy_config_intr(struct phy_device *phydev);
>  irqreturn_t smsc_phy_handle_interrupt(struct phy_device *phydev);
>  int smsc_phy_config_init(struct phy_device *phydev);
>  int lan87xx_read_status(struct phy_device *phydev);
> +int smsc_phy_get_tunable(struct phy_device *phydev,
> +			 struct ethtool_tunable *tuna, void *data);
> +int smsc_phy_set_tunable(struct phy_device *phydev,
> +			 struct ethtool_tunable *tuna, const void *data);
>  int smsc_phy_probe(struct phy_device *phydev);
>  
>  #endif /* __LINUX_SMSCPHY_H__ */
> -- 
> 2.40.0
> 
> 
