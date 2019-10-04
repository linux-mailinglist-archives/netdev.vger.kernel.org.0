Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F272CC406
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 22:12:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387473AbfJDUMY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 16:12:24 -0400
Received: from mga02.intel.com ([134.134.136.20]:1572 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731058AbfJDUMY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Oct 2019 16:12:24 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Oct 2019 13:12:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,257,1566889200"; 
   d="asc'?scan'208";a="192525820"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga007.fm.intel.com with ESMTP; 04 Oct 2019 13:12:22 -0700
Message-ID: <04e8a95837ba8f6a0b1d001dff2e905f5c6311b4.camel@intel.com>
Subject: Re: [RFC 04/20] RDMA/irdma: Add driver framework definitions
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Reply-To: jeffrey.t.kirsher@intel.com
To:     Leon Romanovsky <leon@kernel.org>
Cc:     dledford@redhat.com, jgg@mellanox.com, gregkh@linuxfoundation.org,
        Mustafa Ismail <mustafa.ismail@intel.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        Shiraz Saleem <shiraz.saleem@intel.com>
Date:   Fri, 04 Oct 2019 13:12:22 -0700
In-Reply-To: <20190926173046.GB14368@unreal>
References: <20190926164519.10471-1-jeffrey.t.kirsher@intel.com>
         <20190926164519.10471-5-jeffrey.t.kirsher@intel.com>
         <20190926173046.GB14368@unreal>
Organization: Intel
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-K3X9WgFubrrEIBoAOC9/"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-K3X9WgFubrrEIBoAOC9/
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2019-09-26 at 20:30 +0300, Leon Romanovsky wrote:
> On Thu, Sep 26, 2019 at 09:45:03AM -0700, Jeff Kirsher wrote:
> > From: Mustafa Ismail <mustafa.ismail@intel.com>
> >=20
> > Register irdma as a platform driver capable of supporting platform
> > devices from multi-generation RDMA capable Intel HW. Establish the
> > interface with all supported netdev peer devices and initialize HW.
> >=20
> > Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
> > Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
> > Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> > ---
> >  drivers/infiniband/hw/irdma/i40iw_if.c | 270 +++++++++++
> >  drivers/infiniband/hw/irdma/irdma_if.c | 436 +++++++++++++++++
> >  drivers/infiniband/hw/irdma/main.c     | 531 ++++++++++++++++++++
> >  drivers/infiniband/hw/irdma/main.h     | 639
> > +++++++++++++++++++++++++
> >  4 files changed, 1876 insertions(+)
> >  create mode 100644 drivers/infiniband/hw/irdma/i40iw_if.c
> >  create mode 100644 drivers/infiniband/hw/irdma/irdma_if.c
> >  create mode 100644 drivers/infiniband/hw/irdma/main.c
> >  create mode 100644 drivers/infiniband/hw/irdma/main.h
> >=20
> > diff --git a/drivers/infiniband/hw/irdma/i40iw_if.c
> > b/drivers/infiniband/hw/irdma/i40iw_if.c
> > new file mode 100644
> > index 000000000000..3cddb091acfb
> > --- /dev/null
> > +++ b/drivers/infiniband/hw/irdma/i40iw_if.c
> > @@ -0,0 +1,270 @@
> > +// SPDX-License-Identifier: GPL-2.0 or Linux-OpenIB
> > +/* Copyright (c) 2019, Intel Corporation. */
> > +
> > +#include <linux/module.h>
> > +#include <linux/moduleparam.h>
> > +#include <linux/netdevice.h>
> > +#include <linux/etherdevice.h>
> > +#include <net/addrconf.h>
> > +#include "main.h"
> > +#include "i40iw_hw.h"
> > +#include <linux/net/intel/i40e_client.h>
> > +
> > +/**
> > + * i40iw_request_reset - Request a reset
> > + * @rf: RDMA PCI function
> > + *
> > + */
> > +void i40iw_request_reset(struct irdma_pci_f *rf)
> > +{
> > +	struct i40e_info *ldev =3D (struct i40e_info *)rf->ldev.if_ldev;
> > +
> > +	ldev->ops->request_reset(ldev, rf->ldev.if_client, 1);
> > +}
> > +
> > +/**
> > + * i40iw_open - client interface operation open for iwarp/uda
> > device
> > + * @ldev: LAN device information
> > + * @client: iwarp client information, provided during registration
> > + *
> > + * Called by the LAN driver during the processing of client
> > register
> > + * Create device resources, set up queues, pble and hmc objects
> > and
> > + * register the device with the ib verbs interface
> > + * Return 0 if successful, otherwise return error
> > + */
> > +static int i40iw_open(struct i40e_info *ldev, struct i40e_client
> > *client)
> > +{
> > +	struct irdma_l2params l2params =3D {};
> > +	struct irdma_device *iwdev =3D NULL;
> > +	struct irdma_handler *hdl =3D NULL;
> > +	struct irdma_priv_ldev *pldev;
> > +	u16 last_qset =3D IRDMA_NO_QSET;
> > +	struct irdma_sc_dev *dev;
> > +	struct irdma_pci_f *rf;
> > +	int err_code =3D -EIO;
> > +	u16 qset;
> > +	int i;
> > +
> > +	hdl =3D irdma_find_handler(ldev->pcidev);
> > +	if (hdl)
> > +		return 0;
> > +
> > +	hdl =3D kzalloc((sizeof(*hdl) + sizeof(*iwdev)), GFP_KERNEL);
> > +	if (!hdl)
> > +		return -ENOMEM;
> > +
> > +	iwdev =3D (struct irdma_device *)((u8 *)hdl + sizeof(*hdl));
> > +
> > +	iwdev->param_wq =3D alloc_ordered_workqueue("l2params",
> > WQ_MEM_RECLAIM);
> > +	if (!iwdev->param_wq)
> > +		goto error;
> > +
> > +	rf =3D &hdl->rf;
> > +	rf->hdl =3D hdl;
> > +	dev =3D &rf->sc_dev;
> > +	dev->back_dev =3D rf;
> > +	rf->rdma_ver =3D IRDMA_GEN_1;
> > +	hdl->platform_dev =3D ldev->platform_dev;
> > +	irdma_init_rf_config_params(rf);
> > +	rf->init_hw =3D i40iw_init_hw;
> > +	rf->hw.hw_addr =3D ldev->hw_addr;
> > +	rf->pdev =3D ldev->pcidev;
> > +	rf->netdev =3D ldev->netdev;
> > +	dev->pci_rev =3D rf->pdev->revision;
> > +	iwdev->rf =3D rf;
> > +	iwdev->hdl =3D hdl;
> > +	iwdev->ldev =3D &rf->ldev;
> > +	iwdev->init_state =3D INITIAL_STATE;
> > +	iwdev->rcv_wnd =3D IRDMA_CM_DEFAULT_RCV_WND_SCALED;
> > +	iwdev->rcv_wscale =3D IRDMA_CM_DEFAULT_RCV_WND_SCALE;
> > +	iwdev->netdev =3D ldev->netdev;
> > +	iwdev->create_ilq =3D true;
> > +	iwdev->vsi_num =3D 0;
> > +
> > +	pldev =3D &rf->ldev;
> > +	hdl->ldev =3D pldev;
> > +	pldev->if_client =3D client;
> > +	pldev->if_ldev =3D ldev;
> > +	pldev->fn_num =3D ldev->fid;
> > +	pldev->ftype =3D ldev->ftype;
> > +	pldev->pf_vsi_num =3D 0;
> > +	pldev->msix_count =3D ldev->msix_count;
> > +	pldev->msix_entries =3D ldev->msix_entries;
> > +
> > +	if (irdma_ctrl_init_hw(rf))
> > +		goto error;
> > +
> > +	l2params.mtu =3D
> > +		(ldev->params.mtu) ? ldev->params.mtu :
> > IRDMA_DEFAULT_MTU;
> > +	for (i =3D 0; i < I40E_CLIENT_MAX_USER_PRIORITY; i++) {
> > +		qset =3D ldev->params.qos.prio_qos[i].qs_handle;
> > +		l2params.up2tc[i] =3D ldev->params.qos.prio_qos[i].tc;
> > +		l2params.qs_handle_list[i] =3D qset;
> > +		if (last_qset =3D=3D IRDMA_NO_QSET)
> > +			last_qset =3D qset;
> > +		else if ((qset !=3D last_qset) && (qset !=3D
> > IRDMA_NO_QSET))
> > +			iwdev->dcb =3D true;
> > +	}
> > +
> > +	if (irdma_rt_init_hw(rf, iwdev, &l2params)) {
> > +		irdma_deinit_ctrl_hw(rf);
> > +		goto error;
> > +	}
> > +
> > +	irdma_add_handler(hdl);
> > +	return 0;
> > +error:
> > +	kfree(hdl);
> > +	return err_code;
> > +}
> > +
> > +/**
> > + * i40iw_l2params_worker - worker for l2 params change
> > + * @work: work pointer for l2 params
> > + */
> > +static void i40iw_l2params_worker(struct work_struct *work)
> > +{
> > +	struct l2params_work *dwork =3D
> > +		container_of(work, struct l2params_work, work);
> > +	struct irdma_device *iwdev =3D dwork->iwdev;
> > +
> > +	irdma_change_l2params(&iwdev->vsi, &dwork->l2params);
> > +	atomic_dec(&iwdev->params_busy);
> > +	kfree(work);
> > +}
> > +
> > +/**
> > + * i40iw_l2param_change - handle qs handles for QoS and MSS change
> > + * @ldev: LAN device information
> > + * @client: client for parameter change
> > + * @params: new parameters from L2
> > + */
> > +static void i40iw_l2param_change(struct i40e_info *ldev,
> > +				 struct i40e_client *client,
> > +				 struct i40e_params *params)
> > +{
> > +	struct irdma_l2params *l2params;
> > +	struct l2params_work *work;
> > +	struct irdma_device *iwdev;
> > +	struct irdma_handler *hdl;
> > +	int i;
> > +
> > +	hdl =3D irdma_find_handler(ldev->pcidev);
> > +	if (!hdl)
> > +		return;
> > +
> > +	iwdev =3D (struct irdma_device *)((u8 *)hdl + sizeof(*hdl));
> > +
> > +	if (atomic_read(&iwdev->params_busy))
> > +		return;
> > +	work =3D kzalloc(sizeof(*work), GFP_KERNEL);
> > +	if (!work)
> > +		return;
> > +
> > +	atomic_inc(&iwdev->params_busy);
>=20
> Changing parameters through workqueue and perform locking with
> atomic_t, exciting.
> Please do proper locking scheme and better to avoid workqueue at all.
>=20
> <...>
>=20
> > +/* client interface functions */
> > +static const struct i40e_client_ops i40e_ops =3D {
> > +	.open =3D i40iw_open,
> > +	.close =3D i40iw_close,
> > +	.l2_param_change =3D i40iw_l2param_change
> > +};
> > +
> > +static struct i40e_client i40iw_client =3D {
> > +	.name =3D "irdma",
> > +	.ops =3D &i40e_ops,
> > +	.version.major =3D I40E_CLIENT_VERSION_MAJOR,
> > +	.version.minor =3D I40E_CLIENT_VERSION_MINOR,
> > +	.version.build =3D I40E_CLIENT_VERSION_BUILD,
> > +	.type =3D I40E_CLIENT_IWARP,
> > +};
> > +
> > +int i40iw_probe(struct platform_device *pdev)
> > +{
> > +	struct i40e_peer_dev_platform_data *pdata =3D
> > +		dev_get_platdata(&pdev->dev);
> > +	struct i40e_info *ldev;
> > +
> > +	if (!pdata)
> > +		return -EINVAL;
> > +
> > +	ldev =3D pdata->ldev;
> > +
> > +	if (ldev->version.major !=3D I40E_CLIENT_VERSION_MAJOR ||
> > +	    ldev->version.minor !=3D I40E_CLIENT_VERSION_MINOR) {
> > +		pr_err("version mismatch:\n");
> > +		pr_err("expected major ver %d, caller specified major
> > ver %d\n",
> > +		       I40E_CLIENT_VERSION_MAJOR, ldev->version.major);
> > +		pr_err("expected minor ver %d, caller specified minor
> > ver %d\n",
> > +		       I40E_CLIENT_VERSION_MINOR, ldev->version.minor);
> > +		return -EINVAL;
> > +	}
>=20
> This is can't be in upstream code, we don't support out-of-tree
> modules,
> everything else will have proper versions.

Who is the "we" in this context?  I am sure that all the Linux
distributions would strongly disagree with this stance.  Whether or not
you support out-of-tree drivers, they do exist and this code would
ensure that if a "out-of-tree" driver is loaded, the driver will do a
sanity check to ensure the RDMA driver will work.

--=-K3X9WgFubrrEIBoAOC9/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiTyZWz+nnTrOJ1LZ5W/vlVpL7c4FAl2Xp6YACgkQ5W/vlVpL
7c68lA//bY+fHiYgaFl9QspYqCgfuL3ILXJK1OIzNi2BJuTx2tUvokzIul/hCzMx
Nl2TdXVs/R2kok9H01Ufitw52deWx10exT0cJhDxAOCbLR4ZJK0QovRenxibApGM
TAyVcfVCb28QnZ47DySlu5rBSQ8sDOY0QDOOXop9FfxEXFg69tMJLxB7si8Ncv66
75SDr91jUfCTqQUyuHg8Mp0S+KlYTWISkT7J1jePy2LhQZUvSKjHvJfTA5o/E5Ro
p6O9af7eF2g3utoB7AkOBDVD9gLIHD0bqW3IPshQYMWUe0VFRh8yMDj7hchpECws
fnvZ2iul5801sGvHkRSl6KN1BxrY4cJe/BfXgIjVJrtxSYf80nbzfOYdbua1NcNK
dkhUGmZymnVcj1/iyQ3PzYZHV/g2a3/gpHGwUZ0HgSokKeuGvmdJ/f+Q4J+okyhT
o7c5dZJcbKJY/2TkfW35d4aHjcmWFuHUdrq3nf59IhxBP0kOgDiIaGfxTpdva3w5
thVz/w3oU75BJOBaerYNB271DruHNFANvdkwLi/3gnO5kYRRLmp2eaCqJDbU04zt
z6461oBUdPBFjd3Ql4Ly+m/JChmAZutMOTxpCOOMPLR13FTdpPls3VHANMhmydU2
wOUbDgLIbP7e67YAneVWIeNDMdzSuF8tkragEALZdDJcI2xZW+Y=
=L2JZ
-----END PGP SIGNATURE-----

--=-K3X9WgFubrrEIBoAOC9/--

