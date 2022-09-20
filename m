Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2D105BE5EC
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 14:34:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbiITMeE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 08:34:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229982AbiITMeD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 08:34:03 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 317365F10D
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 05:34:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Ct+8gIvftaPnkAh2I2JZ4hjfPe5MKCLXu1FqfoB15SI=; b=iAkjxrAdo/mdhXZBsoeCuWO74P
        lv74tyIHTTpNR+kgrAvpE5bNP+7UqPsNdqTLG6ntYuUQbX8o3yXWbfVeNbFAOhbvA1U2vJmMpc6Jo
        Vtic0W/sr0HP8nppx2zuRIMzpwRpTALrCzVcwvpycHZ2jhPMl/s2Vq/YxihET/SFOR6Q=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oacRr-00HGdr-EE; Tue, 20 Sep 2022 14:33:59 +0200
Date:   Tue, 20 Sep 2022 14:33:59 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "mattias.forsblad@gmail.com" <mattias.forsblad@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Christian Marangi <ansuelsmth@gmail.com>
Subject: Re: [PATCH rfc v0 8/9] net: dsa: qca8k: Pass response buffer via
 dsa_rmu_request
Message-ID: <YymzN6O4lHQIGZdH@lunn.ch>
References: <20220919110847.744712-3-mattias.forsblad@gmail.com>
 <20220919221853.4095491-1-andrew@lunn.ch>
 <20220919110847.744712-3-mattias.forsblad@gmail.com>
 <20220919221853.4095491-1-andrew@lunn.ch>
 <20220919221853.4095491-9-andrew@lunn.ch>
 <20220919221853.4095491-9-andrew@lunn.ch>
 <20220920002755.wdmv67yiybksqji4@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220920002755.wdmv67yiybksqji4@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 20, 2022 at 12:27:56AM +0000, Vladimir Oltean wrote:
> On Tue, Sep 20, 2022 at 12:18:52AM +0200, Andrew Lunn wrote:
> > Make the calling of operations on the switch more like a request
> > response API by passing the address of the response buffer, rather
> > than making use of global state.
> > 
> > To avoid race conditions with the completion timeout, and late
> > arriving responses, protect the resp members via a mutex.
> 
> Cannot be a mutex; the context of qca8k_rw_reg_ack_handler(), caller of
> dsa_inband_complete(), is NET_RX softirq and that is not sleepable.

Thanks. I will make it a spinlock.

> >  static struct sk_buff *qca8k_alloc_mdio_header(enum mdio_cmd cmd, u32 reg, u32 *val,
> > @@ -230,6 +230,7 @@ static int qca8k_read_eth(struct qca8k_priv *priv, u32 reg, u32 *val, int len)
> >  {
> >  	struct qca8k_mgmt_eth_data *mgmt_eth_data = &priv->mgmt_eth_data;
> >  	struct sk_buff *skb;
> > +	u32 data[4];
> >  	int ret;
> >  
> >  	skb = qca8k_alloc_mdio_header(MDIO_READ, reg, NULL,
> > @@ -249,12 +250,13 @@ static int qca8k_read_eth(struct qca8k_priv *priv, u32 reg, u32 *val, int len)
> >  	skb->dev = priv->mgmt_master;
> >  
> >  	ret = dsa_inband_request(&mgmt_eth_data->inband, skb,
> > -			      qca8k_mdio_header_fill_seq_num,
> > -			      QCA8K_ETHERNET_TIMEOUT);
> 
> Argument list should have been properly aligned when this patch set introduced it.
> 
> > +				 qca8k_mdio_header_fill_seq_num,
> > +				 &data, sizeof(data),
> > +				 QCA8K_ETHERNET_TIMEOUT);
> 
> Kind of feeling the need for an error check right here, instead of
> proceeding to look at the buffer.

Yes, i can add an error check. data is however safe to access, even if
it is uninitilized. It is on this functions stack and known to be big
enough.

> 
> >  
> > -	*val = mgmt_eth_data->data[0];
> > +	*val = data[0];
> >  	if (len > QCA_HDR_MGMT_DATA1_LEN)
> > -		memcpy(val + 1, mgmt_eth_data->data + 1, len - QCA_HDR_MGMT_DATA1_LEN);
> > +		memcpy(val + 1, &data[1], len - QCA_HDR_MGMT_DATA1_LEN);
> 
> This is pretty hard to digest, but it looks like it could work.
> So this can run concurrently with qca8k_rw_reg_ack_handler(), but since
> the end of dsa_inband_request() sets inband->resp to NULL, then even if
> the response will come later, it won't touch the driver-provided on-stack
> buffer, since the DSA completion structure lost the reference to it.

Yes, that is what i want the mutex for, soon to become a spinlock.

> 
> How do we deal with the response being processed so late by the handler
> that it overlaps with the dsa_inband_request() call of the next seqid?
> We open up to another window of opportunity for the handler to have a
> valid buffer and length to which it can copy stuff. Does it matter,
> since the seqid of the response will be smaller than that of the request?

That is what i need to look at. So long as the sequence number is
incremented first, then the completion reinitialized, i think we are
safe.

> Is reordering on multi-CPU, multi-queue masters handled in any way? This
> will be a problem regardless of QoS - currently we assume that all
> management frames are treated the same by the DSA master. But it has no
> insight into the DSA header format, so why would it? It could be doing
> RSS and even find some entropy in our seqid junk data. It's a bit late
> to think through right now.

There is a big mutex serializing all inband operations. There should
never be two or more valid operations in flight.

The way the sequence numbers work, i think in theory you could have
multiple operations in flight and the hardware would do the right
thing, and you could get a little bit more performance. But you really
need to worry about packets getting reordered. I've no numbers yet,
but i think the performance gains from MDIO to single in flight inband
is sufficient we don't need to worry about squeezing the last bit of
performance out.

> >  struct qca8k_mib_eth_data {
> > diff --git a/include/net/dsa.h b/include/net/dsa.h
> > index 1a920f89b667..dad9e31d36ce 100644
> > --- a/include/net/dsa.h
> > +++ b/include/net/dsa.h
> > @@ -1285,12 +1285,17 @@ struct dsa_inband {
> >  	u32 seqno;
> >  	u32 seqno_mask;
> >  	int err;
> > +	struct mutex resp_lock; /* Protects resp* members */
> > +	void *resp;
> > +	unsigned int resp_len;
> 
> Would be good to be a bit more verbose about what "protecting" means
> here (just offering a consistent view of the buffer pointer and of its
> length from DSA's perspective).

Yes, i can expand the comment.

> > -void dsa_inband_complete(struct dsa_inband *inband, int err)
> > +void dsa_inband_complete(struct dsa_inband *inband,
> > +			 void *resp, unsigned int resp_len,
> > +			 int err)
> >  {
> >  	inband->err = err;
> > +
> > +	mutex_lock(&inband->resp_lock);
> > +	resp_len = min(inband->resp_len, resp_len);
> 
> No warning for truncation caused by resp_len > inband->resp_len?
> It seems like a valid error. At least I tried to test Mattias' patch
> set, and this is one of the problems that really happened.

I need to go back and look at Mattias patches, but he made the comment
that you don't always know the size of the response. It can be family
dependent. I think the 6390 adds additional statistics, so its
response it going to be bigger than other devices. We don't currently
handle those additional statistics. I made the same comment as you
did, maybe return -ENOBUF or something if it truncates. QCA8k is
simpler in this respect, it can have a maximum of 12 bytes of optional
data, but given that the frame needs to be padded to 64 bytes, you
know you will always have those bytes, even if they are full of junk.

This is one of those areas where i'm not sure there is a correct
answer. Do more checking here, and force some complexity into the
caller? Truncate, but the caller has no idea a truncate has happened?

	Andrew
