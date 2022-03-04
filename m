Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 371064CD24B
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 11:22:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232679AbiCDKXb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 05:23:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231445AbiCDKXa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 05:23:30 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2098.outbound.protection.outlook.com [40.107.244.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1B233982A
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 02:22:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Er7oK9nvDTjH1WNAfrd6UQCmKJ3pPl6DRNeLspulkBJF5IbjqGNSQ43n2FI2YgMnYga8H7tiTmXInCRUAhf5fmkYDsRU4pVY1/Qb8TLHiyhx9h8P0tzC0vyfyG++zfZE9soQy3T1tWuaafStq7DDuMKjS/+Q0HWQO42vKa85pZZuwnorAOSd7d2v7CwmAcA/9FtoWxIi8e6D6KhnPKFboi+Amlf0meiGdrOs3+xWa94y47yj/CQ6+gnMcJwhxH/aJOivCOeqH9HGxhN3tWO4dpKG84qwsF8bBkA3XSqDNu+9G72leT6oyaftY+UvvJJQHytawn9nNoZB9vTKHK5eEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Dk+rPKe3ctuoi6+aZT1nkf88ZJXRqhGceo9pHKJL8QU=;
 b=itPs/bUaMgTagLYq/w9FpsVJej+49BDtTK7k82nF8Zd6P7/lonA0ycFt7VGm61QQLgtI1plT3+fu8GsgoT9wCysF+SibtBinI55tGIKJ97zUW0XIdVBP7xFEz6wwBFG6XCzGnAnvuW+5OTxQECHid5C658i5/33h7VXQ0N9zFf/WL3zXu0NI7CZQ3D2prCUPp3GHEX0paWtmwV0lAiA8TUczQ68VMrPAzHjrmEvTYAfzGVMtYoSOF8VIqcXsyCk9CBnUvfvBPNlTm7QpbfOfodFt4I8M/Dl+q/z4U47QxJBSnNnCL8dT3lTLRgX0miL7b8e6gtq6xWBjFSEFInrARg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dk+rPKe3ctuoi6+aZT1nkf88ZJXRqhGceo9pHKJL8QU=;
 b=CkP3rJXjvDpf9/VL9igq6N9wje/s1BZTOHQ6CSM6/JONsOB+yvDLjDbAvOPBHkEP2ziZlvBkjMoTh5M19vrFgW4kyzyIsvK47QsjlBJqQl3WHeAMqpWVCnl/Bc01HvxyGJswKfToI3iqGJZ9G6WOaPCXlcB/sI1qeHYYkd0LbN4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB4539.namprd13.prod.outlook.com (2603:10b6:5:36::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.7; Fri, 4 Mar
 2022 10:22:40 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::d27:c7d9:8880:a73e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::d27:c7d9:8880:a73e%2]) with mapi id 15.20.5038.017; Fri, 4 Mar 2022
 10:22:40 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@corigine.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com
Subject: Add AF_XDP zero-copy support for NFP
Date:   Fri,  4 Mar 2022 11:22:09 +0100
Message-Id: <20220304102214.25903-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM8P190CA0012.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:219::17) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7e53c683-aae8-4483-37a8-08d9fdc8e941
X-MS-TrafficTypeDiagnostic: DM6PR13MB4539:EE_
X-Microsoft-Antispam-PRVS: <DM6PR13MB45390DD2B840947E09F8324AE8059@DM6PR13MB4539.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mzRi9pYRrw9p0EVWF77CMKlmDBWXF6U+PyxB//d9EeGeZTTWvME0/UkR2cfL8QXFRVcWij9znZv7pUZXWAzG8W/prbZHdxV/YIVZ5TbtjRA/H5t7Em6//zPYaRK2eFECo0JAjZXudpJ9CJUsa2QMRO6RD2pT9sVwYOSERVrqn1ld8FCWuttkA9fbXwEIcDyXBX0Jp6C2BK8bX6GtAEMbiSZQGA7QsZGxUPPZYsP/zeNmlKCZDu3ATUTSBkWAZbJwm4XMCLrl5JkGcm7Nt3WHd6A78MozP6apacDTP9L4lKZgehNnbszd4oiJo7l8EYScVFYQ9avI6pBJ6ZRNiqaW0EBLbayvbAgsSPrEDZdDv9SVmyGdupSyKW9HO8MLoaVQWkUWa6jZbmBRqXg/52xuPtWMthlIkmMDtI0kfubW0L6+KlPINGXGh1QY6LRFAkIICo9nXyl6pYw8HBrofoR2+uZ8ZBADwfj6l8ZCJtrzlvgBMT0dYd8CWE9Yb7oe2X6cd4MPcT8d6FoTMIvOmh3lW9RF1xB+IgSOB0C+i6ibhlt0gBInJPKWxRdB1wD32BXITsDPHcw7ZBIiuLW6WpA8z20NCn0l8JA/BPA8sPDZmbWZU/UknBl8OjnvG69tm8xFUadRKF/d2ZE2JQZEsgbqNg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(396003)(346002)(136003)(376002)(366004)(39830400003)(6486002)(6636002)(8936002)(110136005)(5660300002)(316002)(508600001)(66946007)(66556008)(66476007)(8676002)(4326008)(6506007)(6666004)(52116002)(86362001)(38100700002)(6512007)(83380400001)(36756003)(2616005)(2906002)(107886003)(1076003)(44832011)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QVVDbnd1MnlFa2ZJRTArQ2pkRW5BVm90Q1ZIbnlQdkdxUm4wc2dWWVFUcWZy?=
 =?utf-8?B?ZzgxNEdaOWZFb1RWdjhmZXB1TjJQQVh4S3JrWlVCUVdoRnRVK29icjBtWnln?=
 =?utf-8?B?NWNScUs3QlV3U24vTWhUZzN5ZlFUZzlQa3E1RWlkaVhrWkNoK3UxZnEvK0FH?=
 =?utf-8?B?dDNxNFpLanUrSndhazdXRzArcmQwU1o2aTR1cEVxVkpBTkdFY2M3a3ViR2NG?=
 =?utf-8?B?eXJnUnAyVHRCVVJvVGlYZkt3ZzNqc3Y4WUVPVThMbGh2MmtVZ3dzbS9tdGZK?=
 =?utf-8?B?Q05BSDZuWmg5VVRSV2tIMFB2OXZlS1ZRbXBFdEZ3NnlScUZzOEVwQktJeisr?=
 =?utf-8?B?RjAxdXVHQ0RWSnBReTI5YWtoRDJUYkZDYTlXMVdGL0luRFE5OTZabDZydEpX?=
 =?utf-8?B?TFhKSGRYNXpLTlY4SElQU1FwdFU0Wk5zWGFpcFNLbUtGVFVwMWh4d2Y1OGdp?=
 =?utf-8?B?MDRZSmV5UkQ2b0ZWbUljcGVvZTB5bld0ajRVTmU1SndnVG80eDVVaUZXdjNE?=
 =?utf-8?B?dlMvUW1zZ2pUeS9wK2ZOS3pDV3N0akpVWGxIay9BcFY0K0IyRTkwUzRqYnNR?=
 =?utf-8?B?N1FUM2VoV0w1NHJQUDdOTjA3ZnhIQ1ltaWNCc2VjK2ZNa0lXcG9SekVkZFA5?=
 =?utf-8?B?UkxtT3FJT3Vnd082M3dXaFdoUUNEUGxhbU9DUUV3SXNwK3R1SUxmSVRxZGM0?=
 =?utf-8?B?azV6aTZOMllBRDVCRWNmdGNOWU9OckVySVpEUDF4S0d6ZWtMakM0VVVIL1lt?=
 =?utf-8?B?d3ovNUVXWFQ1R1dJZ1UrY0FydVdwRWlIbDZ3VmxHckNIRW8xY1hpbHRsZjFP?=
 =?utf-8?B?YVVORWFhOXhNSVNHNXdIajd0YWo4N1dCNWt2NUVCUVpqR0JJZHNMT1NTWndI?=
 =?utf-8?B?OTBESmhLYzB6cFJnTURnNFhMaCtnRU90WG41Z25LWXhkQVZ5cW4zLzVPZ0Fp?=
 =?utf-8?B?cVV2WFM1U1psRitMdXpwRlV4Y2Z3NkFhM1R5UFV6S0Ntd1kvVk0yWXRuYmpO?=
 =?utf-8?B?MGRmNHVGZVhJRG45cEc0OWVmME1aTkNFSVVpZ1NkRkxVU2VFeDQ4NFU0Qy9J?=
 =?utf-8?B?RFE0ZktFKy9QQU1KdnpsYjNJWlVIa0FaclR3SW00bnhDNXVndWlUSGNHYWhx?=
 =?utf-8?B?TEc1RTVDSk1YaGNBVUV1SXlyeFFaUDZwYkhvSmRteWd4YmJPa1RzYzZjS0hZ?=
 =?utf-8?B?dFZuMVZJdU9BVGtyYTc1UXJSK1B0QkIxeVRrMU1iQ1ZTTmRxYUc3dEl2bjB5?=
 =?utf-8?B?bjlpaGRtb3lnV3BTYjVGcG1HcXRLd0h4dTdpb0VvSW1yQnNwZjZIKytvN1o5?=
 =?utf-8?B?b1JtK0N3Tmprb2gzVlhIRlhrb1hjbmRCRnFSS3VnUjc3dHNRNnlNSkZCV0M1?=
 =?utf-8?B?eFZzV1FnSkx1RmUwMzB4d3JUem5GM0ljU3l2ZlBaZlJ2V3RUQVIxZEozTU95?=
 =?utf-8?B?amV1SFQxRG55b0l1NVZGbjlCV2pZVXpORDVXTXlPUllLZ29kbFpqUjYwSzZW?=
 =?utf-8?B?Z2N2NkFiYkdJa2dMSXJobmdRVHNLcnQ1MnIxYnJMU1NXTHVDcWFzTUxhVTJs?=
 =?utf-8?B?aytmWjg5N1N4TW1vQzc4QW1vdnNSaUp0RU91eHN4enRjWU1aTUVOM2I3djU2?=
 =?utf-8?B?NllWS2EzU1B5K2xQR1Z1RSttRVlDdWZmNW5MRWpqQjY2N1NIbmtMcmd1aktl?=
 =?utf-8?B?NXVGNE1BN2svd2FxVjRwTTlHYVE1LytzQUF4NHpQMlpVa1crMnd1ejJuYlEw?=
 =?utf-8?B?YTJFNitJQnJZdjdpcEc5bzJ1aUxHSWY4QmdWbUlDdHo5aEI4WjdHWmRZWm56?=
 =?utf-8?B?NWp3WU00bkEyQVg2WW1jWmtkaG1WUlhUMStqYnZNRFNLNi9Cb3dyc1VITHYz?=
 =?utf-8?B?ZG4zRS9JWkdVeFMzZmxPVUZZUkcrOThrbXErVWZjcWtoQlJEdERNSjV2aXor?=
 =?utf-8?B?eUlMTG4wTDZ0aGVJdU9TY3dReTRIUHM5Ym0wMUVzU3B2aTBFU2xmMjFnT2Zw?=
 =?utf-8?B?VzRFUkY0S0FOYTd3cE5aazg0UUxrd1MrWjFWZjRpNHVPcHhuZEMxdjY3cjA2?=
 =?utf-8?B?Rkg4c1FrbFBMQWJ3cEMxaXFzYjJxenJZb00rUT09?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e53c683-aae8-4483-37a8-08d9fdc8e941
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2022 10:22:40.1412
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /zNQZ6eU7RCrecJ0An2mjUx9exqZwvwGvd/lFvEgGu0+PyyqyWH5nl+CnZjjBLYLTPCuFX1V+0Q6UfACxmuI58pe/zB/iyHhBCuSIyrdt5o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB4539
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Niklas Söderlund says:

This series adds AF_XDP zero-copy support for the NFP driver. The series
is based on previous work done by Jakub Kicinski.

Patch 1/5 and 2/5 prepares the driver for AF_XDP support by refactoring
functions that will act differently once AF_XDP is active or not making
the driver easier to read and by preparing some functions to be reused
outside the local file scope. Patch 3/5 and 4/5 prepares the driver for
dealing the UMEM while finally patch 5/5 adds AF_XDP support.

Based on work by Jakub Kicinski.

Jakub Kicinski (1):
  nfp: wrap napi add/del logic

Niklas Söderlund (4):
  nfp: expose common functions to be used for AF_XDP
  nfp: xsk: add an array of xsk buffer pools to each data path
  nfp: xsk: add configuration check for XSK socket chunk size
  nfp: xsk: add AF_XDP zero-copy Rx and Tx support

 drivers/net/ethernet/netronome/nfp/Makefile   |   1 +
 drivers/net/ethernet/netronome/nfp/nfp_net.h  |  47 +-
 .../ethernet/netronome/nfp/nfp_net_common.c   | 207 ++++--
 .../ethernet/netronome/nfp/nfp_net_debugfs.c  |  33 +-
 .../net/ethernet/netronome/nfp/nfp_net_xsk.c  | 592 ++++++++++++++++++
 .../net/ethernet/netronome/nfp/nfp_net_xsk.h  |  29 +
 6 files changed, 855 insertions(+), 54 deletions(-)
 create mode 100644 drivers/net/ethernet/netronome/nfp/nfp_net_xsk.c
 create mode 100644 drivers/net/ethernet/netronome/nfp/nfp_net_xsk.h

-- 
2.20.1

