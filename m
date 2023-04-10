Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0107C6DC8B6
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 17:44:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230041AbjDJPol (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 11:44:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229982AbjDJPok (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 11:44:40 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on20702.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eaa::702])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23A8B5BAB
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 08:44:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dhRZNOZzNUDX1EoZy7ThaP6HbdpmHFE0snPKGavsuGfPpxMd4g39toVrCtu7CIjv7rGJPDW1Sy/k+ftDLYLQF1NfYTyYOdttRyuXs9S7p8cGFYC2Y7R3Q3BgirWQYpkK27Ia7T2PDDQuoDaHwJ5Pba7oCdsCuVCc/MwD+qIkfkk4CHnRBLBHSETUEA1lAALU3os6hHbWiccWzas4kAQZs39hkv3nfZSu9tyrVvV2Z52kixCscfFdBzqVMZL4lKwcYuUqh0/zvAI3YgFavyTxQoeN+weLWb9WlgRpFVFQ9dzgZQIujylgBzwNIhwNtch1nKCrGPvBRSNAo5YMopjqdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cQGD0Rh5SJ9/lZ7dRASiEcxkNb6ZYN9okf5Ho7Vt1uQ=;
 b=QKYpd5g03ObTPSzXn2u/70rcdFIDBdckpUs9GvHnWHh7BuYSy3UV0vOS/4RUMpUBE233W5MVp6dePuBy/8RNM+ptUP+Aw5qEMEhAM4qI1BNd6mFxP0/Ha1TRS8fCYDyt5UbcDn3awLa32x68OPx9618++WYI8hcmjiwQN7CJnHrVEpCjiVGlukx01sst/1c4IFrO1kFDrX8tODotM/TA2GmqVz+BNym7fMGU80iPDDofmxfk3ImHiTk6+cJuq3dYbytqA38yROa7FXvyE8shP2EB2di6vFjsLR0v8OqncGtFumG/HylOlLQ1tq2/2oaYWri5PRyTZBQOAN+Zc2S0Sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cQGD0Rh5SJ9/lZ7dRASiEcxkNb6ZYN9okf5Ho7Vt1uQ=;
 b=Mt6F2wSZyg748WqC0/jdxnWzukx0RcKVgbOPteNZQO4cx//myEVRr4FymW6y5f4fv9cFWMhxY8m1ztkv4CH6JMYYKBkTlo5vDXHRfFgw65Dih9ypOdpVh9c02xXGyFjbp6DCzg//R0gk22muUt09yaIFIe9d+C6mgjrrSzCP25I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ0PR13MB6151.namprd13.prod.outlook.com (2603:10b6:a03:4e8::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Mon, 10 Apr
 2023 15:44:11 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169%5]) with mapi id 15.20.6277.038; Mon, 10 Apr 2023
 15:44:11 +0000
Date:   Mon, 10 Apr 2023 17:44:04 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Shannon Nelson <shannon.nelson@amd.com>
Cc:     brett.creeley@amd.com, davem@davemloft.net, netdev@vger.kernel.org,
        kuba@kernel.org, drivers@pensando.io, leon@kernel.org,
        jiri@resnulli.us
Subject: Re: [PATCH v9 net-next 07/14] pds_core: add FW update feature to
 devlink
Message-ID: <ZDQuxBlfH5foSEFA@corigine.com>
References: <20230406234143.11318-1-shannon.nelson@amd.com>
 <20230406234143.11318-8-shannon.nelson@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230406234143.11318-8-shannon.nelson@amd.com>
X-ClientProxiedBy: AS4P190CA0031.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d1::6) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SJ0PR13MB6151:EE_
X-MS-Office365-Filtering-Correlation-Id: 7ddc69a4-2496-42ca-3101-08db39da6d90
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nAN2gkQRqNunZsoHFS7Z3qCFPHmExfSS0wAn1w989qjxPCmLSNBeyqelWo9Vj42y5D+tNYCt4ZTgrJAZMWX4YwEw3tJ3PVgTujv801bPL0WqA0yx7NZ2zrowcv+8RLmEessigh6+52kg1hq43jdbaKUh0FzDy9IufZyJHvg3GP394RtgDgx6yN+1sEpTNhfO45S576FRr4FZCIZ8GGceXglNqTYgujv0GZgLJsBFx4VqGvWtJ5NjK4cSDXtU4ZVwV3GKtBv0qea4MSE/eyOwy8S542IFKfrt+aDNGs33g1+Rw/BVg1m2UCNGTv/P1yB5iqM7eiXplFT0Nj+NLUWZDP75UCmVJv8qtRekrs6lqAAIEzTJAZPtCF2fqv9/n5uDGhDkHH4uxzBrANgfOqISmyD5xyea8bmx7ZVtvJY77D1gaklG65HoPuNOv4DQX1Z4C3FS/91lGxDrgzfG7XMDBVK2InELPjX2NnmCKZ4I0MPFLYokM25n8fTFLJY52/hSE0ukRYJwg1byvFnjzBx/Hq89PhCWccBnC++CfHtXVe5fwBAjswIBNkv1maV6ZrJaiFoEkcTIBJJKGKmu0ZSlUcI53Wb97CDYHa7K7YnNKj8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(136003)(396003)(366004)(346002)(376002)(451199021)(66556008)(6486002)(8676002)(66946007)(41300700001)(316002)(6916009)(66476007)(15650500001)(478600001)(36756003)(6506007)(86362001)(4326008)(38100700002)(83380400001)(6512007)(2616005)(186003)(2906002)(6666004)(44832011)(8936002)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dbVoUS94HxXR65MW9GpE51X7EcZpiEsecbUBht3LXMibzMMmdff3oxb4BdtZ?=
 =?us-ascii?Q?ocWUSOkW1nrh750/+H8tsY5gR7RqmgZMOSXqKK5cKIbYPc3iQDnvKMcsqgAs?=
 =?us-ascii?Q?59h1KGs+P12hsqWUlwENDGvwYQRRR3SBhdA1ny7Y3AvZQExYv5cIvcndHFP2?=
 =?us-ascii?Q?L17aHzlSS4g2VfFLt9MklBcQb5N3igSX1SAj96jxfTw0Q1hDGq4DSLwTTRb7?=
 =?us-ascii?Q?wZLTUlYFhrXvOmPWexdenzeA9e0J3CO55L7t/pngjTKgjbW27gmnOVy8Y+r5?=
 =?us-ascii?Q?KHRofZGUi37c9PWLYW0aF09fYdfaTuIYp6/wFkb1OVHml3YcUKJz0s89psh8?=
 =?us-ascii?Q?krah3Njm9oLkBfZYtc9d5awVhtPuZj/kR7CoODx3npog6dObyifHCIQmGCXQ?=
 =?us-ascii?Q?hpTL0eoXaeRxfFLhw/lrBT0zqsQs2evpEJ9Jx76INvKhC1Vfbk+BwYdDxCT6?=
 =?us-ascii?Q?b8AsqLDbHT1EEdpJOA99Z/sH6hy6j2yLqB2DmGGz0y+NK1nCkWxS1v5VFv3a?=
 =?us-ascii?Q?tsrqIAgY35CGBlCuFSPH0VfsO6LoVmViRQD00VoQxz6MRjRvuZrpNz0omkww?=
 =?us-ascii?Q?OZTNvBSzuNFgax9vWJEeuSLEmcZAwPgOVPGbpf0/2i+YkkBLAkv45GwewW2m?=
 =?us-ascii?Q?RC0sPwO5WToas+OGE1VSM1tmnkWIENiRn+Hz+FK1TFWqXZ/dAQv6beQNi/jf?=
 =?us-ascii?Q?RwzICTld5fjsXsd0VKYzXQk/TBnQ+aznjg8dw8Xbm4Exdr2Sks88b1Aju4sE?=
 =?us-ascii?Q?oW5Z8/plmMK9JQLo4cQUdp8VfygPrU5IzUE3KZyrcwAMVq4fKYrHEjieEo/h?=
 =?us-ascii?Q?RfOth1XJ035uMEtwn+PuNYIR9iI23ZcX9jGufsVnfLpx3WSwi7ZZeVV1+m33?=
 =?us-ascii?Q?7w7306lhtZ6s2fHRz/Hnau22cBIczihwqHwpRcYA6I8AW57KOQa8XsFcTuFo?=
 =?us-ascii?Q?CU5uukMsmI5w6Q4QaJyH8L7vZz1WdhDUf+ta72eeRZSmEXqkPrD3R2xaUnjy?=
 =?us-ascii?Q?fUjWEQ9QxziS5Hz1nlcKSiUbX4DQw1EXlWl7VuMaHgcb8IJytWLrHQqgfsne?=
 =?us-ascii?Q?uZMUhsPo5IF+fbh3lHnyjmiz/dZZz5dWcJAUjrvMiO/t+UiySn77z3LV6bv4?=
 =?us-ascii?Q?d9LszcCgsI/SvtI29sOJLgTLHYiwS6SBFcP91PPLNw/FKwTwSjWkLXsWTlsU?=
 =?us-ascii?Q?byuA4vW7L2K9qo0nBUU0UBxRWMmL1oyXjRijz4Zee0TyYaYHqZGjZ/zTujz5?=
 =?us-ascii?Q?w7oD0/9WrgldTu/+HPjYLpHW+EuD4DhR4DO+Aa0BLCQ5fx7kpSMBBE08JJwP?=
 =?us-ascii?Q?JjOnLSjJDN1D2vD/QumJfBy23e+EBVFTylHjxa39KPUVtc3ZqUnBIZxfm3WU?=
 =?us-ascii?Q?rcG+n+oKeeZINnxDXq1zDJUx1JNaf7GIP6c1/Bk1OIjGB+uhQynnrOJi6lLO?=
 =?us-ascii?Q?hiNv0AfpoRQ+2lcPb4k4Hu2DmRGwnRCVSDarXuzIhlvwPM3R2/DC8ypmJ0T9?=
 =?us-ascii?Q?+YWYdwn7Ht8D9zwMqYT7ReBFCRdMuv1njCk5tRy2PbkZKMhvRDxU+s29kR5l?=
 =?us-ascii?Q?DIlZVkB5spyFm59svrVwpNEM6ne1reZYaLS5oTFBsfABHQCc5TDIozx3EZz6?=
 =?us-ascii?Q?l1+jFVSzTw2bFvb1kQF+IseoMB4XtJqtkWvg3/gi1FtGQZkoHa0WSywdKZCU?=
 =?us-ascii?Q?y+6leA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ddc69a4-2496-42ca-3101-08db39da6d90
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2023 15:44:10.9524
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3fh/8rKE/BBDD3BanMSRYBPHorHmantoDp/g+mbj9AoO23Urj9QmVm+FDvkWiiFI/Qs25ORABz7+UjvhCQC9ueRE99jV6sV3cMGxsKwTR/U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR13MB6151
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 06, 2023 at 04:41:36PM -0700, Shannon Nelson wrote:
> Add in the support for doing firmware updates.  Of the two
> main banks available, a and b, this updates the one not in
> use and then selects it for the next boot.
> 
> Example:
>     devlink dev flash pci/0000:b2:00.0 \
> 	    file pensando/dsc_fw_1.63.0-22.tar
> 
> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>

Hi Shannon,

some minor feedback from my side.

...

> diff --git a/Documentation/networking/device_drivers/ethernet/amd/pds_core.rst b/Documentation/networking/device_drivers/ethernet/amd/pds_core.rst
> index 265d948a8c02..6faf46390f5f 100644
> --- a/Documentation/networking/device_drivers/ethernet/amd/pds_core.rst
> +++ b/Documentation/networking/device_drivers/ethernet/amd/pds_core.rst
> @@ -73,6 +73,16 @@ The ``pds_core`` driver reports the following versions
>       - fixed
>       - The revision of the ASIC for this device
>  
> +Firmware Management
> +===================
> +
> +The ``flash`` command can update a the DSC firmware.  The downloaded firmware
> +will be saved into either of firmware bank 1 or bank 2, whichever is not
> +currrently in use, and that bank will used for the next boot::

nit: s/currrently/currently/

...

> diff --git a/drivers/net/ethernet/amd/pds_core/fw.c b/drivers/net/ethernet/amd/pds_core/fw.c

...

> +int pdsc_firmware_update(struct pdsc *pdsc, const struct firmware *fw,
> +			 struct netlink_ext_ack *extack)
> +{
> +	u32 buf_sz, copy_sz, offset;
> +	struct devlink *dl;
> +	int next_interval;
> +	u64 data_addr;
> +	int err = 0;
> +	u8 fw_slot;
> +
> +	dev_info(pdsc->dev, "Installing firmware\n");
> +
> +	dl = priv_to_devlink(pdsc);
> +	devlink_flash_update_status_notify(dl, "Preparing to flash",
> +					   NULL, 0, 0);
> +
> +	buf_sz = sizeof(pdsc->cmd_regs->data);
> +
> +	dev_dbg(pdsc->dev,
> +		"downloading firmware - size %d part_sz %d nparts %lu\n",
> +		(int)fw->size, buf_sz, DIV_ROUND_UP(fw->size, buf_sz));
> +
> +	offset = 0;
> +	next_interval = 0;
> +	data_addr = offsetof(struct pds_core_dev_cmd_regs, data);
> +	while (offset < fw->size) {
> +		if (offset >= next_interval) {
> +			devlink_flash_update_status_notify(dl, "Downloading",
> +							   NULL, offset,
> +							   fw->size);
> +			next_interval = offset +
> +					(fw->size / PDSC_FW_INTERVAL_FRACTION);
> +		}
> +
> +		copy_sz = min_t(unsigned int, buf_sz, fw->size - offset);
> +		mutex_lock(&pdsc->devcmd_lock);
> +		memcpy_toio(&pdsc->cmd_regs->data, fw->data + offset, copy_sz);
> +		err = pdsc_devcmd_fw_download_locked(pdsc, data_addr,
> +						     offset, copy_sz);
> +		mutex_unlock(&pdsc->devcmd_lock);
> +		if (err) {
> +			dev_err(pdsc->dev,
> +				"download failed offset 0x%x addr 0x%llx len 0x%x: %pe\n",
> +				offset, data_addr, copy_sz, ERR_PTR(err));
> +			NL_SET_ERR_MSG_MOD(extack, "Segment download failed");
> +			goto err_out;
> +		}
> +		offset += copy_sz;
> +	}
> +	devlink_flash_update_status_notify(dl, "Downloading", NULL,
> +					   fw->size, fw->size);
> +
> +	devlink_flash_update_timeout_notify(dl, "Installing", NULL,
> +					    PDSC_FW_INSTALL_TIMEOUT);
> +
> +	fw_slot = pdsc_devcmd_fw_install(pdsc);
> +	if (fw_slot < 0) {

The type of fs_slot is u8.
But the return type of pdsc_devcmd_fw_install is int,
(I think) it can return negative error values,
and that case is checked on the line above.

Perhaps the type of fw_slot should be int?

Flagged by Coccinelle as:

drivers/net/ethernet/amd/pds_core/fw.c:154:5-12: WARNING: Unsigned expression compared with zero: fw_slot < 0

And Smatch as:

drivers/net/ethernet/amd/pds_core/fw.c:154 pdsc_firmware_update() warn: impossible condition '(fw_slot < 0) => (0-255 < 0)'

> +		err = fw_slot;
> +		dev_err(pdsc->dev, "install failed: %pe\n", ERR_PTR(err));
> +		NL_SET_ERR_MSG_MOD(extack, "Failed to start firmware install");
> +		goto err_out;
> +	}

...
