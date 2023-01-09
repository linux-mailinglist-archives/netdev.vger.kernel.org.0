Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FEB0662724
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 14:33:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231267AbjAINdS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 08:33:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234702AbjAINcd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 08:32:33 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2042.outbound.protection.outlook.com [40.107.93.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ABAC1E3D9
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 05:32:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cLkM9mgKF9ceLQkd1vDECiVDbS2ntKvxA4R/zBbt6ZxwmPdGBHBWx8QBs50IKChkk54kuyLdz2Ux9q6NTuC/FuH4exWJIGlprEI9dehJNMYwCVPPCGSHCKWlbQwMIlPttjU/fYpqc4hjxlqwXz+eewqC0SV5MYPltTlIiaS6/qoF7wfazB3Y0ckQVafUEdE70ulxjU+tu9mVUlsq6plDEups6wvylZ7YPRYXvDONFhy3KFVK/ucSegdnWH27W4QhBndbN0OCwD5Qwg7BFwtkoWCrA3/WNLEFqVGo/zxVACdJ0i3sh6Ku+XuiaElqi5+RFuhoMHtYYSGu8vWbESTWpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PUaSoNbN2jAInfpgiCYMJWmGen4bHyBLxwu23vOA6jo=;
 b=Z2yqiobSCUJaufnL3VP5Wec+EZ9P0ED/MP7RQ8fsou5KEojXs5fsX1Hz/7NOw/KHr/kqAzZwKIPwpdavguu6Lbuhlr/9NixfajjEKqVASNv3BywVMidoF6IpkSBD3V1qjurWNxoXV1fpljXP8i3uN+895n1sI6rmkqFrE2wP53PxPtfX2PyIhVIqglHugg7PVdn0XsYuYD2cIzIvsTIz8JVYr8Vw7Hqh6LCS6g0bDLUPgS76sCjjt+W0D9d+V9hqvYHTItK77qJmLBRYig0VoZd2o2ZGN5hkX0oe/JVBTiLvbL09CVD7TlKp683A49Q9Xb0Ikls9FARgfrIROdAAgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PUaSoNbN2jAInfpgiCYMJWmGen4bHyBLxwu23vOA6jo=;
 b=CzpvFf/8iWZs2zSeDnkbGX27Nk4MTAz2LUTJpa0acG9sdcHw41v/pUvR41SxM1iLWWegOz768lGew1DXucMa83xYU9GVl8ahZWLOIO2Q2dpqhpzjAaQJmAdxXT3Z16/9pdaHq2rR/Veo+Qncj6jByQfnZLz7vg1mfQQAnmyvqk2nOLE61y2xjw+xD2W0m8upHePB0waSeSS//S5Foa6S+YtPTnN5Z+TBzksrgMt1DQETU6KtQTilgTOto3TrItOAq5uywzDNa/Z67ovmQSKGSqXfppo8AgJ2vmDWVEK3MeYAlmtxzD4jDPnLcH8BZhJ7Q011G7ctTZTsk3+VeZY1Wg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by DM4PR12MB5056.namprd12.prod.outlook.com (2603:10b6:5:38b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Mon, 9 Jan
 2023 13:32:31 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6d66:a4bb:4018:3c70]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6d66:a4bb:4018:3c70%6]) with mapi id 15.20.5986.018; Mon, 9 Jan 2023
 13:32:31 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, davem@davemloft.net, kuba@kernel.org
Cc:     Or Gerlitz <ogerlitz@nvidia.com>,
        Aurelien Aptel <aaptel@nvidia.com>, aurelien.aptel@gmail.com,
        smalin@nvidia.com, malin1024@gmail.com, yorayz@nvidia.com,
        borisp@nvidia.com
Subject: [PATCH v8 10/25] nvme-tcp: Deal with netdevice DOWN events
Date:   Mon,  9 Jan 2023 15:31:01 +0200
Message-Id: <20230109133116.20801-11-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230109133116.20801-1-aaptel@nvidia.com>
References: <20230109133116.20801-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0011.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:62::23) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|DM4PR12MB5056:EE_
X-MS-Office365-Filtering-Correlation-Id: bb554600-6fef-4996-fee9-08daf245f558
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hz2L0n0LyTYKmUIRMMjz3Wm8G9T1zVFh64H+BAVJor44CCzCmAF1I8RJmxfEhG4GXsp5vXlx2KuyqtEHK++ZuyUcgpBccCnPlO06TU/UOfpzCuG5z3eiUIgfcVwboNmQul38gtJFtZTbgIU4OwXQ+ugmLqQJd5LMmjJPmmZpSzH609l3UeV+SMPJR6+ezGYxKsEhPyOJ85yh2jCg1yFaKhTVj7zSmwUws5mUvoUyyCq1vrHkf4Wq1FzB8ymDRYkluOPNECNabxd5FuOU+v+Fd6ZGe2WoMqfvYTY/UR2MRotp3Z7bL6QR7qkyEK6RIfgWlH3E8l9jkq7UFr01Hi62AGn/d6IlycNXPqOl5ySTCICX0b2c6nDbvvUJPEg96s7aDZLdpwsKNLKE3MjavORa/Xp5KNMUh3hTCyLkWPjaXLuponWzmR7xawlzUtMTpcyKnRdDOYUfZqzmXG+LKr6DAswK0+hE8Q8ipAmzrEwbTZjja6thOTeaiQugaOBzrz+hfHb10LpswDzOmK3LuFYx2INfEifEyy4iyAe39y/gmE24Xhng76/2xtjnKfCEm99njC7HmI/NiK76qsgDPchCBAl5e1kW3h79SAS0qyFEWxAVzQwjZ0k3nniQ1Ihz2Z66eHfqFpZQnKeA1QbCF6FdxA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(39860400002)(136003)(346002)(366004)(451199015)(2906002)(83380400001)(54906003)(1076003)(2616005)(66476007)(7416002)(66556008)(5660300002)(66946007)(6666004)(107886003)(26005)(186003)(36756003)(8936002)(6506007)(6512007)(478600001)(38100700002)(8676002)(41300700001)(6486002)(86362001)(4326008)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NTw7lLaoblMwO02EOG7YHgh0tlHnWDF8QUo/onDwHxNETCbUaOCWxUIedSej?=
 =?us-ascii?Q?/79eT8sI6HF1tgKi6T66aiT/iqVjJEDALx0OaBN4+AdkBKLcwsDw9tr3IRIA?=
 =?us-ascii?Q?Vu4FQh246EJGc1S8n+8qYsHduUMPv0vKD97dY9uUOmr8lUxWIPWe+qVhlZbD?=
 =?us-ascii?Q?KAkGNrWncU3et6XzP2TKf5LNzgbnrLxcAlw+iRXNAMjKF2R/GIZByvKcgWro?=
 =?us-ascii?Q?uBBwRtx4MB+AHUXOmMA11zCceNPX+SLtNvJMQIIWmxULXdZeDOdUCwBbcimW?=
 =?us-ascii?Q?qnh/3z7iEMm0LWY65Reh+FWk4DflWYwQD4f7TRjlV1zE3+gxz4bO+Ug0SxIp?=
 =?us-ascii?Q?8pLCzbrBYhWy+8ZZpKpZZE2iOhESe9msWrAOpKOYS0u7hy7Fyd0lAem2Khim?=
 =?us-ascii?Q?wAPuH39RgVB0cEVepdbvfzG8JPWw3KQ0LHKW7bJ39Lncvhtx4zZNVLpf5BAx?=
 =?us-ascii?Q?957VF+wOdTIW3LrI+PLJE6hoUHZZN5I9R/238/5IcH45tjMlOS1fbKf2y2qd?=
 =?us-ascii?Q?UMGqcVJ/h4/BbJES030+e8z40y50+nydcSokEL187FsTiaGijG3MjKUdfVEz?=
 =?us-ascii?Q?hv8VUmDX4VoJDbDB+cLVndsoLOcj+0AlJD/mb7VnjOHmM4vkCgcf6Uq1RItN?=
 =?us-ascii?Q?/Or+v15Bh36vT0LXFx1EKIaIhjLNK0bpLEu1jwovLIIrRR93GLNvJDnhUh6E?=
 =?us-ascii?Q?UrCxylAXCr2CRI2fL9ns8Z/0v/GvABR3d3TKFsjDh99fU8zT+x2iOb3vDhMW?=
 =?us-ascii?Q?amfRIN0ky3mRhzd0fsxfcmGaBoBFuxk3hLiMkoU3Wr1amb40eesO9X+m+ddi?=
 =?us-ascii?Q?TB9WQgurOHF4n6xWZVXPzQLwEShNAItP9zfYvkQLBZHhKLQ9hmhxvBZMpn8E?=
 =?us-ascii?Q?tVcWfyNG5cVApcLYA7a5SKmFMQyUB2tEAY4Sm6P5Jx+ZSLaSN6CrBJhDHlbf?=
 =?us-ascii?Q?GCxYXqDKjall4szMaP3cyQPAGTdzxK7IWUTCih9YM0W/wVX22Vuy15NC/ulp?=
 =?us-ascii?Q?yxbpFbrdObikUHdIirJ6izXrC5AjZ0KlO7u+4+QyN2uNzyxgCSREv1fT4kSA?=
 =?us-ascii?Q?D22mWQl2gGVuEqOILHVeAh00O+rTrQFkx9SooosWGD1vyFUnveWEzMT0w4jM?=
 =?us-ascii?Q?GjXZVbfWDwtu8N46ywUs17WHrSbX7jyiobt3lkD3IqzWvkKpZ/NaG5iwdx4s?=
 =?us-ascii?Q?SIyS0bl29Z+hjsmoKRcFDpecppA/esdnD+mXvFF/Z2smINVQO0KdvoV7fWai?=
 =?us-ascii?Q?BtjenAWVI8nlooC/clP79AOblXGcQ7oOQl4geUR+ptzNT5YnQ8msryZl4rBH?=
 =?us-ascii?Q?DHRdE1mJXm0ppIPe/xEim8Zwjn8mp19vkO2jUscos52B4b8y6x/thnwHq2g8?=
 =?us-ascii?Q?1i8fkbZpGeu7E1gcFxWoDijqUYAh8jcQsnx0rZIdVww4+DMZj6i4Q0aF6B/k?=
 =?us-ascii?Q?0AIz6E+eHl0GjnrNrOgOstKZaLEvTJc7nrO7BDskb987Ek7GOKtIU2B54fkp?=
 =?us-ascii?Q?rqPPp9j0kd8GCw4dVo658fcQ/CmJmDYp2TMDj5JCi26rLr9quNMkyPOCyImz?=
 =?us-ascii?Q?C4eZ08BV/O5gABw63+lKsGsrMuDT4/zQcJ8XlFLx?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb554600-6fef-4996-fee9-08daf245f558
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2023 13:32:30.9886
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mn8MxGqMmbRgd5G3RDaExE+Evo1IPHcwCPRdnqDwAavEYHbLB4fOl+lP4X17gl6oYlD4O4pexJBMBGfYr2qbqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5056
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Or Gerlitz <ogerlitz@nvidia.com>

For ddp setup/teardown and resync, the offloading logic
uses HW resources at the NIC driver such as SQ and CQ.

These resources are destroyed when the netdevice does down
and hence we must stop using them before the NIC driver
destroys them.

Use netdevice notifier for that matter -- offloaded connections
are stopped before the stack continues to call the NIC driver
close ndo.

We use the existing recovery flow which has the advantage
of resuming the offload once the connection is re-set.

This also buys us proper handling for the UNREGISTER event
b/c our offloading starts in the UP state, and down is always
there between up to unregister.

Signed-off-by: Or Gerlitz <ogerlitz@nvidia.com>
Signed-off-by: Boris Pismenny <borisp@nvidia.com>
Signed-off-by: Ben Ben-Ishay <benishay@nvidia.com>
Signed-off-by: Yoray Zack <yorayz@nvidia.com>
Signed-off-by: Shai Malin <smalin@nvidia.com>
Signed-off-by: Aurelien Aptel <aaptel@nvidia.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
---
 drivers/nvme/host/tcp.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 4bd2b03dcf4f..52e0db53d067 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -203,6 +203,7 @@ struct nvme_tcp_ctrl {
 
 static LIST_HEAD(nvme_tcp_ctrl_list);
 static DEFINE_MUTEX(nvme_tcp_ctrl_mutex);
+static struct notifier_block nvme_tcp_netdevice_nb;
 static struct workqueue_struct *nvme_tcp_wq;
 static const struct blk_mq_ops nvme_tcp_mq_ops;
 static const struct blk_mq_ops nvme_tcp_admin_mq_ops;
@@ -3107,6 +3108,30 @@ static struct nvme_ctrl *nvme_tcp_create_ctrl(struct device *dev,
 	return ERR_PTR(ret);
 }
 
+static int nvme_tcp_netdev_event(struct notifier_block *this,
+				 unsigned long event, void *ptr)
+{
+	struct net_device *ndev = netdev_notifier_info_to_dev(ptr);
+	struct nvme_tcp_ctrl *ctrl;
+
+	switch (event) {
+	case NETDEV_GOING_DOWN:
+		mutex_lock(&nvme_tcp_ctrl_mutex);
+		list_for_each_entry(ctrl, &nvme_tcp_ctrl_list, list) {
+			if (ndev != ctrl->offloading_netdev)
+				continue;
+			nvme_tcp_error_recovery(&ctrl->ctrl);
+		}
+		mutex_unlock(&nvme_tcp_ctrl_mutex);
+		flush_workqueue(nvme_reset_wq);
+		/*
+		 * The associated controllers teardown has completed, ddp contexts
+		 * were also torn down so we should be safe to continue...
+		 */
+	}
+	return NOTIFY_DONE;
+}
+
 static struct nvmf_transport_ops nvme_tcp_transport = {
 	.name		= "tcp",
 	.module		= THIS_MODULE,
@@ -3121,13 +3146,26 @@ static struct nvmf_transport_ops nvme_tcp_transport = {
 
 static int __init nvme_tcp_init_module(void)
 {
+	int ret;
+
 	nvme_tcp_wq = alloc_workqueue("nvme_tcp_wq",
 			WQ_MEM_RECLAIM | WQ_HIGHPRI, 0);
 	if (!nvme_tcp_wq)
 		return -ENOMEM;
 
+	nvme_tcp_netdevice_nb.notifier_call = nvme_tcp_netdev_event;
+	ret = register_netdevice_notifier(&nvme_tcp_netdevice_nb);
+	if (ret) {
+		pr_err("failed to register netdev notifier\n");
+		goto out_free_workqueue;
+	}
+
 	nvmf_register_transport(&nvme_tcp_transport);
 	return 0;
+
+out_free_workqueue:
+	destroy_workqueue(nvme_tcp_wq);
+	return ret;
 }
 
 static void __exit nvme_tcp_cleanup_module(void)
@@ -3135,6 +3173,7 @@ static void __exit nvme_tcp_cleanup_module(void)
 	struct nvme_tcp_ctrl *ctrl;
 
 	nvmf_unregister_transport(&nvme_tcp_transport);
+	unregister_netdevice_notifier(&nvme_tcp_netdevice_nb);
 
 	mutex_lock(&nvme_tcp_ctrl_mutex);
 	list_for_each_entry(ctrl, &nvme_tcp_ctrl_list, list)
-- 
2.31.1

