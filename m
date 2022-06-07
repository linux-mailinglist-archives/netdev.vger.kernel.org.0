Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 448FF53FF6C
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 14:51:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240944AbiFGMvo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 08:51:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233403AbiFGMvn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 08:51:43 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2110.outbound.protection.outlook.com [40.107.212.110])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 359851C136
        for <netdev@vger.kernel.org>; Tue,  7 Jun 2022 05:51:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZfYzpGq/VdXhl7j/T3jQ0/YXfEoAl3IChSHdT4bTHdvN/bcE2g3ezDSQVDyHTrb014rgDVaESylS0IpCvG6QItz0Rx4hVf6uO6A1R7isH58Z6npQOKBpy1x0HgEFGwdTeKmloGw9JiwD9+vvqVN1iAndoDQmWXuU2mo60SRhqqf7oT+RMaK7h1RSSLoGtNEkAEJrT2EPQexuOtfWSr7QirN0tGusTv4/em27r+AsF26jaLrlwVz2vKaKkIIiW3KRVAqhwX+Coircf35fSdKr4XKRUxxmUKL2xsJCH0g6xSnpJNIyejsE3sdNP5Lz49y8PE3+9IeoTjUcmtBgoligFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sItBu1qDMW2BsfBNqu4JmSCxZ+rjS7C6WPuWdBfQDIE=;
 b=h99r2ICs2TRlduosZgE3Mkwn+bDoWNyzx1yZHoa1fbEieZV+9FV8+I3T7DlZy01Mm1UbhKoZXO1oqIQN1HcZlwI49JDpNTRxPfBtq0X2CRy4OOD97Hw1xzNlYGnjztlocmaCZLolG7d3v566tSD3CC8ABRUVYSxoRFW2CTDodz6j51cY1PJH6v0sksY6s38aN5Nc74IVxti9csPXI5w+xPdRK0U4X3fRQku6wjEeb70cnR7NCXYF/n90dbcilHbDU+Oqj2+7nlls0zO3vLaFltY08d9Vep6kYrAYMxiV0onPVQ2rc42b4eVzGpMCDrGtKM9/2tQxtnXY0FMM25uMeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sItBu1qDMW2BsfBNqu4JmSCxZ+rjS7C6WPuWdBfQDIE=;
 b=pjoXr/ydbJWIpRi3l9Lv/sBYXm2vu3SINkJjKvDjpuiMItbDM3xFHtgCAR/Fj2EecoVG/rBAAxc4GwS16p+9YEEblLeNrB1fhjfXjZv7bM16aHaCmaOTq7u8tAAYr3Wm21/eUlK0eQxX1mu7xdhFdcLISX0gV76Tx7Cvk/lIQYc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SN4PR13MB5810.namprd13.prod.outlook.com (2603:10b6:806:21a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.9; Tue, 7 Jun
 2022 12:51:39 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::b18b:5e90:6805:a8fa]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::b18b:5e90:6805:a8fa%8]) with mapi id 15.20.5332.011; Tue, 7 Jun 2022
 12:51:38 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next repost] nfp: Remove kernel.h when not needed
Date:   Tue,  7 Jun 2022 14:51:03 +0200
Message-Id: <20220607125103.487801-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P265CA0083.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2bd::20) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6ab2e047-744c-4de8-420e-08da48847654
X-MS-TrafficTypeDiagnostic: SN4PR13MB5810:EE_
X-Microsoft-Antispam-PRVS: <SN4PR13MB581015F5759376BC89D546AEE8A59@SN4PR13MB5810.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Tcystll8mGKpC0y31qc8gRrtC9zKQ+/uHxTtbaaMSWdHb9+aUYqh1kTL9pM3X4/ACywsVMppunF4EUd2JgNBJzq3GWAOgiCbcEKgtyLi4c4DFlhiZW1CvUPaKnxsqQW2p5RQxgvbWQUhPRK7w0a+ytYWYse5+T5R5ucKVg1+nri9VvqPWNj335yWlrynyYPfcS8caiTK1+1nLp+bg4Mu4AqPnYuW4Txbspwk8AWJCbhRaKxcZW/eEvoVFHKBOmUaM1BG7rff6ZFFNhWBvGA1S1gzM9E/6etOlfYteoH7lyUf7hbpc1QMpDsXkPw1JKINgPp7tfL3VkWvm6/stgcNB7rd8yQHT9goBZsZXobWFR4BI4fx7D3KVEjDU7yJybvoVkN4vkwDa9e16WDmfO3b2x3FbsfLKyIgvU5S/4WyG6epvpaD9cznmqxCmuEZrfXl0hz1PBNXo15CGoFAqRxtZlqi1ZTw+bLDemhZQx4z5m03ca3GFsqaFA7uuumTrshT11PHKFIGisRDJPoynJ04LjSa+97TADAimppgWdR/6iATmjw3J5Pr1tC+WJ4JdVNhn17h82fdpykAsnMW090zt67AIa/IkCks3++xZhsnZjQWr1H5rhRpJFpeYDd/CZMTXDKsaM1Dr/k/7yidvYD+Ug==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(136003)(376002)(396003)(39840400004)(366004)(346002)(41300700001)(107886003)(38100700002)(316002)(2616005)(4326008)(8676002)(508600001)(6486002)(83380400001)(52116002)(6666004)(54906003)(66476007)(66556008)(6506007)(66946007)(110136005)(86362001)(8936002)(6512007)(5660300002)(36756003)(186003)(2906002)(44832011)(1076003)(4744005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ss/pfN6Xu7WcJqjCIPq1Hk6GHX1J74TsUZDL4qlw7kuZuhW3yc52lh8wwcod?=
 =?us-ascii?Q?v8R0NNBsER9MHToKZiBicmct0XNcf7Y0NrPJGj78digAafWYhyfE65qySdjr?=
 =?us-ascii?Q?5+XFlXJ/+jWXGCdUU/jyy/yemLtxj1Zgdst32jPWNTc+glN2afDem+XKfK8n?=
 =?us-ascii?Q?KbrmRLUj7tOOwYFrZ7Tv2tiHt9ZfeZPy+jNvt04UL5s9nErOI47UQCfylobi?=
 =?us-ascii?Q?sn39fAkMo4AtaksZ8/f90BtL8IM0e4JvlX0TNVshn3igFjGJ8g+dB/31YLpz?=
 =?us-ascii?Q?owZTR8q9DGeUdZOjzdZMRBKbKfmZ+9YtGY0stPjEyANvgDbxVvwMdT8BuTEP?=
 =?us-ascii?Q?F97VsbqVfBnkO/d7Nx48GIYkKSZ53fISPwkChtHMUMxJE5qr3z0HyaOOvdwT?=
 =?us-ascii?Q?leOecUpQX/IOBaBJpQEtnvuslmOEC0yBk19mAeY970KRcPK+cBPSPVFrLVen?=
 =?us-ascii?Q?IJ4Dr0l5UQ0xSaggEogv/3OO7HwGdsJE1CfWxbRwqqp+BoqyYq4kanpyMdDP?=
 =?us-ascii?Q?dcArp8Iwup1zGT7AezKRq97fWPKeCUcuJq+4moTdIjtGaDIrgDisLWCs7B2Q?=
 =?us-ascii?Q?WK/jj8Rwsc5fZ75u9hBbOZkkZfKryVj2MU/xa+gGjhLZ8WFlkMNa5fIWlPLr?=
 =?us-ascii?Q?sojBdmHHFTJz+F9KbLxDEgKJBWtK758wXvn7Rd4lDNkrfYW4iTxU0FIsRP8Q?=
 =?us-ascii?Q?743bB2/8cWTiFRCSMQ9u86OpslyTN2Nf9Duidqgr22Hep853oVoKxt1A86gV?=
 =?us-ascii?Q?Wl4KPG+Aib7NmIhYyVrWzA4r3fSd3KhcJ2Z48MJluZuuk+FDK+ABu9OMbCPG?=
 =?us-ascii?Q?3fqiyECQ906s0V9g/76tzqdNIZRGUbVF1dbJ1kPXhHN6buLrKJIWu8V94OGy?=
 =?us-ascii?Q?sfo7DT9iSX+nVUniOcnAbPokYU2bJ8bPKxS72eW/egSPzMHBnuTE03OadHyR?=
 =?us-ascii?Q?w4RQA2pMxHzElfkDaaXlin0sxkJt942IlVwBR76CXS0H0OkamQxR6HgzWovK?=
 =?us-ascii?Q?yOJJIL6BsSPLPfrUWbeXZzqkrXBjWGaSG7JDTOF/A9exSnB406lOLAAAAgg9?=
 =?us-ascii?Q?cCpt2qtQmJyfyQOiYiWsHyO9+b7soB2W2CEBz+f4tB9NuqKsiAw1ME3aqdR3?=
 =?us-ascii?Q?YuVnqegcVMO13FGb7YZHPoH5Xpp1xDuU8aFH7cCoIG+hdNZj8+03lw6g/NwC?=
 =?us-ascii?Q?49Lz9y2fEziJ/GChxD33Fq2FWD6++LE4PGm5rFVNwM/ZcWRcpPAPIm24bFTf?=
 =?us-ascii?Q?Sp5BuyQYcn3PHMZAv/HxyJpnHiz9VCvlVIuVPFqmh/FBWpEUuvjzdGODYCz2?=
 =?us-ascii?Q?l9GLNNNCq5J8ls5pGyAaayzkyAyMKfDN8I4sCXq0qCwzS5eOXdxWQkZku8U+?=
 =?us-ascii?Q?JtLQtBWjZSE6T11WbRJl3JRuMfRuFNCJtedK3+xINO1qjI0eFN81J00T6ucp?=
 =?us-ascii?Q?00VzmkdwSaG+B0gnstFp8tyE6Fp744KGUHjQ31R9yRXTN1eLD2sI8NIoJRpV?=
 =?us-ascii?Q?8bXiM8jZn+vr1cjSZw41R+Z78iaytLMCbUkrvwG1wWgBdHDhxTtPbbY4vSBJ?=
 =?us-ascii?Q?3JTLOlvdzKQt+iHD57xGoucBvweROG5z77f3qeHmOh2F8O0lsCCLxst7TxUY?=
 =?us-ascii?Q?jWPUz6oaaJR4DjZ9UDIOxV7tEzFQpSV/ceDp9kyDpLfz9OmoajesYTSlzD8g?=
 =?us-ascii?Q?XEh99X9a+844Z3jZwNTy0TxDUPetn9YWkcgWaWxHLbso0YqZDBndlC7Dv8Fr?=
 =?us-ascii?Q?1qRbBFJQJWd/6jRh/NWTHcNxSyG67SZwmAsrA09o+BXJ/BFWD4MGXZNfT7LC?=
X-MS-Exchange-AntiSpam-MessageData-1: 0EwEP8IN2LWdvOyT1VLiHvzAvpHIxMsAuo4=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ab2e047-744c-4de8-420e-08da48847654
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2022 12:51:38.8206
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Th5tCiv0nYHoyo3jPb8L0D1jNBqWqBVZnM/5na7r23EHLgXrI7IFXoMHkGgmSRFybtm1Gnh/o4lReN5KPfMX/DbGE8qylYEgs7xChNp9ysM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR13MB5810
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

When kernel.h is used in the headers it adds a lot into dependency hell,
especially when there are circular dependencies are involved.

Remove kernel.h when it is not needed.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/nfpcore/crc32.h | 1 -
 1 file changed, 1 deletion(-)

 Reposting now that net-next has re-opened

diff --git a/drivers/net/ethernet/netronome/nfp/nfpcore/crc32.h b/drivers/net/ethernet/netronome/nfp/nfpcore/crc32.h
index afab6f0fc564..6ad43c7cefe6 100644
--- a/drivers/net/ethernet/netronome/nfp/nfpcore/crc32.h
+++ b/drivers/net/ethernet/netronome/nfp/nfpcore/crc32.h
@@ -4,7 +4,6 @@
 #ifndef NFP_CRC32_H
 #define NFP_CRC32_H
 
-#include <linux/kernel.h>
 #include <linux/crc32.h>
 
 /**
-- 
2.30.2

