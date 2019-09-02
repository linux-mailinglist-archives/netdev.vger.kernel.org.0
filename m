Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CD69A5053
	for <lists+netdev@lfdr.de>; Mon,  2 Sep 2019 09:52:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729963AbfIBHwb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 03:52:31 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:56025 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729408AbfIBHwb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Sep 2019 03:52:31 -0400
Received: from [5.158.153.52] (helo=linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:RSA_AES_256_CBC_SHA1:256)
        (Exim 4.80)
        (envelope-from <kurt.kanzenbach@linutronix.de>)
        id 1i4h8D-0007Gj-TA; Mon, 02 Sep 2019 09:52:09 +0200
Date:   Mon, 2 Sep 2019 09:52:09 +0200
From:   Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, vinicius.gomes@intel.com,
        vedang.patel@intel.com, richardcochran@gmail.com,
        weifeng.voon@intel.com, jiri@mellanox.com, m-karicheri2@ti.com,
        Jose.Abreu@synopsys.com, ilias.apalodimas@linaro.org,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, netdev@vger.kernel.org
Subject: Re: [RFC PATCH v2 net-next 10/15] net: dsa: Pass ndo_setup_tc slave
 callback to drivers
Message-ID: <20190902075209.GC3343@linutronix.de>
References: <20190830004635.24863-1-olteanv@gmail.com>
 <20190830004635.24863-11-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="8X7/QrJGcKSMr1RN"
Content-Disposition: inline
In-Reply-To: <20190830004635.24863-11-olteanv@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--8X7/QrJGcKSMr1RN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

On Fri, Aug 30, 2019 at 03:46:30AM +0300, Vladimir Oltean wrote:
> DSA currently handles shared block filters (for the classifier-action
> qdisc) in the core due to what I believe are simply pragmatic reasons -
> hiding the complexity from drivers and offerring a simple API for port
> mirroring.
>
> Extend the dsa_slave_setup_tc function by passing all other qdisc
> offloads to the driver layer, where the driver may choose what it
> implements and how. DSA is simply a pass-through in this case.

I'm having the same problem on how to pass the taprio schedule down to
the DSA driver. I didn't perform a pass-through to keep it in sync with
the already implemented offload. See my approach below.

>
> There is an open question related to the drivers potentially needing to
> do work in process context, but .ndo_setup_tc is called in atomic
> context. At the moment the drivers are left to handle this on their own.
> The risk is that once accepting the offload callback right away in the
> DSA core, then the driver would have no way to signal an error back. So
> right now the driver has to do as much error checking as possible in the
> atomic context and only defer (probably) the actual configuring of the
> offload.
>
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> ---
>  include/net/dsa.h |  3 +++
>  net/dsa/slave.c   | 12 ++++++++----
>  2 files changed, 11 insertions(+), 4 deletions(-)
>
> diff --git a/include/net/dsa.h b/include/net/dsa.h
> index 96acb14ec1a8..232b5d36815d 100644
> --- a/include/net/dsa.h
> +++ b/include/net/dsa.h
> @@ -154,6 +154,7 @@ struct dsa_mall_tc_entry {
>  	};
>  };
>
> +struct tc_taprio_qopt_offload;

Is this needed? The rest looks good to me.

My approach:

diff --git a/include/net/dsa.h b/include/net/dsa.h
index ba6dfff98196..a60bd55f27f2 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -20,6 +20,7 @@
 #include <linux/platform_data/dsa.h>
 #include <net/devlink.h>
 #include <net/switchdev.h>
+#include <net/pkt_sched.h>

 struct tc_action;
 struct phy_device;
@@ -539,6 +540,13 @@ struct dsa_switch_ops {
 	 */
 	netdev_tx_t (*port_deferred_xmit)(struct dsa_switch *ds, int port,
 					  struct sk_buff *skb);
+
+	/*
+	 * Scheduled traffic functionality
+	 */
+	int (*port_set_schedule)(struct dsa_switch *ds, int port,
+				 const struct tc_taprio_qopt_offload *taprio);
+	int (*port_del_schedule)(struct dsa_switch *ds, int port);
 };

 struct dsa_switch_driver {
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 8157be7e162d..6290d55e6011 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -15,6 +15,7 @@
 #include <linux/mdio.h>
 #include <net/rtnetlink.h>
 #include <net/pkt_cls.h>
+#include <net/pkt_sched.h>
 #include <net/tc_act/tc_mirred.h>
 #include <linux/if_bridge.h>
 #include <linux/netpoll.h>
@@ -953,12 +954,33 @@ static int dsa_slave_setup_tc_block(struct net_device *dev,
 	}
 }

+static int dsa_slave_setup_tc_taprio(struct net_device *dev,
+				     const struct tc_taprio_qopt_offload *taprio)
+{
+	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct dsa_switch *ds = dp->ds;
+
+	if (taprio->enable) {
+		if (!ds->ops->port_set_schedule)
+			return -EOPNOTSUPP;
+
+		return ds->ops->port_set_schedule(ds, dp->index, taprio);
+	}
+
+	if (!ds->ops->port_del_schedule)
+		return -EOPNOTSUPP;
+
+	return ds->ops->port_del_schedule(ds, dp->index);
+}
+
 static int dsa_slave_setup_tc(struct net_device *dev, enum tc_setup_type type,
 			      void *type_data)
 {
 	switch (type) {
 	case TC_SETUP_BLOCK:
 		return dsa_slave_setup_tc_block(dev, type_data);
+	case TC_SETUP_QDISC_TAPRIO:
+		return dsa_slave_setup_tc_taprio(dev, type_data);
 	default:
 		return -EOPNOTSUPP;
 	}

Thanks,
Kurt

--8X7/QrJGcKSMr1RN
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl1syikACgkQeSpbgcuY
8Kbm5Q//WR9nvGA4c32slCjbHUqa8Oc99pIPdPzImQyDlSRD1PskZj46arcl2EvM
A6Ot7u4K3dZ+QBiquLGag2jVM5obgkwJp6jk5DU2yiliAfqCxrHYfjIrjkaEmJ9T
Qx4h6KzkuQv6kFvL5M6ExMY6gaF7iPInd0UKBntOAeJV2Kes90uOaBQQQYcIfP0R
LEdUejQZef+E5J/g/ZSzbzI0x2qyDfHHpULYEWoJsyCUV5EABcXn/b/evU4aspvk
9/yaTWuw6ZCAzjchMFpeO4gPWvGGydgPsH893JGBhvk8iUhdsbnxpSZPo2bp0e56
qFlUMGaGeiYdf1qH8I9V8Qts5KRhq80k3mI6lBnFdbuVHrqvpt8DeTB2vcLQvpus
JpmY7Ry4vwAL68kw7K0oFfrG8XLKWopwKa+ad2pPSUHi2T6AdBnEfShxIK7RMUm1
TH+XR523WWRtPV9FAoYhnSQLpoJO/HKPPkWOVRR6kz8GqkUBg6qly1xZMP6WebZo
Qpt69DuJofbmX4I2/WHjK8F2wT7qSw+E9XHBgos0JUQgQVGGWdGR75XlNUuSlGBI
UWCaew7+geOC6lRTdb6SG0Ikf/AdogdEOQXbO9QvfyRKo4HIRpF5rVDqkCL3kgln
PvWhMME5uqiDdUugv/Dvl5Z/aGAwieN2putt7PJa+PQvwsAEhDo=
=O5AP
-----END PGP SIGNATURE-----

--8X7/QrJGcKSMr1RN--
