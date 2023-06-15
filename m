Return-Path: <netdev+bounces-11234-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CC15D732154
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 23:07:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 974141C20EED
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 21:07:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53AF914271;
	Thu, 15 Jun 2023 21:07:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 377B52E0D4
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 21:07:49 +0000 (UTC)
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 864A1184;
	Thu, 15 Jun 2023 14:07:45 -0700 (PDT)
Received: from lhrpeml100001.china.huawei.com (unknown [172.18.147.201])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4QhvxF1C3qz6J7St;
	Fri, 16 Jun 2023 05:06:57 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 lhrpeml100001.china.huawei.com (7.191.160.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 15 Jun 2023 22:07:43 +0100
Received: from lhrpeml500005.china.huawei.com ([7.191.163.240]) by
 lhrpeml500005.china.huawei.com ([7.191.163.240]) with mapi id 15.01.2507.023;
 Thu, 15 Jun 2023 22:07:43 +0100
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: Brett Creeley <brett.creeley@amd.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>, "jgg@nvidia.com"
	<jgg@nvidia.com>, "yishaih@nvidia.com" <yishaih@nvidia.com>,
	"kevin.tian@intel.com" <kevin.tian@intel.com>
CC: "shannon.nelson@amd.com" <shannon.nelson@amd.com>
Subject: RE: [PATCH v10 vfio 4/7] vfio/pds: Add VFIO live migration support
Thread-Topic: [PATCH v10 vfio 4/7] vfio/pds: Add VFIO live migration support
Thread-Index: AQHZlZ4fw+ycc9Ly8kiUgFWK9kvRUa+MZeFw
Date: Thu, 15 Jun 2023 21:07:43 +0000
Message-ID: <e2ed042a061a4de3827f60e1bd695cfc@huawei.com>
References: <20230602220318.15323-1-brett.creeley@amd.com>
 <20230602220318.15323-5-brett.creeley@amd.com>
In-Reply-To: <20230602220318.15323-5-brett.creeley@amd.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.126.169.47]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



> -----Original Message-----
> From: Brett Creeley [mailto:brett.creeley@amd.com]
> Sent: 02 June 2023 23:03
> To: kvm@vger.kernel.org; netdev@vger.kernel.org;
> alex.williamson@redhat.com; jgg@nvidia.com; yishaih@nvidia.com;
> Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>;
> kevin.tian@intel.com
> Cc: brett.creeley@amd.com; shannon.nelson@amd.com
> Subject: [PATCH v10 vfio 4/7] vfio/pds: Add VFIO live migration support
>=20
> Add live migration support via the VFIO subsystem. The migration
> implementation aligns with the definition from uapi/vfio.h and uses
> the pds_core PF's adminq for device configuration.
>=20
> The ability to suspend, resume, and transfer VF device state data is
> included along with the required admin queue command structures and
> implementations.
>=20
> PDS_LM_CMD_SUSPEND and PDS_LM_CMD_SUSPEND_STATUS are added to
> support
> the VF device suspend operation.
>=20
> PDS_LM_CMD_RESUME is added to support the VF device resume operation.
>=20
> PDS_LM_CMD_STATUS is added to determine the exact size of the VF
> device state data.
>=20
> PDS_LM_CMD_SAVE is added to get the VF device state data.
>=20
> PDS_LM_CMD_RESTORE is added to restore the VF device with the
> previously saved data from PDS_LM_CMD_SAVE.
>=20
> PDS_LM_CMD_HOST_VF_STATUS is added to notify the device when
> a migration is in/not-in progress from the host's perspective.
>=20
> Signed-off-by: Brett Creeley <brett.creeley@amd.com>
> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
> ---
>  drivers/vfio/pci/pds/Makefile   |   1 +
>  drivers/vfio/pci/pds/cmds.c     | 319 ++++++++++++++++++++++++
>  drivers/vfio/pci/pds/cmds.h     |   8 +-
>  drivers/vfio/pci/pds/lm.c       | 421
> ++++++++++++++++++++++++++++++++
>  drivers/vfio/pci/pds/lm.h       |  41 ++++
>  drivers/vfio/pci/pds/pci_drv.c  |  13 +
>  drivers/vfio/pci/pds/vfio_dev.c | 120 ++++++++-
>  drivers/vfio/pci/pds/vfio_dev.h |  11 +
>  include/linux/pds/pds_adminq.h  | 217 ++++++++++++++++
>  9 files changed, 1149 insertions(+), 2 deletions(-)
>  create mode 100644 drivers/vfio/pci/pds/lm.c
>  create mode 100644 drivers/vfio/pci/pds/lm.h
>=20
> diff --git a/drivers/vfio/pci/pds/Makefile b/drivers/vfio/pci/pds/Makefil=
e
> index 87581111fa17..dbaf613d3794 100644
> --- a/drivers/vfio/pci/pds/Makefile
> +++ b/drivers/vfio/pci/pds/Makefile
> @@ -5,5 +5,6 @@ obj-$(CONFIG_PDS_VFIO_PCI) +=3D pds_vfio.o
>=20
>  pds_vfio-y :=3D \
>  	cmds.o		\
> +	lm.o		\
>  	pci_drv.o	\
>  	vfio_dev.o
> diff --git a/drivers/vfio/pci/pds/cmds.c b/drivers/vfio/pci/pds/cmds.c
> index ae01f5df2f5c..256f458feb58 100644
> --- a/drivers/vfio/pci/pds/cmds.c
> +++ b/drivers/vfio/pci/pds/cmds.c
> @@ -3,6 +3,7 @@
>=20
>  #include <linux/io.h>
>  #include <linux/types.h>
> +#include <linux/delay.h>
>=20
>  #include <linux/pds/pds_common.h>
>  #include <linux/pds/pds_core_if.h>
> @@ -11,6 +12,34 @@
>  #include "vfio_dev.h"
>  #include "cmds.h"
>=20
> +#define SUSPEND_TIMEOUT_S		5
> +#define SUSPEND_CHECK_INTERVAL_MS	1
> +
> +static int pds_vfio_client_adminq_cmd(struct pds_vfio_pci_device
> *pds_vfio,
> +				      union pds_core_adminq_cmd *req,
> +				      size_t req_len,
> +				      union pds_core_adminq_comp *resp,
> +				      u64 flags)

Why u64? Do we expect more flags to follow? The core interface below
only takes a bool(fast_poll) though.

Thanks,
Shameer

> +{
> +	union pds_core_adminq_cmd cmd =3D {};
> +	size_t cp_len;
> +	int err;
> +
> +	/* Wrap the client request */
> +	cmd.client_request.opcode =3D PDS_AQ_CMD_CLIENT_CMD;
> +	cmd.client_request.client_id =3D cpu_to_le16(pds_vfio->client_id);
> +	cp_len =3D min_t(size_t, req_len, sizeof(cmd.client_request.client_cmd)=
);
> +	memcpy(cmd.client_request.client_cmd, req, cp_len);
> +
> +	err =3D pdsc_adminq_post(pds_vfio->pdsc, &cmd, resp,
> +			       !!(flags & PDS_AQ_FLAG_FASTPOLL));
> +	if (err && err !=3D -EAGAIN)
> +		dev_info(pds_vfio_to_dev(pds_vfio),
> +			 "client admin cmd failed: %pe\n", ERR_PTR(err));
> +
> +	return err;
> +}
> +
>  int pds_vfio_register_client_cmd(struct pds_vfio_pci_device *pds_vfio)
>  {
>  	struct pci_dev *pdev =3D pds_vfio_to_pci_dev(pds_vfio);
> @@ -41,3 +70,293 @@ void pds_vfio_unregister_client_cmd(struct
> pds_vfio_pci_device *pds_vfio)
>=20
>  	pds_vfio->client_id =3D 0;
>  }
> +
> +static int
> +pds_vfio_suspend_wait_device_cmd(struct pds_vfio_pci_device *pds_vfio)
> +{
> +	union pds_core_adminq_cmd cmd =3D {
> +		.lm_suspend_status =3D {
> +			.opcode =3D PDS_LM_CMD_SUSPEND_STATUS,
> +			.vf_id =3D cpu_to_le16(pds_vfio->vf_id),
> +		},
> +	};
> +	struct device *dev =3D pds_vfio_to_dev(pds_vfio);
> +	union pds_core_adminq_comp comp =3D {};
> +	unsigned long time_limit;
> +	unsigned long time_start;
> +	unsigned long time_done;
> +	int err;
> +
> +	time_start =3D jiffies;
> +	time_limit =3D time_start + HZ * SUSPEND_TIMEOUT_S;
> +	do {
> +		err =3D pds_vfio_client_adminq_cmd(pds_vfio, &cmd, sizeof(cmd),
> +						 &comp, PDS_AQ_FLAG_FASTPOLL);
> +		if (err !=3D -EAGAIN)
> +			break;
> +
> +		msleep(SUSPEND_CHECK_INTERVAL_MS);
> +	} while (time_before(jiffies, time_limit));
> +
> +	time_done =3D jiffies;
> +	dev_dbg(dev, "%s: vf%u: Suspend comp received in %d msecs\n",
> __func__,
> +		pds_vfio->vf_id, jiffies_to_msecs(time_done - time_start));
> +
> +	/* Check the results */
> +	if (time_after_eq(time_done, time_limit)) {
> +		dev_err(dev, "%s: vf%u: Suspend comp timeout\n", __func__,
> +			pds_vfio->vf_id);
> +		err =3D -ETIMEDOUT;
> +	}
> +
> +	return err;
> +}
> +
> +int pds_vfio_suspend_device_cmd(struct pds_vfio_pci_device *pds_vfio)
> +{
> +	union pds_core_adminq_cmd cmd =3D {
> +		.lm_suspend =3D {
> +			.opcode =3D PDS_LM_CMD_SUSPEND,
> +			.vf_id =3D cpu_to_le16(pds_vfio->vf_id),
> +		},
> +	};
> +	struct device *dev =3D pds_vfio_to_dev(pds_vfio);
> +	union pds_core_adminq_comp comp =3D {};
> +	int err;
> +
> +	dev_dbg(dev, "vf%u: Suspend device\n", pds_vfio->vf_id);
> +
> +	err =3D pds_vfio_client_adminq_cmd(pds_vfio, &cmd, sizeof(cmd),
> &comp,
> +					 PDS_AQ_FLAG_FASTPOLL);
> +	if (err) {
> +		dev_err(dev, "vf%u: Suspend failed: %pe\n", pds_vfio->vf_id,
> +			ERR_PTR(err));
> +		return err;
> +	}
> +
> +	return pds_vfio_suspend_wait_device_cmd(pds_vfio);
> +}
> +
> +int pds_vfio_resume_device_cmd(struct pds_vfio_pci_device *pds_vfio)
> +{
> +	union pds_core_adminq_cmd cmd =3D {
> +		.lm_resume =3D {
> +			.opcode =3D PDS_LM_CMD_RESUME,
> +			.vf_id =3D cpu_to_le16(pds_vfio->vf_id),
> +		},
> +	};
> +	struct device *dev =3D pds_vfio_to_dev(pds_vfio);
> +	union pds_core_adminq_comp comp =3D {};
> +
> +	dev_dbg(dev, "vf%u: Resume device\n", pds_vfio->vf_id);
> +
> +	return pds_vfio_client_adminq_cmd(pds_vfio, &cmd, sizeof(cmd),
> &comp,
> +					  0);
> +}
> +
> +int pds_vfio_get_lm_status_cmd(struct pds_vfio_pci_device *pds_vfio, u64
> *size)
> +{
> +	union pds_core_adminq_cmd cmd =3D {
> +		.lm_status =3D {
> +			.opcode =3D PDS_LM_CMD_STATUS,
> +			.vf_id =3D cpu_to_le16(pds_vfio->vf_id),
> +		},
> +	};
> +	struct device *dev =3D pds_vfio_to_dev(pds_vfio);
> +	union pds_core_adminq_comp comp =3D {};
> +	int err;
> +
> +	dev_dbg(dev, "vf%u: Get migration status\n", pds_vfio->vf_id);
> +
> +	err =3D pds_vfio_client_adminq_cmd(pds_vfio, &cmd, sizeof(cmd), &comp,
> 0);
> +	if (err)
> +		return err;
> +
> +	*size =3D le64_to_cpu(comp.lm_status.size);
> +	return 0;
> +}
> +
> +static int pds_vfio_dma_map_lm_file(struct device *dev,
> +				    enum dma_data_direction dir,
> +				    struct pds_vfio_lm_file *lm_file)
> +{
> +	struct pds_lm_sg_elem *sgl, *sge;
> +	struct scatterlist *sg;
> +	dma_addr_t sgl_addr;
> +	size_t sgl_size;
> +	int err;
> +	int i;
> +
> +	if (!lm_file)
> +		return -EINVAL;
> +
> +	/* dma map file pages */
> +	err =3D dma_map_sgtable(dev, &lm_file->sg_table, dir, 0);
> +	if (err)
> +		return err;
> +
> +	lm_file->num_sge =3D lm_file->sg_table.nents;
> +
> +	/* alloc sgl */
> +	sgl_size =3D lm_file->num_sge * sizeof(struct pds_lm_sg_elem);
> +	sgl =3D kzalloc(sgl_size, GFP_KERNEL);
> +	if (!sgl) {
> +		err =3D -ENOMEM;
> +		goto out_unmap_sgtable;
> +	}
> +
> +	/* fill sgl */
> +	sge =3D sgl;
> +	for_each_sgtable_dma_sg(&lm_file->sg_table, sg, i) {
> +		sge->addr =3D cpu_to_le64(sg_dma_address(sg));
> +		sge->len =3D cpu_to_le32(sg_dma_len(sg));
> +		dev_dbg(dev, "addr =3D %llx, len =3D %u\n", sge->addr, sge->len);
> +		sge++;
> +	}
> +
> +	sgl_addr =3D dma_map_single(dev, sgl, sgl_size, DMA_TO_DEVICE);
> +	if (dma_mapping_error(dev, sgl_addr)) {
> +		err =3D -EIO;
> +		goto out_free_sgl;
> +	}
> +
> +	lm_file->sgl =3D sgl;
> +	lm_file->sgl_addr =3D sgl_addr;
> +
> +	return 0;
> +
> +out_free_sgl:
> +	kfree(sgl);
> +out_unmap_sgtable:
> +	lm_file->num_sge =3D 0;
> +	dma_unmap_sgtable(dev, &lm_file->sg_table, dir, 0);
> +	return err;
> +}
> +
> +static void pds_vfio_dma_unmap_lm_file(struct device *dev,
> +				       enum dma_data_direction dir,
> +				       struct pds_vfio_lm_file *lm_file)
> +{
> +	if (!lm_file)
> +		return;
> +
> +	/* free sgl */
> +	if (lm_file->sgl) {
> +		dma_unmap_single(dev, lm_file->sgl_addr,
> +				 lm_file->num_sge * sizeof(*lm_file->sgl),
> +				 DMA_TO_DEVICE);
> +		kfree(lm_file->sgl);
> +		lm_file->sgl =3D NULL;
> +		lm_file->sgl_addr =3D DMA_MAPPING_ERROR;
> +		lm_file->num_sge =3D 0;
> +	}
> +
> +	/* dma unmap file pages */
> +	dma_unmap_sgtable(dev, &lm_file->sg_table, dir, 0);
> +}
> +
> +int pds_vfio_get_lm_state_cmd(struct pds_vfio_pci_device *pds_vfio)
> +{
> +	union pds_core_adminq_cmd cmd =3D {
> +		.lm_save =3D {
> +			.opcode =3D PDS_LM_CMD_SAVE,
> +			.vf_id =3D cpu_to_le16(pds_vfio->vf_id),
> +		},
> +	};
> +	struct pci_dev *pdev =3D pds_vfio_to_pci_dev(pds_vfio);
> +	struct device *pdsc_dev =3D &pci_physfn(pdev)->dev;
> +	union pds_core_adminq_comp comp =3D {};
> +	struct pds_vfio_lm_file *lm_file;
> +	int err;
> +
> +	dev_dbg(&pdev->dev, "vf%u: Get migration state\n", pds_vfio->vf_id);
> +
> +	lm_file =3D pds_vfio->save_file;
> +
> +	err =3D pds_vfio_dma_map_lm_file(pdsc_dev, DMA_FROM_DEVICE,
> lm_file);
> +	if (err) {
> +		dev_err(&pdev->dev, "failed to map save migration file: %pe\n",
> +			ERR_PTR(err));
> +		return err;
> +	}
> +
> +	cmd.lm_save.sgl_addr =3D cpu_to_le64(lm_file->sgl_addr);
> +	cmd.lm_save.num_sge =3D cpu_to_le32(lm_file->num_sge);
> +
> +	err =3D pds_vfio_client_adminq_cmd(pds_vfio, &cmd, sizeof(cmd), &comp,
> 0);
> +	if (err)
> +		dev_err(&pdev->dev, "failed to get migration state: %pe\n",
> +			ERR_PTR(err));
> +
> +	pds_vfio_dma_unmap_lm_file(pdsc_dev, DMA_FROM_DEVICE, lm_file);
> +
> +	return err;
> +}
> +
> +int pds_vfio_set_lm_state_cmd(struct pds_vfio_pci_device *pds_vfio)
> +{
> +	union pds_core_adminq_cmd cmd =3D {
> +		.lm_restore =3D {
> +			.opcode =3D PDS_LM_CMD_RESTORE,
> +			.vf_id =3D cpu_to_le16(pds_vfio->vf_id),
> +		},
> +	};
> +	struct pci_dev *pdev =3D pds_vfio_to_pci_dev(pds_vfio);
> +	struct device *pdsc_dev =3D &pci_physfn(pdev)->dev;
> +	union pds_core_adminq_comp comp =3D {};
> +	struct pds_vfio_lm_file *lm_file;
> +	int err;
> +
> +	dev_dbg(&pdev->dev, "vf%u: Set migration state\n", pds_vfio->vf_id);
> +
> +	lm_file =3D pds_vfio->restore_file;
> +
> +	err =3D pds_vfio_dma_map_lm_file(pdsc_dev, DMA_TO_DEVICE, lm_file);
> +	if (err) {
> +		dev_err(&pdev->dev,
> +			"failed to map restore migration file: %pe\n",
> +			ERR_PTR(err));
> +		return err;
> +	}
> +
> +	cmd.lm_restore.sgl_addr =3D cpu_to_le64(lm_file->sgl_addr);
> +	cmd.lm_restore.num_sge =3D cpu_to_le32(lm_file->num_sge);
> +
> +	err =3D pds_vfio_client_adminq_cmd(pds_vfio, &cmd, sizeof(cmd), &comp,
> 0);
> +	if (err)
> +		dev_err(&pdev->dev, "failed to set migration state: %pe\n",
> +			ERR_PTR(err));
> +
> +	pds_vfio_dma_unmap_lm_file(pdsc_dev, DMA_TO_DEVICE, lm_file);
> +
> +	return err;
> +}
> +
> +void pds_vfio_send_host_vf_lm_status_cmd(struct pds_vfio_pci_device
> *pds_vfio,
> +					 enum pds_lm_host_vf_status vf_status)
> +{
> +	union pds_core_adminq_cmd cmd =3D {
> +		.lm_host_vf_status =3D {
> +			.opcode =3D PDS_LM_CMD_HOST_VF_STATUS,
> +			.vf_id =3D cpu_to_le16(pds_vfio->vf_id),
> +			.status =3D vf_status,
> +		},
> +	};
> +	struct device *dev =3D pds_vfio_to_dev(pds_vfio);
> +	union pds_core_adminq_comp comp =3D {};
> +	int err;
> +
> +	dev_dbg(dev, "vf%u: Set host VF LM status: %u", pds_vfio->vf_id,
> +		vf_status);
> +	if (vf_status !=3D PDS_LM_STA_IN_PROGRESS &&
> +	    vf_status !=3D PDS_LM_STA_NONE) {
> +		dev_warn(dev, "Invalid host VF migration status, %d\n",
> +			 vf_status);
> +		return;
> +	}
> +
> +	err =3D pds_vfio_client_adminq_cmd(pds_vfio, &cmd, sizeof(cmd), &comp,
> 0);
> +	if (err)
> +		dev_warn(dev, "failed to send host VF migration status: %pe\n",
> +			 ERR_PTR(err));
> +}
> diff --git a/drivers/vfio/pci/pds/cmds.h b/drivers/vfio/pci/pds/cmds.h
> index 4c592afccf89..3d8a5508c733 100644
> --- a/drivers/vfio/pci/pds/cmds.h
> +++ b/drivers/vfio/pci/pds/cmds.h
> @@ -6,5 +6,11 @@
>=20
>  int pds_vfio_register_client_cmd(struct pds_vfio_pci_device *pds_vfio);
>  void pds_vfio_unregister_client_cmd(struct pds_vfio_pci_device *pds_vfio=
);
> -
> +int pds_vfio_suspend_device_cmd(struct pds_vfio_pci_device *pds_vfio);
> +int pds_vfio_resume_device_cmd(struct pds_vfio_pci_device *pds_vfio);
> +int pds_vfio_get_lm_status_cmd(struct pds_vfio_pci_device *pds_vfio, u64
> *size);
> +int pds_vfio_get_lm_state_cmd(struct pds_vfio_pci_device *pds_vfio);
> +int pds_vfio_set_lm_state_cmd(struct pds_vfio_pci_device *pds_vfio);
> +void pds_vfio_send_host_vf_lm_status_cmd(struct pds_vfio_pci_device
> *pds_vfio,
> +					 enum pds_lm_host_vf_status vf_status);
>  #endif /* _CMDS_H_ */
> diff --git a/drivers/vfio/pci/pds/lm.c b/drivers/vfio/pci/pds/lm.c
> new file mode 100644
> index 000000000000..c507f39a2339
> --- /dev/null
> +++ b/drivers/vfio/pci/pds/lm.c
> @@ -0,0 +1,421 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright(c) 2023 Advanced Micro Devices, Inc. */
> +
> +#include <linux/anon_inodes.h>
> +#include <linux/file.h>
> +#include <linux/fs.h>
> +#include <linux/highmem.h>
> +#include <linux/vfio.h>
> +#include <linux/vfio_pci_core.h>
> +
> +#include "vfio_dev.h"
> +#include "cmds.h"
> +
> +static struct pds_vfio_lm_file *
> +pds_vfio_get_lm_file(const struct file_operations *fops, int flags, u64 =
size)
> +{
> +	struct pds_vfio_lm_file *lm_file =3D NULL;
> +	unsigned long long npages;
> +	struct page **pages;
> +	void *page_mem;
> +	const void *p;
> +
> +	if (!size)
> +		return NULL;
> +
> +	/* Alloc file structure */
> +	lm_file =3D kzalloc(sizeof(*lm_file), GFP_KERNEL);
> +	if (!lm_file)
> +		return NULL;
> +
> +	/* Create file */
> +	lm_file->filep =3D
> +		anon_inode_getfile("pds_vfio_lm", fops, lm_file, flags);
> +	if (!lm_file->filep)
> +		goto out_free_file;
> +
> +	stream_open(lm_file->filep->f_inode, lm_file->filep);
> +	mutex_init(&lm_file->lock);
> +
> +	/* prevent file from being released before we are done with it */
> +	get_file(lm_file->filep);
> +
> +	/* Allocate memory for file pages */
> +	npages =3D DIV_ROUND_UP_ULL(size, PAGE_SIZE);
> +	pages =3D kmalloc_array(npages, sizeof(*pages), GFP_KERNEL);
> +	if (!pages)
> +		goto out_put_file;
> +
> +	page_mem =3D kvzalloc(ALIGN(size, PAGE_SIZE), GFP_KERNEL);
> +	if (!page_mem)
> +		goto out_free_pages_array;
> +
> +	p =3D page_mem - offset_in_page(page_mem);
> +	for (unsigned long long i =3D 0; i < npages; i++) {
> +		if (is_vmalloc_addr(p))
> +			pages[i] =3D vmalloc_to_page(p);
> +		else
> +			pages[i] =3D kmap_to_page((void *)p);
> +		if (!pages[i])
> +			goto out_free_page_mem;
> +
> +		p +=3D PAGE_SIZE;
> +	}
> +
> +	/* Create scatterlist of file pages to use for DMA mapping later */
> +	if (sg_alloc_table_from_pages(&lm_file->sg_table, pages, npages, 0,
> +				      size, GFP_KERNEL))
> +		goto out_free_page_mem;
> +
> +	lm_file->size =3D size;
> +	lm_file->pages =3D pages;
> +	lm_file->npages =3D npages;
> +	lm_file->page_mem =3D page_mem;
> +	lm_file->alloc_size =3D npages * PAGE_SIZE;
> +
> +	return lm_file;
> +
> +out_free_page_mem:
> +	kvfree(page_mem);
> +out_free_pages_array:
> +	kfree(pages);
> +out_put_file:
> +	fput(lm_file->filep);
> +	mutex_destroy(&lm_file->lock);
> +out_free_file:
> +	kfree(lm_file);
> +
> +	return NULL;
> +}
> +
> +static void pds_vfio_put_lm_file(struct pds_vfio_lm_file *lm_file)
> +{
> +	mutex_lock(&lm_file->lock);
> +
> +	lm_file->size =3D 0;
> +	lm_file->alloc_size =3D 0;
> +
> +	/* Free scatter list of file pages */
> +	sg_free_table(&lm_file->sg_table);
> +
> +	kvfree(lm_file->page_mem);
> +	lm_file->page_mem =3D NULL;
> +	kfree(lm_file->pages);
> +	lm_file->pages =3D NULL;
> +
> +	mutex_unlock(&lm_file->lock);
> +
> +	/* allow file to be released since we are done with it */
> +	fput(lm_file->filep);
> +}
> +
> +void pds_vfio_put_save_file(struct pds_vfio_pci_device *pds_vfio)
> +{
> +	if (!pds_vfio->save_file)
> +		return;
> +
> +	pds_vfio_put_lm_file(pds_vfio->save_file);
> +	pds_vfio->save_file =3D NULL;
> +}
> +
> +void pds_vfio_put_restore_file(struct pds_vfio_pci_device *pds_vfio)
> +{
> +	if (!pds_vfio->restore_file)
> +		return;
> +
> +	pds_vfio_put_lm_file(pds_vfio->restore_file);
> +	pds_vfio->restore_file =3D NULL;
> +}
> +
> +static struct page *pds_vfio_get_file_page(struct pds_vfio_lm_file *lm_f=
ile,
> +					   unsigned long offset)
> +{
> +	unsigned long cur_offset =3D 0;
> +	struct scatterlist *sg;
> +	unsigned int i;
> +
> +	/* All accesses are sequential */
> +	if (offset < lm_file->last_offset || !lm_file->last_offset_sg) {
> +		lm_file->last_offset =3D 0;
> +		lm_file->last_offset_sg =3D lm_file->sg_table.sgl;
> +		lm_file->sg_last_entry =3D 0;
> +	}
> +
> +	cur_offset =3D lm_file->last_offset;
> +
> +	for_each_sg(lm_file->last_offset_sg, sg,
> +		    lm_file->sg_table.orig_nents - lm_file->sg_last_entry, i) {
> +		if (offset < sg->length + cur_offset) {
> +			lm_file->last_offset_sg =3D sg;
> +			lm_file->sg_last_entry +=3D i;
> +			lm_file->last_offset =3D cur_offset;
> +			return nth_page(sg_page(sg),
> +					(offset - cur_offset) / PAGE_SIZE);
> +		}
> +		cur_offset +=3D sg->length;
> +	}
> +
> +	return NULL;
> +}
> +
> +static int pds_vfio_release_file(struct inode *inode, struct file *filp)
> +{
> +	struct pds_vfio_lm_file *lm_file =3D filp->private_data;
> +
> +	mutex_lock(&lm_file->lock);
> +	lm_file->filep->f_pos =3D 0;
> +	lm_file->size =3D 0;
> +	mutex_unlock(&lm_file->lock);
> +	mutex_destroy(&lm_file->lock);
> +	kfree(lm_file);
> +
> +	return 0;
> +}
> +
> +static ssize_t pds_vfio_save_read(struct file *filp, char __user *buf,
> +				  size_t len, loff_t *pos)
> +{
> +	struct pds_vfio_lm_file *lm_file =3D filp->private_data;
> +	ssize_t done =3D 0;
> +
> +	if (pos)
> +		return -ESPIPE;
> +	pos =3D &filp->f_pos;
> +
> +	mutex_lock(&lm_file->lock);
> +	if (*pos > lm_file->size) {
> +		done =3D -EINVAL;
> +		goto out_unlock;
> +	}
> +
> +	len =3D min_t(size_t, lm_file->size - *pos, len);
> +	while (len) {
> +		size_t page_offset;
> +		struct page *page;
> +		size_t page_len;
> +		u8 *from_buff;
> +		int err;
> +
> +		page_offset =3D (*pos) % PAGE_SIZE;
> +		page =3D pds_vfio_get_file_page(lm_file, *pos - page_offset);
> +		if (!page) {
> +			if (done =3D=3D 0)
> +				done =3D -EINVAL;
> +			goto out_unlock;
> +		}
> +
> +		page_len =3D min_t(size_t, len, PAGE_SIZE - page_offset);
> +		from_buff =3D kmap_local_page(page);
> +		err =3D copy_to_user(buf, from_buff + page_offset, page_len);
> +		kunmap_local(from_buff);
> +		if (err) {
> +			done =3D -EFAULT;
> +			goto out_unlock;
> +		}
> +		*pos +=3D page_len;
> +		len -=3D page_len;
> +		done +=3D page_len;
> +		buf +=3D page_len;
> +	}
> +
> +out_unlock:
> +	mutex_unlock(&lm_file->lock);
> +	return done;
> +}
> +
> +static const struct file_operations pds_vfio_save_fops =3D {
> +	.owner =3D THIS_MODULE,
> +	.read =3D pds_vfio_save_read,
> +	.release =3D pds_vfio_release_file,
> +	.llseek =3D no_llseek,
> +};
> +
> +static int pds_vfio_get_save_file(struct pds_vfio_pci_device *pds_vfio)
> +{
> +	struct device *dev =3D &pds_vfio->vfio_coredev.pdev->dev;
> +	struct pds_vfio_lm_file *lm_file;
> +	int err;
> +	u64 size;
> +
> +	/* Get live migration state size in this state */
> +	err =3D pds_vfio_get_lm_status_cmd(pds_vfio, &size);
> +	if (err) {
> +		dev_err(dev, "failed to get save status: %pe\n", ERR_PTR(err));
> +		return err;
> +	}
> +
> +	dev_dbg(dev, "save status, size =3D %lld\n", size);
> +
> +	if (!size) {
> +		dev_err(dev, "invalid state size\n");
> +		return -EIO;
> +	}
> +
> +	lm_file =3D pds_vfio_get_lm_file(&pds_vfio_save_fops, O_RDONLY, size);
> +	if (!lm_file) {
> +		dev_err(dev, "failed to create save file\n");
> +		return -ENOENT;
> +	}
> +
> +	dev_dbg(dev, "size =3D %lld, alloc_size =3D %lld, npages =3D %lld\n",
> +		lm_file->size, lm_file->alloc_size, lm_file->npages);
> +
> +	pds_vfio->save_file =3D lm_file;
> +
> +	return 0;
> +}
> +
> +static ssize_t pds_vfio_restore_write(struct file *filp, const char __us=
er
> *buf,
> +				      size_t len, loff_t *pos)
> +{
> +	struct pds_vfio_lm_file *lm_file =3D filp->private_data;
> +	loff_t requested_length;
> +	ssize_t done =3D 0;
> +
> +	if (pos)
> +		return -ESPIPE;
> +
> +	pos =3D &filp->f_pos;
> +
> +	if (*pos < 0 ||
> +	    check_add_overflow((loff_t)len, *pos, &requested_length))
> +		return -EINVAL;
> +
> +	mutex_lock(&lm_file->lock);
> +
> +	while (len) {
> +		size_t page_offset;
> +		struct page *page;
> +		size_t page_len;
> +		u8 *to_buff;
> +		int err;
> +
> +		page_offset =3D (*pos) % PAGE_SIZE;
> +		page =3D pds_vfio_get_file_page(lm_file, *pos - page_offset);
> +		if (!page) {
> +			if (done =3D=3D 0)
> +				done =3D -EINVAL;
> +			goto out_unlock;
> +		}
> +
> +		page_len =3D min_t(size_t, len, PAGE_SIZE - page_offset);
> +		to_buff =3D kmap_local_page(page);
> +		err =3D copy_from_user(to_buff + page_offset, buf, page_len);
> +		kunmap_local(to_buff);
> +		if (err) {
> +			done =3D -EFAULT;
> +			goto out_unlock;
> +		}
> +		*pos +=3D page_len;
> +		len -=3D page_len;
> +		done +=3D page_len;
> +		buf +=3D page_len;
> +		lm_file->size +=3D page_len;
> +	}
> +out_unlock:
> +	mutex_unlock(&lm_file->lock);
> +	return done;
> +}
> +
> +static const struct file_operations pds_vfio_restore_fops =3D {
> +	.owner =3D THIS_MODULE,
> +	.write =3D pds_vfio_restore_write,
> +	.release =3D pds_vfio_release_file,
> +	.llseek =3D no_llseek,
> +};
> +
> +static int pds_vfio_get_restore_file(struct pds_vfio_pci_device *pds_vfi=
o)
> +{
> +	struct device *dev =3D &pds_vfio->vfio_coredev.pdev->dev;
> +	struct pds_vfio_lm_file *lm_file;
> +	u64 size;
> +
> +	size =3D sizeof(union pds_lm_dev_state);
> +	dev_dbg(dev, "restore status, size =3D %lld\n", size);
> +
> +	if (!size) {
> +		dev_err(dev, "invalid state size");
> +		return -EIO;
> +	}
> +
> +	lm_file =3D pds_vfio_get_lm_file(&pds_vfio_restore_fops, O_WRONLY,
> size);
> +	if (!lm_file) {
> +		dev_err(dev, "failed to create restore file");
> +		return -ENOENT;
> +	}
> +	pds_vfio->restore_file =3D lm_file;
> +
> +	return 0;
> +}
> +
> +struct file *
> +pds_vfio_step_device_state_locked(struct pds_vfio_pci_device *pds_vfio,
> +				  enum vfio_device_mig_state next)
> +{
> +	enum vfio_device_mig_state cur =3D pds_vfio->state;
> +	int err;
> +
> +	if (cur =3D=3D VFIO_DEVICE_STATE_STOP && next =3D=3D
> VFIO_DEVICE_STATE_STOP_COPY) {
> +		err =3D pds_vfio_get_save_file(pds_vfio);
> +		if (err)
> +			return ERR_PTR(err);
> +
> +		err =3D pds_vfio_get_lm_state_cmd(pds_vfio);
> +		if (err) {
> +			pds_vfio_put_save_file(pds_vfio);
> +			return ERR_PTR(err);
> +		}
> +
> +		return pds_vfio->save_file->filep;
> +	}
> +
> +	if (cur =3D=3D VFIO_DEVICE_STATE_STOP_COPY && next =3D=3D
> VFIO_DEVICE_STATE_STOP) {
> +		pds_vfio_put_save_file(pds_vfio);
> +		pds_vfio_send_host_vf_lm_status_cmd(pds_vfio,
> PDS_LM_STA_NONE);
> +		return NULL;
> +	}
> +
> +	if (cur =3D=3D VFIO_DEVICE_STATE_STOP && next =3D=3D
> VFIO_DEVICE_STATE_RESUMING) {
> +		err =3D pds_vfio_get_restore_file(pds_vfio);
> +		if (err)
> +			return ERR_PTR(err);
> +
> +		return pds_vfio->restore_file->filep;
> +	}
> +
> +	if (cur =3D=3D VFIO_DEVICE_STATE_RESUMING && next =3D=3D
> VFIO_DEVICE_STATE_STOP) {
> +		err =3D pds_vfio_set_lm_state_cmd(pds_vfio);
> +		if (err)
> +			return ERR_PTR(err);
> +
> +		pds_vfio_put_restore_file(pds_vfio);
> +		return NULL;
> +	}
> +
> +	if (cur =3D=3D VFIO_DEVICE_STATE_RUNNING && next =3D=3D
> VFIO_DEVICE_STATE_RUNNING_P2P) {
> +		pds_vfio_send_host_vf_lm_status_cmd(pds_vfio,
> +						    PDS_LM_STA_IN_PROGRESS);
> +		err =3D pds_vfio_suspend_device_cmd(pds_vfio);
> +		if (err)
> +			return ERR_PTR(err);
> +
> +		return NULL;
> +	}
> +
> +	if (cur =3D=3D VFIO_DEVICE_STATE_RUNNING_P2P && next =3D=3D
> VFIO_DEVICE_STATE_RUNNING) {
> +		err =3D pds_vfio_resume_device_cmd(pds_vfio);
> +		if (err)
> +			return ERR_PTR(err);
> +
> +		pds_vfio_send_host_vf_lm_status_cmd(pds_vfio,
> PDS_LM_STA_NONE);
> +		return NULL;
> +	}
> +
> +	if (cur =3D=3D VFIO_DEVICE_STATE_STOP && next =3D=3D
> VFIO_DEVICE_STATE_RUNNING_P2P)
> +		return NULL;
> +
> +	if (cur =3D=3D VFIO_DEVICE_STATE_RUNNING_P2P && next =3D=3D
> VFIO_DEVICE_STATE_STOP)
> +		return NULL;
> +
> +	return ERR_PTR(-EINVAL);
> +}
> diff --git a/drivers/vfio/pci/pds/lm.h b/drivers/vfio/pci/pds/lm.h
> new file mode 100644
> index 000000000000..13be893198b7
> --- /dev/null
> +++ b/drivers/vfio/pci/pds/lm.h
> @@ -0,0 +1,41 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* Copyright(c) 2023 Advanced Micro Devices, Inc. */
> +
> +#ifndef _LM_H_
> +#define _LM_H_
> +
> +#include <linux/fs.h>
> +#include <linux/mutex.h>
> +#include <linux/scatterlist.h>
> +#include <linux/types.h>
> +
> +#include <linux/pds/pds_common.h>
> +#include <linux/pds/pds_adminq.h>
> +
> +struct pds_vfio_lm_file {
> +	struct file *filep;
> +	struct mutex lock;	/* protect live migration data file */
> +	u64 size;		/* Size with valid data */
> +	u64 alloc_size;		/* Total allocated size. Always >=3D len */
> +	void *page_mem;		/* memory allocated for pages */
> +	struct page **pages;	/* Backing pages for file */
> +	unsigned long long npages;
> +	struct sg_table sg_table;	/* SG table for backing pages */
> +	struct pds_lm_sg_elem *sgl;	/* DMA mapping */
> +	dma_addr_t sgl_addr;
> +	u16 num_sge;
> +	struct scatterlist *last_offset_sg;	/* Iterator */
> +	unsigned int sg_last_entry;
> +	unsigned long last_offset;
> +};
> +
> +struct pds_vfio_pci_device;
> +
> +struct file *
> +pds_vfio_step_device_state_locked(struct pds_vfio_pci_device *pds_vfio,
> +				  enum vfio_device_mig_state next);
> +
> +void pds_vfio_put_save_file(struct pds_vfio_pci_device *pds_vfio);
> +void pds_vfio_put_restore_file(struct pds_vfio_pci_device *pds_vfio);
> +
> +#endif /* _LM_H_ */
> diff --git a/drivers/vfio/pci/pds/pci_drv.c b/drivers/vfio/pci/pds/pci_dr=
v.c
> index a49420aa9736..ffd47fa8ede3 100644
> --- a/drivers/vfio/pci/pds/pci_drv.c
> +++ b/drivers/vfio/pci/pds/pci_drv.c
> @@ -73,11 +73,24 @@ pds_vfio_pci_table[] =3D {
>  };
>  MODULE_DEVICE_TABLE(pci, pds_vfio_pci_table);
>=20
> +static void pds_vfio_pci_aer_reset_done(struct pci_dev *pdev)
> +{
> +	struct pds_vfio_pci_device *pds_vfio =3D pds_vfio_pci_drvdata(pdev);
> +
> +	pds_vfio_reset(pds_vfio);
> +}
> +
> +static const struct pci_error_handlers pds_vfio_pci_err_handlers =3D {
> +	.reset_done =3D pds_vfio_pci_aer_reset_done,
> +	.error_detected =3D vfio_pci_core_aer_err_detected,
> +};
> +
>  static struct pci_driver pds_vfio_pci_driver =3D {
>  	.name =3D KBUILD_MODNAME,
>  	.id_table =3D pds_vfio_pci_table,
>  	.probe =3D pds_vfio_pci_probe,
>  	.remove =3D pds_vfio_pci_remove,
> +	.err_handler =3D &pds_vfio_pci_err_handlers,
>  	.driver_managed_dma =3D true,
>  };
>=20
> diff --git a/drivers/vfio/pci/pds/vfio_dev.c b/drivers/vfio/pci/pds/vfio_=
dev.c
> index 39771265b78f..2435d8255366 100644
> --- a/drivers/vfio/pci/pds/vfio_dev.c
> +++ b/drivers/vfio/pci/pds/vfio_dev.c
> @@ -4,6 +4,7 @@
>  #include <linux/vfio.h>
>  #include <linux/vfio_pci_core.h>
>=20
> +#include "lm.h"
>  #include "vfio_dev.h"
>=20
>  struct pci_dev *pds_vfio_to_pci_dev(struct pds_vfio_pci_device *pds_vfio=
)
> @@ -11,6 +12,11 @@ struct pci_dev *pds_vfio_to_pci_dev(struct
> pds_vfio_pci_device *pds_vfio)
>  	return pds_vfio->vfio_coredev.pdev;
>  }
>=20
> +struct device *pds_vfio_to_dev(struct pds_vfio_pci_device *pds_vfio)
> +{
> +	return &pds_vfio_to_pci_dev(pds_vfio)->dev;
> +}
> +
>  struct pds_vfio_pci_device *pds_vfio_pci_drvdata(struct pci_dev *pdev)
>  {
>  	struct vfio_pci_core_device *core_device =3D
> dev_get_drvdata(&pdev->dev);
> @@ -19,6 +25,98 @@ struct pds_vfio_pci_device
> *pds_vfio_pci_drvdata(struct pci_dev *pdev)
>  			    vfio_coredev);
>  }
>=20
> +static void pds_vfio_state_mutex_unlock(struct pds_vfio_pci_device
> *pds_vfio)
> +{
> +again:
> +	spin_lock(&pds_vfio->reset_lock);
> +	if (pds_vfio->deferred_reset) {
> +		pds_vfio->deferred_reset =3D false;
> +		if (pds_vfio->state =3D=3D VFIO_DEVICE_STATE_ERROR) {
> +			pds_vfio->state =3D VFIO_DEVICE_STATE_RUNNING;
> +			pds_vfio_put_restore_file(pds_vfio);
> +			pds_vfio_put_save_file(pds_vfio);
> +		}
> +		spin_unlock(&pds_vfio->reset_lock);
> +		goto again;
> +	}
> +	mutex_unlock(&pds_vfio->state_mutex);
> +	spin_unlock(&pds_vfio->reset_lock);
> +}
> +
> +void pds_vfio_reset(struct pds_vfio_pci_device *pds_vfio)
> +{
> +	spin_lock(&pds_vfio->reset_lock);
> +	pds_vfio->deferred_reset =3D true;
> +	if (!mutex_trylock(&pds_vfio->state_mutex)) {
> +		spin_unlock(&pds_vfio->reset_lock);
> +		return;
> +	}
> +	spin_unlock(&pds_vfio->reset_lock);
> +	pds_vfio_state_mutex_unlock(pds_vfio);
> +}
> +
> +static struct file *
> +pds_vfio_set_device_state(struct vfio_device *vdev,
> +			  enum vfio_device_mig_state new_state)
> +{
> +	struct pds_vfio_pci_device *pds_vfio =3D
> +		container_of(vdev, struct pds_vfio_pci_device,
> +			     vfio_coredev.vdev);
> +	struct file *res =3D NULL;
> +
> +	mutex_lock(&pds_vfio->state_mutex);
> +	while (new_state !=3D pds_vfio->state) {
> +		enum vfio_device_mig_state next_state;
> +
> +		int err =3D vfio_mig_get_next_state(vdev, pds_vfio->state,
> +						  new_state, &next_state);
> +		if (err) {
> +			res =3D ERR_PTR(err);
> +			break;
> +		}
> +
> +		res =3D pds_vfio_step_device_state_locked(pds_vfio, next_state);
> +		if (IS_ERR(res))
> +			break;
> +
> +		pds_vfio->state =3D next_state;
> +
> +		if (WARN_ON(res && new_state !=3D pds_vfio->state)) {
> +			res =3D ERR_PTR(-EINVAL);
> +			break;
> +		}
> +	}
> +	pds_vfio_state_mutex_unlock(pds_vfio);
> +
> +	return res;
> +}
> +
> +static int pds_vfio_get_device_state(struct vfio_device *vdev,
> +				     enum vfio_device_mig_state *current_state)
> +{
> +	struct pds_vfio_pci_device *pds_vfio =3D
> +		container_of(vdev, struct pds_vfio_pci_device,
> +			     vfio_coredev.vdev);
> +
> +	mutex_lock(&pds_vfio->state_mutex);
> +	*current_state =3D pds_vfio->state;
> +	pds_vfio_state_mutex_unlock(pds_vfio);
> +	return 0;
> +}
> +
> +static int pds_vfio_get_device_state_size(struct vfio_device *vdev,
> +					  unsigned long *stop_copy_length)
> +{
> +	*stop_copy_length =3D PDS_LM_DEVICE_STATE_LENGTH;
> +	return 0;
> +}
> +
> +static const struct vfio_migration_ops pds_vfio_lm_ops =3D {
> +	.migration_set_state =3D pds_vfio_set_device_state,
> +	.migration_get_state =3D pds_vfio_get_device_state,
> +	.migration_get_data_size =3D pds_vfio_get_device_state_size
> +};
> +
>  static int pds_vfio_init_device(struct vfio_device *vdev)
>  {
>  	struct pds_vfio_pci_device *pds_vfio =3D
> @@ -34,6 +132,9 @@ static int pds_vfio_init_device(struct vfio_device
> *vdev)
>  	pds_vfio->vf_id =3D pci_iov_vf_id(pdev);
>  	pds_vfio->pci_id =3D PCI_DEVID(pdev->bus->number, pdev->devfn);
>=20
> +	vdev->migration_flags =3D VFIO_MIGRATION_STOP_COPY |
> VFIO_MIGRATION_P2P;
> +	vdev->mig_ops =3D &pds_vfio_lm_ops;
> +
>  	dev_dbg(&pdev->dev,
>  		"%s: PF %#04x VF %#04x (%d) vf_id %d domain %d
> pds_vfio %p\n",
>  		__func__, pci_dev_id(pdev->physfn), pds_vfio->pci_id,
> @@ -54,17 +155,34 @@ static int pds_vfio_open_device(struct vfio_device
> *vdev)
>  	if (err)
>  		return err;
>=20
> +	mutex_init(&pds_vfio->state_mutex);
> +	pds_vfio->state =3D VFIO_DEVICE_STATE_RUNNING;
> +
>  	vfio_pci_core_finish_enable(&pds_vfio->vfio_coredev);
>=20
>  	return 0;
>  }
>=20
> +static void pds_vfio_close_device(struct vfio_device *vdev)
> +{
> +	struct pds_vfio_pci_device *pds_vfio =3D
> +		container_of(vdev, struct pds_vfio_pci_device,
> +			     vfio_coredev.vdev);
> +
> +	mutex_lock(&pds_vfio->state_mutex);
> +	pds_vfio_put_restore_file(pds_vfio);
> +	pds_vfio_put_save_file(pds_vfio);
> +	mutex_unlock(&pds_vfio->state_mutex);
> +	mutex_destroy(&pds_vfio->state_mutex);
> +	vfio_pci_core_close_device(vdev);
> +}
> +
>  static const struct vfio_device_ops pds_vfio_ops =3D {
>  	.name =3D "pds-vfio",
>  	.init =3D pds_vfio_init_device,
>  	.release =3D vfio_pci_core_release_dev,
>  	.open_device =3D pds_vfio_open_device,
> -	.close_device =3D vfio_pci_core_close_device,
> +	.close_device =3D pds_vfio_close_device,
>  	.ioctl =3D vfio_pci_core_ioctl,
>  	.device_feature =3D vfio_pci_core_ioctl_feature,
>  	.read =3D vfio_pci_core_read,
> diff --git a/drivers/vfio/pci/pds/vfio_dev.h b/drivers/vfio/pci/pds/vfio_=
dev.h
> index 92e8ff241ca8..df6208a7140b 100644
> --- a/drivers/vfio/pci/pds/vfio_dev.h
> +++ b/drivers/vfio/pci/pds/vfio_dev.h
> @@ -7,12 +7,21 @@
>  #include <linux/pci.h>
>  #include <linux/vfio_pci_core.h>
>=20
> +#include "lm.h"
> +
>  struct pdsc;
>=20
>  struct pds_vfio_pci_device {
>  	struct vfio_pci_core_device vfio_coredev;
>  	struct pdsc *pdsc;
>=20
> +	struct pds_vfio_lm_file *save_file;
> +	struct pds_vfio_lm_file *restore_file;
> +	struct mutex state_mutex; /* protect migration state */
> +	enum vfio_device_mig_state state;
> +	spinlock_t reset_lock; /* protect reset_done flow */
> +	u8 deferred_reset;
> +
>  	int vf_id;
>  	int pci_id;
>  	u16 client_id;
> @@ -20,7 +29,9 @@ struct pds_vfio_pci_device {
>=20
>  const struct vfio_device_ops *pds_vfio_ops_info(void);
>  struct pds_vfio_pci_device *pds_vfio_pci_drvdata(struct pci_dev *pdev);
> +void pds_vfio_reset(struct pds_vfio_pci_device *pds_vfio);
>=20
>  struct pci_dev *pds_vfio_to_pci_dev(struct pds_vfio_pci_device *pds_vfio=
);
> +struct device *pds_vfio_to_dev(struct pds_vfio_pci_device *pds_vfio);
>=20
>  #endif /* _VFIO_DEV_H_ */
> diff --git a/include/linux/pds/pds_adminq.h
> b/include/linux/pds/pds_adminq.h
> index 98a60ce87b92..db6de081f15f 100644
> --- a/include/linux/pds/pds_adminq.h
> +++ b/include/linux/pds/pds_adminq.h
> @@ -584,6 +584,213 @@ struct pds_core_q_init_comp {
>  	u8     color;
>  };
>=20
> +#define PDS_LM_DEVICE_STATE_LENGTH		65536
> +#define PDS_LM_CHECK_DEVICE_STATE_LENGTH(X) \
> +			PDS_CORE_SIZE_CHECK(union,
> PDS_LM_DEVICE_STATE_LENGTH, X)
> +
> +/*
> + * enum pds_lm_cmd_opcode - Live Migration Device commands
> + */
> +enum pds_lm_cmd_opcode {
> +	PDS_LM_CMD_HOST_VF_STATUS  =3D 1,
> +
> +	/* Device state commands */
> +	PDS_LM_CMD_STATUS          =3D 16,
> +	PDS_LM_CMD_SUSPEND         =3D 18,
> +	PDS_LM_CMD_SUSPEND_STATUS  =3D 19,
> +	PDS_LM_CMD_RESUME          =3D 20,
> +	PDS_LM_CMD_SAVE            =3D 21,
> +	PDS_LM_CMD_RESTORE         =3D 22,
> +};
> +
> +/**
> + * struct pds_lm_cmd - generic command
> + * @opcode:	Opcode
> + * @rsvd:	Word boundary padding
> + * @vf_id:	VF id
> + * @rsvd2:	Structure padding to 60 Bytes
> + */
> +struct pds_lm_cmd {
> +	u8     opcode;
> +	u8     rsvd;
> +	__le16 vf_id;
> +	u8     rsvd2[56];
> +};
> +
> +/**
> + * struct pds_lm_comp - generic command completion
> + * @status:	Status of the command (enum pds_core_status_code)
> + * @rsvd:	Structure padding to 16 Bytes
> + */
> +struct pds_lm_comp {
> +	u8 status;
> +	u8 rsvd[15];
> +};
> +
> +/**
> + * struct pds_lm_status_cmd - STATUS command
> + * @opcode:	Opcode
> + * @rsvd:	Word boundary padding
> + * @vf_id:	VF id
> + */
> +struct pds_lm_status_cmd {
> +	u8     opcode;
> +	u8     rsvd;
> +	__le16 vf_id;
> +};
> +
> +/**
> + * struct pds_lm_status_comp - STATUS command completion
> + * @status:		Status of the command (enum pds_core_status_code)
> + * @rsvd:		Word boundary padding
> + * @comp_index:		Index in the desc ring for which this is the
> completion
> + * @size:		Size of the device state
> + * @rsvd2:		Word boundary padding
> + * @color:		Color bit
> + */
> +struct pds_lm_status_comp {
> +	u8     status;
> +	u8     rsvd;
> +	__le16 comp_index;
> +	union {
> +		__le64 size;
> +		u8     rsvd2[11];
> +	} __packed;
> +	u8     color;
> +};
> +
> +/**
> + * struct pds_lm_suspend_cmd - SUSPEND command
> + * @opcode:	Opcode PDS_LM_CMD_SUSPEND
> + * @rsvd:	Word boundary padding
> + * @vf_id:	VF id
> + */
> +struct pds_lm_suspend_cmd {
> +	u8     opcode;
> +	u8     rsvd;
> +	__le16 vf_id;
> +};
> +
> +/**
> + * struct pds_lm_suspend_comp - SUSPEND command completion
> + * @status:		Status of the command (enum pds_core_status_code)
> + * @rsvd:		Word boundary padding
> + * @comp_index:		Index in the desc ring for which this is the
> completion
> + * @state_size:		Size of the device state computed post suspend
> + * @rsvd2:		Word boundary padding
> + * @color:		Color bit
> + */
> +struct pds_lm_suspend_comp {
> +	u8     status;
> +	u8     rsvd;
> +	__le16 comp_index;
> +	union {
> +		__le64 state_size;
> +		u8     rsvd2[11];
> +	} __packed;
> +	u8     color;
> +};
> +
> +/**
> + * struct pds_lm_suspend_status_cmd - SUSPEND status command
> + * @opcode:	Opcode PDS_AQ_CMD_LM_SUSPEND_STATUS
> + * @rsvd:	Word boundary padding
> + * @vf_id:	VF id
> + */
> +struct pds_lm_suspend_status_cmd {
> +	u8 opcode;
> +	u8 rsvd;
> +	__le16 vf_id;
> +};
> +
> +/**
> + * struct pds_lm_resume_cmd - RESUME command
> + * @opcode:	Opcode PDS_LM_CMD_RESUME
> + * @rsvd:	Word boundary padding
> + * @vf_id:	VF id
> + */
> +struct pds_lm_resume_cmd {
> +	u8     opcode;
> +	u8     rsvd;
> +	__le16 vf_id;
> +};
> +
> +/**
> + * struct pds_lm_sg_elem - Transmit scatter-gather (SG) descriptor eleme=
nt
> + * @addr:	DMA address of SG element data buffer
> + * @len:	Length of SG element data buffer, in bytes
> + * @rsvd:	Word boundary padding
> + */
> +struct pds_lm_sg_elem {
> +	__le64 addr;
> +	__le32 len;
> +	__le16 rsvd[2];
> +};
> +
> +/**
> + * struct pds_lm_save_cmd - SAVE command
> + * @opcode:	Opcode PDS_LM_CMD_SAVE
> + * @rsvd:	Word boundary padding
> + * @vf_id:	VF id
> + * @rsvd2:	Word boundary padding
> + * @sgl_addr:	IOVA address of the SGL to dma the device state
> + * @num_sge:	Total number of SG elements
> + */
> +struct pds_lm_save_cmd {
> +	u8     opcode;
> +	u8     rsvd;
> +	__le16 vf_id;
> +	u8     rsvd2[4];
> +	__le64 sgl_addr;
> +	__le32 num_sge;
> +} __packed;
> +
> +/**
> + * struct pds_lm_restore_cmd - RESTORE command
> + * @opcode:	Opcode PDS_LM_CMD_RESTORE
> + * @rsvd:	Word boundary padding
> + * @vf_id:	VF id
> + * @rsvd2:	Word boundary padding
> + * @sgl_addr:	IOVA address of the SGL to dma the device state
> + * @num_sge:	Total number of SG elements
> + */
> +struct pds_lm_restore_cmd {
> +	u8     opcode;
> +	u8     rsvd;
> +	__le16 vf_id;
> +	u8     rsvd2[4];
> +	__le64 sgl_addr;
> +	__le32 num_sge;
> +} __packed;
> +
> +/**
> + * union pds_lm_dev_state - device state information
> + * @words:	Device state words
> + */
> +union pds_lm_dev_state {
> +	__le32 words[PDS_LM_DEVICE_STATE_LENGTH / sizeof(__le32)];
> +};
> +
> +enum pds_lm_host_vf_status {
> +	PDS_LM_STA_NONE =3D 0,
> +	PDS_LM_STA_IN_PROGRESS,
> +	PDS_LM_STA_MAX,
> +};
> +
> +/**
> + * struct pds_lm_host_vf_status_cmd - HOST_VF_STATUS command
> + * @opcode:	Opcode PDS_LM_CMD_HOST_VF_STATUS
> + * @rsvd:	Word boundary padding
> + * @vf_id:	VF id
> + * @status:	Current LM status of host VF driver (enum
> pds_lm_host_status)
> + */
> +struct pds_lm_host_vf_status_cmd {
> +	u8     opcode;
> +	u8     rsvd;
> +	__le16 vf_id;
> +	u8     status;
> +};
> +
>  union pds_core_adminq_cmd {
>  	u8     opcode;
>  	u8     bytes[64];
> @@ -600,6 +807,14 @@ union pds_core_adminq_cmd {
>=20
>  	struct pds_core_q_identify_cmd    q_ident;
>  	struct pds_core_q_init_cmd        q_init;
> +
> +	struct pds_lm_suspend_cmd		lm_suspend;
> +	struct pds_lm_suspend_status_cmd	lm_suspend_status;
> +	struct pds_lm_resume_cmd		lm_resume;
> +	struct pds_lm_status_cmd		lm_status;
> +	struct pds_lm_save_cmd			lm_save;
> +	struct pds_lm_restore_cmd		lm_restore;
> +	struct pds_lm_host_vf_status_cmd	lm_host_vf_status;
>  };
>=20
>  union pds_core_adminq_comp {
> @@ -621,6 +836,8 @@ union pds_core_adminq_comp {
>=20
>  	struct pds_core_q_identify_comp   q_ident;
>  	struct pds_core_q_init_comp       q_init;
> +
> +	struct pds_lm_status_comp		lm_status;
>  };
>=20
>  #ifndef __CHECKER__
> --
> 2.17.1


