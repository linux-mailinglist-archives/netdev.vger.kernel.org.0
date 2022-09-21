Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CC7B5BF1E2
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 02:20:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230295AbiIUAT7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 20:19:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbiIUAT6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 20:19:58 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 516B8201B7
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 17:19:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=94SM7CnVRkA70dpbA13YvwV/WgokwguF8Orn/V7awaA=; b=CYUIAgDSdkSVPwh6qNP3CR7oJK
        VIXK4LgA6xLtMfA5ZkDiCf+GCvUFI+UcpNARuOMbB10eibKsiLa9RwSueP+wHHdPn7GEJElgMJPbo
        5eXzFqValzEr6Gefi4BkzxffCPAOfK9exndf02OYM0rk7MlhReZ08JBTwb7hnaTCqb0g=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oanT0-00HJlP-DE; Wed, 21 Sep 2022 02:19:54 +0200
Date:   Wed, 21 Sep 2022 02:19:54 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "mattias.forsblad@gmail.com" <mattias.forsblad@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Christian Marangi <ansuelsmth@gmail.com>
Subject: Re: [PATCH rfc v0 2/9] net: dsa: qca8k: Move completion into DSA core
Message-ID: <YypYqqwgllmcPJZj@lunn.ch>
References: <20220919110847.744712-3-mattias.forsblad@gmail.com>
 <20220919221853.4095491-1-andrew@lunn.ch>
 <20220919221853.4095491-3-andrew@lunn.ch>
 <20220920144303.c5kxvbxlwf6jdx2g@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220920144303.c5kxvbxlwf6jdx2g@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 20, 2022 at 02:43:04PM +0000, Vladimir Oltean wrote:
> On Tue, Sep 20, 2022 at 12:18:46AM +0200, Andrew Lunn wrote:
> > @@ -248,8 +248,6 @@ static int qca8k_read_eth(struct qca8k_priv *priv, u32 reg, u32 *val, int len)
> >  
> >  	skb->dev = priv->mgmt_master;
> >  
> > -	reinit_completion(&mgmt_eth_data->rw_done);
> > -
> >  	/* Increment seq_num and set it in the mdio pkt */
> >  	mgmt_eth_data->seq++;
> >  	qca8k_mdio_header_fill_seq_num(skb, mgmt_eth_data->seq);
> > @@ -257,8 +255,8 @@ static int qca8k_read_eth(struct qca8k_priv *priv, u32 reg, u32 *val, int len)
> >  
> >  	dev_queue_xmit(skb);
> >  
> > -	ret = wait_for_completion_timeout(&mgmt_eth_data->rw_done,
> > -					  QCA8K_ETHERNET_TIMEOUT);
> > +	ret = dsa_inband_wait_for_completion(&mgmt_eth_data->inband,
> > +					     QCA8K_ETHERNET_TIMEOUT);
> >  
> >  	*val = mgmt_eth_data->data[0];
> >  	if (len > QCA_HDR_MGMT_DATA1_LEN)
> 
> Replacing the pattern above with this pattern:
> 
> int dsa_inband_wait_for_completion(struct dsa_inband *inband, int timeout_ms)
> {
> 	unsigned long jiffies = msecs_to_jiffies(timeout_ms);
> 
> 	reinit_completion(&inband->completion);
> 
> 	return wait_for_completion_timeout(&inband->completion, jiffies);
> }
> 
> is buggy because we reinitialize the completion later than the original
> code used to. We now call reinit_completion() from a code path that
> races with the handler that is supposed to call dsa_inband_complete().

I've been thinking about this a bit. And i think the bug is in the old
code.

As soon as we call reinit_completion(), a late arriving packet can
trigger the completion. Note that the sequence number has not been
incremented yet. So that late arriving packet can pass the sequence
number test, and the results will be copied and complete() called.

qca8k_read_eth() can continue, increment the sequence number, call
wait_for_completion_timeout() and immediately exit, returning the
contents of the late arriving reply.

To make this safe:

1) The sequence number needs to be incremented before
   reinit_completion(). That closes one race

2) If the sequence numbers don't match, silently drop the packet, it
   is either later, or bogus. Hopefully the correct reply packet will
   come along soon and trigger the completion.

I've also got some of this wrong in my code.

     Andrew
