Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDFD65B00DC
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 11:48:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229528AbiIGJsf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 05:48:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbiIGJsd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 05:48:33 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2121.outbound.protection.outlook.com [40.107.100.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C969B5178
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 02:48:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bVcv6sKM1EfdstwbpqmPI4o0BNAbPNT7YhVNrBiZaimCV83gIKmXzelzzC/BeCPAA6XCjoCFktRrDxJF2eAeq6GChbCyhY+Elt83eWC6rKl6qqsFUS0bJpqKdmEQi6w9Nt1Rc9OyxisLyOhlPvbz7KW095F2tcMBsNGLRiofYYU3TtGa+OodmjDyVYcW8lYgxkT11R49ECHGPkgqvh179scL7k30Vz6KLoXINVfNAeHd+IPo24PKuA3IIIDCwCpeHd2N3h/iOK+BTSyuWzX2mtovwpwwY1+iKS45YM98xx60H60Wkx54Ed/aZmXIDTPVJTlz93w0nF3TbmOb/Lz6SA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qb3kj1NeRXaKQLhqLo1c9EyeIGq8ShY0GE7IYzN0pek=;
 b=Il2DDrqz0C/Er3jLuNzYtRhSoJp8nEykq1IYn8Fp+z/u6/yQtn8s2CEnMrA6bcuQM8CVDNSZpRAqjWPrDorYhodLFiBv+9qnE0aL+I1XFmdxq/aK5Zz7umi/TlJ+SPFmCMSUHcPQkVJ3gHlXKl1U0LNeBK0JG3anxuxfafTycuYV7cd4Mpj9w4fXiXt3jazjZWNzTSf/jQJrF+pTgz1/9JuKexchgeMtPnNFKaqAxITOyHROdNzfJpXyVursTvBRtylRkPas86FTJbpRcCwteyp+FM98eCn0c25QkyIswajYS2jQO9p4ifySIl6RmVROAwRR4F9UogYfyukM6OYjZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qb3kj1NeRXaKQLhqLo1c9EyeIGq8ShY0GE7IYzN0pek=;
 b=OlDqJ+vLwhexKrBqi1OTyfSSQkKa4N3Bqa+d6/iWrJrEOkKOtaJNde/4BrL/ggoNvHi6DEazmxD2BuJ7Gia4GyRS5IMbyaPNxJGS7G65AdwNOlnaSPwUwrmzlDF3R51QM+oLG01GA34qD9sJ//vSmSCsV/aGHBMst2sLSxeyDiQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB5617.namprd13.prod.outlook.com (2603:10b6:510:138::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.9; Wed, 7 Sep
 2022 09:48:25 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a1e6:3e37:b3f3:7576]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a1e6:3e37:b3f3:7576%9]) with mapi id 15.20.5612.014; Wed, 7 Sep 2022
 09:48:25 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com
Subject: [PATCH net-next 1/3] nfp: extend capability and control words
Date:   Wed,  7 Sep 2022 11:47:56 +0200
Message-Id: <20220907094758.35571-2-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220907094758.35571-1-simon.horman@corigine.com>
References: <20220907094758.35571-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR04CA0093.eurprd04.prod.outlook.com
 (2603:10a6:208:be::34) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH7PR13MB5617:EE_
X-MS-Office365-Filtering-Correlation-Id: 9b4a42d6-e20f-4ffa-5478-08da90b61b98
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nIT1S1dP2LkbACeUdE4+xomyvP8C6TMyeRQiKLxGhsArx0q2yRgyQ46C+9b5FNPd+E0n8CwtorfM7eGrr3azKLY1BAuniQfq6R3z6kcPzXjZH1KVDX9x/SZE9VPH0JEepF7k42mFU0b+ujPY292Kxaei+3FrMXcgw9MAGN7rvwueCZdjtyge0XZd1vujIgpdMo71nBG/GhxVNqEVwHgSgKC14MMyJ7O0vp6vIKKY3zGleDCGVygmkDU3wws1DEuoRoDQvBz2YvkvF2sV/Zfph1Tvs+vpNDqsy87HOp6CIk+idG7VREZrthbzek3mZRQff+oVdZljUYq3OgTduzubcWkQVgigMQQb9ah15v8AwaNWgGfwWRw4sIWpJCamoMszVSntsBxp9LNQhTYBcPIJxd5pByRrU7egFAGY09qiKKQSpb8viD0aKKYs7IQ1nHTYppxHPS6g6lHw9k+Ra5Ak+JopC9a9RzmCoAkegEHKctxq24zLWqRvd73M2n8MD9tWdDJFqlPWWSJ5Exo7H+6vOYt64UTSIYFFLpMjtMkFsMI3nG6R9F8IFHexRsL8ddl+LDfrs2C2Obp8s2Mxhcy2JezE+JJgB2FVGLvEqFVpi56m825G+cWzEW3ROW7UY4Sf2s0MArk3r5j7L7kUAvo8h3S/siIbHZ9fegHBFyrjiGyMlFQaGuvYchEDLgWkw5qqAxFyQ0jOrHDrkirSO8fRpYwUHdpwsk1J2edeRxV1N41rzxcNBXyX0dP4paQtaaGx
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39840400004)(376002)(346002)(136003)(366004)(396003)(186003)(66476007)(38100700002)(478600001)(52116002)(6512007)(6666004)(6506007)(83380400001)(107886003)(1076003)(2616005)(6486002)(41300700001)(5660300002)(86362001)(8936002)(8676002)(44832011)(66556008)(66946007)(2906002)(36756003)(4326008)(316002)(110136005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GBexknM6WL4814CPY8EDNX9lOpURWfVc8MzjQHAvOkjIevFcM2I0KolMj79R?=
 =?us-ascii?Q?mHV4ymCY68LhwIUH+3xI+Ynyo8sHLvtwO9kW5EYFCbl8JHpt/m41os8lBgkh?=
 =?us-ascii?Q?15bCWwUsWO14H5ne+LL0nlN/dqdTE60ucnPHBG9Jnof300155XuAq2EspL/z?=
 =?us-ascii?Q?e9VFroOnCIfGuUssfWhYl6oN5cCbc19gEUcXY2i1/cZM3sc9QSHp4ds8dNAR?=
 =?us-ascii?Q?a0QJ5TvPwdk8L93jYAm65TMk6WUH0fgZJLs2dlWClSOlENs1qJ0DVEt9wASi?=
 =?us-ascii?Q?mddcLxJAU8t7LYNA+zsjuDB5Vt3jxWbJG0oASLn8/H0hrQMkmUM5Jk0wHI8w?=
 =?us-ascii?Q?uwGh5xMf+ba0IcBul2vUeFqQ71UlHQJE5OIDsMTGxxEVgKxt5Y9itDhO9+SG?=
 =?us-ascii?Q?k3MCcNlr2QZBQdgtyqvEVQ6KbHdJCIr5nvGOGjDQOCvEa5/z4CJcoZ4D+COF?=
 =?us-ascii?Q?BxyBrd3u/01wFthNuhQxcTbQ9tG2BxS1aSCNv5Km2DPLiMkbzCaU1r9wFQHC?=
 =?us-ascii?Q?Rp/ea11Shu5FVZ+xJe4h1mPjF9qVz5JuvrHy9znPNRLd9hIDnFkyH6Nixpwe?=
 =?us-ascii?Q?msUzrbILkEew8pC2XNYQBTvhIhy/FNQ9a0VWw6SCrvx3lIFjuj21CXFP6hOq?=
 =?us-ascii?Q?k9ufG6tKGixhl+dZRXXPJqpJ+BbI3dKs7ck2kN+g+6UGX8Y9YcJ58bsr599H?=
 =?us-ascii?Q?rpms07feTah/E9VaWLEXKA4a0P2gbNAsRmSzz5hRdftcdeWDbvd7sy91p22i?=
 =?us-ascii?Q?aHd5Q8EJLXdAms7uG7r10VdMonCZYf7XY3NJCM1Q4yvVGQodyxNEvqST8dLE?=
 =?us-ascii?Q?/Q5LZ9oTa5U05Gstx+n9h2eXaGPzeEDJviB6TtIxpSr0ZtGRR3GBEKbLAtx+?=
 =?us-ascii?Q?ILPxEYZhz7jOlHLm0L+ATeCb1AYoWlsEA7LMMyqaLWL33NR2STCLC6E7pinq?=
 =?us-ascii?Q?JhkcC3LA8m8rFnV7J9fugwzcF7pEmIkt9Y9m4PlcpoBiMyZ6t+YU1v5eGMxD?=
 =?us-ascii?Q?hB2DwlZ/sk4SmrjkSSrIcMZKa+9BxKaVVvvRagAvoJkXXGuNx6DU6+kRzHnt?=
 =?us-ascii?Q?gn8QmQGrhx+ihDOfhSFkaxMFZawTxfI87RD79nPAT6HDMZi8pn1uYRy3lCiu?=
 =?us-ascii?Q?v4zdDcKJyyA44ka9Tfd3kgRDEtWIX/ajWCM/YOC+vuB93KsDI1YK3aP0nsAF?=
 =?us-ascii?Q?Eu2Q/fjitvVcPKUr+QjLwC+3WLW4m3Jajv7xBFtu6Zoqwgof+RkYu4Nk2zrQ?=
 =?us-ascii?Q?UIuWkEwckTdk3KUknmWP2hDCPhLF9EZrLKXfGISUu0on6DwlB4AV7B8iJv9c?=
 =?us-ascii?Q?Hi1lJAgJvXMX2qVXLwumqTXZzMpDBKjakdf3mFNYWtOkPC5Q76nhKj/az3jn?=
 =?us-ascii?Q?+4uvhSW0z7MHmKqKlX6ziAcogbrWcXrRWRcZtd4N/joheHhF2tegkdhXCCaw?=
 =?us-ascii?Q?rxNTX2B0EKiZ81MiTQvNHpw5FNTINitpHPkkB34Evyn40LqWIVomYWV1Jd9f?=
 =?us-ascii?Q?QNuc6ZUejWen+8O3jIybZ1y42XPJNYzk+Tcqv3w0NrM7dpkhh+LiQxlsq5Ql?=
 =?us-ascii?Q?mEBNfTxxgtE39vcC2+64gk6F+GDieVQchpIzwR+nHqNWPQMNT5bPJN8lqIxM?=
 =?us-ascii?Q?Y6ItefS2PjfYqJPVqZvnjBdVtduYpiWXensIPGm5RNT23KrOYbdl6EsYzLZH?=
 =?us-ascii?Q?jst3sA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB5617
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yinjun Zhang <yinjun.zhang@corigine.com>

Currently the 32-bit capability word is almost exhausted, now
allocate some more words to support new features, and control
word is also extended accordingly. Packet-type offloading is
implemented in NIC application firmware, but it's not used in
kernel driver, so reserve this bit here in case it's redefined
for other use.

Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Reviewed-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/nfp_net.h       |  2 ++
 .../net/ethernet/netronome/nfp/nfp_net_common.c    |  1 +
 drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h  | 14 +++++++++++---
 3 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net.h b/drivers/net/ethernet/netronome/nfp/nfp_net.h
index a101ff30a1ae..0c3e7e2f856d 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net.h
@@ -541,6 +541,7 @@ struct nfp_net_dp {
  * @id:			vNIC id within the PF (0 for VFs)
  * @fw_ver:		Firmware version
  * @cap:                Capabilities advertised by the Firmware
+ * @cap_w1:             Extended capabilities word advertised by the Firmware
  * @max_mtu:            Maximum support MTU advertised by the Firmware
  * @rss_hfunc:		RSS selected hash function
  * @rss_cfg:            RSS configuration
@@ -617,6 +618,7 @@ struct nfp_net {
 	u32 id;
 
 	u32 cap;
+	u32 cap_w1;
 	u32 max_mtu;
 
 	u8 rss_hfunc;
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index 469c3939c306..7e4424d626a6 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -2456,6 +2456,7 @@ static int nfp_net_read_caps(struct nfp_net *nn)
 {
 	/* Get some of the read-only fields from the BAR */
 	nn->cap = nn_readl(nn, NFP_NET_CFG_CAP);
+	nn->cap_w1 = nn_readq(nn, NFP_NET_CFG_CAP_WORD1);
 	nn->max_mtu = nn_readl(nn, NFP_NET_CFG_MAX_MTU);
 
 	/* ABI 4.x and ctrl vNIC always use chained metadata, in other cases
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h b/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h
index 1d53f721a1c8..80346c1c266b 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h
@@ -254,10 +254,18 @@
 #define   NFP_NET_CFG_BPF_CFG_MASK	7ULL
 #define   NFP_NET_CFG_BPF_ADDR_MASK	(~NFP_NET_CFG_BPF_CFG_MASK)
 
-/* 40B reserved for future use (0x0098 - 0x00c0)
+/* 3 words reserved for extended ctrl words (0x0098 - 0x00a4)
+ * 3 words reserved for extended cap words (0x00a4 - 0x00b0)
+ * Currently only one word is used, can be extended in future.
  */
-#define NFP_NET_CFG_RESERVED		0x0098
-#define NFP_NET_CFG_RESERVED_SZ		0x0028
+#define NFP_NET_CFG_CTRL_WORD1		0x0098
+#define   NFP_NET_CFG_CTRL_PKT_TYPE	  (0x1 << 0) /* Pkttype offload */
+
+#define NFP_NET_CFG_CAP_WORD1		0x00a4
+
+/* 16B reserved for future use (0x00b0 - 0x00c0) */
+#define NFP_NET_CFG_RESERVED		0x00b0
+#define NFP_NET_CFG_RESERVED_SZ		0x0010
 
 /* RSS configuration (0x0100 - 0x01ac):
  * Used only when NFP_NET_CFG_CTRL_RSS is enabled
-- 
2.30.2

