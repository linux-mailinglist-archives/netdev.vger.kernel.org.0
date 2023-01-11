Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D21266602C
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 17:18:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235411AbjAKQRm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 11:17:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234496AbjAKQRc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 11:17:32 -0500
Received: from EUR02-AM0-obe.outbound.protection.outlook.com (mail-am0eur02on2080.outbound.protection.outlook.com [40.107.247.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 722131C939;
        Wed, 11 Jan 2023 08:17:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gHRagcAPQCvv6bd3Ns5SBaBib3ppGY6hXsiLEna3wq95y4qnWqnb5nZ6Q7SURri/MZocr1U37BaZ/DAOxGSsoCm7PYt1js1ngP7iX+vcM0xfiPunnS6qrKitH1bPWZGFKQ+mYceaoBt7LIDXVLzNR5lE3jfTcrqfXKcp5MClg79afFRCKu+LRYvhUFFA+3ijeabBDwzGed8bUZeAQBWPJyuwXDvMYlL592ZqAK5ImZVYM5DXomVjgLzLjvNTxHhIHnvdqDXTJ/BLKiJTLjZJkvDkuPtW0ubRejulO4oue2T8nSS1UOtuXQZr2RA5GQcygz7+PbetF4UZSFwRVyyzjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U+K3mCrI0dzl3Y0k6y6S7df61prpHK+2vgLIdLHOEW0=;
 b=GiN/H2yMbmE3vGRLS38S7VZ7ywt4RILVu4WAraQQLXP4YJfqq2vMpon5ToB8bHgd6tlE8YyDM45oBUPy/K8il5qKGUgtLth3DmH/aaQncZtp787VBKfHez3394Zz426jO13Ji8IslD+gcB8VAPEf9ZqpSNFQtt2B49irVQgX+4/VfpVn0+iA1JXpPKmNk+ksNpZ1w5bqPONhMp6njUdSWQkEU38VnJEYEFF5ViHXqtGofXcGJIByvGh458gdmIvUVzbMb7SywdCjPA8cGbLlijse3O8jVp/u2ovPWjUFUicQzLgqpgEVouhdek7Cc7L4RZKMVpUUsnyoEuXo0P6+BQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U+K3mCrI0dzl3Y0k6y6S7df61prpHK+2vgLIdLHOEW0=;
 b=PfsOzVCgme38DLwSzVtlNWfEH+Zm9CXVHxpqPbEduOFpwjzBV7ZAktisuZAEtVgMR6tgeeABd0MV/nD459U9lgZ0cazwMsi3OyEelGMRqOf7Ofll4H+xKs4dalLYF1EL6BngyDW9lUH+x4aMvuRqOVee9vCbq0nS/5znq2WAH9c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB9PR04MB8462.eurprd04.prod.outlook.com (2603:10a6:10:2cd::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Wed, 11 Jan
 2023 16:17:18 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.5986.018; Wed, 11 Jan 2023
 16:17:18 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Rui Sousa <rui.sousa@nxp.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH v2 net-next 01/12] net: ethtool: netlink: introduce ethnl_update_bool()
Date:   Wed, 11 Jan 2023 18:16:55 +0200
Message-Id: <20230111161706.1465242-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230111161706.1465242-1-vladimir.oltean@nxp.com>
References: <20230111161706.1465242-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0163.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:67::8) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DB9PR04MB8462:EE_
X-MS-Office365-Filtering-Correlation-Id: ca3d3772-e488-4dad-c386-08daf3ef4f1d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tsx1WU9uDnhYv6TkuzAvPBxtrv/BO9E/bbvkHOloGVDTWGNe5+B83L/PAp7bGqcTAa3w5PqDLZV04TQ0GU1AXltPrbdckaWSvTFzWnD6rxv+nFWNMdKaauxkJrYNManDD0qFWwyipNemF20ShB9Z89i/kl1ZrNAVZhBXAaihx6NZT5bp/QXqv/VDah61zJAdopR1vNBpJ/7PuLaIQTzqOeF2VfueZdriEenRUXInb29LI3VagvnruDLwQVHAwVgiH6mEq/wrABqMrg7vjV57sGEKWp312zKb3lDLjV4JVF/8JBJy5kI9ivzfjPQB692TLdX7lJum8F5cqmQXJK2D3tN+3K9AjELdSecxnFDzj5V0eeZGqAFtxOyPtib6GrKSTW66+XRouUozvOKAVBveHO3oJmkXX199XdDyMZfd7cBjbAPAqB4s4OfdCDK9QfV0Kl1D6DvdFreB3SGLAgpiCJofGF93/w2M925qju5K6Vbf6SBDrXFp/BezC3F0m4kHEKKtZ2wdNSdJAnECE1z0q/t+ZDc1Pnq4tX5kwew7UYKTmRTyP21dqQ/cI658bjNMNqXwJ3tRYJ1rFOnZgL0f4greXyXfABL7PArE9k3dUOCY9BkrsGA17v3/1oEyjHUcW6G6z06yoQKgtZe2kHRNQmI69U1pOReiAl/NrtHq8occo2h0soIiEY4THOFH1KhWKi2jIWOPAEMvG3ZQRvNiyv05T8y3B9cEaN54siItCAw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(39860400002)(376002)(346002)(366004)(451199015)(36756003)(26005)(186003)(8936002)(6666004)(6512007)(6486002)(6506007)(1076003)(2616005)(66946007)(5660300002)(66476007)(66556008)(52116002)(7416002)(6916009)(316002)(4326008)(86362001)(41300700001)(38100700002)(38350700002)(478600001)(54906003)(8676002)(83380400001)(44832011)(2906002)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?w+4mAdpHXDDBP1v9b3ZK0SVWAaXNiX2a2AflQbYcBlYwrJt9cZVSNL+ftELw?=
 =?us-ascii?Q?EOEK7mR3ihN6LJu0ES3KYwBYmCYwsVgiH18KjINj51lxAfs6TqvvvUY3Zi/N?=
 =?us-ascii?Q?zCTRAIJd9GX8JPs7J9GA/eY0S4WoCyLrnOiOjxqKho6dxKipri3gK20oA6n5?=
 =?us-ascii?Q?TOQwDparZavZpoyaD/DwBFn9AsYFprdaRjeg/P55HuCgo8y1gxyhTXwrtfUQ?=
 =?us-ascii?Q?PbJfc57Or9+8ErRFo0FJjsL3knw/MwolwFtYeqNVPTz9tpkB6uyAWOTF0b3H?=
 =?us-ascii?Q?MLSWvu6HzJIetexLJUjUJroROtlRCMTkymlEPVzh7lIJtVZK/1EyF53DFwj9?=
 =?us-ascii?Q?L9LmFvc0W5b5tkFOt5UUjCPawdulcy7RUwlW3PagsiHvxKEPKK9T8k3wFIeW?=
 =?us-ascii?Q?EDtTOKE/b/tfV4IJadPRkYRXalOSjmRU8HUUhncX1Y1AeptY6AFgzuQd0hC/?=
 =?us-ascii?Q?YD4UozBjfJ7IibeOeDDb08/xKd30FdzGDk8dsnN3/1bkSAMgIGmiAdPztWU4?=
 =?us-ascii?Q?4Q17I8bIOhAwRSxBmlyhi9v0QcathYJ1BAC5cstXXRttqnonQr1F+ahPo/VT?=
 =?us-ascii?Q?Phml0VZx6r7hY2Ir8rL+L6OzFwukLgcxI5ZvRx4mPFtNRAeDogvd4gB+hvd+?=
 =?us-ascii?Q?gkGhGcNrccp58BmP0Ijp0+Akg/o825oog63d2GqRx47UH4aZXE93iXY/Bm+3?=
 =?us-ascii?Q?Y93Srl4rdiHsEvu1bVdwpFo7f0/fEgonfXvnVJzH9rx90DFi3NlClwJrKPf8?=
 =?us-ascii?Q?JRH2quJ5tvAswYrW90xDGnFzk77ggTZbAwP7Fa03A990gcgS/ZQErkSAx0hH?=
 =?us-ascii?Q?onYyNEj0pocLOzp7XjXVyw4ceuhT/XcRkeHjsHtTkoWoVkJIKbJRisRSKNZD?=
 =?us-ascii?Q?UstXKCFwwB/oE1VSojlU2DXMX0/xGipeu8kP/pjbA4iGc0QKL+B634arO6ls?=
 =?us-ascii?Q?dDY9p0OIMGgSWduenmnZr9PsLbai4WqnjTGdQXElqfFrT+ETqUZt9ohLfsUN?=
 =?us-ascii?Q?HjQ+Wl4Gj88zcOyPzpc4eOzUG08i3e5mDu0qc5ZWHB8LMU58H7WWslk4bRrv?=
 =?us-ascii?Q?M9I6ib1eY73WdJVYesy8yuQAKJOtN9igxFcpT4B6v06r8HtceBH9yVkjJ4te?=
 =?us-ascii?Q?tWw/Vxaajo9nVN+j0CguKjR3HnO5YyA669NL2btDfnfuxllxnPJwtUgXNyR7?=
 =?us-ascii?Q?dj2WjXlbxgYxpvwSI6b7Zeabpoy4FPWWclMGm7GPmHDvVtUbBgGEFNPNFjPq?=
 =?us-ascii?Q?CKgNz7V3MTM7fN9fws7P9f4Q+D2xtpeSjY1lJedOqfW8ZvsTwaqFyZV29PHO?=
 =?us-ascii?Q?7mC9za33J+uoriQMoYkW3AbnLP2dujc/IeCwEZSaDCsU7T1HFe5sHO2qYDzW?=
 =?us-ascii?Q?70Jw5abS5DoBNkdu401D2VdjPQBNPbn5xriSmBppakh/PL8ov6mV4ZcbLH0J?=
 =?us-ascii?Q?Dp6EvFyynbDXF/k7CwSnT8Ulk+6xUkNCMk1Wp/MF84SXpfCLuhCjevdqi111?=
 =?us-ascii?Q?72fpGTCcz4Drf/gmi5LEFifuKqIiFM1g0bWYhOunJJWXpJHPMHxhvT9mzBKz?=
 =?us-ascii?Q?TsuFVWAjXQtUZoWFC53sfQe2E0l6v+YTmj9jg8fEY3pY8JorUPB6M1rhF9rP?=
 =?us-ascii?Q?1A=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca3d3772-e488-4dad-c386-08daf3ef4f1d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2023 16:17:18.0336
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7ZBHiy6hh7y34iz/Np0qtGXW5T86mfjciLPfbYcAeBome53HKQceG0Sinr6Cf627rZgIPlJVo80lTIgakKVbtQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8462
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Due to the fact that the kernel-side data structures have been carried
over from the ioctl-based ethtool, we are now in the situation where we
have an ethnl_update_bool32() function, but the plain function that
operates on a boolean value kept in an actual u8 netlink attribute
doesn't exist.

With new ethtool features that are exposed solely over netlink, the
kernel data structures will use the "bool" type, so we will need this
kind of helper. Introduce it now; it's needed for things like
verify-disabled for the MAC merge configuration.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: rewrite commit message

 net/ethtool/netlink.h | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index 3753787ba233..744b3ab966b0 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -111,6 +111,32 @@ static inline void ethnl_update_u8(u8 *dst, const struct nlattr *attr,
 	*mod = true;
 }
 
+/**
+ * ethnl_update_bool() - update bool from NLA_U8 attribute
+ * @dst:  value to update
+ * @attr: netlink attribute with new value or null
+ * @mod:  pointer to bool for modification tracking
+ *
+ * Use the u8 value from NLA_U8 netlink attribute @attr to set bool variable
+ * pointed to by @dst to false (if zero) or 1 (if not); do nothing if @attr is
+ * null. Bool pointed to by @mod is set to true if this function changed the
+ * logical value of *dst, otherwise it is left as is.
+ */
+static inline void ethnl_update_bool(bool *dst, const struct nlattr *attr,
+				     bool *mod)
+{
+	u8 val;
+
+	if (!attr)
+		return;
+	val = !!nla_get_u8(attr);
+	if (*dst == val)
+		return;
+
+	*dst = val;
+	*mod = true;
+}
+
 /**
  * ethnl_update_bool32() - update u32 used as bool from NLA_U8 attribute
  * @dst:  value to update
-- 
2.34.1

