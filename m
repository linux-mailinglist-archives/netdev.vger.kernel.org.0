Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE6676C3238
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 14:03:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbjCUNDR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 09:03:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229821AbjCUNDP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 09:03:15 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2044.outbound.protection.outlook.com [40.107.212.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A8F74D601
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 06:02:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jVjsPuR8qVwWevfxzhtFvkGLU6rEe4WOExJn6axiaR434aqerjVU3qm1PyEG090lsgBW+O5Db8iopK5EBOU+EQP3ulKvQQsgS/NA+j1pk26FA7FrS+gUISyyJW8BZMnefbNBW6H2jXu8VlQziNLL2c8a1/aYmGe/ITlZ8rJDcG42UUdWk0jjMwepZ0AIq1pXPRLSroKnm6A3hlLLdQvgoHPSzyO6pjEyNrMzC288sIQmE0c7d6I73SYmV2u3tBPoYkbB+kZQxtAdD5qOXsWxwDuhGBDkKmFq45l7iQqs/lfxidyhfwWSq9Y8rOYAKNR0MGlM3h9j0VJENRI7nJCVyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LMObLNYt7KIqPTQ9BJGNyHvBs5hcvycavJraSfHa/l0=;
 b=ht9W1RKDC0Kx+SRc/wDjbW8sHHwARZkH67DHkP/1/VVvBeqm2RL2OhPPVN+rMxrngmVqUvIONXa0VEBsc9zViKfefeiNzl+UKV9+3GbKYn4ElLe8n8y3nCs9mpd3ldiWBx8hbafFeEOhUAuqQIsiR8nSTl6VrC3nenJE3U8OTLaZOWl4hlAGVzHZkNx7U51Fe9STpFq/rHbYfmNvfcNQOcNpFKlJeug7HzET9gG29sJNCVtqLkL/9FK1AKybMny+OJKZYzf+92dX0+g8GrWLnSRdDXXpKb0fkeu5poNRvfkmJmDE6YWryuOAoo4+yrDq3P6QLH4yhAZJqwZ6p6SAVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LMObLNYt7KIqPTQ9BJGNyHvBs5hcvycavJraSfHa/l0=;
 b=qugBhSBgOsob+m7/FD4KiwBeYw9WQZIPe89Ga7LRZ9KWLcnnP089u2IJb6YRnsSfOeak44UQrFqoJIpSAGP24BUHnsuAyQLOVlE2xwnXeKnST0eW1zz2bKSP7c0xT1IG5VNGo3YPAUwfK/D6buiTLce4zIDUpireDo6fEbDiBAkP2NyyTnn01zIjFUerH/jRTQfKLOg79M1EnFmK7or1zl/9cyNtZB3o6LTh5AZK8XUD/mI/hys6TKbhPx2oZR6TOa5HChjevgEQPW1Ee+1CV411jCV3MJZKZb6fcOvmzVHjpjjUft0MG+MXW5a17nIuQdOaG12grge5V47O8QuyKA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DM8PR12MB5478.namprd12.prod.outlook.com (2603:10b6:8:29::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Tue, 21 Mar
 2023 13:02:50 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3%5]) with mapi id 15.20.6178.037; Tue, 21 Mar 2023
 13:02:50 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, razor@blackwall.org,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH iproute2-next 6/7] bridge: mdb: Add outgoing interface support
Date:   Tue, 21 Mar 2023 15:01:26 +0200
Message-Id: <20230321130127.264822-7-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20230321130127.264822-1-idosch@nvidia.com>
References: <20230321130127.264822-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P190CA0014.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:802:2b::27) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|DM8PR12MB5478:EE_
X-MS-Office365-Filtering-Correlation-Id: 55706225-d4b2-4100-ce84-08db2a0c9382
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uhr4iguzN8CHn9WTj2ZpxvlX8RzixG30ACZb7h/e/K0AT8rejVxgxykdKMRErOMoE1mSvO4sFIBKsHpHgVe8nBtFpCeMpmzUV6KwjUX9JqhNGEU18exEOkLZ9WeH7RnSDXk7Li5LljPYWhk2f2ZR0vyliNRQ8fY8N0ALpJKWvfMnRZKg1Hy8w7cvKcwwpwtX2AHNIt93RPH3/j226PwGPZ4Y2DCSV18rz82/GeYO+cKx9bsjsF04/MitXCK0rZDRpaW1+wrvxNoSIyX65FIhzQvrtzQAQGwbgA6DSo1IoWWmIkI3ir0/2TGTIszAFOK+7iD+oY4ulkA3kTUFvbh0lBcg6cTWmXEweNzZ7ttfkKvSTblnKJC28Em6NNrcvnBZTfLnk/M27YAqnyNeyX5E/ilCUfgY9OlimkHNTaWwgNJ9lY6uBftzxrI0bhv+ufB8vDa8Im1h4sFhAfqwPU4waqLgVZdYXWwVqqlwk+RrTlvIQV8I29cjURaKoRC3MsHAQCpkuigDSjaoyxD/J9FhYfnR5yl/z3Jo6WWpeEHeK7BQjFb1wRwH/Suy+BqjZ5epI4/LNCgFM8qIiPNWQTZGB+fgxpe4wp7ZqgsvQuJTAqiO1RhxRYsutYrGG0ASmVq4bPa6ViahNTXU+G1pVacRmQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(346002)(366004)(39860400002)(396003)(136003)(451199018)(8936002)(41300700001)(5660300002)(36756003)(86362001)(38100700002)(4326008)(2906002)(83380400001)(6506007)(1076003)(6512007)(478600001)(107886003)(66574015)(6666004)(186003)(6486002)(26005)(8676002)(66476007)(66556008)(66946007)(6916009)(2616005)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xpK74nQ5fC2CuRNHa5CCwe8LTOk6I05JdGrGbK9VUkshpb6qOQBuApfiQ2ZY?=
 =?us-ascii?Q?rqFE/GBJFVrLVpgUtmE6qJ4m+zoMDF8DY1Ymdb7OjguNMVB27vSB+mdqGBP6?=
 =?us-ascii?Q?zfEeLbMq2vGVVoPic1uqoVfXMmPo73oNu1A4uiHYDY3bG2MP5v1CqLeqT/rS?=
 =?us-ascii?Q?J6m0G1v/98CjVKQyQjFKG+5qKz4zIsB2qBd3c7lliVokCoxGZiFj7LHiDc9s?=
 =?us-ascii?Q?Eh0s0b86BXvQPQStGo/CwVsSu0cd1vPQInpsCuzXFq8VZwXMKc9eLdGt4b0r?=
 =?us-ascii?Q?SaRqp9i8At8sb9SIpfNiXdOKDmai54sM9+0samy5rFeY8FTybVGuxO2O2IQp?=
 =?us-ascii?Q?hePUUR9z/bVP/DRfztVjwqCIhaRBmRQIawZsPh84DSoVv9pReC7SnIqvH+1e?=
 =?us-ascii?Q?UBDzO37oxdK53X07+0SKLUHXQiBA5zyxPpMKDW9gEPLKevKsgocnivp9TTCA?=
 =?us-ascii?Q?X2nGwXYm1QjNH5Rf6d8KwEx+Qq5KpyaPoVgqUt3FILxr4TFPIP3BXrOgtEzX?=
 =?us-ascii?Q?5IHh143KBNP8f9+ot3sKps7CgEFp9skVkt1//L/QaPyvTF0dBQQ4zoaYZ9S0?=
 =?us-ascii?Q?ek7HAXTUFVeaacunI13N908qJL0q1WYTJ10gzlUH93ykLgqeTYojZSJZ0aKO?=
 =?us-ascii?Q?wQXXZtvzzzgcPpdUD3TsoAK9w5xPzfPVIndTtjYLj11Mn32pUi3PxDXwaQaW?=
 =?us-ascii?Q?LgnQrWjtZk9jTLHPe+SORVTRHsDtVhrTsErPkdreM1y8Xq5k+I6pQoa6h0tX?=
 =?us-ascii?Q?95QXlKDkuuGjo2/Q1fVnT5LwO7rjqp6LhJCB+sXksEtpk2+D2MF3VJjrGdYV?=
 =?us-ascii?Q?6ZheoHdBCyPCKjlEQ3IX6EnWc9j/VkrOXA4T6SWbeHZ8YI+bqYNOiwUcQ3Ut?=
 =?us-ascii?Q?raStM6ktmHI5ifk7rivTHIoouo8FjPne3HIuMkCoH2BpIAhuuB0XlCj/1uQT?=
 =?us-ascii?Q?Glw0GwbLAq+9+P0S5YCyjQay7BLYoR6TRkPhiIi+Vv2/2dBNOUxVGRs6tGJg?=
 =?us-ascii?Q?J3EnMw4A+/muTZcFQ8kKhmPEM3qWW04gpLi0kNha14Z5nh1fysbFjLUKQoDZ?=
 =?us-ascii?Q?UiEYBIo8FSNde+zRx0W2C+x0kG3MKl8qcqk8F7/XCCbvIBynha6uS9uH5Pca?=
 =?us-ascii?Q?DRKIc+H5OSWuyWyMS6QJlN2f2d3mmASacUpFCV4NAZj07EMmdxw6Dn7v4RS7?=
 =?us-ascii?Q?L8dwTJSOEEM0vdzLae5mhVLB685wz/cKs4IZjs66Yd7sn3euUa9tjzNWT46K?=
 =?us-ascii?Q?XmtINPfxsVA6LE/XxeakAEbIvjZ1yjUuTo4TRJmAshVVdVdbvwuKx+WbMOc6?=
 =?us-ascii?Q?QTOtnpXJ6hbcaHITeqVVi/dL86ckz0DgIx1xHOqGlAZicle6ZT2K3kuzx60u?=
 =?us-ascii?Q?uAwNWdomjb4VWmh+A2WAxFa3N30bnFp9djwl4w4xcY4ImrIBXI8GmjzY4Dmm?=
 =?us-ascii?Q?MH8tvEm6jEAL76dYcMcLIup3zhihso8lkpaZyPE6UVFMCPsZO2wnRZVJkxQx?=
 =?us-ascii?Q?ot1mqOVjMRkdYLdDXzWcNzda7B8itAh1B9SmfKTRB4fkPAJDcQSxBKzBxvNm?=
 =?us-ascii?Q?GG8bJtkPruJXOlfWucRYKi09DQEioznXOZ8eyICm?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55706225-d4b2-4100-ce84-08db2a0c9382
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2023 13:02:50.7104
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fg4gznF+0vqzIHUHTnlaMDwd+aWKft+UpN1wms8wkUfWI9eYgyIkwGTtYtNKoWIsrOffqsjkYMgOQrdVrNvrFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5478
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
and view the outgoing interface of VXLAN MDB entries. Specifically, add
support for the 'MDBE_ATTR_IFINDEX' and 'MDBA_MDB_EATTR_IFINDEX'
attributes in request and response messages, respectively.

The outgoing interface will be forced during the underlay route lookup
and is required when the underlay destination IP is multicast, as the
multicast routing tables are not consulted.

Example:

 # bridge mdb add dev vxlan0 port vxlan0 grp 239.1.1.1 permanent dst 198.51.100.1 via dummy10

 $ bridge -d -s mdb show
 dev vxlan0 port vxlan0 grp 239.1.1.1 permanent filter_mode exclude proto static dst 198.51.100.1 via dummy10    0.00

 $ bridge -d -s -j -p mdb show
 [ {
         "mdb": [ {
                 "index": 10,
                 "dev": "vxlan0",
                 "port": "vxlan0",
                 "grp": "239.1.1.1",
                 "state": "permanent",
                 "filter_mode": "exclude",
                 "protocol": "static",
                 "flags": [ ],
                 "dst": "198.51.100.1",
                 "via": "dummy10",
                 "timer": "   0.00"
             } ],
         "router": {}
     } ]

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 bridge/mdb.c      | 32 ++++++++++++++++++++++++++++++--
 man/man8/bridge.8 |  9 ++++++++-
 2 files changed, 38 insertions(+), 3 deletions(-)

diff --git a/bridge/mdb.c b/bridge/mdb.c
index ee83aa38bced..dcc082353514 100644
--- a/bridge/mdb.c
+++ b/bridge/mdb.c
@@ -34,7 +34,7 @@ static void usage(void)
 	fprintf(stderr,
 		"Usage: bridge mdb { add | del | replace } dev DEV port PORT grp GROUP [src SOURCE] [permanent | temp] [vid VID]\n"
 		"              [ filter_mode { include | exclude } ] [ source_list SOURCE_LIST ] [ proto PROTO ] [ dst IPADDR ]\n"
-		"              [ dst_port DST_PORT ] [ vni VNI ] [ src_vni SRC_VNI ]\n"
+		"              [ dst_port DST_PORT ] [ vni VNI ] [ src_vni SRC_VNI ] [ via DEV ]\n"
 		"       bridge mdb {show} [ dev DEV ] [ vid VID ]\n");
 	exit(-1);
 }
@@ -272,6 +272,14 @@ static void print_mdb_entry(FILE *f, int ifindex, const struct br_mdb_entry *e,
 		print_uint(PRINT_ANY, "src_vni", " src_vni %u",
 			   rta_getattr_u32(tb[MDBA_MDB_EATTR_SRC_VNI]));
 
+	if (tb[MDBA_MDB_EATTR_IFINDEX]) {
+		unsigned int ifindex;
+
+		ifindex = rta_getattr_u32(tb[MDBA_MDB_EATTR_IFINDEX]);
+		print_string(PRINT_ANY, "via", " via %s",
+			     ll_index_to_name(ifindex));
+	}
+
 	if (show_stats && tb && tb[MDBA_MDB_EATTR_TIMER]) {
 		__u32 timer = rta_getattr_u32(tb[MDBA_MDB_EATTR_TIMER]);
 
@@ -659,6 +667,19 @@ static int mdb_parse_vni(struct nlmsghdr *n, int maxlen, const char *vni,
 	return 0;
 }
 
+static int mdb_parse_dev(struct nlmsghdr *n, int maxlen, const char *dev)
+{
+	unsigned int ifindex;
+
+	ifindex = ll_name_to_index(dev);
+	if (!ifindex)
+		return -1;
+
+	addattr32(n, maxlen, MDBE_ATTR_IFINDEX, ifindex);
+
+	return 0;
+}
+
 static int mdb_modify(int cmd, int flags, int argc, char **argv)
 {
 	struct {
@@ -672,7 +693,7 @@ static int mdb_modify(int cmd, int flags, int argc, char **argv)
 		.bpm.family = PF_BRIDGE,
 	};
 	char *d = NULL, *p = NULL, *grp = NULL, *src = NULL, *mode = NULL;
-	char *dst_port = NULL, *vni = NULL, *src_vni = NULL;
+	char *dst_port = NULL, *vni = NULL, *src_vni = NULL, *via = NULL;
 	char *src_list = NULL, *proto = NULL, *dst = NULL;
 	struct br_mdb_entry entry = {};
 	bool set_attrs = false;
@@ -728,6 +749,10 @@ static int mdb_modify(int cmd, int flags, int argc, char **argv)
 			NEXT_ARG();
 			src_vni = *argv;
 			set_attrs = true;
+		} else if (strcmp(*argv, "via") == 0) {
+			NEXT_ARG();
+			via = *argv;
+			set_attrs = true;
 		} else {
 			if (matches(*argv, "help") == 0)
 				usage();
@@ -806,6 +831,9 @@ static int mdb_modify(int cmd, int flags, int argc, char **argv)
 			return -1;
 		}
 
+		if (via && mdb_parse_dev(&req.n, sizeof(req), via))
+			return nodev(via);
+
 		addattr_nest_end(&req.n, nest);
 	}
 
diff --git a/man/man8/bridge.8 b/man/man8/bridge.8
index 88046dc1a2b4..9753ce9e92b4 100644
--- a/man/man8/bridge.8
+++ b/man/man8/bridge.8
@@ -153,7 +153,9 @@ bridge \- show / manipulate bridge addresses and devices
 .B vni
 .IR VNI " ] [ "
 .B src_vni
-.IR SRC_VNI " ]
+.IR SRC_VNI " ] [ "
+.B via
+.IR DEV " ]
 
 .ti -8
 .BR "bridge mdb show" " [ "
@@ -1006,6 +1008,11 @@ the source VNI Network Identifier this entry belongs to. Used only when the
 VXLAN device is in external mode. If omitted, the value specified at VXLAN
 device creation will be used.
 
+.TP
+.BI via " DEV"
+device name of the outgoing interface for the VXLAN device to reach the remote
+VXLAN tunnel endpoint.
+
 .in -8
 .SS bridge mdb delete - delete a multicast group database entry
 This command removes an existing mdb entry.
-- 
2.37.3

