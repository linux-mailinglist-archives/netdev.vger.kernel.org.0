Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAD0D6F327C
	for <lists+netdev@lfdr.de>; Mon,  1 May 2023 17:08:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232558AbjEAPI0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 May 2023 11:08:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231728AbjEAPIZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 May 2023 11:08:25 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on20721.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eaa::721])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85FD2187
        for <netdev@vger.kernel.org>; Mon,  1 May 2023 08:08:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iPjlc+B/2clsdM9P5B1uuBEcPou4TmT5i+fy88EDVkxuOl/+iLGKBgVNgWzO6EQ1IBxrVpHFQhpC183HfczGzmYRq28sgzhbJlXPquYJiMiNrrctwp8EKmrTHZaAf2JVR2AlzjGh/yqFPNMdhsn2hiEwsmEjwfGwN+KFmuO7t7BJrr5CVtH7fMOZYg+0SYUdVtoKoOD816/9lPXV4biICbrxtGL2DzK8IjhScdJqN/fF4+JVEdidH2pLx8pqU16pz8mLfWYcFMV8mkHjafaoPgIXzQm5vW29jMon6gIOmghukI1yk5Jl8+/hnA1LsylY54X5mv7gMl0+A1apMnmgkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wW5U5bTLApobxE09ZXPlqhzYqemrelRObu6PpC7eFWo=;
 b=RWS6z1zsd/MYUIOCG8JH/YTjjpBM+L8rUSnEK4CbzXFtqVtxafI39oBj5tu42jHCe+uWSRbb2OBTBSMNkcIZynjpG4UPH8/Q/wTdwkbgWPOCewj+N7xq1tstAyRyNym+PuTcj3M9iKr7l9Z/29GsQS5vZ1SlOWmZwASXvMzVZEfO86cpqP1yKEeFK6kv7imvok7xgaK2XrOsXvqJ3Cq3pkBC73T2jxdGeGMBeEnf9ROO6RvlYa9fmxYj2sUkFo4PhQ2Wpoz4PQ7PUM7o3f+0hG9zfurEaoRVTNFLFphoA18uhgp8eo8jgACRfM9wXCW87ZIhsJd+RtTYKruPHq3XnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wW5U5bTLApobxE09ZXPlqhzYqemrelRObu6PpC7eFWo=;
 b=DxPwh8VLjTLhUikS0cVR1JNsoR2dXbI2asqHkupogNGjLDzXiLDXjV3vyRQDScNv8dGDBZ8keVZk7MBgl5Ft7KLpVUjJvRFc3I3lxIVFTif9MhXPUFIu3xWBZ8bV7NJIIICkgYzlX5H73J9PYkGtjas2wowynmSJw3ETqIZDFyw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SN4PR13MB5680.namprd13.prod.outlook.com (2603:10b6:806:1ec::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.32; Mon, 1 May
 2023 15:08:18 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6340.030; Mon, 1 May 2023
 15:08:18 +0000
Date:   Mon, 1 May 2023 17:08:12 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Shannon Nelson <shannon.nelson@amd.com>
Cc:     jasowang@redhat.com, mst@redhat.com,
        virtualization@lists.linux-foundation.org, brett.creeley@amd.com,
        netdev@vger.kernel.org, drivers@pensando.io
Subject: Re: [PATCH v4 virtio 02/10] pds_vdpa: Add new vDPA driver for
 AMD/Pensando DSC
Message-ID: <ZE/V3AG3ueL26QKO@corigine.com>
References: <20230425212602.1157-1-shannon.nelson@amd.com>
 <20230425212602.1157-3-shannon.nelson@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230425212602.1157-3-shannon.nelson@amd.com>
X-ClientProxiedBy: AM4PR0902CA0007.eurprd09.prod.outlook.com
 (2603:10a6:200:9b::17) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SN4PR13MB5680:EE_
X-MS-Office365-Filtering-Correlation-Id: 748f01a8-10a3-430a-4474-08db4a55e53f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nbgQieWJ6EZAflmmNVKmVbfcbfDXXbzyukbEDERfDwTrE7tqqNQ3tLdfuQtx9dvHq0JToAObXUY3lChkOHlHL5XhsXa/lwrZgx9pQkdtNE6pmmrilNykc28BNMRUt1K15+Igv9iI03VBqxrCLlrmwUkrih7KMOILko8sV2xBNYdx8R5TntTo2Ibwp4i+S/c9Z/J8PT7XDbE6ItjlF8AZAVZ9iwX1CVHAlOlqvGOlzvQt0UsKY+yWL3zz0zhmVouYii0TvIuyJBty7GzFdjGqDm1nWy9cYtpTsxw4vS+W2aUR22zJs2DneZDEeJ+K5ShzFqTNfeVMI+KafJHmcVJX1TcpDa4vq4jQWGHDsFYm0u4catOWNT2yy7aCiDBNWM9EeALx9UHl//lvjb8/52w5we5cas3cS+B/qIy6nSTVQAgy+/lht8p7s2EU/IVSLw3PBpKNKZmCLF4xsX/QEXOHQ6KmvL5svdyqLCMbnfIbvZJaAwon3AA/kzHf+Ah79auNjHWx+ayJ0IwFnqYChXHztkOGVPtld3WqDkkE+HRuJohbNgXmr8h3jcV5kVA4ZaFt
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(346002)(366004)(376002)(39830400003)(396003)(451199021)(66946007)(6916009)(66556008)(36756003)(66476007)(6486002)(4326008)(316002)(44832011)(6666004)(2906002)(4744005)(186003)(5660300002)(41300700001)(478600001)(8936002)(8676002)(83380400001)(86362001)(6512007)(6506007)(38100700002)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Fr1p2PQLUnhZQEzrVX4d/PbnEAE8riCzZcUNfmU6ZmYhYbJH+mF+KvAU1kNr?=
 =?us-ascii?Q?c1T+MvH8rvFXRgTQf0jzJ6XcUPjq+ZolRCUoKFAoDvyaN+nhI2cBfyF7zR4o?=
 =?us-ascii?Q?06yvPxOVSbIPBmxUSjmIsdekhN/s05Z1nH8gqYsyogcO1l1JQ4vx9fzwJwOb?=
 =?us-ascii?Q?U4F4ch0Q9r/3goWMnAMzqkUNZRTr+9hs2PympWbxwO9DZVssiKReFgE+Lc5Q?=
 =?us-ascii?Q?EtzzkFZGS878u5hMMieD9PWUpWeM0istudTEs/RuwR6ElYF76upIaGtwJZ/w?=
 =?us-ascii?Q?YmVXmz8DfKsMtScwuvNF3lKdr1nLeL96iynBdpRCCmGhBf6rNJBXHow1V+5X?=
 =?us-ascii?Q?CaFKWl32OSzmrXcBSnPLG0vRQK1feSu2T1VLkAiLBENi6BtcOnmxYkedN2Tx?=
 =?us-ascii?Q?jzzqGJlKmIbSREHREtkB05eKGXUIS3+zQ3dKgNfquVEyAs6hQ+QIoPfCdfx4?=
 =?us-ascii?Q?AEZHJrWujlnoyIbB6CuoGUnVfulAWksUQf4n7IsryU7CGDiDkwO7oxpfHGz1?=
 =?us-ascii?Q?rC0phpeYmF56k8HFaWOYlnuPgjzCONfLoCwHONH25iKa47PIKtJ2NlVrEwhl?=
 =?us-ascii?Q?NS9I6nYtvLYQb7zTObm0jz565S2GHISF02bDC3KwobNHpAcbnsmxmf7v1mOk?=
 =?us-ascii?Q?XnayQwtWwEr17to5Qk5EkOFyeDwnyVezUXFvXHlLSpEs3KwQws1HIbl+YISc?=
 =?us-ascii?Q?dcAQjB/kCUrVXYwWmO+z4BZEPnI8dg+hXpN5T1HhKbDjuhVpUnpyCG2b78RV?=
 =?us-ascii?Q?4uShe4webDTJhY1E1apQUWLimwYJ9KqgH/0kA7MHuoEzuGT3RhtaH4GQ+6/2?=
 =?us-ascii?Q?OzYwnHoSMwuOWCr7O1t/EY715Dz3tdycv1pJG2jQbTRHWTf0ceDPrYqp0inq?=
 =?us-ascii?Q?zkkFSiqG5pYNzB8HOgK7bgAS+WFMl5QwH4PlP+gr55Q8UPgztQBQU+g2GMXV?=
 =?us-ascii?Q?OzoDxINmRzM1lhI9yFl8nFNwrQdg/p2336Zc9OmHC1+mDwjzfV/AO5usceWJ?=
 =?us-ascii?Q?uRtG7zpAdnA0ZqUgVz8wabD7DCB1I4at7HcxMBb6j7YD0v9wJmdAOb5bUvJV?=
 =?us-ascii?Q?+Xv0YDIQFPZwWEIkvKz03uZwbsSj68aTt+ip9lqRlzP2ZDcwV+/5FbQPQ6Nw?=
 =?us-ascii?Q?fVE336HdpGjlvKf40lRugUXPv1RN5u8A9kjf9O+E/70/ItJzwYuOcAULegpV?=
 =?us-ascii?Q?RUgN0GOFcaxTRDipsF9QHBQUSoJd3003Btm6T+FmUzUSaoulvxAN1+nRpwmo?=
 =?us-ascii?Q?DcAB6uipwnppJRuxKj/kDwqAZx54MyP3X8IejYc+ajEA77WnUoqBmvwz6ZNf?=
 =?us-ascii?Q?MU+Qv4r2N0PuOavWYkkOd62BEYsRCt1YH2CpIKQ8/KU+I9RDaNblfvNciwjK?=
 =?us-ascii?Q?tNUCXtF3hOQH6GKRFkJSjubP4zYDvqz+oiKElUb070AkheATFiJKchbtRzGP?=
 =?us-ascii?Q?JZHAA6M8yM2Fr20ND5NYvfu2hvRTvH2gU6uS4MKry6kiEUUq4z71+4Z0ahpX?=
 =?us-ascii?Q?CfV5UViAaoeCbO8daxaZE3Xr5tfiopP0rG4kq0HEmEq1n72zAONOYz71BfSK?=
 =?us-ascii?Q?Pv325QmAM42yv9QMm/n7as5zJ3VDbUAcUS1mbeXoWf2acEfvMFEvdxdGGPEv?=
 =?us-ascii?Q?XevA+bI3A3y3sWfpA9LOxL8kdTOuno4PysRaobY2YcIGtTQJLBK5bmiDVjrM?=
 =?us-ascii?Q?n5ui5A=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 748f01a8-10a3-430a-4474-08db4a55e53f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2023 15:08:18.4067
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BbmfPkFi3CUEgUH/Cs6EX0416i5nJHsu+0c1RXRBPihloA1+kDFau7y6F7kRcjx5G/i2R/XNrfQzYgEQ26sw8EeL/pQVF9O6ROW4fa9+jLg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR13MB5680
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 25, 2023 at 02:25:54PM -0700, Shannon Nelson wrote:
> This is the initial auxiliary driver framework for a new vDPA
> device driver, an auxiliary_bus client of the pds_core driver.
> The pds_core driver supplies the PCI services for the VF device
> and for accessing the adminq in the PF device.
> 
> This patch adds the very basics of registering for the auxiliary
> device and setting up debugfs entries.
> 
> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
> Acked-by: Jason Wang <jasowang@redhat.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

