Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5730584659
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 21:33:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232864AbiG1TMd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 15:12:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbiG1TMX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 15:12:23 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2064.outbound.protection.outlook.com [40.107.92.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97012691C0;
        Thu, 28 Jul 2022 12:12:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KIsjP/70DVZoJw30aqAhC0An72p+9pnQ0X0HetrxJPbTws4rL9BeZn5HqdBhs1F9mow01IWknmNS0jUKiF89Hk7K2VKjga/LJ6b9YRHJCzCqElHLasLztj96nBpSkur5Hw1Wv/gPgilPWtV2LdXsbwaDH6Ps8HNnND13Yw0XHPj5WVZc5L1KqFqIgmatwoOTNrlA2QqZn87xR8I3NaD0kEZfOw3lkufzZOJDzIhWNWFNry434q1Ad8pCVO/e5kA/4bkMFtZrXqLh+oKhE1qXpSF1B2z2Sd9BacEqAHJdtxNJ8YDgG4QchfZ7OrgIpxVqdt9K9vO6Z4DFoMvFMdijAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Eu+nGm2R1Rw980cLUiROtpKsrrUD8sKB3+Ltxmyk4ds=;
 b=brQsGh2L5w0TUS+U6Yt8xPxs2gx1vKMZK+n9DhK50+RUhl+xTtdCXNzPURSQZYa4SqsM0LA9B+qDJeFBXR0Mr1QSvdbW73ST6hBg2+vCX9Vg0qF7Q8NqDUKupAJX1RVfUjfNNds+TQU6+Sgbj46o4uRQVrndcIlnm157v8Y/gd4mW5eSOBeysrwcQgkVVTvT1u1IiognV4PoXZILFObWgdV4rAtZ7rt2/AtE7mvmeja2q2dir2EZ+4le5341cqbZe7/JrVI9fZaeygUS09mqbiv3Sg3/9Wp39MRPMEsHC/YsJCSWnVhvRd5SLPoo3AI4LOlcNQCy8goH5YnmW/p02A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Eu+nGm2R1Rw980cLUiROtpKsrrUD8sKB3+Ltxmyk4ds=;
 b=J89vP7pEMIDyLkTnFAYvmgbGGGed5/Z8unq+JYwZ0JB65rrkRMk99O7Pjn5LCvU0rlB1LuM8lrJZDMcBI7rRmuMd33lvxm/87CJOCqnvI/5nr3iUlK83G4/04sBJ5o0yuSHJd/N45ggoJbXN9JZ8gWjH0P7wfJu0HJ56NFyA64a7EZ1BAjAed7DUs8Q1+NOpDWau2chARJlCpds7QFWGseORd/4cSYZjk8luznH01QmWWkRD/b7B64m4+hVl4dYGImyDEDDsYVyOV/TLpxHeGNlbAn18AFGAsR0LgaPDYefHxjQzrWW0wk87SiWaEba/Tus0nCf/c+erF7JT5Q8/1Q==
Received: from MW4PR04CA0296.namprd04.prod.outlook.com (2603:10b6:303:89::31)
 by MN0PR12MB6176.namprd12.prod.outlook.com (2603:10b6:208:3c3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.25; Thu, 28 Jul
 2022 19:12:19 +0000
Received: from CO1NAM11FT068.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:89:cafe::7e) by MW4PR04CA0296.outlook.office365.com
 (2603:10b6:303:89::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.24 via Frontend
 Transport; Thu, 28 Jul 2022 19:12:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT068.mail.protection.outlook.com (10.13.175.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5482.10 via Frontend Transport; Thu, 28 Jul 2022 19:12:19 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Thu, 28 Jul
 2022 19:12:18 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Thu, 28 Jul
 2022 12:12:17 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.26 via Frontend Transport; Thu, 28 Jul
 2022 12:12:14 -0700
From:   Tariq Toukan <tariqt@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>
CC:     Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        Gal Pressman <gal@nvidia.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        <linux-kernel@vger.kernel.org>, Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net-next V4 1/3] sched/topology: Add NUMA-based CPUs spread API
Date:   Thu, 28 Jul 2022 22:12:01 +0300
Message-ID: <20220728191203.4055-2-tariqt@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220728191203.4055-1-tariqt@nvidia.com>
References: <20220728191203.4055-1-tariqt@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6a2db83c-5065-4027-ab34-08da70cd1794
X-MS-TrafficTypeDiagnostic: MN0PR12MB6176:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WaVADmXJW1eLOiNDj6E2TE/pIZ3PxX+GSrP4KSOAlwEjlOhGeHJITCdQHgv6yTTjjWF7RdueH+BoLStn64yccdWr72YaNSrRmKkVe/C+9EN0KVCaUVoRKdy/oK+LFV5D4dkM6O1blXBBfE+MlqwWMPIbgZyuK3IQ69BismlJl6H0BmOCNHCfL5u92mduSgiqmH/OcE0YnVdCfZsoqOFgTNz61GuMYABrK8KuB1//9lZKO/Sd5Xpj42IqViiuxUJd26ZOSPNx4trhS/Rv0tHGWK7k/aEsdqxBs+wLots2YhhWuGKPEhz8g+0yuzgY599wadF6zM7i1j742O10azDppwycjWMImf4f9Yc4KAsvHSbk2NkaHOx1zMBRESC6YKUXvbqwQoy04AefVnUOq6JVNHI5RtZgq29Ivi0HxmHMB9Lhh8bltDumnxYdxjOwRizKnhX/AQhuHuV+Hir4zvugM/579GCDVOEa6Az87heMT6dWlHgqpZo+CjxHCeugPDzzTGcu0RV+obWYnX9YaPGXaCe5dbyQw/1D8+uwEJ1YHXRnL4ASZssPjdVHoNUHaGkdjgVI3PJynE8C7Mk23d+KNntptgPCV2n/wlKWG4ll2HTV6uOGKUBFSfZ0VvgGrWUbCvZXPpGBk+qdodsi5d3y95InC4ptcLlAQ9A2MxP7t1YLoptvpJrxXaFGfgkH60yZi+Z++vG1YGRPenDSYxH3IMbK/b2XuWfUqbHzfDVSt5G/Eslex23o0hvnZXin7DhfyauQxhL+B0wF/UIvX+z6xzTTvbrf9mP84FhE0gFVFBLDcPna6Jp+0WsDbb4bwCaYbn9mpIFiS/WNCoDGNHQNoA==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(136003)(396003)(346002)(376002)(39860400002)(46966006)(40470700004)(36840700001)(82740400003)(47076005)(26005)(70206006)(356005)(81166007)(82310400005)(41300700001)(8676002)(6666004)(316002)(2906002)(70586007)(1076003)(83380400001)(7416002)(40460700003)(2616005)(7696005)(4326008)(478600001)(86362001)(36860700001)(336012)(8936002)(5660300002)(107886003)(40480700001)(426003)(54906003)(110136005)(36756003)(186003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2022 19:12:19.1478
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a2db83c-5065-4027-ab34-08da70cd1794
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT068.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6176
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement and expose API that sets the spread of CPUs based on distance,
given a NUMA node.  Fallback to legacy logic that uses
cpumask_local_spread.

This logic can be used by device drivers to prefer some remote cpus over
others.

Reviewed-by: Gal Pressman <gal@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 include/linux/sched/topology.h |  5 ++++
 kernel/sched/topology.c        | 49 ++++++++++++++++++++++++++++++++++
 2 files changed, 54 insertions(+)

diff --git a/include/linux/sched/topology.h b/include/linux/sched/topology.h
index 56cffe42abbc..a49167c2a0e5 100644
--- a/include/linux/sched/topology.h
+++ b/include/linux/sched/topology.h
@@ -210,6 +210,7 @@ extern void set_sched_topology(struct sched_domain_topology_level *tl);
 # define SD_INIT_NAME(type)
 #endif
 
+void sched_cpus_set_spread(int node, u16 *cpus, int ncpus);
 #else /* CONFIG_SMP */
 
 struct sched_domain_attr;
@@ -231,6 +232,10 @@ static inline bool cpus_share_cache(int this_cpu, int that_cpu)
 	return true;
 }
 
+static inline void sched_cpus_set_spread(int node, u16 *cpus, int ncpus)
+{
+	memset(cpus, 0, ncpus * sizeof(*cpus));
+}
 #endif	/* !CONFIG_SMP */
 
 #if defined(CONFIG_ENERGY_MODEL) && defined(CONFIG_CPU_FREQ_GOV_SCHEDUTIL)
diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
index 05b6c2ad90b9..157aef862c04 100644
--- a/kernel/sched/topology.c
+++ b/kernel/sched/topology.c
@@ -2067,8 +2067,57 @@ int sched_numa_find_closest(const struct cpumask *cpus, int cpu)
 	return found;
 }
 
+static bool sched_cpus_spread_by_distance(int node, u16 *cpus, int ncpus)
+{
+	cpumask_var_t cpumask;
+	int first, i;
+
+	if (!zalloc_cpumask_var(&cpumask, GFP_KERNEL))
+		return false;
+
+	cpumask_copy(cpumask, cpu_online_mask);
+
+	first = cpumask_first(cpumask_of_node(node));
+
+	for (i = 0; i < ncpus; i++) {
+		int cpu;
+
+		cpu = sched_numa_find_closest(cpumask, first);
+		if (cpu >= nr_cpu_ids) {
+			free_cpumask_var(cpumask);
+			return false;
+		}
+		cpus[i] = cpu;
+		__cpumask_clear_cpu(cpu, cpumask);
+	}
+
+	free_cpumask_var(cpumask);
+	return true;
+}
+#else
+static bool sched_cpus_spread_by_distance(int node, u16 *cpus, int ncpus)
+{
+	return false;
+}
 #endif /* CONFIG_NUMA */
 
+static void sched_cpus_by_local_spread(int node, u16 *cpus, int ncpus)
+{
+	int i;
+
+	for (i = 0; i < ncpus; i++)
+		cpus[i] = cpumask_local_spread(i, node);
+}
+
+void sched_cpus_set_spread(int node, u16 *cpus, int ncpus)
+{
+	bool success = sched_cpus_spread_by_distance(node, cpus, ncpus);
+
+	if (!success)
+		sched_cpus_by_local_spread(node, cpus, ncpus);
+}
+EXPORT_SYMBOL_GPL(sched_cpus_set_spread);
+
 static int __sdt_alloc(const struct cpumask *cpu_map)
 {
 	struct sched_domain_topology_level *tl;
-- 
2.21.0

