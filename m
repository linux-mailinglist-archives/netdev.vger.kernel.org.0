Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B6C66C6647
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 12:14:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231145AbjCWLOQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 07:14:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231605AbjCWLOH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 07:14:07 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5FB72DE63
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 04:13:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gug+rxsUuY/FRBFIln5u0O6gUzs6s1/h27kvQ9f+qjFlI9l29CUnDcMUk1XXiyFf4a2axghyXzwlg7fDXcy9Qhyn+z2rtcikTdVN8Qs20xZNLKWKop41HruYIe0HvbaW+BL7wOVLRhs1UrOjusG7sT49YuCnaKJ3nnQqBBlstvRvXke3cAvgicaeEJGool0ysGv9/fu8JOtFlB3YKYEx3lqBhbkpSp1HCA6y/rVfdGSeAQUIFmerW8hnr/gWs8iEFYddQgT4JIkvccNXHjStRAcbfloPXXNhQI0Ya46ai0VEgungpjjRspJgXDgEfNAIHJjxr4vOJo0aFnMIv/wHww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XNMfsv5ixeS1I/QrjlzAWD4/izgYAS4TbrjtT1DOJ78=;
 b=mFssNr6d0q+eimcPuYteOzQknApeD3iOqveC15M3ojkMhf6FI0hW1UEtervF87hAfF+F2tG5KaRTBQOfoBI22ClaenTwY9lzZSfzb55lXjhWrmOdOJuji3eCC0cYsiT6fqcreA+1GZuvAD9+35ixGdoqKarC5zxdZhnF2ezIvbtJfFaaAY8MfKYo7xc313+DfQfm11VUIsJelivLNeyjsTS8D1VOuTiKWPJOA5wXWSQWpyO6EGwahuI7PPQFUTMG3qLscaHWnjNnu53CR2LnbJl4XgvJq4TaOHGcGlp7X9T2oocLA/d2GkbtRR3OHObj5MAlr1qQUhc/2eQw9QPHzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XNMfsv5ixeS1I/QrjlzAWD4/izgYAS4TbrjtT1DOJ78=;
 b=gWec6zLFhJNUC8GobyUVpfNTnERWKxO0rHR3Q664FFcOnCuHLxyRXlmQ2Gut9MgQdWYZqIe4rj3s4sliCGOvlBd1WvOiqh+sSfCgguys3tKLriMiDUjfrshOuSMbUlX6Sjptdbsg9LcwSwJRZ8eBy6qYxWJW3a37WenWmU4bZikQyhZ1vqSzZckRsiev+fZvoWXDH4am0vzay0tdBTJgOLhjHD/96b06jkRPUByZgN0CWEnn5O3HlPVK7oIKIzWeneEA0Fede4VFmzYoBPfoT2iuZ8+zWZk0wut05EvYi5rkbfFQlzf7BI8RFp1eVUJgxFso+6GfnAqZGuquWA8l9w==
Received: from MW4PR03CA0347.namprd03.prod.outlook.com (2603:10b6:303:dc::22)
 by CH2PR12MB5017.namprd12.prod.outlook.com (2603:10b6:610:36::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Thu, 23 Mar
 2023 11:13:41 +0000
Received: from CO1NAM11FT016.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:dc:cafe::6c) by MW4PR03CA0347.outlook.office365.com
 (2603:10b6:303:dc::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37 via Frontend
 Transport; Thu, 23 Mar 2023 11:13:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CO1NAM11FT016.mail.protection.outlook.com (10.13.175.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6222.17 via Frontend Transport; Thu, 23 Mar 2023 11:13:41 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Thu, 23 Mar 2023
 04:13:39 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Thu, 23 Mar 2023 04:13:39 -0700
Received: from vdi.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.5 via Frontend
 Transport; Thu, 23 Mar 2023 04:13:36 -0700
From:   Dima Chumak <dchumak@nvidia.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@kernel.org>
CC:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "Jiri Pirko" <jiri@nvidia.com>, <netdev@vger.kernel.org>,
        Dima Chumak <dchumak@nvidia.com>
Subject: [PATCH iproute2-next 3/3] devlink: Support setting port function ipsec_packet cap
Date:   Thu, 23 Mar 2023 13:13:13 +0200
Message-ID: <20230323111313.211866-3-dchumak@nvidia.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230323111059.210634-1-dchumak@nvidia.com>
References: <20230323111059.210634-1-dchumak@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT016:EE_|CH2PR12MB5017:EE_
X-MS-Office365-Filtering-Correlation-Id: 473e9394-8122-4133-7f31-08db2b8fa8c0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1FLv7xw6tw4ORlSLMVNfOszN1LVXkyDOflmrR5yEvO89wTTBrRpudElr3BB5aEaqTFOaOlFOe7GrVd87j7BHST7aia7RqHlu+0XRsvf6TkcZDUq+JnWQKHgbvw2x+WGBJlkro6TdMEt8Wp9vNOqPW97K8y6TH9SRSLg8yVctYWMYQhH03TRzKH42NUd9KSNojdxV6uATvGRE51qnButeVsTSjlP6RoLm73Gqz1Xx9z+K4oc7ri0A7nP6W0rxnAV94bvhxxUkPentzRb/mek/oTaQ3PvgJxqwDacYDPYBLx9ioFHSLC/KljPxPc9IpT3HRJ2oXVd/rBV4ofkGVIAHiE163gWHJ0uIdQ57/AaQaX2S+JK3NpLB7dVV5+H2tv4MlSRnJqQxeRTRvwzQ+26j52D+DJFslUAWXIeYWNlJPjr3OL4djb8RXih1kMGwrV4cXz9S5dwZMg8F3xOmrtwELXFN4rJ12JL0YdPliWrYCYSUiMNEW3pQaN0wlzVfc+/QF8dsjJh+W2cTHC6i+svzQvtTyAdi7Q8MJyYt+SL+7cBqwh4kbHK47hGloiUXINNhKc4p7RZe5u7amODBKreREsEz9eSZuUZBNemOY9ug36Dkp3zFYW02wPRWn8kScMcIXI/25VW8AX5rwRM7F3s62Q3SQ7hdhVgibhXM1blhqKL33jJyKPa5UWf5LKorO3YPKQbtZ4XF2MBth6f0Mt4WANeH+GI/FPvS3c8r7kYz25iyJnbMwQ2z56IsdQMjrQ7E
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(39860400002)(396003)(136003)(451199018)(46966006)(40470700004)(36840700001)(336012)(107886003)(26005)(1076003)(47076005)(6666004)(426003)(8676002)(70206006)(316002)(4326008)(7696005)(110136005)(2616005)(54906003)(70586007)(40480700001)(478600001)(8936002)(2906002)(41300700001)(36860700001)(5660300002)(7636003)(82740400003)(356005)(83380400001)(186003)(86362001)(82310400005)(36756003)(40460700003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2023 11:13:41.3468
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 473e9394-8122-4133-7f31-08db2b8fa8c0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT016.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB5017
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support port function commands to enable / disable IPsec packet
offloads, this is used to control the port IPsec device capabilities.

When IPsec capability is disabled for a function of the port (default),
function cannot offload any IPsec operations. When enabled, IPsec
operations can be offloaded by the function of the port.

Enabling IPsec packet offloads lets the kernel to delegate
encrypt/decrypt operations, as well as encapsulation and SA/policy
states to the device hardware.

Example of a PCI VF port which supports IPsec packet offloads:

$ devlink port show pci/0000:06:00.0/1
    pci/0000:06:00.0/1: type eth netdev enp6s0pf0vf0 flavour pcivf pfnum 0 vfnum 0
	function:
	hw_addr 00:00:00:00:00:00 roce enable ipsec_crypto disable ipsec_packet disable

$ devlink port function set pci/0000:06:00.0/1 ipsec_packet enable

$ devlink port show pci/0000:06:00.0/1
    pci/0000:06:00.0/1: type eth netdev enp6s0pf0vf0 flavour pcivf pfnum 0 vfnum 0
	function:
	hw_addr 00:00:00:00:00:00 roce enable ipsec_crypto disable ipsec_packet enable

Signed-off-by: Dima Chumak <dchumak@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 devlink/devlink.c       | 20 ++++++++++++++++++--
 man/man8/devlink-port.8 | 12 ++++++++++++
 2 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 90ee4d1b7b6f..a422ffe58f3b 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -2270,6 +2270,18 @@ static int dl_argv_parse(struct dl *dl, uint64_t o_required,
 			if (ipsec_crypto)
 				opts->port_fn_caps.value |= DEVLINK_PORT_FN_CAP_IPSEC_CRYPTO;
 			o_found |= DL_OPT_PORT_FN_CAPS;
+		} else if (dl_argv_match(dl, "ipsec_packet") &&
+			   (o_all & DL_OPT_PORT_FN_CAPS)) {
+			bool ipsec_packet;
+
+			dl_arg_inc(dl);
+			err = dl_argv_bool(dl, &ipsec_packet);
+			if (err)
+				return err;
+			opts->port_fn_caps.selector |= DEVLINK_PORT_FN_CAP_IPSEC_PACKET;
+			if (ipsec_packet)
+				opts->port_fn_caps.value |= DEVLINK_PORT_FN_CAP_IPSEC_PACKET;
+			o_found |= DL_OPT_PORT_FN_CAPS;
 		} else {
 			pr_err("Unknown option \"%s\"\n", dl_argv(dl));
 			return -EINVAL;
@@ -4548,7 +4560,7 @@ static void cmd_port_help(void)
 	pr_err("       devlink port unsplit DEV/PORT_INDEX\n");
 	pr_err("       devlink port function set DEV/PORT_INDEX [ hw_addr ADDR ] [ state { active | inactive } ]\n");
 	pr_err("                      [ roce { enable | disable } ] [ migratable { enable | disable } ]\n");
-	pr_err("                      [ ipsec_crypto { enable | disable } ]\n");
+	pr_err("                      [ ipsec_crypto { enable | disable } ] [ ipsec_packet { enable | disable } ]\n");
 	pr_err("       devlink port function rate { help | show | add | del | set }\n");
 	pr_err("       devlink port param set DEV/PORT_INDEX name PARAMETER value VALUE cmode { permanent | driverinit | runtime }\n");
 	pr_err("       devlink port param show [DEV/PORT_INDEX name PARAMETER]\n");
@@ -4678,6 +4690,10 @@ static void pr_out_port_function(struct dl *dl, struct nlattr **tb_port)
 			print_string(PRINT_ANY, "ipsec_crypto", " ipsec_crypto %s",
 				     port_fn_caps->value & DEVLINK_PORT_FN_CAP_IPSEC_CRYPTO ?
 				     "enable" : "disable");
+		if (port_fn_caps->selector & DEVLINK_PORT_FN_CAP_IPSEC_PACKET)
+			print_string(PRINT_ANY, "ipsec_packet", " ipsec_packet %s",
+				     port_fn_caps->value & DEVLINK_PORT_FN_CAP_IPSEC_PACKET ?
+				     "enable" : "disable");
 	}
 
 	if (!dl->json_output)
@@ -4874,7 +4890,7 @@ static void cmd_port_function_help(void)
 {
 	pr_err("Usage: devlink port function set DEV/PORT_INDEX [ hw_addr ADDR ] [ state STATE ]\n");
 	pr_err("                      [ roce { enable | disable } ] [ migratable { enable | disable } ]\n");
-	pr_err("                      [ ipsec_crypto { enable | disable } ]\n");
+	pr_err("                      [ ipsec_crypto { enable | disable } ] [ ipsec_packet { enable | disable } ]\n");
 	pr_err("       devlink port function rate { help | show | add | del | set }\n");
 }
 
diff --git a/man/man8/devlink-port.8 b/man/man8/devlink-port.8
index a51d19e6abdd..026deefc2c9b 100644
--- a/man/man8/devlink-port.8
+++ b/man/man8/devlink-port.8
@@ -80,6 +80,9 @@ devlink-port \- devlink port configuration
 .RI "[ "
 .BR ipsec_crypto " { " enable " | " disable " }"
 .RI "]"
+.RI "[ "
+.BR ipsec_packet " { " enable " | " disable " }"
+.RI "]"
 
 .ti -8
 .BR "devlink port function rate "
@@ -229,6 +232,10 @@ Set the migratable capability of the function.
 .BR ipsec_crypto " { " enable " | " disable  " } "
 Set the IPsec crypto offload capability of the function.
 
+.TP
+.BR ipsec_packet " { " enable " | " disable  " } "
+Set the IPsec packet offload capability of the function.
+
 .ti -8
 .SS devlink port del - delete a devlink port
 .PP
@@ -363,6 +370,11 @@ devlink port function set pci/0000:01:00.0/1 ipsec_crypto enable
 This will enable the IPsec crypto offload functionality of the function.
 .RE
 .PP
+devlink port function set pci/0000:01:00.0/1 ipsec_packet enable
+.RS 4
+This will enable the IPsec packet offload functionality of the function.
+.RE
+.PP
 devlink port function set pci/0000:01:00.0/1 hw_addr 00:00:00:11:22:33 state active
 .RS 4
 Configure hardware address and also active the function. When a function is
-- 
2.40.0

