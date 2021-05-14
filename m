Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1298A38140C
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 01:02:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234237AbhENXDJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 19:03:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230371AbhENXDI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 19:03:08 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBD45C06174A;
        Fri, 14 May 2021 16:01:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=CgABsLE4zHihJEV07T+Hib4mnYLS7sMe5ozAuoSAx20=; b=eE1UkWbaG4+8LTWEZlhPq5BWN
        +7Ge7+VZs+aBpOtfg5UbE/mBdqT1J4979FB5yW/WB5P2Byd4dmqDBIgYdBJYcaf+3RUqkvTAGSQb0
        oba1BJMSKf9tWjUPQwHcN+KHPE3bpUR9uJcxNvMg7wdqJnDskIZK0rSbgWxu+srHB8NFu44rSIezV
        eKLMkUWAaxM8LmjpM/WwGM1C7FnRvGqWMWdcVMPizxwUJo7VphSTLftuyCKq50+xbbDreaaGYHLit
        KcvZl9Tii2Nz5fP5khAtnM5n8K5Hl2gRtJGvnOpIBxOSBoKzoMTcRGUzAPxev9GPf6Tvb+Kx09tfI
        oFm3X+FNA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:43992)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lhgob-0000Yf-85; Sat, 15 May 2021 00:01:53 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lhgoa-0004PG-Or; Sat, 15 May 2021 00:01:52 +0100
Date:   Sat, 15 May 2021 00:01:52 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v6 05/25] net: dsa: qca8k: handle error with
 qca8k_read operation
Message-ID: <20210514230152.GL12395@shell.armlinux.org.uk>
References: <20210514210015.18142-1-ansuelsmth@gmail.com>
 <20210514210015.18142-6-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210514210015.18142-6-ansuelsmth@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 14, 2021 at 10:59:55PM +0200, Ansuel Smith wrote:
> -static void
> +static int
>  qca8k_fdb_read(struct qca8k_priv *priv, struct qca8k_fdb *fdb)
>  {
> -	u32 reg[4];
> +	u32 reg[4], val;

val is unsigned.

>  	int i;
>  
>  	/* load the ARL table into an array */
> -	for (i = 0; i < 4; i++)
> -		reg[i] = qca8k_read(priv, QCA8K_REG_ATU_DATA0 + (i * 4));
> +	for (i = 0; i < 4; i++) {
> +		val = qca8k_read(priv, QCA8K_REG_ATU_DATA0 + (i * 4));
> +		if (val < 0)
> +			return val;

So this return statement will never be reached.

> @@ -374,6 +386,8 @@ qca8k_fdb_access(struct qca8k_priv *priv, enum qca8k_fdb_cmd cmd, int port)
>  	/* Check for table full violation when adding an entry */
>  	if (cmd == QCA8K_FDB_LOAD) {
>  		reg = qca8k_read(priv, QCA8K_REG_ATU_FUNC);
> +		if (reg < 0)
> +			return reg;

"reg" here is also a u32, and therefore unsigned, so this will have no
effect.

>  		if (reg & QCA8K_ATU_FUNC_FULL)
>  			return -1;
>  	}
> @@ -388,10 +402,10 @@ qca8k_fdb_next(struct qca8k_priv *priv, struct qca8k_fdb *fdb, int port)
>  
>  	qca8k_fdb_write(priv, fdb->vid, fdb->port_mask, fdb->mac, fdb->aging);
>  	ret = qca8k_fdb_access(priv, QCA8K_FDB_NEXT, port);
> -	if (ret >= 0)
> -		qca8k_fdb_read(priv, fdb);
> +	if (ret < 0)
> +		return ret;

This looks fine to me.

>  
> -	return ret;
> +	return qca8k_fdb_read(priv, fdb);
>  }
>  
>  static int
> @@ -449,6 +463,8 @@ qca8k_vlan_access(struct qca8k_priv *priv, enum qca8k_vlan_cmd cmd, u16 vid)
>  	/* Check for table full violation when adding an entry */
>  	if (cmd == QCA8K_VLAN_LOAD) {
>  		reg = qca8k_read(priv, QCA8K_REG_VTU_FUNC1);
> +		if (reg < 0)
> +			return reg;

reg is unsigned... unreachable.

>  		if (reg & QCA8K_VTU_FUNC1_FULL)
>  			return -ENOMEM;
>  	}
> @@ -475,6 +491,8 @@ qca8k_vlan_add(struct qca8k_priv *priv, u8 port, u16 vid, bool untagged)
>  		goto out;
>  
>  	reg = qca8k_read(priv, QCA8K_REG_VTU_FUNC0);
> +	if (reg < 0)
> +		return reg;

reg is unsigned... unreachable.

>  	reg |= QCA8K_VTU_FUNC0_VALID | QCA8K_VTU_FUNC0_IVL_EN;
>  	reg &= ~(QCA8K_VTU_FUNC0_EG_MODE_MASK << QCA8K_VTU_FUNC0_EG_MODE_S(port));
>  	if (untagged)
> @@ -506,6 +524,8 @@ qca8k_vlan_del(struct qca8k_priv *priv, u8 port, u16 vid)
>  		goto out;
>  
>  	reg = qca8k_read(priv, QCA8K_REG_VTU_FUNC0);
> +	if (reg < 0)
> +		return reg;

reg is unsigned... unreachable.

>  	reg &= ~(3 << QCA8K_VTU_FUNC0_EG_MODE_S(port));
>  	reg |= QCA8K_VTU_FUNC0_EG_MODE_NOT <<
>  			QCA8K_VTU_FUNC0_EG_MODE_S(port);
> @@ -621,8 +641,11 @@ qca8k_mdio_read(struct qca8k_priv *priv, int port, u32 regnum)
>  			    QCA8K_MDIO_MASTER_BUSY))
>  		return -ETIMEDOUT;
>  
> -	val = (qca8k_read(priv, QCA8K_MDIO_MASTER_CTRL) &
> -		QCA8K_MDIO_MASTER_DATA_MASK);
> +	val = qca8k_read(priv, QCA8K_MDIO_MASTER_CTRL);
> +	if (val < 0)
> +		return val;

val is unsigned... unreachable.

> +
> +	val &= QCA8K_MDIO_MASTER_DATA_MASK;
>  
>  	return val;
>  }
> @@ -978,6 +1001,8 @@ qca8k_phylink_mac_link_state(struct dsa_switch *ds, int port,
>  	u32 reg;
>  
>  	reg = qca8k_read(priv, QCA8K_REG_PORT_STATUS(port));
> +	if (reg < 0)
> +		return reg;

reg is unsigned... unreachable.

>  
>  	state->link = !!(reg & QCA8K_PORT_STATUS_LINK_UP);
>  	state->an_complete = state->link;
> @@ -1078,18 +1103,26 @@ qca8k_get_ethtool_stats(struct dsa_switch *ds, int port,
>  {
>  	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
>  	const struct qca8k_mib_desc *mib;
> -	u32 reg, i;
> +	u32 reg, i, val;
>  	u64 hi;
>  
>  	for (i = 0; i < ARRAY_SIZE(ar8327_mib); i++) {
>  		mib = &ar8327_mib[i];
>  		reg = QCA8K_PORT_MIB_COUNTER(port) + mib->offset;
>  
> -		data[i] = qca8k_read(priv, reg);
> +		val = qca8k_read(priv, reg);
> +		if (val < 0)
> +			continue;

val is unsigned... unreachable....

> +
>  		if (mib->size == 2) {
>  			hi = qca8k_read(priv, reg + 4);
> -			data[i] |= hi << 32;
> +			if (hi < 0)
> +				continue;

hi is a u64, so this condition is always false.

>  		}
> +
> +		data[i] = val;
> +		if (mib->size == 2)
> +			data[i] |= hi << 32;
>  	}
>  }
>  
> @@ -1107,18 +1140,25 @@ qca8k_set_mac_eee(struct dsa_switch *ds, int port, struct ethtool_eee *eee)
>  {
>  	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
>  	u32 lpi_en = QCA8K_REG_EEE_CTRL_LPI_EN(port);
> +	int ret = 0;

No need to zero-initialise this.

>  	u32 reg;
>  
>  	mutex_lock(&priv->reg_mutex);
>  	reg = qca8k_read(priv, QCA8K_REG_EEE_CTRL);
> +	if (reg < 0) {
> +		ret = reg;
> +		goto exit;
> +	}
> +
>  	if (eee->eee_enabled)
>  		reg |= lpi_en;
>  	else
>  		reg &= ~lpi_en;
>  	qca8k_write(priv, QCA8K_REG_EEE_CTRL, reg);
> -	mutex_unlock(&priv->reg_mutex);
>  
> -	return 0;
> +exit:
> +	mutex_unlock(&priv->reg_mutex);
> +	return ret;
>  }
>  
>  static int
> @@ -1443,6 +1483,9 @@ qca8k_sw_probe(struct mdio_device *mdiodev)
>  
>  	/* read the switches ID register */
>  	id = qca8k_read(priv, QCA8K_REG_MASK_CTRL);
> +	if (id < 0)
> +		return id;

id is unsigned ...

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
