Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBB81F1421
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 11:40:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731412AbfKFKkB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 05:40:01 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:41805 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731358AbfKFKkA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 05:40:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573036798;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Yey25+Uqxen0+u/d1twFlJAQI6PD1Ws5vBRnd57oAFY=;
        b=abGs6Xl0/rw4KtEqSeRbLp7TUeIm17P4c6EiZKd780GzpN3tMJkjVHhpZxZ3ZzoHDEj56h
        +XsNvPdTeYDm07hM6/DEdbQisZI1yYwXQVBrFZPlVqiNNDDYfczjzbFG2+sTLs0Y8bhWQb
        bg8xfdiZFUacXE408O0/o+0HZdz1jBk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-148-VCWYZjVVPzupzfwBOdEj9g-1; Wed, 06 Nov 2019 05:39:55 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7CAD58017DD;
        Wed,  6 Nov 2019 10:39:53 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6428F60852;
        Wed,  6 Nov 2019 10:39:53 +0000 (UTC)
Received: from zmail21.collab.prod.int.phx2.redhat.com (zmail21.collab.prod.int.phx2.redhat.com [10.5.83.24])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 41AE84BB5C;
        Wed,  6 Nov 2019 10:39:53 +0000 (UTC)
Date:   Wed, 6 Nov 2019 05:39:52 -0500 (EST)
From:   Jason Wang <jasowang@redhat.com>
To:     Zhu Lingshan <lingshan.zhu@intel.com>
Cc:     mst@redhat.com, alex williamson <alex.williamson@redhat.com>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, dan daly <dan.daly@intel.com>,
        cunming liang <cunming.liang@intel.com>,
        tiwei bie <tiwei.bie@intel.com>,
        jason zeng <jason.zeng@intel.com>
Message-ID: <567342941.12778452.1573036792388.JavaMail.zimbra@redhat.com>
In-Reply-To: <1572946660-26265-3-git-send-email-lingshan.zhu@intel.com>
References: <1572946660-26265-1-git-send-email-lingshan.zhu@intel.com> <1572946660-26265-3-git-send-email-lingshan.zhu@intel.com>
Subject: Re: [PATCH 2/2] IFC VDPA layer
MIME-Version: 1.0
X-Originating-IP: [10.68.5.20, 10.4.195.26]
Thread-Topic: IFC VDPA layer
Thread-Index: 2ubD57q6mWHdEByI6cOoPF/uKOIarw==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: VCWYZjVVPzupzfwBOdEj9g-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



----- Original Message -----
> This commit introduced IFC operations for vdpa, which complys to
> virtio_mdev and vhost_mdev interfaces, handles IFC VF
> initialization, configuration and removal.
>=20
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> ---
>  drivers/vhost/ifcvf/ifcvf_main.c | 605
>  +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 605 insertions(+)
>  create mode 100644 drivers/vhost/ifcvf/ifcvf_main.c
>=20
> diff --git a/drivers/vhost/ifcvf/ifcvf_main.c
> b/drivers/vhost/ifcvf/ifcvf_main.c
> new file mode 100644
> index 0000000..7165457
> --- /dev/null
> +++ b/drivers/vhost/ifcvf/ifcvf_main.c
> @@ -0,0 +1,605 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (C) 2019 Intel Corporation.
> + */
> +
> +#include <linux/interrupt.h>
> +#include <linux/module.h>
> +#include <linux/mdev.h>
> +#include <linux/pci.h>
> +#include <linux/sysfs.h>
> +#include "ifcvf_base.h"
> +
> +#define VERSION_STRING=09"0.1"
> +#define DRIVER_AUTHOR=09"Intel Corporation"
> +#define IFCVF_DRIVER_NAME=09"ifcvf"
> +
> +static struct ifcvf_hw *mdev_to_vf(struct mdev_device *mdev)
> +{
> +=09struct ifcvf_asapter *adapter =3D mdev_get_drvdata(mdev);
> +=09struct ifcvf_hw *vf =3D IFC_PRIVATE_TO_VF(adapter);
> +
> +=09return vf;
> +}
> +
> +static irqreturn_t ifcvf_intr_handler(int irq, void *arg)
> +{
> +=09struct vring_info *vring =3D arg;
> +
> +=09if (vring->cb.callback)
> +=09=09return vring->cb.callback(vring->cb.private);
> +
> +=09return IRQ_HANDLED;
> +}
> +
> +static u64 ifcvf_mdev_get_features(struct mdev_device *mdev)
> +{
> +=09struct ifcvf_hw *vf =3D mdev_to_vf(mdev);
> +
> +=09return ifcvf_get_features(vf);
> +}
> +
> +static int ifcvf_mdev_set_features(struct mdev_device *mdev, u64 feature=
s)
> +{
> +=09struct ifcvf_hw *vf =3D mdev_to_vf(mdev);
> +
> +=09vf->req_features =3D features;
> +
> +=09return 0;
> +}
> +
> +static u64 ifcvf_mdev_get_vq_state(struct mdev_device *mdev, u16 qid)
> +{
> +=09struct ifcvf_hw *vf =3D mdev_to_vf(mdev);
> +=09u16 last_avail_idx;
> +
> +=09last_avail_idx =3D *(u16 *)(vf->lm_cfg + IFCVF_LM_RING_STATE_OFFSET +
> +=09=09=09 (qid / 2) * IFCVF_LM_CFG_SIZE + (qid % 2) * 4);
> +

Similar to the comment of previous patch, it's better to have a
structure for lm_cfg.

> +=09return last_avail_idx;
> +}
> +
> +static int ifcvf_mdev_set_vq_state(struct mdev_device *mdev, u16 qid, u6=
4
> num)
> +{
> +=09struct ifcvf_hw *vf =3D mdev_to_vf(mdev);
> +
> +=09vf->vring[qid].last_avail_idx =3D num;
> +
> +=09return 0;
> +}
> +
> +static int ifcvf_mdev_set_vq_address(struct mdev_device *mdev, u16 idx,
> +=09=09=09=09     u64 desc_area, u64 driver_area,
> +=09=09=09=09     u64 device_area)
> +{
> +=09struct ifcvf_hw *vf =3D mdev_to_vf(mdev);
> +
> +=09vf->vring[idx].desc =3D desc_area;
> +=09vf->vring[idx].avail =3D driver_area;
> +=09vf->vring[idx].used =3D device_area;
> +
> +=09return 0;
> +}
> +
> +static void ifcvf_mdev_set_vq_num(struct mdev_device *mdev, u16 qid, u32
> num)
> +{
> +=09struct ifcvf_hw *vf =3D mdev_to_vf(mdev);
> +
> +=09vf->vring[qid].size =3D num;
> +}
> +
> +static void ifcvf_mdev_set_vq_ready(struct mdev_device *mdev,
> +=09=09=09=09    u16 qid, bool ready)
> +{
> +=09struct ifcvf_hw *vf =3D mdev_to_vf(mdev);
> +
> +=09vf->vring[qid].ready =3D ready;

There should be a "iowrite16(1, &cfg->queue_enable)" here. And there's
probably no need to store ready in vring in this case.

> +}
> +
> +static bool ifcvf_mdev_get_vq_ready(struct mdev_device *mdev, u16 qid)
> +{
> +=09struct ifcvf_hw *vf =3D mdev_to_vf(mdev);
> +
> +=09return vf->vring[qid].ready;

And the status should be read from cfg->queue_enable.

> +}
> +
> +static void ifcvf_mdev_set_vq_cb(struct mdev_device *mdev, u16 idx,
> +=09=09=09=09 struct virtio_mdev_callback *cb)
> +{
> +=09struct ifcvf_hw *vf =3D mdev_to_vf(mdev);
> +
> +=09vf->vring[idx].cb =3D *cb;
> +}
> +
> +static void ifcvf_mdev_kick_vq(struct mdev_device *mdev, u16 idx)
> +{
> +=09struct ifcvf_hw *vf =3D mdev_to_vf(mdev);
> +
> +=09ifcvf_notify_queue(vf, idx);
> +}
> +
> +static u8 ifcvf_mdev_get_status(struct mdev_device *mdev)
> +{
> +=09struct ifcvf_hw *vf =3D mdev_to_vf(mdev);
> +
> +=09return ifcvf_get_status(vf);
> +}
> +
> +static u32 ifcvf_mdev_get_generation(struct mdev_device *mdev)
> +{
> +=09struct ifcvf_hw *vf =3D mdev_to_vf(mdev);
> +
> +=09return ioread8(&vf->common_cfg->config_generation);
> +}
> +
> +static u32 ifcvf_mdev_get_device_id(struct mdev_device *mdev)
> +{
> +=09return VIRTIO_ID_NET;
> +}
> +
> +static u32 ifcvf_mdev_get_vendor_id(struct mdev_device *mdev)
> +{
> +=09return IFCVF_VENDOR_ID;
> +}
> +
> +static u16 ifcvf_mdev_get_vq_align(struct mdev_device *mdev)
> +{
> +=09return IFCVF_QUEUE_ALIGNMENT;
> +}
> +
> +static u64 ifcvf_mdev_get_mdev_features(struct mdev_device *mdev)
> +{
> +=09return VIRTIO_MDEV_F_VERSION_1;
> +}

We've decide to remove this API.

> +
> +static int ifcvf_start_datapath(void *private)
> +{
> +=09struct ifcvf_hw *vf =3D IFC_PRIVATE_TO_VF(private);
> +=09struct ifcvf_adapter *ifcvf;
> +=09int i, ret =3D 0;
> +
> +=09ifcvf =3D container_of(vf, struct ifcvf_adapter, vf);
> +
> +=09for (i =3D 0; i < IFCVF_MAX_QUEUE_PAIRS * 2; i++) {
> +=09=09if (!vf->vring[i].ready) {
> +=09=09=09IFC_ERR(ifcvf->dev,
> +=09=09=09=09"Failed to start datapath, vring %d not ready.\n", i);
> +=09=09=09return -EINVAL;
> +=09=09}

This should be not related. Driver can choose to not start a virtqueue.

> +
> +=09=09if (!vf->vring[i].size) {
> +=09=09=09IFC_ERR(ifcvf->dev,
> +=09=09=09=09"Failed to start datapath, vring %d size is zero.\n", i);
> +=09=09=09return -EINVAL;
> +=09=09}
> +
> +=09=09if (!vf->vring[i].desc || !vf->vring[i].avail ||
> +=09=09=09!vf->vring[i].used) {
> +=09=09=09IFC_ERR(ifcvf->dev,
> +=09=09=09=09"Failed to start datapath, "
> +=09=09=09=09"invaild value for vring %d desc,"
> +=09=09=09=09"avail_idx or usex_idx.\n", i);
> +=09=09=09return -EINVAL;
> +=09=09}
> +=09}
> +
> +=09vf->nr_vring =3D i;
> +=09ret =3D ifcvf_start_hw(vf);

So basically there's no need for ifcvf_start_hw() to care about vq
enablement, virtio core will take care of that through set_vq_ready().

> +
> +=09return ret;
> +}
> +
> +static int ifcvf_stop_datapath(void *private)
> +{
> +=09struct ifcvf_hw *vf =3D IFC_PRIVATE_TO_VF(private);
> +=09int i;
> +
> +=09for (i =3D 0; i < IFCVF_MAX_QUEUES; i++)
> +=09=09vf->vring[i].cb.callback =3D NULL;
> +
> +=09ifcvf_stop_hw(vf);
> +
> +=09return 0;
> +}
> +
> +static void ifcvf_reset_vring(struct ifcvf_adapter *adapter)
> +{
> +=09struct ifcvf_hw *vf =3D IFC_PRIVATE_TO_VF(adapter);
> +=09struct virtio_pci_common_cfg *cfg;
> +=09u8 *lm_cfg;
> +=09int i;
> +
> +=09cfg =3D vf->common_cfg;
> +=09lm_cfg =3D vf->lm_cfg;
> +
> +=09for (i =3D 0; i < IFCVF_MAX_QUEUE_PAIRS * 2; i++) {
> +=09=09vf->vring[i].last_used_idx =3D 0;
> +=09=09vf->vring[i].last_avail_idx =3D 0;
> +=09=09vf->vring[i].desc =3D 0;
> +=09=09vf->vring[i].avail =3D 0;
> +=09=09vf->vring[i].used =3D 0;
> +=09=09vf->vring[i].ready =3D 0;
> +=09=09vf->vring->cb.callback =3D NULL;
> +=09=09vf->vring->cb.private =3D NULL;
> +
> +=09}
> +
> +=09ifcvf_reset(vf);

So virtio-pci call vp_synchornize_vectors(), do need someting similar
here (I mean in ifcvf_reset())?

> +}
> +
> +static void ifcvf_mdev_set_status(struct mdev_device *mdev, u8 status)
> +{
> +=09struct ifcvf_adapter *adapter =3D mdev_get_drvdata(mdev);
> +=09struct ifcvf_hw *vf =3D IFC_PRIVATE_TO_VF(adapter);
> +=09int ret =3D 0;
> +
> +=09if (status =3D=3D 0) {
> +=09=09ifcvf_stop_datapath(adapter);
> +=09=09ifcvf_reset_vring(adapter);
> +=09=09return;
> +=09}
> +
> +=09if (status & VIRTIO_CONFIG_S_DRIVER_OK) {
> +=09=09ret =3D ifcvf_start_datapath(adapter);

If device support VIRTIO_CONFIG_S_DRIVER_OK, having something like
start_datapath here looks wired.

If it just to setup the virtqueue etc, can we simply move them to e.g
set_vq_num, set_vq_address, etc?

> +
> +=09=09if (ret)
> +=09=09=09IFC_ERR(adapter->dev, "Failed to set mdev status %u.\n",
> +=09=09=09=09status);
> +=09}
> +
> +=09ifcvf_set_status(vf, status);
> +}
> +
> +static u16 ifcvf_mdev_get_vq_num_max(struct mdev_device *mdev)
> +{
> +=09struct ifcvf_hw *vf =3D mdev_to_vf(mdev);
> +
> +=09return vf->vring[0].size;

It looks to me the only case that size is set is from
ifcvf_mdev_set_vq_num()? So I don't get how is this supposed to
work. I belive this should be a query for the hardware or a at least a
macro?


> +}
> +static void ifcvf_mdev_get_config(struct mdev_device *mdev, unsigned int
> offset,
> +=09=09=09     void *buf, unsigned int len)
> +{
> +=09struct ifcvf_hw *vf =3D mdev_to_vf(mdev);
> +
> +=09WARN_ON(offset + len > sizeof(struct ifcvf_net_config));
> +=09ifcvf_read_net_config(vf, offset, buf, len);
> +}
> +
> +static void ifcvf_mdev_set_config(struct mdev_device *mdev, unsigned int
> offset,
> +=09=09=09     const void *buf, unsigned int len)
> +{
> +=09struct ifcvf_hw *vf =3D mdev_to_vf(mdev);
> +
> +=09WARN_ON(offset + len > sizeof(struct ifcvf_net_config));
> +=09ifcvf_write_net_config(vf, offset, buf, len);
> +}
> +
> +static struct virtio_mdev_device_ops ifc_mdev_ops =3D {
> +=09.get_features  =3D ifcvf_mdev_get_features,
> +=09.set_features  =3D ifcvf_mdev_set_features,
> +=09.get_status    =3D ifcvf_mdev_get_status,
> +=09.set_status    =3D ifcvf_mdev_set_status,
> +=09.get_vq_num_max =3D ifcvf_mdev_get_vq_num_max,
> +=09.get_vq_state   =3D ifcvf_mdev_get_vq_state,
> +=09.set_vq_state   =3D ifcvf_mdev_set_vq_state,
> +=09.set_vq_cb      =3D ifcvf_mdev_set_vq_cb,
> +=09.set_vq_ready   =3D ifcvf_mdev_set_vq_ready,
> +=09.get_vq_ready=09=3D ifcvf_mdev_get_vq_ready,
> +=09.set_vq_num     =3D ifcvf_mdev_set_vq_num,
> +=09.set_vq_address =3D ifcvf_mdev_set_vq_address,
> +=09.kick_vq        =3D ifcvf_mdev_kick_vq,
> +=09.get_generation=09=3D ifcvf_mdev_get_generation,
> +=09.get_device_id=09=3D ifcvf_mdev_get_device_id,
> +=09.get_vendor_id=09=3D ifcvf_mdev_get_vendor_id,
> +=09.get_vq_align=09=3D ifcvf_mdev_get_vq_align,
> +=09.get_config=09=3D ifcvf_mdev_get_config,
> +=09.set_config=09=3D ifcvf_mdev_set_config,
> +=09.get_mdev_features =3D ifcvf_mdev_get_mdev_features,

set_config_cb needs to be implemented since you claim to support VIRTIO_NET=
_F_STATUS.

> +};
> +
> +static int ifcvf_init_msix(struct ifcvf_adapter *adapter)
> +{
> +=09struct pci_dev *pdev =3D to_pci_dev(adapter->dev);
> +=09struct ifcvf_hw *vf =3D &adapter->vf;
> +=09int vector, i, ret, irq;
> +
> +=09ret =3D pci_alloc_irq_vectors(pdev, IFCVF_MAX_INTR,
> +=09=09=09=09    IFCVF_MAX_INTR, PCI_IRQ_MSIX);
> +=09if (ret < 0) {
> +=09=09IFC_ERR(adapter->dev, "Failed to alloc irq vectors.\n");
> +=09=09return ret;
> +=09}
> +
> +=09for (i =3D 0; i < IFCVF_MAX_QUEUE_PAIRS * 2; i++) {
> +=09=09vector =3D i + IFCVF_MSI_QUEUE_OFF;
> +=09=09irq =3D pci_irq_vector(pdev, vector);
> +=09=09ret =3D request_irq(irq, ifcvf_intr_handler, 0,
> +=09=09=09=09pci_name(pdev), &vf->vring[i]);
> +=09=09if (ret) {
> +=09=09=09IFC_ERR(adapter->dev,
> +=09=09=09=09"Failed to request irq for vq %d.\n", i);
> +=09=09=09return ret;
> +=09=09}
> +=09}

Need allocate config interrupt here as well.

> +
> +=09return 0;
> +}
> +
> +static void ifcvf_destroy_adapter(struct ifcvf_adapter *adapter)
> +{
> +=09struct ifcvf_hw *vf =3D IFC_PRIVATE_TO_VF(adapter);
> +=09struct pci_dev *pdev =3D to_pci_dev(adapter->dev);
> +=09int i, vector, irq;
> +
> +=09for (i =3D 0; i < IFCVF_MAX_QUEUE_PAIRS * 2; i++) {
> +=09=09vector =3D i + IFCVF_MSI_QUEUE_OFF;
> +=09=09irq =3D pci_irq_vector(pdev, vector);
> +=09=09free_irq(irq, &vf->vring[i]);
> +=09}
> +}
> +
> +static ssize_t name_show(struct kobject *kobj, struct device *dev, char
> *buf)
> +{
> +=09const char *name =3D "vhost accelerator (virtio ring compatible)";
> +

I believe something like "IFCVF vhost/virtio accelerator" is better?

> +=09return sprintf(buf, "%s\n", name);
> +}
> +MDEV_TYPE_ATTR_RO(name);
> +
> +static ssize_t device_api_show(struct kobject *kobj, struct device *dev,
> +=09=09=09       char *buf)
> +{
> +=09return sprintf(buf, "%s\n", VIRTIO_MDEV_DEVICE_API_STRING);
> +}
> +MDEV_TYPE_ATTR_RO(device_api);
> +
> +static ssize_t available_instances_show(struct kobject *kobj,
> +=09=09=09=09=09struct device *dev, char *buf)
> +{
> +=09struct pci_dev *pdev;
> +=09struct ifcvf_adapter *adapter;
> +
> +=09pdev =3D to_pci_dev(dev);
> +=09adapter =3D pci_get_drvdata(pdev);
> +
> +=09return sprintf(buf, "%d\n", adapter->mdev_count);
> +}
> +
> +MDEV_TYPE_ATTR_RO(available_instances);
> +
> +static ssize_t type_show(struct kobject *kobj,
> +=09=09=09struct device *dev, char *buf)
> +{
> +=09return sprintf(buf, "%s\n", "net");
> +}
> +
> +MDEV_TYPE_ATTR_RO(type);
> +
> +
> +static struct attribute *mdev_types_attrs[] =3D {
> +=09&mdev_type_attr_name.attr,
> +=09&mdev_type_attr_device_api.attr,
> +=09&mdev_type_attr_available_instances.attr,
> +=09&mdev_type_attr_type.attr,
> +=09NULL,
> +};
> +
> +static struct attribute_group mdev_type_group_virtio =3D {
> +=09.name  =3D "virtio_mdev",
> +=09.attrs =3D mdev_types_attrs,
> +};
> +
> +static struct attribute_group mdev_type_group_vhost =3D {
> +=09.name  =3D "vhost_mdev",
> +=09.attrs =3D mdev_types_attrs,
> +};
> +
> +static struct attribute_group *mdev_type_groups[] =3D {
> +=09&mdev_type_group_virtio,
> +=09&mdev_type_group_vhost,
> +=09NULL,
> +};
> +
> +const struct attribute_group *mdev_dev_groups[] =3D {
> +=09NULL,
> +};
> +
> +static int ifcvf_mdev_create(struct kobject *kobj, struct mdev_device *m=
dev)
> +{
> +=09struct device *dev =3D mdev_parent_dev(mdev);
> +=09struct pci_dev *pdev =3D to_pci_dev(dev);
> +=09struct ifcvf_adapter *adapter =3D pci_get_drvdata(pdev);
> +=09int ret =3D 0;
> +
> +=09mutex_lock(&adapter->mdev_lock);
> +
> +=09if (adapter->mdev_count < IFCVF_MDEV_LIMIT) {
> +=09=09IFC_ERR(&pdev->dev,
> +=09=09=09"Can not create mdev, reached limitation %d.\n",
> +=09=09=09IFCVF_MDEV_LIMIT);
> +=09=09ret =3D -EINVAL;
> +=09=09goto out;
> +=09}
> +
> +=09if (!strcmp(kobj->name, "ifcvf-virtio_mdev"))
> +=09=09mdev_set_virtio_ops(mdev, &ifc_mdev_ops);
> +
> +=09if (!strcmp(kobj->name, "ifcvf-vhost_mdev"))
> +=09=09mdev_set_vhost_ops(mdev, &ifc_mdev_ops);
> +
> +=09mdev_set_drvdata(mdev, adapter);
> +=09mdev_set_iommu_device(mdev_dev(mdev), dev);
> +=09adapter->mdev_count--;
> +
> +out:
> +=09mutex_unlock(&adapter->mdev_lock);
> +=09return ret;
> +}
> +
> +static int ifcvf_mdev_remove(struct mdev_device *mdev)
> +{
> +=09struct device *dev =3D mdev_parent_dev(mdev);
> +=09struct pci_dev *pdev =3D to_pci_dev(dev);
> +=09struct ifcvf_adapter *adapter =3D pci_get_drvdata(pdev);
> +
> +=09mutex_lock(&adapter->mdev_lock);
> +=09adapter->mdev_count++;
> +=09mutex_unlock(&adapter->mdev_lock);
> +
> +=09return 0;
> +}
> +
> +static struct mdev_parent_ops ifcvf_mdev_fops =3D {
> +=09.owner=09=09=09=3D THIS_MODULE,
> +=09.supported_type_groups=09=3D mdev_type_groups,
> +=09.mdev_attr_groups=09=3D mdev_dev_groups,
> +=09.create=09=09=09=3D ifcvf_mdev_create,
> +=09.remove=09=09=09=3D ifcvf_mdev_remove,
> +};
> +
> +static int ifcvf_probe(struct pci_dev *pdev, const struct pci_device_id =
*id)
> +{
> +=09struct device *dev =3D &pdev->dev;
> +=09struct ifcvf_adapter *adapter;
> +=09struct ifcvf_hw *vf;
> +=09int ret, i;
> +
> +=09adapter =3D kzalloc(sizeof(struct ifcvf_adapter), GFP_KERNEL);
> +
> +=09if (adapter =3D=3D NULL) {
> +=09=09ret =3D -ENOMEM;
> +=09=09goto fail;
> +=09}
> +
> +=09mutex_init(&adapter->mdev_lock);
> +=09adapter->mdev_count =3D IFCVF_MDEV_LIMIT;
> +=09adapter->dev =3D dev;
> +=09pci_set_drvdata(pdev, adapter);
> +=09ret =3D pci_enable_device(pdev);
> +
> +=09if (ret) {
> +=09=09IFC_ERR(adapter->dev, "Failed to enable device.\n");
> +=09=09goto free_adapter;
> +=09}
> +
> +=09ret =3D pci_request_regions(pdev, IFCVF_DRIVER_NAME);
> +
> +=09if (ret) {
> +=09=09IFC_ERR(adapter->dev, "Failed to request MMIO region.\n");
> +=09=09goto disable_device;
> +=09}
> +
> +=09pci_set_master(pdev);
> +=09ret =3D ifcvf_init_msix(adapter);
> +
> +=09if (ret) {
> +=09=09IFC_ERR(adapter->dev, "Failed to initialize MSIX.\n");
> +=09=09goto free_msix;
> +=09}
> +
> +=09vf =3D &adapter->vf;
> +
> +=09for (i =3D 0; i < IFCVF_PCI_MAX_RESOURCE; i++) {
> +=09=09vf->mem_resource[i].phys_addr =3D pci_resource_start(pdev, i);
> +=09=09vf->mem_resource[i].len =3D pci_resource_len(pdev, i);
> +=09=09if (!vf->mem_resource[i].len) {
> +=09=09=09vf->mem_resource[i].addr =3D NULL;
> +=09=09=09continue;
> +=09=09}
> +
> +=09=09vf->mem_resource[i].addr =3D pci_iomap_range(pdev, i, 0,
> +=09=09=09=09vf->mem_resource[i].len);
> +=09=09if (!vf->mem_resource[i].addr) {
> +=09=09=09IFC_ERR(adapter->dev, "Failed to map IO resource %d\n",
> +=09=09=09=09i);
> +=09=09=09ret =3D -1;
> +=09=09=09goto free_msix;
> +=09=09}
> +=09}
> +
> +=09if (ifcvf_init_hw(vf, pdev) < 0) {
> +=09=09ret =3D -1;
> +=09=09goto destroy_adapter;
> +=09}
> +
> +=09ret =3D mdev_register_device(dev, &ifcvf_mdev_fops);
> +
> +=09if (ret) {
> +=09=09IFC_ERR(adapter->dev,  "Failed to register mdev device\n");
> +=09=09goto destroy_adapter;
> +=09}
> +
> +=09return 0;
> +
> +destroy_adapter:
> +=09ifcvf_destroy_adapter(adapter);
> +free_msix:
> +=09pci_free_irq_vectors(pdev);
> +=09pci_release_regions(pdev);
> +disable_device:
> +=09pci_disable_device(pdev);
> +free_adapter:
> +=09kfree(adapter);
> +fail:
> +=09return ret;
> +}
> +
> +static void ifcvf_remove(struct pci_dev *pdev)
> +{
> +=09struct ifcvf_adapter *adapter =3D pci_get_drvdata(pdev);
> +=09struct device *dev =3D &pdev->dev;
> +=09struct ifcvf_hw *vf;
> +=09int i;
> +
> +=09mdev_unregister_device(dev);
> +
> +=09vf =3D &adapter->vf;
> +=09for (i =3D 0; i < IFCVF_PCI_MAX_RESOURCE; i++) {
> +=09=09if (vf->mem_resource[i].addr) {
> +=09=09=09pci_iounmap(pdev, vf->mem_resource[i].addr);
> +=09=09=09vf->mem_resource[i].addr =3D NULL;
> +=09=09}
> +=09}
> +
> +=09ifcvf_destroy_adapter(adapter);
> +=09pci_free_irq_vectors(pdev);
> +=09pci_release_regions(pdev);
> +=09pci_disable_device(pdev);
> +=09kfree(adapter);
> +}
> +
> +static struct pci_device_id ifcvf_pci_ids[] =3D {
> +=09{ PCI_DEVICE_SUB(IFCVF_VENDOR_ID,
> +=09=09=09IFCVF_DEVICE_ID,
> +=09=09=09IFCVF_SUBSYS_VENDOR_ID,
> +=09=09=09IFCVF_SUBSYS_DEVICE_ID) },
> +=09{ 0 },
> +};
> +MODULE_DEVICE_TABLE(pci, ifcvf_pci_ids);
> +
> +static struct pci_driver ifcvf_driver =3D {
> +=09.name     =3D IFCVF_DRIVER_NAME,
> +=09.id_table =3D ifcvf_pci_ids,
> +=09.probe    =3D ifcvf_probe,
> +=09.remove   =3D ifcvf_remove,
> +};
> +
> +static int __init ifcvf_init_module(void)
> +{
> +=09int ret;
> +
> +=09ret =3D pci_register_driver(&ifcvf_driver);
> +=09return ret;
> +}
> +
> +static void __exit ifcvf_exit_module(void)
> +{
> +=09pci_unregister_driver(&ifcvf_driver);
> +}

You probably can do something simpler thorugh module_pci_driver().

Thanks

> +
> +module_init(ifcvf_init_module);
> +module_exit(ifcvf_exit_module);
> +
> +MODULE_LICENSE("GPL v2");
> +MODULE_VERSION(VERSION_STRING);
> +MODULE_AUTHOR(DRIVER_AUTHOR);
> --
> 1.8.3.1
>=20
>=20

