Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 563421167B
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 11:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726231AbfEBJU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 05:20:26 -0400
Received: from mga18.intel.com ([134.134.136.126]:20806 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726202AbfEBJU0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 May 2019 05:20:26 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 May 2019 02:20:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,421,1549958400"; 
   d="asc'?scan'208";a="342664452"
Received: from vbhyrapu-mobl.amr.corp.intel.com ([10.252.138.72])
  by fmsmga005.fm.intel.com with ESMTP; 02 May 2019 02:20:25 -0700
Message-ID: <74f5b137ac9af4bbceb7ba08d2de94e972e0fda4.camel@intel.com>
Subject: Re: [net-next 12/12] i40e: Introduce recovery mode support
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     davem@davemloft.net, Alice Michael <alice.michael@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Piotr Marczak <piotr.marczak@intel.com>,
        Don Buchholz <donald.buchholz@intel.com>
Date:   Thu, 02 May 2019 02:20:24 -0700
In-Reply-To: <20190429210755.0de283ed@cakuba>
References: <20190429191628.31212-1-jeffrey.t.kirsher@intel.com>
         <20190429191628.31212-13-jeffrey.t.kirsher@intel.com>
         <20190429210755.0de283ed@cakuba>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-28NwW8wvmwfnvd8jxxKn"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-28NwW8wvmwfnvd8jxxKn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2019-04-29 at 21:07 -0400, Jakub Kicinski wrote:
> On Mon, 29 Apr 2019 12:16:28 -0700, Jeff Kirsher wrote:
> > From: Alice Michael <alice.michael@intel.com>
> >=20
> > This patch introduces "recovery mode" to the i40e driver. It is
> > part of a new Any2Any idea of upgrading the firmware. In this
> > approach, it is required for the driver to have support for
> > "transition firmware", that is used for migrating from structured
> > to flat firmware image. In this new, very basic mode, i40e driver
> > must be able to handle particular IOCTL calls from the NVM Update
> > Tool and run a small set of AQ commands.
>=20
> Could you show us commands that get executed?  I think that'd be much
> quicker for people to parse.
>=20
> > Signed-off-by: Alice Michael <alice.michael@intel.com>
> > Signed-off-by: Piotr Marczak <piotr.marczak@intel.com>
> > Tested-by: Don Buchholz <donald.buchholz@intel.com>
> > Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
>=20
> From a cursory look it seems you create a "basic" netdev.  Can this
> netdev pass traffic?
>=20
> I'd suggest you implement devlink "limp mode".  Devlink can flash the
> device now.  You can register a devlink instance without registering
> any "minimal" netdevs, and flash with devlink.

Good to know, currently this driver and our other LAN drivers do not have
devlink support, but we are currently working to rectify that.  I am hoping
that we can get devlink support in i40e and other drivers in the 5.3 or 5.4
kernel. =20

Alice has updated this patch to add the requested additional information to
the patch description and cleaned up the code not intended for the Linux
kernel driver.  So I will resubmit this series with the updates, once it
goes through our validation checks.

>=20
> > @@ -13904,6 +14007,134 @@ void i40e_set_fec_in_flags(u8 fec_cfg, u32
> > *flags)
> >  		*flags &=3D ~(I40E_FLAG_RS_FEC | I40E_FLAG_BASE_R_FEC);
> >  }
> > =20
> > +/**
> > + * i40e_check_recovery_mode - check if we are running transition
> > firmware
> > + * @pf: board private structure
> > + *
> > + * Check registers indicating the firmware runs in recovery mode. Sets
> > the
> > + * appropriate driver state.
> > + *
> > + * Returns true if the recovery mode was detected, false otherwise
> > + **/
> > +static bool i40e_check_recovery_mode(struct i40e_pf *pf)
> > +{
> > +	u32 val =3D rd32(&pf->hw, I40E_GL_FWSTS);
> > +
> > +	if (val & I40E_GL_FWSTS_FWS1B_MASK) {
> > +		dev_notice(&pf->pdev->dev, "Firmware recovery mode
> > detected. Limiting functionality.\n");
> > +		dev_notice(&pf->pdev->dev, "Refer to the Intel(R) Ethernet
> > Adapters and Devices User Guide for details on firmware recovery
> > mode.\n");
> > +		set_bit(__I40E_RECOVERY_MODE, pf->state);
> > +
> > +		return true;
> > +	}
> > +	if (test_and_clear_bit(__I40E_RECOVERY_MODE, pf->state))
> > +		dev_info(&pf->pdev->dev, "Reinitializing in normal mode
> > with full functionality.\n");
> > +
> > +	return false;
> > +}
> > +
> > +/**
> > + * i40e_init_recovery_mode - initialize subsystems needed in recovery
> > mode
> > + * @pf: board private structure
> > + * @hw: ptr to the hardware info
> > + *
> > + * This function does a minimal setup of all subsystems needed for
> > running
> > + * recovery mode.
> > + *
> > + * Returns 0 on success, negative on failure
> > + **/
> > +static int i40e_init_recovery_mode(struct i40e_pf *pf, struct i40e_hw
> > *hw)
> > +{
> > +	struct i40e_vsi *vsi;
> > +	int err;
> > +	int v_idx;
> > +
> > +#ifdef HAVE_PCI_ERS
> > +	pci_save_state(pf->pdev);
> > +#endif
> > +
> > +	/* set up periodic task facility */
> > +	timer_setup(&pf->service_timer, i40e_service_timer, 0);
> > +	pf->service_timer_period =3D HZ;
> > +
> > +	INIT_WORK(&pf->service_task, i40e_service_task);
> > +	clear_bit(__I40E_SERVICE_SCHED, pf->state);
> > +
> > +	err =3D i40e_init_interrupt_scheme(pf);
> > +	if (err)
> > +		goto err_switch_setup;
> > +
> > +	/* The number of VSIs reported by the FW is the minimum guaranteed
> > +	 * to us; HW supports far more and we share the remaining pool with
> > +	 * the other PFs. We allocate space for more than the guarantee
> > with
> > +	 * the understanding that we might not get them all later.
> > +	 */
> > +	if (pf->hw.func_caps.num_vsis < I40E_MIN_VSI_ALLOC)
> > +		pf->num_alloc_vsi =3D I40E_MIN_VSI_ALLOC;
> > +	else
> > +		pf->num_alloc_vsi =3D pf->hw.func_caps.num_vsis;
> > +
> > +	/* Set up the vsi struct and our local tracking of the MAIN PF vsi.
> > */
> > +	pf->vsi =3D kcalloc(pf->num_alloc_vsi, sizeof(struct i40e_vsi *),
> > +			  GFP_KERNEL);
> > +	if (!pf->vsi) {
> > +		err =3D -ENOMEM;
> > +		goto err_switch_setup;
> > +	}
> > +
> > +	/* We allocate one VSI which is needed as absolute minimum
> > +	 * in order to register the netdev
> > +	 */
> > +	v_idx =3D i40e_vsi_mem_alloc(pf, I40E_VSI_MAIN);
> > +	if (v_idx < 0)
> > +		goto err_switch_setup;
> > +	pf->lan_vsi =3D v_idx;
> > +	vsi =3D pf->vsi[v_idx];
> > +	if (!vsi)
> > +		goto err_switch_setup;
> > +	vsi->alloc_queue_pairs =3D 1;
> > +	err =3D i40e_config_netdev(vsi);
> > +	if (err)
> > +		goto err_switch_setup;
> > +	err =3D register_netdev(vsi->netdev);
> > +	if (err)
> > +		goto err_switch_setup;
> > +	vsi->netdev_registered =3D true;
> > +	i40e_dbg_pf_init(pf);
> > +
> > +	err =3D i40e_setup_misc_vector_for_recovery_mode(pf);
> > +	if (err)
> > +		goto err_switch_setup;
> > +
> > +	/* tell the firmware that we're starting */
> > +	i40e_send_version(pf);
> > +
> > +	/* since everything's happy, start the service_task timer */
> > +	mod_timer(&pf->service_timer,
> > +		  round_jiffies(jiffies + pf->service_timer_period));
> > +
> > +	return 0;
> > +
> > +err_switch_setup:
> > +	i40e_reset_interrupt_capability(pf);
> > +	del_timer_sync(&pf->service_timer);
> > +#ifdef NOT_FOR_UPSTREAM
>=20
> Delightful :)
>=20
> > +	dev_warn(&pf->pdev->dev, "previous errors forcing module to load in
> > debug mode\n");
> > +	i40e_dbg_pf_init(pf);
> > +	set_bit(__I40E_DEBUG_MODE, pf->state);
> > +	return 0;
> > +#else
> > +	i40e_shutdown_adminq(hw);
> > +	iounmap(hw->hw_addr);
> > +	pci_disable_pcie_error_reporting(pf->pdev);
> > +	pci_release_mem_regions(pf->pdev);
> > +	pci_disable_device(pf->pdev);
> > +	kfree(pf);
> > +
> > +	return err;
> > +#endif
> > +}
> > +
> >  /**
> >   * i40e_probe - Device initialization routine
> >   * @pdev: PCI device information struct


--=-28NwW8wvmwfnvd8jxxKn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEiTyZWz+nnTrOJ1LZ5W/vlVpL7c4FAlzKtlgACgkQ5W/vlVpL
7c5mNg/9E5YIkozfy+J2aN5gxaMwHzw2X7D3gHHXmqWBa2mN0afUVOEz24ldPL3s
jYJngRMfMjaiBm0s2bdUmlT51Ljm+YTS0/rQTM6PEPVj5jwM8P3Nl2sJAGA19MW+
JcujkPrW746e1TNltFBgWqzXrBCw2h1XCBoA/wBs54opGU3kjNzPnbfJTCIHtlJe
0Pga+d4QRkKh//Ff1TTZdDXSGD5dK9+v6vZ2W6vreAu+c4pphmdH3yN8C12B3Pmu
TamZpvJe6lw5z6HPJ+7e25QhXADHoaEpLSL9MlRZTzjX1Tnsb4CG9fM5IthR+s0+
gicvjsPetXc1Cb9CQ/jhEKtzC0Gk1OhSUokKphO5wcbdU49HV9TQA5zxXdtdQYEI
NirwOOprn4RV52GX4F8eELfbJY/+GOZqXuiNWScG2dNuKJPYkuwyzaozulCxunNs
5WKTqE5BQqrxQr++CP4ise6lfVswchvprLs9mZ7X+Oif7aywl62pCzXS5YfbmoCL
HfyUzIfxNo/+UjTix+6xWbeqqsJob2PkyepVdPgtC/6meuPGHb1YkbceoJ3QKM99
MT3E/CgyX8v6qyklQD6XBUuXhVKL0qYarOY6VijNb93t3FF1i4mG17Lhab2sAi97
g/VbM/eFlurXGzsES5ZQt71Um7xpmx+nHc0H3o11za7Ft+jDT3A=
=bSux
-----END PGP SIGNATURE-----

--=-28NwW8wvmwfnvd8jxxKn--

