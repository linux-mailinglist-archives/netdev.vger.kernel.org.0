Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 321E8171D0E
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 15:17:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389372AbgB0ORa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 09:17:30 -0500
Received: from smtprelay07.ispgateway.de ([134.119.228.99]:42917 "EHLO
        smtprelay07.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389709AbgB0OR2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 09:17:28 -0500
X-Greylist: delayed 441 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Feb 2020 09:17:28 EST
Received: from [87.123.206.167] (helo=kiste)
        by smtprelay07.ispgateway.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.92.3)
        (envelope-from <ndev@hwipl.net>)
        id 1j7JrU-0006mO-HJ; Thu, 27 Feb 2020 15:10:00 +0100
Date:   Thu, 27 Feb 2020 15:09:46 +0100
From:   Hans Wippel <ndev@hwipl.net>
To:     Karsten Graul <kgraul@linux.ibm.com>
Cc:     ubraun@linux.ibm.com, davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [RFC net-next] net/smc: update peer ID on device changes
Message-Id: <20200227150946.60f12541f7541a64150afe2a@hwipl.net>
In-Reply-To: <b56d4bbc-2a4e-634f-10d4-17bd0253c033@linux.ibm.com>
References: <20200227113902.318060-1-ndev@hwipl.net>
        <b56d4bbc-2a4e-634f-10d4-17bd0253c033@linux.ibm.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Df-Sender: bmRldkBod2lwbC5uZXQ=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 27 Feb 2020 14:13:48 +0100
Karsten Graul <kgraul@linux.ibm.com> wrote:

> On 27/02/2020 12:39, Hans Wippel wrote:
> > From: hwipl <ndev@hwipl.net>
> > 
> > A SMC host's peer ID contains the MAC address of the first active RoCE
> > device. However, if this device becomes inactive or is removed, the peer
> > ID is not updated. This patch adds peer ID updates on device changes.
> 
> The peer ID is used to uniquely identify an SMC host and to check if there
> are already established link groups to the peer which can be reused.
> In failover scenarios RoCE devices can go down and get active again later,
> but this must not change the current peer ID of the host.  
> The part of the MAC address that is included in the peer ID is not used for
> other purposes than the identification of an SMC host.

Is it OK to keep the peer ID if, for example, the device is removed and
used in a different VM?

Hans


> > 
> > Signed-off-by: hwipl <ndev@hwipl.net>
> > ---
> >  net/smc/smc_ib.c | 32 ++++++++++++++++++++++++--------
> >  1 file changed, 24 insertions(+), 8 deletions(-)
> > 
> > diff --git a/net/smc/smc_ib.c b/net/smc/smc_ib.c
> > index 3444de27fecd..5818636962c6 100644
> > --- a/net/smc/smc_ib.c
> > +++ b/net/smc/smc_ib.c
> > @@ -159,11 +159,29 @@ static int smc_ib_fill_mac(struct smc_ib_device *smcibdev, u8 ibport)
> >   * plus a random 2-byte number is used to create this identifier.
> >   * This name is delivered to the peer during connection initialization.
> >   */
> > -static inline void smc_ib_define_local_systemid(struct smc_ib_device *smcibdev,
> > -						u8 ibport)
> > +static void smc_ib_update_local_systemid(void)
> >  {
> > -	memcpy(&local_systemid[2], &smcibdev->mac[ibport - 1],
> > -	       sizeof(smcibdev->mac[ibport - 1]));
> > +	struct smc_ib_device *smcibdev;
> > +	u8 ibport;
> > +
> > +	/* get first ib device with an active port */
> > +	spin_lock(&smc_ib_devices.lock);
> > +	list_for_each_entry(smcibdev, &smc_ib_devices.list, list) {
> > +		for (ibport = 1; ibport <= SMC_MAX_PORTS; ibport++) {
> > +			if (smc_ib_port_active(smcibdev, ibport))
> > +				goto out;
> > +		}
> > +	}
> > +	smcibdev = NULL;
> > +out:
> > +	spin_unlock(&smc_ib_devices.lock);
> > +
> > +	/* set (new) mac address or reset to zero */
> > +	if (smcibdev)
> > +		ether_addr_copy(&local_systemid[2],
> > +				(u8 *)&smcibdev->mac[ibport - 1]);
> > +	else
> > +		eth_zero_addr(&local_systemid[2]);
> >  }
> >  
> >  bool smc_ib_is_valid_local_systemid(void)
> > @@ -229,10 +247,6 @@ static int smc_ib_remember_port_attr(struct smc_ib_device *smcibdev, u8 ibport)
> >  	rc = smc_ib_fill_mac(smcibdev, ibport);
> >  	if (rc)
> >  		goto out;
> > -	if (!smc_ib_is_valid_local_systemid() &&
> > -	    smc_ib_port_active(smcibdev, ibport))
> > -		/* create unique system identifier */
> > -		smc_ib_define_local_systemid(smcibdev, ibport);
> >  out:
> >  	return rc;
> >  }
> > @@ -254,6 +268,7 @@ static void smc_ib_port_event_work(struct work_struct *work)
> >  			clear_bit(port_idx, smcibdev->ports_going_away);
> >  		}
> >  	}
> > +	smc_ib_update_local_systemid();
> >  }
> >  
> >  /* can be called in IRQ context */
> > @@ -599,6 +614,7 @@ static void smc_ib_remove_dev(struct ib_device *ibdev, void *client_data)
> >  	smc_ib_cleanup_per_ibdev(smcibdev);
> >  	ib_unregister_event_handler(&smcibdev->event_handler);
> >  	kfree(smcibdev);
> > +	smc_ib_update_local_systemid();
> >  }
> >  
> >  static struct ib_client smc_ib_client = {
> > 
> 
> -- 
> Karsten
> 
> (I'm a dude)
> 
