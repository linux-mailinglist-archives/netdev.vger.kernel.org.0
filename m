Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56E556944B5
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 12:39:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231213AbjBMLj4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 06:39:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231312AbjBMLjs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 06:39:48 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2059.outbound.protection.outlook.com [40.107.21.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B17218A94;
        Mon, 13 Feb 2023 03:39:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TaSVB+/IwfoWygwPkeozZ0QT/r5i0SRGGMMBdv7Qt4sGDBfg0W8Hgh35y3lGAOvSTPll81Ijm+Rc546MW73X0IVQQ8tnsS0EU8mtnuVVhaGSXMLCBwys5q3aDDe9PeltfcFaLYB8RYe0uzj8Megrm24IUNjEzZIOHlmGcldL4FPe+oJb4BdexB7rWn3v6PnVFtFZ7s6ys0Oqv9146a1U76+ZelHiVtKnLvlVD5pJDC7+nsXOMIF5tdpszasEify2Bb5o+O6V8AHmBUecybjB+9Wa8JECwaynvoZH/Dt7ChIgEmnrzHzPp0W0SqzJzyIxqA/D109AB8phiK08l7aWxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KjZuW6APrSP1wIsOl4RRxu9w+XuLmr8NNBpn+iuWx+w=;
 b=Xy/oFYAn7rG0Qg6c3SGpa3aYwPPW0LDKkDv3wQlpcjy9Ol/LUk5+nLWx5XcFct4TWrbGBSrJkgaRmiIHmnBpHvokAw9zCX86NxhSHlImdCTKcm7mwvSo5xzjaXSUFjqTE/JLz80fc9HAWPFWE1gPVNlE1UoWHf2CASs9mL4hPOAJR3uF82K/cOq0yHeG3s6ymkY1hT2ftySwc9HGiVUeBxwCJKjb8McJTnozWI2YUu44qBM6FryiGKYy2Z4K8bSedcJmUMZM17ygzPvsUz5ScY9EGKbGttVXOet9lpPAEpdgC4bhGI093FAvyI62sUgLtw3bWFTw2GhHQgXMjAtwjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KjZuW6APrSP1wIsOl4RRxu9w+XuLmr8NNBpn+iuWx+w=;
 b=czylzuVsljs0XoyGI3CiiTzW0RmTt4CcNyxNtwLNPEpmsUmBQ4VSqzBaAPKju928ZvMpPcPemshFCbRE4yCLzdxVZyyo5EgfX/BQyxtueSHoQPJ5QJkwlrDCD+rakeMyyZHot5gGVEWRKLiSREQ8w5Sa4v85EjlzfAkyljKb3zY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DU2PR04MB8647.eurprd04.prod.outlook.com (2603:10a6:10:2de::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.23; Mon, 13 Feb
 2023 11:39:12 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.6086.023; Mon, 13 Feb 2023
 11:39:11 +0000
Date:   Mon, 13 Feb 2023 13:39:07 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Petr Machata <petrm@nvidia.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Kubecek <mkubecek@suse.cz>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Rui Sousa <rui.sousa@nxp.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        UNGLinuxDriver@microchip.com, Ido Schimmel <idosch@nvidia.com>,
        Aaron Conole <aconole@redhat.com>
Subject: Re: [RFC PATCH net-next] selftests: forwarding: add a test for MAC
 Merge layer
Message-ID: <20230213113907.j5t5zldlwea3mh7d@skbuf>
References: <20230210221243.228932-1-vladimir.oltean@nxp.com>
 <873579ddv0.fsf@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <873579ddv0.fsf@nvidia.com>
X-ClientProxiedBy: BE1P281CA0030.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:15::9) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DU2PR04MB8647:EE_
X-MS-Office365-Filtering-Correlation-Id: de571b2d-2633-475a-5ebb-08db0db6ecdd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1htTtaCUDAzi/68SjSivVAyMSbA9HgM//Wplpgem8wU0OMHMIgEV2e5K9luFs22O7PWub2yNE9ERBqYylOub4ARkDhOgFKT2xcF9bH7fBZep5lAzbdslCF2rd0qwCLzvCp62gU5iJzn7M7kGh3GSKOe1q9vUPdxKez5JxPi3m/X5NSgu8geN6AYqVab2TfClvBtwZmzq68Hy4l7NLVZ4AsXBhdoMANOBXotU8YQI4zf1DULjz0DTLSmYNEA0tQbXMATHZnQgH8WJYkMEaG6oj/NgwlCrGZ79PUQyZwGo0TxkFv6bg9m2RqWYP1YYSvggoX2+hpmvqUPgDKmhYijkDNFRIvCf5tQhJOEHPC8Z72w9QZ6wy3+aYtdksCmgBpWIcHekwCpM6eymcu/8iyXATVgvfYCTml1T/SCTnS1MnFlilEsVbI4JhkSaIqAcu2QDUkzBlqeqlzYYCGH5Hs0/BrOkTWokXywaV2M/bMd3faFV/g6OZ7G66R+H+q/sOYpcvt4iDhsPPDcu2Lt0vgmQJGMSSN1WxP0c/GXGVM5x4a1DEEaGI5t9iPXm29U+P71Mo/Bl568rvbCyAuVJUVqGjq95kZjmeJ0XRYc5y5e39mETnotvzdKTjqNCSNyrm/Zpo8M80pNkoqflxCq4SpVyvw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(7916004)(346002)(366004)(39860400002)(396003)(136003)(376002)(451199018)(6666004)(1076003)(83380400001)(6506007)(478600001)(33716001)(6486002)(186003)(6512007)(26005)(9686003)(38100700002)(86362001)(5660300002)(8936002)(2906002)(7416002)(54906003)(316002)(44832011)(4326008)(6916009)(41300700001)(8676002)(66476007)(66946007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sh7kc755+LEzcthu27JbJsdiYzYTLFskPHXzzhDCFbuFwqro9zTC/J7rmWDb?=
 =?us-ascii?Q?DjFU/S2Q7hRCJvUtd+Yc8vMU20smaraEH7Cp+X/lPsCiM4cH9+E/2R9mI7yx?=
 =?us-ascii?Q?9c/o0E9jYQkYHq5b/SZi7FJ9yaGy7d8O3UaWgGy90mm10jIVReEe0gVuj2bZ?=
 =?us-ascii?Q?rKFtH4xXSEJE4hcjm5QixSzavDg2t8yUA20HsVS4gLgqAi4/lHL/7UuZ86I7?=
 =?us-ascii?Q?HvAA0RDZ7IcqbhMZ0grwTsyiLwGipxiqTJZjFBK6PpQ69aQ13AH6SxWXbQWE?=
 =?us-ascii?Q?MwnLtDYQl+9RCfd642EDQekNFn4ofJAsofZqyuJ9hWrGVci7yw6QYQVzwnOT?=
 =?us-ascii?Q?F+0N86mz6rWd9i9Xoc4H09WmqMB12sWG0/8UK6V9pYmGbOnwMOo7EGH08xie?=
 =?us-ascii?Q?9oVKh/8W/2OalWEWK9SkmRO922+4cLqbDzQPuMyXl8Zw4T0pePL4wsy4mdP1?=
 =?us-ascii?Q?H/8SHOWBFLyBKYw6v1U0PWYh/oT1VOp/kX4/fBj+SqIIKUWE76u1BNeVY6CA?=
 =?us-ascii?Q?8YnlL0mE6mt3gmfF5stklWwTS8yv4HhM3YAatBiHsT2OIV5SUOGGPeyWUio6?=
 =?us-ascii?Q?wg+tP6CtKs+99mZawkepJym+Nq8KaSC++PlT0LMDhrtdZyStpmLNaVw7XhSA?=
 =?us-ascii?Q?5Oco+2vDISKJduUER34WpEr0b3iEaqKHN3H+OZyGgGnNu2Mwpw00DX+evXc0?=
 =?us-ascii?Q?8gJhima7o24JAamFcBwqo6vk7/5G8PlJIPMAMIjrDfqlHWrVDN2bD3q4wC1v?=
 =?us-ascii?Q?AAlSdDdwk1lUJNGRnJFtuLfQ6iY0wtqsOnE4LPL6Krfy3D5C9TZOviAf42oL?=
 =?us-ascii?Q?uAAk8zSak+owGtuwYMnXYay37omINqjWSRk2eXaA42AJwJUR5SvxrDaqYz5U?=
 =?us-ascii?Q?J+1lhTRAjiEPYffIesXHLYsNxt0Tu4yQkhTLhD9K4+H2tUQhbQZ2KvEGU9qu?=
 =?us-ascii?Q?17JO9oBKPSyjRCdVmLYZHlmSJx2oJfkOSOXR998I/GrIaoE5sa3el741toX+?=
 =?us-ascii?Q?uSBfjHPT3OHKVvsNAn9RI4UpWGT50sVQxFsV19gSnnpKc9E2mkH9k9MxoxaN?=
 =?us-ascii?Q?qF2YIved7oH07GblJ6UVWYetMQi4bvjKNR5UnzCCxZNalKNNP/A5IWulOEHI?=
 =?us-ascii?Q?mhShwLwKFu2d9Q4FRmzk43BgZ5Xymp1y0OQ8ra84RbwOvL+fdw8Q/sQVOBrs?=
 =?us-ascii?Q?VyF5QtwRifrkw/3P0EqXPDBIIoLHbGXS3PUCHwh65M+QXcF+xYjylFLMMydU?=
 =?us-ascii?Q?2giyaSx00BI+91XVFy/CHx5yNEeNs/scP1iuhvevNNvSKR1+5JCwtsDuLPLB?=
 =?us-ascii?Q?FlbhEOO+Ttt7iMTdUnZk0uaEVUgyOLB8UfwagGnnjGsbHYK+AHzErHd6WGRv?=
 =?us-ascii?Q?XDuYTHsF0mS4tHlWy+emKet/i+d7EgNhlcnWahJRkTmMtB3jVUWHo8qqmgOO?=
 =?us-ascii?Q?dgBIZEPvps5De2X+i+AO1KEs5Arbgk9g5jdcidW1h2xZfPi4HzMN2z6iUgOP?=
 =?us-ascii?Q?N92lP5Eqvkb5UeYoMkuSLWxEqRtFPqmc3idPRCRrYXoa2o3KAPEFscdh9gFx?=
 =?us-ascii?Q?Mp5rY61J/q3K/NNPJTbMxfDwSBwUtp/ZtiU875IQQWHWW702J2aXWc0zpjn7?=
 =?us-ascii?Q?tQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de571b2d-2633-475a-5ebb-08db0db6ecdd
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2023 11:39:11.4227
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TEhtKxnMKH2Hj+An3xU/KMUnyOlUoQuKIXFfzIGGlLlPBRsQJQVM4U4ca7Ile1O1DFGVVigfz8F9Ab99CRiyLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8647
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Petr,

On Mon, Feb 13, 2023 at 11:51:37AM +0100, Petr Machata wrote:
> Vladimir Oltean <vladimir.oltean@nxp.com> writes:
> 
> > +# Borrowed from mlxsw/qos_lib.sh, message adapted.
> > +bail_on_lldpad()
> > +{
> > +	if systemctl is-active --quiet lldpad; then
> > +		cat >/dev/stderr <<-EOF
> > +		WARNING: lldpad is running
> > +
> > +			lldpad will likely autoconfigure the MAC Merge layer,
> > +			while this test will configure it manually. One of them
> > +			is arbitrarily going to overwrite the other. That will
> > +			cause spurious failures (or, unlikely, passes) of this
> > +			test.
> > +		EOF
> > +		exit 1
> > +	fi
> > +}
> 
> This would be good to have unified. Can you make the function reusable,
> with a generic or parametrized message? I should be able to carve a bit
> of time later to move it to lib.sh, migrate the mlxsw selftests, and
> drop the qos_lib.sh copy.

Maybe like this?

diff --git a/tools/testing/selftests/drivers/net/mlxsw/qos_headroom.sh b/tools/testing/selftests/drivers/net/mlxsw/qos_headroom.sh
index 3569ff45f7d5..258b4c994bc3 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/qos_headroom.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/qos_headroom.sh
@@ -371,7 +371,7 @@ test_tc_int_buf()
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
index f9858e221996..2676fca18e06 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/qos_pfc.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/qos_pfc.sh
@@ -393,7 +393,7 @@ test_qos_pfc()
 	log_test "PFC"
 }
 
-bail_on_lldpad
+bail_on_lldpad "configure DCB" "configure Qdiscs"
 
 trap cleanup EXIT
 setup_prepare
diff --git a/tools/testing/selftests/drivers/net/mlxsw/sch_ets.sh b/tools/testing/selftests/drivers/net/mlxsw/sch_ets.sh
index ceaa76b17a43..99495f5fa63d 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/sch_ets.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/sch_ets.sh
@@ -78,5 +78,5 @@ collect_stats()
 	done
 }
 
-bail_on_lldpad
+bail_on_lldpad "configure DCB" "configure Qdiscs"
 ets_run
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
index c6ce0b448bf3..bf57400e14ee 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/sch_tbf_ets.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/sch_tbf_ets.sh
@@ -2,7 +2,7 @@
 # SPDX-License-Identifier: GPL-2.0
 
 source qos_lib.sh
-bail_on_lldpad
+bail_on_lldpad "configure DCB" "configure Qdiscs"
 
 lib_dir=$(dirname $0)/../../../net/forwarding
 TCFLAGS=skip_sw
diff --git a/tools/testing/selftests/drivers/net/mlxsw/sch_tbf_prio.sh b/tools/testing/selftests/drivers/net/mlxsw/sch_tbf_prio.sh
index 8d245f331619..b95e95e3b041 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/sch_tbf_prio.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/sch_tbf_prio.sh
@@ -2,7 +2,7 @@
 # SPDX-License-Identifier: GPL-2.0
 
 source qos_lib.sh
-bail_on_lldpad
+bail_on_lldpad "configure DCB" "configure Qdiscs"
 
 lib_dir=$(dirname $0)/../../../net/forwarding
 TCFLAGS=skip_sw
diff --git a/tools/testing/selftests/drivers/net/mlxsw/sch_tbf_root.sh b/tools/testing/selftests/drivers/net/mlxsw/sch_tbf_root.sh
index 013886061f15..c495cb8d38f7 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/sch_tbf_root.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/sch_tbf_root.sh
@@ -2,7 +2,7 @@
 # SPDX-License-Identifier: GPL-2.0
 
 source qos_lib.sh
-bail_on_lldpad
+bail_on_lldpad "configure DCB" "configure Qdiscs"
 
 lib_dir=$(dirname $0)/../../../net/forwarding
 TCFLAGS=skip_sw
diff --git a/tools/testing/selftests/net/forwarding/lib.sh b/tools/testing/selftests/net/forwarding/lib.sh
index 30311214f39f..ab1c2f839167 100755
--- a/tools/testing/selftests/net/forwarding/lib.sh
+++ b/tools/testing/selftests/net/forwarding/lib.sh
@@ -1896,3 +1896,34 @@ mldv1_done_get()
 
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
