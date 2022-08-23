Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50BBB59EF89
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 01:02:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230254AbiHWXCq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 19:02:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbiHWXCo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 19:02:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED8053DF3B;
        Tue, 23 Aug 2022 16:02:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B3E261375;
        Tue, 23 Aug 2022 23:02:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 560EFC433C1;
        Tue, 23 Aug 2022 23:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661295762;
        bh=wW4Ve72oIl7Lv3T7dqpRr612P37xIuLgXOLULBk/spU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sa/OdoMNEG0uRaHzf5VF2NNmt3MnbahArHi+cuQLAqqgzmzBZ6+NKfpoXeR/gqlJS
         f6KiZbG9J2KWl78X1OBYM3ZmMvJTIBBPg/tuoUGSoIJ9kUxvnXbx5ttViJJieMOSxN
         tghdW0Xl2kg8v6wjHHVOKkUYAdnCKZH49wehxCpttSUAmRDrwlQra8N9F0qkrceoQl
         qYtjp9OHSWDC6Df+NTzaZiL93eW6pUr4kaFWfbZi6thmvtDqcqoj/SZ0Lpln6Fi7bK
         03DEhUbO/Q6pHnawTXb6U3rfKJjZep4gRPj1j2qWrEQc40/MfBROFPAmG4rJnTPuMs
         3EbyOi0Ehpgrg==
Date:   Tue, 23 Aug 2022 16:02:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     andrei.tachici@stud.acs.upb.ro
Cc:     linux-kernel@vger.kernel.org, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org,
        vegard.nossum@oracle.com, joel@jms.id.au, l.stelmach@samsung.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        devicetree@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [net-next v5 2/3] net: ethernet: adi: Add ADIN1110 support
Message-ID: <20220823160241.36bc2480@kernel.org>
In-Reply-To: <20220819141941.39635-3-andrei.tachici@stud.acs.upb.ro>
References: <20220819141941.39635-1-andrei.tachici@stud.acs.upb.ro>
        <20220819141941.39635-3-andrei.tachici@stud.acs.upb.ro>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 19 Aug 2022 17:19:40 +0300 andrei.tachici@stud.acs.upb.ro wrote:
> +static int adin1110_ndo_set_mac_address(struct net_device *netdev, void *addr)
> +{
> +	struct sockaddr *sa = addr;
> +
> +	if (netif_running(netdev))
> +		return -EBUSY;

Please use eth_prepare_mac_addr_change() instead.

> +	return adin1110_set_mac_address(netdev, sa->sa_data);
> +}

> +static int adin1110_net_stop(struct net_device *net_dev)
> +{
> +	struct adin1110_port_priv *port_priv = netdev_priv(net_dev);
> +
> +	netif_stop_queue(port_priv->netdev);
> +	flush_work(&port_priv->tx_work);

What prevents the IRQ from firing right after this point and waking 
the queue again?

> +	phy_stop(port_priv->phydev);
> +
> +	return 0;
> +}
> +
> +static void adin1110_tx_work(struct work_struct *work)
> +{
> +	struct adin1110_port_priv *port_priv = container_of(work, struct adin1110_port_priv, tx_work);
> +	struct adin1110_priv *priv = port_priv->priv;
> +	struct sk_buff *txb;
> +	bool last;
> +	int ret;
> +
> +	mutex_lock(&priv->lock);
> +
> +	last = skb_queue_empty(&port_priv->txq);
> +
> +	while (!last) {
> +		txb = skb_dequeue(&port_priv->txq);
> +		last = skb_queue_empty(&port_priv->txq);

while ((txb = skb_dequeue(&port_priv->txq)))

> +		if (txb) {
> +			ret = adin1110_write_fifo(port_priv, txb);
> +			if (ret < 0)
> +				netdev_err(port_priv->netdev, "Frame write error: %d\n", ret);

This needs rate limiting.

> +			dev_kfree_skb(txb);
> +		}
> +	}
> +
> +	mutex_unlock(&priv->lock);
> +}
> +
> +static netdev_tx_t adin1110_start_xmit(struct sk_buff *skb, struct net_device *dev)
> +{
> +	struct adin1110_port_priv *port_priv = netdev_priv(dev);
> +	struct adin1110_priv *priv = port_priv->priv;
> +	netdev_tx_t netdev_ret = NETDEV_TX_OK;
> +	u32 tx_space_needed;
> +
> +	spin_lock(&priv->state_lock);
> +
> +	tx_space_needed = skb->len + ADIN1110_FRAME_HEADER_LEN + ADIN1110_INTERNAL_SIZE_HEADER_LEN;
> +	if (tx_space_needed > priv->tx_space) {
> +		netif_stop_queue(dev);
> +		netdev_ret = NETDEV_TX_BUSY;
> +	} else {
> +		priv->tx_space -= tx_space_needed;
> +		skb_queue_tail(&port_priv->txq, skb);
> +	}
> +
> +	spin_unlock(&priv->state_lock);

What is this lock protecting? There's already a lock around Tx.

> +	schedule_work(&port_priv->tx_work);
> +
> +	return netdev_ret;
> +}
> +

> +static int adin1110_net_bridge_setlink(struct net_device *dev, struct nlmsghdr *nlh, u16 flags,
> +				       struct netlink_ext_ack *extack)
> +{
> +	struct adin1110_port_priv *port_priv = netdev_priv(dev);
> +	struct nlattr *br_spec;
> +	struct nlattr *attr;
> +	int rem;
> +
> +	br_spec = nlmsg_find_attr(nlh, sizeof(struct ifinfomsg), IFLA_AF_SPEC);
> +	if (!br_spec)
> +		return -EINVAL;
> +
> +	nla_for_each_nested(attr, br_spec, rem) {
> +		u16 mode;
> +
> +		if (nla_type(attr) != IFLA_BRIDGE_MODE)
> +			continue;
> +
> +		if (nla_len(attr) < sizeof(mode))
> +			return -EINVAL;
> +
> +		port_priv->priv->br_mode = nla_get_u16(attr);
> +		adin1110_set_rx_mode(dev);
> +		break;
> +	}
> +
> +	return 0;
> +}

I thought this is a callback for legacy SR-IOV NICs. What are you using
it for in a HW device over SPI? :S

> +static int adin1110_port_set_forwarding_state(struct adin1110_port_priv *port_priv)
> +{
> +	struct adin1110_priv *priv = port_priv->priv;
> +	int ret;
> +
> +	port_priv->state = BR_STATE_FORWARDING;
> +
> +	if (adin1110_can_offload_forwarding(priv)) {
> +		ret = adin1110_hw_forwarding(priv, true);
> +		if (ret < 0)
> +			return ret;
> +	}
> +
> +	mutex_lock(&priv->lock);
> +	ret = adin1110_set_mac_address(port_priv->netdev, port_priv->netdev->dev_addr);
> +	if (ret < 0)
> +		goto out;
> +
> +	ret = adin1110_setup_rx_mode(port_priv);
> +out:
> +	mutex_unlock(&priv->lock);
> +
> +	return ret;
> +}

The bridge support looks quite incomplete here, no?
There's no access to the FDB of the switch.
You forward to the host based on the MAC addr of the port not 
the bridge.
