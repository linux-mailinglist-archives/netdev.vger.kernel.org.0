Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF2456D846C
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 18:59:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbjDEQ7l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 12:59:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233923AbjDEQ7X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 12:59:23 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2061c.outbound.protection.outlook.com [IPv6:2a01:111:f400:7d00::61c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9765A83FF
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 09:56:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DwmIa28xnKG33HZZXM613mnVlk9WqlMVS2VvV5D4J7Acd9ZaYQHxsRpudoRwweb+2ZHKnx601sT+3LNyt2wo2t6cHlveb/7LFUQlEPCuMqcJwifsNWKUBto5M5JGeXJOu//rqjQkCvt6qUm+MsyLsR8hg3XUnWKx/4w3niN4ye26M5T4E7KjkBuH0VIl/UKxlqsxuV0iqHK1fLSBWkgpOItLxKUQojBIad8eWe8n3kytEPCLxZyIbEk3h2AhINeJlSL/QBUOq3D303UZKuEyA/FoI2HiDdgj0rAUT6w644Vh5grkpadEvOFUxm3BtMuBCXrqRwUYHi/hDj57bgroLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hnUrsKjP9O4RFJ2begB+FatVOLk1ibzlA3fw5UBaHnY=;
 b=VE/3hO99ePBnSYTffO3iKEFHSdy3FOJltVqep64qiUr5O9DAx7/4OiXotP/8N3j6dRs41Fz+cbchg1JWA7cD5cwf6I9eWRpIM0+ppM65xTnnPto88paYm2d0pEeQKfzoJ4oV8ISRt1O7yy8P87rpLrc/mlJ8f53V1NYyzernxrGJWfIBUivc9DqjUmf2BVW3vyC2KfgcgHSjLXWq4PprBLpjFwZkRqI3jtEAh3Z7ZGwHD2HFIAkCN0/gJDp0PcV0MspDb2XtGzu+UtOQiuCG7vRbC4k7K+bwiFKxDvD46VDGNda++z0NkAt/ad7BdKRlAwYJlq4nAdJUcNjdWEK8fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hnUrsKjP9O4RFJ2begB+FatVOLk1ibzlA3fw5UBaHnY=;
 b=Lt6bsnwxfXts5HKoiwEksRsMxomNti9h8wnkjdIkV7GxTSfMRCsSkA0O0OQ7KTBZHmw/dm6yopF03D1fj0yhRlK1mqmc9FybzThLaQqvYYs45bZRzPOEinTrrizGF338CHJ2NgJjqGPgRWWwHm/9YIZIUO5A/R8XcZTWJa4UdzU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AS8PR04MB8071.eurprd04.prod.outlook.com (2603:10a6:20b:3f9::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.33; Wed, 5 Apr
 2023 16:56:06 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5%3]) with mapi id 15.20.6254.026; Wed, 5 Apr 2023
 16:56:06 +0000
Date:   Wed, 5 Apr 2023 19:56:03 +0300
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [RFC PATCH net-next] net: dsa: replace
 NETDEV_PRE_CHANGE_HWTSTAMP notifier with a stub
Message-ID: <20230405165603.52xafuuhvcqsihtm@skbuf>
References: <20230405165115.3744445-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230405165115.3744445-1-vladimir.oltean@nxp.com>
X-ClientProxiedBy: FR0P281CA0147.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:96::11) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AS8PR04MB8071:EE_
X-MS-Office365-Filtering-Correlation-Id: 04eeec1e-e480-4be5-e9ba-08db35f6a5c1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BPKb4nwlakHJ7at80rmc/j1JciCTyrhlGPVg+oHsc6k75FYWK6I4r8O6tR2VYifiXgKtE3xRaA1e5ChGw4F/fhZgDZu74Nl8qv2l/geOBrq9X7+sQyX2HMgWmGRweQAX7WKZ/qGZ9BECE3Qa9dCMw4h0VGVhcTo0ihZ3zluwZSWujN63PRJDA82oR/geE6oA2sd+xrtfnEtiOHsMvgxp8vS3L7IwrIhWnajgLXpRePFSpc8H9tJ3NzvsEmDibNtb64VlBKJIgdB6FM9PTrzDXOA3dBVEU3b5x5qAc7yWFEccFP4U29oFZ4pQ7cRwpkrxZ9uKK5FAMK+8neFKQnnijg8AhzJWTLeaWPygxLgyoCy3pX3ftlOGu4K2PGPSkK8rCM6FFFCYvUUDXFS+jkGijEuqOMjfMWxf7QEzxPmBNfKm1v6M+3xIBuWK9JlmEO9UcoK97eCAImaJpLPqxQmwA9PtU42D5lp/enRWvHf5FGrzuOx3i2qljyyNUnE4RL1d8S8PObca5yMjet24885kWz9vZERLVqToev+fZFcrMNcM7DKSYAdznHMeAx8OCsbp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(346002)(396003)(376002)(366004)(39860400002)(136003)(451199021)(2906002)(33716001)(86362001)(44832011)(6486002)(83380400001)(186003)(1076003)(26005)(6512007)(6506007)(9686003)(6666004)(66476007)(8676002)(66946007)(6916009)(41300700001)(66556008)(38100700002)(54906003)(5660300002)(478600001)(316002)(8936002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dQJN2mBF/vwEIGiW/tqhlLPDpscJ/bdz0vcQl5vF/5A1nwK0R7fL4lfIqKth?=
 =?us-ascii?Q?I0sJUG0DS1eZdDyreodoqz6k48nj5ZLr7I7OXENwaW/bjbPcBthVV1iwea/W?=
 =?us-ascii?Q?YbKa7sVhdNDr7lJMuh4bHWlByq9X2zln0ELHRov5WJT3NU4VI1L5ODBmMDiY?=
 =?us-ascii?Q?eE3C4XYaifPS7Ap7N+MTXnpkJwMs4XUGrN1eZrw8ur7t47/OTplSR4lkXYmO?=
 =?us-ascii?Q?UasnXxxBvrLiNXlEOnsB40uA2UfPGpEhZ9YCkYphcPn5ob0CbF6DZUlEj2Jp?=
 =?us-ascii?Q?aQJkLw+y3NNNEe4bqA/mj63uYKQm532+e8xG7mjtVkDdi+X27H0JTSNmyByY?=
 =?us-ascii?Q?6RLH3MVCHUqeI2UdUctp5sp2GJL3KdMWa8dYmCa1PLYI+VK5PhqgZ5205b0o?=
 =?us-ascii?Q?j8BDMNJz10pjvnTKY4ccyIwpbl5mvY9IDYkqgm7r0SRa7Uw8SneeUCyPk+7t?=
 =?us-ascii?Q?W3cWTvAGCzMA2i3SfHlnuQ9yGmBYTxEm483b81d3C0TwCjdALOC0olj5tsd+?=
 =?us-ascii?Q?VAN/OzrWUTDiwkZJyAms6BRBzmZZsYbGP1ZPAzusKHqhsy0+lFlwgdLEbrJO?=
 =?us-ascii?Q?LxIKO9ISbunhG5UXvu/1tqy5ygZjiDwqVYTNh2mvN55IzY4r0Unu1KqnRXy9?=
 =?us-ascii?Q?w2rrNmPP3U0Sd2y0DddtKWgz/LvbNK6h+93OKfXF/I/XxMsnbKXaYsGKTbAX?=
 =?us-ascii?Q?z0WTREevxOvWkg+pe+gm0L3tJOrGZlJUiynANQ1xg2tTBHAfPQb+PYWkPyr9?=
 =?us-ascii?Q?szJSXfTZOmzCw9n1yl15PvG6Hb0lEhSoEPRH1KG44tCj9x0v58RUsTwcJ6sh?=
 =?us-ascii?Q?qPI5xIiZgyKBz7nZY0lr17PCJJG7JcsQvjsv+fn9Cp4TUeDLdYFqgQqKOQ6C?=
 =?us-ascii?Q?UtlQNe/OTfYqg15eXkV40p4ewyE7GCIcV9d4U2MEG1JyN+uCnwB/OfHjSIul?=
 =?us-ascii?Q?3uUNXRpMMT32ZW+iCgPkl4TXjWqChKPIc8h8fZnOCwqjRbZzPlEBdIvSBWLC?=
 =?us-ascii?Q?/PtglAw53TarOYVvrt8+qfBIm9azCg//jXtzfK2j0T6IIPSt8vLYxTmE5eNL?=
 =?us-ascii?Q?YTpnaWFHwLcJBPO9OWk2Y04jWhI9NtRlfJ8aUNZJO3EzX7AH8t6rDhKJwPny?=
 =?us-ascii?Q?D017aadye9CeC2JYnRoFxImn7lOQmtAlMDdylSvh1GrTMmizGPNlevlA1iZI?=
 =?us-ascii?Q?SsNOgEQB/th7IcuLdGZeY5VNtstFTMVSES5wiIhLrVyDhkypKcd7XQFi1tEt?=
 =?us-ascii?Q?qpta/8rbGNGZkzpxZWoaV0q4Z/8ajUo6+f1UCd74Rb5EyRRio+FGfs52WWZj?=
 =?us-ascii?Q?JwX+fSePDLBEFuMWbL8tUw1lUJZ+GEl12eNmhjUSxSg7A6iZdZr79OhrOG+C?=
 =?us-ascii?Q?WnDcFUGv+HeyxDRvZDlSluFnPS6vwNzU9Cfzls2gFQUjbVO9m6z7afucxPs4?=
 =?us-ascii?Q?3gr53V9vfDLNaBSOo9YTPQMgWuaMGgH/KSa9rs0nFr1vijB228WulcRWsVFp?=
 =?us-ascii?Q?Au6l2i60BpxiNxs/P1Rs83eKVgpUuqAN8GTx8faiQoOdS5l28O81MdtkDMhz?=
 =?us-ascii?Q?nR4afwGeUOgxsu+hTDwx6pWFgy6xmqKExozTpQo2dWWidfuC85QNSfGRuLt6?=
 =?us-ascii?Q?7Q=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04eeec1e-e480-4be5-e9ba-08db35f6a5c1
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2023 16:56:06.4738
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y0JM90VOjbuwrS7QKZ/SNQBeg5bFbzjKMQC5tUTYWL+WZhL0AbjFoyMJp6mFv2/LyDU9KWazi9CTFXWLLt3akw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8071
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,T_SPF_PERMERROR autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 05, 2023 at 07:51:15PM +0300, Vladimir Oltean wrote:
> +#if IS_ENABLED(CONFIG_NET_DSA)
> +
> +static inline int dsa_master_hwtstamp_validate(struct net_device *dev,
> +					       const struct kernel_hwtstamp_config *config,
> +					       struct netlink_ext_ack *extack)
> +{
> +}
> +
> +#else
> +
> +static inline int dsa_master_hwtstamp_validate(struct net_device *dev,
> +					       const struct kernel_hwtstamp_config *config)
> +{
> +	return 0;
> +}
> +
> +#endif

This happened again, I need to do something about it... I ran
format-patch before I added this last hunk to the commit:

diff --git a/include/net/dsa_stubs.h b/include/net/dsa_stubs.h
index 27a1ad85c038..9556f9fb5a86 100644
--- a/include/net/dsa_stubs.h
+++ b/include/net/dsa_stubs.h
@@ -41,7 +41,8 @@ static inline int dsa_master_hwtstamp_validate(struct net_device *dev,
 #else
 
 static inline int dsa_master_hwtstamp_validate(struct net_device *dev,
-					       const struct kernel_hwtstamp_config *config)
+					       const struct kernel_hwtstamp_config *config,
+					       struct netlink_ext_ack *extack)
 {
 	return 0;
 }

so that the build with CONFIG_NET_DSA=n passes too (which I did test).

It's now fixed on my computer, but whoever is curious to test this will
have to fix it up manually; I won't resend the RFC just for this.
