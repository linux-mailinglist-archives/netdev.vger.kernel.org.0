Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDFA350B2F1
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 10:32:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1445535AbiDVIer (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 04:34:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1445056AbiDVIeb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 04:34:31 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2079.outbound.protection.outlook.com [40.107.237.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F11AF52E4D
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 01:31:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j4XSogA+omHVPvb1hNxttmSbN+T0DobmA+yu2KZRESmKUfdDUr46sSAJsdwqEySJe5Pzcc/jUiEftck2u0b802qjC8JYHI7Cr/udQzaU/B3fOboWDU7Sl0tR62B++N9E3aq9Q92GrBA09gc13BW6rg+gcH16pbXN088QekdDy4H8mJkbX1gVp/PZPr6sSgbnO9Xntrs6eOdHdbBxyChrHRN+f51NwosfjKY6n+0vFaCKE76wzwXtN8JFypqVxAODh0CKLDiSSSIbl/iUIpubL0EhQAtnvKvCnpQeSjMn62lk4xqpd/Wqpx715c8Q27p7p3Tx5HvNTRQKnXWipsb9/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eIZ7jUUHokyUqYqmaO5cexSh9EkdR1+oEBjm4PLuGGk=;
 b=fq4rwONCllEluNGEPRywNrUmb9Lgjx7Uhntiletuifny+W9HsYijEW3I0M/kM0bE4uk1B5ji2vp2SCO+MRcbKKUuHDZyWuF387Dp/cPHrtNNLDO3xcOPa/SwK2UMjkefSMX14/3uEJF7VxB98SlcFvun0E+HJUJAFBVjXFpytdZI7cx37sBwoteGubHPjohZ4LZSR35T+Dm7bhXqoS4CWxQEpp+JnOGFP5RnGolPyHteptNGGVVsN06LCiQE+QFtJthIfuuPJtKir/hx489vK5ou+FarI27Ux4oGSnQ0jXY521djq0/6PB+lVEmblNTjCtwaqo1xcMOzPwTfKYvX2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=networkplumber.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eIZ7jUUHokyUqYqmaO5cexSh9EkdR1+oEBjm4PLuGGk=;
 b=qsCIKO8OHoJ2MNjftf1b5+yp9B/AzfN+khlv16J+jFRutyhhNtu9ITOlfcXnsI1XpzJNWxqb4aXRqCFMMmjmXkuE3x1zs0rJXfr9z9OePhU3scoYmXuTPGGa0qQatmdNLs/Zc66QU4lrNs6yK67HBpg1qNOeXlAtIGJbF/yyJG31S8agP9OFIupFB3bwpZ7Xo6JoQb0LnY8XyfnvgNsqKoDIxT6QawihskGYd9t/X7EQH0NkhtkKWglOYT/k7Hhv4GvM6pwV3onE+d7JxSJNXPKAV1V8VEDLzvR9H/bVAbs9cimospaGFj9IbQKyFA1Pqjq+X/+118VKzFPWBpk/Gw==
Received: from DM6PR13CA0001.namprd13.prod.outlook.com (2603:10b6:5:bc::14) by
 BY5PR12MB3972.namprd12.prod.outlook.com (2603:10b6:a03:1a8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Fri, 22 Apr
 2022 08:31:36 +0000
Received: from DM6NAM11FT038.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:bc:cafe::cc) by DM6PR13CA0001.outlook.office365.com
 (2603:10b6:5:bc::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.6 via Frontend
 Transport; Fri, 22 Apr 2022 08:31:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT038.mail.protection.outlook.com (10.13.173.137) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5186.14 via Frontend Transport; Fri, 22 Apr 2022 08:31:36 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Fri, 22 Apr
 2022 08:31:35 +0000
Received: from localhost.localdomain (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Fri, 22 Apr
 2022 01:31:33 -0700
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>
Subject: [PATCH iproute2-next 04/11] ipstats: Add a "set" command
Date:   Fri, 22 Apr 2022 10:30:53 +0200
Message-ID: <aaad7fd7b27cd77d00b9dd8f7fa41bb15a4da16e.1650615982.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1650615982.git.petrm@nvidia.com>
References: <cover.1650615982.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ba58aefe-f4b2-4a55-92ab-08da243a83b7
X-MS-TrafficTypeDiagnostic: BY5PR12MB3972:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB3972689253A2BEC563FD9AE2D6F79@BY5PR12MB3972.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5k03yqJVK8B/T/x9dgvBoUgBAmQpLRh8uFSaQCsaKrI3ykSpUFnW/nidKdoEDwxXc5HTKS7mnT9rUBu66k8Mof0vS8/hqBgKgMEgmxDiVoCVaUEH7jYbULWhdSOnWhzyAO2GWdKwLDHUqoMmq0nnDYKEZK3XJnJhwa2fPkhSGYWYxZt+hWyXopSHtzt8JTF94IG9Pm1FwSIV8Bdy/O30IhdUaoAoRBT2AlwG0FHIaglBEA7GHTBMeH7NA9UKa7fwHdr1gW/hiDN/WRvZ1XiOvqLPeNCEv9nXsMFfYjtZPZO+4zMT9k4fyHN84I8UWrEN+DfT1zvU36dNOIScDU9w2FbmQCn1JDLUvFOEDPQOr17oupDP3f+/fK7WSHS36JRkL6KoNFRnmPydJlt3yKgjntg2wxA0N+21JJOxu9X8K2HWzcGVV3osyX9mijHeNu2asd7DFFXg8XeRAqkAZVxozCpB/H+EKZKPrT7I5WyPnniR54eEGiXGxWp6g0QsIEmUSmO8AFdy8Wrdl2XQG6n/xV9rOuNzsXwf6AIZzYngvA1dPW5eGWWeOb/A0ieI1vgGjN8vFeY96FISehHW/nknLn5v5x0eT+9gPIko/IpOfy/kEBrmCZvJ4EyOJeaGHzO5wjFACEhYYeKkPapqEZs4g+6CQSfAEDJiCP4i/AoQgvMTYIVTirwSb8FoAwbtCQnusqVv7Vc8NMshyG7yH6SQEA==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(5660300002)(508600001)(316002)(8676002)(86362001)(4326008)(82310400005)(54906003)(356005)(70586007)(70206006)(26005)(6666004)(81166007)(36756003)(6916009)(47076005)(186003)(2906002)(107886003)(16526019)(336012)(2616005)(426003)(8936002)(40460700003)(83380400001)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2022 08:31:36.1801
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ba58aefe-f4b2-4a55-92ab-08da243a83b7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT038.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3972
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a command to allow toggling HW stats. An example usage:

 # ip stats set dev swp1 l3_stats on

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 ip/ipstats.c | 78 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 78 insertions(+)

diff --git a/ip/ipstats.c b/ip/ipstats.c
index 099e18a2..1f5b3f77 100644
--- a/ip/ipstats.c
+++ b/ip/ipstats.c
@@ -1,4 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0+
+#include <errno.h>
+
 #include "utils.h"
 #include "ip_common.h"
 
@@ -6,11 +8,85 @@ static int do_help(void)
 {
 	fprintf(stderr,
 		"Usage: ip stats help\n"
+		"       ip stats set dev DEV l3_stats { on | off }\n"
 		);
 
 	return 0;
 }
 
+static int ipstats_set_do(int ifindex, int at, bool enable)
+{
+	struct ipstats_req req = {
+		.nlh.nlmsg_len = NLMSG_LENGTH(sizeof(struct if_stats_msg)),
+		.nlh.nlmsg_flags = NLM_F_REQUEST,
+		.nlh.nlmsg_type = RTM_SETSTATS,
+		.ifsm.family = PF_UNSPEC,
+		.ifsm.ifindex = ifindex,
+	};
+
+	addattr8(&req.nlh, sizeof(req), at, enable);
+
+	if (rtnl_talk(&rth, &req.nlh, NULL) < 0)
+		return -2;
+	return 0;
+}
+
+static int ipstats_set(int argc, char **argv)
+{
+	const char *dev = NULL;
+	bool enable = false;
+	int ifindex;
+	int at = 0;
+
+	while (argc > 0) {
+		if (strcmp(*argv, "dev") == 0) {
+			NEXT_ARG();
+			if (dev)
+				duparg2("dev", *argv);
+			if (check_ifname(*argv))
+				invarg("\"dev\" not a valid ifname", *argv);
+			dev = *argv;
+		} else if (strcmp(*argv, "l3_stats") == 0) {
+			int err;
+
+			NEXT_ARG();
+			if (at) {
+				fprintf(stderr, "A statistics suite to toggle was already given.\n");
+				return -EINVAL;
+			}
+			at = IFLA_STATS_SET_OFFLOAD_XSTATS_L3_STATS;
+			enable = parse_on_off("l3_stats", *argv, &err);
+			if (err)
+				return err;
+		} else if (strcmp(*argv, "help") == 0) {
+			do_help();
+			return 0;
+		} else {
+			fprintf(stderr, "What is \"%s\"?\n", *argv);
+			do_help();
+			return -EINVAL;
+		}
+
+		NEXT_ARG_FWD();
+	}
+
+	if (!dev) {
+		fprintf(stderr, "Not enough information: \"dev\" argument is required.\n");
+		exit(-1);
+	}
+
+	if (!at) {
+		fprintf(stderr, "Not enough information: stat type to toggle is required.\n");
+		exit(-1);
+	}
+
+	ifindex = ll_name_to_index(dev);
+	if (!ifindex)
+		return nodev(dev);
+
+	return ipstats_set_do(ifindex, at, enable);
+}
+
 int do_ipstats(int argc, char **argv)
 {
 	int rc;
@@ -21,6 +97,8 @@ int do_ipstats(int argc, char **argv)
 	} else if (strcmp(*argv, "help") == 0) {
 		do_help();
 		rc = 0;
+	} else if (strcmp(*argv, "set") == 0) {
+		rc = ipstats_set(argc-1, argv+1);
 	} else {
 		fprintf(stderr, "Command \"%s\" is unknown, try \"ip stats help\".\n",
 			*argv);
-- 
2.31.1

