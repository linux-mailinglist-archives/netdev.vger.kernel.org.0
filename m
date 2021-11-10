Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CFB744BD37
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 09:43:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230312AbhKJIq1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 03:46:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230318AbhKJIqZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Nov 2021 03:46:25 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BF94C061764;
        Wed, 10 Nov 2021 00:43:38 -0800 (PST)
Message-ID: <139d7989-629f-6216-7ae4-a9c2dfbea8d0@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1636533815;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BaCdPVLt3LH31qmIYERVcQuW1qRTSezMav4tuaHTI7I=;
        b=vs/gZuNz6fo8ahaWWAVhUEjnztVnR3fS3A8fm0UDalI2uqb2Z9AWyFgjJVn7l2Evq8NxTq
        qy157GeDrYOncmlqV6OIEWQTVfc7JPWraW1NwCCEvMv4lIE05LoRi5Ike5Mgwf32V+T2f9
        05gxuIafC2FDHxk1jCh2gO5XvYznWMPCjz/1jx1ODyC8psnCoish0ZEaY942Ych5PAP0MY
        kPcv01gPkJyVQIknOZP0L1DBt6+XseB5WG4ZZFdetFuziQfA3SUaahIHj/IiapU5fMtvag
        kFcRiSOArLVuuXnVTPE7LfOFk0Wv/Q9M5Et/2S6VzeZ5LzLp97u9G5tFd9B5lg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1636533815;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BaCdPVLt3LH31qmIYERVcQuW1qRTSezMav4tuaHTI7I=;
        b=7eumjWboScUh+cWycQYVLznpeO4b+Ukq81VrHl0Lk4rP1CdgO+D9samIoB3gWuFs7Hf7Wq
        nwh+ltnYcJ4x46Bw==
Date:   Wed, 10 Nov 2021 09:43:35 +0100
MIME-Version: 1.0
Subject: Re: [PATCH v2 5/7] net: dsa: b53: Add logic for RX timestamping
Content-Language: de-DE
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
References: <20211109095013.27829-1-martin.kaistra@linutronix.de>
 <20211109095013.27829-6-martin.kaistra@linutronix.de>
 <9d9f3b13-051c-0c6d-e2cb-b64bbee2522f@gmail.com>
From:   Martin Kaistra <martin.kaistra@linutronix.de>
In-Reply-To: <9d9f3b13-051c-0c6d-e2cb-b64bbee2522f@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 09.11.21 um 19:07 schrieb Florian Fainelli:
> On 11/9/21 1:50 AM, Martin Kaistra wrote:
>> Packets received by the tagger with opcode=1 contain the 32-bit timestamp
>> according to the timebase register. This timestamp is saved in
>> BRCM_SKB_CB(skb)->meta_tstamp. b53_port_rxtstamp() takes this
>> and puts the full time information from the timecounter into
>> shwt->hwtstamp.
>>
>> Signed-off-by: Martin Kaistra <martin.kaistra@linutronix.de>
>> ---
>>   drivers/net/dsa/b53/b53_common.c |  1 +
>>   drivers/net/dsa/b53/b53_ptp.c    | 28 +++++++++++++++++++++++++
>>   drivers/net/dsa/b53/b53_ptp.h    | 10 +++++++++
>>   include/linux/dsa/b53.h          | 30 +++++++++++++++++++++++++++
>>   net/dsa/tag_brcm.c               | 35 ++++++++++++++++++++++++--------
>>   5 files changed, 95 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
>> index ed590efbd3bf..a9408f9cd414 100644
>> --- a/drivers/net/dsa/b53/b53_common.c
>> +++ b/drivers/net/dsa/b53/b53_common.c
>> @@ -2300,6 +2300,7 @@ static const struct dsa_switch_ops b53_switch_ops = {
>>   	.port_max_mtu		= b53_get_max_mtu,
>>   	.port_change_mtu	= b53_change_mtu,
>>   	.get_ts_info		= b53_get_ts_info,
>> +	.port_rxtstamp		= b53_port_rxtstamp,
>>   };
>>   
>>   struct b53_chip_data {
>> diff --git a/drivers/net/dsa/b53/b53_ptp.c b/drivers/net/dsa/b53/b53_ptp.c
>> index 8629c510b1a0..f8dd8d484d93 100644
>> --- a/drivers/net/dsa/b53/b53_ptp.c
>> +++ b/drivers/net/dsa/b53/b53_ptp.c
>> @@ -6,6 +6,8 @@
>>    * Copyright (C) 2021 Linutronix GmbH
>>    */
>>   
>> +#include <linux/ptp_classify.h>
>> +
>>   #include "b53_priv.h"
>>   #include "b53_ptp.h"
>>   
>> @@ -106,6 +108,32 @@ static long b53_hwtstamp_work(struct ptp_clock_info *ptp)
>>   	return B53_PTP_OVERFLOW_PERIOD;
>>   }
>>   
>> +bool b53_port_rxtstamp(struct dsa_switch *ds, int port, struct sk_buff *skb,
>> +		       unsigned int type)
>> +{
>> +	struct b53_device *dev = ds->priv;
>> +	struct b53_port_hwtstamp *ps = &dev->ports[port].port_hwtstamp;
>> +	struct skb_shared_hwtstamps *shwt;
>> +	u64 ns;
> 
> I had asked you to store b53_port_hwtstamp into dp->priv, any reason for
> not doing that?

I am sorry, I must have misunderstood you. tag_brcm.c ist now accessing 
b53_port_hwtstamp via dp->priv (like in the sja1105 driver). It should 
also be possible, to store it only in there.

> 
>> +
>> +	if (type != PTP_CLASS_V2_L2)
>> +		return false;
>> +
>> +	if (!test_bit(B53_HWTSTAMP_ENABLED, &ps->state))
>> +		return false;
>> +
>> +	mutex_lock(&dev->ptp_mutex);
>> +	ns = timecounter_cyc2time(&dev->tc, BRCM_SKB_CB(skb)->meta_tstamp);
>> +	mutex_unlock(&dev->ptp_mutex);
>> +
>> +	shwt = skb_hwtstamps(skb);
>> +	memset(shwt, 0, sizeof(*shwt));
>> +	shwt->hwtstamp = ns_to_ktime(ns);
>> +
>> +	return false;
>> +}
>> +EXPORT_SYMBOL(b53_port_rxtstamp);
>> +
>>   int b53_ptp_init(struct b53_device *dev)
>>   {
>>   	mutex_init(&dev->ptp_mutex);
>> diff --git a/drivers/net/dsa/b53/b53_ptp.h b/drivers/net/dsa/b53/b53_ptp.h
>> index 5cd2fd9621a2..3b3437870c55 100644
>> --- a/drivers/net/dsa/b53/b53_ptp.h
>> +++ b/drivers/net/dsa/b53/b53_ptp.h
>> @@ -9,11 +9,15 @@
>>   
>>   #include "b53_priv.h"
>>   
>> +#define SKB_PTP_TYPE(__skb) (*(unsigned int *)((__skb)->cb))
>> +
>>   #ifdef CONFIG_B53_PTP
>>   int b53_ptp_init(struct b53_device *dev);
>>   void b53_ptp_exit(struct b53_device *dev);
>>   int b53_get_ts_info(struct dsa_switch *ds, int port,
>>   		    struct ethtool_ts_info *info);
>> +bool b53_port_rxtstamp(struct dsa_switch *ds, int port, struct sk_buff *skb,
>> +		       unsigned int type);
>>   #else /* !CONFIG_B53_PTP */
>>   
>>   static inline int b53_ptp_init(struct b53_device *dev)
>> @@ -31,5 +35,11 @@ static inline int b53_get_ts_info(struct dsa_switch *ds, int port,
>>   	return -EOPNOTSUPP;
>>   }
>>   
>> +static inline bool b53_port_rxtstamp(struct dsa_switch *ds, int port,
>> +				     struct sk_buff *skb, unsigned int type)
>> +{
>> +	return false;
>> +}
>> +
>>   #endif
>>   #endif
>> diff --git a/include/linux/dsa/b53.h b/include/linux/dsa/b53.h
>> index 85aa6d9dc53d..542e5e3040d6 100644
>> --- a/include/linux/dsa/b53.h
>> +++ b/include/linux/dsa/b53.h
>> @@ -46,9 +46,32 @@ struct b53_io_ops {
>>   					struct phylink_link_state *state);
>>   };
>>   
>> +/* state flags for b53_port_hwtstamp::state */
>> +enum {
>> +	B53_HWTSTAMP_ENABLED,
>> +	B53_HWTSTAMP_TX_IN_PROGRESS,
>> +};
>> +
>> +struct b53_port_hwtstamp {
>> +	/* Port index */
>> +	int port_id;
> 
> unsigned int;
> 
>> +
>> +	/* Timestamping state */
>> +	unsigned long state;
>> +
>> +	/* Resources for transmit timestamping */
>> +	unsigned long tx_tstamp_start;
>> +	struct sk_buff *tx_skb;
>> +
>> +	/* Current timestamp configuration */
>> +	struct hwtstamp_config tstamp_config;
>> +};
>> +
>>   struct b53_port {
>>   	u16 vlan_ctl_mask;
>>   	struct ethtool_eee eee;
>> +	/* Per-port timestamping resources */
>> +	struct b53_port_hwtstamp port_hwtstamp;
>>   };
>>   
>>   struct b53_vlan {
>> @@ -112,3 +135,10 @@ struct b53_device {
>>   #define B53_PTP_OVERFLOW_PERIOD (HZ / 2)
>>   	struct delayed_work overflow_work;
>>   };
>> +
>> +struct brcm_skb_cb {
>> +	struct sk_buff *clone;
>> +	u32 meta_tstamp;
>> +};
>> +
>> +#define BRCM_SKB_CB(skb) ((struct brcm_skb_cb *)(skb)->cb)
>> diff --git a/net/dsa/tag_brcm.c b/net/dsa/tag_brcm.c
>> index 96dbb8ee2fee..d611c1073deb 100644
>> --- a/net/dsa/tag_brcm.c
>> +++ b/net/dsa/tag_brcm.c
>> @@ -9,6 +9,7 @@
>>   #include <linux/etherdevice.h>
>>   #include <linux/list.h>
>>   #include <linux/slab.h>
>> +#include <linux/dsa/b53.h>
>>   
>>   #include "dsa_priv.h"
>>   
>> @@ -31,7 +32,10 @@
>>   /* 6th byte in the tag */
>>   #define BRCM_LEG_PORT_ID	(0xf)
>>   
>> -/* Newer Broadcom tag (4 bytes) */
>> +/* Newer Broadcom tag (4 bytes)
>> + * For egress, when opcode = 0001, additional 4 bytes are used for
>> + * the time stamp.
>> + */
>>   #define BRCM_TAG_LEN	4
>>   
>>   /* Tag is constructed and desconstructed using byte by byte access
>> @@ -136,19 +140,29 @@ static struct sk_buff *brcm_tag_xmit_ll(struct sk_buff *skb,
>>    */
>>   static struct sk_buff *brcm_tag_rcv_ll(struct sk_buff *skb,
>>   				       struct net_device *dev,
>> -				       unsigned int offset)
>> +				       unsigned int offset,
>> +				       int *tag_len)
> 
> unsigned int tag_len.
> 
