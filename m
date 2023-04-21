Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF6996EACD1
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 16:26:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232484AbjDUO0G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 10:26:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232417AbjDUO0C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 10:26:02 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2042.outbound.protection.outlook.com [40.107.220.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 178481BD
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 07:26:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D9TEn5ovp+qgKlSTnmD+byMFAIOb4QPI68ry94rp1lXsbH39gHfzOf+ywp2Cf3ntuZAsJJwqQOGkRdlq4TaWWKuh5ExeCqxVjogZFS1jzCnOqofjrbHObZO87YgfHW6pEt2GY/SblHvLX3FFsMY/r32bepTgSn1WMqoVH4R732uF/lDnorGinQoKGtDr578Epf89XaKzzOGLkxnCOnAKwmgJINxWDElOXW0UYc+5AzbcYjIcCV0diiWyZN191Bytcs0CWJ8iu24Cn/lHVDLQy9ddiCw9WmT01MyaRGk9BQyKztz7kp6+ImTg6BV1+Yr3L/34tKNni5qRr8DDiRwPxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Cw2PWGDE1olQqZ3B/VFLPdGj/2o8KE9czoapVjdXMj0=;
 b=ZAXfXsIr4YmvZ3W0vVt7fFXbx1beZfqzzpKnYHrh7iL1oR3cnBR8pVaODURLS7/b3BKV0wm46aA+hFmTrGdZciFrV5d8t81QPEIWt1RLbkJt+5ur1nzOx78mRtFru35/MyqWf7JHbrz0vOBsgIAhDBtd/4ZninMJTNLAhkRqS03QKUDSsa2vWgNxzf2dsaQ07PsKwCQqh1QGCzYJPSKwYcdyiab2uWWiDFyegQimhJ4bz4oDnyNdcVCrE+bqn7DARQizgBr2WSqtWuDq1TKUdeVaYtPiwppomEb8S7vXu1yszk93w7aOloyP2S47cWXpoBjk51clHw5dlEjMigPgrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cw2PWGDE1olQqZ3B/VFLPdGj/2o8KE9czoapVjdXMj0=;
 b=BVdIlmLMmSZWWRMqd6FK4YeK2Z7K6uNRa/ZnRvS2zdLaRfwOuFtdzHfCIEfaOVkxmC1xV3rTVx9kAHlizEFbJ1CE9mXrcAo2KeLY9LtGsITRXYS4fe1EnOt/lsWKfEhKFbQ8SqKDgh1/gxLLvGS/uou++pbjf7nVsZP3oMhKB7eG5Xv87uaYA9Cn4BLuqB7BEfU1rTr2UMhC3V42NfoQUA9yhyWOamKaCDkHAbyDjOQmUvamid9F6vBtDlR3cZSnjAGwj7Y7YDb6DN074T0FAP7g8HVBciO+XHqU24uxMUAQktWskvV3cuGph6NgyikKBhW0AD2hdD6f3VBGx3AT8A==
Received: from BN0PR08CA0021.namprd08.prod.outlook.com (2603:10b6:408:142::16)
 by SN7PR12MB7450.namprd12.prod.outlook.com (2603:10b6:806:29a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Fri, 21 Apr
 2023 14:25:58 +0000
Received: from BN8NAM11FT070.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:142:cafe::d7) by BN0PR08CA0021.outlook.office365.com
 (2603:10b6:408:142::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.25 via Frontend
 Transport; Fri, 21 Apr 2023 14:25:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BN8NAM11FT070.mail.protection.outlook.com (10.13.177.50) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6319.26 via Frontend Transport; Fri, 21 Apr 2023 14:25:57 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Fri, 21 Apr 2023
 07:25:49 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Fri, 21 Apr 2023 07:25:49 -0700
Received: from vdi.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.986.37 via Frontend
 Transport; Fri, 21 Apr 2023 07:25:47 -0700
From:   Dima Chumak <dchumak@nvidia.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@kernel.org>
CC:     <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@nvidia.com>,
        Dima Chumak <dchumak@nvidia.com>
Subject: [PATCH iproute2-next V2 2/3] devlink: Support setting port function ipsec_crypto cap
Date:   Fri, 21 Apr 2023 17:25:05 +0300
Message-ID: <20230421142506.1063114-3-dchumak@nvidia.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230421142506.1063114-1-dchumak@nvidia.com>
References: <20230421142506.1063114-1-dchumak@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT070:EE_|SN7PR12MB7450:EE_
X-MS-Office365-Filtering-Correlation-Id: 4d6c459d-2497-4335-46d4-08db427452f3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tt1bFQdMryiHUoCraQ7rjgHYN3BE419k2+ruu2bZo/3F2d7ePJOCSYdWbBz4veg5Yw0E9LxEedmQuM0c86cUr09fW+NkdnTSIdXhhQRfxkKWY78fXzK0ozEU9Ydv9ZLQQjOneqX9RL+xVKKG9lMsaJy8qvw5vq1x/rAWbeUhSoOQlHlGq73ktqrbReIYw628hl7zlVvHeDbPj+aYobSITnFgh1nhLcO7G/bRqFolzAS/C0yf4byePYTq9s2oKonVMt2fQkvTZlwtSiRy6UpEat4XGBHLmCcSNV6QxG+ngCSIsg6NXQ/9EUDV4V5hgiYZkBqspwqyVaMfxw4SvD1dMfrLHLapZWEZ3dq5FfzJ+0BBXrbNq7YMsUOTRMdauCnsZ4mA+CjNdDz8ZgWgmCO+jO9Gyyk/GvSX4wwiI0ZUbckYhaGd4NnAjwTMFJCN5j5ujx+zu5LoXBixDZDNLI3bIxGUtsAHB5rGIPZTgU+WjINDnkO4hT5/u8kbbnlLh8ECfxOacNB4QhP3p0wj51YFiMjFuOcqQ2O36vTyKkqsmY7HCRGBytD2l/x29C15ugRGr1SC7bBntmrPKSR24dJlJkJdJwdeGaXC2ahn7CMR779goDiby6Q7AbKJB6lYaL1O5xkMm2f31VkwDJglSOMRmcyuG7i8lI8dID5obtcp1AKHVHK3EX6Ynx0Bgbpv3pMVHpcWuNGcPxD33Ovg+88Y98aIWcIf/l7nr4oWK+CJtwEtEJvNr1Fq8LTSAQH5i3vzpJMwoXNtYNdYN88KHNRB2dogMmqZBpdrIWwaE03qOsk=
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(376002)(39860400002)(136003)(451199021)(36840700001)(40470700004)(46966006)(2906002)(82310400005)(86362001)(36756003)(40480700001)(36860700001)(7696005)(34020700004)(6666004)(186003)(336012)(426003)(47076005)(83380400001)(2616005)(26005)(107886003)(1076003)(478600001)(70206006)(40460700003)(4326008)(70586007)(41300700001)(110136005)(7636003)(356005)(82740400003)(54906003)(316002)(8676002)(8936002)(5660300002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2023 14:25:57.6340
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d6c459d-2497-4335-46d4-08db427452f3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT070.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7450
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support port function commands to enable / disable IPsec crypto
offloads, this is used to control the port IPsec device capabilities.

When IPsec crypto capability is disabled for a function of the port
(default), function cannot offload IPsec operation. When enabled, IPsec
operation can be offloaded by the function of the port.

Enabling IPsec crypto offloads lets the kernel to delegate XFRM state
processing and encrypt/decrypt operation to the device hardware.

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
 man/man8/devlink-port.8 | 13 +++++++++++++
 2 files changed, 31 insertions(+)

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
index 56049f7349a8..534d2cbe8fa9 100644
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
@@ -222,6 +225,11 @@ Set the RoCE capability of the function.
 .BR migratable " { " enable " | " disable  " } "
 Set the migratable capability of the function.
 
+.TP
+.BR ipsec_crypto " { " enable " | " disable  " } "
+Set the IPsec crypto offload capability of the function. Controls XFRM state
+crypto operation (Encrypt/Decrypt) offload.
+
 .ti -8
 .SS devlink port del - delete a devlink port
 .PP
@@ -351,6 +359,11 @@ devlink port function set pci/0000:01:00.0/1 migratable enable
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

