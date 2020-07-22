Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6988A22A030
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 21:39:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726841AbgGVTiy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 15:38:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726322AbgGVTiy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 15:38:54 -0400
Received: from the.earth.li (the.earth.li [IPv6:2a00:1098:86:4d:c0ff:ee:15:900d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12DB9C0619DC;
        Wed, 22 Jul 2020 12:38:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=earth.li;
         s=the; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject
        :Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=GnczeIjxWZXuvAgu/k+KP3eIQzgZoam5q8JjSnqywo4=; b=B1wRYs+UaHzh44+7K46LA6t79S
        wj7eaj+Rf9MF8O5uLSuqr3n4bT4tG8NVkGyNeQmnalXO/f67Jx2YSc85qXBVchaJ/RjOE1xsSMYsv
        l9hfBfrTA6Pldyfaz04XmKgMeb3z9/6/JUqDhdhA4podlyJcZyIJ65FR37gXLquybw3kDBvax03Y+
        sDBWD9zAhfCIErwBTZkCUl2EcDwG3Ok3Y/SJ4Y/CEecRS1JxhdmRg8ghzKIzblsgeSKcTkYxEW7Vz
        G8Oz1YgAWiQCb9JdR134uMQRqkRRxNLTqd5GC78iGLu1C1bEmDgiD52zEX2MMenru5bKzFzxvMCfY
        dfqr33yw==;
Received: from noodles by the.earth.li with local (Exim 4.92)
        (envelope-from <noodles@earth.li>)
        id 1jyKZm-0003V2-EX; Wed, 22 Jul 2020 20:38:50 +0100
Date:   Wed, 22 Jul 2020 20:38:50 +0100
From:   Jonathan McDowell <noodles@earth.li>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Matthew Hagan <mnhagan88@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] net: dsa: qca8k: Add 802.1q VLAN support
Message-ID: <20200722193850.GM23489@earth.li>
References: <20200721171624.GK23489@earth.li>
 <1bf941f5-fdb3-3d9b-627a-a0464787b0ab@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1bf941f5-fdb3-3d9b-627a-a0464787b0ab@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 21, 2020 at 10:26:07AM -0700, Florian Fainelli wrote:
> On 7/21/20 10:16 AM, Jonathan McDowell wrote:
> > This adds full 802.1q VLAN support to the qca8k, allowing the use of
> > vlan_filtering and more complicated bridging setups than allowed by
> > basic port VLAN support.
> > 
> > Tested with a number of untagged ports with separate VLANs and then a
> > trunk port with all the VLANs tagged on it.
> 
> This looks good to me at first glance, at least not seeing obvious
> issue, however below are a few questions:

Thanks for the comments.

> - vid == 0 appears to be unsupported according to your port_vlan_prepare
> callback, is this really the case, or is it more a case of VID 0 should
> be pvid untagged, which is what dsa_slave_vlan_rx_add_vid() would
> attempt to program

I don't quite follow you here. VID 0 doesn't appear to be supported by
the hardware (and several other DSA drivers don't seem to like it
either), hence the check; I'm not clear if there's something alternate I
should be doing in that case instead?

> - since we have a qca8k_port_bridge_join() callback which programs the
> port lookup control register, putting all ports by default in VID==1
> does not break per-port isolation between non-bridged and bridged ports,
> right?

VLAN_MODE_NONE (set when we don't have VLAN filtering enabled)
configures us for port filtering, ignoring the VLAN info, so I think
we're good here.

> - since you program the ports with a default VLAN ID upon startup of the
> switch driver should not you also set
> dsa_switch::configure_vlan_while_not_filtering to indicate to the DSA
> layer that there is a VLAN table programmed regardless of VLAN filtering
> being enabled in the bridge or not?

Yup, this should be set. I'd seen the vlan_bridge_vtu patch from
December but not noticed it had been renamed, just assumed it hadn't
been applied.

> See some nitpicks below:
> 
> > 
> > Signed-off-by: Jonathan McDowell <noodles@earth.li>
> > 
> > diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> > index a5566de82853..cce05493075f 100644
> > --- a/drivers/net/dsa/qca8k.c
> > +++ b/drivers/net/dsa/qca8k.c
> > @@ -408,6 +408,104 @@ qca8k_fdb_flush(struct qca8k_priv *priv)
> >  	mutex_unlock(&priv->reg_mutex);
> >  }
> >  
> > +static int
> > +qca8k_vlan_access(struct qca8k_priv *priv, enum qca8k_vlan_cmd cmd, u16 vid)
> > +{
> > +	u32 reg;
> > +
> > +	/* Set the command and VLAN index */
> > +	reg = QCA8K_VTU_FUNC1_BUSY;> +	reg |= cmd;
> > +	reg |= vid << QCA8K_VTU_FUNC1_VID_S;
> > +
> > +	/* Write the function register triggering the table access */
> > +	qca8k_write(priv, QCA8K_REG_VTU_FUNC1, reg);
> > +
> > +	/* wait for completion */
> > +	if (qca8k_busy_wait(priv, QCA8K_REG_VTU_FUNC1, QCA8K_VTU_FUNC1_BUSY))
> > +		return -1;
> 
> Can you propagate the return value from qca8k_busy_wait() directly?

It just returns a boolean. rmk makes a valid point about a sensible
errno instead, so I'll switch to ETIMEDOUT in v2 (and ENOMEM when the
VLAN table is full below).

> > +
> > +	/* Check for table full violation when adding an entry */
> > +	if (cmd == QCA8K_VLAN_LOAD) {
> > +		reg = qca8k_read(priv, QCA8K_REG_VTU_FUNC1);
> > +		if (reg & QCA8K_VTU_FUNC1_FULL)
> > +			return -1;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static int
> > +qca8k_vlan_add(struct qca8k_priv *priv, u8 port, u16 vid, bool tagged)
> > +{
> > +	u32 reg;
> > +	int ret;
> > +
> > +	if (!vid)
> > +		return -EOPNOTSUPP;
> > +
> > +	mutex_lock(&priv->reg_mutex);
> > +	ret = qca8k_vlan_access(priv, QCA8K_VLAN_READ, vid);
> > +	if (ret >= 0) {
> 
> Do an early return upon negative error code instead of reidenting the
> code block?

I'll switch over to a goto for cleanup (unlocking the mutex) to avoid
the extra indentation (and below).

> > +		reg = qca8k_read(priv, QCA8K_REG_VTU_FUNC0);
> > +		reg |= QCA8K_VTU_FUNC0_VALID | QCA8K_VTU_FUNC0_IVL_EN;
> > +		reg &= ~(3 << QCA8K_VTU_FUNC0_EG_MODE_S(port));
> > +		if (tagged)
> > +			reg |= QCA8K_VTU_FUNC0_EG_MODE_TAG <<
> > +					QCA8K_VTU_FUNC0_EG_MODE_S(port);
> > +		else
> > +			reg |= QCA8K_VTU_FUNC0_EG_MODE_UNTAG <<
> > +					QCA8K_VTU_FUNC0_EG_MODE_S(port);
> > +
> > +		qca8k_write(priv, QCA8K_REG_VTU_FUNC0, reg);
> > +		ret = qca8k_vlan_access(priv, QCA8K_VLAN_LOAD, vid);
> > +	}
> > +	mutex_unlock(&priv->reg_mutex);
> > +
> > +	return ret;
> > +}
> > +
> > +static int
> > +qca8k_vlan_del(struct qca8k_priv *priv, u8 port, u16 vid)
> > +{
> > +	u32 reg;
> > +	u32 mask;
> > +	int ret;
> > +	int i;
> > +	bool del;
> > +
> > +	mutex_lock(&priv->reg_mutex);
> > +	ret = qca8k_vlan_access(priv, QCA8K_VLAN_READ, vid);
> > +	if (ret >= 0) {
> 
> Likewise

J.

-- 
"Editing plain text configuration files has never been the Unix way,
and vi certainly isn't a standard unix tool." - mjg59, QOOC.
