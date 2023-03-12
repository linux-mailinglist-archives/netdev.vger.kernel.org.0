Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8E406B6714
	for <lists+netdev@lfdr.de>; Sun, 12 Mar 2023 15:06:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbjCLOGp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Mar 2023 10:06:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbjCLOGn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Mar 2023 10:06:43 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2124.outbound.protection.outlook.com [40.107.95.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62F523525A
        for <netdev@vger.kernel.org>; Sun, 12 Mar 2023 07:06:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DaWkb3UfO4NS50aP8eT8UPegfQPQefh6ePJnYb8nsXTWz9hir/+U8lTnpwuRtCIUjuCcm71N9szaIUhS6kaTEPWMgYIOakxjNQWXRybuT0pxHOo/hfRPAwW/WeF92rKpiifcj5y5fCmwCmoHY2cwAeCYQ3HuTvGIqqVsdo6TcaKJ1OcjG7mk+rz8SFwWXb9NpzF/ZTtmu+kOB3JLhOJn+52znuPDW6eaGul3cBSeFlvXMHk0HnRgiipwd4uGJrz4ZVIUQGCixPUssOUqqs7N/ugLjvayHFrgNxfIeUHtWywllvYM3/q6zZwrN99WL2fdkxqNPVWLAh0o+USO9dJ8HQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sW3GDTJNm6pJ2Ga3ilAi1VSluI9YiI1q0h0cx9lBE7U=;
 b=DrucBgQcapp7zbfxYSZqMuq+Tz+TYAYSzfjTHFl+0z/pBd3aU+kM3wXO0L5hE16mjnRreKlAmF8r+EyZ37G4x5oHW0zjCcz7z67VOf8sNG9QcPZNjE85B/Hk7jLEYqo7OOLNvbXXOYLzpq5wSjye9laGf7pernZUExLoBhrrojDWVNte+O64yFxQclJLIL95TyZ7SGtLNrfyry3ix71bccya83z69fL7+M84AEnqux9QCqr+9wA66HcUZYUuQP29fj80jEJzWCdFTOn+6AYN0HpNks5SuRLIYeUfUKQ5tok8gvJJ/F6z8/9IqyIyHegxpzT0BoeqEehAPEaPiGbOTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sW3GDTJNm6pJ2Ga3ilAi1VSluI9YiI1q0h0cx9lBE7U=;
 b=iSNLw/q/aSadWzbrCqXw9b9eTI/OVtXjM7D3YH0szIXkSYzWH03B0KNQqbvnp2LOlCBOCGkxwV849HYcR0q5BEwM5/Bug3der/FeB4gPl8lI2XJ4jxWKbLVFJPZUTydAs3wmjzlIJ4/0n0bPaLmRsM4AildDq4mB0eBc9nTK/qM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MN2PR13MB3990.namprd13.prod.outlook.com (2603:10b6:208:26d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.23; Sun, 12 Mar
 2023 14:06:39 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.024; Sun, 12 Mar 2023
 14:06:39 +0000
Date:   Sun, 12 Mar 2023 15:06:24 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Shannon Nelson <shannon.nelson@amd.com>
Cc:     jasowang@redhat.com, mst@redhat.com,
        virtualization@lists.linux-foundation.org, brett.creeley@amd.com,
        davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        drivers@pensando.io
Subject: Re: [PATCH RFC v2 virtio 1/7] pds_vdpa: Add new vDPA driver for
 AMD/Pensando DSC
Message-ID: <ZA3cYPoWQCjYoB3g@corigine.com>
References: <20230309013046.23523-1-shannon.nelson@amd.com>
 <20230309013046.23523-2-shannon.nelson@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230309013046.23523-2-shannon.nelson@amd.com>
X-ClientProxiedBy: AM0PR04CA0043.eurprd04.prod.outlook.com
 (2603:10a6:208:1::20) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MN2PR13MB3990:EE_
X-MS-Office365-Filtering-Correlation-Id: 5077c644-30d6-4803-b286-08db2302ff41
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2Yy7N1YyYT62GudPNPGvX7zUOcs+l4Iin/IDgmGd4DowY7L9zyJTuBzCLbjdYC2HGhn/BoVPHe4uVtB1Mz1ihihkTPeF1zVR/B9FrMlCB+/4tDBanxSfeCQuzltkLVZxhZsK4GcFE54j4n10522DmtrbosdV/JBAB0LaKRS5i+cNKXneksA1k0GTBDPPe1M0YC4MR8/3oF1QlO95KSSvUJDE7VSMzA3137LAc7n/e6iex2nsobaBTApvKN4pbRYj5lyCUXk/OZQLPpaY9Xi4nPVJZYWiMeHZ5dnzhqrxB9IzcYp+4HjOxpQft6irvnnH7oOPQgSjUfgqfBd5xMNQIvomtD0ZocNuzgaoenWDgvRYhBvyB6xZt9KBn5O9k01PmZCyjFm1xCWfGwLDcTlka04MDVOnDXfoDOvIE6z0CoDPH6BcQ55wiG+9FOkwdd5t76QhtgHQGjv5xBRXcfoQoUQ2IV9fEmqW4Ef7DO3cfsLbgrUAMP5tHfA4d3foKcsqcFcYCM4Ekd2kwiVGNKxk4rN3htGrd7jlpC5Wio6KRBu2OvranZSo12+ofVfWk4LSXYChjUCu1x7PQEk23iL/hf0k9nUprjaBEoIvS+AGr68eOQpdaXQSiVOXTyNNtli4tEUZbbnfBsGlQOr9tYkqHZ0JCwDmXxenkhdwA6R2hDGz8GU0uRtAu8xjq0AHlFDu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(376002)(346002)(39830400003)(366004)(136003)(451199018)(2906002)(83380400001)(5660300002)(36756003)(44832011)(66946007)(8676002)(66556008)(66476007)(41300700001)(8936002)(6916009)(4326008)(38100700002)(86362001)(186003)(316002)(478600001)(6666004)(2616005)(6506007)(6512007)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hRuBANb7eM+tZQnijs+GVHxMylNfABUq5WWHHBeoSBh8khcExTOC+WTxBQeC?=
 =?us-ascii?Q?dSRCKvyHXOUHd16DVHIdYOtIiJYbc5USv7fpjmAAvQelIeAm9h7I8a2ia2Eo?=
 =?us-ascii?Q?lPFhw9g5/Qy7YtY1qmUYzklut5FFtoDmsFH2+2VGiQU/KjBuE0aUrxMXvnMJ?=
 =?us-ascii?Q?+c8FzehJ9jbdxhK1NeMd4gp1fM9y/zQRe1wLvYS6uuWarLk0UfZB3SxmZi8Q?=
 =?us-ascii?Q?+GexLyyjIpAyJJNp2a0sQWBEkBhBjMhfpYvaaSa7bJJie7ONsE+wFJdFjMQK?=
 =?us-ascii?Q?PQkO5/hPMXYq8PbHqCYWFCZ3TLW8eGWfL1LISOEcQBQpq1axTjlukieN8eFk?=
 =?us-ascii?Q?29nc+l8Aylc3q2pXq5xMvncRA5klo+OW1hYttqeUl6EdgSAOdfoN1nlVYZY5?=
 =?us-ascii?Q?HvnXWqKz1SF0vKFhQgsZ54fN3zCLGiX11aG2dgenw2uwfUWioSWuvPxufpnx?=
 =?us-ascii?Q?dQubPK5fzaXAupvSJNnGUVyDXTAKTAQGkQvKWEvVB0do6aJB6JElaXKZbD0J?=
 =?us-ascii?Q?nyUDEtKE7UG0X2OlX1booIb7I9yPYxkK9YY4iMXZNDaFYJK+Rp7JmTEKKHcb?=
 =?us-ascii?Q?XX1AjYNinTc70WlRrxixyYgCHax4E5ytQ15jaVZHTcSdfp5mCcezuHlruOzP?=
 =?us-ascii?Q?ShedyGtuR3L+xbnRwyjtytuPihkn5c+BJX3HVY8Mhc7DY2wl5WNvWW1UTbDK?=
 =?us-ascii?Q?IoJAPOhLbpgPBCtISsx49ilk9FXeR0n7TmtsyrMzbHizzV4Ib7uEwgUDpEQl?=
 =?us-ascii?Q?Dl3anc8YoJ/lc2wIM/WW5l8VfyA/9NyBRcJmG+gXPMzcH5zBKCPghLNZdvOM?=
 =?us-ascii?Q?gIX2SUMycNAHjHun8KgIFIKduEImi/pvcVBB3A+pcsRA/KZKTCX//kg4sowQ?=
 =?us-ascii?Q?+2elF6N369NSjd7Xh+CBDBylQ0+5KFe/3+iAjLVAPwd396vxAUD9WY3aKw7h?=
 =?us-ascii?Q?fk0qYw2Vly61eUln1GvpIuk6YMsFBgTWrdDAQSdHs+PrxbyixGe84s9iitZe?=
 =?us-ascii?Q?wnDDvat0T6JdJvmRZ3kKQ7jDld2vp15KNFgIxijgV3XAGNkI3fcCesf94uoF?=
 =?us-ascii?Q?Haee0tsok2lFcRrVN1vfIVZG9URjPty6PaPLg/CfIDNYixPurhDGM0vAWtlB?=
 =?us-ascii?Q?lb7QPwXGTK2yz+67vqCN/eCb0MwTSxKblEJS+q472PolOrn+qxmnkA1zuh9u?=
 =?us-ascii?Q?hg+Dx68ZFrHsUudEZGy57xUuHjW8hMRQs4OuoygKdL7bdBvQt0zqrCBw0IAM?=
 =?us-ascii?Q?CDSnxGNsly622cWjlJI5ZnQA1/K0aaXQ3lF6/oXBD3Kmw4mJ75hC3XbYndNT?=
 =?us-ascii?Q?QZwgYAlGprxiLapYDTScYTBl21GYalyXQkTE6MOSf8KIBIZIUCZLieRWAL0W?=
 =?us-ascii?Q?Qq8uy8n8wciuqy27aaiO3twsRdMd9H/OtOgjPN70vfju9VpD/oG+EKl0n4wI?=
 =?us-ascii?Q?pkfPuF+vqdSrcISASfopfWImxObrVDz4ggowEJkcdbcJnpgfgZsyECHsmGN1?=
 =?us-ascii?Q?FRe2/+ZXZOrW+/8xnOwVh1WJdwuVveFWMcfVZ/fHLyAOufRLayWDFmFFbBDV?=
 =?us-ascii?Q?5TMfzidOZWntkewBGzwkwysqnwos6FsOqkX6uml6dHICOAha9DA/DW09U32g?=
 =?us-ascii?Q?gNWam2alSnSR3+eGJLDqxE4+E5SCDe9vNRBLyooXttrhKI3uepKeIyAzpC+i?=
 =?us-ascii?Q?d4jhMg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5077c644-30d6-4803-b286-08db2302ff41
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2023 14:06:38.9171
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yGpDqeEV4I1qHjw7D7mSToAx7qHJaRDL8YkXwirKBnfxs9VOtimWMUZ8Q1tnGJQI/Pitx2fHVHNGP06p1EC2i0ep8foPeiqdv4aHNRLCI9g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR13MB3990
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 08, 2023 at 05:30:40PM -0800, Shannon Nelson wrote:
> This is the initial auxiliary driver framework for a new vDPA
> device driver, an auxiliary_bus client of the pds_core driver.
> The pds_core driver supplies the PCI services for the VF device
> and for accessing the adminq in the PF device.
> 
> This patch adds the very basics of registering for the auxiliary
> device, setting up debugfs entries, and registering with devlink.
> 
> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>

...

> diff --git a/drivers/vdpa/pds/Makefile b/drivers/vdpa/pds/Makefile
> new file mode 100644
> index 000000000000..a9cd2f450ae1
> --- /dev/null
> +++ b/drivers/vdpa/pds/Makefile
> @@ -0,0 +1,8 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +# Copyright(c) 2023 Advanced Micro Devices, Inc
> +
> +obj-$(CONFIG_PDS_VDPA) := pds_vdpa.o
> +
> +pds_vdpa-y := aux_drv.o
> +
> +pds_vdpa-$(CONFIG_DEBUG_FS) += debugfs.o
> diff --git a/drivers/vdpa/pds/aux_drv.c b/drivers/vdpa/pds/aux_drv.c
> new file mode 100644
> index 000000000000..b3f36170253c
> --- /dev/null
> +++ b/drivers/vdpa/pds/aux_drv.c
> @@ -0,0 +1,99 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/* Copyright(c) 2023 Advanced Micro Devices, Inc */
> +
> +#include <linux/auxiliary_bus.h>
> +
> +#include <linux/pds/pds_core.h>

Perhaps I'm missing something obvious, but
pds_core.h doesn't exist (yet).

> +#include <linux/pds/pds_auxbus.h>
> +#include <linux/pds/pds_vdpa.h>

...

> diff --git a/drivers/vdpa/pds/debugfs.c b/drivers/vdpa/pds/debugfs.c
> new file mode 100644
> index 000000000000..3c163dc7b66f
> --- /dev/null
> +++ b/drivers/vdpa/pds/debugfs.c
> @@ -0,0 +1,25 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/* Copyright(c) 2023 Advanced Micro Devices, Inc */
> +
> +#include <linux/pds/pds_core.h>
> +#include <linux/pds/pds_auxbus.h>
> +
> +#include "aux_drv.h"
> +#include "debugfs.h"
> +
> +#ifdef CONFIG_DEBUG_FS

Again, perhaps I'm missing something obvious, but
compilation of this file is guarded by CONFIG_DEBUG_FS (in ./Makefile).
So I don't think this guard is needed here.

> +
> +static struct dentry *dbfs_dir;
> +
> +void pds_vdpa_debugfs_create(void)
> +{
> +	dbfs_dir = debugfs_create_dir(PDS_VDPA_DRV_NAME, NULL);
> +}
> +
> +void pds_vdpa_debugfs_destroy(void)
> +{
> +	debugfs_remove_recursive(dbfs_dir);
> +	dbfs_dir = NULL;
> +}
> +
> +#endif /* CONFIG_DEBUG_FS */
