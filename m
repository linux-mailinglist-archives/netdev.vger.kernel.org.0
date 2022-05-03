Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D748A5183A2
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 13:58:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234980AbiECMBn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 08:01:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234985AbiECMBk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 08:01:40 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80054.outbound.protection.outlook.com [40.107.8.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E67F2E6BC
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 04:58:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R6Y9+tcymY8QqRNRoS3NIL+TVC+ksQVQg7g8MS4xHXBU5pVZ0+mA5W4iMLnUVcC74TDG/aYvPWT2EGrXUIOLHrXf+tNCqlYJjfAA/frngeLh+rjJSnPLvFXEKZojU8Ars+Ufl6KquT4uAA6He4vP/xolunpmARp/urbgTaERsNjxSXVbaHVMt3WtTUbhvJoTcyaGAwJZmXVsktWwYQ4PSmlCjlLvwpYG72tuDK+o2/RABo4JfrMiCbfyMNs3ydI3/CoTUAfg1syua7UH8OMaA6BZMUnmRFO+Vhc2GjmaypFd0QHbOWJ2aI6g79tTM41qsKun8DDI/YQmMe/t0+OxzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5mHlgCmUwAElRPeFqwY8lrBhYfcjGpPdLManQ4A4e98=;
 b=aO620/pAIsORhMnrP/9qbtI0fVxG3JfxUFrvyf9An9mYy19ZBjVLtffhFapHP+BvLvhyhLIUoScIESCpEExMjsSwzF3DyY6iqc5PCPNZcgld8pq5WpqfzqbwA7e74x2sWsjrbDoPUCKYvp7JokKmExBl/eBPxf56UBjj4q1BRTtvNMAg8lkJmLu+/PpflWjH/h5QjN0zEbR4K+NMPi5xZy4xWELbCzBZDzm3alRkrm1cXkxkJ/H4wNDlcsFHTKBNwz3xr4Gn5ZtP+19tZyOwRmlE3x3Fqi2G3J36Fv4dnqRAdglWbhnhCuRlORLYnrGwhGyt79BoHOOmIVLZUCdnQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5mHlgCmUwAElRPeFqwY8lrBhYfcjGpPdLManQ4A4e98=;
 b=kb39PnZBpXmYDatTkWXwk4Obt2kwBzFczO8AF1/PbGuwyHMQRz4YiW4LFKchKKqfDnShzNi54n0LNaBbs7aZzMPqqPn+g/ZTPmugMueIzrLbd4UIiGiDNFtNyQaDPguXi5JX5iuZRm3xqJmL7i2FtWwbxyUpJAD9u8SkvRni6fU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by DB7PR04MB5513.eurprd04.prod.outlook.com (2603:10a6:10:88::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Tue, 3 May
 2022 11:57:58 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::d42:c23c:780e:78eb]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::d42:c23c:780e:78eb%4]) with mapi id 15.20.5206.024; Tue, 3 May 2022
 11:57:58 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Colin Foster <colin.foster@in-advantage.com>
Subject: [PATCH net 6/6] net: mscc: ocelot: avoid corrupting hardware counters when moving VCAP filters
Date:   Tue,  3 May 2022 14:57:28 +0300
Message-Id: <20220503115728.834457-7-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220503115728.834457-1-vladimir.oltean@nxp.com>
References: <20220503115728.834457-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P190CA0009.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:802:2b::22) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1af042ff-4363-491b-ed8a-08da2cfc2a65
X-MS-TrafficTypeDiagnostic: DB7PR04MB5513:EE_
X-Microsoft-Antispam-PRVS: <DB7PR04MB5513A8FF9834E420FCB2C32BE0C09@DB7PR04MB5513.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aM550SMl6tHX1aUnRkzUH5kFoGhV5Ou3yGUlqBHvL1EKwn3wt81PzxldAOWG4TAxxhHW4AJRjPahHJZJjE25/jIGqvBrEd+OMph8wk8pvUlzGYjSFWgN8Wurvd/jB7/LVZKeLeQuNc49FQO5FefYg+0eB4oQbGpwnHwbh/3T3oGQoZDYqglznmlAzhul3G1YHkzq6n2vs1oJD5N22oPVY/yjqrnjGDoWWAdDgwhWzifxdJWvG1SL+ddmh6m6QgHj89nUfJkWETY45k6YnI81MrXg35zVW/J2LaRe2z3NkLpYHahY9S76PqzNQyrWxS0J572PWaqS5mZGv2ZIas4zQRBL/L/LtmFYnWMtTOcq00A4X0iRNhoq63vxpjYjwMPJOAlUzpjcoTHPu78cJvGUUwrHmlk3u6jxLtP8Iclt1o73KDnr0hyKyNfDtJ6n/IJK9X0DMOfj38f94w/cyNfGQKp4+sMzYf2vI9EiHPHrf9BUrXOIHHPJKbmE0tnAiEf+UmuZDhghVtGXtsLMuFnq/Zp/Tw4YWmPWd7UrZxllXbOwhwtaDPFgWdHfIv0ze4CxOfxIuL6vH2/tRqPsL9KBE6S7NCtS4eQ3oeO7Y15+aI8TK2ifNyKIUil4uHHq6GTZuhh9Edf1QwnanQNsY0Yx7XHCM5pWHvPrarbo+mT+huUjAZmsQPAxyX3z0AEb2FNFoCcTgdJWKEqo+nSwM9JeXw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(52116002)(26005)(6512007)(6506007)(83380400001)(2616005)(186003)(54906003)(1076003)(86362001)(8936002)(4326008)(8676002)(66476007)(66556008)(66946007)(6486002)(6666004)(2906002)(316002)(7416002)(508600001)(5660300002)(44832011)(38350700002)(38100700002)(36756003)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YGnMednd4xSHFf2IwARKnZbaNfbwkVUuYVJgQOPWxm0L8eE7CuwqstFVUmyO?=
 =?us-ascii?Q?c0pWXXl+Po838QiPyA31M/fC6kySkQ/TcRpX7IpuqvVfI1DIhIZeNrisP+il?=
 =?us-ascii?Q?0xFRa7VVsx2XtZ2VzJCvManCc33KMeeX/TITStgqjLG5ap8+5O2qIurbvT0U?=
 =?us-ascii?Q?yDGR517PMHLar+Zq1V9ilyVmrmTeTcej3mlJkpAnejPrR8+Gq7hPOlEGptGM?=
 =?us-ascii?Q?ZRHmgnMExKT140c3026xgIu0HQgr8OKF0rUXy40978On0j0fmUePf6Q/E7Lr?=
 =?us-ascii?Q?0CblxivixioPyyVv3ppoTyCZOioq004+rCKfv5xxOyzqxZfJG3/71KrGHi0D?=
 =?us-ascii?Q?3ldQdxwYyqesTSP8G7wb/SyYSoCfTpqIwb8lCTUNO8s8yM/74V7dgiZAxBhl?=
 =?us-ascii?Q?zhXle48kBWaV2VwoZxThWMeTnazfFdaJuwDjsKIX4Nyv3+3+dxFQjt/rXjdq?=
 =?us-ascii?Q?MYZ07upjeq23B59VxjfQOkCdPnLUxlnmAOOQceoRofGw7qM//T+fmSuPWIqb?=
 =?us-ascii?Q?yH7RrjtVhD5pVzd21IFk55n2uZ/Sy9sBRgvW3dFsYFApfV1jydr/0lTPaQfV?=
 =?us-ascii?Q?0KvzdnzGMbbirISABXfIvLzSq7LQChxB8Q877/TvEQEz7XQTClu9tUwQrncC?=
 =?us-ascii?Q?46MZZcX0K1fMsdFanveAnec7pTWJmqo1L7nuCfkO2qdPaTIGRQgriubycSnj?=
 =?us-ascii?Q?4szScSLEqg+hRNMfz8vdpVigoA8lHJLmr1mTDMQkEIKCiAGMtkR9uqP7ptbC?=
 =?us-ascii?Q?5H4p+fmChM0nJNx/XuT3ISeFV8+El+sIy9sjQVwr+lefwP4d7u3LwCV7W5AZ?=
 =?us-ascii?Q?lBvQc3qBDoszpKRza8ZE6B7rajko08aW8ArLYs9gJdc+fRWbK2aNHB+tpQgz?=
 =?us-ascii?Q?7Am6l3ntXC/TQD/2rsE4wvXFRDreNL5JLOIKyrOqXZwJve1FVFmDMdZjvLgR?=
 =?us-ascii?Q?2dL/+qnvj2cvBMKoVrqGuxjQD6UwCsj5qF6n62ujlaY0LsbaX46M7ZigOIyC?=
 =?us-ascii?Q?EbMcOZcHSJ0TjNWbpo7nt/EdggQ+QC8MbjAhVCba4VDzgu3acKiKm+bxnVl0?=
 =?us-ascii?Q?ADh9O6cUSt4sfbIcpcBKJlhXFv4uR15i7Tw2c8sUNMOzLTrma6uY29fIKVom?=
 =?us-ascii?Q?/pOpeRJEhAqWuZmVh2n4JagmaYNtE43vsUYQlBovb73G9d4UquekCRDvE5qS?=
 =?us-ascii?Q?VBtMaus+GgTe1nngi572rWUd/wSpW8scyVW7QPOOds8UCpcJwb2rAWjxV6nk?=
 =?us-ascii?Q?dnR0vMw06BGwQkIJxfP32yP9EwuSEzVJUY7ZyEOr02MIDVC7RInOCurGYC4h?=
 =?us-ascii?Q?yl9xmqDk9qNlaK3gS4RolN0oUoZcf1Sap8H4niptTIqRRJJoy0gtmfAc4qR6?=
 =?us-ascii?Q?vM33bV7Fg06HRFFtUfbgtb+9pQE7wId+merjsLzljPJTzOeHiqH0fcOh3dZ6?=
 =?us-ascii?Q?j/BpfA3wWD/kljKJ3dfsWCaBULe8iPKwBXz/mpw1eAg3QZQPWYWKXUBs1L4c?=
 =?us-ascii?Q?BaYqEtAs3jriY6HAI7rQypNU/gU49T/HWLoQOihQDzeC6rWy61oJesGR74Q4?=
 =?us-ascii?Q?OuS/DSUfvSCZ2y9eluhZP1WentNG84v83NcicY0KLZ8RDeBBfT2NIvLWGF1A?=
 =?us-ascii?Q?k/kvJZbfgh8KB1n/QV2gOmV2KlAR7GotkwIb87OMPvTqxqyPV7gXvhmNkT6A?=
 =?us-ascii?Q?lXb2cL/RRyvEIEDKOBwlSDCJ2RmnkbBZYha2DYTwsHkttRRpa75ixzsagU88?=
 =?us-ascii?Q?enfZSzHFKPJzSDhTGgW3FtYTByDWHVQ=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1af042ff-4363-491b-ed8a-08da2cfc2a65
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2022 11:57:58.2768
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oOD1Mw4UypYDcqYMrkBXn24j0sEMMsDFltj/WEwPxgGQS2ZI1eIvY4lWQjPSZ5mZyPCnVxLMltKXQORYWgFiLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5513
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Given the following order of operations:

(1) we add filter A using tc-flower
(2) we send a packet that matches it
(3) we read the filter's statistics to find a hit count of 1
(4) we add a second filter B with a higher preference than A, and A
    moves one position to the right to make room in the TCAM for it
(5) we send another packet, and this matches the second filter B
(6) we read the filter statistics again.

When this happens, the hit count of filter A is 2 and of filter B is 1,
despite a single packet having matched each filter.

Furthermore, in an alternate history, reading the filter stats a second
time between steps (3) and (4) makes the hit count of filter A remain at
1 after step (6), as expected.

The reason why this happens has to do with the filter->stats.pkts field,
which is written to hardware through the call path below:

               vcap_entry_set
               /      |      \
              /       |       \
             /        |        \
            /         |         \
es0_entry_set   is1_entry_set   is2_entry_set
            \         |         /
             \        |        /
              \       |       /
        vcap_data_set(data.counter, ...)

The primary role of filter->stats.pkts is to transport the filter hit
counters from the last readout all the way from vcap_entry_get() ->
ocelot_vcap_filter_stats_update() -> ocelot_cls_flower_stats().
The reason why vcap_entry_set() writes it to hardware is so that the
counters (saturating and having a limited bit width) are cleared
after each user space readout.

The writing of filter->stats.pkts to hardware during the TCAM entry
movement procedure is an unintentional consequence of the code design,
because the hit count isn't up to date at this point.

So at step (4), when filter A is moved by ocelot_vcap_filter_add() to
make room for filter B, the hardware hit count is 0 (no packet matched
on it in the meantime), but filter->stats.pkts is 1, because the last
readout saw the earlier packet. The movement procedure programs the old
hit count back to hardware, so this creates the impression to user space
that more packets have been matched than they really were.

The bug can be seen when running the gact_drop_and_ok_test() from the
tc_actions.sh selftest.

Fix the issue by reading back the hit count to tmp->stats.pkts before
migrating the VCAP filter. Sure, this is a best-effort technique, since
the packets that hit the rule between vcap_entry_get() and
vcap_entry_set() won't be counted, but at least it allows the counters
to be reliably used for selftests where the traffic is under control.

The vcap_entry_get() name is a bit unintuitive, but it only reads back
the counter portion of the TCAM entry, not the entire entry.

The index from which we retrieve the counter is also a bit unintuitive
(i - 1 during add, i + 1 during del), but this is the way in which TCAM
entry movement works. The "entry index" isn't a stored integer for a
TCAM filter, instead it is dynamically computed by
ocelot_vcap_block_get_filter_index() based on the entry's position in
the &block->rules list. That position (as well as block->count) is
automatically updated by ocelot_vcap_filter_add_to_block() on add, and
by ocelot_vcap_block_remove_filter() on del. So "i" is the new filter
index, and "i - 1" or "i + 1" respectively are the old addresses of that
TCAM entry (we only support installing/deleting one filter at a time).

Fixes: b596229448dd ("net: mscc: ocelot: Add support for tcam")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_vcap.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/mscc/ocelot_vcap.c b/drivers/net/ethernet/mscc/ocelot_vcap.c
index a4e3ff160890..e98e7527da21 100644
--- a/drivers/net/ethernet/mscc/ocelot_vcap.c
+++ b/drivers/net/ethernet/mscc/ocelot_vcap.c
@@ -1212,6 +1212,8 @@ int ocelot_vcap_filter_add(struct ocelot *ocelot,
 		struct ocelot_vcap_filter *tmp;
 
 		tmp = ocelot_vcap_block_find_filter_by_index(block, i);
+		/* Read back the filter's counters before moving it */
+		vcap_entry_get(ocelot, i - 1, tmp);
 		vcap_entry_set(ocelot, i, tmp);
 	}
 
@@ -1266,6 +1268,8 @@ int ocelot_vcap_filter_del(struct ocelot *ocelot,
 		struct ocelot_vcap_filter *tmp;
 
 		tmp = ocelot_vcap_block_find_filter_by_index(block, i);
+		/* Read back the filter's counters before moving it */
+		vcap_entry_get(ocelot, i + 1, tmp);
 		vcap_entry_set(ocelot, i, tmp);
 	}
 
-- 
2.25.1

