Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA4C6261B4A
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 21:01:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731493AbgIHTBS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 15:01:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:54000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731475AbgIHTBJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Sep 2020 15:01:09 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 198F72087D;
        Tue,  8 Sep 2020 19:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599591668;
        bh=L7B4M/aMt4nbjv2yflZs631NEH0Zuj8ODKH/anQjCwk=;
        h=Date:From:To:Subject:In-Reply-To:References:From;
        b=WuxqQj3VELEhGlk9/iSzGDgua5NJSxjyLQaGry7kT++vC6ifXT6ft5UZvHe7kTxYN
         J14zWgMIFLu7rXdhfMV5J9781iZOiYxO2JcnXiqbjiWSDLeFRRfFQOSOz745QClwtu
         to/vhmSyP6yV2po/QGRYdfrZzqKzMJ+6nbnXDKWU=
Date:   Tue, 8 Sep 2020 12:01:06 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Chris Healy <cphealy@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH net-next v2 5/7] net: dsa: mv88e6xxx: Add devlink
 regions
Message-ID: <20200908120100.77cfcfa1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200908005155.3267736-6-andrew@lunn.ch>
References: <20200908005155.3267736-1-andrew@lunn.ch>
        <20200908005155.3267736-6-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  8 Sep 2020 02:51:53 +0200 Andrew Lunn wrote:
> Allow ports, the global registers, and the ATU to be snapshot via
> devlink regions.
> 
> v2:
> Remove left over debug prints
> Comment ATU format is generic for mv88e6xxx, not wider
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Probably best CCing devlink maintainers on devlink patches.

Also - it's always useful to include show command outputs in the commit
message for devlink patches.

> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
> index d8bb5e5e8583..8d1710c896ae 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.c
> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> @@ -2838,6 +2838,7 @@ static void mv88e6xxx_teardown(struct dsa_switch *ds)
>  {
>  	mv88e6xxx_teardown_devlink_params(ds);
>  	dsa_devlink_resources_unregister(ds);
> +	mv88e6xxx_teardown_devlink_regions(ds);
>  }
>  
>  static int mv88e6xxx_setup(struct dsa_switch *ds)
> @@ -2970,7 +2971,18 @@ static int mv88e6xxx_setup(struct dsa_switch *ds)
>  
>  	err = mv88e6xxx_setup_devlink_params(ds);
>  	if (err)
> -		dsa_devlink_resources_unregister(ds);
> +		goto out_resources;
> +
> +	err = mv88e6xxx_setup_devlink_regions(ds);
> +	if (err)
> +		goto out_params;
> +
> +	return 0;
> +
> +out_params:
> +	mv88e6xxx_teardown_devlink_params(ds);
> +out_resources:
> +	dsa_devlink_resources_unregister(ds);
>  
>  	return err;
>  }
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
> index 77d81aa99f37..d8bd211afcec 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.h
> +++ b/drivers/net/dsa/mv88e6xxx/chip.h
> @@ -238,6 +238,15 @@ struct mv88e6xxx_port {
>  	bool mirror_egress;
>  	unsigned int serdes_irq;
>  	char serdes_irq_name[64];
> +	struct devlink_region *region;
> +};
> +
> +enum mv88e6xxx_region_id {
> +	MV88E6XXX_REGION_GLOBAL1 = 0,
> +	MV88E6XXX_REGION_GLOBAL2,
> +	MV88E6XXX_REGION_ATU,
> +
> +	_MV88E6XXX_REGION_MAX,
>  };
>  
>  struct mv88e6xxx_chip {
> @@ -334,6 +343,9 @@ struct mv88e6xxx_chip {
>  
>  	/* Array of port structures. */
>  	struct mv88e6xxx_port ports[DSA_MAX_PORTS];
> +
> +	/* devlink regions */
> +	struct devlink_region *regions[_MV88E6XXX_REGION_MAX];
>  };
>  
>  struct mv88e6xxx_bus_ops {
> diff --git a/drivers/net/dsa/mv88e6xxx/devlink.c b/drivers/net/dsa/mv88e6xxx/devlink.c
> index 91e02024c5cf..d93a2b33e355 100644
> --- a/drivers/net/dsa/mv88e6xxx/devlink.c
> +++ b/drivers/net/dsa/mv88e6xxx/devlink.c
> @@ -5,6 +5,7 @@
>  #include "devlink.h"
>  #include "global1.h"
>  #include "global2.h"
> +#include "port.h"
>  
>  static int mv88e6xxx_atu_get_hash(struct mv88e6xxx_chip *chip, u8 *hash)
>  {
> @@ -260,3 +261,411 @@ int mv88e6xxx_setup_devlink_resources(struct dsa_switch *ds)
>  	return err;
>  }
>  
> +static int mv88e6xxx_region_port_snapshot(struct devlink *dl,
> +					  struct netlink_ext_ack *extack,
> +					  u8 **data,
> +					  int port)
> +{
> +	struct dsa_switch *ds = dsa_devlink_to_ds(dl);
> +	struct mv88e6xxx_chip *chip = ds->priv;
> +	u16 *registers;
> +	int i, err;
> +
> +	registers = kmalloc_array(32, sizeof(u16), GFP_KERNEL);
> +	if (!registers)
> +		return -ENOMEM;
> +
> +	mv88e6xxx_reg_lock(chip);
> +	for (i = 0; i < 32; i++) {
> +		err = mv88e6xxx_port_read(chip, port, i, &registers[i]);
> +		if (err) {
> +			kfree(registers);
> +			goto out;
> +		}
> +	}
> +	*data = (u8 *)registers;
> +out:
> +	mv88e6xxx_reg_unlock(chip);
> +
> +	return err;
> +}
> +
> +#define PORT_SNAPSHOT(_X_)						\
> +static int mv88e6xxx_region_port_ ## _X_ ## _snapshot(		\
> +	struct devlink *dl,						\
> +	struct netlink_ext_ack *extack,					\
> +	u8 **data)							\
> +{									\
> +	return mv88e6xxx_region_port_snapshot(dl, extack, data, _X_);	\
> +}
> +
> +PORT_SNAPSHOT(0);
> +PORT_SNAPSHOT(1);
> +PORT_SNAPSHOT(2);
> +PORT_SNAPSHOT(3);
> +PORT_SNAPSHOT(4);
> +PORT_SNAPSHOT(5);
> +PORT_SNAPSHOT(6);
> +PORT_SNAPSHOT(7);
> +PORT_SNAPSHOT(8);
> +PORT_SNAPSHOT(9);
> +PORT_SNAPSHOT(10);
> +PORT_SNAPSHOT(11);
> +
> +#define PORT_REGION_OPS(_X_)						\
> +static struct devlink_region_ops mv88e6xxx_region_port_ ## _X_ ## _ops = { \
> +	.name = "port" #_X_,						\
> +	.snapshot = mv88e6xxx_region_port_ ## _X_ ## _snapshot,		\
> +	.destructor = kfree,						\
> +}

This is a little awkward, can we make devlink pass the region pointer
back to the callback instead? Plus perhaps an ability to allocate "priv"
data inside the region would also h

> +PORT_REGION_OPS(0);
> +PORT_REGION_OPS(1);
> +PORT_REGION_OPS(2);
> +PORT_REGION_OPS(3);
> +PORT_REGION_OPS(4);
> +PORT_REGION_OPS(5);
> +PORT_REGION_OPS(6);
> +PORT_REGION_OPS(7);
> +PORT_REGION_OPS(8);
> +PORT_REGION_OPS(9);
> +PORT_REGION_OPS(10);
> +PORT_REGION_OPS(11);
> +
> +static const struct devlink_region_ops *mv88e6xxx_region_port_ops[] = {
> +	&mv88e6xxx_region_port_0_ops,
> +	&mv88e6xxx_region_port_1_ops,
> +	&mv88e6xxx_region_port_2_ops,
> +	&mv88e6xxx_region_port_3_ops,
> +	&mv88e6xxx_region_port_4_ops,
> +	&mv88e6xxx_region_port_5_ops,
> +	&mv88e6xxx_region_port_6_ops,
> +	&mv88e6xxx_region_port_7_ops,
> +	&mv88e6xxx_region_port_8_ops,
> +	&mv88e6xxx_region_port_9_ops,
> +	&mv88e6xxx_region_port_10_ops,
> +	&mv88e6xxx_region_port_11_ops,
> +};

Ahh, seems like regions will get a per-port incarnation as some point as
well..

> +static int mv88e6xxx_setup_devlink_regions_ports(struct dsa_switch *ds,
> +						 struct mv88e6xxx_chip *chip)
> +{
> +	int port, port_err;
> +	int err;
> +
> +	for (port = 0; port < mv88e6xxx_num_ports(chip); port++) {
> +		err = mv88e6xxx_setup_devlink_regions_port(ds, chip, port);
> +		if (err)
> +			goto out;
> +	}
> +	return 0;
> +
> +out:
> +	for (port_err = 0; port_err < port; port_err++)
> +		mv88e6xxx_teardown_devlink_regions_port(chip, port_err);

FWIW I'd use

	while (port--)

but some consider it error prone.
