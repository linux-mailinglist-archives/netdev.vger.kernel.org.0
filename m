Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C94DA42ED04
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 11:01:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236244AbhJOJDz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 05:03:55 -0400
Received: from mail-eopbgr70088.outbound.protection.outlook.com ([40.107.7.88]:52805
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234459AbhJOJDz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Oct 2021 05:03:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j/Cjmmo9+xGCWl3CfX5pAoH17EyGr2GFUkY/Mg34310o+pscVfMN8ahd394a8KOwPgagp1akCxeYCNLwwO9l1/06/KV5UyV40/BGsxSSM7YygZvVtMQib5ceHaJRaCQg6kiKz6Y3/c2OszPJ8hmsnPuqP9gzqm8GxY56d2A9viqxIS934Acx0470F6OqJ3Qxa3JufM7RsAUbe6FDk6o6J8gdcelbCCTjt3r7xZ4cHnTKLaKsdEjNLmnAPDxEIF5Op77zAv6V9pfpXleqPHgI5cbiZsObbdgmDG5Z+yRlQNXA9GjOhWJfDEzEqcft0NySw7juItlLLdXoDM8VNY+ndA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+5vuBk1oKoBLESZVzDOGLFxzl0lhpKCyokzqteHL2WQ=;
 b=Oma5iKPcD4dJaxWU+Z+PksPpQPdX92auXezYI6MJofTtHq5znnSL+QQtmKt7NPvNvKi/r2uEStlyplLYdBQPbUWNtcRV++QrRa+SJsK/4fIMEWAK5oQ98Oaoo8dr44HUgq2ICwpgCayiCn5lojiRj96hTvJLJgFtoCMW+LIPtQNdJROc7pIbAxhaZJ0oNgrTcYqwpUUW3oqjgUps/zPJgT8k5ypB9Uo22DJpmsxlJVhMA5AGxpKugbKzX62cguydotO6AeqfK0ZMvzbLb0u19j7ptke524O8otW9P9oJba+z7p5DOjBkAoQn5e1wUxsqkvSg8yIPf7iGhf8sqtXzpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+5vuBk1oKoBLESZVzDOGLFxzl0lhpKCyokzqteHL2WQ=;
 b=SXNQKoF6mVh17ast2Q0UkM4RtUjsEZc6ZLjVbYwzJ2QJGkUvg67hKC0L9K9S4J1VHkAJpwgS84bEXjEejPaMqZo9qhzu5HHuUjrWqQDGZxAtjj0iBtHzogoyKkVGTutMJ9l5MaKNWh9Yrv2gbEeuU+KOoH6BuEqVGSN5nvSKBUk=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from AM4PR0401MB2308.eurprd04.prod.outlook.com
 (2603:10a6:200:4f::13) by AM0PR04MB5988.eurprd04.prod.outlook.com
 (2603:10a6:208:11b::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15; Fri, 15 Oct
 2021 09:01:47 +0000
Received: from AM4PR0401MB2308.eurprd04.prod.outlook.com
 ([fe80::6476:5ddb:7bf2:e726]) by AM4PR0401MB2308.eurprd04.prod.outlook.com
 ([fe80::6476:5ddb:7bf2:e726%8]) with mapi id 15.20.4587.031; Fri, 15 Oct 2021
 09:01:46 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     youri.querry_1@nxp.com, leoyang.li@nxp.com, netdev@vger.kernel.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH v2 net-next 1/5] soc: fsl: dpio: extract the QBMAN clock frequency from the attributes
Date:   Fri, 15 Oct 2021 12:01:23 +0300
Message-Id: <20211015090127.241910-2-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211015090127.241910-1-ioana.ciornei@nxp.com>
References: <20211015090127.241910-1-ioana.ciornei@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM8P190CA0018.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:219::23) To AM4PR0401MB2308.eurprd04.prod.outlook.com
 (2603:10a6:200:4f::13)
MIME-Version: 1.0
Received: from yoga-910.localhost (188.26.184.231) by AM8P190CA0018.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:219::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend Transport; Fri, 15 Oct 2021 09:01:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 453e63b0-198d-4e8a-6306-08d98fba6ab9
X-MS-TrafficTypeDiagnostic: AM0PR04MB5988:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB59880FB3451616C36644FC4EE0B99@AM0PR04MB5988.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OW1LTiIUMMeUFYsyEjIaIii5MzbBaqmlDo3VkoaAsLqv0vBx/RtVYdyNYRu2ggfrsvSxBOWNxfeBa+O44kXl3HXipyNXmaV1LhCdfRxyVkzcyxB40udhAdrzenpn6ZtjU2L9XeQjdvVEr4c2LKfNMSXKZK38bYPPvKwgCOzl8mtGJh/ia+fDPPBqiVJuLKa0P9s5cOV/JO949i3oEs/tV6WV1VG0vGknRMW0jztbuGwZODarqBFozKucwpjs/QdO0FiNQduea2UPuB1siU8RQSp2nEaM0K4vjwjZpWler9xOBk381Z7IJu+ya1HoiXDgh409NzXc58/zFMgttFDiL6A9LyYrD8Q+gLhYlZnz8Jajcbx0ABpcnYI2BW9Kw4/Gk/dS2vQcmeLb7yMioFUgodWpzDZVcRykIwSlsijBwmU1pdpRP+g+ebvMzVhOPmud16OcR+EBYbK/qZdvcbMEWWqN4baiEa3MiP9GQhb1Jg5uG5FGB3m2krfRqxdnjpE08wlQup/g1hRWAL0snvco5fIWFr2IYbr5vxFPMhadtHItpRogrjO/OQ9aE9FYcPTVamasXS3b83MYHizpl73cGY0pkJooKsdZOweimZ9UJQEBZJBzY5eWK8afvLJ8pRf5yX3SNo2sB0sHs8VB2COxiTCFH6EgDtp7Sn0CsxJiapsWnmfzXS8dcT18Sb01ib54N1ALizN0+Em6TdYuaX61jQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM4PR0401MB2308.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(2616005)(956004)(4326008)(44832011)(6486002)(8936002)(36756003)(8676002)(86362001)(2906002)(6506007)(186003)(66946007)(66476007)(66556008)(26005)(1076003)(52116002)(38100700002)(38350700002)(6666004)(508600001)(6512007)(83380400001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?s5btT35vfCkseJP+GWpHoeGk/KhS95LAGcInu+mUPxkkHlyNydE6NR/VQiVr?=
 =?us-ascii?Q?f7c1fLMysCK9XuVZo0aXEaB0Ec1h2S/zHWGckVSFyqpWrbI3yckLthi+e9Hn?=
 =?us-ascii?Q?rJU5ZTj0u5eyMbI1fp/EOFGWYMPWP58wzdmaeUfyzn/3JDFfEsSeTCPD6Lwk?=
 =?us-ascii?Q?hIMQzGluOBb9P946qNOH4gJnhrIlfwiKCjGQFeEWa3kEgVH1uBniHhxdbsCC?=
 =?us-ascii?Q?TQEmwPPkgpYRonJ9FxLtk7HqbCVmH0p53g5pRGGnlbIFmr0NWLE1P8gTMqCu?=
 =?us-ascii?Q?DptpKcWLaZOC8zP9GlNbUvRIo5+UW+u8yfZJl+Sroi7sCoSWnBEQIrDQ6QNK?=
 =?us-ascii?Q?qkrNn6xvPOKomvsF7l3PDo8OwmpFd687k65ljj8m/CHVh0cDoB0co4mU127Z?=
 =?us-ascii?Q?HdPSLA4A0MwKv5Rs24RK5WzM7vYK4JhilfMSDip9zyvkLpttwyn7G1JUJp2G?=
 =?us-ascii?Q?v23Lw/4zRU6t8WglpObcXJCkF+x49kHBZmq6H+znJ7w1HIUBjZywLUz74n3P?=
 =?us-ascii?Q?D/93AZI2ZJllZPFjuSqjHrqa8ygIcnkyyA8xCfUDtTBhg7nSrdOiBCAmJIBf?=
 =?us-ascii?Q?+9RyX17yERizwZAMdCgpb/q45Z5RL9QY7ZFvH1u1rFxsXZLI3eA84ElVOo/1?=
 =?us-ascii?Q?BG0PsidJGI5dkSSSMoTpVVCexHd4LzHiNgP3zvlq0UFGueL34L63eW6bomwG?=
 =?us-ascii?Q?VMPn1w2wa96wlDb9RHcgItZV1wNzL+HCPyQbLEmSuV3RhPEY9c0SG3L2edsw?=
 =?us-ascii?Q?r6Z5bnC/VpBYQysitBDV6R7EpRjJ9upvj85jDSLEntHMJtimb7goYMDc8Fva?=
 =?us-ascii?Q?DwGbe7LLfIZ9ACl7wXIsWKRvTXhqlrLlxLXzQd60JF2DweS0zb0WePW8oh4j?=
 =?us-ascii?Q?Gk6GBiv8EytLN3CKOMSFAXMjT8wMb7RCxj+xoVwQE6YPH1jhLpwiIuX7v7i0?=
 =?us-ascii?Q?DjJhEadfCuQlbY5aZ6Q1SCwjLqeX+SWC0BHxHCfC7pOScrMvBCOPABQFBSG3?=
 =?us-ascii?Q?SSZRUZitEALWCpV4ThibqLdmxXKjACqfszi2pjgNYP+7doUlTi1Yz+fOk3hA?=
 =?us-ascii?Q?dqF7Yu3vYjNPtB82KiYUnVLlVVMth9euQb1x17H7942hp/cibwzkGek+udPM?=
 =?us-ascii?Q?s5JFJO2w9MDBh9yuAnVOUsWv69W6xPlSjthazm5NXIu8y4NZ3/JpO+z2VjGQ?=
 =?us-ascii?Q?xiuWqw74A4A4MpyaecUKMMKmHsKBZwViKvfQpPV9iQExmchc13j/wCdbl1NU?=
 =?us-ascii?Q?BVHOM46kaEKhOFf6gEU/TwH+Wv6732nhRTyv3ImVD/Qbd1FlOrSE9E7GHPP5?=
 =?us-ascii?Q?dtwsUdOIPqAgIg+arSDnWNg1?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 453e63b0-198d-4e8a-6306-08d98fba6ab9
X-MS-Exchange-CrossTenant-AuthSource: AM4PR0401MB2308.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2021 09:01:46.8588
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NaSKzSh6qE64d4nY9uwMYglqgir6UoXYbyiSJX/CRroxaULqBUmTFw9J0AaSmPTVVhqaal8Wqwm6PVmtNMqUbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5988
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Through the dpio_get_attributes() firmware call the dpio driver has
access to the QBMAN clock frequency. Extend the structure which holds
the firmware's response so that we can have access to this information.

This will be needed in the next patches which also add support for
interrupt coalescing which needs to be configured based on the
frequency.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v2:
 - documented the new qman_clk field

 drivers/soc/fsl/dpio/dpio-cmd.h     | 3 +++
 drivers/soc/fsl/dpio/dpio-driver.c  | 1 +
 drivers/soc/fsl/dpio/dpio-service.c | 1 +
 drivers/soc/fsl/dpio/dpio.c         | 1 +
 drivers/soc/fsl/dpio/dpio.h         | 2 ++
 drivers/soc/fsl/dpio/qbman-portal.h | 1 +
 include/soc/fsl/dpaa2-io.h          | 2 ++
 7 files changed, 11 insertions(+)

diff --git a/drivers/soc/fsl/dpio/dpio-cmd.h b/drivers/soc/fsl/dpio/dpio-cmd.h
index e13fd3ac1939..2fbcb78cdaaf 100644
--- a/drivers/soc/fsl/dpio/dpio-cmd.h
+++ b/drivers/soc/fsl/dpio/dpio-cmd.h
@@ -46,6 +46,9 @@ struct dpio_rsp_get_attr {
 	__le64 qbman_portal_ci_addr;
 	/* cmd word 3 */
 	__le32 qbman_version;
+	__le32 pad1;
+	/* cmd word 4 */
+	__le32 clk;
 };
 
 struct dpio_stashing_dest {
diff --git a/drivers/soc/fsl/dpio/dpio-driver.c b/drivers/soc/fsl/dpio/dpio-driver.c
index 7f397b4ad878..dd948889eeab 100644
--- a/drivers/soc/fsl/dpio/dpio-driver.c
+++ b/drivers/soc/fsl/dpio/dpio-driver.c
@@ -162,6 +162,7 @@ static int dpaa2_dpio_probe(struct fsl_mc_device *dpio_dev)
 		goto err_get_attr;
 	}
 	desc.qman_version = dpio_attrs.qbman_version;
+	desc.qman_clk = dpio_attrs.clk;
 
 	err = dpio_enable(dpio_dev->mc_io, 0, dpio_dev->mc_handle);
 	if (err) {
diff --git a/drivers/soc/fsl/dpio/dpio-service.c b/drivers/soc/fsl/dpio/dpio-service.c
index 7351f3030550..2acbb96c5e45 100644
--- a/drivers/soc/fsl/dpio/dpio-service.c
+++ b/drivers/soc/fsl/dpio/dpio-service.c
@@ -127,6 +127,7 @@ struct dpaa2_io *dpaa2_io_create(const struct dpaa2_io_desc *desc,
 	obj->dpio_desc = *desc;
 	obj->swp_desc.cena_bar = obj->dpio_desc.regs_cena;
 	obj->swp_desc.cinh_bar = obj->dpio_desc.regs_cinh;
+	obj->swp_desc.qman_clk = obj->dpio_desc.qman_clk;
 	obj->swp_desc.qman_version = obj->dpio_desc.qman_version;
 	obj->swp = qbman_swp_init(&obj->swp_desc);
 
diff --git a/drivers/soc/fsl/dpio/dpio.c b/drivers/soc/fsl/dpio/dpio.c
index af74c597a675..8ed606ffaac5 100644
--- a/drivers/soc/fsl/dpio/dpio.c
+++ b/drivers/soc/fsl/dpio/dpio.c
@@ -162,6 +162,7 @@ int dpio_get_attributes(struct fsl_mc_io *mc_io,
 	attr->qbman_portal_ci_offset =
 		le64_to_cpu(dpio_rsp->qbman_portal_ci_addr);
 	attr->qbman_version = le32_to_cpu(dpio_rsp->qbman_version);
+	attr->clk = le32_to_cpu(dpio_rsp->clk);
 
 	return 0;
 }
diff --git a/drivers/soc/fsl/dpio/dpio.h b/drivers/soc/fsl/dpio/dpio.h
index da06f7258098..7fda44f0d7f4 100644
--- a/drivers/soc/fsl/dpio/dpio.h
+++ b/drivers/soc/fsl/dpio/dpio.h
@@ -59,6 +59,7 @@ int dpio_disable(struct fsl_mc_io	*mc_io,
  * @num_priorities: Number of priorities for the notification channel (1-8);
  *			relevant only if 'channel_mode = DPIO_LOCAL_CHANNEL'
  * @qbman_version: QBMAN version
+ * @clk: QBMAN clock frequency value in Hz
  */
 struct dpio_attr {
 	int			id;
@@ -68,6 +69,7 @@ struct dpio_attr {
 	enum dpio_channel_mode	channel_mode;
 	u8			num_priorities;
 	u32		qbman_version;
+	u32		clk;
 };
 
 int dpio_get_attributes(struct fsl_mc_io	*mc_io,
diff --git a/drivers/soc/fsl/dpio/qbman-portal.h b/drivers/soc/fsl/dpio/qbman-portal.h
index c7c2225b7d91..f058289416af 100644
--- a/drivers/soc/fsl/dpio/qbman-portal.h
+++ b/drivers/soc/fsl/dpio/qbman-portal.h
@@ -24,6 +24,7 @@ struct qbman_swp_desc {
 	void *cena_bar; /* Cache-enabled portal base address */
 	void __iomem *cinh_bar; /* Cache-inhibited portal base address */
 	u32 qman_version;
+	u32 qman_clk;
 };
 
 #define QBMAN_SWP_INTERRUPT_EQRI 0x01
diff --git a/include/soc/fsl/dpaa2-io.h b/include/soc/fsl/dpaa2-io.h
index c9d849924f89..041ebf7d804c 100644
--- a/include/soc/fsl/dpaa2-io.h
+++ b/include/soc/fsl/dpaa2-io.h
@@ -44,6 +44,7 @@ struct device;
  * @regs_cinh:      The cache inhibited regs
  * @dpio_id:        The dpio index
  * @qman_version:   The qman version
+ * @qman_clk:       The qman clock frequency in Hz
  *
  * Describes the attributes and features of the DPIO object.
  */
@@ -55,6 +56,7 @@ struct dpaa2_io_desc {
 	void __iomem *regs_cinh;
 	int dpio_id;
 	u32 qman_version;
+	u32 qman_clk;
 };
 
 struct dpaa2_io *dpaa2_io_create(const struct dpaa2_io_desc *desc,
-- 
2.31.1

