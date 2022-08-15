Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DB2859315B
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 17:12:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243109AbiHOPM3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 11:12:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242998AbiHOPMC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 11:12:02 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2084.outbound.protection.outlook.com [40.107.93.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7BCC205CD;
        Mon, 15 Aug 2022 08:11:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b59A+/0OFjv39LEgQcvrJ5v7OHkGCBMgiecAn+RL8aM8u9d55vkQZ1I9nKnx+9dqSjvYj20ct59FgtBctMtf5BUldZAKq1mdx1mVFZDRb9RF2H5nG+kapcBraCjnzG04/KRF5XeUYIL2Q2RUB0dFyaX7uReahFaKeUSSEAqRuHAllodBKKZzvdOw9gENkw4nwyBqPJrNWH5oEtGu7aWTAo9Wilh7rEWLH+VNPn2fmQPuwyg+jtxmTPTKLfG+IhlGOXXtyjiCXtyGyHHPw55zVN/ULjHLdvEWR5v2u6gkXdLnyltQwNgRuXiuymZ0TfkK+r9gt1azM9tDGkRwdYuY2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bGO3TkiTw2iOXlUmxtzzhx3ffvb85wgCEX2VrsXq2pE=;
 b=DjJyCtdXZI6GhH37/4ul5zX2J5EnrsEM4WhMDo+MC9l1AzBfirdrMeqr6pulS91HnlafB12cusuML4vyzWZkAdqFGqDdClBfwkL6/NYqoe9A5awBl7mXgR5BB/shMSfNrDRpn97ePfA9EcVUBdk9XtJpGX8KflzNok5tM6TRoqKNcdnuxHNXaJX9yOu8+CNtrLwptsfLdAh3/TlWuAvEkcAEShETUisjaY6cXGmWC2zh1+Bb1/tOw2SRJixgoEPydF+Fwa3zDV9Sn16F4443albWsXIbzsBtyG1aL2BY9sNwQBn9/46SCHJv1xs00Iq3UYVzfTlpuLCm8A1MoBdDYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bGO3TkiTw2iOXlUmxtzzhx3ffvb85wgCEX2VrsXq2pE=;
 b=Z/MBXHwcfuTS0TAUHXhnRoAue1Ys5zLZc6S98ZfxZ/3J5e/eoiW8MautFHw1BTPeDKt30b+EVo5pCvp3ByQUOLKVl0TvTarXBVMRdfZvAv17rNLEfc7E92qpsCzhJsBWGANpA285uwO9xoLxOt06/5v7rQvyps310t/t9wWMzOx6+d7rZCxjCwzQ1eROmpY9Cciro19RUxG34O9I+5wn7AlHhZvAxclHRXH9EggDm9crt2eIaJ/2o7NpRGjTXdhAG1jurvkSdeXBaHsiZECFWBcQhInLoOimXlDcVVii0Cg8JQI0k222YTjRNiqUtzA14vmB9yPyKf5VMl6Tnrc2lw==
Received: from MW4PR03CA0065.namprd03.prod.outlook.com (2603:10b6:303:b6::10)
 by DM5PR12MB1420.namprd12.prod.outlook.com (2603:10b6:3:78::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.19; Mon, 15 Aug
 2022 15:11:53 +0000
Received: from CO1NAM11FT113.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b6:cafe::68) by MW4PR03CA0065.outlook.office365.com
 (2603:10b6:303:b6::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.16 via Frontend
 Transport; Mon, 15 Aug 2022 15:11:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT113.mail.protection.outlook.com (10.13.174.180) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5546.7 via Frontend Transport; Mon, 15 Aug 2022 15:11:52 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.38; Mon, 15 Aug 2022 15:11:51 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Mon, 15 Aug 2022 08:11:50 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.29 via Frontend
 Transport; Mon, 15 Aug 2022 08:11:47 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <saeedm@nvidia.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <cohuck@redhat.com>
Subject: [PATCH V4 vfio 03/10] vfio: Introduce DMA logging uAPIs
Date:   Mon, 15 Aug 2022 18:11:02 +0300
Message-ID: <20220815151109.180403-4-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220815151109.180403-1-yishaih@nvidia.com>
References: <20220815151109.180403-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e0bd148f-2e34-4699-1d9c-08da7ed07c4d
X-MS-TrafficTypeDiagnostic: DM5PR12MB1420:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S3J57SjIP+YU6rVYIRgbjGTFQDsNRw9EyQOGs9jlh5ltFI0fRRZn2dBHhLUMJRqHYuJnMyprNgCbSqwtvmirXifet0zjzmX8mSsiC9wjz7tQuRssJXovk1uTJsSlj1BlUfWsi8lpmkzgJumkfKMDLBGqg3GWhBUsW+xRmDl6gz0/Ka0Z6aqFuC+v53XYJRaY4aicq1VxgSBiQfzK5AzvmVX598YQT0LMinQ7JkSFx90i9Z6BdSSLBIJvGtpQq/3AFEykGXSGORnq00wvyeWGg8wrC6a1+90+/20OZaW5PrsxOSt7v0YpDvTkCdsoXIiqhS31hOWuelBjvGQQQwDXnoW7vHyutTsf+dZcQJ5jGFam6H6tXPAvbj652P9yl4MYlOOj75P8WNc2OImXuCHf0v2omh0yYz7g49iyScUctqDxgW+KbsOq8fWSCYADK26y2Xlnm2916tvc98wLsCJ8PzWJi/MAsb0+ImsCoQyV2C6pJ8YQpJ1B550V+hh8V96fsdj0xprMivg6YVv6ds3RLYfqi7Vt504AEh0jhbbibr/LKxE8QA6S2WD5fV2m65u7ZNS6r7hqWNljRmtYyoLIj55qbw/+FPdpxZkgD6goYydIOskC5Bj8UKUVWnXtoW8vVrWfOPWFsayrFxS/okw3YPPzRmBsRgmhR05IqoJHPd3JTjJ4Ucn0gNA72hqox4j+/tNBwaux0lETwsAHlhCEW0qH3Zo6EASo4YTczQEm6PmXmfUMBfAf3pRxYVhEaukxXJ2/bXHNvAfOPsO3nllHlFyZcgWgg5lNOpEyAV1HPRXuYZZllyHSVsofc0JiTrXWEdcF06IVz9q0Ayc3133cnQ==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(39860400002)(376002)(396003)(40470700004)(36840700001)(46966006)(2906002)(36756003)(4326008)(8676002)(70206006)(70586007)(54906003)(316002)(478600001)(6636002)(110136005)(82310400005)(1076003)(2616005)(426003)(336012)(26005)(7696005)(41300700001)(82740400003)(47076005)(83380400001)(186003)(5660300002)(40480700001)(6666004)(36860700001)(8936002)(40460700003)(356005)(81166007)(86362001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2022 15:11:52.8353
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e0bd148f-2e34-4699-1d9c-08da7ed07c4d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT113.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1420
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DMA logging allows a device to internally record what DMAs the device is
initiating and report them back to userspace. It is part of the VFIO
migration infrastructure that allows implementing dirty page tracking
during the pre copy phase of live migration. Only DMA WRITEs are logged,
and this API is not connected to VFIO_DEVICE_FEATURE_MIG_DEVICE_STATE.

This patch introduces the DMA logging involved uAPIs.

It uses the FEATURE ioctl with its GET/SET/PROBE options as of below.

It exposes a PROBE option to detect if the device supports DMA logging.
It exposes a SET option to start device DMA logging in given IOVAs
ranges.
It exposes a SET option to stop device DMA logging that was previously
started.
It exposes a GET option to read back and clear the device DMA log.

Extra details exist as part of vfio.h per a specific option.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 include/uapi/linux/vfio.h | 86 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 86 insertions(+)

diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 733a1cddde30..aa63effc38e8 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -986,6 +986,92 @@ enum vfio_device_mig_state {
 	VFIO_DEVICE_STATE_RUNNING_P2P = 5,
 };
 
+/*
+ * Upon VFIO_DEVICE_FEATURE_SET start/stop device DMA logging.
+ * VFIO_DEVICE_FEATURE_PROBE can be used to detect if the device supports
+ * DMA logging.
+ *
+ * DMA logging allows a device to internally record what DMAs the device is
+ * initiating and report them back to userspace. It is part of the VFIO
+ * migration infrastructure that allows implementing dirty page tracking
+ * during the pre copy phase of live migration. Only DMA WRITEs are logged,
+ * and this API is not connected to VFIO_DEVICE_FEATURE_MIG_DEVICE_STATE.
+ *
+ * When DMA logging is started a range of IOVAs to monitor is provided and the
+ * device can optimize its logging to cover only the IOVA range given. Each
+ * DMA that the device initiates inside the range will be logged by the device
+ * for later retrieval.
+ *
+ * page_size is an input that hints what tracking granularity the device
+ * should try to achieve. If the device cannot do the hinted page size then
+ * it's the driver choice which page size to pick based on its support.
+ * On output the device will return the page size it selected.
+ *
+ * ranges is a pointer to an array of
+ * struct vfio_device_feature_dma_logging_range.
+ *
+ * The core kernel code guarantees to support by minimum num_ranges that fit
+ * into a single kernel page. User space can try higher values but should give
+ * up if the above can't be achieved as of some driver limitations.
+ *
+ * A single call to start device DMA logging can be issued and a matching stop
+ * should follow at the end. Another start is not allowed in the meantime.
+ */
+struct vfio_device_feature_dma_logging_control {
+	__aligned_u64 page_size;
+	__u32 num_ranges;
+	__u32 __reserved;
+	__aligned_u64 ranges;
+};
+
+struct vfio_device_feature_dma_logging_range {
+	__aligned_u64 iova;
+	__aligned_u64 length;
+};
+
+#define VFIO_DEVICE_FEATURE_DMA_LOGGING_START 3
+
+/*
+ * Upon VFIO_DEVICE_FEATURE_SET stop device DMA logging that was started
+ * by VFIO_DEVICE_FEATURE_DMA_LOGGING_START
+ */
+#define VFIO_DEVICE_FEATURE_DMA_LOGGING_STOP 4
+
+/*
+ * Upon VFIO_DEVICE_FEATURE_GET read back and clear the device DMA log
+ *
+ * Query the device's DMA log for written pages within the given IOVA range.
+ * During querying the log is cleared for the IOVA range.
+ *
+ * bitmap is a pointer to an array of u64s that will hold the output bitmap
+ * with 1 bit reporting a page_size unit of IOVA. The mapping of IOVA to bits
+ * is given by:
+ *  bitmap[(addr - iova)/page_size] & (1ULL << (addr % 64))
+ *
+ * The input page_size can be any power of two value and does not have to
+ * match the value given to VFIO_DEVICE_FEATURE_DMA_LOGGING_START. The driver
+ * will format its internal logging to match the reporting page size, possibly
+ * by replicating bits if the internal page size is lower than requested.
+ *
+ * The LOGGING_REPORT will only set bits in the bitmap and never clear or
+ * perform any initialization of the user provided bitmap.
+ *
+ * If any error is returned userspace should assume that the dirty log is
+ * corrupted. Error recovery is to consider all memory dirty and try to
+ * restart the dirty tracking, or to abort/restart the whole migration.
+ *
+ * If DMA logging is not enabled, an error will be returned.
+ *
+ */
+struct vfio_device_feature_dma_logging_report {
+	__aligned_u64 iova;
+	__aligned_u64 length;
+	__aligned_u64 page_size;
+	__aligned_u64 bitmap;
+};
+
+#define VFIO_DEVICE_FEATURE_DMA_LOGGING_REPORT 5
+
 /* -------- API for Type1 VFIO IOMMU -------- */
 
 /**
-- 
2.18.1

