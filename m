Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6C5C2A8C52
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 02:53:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732883AbgKFBwz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 20:52:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:33714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730414AbgKFBwz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Nov 2020 20:52:55 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 942EC206FB;
        Fri,  6 Nov 2020 01:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604627574;
        bh=pHVYKkUiefYFZk5zGyqOPxW1EYRdawa7eqh570usVN4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jIpCNYypwUEUP3ek2nGHn7uaFGbGarWNBSq4n4C7NeuUapQcQ17PjtyBPEMopYHM2
         bJMCpcIfuyK8hzRSZF0a+cGWHmQFWhYJ0mSZxhrROh3XuABAK84FUT7opNsj01FHl0
         ap3SBxa5VwPbk0btx0F7yGKKbWvxBwa8kqlHFLLc=
Date:   Thu, 5 Nov 2020 17:52:52 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pavana Sharma <pavana.sharma@digi.com>
Cc:     andrew@lunn.ch, ashkan.boldaji@digi.com, davem@davemloft.net,
        f.fainelli@gmail.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, marek.behun@nic.cz,
        netdev@vger.kernel.org, vivien.didelot@gmail.com
Subject: Re: [PATCH v8 4/4] net: dsa: mv88e6xxx: Add support for mv88e6393x
 family of Marvell
Message-ID: <20201105175252.12bdc0d3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <e6d70ebf3b10a1e7222d8820bc585765001028b8.1604388359.git.pavana.sharma@digi.com>
References: <cover.1604388359.git.pavana.sharma@digi.com>
        <e6d70ebf3b10a1e7222d8820bc585765001028b8.1604388359.git.pavana.sharma@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  3 Nov 2020 18:50:38 +1000 Pavana Sharma wrote:
> The Marvell 88E6393X device is a single-chip integration of a 11-port
> Ethernet switch with eight integrated Gigabit Ethernet (GbE) transceivers
> and three 10-Gigabit interfaces.
> 
> This patch adds functionalities specific to mv88e6393x family (88E6393X,
> 88E6193X and 88E6191X)

Please fix all checkpatch --strict --min-conf-desc-length=80 warnings
and what I point out below

> Co-developed-by: Ashkan Boldaji <ashkan.boldaji@digi.com>
> Signed-off-by: Ashkan Boldaji <ashkan.boldaji@digi.com>
> Signed-off-by: Pavana Sharma <pavana.sharma@digi.com>

> +	reg &= ~(MV88E6XXX_PORT_MAC_CTL_SPEED_MASK |
> +			MV88E6390_PORT_MAC_CTL_ALTSPEED |
> +			MV88E6390_PORT_MAC_CTL_FORCE_SPEED);

Align the continuation lines under the opening bracket, like the kernel
coding style require, please.

> +
> +	if (speed != SPEED_UNFORCED)
> +		reg |= MV88E6390_PORT_MAC_CTL_FORCE_SPEED;
> +
> +	reg |= ctrl;
> +
> +	err = mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_MAC_CTL, reg);
> +	if (err)
> +		return err;
> +
> +	return 0;

no need to set err, just directly do:

	return mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_MAC_CTL,
	reg);

> +}
> +
>  static int mv88e6xxx_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
>  				    phy_interface_t mode, bool force)
>  {

> +/* Offset 0x0E: Policy & MGMT Control Register for FAMILY 6191X 6193X 6393X*/

Missing space at the end of that comment.

> +static int mv88e6393x_port_policy_write(struct mv88e6xxx_chip *chip, u16 pointer,
> +				u8 data)
> +{
> +
> +	int err = 0;
> +	int port;
> +	u16 reg;
> +
> +	/* Setup per Port policy register */
> +	for (port = 0; port < mv88e6xxx_num_ports(chip); port++) {
> +		if (dsa_is_unused_port(chip->ds, port))
> +			continue;
> +
> +		/* Prevent the use of an invalid port. */
> +		if (mv88e6xxx_is_invalid_port(chip, port)) {
> +			dev_err(chip->dev, "port %d is invalid\n", port);
> +			err = -EINVAL;

did you mean to exit here? this assignment looks pointless

> +		}
> +		reg = MV88E6393X_PORT_POLICY_MGMT_CTL_UPDATE | pointer | data;
> +		err = mv88e6xxx_port_write(chip, port, MV88E6393X_PORT_POLICY_MGMT_CTL, reg);
> +	}
> +	return err;
> +}

> +int mv88e6393x_port_mgmt_rsvd2cpu(struct mv88e6xxx_chip *chip)
> +{
> +	u16 ptr;
> +	int err;
> +
> +	/* Consider the frames with reserved multicast destination
> +	 * addresses matching 01:80:c2:00:00:00 and
> +	 * 01:80:c2:00:00:02 as MGMT.
> +	 */
> +	ptr = MV88E6393X_PORT_POLICY_MGMT_CTL_PTR_01C280000000XLO;
> +	err = mv88e6393x_port_policy_write(chip, ptr, 0xff);
> +	if (err)
> +		return err;
> +
> +	ptr = MV88E6393X_PORT_POLICY_MGMT_CTL_PTR_01C280000000XHI;
> +	err = mv88e6393x_port_policy_write(chip, ptr, 0xff);
> +	if (err)
> +		return err;
> +
> +	ptr = MV88E6393X_PORT_POLICY_MGMT_CTL_PTR_01C280000002XLO;
> +	err = mv88e6393x_port_policy_write(chip, ptr, 0xff);
> +	if (err)
> +		return err;
> +
> +	ptr = MV88E6393X_PORT_POLICY_MGMT_CTL_PTR_01C280000002XHI;
> +	err = mv88e6393x_port_policy_write(chip, ptr, 0xff);
> +	if (err)
> +		return err;
> +
> +	return 0;

return mv...

> +}
> +


> +	err = mv88e6xxx_port_write(chip, port, MV88E6393X_PORT_EPC_CMD, val);
> +	if (err)
> +		return err;
> +
> +	return 0;

ditto

> +}

> +
> +int mv88e6393x_serdes_power(struct mv88e6xxx_chip *chip, int port, int lane,
> +		    bool on)
> +{
> +	if (port == 0 || port == 9 || port == 10) {

Flip the condition, return early. Entire body of a function should not
have to be indented.

> +		u8 cmode = chip->ports[port].cmode;
> +
> +		mv88e6393x_serdes_port_config(chip, lane, on);
> +
> +		switch (cmode) {
> +		case MV88E6XXX_PORT_STS_CMODE_1000BASEX:
> +		case MV88E6XXX_PORT_STS_CMODE_2500BASEX:
> +			return mv88e6390_serdes_power_sgmii(chip, lane, on);
> +		case MV88E6XXX_PORT_STS_CMODE_10GBASER:
> +			return mv88e6390_serdes_power_10g(chip, lane, on);
> +		}
> +	}
> +
> +	return 0;
> +}

> @@ -130,7 +169,7 @@ int mv88e6390_serdes_get_regs_len(struct mv88e6xxx_chip *chip, int port);
>  void mv88e6390_serdes_get_regs(struct mv88e6xxx_chip *chip, int port, void *_p);
>  
>  /* Return the (first) SERDES lane address a port is using, ERROR otherwise. */
> -static inline u8 mv88e6xxx_serdes_get_lane(struct mv88e6xxx_chip *chip,
> +static inline int mv88e6xxx_serdes_get_lane(struct mv88e6xxx_chip *chip,
>  					   int port)

Looks like this should be in patch 3?

>  {
>  	if (!chip->info->ops->serdes_get_lane)

