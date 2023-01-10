Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38DC4663A69
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 09:05:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230373AbjAJIF3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 03:05:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237892AbjAJIEy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 03:04:54 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2089.outbound.protection.outlook.com [40.107.220.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 800BD3AB3A
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 00:04:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kPLOOcwprVikBGLi1rjyaYR/AtnK2syTIFs89Y+BgOsTDu/QUo57ivGE8iFYI25pCgfjdWfk2OHeoSJHZXXaFW9ZB8YIJZduMR78xY+HlgpMo8kaqObBJGUiI8NswUgmz1JMDDdiRqqjOXRAjD5ZpdreZ6O7aBjgQjAVdQByrotcZPCPm5hKrPchR+oOgt6IttI1p45tajD+1yhfu/5X93dg5dFvdZwC80xFGPzVs2/Y0xQYSfppb8SIOisEPmYssU2IgDAIlTlcdKO/j3oRsQ5/Rs8OOhAdg3uObJWKJl31Z0zE9D6gklYWIy8HXPZP8pv9GI4YcVS8QNzCs7coTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I1kT46Dcv4xN9InC76avaqERLNTVGejLy65xAvLTaGg=;
 b=nj4C8ybVMAxtXOWXmqszWIj+8P6Ls6nmK+tLI+CtgzC6EYkPPI5GDlTAf4rrY6slOvqctuENXARDFf5eLKdfn8EINCwSU5FPhUd9EmgP/tImxIywPkM1NUGQLOxMnhpxPPo9ZYpE97sTmfRMnjjB2bgoN15T5WOs2eyi74Vz9V/chiToPF7KgxckrELNYg/I56YHgCJbhCcmkBlvGrx3geu1VcgbTqk4ceb350RcM4O7tKWjv5LTLU6mCVxzoRglvTMHgSHFmm3IRA0Gc8adUfDLTWRDxZSZRGipJ7Q1/HRvOLeWJmG1ULcXLkXbNfyRGyIAXhoAmo/f7nkUx5PeWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=queasysnail.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I1kT46Dcv4xN9InC76avaqERLNTVGejLy65xAvLTaGg=;
 b=s1pPTjPemWeXMtRNoH7m2XhH7J16g0B5a1O/E628dKwFz7OFttd9zx0t61KaEtfIgDxLSjSJk13rgabzCNKrIlphvbEDNzA8VKWSMtgIwaoaIr/ca2iWlwBc2GzJP6d0kcjhE7Z9Va6+ryPqoTYl2fuXWoYVuZGnrKEYuhXFSWSGm7Hf47pEPj9taCu6cYrlfwVbA4+e0yXcBfEtY8pa6VR/9iT493p/ET8ne2sXQ0O3J4gH/3qAWqD+xdK6zJQxNiTzpwy6n/QU8/jaITXlKL87TsNkZp0zOGwP0N/ZlvN8stVhcrk/wgSN9dy1ddUO8wtri72XqLSJWPbe3DVPrw==
Received: from MW4PR04CA0226.namprd04.prod.outlook.com (2603:10b6:303:87::21)
 by MN2PR12MB4239.namprd12.prod.outlook.com (2603:10b6:208:1d2::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Tue, 10 Jan
 2023 08:04:50 +0000
Received: from CO1NAM11FT057.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:87:cafe::b9) by MW4PR04CA0226.outlook.office365.com
 (2603:10b6:303:87::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18 via Frontend
 Transport; Tue, 10 Jan 2023 08:04:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1NAM11FT057.mail.protection.outlook.com (10.13.174.205) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5986.18 via Frontend Transport; Tue, 10 Jan 2023 08:04:49 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 10 Jan
 2023 00:04:38 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 10 Jan
 2023 00:04:37 -0800
Received: from vdi.nvidia.com (10.127.8.9) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Tue, 10 Jan
 2023 00:04:36 -0800
From:   <ehakim@nvidia.com>
To:     <sd@queasysnail.net>
CC:     <dsahern@kernel.org>, <netdev@vger.kernel.org>,
        Emeel Hakim <ehakim@nvidia.com>, Raed Salem <raeds@nvidia.com>
Subject: [PATCH main 1/1] macsec: Fix Macsec replay protection
Date:   Tue, 10 Jan 2023 10:02:19 +0200
Message-ID: <20230110080218.18799-1-ehakim@nvidia.com>
X-Mailer: git-send-email 2.21.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT057:EE_|MN2PR12MB4239:EE_
X-MS-Office365-Filtering-Correlation-Id: a2ec59a1-6121-4b3f-6faf-08daf2e158fa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5zxsj45gqfKimzqLXWRjyVGQKjGQ4CHILMqENjslO5OZ7dlgEyecXi58qTkof0IbAUF/92Wg6Dsdmqe+TMUVvKimUYFX+K3HOUc90TRyD62D7pb2x1KxnJaRPQGXTS67xT9TZv1AnBUsW1NlQXL/gTHQRgPGtV9ZlWCbvtX5KXs5RjcEUUiPLIkbngVyuU4s4Ik1buY2iCcFsAxOfmgyDlziuUeX/Y8e3rXQpvqzRLvLc5pKnDHTSAiRtwMu7bkyGprzLfTIsZ63UtODRPx8Dhcc5qG+XKwIA0zjMiNNJ3nQqttIsZsEJ7udZT+fVCcz3/efpcnQsfuPX3k5sSZQdCyXlN8vC3SFOUQDyUc+AwVGzgn+dJd8H/30gjTeX43ZXFle+6qlibCk7kM3ENfeYNsldRSvvPYPZp9OTRmXSx1kRxYdSvSLKVqsnZ23O71H6hDHOSVTRwsoOBDAzhcBcX3Wkl0G1opZvzTvrUpM/e1b5AUQnvWTE3mP0lZrXNCujfa21erSc9pFcn7x2NJtWG0fIX85IlR1j/brpmzf2iceYknqc1+Zb1qCQ0LWwHRzFbePSIiW6NHqUYaxJuElg1fQkEp+xRtRhSEQMF+vStgoiWj9LB3nVarZsp0WIWcJRm5Rg+PiQ3miOSRxYKsrbcVs8gAWffadnWY7T+VISo76tDiYe82Q3WPWfEbynHUbF5T4ltC9x7MfoUqMRCD6hfeUM5KNdQn8AMgWB7vq3nw=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(396003)(39860400002)(136003)(451199015)(46966006)(40470700004)(36840700001)(2906002)(82310400005)(47076005)(83380400001)(336012)(36860700001)(2876002)(426003)(54906003)(2616005)(1076003)(5660300002)(40480700001)(7696005)(6666004)(107886003)(8936002)(26005)(186003)(36756003)(6916009)(478600001)(7636003)(70586007)(70206006)(8676002)(41300700001)(356005)(86362001)(4326008)(40460700003)(316002)(82740400003)(309714004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2023 08:04:49.9155
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a2ec59a1-6121-4b3f-6faf-08daf2e158fa
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT057.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4239
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Emeel Hakim <ehakim@nvidia.com>

Currently when configuring macsec with replay protection,
replay protection and window gets a default value of -1,
the above is leading to passing replay protection and
replay window attributes to the kernel while replay is
explicitly set to off, leading for an invalid argument
error when configured with extended packet number (XPN).
since the default window value which is 0xFFFFFFFF is
passed to the kernel and while XPN is configured the above
value is an invalid window value.

Example:
ip link add link eth2 macsec0 type macsec sci 1 cipher
gcm-aes-xpn-128 replay off

RTNETLINK answers: Invalid argument

Fix by using a boolean variable for replay protect with a default value
of false.

Fixes: b26fc590ce62 ("ip: add MACsec support")
Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
Reviewed-by: Raed Salem <raeds@nvidia.com>
---
 ip/ipmacsec.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/ip/ipmacsec.c b/ip/ipmacsec.c
index 6dd73827..e2809fd6 100644
--- a/ip/ipmacsec.c
+++ b/ip/ipmacsec.c
@@ -1356,8 +1356,7 @@ static int macsec_parse_opt(struct link_util *lu, int argc, char **argv,
 	enum macsec_offload offload;
 	struct cipher_args cipher = {0};
 	enum macsec_validation_type validate;
-	bool es = false, scb = false, send_sci = false;
-	int replay_protect = -1;
+	bool es = false, scb = false, send_sci = false, replay_protect = false;
 	struct sci sci = { 0 };
 
 	ret = get_sci_portaddr(&sci, &argc, &argv, true, true);
@@ -1453,7 +1452,7 @@ static int macsec_parse_opt(struct link_util *lu, int argc, char **argv,
 			i = parse_on_off("replay", *argv, &ret);
 			if (ret != 0)
 				return ret;
-			replay_protect = !!i;
+			replay_protect = i;
 		} else if (strcmp(*argv, "window") == 0) {
 			NEXT_ARG();
 			ret = get_u32(&window, *argv, 0);
@@ -1498,12 +1497,12 @@ static int macsec_parse_opt(struct link_util *lu, int argc, char **argv,
 		return -1;
 	}
 
-	if (window != -1 && replay_protect == -1) {
+	if (window != -1 && !replay_protect) {
 		fprintf(stderr,
 			"replay window set, but replay protection not enabled. did you mean 'replay on window %u'?\n",
 			window);
 		return -1;
-	} else if (window == -1 && replay_protect == 1) {
+	} else if (window == -1 && replay_protect) {
 		fprintf(stderr,
 			"replay protection enabled, but no window set. did you mean 'replay on window VALUE'?\n");
 		return -1;
@@ -1516,7 +1515,7 @@ static int macsec_parse_opt(struct link_util *lu, int argc, char **argv,
 		addattr_l(n, MACSEC_BUFLEN, IFLA_MACSEC_ICV_LEN,
 			  &cipher.icv_len, sizeof(cipher.icv_len));
 
-	if (replay_protect != -1) {
+	if (replay_protect) {
 		addattr32(n, MACSEC_BUFLEN, IFLA_MACSEC_WINDOW, window);
 		addattr8(n, MACSEC_BUFLEN, IFLA_MACSEC_REPLAY_PROTECT,
 			 replay_protect);
-- 
2.21.3

