Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D66506CD953
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 14:25:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbjC2MY7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 08:24:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbjC2MY6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 08:24:58 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2071d.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe59::71d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCD1F422C;
        Wed, 29 Mar 2023 05:24:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iNpqAhIrmiSLyPpojr86J7jjyPGWPNY4s7AVEUOKgcehEG9Bb+SS/DJvneSyxE57BS37ANJO3WJdZH1+95uyeBrrFZOzUvK3pJ/pop7rYE7vzZASQUI71UU99UbcRx7pjNKy9Yd9+SxupNuA6mee0neQ0r/2l8pZ+e4qzyIvTwg8khONh96UkKVMYGZZHrwfPNoFaE7m9QhrX652F6AAzusBGsTq0yGw6l2HnmoizWPiefakXUylM6uz7kx6o9LuTH2tnU5PlfvU5yXfgouW7vWASljM8ab+zf1it5hJ1FB1kVHIHH/A7Ek4G0kZbiOTTo8TbZgzKEp/4Q8oO1EwCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7C51BFibW7xGNvUn1xhFcayLailsapHSAJ7ZyF86ezU=;
 b=oTy15OzUdyZKDTN4FnYUfMWTN2BMosbDDH+xwuClScOLE9W2valvwMjFGuSObQ4S9KopbQZ/hdUruVBzegLScQSCwRPIwFEC0jjUpGvDEEx80jwW8W8IQcTDRa8j5GxLVdpPHW1kvhDlAbE5CyWlfkORBog0ZUPl6UddqNRGQQ4iDB+uMFna8B3RBDI2m4fQOMoxksuEYQiBtXT8maB/A7XJ7HZJofY3DHL55xRM77EunSO7/ld1RIa94ZnztEZ83WRXFSTS9hPNWSgEhq4eRZn4MOfhNH8OiWsXeAcRq7fMPujQ8nrQY2umoVOcAHDlrV37aqa2HoKTA9yJfbqzww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7C51BFibW7xGNvUn1xhFcayLailsapHSAJ7ZyF86ezU=;
 b=eTCHDpo/pwHp5dJYsiOvCKErpaaKjjFnsPWUrqSzv7gVoH6FBiBWujKY6FzNrJ6EocHVkXxZzUYUOKeZXHFddl4hVXg+cYXCTbyF1Yjug7o+Cbv9YpGhqi4jd++QOHJVOq9rinJOxazbh7nFkbBrpaWYtwv9ybPvCRZtPMFb2dw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB4100.namprd13.prod.outlook.com (2603:10b6:5:2af::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.33; Wed, 29 Mar
 2023 12:24:47 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%4]) with mapi id 15.20.6222.028; Wed, 29 Mar 2023
 12:24:47 +0000
Date:   Wed, 29 Mar 2023 14:24:40 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Brett Creeley <brett.creeley@amd.com>
Cc:     kvm@vger.kernel.org, netdev@vger.kernel.org,
        alex.williamson@redhat.com, jgg@nvidia.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        shannon.nelson@amd.com, drivers@pensando.io
Subject: Re: [PATCH v6 vfio 4/7] vfio/pds: Add VFIO live migration support
Message-ID: <ZCQuCPG864f0R+9s@corigine.com>
References: <20230327200553.13951-1-brett.creeley@amd.com>
 <20230327200553.13951-5-brett.creeley@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230327200553.13951-5-brett.creeley@amd.com>
X-ClientProxiedBy: AS4P190CA0017.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d0::7) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM6PR13MB4100:EE_
X-MS-Office365-Filtering-Correlation-Id: b2e31856-0247-404c-e25f-08db305095cc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XEXKZCRsVGSwAzxRIJDhzKjXjvuYwGpZcuJwJKbSZvBJbJtjoevghT+pFEAkMbOTMlgwfG3po40W6kJ6pFk610DPYfDarLBrOyLjqJUTWZdoEwr5L3N6ddhuKt4aT6Bi6kcN27W8R87N5ofKAoA2J6mhQGTBM5Bb7SB176XnygevI/Iy7Pcg0N9mA7FqFm3NBwgN7hsvyqX5FV36PxtqCGAD8D0LxFjkacRmcMfrPJ4J66QWP7HKYG0yg4lTH+a+x0fBV567Cr7wnh67hJBGNl2CYAbEz7FCl7emV3+po2BL+3De3xP19LeFtc4IcABp6v+7STQf3+2veUS0LoeJQRi+cobYnl6UPvNpE40ePCxB19CYKKCZEANNRG+cPqegCzUbNKuTGPpfgPuMKBFUfVUpGEfh4lbU0Hu7Fv3fv6aIAMrBVqq9ceQcKKAPN66Tl5IhokcUTmvI8VhT5uyUk4xB8iXsxkjI3i3XIgPIqIVhzfauDaiKG6uCv4nD7zuXUJi/NFKdCCcF9wBnyqv3kvhnnKSdKInvTB0ZzrYu5tpfQ7wPKjTdnF8oIEXWfVtFHvx3mzseIWbSMLRvmovOQL73mXh5L93CXx2gGSC8NVOGrwkmR4yPHhWBko/BlVRX6b0l2gE73Bqxmh865wVtHQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(376002)(136003)(396003)(39840400004)(346002)(451199021)(2906002)(44832011)(38100700002)(41300700001)(8936002)(4326008)(7416002)(5660300002)(86362001)(36756003)(66476007)(6916009)(478600001)(316002)(6666004)(6486002)(6512007)(6506007)(66556008)(2616005)(66946007)(8676002)(186003)(83380400001)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QNDoi6qvwuimUBUSSZC/2u0Uxt0+rLNI5elnR+OEBe0DFsboymPi5RW4IQOq?=
 =?us-ascii?Q?G4eVqqaAO5W52sjDAQe1g/iNxLyYoGiQv3vZ9phCHneNiRlGNGzXveKx5j99?=
 =?us-ascii?Q?rlTVflEGxjelcUSBEpneimFSz3dKnC3oM518w8s/f1e9+FdLtvSjS/T8VpP/?=
 =?us-ascii?Q?PQOtP0gLjySF344hZK3CjBQcPOxvrMrWVYbG0vKJ7fccOL1o3/LXmCx7kN1G?=
 =?us-ascii?Q?G/zlvFTQGWdi1VDugTPGIlbr4rVVIPQk8LFLQH/pXvpAh8YqIQsWj48sHItY?=
 =?us-ascii?Q?BMfQyWIx4qxpEhvlzW2vP5DAF0pO2XDPG11QBfSdQvPAuIylqMNJ2nys5Ocr?=
 =?us-ascii?Q?pxlTv6StFPc3s+xnkEObl8E939g0zQAdOM9Zxm+BXIlCwbDFHuijOin12ApS?=
 =?us-ascii?Q?oGydAAvIZzkWg7OmTyNxcH9NI9Cy4PvaUGLdtaN2WO3XcVmawlIt6L2uCFsT?=
 =?us-ascii?Q?cSIWd6mDiVrTkyGJdYLciaWt7TlcwC45ntmQquh4gqYSGg8kBuSeiYhwiynq?=
 =?us-ascii?Q?kyYx5GpWvppcR/zpTuEI1U2URtP6waiqmyFJFA+Q9dOqgn+pC9TGasRsOfkb?=
 =?us-ascii?Q?qYudx2FxeaANVJEOa9i1F4xU6yUnH1mPdk2S+Lyn22UKoB30D7g86P5tPzI3?=
 =?us-ascii?Q?5yE+9IatZm5wSZu20S81yqgcq2tZQu3v7uyoXBNgo9zirgcxX2wfd0AH4n9D?=
 =?us-ascii?Q?YczHxMnnmKtY3HAYui0BFuuqEb7zOpyN8lCmF+JioWePNHuJHDDGfjE3QRMA?=
 =?us-ascii?Q?vgOYo6SaBfs6vEGirRcpgQqNPHjpRls9P3ZrX0fkwSbA+zx8+FDTU0wmoQVD?=
 =?us-ascii?Q?N0bMr3Ix/DOK+zShsW5qWYpIoM8Drdet9Am8j8Us01sxMcbjPdHSaW35bfgp?=
 =?us-ascii?Q?WWttnm8re5wAV2ARI2TyathJAeZ6yRQ7YYFv9k/tvFNNSM/WfyJs0YtRzbzG?=
 =?us-ascii?Q?N4Pwr7K91dgi+OiYFYHsfP8wLGIc7XyZ/oelbq8D8EIYKp6gSiW+S1RhLCmq?=
 =?us-ascii?Q?E8W0nS/JW3YeMqgZvXENrWF0BXkiJyw4Ue90QvaNeVkxasA5J/q/rBiY4mPV?=
 =?us-ascii?Q?thX7aMuO1j+u0WD+1goTDRGz9qKKEzXio143CSH92hdEovEJQPhyXlpjOwFo?=
 =?us-ascii?Q?+3YskCIjminX/xMDqE41myCtio6AsFqTNSOtZABQ05uF6z3eWTxvj0vnWOH+?=
 =?us-ascii?Q?t5DDkLj035PoSh7dNimtC0fioNSMUbC5DVYgggAFAo9fiqU7seeVxUvC0L96?=
 =?us-ascii?Q?T6f8XGB4VuHyyKie4aGmViy9jT5fk6EQe+n9jbQc5YEABwVGwM9JZSXzmt/d?=
 =?us-ascii?Q?iCYAyHVoN3C50K99riVnIB18/4CGT8wOE7G8++TNC/qhDWAEEQJ2DdeCbs7G?=
 =?us-ascii?Q?ogp74iTq4U32GVRjdKKbc8VMJUFBs/6nz/cen8cNHfznLHFBJy1NIr5Gtn8D?=
 =?us-ascii?Q?tN2grFZoRdfD5uPUEXTZZZGoBV/eoZPNkCzQlWLs6EZcfQZ4ybcYN5rEXIUs?=
 =?us-ascii?Q?rUAB28fkuysL+GBiwoxSsopB5W5Sqrehu1MNJP0snFXJ8RqzBliRpTEtf+gT?=
 =?us-ascii?Q?RjrKwOtue7WOEoYQ4eeRc6u1ueDljtwP0+Nl6JLlc16YJrPRghM5czfIcpyO?=
 =?us-ascii?Q?V83xzbO8LWXrcrWFHTDerw/UvESW1mK3z5JcVIPFRmEgbB9EYm/YQQs+jpS2?=
 =?us-ascii?Q?5cfYkQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2e31856-0247-404c-e25f-08db305095cc
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2023 12:24:47.3676
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vUGinNuoDrI+fzLXVntpKv7hMv8pPCdKKvnaYr/h3NrBwqPT3bMMLjV3EdkAcVpZz9j72/JuZ3Ali1ipEnpV7cHmWkUKkzmkjYuBNBDaQQw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB4100
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 27, 2023 at 01:05:50PM -0700, Brett Creeley wrote:
> Add live migration support via the VFIO subsystem. The migration
> implementation aligns with the definition from uapi/vfio.h and uses
> the pds_core PF's adminq for device configuration.
> 
> The ability to suspend, resume, and transfer VF device state data is
> included along with the required admin queue command structures and
> implementations.
> 
> PDS_LM_CMD_SUSPEND and PDS_LM_CMD_SUSPEND_STATUS are added to support
> the VF device suspend operation.
> 
> PDS_LM_CMD_RESUME is added to support the VF device resume operation.
> 
> PDS_LM_CMD_STATUS is added to determine the exact size of the VF
> device state data.
> 
> PDS_LM_CMD_SAVE is added to get the VF device state data.
> 
> PDS_LM_CMD_RESTORE is added to restore the VF device with the
> previously saved data from PDS_LM_CMD_SAVE.
> 
> PDS_LM_CMD_HOST_VF_STATUS is added to notify the device when
> a migration is in/not-in progress from the host's perspective.
> 
> Signed-off-by: Brett Creeley <brett.creeley@amd.com>
> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>

Thanks Brett,

overall this looks clean to me.
I've provided some minor points inline which you may wish
to consider if you need to respin the series for some reason.

...

> diff --git a/drivers/vfio/pci/pds/cmds.c b/drivers/vfio/pci/pds/cmds.c

...

> +int
> +pds_vfio_get_lm_status_cmd(struct pds_vfio_pci_device *pds_vfio, u64 *size)
> +{
> +	struct pds_lm_status_cmd cmd = {
> +		.opcode = PDS_LM_CMD_STATUS,
> +		.vf_id = cpu_to_le16(pds_vfio->vf_id),
> +	};
> +	struct pds_lm_status_comp comp = {0};
> +	int err = 0;

nit: there is no need to initialise err here,
     as it is set below before it is used.

> +
> +	dev_dbg(&pds_vfio->pdev->dev, "vf%u: Get migration status\n",
> +		pds_vfio->vf_id);
> +
> +	err = pds_client_adminq_cmd(pds_vfio,
> +				    (union pds_core_adminq_cmd *)&cmd,
> +				    sizeof(cmd),
> +				    (union pds_core_adminq_comp *)&comp,
> +				    0);
> +	if (err)
> +		return err;
> +
> +	*size = le64_to_cpu(comp.size);
> +	return 0;
> +}
> +
> +static int
> +pds_vfio_dma_map_lm_file(struct device *dev, enum dma_data_direction dir,
> +			 struct pds_vfio_lm_file *lm_file)
> +{
> +	struct pds_lm_sg_elem *sgl, *sge;
> +	struct scatterlist *sg;
> +	int err = 0;

Ditto.

> +	int i;
> +
> +	if (!lm_file)
> +		return -EINVAL;
> +
> +	/* dma map file pages */
> +	err = dma_map_sgtable(dev, &lm_file->sg_table, dir, 0);
> +	if (err)
> +		goto err_dma_map_sg;

nit: 'return err;' might be simpler.

> +
> +	lm_file->num_sge = lm_file->sg_table.nents;
> +
> +	/* alloc sgl */
> +	sgl = dma_alloc_coherent(dev, lm_file->num_sge *
> +				 sizeof(struct pds_lm_sg_elem),
> +				 &lm_file->sgl_addr, GFP_KERNEL);
> +	if (!sgl) {
> +		err = -ENOMEM;
> +		goto err_alloc_sgl;
> +	}
> +
> +	lm_file->sgl = sgl;
> +
> +	/* fill sgl */
> +	sge = sgl;
> +	for_each_sgtable_dma_sg(&lm_file->sg_table, sg, i) {
> +		sge->addr = cpu_to_le64(sg_dma_address(sg));
> +		sge->len  = cpu_to_le32(sg_dma_len(sg));
> +		dev_dbg(dev, "addr = %llx, len = %u\n", sge->addr, sge->len);
> +		sge++;
> +	}
> +
> +	return 0;
> +
> +err_alloc_sgl:
> +	dma_unmap_sgtable(dev, &lm_file->sg_table, dir, 0);
> +err_dma_map_sg:
> +	return err;
> +}

...

> diff --git a/drivers/vfio/pci/pds/lm.c b/drivers/vfio/pci/pds/lm.c

...

> +static int
> +pds_vfio_get_save_file(struct pds_vfio_pci_device *pds_vfio)
> +{
> +	struct pci_dev *pdev = pds_vfio->pdev;
> +	struct pds_vfio_lm_file *lm_file;
> +	int err = 0;
> +	u64 size;
> +
> +	/* Get live migration state size in this state */
> +	err = pds_vfio_get_lm_status_cmd(pds_vfio, &size);
> +	if (err) {
> +		dev_err(&pdev->dev, "failed to get save status: %pe\n",
> +			ERR_PTR(err));
> +		goto err_get_lm_status;
> +	}
> +
> +	dev_dbg(&pdev->dev, "save status, size = %lld\n", size);
> +
> +	if (!size) {
> +		err = -EIO;
> +		dev_err(&pdev->dev, "invalid state size\n");
> +		goto err_get_lm_status;
> +	}
> +
> +	lm_file = pds_vfio_get_lm_file(PDS_VFIO_LM_FILENAME,
> +				       &pds_vfio_save_fops,
> +				       O_RDONLY, size);
> +	if (!lm_file) {
> +		err = -ENOENT;
> +		dev_err(&pdev->dev, "failed to create save file\n");
> +		goto err_get_lm_file;
> +	}
> +
> +	dev_dbg(&pdev->dev, "size = %lld, alloc_size = %lld, npages = %lld\n",
> +		lm_file->size, lm_file->alloc_size, lm_file->npages);
> +
> +	pds_vfio->save_file = lm_file;
> +
> +	return 0;
> +
> +err_get_lm_file:
> +err_get_lm_status:

nit: I don't think these labels are giving us much.
     If it was me I'd just use return rather than goto above.

> +	return err;
> +}

...
