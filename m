Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD9D487C6E
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 19:49:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230284AbiAGSs7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 13:48:59 -0500
Received: from mail-eopbgr70049.outbound.protection.outlook.com ([40.107.7.49]:30854
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230257AbiAGSs5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jan 2022 13:48:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BPpnv26WAXQNZB0qIhKjIKwN+YPtmLPAQCmLgRX/YmAPrzvJ+LvC1EqnVSTWGQGr0fbkNBUC3dUArZN8aJ4QR4xlneI94JEwxdQ73vpQ4TFmshCwEMVJeOGZ/qEZhgMZQ7z+KlgfgTbSSwD+ay8qHmPRoqXX4u/J+kMKVRIx3SV9j8bSyFLnIlzQMbgvisQAslxiEBNumxNOC2l5Rr7ac4cdinRIhMmfJqVGdEo5+9hE8JHfC9ZPd/XRcqfHspleRKg6QSLoB+37HHLmhNBuYVRylzmMqmg/9GUgVpE6oshxzlQdTvp+3aaZL1FXPx2HtXIH8XJXlPPTKGIbQDy1hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0UqLaHfGIXmAW5zhwdpEUn79n00QcOW4o6tNnbi45/8=;
 b=duEhrvZadCiYClLlRLiWtkCBy9AdPE0AFBiUqJssqQ45chEZu5yNln8+JNGPCKbhTOOK/CQSEfETzqHUFEMnN7FvbLcbivrZagtw+YPErh3M0CLwhX7bv3Xl7FsndG79Rtb8248TfYFUowPcEaL+iwIrAMChs/l2fmAJg39BZh2i84L+C2x6LsdNExOqAErvWPn67VJ5s4y8B6+BustCcgTqyZt5lKEDkHO5/eXtuVxEpNFzv74LGzQtJTta0Cw+KxEdRiA9gFDzD/cgesK572aAPkcfgncJclQHMj2ehA/XHaxrmal8hwV7Pd7MflzygAMXW572v4jE+gFgTboVDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0UqLaHfGIXmAW5zhwdpEUn79n00QcOW4o6tNnbi45/8=;
 b=cjqanFPLuoVN8GF/S3TZPBd+Sgq13U9YLuARKcfQ+Jc2QU87mQoPYgj9CcM1ZYoImyFhOtWK17U8QL6JKR5vflJ3rn1OUZzu0R5U8j/LKzEK2FtYpuFZR207NAHQenMkeEopmLld+f5fWSlh+MmoSdLcJWVBEOAwdKSQ29uL3uk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB3070.eurprd04.prod.outlook.com (2603:10a6:802:4::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.9; Fri, 7 Jan
 2022 18:48:55 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4844.017; Fri, 7 Jan 2022
 18:48:53 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
Subject: [RFC PATCH net-next 2/2] net: dsa: remove lockdep class for DSA master address list
Date:   Fri,  7 Jan 2022 20:48:42 +0200
Message-Id: <20220107184842.550334-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220107184842.550334-1-vladimir.oltean@nxp.com>
References: <20220107184842.550334-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6PR0202CA0058.eurprd02.prod.outlook.com
 (2603:10a6:20b:3a::35) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 17cfe841-e797-4bea-8e8f-08d9d20e5a3e
X-MS-TrafficTypeDiagnostic: VI1PR04MB3070:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB3070D9EF8893E1F4961BEBB5E04D9@VI1PR04MB3070.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:176;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ohGDqaOEWc+A2nlXqB7Ga8OAkSfoc2iTnfbDqdsr9hcjFn6rq++d9Tr9dLuvIzvPoCZiAAv/wLW2l4ST2em2JNBaShR9+3jOC1JyCIBmxKWlf+0eQvucVP5qOaUZ89Wy1ZAkYkble9+qXFmcXRmquYZy2hxcO8FpsnCwf9dQscMBHh6oANaEMMNRzVATVLifDtWxNl4KuJZJ9t/Jg8N4fm0JJc3w0dd6X3JULuweb59VmjaP0wHkltgTt5KfW8gOq/F3nDvGxKrbXTSP3XD/c/6wLvlX+0O8KhXn6GjP/Myt63JlGW9FvwlLljty0OZazdqjyOVFzMgAa9/KrfGeCgbW4Egyoh02M+d9Noxm4UhZsRLI7HVsrykowYYuPsb/OOfZRrX04S6GTclvu2jk5uouHpQ9r0ms4HFrRHjk1gKxh7PAgqHfsDviISlrFE0yvZqywA0LlKDs2PdDRY0+BJwersKWBM//MS/0lZML4PpxkAZK4Hg7BNru66KBIIjwjCc0GUsHjTHmZ3E7AvOuiAKkEq3FmT3QdvHFQ7xnFcg5p9Ee+ZhxwLJgM0MzZzwApnF0XqR8/J/45Yx+WCdl1RqfQxO+EMSiI/HMx+JDvGCmguES0N/LE0L8t76PCH3SenThJ+Qr6S5PYaUO11DG8t/h6b9eEajR2yteIm1r1RuF2h6w7lzjw7AqujH/3rSDABggI/HN+3mUM2Mde/KBfw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38100700002)(6486002)(66476007)(5660300002)(86362001)(316002)(66946007)(2616005)(36756003)(52116002)(1076003)(4326008)(38350700002)(66556008)(44832011)(8676002)(6666004)(8936002)(508600001)(26005)(2906002)(6512007)(6506007)(186003)(6916009)(83380400001)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rWpLCdPKvLqWcH9HmWoC55jxLo4HtWmNqdZueKZS5jHnd2vXPj0qhP1sRnzU?=
 =?us-ascii?Q?AI6gpHqf4Uvow3sn2yWHIy3Z5KzhBIU1zvygD/7GuOkrZPdESzaRL78YfHuT?=
 =?us-ascii?Q?2jDXxbWEVlqEdaP8GZ0Iq+0AmQi7+pUGXFxFDiFQjwZ9ePUqdWI4WyfPkAyH?=
 =?us-ascii?Q?BiHuef3REQ278Vmwo9MyDo+7ez4Fv4fh6mf/0xi+gghOvtJ23nlGCZIXIyyL?=
 =?us-ascii?Q?h9jCfrRxczbuguY7GmajgsRLryeznMRUkSn7LprT5biAF0/yfRzquxYNAq3K?=
 =?us-ascii?Q?EcGKP9XYfSI3kEFxi5ec0Ge41gpr3+V+t1g9lEI2K4WiBkiqjlOeD9fT4Uk8?=
 =?us-ascii?Q?khsbHdWRfTpIk5wLPYG8OsZizTy5zIPvqwfXUz0Qq6hg27MWlmbgwMM45S4U?=
 =?us-ascii?Q?HceRjA/rXz1oyAznz8J+inIBuoRs47V/rOnk03VD23AGKc0oV9O969Rwy7Mn?=
 =?us-ascii?Q?IyVq70pxfPH9eHy6kHWWCrvq7VKZP3+N6g52CTJb6RQNvDbZ1Znx6TUMGIBY?=
 =?us-ascii?Q?Sr2ROJ792VOBNsvq0UhwGWLYd/UUdwh+OABJLFusNwP+JRugNfYgwhg2qVjH?=
 =?us-ascii?Q?9pWPj4cT/Hu2RbbRV0n1y6ojARK36eExRTIzcWp4z413XkK9DgcSfRkQ5HKw?=
 =?us-ascii?Q?Hh0gD2LcumIPrczX3Wtuh85fZeuot9OOvulfpGfcf/dr7W1ah4QtKtppmPy5?=
 =?us-ascii?Q?L39gtkj5qziAggQtHju3XDlIEEy2NVMWAw1miSxeE3v3JjsmPxfBqtrrG+oF?=
 =?us-ascii?Q?9wu9RqquoA5taC78L/kIKCquZjIGGV++R4rThDiVgk40KDrADzRM4mgHt8Le?=
 =?us-ascii?Q?+bgyanDAGHjQtdXPxICtfbVUCZ70t0oxDNVvLqv99Znvg/KI0wMvNBMFgLt6?=
 =?us-ascii?Q?hUnzItpg6e/pqf0nRLF5Nn6NGhbhG37AVJtJBJq3nDTx/jz661xnOZKg/ezV?=
 =?us-ascii?Q?HdfjX8uvbQLueT2ucucOI+kTpA5MSJnHPuvmZfiPsS1pkIRdF6lAA5JaWjg2?=
 =?us-ascii?Q?rP1BduNddlYM35kTlLcg8KwU3E4eGtaEWKUHY8qO2HEhaBTpWGxbo1CEN4Ti?=
 =?us-ascii?Q?ogK+QfK04kLFjswpRpBa/aTbeIEYViYJjk+WpL0yTQ98YlmDLaGT/dUUwjgi?=
 =?us-ascii?Q?L0mi6S+nB4855bADtNh/25JBIENEuEh+PERMv7W1hWjO/vS+ZIMEsXcPZ8uD?=
 =?us-ascii?Q?AOd4XQLDX0kp4rcGLMK1t+onj1WcsTK/dvzNW3X8fj7OWLy5j2kSAt80ePRT?=
 =?us-ascii?Q?Rfw84iJ+9ZS1d0BZH6jB3oGYX0czxmL2lXoq3Essagrr2YFKY/Qtevruh43g?=
 =?us-ascii?Q?qCFUXziqD/CmXcy6qiJuKAz+RcScz8OSEex83l7tkKHf/wDHrD7fDLXcPbwA?=
 =?us-ascii?Q?AR44CfHFTKFfpF+kUdZ7oHdFuYSR9anO3ZGYt1qAb2g+3QWn6w+1+SK9pfaw?=
 =?us-ascii?Q?lWXsjZ6nrU8iJ/KYSPGFAQUUPlnTWBduoZIatWbNr0eZ37BbS4jnSYFZzLkY?=
 =?us-ascii?Q?dHtGpfZhccGW1foZBDQFaQJKtw/a8LOq0XapAHnC267U83CyDJyUD/pZs0Ay?=
 =?us-ascii?Q?g7F4+Kr2v0miK3GxUcVKoDpUu9H8SEVm33AVVpkHk8WSRV3RV8mHM8cK+lM8?=
 =?us-ascii?Q?1iLpAfsyB9CMkoAUBvolywE=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17cfe841-e797-4bea-8e8f-08d9d20e5a3e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2022 18:48:53.7091
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dV4gvvvb/zlT+c9ATgdO/SRpxQxxl0MoTatyJM+OdIWZIZWxkxnUtXXZaBNUsPn97HZ1HwCL68c63PvZxqXgqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3070
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit 2f1e8ea726e9 ("net: dsa: link interfaces with the DSA
master to get rid of lockdep warnings"), suggested by Cong Wang, the
DSA interfaces and their master have different dev->nested_level, which
makes netif_addr_lock() stop complaining about potentially recursive
locking on the same lock class.

So we no longer need DSA masters to have their own lockdep class.

Cc: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/master.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/net/dsa/master.c b/net/dsa/master.c
index 2199104ca7df..6ac393cc6ea7 100644
--- a/net/dsa/master.c
+++ b/net/dsa/master.c
@@ -330,8 +330,6 @@ static const struct attribute_group dsa_group = {
 	.attrs	= dsa_slave_attrs,
 };
 
-static struct lock_class_key dsa_master_addr_list_lock_key;
-
 int dsa_master_setup(struct net_device *dev, struct dsa_port *cpu_dp)
 {
 	struct dsa_switch *ds = cpu_dp->ds;
@@ -353,8 +351,6 @@ int dsa_master_setup(struct net_device *dev, struct dsa_port *cpu_dp)
 	wmb();
 
 	dev->dsa_ptr = cpu_dp;
-	lockdep_set_class(&dev->addr_list_lock,
-			  &dsa_master_addr_list_lock_key);
 
 	dsa_master_set_promiscuity(dev, 1);
 
-- 
2.25.1

