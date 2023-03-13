Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 752AC6B7D69
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 17:26:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231166AbjCMQ0N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 12:26:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230355AbjCMQ0M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 12:26:12 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2093.outbound.protection.outlook.com [40.107.92.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF95F2DE41
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 09:26:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LjU447DOlaOHypZ8WpRBZCY1FJnn8LPKTAe8j2Ih3S8MZdJFA5EU82kZHxWI3nVwotOJpym9PSi6X483Lj0A90c5hk9ejEfEOgdEniikg2RlWMiQpUz1v9e68kdVckEL9nyOuQr9ga4wER7WdSjRbaOW7e89+0tHt/yfG8S5tReRBzhbi8+1HsmmyccHvcvN2UZqQ9g+3uPut7AvC7j9dbO0vW7rBzcSBxyalQcNeJDsVMVoFhDnlBuLiIwcUUntkJWrID8uIQxG+VvgwDm0rArXq1bylY/UIfg5mAOOMtLrG15vKOOSypsljbO8yKOvcKwHAWg0GR0OAbQqsROr0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RaiTWc1TBAi5d1rLuyLL3Bni4jqnqiB7HmeC9LT6Wkw=;
 b=FPH+XkvuuYsZqnm1TY0qtGdpY0dLj0Orz7hO0Vz3VOP+XnrP17+2s33ZcQ4JctvVNbKVTQote/rDO/CC8nl8y1dQocO37IWIULXyKoM3UOa1VGiBbacJH1tj9DtdrMpOKTrk/qSOyGhjgijLgUK5ZixPqhJWVwne7EzFaW2QNfvcHZ1ci/hHD4KQmJbim+p7qkxxsgw12Cl8ljz7g2W0yYbz3TDTSgJFNYf46IUcytSVKyghZiHP0bVoq4kjsUAWvsKo72eVQ4pSVX/7AvaQG73OLBaAS5ndcDMUANMmnjZtokDpx+ay+4bIL74dspJ8rvPGgLocb0whjxw2XBPsjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RaiTWc1TBAi5d1rLuyLL3Bni4jqnqiB7HmeC9LT6Wkw=;
 b=Yv0cahuwprdQm5RKA4NuM46VgCaJuoHpioCtAfJINgFh6+4tN/9kjQi2WHHs/08LWgMeTco92N9Th4hFif5f0++GEefjTuwLrcDhut8nMvWjeU9QFnyD1tW3iJiC/vtIZqJE2VHkeW9DrzKa2xXEuhFhRvd7DbacZjHQAu3t8ek=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CO1PR13MB4936.namprd13.prod.outlook.com (2603:10b6:303:fb::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Mon, 13 Mar
 2023 16:26:07 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.024; Mon, 13 Mar 2023
 16:26:07 +0000
Date:   Mon, 13 Mar 2023 17:26:01 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Shannon Nelson <shannon.nelson@amd.com>
Cc:     jasowang@redhat.com, mst@redhat.com,
        virtualization@lists.linux-foundation.org, brett.creeley@amd.com,
        davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        drivers@pensando.io
Subject: Re: [PATCH RFC v2 virtio 1/7] pds_vdpa: Add new vDPA driver for
 AMD/Pensando DSC
Message-ID: <ZA9OmfdYIosUrKAa@corigine.com>
References: <20230309013046.23523-1-shannon.nelson@amd.com>
 <20230309013046.23523-2-shannon.nelson@amd.com>
 <ZA3cYPoWQCjYoB3g@corigine.com>
 <ZA3jKuMlr/kBQNml@corigine.com>
 <37fd08f6-0608-c6a3-28f0-63d05eaf0a40@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37fd08f6-0608-c6a3-28f0-63d05eaf0a40@amd.com>
X-ClientProxiedBy: AS4P251CA0012.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d2::13) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CO1PR13MB4936:EE_
X-MS-Office365-Filtering-Correlation-Id: e0feb100-d10e-4ecc-c33a-08db23dfa604
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: exDXoeMfUmab8q0VOpbmXDGrTEMnY6rNbP6X2w9a7FfIfWOoZkC1yY3nLdqoBx9/3NZQQjcfha7A7ZVfjIFD5B3sZuD5d6gZS7r74gHPjTU/NWdGMm4SuiQWdbbiz/Du6eDl19lHtdNEkPPtIEFA7tcs7FDm9PdTPGX2rO1As4mttCpn4OELJXYQKVmcU9Yy4xhSiUN/CRpIMxrcr1fY3zXa5QpiBxnLloqM3a5qq3aghVVdZDSQUrbYmIn5Vo9MmyBgZtyfKahONZ8Sd/FEyOkaudBe2WdkqNWncqn2FH3HK0scPfHWsUeeMNxlBOZr92BhyKXdXjgwao0P0ovvTJfjGtwZXOouloEVzJOBf13k709SQhJP/xz4Qikr56cQiBMaGv3SreOa1oOH+zhhqyt+JJPA73dhXmyexDw/s3CmY+wdvYnE9+ff/ipV/Q2r6zYa0EsCJYs0xX5r1yjweOcc1M822srKbCQvTQEW0HCm3hECNUQ8KAi4xLop6+872BSoU1gtOWEWT6ys/oEDmmhzI4BKf6gPwB6BhXq4nTM4RYRHlWBLsPcN31nKzEk87A6UFRyrLNIDZkWdIpI6gF09R0zwWgH8YMjMF2xQQl39J63Sn6vIcCHPCc4wcrtDGzu0xq482rQWIN4nEmyA6A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39840400004)(366004)(376002)(396003)(136003)(346002)(451199018)(41300700001)(478600001)(8936002)(66556008)(8676002)(66476007)(6916009)(66946007)(4326008)(86362001)(36756003)(38100700002)(6512007)(6666004)(53546011)(186003)(6506007)(44832011)(5660300002)(2906002)(316002)(6486002)(83380400001)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?D2jaYPLze58sEay6B7m322lyIurGuBNY+FXbQahp7PO9JgiVp8UdGqSgNKhJ?=
 =?us-ascii?Q?4Dd7KAiMj/co8NHbgPQ97WO16JuKQqr0NRHYmofvToEdIdVi8+KQR9TQEv9o?=
 =?us-ascii?Q?QYzVHkB67UIzXBhqa9rsVDq5+WFKHwAr+M83emuXIhXV2cDi/CTyUqc4wibf?=
 =?us-ascii?Q?4Sjk+KrNkSV+EpLV/Fgkkg8UDVowPo01d8t83XvrlDWn/Iqv7A+8MUWL2GmR?=
 =?us-ascii?Q?0p8Tc7Sd6RmuILUpK+N2h//EaP5FFNWai1MXudi7qus4oRxPk823zOBhvK31?=
 =?us-ascii?Q?oE08R7fzfhZBF+dp7M9C81uPu1ZkzA8/p5RTI0O7QxP+4UXE5z+TEF/GqKUh?=
 =?us-ascii?Q?xpkde2sXKkpgGvvfjJOYUyunVzcWHl/IP6Wk+cS5h+kg5NP9zh82JqqQH/mZ?=
 =?us-ascii?Q?PqBHUXc0Y7VpcUna3Jv71NATpsE2Ij20gGd3tjoOXQllbCzEHSnpYsA/DXks?=
 =?us-ascii?Q?AhP6RthA31gtlv9Xt6F37HJY0d0R9q+Doh8z6T+uVkTTc5Vi//qJziWZ3W5l?=
 =?us-ascii?Q?abhwQVloolq9CUxynAnSQQ6SDMRdXZkHC39vjysySQzsYmoU4GAhErr+//kg?=
 =?us-ascii?Q?y9d4loxMMymUd4IlFMdQ5I+56193/8NalyKId+Jw+D66FnHTeRfYtxKwJEu4?=
 =?us-ascii?Q?C8eAm7/Skp1kVnmu3Tv0zI9/VIqFvGrCnOU8NxVaqZ4TdbRj5Ge/GPQbR7+x?=
 =?us-ascii?Q?sZ5ELw9XvaQdaQWYJB2VQsqwD+O14qQQzTz1jzh4UFGzMiQjXo6znydC826L?=
 =?us-ascii?Q?4WiK0PHzy1H7SAeZaocsWwQXqoklQiLaJUc6biwkfSYnYWv/263KqmA4D8nB?=
 =?us-ascii?Q?rxbswikjYIp9kGahPqK2NeIEXhNQmY+BqlfA+dM8FBWXI6yzJdoqvPLbWZSS?=
 =?us-ascii?Q?dkrauyIz8WP7R8tHmYTBaoS7vEbunOKmEX1kSdeZYLZo+mbuSjrgEoiWfBkg?=
 =?us-ascii?Q?ROBrn6tstGo4PykaYAyBZKfJzP1YK59YH6kIiDvRNR0nc9GkjoJHxmji/pW6?=
 =?us-ascii?Q?Epg/aaxt/z9zllUzGuahzyqZCQ1fD6BrO2EdCNiYJW8sGIiDeQ0tlLJr9kVT?=
 =?us-ascii?Q?bAXivB2xo46Wmox7kFFegEqHMHIc8ulDIQaxGnJu1GvBoApy9YTe9sbBIfIX?=
 =?us-ascii?Q?NnPpy/SOsr1qlTHbc30aj/H3dGvCiL+8zqMHxv163ylMr6l9QfXPbaY7j6aG?=
 =?us-ascii?Q?iNiSy+eNG9G/xqFwla1XNsQSkIQFEoc6nApCnjy25Xzfr/RnH97ryO8Yk45n?=
 =?us-ascii?Q?Fcga8VexPVD5ZM658qSACMDw9LCiW1WtW9vcnbavy5nejWupK73LN4oLOUwh?=
 =?us-ascii?Q?wZRTWOqMOxpHMyzhcNYehiIQFuN6kMg2DtNJqawooRHubhJ7n1PgOO9PAimX?=
 =?us-ascii?Q?GaKqzS3ZaG8z7xDfFOZojguqnSF0eY+DCTvLMUShDlvyP5Lm7Y2q6DPlFNnr?=
 =?us-ascii?Q?5oZf0VBfiPoE1Sn/VzCRas3dKlvaWh61zqZjb9nBUAyGDsvGPWJnu5EiXiwr?=
 =?us-ascii?Q?5zviWcD7PsgNqJrsH5jO1c3KYyxo45/YANk1NZ8oUK58aetv/eE0XhAvWUr3?=
 =?us-ascii?Q?r+VLE0aiQIqnsrtPcO1++gsnNSAYTC9+Tk0UentmdEQcWG1pKPiLQXNPYWNK?=
 =?us-ascii?Q?cK9U+MaspBtfZq8uHACeiiFAwl+nPrl/NSF45uxQpoS7cP0UeEIeYNiEsQ4O?=
 =?us-ascii?Q?AzfW8g=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0feb100-d10e-4ecc-c33a-08db23dfa604
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2023 16:26:07.4628
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EvYhTVZR7ZJaW2mCtg4bYRIsjT7Y6qhrh4WjUZKZkycQH8w5+znPjcNJmLUgpMRpl4hyKbYQGhGJnzaI99FHFPABhKbX3rE6Lq0C76FLwFI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR13MB4936
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 13, 2023 at 09:13:11AM -0700, Shannon Nelson wrote:
> On 3/12/23 7:35 AM, Simon Horman wrote:
> > On Sun, Mar 12, 2023 at 03:06:39PM +0100, Simon Horman wrote:
> > > On Wed, Mar 08, 2023 at 05:30:40PM -0800, Shannon Nelson wrote:
> > > > This is the initial auxiliary driver framework for a new vDPA
> > > > device driver, an auxiliary_bus client of the pds_core driver.
> > > > The pds_core driver supplies the PCI services for the VF device
> > > > and for accessing the adminq in the PF device.
> > > > 
> > > > This patch adds the very basics of registering for the auxiliary
> > > > device, setting up debugfs entries, and registering with devlink.
> > > > 
> > > > Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
> > > 
> > > ...
> > > 
> > > > diff --git a/drivers/vdpa/pds/Makefile b/drivers/vdpa/pds/Makefile
> > > > new file mode 100644
> > > > index 000000000000..a9cd2f450ae1
> > > > --- /dev/null
> > > > +++ b/drivers/vdpa/pds/Makefile
> > > > @@ -0,0 +1,8 @@
> > > > +# SPDX-License-Identifier: GPL-2.0-only
> > > > +# Copyright(c) 2023 Advanced Micro Devices, Inc
> > > > +
> > > > +obj-$(CONFIG_PDS_VDPA) := pds_vdpa.o
> > > > +
> > > > +pds_vdpa-y := aux_drv.o
> > > > +
> > > > +pds_vdpa-$(CONFIG_DEBUG_FS) += debugfs.o
> > > > diff --git a/drivers/vdpa/pds/aux_drv.c b/drivers/vdpa/pds/aux_drv.c
> > > > new file mode 100644
> > > > index 000000000000..b3f36170253c
> > > > --- /dev/null
> > > > +++ b/drivers/vdpa/pds/aux_drv.c
> > > > @@ -0,0 +1,99 @@
> > > > +// SPDX-License-Identifier: GPL-2.0-only
> > > > +/* Copyright(c) 2023 Advanced Micro Devices, Inc */
> > > > +
> > > > +#include <linux/auxiliary_bus.h>
> > > > +
> > > > +#include <linux/pds/pds_core.h>
> > > 
> > > Perhaps I'm missing something obvious, but
> > > pds_core.h doesn't exist (yet).
> > 
> > The obvious thing that I was missing is that it is added by
> > 
> > * [PATCH RFC v4 net-next 00/13] pds_core driver
> 
> Sorry about that - I can try to make that dependency more obvious in the
> next round.

That might be a good idea.
But I am likewise sorry for jumping the gun with my email yesterday.
