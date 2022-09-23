Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 226205E847B
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 23:02:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232299AbiIWVA5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 17:00:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231593AbiIWVAr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 17:00:47 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2041.outbound.protection.outlook.com [40.107.21.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25AE510D642;
        Fri, 23 Sep 2022 14:00:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XiixKbHZxXEHbLb2fipWbw6AkLXHKndg68CoGWE1OxNA8s62GIYoHdYC/BCsmgbxAlaAXYdFvQYUhVY2KmwIO49Jwq561GPemZ4MpyTR1e3n81d7C0Wb1ciQiCjYMVLjisfMRXXU2i90jXnFDdpAQh64RqZ6Ogd2m2hCImd6XxvhbAs3enX9IsQyYl5qm0b18A5h7BRxArc3cA6md4fa4tAKlwnVTFuXA4kMIE0dl/+yxnMEHVpiRgzzUYb3vvVuifRB7UDljuY1rk4CjTAKD3Z+NNLFrF5fPlcWwv1PmTHo6Juz6Rc9me+nv3fa1f/TUpf9e6y4JnCpKqgIweIdtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uam/3T3/50/z/8v91n0dbEBvvU607MfNHi2z6Umk/wI=;
 b=FMVIvj8PbIEGP5ZwY9aTXikYG08St3kJ00FRBQWv8oHLR1HoZZKzJm00NnA3AFZz2oU871kFpvBhsxEnRFQATMaKQRdbCTaUsDYNfHyPSwvXPCKtMgKoC1nRIUoT/UkjDOvzH8+QmJ2Wo43S+eRJb629/dvDE+rcDo0dbxPy7Rmv+iB6t9W1Y3Dq1Vsn/Ehn2Z4OmNYDU/qWNHPHwkmdA8rX/5BIusK9wOetDwYlqvpTCX8/0Lt3f84/Ke6dW4hPdYEL8LbQresTuNDrIpBQ3xlsF1v6nPSt31+A9Wy7Y5g0D0gsCkmwaJ/g+HKHfjVPmkdI26IMFnMBOw7yR8kzdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uam/3T3/50/z/8v91n0dbEBvvU607MfNHi2z6Umk/wI=;
 b=TxEGvLGielyZR9r5nXn47sXcZYJNzeZtK0ENdkZODxNHQEvy4mABPsJoeMXW1YxGF0AjQcDW074Hv9D0cDAQHnyY3KBPlMN92q16J7UZeIoGQ5+gv42TCazyrTAWToWhzDU5bUUWTFNOp9HlPT2RBgYskhap48RBG9aMRQ4ea6E=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB7863.eurprd04.prod.outlook.com (2603:10a6:20b:2a8::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.18; Fri, 23 Sep
 2022 21:00:42 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5632.021; Fri, 23 Sep 2022
 21:00:42 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 4/4] selftests: net: tsn_lib: run phc2sys in automatic mode
Date:   Sat, 24 Sep 2022 00:00:16 +0300
Message-Id: <20220923210016.3406301-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220923210016.3406301-1-vladimir.oltean@nxp.com>
References: <20220923210016.3406301-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0270.eurprd07.prod.outlook.com
 (2603:10a6:803:b4::37) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AS8PR04MB7863:EE_
X-MS-Office365-Filtering-Correlation-Id: 39b03766-2541-4ade-cc07-08da9da6ad67
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Je5uVZUTQfhV6J4Z0ThS9gRQzwD3keRO3FZbgIF4Bzx4Z5kJyVUqvoS/i9zp1MClQ9Rv52kG1Wmu2dOaO1tHObZXe6vkTs9POYEbDPURtaQqGHIp211IjhrycwAaNpaBVwSDoLgzMjWHGdr8mIvaiK7+422mvS8DbJ0OAlfGt85r5Xr3TWs+2PkWx/3FvLCsWFdbcIQTKzrgIxN+Q11QdRqjgQz9OA215EdqLnGyNu9D986FgBP6NTBnp3WdVCpm2eMNVb+Q91VHHVXL9aSPgzHHoFqaJKLI5DUEeP9qZXqcmUfUlY36QV526WVDmFDgh1vAJNXObuvjPATn7vONi6zk8AWjGa8HiDkWk/vXhfJ0ePGbhkzS3wWn0Hm6GgXSiCTMcO93CiKBRiohvd8H4ZCv/Q7LNM69jEY8iP66bYI+WvpwKPfPQ3HRZQRsBMNAtx2JY1MXfhGFTpKFDzxhpd8bCUyZsSEi0GVz+CbnSqc0GSu/qJ/c/OQRoMiXtQJ0DQMYk7ZRF8MwgB8/l9FwvyOADuaIwi2XELyRj9KY26+YwkIqpFnuXK97G/Kbv8qLgtyhZ61QdmhrLejLyCM+KWjR+jO/fJ8fklr/hOSCLPXBDfOf7ySsyYtx9ZFyf2AN1klSScxmNtNMDKRD3ybiHwXWEaowEQ4bpA2kxM0qqaV6NRxpjlULOvFOcfKQLKPHE5s0AVoJhhkWJBxv0EXDUc6arAHdtkQBse4PoBFsfivKENrVagMT/EPTtqR3YWDQ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(366004)(346002)(39860400002)(396003)(136003)(451199015)(6486002)(38100700002)(66476007)(52116002)(316002)(6916009)(8676002)(4326008)(66556008)(66946007)(6506007)(36756003)(6666004)(1076003)(478600001)(8936002)(5660300002)(54906003)(41300700001)(86362001)(44832011)(2906002)(38350700002)(6512007)(26005)(186003)(2616005)(83380400001)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AHDIlKJXdX3bHQWEGge2roMHAEt2SU8Ygp8si+5cU8M8IKUqGnZ2GoOpY3p4?=
 =?us-ascii?Q?Zfqrg4nLDO/7N9OnE6frY5MDbdzGtrN2SUoI5W124IBWv+IjqyL/EAWnZ5lP?=
 =?us-ascii?Q?CR8HH+x6y+TBXrFFA5Hdm/EbKhEbp8avjCdHLqggxZI76mc0RZLRjZfLOSll?=
 =?us-ascii?Q?rZkgcV3JY5UAnmYySnb0S5ziM9rlpKWlL1NPZEznAHSUSHH3gBfASlV56AU+?=
 =?us-ascii?Q?bAW95kitJM240XkTMvgek251BgqNZCQqQcVJAvuw6la0TqMvamDA3Ap1ubkb?=
 =?us-ascii?Q?hkZYdg6z0HyRo+tLrNXbQpU70ZxD0u61a5qWegB8n4x+UF03I3b9G3gpO8tO?=
 =?us-ascii?Q?TX93QAZm19BGkKrURXhhRvIWAMpdx8Ie23fMTadNlpMDuFLb6XIH8X4doDM8?=
 =?us-ascii?Q?C+rRuGqZSHkNCGQyZsPwPApx6DJUZLWDIvl2xNPgOL5/slM6WIeGZb9/xHn7?=
 =?us-ascii?Q?Sg9um6h6eQjug9aitUNDgAvxBe976RA6sKtpkgpomgcw0o1Tef1ax80MUvfJ?=
 =?us-ascii?Q?4r073DKqYixH0ZLhwhJ1mxhNQibu3yYQhJGTEBsOkjoUQqj5XLL/alWJfyB0?=
 =?us-ascii?Q?/s4l55QfQBAddJ+MFmxVe3qCJwvY9HZvfqdaN+abLNA7x3yFcO3UQm0W9kyp?=
 =?us-ascii?Q?A9y55WaK+bifBe70nd/WzMhFRDkhJEgn6JNCbJdTK8bLEEZvzmvjYHVJQV5X?=
 =?us-ascii?Q?2MxTQwfbAQtbGm0E6irmWncQqfCQUtutgN5+5Y2uTSVYBurAEJlHjqE4SUx8?=
 =?us-ascii?Q?YoMtSwdEPv2urrYwkWB4x53TxS8iB2V5PocUZLl4rQTFr+txIUnuAMyGxfEI?=
 =?us-ascii?Q?ImjHRDDGH/ihKQwUFRaEWQirtXVEMTC4/cS0RjzIXZ82PYYoHs/mppPbEl5l?=
 =?us-ascii?Q?2+Lcljv/IrjOY2C0nPX5dVwe7Ony2OVMR++DN9y8ZXcVJ9uuDQZ3QzhQJ4rF?=
 =?us-ascii?Q?PiU5BwNE4fG6JaR2JKBxYVoA8PYvveV5/pog/fDpdxg2Vmtl7Zxyp6VmAV4H?=
 =?us-ascii?Q?eduDOw0sKx8N3dl9UCD27dvZ2qO9M7Q0YtWNgoFmCJhcze/aA3BLLx6agA4o?=
 =?us-ascii?Q?Jme+2Gi8BmabMxCo9BlASU4AeJqWPYQ1+l6LXaVS00mvVa3Bx3ELsP7v5yt4?=
 =?us-ascii?Q?pRtbIZ8iGTgddw3kb/bFdW12gSyXayvhAAxeJEkc/aqoVlc4FdDGlidaEq3g?=
 =?us-ascii?Q?XTntQjWUtq1nh30w1jPxwvvWBxOPbFORY5nxi4HPpU25Hvw1j5Bp2L+3v99y?=
 =?us-ascii?Q?bI1a2zv/Vu4iP5iVLzQC4QirkkqSJT6H1FaeQZ+jeuBAJcoyonIXuNLi57f9?=
 =?us-ascii?Q?YLJJP9dbbyHEUnUznsK8SexWpNjJBLgX+AM4+UXkoufGKUhh5TI5x8biZm05?=
 =?us-ascii?Q?RPni856ERaZIdtGi7ySkr7x8541bO0szDkIPQ1Ew3yUyFBe3/4l4WUxdCtts?=
 =?us-ascii?Q?LS1lKfp+uul/k+rClaPS6hl+jzt+PKVr2UhQEjRhHCBT9Q10wjV8DmJXPyWE?=
 =?us-ascii?Q?BLiTraxf72JAchALj/XYafxEoIfhQYN1BvAh8BjL93v5djQjt/Hch/fnYcoI?=
 =?us-ascii?Q?+NMVMHrVwlK6mdiCt6iM0z4gb0nY6xVRDn1XVPgKxifKxY7udnd8SZuLRdiR?=
 =?us-ascii?Q?2w=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39b03766-2541-4ade-cc07-08da9da6ad67
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2022 21:00:42.7926
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qoN69MQ+k97+WhgSUdmnRE6iRINMRjRL9J5RX6RvYfNMzLWAUMqBWsU6L+ViGQohSTO0EC/Dj627jmhYT4SPgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7863
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We can make the phc2sys helper not only synchronize a PHC to
CLOCK_REALTIME, which is what it currently does, but also CLOCK_REALTIME
to a PHC, which is going to be needed in distributed TSN tests.

Instead of making the complexity of the arguments passed to
phc2sys_start() explode, we can let it figure out the sync direction
automatically, based on ptp4l's port states.

Towards that goal, pass just the path to the desired ptp4l instance's
UNIX domain socket, and remove the $if_name argument (from which it
derives the PHC). Also adapt the one caller from the ocelot psfp.sh
test. In the case of psfp.sh, phc2sys_start is able to properly figure
out that CLOCK_REALTIME is the source clock and swp1's PHC is the
destination, because of the way in which ptp4l_start for the
UDS_ADDRESS_SWP1 was called: with slave_only=false, so it will always
win the BMCA and always become the sync master between itself and $h1.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 tools/testing/selftests/drivers/net/ocelot/psfp.sh | 2 +-
 tools/testing/selftests/net/forwarding/tsn_lib.sh  | 7 ++-----
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/ocelot/psfp.sh b/tools/testing/selftests/drivers/net/ocelot/psfp.sh
index 5a5cee92c665..bed748dde4b0 100755
--- a/tools/testing/selftests/drivers/net/ocelot/psfp.sh
+++ b/tools/testing/selftests/drivers/net/ocelot/psfp.sh
@@ -181,7 +181,7 @@ setup_prepare()
 
 	# Set up swp1 as a master PHC for h1, synchronized to the local
 	# CLOCK_REALTIME.
-	phc2sys_start ${swp1} ${UDS_ADDRESS_SWP1}
+	phc2sys_start ${UDS_ADDRESS_SWP1}
 
 	# Assumption true for LS1028A: h1 and h2 use the same PHC. So by
 	# synchronizing h1 to swp1 via PTP, h2 is also implicitly synchronized
diff --git a/tools/testing/selftests/net/forwarding/tsn_lib.sh b/tools/testing/selftests/net/forwarding/tsn_lib.sh
index 20c2b411ba36..b91bcd8008a9 100644
--- a/tools/testing/selftests/net/forwarding/tsn_lib.sh
+++ b/tools/testing/selftests/net/forwarding/tsn_lib.sh
@@ -22,8 +22,7 @@ fi
 
 phc2sys_start()
 {
-	local if_name=$1
-	local uds_address=$2
+	local uds_address=$1
 	local extra_args=""
 
 	if ! [ -z "${uds_address}" ]; then
@@ -33,9 +32,7 @@ phc2sys_start()
 	phc2sys_log="$(mktemp)"
 
 	chrt -f 10 phc2sys -m \
-		-c ${if_name} \
-		-s CLOCK_REALTIME \
-		-O ${UTC_TAI_OFFSET} \
+		-a -rr \
 		--step_threshold 0.00002 \
 		--first_step_threshold 0.00002 \
 		${extra_args} \
-- 
2.34.1

