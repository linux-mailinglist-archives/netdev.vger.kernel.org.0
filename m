Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7837E179776
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 19:04:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730026AbgCDSEB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 13:04:01 -0500
Received: from mga07.intel.com ([134.134.136.100]:57512 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727528AbgCDSEB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Mar 2020 13:04:01 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Mar 2020 10:04:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,514,1574150400"; 
   d="asc'?scan'208";a="232695316"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga007.fm.intel.com with ESMTP; 04 Mar 2020 10:03:59 -0800
Message-ID: <c84d4055e13f30edf7b79086c9ed8d7d1fe6523b.camel@intel.com>
Subject: Re: [PATCH net 1/1] e1000e: Stop tx/rx setup spinning for upwards
 of 300us.
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Reply-To: jeffrey.t.kirsher@intel.com
To:     David Laight <David.Laight@ACULAB.COM>,
        Network Development <netdev@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>
Cc:     "'bruce.w.allan@intel.com'" <bruce.w.allan@intel.com>,
        "'jeffrey.e.pieper@intel.com'" <jeffrey.e.pieper@intel.com>
Date:   Wed, 04 Mar 2020 10:03:59 -0800
In-Reply-To: <6ef1e257642743a786c8ddd39645bba3@AcuMS.aculab.com>
References: <6ef1e257642743a786c8ddd39645bba3@AcuMS.aculab.com>
Organization: Intel
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-wctGzAme2eL3FaF4J5Ew"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-wctGzAme2eL3FaF4J5Ew
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2020-03-03 at 17:06 +0000, David Laight wrote:
> Instead of spinning waiting for the ME to be idle defer the ring
> tail updates until one of the following:
> - The next update for that ring.
> - The receive frame processing.
> - The next timer tick.
>=20
> Reduce the delay between checks for the ME being idle from 50us
> to uus.
>=20
> Part fix for bdc125f7.
>=20
> Signed-off-by: David Laight <david.laight@aculab.com>

Added intel-wired-lan@lists.osuosl.org mailing list, so the right
people can review your patch.

> ---
>  This change probably applies as back as far as 3.16.
>=20
>  drivers/net/ethernet/intel/e1000e/e1000.h   |   3 +
>  drivers/net/ethernet/intel/e1000e/ich8lan.h |   2 +-
>  drivers/net/ethernet/intel/e1000e/netdev.c  | 131
> ++++++++++++++++++++--------
>  3 files changed, 99 insertions(+), 37 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/intel/e1000e/e1000.h
> b/drivers/net/ethernet/intel/e1000e/e1000.h
> index 6c51b1b..c7819e0 100644
> --- a/drivers/net/ethernet/intel/e1000e/e1000.h
> +++ b/drivers/net/ethernet/intel/e1000e/e1000.h
> @@ -155,6 +155,8 @@ struct e1000_ring {
> =20
>  	u16 next_to_use;
>  	u16 next_to_clean;
> +#define E1000_RING_NOT_DEFERRED 0xffff
> +	u16 next_to_use_deferred;
> =20
>  	void __iomem *head;
>  	void __iomem *tail;
> @@ -190,6 +192,7 @@ struct e1000_adapter {
> =20
>  	struct work_struct reset_task;
>  	struct delayed_work watchdog_task;
> +	struct delayed_work delay_ring_write_task;
> =20
>  	struct workqueue_struct *e1000_workqueue;
> =20
> diff --git a/drivers/net/ethernet/intel/e1000e/ich8lan.h
> b/drivers/net/ethernet/intel/e1000e/ich8lan.h
> index 1502895..75e5a53 100644
> --- a/drivers/net/ethernet/intel/e1000e/ich8lan.h
> +++ b/drivers/net/ethernet/intel/e1000e/ich8lan.h
> @@ -34,7 +34,7 @@
>  /* FW established a valid mode */
>  #define E1000_ICH_FWSM_FW_VALID	0x00008000
>  #define E1000_ICH_FWSM_PCIM2PCI	0x01000000	/* ME PCIm-
> to-PCI active */
> -#define E1000_ICH_FWSM_PCIM2PCI_COUNT	2000
> +#define E1000_ICH_FWSM_PCIM2PCI_COUNT	20000
> =20
>  #define E1000_ICH_MNG_IAMT_MODE		0x2
> =20
> diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c
> b/drivers/net/ethernet/intel/e1000e/netdev.c
> index d7d56e4..299e5af 100644
> --- a/drivers/net/ethernet/intel/e1000e/netdev.c
> +++ b/drivers/net/ethernet/intel/e1000e/netdev.c
> @@ -118,13 +118,20 @@ struct e1000_reg_info {
>   * an incorrect value.  Workaround this by checking the FWSM
> register which
>   * has bit 24 set while ME is accessing MAC CSR registers, wait if
> it is set
>   * and try again a number of times.
> + * NB: This bit can stay set for 300us even if polled every 5us.
>   **/
> +
> +static bool __ew32_prepare_busy(struct e1000_hw *hw)
> +{
> +	return (er32(FWSM) & E1000_ICH_FWSM_PCIM2PCI);
> +}
> +
>  s32 __ew32_prepare(struct e1000_hw *hw)
>  {
>  	s32 i =3D E1000_ICH_FWSM_PCIM2PCI_COUNT;
> =20
> -	while ((er32(FWSM) & E1000_ICH_FWSM_PCIM2PCI) && --i)
> -		udelay(50);
> +	while (__ew32_prepare_busy(hw) && --i)
> +		udelay(5);
> =20
>  	return i;
>  }
> @@ -603,38 +610,75 @@ static void e1000_rx_checksum(struct
> e1000_adapter *adapter, u32 status_err,
>  	adapter->hw_csum_good++;
>  }
> =20
> -static void e1000e_update_rdt_wa(struct e1000_ring *rx_ring,
> unsigned int i)
> +static bool deferred_update_dt_wa(struct e1000_ring *ring)
>  {
> -	struct e1000_adapter *adapter =3D rx_ring->adapter;
> -	struct e1000_hw *hw =3D &adapter->hw;
> -	s32 ret_val =3D __ew32_prepare(hw);
> -
> -	writel(i, rx_ring->tail);
> +	struct e1000_adapter *adapter;
> +	struct e1000_hw *hw;
> +	unsigned long flags;
> +	u32 deferred;
> =20
> -	if (unlikely(!ret_val && (i !=3D readl(rx_ring->tail)))) {
> -		u32 rctl =3D er32(RCTL);
> +	adapter =3D ring->adapter;
> +	hw =3D &adapter->hw;
> +	spin_lock_irqsave(&adapter->systim_lock, flags);
> +	deferred =3D ring->next_to_use_deferred;
> +	if (deferred !=3D E1000_RING_NOT_DEFERRED) {
> +		if (__ew32_prepare_busy(hw)) {
> +			spin_unlock_irqrestore(&adapter->systim_lock,
> flags);
> +			/* Caller needs to ensure timer running */
> +			return true;
> +		}
> =20
> -		ew32(RCTL, rctl & ~E1000_RCTL_EN);
> -		e_err("ME firmware caused invalid RDT - resetting\n");
> -		schedule_work(&adapter->reset_task);
> +		writel(deferred, ring->tail);
> +		ring->next_to_use_deferred =3D E1000_RING_NOT_DEFERRED;
>  	}
> +	spin_unlock_irqrestore(&adapter->systim_lock, flags);
> +	return false;
>  }
> =20
> -static void e1000e_update_tdt_wa(struct e1000_ring *tx_ring,
> unsigned int i)
> +/* Inline the cheap unlocked test */
> +#define e1000e_deferred_update_dt_wa(ring) \
> +	(likely(READ_ONCE(ring->next_to_use_deferred) =3D=3D \
> +	        E1000_RING_NOT_DEFERRED) ? false : \
> +					   deferred_update_dt_wa(ring))
> +
> +static void e1000e_delay_ring_write_task(struct work_struct *work)
>  {
> -	struct e1000_adapter *adapter =3D tx_ring->adapter;
> -	struct e1000_hw *hw =3D &adapter->hw;
> -	s32 ret_val =3D __ew32_prepare(hw);
> +	struct e1000_adapter *adapter;
> =20
> -	writel(i, tx_ring->tail);
> +	adapter =3D container_of(work, struct e1000_adapter,
> +			       delay_ring_write_task.work);
> =20
> -	if (unlikely(!ret_val && (i !=3D readl(tx_ring->tail)))) {
> -		u32 tctl =3D er32(TCTL);
> +	if (e1000e_deferred_update_dt_wa(adapter->tx_ring) |
> +	    e1000e_deferred_update_dt_wa(adapter->rx_ring))
> +		mod_delayed_work(adapter->e1000_workqueue,
> +			 &adapter->delay_ring_write_task, 1);
> +}
> =20
> -		ew32(TCTL, tctl & ~E1000_TCTL_EN);
> -		e_err("ME firmware caused invalid TDT - resetting\n");
> -		schedule_work(&adapter->reset_task);
> +static void e1000e_update_dt_wa(struct e1000_ring *ring, unsigned
> int i)
> +{
> +	struct e1000_adapter *adapter =3D ring->adapter;
> +	struct e1000_hw *hw =3D &adapter->hw;
> +	unsigned long flags;
> +	u32 deferred;
> +
> +	deferred =3D READ_ONCE(ring->next_to_use_deferred);
> +	if (unlikely(deferred !=3D E1000_RING_NOT_DEFERRED)) {
> +		/* previous write was deferred - forget about it */
> +		spin_lock_irqsave(&adapter->systim_lock, flags);
> +		ring->next_to_use_deferred =3D E1000_RING_NOT_DEFERRED;
> +		spin_unlock_irqrestore(&adapter->systim_lock, flags);
> +	}
> +
> +	if (!__ew32_prepare_busy(hw)) {
> +		writel(i, ring->tail);
> +		return;
>  	}
> +
> +	/* We can't write now, defer to rx clean or timeout */
> +	WRITE_ONCE(ring->next_to_use_deferred, i);
> +
> +	mod_delayed_work(adapter->e1000_workqueue,
> +			 &adapter->delay_ring_write_task, 1);
>  }
> =20
>  /**
> @@ -692,7 +736,7 @@ static void e1000_alloc_rx_buffers(struct
> e1000_ring *rx_ring,
>  			 */
>  			wmb();
>  			if (adapter->flags2 &
> FLAG2_PCIM2PCI_ARBITER_WA)
> -				e1000e_update_rdt_wa(rx_ring, i);
> +				e1000e_update_dt_wa(rx_ring, i);
>  			else
>  				writel(i, rx_ring->tail);
>  		}
> @@ -792,7 +836,7 @@ static void e1000_alloc_rx_buffers_ps(struct
> e1000_ring *rx_ring,
>  			 */
>  			wmb();
>  			if (adapter->flags2 &
> FLAG2_PCIM2PCI_ARBITER_WA)
> -				e1000e_update_rdt_wa(rx_ring, i << 1);
> +				e1000e_update_dt_wa(rx_ring, i << 1);
>  			else
>  				writel(i << 1, rx_ring->tail);
>  		}
> @@ -884,7 +928,7 @@ static void e1000_alloc_jumbo_rx_buffers(struct
> e1000_ring *rx_ring,
>  		 */
>  		wmb();
>  		if (adapter->flags2 & FLAG2_PCIM2PCI_ARBITER_WA)
> -			e1000e_update_rdt_wa(rx_ring, i);
> +			e1000e_update_dt_wa(rx_ring, i);
>  		else
>  			writel(i, rx_ring->tail);
>  	}
> @@ -1256,6 +1300,8 @@ static bool e1000_clean_tx_irq(struct
> e1000_ring *tx_ring)
> =20
>  	tx_ring->next_to_clean =3D i;
> =20
> +	e1000e_deferred_update_dt_wa(tx_ring);
> +
>  	netdev_completed_queue(netdev, pkts_compl, bytes_compl);
> =20
>  #define TX_WAKE_THRESHOLD 32
> @@ -1729,6 +1775,7 @@ static void e1000_clean_rx_ring(struct
> e1000_ring *rx_ring)
> =20
>  	rx_ring->next_to_clean =3D 0;
>  	rx_ring->next_to_use =3D 0;
> +	rx_ring->next_to_use_deferred =3D E1000_RING_NOT_DEFERRED;
>  	adapter->flags2 &=3D ~FLAG2_IS_DISCARDING;
>  }
> =20
> @@ -2342,6 +2389,7 @@ int e1000e_setup_tx_resources(struct e1000_ring
> *tx_ring)
> =20
>  	tx_ring->next_to_use =3D 0;
>  	tx_ring->next_to_clean =3D 0;
> +	tx_ring->next_to_use_deferred =3D E1000_RING_NOT_DEFERRED;
> =20
>  	return 0;
>  err:
> @@ -2388,6 +2436,7 @@ int e1000e_setup_rx_resources(struct e1000_ring
> *rx_ring)
> =20
>  	rx_ring->next_to_clean =3D 0;
>  	rx_ring->next_to_use =3D 0;
> +	rx_ring->next_to_use_deferred =3D E1000_RING_NOT_DEFERRED;
>  	rx_ring->rx_skb_top =3D NULL;
> =20
>  	return 0;
> @@ -2427,6 +2476,7 @@ static void e1000_clean_tx_ring(struct
> e1000_ring *tx_ring)
> =20
>  	tx_ring->next_to_use =3D 0;
>  	tx_ring->next_to_clean =3D 0;
> +	tx_ring->next_to_use_deferred =3D E1000_RING_NOT_DEFERRED;
>  }
> =20
>  /**
> @@ -2666,6 +2716,9 @@ static int e1000e_poll(struct napi_struct
> *napi, int budget)
> =20
>  	adapter =3D netdev_priv(poll_dev);
> =20
> +	e1000e_deferred_update_dt_wa(adapter->tx_ring);
> +	e1000e_deferred_update_dt_wa(adapter->rx_ring);
> +
>  	if (!adapter->msix_entries ||
>  	    (adapter->rx_ring->ims_val & adapter->tx_ring->ims_val))
>  		tx_cleaned =3D e1000_clean_tx_irq(adapter->tx_ring);
> @@ -2930,10 +2983,11 @@ static void e1000_configure_tx(struct
> e1000_adapter *adapter)
>  	tx_ring->tail =3D adapter->hw.hw_addr + E1000_TDT(0);
> =20
>  	writel(0, tx_ring->head);
> -	if (adapter->flags2 & FLAG2_PCIM2PCI_ARBITER_WA)
> -		e1000e_update_tdt_wa(tx_ring, 0);
> -	else
> -		writel(0, tx_ring->tail);
> +	if (adapter->flags2 & FLAG2_PCIM2PCI_ARBITER_WA) {
> +		while (__ew32_prepare_busy(hw))
> +			usleep_range(50, 100);
> +	}
> +	writel(0, tx_ring->tail);
> =20
>  	/* Set the Tx Interrupt Delay register */
>  	ew32(TIDV, adapter->tx_int_delay);
> @@ -3254,10 +3308,11 @@ static void e1000_configure_rx(struct
> e1000_adapter *adapter)
>  	rx_ring->tail =3D adapter->hw.hw_addr + E1000_RDT(0);
> =20
>  	writel(0, rx_ring->head);
> -	if (adapter->flags2 & FLAG2_PCIM2PCI_ARBITER_WA)
> -		e1000e_update_rdt_wa(rx_ring, 0);
> -	else
> -		writel(0, rx_ring->tail);
> +	if (adapter->flags2 & FLAG2_PCIM2PCI_ARBITER_WA) {
> +		while (__ew32_prepare_busy(hw))
> +			usleep_range(50, 100);
> +	}
> +	writel(0, rx_ring->tail);
> =20
>  	/* Enable Receive Checksum Offload for TCP and UDP */
>  	rxcsum =3D er32(RXCSUM);
> @@ -5908,8 +5963,8 @@ static netdev_tx_t e1000_xmit_frame(struct
> sk_buff *skb,
>  		if (!netdev_xmit_more() ||
>  		    netif_xmit_stopped(netdev_get_tx_queue(netdev, 0)))
> {
>  			if (adapter->flags2 &
> FLAG2_PCIM2PCI_ARBITER_WA)
> -				e1000e_update_tdt_wa(tx_ring,
> -						     tx_ring-
> >next_to_use);
> +				e1000e_update_dt_wa(tx_ring,
> +						    tx_ring-
> >next_to_use);
>  			else
>  				writel(tx_ring->next_to_use, tx_ring-
> >tail);
>  		}
> @@ -7271,6 +7326,9 @@ static int e1000_probe(struct pci_dev *pdev,
> const struct pci_device_id *ent)
>  	queue_delayed_work(adapter->e1000_workqueue, &adapter-
> >watchdog_task,
>  			   0);
> =20
> +	INIT_DELAYED_WORK(&adapter->delay_ring_write_task,
> +			  e1000e_delay_ring_write_task);
> +
>  	timer_setup(&adapter->phy_info_timer, e1000_update_phy_info,
> 0);
> =20
>  	INIT_WORK(&adapter->reset_task, e1000_reset_task);
> @@ -7424,6 +7482,7 @@ static void e1000_remove(struct pci_dev *pdev)
>  	cancel_work_sync(&adapter->print_hang_task);
> =20
>  	cancel_delayed_work(&adapter->watchdog_task);
> +	cancel_delayed_work(&adapter->delay_ring_write_task);
>  	flush_workqueue(adapter->e1000_workqueue);
>  	destroy_workqueue(adapter->e1000_workqueue);
> =20


--=-wctGzAme2eL3FaF4J5Ew
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiTyZWz+nnTrOJ1LZ5W/vlVpL7c4FAl5f7Y8ACgkQ5W/vlVpL
7c5pFA//SK2uCqvykMZXWAT8q6JZYr/G3cpUSaZMpnEXAHA7z8cAZGDIGEmSI/CW
Q9quX6kUyheCE4q30p/vRsRBB5BCgdKSiXu9dViCR12sPhNpghVJcZsVaHliExci
OSGhchA5vx9/4OodhUZ4+hxI1kz0rgZ5v0KPCE5t7D1zyWn5cACdx8t6ApN190jt
sJBWDCABHLKG2H+1fCXynSlcFqRkwj/ZImnwbDgiJ3FRDYT8b8fEQ0Tbk/95F6GT
/mvid5EXqmwCucr5LITbyn6gS2pXpIBA16orZLBvsdusuh0M+V9X2n+66Qchn8jt
l4ws6qX4/8Dn11hk8vGsR2KSW2FkKIgW5sTxJPR6Iq2ve1a1/F9FmDkxGdplz1Wm
q3aZslMOmVmatqxDcLoNdZMcmJ8wkBCyY+4HdaF90QRdNfP0Wc/XLCYUyntxZIXV
Tu/XPVJwXbZ5QdCM5aN9KEnwuMjqKI4BcbqOog9WiWk2gk0hCoDZN/cfzUdGnMRR
ZGZ0HRVLN9OserlTxKj0/qjfS/rIM2htKZ2JJYmMwfhzhPu2WwGue2pOI8PGRlQ1
w+CnuBCy9Tc1dXevBvPhFXH7Ul5M/82sIizQWxfTgYHLYI8w0ghvQt3W+RAG4G+d
f2W5xil+oFg5pL7hjP8RujpqlCXriJoEnUM292C+mRGmB84Aars=
=bTDT
-----END PGP SIGNATURE-----

--=-wctGzAme2eL3FaF4J5Ew--

