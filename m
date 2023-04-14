Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 242296E23CE
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 14:57:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230163AbjDNM5x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 08:57:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229673AbjDNM5v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 08:57:51 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2075.outbound.protection.outlook.com [40.107.94.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CB9AA276;
        Fri, 14 Apr 2023 05:57:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GFwYtjqFTK6FGQCS05oZccv5WOLe4oOwRRqUPZZ79UN5+dIQokoK9MCEHvfNyPGLI/ZaaiA2byjPEYKTAZLpSUZWzyQsdMfr4ddUsVrbyL/5OfFNVQmL5kYe+q55EXFarBzgh1oPc7hGT1MvGRnhV3OYzRZM9+ZmAS+XkpmRe13dFgTG27wQbvz6VXGmJqB/099W6S3sPnqFF8RJpmuryppUvbtGFypVRIp3Fmry+dh9hepux5Qj9uTjLPEGzC6BkA5EsnyDHy+pAowEwFmFTscJ4HRHT9Cj7j+u59VoKhf0TMqNI2kybQU1VovtJ1h/K3+MOuZrUSbPqhIYhFqL0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x6R5sQN64PgaSy6cf7GllZybcBzD1BIbN+i0bY8XqLk=;
 b=SpuN1DSfpSjhLv9F4BN8VfkIeUe2euMlNJRRQZt2GLwdk8Df0u43E48QanO8HM60qt2Yj3vt9C58Nye3tEfIXsrUhqX/fXUfVAkcsbBtRIPP5w8yxOOwxNm3gu2BLEVf9dnypDwZ6JOEBJ5xmrgRJAQ6H5cDYHdOBQ7jIahPRurQMrQ42AJmRLzDkneXlDmjBYAsM0naoDCb6K854G9gSHaQ8wzfqkIiq7nBQO+9cTyAFscbCQJTafv2/shIYmxONz0awJvaLZLthSAEtjnr0VkyVTviqSKHq/KCYolQJuBr+MIlUmOeAGgR70fAWvvCX8aWqw7Q6CCx4BKfQflYCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x6R5sQN64PgaSy6cf7GllZybcBzD1BIbN+i0bY8XqLk=;
 b=IxP8tWgXNgtL9t7UsuNalgKeg0r53dFLAHal/JM1o5epA7M/TMTQCpG8H1LRGQ8CO52TvK8ZzAF2RCodDouaaDX1NQ2CAnqksYu7zo/CWGXSUAn1dAQZ5AEc6rDFGlhJbZ3R/2Has5pFTBBDJvEfOpq9U7alXSFJMm7wSu7EYlXwIZCYCUz9QYm/GMBuWLmjDxIiddYg11el9Rfi+W34MCSq5UxNy94OO40PY46odaij+cJBLZqoTwwAcpXN1hHmwRxwNFemk5QBsVw+p+yFyFqj7GEarWFXc09xmz2vketjdQruE/30CTSDleh5HOXYdRDhUPGmSBFlCikeVNCZsg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CY8PR12MB7634.namprd12.prod.outlook.com (2603:10b6:930:9d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Fri, 14 Apr
 2023 12:57:17 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::6045:ad97:10b7:62a2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::6045:ad97:10b7:62a2%9]) with mapi id 15.20.6298.030; Fri, 14 Apr 2023
 12:57:17 +0000
Date:   Fri, 14 Apr 2023 09:57:15 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Brett Creeley <brett.creeley@amd.com>
Cc:     kvm@vger.kernel.org, netdev@vger.kernel.org,
        alex.williamson@redhat.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        shannon.nelson@amd.com, drivers@pensando.io,
        simon.horman@corigine.com
Subject: Re: [PATCH v8 vfio 7/7] vfio/pds: Add Kconfig and documentation
Message-ID: <ZDlNq9YzfaX3rOi/@nvidia.com>
References: <20230404190141.57762-1-brett.creeley@amd.com>
 <20230404190141.57762-8-brett.creeley@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230404190141.57762-8-brett.creeley@amd.com>
X-ClientProxiedBy: BYAPR08CA0029.namprd08.prod.outlook.com
 (2603:10b6:a03:100::42) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CY8PR12MB7634:EE_
X-MS-Office365-Filtering-Correlation-Id: 23dedb52-9d6b-4cc5-abd3-08db3ce7c6f7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rNqFS3/iYcb3RtT3UF53Oln3Aj6VwTnWbIyr9F9fBKVfEZmraT/w5a4eww2V/V0ukr9UGzuenUw/H5uYIznAeOdVHLyeDzBAGntH4d4C//XMPT+6Lw5lD1AqxPMz9G/gUJAEzEeB1Hz9rngqdzOgnSomPuwMJrmUEHD3C23+LpXB2UsSdIxiFu27N0wCq/z0aXT9IydQsFYoHFfOoyXQgHiAtSTSslM7UalvRKgST9TWLgUbUmTLTML1VkovSye6U2c201rO0jYAmP4RLiNbUH9wv3U109JAQwNjMOW3LuhF3vh1OG2nw20L9NxRUq71YaCMsK2zgF1gmSMsohv5MgD9/Mjdy5PnXZk1SdND9IR93TwTxEfq1+MptiZIZBeUmE1E1Qp2hiadjRPRY3PjVW5hi+NdoNoeRjZ9k5aGS6569XFJbpCXfffp4sAQfZKCoEg+mTK+f4J4SgBjOZTOflG3GavHpDX47w1UEYkkaryE9d8Sz/sqqc1DG3aUZeNw46F5HtFcDfysYsOANUk7bkMABnsUpbif71veP/2LmD2SdxTraHJa2aafOAjjit44
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(346002)(366004)(376002)(396003)(136003)(451199021)(38100700002)(478600001)(6512007)(2616005)(6506007)(186003)(26005)(36756003)(6486002)(6916009)(4744005)(2906002)(4326008)(66476007)(66556008)(8676002)(8936002)(86362001)(41300700001)(66946007)(5660300002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Uccwqm72U0ia+h35bTjt4aggIAHEgfn1zJHGSZSKDI0vFz4U2/q/LwwUT8hA?=
 =?us-ascii?Q?QOVmgjHZiPFSKFOkDVuKbMtDI2IQ2i6lWNhNPn8utJIIsYcBDgB4dB3RSb6r?=
 =?us-ascii?Q?K7G3bdDEUp/dqv1Kz8CMIX0Hf3fEXyL69AMxnXm4ooLPai/geTOJ3kF2oie9?=
 =?us-ascii?Q?lwqmYYCIZutf3zXdFrAld7pAhlmixSxahJfLOp1GnLcyLwS+1KuJC2h2znzQ?=
 =?us-ascii?Q?msbULyxyv0KnQwvAIdd2KrL2qlD0Slg2SSb0ztOEs6x+rQ+KjUnpt8BgRQm+?=
 =?us-ascii?Q?NCP/uklO7mmXQn19TXufaJ9JbwcV1yZqdX4XoWDG1fKNNQyzBbwCBt/T8rhw?=
 =?us-ascii?Q?YCmlXuC1Ry6yCV1ZSiIViX4SRrTNpV7caEBcTscJFrlLKIw1mvEOcN4Yn7Tp?=
 =?us-ascii?Q?OWvtumBhbWw24lYsUYwpG/qpMAMveW2A+IAYmQlzBTFTRFJM9vY9egUFpc8E?=
 =?us-ascii?Q?QE39EUQOu5q6kfT10hkC0+wwpUdeJm0c+XV38JYPAE6Ooh4AElzh3Scmfp8j?=
 =?us-ascii?Q?rTyU0IuDP1hKMntM22JVZXV4N4VsoRCMERNZRcNMM8fKy8lHKFB3iKeTgC2p?=
 =?us-ascii?Q?RqX2QKy4gJsYU2lxNmofV9oZAG+QqiznNZSKm0lHvlbf0AmGLhoJOIS3uyuF?=
 =?us-ascii?Q?+27h2MaJHR4ernStZEtKXnIgMPASbYrgl1hA2124gFlTI6j8zZLG2g9jSg1Q?=
 =?us-ascii?Q?MUrC2nRk0+D0GnK353lfgZjkFdL+ggLBuydzhJKFC6kVMvE1n6NOZvLEXJ0+?=
 =?us-ascii?Q?IBYLhmUMhGoV0k4QQiWLkxb5gW0gs7D27sZiHkOiuQIw2mr8pr5P0vsSIy8a?=
 =?us-ascii?Q?6HDqMwzJV7FsDGYmCW6m909tB9JGEaLKIFDjacISFqW6t7GAxn+xhK8i/K4m?=
 =?us-ascii?Q?G1d9bDaieTONNlmv+s7uNi/BEbrvjDxsdqa15drXrJEfojS3+efX0awHZuLl?=
 =?us-ascii?Q?4dUCCpLNVmdoZLX5BKiwA8+muqKx548xZS9wwoy+eYt6fKH1Rp+SiZR8Za/p?=
 =?us-ascii?Q?klpXTPCfV+6xBjF+m/76OjzwjDZtpbdcQ8a1qX6GBbHGbYr4YU0RDt3FnxPH?=
 =?us-ascii?Q?iIs+uyT4h2JfqE1+xnOpy9BI4N8vz/bbxuUvjqWpDgjWfLnmGXTOnvBoA2wO?=
 =?us-ascii?Q?BgyDL3fkYfF2woHAgkYE/cvRyi6kDyRcY5a22xeG2lGAU17LqMPDn4M5S9hI?=
 =?us-ascii?Q?65LAMlu5jXndGThuDLw7r47BYNWISskobPdQ9FnXBJZ3W3QhGvR/0goeXAO7?=
 =?us-ascii?Q?n4SQIKJccxzhESlRSyMvH1N0womttPhgUjqWQ8xRbPgtmBELOUhnIg+TXHrj?=
 =?us-ascii?Q?tca5FXJOi8ElgMVW6i+VcTTuYVeBeR4yamzzpsksXGYj0GE2HuDIPTf5jhp4?=
 =?us-ascii?Q?VOYE3lIkyQcMKil+Ak4jRctH08J/adtyaY1jw7iBbzAOl/woU0dudFk+luoK?=
 =?us-ascii?Q?YtPaInQBbcQb9I64/XmIsbTKWAzYIvZ5XhPSLejT2ffiZubkCPooId3Bs1uG?=
 =?us-ascii?Q?Abm39wOAc99+2zff6Td47w2u/8UNpTrjIjsmHNvGkLLqDyUt/dRzk1H+I7YX?=
 =?us-ascii?Q?TPkrGmC6b2AN5EsWxyQVhsVjuuXy5Fzs/uuX4rDU?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23dedb52-9d6b-4cc5-abd3-08db3ce7c6f7
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2023 12:57:17.8088
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YoFLcYlOJztj+mZJOfwqq/NlK6Fz9N+SGi/uiXwsB3MtPS2eS4LT3GyzQvrdAQRC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7634
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 04, 2023 at 12:01:41PM -0700, Brett Creeley wrote:
> Add Kconfig entries and pds_vfio.rst. Also, add an entry in the
> MAINTAINERS file for this new driver.
> 
> It's not clear where documentation for vendor specific VFIO
> drivers should live, so just re-use the current amd
> ethernet location.

It would be nice to make a kdoc section for vfio.

Jason
