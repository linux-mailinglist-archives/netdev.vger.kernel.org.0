Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 844AD5770EE
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 20:54:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232338AbiGPSy3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jul 2022 14:54:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232483AbiGPSyP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jul 2022 14:54:15 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80075.outbound.protection.outlook.com [40.107.8.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D3B7E024
        for <netdev@vger.kernel.org>; Sat, 16 Jul 2022 11:54:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=If202mWNs6vVJEXr/A/Vuv2XorQzUfFKM2WDMLfFaYnu/BOnSu+caLW9u+xh349k7tfLXdInHwhFzLm7oKib7RkhIC61/nMgii5llAhwlKs6YXVPgtn3UVZHdT4YXj4md2ZsWdrn1jfcomGY5yeuNBdIfdUe3WTBXtOEr9T45ULd63PNrzTVxERKodtIh9g+dlyGStMd2K94CZmKXRQ5vWYMMN9u2mKTgH5dkyjxuF349lRs/kluiNSHjExgf6vYLWcIWIfDkWjCNIySeufArRzxDRZisgh7jUixrul8jJ9caOEhXYkWtgl/qDa4pA4I5uPtTIPPj3HOxpyoO9iJeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u5Oq5z5zWxDv8wp/x5hD+DxSOmMI2yr5VOS1Cj+N/EE=;
 b=cOGLZNbTGEJErOF8Gj5R2etyjM5IbbI9R0paQMQSKJyFXZjUEOstRtaD6zhVzOFRoBS8XtKShjE1F2UjiQjq3oFo6YQpTemKKKUy4fwKM/jyUwWY/52NeD2LPyCBNzORN0jm/D4gtAYyldmnUXoD0LyLlkMRz9/LJMq5whd4vLmeRSgYyY6LtCyAMTUzYoNE+az6alAD26DtZylL695B6A9XGwDGLAiB+nt38SdRYzRmfcMfzB6fWcez6MBLwGd8oqnoUxCVL8yz4mRBP1Y71/e6QKC2CXKRQwfST9VVoZfh1RTIoH+hHaiRHKQrflbFDjB3zJxdxQX/rpOcAjHyYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u5Oq5z5zWxDv8wp/x5hD+DxSOmMI2yr5VOS1Cj+N/EE=;
 b=rDeeRdrlX8c2Aeh3Uy5aDS0PEFqfna6IFjVl6Z2Wr8udfxgv7O0dyMta8X3oBtS+MDXie7Gl5EyqW+gBBSjff123hIkP3CNBpt2z6szTfoFPk80FH2cTZdXf6gkwEEsPeWx5jFeapq32olg2/bZZk0KAvlY9/597ZR8WB+HLFb4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by VI1PR04MB5311.eurprd04.prod.outlook.com (2603:10a6:803:60::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.20; Sat, 16 Jul
 2022 18:54:09 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::5c17:601f:ac4f:ebfd]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::5c17:601f:ac4f:ebfd%6]) with mapi id 15.20.5438.020; Sat, 16 Jul 2022
 18:54:09 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH net 12/15] docs: net: dsa: add a section for address databases
Date:   Sat, 16 Jul 2022 21:53:41 +0300
Message-Id: <20220716185344.1212091-13-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220716185344.1212091-1-vladimir.oltean@nxp.com>
References: <20220716185344.1212091-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6P194CA0101.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:209:8f::42) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5860c8ea-4575-47de-1ede-08da675c90c8
X-MS-TrafficTypeDiagnostic: VI1PR04MB5311:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Sd7HjbUYNHJcIM48e77TVBU6n6WekA58l4ri8dDDI5l8jiekFJUNu7JIxUOGmPEkW1+6XY5YV3/3e5daQHGgNb8bGDXYQvs8oGHZs4Jp7dETFDs3fcK+4/NHDRbIOpl42VJrQanJSzOZtiZX6MbBpCbU25OSLhl9ZdU2whSCYkYj2RcRc/H/rAtVnLqnWqrBdXpJPwlt92JyhU4OsbB/My3pXhAIKEHd+4DPOf3sFZ5m5zjcJDYkJsNFnmEBNkrKfPjXguP8CmhTT/Mb2dJbdfAzs1j46FqekZqCT6/213X2/J9VrYpDRezLryoVIVVRE8GG69JDRHyncffUamnZTrxzdCSipNF3PMqyZ3zdlvY0QIXqhDPGsisg2NMzg28ADaq2mxLl3se4Pts6suKmInm337HtcRIcD+nNmlDHOgnSM3Q+IJ/LIFq6iCZ7V+vNmrC9BqZ0gfdtGX0QxIYr2LjgVs306CCo6YBW8oyoQR7z0GqhZrFpHvBHMrIQIPPwQ7oTmep6DORffiGwgzND2+FxU5hMNgCEz2rE83Aowdz4tp9mCzMugngTmTahUwX5VYCEP2XSNdN2hIcqYTXL7mHvX+4Y5Kub7J86e4ewxdVtw5KVh2jrE3W5Od3ZqsDImdsEldlfQqiQbxLjYC8uHRjJvUFpcPPw+UwZcWg+T4pe5OYivT6yZakjAoqctHLQo8Wa65DLcQIiwvHUa6OBueBB5LUGPgmjIMSrVu74Ypur9hy3coIhuJgsOyp5IKmcE9cjob8kOMaSfrkB/c8++UmfdMIiUYLfXibw3qVeiNF6c5FvgEfw7CJP6LINQpBMnvK0A27SThoByzkUh0UFDg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(366004)(396003)(346002)(376002)(39860400002)(26005)(6506007)(6666004)(41300700001)(6512007)(52116002)(6486002)(478600001)(5660300002)(44832011)(8936002)(86362001)(2906002)(54906003)(316002)(6916009)(36756003)(66946007)(4326008)(8676002)(83380400001)(38350700002)(66476007)(1076003)(2616005)(66556008)(186003)(38100700002)(130980200001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PYDAxqAydcpZsZx3hZ5kPhXv4Q/hkDSNDNySA61CT3uzN2l1pmZOWN1cjHGY?=
 =?us-ascii?Q?rZLWM5zrrpMLk1HdnqDnZdJmMrOSESphgHXV1M89zI841UEurmj6tStpav0x?=
 =?us-ascii?Q?kv+tgvhPVxRp4LI6toKQEWesl+kW/A6GoS4Z92V4zUn9754LiA+fpg+4iOP3?=
 =?us-ascii?Q?6OkE8fHVrp3vAfyUHxBt8XNNKY0wKyYEthOro+qyoQKNYM3s6/BYYZ6CnY/0?=
 =?us-ascii?Q?nAnJPFgcozFl7LD8AmSt+wZijX7FCq2qEgrfLwhOLHYYQLOVX9x/yn0pwRKO?=
 =?us-ascii?Q?/cMtVHM42C8nunwlGNfKTUMx0HxLuDZPWWTRh7UQpN7pCLA2ZyfRjJzOuk+0?=
 =?us-ascii?Q?vNoiuuF157Z3V7ZN1pNtPJCyZ/oMqJt8/GWz5naGfKWMa9DR5eR8Evuy7/xJ?=
 =?us-ascii?Q?mxh/0IgmVDGaI8iom4+qV0FAU7PCAlD2ZowxW3uV/eNzjIPh6bQtYpjxZDS6?=
 =?us-ascii?Q?RhdMTM2netojWYQ1j+fWg9726holhPC0RGbu1IuyMnU7qsRLxVvaUSZ9fADo?=
 =?us-ascii?Q?rKAhbIEVJYddTFmpT3dNXerOFcddKaAjk9/ZuTiALBO9JmjBvzH1uGMTWBUL?=
 =?us-ascii?Q?ZhrvtKGBtPn8U8zIxzMclOHyPfNVKwjzMR3OmETOKUoLoAMkIvnVlZeS2hfC?=
 =?us-ascii?Q?1pTCN2Mb2u4Obn/la8iKNYD+Ndi67doSXYEUW3uhd2lO9KgEy1//bBIUnLVW?=
 =?us-ascii?Q?ViE4ELb7dakmxOVHeSV4HHkcRADn+VqzLAZmVfS5xYXemet8uvPptvcX1Asm?=
 =?us-ascii?Q?aV+GYfdWXeT5hnuecbApb78Z7Fzk3IrmFbSdJgCY+8dUQu/12T7kDEOblMhJ?=
 =?us-ascii?Q?xbTL1j3800kYE+KGduaIwlD4j+DQMFIYhG8iFIobQPUIqIK1HmXtSTm3O0qJ?=
 =?us-ascii?Q?e1j3Sgdwkg1hwtqoAifLaQLlFdeLkzu2l6H+B9KXH8VObTBih3DVET8+n/qJ?=
 =?us-ascii?Q?RerK1z3F54oQFyZGvGlsNevM262FAXDLw6ekR5m/K2FAGmP6UcclEg3ftLXf?=
 =?us-ascii?Q?WfW1gz33H7qVLcfxpcJ35BpN3h7k68lkcij5INd6eJTbtbolhmfdEwPxv7lw?=
 =?us-ascii?Q?cPu1LuEwcNLvxBKvZvZdYrwOfB4URV5BGdneG9meYGLpi0W1TruBRMCJfZpG?=
 =?us-ascii?Q?M6TDy28k/GHGZE3KRqC9/++e/THLpqDZSedRV7wNmALa2BqnZAbS8wQ4qWUe?=
 =?us-ascii?Q?DTeAxkAG5EJ+VrQ2N2WX9vIitvEnaEa5mSJqrwFuvN1Fq79kHMH6/qva2uo7?=
 =?us-ascii?Q?3s7jhMfJCtbDSMqPKfOlWd20dEjOYWYbd1M/iECGSSoyPKdn8NpXnUoBFQbf?=
 =?us-ascii?Q?buU/Dxsa3BzXtA/PiF6BQqzwWFo0dVOexHMNULZrpXmLW8iT1ljOzQ/BDgkn?=
 =?us-ascii?Q?xZVWvpsHAM2WhNuLNZsgKr2oeY+DbLH2V+tk6V01+lUETi6bOvmudkYVDlxV?=
 =?us-ascii?Q?zOc9PTZceBA07LX4c1wzmbH1LzPQYfmtfL3e15oQquC4zukDcXloPDwlcjIB?=
 =?us-ascii?Q?+pONNgxEIBLDc8l8AeNJjWrCMKvaudove8yQpklDQHjGJb3g6pHrO/62qhxt?=
 =?us-ascii?Q?x+2Tp3HHseIjxqBos4JYVgRWcIHFVTPbezRslKoWbjLyxXEuC4YCB1rrziIS?=
 =?us-ascii?Q?8w=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5860c8ea-4575-47de-1ede-08da675c90c8
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2022 18:54:09.2376
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rGmnLJYca/62mODaYH8SDZsFWIFd3PO36lh86u57qxCCwnh+E9LxJaaDuggTL+CY68yocNhIQ+BWr8rxb6UYgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5311
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The given definition for what VID 0 represents in the current
port_fdb_add and port_mdb_add is blatantly wrong. Delete it and explain
the concepts surrounding DSA's understanding of FDB isolation.

Fixes: c26933639b54 ("net: dsa: request drivers to perform FDB isolation")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 Documentation/networking/dsa/dsa.rst | 136 +++++++++++++++++++++++++--
 1 file changed, 130 insertions(+), 6 deletions(-)

diff --git a/Documentation/networking/dsa/dsa.rst b/Documentation/networking/dsa/dsa.rst
index 118853d1d7ac..c8bd246d4010 100644
--- a/Documentation/networking/dsa/dsa.rst
+++ b/Documentation/networking/dsa/dsa.rst
@@ -727,6 +727,136 @@ Power management
   ``BR_STATE_DISABLED`` and propagating changes to the hardware if this port is
   disabled while being a bridge member
 
+Address databases
+-----------------
+
+Switching hardware is expected to have a table for FDB entries, however not all
+of them are active at the same time. An address database is the subset (partition)
+of FDB entries that is active (can be matched by address learning on RX, or FDB
+lookup on TX) depending on the state of the port. An address database may
+occasionally be called "FID" (Filtering ID) in this document, although the
+underlying implementation may choose whatever is available to the hardware.
+
+For example, all ports that belong to a VLAN-unaware bridge (which is
+*currently* VLAN-unaware) are expected to learn source addresses in the
+database associated by the driver with that bridge (and not with other
+VLAN-unaware bridges). During forwarding and FDB lookup, a packet received on a
+VLAN-unaware bridge port should be able to find a VLAN-unaware FDB entry having
+the same MAC DA as the packet, which is present on another port member of the
+same bridge. At the same time, the FDB lookup process must be able to not find
+an FDB entry having the same MAC DA as the packet, if that entry points towards
+a port which is a member of a different VLAN-unaware bridge (and is therefore
+associated with a different address database).
+
+Similarly, each VLAN of each offloaded VLAN-aware bridge should have an
+associated address database, which is shared by all ports which are members of
+that VLAN, but not shared by ports belonging to different bridges that are
+members of the same VID.
+
+In this context, a VLAN-unaware database means that all packets are expected to
+match on it irrespective of VLAN ID (only MAC address lookup), whereas a
+VLAN-aware database means that packets are supposed to match based on the VLAN
+ID from the classified 802.1Q header (or the pvid if untagged).
+
+At the bridge layer, VLAN-unaware FDB entries have the special VID value of 0,
+whereas VLAN-aware FDB entries have non-zero VID values. Note that a
+VLAN-unaware bridge may have VLAN-aware (non-zero VID) FDB entries, and a
+VLAN-aware bridge may have VLAN-unaware FDB entries. As in hardware, the
+software bridge keeps separate address databases, and offloads to hardware the
+FDB entries belonging to these databases, through switchdev, asynchronously
+relative to the moment when the databases become active or inactive.
+
+When a user port operates in standalone mode, its driver should configure it to
+use a separate database called a port private database. This is different from
+the databases described above, and should impede operation as standalone port
+(packet in, packet out to the CPU port) as little as possible. For example,
+on ingress, it should not attempt to learn the MAC SA of ingress traffic, since
+learning is a bridging layer service and this is a standalone port, therefore
+it would consume useless space. With no address learning, the port private
+database should be empty in a naive implementation, and in this case, all
+received packets should be trivially flooded to the CPU port.
+
+DSA (cascade) and CPU ports are also called "shared" ports because they service
+multiple address databases, and the database that a packet should be associated
+to is usually embedded in the DSA tag. This means that the CPU port may
+simultaneously transport packets coming from a standalone port (which were
+classified by hardware in one address database), and from a bridge port (which
+were classified to a different address database).
+
+Switch drivers which satisfy certain criteria are able to optimize the naive
+configuration by removing the CPU port from the flooding domain of the switch,
+and just program the hardware with FDB entries pointing towards the CPU port
+for which it is known that software is interested in those MAC addresses.
+Packets which do not match a known FDB entry will not be delivered to the CPU,
+which will save CPU cycles required for creating an skb just to drop it.
+
+DSA is able to perform host address filtering for the following kinds of
+addresses:
+
+- Primary unicast MAC addresses of ports (``dev->dev_addr``). These are
+  associated with the port private database of the respective user port,
+  and the driver is notified to install them through ``port_fdb_add`` towards
+  the CPU port.
+
+- Secondary unicast and multicast MAC addresses of ports (addresses added
+  through ``dev_uc_add()`` and ``dev_mc_add()``). These are also associated
+  with the port private database of the respective user port.
+
+- Local/permanent bridge FDB entries (``BR_FDB_LOCAL``). These are the MAC
+  addresses of the bridge ports, for which packets must be terminated locally
+  and not forwarded. They are associated with the address database for that
+  bridge.
+
+- Static bridge FDB entries installed towards foreign (non-DSA) interfaces
+  present in the same bridge as some DSA switch ports. These are also
+  associated with the address database for that bridge.
+
+- Dynamically learned FDB entries on foreign interfaces present in the same
+  bridge as some DSA switch ports, only if ``ds->assisted_learning_on_cpu_port``
+  is set to true by the driver. These are associated with the address database
+  for that bridge.
+
+For various operations detailed below, DSA provides a ``dsa_db`` structure
+which can be of the following types:
+
+- ``DSA_DB_PORT``: the FDB (or MDB) entry to be installed or deleted belongs to
+  the port private database of user port ``db->dp``.
+- ``DSA_DB_BRIDGE``: the entry belongs to one of the address databases of bridge
+  ``db->bridge``. Separation between the VLAN-unaware database and the per-VID
+  databases of this bridge is expected to be done by the driver.
+- ``DSA_DB_LAG``: the entry belongs to the address database of LAG ``db->lag``.
+  Note: ``DSA_DB_LAG`` is currently unused and may be removed in the future.
+
+The drivers which act upon the ``dsa_db`` argument in ``port_fdb_add``,
+``port_mdb_add`` etc should declare ``ds->fdb_isolation`` as true.
+
+DSA associates each offloaded bridge and each offloaded LAG with a one-based ID
+(``struct dsa_bridge :: num``, ``struct dsa_lag :: id``) for the purposes of
+refcounting addresses on shared ports. Drivers may piggyback on DSA's numbering
+scheme (the ID is readable through ``db->bridge.num`` and ``db->lag.id`` or may
+implement their own.
+
+Only the drivers which declare support for FDB isolation are notified of FDB
+entries on the CPU port belonging to ``DSA_DB_PORT`` databases.
+For compatibility/legacy reasons, ``DSA_DB_BRIDGE`` addresses are notified to
+drivers even if they do not support FDB isolation. However, ``db->bridge.num``
+and ``db->lag.id`` are always set to 0 in that case (to denote the lack of
+isolation, for refcounting purposes).
+
+Note that it is not mandatory for a switch driver to implement physically
+separate address databases for each standalone user port. Since FDB entries in
+the port private databases will always point to the CPU port, there is no risk
+for incorrect forwarding decisions. In this case, all standalone ports may
+share the same database, but the reference counting of host-filtered addresses
+(not deleting the FDB entry for a port's MAC address if it's still in use by
+another port) becomes the responsibility of the driver, because DSA is unaware
+that the port databases are in fact shared. This can be achieved by calling
+``dsa_fdb_present_in_other_db()`` and ``dsa_mdb_present_in_other_db()``.
+The down side is that the RX filtering lists of each user port are in fact
+shared, which means that user port A may accept a packet with a MAC DA it
+shouldn't have, only because that MAC address was in the RX filtering list of
+user port B. These packets will still be dropped in software, however.
+
 Bridge layer
 ------------
 
@@ -835,9 +965,6 @@ Bridge VLAN filtering
   function should return ``-EOPNOTSUPP`` to inform the bridge code to fallback to
   a software implementation.
 
-.. note:: VLAN ID 0 corresponds to the port private database, which, in the context
-        of DSA, would be its port-based VLAN, used by the associated bridge device.
-
 - ``port_fdb_del``: bridge layer function invoked when the bridge wants to remove a
   Forwarding Database entry, the switch hardware should be programmed to delete
   the specified MAC address from the specified VLAN ID if it was mapped into
@@ -854,9 +981,6 @@ Bridge VLAN filtering
   specified address in the specified VLAN ID in the forwarding database
   associated with this VLAN ID.
 
-.. note:: VLAN ID 0 corresponds to the port private database, which, in the context
-        of DSA, would be its port-based VLAN, used by the associated bridge device.
-
 - ``port_mdb_del``: bridge layer function invoked when the bridge wants to remove a
   multicast database entry, the switch hardware should be programmed to delete
   the specified MAC address from the specified VLAN ID if it was mapped into
-- 
2.34.1

