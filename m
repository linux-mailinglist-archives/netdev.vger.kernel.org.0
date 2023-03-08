Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CDED6AFE96
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 06:49:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbjCHFtD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 00:49:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjCHFtC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 00:49:02 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B3B6A1FF1
        for <netdev@vger.kernel.org>; Tue,  7 Mar 2023 21:48:59 -0800 (PST)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pZmfY-0003ya-NY; Wed, 08 Mar 2023 06:48:56 +0100
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pZmfW-0007Bs-EE; Wed, 08 Mar 2023 06:48:54 +0100
Date:   Wed, 8 Mar 2023 06:48:54 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        UNGLinuxDriver@microchip.com, Eric Dumazet <edumazet@google.com>,
        kernel@pengutronix.de, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next v1 2/2] net: dsa: microchip: add ETS Qdisc
 support for KSZ9477 series
Message-ID: <20230308054854.GC1692@pengutronix.de>
References: <20230306124940.865233-1-o.rempel@pengutronix.de>
 <20230306124940.865233-2-o.rempel@pengutronix.de>
 <20230306140651.kqayqatlrccfky2b@skbuf>
 <20230306163542.GB11936@pengutronix.de>
 <20230307164614.jy2mzxvk3xgc4z7b@skbuf>
 <20230307182732.GA1692@pengutronix.de>
 <20230307185734.x2lv4j3ml3fzfzoy@skbuf>
 <20230307195250.GB1692@pengutronix.de>
 <20230307211134.ref5gwbv52jd473r@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230307211134.ref5gwbv52jd473r@skbuf>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 07, 2023 at 11:11:34PM +0200, Vladimir Oltean wrote:
> On Tue, Mar 07, 2023 at 08:52:50PM +0100, Oleksij Rempel wrote:
> > > > One more question is, what is actual expected behavior of mqprio if max_rate
> > > > option is used? In my case, if max_rate is set to a queue (even to max value),
> > > > then strict priority TSA will not work:
> > > > queue0---max rate 100Mbit/s---\
> > > >                                |---100Mbit/s---
> > > > queue1---max rate 100Mbit/s---/
> > > > 
> > > > in this example both streams will get 49Mbit/s. My expectation of strict prio
> > > > is that queue1 should get 100Mbit/s and queue 0Mbit/s
> > > 
> > > I don't understand this. Have you already implemented mqprio offloading
> > > and this is what you observe?
> > 
> > Ack.
> > 
> > > max_rate is an option per traffic class. Are queue0 and queue1 mapped to
> > > the same traffic class in your example, or are they not?
> > 
> > They are separate TCs. It is not possible to assign multiple TXQs to on TC on
> > KSZ.
> > 
> > > Could you show the full ommand you ran?
> > 
> > tc qdisc add dev lan2 parent root handle 100 mqprio num_tc 4 map 0 1 2 3
> > queues 1@0 1@1 1@2 1@3  hw 1 mode channel shaper bw_rlimit max_rate
> > 70Mbit 70Mbit 70Mbit 70Mbit
> > 
> > lan2 is bridged with lan1 and lan3. Egress traffic on lan2 is from lan1 and lan3.
> > For testing I use 2 iperf3 instances with different PCP values in the VLAN tag.
> > Classification is done by HW (currently not configurable from user space)
> 
> Hmm, I still don't understand the question. First of all you changed the
> data between messages - first you talk about max_rate 100 Mbps and then
> you specify max_rate 70Mbit per traffic class. Possibly also the link
> speeds are changed between the 2 examples. What is the link speed of the
> egress port in the 2 examples?

The link is 100Mbit/s

Configuring all TCs to 100Mbit will make same effect, no prioritisation
will happen:
 tc qdisc add dev lan2 parent root handle 100 mqprio num_tc 4 map 0 1 2 3
 queues 1@0 1@1 1@2 1@3  hw 1 mode channel shaper bw_rlimit max_rate
 100Mbit 100Mbit 100Mbit 100Mbit

> The question is phrased as "what is the actual expected behavior" - that
> would be easy - the traffic classes corresponding to the 2 TXQs are rate
> limited to no more than 100 Mbps each. When the total sum of bandwidth
> consumptions exceeds the capacity of the link is when you'll start
> seeing prioritization effects.

In this case and if my code is correct, rate limit can't be used for
MQPRIO on this chip.

> If the question is why this doesn't happen in your case and they get
> equal bandwidths instead (assuming you do create congestion), I don't know;
> I have seen neither your implementation nor am I familiar with the
> hardware.

See the code at the end of mail.

>  However, there are a few things I've noticed which might be of
> help:
> 
> - the fact that you get 50-50 bandwidth allocation sounds an awful lot
>   to me as if the TXQs are still operating in WRR mode and not in strict
>   priority mode.

Even not *W*RR. Configuring weight to different queues will not make
effect as soon as rate limit is not zero.

> - the KSZ9477 datasheet says that rate limiting is per port, and not per
>   queue, unless Switch MAC Control 5 Register bit 3 (Queue Based Egress
>   Rate Limit Enable) is set.

This part was easy to test. By configuring different queues to different
rate i was able to see if traffic flows trough expected queue.
 tc qdisc add dev lan2 parent root handle 100 mqprio num_tc 4 map 0 1 2 3
 queues 1@0 1@1 1@2 1@3  hw 1 mode channel shaper bw_rlimit max_rate
 10Mbit 20Mbit 30Mbit 40Mbit

Since there are no queue counters, it is only way to confirm if my code
was actually working.

> - maybe you simply failed to convert the rates properly between the unit
>   of measurement passed by iproute2 to the unit of measurement expected
>   by hw. Here's a random comment from the ice driver:
> 
> 		/* TC command takes input in K/N/Gbps or K/M/Gbit etc but
> 		 * converts the bandwidth rate limit into Bytes/s when
> 		 * passing it down to the driver. So convert input bandwidth
> 		 * from Bytes/s to Kbps
> 		 */

I get expected rate per queue if rate limiting is working. But like I
said, it is enough to set max rate limit to a queue to make strict prio
and WRR modes do not work.

This is draft code for MQPRIO. Mainline version would look a bit more
complicated, because rate configuration is different per link speed. I
would need to update rate config on each link up event. But, since
prioritization is not working as soon as rate limit is configured, using
MQPRIO make no sense any way.

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index e9cee0ce6b46..9a57595d3248 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -22,6 +22,7 @@
 #include <linux/of_device.h>
 #include <linux/of_net.h>
 #include <linux/micrel_phy.h>
+#include <linux/units.h>
 #include <net/dsa.h>
 #include <net/pkt_cls.h>
 #include <net/switchdev.h>
@@ -3348,6 +3349,88 @@ static int ksz_tc_setup_qdisc_ets(struct dsa_switch *ds, int port,
 	return -EOPNOTSUPP;
 }
 
+static int ksz_reset_per_queue_rate_limit(struct ksz_device *dev, int port)
+{
+	int i, ret;
+
+	for (i = 0; i < dev->info->num_tx_queues; i++) {
+		ret = ksz_pwrite8(dev, port, KSZ9477_REG_PORT_OUT_RATE_0 + i, 0);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int ksz_setup_queue_rates(struct ksz_device *dev, int port, int queue,
+				 u64 max_rate)
+{
+	u8 val = 0;
+
+	/* Convert to from Bps to bps */
+	max_rate *= 8;
+
+	/* TODO: this conversation works only for 10 and 100Mbit links */
+	if (max_rate >= (1 * MEGA)) {
+		val = DIV_ROUND_CLOSEST_ULL(max_rate, 1 * MEGA);
+	}
+
+	return ksz_pwrite8(dev, port, KSZ9477_REG_PORT_OUT_RATE_0 + queue, val);
+}
+
+static int ksz_setup_tc_mqprio(struct dsa_switch *ds, int port,
+			       struct tc_mqprio_qopt_offload *mqprio)
+{
+	struct ksz_device *dev = ds->priv;
+	struct net_device *ndev;
+	int ret, queue;
+	u8 num_queues;
+	u8 num_tc;
+
+	mqprio->qopt.hw = TC_MQPRIO_HW_OFFLOAD_TCS;
+	ndev = ksz_port_to_netdev(dev, port);
+	num_queues = dev->info->num_tx_queues;
+	num_tc = mqprio->qopt.num_tc;
+
+	if (num_tc > num_queues)
+		return -EINVAL;
+
+	if (!num_tc) {
+		netdev_reset_tc(ndev);
+		return ksz_reset_per_queue_rate_limit(dev, port);
+	}
+
+	netdev_set_num_tc(ndev, mqprio->qopt.num_tc);
+
+	for (queue = 0; queue < mqprio->qopt.num_tc; queue++) {
+		netdev_set_tc_queue(ndev, queue, mqprio->qopt.count[queue],
+				    mqprio->qopt.offset[queue]);
+
+		ret = ksz_pwrite32(dev, port, REG_PORT_MTI_QUEUE_INDEX__4, queue);
+		if (ret)
+			return ret;
+
+		ret = ksz_setup_tc_mode(dev, port, MTI_SCHEDULE_STRICT_PRIO,
+					MTI_SHAPING_OFF);
+		if (ret)
+			return ret;
+	}
+
+	if (mqprio->shaper != TC_MQPRIO_SHAPER_BW_RATE)
+		return ksz_reset_per_queue_rate_limit(dev, port);
+
+	for (queue = 0; queue < mqprio->qopt.num_tc; queue++) {
+		ret = ksz_setup_queue_rates(dev, port, queue,
+					    mqprio->max_rate[queue]);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+
+
 static int ksz_setup_tc(struct dsa_switch *ds, int port,
 			enum tc_setup_type type, void *type_data)
 {
@@ -3357,6 +3440,8 @@ static int ksz_setup_tc(struct dsa_switch *ds, int port,
 	case TC_SETUP_QDISC_ETS:
 		ksz_tc_setup_qdisc_ets(ds, 2, type_data);
 		return ksz_tc_setup_qdisc_ets(ds, port, type_data);
+	case TC_SETUP_QDISC_MQPRIO:
+		return ksz_setup_tc_mqprio(ds, port, type_data);
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 7618a4714e06..e284538d6898 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -590,6 +590,17 @@ static inline int is_lan937x(struct ksz_device *dev)
 		dev->chip_id == LAN9374_CHIP_ID;
 }
 
+static inline struct net_device *ksz_port_to_netdev(struct ksz_device *dev,
+						    int port)
+{
+	struct dsa_switch *ds = dev->ds;
+
+	if (!dsa_is_user_port(ds, port))
+		return NULL;
+
+	return dsa_to_port(ds, port)->slave;
+}
+
 /* STP State Defines */
 #define PORT_TX_ENABLE			BIT(2)
 #define PORT_RX_ENABLE			BIT(1)

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
