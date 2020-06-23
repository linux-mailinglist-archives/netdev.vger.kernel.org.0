Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58345204F74
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 12:45:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732335AbgFWKpD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 06:45:03 -0400
Received: from mail-vi1eur05on2083.outbound.protection.outlook.com ([40.107.21.83]:29070
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732135AbgFWKpA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 06:45:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UZ/EiwQwIBwnyBiicy4MDPL+bXBkq+3ogq7sLzRQNglaTOD3V+DG0lj8ec6PKUD8IRo94k7tjJrRR84IZ1oO3CtE8z1/8atAxxrjDhg+kpPEXdBRMBeG3JsfR+k7HG+62qfMkpobwwOgKIZ0BdcfMKL8BdeHebpYXaB3gpY+HAnQGHyrBOKKJyY163KtjNwL/z9IzSr/S2Hr3CTOY9SkOlKam4Hf+ZZHIPaU64mDc4Z2Fuh0rqBoDArZ6w/7n9D+BtDIB2Y+gg4mlLLhizIB3bSCWhODlxSLp/rhSCLdIsesqm3Qcr34FI6Wy7jGsOalTsD8VJexB9eBU9US+RGiPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4N/SsK8/X40XYxNWlnkZM+qVBhy3YIHrAP39wIgOhdg=;
 b=VA7J61GuyWIvsu6dGueleCn42h4CBzgU+sCCrqxnloySDSFiokhyoFFYrcU9/qybCaQoML+MQkHVDWgcogCMeXmPiPcdg9HZJxz0OXCRDMjwjy9ObDu9X98yTaan5QTNBVT8wxXul5zwUZUHqvGixN13nGXmPjIpYWBc1RQYszarXUqRaPO7+HcjtbfuP6yYLjheJUxH+tA1pDejZxIw90RrLz6KhQLEO2cz5MI6F2CtprjGMXh62Ia/4advolH0f2bFieuRuxRAYw2sIhyWc7n2nvH2FuDQ3LXEkpsbegWpb0kV64wDHchxbIHwTzR+jxlfLlw1pjY4dl13B5XRjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4N/SsK8/X40XYxNWlnkZM+qVBhy3YIHrAP39wIgOhdg=;
 b=LBzxQYhH1vC9xL+VwZ+zN7YfDDKkn1m3Q90t7AnDjQ9uetjRY11KI41gVhW8s+m1mldkD4Psmkx00+w9urkbZejj/z29nss6dc8+XhNm6shffSXh3cp9KkkT5NwnckuIg5qJpTT2nU9RbVilTnIc3u/zZ1zr1jPxraBRqGlWFsY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (2603:10a6:208:c0::32)
 by AM0PR05MB6401.eurprd05.prod.outlook.com (2603:10a6:208:13e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Tue, 23 Jun
 2020 10:44:55 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::d44d:a804:c730:d2b7]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::d44d:a804:c730:d2b7%2]) with mapi id 15.20.3109.027; Tue, 23 Jun 2020
 10:44:55 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, jiri@mellanox.com, dsahern@kernel.org,
        Parav Pandit <parav@mellanox.com>
Subject: [PATCH iproute2-next 3/4] devlink: Support querying hardware address of port function
Date:   Tue, 23 Jun 2020 10:44:24 +0000
Message-Id: <20200623104425.2324-4-parav@mellanox.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200623104425.2324-1-parav@mellanox.com>
References: <20200623104425.2324-1-parav@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0201CA0035.namprd02.prod.outlook.com
 (2603:10b6:803:2e::21) To AM0PR05MB4866.eurprd05.prod.outlook.com
 (2603:10a6:208:c0::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sw-mtx-036.mtx.labs.mlnx (208.176.44.194) by SN4PR0201CA0035.namprd02.prod.outlook.com (2603:10b6:803:2e::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22 via Frontend Transport; Tue, 23 Jun 2020 10:44:54 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [208.176.44.194]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: cb3d3449-c628-4bd0-b5f4-08d8176277bd
X-MS-TrafficTypeDiagnostic: AM0PR05MB6401:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR05MB6401BC0525A6E10ED2A8AFBAD1940@AM0PR05MB6401.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1079;
X-Forefront-PRVS: 04433051BF
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SKvC3nbNuCPdd9ozKV3Ck93Wyw37LmcFkc84SB/2dO1PFLk+EBtd64s+85Nybyk9cPYbH0gI9xKQuRkPt9NG/tpOBRBLVjk8+OlnD27tMnCQ0MIZJB1IGvZ/b7cV4rs+8kn6MeckFfNL6QRzOq4E4uL38jjRFCO3gAhblClFb9C1bFcIrfKzyW8Ni9sxc03lvcmArFBN6NO3fpMMZtgNL88BQjUxja6kmrrwrMHVWnxopbNGFTbzOGs5Eeq3wiXU2JzxA6iLUUzV0qKV2+nUEaE71uN5AvEdeQrI6cHfCAbwmVRuJAnYTZw8+Sv1mIpVq6baV9kzvVTo3R0F/cYU8A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB4866.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(396003)(39860400002)(366004)(136003)(346002)(6506007)(26005)(16526019)(316002)(52116002)(478600001)(186003)(8936002)(2616005)(1076003)(2906002)(5660300002)(66556008)(6916009)(66946007)(66476007)(6512007)(8676002)(36756003)(4326008)(86362001)(107886003)(83380400001)(956004)(6486002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: fPNZeGGWXrTIPfFYHG8+ARfAvHocZakTQAlE2243Ja4YaE3WxkKekPcwLxLP5hUXYcLwX+4/jtdNHWK4Bom+D1i4kMkOAim3QuEMAKQnfN20u4of27z1Wnz52Fy3rpN2xoI3xok2I2p8hGSOD+qKL07MYRaxJ5JknigvyIb9zdCM9hZP3rBBMG3b0EoV7qk8BbCQLy6shooX61Gu64tehKjVLxrAT6uiQIePBXpUpwQ0dpYCOxk/3BrDSd1Gf3RJz3rIHLmjnQvxAqIY+2sZBds5YGfAZJVovHk4vlONTF3prTkcKS0TTvw4BU0ZQQffjXx3RX8uC31Vgs0AXG+IsUy2tdrBvQz99XwFMd3LvZgi23fccHX7OKv3Ke2U5LhGid0v+zpib171wiiBlqMcsOLsttSBv9KH0Enla4F06e8+crlFGhmYYsB5TOi14cEfV32GMrFly4/RJgLz8emBhnM55r8j/lNLx5dlcRjDMP9nAHg/wySCE3xtAc2BK+sr
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb3d3449-c628-4bd0-b5f4-08d8176277bd
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2020 10:44:55.7579
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gPnLk0iYE+35bVZyIsZ1opGUOIfZ/Wmd0yvZxrQF8bu/TmjY5XIqYw6MGZK0bRiLWuDWYHEotDTRJO7Ez72+Vg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6401
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support to query the hardware address of function represented
by devlink port function.

Example of a PCI VF port which supports a port function:
$ devlink port show pci/0000:06:00.0/2
pci/0000:06:00.0/2: type eth netdev enp6s0pf0vf1 flavour pcivf pfnum 0 vfnum 1
  function:
    hw_addr 00:11:22:33:44:66

$ devlink port show pci/0000:06:00.0/2 -jp
{
    "port": {
        "pci/0000:06:00.0/2": {
            "type": "eth",
            "netdev": "enp6s0pf0vf1",
            "flavour": "pcivf",
            "pfnum": 0,
            "vfnum": 1,
            "function": {
                "hw_addr": "00:11:22:33:44:66"
            }
        }
    }
}

Signed-off-by: Parav Pandit <parav@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 devlink/devlink.c | 57 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 57 insertions(+)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index b7699f30..16fc834e 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -26,6 +26,7 @@
 #include <libmnl/libmnl.h>
 #include <netinet/ether.h>
 #include <sys/types.h>
+#include <rt_names.h>
 
 #include "SNAPSHOT.h"
 #include "list.h"
@@ -708,6 +709,30 @@ static int attr_stats_cb(const struct nlattr *attr, void *data)
 	return MNL_CB_OK;
 }
 
+static const enum mnl_attr_data_type
+devlink_function_policy[DEVLINK_PORT_FUNCTION_ATTR_MAX + 1] = {
+	[DEVLINK_PORT_FUNCTION_ATTR_HW_ADDR ] = MNL_TYPE_BINARY,
+};
+
+static int function_attr_cb(const struct nlattr *attr, void *data)
+{
+	const struct nlattr **tb = data;
+	int type;
+
+	/* Allow the tool to work on top of newer kernels that might contain
+	 * more attributes.
+	 */
+	if (mnl_attr_type_valid(attr, DEVLINK_PORT_FUNCTION_ATTR_MAX) < 0)
+		return MNL_CB_OK;
+
+	type = mnl_attr_get_type(attr);
+	if (mnl_attr_validate(attr, devlink_function_policy[type]) < 0)
+		return MNL_CB_ERROR;
+
+	tb[type] = attr;
+	return MNL_CB_OK;
+}
+
 static int ifname_map_cb(const struct nlmsghdr *nlh, void *data)
 {
 	struct nlattr *tb[DEVLINK_ATTR_MAX + 1] = {};
@@ -3243,6 +3268,37 @@ static void pr_out_port_pfvf_num(struct dl *dl, struct nlattr **tb)
 	}
 }
 
+static void pr_out_port_function(struct dl *dl, struct nlattr **tb_port)
+{
+	struct nlattr *tb[DEVLINK_PORT_FUNCTION_ATTR_MAX + 1] = {};
+	unsigned char *data;
+	SPRINT_BUF(hw_addr);
+	uint32_t len;
+	int err;
+
+	if (!tb_port[DEVLINK_ATTR_PORT_FUNCTION])
+		return;
+
+	err = mnl_attr_parse_nested(tb_port[DEVLINK_ATTR_PORT_FUNCTION],
+				    function_attr_cb, tb);
+	if (err != MNL_CB_OK)
+		return;
+
+	if (!tb[DEVLINK_PORT_FUNCTION_ATTR_HW_ADDR])
+		return;
+
+	len = mnl_attr_get_payload_len(tb[DEVLINK_PORT_FUNCTION_ATTR_HW_ADDR]);
+	data = mnl_attr_get_payload(tb[DEVLINK_PORT_FUNCTION_ATTR_HW_ADDR]);
+
+	pr_out_object_start(dl, "function");
+	check_indent_newline(dl);
+	print_string(PRINT_ANY, "hw_addr", "hw_addr %s",
+		     ll_addr_n2a(data, len, 0, hw_addr, sizeof(hw_addr)));
+	if (!dl->json_output)
+		__pr_out_indent_dec();
+	pr_out_object_end(dl);
+}
+
 static void pr_out_port(struct dl *dl, struct nlattr **tb)
 {
 	struct nlattr *pt_attr = tb[DEVLINK_ATTR_PORT_TYPE];
@@ -3296,6 +3352,7 @@ static void pr_out_port(struct dl *dl, struct nlattr **tb)
 	if (tb[DEVLINK_ATTR_PORT_SPLIT_GROUP])
 		print_uint(PRINT_ANY, "split_group", " split_group %u",
 			   mnl_attr_get_u32(tb[DEVLINK_ATTR_PORT_SPLIT_GROUP]));
+	pr_out_port_function(dl, tb);
 	pr_out_port_handle_end(dl);
 }
 
-- 
2.25.4

