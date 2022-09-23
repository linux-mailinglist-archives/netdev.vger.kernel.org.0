Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4EE25E8480
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 23:02:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232100AbiIWVAx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 17:00:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231160AbiIWVAq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 17:00:46 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2041.outbound.protection.outlook.com [40.107.21.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB8E2109634;
        Fri, 23 Sep 2022 14:00:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kK5d1xMLQY+Zn3yxYdUkeyI4fd58BtATz4quizlK+/hQnPigpMjpRmGQC5NmyDmAKcWD3x2QGwBH7+a7HW4He3byPbKqullonwIhWE0JDugUGA4YGHv9SS/KxLh9nd0ebQxIargqnDDieV0Lo5DYzXwEsFlGT7TO/jfVds5RSKtvfUDbyl6zBHbIKWjzhK/TygPTnwu4k9hk0MKqDifgKGsjGBouOPWwohSDXCEM8/EwqkuDaXHtZpI0USoirHPgGRSAfkC03EQbozgY6quaG1Ry14eQmVW1J+lBpEUUppDu/z5wJCaGCcCEz9vWLLbI+3uuCaROCAckgN4U902MkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uam/3T3/50/z/8v91n0dbEBvvU607MfNHi2z6Umk/wI=;
 b=VskDl50aTIavk/pfcMWsIei6S8fjztAiy9mfa3lBv0EbWQ6Hco27YzllTUEOZIODTUZ8Vae6lJU0KIwXHtJ6fo7DFbojZf3/J8zNNIV7YizSvpwsWpNVr6t5wEWSiJCAqbQsBAan+rPy/vGoiiYEb2prEOrdQBmUWZvOgJaJL7PqV6qAcDcfUhH35gNuQiPBvLdncXjY0RQ0z7pWA69DRLkMFojZbWc7Z6Jiy3YBiIpZDprIpPQEcLDT00FhN1paRNPQEmSGQb3zeV0EL2rkfp4hFsIy5zRUWXxNFcK689xw4h/W91e9iGOXqZ4XcYFWbYux5hr0PBIU1ja/W+v+fA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uam/3T3/50/z/8v91n0dbEBvvU607MfNHi2z6Umk/wI=;
 b=sYPeMe2q0akxaqjyV7+OVAFF6JHF6o+/nAlsAEsdJs4qfcT/PTLz4GeHbjIfPOIBS5JFMBJmeN/fsgQwtq3eZXgWyfB0Zz8Mq2A99byIjGNzrDwDksMw+wHASVcU/yxqGj5EaDYYu2atIHuhDHk3pg+r8dzLmGn1uHnIe0meufk=
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
Date:   Sat, 24 Sep 2022 00:00:15 +0300
Message-Id: <20220923210016.3406301-5-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 709e8d32-0885-4585-ad14-08da9da6ace4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2irx0vAv+J5mrUpaHcCGylejuehYvDQASvul5zYuhEeHjOhlPhzsltXUlryXp2QbHcJA2Zayl2iGzcxX+MgJO39bdO1S3iq+d3W36HQOPwzMyhQfFGijL/E110cd0mtJsy/JmrYv7QJZpSIF0cYYOslaqvLkHWQKoQY5R7zs/OCV92fribD2QyZZzexhZ8bp5osUJunq1kx4/alssB2HUDfNlWguQyyaYk5SArapBpVqTI8ejtwSuxiPN6KVBt66WNw5MnxcOOMM+jolf9D8IXT4gus0t+7QbzgLWcEcHE+GiJqOHh+mw++rn3gJD3k6Aqex2VsG9Kk8LZd0bZkVzDfEKv6HU/Dp+iedlT/Zs054J7I9nvdOsG3kR25GwK4hJ4F3FBUHgU4KklUWMMKnjGMV++fepB0jA2oAH7Ln+dwy9m7WyOM1CiF/wddn4f59BMidXVOhWbdD47sdjCQSddqPC0zwC3PX17mlAdiNFN5qy+opYuxKQup8zU8Bh4bnoktWbDmGNBt6gzPrDdvhyzyH/gSlFugRgfQFzTW5HYlikU8dx/yPNNLd2TVnwvjh3IZ7+q3JjyUjlLRZ9POUQ+w3ZHiEPXgvLD/7STDBbU1fLnaAFwwMApckZ0BDsaQHcNM2tJF2oqSF9/pS2mx6MJ7oILqFOFdWTYSsf2RPKpGXxWxL4sKi8JsYjAtPa6Uobr4NAjbmaoSetGhMTVrq6iPg6HTvTS0JKf+d5FJxvqobdsSAruwmDzqX7dV+jNEc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(366004)(346002)(39860400002)(396003)(136003)(451199015)(6486002)(38100700002)(66476007)(52116002)(316002)(6916009)(8676002)(4326008)(66556008)(66946007)(6506007)(36756003)(6666004)(1076003)(478600001)(8936002)(5660300002)(54906003)(41300700001)(86362001)(44832011)(2906002)(38350700002)(6512007)(26005)(186003)(2616005)(83380400001)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AlT6Kp8KBQ/cbpoaG06gr5SX3Zw8e15oolb3AuVutbF1Qdxtoh1RVRH3NOkY?=
 =?us-ascii?Q?Giwnu6Ds6jaWI9vh3yXnQGx5PazU5l4BpIkDSYI/3+sDnMCR9WenOR0/F0/n?=
 =?us-ascii?Q?OsjTrsUd/Y0E1N5ZVauhkyZJ0fz3KSeiBilpNmvzrLFGMxi4kEXPCc8GXFlz?=
 =?us-ascii?Q?izcD/lvWAYnZF19kHVqZfqUQiDPkJTEFpw/YOZQ4wn5fBVy265IzNOMSskzM?=
 =?us-ascii?Q?inUlhNgw0jyAG1SzFTpjS25JW46ZzUkmSQGapksjS9bxZzyQ3dDYmSikOsjo?=
 =?us-ascii?Q?8iayL/E8TfDcYUffWgVE0VAuVN3e3UE348AqYUE39DmEWWS5ZYZaAugBkAZG?=
 =?us-ascii?Q?VziBkhLYZqEUpfTXHF3M1/nmTbd9PkXysiDBi/ZOWFmZo8g2B0hzHzfl6LJW?=
 =?us-ascii?Q?ECIkdBYPImQzD7QV/lTDEGetJndJ2AQutq6OCQeKBnkSejoLblBODNANdhb2?=
 =?us-ascii?Q?80cfdwjBO6Roh7F0/A6rN7D/kySrH4gUVeLHEk0i46keOV4uAaRnUaq7tIhc?=
 =?us-ascii?Q?phXJp0ffvht0WHdkaDgocrucgtYLabPC9uh4Y8VPp5EM+xo2rKgBFtbI6FNv?=
 =?us-ascii?Q?FW2ZVT1+MPu2V01G9JAw/lFv+3CsCxSWqU4AagBcgwEwMX4jQTybvAzOuHuq?=
 =?us-ascii?Q?cJscTU81C6HexnqcEDJy1brnBqCWfWEJduMHsU2yCDYfAlE+DNPR9/hSsies?=
 =?us-ascii?Q?E13SFWJDm7EkCJv3rMsiY3ZrnMRmidqS4VPr/JUXVin+BH8ADd8U/8VQC+uc?=
 =?us-ascii?Q?PEPmdiCEpprnXUJLczUOtVCn0URwaYGdj4YcZ8x2VI8aF+uramooevSe8Wq7?=
 =?us-ascii?Q?cw8hp6VUlYcJ6khzQ26JFGu/ISBU+L+YlCyNdCYqg//yiH+SNLytA0eDj+cJ?=
 =?us-ascii?Q?BchMlWwHBteRb8RryZokEB8LFXlcj5bLBDltFO31rj6gmR6fUmL0myMX6+8e?=
 =?us-ascii?Q?fXOH2+gyF759P20xlLO4QM6A0z4DA7AXLn7FOuxfBPq9cYUVSGjQh65htDIO?=
 =?us-ascii?Q?exrSgBjIOYb4GPr8UZ9AFYk+Hw2FnaDZkQMSwMyaIlWlTZxpyZg20b7RhgI8?=
 =?us-ascii?Q?TWHX4sif6Ec3j4ybV+kmYquKfITnyHRX5sH8kbWZ6/NUPE6awP8Sxhj/cdkf?=
 =?us-ascii?Q?z5G1yWnD6GHdD5j1hEJisJgjKC5VJ3ThwdJkUUWpjzK94p1OWf2OKm3CWPCE?=
 =?us-ascii?Q?CJOR29R3iGuR2n3+SzpJXTTdVRKq4Ott0fC/Kd3qNs3S/508WF7Zg7hszlR9?=
 =?us-ascii?Q?jjFUbiJeDTnXyAt23cy+uD3V4Up5/nJdV/X3h/cCSziVUKn5VsHALD8PtJgk?=
 =?us-ascii?Q?p02s+IJX8WBzDNrf7D33GI+h1GJ5xWkkbxYM9hwa7do1Qm3aeccBxu2fzKa4?=
 =?us-ascii?Q?FRPNTVwOtJh+Ne4JtsIh5IbfazJCcSlZ68Tyji0btTdN1V9S8QCcsWzmy8+X?=
 =?us-ascii?Q?SW1MSOkIvu0r9xd2fTObGk0oNN8dQMAI/6QKg1tUNW6xc4i6fEE3lEDCGs3o?=
 =?us-ascii?Q?dBiA7bPunJxFjKpRke9Laio8A6EVIEUzH0X416OCf7G+iOkyiZU0D6QNoOrl?=
 =?us-ascii?Q?GU7KJG+zn76Lq8EQ64BB1PTfENF62fDKeUOBsDYIDxyktUsTsELmM4pzgqgz?=
 =?us-ascii?Q?Hw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 709e8d32-0885-4585-ad14-08da9da6ace4
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2022 21:00:41.9489
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WehLZohwmfwpQ/IP6Iflki5jVbTYx/noHLdh3zhqCgmK1kL1Da4aqiguvMezw9BQmIRk88Oo0bVSiQAZ+0sgbw==
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

