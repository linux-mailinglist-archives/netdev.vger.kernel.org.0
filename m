Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D28D16E5F96
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 13:16:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231500AbjDRLQD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 07:16:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231444AbjDRLP4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 07:15:56 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2045.outbound.protection.outlook.com [40.107.104.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9B7A7EC8;
        Tue, 18 Apr 2023 04:15:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OBLOpwI5AbqCRSAyuBSCprsR8zian8DjZuCNgL3lCGQQEDWifpMyw7UX2ArIQQemgrXp6DcuUhrY1BbxqL0PkU/nLYJUkjlkR/qXzKVkhvmZSrUVOa/4fPhLjx7Ru1JruUPm+Gx603BtD7YSu3K2YZbiIRwdA5SLT9ZV9ojgPwUue2Eb/RFB/UHe/NjeamQJ+I+9utaOM4BTuEKDTscP1IDFj2FmN2o/qgv8X1nHtfyeGQLWNO2tEfE9EoHCbczUmnUtbrCwy5z+EZhL+H5oRYJa+lC2AdguCC7d63ipzFSFtnVdBkm2M8R1GXYdu1Jj9/Yx0Boj8mbQbbrm3GBpzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b004uq+1MEuH0toHwUCzkpI74907JbHOBxiLaLkv6es=;
 b=nUmU3pkrCd5C/yrMWTeVgaKG9seT77yPlJUYH8laliJDZMxdOhk6p3NDTsMLqKhaIm83iXe48sh/1Gc4EVkGTI0ra0TQhAw+K136BrdtC4/BnnKaaVueo1Wd0UzwfFcyRt64adIwTEZBjOFXVElN1XsBLhNMC3e723XUE1u//g4D1LZC4hwfNhZS/eip9bD6e/Ygav23ERHlXd03dUHjE0iddEu2V8EM3EQA40IKpUi0MHYenANPlCzMjnqOH9b2bdlyoz1xRWLCf8Awlb2HpkhGLyt7KjwRtUe5joWDJeWi0eMCZccZa+0A6K+jnVcYf5nMboPONr572t0IW82TEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b004uq+1MEuH0toHwUCzkpI74907JbHOBxiLaLkv6es=;
 b=ObsudGMBSXGGPruokiIKI7J5xYVBICMhNVi7/dHVztI0E1Jg0WaKZ5gmUSb+MHR275ntMnxwHMS9psP2m0Nqo3OM5LSvIlafCO4JFjfP6VDA4fgnjymYuons98RD8Ms0su/MgXIHFiNYb/Cp7tdadXa0eu9KOzEKK1z0CAVSFqU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AS8PR04MB8659.eurprd04.prod.outlook.com (2603:10a6:20b:42a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Tue, 18 Apr
 2023 11:15:25 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b%5]) with mapi id 15.20.6298.028; Tue, 18 Apr 2023
 11:15:25 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Michal Kubecek <mkubecek@suse.cz>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Petr Machata <petrm@nvidia.com>,
        Danielle Ratson <danieller@nvidia.com>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Aaron Conole <aconole@redhat.com>,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 net-next 7/9] selftests: forwarding: generalize bail_on_lldpad from mlxsw
Date:   Tue, 18 Apr 2023 14:14:57 +0300
Message-Id: <20230418111459.811553-8-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230418111459.811553-1-vladimir.oltean@nxp.com>
References: <20230418111459.811553-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0152.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:98::19) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AS8PR04MB8659:EE_
X-MS-Office365-Filtering-Correlation-Id: 342a45d5-b2c2-4e27-1b5d-08db3ffe3521
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uH61K1LCZpzEFK/y5IKyIN+btc8P42h2YzzQgZgS9feQoER9bn+Jdm+qNeZp4ws6nm/0MG862u+Q5j7dqicuDFozZg0o328xISg3YSpYoU2xwALG4OiNtBlP8BxV38Rcm88uzmtawSRqtpUcKA9NJxCcFspVYOpb1fZsuTPw1hD+8uc0YBRKkFjZGjwwGsQT8Pf8XI+4Gg4JLjleHLa/8PfYOs8lIWu1t/TP+rbVp9FbHeS9IaFtXzo9FwEhy+bJ615ETCE6zGOB/kvv58U9t48WFldgbA2QPTlNwCTnaPpW9sJHImzqIndDY3eIOfbah3wec3XzPdMHBuqvxzK52M4nzcY2XH7Fhjzl9wdmOjCYh53j0LWx+L0rNao9zB4m+SkyYQwuJAvDniTLeiFgHJ77av3O5TCX6jxqneUQ7fr14kB95vB6+kY02KZLGv11SH2DESuqGuwNYYVsCSbf1jjFy7VMS1ReO+QNNvaJw41IomGM6h8OWuWbM2PXUgvT8c3LbVekkjCZnlWi0IIG8Af7uVPSp/VbVysXpRTOBeSj1e3xxDAFWq4JlCkxom/+ZvelioYEfZZaJat7ZeUO6QpiotdxCtTvmx99cDKKI/C66zvnQY+TZh3p2k+NeVvhpca0B1wh8J83VYfKjJQEiQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(346002)(396003)(39860400002)(366004)(451199021)(6666004)(6486002)(478600001)(86362001)(2616005)(36756003)(26005)(83380400001)(6512007)(1076003)(6506007)(186003)(38100700002)(38350700002)(52116002)(66556008)(66946007)(66476007)(316002)(2906002)(4326008)(6916009)(8936002)(5660300002)(8676002)(7416002)(44832011)(41300700001)(54906003)(17423001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SkIEGVZkVFuJ9nDB91o8kITlMJMFK9GDo3nFv4i5bj7Bxkw2WEMAmYEBIROV?=
 =?us-ascii?Q?TmNoBIaaiyXUu0a3W7casWZZ2PT7sXhB6Jh/XYkzF5HPTomGr1kL2oripGd/?=
 =?us-ascii?Q?IGqHaLDQoQYpin2eZXB1Ewcov/IpfZLHMZrTt6pwn4LwKIx2zvPOMqrVu0QM?=
 =?us-ascii?Q?hgWVR/hvTz9RB2+eEExDq70alvui057vr9hjM4XbHMBWhq9fuX+hRHS5Gsql?=
 =?us-ascii?Q?rNyNkV53bWMpKzHp4YFGiwqgiMbfmra80pMqrSbRA9yNCxELCX8TxtNp2bB1?=
 =?us-ascii?Q?tIjh0RIyiGIJKoVzSSGp5pCgRDVH01s8i/3UlfMcEZXJLOjtISGe5KtfdBEV?=
 =?us-ascii?Q?L5WbJD8y0ugQE19M2n/OR43nTAD8NFksscGNeKQM/si/9iv1WNI/XEddGnAI?=
 =?us-ascii?Q?iCWQAuNZMAA+Iyxjs1Bv1vTFp2g9aHTW1eFrj3YzEzBNFJ2iiwiRgy5AJuH3?=
 =?us-ascii?Q?JoJt4kh/ffREmyM8gWDpQqvY1AF/BkPZGLhJTq2HSs0tBk+12BFsrjytUEBN?=
 =?us-ascii?Q?ZHBTxvJed8HjcfGH4m1hQKv5W4Qlijq1KSaTileQpvxsQ9Ya3aJCJkClXO+9?=
 =?us-ascii?Q?I311W9SF1y1u1zF0ScEmAeMdoqbEm1DRZU+CpqjS1L9PYL1Pqw9zbO7SuIpy?=
 =?us-ascii?Q?FzFrxwYD1ptRMMbLOzVCq4IaQubZkrHvedMn+GkFj71R3uPKj0cLUwNAsPCZ?=
 =?us-ascii?Q?izn2xU6dbY91QpIIGqw4zT/f0dKovFNLGj3PDa7M96g+3y2Il1Xf2BgK6BEq?=
 =?us-ascii?Q?oxT2YTqgeZTbiFcy/1vu9DUBEIJqzMcxc//tjeXRB4jCRLXMErGaYEkrufT4?=
 =?us-ascii?Q?UMR+z/zohPlieG7hSCoOWLjUa/qtPKywUUEFmpui9IpZYnmvwVwlpPbjCrZI?=
 =?us-ascii?Q?33dYWMvnt05ag4Gi1UFGHi/i8OoGXCW27pPnFY7pu9SJWJebK5VCsCMwNinG?=
 =?us-ascii?Q?qSU8ps4qGNN2PN3u0u2cvGcSXl51NRYnb+M4i4gK4lATk9X8MsMLIfwIKQXO?=
 =?us-ascii?Q?RRSuuLdxPE9EFWQW9GpNxUU8hHxfXgbtADIJy1L/ztLJShYoSqRouwysNksN?=
 =?us-ascii?Q?IaDeq9FmQeGhh9r4P+Vvw13ERdLfZR0OIGQ6JN3TAVucEcCL2SMC7Watpr7R?=
 =?us-ascii?Q?MR9A3iPyFlc/dQKvwlXH0yOsJQpPg/8rMgQpuqvug5EN47cFEiw9O7QAQ95G?=
 =?us-ascii?Q?eyYlARYqDAVzhWCK0PQNd6oUuNxGZzfzmz5GtftnqgXD3xahid6WYI00Ah6T?=
 =?us-ascii?Q?lZ/xlIMkxrWlvyZZRmDUDITpbUC8I+QGtbKVgxFrPt1i1KI1cItsEcgHLhwG?=
 =?us-ascii?Q?G9QR+Qdcv/bwR7ni2We2F17lUcA/2LFZ+mR7QGVj07Q60mmLJHoHCqqMSGhU?=
 =?us-ascii?Q?zBOHuJXe7nzbAYnbwJPYJs9/qP74XaIJ5dNg+hZ0RYaZmkLVxnfpcaAZKOLn?=
 =?us-ascii?Q?Mx/uRDmVcMDafyyUpv0YshFIKtLMPxsBdx9gXXh3WLVuk/R9lzIMn30pMdiC?=
 =?us-ascii?Q?7F2fJp/GMQid6ZW0WdsD/I0AEyAYzju4/KkzwvJRgGpU40NmQij6A+v/u+XD?=
 =?us-ascii?Q?8sKFzMXRz4bmyYiPCXqA/QHujKl4rnO9FTA8YBcK4VPqF1+yMtl/zec707nq?=
 =?us-ascii?Q?eA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 342a45d5-b2c2-4e27-1b5d-08db3ffe3521
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2023 11:15:25.0155
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jIQlzZXSOI1fyHEt48XUXqgkf/URFuVFkzWIJDCT45SyAXAtAYiFy1z/Iqc1mqNobnvjl/As7oMBz0IvTV+Vrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8659
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

mlxsw selftests often invoke a bail_on_lldpad() helper to make sure LLDPAD
is not running, to prevent conflicts between the QoS configuration applied
through TC or DCB command line tool, and the DCB configuration that LLDPAD
might apply. This helper might be useful to others. Move the function to
lib.sh, and parameterize to make reusable in other contexts.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Danielle Ratson <danieller@nvidia.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: new patch from Petr

 .../drivers/net/mlxsw/qos_headroom.sh         |  3 +-
 .../selftests/drivers/net/mlxsw/qos_lib.sh    | 28 -----------------
 .../selftests/drivers/net/mlxsw/qos_pfc.sh    |  3 +-
 .../selftests/drivers/net/mlxsw/sch_ets.sh    |  3 +-
 .../drivers/net/mlxsw/sch_red_core.sh         |  1 -
 .../drivers/net/mlxsw/sch_red_ets.sh          |  2 +-
 .../drivers/net/mlxsw/sch_red_root.sh         |  2 +-
 .../drivers/net/mlxsw/sch_tbf_ets.sh          |  4 +--
 .../drivers/net/mlxsw/sch_tbf_prio.sh         |  4 +--
 .../drivers/net/mlxsw/sch_tbf_root.sh         |  4 +--
 tools/testing/selftests/net/forwarding/lib.sh | 31 +++++++++++++++++++
 11 files changed, 39 insertions(+), 46 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/qos_headroom.sh b/tools/testing/selftests/drivers/net/mlxsw/qos_headroom.sh
index 3569ff45f7d5..88162b4027c0 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/qos_headroom.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/qos_headroom.sh
@@ -18,7 +18,6 @@ lib_dir=$(dirname $0)/../../../net/forwarding
 NUM_NETIFS=0
 source $lib_dir/lib.sh
 source $lib_dir/devlink_lib.sh
-source qos_lib.sh
 
 swp=$NETIF_NO_CABLE
 
@@ -371,7 +370,7 @@ test_tc_int_buf()
 	tc qdisc delete dev $swp root
 }
 
-bail_on_lldpad
+bail_on_lldpad "configure DCB" "configure Qdiscs"
 
 trap cleanup EXIT
 setup_wait
diff --git a/tools/testing/selftests/drivers/net/mlxsw/qos_lib.sh b/tools/testing/selftests/drivers/net/mlxsw/qos_lib.sh
index faa51012cdac..5ad092b9bf10 100644
--- a/tools/testing/selftests/drivers/net/mlxsw/qos_lib.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/qos_lib.sh
@@ -54,31 +54,3 @@ measure_rate()
 	echo $ir $er
 	return $ret
 }
-
-bail_on_lldpad()
-{
-	if systemctl is-active --quiet lldpad; then
-
-		cat >/dev/stderr <<-EOF
-		WARNING: lldpad is running
-
-			lldpad will likely configure DCB, and this test will
-			configure Qdiscs. mlxsw does not support both at the
-			same time, one of them is arbitrarily going to overwrite
-			the other. That will cause spurious failures (or,
-			unlikely, passes) of this test.
-		EOF
-
-		if [[ -z $ALLOW_LLDPAD ]]; then
-			cat >/dev/stderr <<-EOF
-
-				If you want to run the test anyway, please set
-				an environment variable ALLOW_LLDPAD to a
-				non-empty string.
-			EOF
-			exit 1
-		else
-			return
-		fi
-	fi
-}
diff --git a/tools/testing/selftests/drivers/net/mlxsw/qos_pfc.sh b/tools/testing/selftests/drivers/net/mlxsw/qos_pfc.sh
index f9858e221996..42ce602d8d49 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/qos_pfc.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/qos_pfc.sh
@@ -79,7 +79,6 @@ lib_dir=$(dirname $0)/../../../net/forwarding
 NUM_NETIFS=6
 source $lib_dir/lib.sh
 source $lib_dir/devlink_lib.sh
-source qos_lib.sh
 
 _1KB=1000
 _100KB=$((100 * _1KB))
@@ -393,7 +392,7 @@ test_qos_pfc()
 	log_test "PFC"
 }
 
-bail_on_lldpad
+bail_on_lldpad "configure DCB" "configure Qdiscs"
 
 trap cleanup EXIT
 setup_prepare
diff --git a/tools/testing/selftests/drivers/net/mlxsw/sch_ets.sh b/tools/testing/selftests/drivers/net/mlxsw/sch_ets.sh
index ceaa76b17a43..139175fd03e7 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/sch_ets.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/sch_ets.sh
@@ -5,7 +5,6 @@
 lib_dir=$(dirname $0)/../../../net/forwarding
 source $lib_dir/sch_ets_core.sh
 source $lib_dir/devlink_lib.sh
-source qos_lib.sh
 
 ALL_TESTS="
 	ping_ipv4
@@ -78,5 +77,5 @@ collect_stats()
 	done
 }
 
-bail_on_lldpad
+bail_on_lldpad "configure DCB" "configure Qdiscs"
 ets_run
diff --git a/tools/testing/selftests/drivers/net/mlxsw/sch_red_core.sh b/tools/testing/selftests/drivers/net/mlxsw/sch_red_core.sh
index 45b41b8f3232..299e06a5808c 100644
--- a/tools/testing/selftests/drivers/net/mlxsw/sch_red_core.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/sch_red_core.sh
@@ -74,7 +74,6 @@ lib_dir=$(dirname $0)/../../../net/forwarding
 source $lib_dir/lib.sh
 source $lib_dir/devlink_lib.sh
 source mlxsw_lib.sh
-source qos_lib.sh
 
 ipaddr()
 {
diff --git a/tools/testing/selftests/drivers/net/mlxsw/sch_red_ets.sh b/tools/testing/selftests/drivers/net/mlxsw/sch_red_ets.sh
index 0d01c7cd82a1..8ecddafa79b3 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/sch_red_ets.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/sch_red_ets.sh
@@ -166,7 +166,7 @@ ecn_mirror_test()
 	uninstall_qdisc
 }
 
-bail_on_lldpad
+bail_on_lldpad "configure DCB" "configure Qdiscs"
 
 trap cleanup EXIT
 setup_prepare
diff --git a/tools/testing/selftests/drivers/net/mlxsw/sch_red_root.sh b/tools/testing/selftests/drivers/net/mlxsw/sch_red_root.sh
index 860205338e6f..159108d02895 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/sch_red_root.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/sch_red_root.sh
@@ -73,7 +73,7 @@ red_mirror_test()
 	uninstall_qdisc
 }
 
-bail_on_lldpad
+bail_on_lldpad "configure DCB" "configure Qdiscs"
 
 trap cleanup EXIT
 setup_prepare
diff --git a/tools/testing/selftests/drivers/net/mlxsw/sch_tbf_ets.sh b/tools/testing/selftests/drivers/net/mlxsw/sch_tbf_ets.sh
index b9b4cdf14ceb..ecc3664376b3 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/sch_tbf_ets.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/sch_tbf_ets.sh
@@ -1,11 +1,9 @@
 #!/bin/bash
 # SPDX-License-Identifier: GPL-2.0
 
-source qos_lib.sh
-
 sch_tbf_pre_hook()
 {
-	bail_on_lldpad
+	bail_on_lldpad "configure DCB" "configure Qdiscs"
 }
 
 lib_dir=$(dirname $0)/../../../net/forwarding
diff --git a/tools/testing/selftests/drivers/net/mlxsw/sch_tbf_prio.sh b/tools/testing/selftests/drivers/net/mlxsw/sch_tbf_prio.sh
index dff9810ee04f..2e0a4efb1703 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/sch_tbf_prio.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/sch_tbf_prio.sh
@@ -1,11 +1,9 @@
 #!/bin/bash
 # SPDX-License-Identifier: GPL-2.0
 
-source qos_lib.sh
-
 sch_tbf_pre_hook()
 {
-	bail_on_lldpad
+	bail_on_lldpad "configure DCB" "configure Qdiscs"
 }
 
 lib_dir=$(dirname $0)/../../../net/forwarding
diff --git a/tools/testing/selftests/drivers/net/mlxsw/sch_tbf_root.sh b/tools/testing/selftests/drivers/net/mlxsw/sch_tbf_root.sh
index 75406bd7036e..6679a338dfc4 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/sch_tbf_root.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/sch_tbf_root.sh
@@ -1,11 +1,9 @@
 #!/bin/bash
 # SPDX-License-Identifier: GPL-2.0
 
-source qos_lib.sh
-
 sch_tbf_pre_hook()
 {
-	bail_on_lldpad
+	bail_on_lldpad "configure DCB" "configure Qdiscs"
 }
 
 lib_dir=$(dirname $0)/../../../net/forwarding
diff --git a/tools/testing/selftests/net/forwarding/lib.sh b/tools/testing/selftests/net/forwarding/lib.sh
index d47499ba81c7..efd48e1cadd2 100755
--- a/tools/testing/selftests/net/forwarding/lib.sh
+++ b/tools/testing/selftests/net/forwarding/lib.sh
@@ -1887,3 +1887,34 @@ mldv1_done_get()
 
 	payload_template_expand_checksum "$hbh$icmpv6" $checksum
 }
+
+bail_on_lldpad()
+{
+	local reason1="$1"; shift
+	local reason2="$1"; shift
+
+	if systemctl is-active --quiet lldpad; then
+
+		cat >/dev/stderr <<-EOF
+		WARNING: lldpad is running
+
+			lldpad will likely $reason1, and this test will
+			$reason2. Both are not supported at the same time,
+			one of them is arbitrarily going to overwrite the
+			other. That will cause spurious failures (or, unlikely,
+			passes) of this test.
+		EOF
+
+		if [[ -z $ALLOW_LLDPAD ]]; then
+			cat >/dev/stderr <<-EOF
+
+				If you want to run the test anyway, please set
+				an environment variable ALLOW_LLDPAD to a
+				non-empty string.
+			EOF
+			exit 1
+		else
+			return
+		fi
+	fi
+}
-- 
2.34.1

