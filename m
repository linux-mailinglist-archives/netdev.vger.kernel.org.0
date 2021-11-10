Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADDDA44C1B6
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 13:57:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231924AbhKJNAN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 08:00:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbhKJNAM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Nov 2021 08:00:12 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3BA7C061764;
        Wed, 10 Nov 2021 04:57:24 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id z21so10200695edb.5;
        Wed, 10 Nov 2021 04:57:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nVA+zfaDqSlr+gq4XxpbLUoZScXiFF2ADoBYZKMuCg0=;
        b=Mf7WRDcI6n3He/xcdw7vg7cyrIkXnpW+Oa5iYOEfrU94rYbBTbnIwv/5zz61usk3Pq
         wJdzblvjNJQhtupq1UHBgLUxhVuBTNns6ZzyOk7Ba0o3Txz1bpeq0PjeScZsKv7KsUn6
         +fg2s4esQ7oHsc2Cnv+5HZkejtw4yjWyo2aGwDnBBW9QjTukARPcyPH406XGPRykqgS/
         6JFwvUPeymyIYwQxnKpcPVZTl2qsd7mJJqVsp3HqsJPLp4EhysH84yD605GavO00DSc7
         DfN+9Gxh2RH0jiBa9PhgDGNTEwdJqTy9yRXhfXHg42n48G5rZr8AUrsD5F38d9i1Asdv
         KsXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nVA+zfaDqSlr+gq4XxpbLUoZScXiFF2ADoBYZKMuCg0=;
        b=zIX5kbo6fIcZqXp3QOwYI+fbI2DExy903RihnESOA7sru4URhYJqFXhZEp3MT1IkLk
         DKXeC/cVD+1zgEswWTpAO5enKA/HarbZkiXuh4mEgR6m23TP4epPEhQLZVECOtSriiuh
         WpJMyh4ELbxym0g6bFh46KWNUn88ryuCYF4Nf0e5iaY+m763wGWBwCfyDMGibEv3TQM4
         OqInhW/iQZEL4gYaTVTIjtOFl+nYE79uEtaEnW1P4KZVxNZD6hFPzTOTbj9sKIYCiaxd
         etadh8WCGuc6JoWXCD2upsvodSZBKjfpKmsOWSHkA34CLnj0SKpJ/jPNtka0TuBYlAuB
         GBGQ==
X-Gm-Message-State: AOAM530dHGRmQUW3m5efGhXnMU9kdTrkVH5EFzsldDbjtse+hY8idAmS
        Mug73fWAL/fb4XVoN3uonMA=
X-Google-Smtp-Source: ABdhPJxtlKlHkJ27mWZvmz2Crloxqd8G3ouyJYWn8vSUjqbSJ/816ieuthWR8aUK123OljChRqdvNw==
X-Received: by 2002:a17:906:4488:: with SMTP id y8mr20336979ejo.175.1636549043333;
        Wed, 10 Nov 2021 04:57:23 -0800 (PST)
Received: from skbuf ([188.25.175.102])
        by smtp.gmail.com with ESMTPSA id h20sm12766630eds.88.2021.11.10.04.57.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Nov 2021 04:57:23 -0800 (PST)
Date:   Wed, 10 Nov 2021 14:57:21 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Martin Kaistra <martin.kaistra@linutronix.de>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 6/7] net: dsa: b53: Add logic for TX timestamping
Message-ID: <20211110125721.jrmhv5jjgzbvheun@skbuf>
References: <20211109095013.27829-1-martin.kaistra@linutronix.de>
 <20211109095013.27829-7-martin.kaistra@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211109095013.27829-7-martin.kaistra@linutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 09, 2021 at 10:50:08AM +0100, Martin Kaistra wrote:
> In order to get the switch to generate a timestamp for a transmitted
> packet, we need to set the TS bit in the BRCM tag. The switch will then
> create a status frame, which gets send back to the cpu.
> In b53_port_txtstamp() we put the skb into a waiting position.
> 
> When a status frame is received, we extract the timestamp and put the time
> according to our timecounter into the waiting skb. When
> TX_TSTAMP_TIMEOUT is reached and we have no means to correctly get back
> a full timestamp, we cancel the process.
> 
> As the status frame doesn't contain a reference to the original packet,
> only one packet with timestamp request can be sent at a time.
> 
> Signed-off-by: Martin Kaistra <martin.kaistra@linutronix.de>
> ---
>  drivers/net/dsa/b53/b53_common.c |  1 +
>  drivers/net/dsa/b53/b53_ptp.c    | 56 ++++++++++++++++++++++++++++++++
>  drivers/net/dsa/b53/b53_ptp.h    |  8 +++++
>  net/dsa/tag_brcm.c               | 46 ++++++++++++++++++++++++++
>  4 files changed, 111 insertions(+)
> 
> diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
> index a9408f9cd414..56a9de89b38b 100644
> --- a/drivers/net/dsa/b53/b53_common.c
> +++ b/drivers/net/dsa/b53/b53_common.c
> @@ -2301,6 +2301,7 @@ static const struct dsa_switch_ops b53_switch_ops = {
>  	.port_change_mtu	= b53_change_mtu,
>  	.get_ts_info		= b53_get_ts_info,
>  	.port_rxtstamp		= b53_port_rxtstamp,
> +	.port_txtstamp		= b53_port_txtstamp,
>  };
>  
>  struct b53_chip_data {
> diff --git a/drivers/net/dsa/b53/b53_ptp.c b/drivers/net/dsa/b53/b53_ptp.c
> index f8dd8d484d93..5567135ba8b9 100644
> --- a/drivers/net/dsa/b53/b53_ptp.c
> +++ b/drivers/net/dsa/b53/b53_ptp.c
> @@ -100,14 +100,65 @@ static long b53_hwtstamp_work(struct ptp_clock_info *ptp)
>  {
>  	struct b53_device *dev =
>  		container_of(ptp, struct b53_device, ptp_clock_info);
> +	struct dsa_switch *ds = dev->ds;
> +	int i;
>  
>  	mutex_lock(&dev->ptp_mutex);
>  	timecounter_read(&dev->tc);
>  	mutex_unlock(&dev->ptp_mutex);
>  
> +	for (i = 0; i < ds->num_ports; i++) {
> +		struct b53_port_hwtstamp *ps;
> +
> +		if (!dsa_is_user_port(ds, i))
> +			continue;
> +
> +		ps = &dev->ports[i].port_hwtstamp;
> +
> +		if (test_bit(B53_HWTSTAMP_TX_IN_PROGRESS, &ps->state) &&
> +		    time_is_before_jiffies(ps->tx_tstamp_start +
> +					   TX_TSTAMP_TIMEOUT)) {
> +			dev_err(dev->dev,
> +				"Timeout while waiting for Tx timestamp!\n");
> +			dev_kfree_skb_any(ps->tx_skb);
> +			ps->tx_skb = NULL;
> +			clear_bit_unlock(B53_HWTSTAMP_TX_IN_PROGRESS,
> +					 &ps->state);
> +		}
> +	}
> +
>  	return B53_PTP_OVERFLOW_PERIOD;
>  }
>  
> +void b53_port_txtstamp(struct dsa_switch *ds, int port, struct sk_buff *skb)
> +{
> +	struct b53_device *dev = ds->priv;
> +	struct b53_port_hwtstamp *ps = &dev->ports[port].port_hwtstamp;
> +	struct sk_buff *clone;
> +	unsigned int type;
> +
> +	type = ptp_classify_raw(skb);
> +
> +	if (type != PTP_CLASS_V2_L2)
> +		return;
> +
> +	if (!test_bit(B53_HWTSTAMP_ENABLED, &ps->state))
> +		return;
> +
> +	clone = skb_clone_sk(skb);
> +	if (!clone)
> +		return;
> +
> +	if (test_and_set_bit_lock(B53_HWTSTAMP_TX_IN_PROGRESS, &ps->state)) {
> +		kfree_skb(clone);
> +		return;
> +	}
> +
> +	ps->tx_skb = clone;
> +	ps->tx_tstamp_start = jiffies;
> +}
> +EXPORT_SYMBOL(b53_port_txtstamp);
> +
>  bool b53_port_rxtstamp(struct dsa_switch *ds, int port, struct sk_buff *skb,
>  		       unsigned int type)
>  {
> @@ -136,6 +187,8 @@ EXPORT_SYMBOL(b53_port_rxtstamp);
>  
>  int b53_ptp_init(struct b53_device *dev)
>  {
> +	struct dsa_port *dp;
> +
>  	mutex_init(&dev->ptp_mutex);
>  
>  	/* Enable BroadSync HD for all ports */
> @@ -191,6 +244,9 @@ int b53_ptp_init(struct b53_device *dev)
>  
>  	ptp_schedule_worker(dev->ptp_clock, 0);
>  
> +	dsa_switch_for_each_port(dp, dev->ds)
> +		dp->priv = &dev->ports[dp->index].port_hwtstamp;
> +
>  	return 0;
>  }
>  EXPORT_SYMBOL(b53_ptp_init);
> diff --git a/drivers/net/dsa/b53/b53_ptp.h b/drivers/net/dsa/b53/b53_ptp.h
> index 3b3437870c55..f888f0a2022a 100644
> --- a/drivers/net/dsa/b53/b53_ptp.h
> +++ b/drivers/net/dsa/b53/b53_ptp.h
> @@ -10,6 +10,7 @@
>  #include "b53_priv.h"
>  
>  #define SKB_PTP_TYPE(__skb) (*(unsigned int *)((__skb)->cb))
> +#define TX_TSTAMP_TIMEOUT msecs_to_jiffies(40)
>  
>  #ifdef CONFIG_B53_PTP
>  int b53_ptp_init(struct b53_device *dev);
> @@ -18,6 +19,8 @@ int b53_get_ts_info(struct dsa_switch *ds, int port,
>  		    struct ethtool_ts_info *info);
>  bool b53_port_rxtstamp(struct dsa_switch *ds, int port, struct sk_buff *skb,
>  		       unsigned int type);
> +void b53_port_txtstamp(struct dsa_switch *ds, int port, struct sk_buff *skb);
> +
>  #else /* !CONFIG_B53_PTP */
>  
>  static inline int b53_ptp_init(struct b53_device *dev)
> @@ -41,5 +44,10 @@ static inline bool b53_port_rxtstamp(struct dsa_switch *ds, int port,
>  	return false;
>  }
>  
> +static inline void b53_port_txtstamp(struct dsa_switch *ds, int port,
> +				     struct sk_buff *skb)
> +{
> +}
> +
>  #endif
>  #endif
> diff --git a/net/dsa/tag_brcm.c b/net/dsa/tag_brcm.c
> index d611c1073deb..a44ac81fa097 100644
> --- a/net/dsa/tag_brcm.c
> +++ b/net/dsa/tag_brcm.c
> @@ -8,6 +8,7 @@
>  #include <linux/dsa/brcm.h>
>  #include <linux/etherdevice.h>
>  #include <linux/list.h>
> +#include <linux/ptp_classify.h>
>  #include <linux/slab.h>
>  #include <linux/dsa/b53.h>
>  
> @@ -76,6 +77,7 @@
>  #define BRCM_EG_TC_SHIFT	5
>  #define BRCM_EG_TC_MASK		0x7
>  #define BRCM_EG_PID_MASK	0x1f
> +#define BRCM_EG_T_R		0x20
>  
>  #if IS_ENABLED(CONFIG_NET_DSA_TAG_BRCM) || \
>  	IS_ENABLED(CONFIG_NET_DSA_TAG_BRCM_PREPEND)
> @@ -85,6 +87,8 @@ static struct sk_buff *brcm_tag_xmit_ll(struct sk_buff *skb,
>  					unsigned int offset)
>  {
>  	struct dsa_port *dp = dsa_slave_to_port(dev);
> +	unsigned int type = ptp_classify_raw(skb);
> +	struct b53_port_hwtstamp *ps = dp->priv;
>  	u16 queue = skb_get_queue_mapping(skb);
>  	u8 *brcm_tag;
>  
> @@ -112,7 +116,13 @@ static struct sk_buff *brcm_tag_xmit_ll(struct sk_buff *skb,
>  	 */
>  	brcm_tag[0] = (1 << BRCM_OPCODE_SHIFT) |
>  		       ((queue & BRCM_IG_TC_MASK) << BRCM_IG_TC_SHIFT);
> +
>  	brcm_tag[1] = 0;
> +
> +	if (type == PTP_CLASS_V2_L2 &&
> +	    test_bit(B53_HWTSTAMP_TX_IN_PROGRESS, &ps->state))

Introducing dp->priv must be one of the most stupid things I've ever done.
I'm sorry for this, I'll try to remove it over the weekend.
Here you are dereferencing dp->priv without checking for NULL. But you
are only populating dp->priv if CONFIG_B53_PTP is enabled. So if a
"malicious" user space program sends a PTP event packet without
requesting timestamping, and PTP support is turned off, the kernel is toast.

In other news, you should not blindly timestamp any packet that looks
like PTP. You should look at (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP),
AND (this is important) whether the HWTSTAMP_TX_ON ioctl flag was passed
to _your_ driver. Otherwise, PHY timestamping will be broken and people
will wonder why (it still is, currently, because DSA doesn't call
skb_tx_timestamp(). but that is way easier to debug and fix than it
would be to get timestamps from the unintended PHC). Or even
PTP timestamping of a DSA switch cascaded beneath a b53 port, in a
disjoint tree setup. Please take a look at chapter "3.2.4 Other caveats
for MAC drivers" from Documentation/networking/timestamping.rst (a bit
ironic, I know, I've been RTFM'ed with this same file in the same
thread).

> +		brcm_tag[1] = 1 << BRCM_IG_TS_SHIFT;
> +
>  	brcm_tag[2] = 0;
>  	if (dp->index == 8)
>  		brcm_tag[2] = BRCM_IG_DSTMAP2_MASK;
> @@ -126,6 +136,33 @@ static struct sk_buff *brcm_tag_xmit_ll(struct sk_buff *skb,
>  	return skb;
>  }
>  
> +static int set_txtstamp(struct dsa_port *dp,
> +			int port,
> +			u64 ns)
> +{
> +	struct b53_device *b53_dev = dp->ds->priv;
> +	struct b53_port_hwtstamp *ps = dp->priv;
> +	struct skb_shared_hwtstamps shhwtstamps;
> +	struct sk_buff *tmp_skb;
> +
> +	if (!ps->tx_skb)
> +		return 0;
> +
> +	mutex_lock(&b53_dev->ptp_mutex);
> +	ns = timecounter_cyc2time(&b53_dev->tc, ns);
> +	mutex_unlock(&b53_dev->ptp_mutex);
> +
> +	memset(&shhwtstamps, 0, sizeof(shhwtstamps));
> +	shhwtstamps.hwtstamp = ns_to_ktime(ns);
> +	tmp_skb = ps->tx_skb;
> +	ps->tx_skb = NULL;
> +
> +	clear_bit_unlock(B53_HWTSTAMP_TX_IN_PROGRESS, &ps->state);
> +	skb_complete_tx_timestamp(tmp_skb, &shhwtstamps);
> +
> +	return 0;
> +}
> +
>  /* Frames with this tag have one of these two layouts:
>   * -----------------------------------
>   * | MAC DA | MAC SA | 4b tag | Type | DSA_TAG_PROTO_BRCM
> @@ -143,6 +180,7 @@ static struct sk_buff *brcm_tag_rcv_ll(struct sk_buff *skb,
>  				       unsigned int offset,
>  				       int *tag_len)
>  {
> +	struct dsa_port *dp;
>  	int source_port;
>  	u8 *brcm_tag;
>  	u32 tstamp;
> @@ -177,6 +215,14 @@ static struct sk_buff *brcm_tag_rcv_ll(struct sk_buff *skb,
>  	if (!skb->dev)
>  		return NULL;
>  
> +	/* Check whether this is a status frame */
> +	if (unlikely(*tag_len == 8 && brcm_tag[3] & BRCM_EG_T_R)) {
> +		dp = dsa_slave_to_port(skb->dev);
> +
> +		set_txtstamp(dp, source_port, tstamp);
> +		return NULL;
> +	}
> +
>  	/* Remove Broadcom tag and update checksum */
>  	skb_pull_rcsum(skb, *tag_len);
>  
> -- 
> 2.20.1
> 
