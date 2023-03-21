Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A32F36C3234
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 14:02:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230361AbjCUNCk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 09:02:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230337AbjCUNCf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 09:02:35 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2067.outbound.protection.outlook.com [40.107.94.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 694814D42A
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 06:02:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JnSPRXxywg7q9BcVvP9hYxrUU3IcsEIx9PUDtTjsqfc8wovve51tFMr/j3k3+QsPVS1HZDz99XWCtTohf2XpI+1wLB4Ae1st8VG6WcnHqvJWfYCnQO59sU+0FkVgIY1Mer0Z7yUfoWWzPfAg0qygYmvFuAH00v2peeGAofix6g2r+lvH+iAlDZb1neO2IvBNWk8XRZUAiVYBJ1ITxUYDJp81ug6efZhMyqIrGqZ6Pro2EPghFOkAOG9lqdlFiEFHM0bx2U+N9E8QWG7biNSJCgc5dXO8/7nmDYweHDJqTToXZIa/wHcn0AiIsLrgWDYBISocfHl+nzNkZqVKUHhgwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7YHBc0R/PAhxeLJzCnHuoxJ+bzSBHXXLxTT/14zuwp0=;
 b=GKbjPyH13LJ0ZeAhEJzW78d0WML7hexA2Box9gwRZeIe+uKX3KnRbZnmmaDbawkMhGDmw2xo0Sv9grNsJ4ExLia9VRhc23FVgQAJQviCq6i1E1QbRs2I1j/88fbVbKbLHvlsmmYdSgP1d36rCnttxIxktNGbc3IS6e/OXXCNTs68ws00j67a8TT1AFT44ImalDiiZlYWJkgM7EEUs3kYHE+vTLt4rWKJbhs+8oVoKvJvWuhaRpDD6Y196Gh3LuRRPFfEZfTGi+/nOfrJ7b7aciv9aJaMHS6ciWl6fS/PGhktEu/qL4yhh7L8XfESUg60A7iZrrfq46qQo0IXTgHoSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7YHBc0R/PAhxeLJzCnHuoxJ+bzSBHXXLxTT/14zuwp0=;
 b=X3iazbsp2TsBXpCRzc/gI4nrdeU/S5bzB/iVZ+BiFaXSgKtXFAVIuM7SbZqY8iUWVilWBadOZkPHlERzmLIjW+/kqn1oqbPH4smvzmRkoc+YEQrFXETwbbUWdrCUEL+ul8DWVFF9SeLHgmfJ/B49h5Y4weZIavj5Nsg7fh1rzI98YAXoilWBI5YvvN6/8BJFcsARklF+606vbmS4xLS3HwhWXfsGdWA1rtXl1PoK2x/PbKy6Wt60B1VpvLFfm30WIHnJUDF6peXhI8//XErRX32P+ZEcISo5pX7fOv/EQMcxGTe5KHwBD9uDrkJCLMrKRUFTV42XtIu8A1Osj2vyTg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by MW3PR12MB4395.namprd12.prod.outlook.com (2603:10b6:303:5c::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Tue, 21 Mar
 2023 13:02:29 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3%5]) with mapi id 15.20.6178.037; Tue, 21 Mar 2023
 13:02:29 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, razor@blackwall.org,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH iproute2-next 3/7] bridge: mdb: Add UDP destination port support
Date:   Tue, 21 Mar 2023 15:01:23 +0200
Message-Id: <20230321130127.264822-4-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20230321130127.264822-1-idosch@nvidia.com>
References: <20230321130127.264822-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0901CA0105.eurprd09.prod.outlook.com
 (2603:10a6:800:7e::31) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|MW3PR12MB4395:EE_
X-MS-Office365-Filtering-Correlation-Id: 26481924-27cf-4b25-43e6-08db2a0c86ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4K7uIPCuHnQ/JbU0lWJrwBS/YTjPyOvYTvljoQKYkBm9Qvl5qJ33lLpQ5wikaLR3ZXpjtTlPMPGL7+ZAT9byMeSP7vuopZBH0ETFBCymevaCL4YG5J+9C2i6tDpcTpR9Tne8jsW9/ApqSxbHlSzMs4Wq6IPkE4qZ7/b+iKpu+v75y0DvqeZmbos8qdDXjtTzaIwmnn/BumQV+LrXl66YMFO+n6SuDpwAlDCAw0lTMuAIvui5kfQGqrcy48475xKOjkJqzwskfsJhdRX0ROM2kmBmowxIjkDRJbdSYEabftisQq6fKNEXX3Ce67SDzd1mY27XkJc6XJiSisaKLOFCr1s1cs+AlHbkbynV1D6XoGucNAmvpmu0vdVKPmpjuvTnqgIhItgQItX58CdKs39yxog/KgeXASHxo1wcXVnXzWgTKMaYBWWSnOrbG56WAoePI60E2/LJFEVyZFzkrZCWuKbCzl+Yu7ZriJCYIfNhb/zGIbhmTM9I/ElFBllx0OZE/elUnAPVGHOQtWnHIiYy+FUW0T1EcgAITsijj4Jh9LUUNJMD6b+/V0zSSK24vjfKDNN6OpGzSfaSRyey5WzxTbgjFJVPPplpvWlA0jOBWMROMHdsoMdQemYCwMXqGKk85f79oTMIInzoP/UJ4A1Ehw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(366004)(376002)(396003)(39860400002)(136003)(451199018)(2616005)(6486002)(478600001)(6506007)(83380400001)(66574015)(6666004)(107886003)(316002)(66556008)(66946007)(66476007)(8676002)(6916009)(1076003)(186003)(26005)(6512007)(4326008)(41300700001)(5660300002)(8936002)(38100700002)(2906002)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uespgYlKztEkfdP35NuvasX0lSV0Oorysd+ZkfdcMJvK4IHZCtcoc12zHEfZ?=
 =?us-ascii?Q?z0o4/1s61S3+S5sCzDSotMv/zBiOgduiUr6wZAE0d+mKjvxDl004VdWTEg4v?=
 =?us-ascii?Q?8ynvxbGr7N6wO4g2X7nx4KnmtQLiT8aNfBIbwe1budgghEMF8RCN58vdpc+H?=
 =?us-ascii?Q?vnniVucoahIwMVkgVR1y61KKWbhpapbyfaGyRdnpPIYxLiao37BjLAD8oete?=
 =?us-ascii?Q?AiNN7eGh56vFy4bRfIHaoGFoFuqcQpiY3zjnJ/F6kGPLzhrrcscOS4DbFP7A?=
 =?us-ascii?Q?mnSossF1lwAFUv1ogtBzkLguFM/QQplCk0Ja/jC9GmI+bFD9L31fsnTZh1nF?=
 =?us-ascii?Q?Kgw2Y0JnJiac4/NMFgE3ufL/5C4RKRDgb6hrwAqFruEEcpPWh0sCvWkFS4vw?=
 =?us-ascii?Q?H6+diiBueVSBiYdXjDXQ59zF66JC/CXI8rzSe1xphsTGmGVBblZVTKucoXxn?=
 =?us-ascii?Q?j7iO5eopejraXPnas66JBAkry4utHQKudMLZgS1oN7axJ7TL2z4gIncm/Xr+?=
 =?us-ascii?Q?5l1I7yrat1OT0TszE1BAYFWIiP00G5tnm60MaroAk43WVWwW/MKy5vkevAXX?=
 =?us-ascii?Q?xyG+2oAoruYT1e16AEEWb+hteyx8d3F0JMDQl4fk9yB+nML5gTBQ9SJCWzJn?=
 =?us-ascii?Q?LlOdWVP5/ghCFjEtO2Rh762aNYWi1l0RciNF0/pp0J596ZFc0dMzXkGq5YOT?=
 =?us-ascii?Q?yrrigx3MxaDfZcsaofpV0m4LkZYJVULTGjVNGujgwn3VeOavT1VRbzrIhXF4?=
 =?us-ascii?Q?TKcvv+3JPla2c2ByJtL24BSxSK6CKxCj0mh6NlEw/9gb6HfllmUL/k5l1qj/?=
 =?us-ascii?Q?0wB32HxcPuIN/KhhZY63hxQ5slhVfm6a991/Pyanain4A9WcsOSJF5MCXUEH?=
 =?us-ascii?Q?ksNvvxdvQTGr4DmEwRj1fdisO1njTE55j2BBiPDw0y4YTxznW1vstV8ESgF8?=
 =?us-ascii?Q?VTVZ1he7rR00JaTxubYfxn+0T7adHLtHvDt4wrMelmSzmjByTVsLFW09bkaC?=
 =?us-ascii?Q?Zv/BN6/mNzqR1wqCDElSakuXYZHx98s7eANyV3cCnQowa97m/F+wWQuuuYRV?=
 =?us-ascii?Q?a5rJ/01qJzujgO6wwFdKzpwzZrUiyAPd6oCmEZEC4A8bNNy5inR84sKz9ukU?=
 =?us-ascii?Q?PWALOmU2jxcVhaybceEvrwP/yszJTSxiMEr+KPOTmUcFDM+pABJeIxd1moRC?=
 =?us-ascii?Q?ZDKBJlSbHFJr/xy6cQqzWNHG6xwtKy80wH0n7f6YX+19Wu961B8yOFFYcUS1?=
 =?us-ascii?Q?SomlGauFbpR3YKiMKbacMf3Hwm+CSL6H5jGAGf4P2QKOkwSi7ptQSTlUzgQp?=
 =?us-ascii?Q?H6Z2AQ4YXn+AgZkbBOUS5t10jiznGq9YExiere2F+N4v/9nnJNuQ4UnEJsDz?=
 =?us-ascii?Q?UgF4hhC+X1XWfRwf64bXTUqKXFYe+jeH1dCoPKAFlwzoKCpMg0rAc8KygIkQ?=
 =?us-ascii?Q?lRSF4CVlKTLDiOIB3VHL1PynneX7B7mOa3fx+epMSTuC3kIRSdzgBfi+FBOd?=
 =?us-ascii?Q?Pn4v889PUd3Bv6alSblCHugvfHlsXUzR9TJ2mlH6afI7pyC6eZbQZa8KW2Tx?=
 =?us-ascii?Q?ck5OZOew6xPR6EPjlf2OaULGpy44Zt5ZCdXiPHEH?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26481924-27cf-4b25-43e6-08db2a0c86ba
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2023 13:02:29.2635
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TN3+CaXHrbER1INFO42e1WchntO4x3+9uHMIxy6kiyBQltof1i0ojFmrjVQr9j8p4MMBZF3kRi7v+2uAdYhjCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4395
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In a similar fashion to VXLAN FDB entries, allow user space to program
and view the UDP destination port of VXLAN MDB entries. Specifically,
add support for the 'MDBE_ATTR_DST_PORT' and 'MDBA_MDB_EATTR_DST_PORT'
attributes in request and response messages, respectively.

Use the keyword "dst_port" instead of "port" as the latter is already
used to specify the net device associated with the MDB entry.

Example:

 # bridge mdb add dev vxlan0 port vxlan0 grp 239.1.1.1 permanent dst 198.51.100.1 dst_port 1234

 $ bridge -d -s mdb show
 dev vxlan0 port vxlan0 grp 239.1.1.1 permanent filter_mode exclude proto static dst 198.51.100.1 dst_port 1234    0.00

 $ bridge -d -s -j -p mdb show
 [ {
         "mdb": [ {
                 "index": 15,
                 "dev": "vxlan0",
                 "port": "vxlan0",
                 "grp": "239.1.1.1",
                 "state": "permanent",
                 "filter_mode": "exclude",
                 "protocol": "static",
                 "flags": [ ],
                 "dst": "198.51.100.1",
                 "dst_port": 1234,
                 "timer": "   0.00"
             } ],
         "router": {}
     } ]

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 bridge/mdb.c      | 40 ++++++++++++++++++++++++++++++++++++++++
 man/man8/bridge.8 | 10 +++++++++-
 2 files changed, 49 insertions(+), 1 deletion(-)

diff --git a/bridge/mdb.c b/bridge/mdb.c
index 137d509ce764..893488211911 100644
--- a/bridge/mdb.c
+++ b/bridge/mdb.c
@@ -14,6 +14,7 @@
 #include <linux/if_ether.h>
 #include <string.h>
 #include <arpa/inet.h>
+#include <netdb.h>
 
 #include "libnetlink.h"
 #include "utils.h"
@@ -33,6 +34,7 @@ static void usage(void)
 	fprintf(stderr,
 		"Usage: bridge mdb { add | del | replace } dev DEV port PORT grp GROUP [src SOURCE] [permanent | temp] [vid VID]\n"
 		"              [ filter_mode { include | exclude } ] [ source_list SOURCE_LIST ] [ proto PROTO ] [ dst IPADDR ]\n"
+		"              [ dst_port DST_PORT ]\n"
 		"       bridge mdb {show} [ dev DEV ] [ vid VID ]\n");
 	exit(-1);
 }
@@ -258,6 +260,10 @@ static void print_mdb_entry(FILE *f, int ifindex, const struct br_mdb_entry *e,
 	if (tb[MDBA_MDB_EATTR_DST])
 		print_dst(tb[MDBA_MDB_EATTR_DST]);
 
+	if (tb[MDBA_MDB_EATTR_DST_PORT])
+		print_uint(PRINT_ANY, "dst_port", " dst_port %u",
+			   rta_getattr_u16(tb[MDBA_MDB_EATTR_DST_PORT]));
+
 	if (show_stats && tb && tb[MDBA_MDB_EATTR_TIMER]) {
 		__u32 timer = rta_getattr_u32(tb[MDBA_MDB_EATTR_TIMER]);
 
@@ -607,6 +613,29 @@ static int mdb_parse_dst(struct nlmsghdr *n, int maxlen, const char *dst)
 	return -1;
 }
 
+static int mdb_parse_dst_port(struct nlmsghdr *n, int maxlen,
+			      const char *dst_port)
+{
+	unsigned long port;
+	char *endptr;
+
+	port = strtoul(dst_port, &endptr, 0);
+	if (endptr && *endptr) {
+		struct servent *pse;
+
+		pse = getservbyname(dst_port, "udp");
+		if (!pse)
+			return -1;
+		port = ntohs(pse->s_port);
+	} else if (port > USHRT_MAX) {
+		return -1;
+	}
+
+	addattr16(n, maxlen, MDBE_ATTR_DST_PORT, port);
+
+	return 0;
+}
+
 static int mdb_modify(int cmd, int flags, int argc, char **argv)
 {
 	struct {
@@ -621,6 +650,7 @@ static int mdb_modify(int cmd, int flags, int argc, char **argv)
 	};
 	char *d = NULL, *p = NULL, *grp = NULL, *src = NULL, *mode = NULL;
 	char *src_list = NULL, *proto = NULL, *dst = NULL;
+	char *dst_port = NULL;
 	struct br_mdb_entry entry = {};
 	bool set_attrs = false;
 	short vid = 0;
@@ -663,6 +693,10 @@ static int mdb_modify(int cmd, int flags, int argc, char **argv)
 			NEXT_ARG();
 			dst = *argv;
 			set_attrs = true;
+		} else if (strcmp(*argv, "dst_port") == 0) {
+			NEXT_ARG();
+			dst_port = *argv;
+			set_attrs = true;
 		} else {
 			if (matches(*argv, "help") == 0)
 				usage();
@@ -722,6 +756,12 @@ static int mdb_modify(int cmd, int flags, int argc, char **argv)
 			return -1;
 		}
 
+		if (dst_port && mdb_parse_dst_port(&req.n, sizeof(req),
+						   dst_port)) {
+			fprintf(stderr, "Invalid destination port \"%s\"\n", dst_port);
+			return -1;
+		}
+
 		addattr_nest_end(&req.n, nest);
 	}
 
diff --git a/man/man8/bridge.8 b/man/man8/bridge.8
index 2f8500af1f02..9385aba0ee68 100644
--- a/man/man8/bridge.8
+++ b/man/man8/bridge.8
@@ -147,7 +147,9 @@ bridge \- show / manipulate bridge addresses and devices
 .B proto
 .IR PROTO " ] [ "
 .B dst
-.IR IPADDR " ]
+.IR IPADDR " ] [ "
+.B dst_port
+.IR DST_PORT " ]
 
 .ti -8
 .BR "bridge mdb show" " [ "
@@ -982,6 +984,12 @@ is of type VXLAN.
 the IP address of the destination
 VXLAN tunnel endpoint where the multicast receivers reside.
 
+.TP
+.BI dst_port " DST_PORT"
+the UDP destination port number to use to connect to the remote VXLAN tunnel
+endpoint. If omitted, the value specified at VXLAN device creation will be
+used.
+
 .in -8
 .SS bridge mdb delete - delete a multicast group database entry
 This command removes an existing mdb entry.
-- 
2.37.3

