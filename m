Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 906F523307A
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 12:40:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729025AbgG3Kki (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 06:40:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726819AbgG3Kkh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 06:40:37 -0400
Received: from the.earth.li (the.earth.li [IPv6:2a00:1098:86:4d:c0ff:ee:15:900d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46781C061794;
        Thu, 30 Jul 2020 03:40:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=earth.li;
         s=the; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject
        :Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=E3AZ3pLcXHiTa8y0cu9vg0iCiq6X1gsc4YSVmWzL2ug=; b=Xz5oki38ODj89iqPtHc5HcKKQ6
        JGqR/jL5UqiqGLpnU5Hf9kGXDoQDImTfikk242HnCV6ktkvMmY7T5lqyzY4IICClMFuvmTkIAhXtO
        l3HBHkvXxWCD0vmDPxzfu5iRNyJc66el5+ERBe4TjbKIfWQoR48z/cXxgg3IzDgcP71VLTiARlAvq
        p+KdepwKktrg/drzdFyUooZDdq8tI5RV5bWN/rB5BsJtZscpXXoe+loOrmYxlQFhd9pq8R3uuxhD2
        GghN6mvsxNaAMhUTXX8A2u9uJJV0ZkzV/uFO0GgJOQctbDWZXJGYL6pbldvJ31WBSXnxwSoQuNBu4
        PDZ2+PPg==;
Received: from noodles by the.earth.li with local (Exim 4.92)
        (envelope-from <noodles@earth.li>)
        id 1k15zB-0003kD-8H; Thu, 30 Jul 2020 11:40:29 +0100
Date:   Thu, 30 Jul 2020 11:40:29 +0100
From:   Jonathan McDowell <noodles@earth.li>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Matthew Hagan <mnhagan88@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2] net: dsa: qca8k: Add 802.1q VLAN support
Message-ID: <20200730104029.GB21409@earth.li>
References: <20200721171624.GK23489@earth.li>
 <20200726145611.GA31479@earth.li>
 <20200728163457.imcrsuj7w2la5inp@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200728163457.imcrsuj7w2la5inp@skbuf>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 28, 2020 at 07:34:57PM +0300, Vladimir Oltean wrote:
> Hi Jonathan,
> 
> On Sun, Jul 26, 2020 at 03:56:11PM +0100, Jonathan McDowell wrote:
> > This adds full 802.1q VLAN support to the qca8k, allowing the use of
> > vlan_filtering and more complicated bridging setups than allowed by
> > basic port VLAN support.
> > 
> > Tested with a number of untagged ports with separate VLANs and then a
> > trunk port with all the VLANs tagged on it.
> > 
> > v2:
> > - Return sensible errnos on failure rather than -1 (rmk)
> > - Style cleanups based on Florian's feedback
> > - Silently allow VLAN 0 as device correctly treats this as no tag
> > 
> > Signed-off-by: Jonathan McDowell <noodles@earth.li>
> > ---
> 
> This generally looks ok. The integration with the APIs is fine.
> Some comments below.
> 
> >  drivers/net/dsa/qca8k.c | 191 ++++++++++++++++++++++++++++++++++++++--
> >  drivers/net/dsa/qca8k.h |  28 ++++++
> >  2 files changed, 214 insertions(+), 5 deletions(-)
> > 
> > diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> > index a5566de82853..1cc61bc8929f 100644
> > --- a/drivers/net/dsa/qca8k.c
> > +++ b/drivers/net/dsa/qca8k.c
> > @@ -408,6 +408,111 @@ qca8k_fdb_flush(struct qca8k_priv *priv)
> >  	mutex_unlock(&priv->reg_mutex);
> >  }
> >  
> > +static int
> > +qca8k_vlan_access(struct qca8k_priv *priv, enum qca8k_vlan_cmd cmd, u16 vid)
> > +{
> > +	u32 reg;
> > +
> > +	/* Set the command and VLAN index */
> > +	reg = QCA8K_VTU_FUNC1_BUSY;
> > +	reg |= cmd;
> > +	reg |= vid << QCA8K_VTU_FUNC1_VID_S;
> > +
> > +	/* Write the function register triggering the table access */
> > +	qca8k_write(priv, QCA8K_REG_VTU_FUNC1, reg);
> > +
> > +	/* wait for completion */
> > +	if (qca8k_busy_wait(priv, QCA8K_REG_VTU_FUNC1, QCA8K_VTU_FUNC1_BUSY))
> > +		return -ETIMEDOUT;
> > +
> > +	/* Check for table full violation when adding an entry */
> > +	if (cmd == QCA8K_VLAN_LOAD) {
> > +		reg = qca8k_read(priv, QCA8K_REG_VTU_FUNC1);
> > +		if (reg & QCA8K_VTU_FUNC1_FULL)
> > +			return -ENOMEM;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static int
> > +qca8k_vlan_add(struct qca8k_priv *priv, u8 port, u16 vid, bool tagged)
> 
> It is customary to keep referring to this bool as 'untagged' for
> consistency with many other parts of the kernel.

Ok, changed.

> > +{
> > +	u32 reg;
> > +	int ret;
> > +
> > +	/* We do the right thing with VLAN 0 and treat it as untagged */
> 
> ...while also preserving the tag on egress.
> 
> > +	if (vid == 0)
> > +		return 0;
> > +
> > +	mutex_lock(&priv->reg_mutex);
> 
> Unrelated, but what's the purpose of this mutex?

The access to the VLAN configuration is a set of writes to multiple
registers, so the mutex is to avoid trying to do 2 updates at the same
time. Same principle as is applied for the existing FDB accesses.

> > +	ret = qca8k_vlan_access(priv, QCA8K_VLAN_READ, vid);
> > +	if (ret < 0)
> > +		goto out;
> > +
> > +	reg = qca8k_read(priv, QCA8K_REG_VTU_FUNC0);
> > +	reg |= QCA8K_VTU_FUNC0_VALID | QCA8K_VTU_FUNC0_IVL_EN;
> > +	reg &= ~(3 << QCA8K_VTU_FUNC0_EG_MODE_S(port));
> > +	if (tagged)
> > +		reg |= QCA8K_VTU_FUNC0_EG_MODE_TAG <<
> > +				QCA8K_VTU_FUNC0_EG_MODE_S(port);
> > +	else
> > +		reg |= QCA8K_VTU_FUNC0_EG_MODE_UNTAG <<
> > +				QCA8K_VTU_FUNC0_EG_MODE_S(port);
> > +
> 
> Not thrilled about the "3 <<" thing, maybe a definition like the one
> below would look better:
> 
> #define QCA8K_VTU_FUNC_REG0_EG_VLAN_MODE_MASK(port) \
> 	GENMASK(5 + (port) * 2, 4 + (port) * 2)
> 
> ...
> 
> 	int eg_vlan_mode = QCA8K_VTU_FUNC_REG0_EG_MODE_TAG;
> 
> 	reg &= ~QCA8K_VTU_FUNC_REG0_EG_VLAN_MODE_MASK(port);
> 	if (tagged)
> 		eg_vlan_mode = QCA8K_VTU_FUNC_REG0_EG_MODE_UNTAG;
> 	reg |= QCA8K_VTU_FUNC_REG0_EG_MODE(eg_vlan_mode, port);
> 
> Your call if you want to change this, though.

I've added QCA8K_VTU_FUNC_REG0_EG_MODE_MASK instead of using the hard
coded 3, I think it's clearer when the mask + the values are both
getting the shift in the same manner.

> > +	qca8k_write(priv, QCA8K_REG_VTU_FUNC0, reg);
> > +	ret = qca8k_vlan_access(priv, QCA8K_VLAN_LOAD, vid);
> > +
> > +out:
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
> 
> How about:
> 
> 	u32 reg, mask;
> 	int ret, i;
> 	bool del;

Ok.

> > +
> > +	mutex_lock(&priv->reg_mutex);
> > +	ret = qca8k_vlan_access(priv, QCA8K_VLAN_READ, vid);
> > +	if (ret < 0)
> > +		goto out;
> > +
> > +	reg = qca8k_read(priv, QCA8K_REG_VTU_FUNC0);
> > +	reg &= ~(3 << QCA8K_VTU_FUNC0_EG_MODE_S(port));
> > +	reg |= QCA8K_VTU_FUNC0_EG_MODE_NOT <<
> > +			QCA8K_VTU_FUNC0_EG_MODE_S(port);
> > +
> > +	/* Check if we're the last member to be removed */
> > +	del = true;
> > +	for (i = 0; i < QCA8K_NUM_PORTS; i++) {
> > +		mask = QCA8K_VTU_FUNC0_EG_MODE_NOT;
> > +		mask <<= QCA8K_VTU_FUNC0_EG_MODE_S(i);
> > +
> > +		if ((reg & mask) != mask) {
> > +			del = false;
> > +			break;
> > +		}
> > +	}
> > +
> > +	if (del) {
> > +		ret = qca8k_vlan_access(priv, QCA8K_VLAN_PURGE, vid);
> > +	} else {
> > +		qca8k_write(priv, QCA8K_REG_VTU_FUNC0, reg);
> > +		ret = qca8k_vlan_access(priv, QCA8K_VLAN_LOAD, vid);
> > +	}
> > +
> > +out:
> > +	mutex_unlock(&priv->reg_mutex);
> > +
> > +	return ret;
> > +}
> > +
> >  static void
> >  qca8k_mib_init(struct qca8k_priv *priv)
> >  {
> > @@ -663,10 +768,11 @@ qca8k_setup(struct dsa_switch *ds)
> >  			 * default egress vid
> >  			 */
> >  			qca8k_rmw(priv, QCA8K_EGRESS_VLAN(i),
> > -				  0xffff << shift, 1 << shift);
> > +				  0xffff << shift,
> > +				  QCA8K_PORT_VID_DEF << shift);
> 
> This has telltale signs of copy-pasted code. ROUTER_DEFAULT_VID is a
> 12-bit register, so 0xffff is probably not the right mask. But, it is
> true that the upper 4 bits are reserved, so it isn't quite a bug to
> zero them out, just something that sticks out as not correct.

Not my code originally, can fix up.

> >  			qca8k_write(priv, QCA8K_REG_PORT_VLAN_CTRL0(i),
> > -				    QCA8K_PORT_VLAN_CVID(1) |
> > -				    QCA8K_PORT_VLAN_SVID(1));
> > +				    QCA8K_PORT_VLAN_CVID(QCA8K_PORT_VID_DEF) |
> > +				    QCA8K_PORT_VLAN_SVID(QCA8K_PORT_VID_DEF));
> >  		}
> >  	}
> >  
> > @@ -1133,7 +1239,7 @@ qca8k_port_fdb_insert(struct qca8k_priv *priv, const u8 *addr,
> >  {
> >  	/* Set the vid to the port vlan id if no vid is set */
> >  	if (!vid)
> > -		vid = 1;
> > +		vid = QCA8K_PORT_VID_DEF;
> >  
> >  	return qca8k_fdb_add(priv, addr, port_mask, vid,
> >  			     QCA8K_ATU_STATUS_STATIC);
> > @@ -1157,7 +1263,7 @@ qca8k_port_fdb_del(struct dsa_switch *ds, int port,
> >  	u16 port_mask = BIT(port);
> >  
> >  	if (!vid)
> > -		vid = 1;
> > +		vid = QCA8K_PORT_VID_DEF;
> 
> Maybe you could split out this s/1/QCA8K_PORT_VID_DEF/g patch into a
> separate one? For the purpose of the introduction of VLAN callbacks,
> it's just noise.

Ok.

> >  	return qca8k_fdb_del(priv, addr, port_mask, vid);
> >  }
> > @@ -1186,6 +1292,76 @@ qca8k_port_fdb_dump(struct dsa_switch *ds, int port,
> >  	return 0;
> >  }
> >  
> > +static int
> > +qca8k_port_vlan_filtering(struct dsa_switch *ds, int port, bool vlan_filtering)
> > +{
> > +	struct qca8k_priv *priv = ds->priv;
> > +
> > +	if (vlan_filtering) {
> > +		qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(port),
> > +			  QCA8K_PORT_LOOKUP_VLAN_MODE,
> > +			  QCA8K_PORT_LOOKUP_VLAN_MODE_SECURE);
> > +	} else {
> > +		qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(port),
> > +			  QCA8K_PORT_LOOKUP_VLAN_MODE,
> > +			  QCA8K_PORT_LOOKUP_VLAN_MODE_NONE);
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static int
> > +qca8k_port_vlan_prepare(struct dsa_switch *ds, int port,
> > +			const struct switchdev_obj_port_vlan *vlan)
> > +{
> > +	return 0;
> > +}
> > +
> > +static void
> > +qca8k_port_vlan_add(struct dsa_switch *ds, int port,
> > +		    const struct switchdev_obj_port_vlan *vlan)
> > +{
> > +	struct qca8k_priv *priv = ds->priv;
> 
> Reverse Christmas notation please.

Sure, fixed.

> > +
> > +	for (vid = vlan->vid_begin; vid <= vlan->vid_end && !ret; ++vid)
> > +		ret = qca8k_vlan_add(priv, port, vid, !untagged);
> > +
> > +	if (ret)
> > +		dev_err(priv->dev, "Failed to add VLAN to port %d (%d)", port, ret);
> > +
> 
> If for some reason there is a temporary failure in qca8k_vlan_add, you'd
> be swallowing it instead of printing the error and stopping the
> execution.

I don't follow; I'm breaking out of the for loop when we get an error? I
figured that was a better move than potentially printing 4095 error
messages if they were all going to fail.

> > +	if (pvid) {
> > +		int shift = 16 * (port % 2);
> > +
> > +		qca8k_rmw(priv, QCA8K_EGRESS_VLAN(port),
> 
> What's up with this name? Why not "ROUTER_DEFAULT_VID" which is how the
> hardware calls it? I had some trouble finding it.

Not my naming; it's how the driver already defined it.

J.

-- 
... Nice world. Let's make it weirder.
