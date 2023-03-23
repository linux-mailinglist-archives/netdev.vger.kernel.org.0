Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EE146C6645
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 12:14:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231544AbjCWLOF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 07:14:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231389AbjCWLOC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 07:14:02 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2057.outbound.protection.outlook.com [40.107.94.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18B762ED48
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 04:13:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eIeXGKF+Y8n5DDZk3mlFkLiWcnTCcef4ScQ65i9206WFZlI2SwAxocBKrWSZf+xgeoAWKX6oOqYO0/mfpAF5yyVTQZ19inPp4AaaktmfY0Xb1cEMoJrUD+MBUuBUxL9jH6HiwICoKZySjpBJZBk6JLXpQyVQb4OHCHsMZiYXQNQkM66ZCWjnnP+txbfqayH5MNgvxqHF/czH6QCQB/Xnu/KPTwRfTPYkud/H+nEj18EUEivpbJNK5FypGLH2fTuP0vSm6yuFAeihUYs9rD9dzwrVRyxmZi1HrtAyWzpWQPrPIrd1XRIXohLdF/ohBl3+t1+w3Wtkuu1kmus1DmRrWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9CF3Hv7S99pAA9CYNR8swnOvEedUXq2xY33UrwuBZQQ=;
 b=TsISflEWVB+dxH6jZay4YHgnJa+m+essU6nhG4BPtidZnxstf3zTHGg9+Jd7UuYaAD7OByQEAFCfc4j3RusyKm5UQfX9IaNkB+VfbrY6TnCglm7OXbcYhQMCLpf0Cioyehz3ZqLM+crubdyPp61tFOtJqqsp55caDKzz+7W92rAgazeQacZa/LJiCGn+gMMqBxbiYreCNBKB4sxlZ4MjkwWrSBdR/Z9eZb9eCuCJhEIhr9lTOuQY68pj+dI3ltVj4FQ8G0oh9MISJBQL0Fsyw4ZsSauujmrWjR+Y6t+eWZjKRTtIRQvZ91z9+jh0QPiNNmW76KdpVAiyy8VBGulG9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9CF3Hv7S99pAA9CYNR8swnOvEedUXq2xY33UrwuBZQQ=;
 b=HGj5H4c4nyAppn4WXSP46ljvy08QYjYosagLZMUJNzBluv8SyvWfJ+XvPxYCkGP0Hpdgwuu6HcHb6x/txxHFl/E1AUzbVdIkfj2BaSZnHUOxGCjRW1i61PPZIldoA2V8ddrKWcwre6oMbUK/AkF/E0WXHNdEbaH6M3JkI7aMixKEdOC0S3k5AbM5pMP4TZlvS6xADA0CXmtwvsRbbBqRKfc+BtaVxuLalGzF0snhmYy9oR4nY1/A3IX6nhNZc9vHDJyrz2REFXNIZLVjBIdnJVsB4Kn3sOpKKdBHzuz6Ste3D0lkiMyVGVBZI5LyvUczxiY5Y3XIkhoJNvHGiHA0Mw==
Received: from DS7PR03CA0262.namprd03.prod.outlook.com (2603:10b6:5:3b3::27)
 by SJ2PR12MB8063.namprd12.prod.outlook.com (2603:10b6:a03:4d1::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38; Thu, 23 Mar
 2023 11:13:38 +0000
Received: from DM6NAM11FT021.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b3:cafe::e7) by DS7PR03CA0262.outlook.office365.com
 (2603:10b6:5:3b3::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38 via Frontend
 Transport; Thu, 23 Mar 2023 11:13:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 DM6NAM11FT021.mail.protection.outlook.com (10.13.173.76) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6222.17 via Frontend Transport; Thu, 23 Mar 2023 11:13:37 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Thu, 23 Mar 2023
 04:13:36 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Thu, 23 Mar 2023 04:13:36 -0700
Received: from vdi.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.5 via Frontend
 Transport; Thu, 23 Mar 2023 04:13:34 -0700
From:   Dima Chumak <dchumak@nvidia.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@kernel.org>
CC:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "Jiri Pirko" <jiri@nvidia.com>, <netdev@vger.kernel.org>,
        Dima Chumak <dchumak@nvidia.com>
Subject: [PATCH iproute2-next 2/3] devlink: Support setting port function ipsec_crypto cap
Date:   Thu, 23 Mar 2023 13:13:12 +0200
Message-ID: <20230323111313.211866-2-dchumak@nvidia.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230323111059.210634-1-dchumak@nvidia.com>
References: <20230323111059.210634-1-dchumak@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT021:EE_|SJ2PR12MB8063:EE_
X-MS-Office365-Filtering-Correlation-Id: 702f860c-72b5-4782-242e-08db2b8fa694
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qNMgWfESUoYw9TULZJocgoHAAbcTuSolt7iZTN1N7FBL1lJw2cq7iVG+9pzjkATm+1w8PHoCGkblvBNtl+qXNmpj+iz00Co0JwP1cENg/XSa9MlaL3biFCgHhE45ER5zC+MWXtGOneCxl+L4BBAxg3fLtYSInp2SNI8L1HlqTfbqN5YJ3oO9mA+u6a8P4UiN/PZ5hXcLCCTNXVP+R0EYzdt9tN0RtlWAOIw0c6b3sotTB3ctIfSFfE9XhF4nFL1WgnRfEC8dGPt1gy3YQiWyMP3L6/uQxLwGWugVWTBA3/BYABD+UN24qyTrmsJsCJGY/Hk3ixezzuW7fTpiiLJdM1akm4EXHfD19/xsd9eqOjKNyHUwWejzQ8DlYIZtZGP76w+Py+4Uwp5qy9mMvXIHl1ZOklMD57HTsd9abgpBXOD5aez9l+arsbE7mzs+NqWf2H7DVQcxv+J0zagKMLjvJaXP9aJPHJbkfMuzr3pW31a72Q9umT+Ei+Cgk0Fo88wz9XE0furyq8qGg47xT6zIU0DdzdlMi8/mUjz4NB4nDtNVxkAKiPRIhykkYTraEW9lUsuOt8ScSK6K5BJVg5S1kdOBA8oWwVNimLbLg7rvWciV/hujEpMqzkYTUK8O69BHunzF4salvSZoz0R1iyhzEDrd1y9qLS0/FTgjQGAOVTtc//c+wERCagV6ttb1RDOo1OGoqVfZunqHhBVy7OK9iDYsKagxxKygDH0u3TWlL1LF1WqLQORD3sYpPY74U9WP
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(136003)(346002)(396003)(376002)(39860400002)(451199018)(46966006)(40470700004)(36840700001)(41300700001)(4326008)(8676002)(5660300002)(40460700003)(2906002)(82740400003)(356005)(36860700001)(7636003)(36756003)(86362001)(107886003)(7696005)(26005)(6666004)(1076003)(8936002)(110136005)(478600001)(70586007)(316002)(40480700001)(82310400005)(54906003)(47076005)(426003)(70206006)(336012)(83380400001)(2616005)(186003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2023 11:13:37.6538
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 702f860c-72b5-4782-242e-08db2b8fa694
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT021.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8063
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support port function commands to enable / disable IPsec crypto
offloads, this is used to control the port IPsec device capabilities.

When IPsec capability is disabled for a function of the port (default),
function cannot offload any IPsec operations. When enabled, IPsec
operations can be offloaded by the function of the port.

Enabling IPsec crypto offloads lets the kernel to delegate
encrypt/decrypt operations to the device hardware.

Example of a PCI VF port which supports IPsec crypto offloads:

$ devlink port show pci/0000:06:00.0/1
    pci/0000:06:00.0/1: type eth netdev enp6s0pf0vf0 flavour pcivf pfnum 0 vfnum 0
	function:
	hw_addr 00:00:00:00:00:00 roce enable ipsec_crypto disable

$ devlink port function set pci/0000:06:00.0/1 ipsec_crypto enable

$ devlink port show pci/0000:06:00.0/1
    pci/0000:06:00.0/1: type eth netdev enp6s0pf0vf0 flavour pcivf pfnum 0 vfnum 0
	function:
	hw_addr 00:00:00:00:00:00 roce enable ipsec_crypto enable

Signed-off-by: Dima Chumak <dchumak@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 devlink/devlink.c       | 18 ++++++++++++++++++
 man/man8/devlink-port.8 | 12 ++++++++++++
 2 files changed, 30 insertions(+)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 795f8318c0c4..90ee4d1b7b6f 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -2258,6 +2258,18 @@ static int dl_argv_parse(struct dl *dl, uint64_t o_required,
 			if (mig)
 				opts->port_fn_caps.value |= DEVLINK_PORT_FN_CAP_MIGRATABLE;
 			o_found |= DL_OPT_PORT_FN_CAPS;
+		} else if (dl_argv_match(dl, "ipsec_crypto") &&
+			   (o_all & DL_OPT_PORT_FN_CAPS)) {
+			bool ipsec_crypto;
+
+			dl_arg_inc(dl);
+			err = dl_argv_bool(dl, &ipsec_crypto);
+			if (err)
+				return err;
+			opts->port_fn_caps.selector |= DEVLINK_PORT_FN_CAP_IPSEC_CRYPTO;
+			if (ipsec_crypto)
+				opts->port_fn_caps.value |= DEVLINK_PORT_FN_CAP_IPSEC_CRYPTO;
+			o_found |= DL_OPT_PORT_FN_CAPS;
 		} else {
 			pr_err("Unknown option \"%s\"\n", dl_argv(dl));
 			return -EINVAL;
@@ -4536,6 +4548,7 @@ static void cmd_port_help(void)
 	pr_err("       devlink port unsplit DEV/PORT_INDEX\n");
 	pr_err("       devlink port function set DEV/PORT_INDEX [ hw_addr ADDR ] [ state { active | inactive } ]\n");
 	pr_err("                      [ roce { enable | disable } ] [ migratable { enable | disable } ]\n");
+	pr_err("                      [ ipsec_crypto { enable | disable } ]\n");
 	pr_err("       devlink port function rate { help | show | add | del | set }\n");
 	pr_err("       devlink port param set DEV/PORT_INDEX name PARAMETER value VALUE cmode { permanent | driverinit | runtime }\n");
 	pr_err("       devlink port param show [DEV/PORT_INDEX name PARAMETER]\n");
@@ -4661,6 +4674,10 @@ static void pr_out_port_function(struct dl *dl, struct nlattr **tb_port)
 			print_string(PRINT_ANY, "migratable", " migratable %s",
 				     port_fn_caps->value & DEVLINK_PORT_FN_CAP_MIGRATABLE ?
 				     "enable" : "disable");
+		if (port_fn_caps->selector & DEVLINK_PORT_FN_CAP_IPSEC_CRYPTO)
+			print_string(PRINT_ANY, "ipsec_crypto", " ipsec_crypto %s",
+				     port_fn_caps->value & DEVLINK_PORT_FN_CAP_IPSEC_CRYPTO ?
+				     "enable" : "disable");
 	}
 
 	if (!dl->json_output)
@@ -4857,6 +4874,7 @@ static void cmd_port_function_help(void)
 {
 	pr_err("Usage: devlink port function set DEV/PORT_INDEX [ hw_addr ADDR ] [ state STATE ]\n");
 	pr_err("                      [ roce { enable | disable } ] [ migratable { enable | disable } ]\n");
+	pr_err("                      [ ipsec_crypto { enable | disable } ]\n");
 	pr_err("       devlink port function rate { help | show | add | del | set }\n");
 }
 
diff --git a/man/man8/devlink-port.8 b/man/man8/devlink-port.8
index 56049f7349a8..a51d19e6abdd 100644
--- a/man/man8/devlink-port.8
+++ b/man/man8/devlink-port.8
@@ -77,6 +77,9 @@ devlink-port \- devlink port configuration
 .RI "[ "
 .BR migratable " { " enable " | " disable " }"
 .RI "]"
+.RI "[ "
+.BR ipsec_crypto " { " enable " | " disable " }"
+.RI "]"
 
 .ti -8
 .BR "devlink port function rate "
@@ -222,6 +225,10 @@ Set the RoCE capability of the function.
 .BR migratable " { " enable " | " disable  " } "
 Set the migratable capability of the function.
 
+.TP
+.BR ipsec_crypto " { " enable " | " disable  " } "
+Set the IPsec crypto offload capability of the function.
+
 .ti -8
 .SS devlink port del - delete a devlink port
 .PP
@@ -351,6 +358,11 @@ devlink port function set pci/0000:01:00.0/1 migratable enable
 This will enable the migratable functionality of the function.
 .RE
 .PP
+devlink port function set pci/0000:01:00.0/1 ipsec_crypto enable
+.RS 4
+This will enable the IPsec crypto offload functionality of the function.
+.RE
+.PP
 devlink port function set pci/0000:01:00.0/1 hw_addr 00:00:00:11:22:33 state active
 .RS 4
 Configure hardware address and also active the function. When a function is
-- 
2.40.0

