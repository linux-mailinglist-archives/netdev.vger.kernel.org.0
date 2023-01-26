Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90A9F67D130
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 17:21:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232611AbjAZQVy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 11:21:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232494AbjAZQVw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 11:21:52 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2049.outbound.protection.outlook.com [40.107.92.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B60A855BC
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 08:21:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MEBkZXeXJDQx9SOilocPYy7yyM9cfpgR2Q0uqhhTDp33c+s31qQfmaLhEOgYAywjSHgg+suTPGMkEfP5A+mcJC8BpCo6jvKAlpwGscr2WAWezSGu982wXJ1t99jm0QpGHx+fho44GNOuBg46VmfMSnuStSDIlu4KX64T18yk9uinGJs1lPrNtmQuiaf380GWyZyrattsLWV1eWW3J0mAUYZVbq8LOeUfqLh9GlCKDMlg0Y9ylsyNWR1QhIHPe7mcAwki6S4MWSadOCgr2R7ChnPsvbRAXkeTOZcnP6tEvbmQbEOoA3zqDaSPjal1Cem4UwHP0RDO2D3l1i9uw9f4wQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V0V27EDISwYougR+lV6ULBQcCovHyiqw/G74Lg25Zyg=;
 b=dGqV1W+0Zj/tsTO31oWETRPeQArGfbnSnPPJs4LUeohJn1ptgxfaqgRN1jj6uThmq540SgYbibYCkqzeRG0mT/DmeZzK+FwtVBkbrwF2Pzz4I+YqQOtjm4rHKNjKMCVCUIXP8h55NAOHSOVyDnRENFJNXxQCM5dESC9mhJYzLqAB8/+Aso/aOb++QOVjc/tnjk4Z0eQqxvxOajdEVU7XLt9LpbpAAiT/A/AyPb6SEq47Wu2breHyb+mlhVqMczJ8htzX9qgv2d7pQwHhglcOzBrwur3Q1KjJyiUvVyksua+NzeVk0eeapxb9CtXPZKmhzw9HZ0ZVk8G1e06Zx+ItvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V0V27EDISwYougR+lV6ULBQcCovHyiqw/G74Lg25Zyg=;
 b=ZLNjlhVJFBFZfkgpkJb6OdLTB53T71TX2K/KgywmDVcHKCU7wOYkGRKmp5kXtH+Yn7Z5AvYYFALajcW+A2zn/yi5bNqLo9vK2IRXv+bZLADPAh9b5fvx0Ap0QQJEo5aZo7LIhoZUm3uJOTIN9qFL+MSfPTbQ/kPIK3shvSruDf0sBMf+XCdjCG2SRC4zYB8pqijFmiEHI58khY94Cp//9gb6ItctHIDU5w3GVbAa/qPZoHy+MX216fNKMAtRZdQTMfUSogmjxJP/rLat32N+rIveh1COhucSL0M3CpVL+3tkKyY4pqW9vM3yDx55V2q3Raq868K/4RlxodNPFpPO8Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by PH0PR12MB7792.namprd12.prod.outlook.com (2603:10b6:510:281::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Thu, 26 Jan
 2023 16:21:47 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::9fd9:dadc:4d8a:2d84]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::9fd9:dadc:4d8a:2d84%6]) with mapi id 15.20.6043.022; Thu, 26 Jan 2023
 16:21:47 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, davem@davemloft.net, kuba@kernel.org
Cc:     aaptel@nvidia.com, aurelien.aptel@gmail.com, smalin@nvidia.com,
        malin1024@gmail.com, ogerlitz@nvidia.com, yorayz@nvidia.com,
        borisp@nvidia.com
Subject: [PATCH v10 00/25] nvme-tcp receive offloads
Date:   Thu, 26 Jan 2023 18:21:11 +0200
Message-Id: <20230126162136.13003-1-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0575.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:276::7) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|PH0PR12MB7792:EE_
X-MS-Office365-Filtering-Correlation-Id: 570a093e-3e95-431a-ab32-08daffb96be5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y3AZM/s2jrPeZtovzUG9TtVeGrv1XuebpDD17eles7BRndyRRJIu1+wsWDu5nSUv4hbcUZY4SRykpIi+wvvYUzRzVGaebTzIAt6gNZ4Hzl9XDumJ8MI0wO1Uhn3P8NtwXhyx5nxw46viv96DpZSCNJSH1X2+Zc7ZHSrKgx1QWHjYpg21uendV9CwpG/nNYC7hhXupo5apVgWh8rYC0gK7Erhga8qj+NA6PqMHOs7F4at4o7ugF23M7hrqeOaCMsLbCSJtrWmuT2AFmO98oqbMBadbvI2wBqbJy5fLRcYhLnE5kd5rQqQ6sGupmg741wxrtjY2Rw8BAjY//rVZtgiZtslOtX0McK4DgRMSdpk3aYXSewuyv5XrcPhpDO+IQv9kFqd6/pZP+Y/0w/f1+Tbq5u0y01LovnyRrnFHvbXPDcOmfGgxV0z3VS8nRUiJSih4T1+fLjs7h1BS64RJ4sldhenUIpF2X6jJawJ0g9uOvjL36Y/lPfvH2JRH08JVzT6R3Lq4FWXmpYBnsU/K+n3jsXlhYJxugM8i4lXomUqya/A+rZ9fempP7vQumZM/KTjRCrTenTcEJIf/wA1RFVdZUpL2akaawG4HD6LhCGGlU7B40uXZHuj2wXih2dNUI/Sju8Ud/3WQEDVmbu+7EUfkjWBpBHJdq3+t/fNS1Yly0xCSgkKcP1kCpUOHxRRCYQYVpRqhH5YPrDgPqC5PiVa2/0RsAlA6EjwOt5hboBTC4pvQMCL7vcrIVXezPbLSKxK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(39860400002)(136003)(396003)(366004)(376002)(451199018)(66899018)(4326008)(66476007)(316002)(36756003)(66556008)(86362001)(66946007)(8676002)(6512007)(107886003)(966005)(478600001)(2616005)(26005)(83380400001)(8936002)(186003)(6666004)(5660300002)(1076003)(6486002)(2906002)(7416002)(38100700002)(6506007)(41300700001)(30864003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d0lRbHNNYVRQcjJXZ2pHUDFIU25YdmtDWVl4Yk1ibmZNeUQ1OU1jZ1FyekJP?=
 =?utf-8?B?eUdGVzU5YXVZMTl2SDNSS254b0tKZ3NWZVBTT0YwNnBLL0crWnZoMENVUW5a?=
 =?utf-8?B?bWVvS09rRzN1a2Y1M0RmWE9YcVNucVNjVHg3UFhic1cxYmlGbTdZeVdIUzJw?=
 =?utf-8?B?V1l3M0dHeHY5VUxiUElFakpXQUNDKzVmM29WOU92QWdYVERZZC9DN0huaTZn?=
 =?utf-8?B?QVBEVjFiaUw0YUNxMHVFS1VoUE14OU82dDQ4cHMvOEdLRmpGN2NXMVgvZGZD?=
 =?utf-8?B?ZTM1M2F0UmlTN00ydjR4bFYrbGZwKzVKZ3JoRkhwaTRJZUFyaDhGdDR2N005?=
 =?utf-8?B?WEduQzJ4dlVLOW8rbFVTQWo5QVNPQVJmZzh0clNvb21DU3FtZGs5eVZtRVpo?=
 =?utf-8?B?ZnZ0WDZsMWpRTGVRMHh5UUJZN0VJSEJ1L1psdEs0RVpTMFEyYi8vL01WSWlG?=
 =?utf-8?B?alVBajRIeTBGWE03V0RWYVg0SCt0VVNYbitrOFd3VEZuM01YVEg1NWNqcWUv?=
 =?utf-8?B?UWEveGtncm5oL1VvL1BGNDY2Qk93c0pCb21OS2xoN0RZbUFGcU1aRnk3QWhB?=
 =?utf-8?B?cnJsZXMrTk93UVVTR2RvN0Y1d3RUTUwwYWw0MnM5TFhqa2ZQSWhyWnlJem82?=
 =?utf-8?B?SmJBcTFNaHNEUkhSTFhBdHduYWlNbXFMRzNVWDN6SFdJUm9FQ0VXNmdMSVV3?=
 =?utf-8?B?Q0ljOFZwaUt6VEY4elZyUzhzdmR0cmkvTmNKaTZOTlVBNkU2cFN4eXMya0kz?=
 =?utf-8?B?cXJ5RUdiSmwxQ2dBN0ZVanpscWxKdGNVbjFockhGVzl4N2VUMVljR2t3TlZW?=
 =?utf-8?B?MTVmVmxEWXZNYmdJSUpDWGpyalVsaVU4bXpOamZCNHQ1SVFPNU5ua2dhMUdM?=
 =?utf-8?B?NzRtM1p2OW1PemZWdER4VzRBSEZWNi9wWS9IVUVLbVpKMjlSQU9uclZiZ2h2?=
 =?utf-8?B?UmtoVlZEWVQ1U0RaWTBhMDBmSWhzb2ZtUFJRK3BoQVFZQ3U1ZVRBWDIzVCtE?=
 =?utf-8?B?c2xzdzBSSFNyZTc2cW9vRXNLeXZqWW1pNkRRQ0Jjc0hwSUNpWldnY1ljaEN5?=
 =?utf-8?B?Y3B4RU0xYmpDSGlhcXR6WlBPNEJtME5meVo0VzJ0NG55OHA0TlFYdmhXSFhr?=
 =?utf-8?B?UXhZdTlKQVlHWEZTN1NqVmxORm5DVGxYZ3h0ZUs2KzNGdUlPRnRCdE10Y1Zi?=
 =?utf-8?B?ZUJnb1JWQkkySW9JOE1JckJxSHF6Sk8xYXBDd05JZVZobWhpdy9aWHl1cTZC?=
 =?utf-8?B?emNOMm5paUM5b1NYSkRQL3VpL3ppenJuNXFXVTQ1ejF3ZEpXUTd4eW1yc09L?=
 =?utf-8?B?c001a0xaeW9PQTFaYU55cGxXYVZ2SEV3WHUwSlNpWjM1VEVqT3d3QlI3aHox?=
 =?utf-8?B?dUszQ1gyNzFUL1BkZUhuZmg5UndOejVYRkY2YmxEVktsaC9rR2tTVC82Tjha?=
 =?utf-8?B?YmZQWWVNRTZlaHNmNEIrZFdMMjdUMFdjZHI4VXdGYjZ2QVdaODh5UldXc1Rq?=
 =?utf-8?B?RUZ3bk1JM0REY1VuN2FCRU0xWkVsMjJnQjZtd3lKcG1vV3l5UWViL0h1QWZJ?=
 =?utf-8?B?NnJmdkQ4bEFndUllSVVEQVRJcHlSOU5LYlY2RDlqV1BETnkreG9mRW0xSkM5?=
 =?utf-8?B?cEVueDRpN0w3Q2Y3c014MnZTenlwdmIvdXRRTktHZm0yazhwSzF1M0RGWFlT?=
 =?utf-8?B?MUoydDIxMC9telJCK3ZmSlhyZSsxNkdyLytmTVVmbXF6NHVwUC8yZEE1UEF4?=
 =?utf-8?B?ZUhaQTM2T3dWR1hXN3hWRGVJSi9mRTdoZXNZUjBxMjZVMFhCTURMeVIrVnlD?=
 =?utf-8?B?bmVJMENFZTZpeE02SDFCdlJoZEkwcm1TL01EWDFhSUsxV2RFcThwVVp2LzI3?=
 =?utf-8?B?Ty9oNkVQaGdqMmNIUmRMeGFHWUswNWpPS2lYblFZS2NXNzdPcmV2VVJwZWJm?=
 =?utf-8?B?TEdxNFZFYmVDa0lac0RyTkxqT24xYmpGT2JhY2luYkdOajVPaS8yR3IrYUlN?=
 =?utf-8?B?UERWOVNndW5MOEFoUHExbkljeUZLbkRvMDlTSDdKOVYvZTBUK2l6amk2amJl?=
 =?utf-8?B?N3BxV2JpQXlRWVB4cXBFT0ZDQmJVTFhqTzdHQzJqTE9Va1ZaZmtzZ240TFky?=
 =?utf-8?Q?nvbVobcdAXTfkArSJj4W2I5oc?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 570a093e-3e95-431a-ab32-08daffb96be5
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2023 16:21:47.2311
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xp/tYRr/jY8DlRhLyt299AeuRbSfv5SZK8yytoaiKXG6/qZ/R1OJax/OTfpAyYfzRpdSknpwmtgXgBq8bQhdCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7792
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Here is the next iteration of our nvme-tcp receive offload series.

The main changes are in patch 1 (ulp crc check) and patches 2, 3, 4, 12 (netlink stats).

Rebased on top of today net-next
97f7d3dd761a ("Merge branch 'mptcp-add-mixed-v4-v6-support-for-the-in-kernel-pm'")

The changes are also available through git:

Repo: https://github.com/aaptel/linux.git branch nvme-rx-offload-v10
Web: https://github.com/aaptel/linux/tree/nvme-rx-offload-v10

The NVMeTCP offload was presented in netdev 0x16 (video now available):
- https://netdevconf.info/0x16/session.html?NVMeTCP-Offload-%E2%80%93-Implementation-and-Performance-Gains
- https://youtu.be/W74TR-SNgi4

From: Aurelien Aptel <aaptel@nvidia.com>
From: Shai Malin <smalin@nvidia.com>
From: Ben Ben-Ishay <benishay@nvidia.com>
From: Boris Pismenny <borisp@nvidia.com>
From: Or Gerlitz <ogerlitz@nvidia.com>
From: Yoray Zack <yorayz@nvidia.com>

=========================================

This series adds support for NVMe-TCP receive offloads. The method here
does not mandate the offload of the network stack to the device.
Instead, these work together with TCP to offload:
1. copy from SKB to the block layer buffers.
2. CRC calculation and verification for received PDU.

The series implements these as a generic offload infrastructure for storage
protocols, which calls TCP Direct Data Placement and TCP Offload CRC
respectively. We use this infrastructure to implement NVMe-TCP offload for
copy and CRC.
Future implementations can reuse the same infrastructure for other protocols
such as iSCSI.

Note:
These offloads are similar in nature to the packet-based NIC TLS offloads,
which are already upstream (see net/tls/tls_device.c).
You can read more about TLS offload here:
https://www.kernel.org/doc/html/latest/networking/tls-offload.html

Queue Level
===========
The offload for IO queues is initialized after the handshake of the
NVMe-TCP protocol is finished by calling `nvme_tcp_offload_socket`
with the tcp socket of the nvme_tcp_queue:
This operation sets all relevant hardware contexts in
hardware. If it fails, then the IO queue proceeds as usual with no offload.
If it succeeds then `nvme_tcp_setup_ddp` and `nvme_tcp_teardown_ddp` may be
called to perform copy offload, and crc offload will be used.
This initialization does not change the normal operation of NVMe-TCP in any
way besides adding the option to call the above mentioned NDO operations.

For the admin queue, NVMe-TCP does not initialize the offload.
Instead, NVMe-TCP calls the driver to configure limits for the controller,
such as max_hw_sectors and max_segments, these must be limited to accommodate
potential HW resource limits, and to improve performance.

If some error occurs, and the IO queue must be closed or reconnected, then
offload is teardown and initialized again. Additionally, we handle netdev
down events via the existing error recovery flow.

IO Level
========
The NVMe-TCP layer calls the NIC driver to map block layer buffers to CID
using `nvme_tcp_setup_ddp` before sending the read request. When the response
is received, then the NIC HW will write the PDU payload directly into the
designated buffer, and build an SKB such that it points into the destination
buffer. This SKB represents the entire packet received on the wire, but it
points to the block layer buffers. Once NVMe-TCP attempts to copy data from
this SKB to the block layer buffer it can skip the copy by checking in the
copying function: if (src == dst) -> skip copy

Finally, when the PDU has been processed to completion, the NVMe-TCP layer
releases the NIC HW context by calling `nvme_tcp_teardown_ddp` which
asynchronously unmaps the buffers from NIC HW.

The NIC must release its mapping between command IDs and the target buffers.
This mapping is released when NVMe-TCP calls the NIC
driver (`nvme_tcp_offload_socket`).
As completing IOs is performance critical, we introduce asynchronous
completions for NVMe-TCP, i.e. NVMe-TCP calls the NIC, which will later
call NVMe-TCP to complete the IO (`nvme_tcp_ddp_teardown_done`).

On the IO level, and in order to use the offload only when a clear
performance improvement is expected, the offload is used only for IOs
which are bigger than io_threshold.

SKB
===
The DDP (zero-copy) and CRC offloads require two additional bits in the SKB.
The ddp bit is useful to prevent condensing of SKBs which are targeted
for zero-copy. The crc bit is useful to prevent GRO coalescing SKBs with
different offload values. This bit is similar in concept to the
"decrypted" bit.

After offload is initialized, we use the SKB's crc bit to indicate that:
"there was no problem with the verification of all CRC fields in this packet's
payload". The bit is set to zero if there was an error, or if HW skipped
offload for some reason. If *any* SKB in a PDU has (crc != 1), then the
calling driver must compute the CRC, and check it. We perform this check, and
accompanying software fallback at the end of the processing of a received PDU.

Resynchronization flow
======================
The resynchronization flow is performed to reset the hardware tracking of
NVMe-TCP PDUs within the TCP stream. The flow consists of a request from
the hardware proxied by the driver, regarding a possible location of a
PDU header. Followed by a response from the NVMe-TCP driver.

This flow is rare, and it should happen only after packet loss or
reordering events that involve NVMe-TCP PDU headers.

CID Mapping
===========
ConnectX-7 assumes linear CID (0...N-1 for queue of size N) where the Linux NVMe
driver uses part of the 16 bit CCID for generation counter.
To address that, we use the existing quirk in the NVMe layer when the HW
driver advertises that they don't support the full 16 bit CCID range.

Enablement on ConnectX-7
========================
By default, NVMeTCP offload is disabled in the mlx driver and in the nvme-tcp host.
In order to enable it:

	# Disable CQE compression (specific for ConnectX)
	ethtool --set-priv-flags <device> rx_cqe_compress off

	# Enable the ULP-DDP
	ethtool --ulp-ddp <device> nvme-tcp-ddp on nvme-tcp-ddgst-rx-offload on

	# Enable ULP offload in nvme-tcp
	modprobe nvme-tcp ulp_offload=1

Following the device ULP-DDP enablement, all the IO queues/sockets which are
running on the device are offloaded.

This feature requires a patched ethtool that can be obtained from
Web: https://github.com/aaptel/ethtool/tree/ulp-ddp
Git: https://github.com/aaptel/ethtool.git
Branch: ulp-ddp

Performance
===========
With this implementation, using the ConnectX-7 NIC, we were able to
demonstrate the following CPU utilization improvement:

Without data digest:
For  64K queued read IOs – up to 32% improvement in the BW/IOPS (111 Gbps vs. 84 Gbps).
For 512K queued read IOs – up to 55% improvement in the BW/IOPS (148 Gbps vs. 98 Gbps).

With data digest:
For  64K queued read IOs – up to 107% improvement in the BW/IOPS (111 Gbps vs. 53 Gbps).
For 512K queued read IOs – up to 138% improvement in the BW/IOPS (146 Gbps vs. 61 Gbps).

With small IOs we are not expecting that the offload will show a performance gain.

The test configuration:
- fio command: qd=128, jobs=8.
- Server: Intel(R) Xeon(R) Platinum 8380 CPU @ 2.30GHz, 160 cores.

Patches
=======
Patch 1:  Introduce the infrastructure for all ULP DDP and ULP DDP CRC offloads.
Patch 2:  Add ethtool string sets for ULP DDP capability names and stats names.
Patch 3:  Add ethtool operations to get/set ULP DDP capabilities and statistics.
Patch 4:  Documentation of ULP DDP ethtool netlink messages.
Patch 5:  The iov_iter change to skip copy if (src == dst).
Patch 6:  Export the get_netdev_for_sock function from TLS to generic location.
Patch 7:  NVMe-TCP changes to call NIC driver on queue init/teardown and resync.
Patch 8:  NVMe-TCP changes to call NIC driver on IO operation
          setup/teardown, and support async completions.
Patch 9:  NVMe-TCP changes to support CRC offload on receive
          Also, this patch moves CRC calculation to the end of PDU
          in case offload requires software fallback.
Patch 10: NVMe-TCP handling of netdev events: stop the offload if netdev is
          going down.
Patch 11: Add module parameter to the NVMe-TCP control the enable ULP offload.
Patch 12: Documentation of ULP DDP offloads.

The rest of the series is the mlx5 implementation of the offload.

Testing
=======
This series was tested on ConnectX-7 HW using various configurations
of IO sizes, queue depths, MTUs, and with both the SPDK and kernel NVMe-TCP
targets.

Compatibility
=============
* The offload works with bare-metal or SRIOV.
* The HW can support up to 64K connections per device (assuming no
  other HW accelerations are used). In this series, we will introduce
  the support for up to 4k connections, and we have plans to increase it.
* SW TLS could not work together with the NVMeTCP offload as the HW
  will need to track the NVMeTCP headers in the TCP stream.
* The ConnectX HW support HW TLS, but in ConnectX-7 those features
  could not co-exists (and it is not part of this series).
* The NVMeTCP offload ConnectX 7 HW can support tunneling, but we
  don’t see the need for this feature yet.
* NVMe poll queues are not in the scope of this series.

Future Work
===========
* NVMeTCP transmit offload.
* NVMeTCP host offloads incremental features.
* NVMeTCP target offload.

Changes since v9:
=================
- Add missing crc checks in tcp_try_coalesce() (Paolo).
- Add missing ifdef guard for socket ops (Paolo).
- Remove verbose netlink format for statistics (Jakub).
- Use regular attributes for statistics (Jakub).
- Expose and document individual stats to uAPI (Jakub).
- Move ethtool ops for caps&stats to netdev_ops->ulp_ddp_ops (Jakub).

Changes since v8:
=================
- Make stats stringset global instead of per-device (Jakub).
- Remove per-queue stats (Jakub).
- Rename ETH_SS_ULP_DDP stringset to ETH_SS_ULP_DDP_CAPS.
- Update & fix kdoc comments.
- Use 80 columns limit for nvme code.

Changes since v7:
=================
- Remove ULP DDP netdev->feature bit (Jakub).
- Expose ULP DDP capabilities to userspace via ethtool netlink messages (Jakub).
- Move ULP DDP stats to dedicated stats group (Jakub).
- Add ethtool_ops operations for setting capabilities and getting stats (Jakub).
- Move ulp_ddp_netdev_ops into net_device_ops (Jakub).
- Use union for protocol-specific struct instances (Jakub).
- Fold netdev_sk_get_lowest_dev() into get_netdev_for_sock (Christoph).
- Rename memcpy skip patch to something more obvious (Christoph).
- Move capabilities from ulp_ddp.h to ulp_ddp_caps.h.
- Add "Compatibility" section on the cover letter (Sagi).

Changes since v6:
=================
- Moved IS_ULP_{DDP,CRC} macros to skb_is_ulp_{ddp,crc} inline functions (Jakub).
- Fix copyright notice (Leon).
- Added missing ifdef to allow build with MLX5_EN_TLS disabled.
- Fix space alignment, indent and long lines (max 99 columns).
- Add missing field documentation in ulp_ddp.h.

Changes since v5:
=================
- Limit the series to RX offloads.
- Added two separated skb indications to avoid wrong flushing of GRO
  when aggerating offloaded packets.
- Use accessor functions for skb->ddp and skb->crc (Eric D) bits.
- Add kernel-doc for get_netdev_for_sock (Christoph).
- Remove ddp_iter* routines and only modify _copy_to_iter (Al Viro, Christoph).
- Remove consume skb (Sagi).
- Add a knob in the ddp limits struct for the HW driver to advertise
  if they need the nvme-tcp driver to apply the generation counter
  quirk. Use this knob for the mlx5 CX7 offload.
- bugfix: use u8 flags instead of bool in mlx5e_nvmeotcp_queue->dgst.
- bugfix: use sg_dma_len(sgl) instead of sgl->length.
- bugfix: remove sgl leak in nvme_tcp_setup_ddp().
- bugfix: remove sgl leak when only using DDGST_RX offload.
- Add error check for dma_map_sg().
- Reduce #ifdef by using dummy macros/functions.
- Remove redundant netdev null check in nvme_tcp_pdu_last_send().
- Rename ULP_DDP_RESYNC_{REQ -> PENDING}.
- Add per-ulp limits struct (Sagi).
- Add ULP DDP capabilities querying (Sagi).
- Simplify RX DDGST logic (Sagi).
- Document resync flow better.
- Add ulp_offload param to nvme-tcp module to enable ULP offload (Sagi).
- Add a revert commit to reintroduce nvme_tcp_queue->queue_size.

Changes since v4:
=================
- Add transmit offload patches.
- Use one feature bit for both receive and transmit offload.

Changes since v3:
=================
- Use DDP_TCP ifdefs in iov_iter and skb iterators to minimize impact
  when compiled out (Christoph).
- Simplify netdev references and reduce the use of
  get_netdev_for_sock (Sagi).
- Avoid "static" in it's own line, move it one line down (Christoph)
- Pass (queue, skb, *offset) and retrieve the pdu_seq in
  nvme_tcp_resync_response (Sagi).
- Add missing assignment of offloading_netdev to null in offload_limits
  error case (Sagi).
- Set req->offloaded = false once -- the lifetime rules are:
  set to false on cmd_setup / set to true when ddp setup succeeds (Sagi).
- Replace pr_info_ratelimited with dev_info_ratelimited (Sagi).
- Add nvme_tcp_complete_request and invoke it from two similar call
  sites (Sagi).
- Introduce nvme_tcp_req_map_sg earlier in the series (Sagi).
- Add nvme_tcp_consume_skb and put into it a hunk from
  nvme_tcp_recv_data to handle copy with and without offload.

Changes since v2:
=================
- Use skb->ddp_crc for copy offload to avoid skb_condense.
- Default mellanox driver support to no (experimental feature).
- In iov_iter use non-ddp functions for kvec and iovec.
- Remove typecasting in NVMe-TCP.

Changes since v1:
=================
- Rework iov_iter copy skip if src==dst to be less intrusive (David Ahern).
- Add tcp-ddp documentation (David Ahern).
- Refactor mellanox driver patches into more patches (Saeed Mahameed).
- Avoid pointer casting (David Ahern).
- Rename NVMe-TCP offload flags (Shai Malin).
- Update cover-letter according to the above.

Changes since RFC v1:
=====================
- Split mlx5 driver patches to several commits.
- Fix NVMe-TCP handling of recovery flows. In particular, move queue offload.
  init/teardown to the start/stop functions.

Signed-off-by: Or Gerlitz <ogerlitz@nvidia.com>

Aurelien Aptel (6):
  net/ethtool: add new stringset ETH_SS_ULP_DDP_{CAPS,STATS}
  net/ethtool: add ULP_DDP_{GET,SET} operations for caps and stats
  Documentation: document netlink ULP_DDP_GET/SET messages
  net/tls,core: export get_netdev_for_sock
  nvme-tcp: Add modparam to control the ULP offload enablement
  net/mlx5e: NVMEoTCP, statistics

Ben Ben-Ishay (8):
  iov_iter: skip copy if src == dst for direct data placement
  net/mlx5: Add NVMEoTCP caps, HW bits, 128B CQE and enumerations
  net/mlx5e: NVMEoTCP, offload initialization
  net/mlx5e: NVMEoTCP, use KLM UMRs for buffer registration
  net/mlx5e: NVMEoTCP, queue init/teardown
  net/mlx5e: NVMEoTCP, ddp setup and resync
  net/mlx5e: NVMEoTCP, async ddp invalidation
  net/mlx5e: NVMEoTCP, data-path for DDP+DDGST offload

Boris Pismenny (4):
  net: Introduce direct data placement tcp offload
  nvme-tcp: Add DDP offload control path
  nvme-tcp: Add DDP data-path
  net/mlx5e: TCP flow steering for nvme-tcp acceleration

Or Gerlitz (5):
  nvme-tcp: Deal with netdevice DOWN events
  net/mlx5e: Rename from tls to transport static params
  net/mlx5e: Refactor ico sq polling to get budget
  net/mlx5e: Have mdev pointer directly on the icosq structure
  net/mlx5e: Refactor doorbell function to allow avoiding a completion

Yoray Zack (2):
  nvme-tcp: RX DDGST offload
  Documentation: add ULP DDP offload documentation

 Documentation/networking/ethtool-netlink.rst  |   91 ++
 Documentation/networking/index.rst            |    1 +
 Documentation/networking/statistics.rst       |    1 +
 Documentation/networking/ulp-ddp-offload.rst  |  376 ++++++
 .../net/ethernet/mellanox/mlx5/core/Kconfig   |   11 +
 .../net/ethernet/mellanox/mlx5/core/Makefile  |    3 +
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |   10 +
 .../net/ethernet/mellanox/mlx5/core/en/fs.h   |    4 +-
 .../ethernet/mellanox/mlx5/core/en/params.c   |   12 +-
 .../ethernet/mellanox/mlx5/core/en/params.h   |    3 +
 .../mellanox/mlx5/core/en/reporter_rx.c       |    4 +-
 .../ethernet/mellanox/mlx5/core/en/rx_res.c   |   28 +
 .../ethernet/mellanox/mlx5/core/en/rx_res.h   |    4 +
 .../net/ethernet/mellanox/mlx5/core/en/tir.c  |   15 +
 .../net/ethernet/mellanox/mlx5/core/en/tir.h  |    2 +
 .../net/ethernet/mellanox/mlx5/core/en/txrx.h |   28 +-
 .../ethernet/mellanox/mlx5/core/en/xsk/rx.c   |    1 +
 .../ethernet/mellanox/mlx5/core/en/xsk/rx.h   |    1 +
 .../mlx5/core/en_accel/common_utils.h         |   32 +
 .../mellanox/mlx5/core/en_accel/en_accel.h    |    3 +
 .../mellanox/mlx5/core/en_accel/fs_tcp.c      |   12 +-
 .../mellanox/mlx5/core/en_accel/fs_tcp.h      |    2 +-
 .../mellanox/mlx5/core/en_accel/ktls.c        |    2 +-
 .../mellanox/mlx5/core/en_accel/ktls_rx.c     |    8 +-
 .../mellanox/mlx5/core/en_accel/ktls_tx.c     |    8 +-
 .../mellanox/mlx5/core/en_accel/ktls_txrx.c   |   36 +-
 .../mellanox/mlx5/core/en_accel/ktls_utils.h  |   17 +-
 .../mellanox/mlx5/core/en_accel/nvmeotcp.c    | 1115 +++++++++++++++++
 .../mellanox/mlx5/core/en_accel/nvmeotcp.h    |  142 +++
 .../mlx5/core/en_accel/nvmeotcp_rxtx.c        |  325 +++++
 .../mlx5/core/en_accel/nvmeotcp_rxtx.h        |   37 +
 .../mlx5/core/en_accel/nvmeotcp_stats.c       |   66 +
 .../mlx5/core/en_accel/nvmeotcp_utils.h       |   66 +
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  |    6 +
 .../net/ethernet/mellanox/mlx5/core/en_fs.c   |    4 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c |   31 +-
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |   78 +-
 .../ethernet/mellanox/mlx5/core/en_stats.h    |    7 +
 .../net/ethernet/mellanox/mlx5/core/en_txrx.c |    4 +-
 drivers/net/ethernet/mellanox/mlx5/core/fw.c  |    6 +
 .../net/ethernet/mellanox/mlx5/core/main.c    |    1 +
 drivers/nvme/host/tcp.c                       |  567 ++++++++-
 include/linux/ethtool.h                       |   32 +
 include/linux/mlx5/device.h                   |   59 +-
 include/linux/mlx5/mlx5_ifc.h                 |   82 +-
 include/linux/mlx5/qp.h                       |    1 +
 include/linux/netdevice.h                     |   18 +-
 include/linux/skbuff.h                        |   24 +
 include/net/inet_connection_sock.h            |    6 +
 include/net/ulp_ddp.h                         |  187 +++
 include/net/ulp_ddp_caps.h                    |   35 +
 include/uapi/linux/ethtool.h                  |    4 +
 include/uapi/linux/ethtool_netlink.h          |   37 +
 lib/iov_iter.c                                |    8 +-
 net/Kconfig                                   |   20 +
 net/core/dev.c                                |   26 +-
 net/core/skbuff.c                             |    3 +-
 net/ethtool/Makefile                          |    2 +-
 net/ethtool/common.c                          |   22 +
 net/ethtool/common.h                          |    2 +
 net/ethtool/netlink.c                         |   17 +
 net/ethtool/netlink.h                         |    4 +
 net/ethtool/strset.c                          |   11 +
 net/ethtool/ulp_ddp.c                         |  334 +++++
 net/ipv4/tcp_input.c                          |   13 +-
 net/ipv4/tcp_ipv4.c                           |    3 +
 net/ipv4/tcp_offload.c                        |    3 +
 net/tls/tls_device.c                          |   16 -
 68 files changed, 3988 insertions(+), 151 deletions(-)
 create mode 100644 Documentation/networking/ulp-ddp-offload.rst
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/common_utils.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_rxtx.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_rxtx.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_stats.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_utils.h
 create mode 100644 include/net/ulp_ddp.h
 create mode 100644 include/net/ulp_ddp_caps.h
 create mode 100644 net/ethtool/ulp_ddp.c

-- 
2.31.1

