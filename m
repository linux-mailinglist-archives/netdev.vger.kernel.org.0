Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A5055A131F
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 16:14:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241764AbiHYOOT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 10:14:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241385AbiHYONz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 10:13:55 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2124.outbound.protection.outlook.com [40.107.220.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62E92B6D52
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 07:13:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GxaZeJTScFF0XMF/lJIQle6pysDsOh/tT7DRU3hxobFqxnskSWZYrXiSMcJtWm2/ZbjRqTbVTOtI2AxztjdJvxEli/qihIMQpFiR5FVTRs3XzYsmVpP/yuDnEn+4k+eqE163dUFrg6b0Yj4peLnf9SJOflHf5JIK6+ez2t9vCddJqySfoEqt2h5RYJrhQUJjkqj3sBLul2O0SycXn4QOn/qkXIqQBd2vzeMpRPCKs+NiutW40UsxPR7zZQSlDOhojybrvVr1sfwU5NJLdX50cz/RP57kX53c9UynNw4MnuO5ye3m8KpYhDqEuhGoEyctavf7g86Fkvkea9vJK7SKJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VQWZ9NpAssNVObQ0AmIdAhovxyp2RhtpJDKuX7Eiowc=;
 b=kONnw2NtK1XydXAM+MPXQdgonVafjgCdCosk1eL4KHcftz6j78DC0uaHql1nSHgpzOwC8zdYztRmU8g+UNnfONP4i3qqgVbgm9g7U43DnKcS+vj8QYEMHreKNTZ4pWfyvL38a3fkkPSgPmDHo4wZ/MkrSvJAlXbfufMN3eep5MHaAA6AfYJdBRV7jEvYsmG6dPMS9gsQKUGo8GUQrLeL1edZjAH6UvVeFsvd9rDRhTP0e75sAt385yD/Ola2JWU9jy6vct7YQl5MA+3KfC8QVdiKEVB+A6TGO1kL2lboWibTFxeqiTV8jAkCDwUNVvc0wLCkbAOTTOcnkpTyFftL6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VQWZ9NpAssNVObQ0AmIdAhovxyp2RhtpJDKuX7Eiowc=;
 b=oMW8PGuGHqaVMtq8gNsTVoiANUGxueqbKV4stO7WuGzuqRUQ71MZORJZfEOKO4wfNtpWj3oqqdBqppvujwKEkKMPLtU5te59xZsqlzsaswEbRsig5LPxBWc5YSPU9DSS5LWIetr6/UuajACTyN5sOb3B5AyqBvY6r2SohwuPqok=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ0PR13MB5401.namprd13.prod.outlook.com (2603:10b6:a03:424::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.14; Thu, 25 Aug
 2022 14:12:44 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a1e6:3e37:b3f3:7576]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a1e6:3e37:b3f3:7576%8]) with mapi id 15.20.5566.014; Thu, 25 Aug 2022
 14:12:44 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com
Subject: [PATCH net-next 3/3] nfp: add support for eeprom get and set command
Date:   Thu, 25 Aug 2022 16:12:23 +0200
Message-Id: <20220825141223.22346-4-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220825141223.22346-1-simon.horman@corigine.com>
References: <20220825141223.22346-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0078.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::19) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b4d9a1d2-4785-4ca0-a39d-08da86a3e103
X-MS-TrafficTypeDiagnostic: SJ0PR13MB5401:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yd7JvlXwIZsukBwenHP79cj/UTZYvvlZb0y7PEzBQOGbN6ywSZgsFujxgBrCRHsQ7hWmqjojDJg6vuLdFO+ltP8+ULmJqAirHFugrc7rPHbiSsMnoJVWVv3W8jtZQ/SpUoq+fxDQC9GLxLUhz32i4hdMWoSoUYKLTg17RN8/DvyVj4Kqvo46BI71LmVOhohaWora3jz5eVLFuGOKrxZ4YHxHcvUsIJbENTwfI/9YQTNlHO9D//gt2bpO/nPj7yO4aSkr3VuTo8gwFQyDSJ7RU9N6s8a5YMWn++T7trQXkVpp/jUpnB1s5g1nxnjub7NKSR//eUqrq/JvCBeCvcMBCcJAUWmTdIEU7h433Qa2V03llJVYk84ntdhm5vNPc4h0lB0DkHVBimv6x+8nwTOctUfDpSWrWwNApo8amXMAUT2tQGpNXpF0sVL3sAq+RJqnZT34lMqtrbafd0gUn/vTlTYYdJDj1NipfjGX7qkxoSw5r199WdkhobFzf58qzL4k2GjawSCPOw0g/uB3U2oqMw03o8hECu8bdydMOoFp7rQBTFNWCZVzGEAwz99lHIXVTOktTdSBT9R6GGY6kFPGwQ6nR1AJyKu7zwphs3csnzZ20blz4dRuTurbosyb1RR8yKW+/PNwhggcNOExymg3rTelbr0yswRDzegl+L6Pu8KXogAuXcLbwd0Br+VftQnARcAPerRLz5ApyA1LJ3Oryg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(396003)(366004)(136003)(346002)(39840400004)(86362001)(83380400001)(38100700002)(8936002)(4326008)(66946007)(6486002)(478600001)(8676002)(66476007)(66556008)(52116002)(110136005)(316002)(44832011)(6666004)(1076003)(2906002)(6512007)(36756003)(5660300002)(107886003)(186003)(41300700001)(6506007)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ueTNilP62f8BybZd5AFMvqQvu2OAg6zc4T4o18OyJBzhIMaIsGksXGNo1hDg?=
 =?us-ascii?Q?ZvJZx7ApHyzBE4K5YHiwypecCBKCNaA+2jdRpEaaAGvwj+grPQoOotQMbBKU?=
 =?us-ascii?Q?7nQvxbdDKl8it09EhjmAWRuKnLoK9+dlJWrRKXFC+ioR2pWbx18vRT3JUuZS?=
 =?us-ascii?Q?3/Nk9RgSFdnBcGe/XGaZNwCHWvvTpVO96ABPiA1KclBB0I5Q1w8d9piP72Vu?=
 =?us-ascii?Q?Um7M3e7Q+5JCqDRbKuCp+bhqU+O0suJ6PMZ8Zy4ojyJ508pRN37sraG5o13E?=
 =?us-ascii?Q?0/7oadYQKrdT3cFo5tgrEuhyFEnwoBKBINzNEXxtxJqgJwtgxR8arxd5syiu?=
 =?us-ascii?Q?LXdNfQrjJQaqTi+cCOSa8jIMlTyauPraYNuFSuDMZMH2qXh92anQAnlgIidf?=
 =?us-ascii?Q?4JQqmoiSjJnOhWTtD2WgRdzPD4+pZ1nJcnHHrH6b3g7Xd02SwtdVyc/OqlrG?=
 =?us-ascii?Q?litgBNUJSw4V4dnUg0fvAFCLxl19RY+HqZhk97vrHUdkD1IdZ4ZyzbZMjQe1?=
 =?us-ascii?Q?EoG3vyjqWOAwUS37exQ7ZZZfjtFEJF1Bf/kTn1WO1b+Aze1dUPJwcAj/mGt7?=
 =?us-ascii?Q?OXeJQ2gN0CJ0Yh9TaJ0i+/KyaKCk+VP3sksv0Kr2m4tQVT7++0wjDg5xBSGP?=
 =?us-ascii?Q?VceVP0PsorOcYpx87weQh3c2EqE+BVN4dF5UeQOC0aLg/GAb7zo6lnTFeVZA?=
 =?us-ascii?Q?RXGvRHAQC+5yu4SIUmpkXThnYj34ukh9xnB7kUxeOI//IRt+rrm7CFZqY1ez?=
 =?us-ascii?Q?C6CcwIWFd98ZHMHi8EPbQPDBC9MIKmlGkhkWzrk8OqrHOPAJo93m9ZRjbcHS?=
 =?us-ascii?Q?p/3wNZR6fYmUTeLRiKlkkcOQ+jurL1FbruO1ERYJj7ppp+1XXFSBPovnwR/2?=
 =?us-ascii?Q?B+vzA6mkPdZZnwGXVI2AnB6UvPApcmykjKMqsMX1T6Gbtg16owg0V6hdr1DV?=
 =?us-ascii?Q?U336DcQpWMS3e3Fbm5oViZNK3FFyA3x36pfC5xm/ephXgBScu7trarxIVhLA?=
 =?us-ascii?Q?HY0Ye1gTDzqBqrJmy+8Sna6sM+UXlVzgtdCl5MYq0Uomub5A/db5IF9PcoVQ?=
 =?us-ascii?Q?RYJBS6h0gPto/u/PMoUb2T+s+2BpKRIdfBTJwySyNo8c4H9eEHuOuwpomD7f?=
 =?us-ascii?Q?854qTIv8ic+9lQw73RNNOvrgzqCdo/n5D22UXeD++XJLs5A7AvVkFJ0vMel0?=
 =?us-ascii?Q?SxB2s/4vvv7v/MzzP6uPs2wO1tg/dCLrraIpkIRUXT35aslD4BiYfiojv4jM?=
 =?us-ascii?Q?r4QASseDkaZc9BS/O7ejrLniSVSBYsezpsr1ESfu78CzpylkGsgkV2qrzuhM?=
 =?us-ascii?Q?SJ2xgtJSs/JHG7NAuwkTuGCv0q3i/3Nat4wJJmTZ/bT6Wv+MJIrwMnYS5Sg2?=
 =?us-ascii?Q?3XSayqGqdSG78zTIdQ6HS6xvwg/CuUQi7GLY52fMcrVXlnQF+xgpQBavUdqj?=
 =?us-ascii?Q?mIPnWE0SGn5cU36xZ2tuVdiriYgZ7TcPIIYyj/JMGInn0ivmilYr9Nc5B2gA?=
 =?us-ascii?Q?d8l1EUPv8QIMei4NHr6+1PI16dnmv3N6Y01HsNiAVNneBTYyQJXFnxQquZiC?=
 =?us-ascii?Q?arz+Yv9VQNDZRDaRr7AhDQ6NIFgvoXd/1G80qhQbKlfF71ddGfpWij2rx1Q8?=
 =?us-ascii?Q?CZoKZ0cDX+4Yd7rTLJWdZO0szwwo4CUzTD3aHvSfVaSf4tUpsQ4qLU9LMjwZ?=
 =?us-ascii?Q?6JRNkg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4d9a1d2-4785-4ca0-a39d-08da86a3e103
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2022 14:12:44.0655
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zcfDRLDB2YBRoTVxgJciGYLIbo16XX3id6FP99AQSij4oM/ThN+BFAfksLj7GDh87iFUKLI5/I6nQa47adPFCFx7aV6OWTT+wJUWe1W6zlo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR13MB5401
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Baowen Zheng <baowen.zheng@corigine.com>

Add support for eeprom get and set operation with ethtool command.
with this change, we can support commands as:

 #ethtool -e enp101s0np0 offset 0 length 6
 Offset          Values
 ------          ------
 0x0000:         00 15 4d 16 66 33

 #ethtool -E enp101s0np0 magic 0x400019ee offset 5 length 1 value 0x88

We make this change to persist MAC change during driver reload and system
reboot.

Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 .../ethernet/netronome/nfp/nfp_net_ethtool.c  | 157 ++++++++++++++++++
 1 file changed, 157 insertions(+)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
index cd2e67185e8c..ac31c79ccd3a 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
@@ -1664,6 +1664,160 @@ static int nfp_net_set_phys_id(struct net_device *netdev,
 	return err;
 }
 
+#define NFP_EEPROM_LEN ETH_ALEN
+
+static int
+nfp_net_get_eeprom_len(struct net_device *netdev)
+{
+	struct nfp_eth_table_port *eth_port;
+	struct nfp_port *port;
+
+	port = nfp_port_from_netdev(netdev);
+	eth_port = __nfp_port_get_eth_port(port);
+	if (!eth_port)
+		return 0;
+
+	return NFP_EEPROM_LEN;
+}
+
+static int
+nfp_net_get_nsp_hwindex(struct net_device *netdev,
+			struct nfp_nsp **nspptr,
+			u32 *index)
+{
+	struct nfp_eth_table_port *eth_port;
+	struct nfp_port *port;
+	struct nfp_nsp *nsp;
+	int err;
+
+	port = nfp_port_from_netdev(netdev);
+	eth_port = __nfp_port_get_eth_port(port);
+	if (!eth_port)
+		return -EOPNOTSUPP;
+
+	nsp = nfp_nsp_open(port->app->cpp);
+	if (IS_ERR(nsp)) {
+		err = PTR_ERR(nsp);
+		netdev_err(netdev, "Failed to access the NSP: %d\n", err);
+		return err;
+	}
+
+	if (!nfp_nsp_has_hwinfo_lookup(nsp)) {
+		netdev_err(netdev, "NSP doesn't support PF MAC generation\n");
+		nfp_nsp_close(nsp);
+		return -EOPNOTSUPP;
+	}
+
+	*nspptr = nsp;
+	*index = eth_port->eth_index;
+
+	return 0;
+}
+
+static int
+nfp_net_get_port_mac_by_hwinfo(struct net_device *netdev,
+			       u8 *mac_addr)
+{
+	char hwinfo[32] = {};
+	struct nfp_nsp *nsp;
+	u32 index;
+	int err;
+
+	err = nfp_net_get_nsp_hwindex(netdev, &nsp, &index);
+	if (err)
+		return err;
+
+	snprintf(hwinfo, sizeof(hwinfo), "eth%u.mac", index);
+	err = nfp_nsp_hwinfo_lookup(nsp, hwinfo, sizeof(hwinfo));
+	nfp_nsp_close(nsp);
+	if (err) {
+		netdev_err(netdev, "Reading persistent MAC address failed: %d\n",
+			   err);
+		return -EOPNOTSUPP;
+	}
+
+	if (sscanf(hwinfo, "%02hhx:%02hhx:%02hhx:%02hhx:%02hhx:%02hhx",
+		   &mac_addr[0], &mac_addr[1], &mac_addr[2],
+		   &mac_addr[3], &mac_addr[4], &mac_addr[5]) != 6) {
+		netdev_err(netdev, "Can't parse persistent MAC address (%s)\n",
+			   hwinfo);
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
+static int
+nfp_net_set_port_mac_by_hwinfo(struct net_device *netdev,
+			       u8 *mac_addr)
+{
+	char hwinfo[32] = {};
+	struct nfp_nsp *nsp;
+	u32 index;
+	int err;
+
+	err = nfp_net_get_nsp_hwindex(netdev, &nsp, &index);
+	if (err)
+		return err;
+
+	snprintf(hwinfo, sizeof(hwinfo),
+		 "eth%u.mac=%02hhx:%02hhx:%02hhx:%02hhx:%02hhx:%02hhx",
+		 index, mac_addr[0], mac_addr[1], mac_addr[2], mac_addr[3],
+		 mac_addr[4], mac_addr[5]);
+
+	err = nfp_nsp_hwinfo_set(nsp, hwinfo, sizeof(hwinfo));
+	nfp_nsp_close(nsp);
+	if (err) {
+		netdev_err(netdev, "HWinfo set failed: %d, hwinfo: %s\n",
+			   err, hwinfo);
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
+static int
+nfp_net_get_eeprom(struct net_device *netdev,
+		   struct ethtool_eeprom *eeprom, u8 *bytes)
+{
+	struct nfp_net *nn = netdev_priv(netdev);
+	u8 buf[NFP_EEPROM_LEN] = {};
+
+	if (eeprom->len == 0)
+		return -EINVAL;
+
+	if (nfp_net_get_port_mac_by_hwinfo(netdev, buf))
+		return -EOPNOTSUPP;
+
+	eeprom->magic = nn->pdev->vendor | (nn->pdev->device << 16);
+	memcpy(bytes, buf + eeprom->offset, eeprom->len);
+
+	return 0;
+}
+
+static int
+nfp_net_set_eeprom(struct net_device *netdev,
+		   struct ethtool_eeprom *eeprom, u8 *bytes)
+{
+	struct nfp_net *nn = netdev_priv(netdev);
+	u8 buf[NFP_EEPROM_LEN] = {};
+
+	if (eeprom->len == 0)
+		return -EINVAL;
+
+	if (eeprom->magic != (nn->pdev->vendor | nn->pdev->device << 16))
+		return -EINVAL;
+
+	if (nfp_net_get_port_mac_by_hwinfo(netdev, buf))
+		return -EOPNOTSUPP;
+
+	memcpy(buf + eeprom->offset, bytes, eeprom->len);
+	if (nfp_net_set_port_mac_by_hwinfo(netdev, buf))
+		return -EOPNOTSUPP;
+
+	return 0;
+}
+
 static const struct ethtool_ops nfp_net_ethtool_ops = {
 	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
 				     ETHTOOL_COALESCE_MAX_FRAMES |
@@ -1687,6 +1841,9 @@ static const struct ethtool_ops nfp_net_ethtool_ops = {
 	.set_dump		= nfp_app_set_dump,
 	.get_dump_flag		= nfp_app_get_dump_flag,
 	.get_dump_data		= nfp_app_get_dump_data,
+	.get_eeprom_len         = nfp_net_get_eeprom_len,
+	.get_eeprom             = nfp_net_get_eeprom,
+	.set_eeprom             = nfp_net_set_eeprom,
 	.get_module_info	= nfp_port_get_module_info,
 	.get_module_eeprom	= nfp_port_get_module_eeprom,
 	.get_coalesce           = nfp_net_get_coalesce,
-- 
2.30.2

