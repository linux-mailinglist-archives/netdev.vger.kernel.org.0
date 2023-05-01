Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D938C6F327D
	for <lists+netdev@lfdr.de>; Mon,  1 May 2023 17:08:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232434AbjEAPIm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 May 2023 11:08:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231728AbjEAPIl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 May 2023 11:08:41 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2136.outbound.protection.outlook.com [40.107.95.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44EDFE42
        for <netdev@vger.kernel.org>; Mon,  1 May 2023 08:08:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n6H0RRQ9I6m22b63y1lsJ07EG2bojwrIDZbOrN+rZ8StJJCUtsI+xBkvtOQlDalbIT9vsGLj4Nwy39E3EOo+6PepK0nkZXzt/rva3LZ4VKCmJB1c5H0pt0a3NMINzoCol7shaHaqJPH5zqf3TbhanlaKSZrr/7McuTzF+4u2iAZVjqz1ieWrSOgfffncaf4HSPdspLb2ZpGm6kMfCEf8Kjbm30VR65wIHi+xKaVmvKHidHjcsbz61VvQvhbBGFCo1SZP5Lhx0JF0EZ2uiTGPoC+77ybFDw0+dgYeABwnZTG3s3yTh8qVqe8f24yqteSC1ZoueYOTvd5GAti5XHr2QA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WIy+ikqoza0ov0ckYqR3rMDINZlGf7WbUzgYNzXuWr4=;
 b=NWNvJyj69oKLTZD30PcWd/9rHeK0k8uzbTbsvupU3l/zfuy5VIPPi2SLesCC1fSUDa7HU7CF85eS5gmWH2CHksyGgzXHf3OAGPDbYszi+NONmPJKueK6UYS4xfugq2JzPmvK2HYgVh4l4cFmGoNyfgXGtoMUQhEIOfNIVvzIG2Dy5agZUdCpEHMFdCrDKi28vUvGU4zss0P5/F1Y40BdCbXokBBOelN4OdsXMLUXrfeyvVtqZYd+bTz4Tlo4D4/P8Nrx0K7wqNR/gooMWqvlcovAAYeg82jka1DCfWuUe0skYRVsGWEMwYWxZwMVOhnmFJLbuPGom+ZfCQEKdijRaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WIy+ikqoza0ov0ckYqR3rMDINZlGf7WbUzgYNzXuWr4=;
 b=dJvof3XU33kTQViIvFawoMKKronLeEs1hXAM4TnG7nvyK9TL6wF4gC8eMxoSSwkhgzsodEatYf86UpzhL58yQWEd2mRPVMZRA85BvESZLXF8ZRTrjY3z1mpQsPtlb9TArfuHOQI5h6puSTLtshcZBvnsIoyYK0LX91CQexngkgE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY3PR13MB5059.namprd13.prod.outlook.com (2603:10b6:a03:36e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.30; Mon, 1 May
 2023 15:08:35 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6340.030; Mon, 1 May 2023
 15:08:35 +0000
Date:   Mon, 1 May 2023 17:08:29 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Shannon Nelson <shannon.nelson@amd.com>
Cc:     jasowang@redhat.com, mst@redhat.com,
        virtualization@lists.linux-foundation.org, brett.creeley@amd.com,
        netdev@vger.kernel.org, drivers@pensando.io
Subject: Re: [PATCH v4 virtio 09/10] pds_vdpa: subscribe to the pds_core
 events
Message-ID: <ZE/V7SuOMD8z+afU@corigine.com>
References: <20230425212602.1157-1-shannon.nelson@amd.com>
 <20230425212602.1157-10-shannon.nelson@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230425212602.1157-10-shannon.nelson@amd.com>
X-ClientProxiedBy: AS4P190CA0024.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d0::15) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY3PR13MB5059:EE_
X-MS-Office365-Filtering-Correlation-Id: b752eb01-567f-4c0e-794d-08db4a55ef71
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YAXAaDUkcxt8pVBdhXp1D/IZ/Hi+wfoudHfsFQTicpJ6045Feir/XVGXuRfaozb3j12rTpiC+wJsNYKpSrSEUtsa27KXBtKqBj8hFTX9xyaTgyv58R0aX5O2/z0S/o9h3hSePgFDorSJRdf/01NVchoYZouB8IMeT+CI/FL4+pvul6ZU9Q4Zn+GhPLHuE/G43xp6I9pBdoBGPPVlUJ7F3K7754RpwALQwNDN6QR2Aade3hHY+cZ5WwALrvifcdJM7zQ0QdeLpMSmpOdYmPHK0CBpN1OFz9OM5yfAWdsBUXGVQHfQIRgQIzUrcOWYwDJqr337JYWZcHriPyyE2KrRQPNDmhKKcW+gmo1a2UXiRBY4PASKF5fJkpfw7MBx9UMfOQDg+wE1piPI9ZNib5zX8wNGoFwzxW88X12K05X1AN3Lakvtf2Qp+zDYBBGseuD0/O2OC2VyCHDuqp7H3MbrmUucoUwcAC8Se5gsVdrtcFKVKo09xYuw6eYHFS+Tzese1AFtyp7qfHHKV01oQbiEfVija+OJTiFiTQ3ZY3kDbu11NB75cCg1NM895/HCR7QD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39830400003)(136003)(366004)(396003)(376002)(346002)(451199021)(86362001)(83380400001)(6486002)(6666004)(2616005)(6506007)(6512007)(186003)(44832011)(4744005)(2906002)(36756003)(5660300002)(38100700002)(66476007)(66556008)(4326008)(66946007)(6916009)(41300700001)(8676002)(8936002)(316002)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nL3J1vBXWAkVvBLbhYsdrbIvnD+S6YMdGToz0+iEgzmGcJHS7RM8YOMQ/71i?=
 =?us-ascii?Q?8pMOtk915X5tuqbjGp+WQQ9dV51IOxCMHkicSzvUrTLwGPJNNqHiTPpepeyK?=
 =?us-ascii?Q?d8muSV9EKjZANl1BEkE+Sc5RjxMcg2O1CRE46Zv6F8ELiM2M72qVmI+EtnSd?=
 =?us-ascii?Q?3smmIoURuSnmYi2fEyjzGI6sMyB4fzU/RfcHrjd+WlHG7O72HOBJsgH26yBM?=
 =?us-ascii?Q?KFgObk8r5hkJAiXH6LSkl30sKbbIuDK9kRTdlcSzpEi9cocG+0bEDI/OjxI+?=
 =?us-ascii?Q?YkldzahNtq9342LJsmYMk5uz1rLE+az9GcItu7mVdnZPuv7yAT2J2yzPZipK?=
 =?us-ascii?Q?pp8/id/I/4s8W+XDZqrjBE82ekZFWVyCaG8yrvcGJrW6RGzLvmlRzm1rFwyE?=
 =?us-ascii?Q?ma329DK36hTDBXDTx0jGba6uXhMnduAmArTyy7HCswZJzxkpMdlMqAgrOIvQ?=
 =?us-ascii?Q?nOvl3LpQUp+jFKTEHzslpIDDdB+dBo5EqhQlHWI5wANfT2vAoHbXdaliGq5M?=
 =?us-ascii?Q?viRo8BpxysECd6RNeZ8TKBKjQRHaKurnptAmpQMlniodFWG0PjBfl8IhPtzY?=
 =?us-ascii?Q?6Qu1YcXrgaB/nnUOAZ6iUpDM5bSK/jYFfWUmx/8ugYgtpxA/Rn1P2edo561G?=
 =?us-ascii?Q?Iy/aN85CENPoPGvTjTZv8qdjRCXvzI4BvCa+YwIO+hBDZfKDXSMqv3l9msJQ?=
 =?us-ascii?Q?hRtYhwtqK6WL0omCgBzEQ7ThQBc15aO2i+sJonyqFSsJoTc1XNig2TgCTXGp?=
 =?us-ascii?Q?BbtuPWkEkcJrjT084UrNtyaHZ3NHNNT1Xfcj6H0J+eH9svDq/Bqlj/BtTpJ+?=
 =?us-ascii?Q?CSPQ8pQoGAApEzXBLYw2GRQTBUa5/pGGESl0+Fq4FnS4tYf3Dcg7I4AVJ9r8?=
 =?us-ascii?Q?mdaHAwifxtuy4F5CybRlWGpiLNChCmU5G+G527dgozk+n2Sv5vE1SNRYOzia?=
 =?us-ascii?Q?gu4qGXNIFPtptAWGVl1grNbKzveIA7zn1djwHgIIPSDmpsnCGgmnswL2YNu5?=
 =?us-ascii?Q?97fPEc5eid5z/K/RivsPZIRpq0ykQ2qX2iuSFZV1w2RAs5QO0YVdn4rXjRkf?=
 =?us-ascii?Q?ddW/ghYVDqBtwtsO/LBYRbstMfmsKyV8ZyL44so9TJ0ZBA64Xj9siKjvaWVg?=
 =?us-ascii?Q?MxzaRi8EBZiXFGsO52UTPgWBUk8SfAGXLrmkXkEVZ3lu64fqAJgEaFTXbm7/?=
 =?us-ascii?Q?tir0QgddczAJGCIb7am6xTpRIFBvHTQ5mVFAYt7veuUL7sOWbeLqDoZkoa7u?=
 =?us-ascii?Q?0yi89qPydAf7Db/K54QEbnYsgmK87hyPqXhZtw+WpHhLtB6hKfrWvQtdP6rJ?=
 =?us-ascii?Q?ruaD9H2qBG2IFbXqeFYlaSfWHf1JvF2ZWPiArvLrHHLEI/ro5Z9WhiFDkaOD?=
 =?us-ascii?Q?v4z4kXtst0i4JU03TE2jYiHu+OCXu3uZCjFLQE0sAt9y3mTb1GoiWgN5DC3F?=
 =?us-ascii?Q?ASTZrt9UNLpu0p69OILk4kEEqId1bgbzFyAXTiYD+vSB/dQUWqLIK+veSzg4?=
 =?us-ascii?Q?cGPuksuqnHZnxpS3ZAu8oZ3xbpzMKQ2Oy8ISV4gBKBGDA+o4gGxaPvbN2HBv?=
 =?us-ascii?Q?GDX6udsG7ROrMSAR3izWF3xOKgjoonD1MDUNBpul9Ef1/ihkC53GuZlbKRFh?=
 =?us-ascii?Q?ardARqOHjPoRPx9ybTU9I6fi+OBfW1HCB2YDpwHxORqXEC7SVnXSzirrhgBR?=
 =?us-ascii?Q?PYs8aw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b752eb01-567f-4c0e-794d-08db4a55ef71
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2023 15:08:35.4700
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MF08IXDDee1Zn6Iv2Byl4EL5HqfNc2FVMQABHX8V46zT2XTL5SBccpe8mfFfZT5taW9CVvpDjpOhg5/p0iTilk/X3T6uAp3JntVdZsuIT6M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR13MB5059
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 25, 2023 at 02:26:01PM -0700, Shannon Nelson wrote:
> Register for the pds_core's notification events, primarily to
> find out when the FW has been reset so we can pass this on
> back up the chain.
> 
> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

