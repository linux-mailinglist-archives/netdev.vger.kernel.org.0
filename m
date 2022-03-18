Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4E6F4DE200
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 20:55:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240436AbiCRT4W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 15:56:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240380AbiCRT4U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 15:56:20 -0400
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-eopbgr140077.outbound.protection.outlook.com [40.107.14.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B4AFB2
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 12:55:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SBR7WDCI0rNBO4IN8tRz8iWA5qAOIaCmX91b5j8vVp4aE6cN6w7LpisyBYDxsF7QS4Dt2bJermsWbJ9b9KX/ZcXhtGl+NT6rkHcs5oWcnaNiUYTS79BQsvgB5Xqkd4S1SJAqMtEhZJUgSrF8XxICwjFqX8L+efc4BYWrd//PbdRZazPj5eAZzWyaSUONN61JNKMgznGWIvs8/V2kaPppgCGVQAEVJOuL5/6BqM82gn4yfElaHue/hgb8My7C5gj+syU46vktBVqjrP1oxOBUEytBUJshJek5eSuqG1Xs3G7lF43HhabmAwXIqfUk96ajdFpOQ6ay0l3O/7Z6vy/YxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yvdd0NWmM4/SjkiRex60CV5wFJmiG0M/rDDEMxCJ1vo=;
 b=CHCEbHjxeP2vPtKM43PIcOdpExGIvwl7MZ/i8QUX4z1Q6X6fh97EYX4lpaN068+OcKzCdmNd7gEtZ4rZ+dROBG5eSWKzUh14Sl6QC8xg0gh8gIoeRtePNriFDYAI8Qt+KF59R52W4ZgSIPPrW6PQxxFrSJq3AWe75UYs54N7KmUhbnrvruWyH2kXuujOvuiXerqhCdvyVvQco1ZpFxLc/NNCZfEbINB5xSH3SKWuz2QKRGrT8v+yIg8f+D6NuGoXr953YivNDK6CrR8yG3/bBtWCxmHIZMb9r64b17TgYDpuXkPVQGnCZ+MUPqXq336j+dFQVX1Ovh+mZ6xhwxvAhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yvdd0NWmM4/SjkiRex60CV5wFJmiG0M/rDDEMxCJ1vo=;
 b=NaXSPLSDY3fo6nLCHH1Z37GElVOyUy3C9gwOw1mjg34ug5yu7mZB5a/Kb5m858GVvW2xgEiG+kgDQQ+0jCPPTTasa3TYf14FkMm/7dA/MskV5LVFa5Jp5UwT0oKvTGQCLLWUfMrXlv79P/PkPnQtZY1jILsqB4JcsHyRsCKGABQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB8110.eurprd04.prod.outlook.com (2603:10a6:102:1bd::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.18; Fri, 18 Mar
 2022 19:54:57 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::de5:11ee:c7ea:1d37]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::de5:11ee:c7ea:1d37%7]) with mapi id 15.20.5081.018; Fri, 18 Mar 2022
 19:54:57 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net] net: dsa: fix panic on shutdown if multi-chip tree failed to probe
Date:   Fri, 18 Mar 2022 21:54:43 +0200
Message-Id: <20220318195443.275026-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6P192CA0007.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:209:83::20) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6180235c-427f-4a96-a236-08da09192dac
X-MS-TrafficTypeDiagnostic: PAXPR04MB8110:EE_
X-Microsoft-Antispam-PRVS: <PAXPR04MB81103A5B67FB4EDC38CDEE44E0139@PAXPR04MB8110.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AXBCDY4HSrZP4sLrEqN6rNl+uu92h8LPvT7+U2TBrBFJx1O2pA62P4aYAW6eWrV3F7SYhHzfRPE8DSC7+CkoVV0bdFmek/b9V1Bua3AjGU+lnkbAtsfK5pYaEDLaYn5N8tt6GLwWDWflAMPKdpBoKdKiN5gzeXURmDcV+u9VZCLOob4LFubmMWmBTKbpvZD0MW/bbP+ulc/Nn1aliK9u4lqP1ovAJ8GnS8XMr3b+sM1ywrQ7z9JHBENS2AL1uR3gzxMV3gO+5F4f/Ego06bHrustqEOGGCg1C1bP0/LOK6OFEcmaYQRKhS4m+jeVonRsw9fWGfwA2BhvfKpGR/knw+4dh8vQmOB8TEa/1j7W6LqiYjV2dN9N86i0TLGWqcAKZ7h3KknZcQy2iUKtDAOFv1UM2PUlfiRfDcWedp3BethjbpBt+zMt0Q9X3EnISpUoWazIWYKWZqeKjHAln7BhxmJ8QZFq3MdY4jSaaMQpnYKBTpggvl237+jYcYalm1mTrgy1Q7mhVP4jorG7h0TmD17WogW49pFL1kXnFxqVefQs0jvarqLz3AsGJIJTVaRds0nUAQuylMb9ck9pvr8/Nt8nzltVGK7hPoQ30qq17Nj08TgPHNIPm4Et9/yfZuRdVaGNSZvvPyoSSamXBHw5/LjjOTBWFhCDy5uLek8EDSpG2vNh0MyHfrSIW9UGLlhr2WCKg6sOt5fpK6X5NcJZrA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2616005)(26005)(186003)(1076003)(6512007)(83380400001)(36756003)(5660300002)(8936002)(66556008)(4326008)(66476007)(86362001)(66946007)(44832011)(38100700002)(38350700002)(2906002)(6486002)(6666004)(52116002)(6506007)(508600001)(316002)(8676002)(54906003)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bD+d2ZO5v85FHDNUQ8/NMv8PDARx/k7W/wpl9gnBzASZkXu0LOcer9DvBHhh?=
 =?us-ascii?Q?jzzyaJGjGNCvWw1msvD090QMI8f2bmCLQzsI4XRfhvlFI/TfEzduXqwLAy66?=
 =?us-ascii?Q?gwgcdSHjWR0TqLgJ62ce/dPUm7AEVSmDL0OGwn9r4RMAViB7VEnptFDpdi/5?=
 =?us-ascii?Q?NjJpALtDcc6BL8MU2Fm1Fdb+YBy4d8OOVWwz+zYyktVid3bvHzBQwOXVQrFF?=
 =?us-ascii?Q?gQr9WMIM+F9JUq+CaO2Tl5g9xd6SiVS2Z9uaAenF5my1wMyu9kCZtkO9RgBa?=
 =?us-ascii?Q?3AEzJ+t92PLb5mVwK0kjQsNPWFVWUiL2peVW1HFuuvd2nNMzKq30I38xMpNa?=
 =?us-ascii?Q?tlW8sjAxWXRcHj8JvJscrBGmQCiyOFmRCIpFRSyUwmFqjCNyW5geReWrBSHr?=
 =?us-ascii?Q?JHrH+OhebXlV6LFvoMMTGUZZSOgyASVefBLyTsbz5UXD76cuDdPK0uwbEQQE?=
 =?us-ascii?Q?5EI7B/CT9EpfdDSdRzPNhQepdxBszyCZMJ4gqvydxY5ufvit4CulbPK9HR8G?=
 =?us-ascii?Q?+In0C8XnqQysB4teNKQLaS6x6AY9X3xQGHkNpAWUxQJ78QVBWhC8q6QmHOBH?=
 =?us-ascii?Q?Ik4mPlvS1jEyAdunZPN6EzmE8e19aGaXaWryertnQOMm/vvRmuGiEVObax+J?=
 =?us-ascii?Q?bVVPjUqD+OoJHz2j4LjsqXmKQeik6OwdffLOM0ui3aFHzsq0tx+t6sHPLs6H?=
 =?us-ascii?Q?fqo8/4/i3HBmBNicQDh6XEle/ecJlSWW9lqR5BkB8wtgSesvLcMhYVCn00aA?=
 =?us-ascii?Q?uwncXPP5GUgxW/d/S/PGPGt/gQhdVq4N4AyMAy4tzXxcGv8rrwQOt5HET2tt?=
 =?us-ascii?Q?R0OwKdrEHggc4WUy5BAH/RqS+BjAfNcvxNoVryEy3c/0CkxHSvAK5yrnllHe?=
 =?us-ascii?Q?ajVD50282dq5utiO654GT0f/h44hOJWkRfLU35UU96PDABMEMPSsI6qdLvsg?=
 =?us-ascii?Q?NvJDrlHu10H5spWyNL/syry/dJ5wjnwpAYWn+2nVKStgyiU/QACdRVmAYE14?=
 =?us-ascii?Q?L9SFdOobYFV/KYNjjTn9oxtbfiIpcjIH9aI0GmNyumnZOBY7F0aqMs8cPUFV?=
 =?us-ascii?Q?ftI9ftL/QC5ccwUVzMbXN5AHrL4YY1s7CosCEkWQBN4I7xkkPuKLFpwNBd9A?=
 =?us-ascii?Q?S5VPs2Qx7/OtTRwRwuPcy/g0FHnC8U5+6K3gHkmLOplsZLO50YdrMpnXi/Em?=
 =?us-ascii?Q?bnaV1t4TBca1E+8CAo6MubU5Xo6OD0Ncgb6MAWSMXyjbUrU/vZbVyi0EcZn8?=
 =?us-ascii?Q?uC8DpOCo6hlPybnxKKJAoFcqF7oj/hcEpxq3cFeyrGh1F/1+pI8Nkn1dUcj+?=
 =?us-ascii?Q?smLolq+N7dZ2jg6sTFE/sj5pto8ZP4GJf+2l7F/WJEOQ57uWVFSiA6ZoOwWj?=
 =?us-ascii?Q?xifemSnHFeem02oa0Iwrs6gqGIDa+OVfH3BSx4RHyGALfLRrCAW2xrn/YIcX?=
 =?us-ascii?Q?cyIDS1Nn2OEZJpLUpaHjBpKZqW2ruU/dU7G65O8fXfnkQl15MeIXnw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6180235c-427f-4a96-a236-08da09192dac
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2022 19:54:57.3810
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HuWVhCcAvROBYk5HHyGw3/UQkvcE+RzwencDVcJKo1yegi6e5Y+avN300toW+xAKDHsn5pVu3CI0/SRm6qzpJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8110
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DSA probing is atypical because a tree of devices must probe all at
once, so out of N switches which call dsa_tree_setup_routing_table()
during probe, for (N - 1) of them, "complete" will return false and they
will exit probing early. The Nth switch will set up the whole tree on
their behalf.

The implication is that for (N - 1) switches, the driver binds to the
device successfully, without doing anything. When the driver is bound,
the ->shutdown() method may run. But if the Nth switch has failed to
initialize the tree, there is nothing to do for the (N - 1) driver
instances, since the slave devices have not been created, etc. Moreover,
dsa_switch_shutdown() expects that the calling @ds has been in fact
initialized, so it jumps at dereferencing the various data structures,
which is incorrect.

Avoid the ensuing NULL pointer dereferences by simply checking whether
the Nth switch has previously set "ds->setup = true" for the switch
which is currently shutting down. The entire setup is serialized under
dsa2_mutex which we already hold.

Fixes: 0650bf52b31f ("net: dsa: be compatible with masters which unregister on shutdown")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/dsa2.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 12b9bced4eb8..ca3f68ee4203 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -1782,6 +1782,10 @@ void dsa_switch_shutdown(struct dsa_switch *ds)
 	struct dsa_port *dp;
 
 	mutex_lock(&dsa2_mutex);
+
+	if (!ds->setup)
+		goto out;
+
 	rtnl_lock();
 
 	dsa_switch_for_each_user_port(dp, ds) {
@@ -1798,6 +1802,7 @@ void dsa_switch_shutdown(struct dsa_switch *ds)
 		dp->master->dsa_ptr = NULL;
 
 	rtnl_unlock();
+out:
 	mutex_unlock(&dsa2_mutex);
 }
 EXPORT_SYMBOL_GPL(dsa_switch_shutdown);
-- 
2.25.1

