Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F131D564598
	for <lists+netdev@lfdr.de>; Sun,  3 Jul 2022 09:37:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbiGCHhL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jul 2022 03:37:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231351AbiGCHhD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jul 2022 03:37:03 -0400
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-eopbgr20088.outbound.protection.outlook.com [40.107.2.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F3089FF4;
        Sun,  3 Jul 2022 00:37:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OjPMsrTZv3TNHdOsW47KzBG4xB4zUfUVRpsxZ+TJPb5YyKY+2Cq8a5QMl3s3//8A90k09aW9EAWLY38UDuikBuDj65FyWX7oVy4SeQRlE4vw03PqsPC8VsnZTzlEWW7Ijglit/1hnjRO40M+cl8yW5RpOJKaISHW9nVEdrSEVCm5vThqU1sEtZlzu5VMJNVfI9fiTwzpTHWwYqS5vKBOsgYQJRFYlzO3xmMb0SaE0f23ef5GFTzeZxYxqb/xG7mBtIp6nin4SGw/w4Qspio+kWBTPm0AkbMrtczKW7lpzjCspTw7NtmUGiB6rNnsClORMUNWKVjbPYMIEqNCmVpL0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CzZDA8KrFHMhyX26+iKwL9mPxZ7aibS3vTUuyU7rt8U=;
 b=TxDr2iwq+Ni+iG7QyZqCU8EpzQ8ZgF/lkcfBBICXmr8DH9gAnaKpHZ5fpl+B8aBXZV2mBoIMRgMzxYrclmUJ20EObtZ3W4jN9VGw8twejdujGr7QD7jlSUNoD+ZOqs3ud0URFDqHOVzMwC9rqmWoXMV7QQThtstUAxx9me1AM7fv6sdk2afs3OiWv3n9Yvqqj6ed8jXYv9CETRz0KrLhGTyf6AUqPRNAkX+k1KzbRJ4bW6vqMDNyQom98OpCLxnRoyrZd8/S4vYrqUvOFLzlh33eqMZ7YeYY0aUMu0zrapD5GYa6FBSSePS4d+V/JAM8xiRazK6EcBemX3HWKrQdRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CzZDA8KrFHMhyX26+iKwL9mPxZ7aibS3vTUuyU7rt8U=;
 b=oLmDImlZ+Qyu1VsT4I3mtCHcDVuZgmK/HtDdVGkQQIInluM0c+X649PEH1qTK20oMfTlGWRN/DU46fLMdBh6E4edCWAsRJzWGCw4QWYu1no3BCk2Z7fogpN6FSzE1y92+YFPRCvwgaj/XHY/D33XdjZ+1wxoxQt94Slxe880P7U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM6PR0402MB3877.eurprd04.prod.outlook.com (2603:10a6:209:1d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.19; Sun, 3 Jul
 2022 07:36:56 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5395.019; Sun, 3 Jul 2022
 07:36:56 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        Petr Machata <petrm@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        linux-kselftest@vger.kernel.org
Subject: [PATCH net 3/3] selftests: forwarding: fix error message in learning_test
Date:   Sun,  3 Jul 2022 10:36:26 +0300
Message-Id: <20220703073626.937785-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220703073626.937785-1-vladimir.oltean@nxp.com>
References: <20220703073626.937785-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0018.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:15::23) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e87ea527-fdfa-4bf3-7a33-08da5cc6ce49
X-MS-TrafficTypeDiagnostic: AM6PR0402MB3877:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KHc20ImQEzsfqO7uiSBJ0NU9H8v9FjDrimFR5fZkhabzT0ADxywl737l1GvXiIsSyiDgg3WBq1Y26SQzxr5IeUMoAZYritD9VUyWy+48qVYg2mOTLzDfGZVgbNclanHwrlq/xXTsRXAWV06mIA+yRh9zdoewxZqBdMxg2coVbKxD3jAEueOj1ftcPrAWfDWKJMEDXWMIENyPgnITk+rig4W1weR/ibd3/fZ2Zp+RmX4OfUNZNU44BY521VBhuniSDyVI3YOgdFUpOEhkw3v1iYjJNuXFZGLONxZoZ/xzxOpG1sO7+6Fw6uJIa6tsKosk39htO5jslBOmksm6++aPZKLlfGXp8UA6bdVbh/Nmiz0h+6WFEHUxXePxtTjdlC4VoCW63gHZHH2ZGmYcZYf7RWBo239DuzvW4KeIJw/j5sdr5IZoTBE76L0PtL0ywPTD05VY6gwCSfjT6ZpTF9LlQ3AxFVibLF37HAHW7h+1WrVyvFERbaWXZLJVhwW8OPv5To3qow9t2oJcdM9JS4AdeOmSOLdyXk090zTMyWHFA5/HHJ9H+DR4GT6izJwXMDxq5Pw7ny6tAOBtPQuLmPiVfyzzeofL/1li125B/SjrMiTzdZy2lfmKs/wLvCt9SMqq5qSBPBPFyzrPcRuT3ze8YwfluJ0lgb6x3RglEy1bJtA/LrYf68LCConFfkiI3TbE1lnetMJwhyZm2aSiuEJiNskgGxFi9VRIiDB44BwaxRrHBLwoTF3l0AKNjn49ZMg8hRSqStQOYkTOCXyWxE4mXQ+u9Ko40NCgvkeETnkKn2jKhUfJhi8cSRn8w/G743J8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(396003)(346002)(376002)(136003)(39860400002)(2616005)(1076003)(5660300002)(8936002)(6916009)(54906003)(4326008)(8676002)(86362001)(316002)(66476007)(66556008)(66946007)(6506007)(41300700001)(6666004)(6512007)(26005)(38100700002)(52116002)(38350700002)(6486002)(478600001)(83380400001)(2906002)(15650500001)(44832011)(36756003)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4dwT+qylElaVubg2RGa5qWKBEPK0hh5P9LWMnkdswlCno4z0CkWrbKCuIAan?=
 =?us-ascii?Q?9zoM2zL7u31BZKOBkrMq5zWiheQeP/o0/LWFl3mLBjlt0wp6DvPfs7sh4rDs?=
 =?us-ascii?Q?qQeUJQ7hk3ZfjcxuUavUYljdBMwdBSReBGE3bAjuo9bwG/rGPxEVRPbigHZt?=
 =?us-ascii?Q?nO1N7f7MaaQ6x39nNy4TZXHBHE9RbvFAXavsR8KI1xNzMxlFJf0iCDAZLZNx?=
 =?us-ascii?Q?V5hR6XMjPNeG3kxUcmmALidgN50PgJS14MFKKxsXCce3SRTq1dcYnsmfufM5?=
 =?us-ascii?Q?AD6JVsYIGGtzZM1iR9GUgJ/cw87/HMNWsfKiIvNXT7zMQZSN6+5Xd12YSujr?=
 =?us-ascii?Q?CBBPNb+2Av4KIt38IzZiecNILKsE5a00h7ZdF+5UqUGCrN5wWTdt2zSkgu1Q?=
 =?us-ascii?Q?ntE97Yb5o8JwPkWuIz3HrANy3bm6HvRdt329+CxaK14j70rzWD0xg5lvz5uY?=
 =?us-ascii?Q?Cj/Z8tWeL5BHmqj7fa4t/Bp6Bp62D3OvHdtcJBXm8bFpbfP/txmz29KIHQVL?=
 =?us-ascii?Q?oyIwPO6rLKZu10H6QoBduwfOkADUoiBc8zuTPWvhfdEtMg7zS07mY6JLQTvG?=
 =?us-ascii?Q?vMWS38SPYv9FIMtoql9Zi+YkCn0Lg1pg2vxoTeAkrCrRo6PmFYwkGw5kicBZ?=
 =?us-ascii?Q?0G8Mz6IhGQ4odRAD8uKBD/239jc52BCnRzDeoo25gXZm7hM1TkgqC/QTXF5v?=
 =?us-ascii?Q?n7FdFEG5NZP+rV5rYD9i5GJCRhCurExK3sCWjWqTp72JaUT5aBFpZAMctQ1j?=
 =?us-ascii?Q?0DACL6f/TAba0HZZhIhJtkrl6XdcXYPE5Eb9HA2xYJze65MxQB1dPtzuRJ3C?=
 =?us-ascii?Q?CCpqUrbYSO608uRuSLNUgIr0lu3Wl4CZBIibAMgpZp7XfnuWv+lVbi53ziu5?=
 =?us-ascii?Q?0apX5BO9sBPw2R+TXuFBwjEYV5/ZF9daRZz6nZUTrfx6BmQtkIvR3gj2nOPx?=
 =?us-ascii?Q?7WlE4PFbKFBTIZpIkZn40Zt7LSQ3H1OH3Q4ACRgdMXFlKJjKQDMh/Co/ZdcE?=
 =?us-ascii?Q?sb5+qrZDmSHi9vTvLU1DarK0xi5AzFUUrr/SkoTf0iHwWWaOLdnxoDqI001U?=
 =?us-ascii?Q?3cYNE+8l9LyII2XIuGCva64DAC4+GiUvhydSuxsaSRyBdg5aibE8wIGLa3xk?=
 =?us-ascii?Q?UT04cNUvMAEWeZKVP3Rv7SDdX96gdyDMOjK2/ImZd9HJ7Rv5UtkmDb2Q3hFj?=
 =?us-ascii?Q?/F0j8IIxcCvUKZgaU1+oGjdigDamddrAtOVOF4x0GRokex3rGEQcfPCjhdi7?=
 =?us-ascii?Q?70nZXYx48xQcSHsd2iwalE6tELMSWlokEaGUbEAafBq7nwz2bUqWGnNxVomg?=
 =?us-ascii?Q?UcoDuHjJAf2xEGNEdoruXzZPeu1v+Mck7JkddWo9AwDaP6NsG3w4OCyhKdZt?=
 =?us-ascii?Q?99kuXlqnZAP3GYbtKlTMCrxSK9Xln8ZBEyBmJJ+W6Lao2Nmmo4jSDbzdS91i?=
 =?us-ascii?Q?lIg3hAKwoBNfHVet1eGT5t5wcOLWIH/G4RDcBVUhetC1ogLPUPqmW9+dOdUB?=
 =?us-ascii?Q?agVAVbh8/AJ/G5tzvAeLnicM8KaN4PlUZJ6s7aqNSwtHuw7mSvixndAifBwh?=
 =?us-ascii?Q?ODcZpwlzXFW4iAesS0r4d7JrM07Ii5yvDluCPvXCBLC791jTIK+2lP4fRSMw?=
 =?us-ascii?Q?1g=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e87ea527-fdfa-4bf3-7a33-08da5cc6ce49
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2022 07:36:56.2423
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IDoNhDuWlnOb0Slio5sXKNWP1QCYQ/xlwXpewSaelEFjpslnYPI+Ec5k/hfMDzfidVSlHj4llGOJ8FtztKDg0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3877
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When packets are not received, they aren't received on $host1_if, so the
message talking about the second host not receiving them is incorrect.
Fix it.

Fixes: d4deb01467ec ("selftests: forwarding: Add a test for FDB learning")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 tools/testing/selftests/net/forwarding/lib.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/forwarding/lib.sh b/tools/testing/selftests/net/forwarding/lib.sh
index 26ba8b5d264a..3ffb9d6c0950 100755
--- a/tools/testing/selftests/net/forwarding/lib.sh
+++ b/tools/testing/selftests/net/forwarding/lib.sh
@@ -1251,7 +1251,7 @@ learning_test()
 	tc -j -s filter show dev $host1_if ingress \
 		| jq -e ".[] | select(.options.handle == 101) \
 		| select(.options.actions[0].stats.packets == 1)" &> /dev/null
-	check_fail $? "Packet reached second host when should not"
+	check_fail $? "Packet reached first host when should not"
 
 	$MZ $host1_if -c 1 -p 64 -a $mac -t ip -q
 	sleep 1
-- 
2.25.1

