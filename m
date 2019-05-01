Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6ADD10F09
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 00:34:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726249AbfEAWei (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 18:34:38 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:51633 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726144AbfEAWeh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 May 2019 18:34:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=2pzRNrhAytCoDUjL1HUUqN+ZWTZeJU+HiUpUd3oqOqo=; b=crWRdA47u/c2n+7F2Aax9dAplO
        TZDwLDkTVbymwx87SxlVbv4yBCZ1iDq1cCqXlWy3IyVXNMt1cz1XH8hC/GVPpLHvNLPDeHipLx9Eb
        HdzxCgqcppZbDpeDCpIBFu7DKkeMuR6klRCvNz9mXdihXHC3auR82fcHYZATdPpFsQJo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hLxo8-0001sN-T9; Thu, 02 May 2019 00:34:32 +0200
Date:   Thu, 2 May 2019 00:34:32 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Hauke Mehrtens <hauke@hauke-m.de>
Cc:     davem@davemloft.net, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH 2/5] net: dsa: lantiq: Add VLAN unaware bridge offloading
Message-ID: <20190501223432.GI19809@lunn.ch>
References: <20190501204506.21579-1-hauke@hauke-m.de>
 <20190501204506.21579-3-hauke@hauke-m.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190501204506.21579-3-hauke@hauke-m.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 01, 2019 at 10:45:03PM +0200, Hauke Mehrtens wrote:

Hi Hauke

/* Add the LAN port into a bridge with the CPU port by
> + * default. This prevents automatic forwarding of
> + * packages between the LAN ports when no explicit
> + * bridge is configured.
> + */
> +static int gswip_add_signle_port_br(struct gswip_priv *priv, int port, bool add)

single ?

> +{
> +	struct gswip_pce_table_entry vlan_active = {0,};
> +	struct gswip_pce_table_entry vlan_mapping = {0,};
> +	unsigned int cpu_port = priv->hw_info->cpu_port;
> +	unsigned int max_ports = priv->hw_info->max_ports;
> +	int err;
> +
> +	if (port >= max_ports) {
> +		dev_err(priv->dev, "single port for %i supported\n", port);
> +		return -EIO;
> +	}
> +
> +	vlan_active.index = port + 1;

>  
> +static int gswip_vlan_active_create(struct gswip_priv *priv,
> +				    struct net_device *bridge,
> +				    int fid, u16 vid)
> +{
> +	struct gswip_pce_table_entry vlan_active = {0,};
> +	unsigned int max_ports = priv->hw_info->max_ports;
> +	int idx = -1;
> +	int err;
> +	int i;
> +
> +	/* Look for a free slot */
> +	for (i = max_ports; i < ARRAY_SIZE(priv->vlans); i++) {
> +		if (!priv->vlans[i].bridge) {
> +			idx = i;
> +			break;
> +		}
> +	}

> +static int gswip_vlan_add_unaware(struct gswip_priv *priv,
> +				  struct net_device *bridge, int port)
> +{
> +	struct gswip_pce_table_entry vlan_mapping = {0,};
> +	unsigned int max_ports = priv->hw_info->max_ports;
> +	unsigned int cpu_port = priv->hw_info->cpu_port;
> +	bool active_vlan_created = false;
> +	int idx = -1;
> +	int i;
> +	int err;
> +
> +	/* Check if there is already a page for this bridge */
> +	for (i = max_ports; i < ARRAY_SIZE(priv->vlans); i++) {
> +		if (priv->vlans[i].bridge == bridge) {
> +			idx = i;
> +			break;
> +		}
> +	}

If i understand this correctly, VLANs 1 to max_ports are used for when
a port is not a member of a bridge. When a port is added to a bridge,
an unused vlan is allocated to the bridge.

You could however reuse the port VLANs.  When the 1st port joins a
bridge, it keeps its VLAN ID, but the bridge is associated to the
port. When the 2nd, 3rd, 4rd port joins the bridge, use the VLAN from
the 1st port.

It gets messy when ports leave. If the 1st port is not the last to
leave, you need to modify the VLAN ID to a port which is still a
member of the bridge.

What you have here is simple, but if you think VLANs are valuable,
this scheme can save you some VLANS, but at the expense of a bit of
extra code complexity.

     Andrew
