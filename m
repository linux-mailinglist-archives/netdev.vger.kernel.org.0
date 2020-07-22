Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CA8422A02C
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 21:34:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730802AbgGVTdr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 15:33:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726322AbgGVTdq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 15:33:46 -0400
Received: from the.earth.li (the.earth.li [IPv6:2a00:1098:86:4d:c0ff:ee:15:900d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21096C0619DC;
        Wed, 22 Jul 2020 12:33:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=earth.li;
         s=the; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject
        :Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ISoKoytpq3L1gpPEtulltusvnGO1W6LIHiEoj4uXF2c=; b=f0sNwiQ+UX4pzQhlVBmTh3xG7o
        4YSfhWgYpJgenOFBT0vtJ8o6MODCszo3t6NdExdyAuXrm+sevejdOidD+vmMlXXDdVITO3+IOMI9A
        YoXjCoQN+0i6xkGzEcrBDvRMVsHlCVd2M+XoBJKquRu3DnqaQencBaS6io55kUAfEXz3kbgw6On+y
        EB8J9Qz30oDVOcf9oMFDHH3ZHYxYO9jkBUgFOSXbwnKbO2LF9ystwal8dfX2BKCLOit3xLo4ptius
        n7Y9qqCbG2bS7Q30e3tU1VywpdoNqGnZRLItX0HNH8pYF1lmNF9XuO0z4sprzo/QAXdO/4b+NYmHI
        eTH6pcpQ==;
Received: from noodles by the.earth.li with local (Exim 4.92)
        (envelope-from <noodles@earth.li>)
        id 1jyKUi-00036F-Ox; Wed, 22 Jul 2020 20:33:36 +0100
Date:   Wed, 22 Jul 2020 20:33:36 +0100
From:   Jonathan McDowell <noodles@earth.li>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthew Hagan <mnhagan88@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] net: dsa: qca8k: Add 802.1q VLAN support
Message-ID: <20200722193336.GL23489@earth.li>
References: <20200721171624.GK23489@earth.li>
 <20200721204818.GB1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200721204818.GB1551@shell.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 21, 2020 at 09:48:18PM +0100, Russell King - ARM Linux admin wrote:
> On Tue, Jul 21, 2020 at 06:16:24PM +0100, Jonathan McDowell wrote:
> > This adds full 802.1q VLAN support to the qca8k, allowing the use of
> > vlan_filtering and more complicated bridging setups than allowed by
> > basic port VLAN support.
> > 
> > Tested with a number of untagged ports with separate VLANs and then a
> > trunk port with all the VLANs tagged on it.
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
> > +	reg = QCA8K_VTU_FUNC1_BUSY;
> > +	reg |= cmd;
> > +	reg |= vid << QCA8K_VTU_FUNC1_VID_S;
> > +
> > +	/* Write the function register triggering the table access */
> > +	qca8k_write(priv, QCA8K_REG_VTU_FUNC1, reg);
> > +
> > +	/* wait for completion */
> > +	if (qca8k_busy_wait(priv, QCA8K_REG_VTU_FUNC1, QCA8K_VTU_FUNC1_BUSY))
> > +		return -1;
> 
> You return -1 here.  Personally, I don't like this in the kernel, as
> convention is for functions returning "int" to return negative errno
> values, and this risks returning -1 (-EPERM) being returned to userspace
> if someone decides to propagate the "error code".

Reasonable. I based this code off the qca8k_fdb_access code, but I'll
switch over to more sensible returns (and clean the fdb stuff up in a
separate patch).

> > +
> > +	/* Check for table full violation when adding an entry */
> > +	if (cmd == QCA8K_VLAN_LOAD) {
> > +		reg = qca8k_read(priv, QCA8K_REG_VTU_FUNC1);
> > +		if (reg & QCA8K_VTU_FUNC1_FULL)
> > +			return -1;
> 
> ... and here.
> 
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
> 
> Have you checked whether this can be called with vid=0 ?

It's called at startup with VID 0 (part of setting up the HW filter
according to the log message?) and the hardware isn't happy with that.

...
> > +
> > +static int
> > +qca8k_port_vlan_prepare(struct dsa_switch *ds, int port,
> > +			const struct switchdev_obj_port_vlan *vlan)
> > +{
> > +	if (!vlan->vid_begin)
> > +		return -EOPNOTSUPP;
> > +
> > +	return 0;
> > +}
> > +
> > +static void
> > +qca8k_port_vlan_add(struct dsa_switch *ds, int port,
> > +		    const struct switchdev_obj_port_vlan *vlan)
> > +{
> > +	struct qca8k_priv *priv = ds->priv;
> > +	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
> > +	bool pvid = vlan->flags & BRIDGE_VLAN_INFO_PVID;
> > +	u16 vid;
> > +
> > +	for (vid = vlan->vid_begin; vid <= vlan->vid_end; ++vid)
> > +		qca8k_vlan_add(priv, port, vid, !untagged);
> 
> The and ignored here, so is there any point qca8k_vlan_add() returning
> an error?  If it fails, we'll never know... there even seems to be no
> diagnostic gets logged in the kernel message log.
> 
> If you decide to add some logging, be careful how you do it - userspace
> could ask for vids 1..4095 to be added, and we wouldn't want the
> possibility of 4094 error messages.
> 
> Another issue may be the time taken to process 4094 VIDs if
> qca8k_busy_wait() has to wait for every one.

I'll add a break out on error (and a dev_err) for this and the del case
in v2.

J.

-- 
       Hell is other people.       |  .''`.  Debian GNU/Linux Developer
                                   | : :' :  Happy to accept PGP signed
                                   | `. `'   or encrypted mail - RSA
                                   |   `-    key on the keyservers.
