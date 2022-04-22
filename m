Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C59EE50B4CE
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 12:16:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245455AbiDVKTA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 06:19:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1446470AbiDVKSe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 06:18:34 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70049.outbound.protection.outlook.com [40.107.7.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 070DD35AB6
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 03:15:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GGL6ZYv4QRTnwFChhoZo2wf0As2tcdfCH8d2P+zZeHcJNUwMIq+tSjquiIG7tW7xGLkMwoavA2TSW7W0rFMR7b2VegHSiMEoLspI/djzrYYDouHCfQV+IgdbEJ4fWlG4NZislJybCM8vDG7VCQ6sjEh1LNuSn+rJ8TJt4zUvuN19kuteyMX1mtRO+b3e5AUCGGmWfS/diVsOCJxyE/qPVyel1VrWK4Rpwzn+bdq5NaZiqc18F7mclR8NoKmjgJtEH58mU3mdGk8DhrwmzNsqjVZYuTNfjC3LaXBHa2keROsuTWFL3jMbQvtXHMyaZbaeOIu+TtQ4RxWvPkPOj3yIkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=juwRL/b4qn8r3Plx4wvLAOCeAgppCd42xd12YwekAzo=;
 b=gV+FtV1VJpRg9J9Zp8ZNWBZ+CaN2U8osWos74yw43kKJEZ/yYhTKEY75ZgoAgb8j5BuJDRGH32xKWfNZcfEHOgkOEk7kl5rE/53WE0yavXbSlvIbeAkGbMM7nB50KVSrXez2eYESnEmzLAogDvNbPqjJo7m6VnjFpGVAoZKUGfmhZDskM+y5dqrChricYh276SRw0r5707oddydIaCpp/0qKLrKbgQtJgRGqQrE5bye3iPd7Lug6nkolKiW+C9MkKpEs9zO6rsbQVvZz0z18tdgDxC6nWLuh94rzEx85wUIekQKxW13zugRanWXbMPlTFpRl22woYANEw/cQgp/hdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=juwRL/b4qn8r3Plx4wvLAOCeAgppCd42xd12YwekAzo=;
 b=mmmKQ4dTNSDsw+tqltY8IHtBwbmx25qyiu5a7anVxW03vfDxC+AxqUbp/Qiw5MYcCrTM4rmu6Qb3guMNiXUZcPwz86romEdX5SHbPjf/11gC7HEI06Ol49ZlqTAp6MF1ayJG48B8QE4LeSMAz/DeYkhCQDCxHHHZI+JWTA0CNFA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3856.eurprd04.prod.outlook.com (2603:10a6:803:21::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Fri, 22 Apr
 2022 10:15:27 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e%3]) with mapi id 15.20.5164.025; Fri, 22 Apr 2022
 10:15:27 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Mattias Forsblad <mattias.forsblad@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Joachim Wiberg <troglobit@gmail.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH net-next 8/8] selftests: drivers: dsa: add a subset of forwarding selftests
Date:   Fri, 22 Apr 2022 13:15:04 +0300
Message-Id: <20220422101504.3729309-9-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220422101504.3729309-1-vladimir.oltean@nxp.com>
References: <20220422101504.3729309-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P195CA0057.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:802:5a::46) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a8ff6283-b9a7-4a76-e0e1-08da24490571
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3856:EE_
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3856F3A49BD83B872241A3FFE0F79@VI1PR0402MB3856.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: irSu3dZAINRsPUZX1kMo0lF/3lIewb1DZXI77OcCSupmNQgBRXeJLAWPUdZvwPCC+AIGyrcZCAk2yYdCrDqR2eqyC/OPrkNHx9kTavlxfc21O3gNg12Of8AfiDR1qpHWUwmoHbbv6brWHkKQnUQAJSLaALZtFjHGIeIPUrAfB5Ffn6d18wZPh++iNUHABkYwMfme5OFDDh50KpTcEqhyKlPzl6ds+5axCEzk0doPLRr9zE9vVHulvZ0E3QBfUXJA26a82zznQfusnsPkW/8yK2PXOEZLiIU/WToldrp5LPgh+V6faEWJqTIpJMYHFOjwkM7T01oNCr/ti7UWISW+H4pH9rIxNaTzVPgeVX2uDPSm5+qrh7eWGxZozfeuRINaH0aTxo5rFu8iSxNTC70wBzbhx+Udlqk07ycgZ38qvug+Ck/1bWDwrH4Yg43U8lXtCqDQx5P5YlAeDMZT2Etc4D950p1e6YDxInaJFWvPlMEE/iPTSQbLEVwFlYhUz1P+GZtuER3wjaqFTHboT0jb1xS2yWxMrdcCXF/Dv74gwBC+utd9h8qUx8W1++xZW+OK4DC26S94u0VBkNMOmoRkknwkMSkBSXLN/OAFRxdMVNawDO+8V8Id4C8DF9vREfuWDBtlxwzBwmovQN3yE2/i2iS/MIWdCjCpe91N+c0dlNQ1sqq6MYlb2w3Uv0lMf08OD1Q8PPyqV84uHYfuTmVIgA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6506007)(5660300002)(36756003)(86362001)(52116002)(8936002)(2616005)(6666004)(6486002)(508600001)(1076003)(186003)(44832011)(26005)(38100700002)(6512007)(83380400001)(2906002)(316002)(38350700002)(6916009)(66556008)(66476007)(54906003)(66946007)(7416002)(8676002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IWj4o/SwV+lDxT6YmFm9m/3L0GFdrTongJYmAvW2D4qi8YHdj00DSY9ekeTZ?=
 =?us-ascii?Q?ZbdpgEV3E4LY5tI8twnpkv1DGYnkeeMQKhkQVPpVo0c3scJqsgoviJ8H5on8?=
 =?us-ascii?Q?7tb4CcXKFRpLoYafLbgiXTYUiGlk9/VTk3TsdQgiGr6YXRU+fjpJ2XkjHFlQ?=
 =?us-ascii?Q?GnfjbusVcWZoCGjwnrhpiiMJt2mp4YVx1TKDQisaxBwlyaUemD67VXKImATF?=
 =?us-ascii?Q?7WFQlzhtcDMdYRlMMbpdJZQ3QsOiItThNZNTEFsb9/eKdoKjua54wTSrDHgP?=
 =?us-ascii?Q?Mw+5+ZF9eVq4bRP5+NuzEEFkOaGI5VXQZu2Lj4lutHf6vMmDZbVNc2zzWaCq?=
 =?us-ascii?Q?ybkxg345Ip5Xwrqsr9yIyN7HjqBf8HoQrY5Jnguoz/XDCIZV940D77QCisAU?=
 =?us-ascii?Q?4FPPcGkU28BeydMD3NEatD77gU2VffGOM3St4pM5e8y9AXLTw1ZEVFo4HbSA?=
 =?us-ascii?Q?UapW1Zh8IkoLL5Bf6iCXQLBw2EFFEUlAsv1ZecucxWZQSAtIGU2T+KOJDIPz?=
 =?us-ascii?Q?fXv3gc4HlRa/PabM84GWn+9jaHsREDJkjNcuOPgkJoMoJqyLQiyWnnufrtwu?=
 =?us-ascii?Q?/d2vwvWc/VA/+CxVAazUGOTiXrMQZJ842sXTTeTlZ/WRSVq+jEyoc6Xb1xVs?=
 =?us-ascii?Q?vRiaTEdzjgcdH0MEMR37Z2LO5G8gY7o2BhqIKihMSPQP/7K6AxIwb30yFzAQ?=
 =?us-ascii?Q?y433GSg3N5PbYFn2TVZUsUhrVNShXhlD43iEm84v/bTNd1fiQ829CLU1G+EN?=
 =?us-ascii?Q?/AjVvTjzgDjZuA6OqdWxxQFpN+D+Tj/UWpvE9NnZuuD7QVUF0Co3ma1vp2XZ?=
 =?us-ascii?Q?xnG0+V6RaEeUKucbBeoknHZS8dbcNs9gVzL7gV0iblLQlq3MDlSIEnNpR0iD?=
 =?us-ascii?Q?LEq79hN314Qys4tqpUjT0/7Y88ohYpsO1YNTQ5nebvDL2jzmSewUaWzm2pmL?=
 =?us-ascii?Q?lg8Pur22UGoWhgF/EOKod0Wx15moZdBpsMEpFIe4hDpaWqyzqgz+CZVJvGzU?=
 =?us-ascii?Q?rHJrLKARy979Ulu5Aeam56SA1cfssHVLCOMe4kdKG3EP5uOs8DVJNdouA1RE?=
 =?us-ascii?Q?5GROB3KFbujtySTC1M8nuc084IEBKGFEpsBTRdUfN1vyWQodgEo5cv315RQq?=
 =?us-ascii?Q?e9jJfMAlrvduRwFKN9i6GYWhb0MJgYit/YJbugKgGPoic2lQWb2SQtBc+yyq?=
 =?us-ascii?Q?aks0Keqi3leviwgu54bGIKagA3Z/e4lNPkv4GjqylC4ftPwKuV7UGKkzToWg?=
 =?us-ascii?Q?KiGCVknjU4MV83rt5S5FnGDsA7Xw4j3bHOJWbA5LAj2g85xxL+gOqR7l6XTF?=
 =?us-ascii?Q?6biGobqFg1Hteg6WNpoJQTCiKiC2sZo55j9sOqjiHESWr3Nabw6T8OgOZAEV?=
 =?us-ascii?Q?xewOBytGTpIwoQrb2TOpkw6UypdIlRMT1V6+sx3aV99hp9U3KotFRpULt6iC?=
 =?us-ascii?Q?JDsym4I9x/CWoK1113kVmRkcgtE7tYvZaLxRVo+4Qny71shrwBg91npmC9gu?=
 =?us-ascii?Q?cmQwJACGnWUKKVZHjwtEPcz9oW12lYvtBafGHW/ax95f5NuFqQZECfhHYETf?=
 =?us-ascii?Q?TUt8my9HqE+YLKo1CPQ8pgUKUZJjhG4TD2d1KIRHt0Ap14JwslEuj8g/DhvQ?=
 =?us-ascii?Q?PWavh7/yAZw9PVOWw/5kkz5bvuQ63BBWOPJg0yBi2FKVTQZnuJoUWQxCMQjo?=
 =?us-ascii?Q?05Vr+Qkf1mdegO6RYiMp8vegIF6fmQDBzHypq8YK4fuefFE0/dkemu4p5G8F?=
 =?us-ascii?Q?zA5RIqDhOEflgdH5ahJLOUQT18ZcXFQ=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8ff6283-b9a7-4a76-e0e1-08da24490571
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2022 10:15:27.2189
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1zpIPirDrVEf6GvXsyJgbO1t+1VALMxnwf4i6PBjMG0B32drjo2Ie9VJhGFo18g0pvPvSRG5cgDqYM2Z+Dz4nA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3856
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds an initial subset of forwarding selftests which I considered
to be relevant for DSA drivers, along with a forwarding.config that
makes it easier to run them (disables veth pair creation, makes sure MAC
addresses are unique and stable).

The intention is to request driver writers to run these selftests during
review and make sure that the tests pass, or at least that the problems
are known.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 tools/testing/selftests/drivers/net/dsa/bridge_locked_port.sh  | 1 +
 tools/testing/selftests/drivers/net/dsa/bridge_mdb.sh          | 1 +
 tools/testing/selftests/drivers/net/dsa/bridge_mld.sh          | 1 +
 tools/testing/selftests/drivers/net/dsa/bridge_vlan_aware.sh   | 1 +
 tools/testing/selftests/drivers/net/dsa/bridge_vlan_mcast.sh   | 1 +
 tools/testing/selftests/drivers/net/dsa/bridge_vlan_unaware.sh | 1 +
 tools/testing/selftests/drivers/net/dsa/forwarding.config      | 2 ++
 tools/testing/selftests/drivers/net/dsa/lib.sh                 | 1 +
 tools/testing/selftests/drivers/net/dsa/local_termination.sh   | 1 +
 tools/testing/selftests/drivers/net/dsa/no_forwarding.sh       | 1 +
 10 files changed, 11 insertions(+)
 create mode 120000 tools/testing/selftests/drivers/net/dsa/bridge_locked_port.sh
 create mode 120000 tools/testing/selftests/drivers/net/dsa/bridge_mdb.sh
 create mode 120000 tools/testing/selftests/drivers/net/dsa/bridge_mld.sh
 create mode 120000 tools/testing/selftests/drivers/net/dsa/bridge_vlan_aware.sh
 create mode 120000 tools/testing/selftests/drivers/net/dsa/bridge_vlan_mcast.sh
 create mode 120000 tools/testing/selftests/drivers/net/dsa/bridge_vlan_unaware.sh
 create mode 100644 tools/testing/selftests/drivers/net/dsa/forwarding.config
 create mode 120000 tools/testing/selftests/drivers/net/dsa/lib.sh
 create mode 120000 tools/testing/selftests/drivers/net/dsa/local_termination.sh
 create mode 120000 tools/testing/selftests/drivers/net/dsa/no_forwarding.sh

diff --git a/tools/testing/selftests/drivers/net/dsa/bridge_locked_port.sh b/tools/testing/selftests/drivers/net/dsa/bridge_locked_port.sh
new file mode 120000
index 000000000000..f5eb940c4c7c
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/dsa/bridge_locked_port.sh
@@ -0,0 +1 @@
+../../../net/forwarding/bridge_locked_port.sh
\ No newline at end of file
diff --git a/tools/testing/selftests/drivers/net/dsa/bridge_mdb.sh b/tools/testing/selftests/drivers/net/dsa/bridge_mdb.sh
new file mode 120000
index 000000000000..76492da525f7
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/dsa/bridge_mdb.sh
@@ -0,0 +1 @@
+../../../net/forwarding/bridge_mdb.sh
\ No newline at end of file
diff --git a/tools/testing/selftests/drivers/net/dsa/bridge_mld.sh b/tools/testing/selftests/drivers/net/dsa/bridge_mld.sh
new file mode 120000
index 000000000000..81a7e0df0474
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/dsa/bridge_mld.sh
@@ -0,0 +1 @@
+../../../net/forwarding/bridge_mld.sh
\ No newline at end of file
diff --git a/tools/testing/selftests/drivers/net/dsa/bridge_vlan_aware.sh b/tools/testing/selftests/drivers/net/dsa/bridge_vlan_aware.sh
new file mode 120000
index 000000000000..9831ed74376a
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/dsa/bridge_vlan_aware.sh
@@ -0,0 +1 @@
+../../../net/forwarding/bridge_vlan_aware.sh
\ No newline at end of file
diff --git a/tools/testing/selftests/drivers/net/dsa/bridge_vlan_mcast.sh b/tools/testing/selftests/drivers/net/dsa/bridge_vlan_mcast.sh
new file mode 120000
index 000000000000..7f3c3f0bf719
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/dsa/bridge_vlan_mcast.sh
@@ -0,0 +1 @@
+../../../net/forwarding/bridge_vlan_mcast.sh
\ No newline at end of file
diff --git a/tools/testing/selftests/drivers/net/dsa/bridge_vlan_unaware.sh b/tools/testing/selftests/drivers/net/dsa/bridge_vlan_unaware.sh
new file mode 120000
index 000000000000..bf1a57e6bde1
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/dsa/bridge_vlan_unaware.sh
@@ -0,0 +1 @@
+../../../net/forwarding/bridge_vlan_unaware.sh
\ No newline at end of file
diff --git a/tools/testing/selftests/drivers/net/dsa/forwarding.config b/tools/testing/selftests/drivers/net/dsa/forwarding.config
new file mode 100644
index 000000000000..7adc1396fae0
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/dsa/forwarding.config
@@ -0,0 +1,2 @@
+NETIF_CREATE=no
+STABLE_MAC_ADDRS=yes
diff --git a/tools/testing/selftests/drivers/net/dsa/lib.sh b/tools/testing/selftests/drivers/net/dsa/lib.sh
new file mode 120000
index 000000000000..39c96828c5ef
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/dsa/lib.sh
@@ -0,0 +1 @@
+../../../net/forwarding/lib.sh
\ No newline at end of file
diff --git a/tools/testing/selftests/drivers/net/dsa/local_termination.sh b/tools/testing/selftests/drivers/net/dsa/local_termination.sh
new file mode 120000
index 000000000000..c08166f84501
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/dsa/local_termination.sh
@@ -0,0 +1 @@
+../../../net/forwarding/local_termination.sh
\ No newline at end of file
diff --git a/tools/testing/selftests/drivers/net/dsa/no_forwarding.sh b/tools/testing/selftests/drivers/net/dsa/no_forwarding.sh
new file mode 120000
index 000000000000..b9757466bc97
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/dsa/no_forwarding.sh
@@ -0,0 +1 @@
+../../../net/forwarding/no_forwarding.sh
\ No newline at end of file
-- 
2.25.1

